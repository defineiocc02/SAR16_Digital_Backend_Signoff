#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/calibre/lvs
echo "=== overall comparison results ==="
sed -n '/OVERALL COMPARISON RESULTS/,/CELL  SUMMARY/p' $L/lvs.rep | head -20
echo
echo "=== ports: which side has extra? ==="
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
print("  source ports=%d  layout ports=%d" % (len(src), len(lay)))
print("  layout-only :", sorted(set(lay) - set(src)))
print("  source-only :", sorted(set(src) - set(lay)))
print("  rst_n in layout :", "rst_n" in set(lay))
PYEOF
echo
echo "=== incorrect nets / instances summary ==="
grep -acE '^ +[0-9]+ +Net ' $L/lvs.rep
grep -anE 'Incorrect (Nets|Instances|Ports)|^\s+Net VDD|^\s+Net VSS' $L/lvs.rep | head -12
echo
echo "=== the first 3 incorrect nets, with connection counts ==="
awk '/^ +[0-9]+ +Net /{c++} c>=1 && c<=3' $L/lvs.rep | grep -aE '^\s+[0-9]+ +Net|Connections On This Net' | head -12
echo
echo "=== ERC ==="
head -40 $L/erc.rep 2>/dev/null
