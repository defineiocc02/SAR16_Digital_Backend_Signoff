#!/bin/bash
# Round 10: re-create the BEST LVS configuration (variant F = cells boxed + INJECT
# LOGIC NO) and dump the remaining incorrect objects in full, so the residual can be
# dispositioned one net at a time instead of being described as a percentage.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
LVS=$PC/calibre/lvs
W=/tmp/lvs10
rm -rf $W; mkdir -p $W; cd $W || exit 1

# box list = every real standard-cell master in the extracted layout netlist
python3 - "$LVS/svdb/sar_digi_paper_core.sp" > $W/boxlist.txt <<'PYEOF'
import sys, collections
path = sys.argv[1]
logical = []
for raw in open(path, errors='replace'):
    st = raw.strip()
    if st.startswith('+'):
        if logical: logical[-1] = logical[-1] + ' ' + st[1:].strip()
        continue
    logical.append(st)
cur = None; subs = collections.OrderedDict(); order = []
for st in logical:
    up = st.upper()
    if up.startswith('.SUBCKT'):
        t = st.split(); cur = t[1]; subs[cur] = {'m': 0}; order.append(cur); continue
    if up.startswith('.ENDS'):
        cur = None; continue
    if cur and st and st[0].upper() == 'M':
        subs[cur]['m'] += 1
for k in order:
    if not k.startswith('ICV_') and k != 'sar_digi_paper_core' and subs[k]['m'] > 0:
        print(k)
PYEOF
echo "BOX_CELLS=$(wc -l < $W/boxlist.txt)"
NAMES=$(tr '\n' ' ' < $W/boxlist.txt)

awk -v box="LVS BOX $NAMES" '{ print } /^LAYOUT PRIMARY/ && !d { print box; d=1 }' \
    $LVS/mylvs.lvs > $W/lvsF.lvs
printf 'LVS INJECT LOGIC NO\n' >> $W/lvsF.lvs
sed -i "s|^LVS REPORT \".*\"|LVS REPORT \"$W/lvsF.rep\"|" $W/lvsF.lvs
echo "  BOX stmts=$(grep -c '^LVS BOX ' $W/lvsF.lvs)  INJECT_NO=$(grep -c '^LVS INJECT LOGIC NO' $W/lvsF.lvs)"

T0=$(date +%s)
calibre -lvs -hier -turbo 6 lvsF.lvs > $W/lvsF.log 2>&1
echo "RC=$? elapsed=$(( $(date +%s) - T0 ))s"
grep -a -m1 'LVS completed' $W/lvsF.log
R=$W/lvsF.rep
echo ""
echo "=== errors / warnings ==="
grep -a -E '^  (Error|Warning):' $R | sed 's/^ *//' | sort -u
echo ""
echo "=== after transformation (top of table) ==="
N=$(grep -n 'NUMBERS OF OBJECTS AFTER TRANSFORMATION' $R | head -1 | cut -d: -f1)
sed -n "$((N+3)),$((N+10))p" $R
echo ""
echo "=== INCORRECT OBJECTS inventory ==="
for S in 'INCORRECT NETS' 'INCORRECT INSTANCES' 'INCORRECT PORTS' 'INCORRECT DEVICES' \
         'UNMATCHED' 'FLOATING' 'SHORTS' 'NO-SIMILAR'; do
    c=$(grep -a -c "$S" $R)
    echo "  $S : $c"
done
echo ""
echo "=== dump of the INCORRECT NETS section (first 260 lines) ==="
A=$(grep -n 'INCORRECT NETS' $R | head -1 | cut -d: -f1)
if [ -n "$A" ]; then sed -n "${A},$((A+260))p" $R; else echo "  no INCORRECT NETS section"; fi
echo "=== LVS10_DONE ==="
