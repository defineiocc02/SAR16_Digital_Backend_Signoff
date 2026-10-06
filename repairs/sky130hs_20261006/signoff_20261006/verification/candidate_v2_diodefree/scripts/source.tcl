set w $::env(SAR16_SIGNOFF)
read_db $::env(SAR16_VERIFY_ODB)
write_verilog -include_pwr_gnd $w/results/source.pg.v
write_cdl -include_fillers -masters $::env(SAR16_HS_SPICE) $w/results/source.cdl
set fp [open $w/reports/source_instances.txt w]
puts $fp [llength [[ord::get_db_block] getInsts]]
close $fp
