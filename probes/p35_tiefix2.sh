#!/bin/bash
# Round 10b: retry the tie-net repair with a token-level port-list rewrite (the first
# attempt left ", ," and v2lvs exited 1 -- proven by the missing output file, not by
# the return code alone).
set -u
PC=/home/<user>/sar16_work/proj_paper_core
LVS=$PC/calibre/lvs
SRC=$PC/pnr/out/sar_digi_paper_core_pnr.v
W=/tmp/lvs10
cd $W || exit 1

cp $SRC $W/net_fix.v
echo "=== 1. patch ==="
python3 /tmp/tie_fix_verilog.py $W/net_fix.v
echo "  --- patched module headers ---"
sed -n '151,155p;982,990p' $W/net_fix.v | sed 's/^/    /'

echo ""
echo "=== 2. v2lvs ==="
v2lvs -v $W/net_fix.v -o $W/sar16_fix.cdl -s $W/smic18_san.cdl -s0 VSS -s1 VDD \
      -log $W/v2lvs_fix.log > $W/v2lvs_fix.out 2>&1
RC=$?
echo "  v2lvs rc=$RC"
echo "  --- v2lvs log tail ---"; tail -12 $W/v2lvs_fix.log | sed 's/^/    /'
if [ ! -s $W/sar16_fix.cdl ]; then
    echo "FATAL: no CDL produced"; echo "  --- v2lvs.out tail ---"; tail -20 $W/v2lvs_fix.out; exit 1
fi
echo "  .SUBCKT count     : $(grep -c '^\.SUBCKT' $W/sar16_fix.cdl)"
echo "  top present       : $(grep -c '^\.SUBCKT sar_digi_paper_core' $W/sar16_fix.cdl)"
echo "  HFSNET in new CDL : $(grep -c 'HFSNET' $W/sar16_fix.cdl)   (must be 0)"
echo "  VDD mentions      : $(grep -o 'VDD' $W/sar16_fix.cdl | wc -l)"

echo ""
echo "=== 3. LVS: boxed + INJECT LOGIC NO + patched SOURCE ==="
NAMES=$(tr '\n' ' ' < $W/boxlist.txt)
awk -v box="LVS BOX $NAMES" '{ print } /^LAYOUT PRIMARY/ && !d { print box; d=1 }' \
    $LVS/mylvs.lvs > $W/lvsK.lvs
printf 'LVS INJECT LOGIC NO\n' >> $W/lvsK.lvs
sed -i -e "s|^LVS REPORT \".*\"|LVS REPORT \"$W/lvsK.rep\"|" \
       -e "s|^SOURCE PATH \".*\"|SOURCE PATH \"$W/sar16_fix.cdl\"|" $W/lvsK.lvs
grep -m1 '^SOURCE PATH' $W/lvsK.lvs | sed 's/^/  /'
T0=$(date +%s)
calibre -lvs -hier -turbo 6 lvsK.lvs > $W/lvsK.log 2>&1
echo "  RC=$? elapsed=$(( $(date +%s) - T0 ))s"
grep -a -m1 'LVS completed' $W/lvsK.log | sed 's/^/  /'
echo "  --- errors ---"
grep -a -E '^  (Error|Warning):' $W/lvsK.rep | sed 's/^ *//' | sort -u | sed 's/^/    /'
N=$(grep -n 'NUMBERS OF OBJECTS AFTER TRANSFORMATION' $W/lvsK.rep | head -1 | cut -d: -f1)
sed -n "$((N+3)),$((N+11))p" $W/lvsK.rep | sed 's/^/    /'
A=$(grep -n 'INCORRECT NETS' $W/lvsK.rep | head -1 | cut -d: -f1)
if [ -n "$A" ]; then
  echo "  --- incorrect nets (first 50 lines) ---"
  sed -n "${A},$((A+50))p" $W/lvsK.rep | sed 's/^/    /'
fi
echo "=== LVSK_DONE ==="
