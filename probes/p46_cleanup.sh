#!/bin/bash
# Round 12c: the F3 wrapper run produced a 0-byte log -- fc_shell never got as far as
# printing anything.  Inspect what is running, stop ONLY the fc_shell this experiment
# started (never the RTL dc_shell PIDs), and clean up.
echo "=== fc_shell / dc_shell processes ==="
ps -eo pid,ppid,etime,cmd | grep -E 'fc_shell|dc_shell' | grep -v grep
echo ""
echo "=== p44.out tail (did the wrapper script finish?) ==="
tail -5 /tmp/p44.out 2>/dev/null
echo ""
echo "=== how does reproduce_all.sh invoke fc_shell? ==="
grep -n -E 'fc_shell|source|\.sh|setup|env' /home/<user>/sar16_work/proj_paper_core/scripts/reproduce_all.sh 2>/dev/null | head -20
echo ""
echo "=== stop the experiment's fc_shell (match on our /tmp/f3wrap/f3.tcl) ==="
for p in $(ps -eo pid,cmd | grep 'fc_shell -f /tmp/f3wrap/f3.tcl' | grep -v grep | awk '{print $1}'); do
    echo "  killing fc_shell pid=$p (started by this experiment)"
    kill $p 2>/dev/null
done
sleep 2
echo "=== remaining ==="
ps -eo pid,etime,cmd | grep -E 'fc_shell|dc_shell' | grep -v grep
echo "(the RTL dc_shell PIDs 669096/669097 must NOT appear as killed above)"
echo ""
echo "=== cleanup ==="
rm -rf /tmp/f3wrap
rm -f /tmp/p44.out
ls -1 /tmp | wc -l; du -sh /tmp 2>/dev/null
echo ""
echo "=== project tree untouched? ==="
find /home/<user>/sar16_work/proj_paper_core -newermt "2026-09-18 22:15" -type f 2>/dev/null | head
echo "(empty = round 12 did not write into the project tree)"
echo "=== DONE ==="
