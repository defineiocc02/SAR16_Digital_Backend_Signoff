#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""What ARE the 35 layout-only transistors?  Answer from the geometry.

For each coordinate Calibre flagged, report:
  * the placed standard-cell instance that contains it, with full placement
    transform handling (origin + STRANS mirror + ANGLE rotation),
  * every top-cell shape covering the point, by layer.

If the point sits on diffusion + poly, it is a real transistor; the layer mix and
the owning cell then say where it came from.
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
LN = {61: "M1", 62: "M2", 63: "M3", 64: "M4", 65: "M5", 66: "M6",
      10: "AA", 30: "GT", 20: "NW", 40: "SN", 41: "SP", 51: "CONT",
      52: "VIA1", 53: "VIA2", 54: "VIA3", 55: "VIA4", 56: "VIA5"}

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x1A: "STRANS", 0x1C: "ANGLE"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}
import math


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

# shape index (top cell only)
BIN = 100000
sg = defaultdict(list)
for i, (lay, bb) in enumerate(top["shapes"]):
    for gx in range(bb[0] // BIN, bb[2] // BIN + 1):
        for gy in range(bb[1] // BIN, bb[3] // BIN + 1):
            sg[(gx, gy)].append(i)


def shapes_at(x, y, pad=0):
    out = []
    for gx in ((x - pad) // BIN, (x + pad) // BIN + 1):
        for gy in ((y - pad) // BIN, (y + pad) // BIN + 1):
            for i in sg.get((gx, gy), []):
                lay, bb = top["shapes"][i]
                if bb[0] - pad <= x <= bb[2] + pad and bb[1] - pad <= y <= bb[3] + pad:
                    out.append(lay)
    return out


def place_of(x, y):
    """Return the master whose placed extent contains (x,y), plus its local coords."""
    for nm, ox, oy, ang, flip in top["srefs"]:
        c = cells.get(nm)
        if not c or not c["bbox"]:
            continue
        b = c["bbox"]
        w, h = b[2] - b[0], b[3] - b[1]
        a = round(ang / 90.0) * 90
        if a in (90, 270):
            w, h = h, w
        if ox <= x <= ox + w and oy <= y <= oy + h:
            # local coordinates
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
                return nm, (lx, ly)
    return None, None


t = io.open(LVS, encoding="utf-8", errors="replace").read()
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
flag = re.findall(r"^\s+\d+\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)"
                  r"\s+\*\* missing instance", blk, re.M)
print("flagged layout-only transistors: %d\n" % len(flag))

owners = Counter()
layer_sets = Counter()
detail = []
for inst, dev, xs, ys, kind, model in flag:
    x = int(round(float(xs) * S))
    y = int(round(float(ys) * S))
    master, local = place_of(x, y)
    lays = sorted(set(shapes_at(x, y, 200)))          # +/- 0.02 um window
    names = tuple(LN.get(l, str(l)) for l in lays)
    owners[master or "(top level / routing area)"] += 1
    layer_sets[names] += 1
    detail.append((inst, dev, kind, model, xs, ys, master, local, names))

print("=== owning cell ===")
for k, v in owners.most_common():
    print("   %-34s %d" % (k, v))

print("\n=== layer mix at the flagged points (+/-0.02 um) ===")
for k, v in layer_sets.most_common():
    print("   %-40s %d" % (",".join(k) if k else "(nothing)", v))

print("\n=== detail ===")
for inst, dev, kind, model, xs, ys, master, local, names in detail:
    loc = "(%.2f,%.2f)" % local if local else "  --  "
    print("   %-12s %-4s %s(%s) at (%8s,%8s)  cell=%-22s local=%s  layers=%s"
          % (inst, dev, kind, model, xs, ys, master or "-", loc, ",".join(names)))
