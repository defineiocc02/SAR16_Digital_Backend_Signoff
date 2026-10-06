read_spef $result/routed.spef
set_propagated_clock [all_clocks]
to_file $report/antenna.rpt {check_antennas -verbose}
to_file $report/pg_vdd.rpt {check_power_grid -net VDD}
to_file $report/pg_vss.rpt {check_power_grid -net VSS}
to_file $report/placement.rpt {check_placement -verbose}
to_file $report/area.rpt {report_design_area}
foreach tag {nominal scalarstress} {
 if {$tag eq "nominal"} {
  set_timing_derate -early 1.0
  set_timing_derate -late 1.0
 } else {
  set_timing_derate -early 0.9
  set_timing_derate -late 1.1
 }
 to_file $report/${tag}_setup_wns.rpt {report_worst_slack -max -digits 6}
 to_file $report/${tag}_hold_wns.rpt {report_worst_slack -min -digits 6}
 to_file $report/${tag}_setup_tns.rpt {report_tns -max -digits 6}
 to_file $report/${tag}_hold_tns.rpt {report_tns -min -digits 6}
 to_file $report/${tag}_setup.rpt {report_checks -path_delay max -group_path_count 20 -digits 6 -fields {slew capacitance fanout net input_pin}}
 to_file $report/${tag}_hold.rpt {report_checks -path_delay min -group_path_count 20 -digits 6 -fields {slew capacitance fanout net input_pin}}
 foreach kind {max_slew max_capacitance min_capacitance max_fanout min_pulse_width min_period recovery removal} {
  to_file $report/${tag}_${kind}.rpt [list report_check_types -$kind -violators -digits 6]
 }
 to_file $report/${tag}_annotation.rpt {report_parasitic_annotation -report_unannotated}
 to_file $report/${tag}_check_setup.rpt {check_setup -verbose}
 to_file $report/${tag}_unconstrained.rpt {check_setup -verbose -unconstrained_endpoints}
 source $work/scripts/cdc_reports.tcl
}
set b [ord::get_db_block]
set dbu [$b getDbUnitsPerMicron]
set f [open $result/routed_nets.csv w]
puts $f "name,type,pins,wire_present"
foreach n [$b getNets] {
 set pins [expr {[llength [$n getITerms]]+[llength [$n getBTerms]]}]
 set wire [expr {[$n getWire] != "NULL"}]
 puts $f "[$n getName],[$n getSigType],$pins,$wire"
}
close $f
set f [open $result/placed_cells.csv w]
puts $f "instance,master,x_um,y_um,width_um,height_um"
set area 0.0
foreach i [$b getInsts] {
 set bb [$i getBBox]
 set m [$i getMaster]
 set area [expr {$area+double([$m getWidth])*double([$m getHeight])/$dbu/$dbu}]
 puts $f "[$i getName],[$m getName],[expr {double([$bb xMin])/$dbu}],[expr {double([$bb yMin])/$dbu}],[expr {double([$bb xMax]-[$bb xMin])/$dbu}],[expr {double([$bb yMax]-[$bb yMin])/$dbu}]"
}
close $f
set f [open $report/physical_counts.rpt w]
puts $f "instances [llength [$b getInsts]]"
puts $f "nets [llength [$b getNets]]"
puts $f "ports [llength [$b getBTerms]]"
puts $f "all_instance_area_um2 $area"
puts $f "routed_connectivity [design_is_routed]"
set bad 0
foreach inst [$b getInsts] {
 foreach it [$inst getITerms] {
  if {[$it getSigType] in {POWER GROUND} && [$it getNet] eq "NULL"} {incr bad}
 }
}
puts $f "unconnected_pg_terminals $bad"
close $f
