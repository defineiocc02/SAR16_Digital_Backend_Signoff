#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Which CELL do the layout-only transistors belong to?

The extracted layout netlist is hierarchical: instance Xn maps to a .SUBCKT whose
name is the master cell.  So for each instance that Calibre flagged, we can read
off the master and count devices -- then compare with the kit CDL's .SUBCKT for
the same master.  A mismatch there means the KIT is internally inconsistent, not
our design.
"""
import io
import os
import re
from collections import Counter, defaultdict

R = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "evidence", "rpt_v51")
SP = os.path.join(R, "sar_digi_paper_core.sp")
CDL = os.path.join(R, "sar16.cdl")


def parse_sp(path):
    """subckt -> dict(devices=['M...'], types=Counter, insts=[(name, master)])"""
    subs = {}
    cur = None
    for ln in io.open(path, encoding="utf-8", errors="replace").read().splitlines():
        s = ln.strip()
        if s.upper().startswith(".SUBCKT"):
            p = s.split()
            cur = p[1]
            subs[cur] = dict(devs=0, types=Counter(), insts=[], pins=len(p) - 2)
            continue
        if s.upper().startswith(".ENDS"):
            cur = None
            continue
        if cur is None or not s or s.startswith("*"):
            continue
        if s[0] in "Mm":
            subs[cur]["devs"] += 1
            p = s.split()
            if len(p) >= 6:
                subs[cur]["types"][p[-1]] += 1
        elif s[0] in "Xx":
            p = s.split()
            subs[cur]["insts"].append((p[0], p[-1]))
    return subs


subs = parse_sp(SP)
print("extracted netlist: %d .SUBCKT definitions" % len(subs))
print("top cell device count: %s" % subs.get("sar_digi_paper_core", {}).get("devs"))
print()

# map the reported instances back to masters via their parent subckt
t = io.open(os.path.join(R, "lvs.rep"), encoding="utf-8", errors="replace").read()
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
missing = re.findall(r"^\s+\d+\s+(\S+)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)",
                     blk, re.M)
print("flagged layout-only transistors: %d" % len(missing))
print()

# Calibre's layout instance names are X<topidx>/<path>.  The extracted netlist
# uses the same X-numbering for the top level, so walk it.
top = subs.get("sar_digi_paper_core")
idx2master = {}
if top:
    for nm, master in top["insts"]:
        m = re.match(r"^X(\d+)$", nm)
        if m:
            idx2master[int(m.group(1))] = master
print("top-level instance map (X<idx> -> master): %d entries" % len(idx2master))
print("   sample: %s" % list(idx2master.items())[:6])

masters_hit = Counter()
for full, dev, x, y, kind, model in missing:
    parts = full.split("/")
    m = re.match(r"^X(\d+)$", parts[0])
    if not m:
        continue
    masters_hit[idx2master.get(int(m.group(1)), "?" + parts[0])] += 1
print("\n=== master cells of the flagged transistors ===")
for k, v in masters_hit.most_common(20):
    d = subs.get(k, {})
    print("   %-24s %2d flagged   (extracted: %s devices, pins=%s)"
          % (k, v, d.get("devs"), d.get("pins")))

# kit CDL device counts for the same masters
cdl = {}
cur = None
for ln in io.open(CDL, encoding="utf-8", errors="replace").read().splitlines():
    s = ln.strip()
    if s.upper().startswith(".SUBCKT"):
        cur = s.split()[1]
        cdl[cur] = 0
    elif s.upper().startswith(".ENDS"):
        cur = None
    elif cur and s[:1] in ("M", "m"):
        cdl[cur] += 1
print("\n=== kit CDL vs extracted layout, per master ===")
print("%-24s %10s %10s %8s" % ("master", "kit CDL M", "layout M", "delta"))
tot_c = tot_l = 0
for k, v in masters_hit.most_common(20):
    l = subs.get(k, {}).get("devs", 0)
    c = cdl.get(k, 0)
    tot_c += c
    tot_l += l
    print("%-24s %10d %10d %+8d" % (k, c, l, l - c))
print("%-24s %10d %10d %+8d" % ("TOTAL", tot_c, tot_l, tot_l - tot_c))
