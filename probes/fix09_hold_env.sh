#!/bin/bash
# FIX 09: write the hold verdict + caliber into the machine-readable summary.
# collect_result.sh currently emits only setup slack; RESULT_CURRENT.env has no
# sign-off hold keys at all.  This appends a hold section (backup kept, test run first).
set -u
PC=/home/<user>/sar16_work/proj_paper_core
S=$PC/scripts/collect_result.sh
B=$S.bak_holdfix

echo "############ A. where does collect_result.sh write its keys? ############"
wc -l "$S"
grep -n -E 'sta_|slack|>>|>>* *"\$|RESULT|#' "$S" | grep -n -E 'sta_|slack' | head -12
echo "--- last 12 lines of the script ---"
tail -12 "$S"

if [ ! -f "$B" ]; then cp -p "$S" "$B"; echo "backup created: $B"; else echo "backup already exists: $B"; fi

if grep -q 'HLD_CALIBER' "$S"; then
    echo "hold section already present -- not appending again"
else
cat >> "$S" <<'EOF'

# ---------------------------------------------------------------------------
# 修复 09：hold 结论与口径（原脚本只写 setup，机读汇总里没有任何签核 hold 键）
# 口径 = PT 自己汇总的 viol_hold（typical/slow/fast），见 docs/_过程记录/修复08
# ---------------------------------------------------------------------------
_HLD_SUM="$RPT/sta/sta_pc_summary.txt"
if [ -s "$_HLD_SUM" ]; then
    for _c in typical slow fast; do
        _line=$(grep -m1 "^STA_RESULT corner=$_c " "$_HLD_SUM" || true)
        _v=$(echo "$_line" | sed -n 's/.*viol_hold=\([0-9]*\).*/\1/p')
        _w=$(echo "$_line" | sed -n 's/.*wns_hold=\(-\?[0-9.]*\).*/\1/p')
        [ -n "$_v" ] && echo "sta_${_c}_hold_viols=$_v"
        [ -n "$_w" ] && echo "sta_${_c}_hold_wns=$_w"
    done
    echo "hold_caliber=PT_viol_hold_from_sta_pc_summary"
    echo "hold_caliber_note=three pc corners summed; per-corner dedup union is 25-28; the value 39 quoted earlier is not reproducible"
    _tot=0
    for _c in typical slow fast; do
        _line=$(grep -m1 "^STA_RESULT corner=$_c " "$_HLD_SUM" || true)
        _v=$(echo "$_line" | sed -n 's/.*viol_hold=\([0-9]*\).*/\1/p')
        [ -n "$_v" ] && _tot=$((_tot + _v))
    done
    echo "sta_hold_viols_total=$_tot"
fi
EOF
    echo "hold section appended"
fi

echo ""
echo "############ B. test run -> /tmp (does the real RESULT_CURRENT.env get hold keys?) ############"
cd $PC || exit 1
bash "$S" /tmp/RESULT_TEST.env > /tmp/collect_test.log 2>&1
echo "collect rc=$?"
echo "--- hold keys in the TEST output ---"
grep -E 'hold' /tmp/RESULT_TEST.env 2>/dev/null || echo "  (no hold keys produced)"
echo "--- for comparison: hold keys in the DELIVERED env ---"
grep -E 'hold' $PC/reports/RESULT_CURRENT.env 2>/dev/null || echo "  (none -- this is the gap)"
echo "=== FIX09_DONE ==="
