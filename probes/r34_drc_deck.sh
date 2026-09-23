#!/bin/bash
# Probe the Calibre DRC run: what the 16 firing checks actually mean, and whether the
# violation coordinates are available locally (the .SUM has counts only).
set -u
PC=/home/<user>/sar16_work/proj_paper_core
echo "=== calibre/drc directory ==="
ls -la $PC/calibre/drc/ 2>/dev/null | head -25
echo
echo "=== deck / rule files in the project ==="
find $PC/calibre -maxdepth 3 -type f \( -name '*.drc' -o -name '*.rul' -o -name '*.cal' \) 2>/dev/null | head -10
echo
DECK=$(find $PC/calibre -maxdepth 3 -type f -name '*.drc' 2>/dev/null | head -1)
echo "DECK=$DECK"
echo
for R in BD_1 BD_2a NW_2a M1_2 M1_1 M2_2 V1_2 V1_1 GT_12 M1_7 M2_1 M2_7 M3_7 M4_7 M5_7 MT_6; do
  echo "################ rule $R ################"
  grep -n -B10 -A4 "RULECHECK[[:space:]]\+$R\b" "$DECK" 2>/dev/null | head -26
  echo
done
echo "=== DRC results DB (for violation coordinates, if ASCII) ==="
ls -la $PC/calibre/drc/drc_CAL.OUT 2>/dev/null
head -c 400 $PC/calibre/drc/drc_CAL.OUT 2>/dev/null
echo
echo "=== END ==="
