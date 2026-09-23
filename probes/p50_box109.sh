#!/bin/bash
# Round 20: box ALL 109 LEF macro names instead of only the 89 masters that appear in
# the extracted layout netlist.  If the source side holds cell types the layout does
# not, `LVS BOX ... not located` will name them -- that is the diagnostic.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
LVS=$PC/calibre/lvs
W=/tmp/lvs20
rm -rf $W; mkdir -p $W; cd $W || exit 1

python3 - "$PC/pnr/out/sar_digi_paper_core.lef" > $W/box109.txt <<'PYEOF'
import re, sys
for ln in open(sys.argv[1], errors='replace'):
    m = re.match(r'^MACRO\s+(\S+)\s*$', ln.rstrip())
    if m:
        print(m.group(1))
PYEOF
echo "BOX_NAMES=$(wc -l < $W/box109.txt)"
NAMES=$(tr '\n' ' ' < $W/box109.txt)

awk -v box="LVS BOX $NAMES" '{ print } /^LAYOUT PRIMARY/ && !d { print box; d=1 }' \
    $LVS/mylvs.lvs > $W/lvsN.lvs
printf 'LVS INJECT LOGIC NO\n' >> $W/lvsN.lvs
sed -i -e "s|^LVS REPORT \".*\"|LVS REPORT \"$W/lvsN.rep\"|" $W/lvsN.lvs
T0=$(date +%s)
calibre -lvs -hier -turbo 6 lvsN.lvs > $W/lvsN.log 2>&1
echo "RC=$? elapsed=$(( $(date +%s) - T0 ))s"
grep -a -m1 'LVS completed' $W/lvsN.log
echo ""
echo "=== BOX warnings: which names were NOT located ==="
grep -a 'LVS BOX cell' $W/lvsN.log | sed 's/.*LVS BOX cell //' | sort -u | head -20
echo "  (count: $(grep -a -c 'not located or not allowed' $W/lvsN.log))"
echo ""
echo "=== device table (initial) ==="
N=$(grep -n 'INITIAL NUMBERS OF OBJECTS' $W/lvsN.rep | head -1 | cut -d: -f1)
sed -n "$((N+3)),$((N+11))p" $W/lvsN.rep | sed 's/^/  /'
echo ""
echo "=== device table (after transformation) ==="
M=$(grep -n 'NUMBERS OF OBJECTS AFTER TRANSFORMATION' $W/lvsN.rep | head -1 | cut -d: -f1)
sed -n "$((M+3)),$((M+11))p" $W/lvsN.rep | sed 's/^/  /'
echo "=== LVS20_DONE ==="
