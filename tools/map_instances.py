#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Map Calibre's layout instance names onto the source hierarchy.

The INCORRECT INSTANCES block prints, for every MATCHED device, both names:
    X0/X414/M0(136.12,389.22)  MN(N18)      Xu_calib_ctrl/Xtemp_acc_reg[6]/M13  MN(N18)
Those pairs are an oracle: they tell us which source instance each layout
instance corresponds to.  Then the layout-only devices can be named by the
company they keep.
"""
import io
import os
import re
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
LVS = os.path.join(HERE, "..", "evidence", "rpt_v51", "lvs.rep")
t = io.open(LVS, encoding="utf-8", errors="replace").read()

# paired lines: layout dev ...  source dev
pairs = re.findall(
    r"^\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)\s+"
    r"(\S+?)/(M\d+)\s+(M[NP])\((\w+)\)\s*$", t, re.M)
print("matched device pairs found: %d" % len(pairs))

inst_map = defaultdict(Counter)
for li, ld, x, y, lk, lm, si, sd, sk, sm in pairs:
    # strip the trailing register/bit suffix to get the containing instance
    inst_map[li][re.sub(r"/M\d+$", "", si)] += 1
print("layout instances with a known source counterpart: %d" % len(inst_map))
for k in list(inst_map)[:8]:
    print("   %-14s -> %s" % (k, inst_map[k].most_common(2)))

# the flagged instances
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
flag = re.findall(r"^\s+\d+\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)"
                  r"\s+\*\* missing instance", blk, re.M)
print("\nlayout-only devices: %d, in %d distinct instances"
      % (len(flag), len({f[0] for f in flag})))

print("\n=== who are they, by the company they keep ===")
resolved = 0
for inst in sorted({f[0] for f in flag}):
    src = inst_map.get(inst)
    if src:
        resolved += 1
        print("   %-14s -> nearest matched source: %s" % (inst, src.most_common(1)[0][0]))
    else:
        print("   %-14s -> no matched sibling (cannot name it this way)" % inst)

print("\nresolved %d of %d instances" % (resolved, len({f[0] for f in flag})))

# aggregate by the source block name
agg = Counter()
for inst in {f[0] for f in flag}:
    src = inst_map.get(inst)
    if src:
        nm = src.most_common(1)[0][0]
        agg[re.sub(r"/[^/]*$", "", nm)] += 1
print("\n=== by source sub-block ===")
for k, v in agg.most_common():
    print("   %-30s %d" % (k, v))

# how many devices in total are flagged per source block, using counts
print("\n=== VDD/VSS connection-delta context ===")
m = re.search(r"Net VDD.*?--- (\d+) Connections On This Net ---\s+--- (\d+) Connections", t, re.S)
if m:
    print("   VDD layout=%s source=%s delta=+%d" % (m.group(1), m.group(2),
                                                   int(m.group(1)) - int(m.group(2))))
