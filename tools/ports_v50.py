#!/usr/bin/env python3
"""Port accounting on the v5.0 run: source CDL vs extracted layout netlist."""
import sys

SRC = r"E:\ReedLab\tmp\sar16_handover\v50\sar16.cdl"
SP = r"E:\ReedLab\tmp\sar16_handover\v50\sar_digi_paper_core.sp"
TOP = "sar_digi_paper_core"


def ports(path, top=TOP):
    lines = open(path, errors="replace").read().splitlines()
    toks, on = [], False
    for l in lines:
        s = l.rstrip()
        up = s.upper()
        if not on:
            if up.startswith(".SUBCKT " + top.upper()):
                on = True
                toks.append(s[len(".SUBCKT "):].strip())
        else:
            if s.startswith("+"):
                toks.append(s[1:].strip())
            else:
                break
    words = " ".join(toks).split()
    return words[1:] if words and words[0] == TOP else words


src = ports(SRC)
lay = ports(SP)
print("source top ports : %d" % len(src))
print("layout top ports : %d" % len(lay))
s, l = set(src), set(lay)
print("\nsource-only : %d" % len(s - l))
for p in sorted(s - l):
    print("   %s" % p)
print("\nlayout-only : %d" % len(l - s))
for p in sorted(l - s):
    print("   %s" % p)

for grp in ("weight_rd_data", "srm_residue_o"):
    print("\n%s in source: %d" % (grp, sum(1 for p in src if p.startswith(grp))))
    print("%s in layout: %d" % (grp, sum(1 for p in lay if p.startswith(grp))))
print("\nexpected signal ports = 232 - 30 - 20 = 182")
print("GDS labels said        = 176 signal + 2 supply = 178")
