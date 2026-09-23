#!/bin/bash
# Round 9 housekeeping: copy the small evidence out, remove the big transient LVS
# products, and PROVE the project tree was not touched by this round's experiments.
PC=/home/<user>/sar16_work/proj_paper_core
echo "=== project calibre/lvs before cleanup (file count + newest 5) ==="
find $PC/calibre/lvs -maxdepth 1 -type f | wc -l
ls -lat $PC/calibre/lvs | head -6
echo "=== did any experiment write into the project tree today after 21:15? ==="
find $PC/calibre -newermt "2026-09-18 21:15" -type f 2>/dev/null | head -20
echo "(empty = the project tree was not touched by round 9)"
echo "=== /tmp usage ==="
du -sh /tmp/lvsbox 2>/dev/null
echo "=== compact evidence extracted ==="
W=/tmp/lvsbox
{
  echo "### round-9 LVS knob matrix (raw lines from p28/p29)"
  grep -a -E 'variant|LVS completed|inject in report|Ports:|Nets:|Instances:|Total Inst|incorrect-net blocks|RC=' /tmp/p28.out /tmp/p29.out 2>/dev/null
  echo
  echo "### proof that LVS BOX CELL LIST silently no-ops (lvsC.log)"
  grep -a -n -i "LVS BOX" $W/lvsC.log | head -8
  echo
  echo "### best-config (variant F, boxed + INJECT NO) verdict block"
  sed -n '25,45p' $W/lvsF.rep
  echo
  echo "### variant F report size / variant D report size"
  ls -la $W/lvsD.rep $W/lvsF.rep $W/lvsJ.rep 2>/dev/null
} > /tmp/round9_evidence.txt
wc -l /tmp/round9_evidence.txt
echo "=== removing transient LVS products from /tmp ==="
rm -rf $W
ls -d $W 2>/dev/null || echo "  /tmp/lvsbox removed"
du -sh /tmp 2>/dev/null
echo "=== DONE ==="
