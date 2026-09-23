#!/bin/bash
# Round 9c: LVS BOX CELL LIST was tokenised as three CELL NAMES ("CELL","LIST",path).
# So this Calibre version wants  LVS BOX <name> <name> ...  .  Retry with the explicit
# 89-name form, placed in the deck header.  Success is proven by BOX_RECORD != 0 and
# by the Total Inst dropping -- not by the absence of an error.
set -u
LVS=/home/<user>/sar16_work/proj_paper_core/calibre/lvs
W=/tmp/lvsbox
cd $W || exit 1

echo "=== run C warnings about BOX ? ==="
grep -n -i "LVS BOX" $W/lvsC.log | head -8

NAMES=$(tr '\n' ' ' < $W/boxlist.txt)
echo "=== explicit LVS BOX statement: $(wc -w <<< "$NAMES") names ==="
awk -v box="LVS BOX $NAMES" '
  { print }
  /^LAYOUT PRIMARY/ && !done { print box; done=1 }
' $LVS/mylvs.lvs > $W/mylvsD.lvs
grep -c "^LVS BOX " $W/mylvsD.lvs
sed -i "s|^LVS REPORT \".*\"|LVS REPORT \"$W/lvsD.rep\"|" $W/mylvsD.lvs
grep -n "^LVS BOX " $W/mylvsD.lvs | cut -c1-160

echo "=== RUN D $(date) ==="
T0=$(date +%s)
calibre -lvs -hier -turbo 6 mylvsD.lvs > $W/lvsD.log 2>&1
echo "LVS_RC=$?  elapsed $(( $(date +%s) - T0 )) s"
echo "=== BOX accounting ==="
grep -a -i -E "LVS BOX|BOX_RECORD" $W/lvsD.log | head -12
echo "=== verdict ==="
grep -a -i -E "INCORRECT|CORRECT|Nothing in" $W/lvsD.log | tail -5
echo "=== report D object tables ==="
N=$(grep -n "INITIAL NUMBERS OF OBJECTS" $W/lvsD.rep 2>/dev/null | head -1 | cut -d: -f1)
if [ -n "$N" ]; then sed -n "${N},$((N+20))p" $W/lvsD.rep; else echo "no table / no report"; fi
echo "=== LVSBOXD_DONE ==="
