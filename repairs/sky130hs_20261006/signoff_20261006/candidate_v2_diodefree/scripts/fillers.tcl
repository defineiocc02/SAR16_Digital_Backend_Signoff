set w $::env(SAR16_CANDIDATE)
read_db $w/../../run_v6/results/routed.odb
set_thread_count 4
filler_placement {sky130_fd_sc_hs__fill_8 sky130_fd_sc_hs__fill_4 sky130_fd_sc_hs__fill_2 sky130_fd_sc_hs__fill_1}
add_global_connection -net VDD -inst_pattern {.*} -pin_pattern {^(VPWR|VPB|VDD|VDDPE|VDDCE)$} -power
add_global_connection -net VSS -inst_pattern {.*} -pin_pattern {^(VGND|VNB|VSS|VSSE)$} -ground
global_connect
check_placement -verbose
write_db $w/results/fillers.odb
write_def $w/results/fillers.def
write_verilog -sort $w/results/fillers.v
set b [ord::get_db_block]
puts "CANDIDATE_FILLER_INSTANCE_COUNT [llength [$b getInsts]]"
exit
