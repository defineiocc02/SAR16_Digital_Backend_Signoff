set root $::env(SAR16_EDA_ROOT)
set p $::env(NANGATE45_ROOT)
set_thread_count 2
read_lef $p/lef/NangateOpenCellLibrary.tech.lef
read_lef $p/lef/NangateOpenCellLibrary.macro.mod.lef
read_liberty $p/lib/NangateOpenCellLibrary_typical.lib
read_verilog $root/smoke/counter_netlist.v
link_design counter
initialize_floorplan -die_area {0 0 30 30} -core_area {5 5 25 25} -site FreePDK45_38x28_10R_NP_162NW_34O
source $p/make_tracks.tcl
create_clock -name clk -period 10 [get_ports clk]
set_input_delay 0.1 -clock clk [get_ports {rst en}]
set_output_delay 0.1 -clock clk [get_ports {q*}]
source $p/setRC.tcl
place_pins -hor_layers metal3 -ver_layers metal2
global_placement -density 0.2
detailed_placement
check_placement -verbose
clock_tree_synthesis -root_buf CLKBUF_X3 -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3}
repair_clock_nets
detailed_placement
set_propagated_clock [all_clocks]
set_routing_layers -signal metal2-metal6 -clock metal2-metal6
set_global_routing_layer_adjustment metal2-metal6 0.2
global_route -guide_file $root/smoke/counter.guide -verbose
detailed_route -output_drc $root/smoke/counter.drc -output_maze $root/smoke/counter.maze.log
write_db $root/smoke/counter_routed.odb
write_def $root/smoke/counter_routed.def
extract_parasitics -ext_model_file $p/rcx_patterns.rules
write_spef $root/smoke/counter.spef
report_checks -path_delay min_max
puts "PLACEMENT_ROUTE_RCX_SMOKE_PASS"
exit
