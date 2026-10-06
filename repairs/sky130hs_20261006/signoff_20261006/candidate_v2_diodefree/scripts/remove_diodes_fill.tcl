set w $::env(SAR16_CANDIDATE)
if {[info exists ::env(SAR16_V1_ODB)]} {read_db $::env(SAR16_V1_ODB)} else {read_db $w/../candidate_v1/results/routed.odb}
set b [ord::get_db_block]
set rem {}
foreach i [$b getInsts] {if {[string match *diode* [[$i getMaster] getName]]} {lappend rem $i}}
set f [open $w/reports/removed_diodes.tsv w]
puts $f "instance\tmaster\tnet\tx_dbu\ty_dbu"
foreach i $rem {
 set net NONE
 foreach t [$i getITerms] {if {[$t getSigType] ni {POWER GROUND}} {set net [[$t getNet] getName]}}
 puts $f "[$i getName]\t[[$i getMaster] getName]\t$net\t[join [$i getLocation] \t]"
 odb::dbInst_destroy $i
}
close $f
filler_placement -prefix DIODEFREE_FILL {sky130_fd_sc_hs__fill_8 sky130_fd_sc_hs__fill_4 sky130_fd_sc_hs__fill_2 sky130_fd_sc_hs__fill_1}
add_global_connection -net VDD -inst_pattern {.*} -pin_pattern {^(VPWR|VPB|VDD|VDDPE|VDDCE)$} -power
add_global_connection -net VSS -inst_pattern {.*} -pin_pattern {^(VGND|VNB|VSS|VSSE)$} -ground
global_connect
check_placement -verbose
write_def $w/results/no_diodes.def
exit
