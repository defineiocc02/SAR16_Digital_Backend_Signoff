#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
echo "=== how is SDC_EXTRA supplied? ==="
grep -nE 'SDC_EXTRA' $PC/scripts/run_sta_paper_core.sh
echo "--- tcl side ---"
sed -n '38,45p' $PC/scripts/sta_pt_paper_core.tcl
sed -n '105,118p' $PC/scripts/sta_pt_paper_core.tcl
echo
echo "=== the three boundary assumptions actually in play ==="
echo "-- 1. DIG_IN_PORTS min delay (drives the slow/25 violations)"
grep -nE 'DIG_IN_PORTS|set_input_delay -clock \$CLK_NAME -min' $PC/constraints/sar_digi_paper_core.sdc | head
echo "-- 2. calib_comp_out min delay (drives the typical/1 violation)"
grep -nE 'calib_comp_out' $PC/constraints/sar_digi_paper_core.sdc | head
echo "-- 3. DIG_OUT_PORTS min delay = -IO_MIN_DELAY (drives the fast/4 flop-to-output)"
grep -nE 'set_output_delay -clock \$CLK_NAME -min' $PC/constraints/sar_digi_paper_core.sdc
echo
echo "=== the worst-path arithmetic, straight from the report ==="
awk '/Startpoint: raw_bits_i\[15\]/,/slack \(VIOLATED\)/' \
    $PC/pnr/reports/sta/sta_pc_slow_pc_hold.rpt | grep -aE 'input external delay|U18|data arrival time|clock network|clock uncertainty|library hold|data required|slack'
