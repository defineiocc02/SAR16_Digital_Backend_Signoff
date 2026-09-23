#!/bin/bash
# Pull everything the report generator needs, from the v5.1 run.
PC=/home/<user>/sar16_work/proj_paper_core
S=/tmp/rpt_v51
rm -rf $S; mkdir -p $S
# reported inputs produced by collect_result.sh
cp -rp $PC/report_pack            $S/ 2>/dev/null
cp -p  $PC/reports/RESULT_CURRENT.env $S/ 2>/dev/null
cp -p  $PC/reports/RESULT_BASELINE.env $S/ 2>/dev/null
# calibre
cp -p  $PC/calibre/lvs/lvs.rep       $S/ 2>/dev/null
cp -p  $PC/calibre/lvs/lvs.rep.ext   $S/ 2>/dev/null
cp -p  $PC/calibre/lvs/erc.rep       $S/ 2>/dev/null
cp -p  $PC/calibre/lvs/mylvs.lvs     $S/ 2>/dev/null
cp -p  $PC/calibre/drc/drc_CAL.SUM   $S/ 2>/dev/null
# pnr / layout
cp -p  $PC/pnr/out/sar_digi_paper_core.gds          $S/ 2>/dev/null
cp -p  $PC/pnr/out/sar_digi_paper_core.lef          $S/ 2>/dev/null
cp -p  $PC/pnr/out/sar_digi_paper_core_pnr.v        $S/ 2>/dev/null
cp -p  $PC/pnr/out/sar_digi_paper_core_pnr.sdc      $S/ 2>/dev/null
cp -p  $PC/calibre/sar_digi_paper_core_merged.gds   $S/ 2>/dev/null
cp -p  $PC/calibre/lvs/svdb/sar_digi_paper_core.sp  $S/ 2>/dev/null
cp -p  $PC/calibre/lvs/sar16.cdl                    $S/ 2>/dev/null
# logs the report quotes
cp -p  $PC/logs/repro_v51.log        $S/ 2>/dev/null
cp -p  $PC/logs/dc.log               $S/ 2>/dev/null
cp -p  $PC/logs/fc_pnr.log           $S/ 2>/dev/null
echo "=== pulled ==="
ls -la $S/ | head -30
echo
echo "=== report_pack tree ==="
find $S/report_pack -type f | sed "s#$S/##" | sort
echo
echo "=== sizes ==="
du -sh $S; du -sh $S/report_pack
