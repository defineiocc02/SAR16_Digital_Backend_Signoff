#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Are there DUPLICATE struct names in the merged GDS?

A merge of a P&R GDS (which may carry frame/abstract views of the standard cells)
with the kit GDS can leave two structs with the same name.  A naive parser keeps
only the last one, which would make a real inverter look like a 5-shape frame.
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

f = open(GDS, "rb")
cur = None
cur_name = None
seq = []          # (name, Counter)
el = None
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack(">HBB", h)
    d = f.read(rl - 4) if rl >= 4 else b""
    n = REC.get(rt)
    if n == "BGNSTR":
        cur = Counter(); cur_name = None
    elif n == "STRNAME":
        cur_name = d.split(b"\x00")[0].decode("latin-1")
    elif n == "ENDSTR":
        if cur_name is not None:
            seq.append((cur_name, cur))
        cur = None; cur_name = None
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

print("structs in file: %d" % len(seq))
names = [s[0] for s in seq]
dup = [k for k, v in Counter(names).items() if v > 1]
print("DUPLICATE struct names: %d" % len(dup))
for k in dup[:20]:
    occ = [i for i, s in enumerate(seq) if s[0] == k]
    print("   %-18s appears %d times at index %s" % (k, len(occ), occ))
    for i in occ:
        tot = sum(seq[i][1].values())
        print("        #%-4d  %3d shapes over %2d layer pairs  -> %s"
              % (i, tot, len(seq[i][1]),
                 sorted(set(l for l, _ in seq[i][1]))[:12]))

print("\n=== per-cell shape totals for a few standard cells (ALL occurrences) ===")
for k in ("INVXL", "NOR2XL", "DFFSX1", "NAND2BXL", "MXI2XL"):
    for i, (nm, c) in enumerate(seq):
        if nm == k:
            print("   %-10s idx=%-4d shapes=%-5d layers=%s"
                  % (k, i, sum(c.values()), sorted(set(l for l, _ in c))[:14]))
