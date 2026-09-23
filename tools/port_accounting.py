#!/usr/bin/env python3
"""Exact top-level port accounting: source CDL vs extracted layout netlist.

SPICE/CDL continuation lines START with '+'.  (A previous attempt looked for a
trailing '+', which is why it reported 0 ports.)
"""
import sys

SRC = "/home/<user>/sar16_work/proj_paper_core/calibre/lvs/sar16.cdl"
SP = "/home/<user>/sar16_work/proj_paper_core/calibre/lvs/svdb/sar_digi_paper_core.sp"
TOP = "sar_digi_paper_core"


def ports(path):
    lines = open(path, errors="replace").read().splitlines()
    toks, on = [], False
    for l in lines:
        s = l.rstrip()
        up = s.upper()
        if not on:
            if up.startswith(".SUBCKT " + TOP.upper()):
                on = True
                toks.append(s[len(".SUBCKT "):].strip())
                if not s.upper().startswith(".SUBCKT " + TOP.upper() + " "):
                    # name-only line; ports follow
                    toks = []
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

sset, lset = set(src), set(lay)
print("\nsource-only ports : %d" % len(sset - lset))
for p in sorted(sset - lset):
    print("   %s" % p)
print("\nlayout-only ports : %d" % len(lset - sset))
for p in sorted(lset - sset):
    print("   %s" % p)

print("\nrst_n in source : %s" % ("rst_n" in sset))
print("rst_n in layout : %s" % ("rst_n" in lset))
print("VDD in layout   : %s ; VSS in layout : %s" % ("VDD" in lset, "VSS" in lset))

# how many of the 232 source names are degenerate?
wrd = [p for p in src if p.startswith("weight_rd_data")]
sro = [p for p in src if p.startswith("srm_residue_o")]
print("\nweight_rd_data ports : %d %s" % (len(wrd), sorted(wrd)[:4]))
print("srm_residue_o ports  : %d" % len(sro))
print("232 - (30-1) - (21-1) = %d" % (232 - 29 - 20))
