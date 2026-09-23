#!/bin/bash
# Round 11c (fixed): the first attempt grabbed the 157-byte `*.spef_scenario`
# descriptor instead of the real 7 MB SPEF.  Target the file by size.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
SPEF=$(find $PC -name '*.spef' -size +1M 2>/dev/null | head -1)
echo "SPEF = $SPEF"
stat -c '  size = %s B' "$SPEF" 2>/dev/null
if [ -z "$SPEF" ]; then echo "FATAL: no SPEF > 1 MB found"; exit 1; fi

echo ""
echo "=== decisive test: HFSINV / HFSNET in the parasitics ==="
printf '  HFSINV lines : %s\n' "$(grep -c HFSINV "$SPEF")"
printf '  HFSNET lines : %s\n' "$(grep -c HFSNET "$SPEF")"
printf '  distinct HFSINV instance names : %s\n' "$(grep -o 'HFSINV_[0-9]*_[0-9]*' "$SPEF" | sort -u | wc -l)"

echo ""
echo "=== distinct instance names from *I lines ==="
grep -a '^\*I ' "$SPEF" | sed 's/^\*I  *//' | awk -F: '{print $1}' | sort -u > /tmp/spef_insts.txt
printf '  distinct instances : %s\n' "$(wc -l < /tmp/spef_insts.txt)"
printf '  total *I lines     : %s\n' "$(grep -ac '^\*I ' "$SPEF")"
printf '  top-level (no slash): %s\n' "$(grep -vc '/' /tmp/spef_insts.txt)"
head -6 /tmp/spef_insts.txt | sed 's/^/    /'

echo ""
echo "=== the 20 netlist-only cell instance names in the SPEF ==="
for n in ADDHXL AND3X2 AOI211X2 AOI211X4 AOI221XL CLKINVXL DFFSX4 INVX8 MX2XL MXI2X1 \
         NAND4BX1 NOR2BX2 NOR3BX1 NOR3X1 NOR4BX1 NOR4X1 OAI211X1 OR3X2 OR3XL OR4XL; do
    printf '  %-10s %s\n' "$n" "$(grep -c "$n" /tmp/spef_insts.txt)"
done
echo "=== DONE ==="
