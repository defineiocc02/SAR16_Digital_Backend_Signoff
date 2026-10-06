set w $::env(SAR16_SIGNOFF)
read_db $w/../run_v6/results/routed.odb
set b [ord::get_db_block]
if {[llength [$b getInsts]] != 5765} {error "Frozen baseline instance count changed"}
write_verilog -sort -include_pwr_gnd $w/results/source.pg.v
if {[info exists ::env(SAR16_HS_SPICE)]} {
 write_cdl -include_fillers -masters $::env(SAR16_HS_SPICE) $w/results/source.cdl
}
puts "BASELINE_SOURCE_EXPORT_COMPLETE"
