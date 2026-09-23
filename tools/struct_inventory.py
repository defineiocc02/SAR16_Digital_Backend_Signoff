#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Full struct inventory of the merged GDS: name, shape count, layers, referenced?"""
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
cur_name = None
seq = []
el = None
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack(">HBB", h)
    d = f.read(rl - 4) if rl >= 4 else b""
    n = REC.get(rt)
    if n == "BGNSTR":
        cur = {"shapes": Counter(), "refs": Counter(), "texts": 0}
        cur_name = None
    elif n == "STRNAME":
        cur_name = d.split(b"\x00")[0].decode("latin-1")
    elif n == "ENDSTR":
        seq.append((cur_name, cur))
        cur = None
    elif rt in ELEM:
        el = {"kind": n, "layer": None, "dt": None, "sname": None}
    elif n == "LAYER" and el is not None:
        el["layer"] = struct.unpack(">h", d[:2])[0]
    elif n == "DATATYPE" and el is not None:
        el["dt"] = struct.unpack(">h", d[:2])[0]
    elif n == "SNAME" and el is not None:
        el["sname"] = d.split(b"\x00")[0].decode("latin-1")
    elif n == "ENDEL":
        if el is not None and cur is not None:
            if el["kind"] in ("SREF", "AREF") and el["sname"]:
                cur["refs"][el["sname"]] += 1
            elif el["layer"] is not None:
                cur["shapes"][(el["layer"], el["dt"])] += 1
            elif el["kind"] == "TEXT":
                cur["texts"] += 1
        el = None
f.close()

ref = Counter()
for nm, c in seq:
    for k, v in c["refs"].items():
        ref[k] += v

print("structs: %d" % len(seq))
print("\n%-24s %8s %7s %6s  %-34s %s"
      % ("name", "shapes", "layers", "texts", "layers used", "referenced by"))
rows = []
for nm, c in seq:
    s = sum(c["shapes"].values())
    lay = sorted(set(l for l, _ in c["shapes"]))
    rows.append((s, nm, len(lay), c["texts"], lay, sum(c["refs"].values()), ref.get(nm, 0)))

rows.sort(key=lambda r: -r[0])
for s, nm, nl, tx, lay, out, inc in rows[:40]:
    print("%-24s %8d %7d %6d  %-34s out=%d in=%d"
          % (nm, s, nl, tx, ",".join(str(x) for x in lay[:10]), out, inc))

print("\n=== summary by layer-set signature ===")
sig = Counter()
for s, nm, nl, tx, lay, out, inc in rows:
    sig[tuple(lay)] += 1
for k, v in sig.most_common(12):
    print("   %-60s %d struct(s)" % (",".join(str(x) for x in k[:12]), v))

print("\n=== how many structs contain diffusion(10)/poly(30)? ===")
n10 = sum(1 for s, nm, nl, tx, lay, out, inc in rows if 10 in lay)
n30 = sum(1 for s, nm, nl, tx, lay, out, inc in rows if 30 in lay)
print("   layer 10 present in %d structs; layer 30 in %d" % (n10, n30))
print("   total shapes on layer 10 across file: %d"
      % sum(c["shapes"].get((10, 0), 0) for _, c in seq))
print("   total shapes on layer 30 across file: %d"
      % sum(c["shapes"].get((30, 0), 0) for _, c in seq))
