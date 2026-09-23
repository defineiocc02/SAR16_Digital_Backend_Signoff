#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Is the geometry in the delivered GDS actually the KIT's geometry?

The merge wrapped every standard cell and put the real layout one level down under
a mangled name.  If that geometry came from anywhere other than the kit GDS the
CDL describes, per-cell device counts would differ even though the kit is
self-consistent.  Compare the two directly: polygon counts per layer and bbox.
"""
import os
import struct
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
MERGED = os.path.join(HERE, "..", "evidence", "rpt_v51", "sar_digi_paper_core_merged.gds")
KIT = sys.argv[1] if len(sys.argv) > 1 else None
REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x0E: "DATATYPE", 0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}


def cells_with_geom(path):
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
            cur = Counter(); name = None
        elif n == "STRNAME":
            name = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            if name is not None:
                out[name] = cur
            cur = None
        elif rt in ELEM:
            el = {"kind": n, "layer": None}
        elif n == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", d[:2])[0]
        elif n == "ENDEL":
            if el is not None and cur is not None and el["layer"] is not None:
                if el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    cur[el["layer"]] += 1
            el = None
    f.close()
    return out


merged = cells_with_geom(MERGED)
print("merged GDS: %d cells" % len(merged))

# find the renamed real cells by their layer signature
real = {k: v for k, v in merged.items() if (10 in v and 30 in v)}
frames = {k: v for k, v in merged.items() if set(v) == {127, 141}}
print("cells with device geometry (10+30): %d" % len(real))
print("frame-only cells                  : %d" % len(frames))

if KIT:
    kit = cells_with_geom(KIT)
    print("kit GDS   : %d cells" % len(kit))
    # pair each frame name with the renamed cell its SREF points to
    print("\n=== frame name -> renamed geometry cell -> layer histogram comparison ===")
    import re
    # the mapping was established earlier; rebuild it from the merged file
    f2 = open(MERGED, "rb")
    cur = None
    name = None
    el = None
    link = {}
    while True:
        h = f2.read(4)
        if len(h) < 4:
            break
        rl, rt, rd = struct.unpack(">HBB", h)
        d = f2.read(rl - 4) if rl >= 4 else b""
        n = REC.get(rt)
        if n == "BGNSTR":
            cur = []; name = None
        elif n == "STRNAME":
            name = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            cur = None
        elif rt in ELEM:
            el = {"kind": n, "sname": None}
        elif n == "SNAME" and el is not None:
            el["sname"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDEL":
            if el is not None and el["kind"] in ("SREF", "AREF") and el["sname"] and name:
                link.setdefault(name, []).append(el["sname"])
            el = None
    f2.close()

    print("%-12s %-30s %-42s %s" % ("frame", "-> geometry cell", "layers", "kit cell layers"))
    shown = 0
    for fn in ("INVXL", "NOR2XL", "DFFSX1", "NAND2BXL", "AOI21XL", "XNOR2XL"):
        g = (link.get(fn) or [None])[0]
        if not g or g not in merged:
            print("%-12s %-30s %s" % (fn, g or "(none)", "(no geometry)"))
            continue
        ml = ",".join("%d:%d" % (k, merged[g][k]) for k in sorted(merged[g]))
        kl = ",".join("%d:%d" % (k, kit[fn][k]) for k in sorted(kit.get(fn, {})))
        same = (sorted(merged[g].items()) == sorted(kit.get(fn, {}).items()))
        print("%-12s %-30s %-42s %s   %s" % (fn, g, ml, kl, "IDENTICAL" if same else "DIFFERENT"))
        shown += 1
else:
    print("\n(no kit GDS path given; pass it as argv[1] to compare)")
