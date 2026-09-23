#!/bin/bash
# F1: WHERE was the reset connection lost -- synthesis (DC) or place&route (FC)?
# Compare the RTL, the DC netlist and the post-route netlist for the rst_n connection
# of the two big sub-blocks.
PC=/home/<user>/sar16_work/proj_paper_core
echo "############ A. RTL (the intent) ############"
grep -n -A6 'u_calib_ctrl\|u_srm_residue' $PC/rtl/sar_digi_paper_core.sv 2>/dev/null | grep -n 'rst_n' | head -6

echo ""
echo "############ B. DC synthesised netlist ############"
DC=$PC/mapped_ss/sar_digi_paper_core_netlist.v
if [ -s "$DC" ]; then
    echo "  file: $DC ($(stat -c%s "$DC") B)"
    grep -n 'u_calib_ctrl\|u_srm_residue' "$DC" | head -4
    echo "  --- their .rst_n connections ---"
    grep -n '\.rst_n' "$DC" | head -8
    echo "  --- any HFSNET in the DC netlist? ---"
    printf '    HFSNET lines: %s\n' "$(grep -c HFSNET "$DC")"
    printf '    .start/start_calib lines: %s\n' "$(grep -c 'start' "$DC")"
else
    echo "  no DC netlist at $DC"
    ls -la $PC/mapped_ss/ 2>/dev/null | head -8
fi

echo ""
echo "############ C. post-route netlist ############"
PNR=$PC/pnr/out/sar_digi_paper_core_pnr.v
grep -n '\.rst_n' "$PNR" | head -6
printf '  HFSNET lines: %s\n' "$(grep -c HFSNET "$PNR")"

echo ""
echo "############ D. other candidate DC netlists ############"
find $PC/mapped $PC/mapped_ss -name '*.v' 2>/dev/null | while read f; do
    printf '  %10s  %-58s HFSNET=%s  rst_n=%s\n' "$(stat -c%s "$f")" "$(basename "$f")" \
        "$(grep -c HFSNET "$f")" "$(grep -c '\.rst_n' "$f")"
done
echo "=== F1_DONE ==="
