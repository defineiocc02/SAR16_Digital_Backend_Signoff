#!/bin/bash
python3 - <<'PYEOF'
def ports(path, top="sar_digi_paper_core"):
    lines = open(path, errors="replace").read().splitlines()
    toks, on = [], False
    for l in lines:
        s = l.rstrip(); up = s.upper()
        if not on:
            if up.startswith(".SUBCKT " + top.upper()):
                on = True; toks.append(s[len(".SUBCKT "):].strip())
        else:
            if s.startswith("+"): toks.append(s[1:].strip())
            else: break
    w = " ".join(toks).split()
    return w[1:] if w and w[0] == top else w
src = ports("/home/<user>/sar16_work/proj_paper_core/calibre/lvs/sar16.cdl")
lay = ports("/home/<user>/sar16_work/proj_paper_core/calibre/lvs/svdb/sar_digi_paper_core.sp")
print("source=%d layout=%d" % (len(src), len(lay)))
print("layout-only :", sorted(set(lay) - set(src)))
print("source-only :", sorted(set(src) - set(lay)))
PYEOF
echo
echo "=== does the source CDL still carry .GLOBAL? ==="
grep -n '^[.]GLOBAL' /home/<user>/sar16_work/proj_paper_core/calibre/lvs/sar16.cdl | head -3
echo
echo "=== GLOBALS / POWER-NAME settings in the deck ==="
grep -nE 'LVS (GLOBALS|POWER|GROUND)' /home/<user>/sar16_work/proj_paper_core/calibre/lvs/mylvs.lvs
