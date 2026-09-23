#!/bin/bash
# What did the existing Formality run actually prove?  Read its own setup and its
# unmatched-point report -- "1207 passing / 0 failing" is only meaningful together with
# what was read in and what stayed unmatched.
PC=/home/<user>/sar16_work/proj_paper_core/fm
echo "############ fm.tcl : what is compared ############"
grep -n -E 'read_|set_top|set_reference|set_implementation|verify|svf|guidance|analyze' $PC/fm.tcl | head -30
echo ""
echo "############ unmatched.rpt : summary ############"
head -40 $PC/fm/unmatched.rpt
echo ""
echo "############ fm.log : the verdict region ############"
grep -n -B3 -A12 'Verification SUCCEEDED' $PC/fm/fm.log | head -40
echo ""
echo "############ fm.log : the '20 failing' line context ############"
grep -n -B6 -A3 '30 passing / 20 failing' $PC/fm/fm.log | head -30
echo "=== FMRECON_DONE ==="
