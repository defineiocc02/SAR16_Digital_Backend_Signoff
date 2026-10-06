set work $::env(SAR16_IMPL_DIR)
set result $work/results
set report $work/reports
set platform $::env(SAR16_EDA_ROOT)/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs
source $work/scripts/report_utils.tcl
set_thread_count 4
read_liberty $platform/lib/sky130_fd_sc_hs__tt_025C_1v80.lib
read_db $result/routed.odb
source $work/scripts/proxy_constraints.sdc
source $platform/setRC.tcl
set_propagated_clock [all_clocks]
set_global_routing_layer_adjustment met1-met5 0.2
set_routing_layers -signal met1-met5 -clock met3-met5
# Use the supported post-detailed-route repair flow on the ACTUAL detailed
# wires; do not destroy or globally regenerate already completed routes.
for {set iteration 1} {$iteration<=10} {incr iteration} {
 set count [check_antennas -report_file $report/antenna_before_${iteration}.rpt]
 puts "POST_DRT_ANTENNA_ITERATION $iteration COUNT $count"
 if {$count==0} {break}
 repair_antennas sky130_fd_sc_hs__diode_2 -iterations 5 -ratio_margin 10 -diode_only
 add_global_connection -net VDD -inst_pattern {.*} -pin_pattern {^(VPWR|VPB|VDD|VDDPE|VDDCE)$} -power
 add_global_connection -net VSS -inst_pattern {.*} -pin_pattern {^(VGND|VNB|VSS|VSSE)$} -ground
 global_connect
 check_placement -verbose
 detailed_route -output_drc $report/route_drc.rpt -output_maze $result/maze.log -verbose 1
 write_db $result/post_drt_${iteration}.odb
}
if {![design_is_routed]} {error "Detailed-route connectivity incomplete"}
write_db $result/routed.odb
write_def $result/routed.def
write_verilog $result/routed.v
write_guides $result/route.guide
to_file $report/antenna.rpt {check_antennas -verbose}
puts "STAGE_COMPLETE post_drt_antenna"
exit
