set w $::env(SAR16_CANDIDATE)
set p $::env(SKY130HS_ROOT)
read_lef $p/lef/sky130_fd_sc_hs.tlef
read_lef $p/lef/sky130_fd_sc_hs_merged.lef
read_def $w/results/access_repair.def
# DEF represents both LOCKED and FIRM as FIXED; restore original locked tap metadata.
foreach i [[ord::get_db_block] getInsts] {
 if {[[$i getMaster] getName] eq "sky130_fd_sc_hs__tapvpwrvgnd_1"} {$i setPlacementStatus LOCKED}
}
add_global_connection -net VDD -inst_pattern {.*} -pin_pattern {^(VPWR|VPB|VDD|VDDPE|VDDCE)$} -power
add_global_connection -net VSS -inst_pattern {.*} -pin_pattern {^(VGND|VNB|VSS|VSSE)$} -ground
global_connect
check_placement -verbose
puts "ROUTED_CONNECTIVITY [design_is_routed]"
write_db $w/results/routed.odb
write_def $w/results/routed.def
write_verilog $w/results/routed.v
write_verilog -include_pwr_gnd $w/results/source.pg.v
exit
