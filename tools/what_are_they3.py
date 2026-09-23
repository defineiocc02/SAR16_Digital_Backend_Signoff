#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""What ARE the 35 layout-only transistors? (v3 -- descend to the real geometry)

Hierarchy in the delivered GDS:
    sar_digi_paper_core
      └── SREF -> NOR2XL        (frame: layers 127 + 141 only)
                    └── SREF -> nor2_lxaww...   (the REAL layout: 10,14,30,40,43,50,61)

v2 stopped at the frame, so every point looked like "layer 127 only".  This
version follows the frame's single SREF down to the real cell and answers the
question that matters: does the flagged coordinate sit on diffusion + poly?
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
LN = {10: "AA", 14: "AA?", 30: "GT", 20: "NW", 40: "SN", 43: "SP?", 50: "CONT?",
      61: "M1", 62: "M2", 63: "M3", 64: "M4", 65: "M5", 66: "M6",
      127: "L127", 141: "M1TXT"}

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x1A: "STRANS", 0x1C: "ANGLE"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}


def load(path):
    f = open(path, "rb")
    structs, cur, el = {}, None, None
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
            structs[cur["name"]] = cur
            cur = None
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
    return structs


cells = load(GDS)
top = cells["sar_digi_paper_core"]


def place(x, y, master):
    """Map an absolute point into `master`; return local coords or None."""
    c = cells.get(master)
    if not c or not c["bbox"]:
        return None
    b = c["bbox"]
    w, h = b[2] - b[0], b[3] - b[1]
    dx, dy = x - b[0], y - b[1]
    if b[0] <= x <= b[2] and b[1] <= y <= b[3]:
        return dx, dy
    return None


def find_in(master, lx, ly):
    """(lx,ly) are in MASTER's local frame; return (deepest_master, x, y).

    Children are tried BEFORE accepting the current cell: the delivered GDS wraps
    every standard cell in a frame struct whose bbox covers the whole cell, so
    accepting the current cell first would stop the descent at a geometry-free
    wrapper.
    """
    c = cells.get(master)
    if not c:
        return None
    for nm, ox, oy, ang, flip in c["srefs"]:
        ch = cells.get(nm)
        if not ch or not ch["bbox"]:
            continue
        b = ch["bbox"]
        w, h = b[2] - b[0], b[3] - b[1]
        a = round(ang / 90.0) * 90
        if a in (90, 270):
            w, h = h, w
        if not (ox <= lx <= ox + w and oy <= ly <= oy + h):
            continue
        dx, dy = lx - ox, ly - oy
        if a == 90:
            cx, cy = dy, w - dx
        elif a == 180:
            cx, cy = w - dx, h - dy
        elif a == 270:
            cx, cy = h - dy, dx
        else:
            cx, cy = dx, dy
        if flip:
            cy = h - cy
        r = find_in(nm, cx, cy)
        if r:
            return r
    if c["bbox"] and c["bbox"][0] <= lx <= c["bbox"][2] and c["bbox"][1] <= ly <= c["bbox"][3]:
        return master, lx, ly
    return None


def layers_near(master, lx, ly, pad=200):
    c = cells.get(master)
    out = []
    if not c:
        return out
    for lay, bb in c["shapes"]:
        if bb[0] - pad <= lx <= bb[2] + pad and bb[1] - pad <= ly <= bb[3] + pad:
            out.append(lay)
    return out


t = io.open(LVS, encoding="utf-8", errors="replace").read()
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
flag = re.findall(r"^\s+\d+\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)"
                  r"\s+\*\* missing instance", blk, re.M)
print("flagged layout-only transistors: %d\n" % len(flag))

own = Counter()
active = 0
print("%-12s %-5s %-9s %-22s %s" % ("inst", "dev", "type", "cell where the GEOMETRY is", "layers"))
for inst, dev, xs, ys, kind, model in flag:
    x = int(round(float(xs) * S)); y = int(round(float(ys) * S))
    # find the placed frame master first
    frame = None
    for nm, ox, oy, ang, flip in top["srefs"]:
        ch = cells.get(nm)
        if not ch or not ch["bbox"]:
            continue
        b = ch["bbox"]
        w, h = b[2] - b[0], b[3] - b[1]
        if ox <= y * 0 + x <= ox + w and oy <= y <= oy + h:
            frame = (nm, ox, oy)
            break
    if not frame:
        print("%-12s %-5s %-9s %-22s %s" % (inst, dev, "%s(%s)" % (kind, model),
                                            "(not in any placement)", "-"))
        own["(no placement)"] += 1
        continue
    nm, ox, oy = frame
    r = find_in(nm, x - ox, y - oy)
    if not r:
        print("%-12s %-5s %-9s %-22s %s" % (inst, dev, "%s(%s)" % (kind, model),
                                            nm + " (no deeper)", "-"))
        own[nm] += 1
        continue
    master, lx, ly = r
    lays = sorted(set(layers_near(master, lx, ly)))
    names = [LN.get(l, "L%d" % l) for l in lays]
    own[master] += 1
    if "AA" in names and "GT" in names:
        active += 1
    print("%-12s %-5s %-9s %-22s %s" % (inst, dev, "%s(%s)" % (kind, model), master,
                                        ",".join(names)))

print("\n=== real geometry cell for each flagged device ===")
for k, v in own.most_common(15):
    print("   %-34s %d" % (k, v))
print("\n=== flagged points sitting on BOTH diffusion(AA) and poly(GT) ===")
print("   %d of %d" % (active, len(flag)))
