#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Layout placements vs netlist instances, counted properly.

The netlist may be hierarchical, so counting only the top module is not the same
as counting the design.  This counts instances in EVERY module body and compares
the multiset of masters against the layout's placed masters.
"""
import io
import os
import struct
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
R = os.path.join(HERE, "..", "evidence", "rpt_v51")
V = os.path.join(R, "sar_digi_paper_core_pnr.v")
GDS = os.path.join(R, "sar_digi_paper_core_merged.gds")

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x0A: "SREF", 0x0B: "AREF",
       0x11: "ENDEL", 0x12: "SNAME"}

# ---- layout ----
f = open(GDS, "rb")
cur = None
lay = Counter()
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
        nm = d.split(b"\x00")[0].decode("latin-1")
        if not nm.startswith("$$"):
            lay[nm] += 1
f.close()

# ---- netlist ----
txt = io.open(V, encoding="utf-8", errors="replace").read()
modules = {}
cur_mod = None
for ln in txt.splitlines():
    s = ln.strip()
    if s.startswith("module "):
        cur_mod = s.split()[1].split("(")[0]
        modules[cur_mod] = Counter()
    elif s.startswith("endmodule"):
        cur_mod = None
    elif cur_mod:
        if s.startswith(("input", "output", "inout", "wire", "reg", "assign", "parameter",
                         "localparam", "//", "/*", "*", "`", "endmodule", "generate",
                         "endgenerate", "always", "initial", "if", "else", "case",
                         "endcase", "begin", "end", "for", "function", "endfunction")):
            continue
        # structural instance:  MASTER instname ( ... );
        m = s.split()
        if len(m) >= 2 and m[1].endswith("(") is False and "(" in s:
            name = m[0]
            if name not in ("module",) and not name.startswith("."):
                modules[cur_mod][name] += 1

# flatten: expand recursively
def expand(mod, mult, acc, depth=0):
    if depth > 12:
        return
    for master, cnt in modules.get(mod, {}).items():
        acc[master] += cnt * mult
        if master in modules:
            expand(master, cnt * mult, acc, depth + 1)

flat = Counter()
expand("sar_digi_paper_core", 1, flat)
# phys-only cells appear as leaf masters that ARE in the netlist but also as modules
no_mod = {k: v for k, v in flat.items() if k not in modules}
print("netlist modules defined : %d" % len(modules))
print("flattened instance count: %d (over %d distinct leaf masters)"
      % (sum(no_mod.values()), len(no_mod)))
print("layout logic placements : %d (over %d distinct masters)" % (sum(lay.values()), len(lay)))

print("\n=== masters placed in the LAYOUT that the FLATTENED NETLIST never instantiates ===")
extra = sorted(set(lay) - set(no_mod))
for m in extra:
    print("   %-18s %d placement(s)" % (m, lay[m]))
print("   (none)" if not extra else "")

print("\n=== masters the NETLIST instantiates that the LAYOUT does not place ===")
miss = sorted(set(no_mod) - set(lay))
for m in miss[:20]:
    print("   %-40s %d instance(s)" % (m, no_mod[m]))
print("   (none)" if not miss else "   ... %d total" % len(miss))

print("\n=== counts differ ===")
for m in sorted(set(lay) & set(no_mod)):
    if lay[m] != no_mod[m]:
        print("   %-18s layout %5d  netlist %5d  delta %+d" % (m, lay[m], no_mod[m], lay[m] - no_mod[m]))
