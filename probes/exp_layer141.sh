#!/bin/bash
# Controlled experiment: does the frame view's layer-141 text declaration matter?
#
# The merged GDS places 3626 cells that contain only frame geometry (layers 127
# and 141) plus one SREF to the real layout.  Layer 141 is M1TXT, and the LVS deck
# says  PORT LAYER TEXT 141  -- i.e. that layer is treated as PORT TEXT.  If the
# frame's 141 shapes are being read as port labels, they would create spurious
# names/ports inside every placed cell.
#
# Test: comment out PORT LAYER TEXT 141 and re-run the LVS stage.  Compare.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/calibre/lvs

echo "=== the declaration, with its context ==="
grep -n 'PORT LAYER TEXT 141' $L/mylvs.lvs
for n in $(grep -n 'PORT LAYER TEXT 141' $L/mylvs.lvs | cut -d: -f1); do
    echo "--- around line $n ---"
    sed -n "$((n-6)),$((n+2))p" $L/mylvs.lvs
done
echo
echo "=== baseline numbers (before the experiment) ==="
sed -n '/INITIAL NUMBERS OF OBJECTS/,/Total Inst/p' $L/lvs.rep | head -12
echo "short groups: $( [ -f $L/lvs.rep.shorts ] && grep -ac '^SHORT' $L/lvs.rep.shorts || echo 0 )"
echo
echo "=== how the deck patch is produced (so I patch the RIGHT place) ==="
grep -n 'PORT LAYER\|TEXT LAYER' $PC/scripts/run_lvs_paper_core.sh | head
echo "(the deck is sed-patched by run_lvs_paper_core.sh; mylvs.lvs is regenerated each run,"
echo " so the experiment patches the SOURCE deck copy used by that sed, not mylvs.lvs)"
