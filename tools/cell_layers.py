#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Layer inventory of a few standard cells in the merged GDS (child structs)."""
import os
import struct
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
GDS = os.path.join(HERE, "..", "evidence", "rpt_v51", "sar_digi_paper_core_merged.gds")
REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x0E: "DATATYPE", 0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}

f = open(GDS, "rb")
cur = None
el = None
cells = {}
order = []
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack(">HBB", h)
    d = f.read(rl - 4) if rl >= 4 else b""
    n = REC.get(rt)
    if n == "BGNSTR":
        cur = Counter()
    elif n == "STRNAME":
        nm = d.split(b"\x00")[0].decode("latin-1")
        cells[nm] = cur
        order.append(nm)
    elif n == "ENDSTR":
        cur = None
    elif rt in ELEM:
        el = {"kind": n, "layer": None, "dt": None}
    elif n == "LAYER" and el is not None:
        el["layer"] = struct.unpack(">h", d[:2])[0]
    elif n == "DATATYPE" and el is not None:
        el["dt"] = struct.unpack(">h", d[:2])[0]
    elif n == "ENDEL":
        if el is not None and cur is not None and el["layer"] is not None:
            cur[(el["layer"], el["dt"])] += 1
        el = None
f.close()

print("total cells: %d" % len(cells))
for name in ("INVXL", "NOR2XL", "DFFSX1", "NAND2BXL"):
    c = cells.get(name)
    print("\n=== %s : %d layer/datatype pairs ===" % (name, len(c) if c else 0))
    if c:
        for (l, dt), n in sorted(c.items()):
            print("   layer %-5d datatype %-4s  %d shape(s)" % (l, dt, n))

allpairs = Counter()
for c in cells.values():
    for k, v in c.items():
        allpairs[k] += 1
print("\n=== layer/datatype pairs across ALL cells (pair -> #cells using it) ===")
for (l, dt), n in sorted(allpairs.items(), key=lambda kv: -kv[1])[:30]:
    print("   layer %-5d datatype %-4s  %d cells" % (l, dt, n))
