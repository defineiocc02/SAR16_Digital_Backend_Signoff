#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Diff the cell masters in the LAYOUT against the cell masters in the NETLIST.

If the layout places masters that the netlist never instantiates -- filler, tap or
decap cells are physical-only -- their transistors appear in the extraction with
no source counterpart, which is exactly the shape of the remaining mismatch.
"""
import io
import os
import re
import struct
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
R = os.path.join(HERE, "..", "evidence", "rpt_v51")
GDS = os.path.join(R, "sar_digi_paper_core_merged.gds")
V = os.path.join(R, "sar_digi_paper_core_pnr.v")

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x0A: "SREF", 0x0B: "AREF",
       0x11: "ENDEL", 0x12: "SNAME"}


def gds_masters(path, top="sar_digi_paper_core"):
    f = open(path, "rb")
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
        elif n == "SNAME" and cur == top:
            refs[d.split(b"\x00")[0].decode("latin-1")] += 1
    f.close()
    return refs


layout = gds_masters(GDS)
print("layout top cell references %d distinct masters, %d placements"
      % (len(layout), sum(layout.values())))

txt = io.open(V, encoding="utf-8", errors="replace").read()
# Verilog netlist: instances look like   CELLNAME instname ( .PIN(net), ... );
net = Counter()
for m in re.finditer(r"^\s{0,8}([A-Za-z_][\w]*)\s+([\\\w\[\]\./]+)\s*\(", txt, re.M):
    name = m.group(1)
    if name in ("module", "input", "output", "wire", "reg", "assign", "endmodule",
                "always", "if", "else", "begin", "case", "endcase", "default"):
        continue
    net[name] += 1
print("netlist references %d distinct masters, %d instances"
      % (len(net), sum(net.values())))

lon = set(layout)
non = set(net)
print("\n=== masters in the LAYOUT but not in the NETLIST ===")
extra = sorted(lon - non)
tot = 0
for m in extra:
    print("   %-26s %d placement(s)" % (m, layout[m]))
    tot += layout[m]
print("   -> %d placement(s) with no netlist counterpart" % tot)

print("\n=== masters in the NETLIST but not in the LAYOUT ===")
for m in sorted(non - lon)[:20]:
    print("   %-26s %d instance(s)" % (m, net[m]))

print("\n=== masters present in both but with different counts ===")
diff = [(m, layout[m], net[m]) for m in sorted(lon & non) if layout[m] != net[m]]
for m, a, b in diff[:25]:
    print("   %-26s layout %5d  netlist %5d  delta %+d" % (m, a, b, a - b))
print("   (%d masters differ)" % len(diff))
