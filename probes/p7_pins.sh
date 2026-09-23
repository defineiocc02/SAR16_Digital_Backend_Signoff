#!/bin/bash
# Read-only probe 7: how are pins placed, and was anyone already probing a fix?
PC=/home/<user>/sar16_work/proj_paper_core

echo "########## A. pin-placement section of fc_pnr_paper_core.tcl ##########"
grep -n 'pin\|PIN' $PC/scripts/fc_pnr_paper_core.tcl | head -40

echo
echo "########## B. the script's own place_pins block (line context) ##########"
awk 'NR>=830 && NR<=880 {printf "%5d  %s\n", NR, $0}' $PC/scripts/fc_pnr_paper_core.tcl

echo
echo "########## C. probe_fix_pins_pg.tcl (someone was probing this already) ##########"
cat $PC/scripts/probe_fix_pins_pg.tcl

echo
echo "########## D. what the tool itself says about place_pins ##########"
man place_pins 2>/dev/null | head -60
