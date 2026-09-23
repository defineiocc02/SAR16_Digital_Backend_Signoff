#!/bin/bash
# Round 9: connectivity LVS with the standard cells BOXED.
# Rationale: cell-internal LVS is already proven (109/109 kit masters CORRECT
# standalone, and every master extracts identically in the kit GDS and in our
# merged GDS in-context).  The flat netlist comparison is dominated by
# multi-finger device reduction.  Boxing the cells compares exactly what has NOT
# yet been proven: the placed-and-routed NET CONNECTIVITY of the design itself.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
LVS=$PC/calibre/lvs
W=/tmp/lvsbox
rm -rf $W; mkdir -p $W
cd $W || exit 1

# ---- 1. box list: every real standard-cell master in the extracted layout netlist ----
python3 - "$LVS/svdb/sar_digi_paper_core.sp" > $W/boxlist.txt <<'PYEOF'
import sys, collections
path = sys.argv[1]
subs = collections.OrderedDict(); order = []; logical = []
for raw in open(path, errors='replace'):
    st = raw.strip()
    if st.startswith('+'):
        if logical: logical[-1] = logical[-1] + ' ' + st[1:].strip()
        continue
    logical.append(st)
cur = None
for st in logical:
    up = st.upper()
    if up.startswith('.SUBCKT'):
        t = st.split(); cur = t[1]; subs[cur] = {'mos': 0, 'x': 0}; order.append(cur); continue
    if up.startswith('.ENDS'):
        cur = None; continue
    if cur is None or not st: continue
    c = st[0].upper()
    if c == 'M': subs[cur]['mos'] += 1
    elif c == 'X': subs[cur]['x'] += 1
names = [k for k in order if not k.startswith('ICV_') and k != 'sar_digi_paper_core' and subs[k]['mos'] > 0]
for n in names: print(n)
PYEOF
BOX=$(wc -l < $W/boxlist.txt)
echo "BOX_CELLS=$BOX"

# ---- 2. deck: same as mylvs.lvs, only the report name and the BOX statement differ ----
sed -e "s|^LVS REPORT \".*\"|LVS REPORT \"$W/lvsB.rep\"|" $LVS/mylvs.lvs > $W/mylvsB.lvs
if ! grep -qF "LVS REPORT \"$W/lvsB.rep\"" $W/mylvsB.lvs; then echo "FATAL: report path not patched"; exit 1; fi
printf 'LVS BOX CELL LIST "%s/boxlist.txt"\n' "$W" >> $W/mylvsB.lvs
grep -n "^LVS BOX CELL LIST" $W/mylvsB.lvs
# the deck must still point at the real inputs
grep -nE '^(LAYOUT PATH|LAYOUT PRIMARY|SOURCE PATH|SOURCE PRIMARY|PRECISION)' $W/mylvsB.lvs
diff <(grep -v "^//" $LVS/mylvs.lvs) <(grep -v "^//" $W/mylvsB.lvs) | head -20

# ---- 3. run ----
echo "=== RUN START $(date) ==="
T0=$(date +%s)
calibre -lvs -hier -turbo 6 mylvsB.lvs > $W/lvsB.log 2>&1
echo "LVS_RC=$?  elapsed $(( $(date +%s) - T0 )) s"
echo "=== verdict ==="
grep -aiE 'CORRECT|INCORRECT|Nothing in layout|Nothing in source|Unmatched|Discrepan|must be fixed|Error:' $W/lvsB.log | tail -25
echo "=== report head ==="
sed -n '25,60p' $W/lvsB.rep 2>/dev/null
echo "=== LVSBOX_DONE ==="
