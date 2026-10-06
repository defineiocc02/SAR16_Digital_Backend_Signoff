#!/usr/bin/env bash
# Verify only; never mutate input ODB/DEF or waive checker rules.
set -euo pipefail
S=$(cd "$(dirname "$0")/.." && pwd)
NAME=$1; DEF=$(realpath "$2"); ODB=$(realpath "$3")
W="$S/verification/$NAME"
mkdir -p "$W"/{scripts,results,reports,logs}
export SAR16_SIGNOFF="$W" PDK_ROOT="$S/pdk"
export SAR16_VERIFY_ODB="$ODB"
export SAR16_HS_SPICE="$S/pdk/sky130A/libs.ref/sky130_fd_sc_hs/spice/sky130_fd_sc_hs.geometry_matched.spice"
P="$S/../environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs"
sha256sum "$DEF" "$ODB" "$SAR16_HS_SPICE" > "$W/reports/input.sha256"
"$S/tools/bin/klayout" -b -r "$S/scripts/def2stream.upstream.py" \
 -rd tech_file="$S/inputs/sky130hs.absolute.lyt" -rd layer_map= \
 -rd in_def="$DEF" -rd design_name=sar_digi_paper_core \
 -rd in_files="$P/gds/sky130_fd_sc_hs.gds" -rd seal_file= \
 -rd out_file="$W/results/baseline.gds" > "$W/logs/streamout.log" 2>&1
cat > "$W/scripts/source.tcl" <<'TCL'
set w $::env(SAR16_SIGNOFF)
read_db $::env(SAR16_VERIFY_ODB)
write_verilog -include_pwr_gnd $w/results/source.pg.v
write_cdl -include_fillers -masters $::env(SAR16_HS_SPICE) $w/results/source.cdl
set fp [open $w/reports/source_instances.txt w]
puts $fp [llength [[ord::get_db_block] getInsts]]
close $fp
TCL
(
 source "$S/../environment/env.sh"
 openroad -exit "$W/scripts/source.tcl" > "$W/logs/source.log" 2>&1
)
printf '* Geometry-matched official source\n.include "%s"\n.include "%s"\n' "$SAR16_HS_SPICE" "$W/results/source.cdl" > "$W/results/source.reference.spice"
"$S/tools/bin/magic" -dnull -noconsole -rcfile "$PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc" "$S/scripts/magic_extract.tcl" > "$W/logs/magic_extract.log" 2>&1
"$S/tools/bin/netgen" -batch lvs "$W/results/baseline.extracted.spice sar_digi_paper_core" "$W/results/source.reference.spice sar_digi_paper_core" "$PDK_ROOT/sky130A/libs.tech/netgen/sky130A_setup.tcl" "$W/reports/netgen_lvs.out" -json > "$W/logs/netgen_lvs.log" 2>&1
"$S/tools/bin/magic" -dnull -noconsole -rcfile "$PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc" "$S/scripts/magic_drc.tcl" > "$W/logs/magic_drc.log" 2>&1
"$S/tools/bin/klayout" -b -rd in_gds="$W/results/baseline.gds" -rd report_file="$W/reports/klayout_beol.lyrdb" -r "$S/inputs/orfs_sky130_beol_unmodified.lydrc" > "$W/logs/klayout_beol.log" 2>&1
printf 'VERIFICATION_CHECKERS_COMPLETED %s (inspect reports for PASS/FAIL; checker exit codes are insufficient)\n' "$NAME"
