#!/usr/bin/env bash
# Run from a fresh extracted copy. Audit works on delivered exact geometry;
# re-routing creates a new artifact that must be formally and physically checked.
set -euo pipefail
R=$(cd "$(dirname "$0")" && pwd)
cd "$R"
FINAL_RUN=$(cat FINAL_RUN)
source environment/env.sh
export SAR16_IMPL_DIR="$R/$FINAL_RUN"
case "${1:-audit}" in
  tools) bash environment/smoke_sky130hs.sh;;
  audit)
    bash "$FINAL_RUN/scripts/run.sh" audit
    python3 "$FINAL_RUN/scripts/check_spef_coverage.py"
    python3 "$FINAL_RUN/scripts/physical_summary.py"
    ;;
  formal) python3 replay_formal.py;;
  render)
    QT_QPA_PLATFORM=offscreen openroad -gui -exit "$FINAL_RUN/scripts/render_images.tcl"
    ;;
  *) echo 'Usage: reproduce.sh tools|audit|formal|render' >&2; exit 2;;
esac
