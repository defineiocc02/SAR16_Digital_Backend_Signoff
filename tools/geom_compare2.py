#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Follow the frame -> geometry link in BOTH files and compare the geometry.

The kit GDS is itself two-level: a named cell holds an outline (layer 127), the
pin-name texts (layer 141) and one SREF to the real layout.  The merged GDS keeps
that shape but renames the inner cell.  This checks whether the merged inner cell
is byte-for-byte the same set of polygons as the kit's inner cell.
"""
import os
import struct
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
MERGED = os.path.join(HERE, "..", "evidence", "rpt_v51", "sar_digi_paper_core_merged.gds")
KIT = sys.argv[1]
REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x0E: "DATATYPE", 0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}


def scan(path):
    """returns {cell: {'layers':Counter, 'srefs':[names], 'bbox':(..)}}"""
    f = open(path, "rb")
    out = {}
    cur = None
    name = None
    el = None
    while True:
        h = f.read(4)
        if len(h) < 4:
            break
        rl, rt, rd = struct.unpack(">HBB", h)
        d = f.read(rl - 4) if rl >= 4 else b""
        n = REC.get(rt)
        if n == "BGNSTR":
            cur = {"layers": Counter(), "srefs": [], "bbox": None}
            name = None
        elif n == "STRNAME":
            name = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            if name:
                out[name] = cur
            cur = None
        elif rt in ELEM:
            el = {"kind": n, "layer": None, "xy": None, "sname": None}
        elif n == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", d[:2])[0]
        elif n == "XY" and el is not None:
            k = len(d) // 4
            el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
        elif n == "SNAME" and el is not None:
            el["sname"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDEL":
            if el is not None and cur is not None:
                if el["kind"] in ("SREF", "AREF") and el["sname"]:
                    cur["srefs"].append(el["sname"])
                elif el["layer"] is not None and el["xy"]:
                    cur["layers"][el["layer"]] += 1
                    xs = el["xy"][0::2]; ys = el["xy"][1::2]
                    bb = (min(xs), min(ys), max(xs), max(ys))
                    b = cur["bbox"]
                    cur["bbox"] = bb if b is None else (min(b[0], bb[0]), min(b[1], bb[1]),
                                                        max(b[2], bb[2]), max(b[3], bb[3]))
            el = None
    f.close()
    return out


kit = scan(KIT)
merged = scan(MERGED)
print("kit cells: %d   merged cells: %d" % (len(kit), len(merged)))

print("\n%-10s %-30s %-38s %-38s %s" % ("cell", "kit inner cell", "kit inner layers",
                                        "merged inner cell", "merged inner layers"))
for fn in ("INVXL", "NOR2XL", "DFFSX1", "NAND2BXL", "AOI21XL", "XNOR2XL", "CLKBUFX2"):
    kin = (kit.get(fn, {}).get("srefs") or [None])[0]
    min_ = (merged.get(fn, {}).get("srefs") or [None])[0]
    kl = kit.get(kin, {}).get("layers") if kin else None
    ml = merged.get(min_, {}).get("layers") if min_ else None
    same = (kl is not None and ml is not None and sorted(kl.items()) == sorted(ml.items()))
    print("%-10s %-30s %-38s %-38s %s" % (
        fn, kin or "-",
        ",".join("%d:%d" % (k, kl[k]) for k in sorted(kl)) if kl else "-",
        ",".join("%d:%d" % (k, ml[k]) for k in sorted(ml)) if ml else "-",
        ("IDENTICAL" if same else "DIFFERENT")))

print("\n=== bbox comparison for the inner cells ===")
for fn in ("INVXL", "NOR2XL", "DFFSX1"):
    kin = (kit.get(fn, {}).get("srefs") or [None])[0]
    min_ = (merged.get(fn, {}).get("srefs") or [None])[0]
    print("   %-10s kit %s   merged %s" % (fn,
          kit.get(kin, {}).get("bbox"), merged.get(min_, {}).get("bbox")))
