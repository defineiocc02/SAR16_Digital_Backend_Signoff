#!/usr/bin/env bash
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
source "${SAR16_ENV_SH:-$ROOT/sar16_signoff_20261005/environment/env.sh}"
export SAR16_ENV_SH="${SAR16_ENV_SH:-$ROOT/sar16_signoff_20261005/environment/env.sh}"
export RTL_DIR="$ROOT/sar16_rework_20261005/repo/rtl_optimized"
# Candidate is frozen; do not rewrite it here. create_candidate.py documents its construction.
python3 "$HERE/scripts/prove_reference_invariant.py"
yosys-native -l "$HERE/logs/baseline_invariant.log" "$HERE/formal/baseline_invariant.ys" > "$HERE/logs/baseline_invariant.console.log" 2>&1
python3 "$HERE/scripts/build_equivalence.py"
for n in old new; do yosys-native -l "$HERE/logs/$n-normalize.log" "$HERE/formal/$n.ys" > /dev/null; done
python3 "$HERE/scripts/prove_state_relation.py"
yosys-native -l "$HERE/logs/storage_equivalence.log" "$HERE/formal/storage_equivalence.ys" > "$HERE/logs/storage_equivalence.console.log" 2>&1
python3 "$HERE/scripts/prove_reset_base.py"
yosys-native -l "$HERE/logs/reset_base.log" "$HERE/formal/reset_base.ys" > "$HERE/logs/reset_base.console.log" 2>&1
python3 "$HERE/scripts/run_parameter_checks.py" > "$HERE/logs/parameter_checks.log" 2>&1
python3 "$HERE/scripts/finish_parameter_checks.py" > "$HERE/logs/parameter_checks_finish.log" 2>&1
python3 "$HERE/scripts/run_negative_control.py" > "$HERE/logs/negative_control.log" 2>&1
(
 cd "$HERE/formal_regression"
 python3 build.py calib calib_publish
 for case in calib calib_publish; do
   timeout 600 yosys-smtbmc --noprogress --presat -s z3 -t 12 "${case}_formal.smt2" > "logs/${case}_bmc.log" 2>&1
   timeout 600 yosys-smtbmc --noprogress -s z3 -i -t 12 "${case}_formal.smt2" > "logs/${case}_induction.log" 2>&1
 done
 yosys-smtbmc --noprogress -s z3 -c -t 12 --dump-vcd traces/calib_cover_%.vcd calib_formal.smt2 > logs/calib_cover.log 2>&1
)
bash "$HERE/regression/tests/run_tests.sh" > "$HERE/regression/logs/run_all.console.log" 2>&1
python3 "$HERE/scripts/generate_synth.py"
yosys-native -l "$HERE/synthesis/logs/synthesis.log" "$HERE/synthesis/scripts/synth.ys" > "$HERE/synthesis/logs/synthesis.console.log" 2>&1
python3 "$HERE/scripts/verify_evidence.py"
