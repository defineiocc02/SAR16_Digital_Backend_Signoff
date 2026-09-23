#!/bin/bash
# Round 13: F3 (block abstract) via the flow's OWN stage wrapper.
# The bare `fc_shell -f x.tcl < /dev/null` produced a 0-byte log last round, so this
# time the F3 Tcl is run through a copy of run_pnr_paper_core.sh (same environment,
# same input-lock preflight) with only the Tcl filename swapped.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/f3b
rm -rf $W; mkdir -p $W
echo "=== how the flow invokes fc_shell ==="
grep -n -E 'fc_shell|tcl|TCL' $PC/scripts/run_pnr_paper_core.sh | head -20
echo ""
echo "=== full run_pnr_paper_core.sh (it is expected to be short) ==="
wc -l $PC/scripts/run_pnr_paper_core.sh
cat $PC/scripts/run_pnr_paper_core.sh
echo "=== END OF SCRIPT DUMP ==="
