# Reconstructed native SKY130HS physical run; original geometry was not delivered.
# Frozen RTL/mapped logic, explicit 10ns/3ns clocks, 0.05pF max load, -0.5ns output min.
set work $::env(SAR16_IMPL_DIR)
set result $work/results
set report $work/reports
set platform $::env(SAR16_EDA_ROOT)/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs
set stage $::env(SAR16_STAGE)
source $work/scripts/report_utils.tcl
set_thread_count 4
read_liberty $platform/lib/sky130_fd_sc_hs__tt_025C_1v80.lib
proc pg_connect {} {
 add_global_connection -net VDD -inst_pattern {.*} -pin_pattern {^(VPWR|VPB|VDD|VDDPE|VDDCE)$} -power
 add_global_connection -net VSS -inst_pattern {.*} -pin_pattern {^(VGND|VNB|VSS|VSSE)$} -ground
 global_connect
}
proc check_and_save {name} {
 global result
 detailed_placement
 check_placement -verbose
 pg_connect
 write_db $result/$name.odb
}
if {$stage eq "floorplan"} {
 read_lef $platform/lef/sky130_fd_sc_hs.tlef
 read_lef $platform/lef/sky130_fd_sc_hs_merged.lef
 read_verilog $result/mapped.v
 link_design sar_digi_paper_core
 set b [ord::get_db_block]
 foreach net [$b getNets] {
  if {[$net getName] in {zero_ one_} && [llength [$net getITerms]] == 0 && [llength [$net getBTerms]] == 0} {odb::dbNet_destroy $net}
 }
 set capture_cdc_mapping 1
 source $work/scripts/proxy_constraints.sdc
 unset capture_cdc_mapping
 to_file $report/units.rpt {report_units}
 to_file $report/synth_area.rpt {report_design_area}
 initialize_floorplan -die_area {0 0 392.98 392.98} -core_area {12 13.32 380.64 379.62} -site unit
 source $platform/make_tracks.tcl
 source $work/scripts/module_pinplan.tcl
 place_pins -hor_layers met3 -ver_layers met2 -write_pin_placement $result/pin_placement.tcl
 set ::env(TAP_CELL_NAME) sky130_fd_sc_hs__tapvpwrvgnd_1
 source $platform/tapcell.tcl
 source $platform/pdn.tcl
 pdngen -failed_via_report $report/pdn_failed_vias.rpt
 write_db $result/floorplan.odb
 puts "STAGE_COMPLETE floorplan"
 exit
}
set input [dict get {place floorplan cts placed route cts extract routed audit extracted} $stage]
read_db $result/$input.odb
source $work/scripts/proxy_constraints.sdc
source $platform/setRC.tcl
set_dont_use {sky130_fd_sc_hs__tapvpwrvgnd_1 sky130_fd_sc_hs__fill_* sky130_fd_sc_hs__decap_* sky130_fd_sc_hs__diode_2}
pg_connect
if {$stage eq "place"} {
 repair_tie_fanout -separation 0 sky130_fd_sc_hs__conb_1/HI
 repair_tie_fanout -separation 0 sky130_fd_sc_hs__conb_1/LO
 buffer_ports
 global_placement -density 0.62
 estimate_parasitics -placement
 repair_design -slew_margin 15 -cap_margin 20
 check_and_save placed
 to_file $report/placed_timing.rpt {report_checks -path_delay min_max -group_path_count 10 -digits 6}
}
if {$stage eq "cts"} {
 clock_tree_synthesis -root_buf sky130_fd_sc_hs__clkbuf_8 -buf_list {sky130_fd_sc_hs__clkbuf_2 sky130_fd_sc_hs__clkbuf_4 sky130_fd_sc_hs__clkbuf_8 sky130_fd_sc_hs__clkbuf_16} -sink_clustering_enable -sink_clustering_size 20 -sink_buffer_max_cap_derate 0.9
 set_propagated_clock [all_clocks]
 detailed_placement
 estimate_parasitics -placement
 set_timing_derate -early 0.9
 set_timing_derate -late 1.1
 repair_design -slew_margin 15 -cap_margin 20
 repair_timing -setup -setup_margin 0.10
 write_db $result/prehold.odb
 repair_timing -hold -hold_margin 0.05 -max_buffer_percent 45
 check_and_save cts
 estimate_parasitics -placement
 report_cts -out_file $report/cts.rpt
 to_file $report/cts_timing.rpt {report_checks -path_delay min_max -group_path_count 10 -digits 6}
}
if {$stage eq "route"} {
 set_propagated_clock [all_clocks]
 set_timing_derate -early 0.9
 set_timing_derate -late 1.1
 set_global_routing_layer_adjustment met1-met5 0.2
 set_routing_layers -signal met1-met5 -clock met3-met5
 global_route -guide_file $result/route.guide -congestion_iterations 50
 estimate_parasitics -global_routing
 repair_antennas sky130_fd_sc_hs__diode_2 -iterations 5 -ratio_margin 30
 pg_connect
 check_placement -verbose
 write_db $result/globalroute.odb
 write_guides $result/route.guide
 detailed_route -output_drc $report/route_drc.rpt -output_maze $result/maze.log -verbose 1
 if {![design_is_routed]} {error "Detailed route left signal nets unconnected"}
 puts "ROUTED_CONNECTIVITY_COMPLETE"
 write_db $result/routed.odb
 write_def $result/routed.def
 write_verilog $result/routed.v
 to_file $report/antenna.rpt {check_antennas -verbose}
}
if {$stage eq "extract"} {
 set_propagated_clock [all_clocks]
 define_process_corner -ext_model_index 0 X
 extract_parasitics -ext_model_file $platform/rcx_patterns.rules
 write_spef $result/routed.spef
 read_spef $result/routed.spef
 write_db $result/extracted.odb
 write_sdc $result/routed.sdc
 write_sdf $result/routed.sdf
}
if {$stage eq "audit"} {source $work/scripts/audit.tcl}
puts "STAGE_COMPLETE $stage"
