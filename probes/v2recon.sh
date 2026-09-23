#!/bin/bash
# V2/V3 recon: reproduce what the existing gate-level run did.
#   * which netlist did it compile (synthesised or post-route)?
#   * where are the standard-cell Verilog models?
#   * what was the exact vcs command line, so an independent run can be built.
PC=/home/<user>/sar16_work/proj_paper_core
echo "############ A. vcs command line used by the existing GLS ############"
grep -a -m3 -n -E '^vcs |vcs -|/vcs ' $PC/pwr_gls/build.log $PC/pwr_gls/run.log 2>/dev/null | head -6
echo "--- the full first vcs invocation (wrapped) ---"
grep -a -n -m1 'vcs ' $PC/pwr_gls/build.log | cut -c1-600
echo ""
echo "############ B. which netlist files were passed ############"
grep -a -oE '[A-Za-z0-9_./-]+\.(v|sv|vg)\b' $PC/pwr_gls/build.log | sort -u | head -25
echo ""
echo "############ C. standard-cell simulation models in the kit ############"
find /home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital -maxdepth 4 \( -name '*.v' -o -name '*.sv' \) 2>/dev/null | head -15
echo "--- (count) ---"
find /home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital -maxdepth 5 -name '*.v' 2>/dev/null | wc -l
echo ""
echo "############ D. project-level sim dirs / file lists ############"
find $PC -maxdepth 2 \( -name '*.f' -o -name '*filelist*' -o -name 'run_*.sh' \) 2>/dev/null | head -20
echo ""
echo "############ E. what is simv_pc at the project root? ############"
ls -la $PC/simv_pc $PC/simv_pc.daidir 2>/dev/null | head -8
grep -a -m1 -oE '[A-Za-z0-9_./-]+_pnr\.v|[A-Za-z0-9_./-]+_netlist\.v' $PC/simv_pc.daidir/* 2>/dev/null | head -5
echo "=== V2RECON_DONE ==="
