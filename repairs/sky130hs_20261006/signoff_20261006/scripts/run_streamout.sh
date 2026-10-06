#!/usr/bin/env bash
set -euo pipefail
W=$(cd "$(dirname "$0")/.." && pwd)
P="$W/../environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs"
KLAYOUT=${KLAYOUT:-$W/tools/bin/klayout}
"$KLAYOUT" -b -r "$W/scripts/def2stream.upstream.py" \
 -rd tech_file="$W/inputs/sky130hs.absolute.lyt" \
 -rd layer_map= -rd in_def="$W/../run_v6/results/routed.def" \
 -rd design_name=sar_digi_paper_core \
 -rd in_files="$P/gds/sky130_fd_sc_hs.gds" -rd seal_file= \
 -rd out_file="$W/results/baseline.gds" 2>&1 | tee "$W/logs/streamout.log"
