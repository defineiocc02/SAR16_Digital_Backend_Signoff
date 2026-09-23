#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Is the SOURCE netlist short of devices?

Everything on the layout side has now been cleared: the kit is self-consistent
(109/109), the placement multiset matches the netlist exactly (3626/3626), and the
merged geometry is identical to the kit's.  So compute what the source SHOULD
contain -- sum over masters of (placements x devices declared in the kit CDL,
expanded recursively) -- and compare with what Calibre counted (50026).
"""
import io
import os
import re
import sys
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
EV = os.path.join(HERE, "..", "evidence")
MASTERS = os.path.join(HERE, "..", "probes", "masters.txt")
CDL = sys.argv[1] if len(sys.argv) > 1 else None


def parse_cdl(path):
    subs = {}
    cur = None
    raw = io.open(path, encoding="utf-8", errors="replace").read()
    for ln in raw.splitlines():
        s = ln.strip()
        up = s.upper()
        if up.startswith(".SUBCKT"):
            p = s.split()
            cur = p[1]
            subs[cur] = {"devs": 0, "kids": Counter()}
        elif up.startswith(".ENDS"):
            cur = None
        elif cur and s and s[0] in "Mm":
            subs[cur]["devs"] += 1
        elif cur and s and s[0] in "Xx":
            p = s.split()
            if len(p) >= 2:
                subs[cur]["kids"][p[-1]] += 1
    return subs


def expand(name, subs, acc, mult=1, depth=0):
    if depth > 12 or name not in subs or mult <= 0:
        return
    s = subs[name]
    acc[name] += mult
    for k, c in s["kids"].items():
        expand(k, subs, acc, mult * c, depth + 1)


subs = parse_cdl(CDL) if CDL else {}
print("kit CDL subckts: %d" % len(subs))

place = {}
for ln in io.open(MASTERS, encoding="utf-8").read().splitlines():
    p = ln.split()
    if len(p) == 2:
        place[p[0]] = int(p[1])
print("placed masters: %d   placements: %d" % (len(place), sum(place.values())))

acc = Counter()
for m, n in place.items():
    expand(m, subs, acc, n)

total = 0
missing = []
for m, n in acc.items():
    if m in subs:
        total += subs[m]["devs"] * n
    else:
        missing.append((m, n))

print("\n=== expected source device count ===")
print("   sum over expanded hierarchy: %d" % total)
print("   Calibre's SOURCE count     : 50026")
print("   difference                 : %d" % (total - 50026))
print("   Calibre's LAYOUT count     : 50686")
print("   layout - computed          : %d" % (50686 - total))

if missing:
    print("\n=== masters not found in the CDL (%d) ===" % len(missing))
    for m, n in sorted(missing, key=lambda x: -x[1])[:20]:
        print("   %-44s x%d" % (m, n))
else:
    print("\n   every placed master exists in the CDL")

print("\n=== deepest expansion (top 15 by count) ===")
for m, n in acc.most_common(15):
    d = subs.get(m, {}).get("devs", 0)
    print("   %-24s x%-6d  devs/cell=%-4d  devices=%d" % (m, n, d, d * n))
