#!/bin/bash
echo "=== /tmp top 15 by size ==="
du -sh /tmp/* 2>/dev/null | sort -rh | head -15
echo "=== /tmp entry count ==="
ls -1 /tmp | wc -l
echo "=== remove round-9 probe scripts/outputs (they are versioned in the host scratch) ==="
rm -f /tmp/p2*.sh /tmp/p3*.sh /tmp/p2*.out /tmp/p3*.out /tmp/p2*.py /tmp/p3*.py /tmp/dump.sh \
      /tmp/round9_evidence.txt /tmp/lvs_pc.out /tmp/lvs_pc* /tmp/lp.tcl 2>/dev/null
echo "=== /tmp after ==="
ls -1 /tmp | wc -l
du -sh /tmp 2>/dev/null
echo "=== remaining entries ==="
ls -1 /tmp | head -30
echo "=== DONE ==="
