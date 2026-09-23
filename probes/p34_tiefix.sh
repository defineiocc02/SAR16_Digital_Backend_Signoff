#!/bin/bash
# Round 10: the P&R Verilog leaves every HFSNET_* net UNDRIVEN -- including the rst_n
# pin of the two largest sub-blocks (RTL clearly connects .rst_n(rst_n)).  v2lvs then
# emits them as free nets; the layout has them on VDD.  This experiment ties them to
# 1'b1 (which v2lvs maps to VDD via -s1 VDD) on a COPY of the netlist and re-runs LVS.
#
# It is a discriminating test, not a "make it green" knob:
#   * if LVS becomes CORRECT  -> the layout really does hold those pins on VDD
#   * if LVS now fails on rst_n -> the layout has rst_n correctly connected and only
#                                  the written netlist is wrong
set -u
PC=/home/<user>/sar16_work/proj_paper_core
LVS=$PC/calibre/lvs
SRC=$PC/pnr/out/sar_digi_paper_core_pnr.v
W=/tmp/lvs10
cd $W || exit 1

echo "=== 0. inputs ==="
ls -la $SRC $LVS/smic18_san.cdl | sed 's/^/  /'

echo ""
echo "=== 1. patch a COPY of the netlist ==="
cp $SRC $W/net_fix.v
BEFORE=$(grep -c 'HFSNET' $W/net_fix.v)
echo "  HFSNET occurrences before : $BEFORE"
python3 - "$W/net_fix.v" <<'PYEOF'
import io, re, sys
p = sys.argv[1]
t = io.open(p, encoding='utf-8', errors='replace').read()

# (a) every instantiation connection  .PORT ( HFSNET_n )  ->  .PORT ( 1'b1 )
t, n_conn = re.subn(r'(\.\w+\s*\(\s*)HFSNET_\d+(\s*\))', r"\g<1>1'b1\g<2>", t)

# (b) drop the port declarations
lines = t.splitlines()
kept = []
n_decl = 0
for ln in lines:
    if re.match(r'\s*(input|output|inout)\s+HFSNET_\d+\s*;\s*$', ln):
        n_decl += 1
        continue
    kept.append(ln)
t = '\n'.join(kept)

# (c) drop the names from the module port lists and repair the commas
out = []
n_list = 0
for ln in t.splitlines():
    if 'HFSNET' in ln:
        n_list += ln.count('HFSNET')
        ln = re.sub(r'\s*HFSNET_\d+\s*', ' ', ln)
        ln = re.sub(r'\(\s*,', '(', ln)
        ln = re.sub(r',\s*,', ',', ln)
        ln = re.sub(r',\s*\)', ' )', ln)
        ln = re.sub(r'[ \t]{2,}', ' ', ln)
    out.append(ln)
t = '\n'.join(out)
io.open(p, 'w', encoding='utf-8', newline='\n').write(t + '\n')
print('  connections rewritten : %d' % n_conn)
print('  declarations removed  : %d' % n_decl)
print('  port-list names removed: %d' % n_list)
PYEOF
AFTER=$(grep -c 'HFSNET' $W/net_fix.v)
TIE=$(grep -c "1'b1" $W/net_fix.v)
echo "  HFSNET occurrences after  : $AFTER   (must be 0)"
echo "  1'b1 occurrences after    : $TIE"
if [ "$AFTER" != "0" ]; then echo "FATAL: HFSNET survived the patch"; grep -n 'HFSNET' $W/net_fix.v | head -5; exit 1; fi
echo "  module headers after patch:"
grep -n -A3 '^module srm_residue_estimator\|^module sar_calib_ctrl_serial' $W/net_fix.v | head -12 | sed 's/^/    /'

echo ""
echo "=== 2. re-run v2lvs on the patched netlist ==="
cp $LVS/smic18_san.cdl $W/smic18_san.cdl
v2lvs -v $W/net_fix.v -o $W/sar16_fix.cdl -s $W/smic18_san.cdl -s0 VSS -s1 VDD \
      -log $W/v2lvs_fix.log > $W/v2lvs_fix.out 2>&1
echo "  v2lvs rc=$?"
echo "  .SUBCKT count : $(grep -c '^\.SUBCKT' $W/sar16_fix.cdl)"
echo "  top present   : $(grep -c '^\.SUBCKT sar_digi_paper_core' $W/sar16_fix.cdl)"
echo "  HFSNET in new CDL : $(grep -c 'HFSNET' $W/sar16_fix.cdl)   (must be 0)"

echo ""
echo "=== 3. LVS with cells boxed + INJECT LOGIC NO, patched SOURCE ==="
NAMES=$(tr '\n' ' ' < $W/boxlist.txt)
awk -v box="LVS BOX $NAMES" '{ print } /^LAYOUT PRIMARY/ && !d { print box; d=1 }' \
    $LVS/mylvs.lvs > $W/lvsK.lvs
printf 'LVS INJECT LOGIC NO\n' >> $W/lvsK.lvs
sed -i -e "s|^LVS REPORT \".*\"|LVS REPORT \"$W/lvsK.rep\"|" \
       -e "s|^SOURCE PATH \".*\"|SOURCE PATH \"$W/sar16_fix.cdl\"|" $W/lvsK.lvs
echo "  SOURCE PATH = $(grep -m1 '^SOURCE PATH' $W/lvsK.lvs)"
echo "  BOX stmts   = $(grep -c '^LVS BOX ' $W/lvsK.lvs)"
T0=$(date +%s)
calibre -lvs -hier -turbo 6 lvsK.lvs > $W/lvsK.log 2>&1
echo "  RC=$? elapsed=$(( $(date +%s) - T0 ))s"
grep -a -m1 'LVS completed' $W/lvsK.log
echo "  --- errors ---"
grep -a -E '^  (Error|Warning):' $W/lvsK.rep | sed 's/^ *//' | sort -u | sed 's/^/    /'
N=$(grep -n 'NUMBERS OF OBJECTS AFTER TRANSFORMATION' $W/lvsK.rep | head -1 | cut -d: -f1)
sed -n "$((N+3)),$((N+11))p" $W/lvsK.rep | sed 's/^/    /'
A=$(grep -n 'INCORRECT NETS' $W/lvsK.rep | head -1 | cut -d: -f1)
if [ -n "$A" ]; then
  echo "  --- incorrect nets (first 60 lines) ---"
  sed -n "${A},$((A+60))p" $W/lvsK.rep | sed 's/^/    /'
fi
echo "=== LVSK_DONE ==="
