#!/usr/bin/env bash
# Focused restoration checks only. This does not place or route SAR16.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT/env.sh"
cd "$ROOT"
mkdir -p logs
openroad -exit smoke/sky130hs_restore.tcl > logs/sky130hs-openroad-smoke.log 2>&1
grep -q SKY130HS_PINNED_RESTORE_SMOKE_PASS logs/sky130hs-openroad-smoke.log
! grep -q '\[ERROR ' logs/sky130hs-openroad-smoke.log
yosys-native -Q -T -p "read_verilog smoke/counter.v; hierarchy -top counter; synth -top counter; dfflibmap -liberty $SKY130HS_ROOT/lib/sky130_fd_sc_hs__tt_025C_1v80.lib; abc -liberty $SKY130HS_ROOT/lib/sky130_fd_sc_hs__tt_025C_1v80.lib; check; stat; write_verilog smoke/counter_sky130hs.v" > logs/sky130hs-yosys-smoke.log 2>&1
iverilog -g2012 -s tb -o smoke/counter.vvp smoke/counter.v smoke/tb.sv
vvp smoke/counter.vvp > logs/iverilog-smoke.log 2>&1
grep -q SIMULATION_SMOKE_PASS logs/iverilog-smoke.log
verilator --lint-only --top-module counter -Wno-fatal smoke/counter.v > logs/restored-verilator-smoke.log 2>&1
printf 'SKY130HS_TOOL_RESTORE_SMOKES_PASS\n'
