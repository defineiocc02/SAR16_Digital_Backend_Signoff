#!/bin/bash
# Round 9 housekeeping part 2: the earlier rounds' transitional experiment scratch in
# /tmp.  Every one of these has its evidence already captured in the host scratch
# (probes/exp141*, evidence/hold_exp/, the write_lef variant table in the report),
# so the VM copies are transitional and removable.
echo "=== removing transitional experiment scratch (evidence already archived on host) ==="
for p in exp141 holdexp hold_exp_evidence v1.lef v2.lef v3.lef v4.lef v5.lef v6.lef \
         f3_before.lef f3_after.lef tmp.gSyF0gH3eJ ka.sh ka.out masters.txt \
         tmp_cleanup_manifest.txt v_after_out.log; do
    if [ -e "/tmp/$p" ]; then rm -rf "/tmp/$p"; echo "  removed /tmp/$p"; fi
done
echo "=== /tmp now ==="
ls -1 /tmp | wc -l; du -sh /tmp 2>/dev/null; ls -1 /tmp
echo "=== project tree: nothing newer than 21:15 ? ==="
find /home/<user>/sar16_work/proj_paper_core -newermt "2026-09-18 21:15" -type f 2>/dev/null | head
echo "=== other protected work untouched ==="
ls -d /home/<user>/adc_rtl_synth 2>/dev/null && echo "  (RTL project present, untouched)"
echo "=== DONE ==="
