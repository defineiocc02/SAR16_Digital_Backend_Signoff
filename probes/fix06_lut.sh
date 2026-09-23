#!/bin/bash
# FIX 06: restore the missing LUT generator into the project's gen/ directory and PROVE
# it reproduces the table that is baked into rtl/srm_residue_lut.sv.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
RTL=$PC/rtl/srm_residue_lut.sv

echo "=== BEFORE: does the generator exist? ==="
ls -la $PC/gen/gen_srm_lut.py 2>/dev/null || echo "  MISSING (this is the defect)"

echo ""
echo "=== extract the delivered table from the RTL (the ground truth) ==="
grep -E "5'd[0-9]+ : tbl_q8" $RTL | sed 's/^ *//' > /tmp/table_rtl.txt
wc -l < /tmp/table_rtl.txt

echo ""
echo "=== restore the file ==="
mkdir -p $PC/gen
cp /tmp/gen_srm_lut.py $PC/gen/gen_srm_lut.py
chmod +x $PC/gen/gen_srm_lut.py
ls -la $PC/gen/gen_srm_lut.py

echo ""
echo "=== run it and compare with the RTL table ==="
( cd $PC/gen && python3 gen_srm_lut.py --n 22 --sigma-q8 128 --frac-out 8 ) \
    | grep -E "5'd[0-9]+ : tbl_q8" | sed 's/^ *//' > /tmp/table_gen.txt
wc -l < /tmp/table_gen.txt
echo "--- diff (empty = identical) ---"
diff /tmp/table_rtl.txt /tmp/table_gen.txt && echo "  IDENTICAL: the generator reproduces the delivered table exactly"

echo ""
echo "=== reconstruct the FULL table check: count entries ==="
echo "  RTL entries : $(wc -l < /tmp/table_rtl.txt)"
echo "  GEN entries : $(wc -l < /tmp/table_gen.txt)"
echo "=== FIX06_DONE ==="
