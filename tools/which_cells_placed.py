#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DECISIVE: which structs does the top cell actually reference, and do they have
device geometry?

The merged GDS holds two families of cells:
  * correctly named ones (INVXL, DFFSX1, ...) carrying only layers 127/141
  * renamed ones  (dffs_4xawwfcwwwwd6szgjy, ...) carrying 10,14,30,40,43,50,61
Whichever family the top cell instantiates decides whether the delivered file has
real standard-cell geometry at all.
"""
import os
import struct
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
GDS = os.path.join(HERE, "..", "evidence", "rpt_v51", "sar_digi_paper_core_merged.gds")
REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x0E: "DATATYPE", 0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}
S = 10000.0

f = open(GDS, "rb")
cur = None
cur_name = None
structs = {}
order = []
el = None
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack(">HBB", h)
    d = f.read(rl - 4) if rl >= 4 else b""
    n = REC.get(rt)
    if n == "BGNSTR":
        cur = {"shapes": Counter(), "refs": Counter(), "bbox": None, "srefxy": []}
        cur_name = None
    elif n == "STRNAME":
        cur_name = d.split(b"\x00")[0].decode("latin-1")
        structs[cur_name] = cur
        order.append(cur_name)
    elif n == "ENDSTR":
        cur = None
    elif rt in ELEM:
        el = {"kind": n, "layer": None, "sname": None, "xy": None}
    elif n == "LAYER" and el is not None:
        el["layer"] = struct.unpack(">h", d[:2])[0]
    elif n == "SNAME" and el is not None:
        el["sname"] = d.split(b"\x00")[0].decode("latin-1")
    elif n == "XY" and el is not None:
        k = len(d) // 4
        el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
    elif n == "ENDEL":
        if el is not None and cur is not None:
            if el["kind"] in ("SREF", "AREF") and el["sname"]:
                cur["refs"][el["sname"]] += 1
                if el["sname"] == "sar_digi_paper_core":
                    pass
            elif el["layer"] is not None and el["xy"]:
                xs = el["xy"][0::2]; ys = el["xy"][1::2]
                bb = (min(xs), min(ys), max(xs), max(ys))
                b = cur["bbox"]
                cur["bbox"] = bb if b is None else (min(b[0], bb[0]), min(b[1], bb[1]),
                                                    max(b[2], bb[2]), max(b[3], bb[3]))
                cur["shapes"][(el["layer"], el["kind"])] += 1
        el = None
f.close()

top = structs["sar_digi_paper_core"]
print("top cell references %d distinct masters, %d placements"
      % (len(top["refs"]), sum(top["refs"].values())))
print("\n%-24s %8s %7s %-30s %s" % ("master", "placements", "shapes", "layers",
                                    "has AA/GT?"))
tot_dev_geom = 0
no_geom = 0
for nm, cnt in sorted(top["refs"].items(), key=lambda kv: -kv[1])[:20]:
    c = structs.get(nm)
    if not c:
        print("%-24s %8d   (NOT DEFINED)" % (nm, cnt))
        continue
    lays = sorted(set(l for l, _ in c["shapes"]))
    has = any(l in (10, 30) for l in lays)
    print("%-24s %8d %7d %-30s %s"
          % (nm, cnt, sum(c["shapes"].values()),
             ",".join(str(x) for x in lays[:8]), "YES" if has else "NO (frame only)"))
    if has:
        tot_dev_geom += cnt
    else:
        no_geom += cnt

for nm, cnt in top["refs"].items():
    c = structs.get(nm)
    if not c:
        continue
    lays = set(l for l, _ in c["shapes"])
    if not any(l in (10, 30) for l in lays) and not nm.startswith("$$"):
        no_geom += 0

print("\n=== totals over ALL masters the top cell places ===")
allref = {k: v for k, v in top["refs"].items() if not k.startswith("$$")}
has_geom = sum(v for k, v in allref.items()
               if k in structs and any(l in (10, 30) for l, _ in structs[k]["shapes"]))
no_geom2 = sum(v for k, v in allref.items()
               if k in structs and not any(l in (10, 30) for l, _ in structs[k]["shapes"]))
print("   logic placements WITH device geometry   : %d" % has_geom)
print("   logic placements as FRAME ONLY (no AA/GT): %d" % no_geom2)

print("\n=== so who references the renamed, full-geometry cells? ===")
refd = Counter()
for nm, c in structs.items():
    for k, v in c["refs"].items():
        refd[k] += v
renamed = [nm for nm in structs if any(l in (10, 30) for l, _ in structs[nm]["shapes"])]
print("   renamed full-geometry cells: %d" % len(renamed))
inref = [nm for nm in renamed if refd.get(nm, 0) > 0]
print("   of those, referenced by anything: %d" % len(inref))
for nm in inref[:8]:
    who = [a for a, c in structs.items() if nm in c["refs"]]
    print("      %-30s <- %s" % (nm, who))
