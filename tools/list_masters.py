#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""List every standard-cell master the delivered layout actually places."""
import os
import struct
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
GDS = os.path.join(HERE, "..", "evidence", "rpt_v51", "sar_digi_paper_core_merged.gds")
REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x0A: "SREF", 0x0B: "AREF",
       0x11: "ENDEL", 0x12: "SNAME"}

f = open(GDS, "rb")
cur = None
refs = Counter()
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack(">HBB", h)
    d = f.read(rl - 4) if rl >= 4 else b""
    n = REC.get(rt)
    if n == "BGNSTR":
        cur = None
    elif n == "STRNAME":
        cur = d.split(b"\x00")[0].decode("latin-1")
    elif n == "SNAME" and cur == "sar_digi_paper_core":
        refs[d.split(b"\x00")[0].decode("latin-1")] += 1
f.close()

logic = {k: v for k, v in refs.items() if not k.startswith("$$")}
print("logic masters: %d   placements: %d" % (len(logic), sum(logic.values())))
with open(os.path.join(HERE, "..", "probes", "masters.txt"), "w", encoding="utf-8") as fh:
    for k in sorted(logic):
        fh.write("%s %d\n" % (k, logic[k]))
print("written to probes/masters.txt")
for k in sorted(logic):
    print("   %-16s %d" % (k, logic[k]))
