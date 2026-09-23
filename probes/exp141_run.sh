#!/bin/bash
# Controlled experiment, fully isolated: does PORT LAYER TEXT 141 matter?
#
# Everything happens in /tmp/exp141.  The kit deck and the project's mylvs.lvs are
# only READ.  The variant deck is written to /tmp, with LVS REPORT redirected, so
# no project evidence can be overwritten.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/calibre/lvs
W=/tmp/exp141
rm -rf $W; mkdir -p $W; cd $W || exit 1

echo "=== baseline (from the project's own v5.1 run) ==="
sed -n '/INITIAL NUMBERS OF OBJECTS/,/Total Inst/p' $L/lvs.rep | head -12
echo "   shorts: $( [ -f $L/lvs.rep.shorts ] && grep -ac '^SHORT' $L/lvs.rep.shorts || echo 0 )"

# --- variant deck: layer-141 port text declaration removed ---
sed -e "s|^LVS REPORT .*|LVS REPORT \"$W/exp141.rep\"|" \
    -e 's|^PORT LAYER TEXT 141|// PORT LAYER TEXT 141  (removed for experiment)|' \
    $L/mylvs.lvs > $W/exp141.lvs
echo
echo "=== variant deck checks ==="
echo "   LVS REPORT  -> $(grep -m1 '^LVS REPORT' $W/exp141.lvs)"
echo "   PORT 141 lines remaining: $(grep -c '^PORT LAYER TEXT 141' $W/exp141.lvs)  (want 0)"
echo "   commented lines        : $(grep -c 'PORT LAYER TEXT 141  (removed' $W/exp141.lvs)  (want 4)"
echo "   LAYOUT PATH  -> $(grep -m1 '^LAYOUT PATH' $W/exp141.lvs)"
echo "   SOURCE PATH  -> $(grep -m1 '^SOURCE PATH' $W/exp141.lvs)"
echo "   PRECISION    -> $(grep -m1 '^PRECISION' $W/exp141.lvs)"

echo
echo "=== running the variant ==="
T0=$(date +%s)
calibre -lvs -hier -turbo 6 $W/exp141.lvs > $W/exp141.log 2>&1
echo "rc=$?  elapsed $(( $(date +%s) - T0 ))s"

echo
echo "=== variant result ==="
sed -n '/INITIAL NUMBERS OF OBJECTS/,/Total Inst/p' $W/exp141.rep 2>/dev/null | head -12
echo "   verdict : $(grep -aoE '^\s+(CORRECT|INCORRECT)\s+' $W/exp141.rep 2>/dev/null | head -1 | tr -d ' ')"
echo "   nets(incorrect) : $(grep -acE '^ +[0-9]+ +Net ' $W/exp141.rep 2>/dev/null)"
echo "   shorts  : $( [ -f $W/exp141.rep.shorts ] && grep -ac '^SHORT' $W/exp141.rep.shorts || echo 0 )"
echo
echo "=== after transformation ==="
awk '/AFTER TRANSFORMATION/{f=1} f&&/Total Inst/{print; exit} f' $W/exp141.rep 2>/dev/null | head -8
echo
echo "=== project evidence untouched? ==="
ls -la $L/lvs.rep $L/lvs.rep.shorts 2>/dev/null | awk '{print "   "$6" "$7" "$8"  "$9}'
echo
echo "EXP141_DONE"
