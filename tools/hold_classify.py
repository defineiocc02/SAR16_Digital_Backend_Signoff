#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Classify every hold violation: boundary or internal?

If every violation is input-port -> first flop (or last flop -> output port), then
the block has no internal hold problem and the requirement is a boundary one,
driven by the SDC's placeholder external hold assumption.  If any violation is
flop -> flop inside the design, that is a real internal hold problem and a
different fix applies.  The distinction decides the whole conclusion.
"""
import io
import os
import re
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
STA = os.path.join(HERE, "..", "evidence", "rpt_v51", "sta")


def paths(fn):
    txt = io.open(os.path.join(STA, fn), encoding="utf-8", errors="replace").read()
    out = []
    for blk in txt.split("Startpoint:")[1:]:
        sp = blk.split("\n")[0].strip()
        m = re.search(r"Endpoint:\s*(\S+)", blk)
        ep = m.group(1) if m else "?"
        m = re.search(r"slack\s+\(VIOLATED\)\s+([-\d.]+)", blk)
        if not m:
            continue
        slack = float(m.group(1))
        # is the endpoint a flop (has /D or /CK) or a port?
        ep_ff = bool(re.search(r"/(D|CK|SI|SE|SN|Q|QN)$|_reg\[", ep))
        sp_ff = bool(re.search(r"/(D|CK|SI|SE|SN|Q|QN)$|_reg\[", sp))
        out.append((sp, ep, slack, sp_ff, ep_ff))
    return out


for corner in ("typical", "slow", "fast"):
    fn = "sta_pc_%s_pc_hold.rpt" % corner
    if not os.path.exists(os.path.join(STA, fn)):
        continue
    ps = paths(fn)
    cls = Counter()
    for sp, ep, slack, sp_ff, ep_ff in ps:
        if not sp_ff and ep_ff:
            cls["input port -> flop"] += 1
        elif sp_ff and not ep_ff:
            cls["flop -> output port"] += 1
        elif sp_ff and ep_ff:
            cls["flop -> flop (INTERNAL)"] += 1
        else:
            cls["port -> port"] += 1
    print("=== %s : %d violating hold path(s) ===" % (corner, len(ps)))
    for k, v in cls.most_common():
        print("   %-26s %d" % (k, v))
    w = min(ps, key=lambda p: p[2]) if ps else None
    if w:
        print("   worst: %-42s -> %-42s  %+.4f ns" % (w[0][:42], w[1][:42], w[2]))
    if cls.get("flop -> flop (INTERNAL)"):
        print("   INTERNAL hold violators:")
        for sp, ep, slack, sf, ef in ps:
            if sf and ef:
                print("      %-46s -> %-46s %+.4f" % (sp[:46], ep[:46], slack))
    print()

print("=== how many DISTINCT startpoints/endpoints ===")
for corner in ("slow", "fast"):
    fn = "sta_pc_%s_pc_hold.rpt" % corner
    if os.path.exists(os.path.join(STA, fn)):
        ps = paths(fn)
        print("   %-8s startpoints=%d endpoints=%d"
              % (corner, len({p[0] for p in ps}), len({p[1] for p in ps})))
        print("            startpoint sample: %s" % sorted({p[0] for p in ps})[:6])
        print("            endpoint   sample: %s" % sorted({p[1] for p in ps})[:6])
