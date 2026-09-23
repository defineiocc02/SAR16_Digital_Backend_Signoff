#!/bin/bash
# V3: what did the existing post-route gate-level sim actually report, and is there any
# X-propagation evidence from the undriven tie nets?
PC=/home/<user>/sar16_work/proj_paper_core
echo "############ A. pwr_gls/run.log ############"
cat $PC/pwr_gls/run.log
echo ""
echo "############ B. pwr_gls/run.out ############"
cat $PC/pwr_gls/run.out
echo ""
echo "############ C. X / warning evidence in the build ############"
grep -a -c -iE '\bX\b|x-propagation|Warning-.*x' $PC/pwr_gls/build.log 2>/dev/null | sed 's/^/  build.log x-ish lines: /'
grep -a -iE "Warning.*(undriven|floating|no driver)" $PC/pwr_gls/build.log 2>/dev/null | sort -u | head -8
echo ""
echo "############ D. the RTL testbench runner ############"
sed -n '1,45p' $PC/scripts/run_tb_paper_core.sh
echo ""
echo "############ E. does the delivered netlist even reference the tie nets? ############"
grep -a -c 'HFSNET' $PC/pnr/out/sar_digi_paper_core_pnr.v | sed 's/^/  HFSNET lines: /'
echo "=== V3RECON_DONE ==="
