#!/usr/bin/env bash
# Reproduce only the official Magic / Netgen SKY130A technology views.
# Definitions and transformations follow sky130/Makefile.in's magic-A/netgen-A targets.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/src/open-pdks-801834fcbf9119e6fd4462f97da9e637f284539a"
OUT="$ROOT/sky130A/libs.tech"
DEFS=(-DTECHNAME=sky130A -DREVISION=1.0.611-801834f -DMETAL5 -DMIM -DREDISTRIBUTION "-DSTAGING_PATH=$ROOT" -DMAGIC_CURRENT=libs.tech/magic)
mkdir -p "$OUT/magic" "$OUT/netgen"
pp() { python3 "$SRC/common/preproc.py" "${DEFS[@]}" "$@"; }
pp "$SRC/sky130/magic/sky130.tech" "$OUT/magic/sky130A.tech"
pp "$SRC/sky130/magic/sky130gds.tech" "$OUT/magic/sky130A-GDS.tech"
pp "$SRC/sky130/magic/sky130.magicrc" "$OUT/magic/sky130A.magicrc"
pp "$SRC/common/pdk.bindkeys" "$OUT/magic/sky130A-BindKeys"
pp "$SRC/sky130/magic/sky130.tcl" "$OUT/magic/sky130A.tcl"
pp "$SRC/common/pdk.tcl" >> "$OUT/magic/sky130A.tcl"
cp "$SRC/sky130/custom/scripts/run_standard_drc.py" "$OUT/magic/"
for f in generate_fill.py check_density.py check_antenna.py; do pp "$SRC/sky130/custom/scripts/$f" "$OUT/magic/$f"; done
pp "$SRC/sky130/netgen/sky130_setup.tcl" "$OUT/netgen/sky130A_setup.tcl"
ln -sfn sky130A.magicrc "$OUT/magic/magicrc"
ln -sfn sky130A_setup.tcl "$OUT/netgen/setup.tcl"
printf 'PDK_ROOT=%s\nMagic technology: %s\nNetgen setup: %s\n' "$ROOT" "$OUT/magic/sky130A.tech" "$OUT/netgen/sky130A_setup.tcl"
