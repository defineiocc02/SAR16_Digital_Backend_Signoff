#!/bin/bash
# Round 9b: why did LVS BOX CELL LIST not take effect?  Diagnose then retry with the
# statement placed in the deck HEADER (before the layer/device sections).
set -u
LVS=/home/<user>/sar16_work/proj_paper_core/calibre/lvs
W=/tmp/lvsbox

echo "=== 1. deck: any existing BOX statements? ==="
grep -n -i "LVS BOX" $LVS/mylvs.lvs | head
echo "=== deck context around the appended line ==="
sed -n '3200,3212p' $W/mylvsB.lvs
echo "=== deck: comment/IF structure at EOF ==="
tail -6 $W/mylvsB.lvs
echo "=== count of #IF / #IFDEF / #ENDIF in deck ==="
for k in '#IF' '#IFDEF' '#IFNDEF' '#ELSE' '#ENDIF' '#DEFINE'; do printf '  %-9s %s\n' "$k" "$(grep -c -- "$k" $LVS/mylvs.lvs)"; done
echo "=== 2. log: BOX / warning lines ==="
grep -n -i -E "box|warn" $W/lvsB.log | head -20
echo "=== 3. log: first 30 lines ==="
head -30 $W/lvsB.log

echo ""
echo "=== 4. retry: BOX statement in the deck header ==="
awk -v box="LVS BOX CELL LIST \"$W/boxlist.txt\"" '
  { print }
  /^LAYOUT PRIMARY/ && !done { print box; done=1 }
' $LVS/mylvs.lvs > $W/mylvsC.lvs
if ! grep -qF 'LVS BOX CELL LIST' $W/mylvsC.lvs; then echo "FATAL: header insert failed"; exit 1; fi
grep -n -E "^(LAYOUT PRIMARY|LVS BOX CELL LIST|PRECISION|SOURCE PRIMARY)" $W/mylvsC.lvs
sed -i "s|^LVS REPORT \".*\"|LVS REPORT \"$W/lvsC.rep\"|" $W/mylvsC.lvs
grep -n "^LVS REPORT" $W/mylvsC.lvs

echo "=== RUN C $(date) ==="
cd $W || exit 1
T0=$(date +%s)
calibre -lvs -hier -turbo 6 mylvsC.lvs > $W/lvsC.log 2>&1
echo "LVS_RC=$?  elapsed $(( $(date +%s) - T0 )) s"
grep -a -i -E "CORRECT|Nothing in|Error|BOX" $W/lvsC.log | tail -20
echo "=== report C object tables ==="
N=$(grep -n "INITIAL NUMBERS OF OBJECTS" $W/lvsC.rep | head -1 | cut -d: -f1)
if [ -n "$N" ]; then sed -n "${N},$((N+70))p" $W/lvsC.rep; else echo "no table"; fi
echo "=== LVSBOXC_DONE ==="
