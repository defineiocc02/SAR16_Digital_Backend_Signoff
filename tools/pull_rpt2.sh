#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
S=/tmp/rpt_v51
echo "=== \$PC/reports ==="
ls -la $PC/reports/ | head -25
echo
echo "=== \$PC/pnr/reports (recursive, files only) ==="
find $PC/pnr/reports -type f | head -40
echo
echo "=== collect_result.sh: where does it write? ==="
grep -nE 'RPT=|report_pack|reports/|OUT|DEST' $PC/scripts/collect_result.sh | head -20
echo
mkdir -p $S/sta $S/dc $S/pnr
cp -p $PC/reports/*.rpt      $S/dc/   2>/dev/null
cp -p $PC/reports/*.txt      $S/dc/   2>/dev/null
cp -pr $PC/pnr/reports/sta/. $S/sta/  2>/dev/null
cp -p $PC/pnr/reports/*.rpt  $S/pnr/  2>/dev/null
cp -p $PC/pnr/reports/*.log  $S/pnr/  2>/dev/null
echo "=== staged ==="
find $S -type f | wc -l
du -sh $S
