#!/bin/bash
# V2 round 13: how was the LUT actually generated?  The table deviates systematically
# from sigma*Phi^-1(cnt/N) with sigma = 0.5 LSB, so read the generator.
PC=/home/<user>/sar16_work/proj_paper_core
G=$(find $PC -name 'gen_srm_lut.py' 2>/dev/null | head -1)
echo "generator = ${G:-NOT FOUND}"
if [ -z "$G" ]; then
    echo "--- any lut generator anywhere? ---"
    find /home/<user>/sar16_work -name '*srm_lut*' -o -name '*gen_srm*' 2>/dev/null | head -10
    exit 0
fi
echo "size = $(stat -c%s "$G") B"
echo ""
echo "############ formula / sigma / rounding lines ############"
grep -n -E 'sigma|erfinv|norm|ppf|round|floor|ceil|clip|clamp|satur|N =|n =|OUT|frac|def ' "$G" | head -40
echo ""
echo "############ the core table computation (context) ############"
grep -n -B4 -A14 -E 'erfinv|norm\.ppf|round\(' "$G" | head -50
