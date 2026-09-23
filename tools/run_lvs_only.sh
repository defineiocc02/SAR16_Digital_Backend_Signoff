#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
cd $PC || exit 1
rm -f $PC/logs/repro_lvs_globals.log
bash scripts/reproduce_all.sh 5 > $PC/logs/repro_lvs_globals.log 2>&1
echo "rc=$?"
echo
echo "=== the setting actually used in the patched deck ==="
grep -n 'LVS GLOBALS ARE PORTS' $PC/calibre/lvs/mylvs.lvs
echo
echo "=== port comparison now ==="
sed -n '/INITIAL NUMBERS OF OBJECTS/,/Total Inst/p' $PC/calibre/lvs/lvs.rep | head -14
echo
echo "=== error lines ==="
sed -n '/OVERALL COMPARISON RESULTS/,/CELL  SUMMARY/p' $PC/calibre/lvs/lvs.rep | grep -aE 'Error|Warning|CORRECT'
echo
echo "=== shorts? ==="
if [ -f $PC/calibre/lvs/lvs.rep.shorts ]; then
    echo "shorts file exists: $(grep -ac '^SHORT' $PC/calibre/lvs/lvs.rep.shorts) group(s)"
else
    echo "NO SHORTS FILE -> zero shorts"
fi
echo
echo "=== incorrect nets count ==="
grep -acE '^ +[0-9]+ +Net ' $PC/calibre/lvs/lvs.rep
