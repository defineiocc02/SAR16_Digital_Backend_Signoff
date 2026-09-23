#!/bin/bash
# Round 12: where do the extra numeric ports of the extracted cells come from?
#   * the deck's PORT / TEXT / LABEL statements
#   * the body of an affected cell (DFFSX1) in the extracted layout netlist
PC=/home/<user>/sar16_work/proj_core
PC=/home/<user>/sar16_work/proj_paper_core
LVS=$PC/calibre/lvs
echo "=== deck: PORT / LAYER TEXT / LABEL statements ==="
grep -n -E '^[[:space:]]*(PORT|TEXT|LAYER|ATTACH)' $LVS/mylvs.lvs | grep -i -E 'port|text|label' | head -30
echo ""
echo "=== deck: every PORT statement ==="
grep -n -E '^[[:space:]]*PORT ' $LVS/mylvs.lvs | head -20
echo ""
echo "=== extracted DFFSX1 subckt body (the cell with 9 ports vs 7 in the CDL) ==="
awk '/^\.SUBCKT DFFSX1 /{f=1} f{print} /^\.ENDS/{if(f){exit}}' $LVS/svdb/sar_digi_paper_core.sp | head -30
echo ""
echo "=== extracted DFFSXL subckt body ==="
awk '/^\.SUBCKT DFFSXL /{f=1} f{print} /^\.ENDS/{if(f){exit}}' $LVS/svdb/sar_digi_paper_core.sp | head -25
echo ""
echo "=== source CDL: DFFSX1 / DFFSXL port lists for comparison ==="
grep -A2 -E '^\.SUBCKT DFFSX1 |^\.SUBCKT DFFSXL ' $LVS/smic18_san.cdl | head -12
echo "=== DONE ==="
