#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
WD=$PC/kitcheck
K=/home/<user>/Project/DESIGN/14BIT_ADC/smic18
echo "=== NOR2XL.log (first 40 lines) ==="
head -40 $WD/NOR2XL.log 2>/dev/null
echo
echo "=== files produced ==="
ls -la $WD/ | head -15
echo
echo "=== does the kit GDS actually contain NOR2XL? ==="
grep -ac 'NOR2XL' $K/digital/sc/gds2/smic18.gds2 2>/dev/null || echo "  (binary grep)"
strings $K/digital/sc/gds2/smic18.gds2 2>/dev/null | grep -x 'NOR2XL\|INVXL\|DFFSX1' | head
echo
echo "=== cell names present in the kit GDS (STRNAME strings) ==="
strings $K/digital/sc/gds2/smic18.gds2 2>/dev/null | grep -E '^[A-Z][A-Z0-9]+X[0-9L]+$' | head -20
echo
echo "=== and the deck's own header ==="
head -30 $WD/NOR2XL.lvs
