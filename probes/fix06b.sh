#!/bin/bash
# FIX 06b: the previous comparison only matched 2 rows (my regex required ONE space
# before the colon).  Redo it with whitespace normalised on both sides.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
RTL=$PC/rtl/srm_residue_lut.sv

norm () { tr -s ' ' | sed 's/ *: */ : /; s/tbl_q8 = *-/tbl_q8 = -/; s/tbl_q8 = */tbl_q8 = /'; }

echo "=== RTL baked table (ground truth) ==="
grep -oE "5'd[0-9]+ *: *tbl_q8 *= *-?16'sd[0-9]+" $RTL | norm | sort -t"'" -k2 -n > /tmp/t_rtl.txt
wc -l < /tmp/t_rtl.txt; cat /tmp/t_rtl.txt

echo ""
echo "=== generator output ==="
( cd $PC/gen && python3 gen_srm_lut.py --n 22 --sigma-q8 128 --frac-out 8 ) \
  | grep -oE "5'd[0-9]+ *: *tbl_q8 *= *-?16'sd[0-9]+" | norm > /tmp/t_gen.txt
wc -l < /tmp/t_gen.txt

echo ""
echo "=== diff (empty = the generator reproduces the delivered table) ==="
if diff /tmp/t_rtl.txt /tmp/t_gen.txt; then
    echo "  RESULT: IDENTICAL -- $(wc -l < /tmp/t_rtl.txt) entries, generator reproduces the RTL table exactly"
else
    echo "  RESULT: DIFFERS (see above)"
fi
echo "=== FIX06B_DONE ==="
