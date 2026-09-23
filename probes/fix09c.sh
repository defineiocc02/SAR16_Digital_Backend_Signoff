#!/bin/bash
# FIX 09c: the hold block used $RPT, but this script reads STA from $P/pnr/reports.
# Use the same literal path the script itself uses, then re-test.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
S=$PC/scripts/collect_result.sh

echo "--- what is RPT set to here, and where does the script read STA from? ---"
grep -n -E '^RPT=|^P=|sta_pc_summary' "$S" | head -8

sed -i 's|_HLD="\$RPT/sta/sta_pc_summary.txt"|_HLD="$P/pnr/reports/sta/sta_pc_summary.txt"|' "$S"
grep -n '_HLD=' "$S"

echo ""
echo "--- does that file exist? ---"
ls -la "$PC/pnr/reports/sta/sta_pc_summary.txt" 2>/dev/null || echo "  NOT at that path"
find $PC -name 'sta_pc_summary.txt' 2>/dev/null | head -3

echo ""
echo "############ test run ############"
cd $PC || exit 1
bash "$S" /tmp/RESULT_TEST3.env > /tmp/collect_test3.log 2>&1
echo "rc=$?"
echo "--- hold keys in the TEST output ---"
grep -E 'hold' /tmp/RESULT_TEST3.env 2>/dev/null || echo "  (still none)"

echo ""
echo "############ if it works, update the real summary (backup first) ############"
if grep -q 'sta_hold_viols_total' /tmp/RESULT_TEST3.env 2>/dev/null; then
    cp -p $PC/reports/RESULT_CURRENT.env $PC/reports/RESULT_CURRENT.env.bak_pre_hold
    cp -f /tmp/RESULT_TEST3.env $PC/reports/RESULT_CURRENT.env
    echo "  RESULT_CURRENT.env updated (backup: RESULT_CURRENT.env.bak_pre_hold)"
    grep -E 'hold' $PC/reports/RESULT_CURRENT.env
else
    echo "  test did not produce hold keys -- real summary left untouched"
fi
echo "=== FIX09C_DONE ==="
