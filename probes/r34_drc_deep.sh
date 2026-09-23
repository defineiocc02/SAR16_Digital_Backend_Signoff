#!/bin/bash
# Deep DRC evidence: rule text for the firing checks, the per-layer DENSITY reports
# (M1_7..M5_7 and MT_6 are density rules, 1 result each = a whole-chip density window),
# and the violation database so the violations can be located.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
D=$PC/calibre/drc
echo "=== density report logs (one line each) ==="
for f in $D/density_report_*.log; do echo "--- $(basename $f) ---"; cat "$f"; done
echo
echo "=== density .rdb headers (density windows) ==="
for f in $D/M1SLOT_SL_8_density.rdb $D/M2SLOT_SL_8_density.rdb $D/M5SLOT_SL_8_density.rdb $D/M6SLOT_SL_8_density.rdb; do
  echo "--- $(basename $f) ---"; head -18 "$f"; echo
done
echo
echo "=== rule bodies for the remaining firing checks ==="
for R in BD_1 NW_2a M1_2 M1_1 M2_2 M2_1 V1_2 V1_1 GT_12; do
  echo "################ $R ################"
  grep -n -B12 -A3 "^RULECHECK $R {" "$D/mydrc.drc" | head -30
  echo
done
echo "=== density rule text M1_7 / MT_6 ==="
for R in M1_7 M2_7 M5_7; do
  echo "################ $R ################"
  grep -n -B8 -A4 "^RULECHECK $R {" "$D/mydrc.drc" | head -20
  echo
done
echo "=== copy the violation DB out for local parsing ==="
cp -p $D/drc_CAL.OUT /tmp/drc_CAL.OUT
ls -la /tmp/drc_CAL.OUT
md5sum /tmp/drc_CAL.OUT
echo "=== END ==="
