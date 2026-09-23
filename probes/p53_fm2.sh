#!/bin/bash
# Corrected paths (the previous run doubled /fm).
F=/home/<user>/sar16_work/proj_paper_core/fm
echo "############ unmatched.rpt (first 35 lines) ############"
head -35 $F/unmatched.rpt
echo ""
echo "############ unmatched.rpt : tail ############"
tail -12 $F/unmatched.rpt
echo ""
echo "############ fm.log : verdict region ############"
grep -n -B2 -A14 'Verification SUCCEEDED' $F/fm.log | head -34
echo ""
echo "############ fm.log : the '20 failing' line, with context ############"
grep -n -B8 -A2 'passing / ' $F/fm.log | head -30
echo "=== FMRECON2_DONE ==="
