#!/bin/bash
# FIX 09b: the first attempt appended the hold block AFTER the script's
# `{ ... } > "$OUT"` group, so the keys went to stdout instead of into the env file.
# Restore from the backup and insert INSIDE the group, just before the closing brace.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
S=$PC/scripts/collect_result.sh
B=$S.bak_holdfix

[ -f "$B" ] || { echo "no backup -- aborting"; exit 1; }
cp -p "$B" "$S"
echo "restored from backup"

cat > /tmp/hold_block.sh <<'EOF'
# ---- 修复 09：hold 结论与口径（原脚本只写 setup，机读汇总没有任何签核 hold 键）----
_HLD="$RPT/sta/sta_pc_summary.txt"
if [ -s "$_HLD" ]; then
    _tot=0
    for _c in typical slow fast; do
        _l=$(grep -m1 "^STA_RESULT corner=$_c " "$_HLD" || true)
        _v=$(echo "$_l" | sed -n 's/.*viol_hold=\([0-9]*\).*/\1/p')
        _w=$(echo "$_l" | sed -n 's/.*wns_hold=\(-\{0,1\}[0-9.]*\).*/\1/p')
        [ -n "$_v" ] && echo "sta_${_c}_hold_viols=$_v"
        [ -n "$_w" ] && echo "sta_${_c}_hold_wns=$_w"
        [ -n "$_v" ] && _tot=$((_tot + _v))
    done
    echo "sta_hold_viols_total=$_tot"
    echo "hold_caliber=PT_viol_hold_from_sta_pc_summary"
    echo "# caliber note: three pc corners summed (typical/slow/fast). Per-corner endpoint"
    echo "# dedup union is 25-28; the value 39 quoted in an earlier draft is NOT reproducible"
    echo "# from any delivered STA report (see docs/_process/修复08)."
fi
EOF

python3 - "$S" /tmp/hold_block.sh <<'PYEOF'
import io, sys
s, blk = sys.argv[1], sys.argv[2]
lines = io.open(s, encoding='utf-8', errors='replace').read().splitlines(True)
block = io.open(blk, encoding='utf-8').read()
# insert before the LAST line that closes the output group
idx = None
for i in range(len(lines) - 1, -1, -1):
    if lines[i].lstrip().startswith('} >'):
        idx = i
        break
assert idx is not None, 'closing "} > $OUT" not found'
lines.insert(idx, block)
io.open(s, 'w', encoding='utf-8', newline='').write(''.join(lines))
print('inserted before line %d: %s' % (idx + 1, lines[idx + 2].strip()[:40] if idx + 2 < len(lines) else ''))
PYEOF

echo "--- verify insertion point ---"
grep -n -B2 -A1 '修复 09' "$S" | head -8

echo ""
echo "############ test run ############"
cd $PC || exit 1
bash "$S" /tmp/RESULT_TEST2.env > /tmp/collect_test2.log 2>&1
echo "rc=$?"
echo "--- hold keys in the TEST output ---"
grep -E 'hold' /tmp/RESULT_TEST2.env 2>/dev/null || echo "  (still none)"
echo "=== FIX09B_DONE ==="
