#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""What ARE the 35 layout-only transistors? (v2 -- descend into the owning cell)

v1 looked only at the TOP cell's shapes, which never contain a standard cell's
diffusion or poly, so it reported "only metal".  The right question is: at the
device's LOCAL coordinates inside its owning master, what layers are present?
A real transistor needs AA (diffusion) and GT (poly).
"""
import io
import os
import re
import struct
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
R = os.path.join(HERE, "..", "evidence", "rpt_v51")
GDS = os.path.join(R, "sar_digi_paper_core_merged.gds")
LVS = os.path.join(R, "lvs.rep")
S = 10000.0
LN = {10: "AA", 30: "GT", 20: "NW", 40: "SN", 41: "SP", 51: "CONT",
      52: "VIA1", 53: "VIA2", 54: "VIA3", 55: "VIA4", 56: "VIA5",
      61: "M1", 62: "M2", 63: "M3", 64: "M4", 65: "M5", 66: "M6"}

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x1A: "STRANS", 0x1C: "ANGLE"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}


def load(path):
    f = open(path, "rb")
    structs, cur, el = [], None, None
    while True:
        h = f.read(4)
        if len(h) < 4:
            break
        rl, rt, rd = struct.unpack(">HBB", h)
        d = f.read(rl - 4) if rl >= 4 else b""
        n = REC.get(rt)
        if n == "BGNSTR":
            cur = {"name": None, "bbox": None, "shapes": [], "srefs": []}
        elif n == "STRNAME":
            cur["name"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            structs.append(cur); cur = None
        elif rt in ELEM:
            el = {"kind": n, "layer": None, "xy": None, "sname": None,
                  "flip": False, "angle": 0.0}
        elif n == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", d[:2])[0]
        elif n == "XY" and el is not None:
            k = len(d) // 4
            el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
        elif n == "SNAME" and el is not None:
            el["sname"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "STRANS" and el is not None:
            el["flip"] = bool(struct.unpack(">H", d[:2])[0] & 0x8000)
        elif n == "ANGLE" and el is not None:
            try:
                el["angle"] = struct.unpack(">d", d[:8])[0]
            except Exception:
                el["angle"] = 0.0
        elif n == "ENDEL":
            if el is not None and cur is not None and el["xy"]:
                xs = el["xy"][0::2]; ys = el["xy"][1::2]
                bb = (min(xs), min(ys), max(xs), max(ys))
                if el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    b = cur["bbox"]
                    cur["bbox"] = bb if b is None else (min(b[0], bb[0]), min(b[1], bb[1]),
                                                        max(b[2], bb[2]), max(b[3], bb[3]))
                    cur["shapes"].append((el["layer"], bb))
                elif el["kind"] in ("SREF", "AREF"):
                    cur["srefs"].append((el["sname"], el["xy"][0], el["xy"][1],
                                         el["angle"], el["flip"]))
            el = None
    f.close()
    return {s["name"]: s for s in structs}


cells = load(GDS)
top = cells["sar_digi_paper_core"]


def local_layers(master, lx, ly, pad=100):
    c = cells.get(master)
    if not c:
        return []
    out = []
    for lay, bb in c["shapes"]:
        if bb[0] - pad <= lx <= bb[2] + pad and bb[1] - pad <= ly <= bb[3] + pad:
            out.append(lay)
    return out


def place_of(x, y):
    for nm, ox, oy, ang, flip in top["srefs"]:
        c = cells.get(nm)
        if not c or not c["bbox"]:
            continue
        b = c["bbox"]
        w, h = b[2] - b[0], b[3] - b[1]
        a = round(ang / 90.0) * 90
        if a in (90, 270):
            w, h = h, w
        if not (ox <= x <= ox + w and oy <= y <= oy + h):
            continue
        dx, dy = x - ox, y - oy
        if a == 90:
            lx, ly = dy, w - dx
        elif a == 180:
            lx, ly = w - dx, h - dy
        elif a == 270:
            lx, ly = h - dy, dx
        else:
            lx, ly = dx, dy
        if flip:
            ly = h - ly
        if b[0] <= lx <= b[2] and b[1] <= ly <= b[3]:
            return nm, lx, ly
    return None, None, None


t = io.open(LVS, encoding="utf-8", errors="replace").read()
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
flag = re.findall(r"^\s+\d+\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)"
                  r"\s+\*\* missing instance", blk, re.M)
print("flagged layout-only transistors: %d\n" % len(flag))

print("%-12s %-5s %-9s %-22s %-24s %s" % ("inst", "dev", "type", "owning cell",
                                          "local coords (um)", "layers in that cell"))
own = Counter()
has_active = 0
for inst, dev, xs, ys, kind, model in flag:
    x = int(round(float(xs) * S)); y = int(round(float(ys) * S))
    m, lx, ly = place_of(x, y)
    if m:
        lays = sorted(set(local_layers(m, lx, ly)))
    else:
        lays = []
    names = [LN.get(l, "L%d" % l) for l in lays]
    own[m or "(no cell)"] += 1
    if any(n in ("AA", "GT") for n in names):
        has_active += 1
    print("%-12s %-5s %-9s %-22s %-24s %s"
          % (inst, dev, "%s(%s)" % (kind, model), m or "-",
             "(%.2f, %.2f)" % (lx / S, ly / S) if m else "--",
             ",".join(names) if names else "(none)"))

print("\n=== owning cells ===")
for k, v in own.most_common():
    print("   %-28s %d" % (k, v))
print("\n=== how many flagged points sit on AA and/or GT (a real device needs them) ===")
print("   %d of %d" % (has_active, len(flag)))
