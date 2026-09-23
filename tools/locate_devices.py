#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Locate Calibre's layout-only transistors inside the standard cells.

Calibre reports each unmatched device with absolute coordinates.  Placing those
coordinates against the GDS's SREF list says which MASTER CELL each one lives in
-- no EDA tool needed, and no guessing from instance names (Calibre's instance
names are its own X<n> numbering, not the netlist's).
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
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME"}
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
            structs.append(cur)
            cur = None
        elif rt in ELEM:
            el = {"kind": n, "xy": None, "sname": None}
        elif n == "XY" and el is not None:
            k = len(d) // 4
            el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
        elif n == "SNAME" and el is not None:
            el["sname"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDEL":
            if el is not None and cur is not None and el["xy"]:
                xs = el["xy"][0::2]
                ys = el["xy"][1::2]
                bb = (min(xs), min(ys), max(xs), max(ys))
                if el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    b = cur["bbox"]
                    cur["bbox"] = bb if b is None else (min(b[0], bb[0]), min(b[1], bb[1]),
                                                        max(b[2], bb[2]), max(b[3], bb[3]))
                elif el["kind"] in ("SREF", "AREF"):
                    cur["srefs"].append((el["sname"], bb))
            el = None
    f.close()
    return {s["name"]: s for s in structs}


cells = load(GDS)
top = cells.get("sar_digi_paper_core")
print("merged GDS: %d cells" % len(cells))
print("top cell SREFs: %d" % len(top["srefs"]))

# spatial index over top-level SREFs
BIN = 50000
grid = defaultdict(list)
for i, (nm, bb) in enumerate(top["srefs"]):
    for gx in range(bb[0] // BIN, bb[2] // BIN + 1):
        for gy in range(bb[1] // BIN, bb[3] // BIN + 1):
            grid[(gx, gy)].append(i)

t = io.open(LVS, encoding="utf-8", errors="replace").read()
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
missing = re.findall(r"^\s+\d+\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)\s+\*\* missing instance",
                     blk, re.M)
print("flagged layout-only transistors: %d" % len(missing))

hits = Counter()
detail = defaultdict(list)
for inst, dev, xs, ys, kind, model in missing:
    x = int(round(float(xs) * S))
    y = int(round(float(ys) * S))
    found = None
    for gx in (x // BIN, x // BIN + 1):
        for gy in (y // BIN, y // BIN + 1):
            for i in grid.get((gx, gy), []):
                nm, bb = top["srefs"][i]
                if bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]:
                    found = nm
                    break
            if found:
                break
        if found:
            break
    hits[found or "(not inside any SREF)"] += 1
    detail[found or "?"].append((inst, dev, kind, model, xs, ys))

print("\n=== master cells holding the flagged transistors ===")
for nm, c in hits.most_common():
    print("   %-22s %d" % (nm, c))

print("\n=== per-cell detail ===")
for nm, lst in sorted(detail.items(), key=lambda kv: -len(kv[1])):
    print("   %s :" % nm)
    for inst, dev, kind, model, xs, ys in lst[:6]:
        print("      %-14s %-4s %s(%s)  at (%s, %s)" % (inst, dev, kind, model, xs, ys))
