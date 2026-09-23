#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Locate Calibre's layout-only transistors inside the standard cells (v2).

Fix over v1: an SREF's XY record carries ONE point -- the placement origin -- not
a bounding box.  The placed extent has to be built from the master cell's own
bbox plus that origin (with R90/R270 swapping the extents).
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
            cur = {"name": None, "bbox": None, "srefs": []}
        elif n == "STRNAME":
            cur["name"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            structs.append(cur); cur = None
        elif rt in ELEM:
            el = {"kind": n, "xy": None, "sname": None, "angle": 0.0}
        elif n == "XY" and el is not None:
            k = len(d) // 4
            el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
        elif n == "SNAME" and el is not None:
            el["sname"] = d.split(b"\x00")[0].decode("latin-1")
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
                elif el["kind"] in ("SREF", "AREF"):
                    cur["srefs"].append((el["sname"], el["xy"][0], el["xy"][1], el["angle"]))
            el = None
    f.close()
    return {s["name"]: s for s in structs}


cells = load(GDS)
top = cells.get("sar_digi_paper_core")
print("merged GDS: %d cells; top SREFs: %d" % (len(cells), len(top["srefs"])))

placed = []          # (cell, x0,y0,x1,y1)
for nm, ox, oy, ang in top["srefs"]:
    c = cells.get(nm)
    if not c or not c["bbox"]:
        continue
    b = c["bbox"]
    w, h = b[2] - b[0], b[3] - b[1]
    if abs(ang) in (90.0, 270.0):
        w, h = h, w
    placed.append((nm, ox, oy, ox + w, oy + h))
print("placed instances with a known bbox: %d" % len(placed))

BIN = 100000
grid = defaultdict(list)
for i, (nm, x0, y0, x1, y1) in enumerate(placed):
    for gx in range(x0 // BIN, x1 // BIN + 1):
        for gy in range(y0 // BIN, y1 // BIN + 1):
            grid[(gx, gy)].append(i)


def find(x, y):
    out = []
    for gx in (x // BIN, x // BIN + 1):
        for gy in (y // BIN, y // BIN + 1):
            for i in grid.get((gx, gy), []):
                nm, x0, y0, x1, y1 = placed[i]
                if x0 <= x <= x1 and y0 <= y <= y1:
                    out.append(nm)
    return out


t = io.open(LVS, encoding="utf-8", errors="replace").read()
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
missing = re.findall(r"^\s+\d+\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)"
                     r"\s+\*\* missing instance", blk, re.M)
print("flagged layout-only transistors: %d\n" % len(missing))

hits = Counter()
detail = defaultdict(list)
for inst, dev, xs, ys, kind, model in missing:
    x = int(round(float(xs) * S))
    y = int(round(float(ys) * S))
    c = find(x, y)
    key = c[0] if c else "(no instance)"
    hits[key] += 1
    detail[key].append((inst, dev, kind, model))

print("=== master cells holding the flagged transistors ===")
for nm, k in hits.most_common():
    print("   %-22s %d" % (nm, k))
print("\n=== per-cell detail ===")
for nm, lst in sorted(detail.items(), key=lambda kv: -len(kv[1])):
    print("   %-20s : %s" % (nm, ", ".join("%s/%s %s(%s)" % (a, b, c, d) for a, b, c, d in lst[:8])))
