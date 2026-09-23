#!/bin/bash
# Round 14: re-run the best LVS configuration with the report cap raised, so the
# per-net device lists are no longer truncated.  That decides whether the 8 incorrect
# nets which touch none of the 15 affected masters are really unrelated, or just had
# their affected neighbour cut off by `LVS REPORT MAXIMUM 50`.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
LVS=$PC/calibre/lvs
W=/tmp/lvs14
rm -rf $W; mkdir -p $W; cd $W || exit 1

python3 - "$LVS/svdb/sar_digi_paper_core.sp" > $W/boxlist.txt <<'PYEOF'
import sys, collections
logical = []
for raw in open(sys.argv[1], errors='replace'):
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
NAMES=$(tr '\n' ' ' < $W/boxlist.txt)
echo "BOX_CELLS=$(wc -l < $W/boxlist.txt)"

awk -v box="LVS BOX $NAMES" '{ print } /^LAYOUT PRIMARY/ && !d { print box; d=1 }' \
    $LVS/mylvs.lvs > $W/lvsM.lvs
# raise the object-report cap and keep INJECT LOGIC off
python3 - "$W/lvsM.lvs" <<'PYEOF'
import io, re, sys
p = sys.argv[1]
t = io.open(p, errors='replace').read()
t2, n = re.subn(r'(?m)^LVS REPORT MAXIMUM\s+\d+', 'LVS REPORT MAXIMUM 500', t)
if n == 0:
    t2 = t + '\nLVS REPORT MAXIMUM 500\n'
t2 += "\nLVS INJECT LOGIC NO\n"
t2 = re.sub(r'(?m)^LVS REPORT "[^"]*"', 'LVS REPORT "/tmp/lvs14/lvsM.rep"', t2)
io.open(p, 'w', newline='\n').write(t2)
print('  cap rewritten: %d   INJECT NO appended' % n)
PYEOF
echo "  $(grep -m1 '^LVS REPORT MAXIMUM' $W/lvsM.lvs)"
echo "  $(grep -m1 '^LVS REPORT \"' $W/lvsM.lvs)"
echo "  $(grep -m1 '^LVS INJECT LOGIC' $W/lvsM.lvs)"

T0=$(date +%s)
calibre -lvs -hier -turbo 6 lvsM.lvs > $W/lvsM.log 2>&1
echo "RC=$? elapsed=$(( $(date +%s) - T0 ))s"
grep -a -m1 'LVS completed' $W/lvsM.log
echo "  cap in report: $(grep -a -m1 'LVS REPORT MAXIMUM' $W/lvsM.rep | sed 's/^ *//')"
echo "  inject in report: $(grep -a -m1 'LVS INJECT LOGIC' $W/lvsM.rep | sed 's/^ *//')"
echo "  report bytes: $(stat -c%s $W/lvsM.rep)"
echo "  incorrect-net entries: $(grep -a -c 'Connections On This Net' $W/lvsM.rep)"
N=$(grep -n 'NUMBERS OF OBJECTS AFTER TRANSFORMATION' $W/lvsM.rep | head -1 | cut -d: -f1)
sed -n "$((N+3)),$((N+11))p" $W/lvsM.rep | sed 's/^/    /'
echo "=== LVS14_DONE ==="
