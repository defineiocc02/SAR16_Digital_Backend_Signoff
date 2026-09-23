#!/bin/bash
# Round 11b: third independent caliber for the placement count -- the DEF.
# The GDS SREF census said 3626 placements over 109 masters; my census of the
# EXTRACTED layout netlist said 3606 over 89.  The DEF is written by the P&R tool
# itself and is independent of both.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
echo "=== DEF files available ==="
find $PC -name '*.def*' -o -name '*.DEF*' 2>/dev/null | head -10
echo ""
echo "=== sizes ==="
find $PC -name '*.def*' 2>/dev/null | while read f; do printf '  %10s  %s\n' "$(stat -c%s "$f")" "$f"; done | head -10
