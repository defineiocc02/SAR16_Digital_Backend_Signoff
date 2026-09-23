#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""What exactly are the layer-141 / layer-127 elements inside a frame cell?

TEXT records (with strings) and BOUNDARY polygons behave completely differently
under a deck that says  TEXT LAYER 141 ATTACH 141 metal1 .
"""
import os
import struct

HERE = os.path.dirname(os.path.abspath(__file__))
GDS = os.path.join(HERE, "..", "evidence", "rpt_v51", "sar_digi_paper_core_merged.gds")
REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x0E: "DATATYPE", 0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME",
       0x16: "TEXTTYPE", 0x19: "STRING"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}

f = open(GDS, "rb")
cur = None
cur_name = None
el = None
found = {}
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack(">HBB", h)
    d = f.read(rl - 4) if rl >= 4 else b""
    n = REC.get(rt)
    if n == "BGNSTR":
        cur = []
    elif n == "STRNAME":
        cur_name = d.split(b"\x00")[0].decode("latin-1")
    elif n == "ENDSTR":
        if cur_name in ("INVXL", "NOR2XL", "DFFSX1"):
            found[cur_name] = cur
        cur = None
    elif rt in ELEM:
        el = {"kind": n, "layer": None, "dt": None, "text": None, "npts": 0}
    elif n == "LAYER" and el is not None:
        el["layer"] = struct.unpack(">h", d[:2])[0]
    elif n in ("DATATYPE", "TEXTTYPE") and el is not None:
        el["dt"] = struct.unpack(">h", d[:2])[0]
    elif n == "XY" and el is not None:
        el["npts"] = len(d) // 8
    elif n == "STRING" and el is not None:
        el["text"] = d.split(b"\x00")[0].decode("latin-1")
    elif n == "ENDEL":
        if el is not None and cur is not None:
            cur.append(el)
        el = None
f.close()

for nm, els in found.items():
    print("=== %s : %d element(s) ===" % (nm, len(els)))
    for e in els:
        t = (" text=%r" % e["text"]) if e["text"] else ""
        print("   %-9s layer=%-5s datatype=%-5s points=%d%s"
              % (e["kind"], e["layer"], e["dt"], e["npts"], t))
    print()
