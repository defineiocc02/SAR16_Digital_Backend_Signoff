#!/bin/bash
# Remote dump helper: prints only the lines this round needs.  Kept as a FILE because
# a PowerShell single-quoted ssh argument loses inner double quotes and turns `|` into
# a shell pipe (that mistake cost two wasted calls this round).
echo "=== p29 matrix ==="
cat /tmp/p29.out 2>/dev/null | grep -a -E 'variant|LVS completed|Total Inst|incorrect-net|inject in report|Nets:|Ports:|Instances:|DONE'
echo ""
echo "=== /tmp/lvsbox listing ==="
ls -la /tmp/lvsbox 2>/dev/null | head -30
echo ""
echo "=== kitcheck: any INCORRECT among the 109 cell decks? ==="
grep -l -a 'INCORRECT' /home/<user>/sar16_work/proj_paper_core/kitcheck/*.rep 2>/dev/null | head
echo "kitcheck rep count: $(ls /home/<user>/sar16_work/proj_paper_core/kitcheck/*.rep 2>/dev/null | wc -l)"
