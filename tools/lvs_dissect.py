#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Dissect the remaining LVS mismatch in the v5.1 run."""
import io
import os
import re
from collections import Counter

R = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "evidence", "rpt_v51")
t = io.open(os.path.join(R, "lvs.rep"), encoding="utf-8", errors="replace").read()

print("=== INITIAL NUMBERS ===")
m = re.search(r"INITIAL NUMBERS OF OBJECTS(.*?)AFTER TRANSFORMATION", t, re.S)
print(m.group(1).strip()[:600] if m else "not found")

print("\n=== AFTER TRANSFORMATION ===")
m = re.search(r"AFTER TRANSFORMATION(.*?)(\* = Number of objects)", t, re.S)
body = m.group(1) if m else ""
rows = []
for ln in body.splitlines():
    mm = re.match(r"\s+([\w/_ ]+?):\s+(\d+)\s+(\d+)\s*(\*?)\s*(.*)$", ln)
    if mm:
        rows.append((mm.group(5).strip() or mm.group(1).strip(), int(mm.group(2)),
                     int(mm.group(3)), mm.group(4)))
if not rows:
    for ln in body.splitlines():
        mm = re.match(r"\s*([A-Za-z_][\w/]*)\s*\(?(\d+) pins\)?\s+(\d+)\s+(\d+)\s*(\*?)\s*$", ln)
        if mm:
            rows.append((mm.group(1), int(mm.group(3)), int(mm.group(4)), mm.group(5)))
print("%-34s %10s %10s %8s %s" % ("component type", "layout", "source", "delta", "flag"))
for name, l, s, f in rows:
    print("%-34s %10d %10d %+8d %s" % (name, l, s, l - s, f))

print("\n=== error / warning lines ===")
for e in re.finditer(r"^\s*(Error|Warning):\s*(.+)$", t, re.M):
    print("   %-8s %s" % (e.group(1), e.group(2).strip()))

print("\n=== INCORRECT NETS: first line of each entry ===")
nets = []
for mm in re.finditer(r"^\s+(\d+)\s+Net\s+(\S+)\s+(\S+)\s*$", t, re.M):
    nets.append((int(mm.group(1)), mm.group(2), mm.group(3)))
print("count: %d" % len(nets))
for i, a, c in nets[:25]:
    print("   %3d  %-34s %s" % (i, a, c))
print("   ..." if len(nets) > 25 else "")

print("\n=== INCORRECT NETS: connection-count deltas ===")
deltas = []
for mm in re.finditer(r"Net\s+(\S+)\s+(\S+)\s*\n\s+---\s+(\d+) Connections On This Net ---"
                      r"\s+---\s+(\d+) Connections", t):
    deltas.append((mm.group(1), int(mm.group(3)), int(mm.group(4))))
for n, l, s in deltas[:15]:
    print("   %-34s layout %6d  source %6d  delta %+6d" % (n, l, s, l - s))
print("   total entries: %d" % len(deltas))

print("\n=== INCORRECT INSTANCES: what is extra ===")
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
miss = re.findall(r"^(\s+\d+\s+\S+.*?)\s+\*\* missing instance \*\*", blk, re.M)
print("   'missing instance' lines: %d" % len(miss))
for x in miss[:12]:
    print("     " + x.strip()[:90])
cells = Counter(re.sub(r"/[^/]+$", "", x.split()[1]) for x in miss if len(x.split()) > 1)
print("   parent cells: %s" % cells.most_common(8))
types = Counter(re.findall(r"(MN|MP)\((\w+)\)", blk))
print("   device types: %s" % types.most_common(10))

print("\n=== how many nets carry 'no similar net' ===")
print("   %d" % len(re.findall(r"no similar net", t)))
