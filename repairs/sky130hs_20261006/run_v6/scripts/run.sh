#!/usr/bin/env bash
set -euo pipefail
W=$(cd "$(dirname "$0")/.." && pwd)
source "$W/../environment/env.sh"
export SAR16_IMPL_DIR="$W"
export SAR16_STAGE="${1:-floorplan}"
openroad -exit "$W/scripts/flow.tcl" 2>&1 | tee "$W/logs/${SAR16_STAGE}.log"
