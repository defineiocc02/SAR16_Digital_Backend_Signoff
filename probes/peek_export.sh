#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
F=$PC/scripts/fc_pnr_paper_core.tcl
echo "=== export section (lines 600-680) ==="
awk 'NR>=600 && NR<=680 {printf "%5d  %s\n", NR, $0}' $F
echo
echo "=== every write_* call in the script ==="
grep -n 'write_' $F
echo
echo "=== the interface census block ==="
awk 'NR>=625 && NR<=660 {printf "%5d  %s\n", NR, $0}' $F
