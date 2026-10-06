#!/usr/bin/env bash
# Reproduce all physical repairs from frozen run_v6 in a fresh sibling directory.
set -euo pipefail
HOST_PYTHON3=$(command -v python3)
SRC=$(cd "$(dirname "$0")" && pwd)
W=$(cd "$SRC/.." && pwd)
ROOT=$(cd "$W/.." && pwd)
OUT=${1:-"$W/candidate_v2_diodefree_replay"}
if [[ -e "$OUT" ]]; then echo "Refusing to overwrite existing results: $OUT" >&2; exit 2; fi
if [[ $(cd "$(dirname "$OUT")" && pwd) != "$W" ]]; then echo 'Replay must be a sibling under signoff_20261006' >&2; exit 2; fi
mkdir -p "$OUT"/{scripts,results,reports,logs,images}
OUT=$(cd "$OUT" && pwd)
cp "$SRC"/scripts/* "$OUT/scripts/"
cp "$ROOT/run_v6/results/"{mapped.v,cdc_pin_map.tcl} "$OUT/results/"
source "$ROOT/environment/env.sh"
export SAR16_CANDIDATE="$OUT" SAR16_IMPL_DIR="$OUT"
# First reproduce the filler and three CLK access corrections from run_v6.
openroad -exit "$OUT/scripts/fillers.tcl" > "$OUT/logs/fillers.log" 2>&1
python3 "$OUT/scripts/repair_li_access.py"
openroad -exit "$OUT/scripts/ingest_repaired_def.tcl" > "$OUT/logs/ingest_v1.log" 2>&1
mv "$OUT/results/routed.odb" "$OUT/results/v1_intermediate.odb"
export SAR16_V1_ODB="$OUT/results/v1_intermediate.odb"
# Remove eight diodes, refill their sites, and create real layer-jump routing.
openroad -exit "$OUT/scripts/remove_diodes_fill.tcl" > "$OUT/logs/remove_diodes_fill.log" 2>&1
python3 "$OUT/scripts/route_jumper.py" > "$OUT/logs/route_jumper.log"
openroad -exit "$OUT/scripts/ingest_repaired_def.tcl" > "$OUT/logs/ingest_repaired_def.log" 2>&1
for SAR16_STAGE in extract audit; do export SAR16_STAGE; openroad -exit "$OUT/scripts/flow.tcl" > "$OUT/logs/$SAR16_STAGE.log" 2>&1; done
openroad -exit "$OUT/scripts/router_check.tcl" > "$OUT/logs/router_check.log" 2>&1
openroad -exit "$OUT/scripts/check_antenna_fresh.tcl" > "$OUT/logs/check_antenna_fresh.log" 2>&1
openroad -python -exit "$OUT/scripts/audit_invariance.py" > "$OUT/logs/audit_invariance.log" 2>&1
openroad -python -exit "$OUT/scripts/audit_antenna_models.py" > "$OUT/logs/audit_antenna_models.log" 2>&1
python3 "$OUT/scripts/check_spef_coverage.py"
python3 "$OUT/scripts/physical_summary.py"
openroad -exit "$OUT/scripts/extra_final.tcl" > "$OUT/logs/extra_final.log" 2>&1
"$W/tools/bin/klayout" -b -r "$W/scripts/def2stream.upstream.py" \
 -rd tech_file="$W/inputs/sky130hs.absolute.lyt" -rd layer_map= \
 -rd in_def="$OUT/results/routed.def" -rd design_name=sar_digi_paper_core \
 -rd in_files="$SKY130HS_ROOT/gds/sky130_fd_sc_hs.gds" -rd seal_file= \
 -rd out_file="$OUT/results/candidate.gds" > "$OUT/logs/streamout.log" 2>&1
"$W/tools/bin/klayout" -b -r "$OUT/scripts/export_jumper_geometry.py" > "$OUT/logs/export_jumper_geometry.log" 2>&1
MPLCONFIGDIR="$OUT/.mpl_cache" "$HOST_PYTHON3" "$OUT/scripts/render_jumper_zooms.py"
"$W/tools/bin/klayout" -b -r "$OUT/scripts/export_li_zoom_geometry.py" > "$OUT/logs/export_li_zoom_geometry.log" 2>&1
MPLCONFIGDIR="$OUT/.mpl_cache" "$HOST_PYTHON3" "$OUT/scripts/render_li_zooms.py"
QT_QPA_PLATFORM=offscreen openroad -gui -exit "$OUT/scripts/render_images.tcl" > "$OUT/logs/render_images.log" 2>&1
printf '\nPhysical repair replay complete from frozen run_v6: %s\n' "$OUT"
printf 'Run the main signoff workflow for full GDS DRC / extracted strict LVS and formal verification.\n'
