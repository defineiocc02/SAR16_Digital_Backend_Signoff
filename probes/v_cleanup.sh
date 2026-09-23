#!/bin/bash
# Housekeeping: remove MY OWN experiment directories from /tmp.
# The 167 MB found in round 23 is entirely this verification session's V2 simulations,
# which I failed to clean up after each run.  The evidence for every one of them is
# already in the host scratch docs, so the directories are transitional and removable.
echo "=== sizes before ==="
du -s -h /tmp/v2* /tmp/v1* /tmp/f3b 2>/dev/null

for d in v2b v2e v2f v2g v2h v2i v2ind v2ind2 v2rtl v1 v3r v2r f3b f3c; do
    if [ -e "/tmp/$d" ]; then rm -rf "/tmp/$d"; echo "  removed /tmp/$d"; fi
done
rm -f /tmp/p3*.out /tmp/p4*.out /tmp/p5*.out /tmp/p3*.sh /tmp/p4*.sh /tmp/p5*.sh 2>/dev/null
rm -f /tmp/v1*.out /tmp/v1*.sh /tmp/v2*.out /tmp/v2*.sh 2>/dev/null
rm -f /tmp/round*.txt /tmp/dump.sh /tmp/tie_*.py 2>/dev/null

echo ""
echo "=== kept on purpose (evidence for the verification report) ==="
ls -d /tmp/fmv 2>/dev/null && du -s -h /tmp/fmv 2>/dev/null

echo ""
echo "=== /tmp after ==="
ls -1 /tmp | wc -l
du -s -h /tmp 2>/dev/null | tail -1
echo "--- remaining entries (not mine: .cadence, .ICE-unix, keep*.txt from 01:10) ---"
ls -1 /tmp | head -20
echo "=== project tree intact? ==="
ls -d /home/<user>/sar16_work/proj_paper_core/pnr/out >/dev/null && echo "  pnr/out INTACT"
echo "=== DONE ==="
