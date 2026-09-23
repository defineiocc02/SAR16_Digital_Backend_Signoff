#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
echo "=== STA script: how is the SDC referenced? ==="
grep -nE 'SDC|sdc|read_sdc|source' $PC/scripts/sta_pt_paper_core.tcl | head -14
echo
echo "=== run_sta wrapper ==="
grep -nE 'SDC|sdc|pt_shell|RPT|LOG' $PC/scripts/run_sta_paper_core.sh | head -16
echo
echo "=== the IO_MIN_FRAC block in the signoff SDC ==="
sed -n '46,64p' $PC/constraints/sar_digi_paper_core.sdc
echo
echo "=== and the output-delay side ==="
grep -nE 'set_output_delay' $PC/constraints/sar_digi_paper_core.sdc
echo
echo "=== what the P&R stage SDC says (the one written by write_sdc) ==="
grep -nE 'set_input_delay|set_output_delay' $PC/pnr/out/sar_digi_paper_core_pnr.sdc | head -8
