#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
F=$PC/scripts/fc_pnr_paper_core.tcl
echo "=== library / block names used by the flow ==="
grep -nE 'set PNR|set OUT|open_lib|open_block|save_block|create_lib' $F | head -12
echo
echo "=== what libraries exist ==="
ls -la $PC/pnr/ 2>/dev/null | head
find $PC/pnr -maxdepth 1 -name '*.nlib' -o -maxdepth 1 -type d | head
echo
echo "=== is the saved block still there? ==="
find $PC/pnr -maxdepth 3 -name '*.nlib' -o -maxdepth 3 -name 'sar16_pnr_paper_core*' | head
