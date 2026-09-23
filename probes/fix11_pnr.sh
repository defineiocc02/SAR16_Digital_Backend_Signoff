#!/bin/bash
# FIX 11: guarded P&R re-run on a COPY, with a hard gate that refuses to proceed if the
# copy still points at the original project (the stage script starts with rm -rf $PRJ/pnr).
set -u
SRC=/home/<user>/sar16_work/proj_paper_core
# The tcl carries its own pre-flight assert: NET must point "into proj_paper_core".
# Naming the copy with that substring keeps the assert meaningful instead of disabling it.
DST=/home/<user>/sar16_work/proj_paper_core_fixtie
LOG=/tmp/fix11.log
exec > "$LOG" 2>&1
echo "=== FIX11 start $(date) ==="

echo "--- step 1: copy the project ($(du -sh $SRC 2>/dev/null | cut -f1)) ---"
rm -rf "$DST"
cp -a "$SRC" "$DST" || { echo "STOP: copy failed"; exit 1; }
echo "copy done: $(du -sh $DST | cut -f1)"

echo "--- step 2: repoint the copy's hardcoded paths ---"
sed -i "s|$SRC|$DST|g" "$DST/scripts/fc_pnr_paper_core.tcl"
sed -i "s|$SRC|$DST|g" "$DST/scripts/run_pnr_paper_core.sh"

echo "--- step 3: HARD GATE ---"
FAIL=0
# boundary-aware: the copy's name CONTAINS "$SRC", so a bare substring test is useless.
# What must not appear is the ORIGINAL path as a whole component: "$SRC" followed by a
# character that is not [A-Za-z0-9_], or end of line.
BOUND="$SRC([^A-Za-z0-9_]|$)"
if grep -qE "$BOUND" "$DST/scripts/fc_pnr_paper_core.tcl"; then echo "GATE FAIL: tcl still points at SRC"; FAIL=1; fi
if grep -qE "$BOUND" "$DST/scripts/run_pnr_paper_core.sh"; then echo "GATE FAIL: sh still points at SRC"; FAIL=1; fi
[ -d "$DST/pnr" ] || { echo "GATE FAIL: no pnr in the copy"; FAIL=1; }
[ -f "$DST/rtl/sar_digi_paper_core.sv" ] || { echo "GATE FAIL: no rtl in the copy"; FAIL=1; }
if [ "$FAIL" != "0" ]; then echo "STOP: gate failed, NOTHING was run"; exit 1; fi
echo "GATE OK: the original project will not be touched"
grep -n '^set PRJ\|^PRJ=' "$DST/scripts/fc_pnr_paper_core.tcl" "$DST/scripts/run_pnr_paper_core.sh" | head -4

echo "--- step 4: apply the tie-cell patch (inside catch, so a wrong syntax cannot abort) ---"
python3 - "$DST/scripts/fc_pnr_paper_core.tcl" <<'PYEOF'
import io, sys
p = sys.argv[1]
t = io.open(p, encoding='utf-8', errors='replace').read()
if 'FIX_TIECELL' in t:
    print('patch already present'); raise SystemExit(0)
anchor = 'ok "link_block"'
i = t.find(anchor)
if i < 0:
    print('ANCHOR NOT FOUND (link_block) -- patch not applied'); raise SystemExit(0)
ins = '''
# ---- FIX_TIECELL: bind the library's tie cells so FC stops building constants out of
# inverters (log said: Warning: No tie cell is available for constant fixing. OPT-200).
# Wrapped in catch: a wrong option name must NOT abort the run.
if {[catch {
    connect_tie_cells -tie_high_lib_cell sar16_smic18_6lm_v4/TIEHI \\
                      -tie_low_lib_cell  sar16_smic18_6lm_v4/TIELO
} m]} { puts "FIX_NOTE connect_tie_cells: $m" } else { puts "FIX_OK tie cells bound" }
if {[catch {set_app_options -name compile.flow.tie_unused_hier_inputs_to_constants -value false} m2]} {
    puts "FIX_NOTE tie_unused_hier_inputs: $m2"
} else { puts "FIX_OK tie_unused_hier_inputs disabled" }
'''
t = t[:i + len(anchor)] + ins + t[i + len(anchor):]
io.open(p, 'w', encoding='utf-8', newline='').write(t)
print('patch inserted after link_block')
PYEOF
grep -c 'FIX_TIECELL' "$DST/scripts/fc_pnr_paper_core.tcl"

echo "--- step 5: run P&R on the copy $(date) ---"
cd "$DST" || exit 1
timeout 7200 bash scripts/run_pnr_paper_core.sh
echo "PNR_RC=$?"

echo "--- step 6: criterion 1 -- HFSNET in the new netlist (target 0, was 1841) ---"
NEW=$DST/pnr/out/sar_digi_paper_core_pnr.v
if [ -s "$NEW" ]; then
    echo "  HFSNET lines : $(grep -c HFSNET "$NEW")"
    echo "  rst_n conns  : $(grep -c '\.rst_n' "$NEW")"
    grep -n '\.rst_n' "$NEW" | head -4
else
    echo "  NO NETLIST PRODUCED"
fi
echo "--- original project intact? ---"
ls -d $SRC/pnr/out >/dev/null && echo "  ORIGINAL pnr/out INTACT"
grep -c HFSNET $SRC/pnr/out/sar_digi_paper_core_pnr.v | sed 's/^/  original HFSNET lines: /'
echo "=== FIX11_DONE $(date) ==="
