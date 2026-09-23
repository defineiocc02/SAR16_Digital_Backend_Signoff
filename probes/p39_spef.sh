#!/bin/bash
# Round 11c: the SPEF as a third, independent caliber.
#   * distinct instance names  -> how many cells were really placed
#   * does `HFSINV` appear     -> were the 85 tie inverters kept in the layout or
#                                 constant-propagated away?
set -u
PC=/home/<user>/sar16_work/proj_paper_core
SPEF=$(find $PC -name '*.spef*' 2>/dev/null | head -1)
echo "SPEF = $SPEF"
ls -la "$SPEF" 2>/dev/null | sed 's/^/  /'
echo ""
echo "=== HFSINV / HFSNET in the SPEF (the decisive test) ==="
printf '  HFSINV occurrences : %s\n' "$(grep -c HFSINV "$SPEF" 2>/dev/null)"
printf '  HFSNET occurrences : %s\n' "$(grep -c HFSNET "$SPEF" 2>/dev/null)"
grep -o 'HFSINV_[0-9]*_[0-9]*' "$SPEF" 2>/dev/null | sort -u | head -5 | sed 's/^/    e.g. /'
printf '  distinct HFSINV instance names : %s\n' "$(grep -o 'HFSINV_[0-9]*_[0-9]*' "$SPEF" 2>/dev/null | sort -u | wc -l)"
echo ""
echo "=== distinct instance names from *I lines ==="
grep -a '^\*I ' "$SPEF" 2>/dev/null | sed 's/^\*I  *//' | awk -F: '{print $1}' | sort -u > /tmp/spef_insts.txt
printf '  distinct instances : %s\n' "$(wc -l < /tmp/spef_insts.txt)"
printf '  total *I lines     : %s\n' "$(grep -ac '^\*I ' "$SPEF" 2>/dev/null)"
echo "  sample:"
head -5 /tmp/spef_insts.txt | sed 's/^/    /'
echo ""
echo "=== top-level instance names (no slash) ==="
grep -v '/' /tmp/spef_insts.txt | wc -l | sed 's/^/  count: /'
echo ""
echo "=== do the 20 netlist-only cell INSTANCE names exist in the SPEF? ==="
for n in ADDHXL AND3X2 AOI211X2 AOI211X4 AOI221XL CLKINVXL DFFSX4 INVX8 MX2XL MXI2X1 \
         NAND4BX1 NOR2BX2 NOR3BX1 NOR3X1 NOR4BX1 NOR4X1 OAI211X1 OR3X2 OR3XL OR4XL; do
    printf '  %-10s %s\n' "$n" "$(grep -c "$n" /tmp/spef_insts.txt)"
done
echo ""
echo "=== other report files that might carry a cell count ==="
grep -l -a -i 'instances' $PC/reports/*.rpt $PC/reports/*.txt 2>/dev/null | head -5
echo "=== DONE ==="
