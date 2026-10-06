#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
export PATH="$ROOT/bin:$PATH"
cd "$ROOT/smoke"
magic --version | tee "$ROOT/logs/magic-version.log"
netgen -batch > "$ROOT/logs/netgen-version.log" 2>&1 || true
klayout -b -v | tee "$ROOT/logs/klayout-version.log"
magic -dnull -noconsole -T scmos "$ROOT/smoke/magic_smoke.tcl" > "$ROOT/logs/magic-smoke.log" 2>&1
grep -F 'MAGIC_SMOKE_CLEAN_DRC=0' "$ROOT/logs/magic-smoke.log"
grep -F 'MAGIC_SMOKE_PASS' "$ROOT/logs/magic-smoke.log"
netgen -batch lvs 'a.spice smoke' 'b.spice smoke' setup.tcl netgen-pass.out > "$ROOT/logs/netgen-pass.log" 2>&1
grep -F 'Circuits match uniquely.' netgen-pass.out
netgen -batch lvs 'a.spice smoke' 'bad.spice smoke' setup.tcl netgen-fail.out > "$ROOT/logs/netgen-fail.log" 2>&1
if grep -Fq 'Circuits match uniquely.' netgen-fail.out; then echo 'False positive in Netgen smoke test'; exit 1; fi
grep -Ei 'do not match|failed|mismatch' netgen-fail.out
klayout -b -r klayout_smoke.rb -rd smoke_dir="$ROOT/smoke" > "$ROOT/logs/klayout-smoke.log" 2>&1
grep -F 'KLAYOUT_SMOKE_PASS' "$ROOT/logs/klayout-smoke.log"
klayout -b -r klayout_smoke.drc -rd input="$ROOT/smoke/tool_smoke.gds" -rd output="$ROOT/smoke/klayout_smoke.lyrdb" > "$ROOT/logs/klayout-drc-smoke.log" 2>&1
grep -q '<item>' klayout_smoke.lyrdb
printf 'All tool smoke checks passed. These are tool tests, not design signoff.\n'
