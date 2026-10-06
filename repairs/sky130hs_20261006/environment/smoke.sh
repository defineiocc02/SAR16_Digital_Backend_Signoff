#!/usr/bin/env bash
# Real functionality checks, with markers because OpenROAD may return zero on Tcl errors.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT/env.sh"
mkdir -p "$ROOT/logs"
iverilog -g2012 -s tb -o "$ROOT/smoke/counter.vvp" "$ROOT/smoke/counter.v" "$ROOT/smoke/tb.sv"
vvp "$ROOT/smoke/counter.vvp" > "$ROOT/logs/simulation-smoke.log" 2>&1
grep -q SIMULATION_SMOKE_PASS "$ROOT/logs/simulation-smoke.log"
verilator --lint-only --top-module counter -Wno-fatal "$ROOT/smoke/counter.v" > "$ROOT/logs/verilator-smoke.log" 2>&1
yosys-native -Q -T -p "read_verilog $ROOT/smoke/counter.v; hierarchy -top counter; synth -top counter; dfflibmap -liberty $NANGATE45_ROOT/lib/NangateOpenCellLibrary_typical.lib; abc -liberty $NANGATE45_ROOT/lib/NangateOpenCellLibrary_typical.lib; check; stat; write_verilog $ROOT/smoke/counter_netlist.v" > "$ROOT/logs/synthesis-smoke.log" 2>&1
(cd "$ROOT/smoke"; sby -f formal.sby) > "$ROOT/logs/formal-smoke.log" 2>&1
grep -q 'DONE (PASS' "$ROOT/logs/formal-smoke.log"
set +e
(cd "$ROOT/smoke"; sby -f negative.sby) > "$ROOT/logs/formal-negative-control.log" 2>&1
NEG=$?
set -e
test "$NEG" = 2
grep -q 'DONE (FAIL' "$ROOT/logs/formal-negative-control.log"
test -s "$ROOT/smoke/negative/engine_0/trace.vcd"
openroad -exit "$ROOT/smoke/openroad_capabilities.tcl" > "$ROOT/logs/openroad-capabilities.log" 2>&1
grep -q OPENROAD_CAPABILITY_SMOKE_PASS "$ROOT/logs/openroad-capabilities.log"
openroad -exit "$ROOT/smoke/place_route.tcl" > "$ROOT/logs/place-route-smoke.log" 2>&1
grep -q PLACEMENT_ROUTE_RCX_SMOKE_PASS "$ROOT/logs/place-route-smoke.log"
! grep -q '\[ERROR ' "$ROOT/logs/place-route-smoke.log"
for p in counter_routed.odb counter_routed.def counter.spef; do test -s "$ROOT/smoke/$p"; done
test -f "$ROOT/smoke/counter.drc" && test ! -s "$ROOT/smoke/counter.drc"
printf 'ALL_ENVIRONMENT_SMOKES_PASS\n'
