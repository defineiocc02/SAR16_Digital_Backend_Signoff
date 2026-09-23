#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
F=$PC/scripts/fc_pnr_paper_core.tcl
echo "=== does the P&R flow do any HOLD optimisation? ==="
grep -nE 'hold|fix_eco|optimize_netlist|route_opt|place_opt|clock_opt|set_app_options.*hold' $F | head -40
echo
echo "=== the stages the flow actually runs, in order ==="
grep -nE '^stage |^run ' $F | head -40
echo
echo "=== sign-off SDC: the I/O min-delay placeholder ==="
S=$PC/constraints/sar_digi_paper_core.sdc
grep -nE 'IO_MIN|IO_MAX|set_input_delay|set_output_delay|CLK_PERIOD' $S | head -20
echo
echo "=== clock latency report (slow) ==="
head -40 $PC/pnr/reports/sta/sta_pc_slow_pc_clock_latency.rpt 2>/dev/null
