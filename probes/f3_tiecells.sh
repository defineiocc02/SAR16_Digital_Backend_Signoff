#!/bin/bash
# F3 (fix step 1): does the standard-cell library actually contain tie cells?
# FC warned "No tie cell is available for constant fixing (OPT-200)", so check the
# library's own cell list rather than trusting the warning.
K=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc
echo "=== kit std-cell CDL files ==="
ls -la $K/lvs_netlist/ 2>/dev/null | head -6
CDL=$(find $K -name '*.cdl' 2>/dev/null | head -1)
echo "CDL = $CDL"
if [ -n "$CDL" ]; then
    echo "  total .SUBCKT : $(grep -ci '^[[:space:]]*\.subckt' "$CDL")"
    echo "=== cell names matching TIE / CONST / TIEH / TIEL ==="
    grep -i -oE '^[[:space:]]*\.subckt[[:space:]]+[A-Za-z0-9_]+' "$CDL" \
      | awk '{print $2}' | grep -iE 'tie|const|tieh|tiel' | sort -u | head -20
    echo "  (count: $(grep -i -oE '^[[:space:]]*\.subckt[[:space:]]+[A-Za-z0-9_]+' "$CDL" | awk '{print $2}' | grep -icE 'tie|const|tieh|tiel'))"
fi
echo ""
echo "=== the same check on the LEF, if one exists ==="
LEF=$(find $K -name '*.lef' 2>/dev/null | head -1)
echo "LEF = ${LEF:-none}"
[ -n "$LEF" ] && grep -i -oE '^MACRO[[:space:]]+[A-Za-z0-9_]+' "$LEF" | awk '{print $2}' | grep -iE 'tie|const' | sort -u | head -10
echo ""
echo "=== full list of library cell-name prefixes (to see the naming scheme) ==="
CDL=$(find $K -name '*.cdl' 2>/dev/null | head -1)
[ -n "$CDL" ] && grep -i -oE '^[[:space:]]*\.subckt[[:space:]]+[A-Za-z0-9_]+' "$CDL" | awk '{print toupper($2)}' \
  | sed -E 's/[0-9]+.*$//' | sort | uniq -c | sort -rn | head -25
echo "=== F3_DONE ==="
