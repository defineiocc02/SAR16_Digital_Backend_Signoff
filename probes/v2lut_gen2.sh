#!/bin/bash
# Wider, quote-safe search for the LUT generator before claiming it is missing.
echo "=== A. whole home for the generator by name ==="
find /home/<user> -maxdepth 7 -name 'gen_srm_lut.py' 2>/dev/null | head
echo "=== B. anything with srm_lut in the name under sar16_work ==="
find /home/<user>/sar16_work -maxdepth 7 -name '*srm_lut*' 2>/dev/null | head
echo "=== C. any gen/ directory in the project ==="
find /home/<user>/sar16_work/proj_paper_core -maxdepth 4 -type d -name 'gen' 2>/dev/null
echo "=== D. any python file mentioning the table, anywhere in the project ==="
grep -rl --include='*.py' -e 'erfinv' -e 'srm_lut' -e 'SIGMA_Q8' \
     /home/<user>/sar16_work/proj_paper_core 2>/dev/null | head
echo "=== E. whole home, any .py mentioning erfinv ==="
grep -rl --include='*.py' 'erfinv' /home/<user> 2>/dev/null | head
echo "=== F. project top level ==="
ls -1 /home/<user>/sar16_work/proj_paper_core | head -30
echo "=== G. does the RTL reference gen/ explicitly? ==="
grep -n 'gen/' /home/<user>/sar16_work/proj_paper_core/rtl/srm_residue_lut.sv \
              /home/<user>/sar16_work/proj_paper_core/rtl/srm_residue_estimator.sv 2>/dev/null | head
echo "=== DONE ==="
