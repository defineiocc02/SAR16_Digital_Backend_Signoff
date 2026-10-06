foreach cmd {read_lef read_liberty read_verilog initialize_floorplan global_placement detailed_placement clock_tree_synthesis global_route detailed_route extract_parasitics report_checks write_db write_def write_spef} {
 if {[llength [info commands $cmd]]==0} {error "Missing capability: $cmd"}
 puts "CAPABILITY_PRESENT $cmd"
}
puts "OPENROAD_CAPABILITY_SMOKE_PASS"
exit
