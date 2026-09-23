#!/bin/bash
# Independent-verification recon: what verification already exists, and what fixes the
# floorplan utilization (the "why is the routing so sparse" question).
PC=/home/<user>/sar16_work/proj_paper_core
echo "############ A. floorplan utilisation setting ############"
grep -n -iE 'util|core_util|row_util|aspect|die_size|core_size|floorplan|initialize_floorplan|create_floorplan' \
     $PC/scripts/fc_pnr_paper_core.tcl | head -20
echo ""
echo "############ B. formality / LEC ############"
ls -la $PC/fm 2>/dev/null | head -15
find $PC/fm -maxdepth 2 -type f 2>/dev/null | head -20
echo "--- any verdict lines in fm logs ---"
grep -a -iE 'succeeded|failed|equivalent|nonequivalent|passing|failing' $PC/fm/*.log $PC/fm/*.txt $PC/fm/*.rpt 2>/dev/null | tail -15
echo ""
echo "############ C. gate-level simulation ############"
ls -la $PC/pwr_gls 2>/dev/null | head -20
echo "--- which netlist did the GLS compile? ---"
grep -a -oE '[A-Za-z0-9_/.-]+\.v' $PC/pwr_gls/*.f $PC/pwr_gls/*.sh $PC/pwr_gls/Makefile 2>/dev/null | sort -u | head -20
echo "--- GLS result lines ---"
grep -a -riE 'PASS|FAIL|MISMATCH|ERROR' $PC/pwr_gls/*.log 2>/dev/null | tail -12
echo ""
echo "############ D. testbenches ############"
ls -la $PC/tb 2>/dev/null
echo ""
echo "############ E. simulation binaries present ############"
ls -d $PC/simv* 2>/dev/null
echo "--- vcs/verdi availability ---"
for T in vcs xrun irun verdi iverilog; do printf '  %-9s %s\n' "$T" "$(command -v $T || echo ABSENT)"; done
echo "=== RECON_DONE ==="
