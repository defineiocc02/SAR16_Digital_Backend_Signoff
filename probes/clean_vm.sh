#!/bin/bash
# Remove only the scratch I (the handover side) created on the VM.
# Backups of the project's own files are KEPT: they are the rollback path.
PC=/home/<user>/sar16_work/proj_paper_core

echo "=== before ==="
df -h /home | tail -1

echo
echo "=== my scratch in /tmp ==="
du -sh /tmp/rpt_v51 /tmp/handover /tmp/handover51 2>/dev/null
ls -la /tmp/*.sh /tmp/*.tcl /tmp/*.py /tmp/*.txt 2>/dev/null | head -20

rm -rf /tmp/rpt_v51 /tmp/handover /tmp/handover51
rm -f  /tmp/pr.sh /tmp/pr2.sh /tmp/rlo.sh /tmp/p19.sh /tmp/p20.sh /tmp/pg.py \
       /tmp/wait_v51.sh /tmp/pinprobe.tcl /tmp/pinprobe2.tcl /tmp/pinprobe3.tcl \
       /tmp/pinh2.tcl /tmp/pinhelp.tcl /tmp/lp.tcl /tmp/top_src.txt /tmp/top_src.cdl \
       /tmp/vdd_entry.txt /tmp/portblock.txt 2>/dev/null

echo
echo "=== my probe logs inside the project ==="
ls -la $PC/fc_pinprobe*.log $PC/fc_pinh2.log $PC/fc_pinhelp.log 2>/dev/null
rm -f $PC/fc_pinprobe.log $PC/fc_pinprobe2.log $PC/fc_pinprobe3.log \
      $PC/fc_pinh2.log $PC/fc_pinhelp.log

echo
echo "=== KEPT (rollback path) ==="
for d in rtl/.bak_v50 constraints/.bak_v50 tb/.bak_v50 scripts/.bak_pinfix scripts/.bak_globals; do
    [ -d "$PC/$d" ] && printf "   %-32s %s\n" "$d" "$(ls -1 $PC/$d | wc -l) file(s)"
done

echo
echo "=== after ==="
df -h /home | tail -1
echo
echo "=== residual scratch check (want none) ==="
ls -d /tmp/rpt_v51 /tmp/handover /tmp/handover51 2>/dev/null || echo "   none"
ls $PC/fc_pin*.log 2>/dev/null || echo "   no probe logs left in the project"
echo
echo "=== project size ==="
du -sh $PC
