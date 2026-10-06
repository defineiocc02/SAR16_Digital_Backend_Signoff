# OpenSTA portability adaptation of PR1 constraints/sar_digi_paper_core_pnr.sdc
# Repaired and frozen RTL identity is recorded in reports/rtl_sha256.json.
# Units: SKY130HS native ns, pF, kohm, um; external 50fF =0.05pF.
# This is a transparent feasibility model, not an approved analog IO contract.
if {![info exists clk_period]} { set clk_period 10.0 }
if {![info exists dec_period]} { set dec_period 3.0 }
if {![info exists output_load_ff]} { set output_load_ff 0.05 }
foreach name {clk dec_clk rst_n start_calib calib_comp_out data_valid_i raw_bits_i[*] srm_start srm_decision_valid srm_decision_bit residue_consume_i calib_done calib_done_pulse calib_mode_en calib_overrange calib_overrange_bits[*] dac_p_force[*] dac_n_force[*] raw_code_o[*] raw_code_valid_o w_wr_en w_wr_addr[*] w_wr_data[*] srm_busy srm_done srm_residue_valid srm_residue_o[*] srm_ones_count[*] srm_total_count[*] srm_count_shortfall srm_stalled} {
    if {[llength [get_ports -quiet $name]] == 0} { error "Missing required port $name" }
}
create_clock -name clk -period $clk_period -waveform [list 0.0 [expr {$clk_period/2.0}]] [get_ports clk]
create_clock -name dec_clk -period $dec_period -waveform [list 0.0 [expr {$dec_period/2.0}]] [get_ports dec_clk]
set_clock_uncertainty -setup [expr {$clk_period*0.02}] [get_clocks clk]
set_clock_uncertainty -hold [expr {$clk_period*0.005}] [get_clocks clk]
set_clock_uncertainty -setup [expr {$dec_period*0.02}] [get_clocks dec_clk]
set_clock_uncertainty -hold [expr {$dec_period*0.005}] [get_clocks dec_clk]
set_clock_latency -source 0.0 [all_clocks]
set_clock_transition 0.15 [get_clocks clk]
set_clock_transition 0.10 [get_clocks dec_clk]
# Do not declare broad asynchronous clock groups: those would override Gray
# physical max-delay limits. Targeted asynchronous entries are constrained below.
# External reset is asynchronous by board contract. This waiver covers only its
# direct asynchronous-clear pins; raw/calibration release remains an integration
# assumption, not a proven reset-domain crossing result. SRM local release paths
# from clk_rst_s2/dec_rst_s2 remain timed for recovery/removal.
set reset_pins {}
foreach pin [get_fanout -from [get_ports rst_n] -flat -endpoints_only -trace_arcs all] {
 set pn [get_full_name $pin]
 if {[regexp {/(RN|RESET_B|RESETN|CLR|RESET)$} $pn]} {lappend reset_pins $pin}
}
if {[llength $reset_pins] == 0} {error "No external asynchronous-reset sinks resolved"}
set_false_path -from [get_ports rst_n] -to $reset_pins
puts "EXTERNAL_RESET_WAIVER_PINS [llength $reset_pins]"
set dig_in [get_ports {start_calib data_valid_i raw_bits_i[*] srm_start residue_consume_i}]
set_input_delay -clock clk -max [expr {$clk_period*0.35}] $dig_in
set_input_delay -clock clk -min [expr {$clk_period*0.05}] $dig_in
set dec_in [get_ports {srm_decision_valid srm_decision_bit}]
set_input_delay -clock dec_clk -max [expr {$dec_period*0.35}] $dec_in
set_input_delay -clock dec_clk -min [expr {$dec_period*0.05}] $dec_in
# Comparator is asynchronous; these numbers retain the original test assumption,
# do not bound phase/metastability and do not close the analog timing interface.
set_input_delay -clock clk -max [expr {$clk_period*0.10}] [get_ports calib_comp_out]
set_input_delay -clock clk -min 0.0 [get_ports calib_comp_out]
set nonclock_inputs [get_ports {rst_n start_calib calib_comp_out data_valid_i raw_bits_i[*] srm_start srm_decision_valid srm_decision_bit residue_consume_i}]
set_input_transition -max [expr {$clk_period*0.02}] $nonclock_inputs
set_input_transition -min 0.0 $nonclock_inputs
set dig_out [get_ports {calib_done calib_done_pulse calib_mode_en calib_overrange calib_overrange_bits[*] raw_code_o[*] raw_code_valid_o w_wr_en w_wr_addr[*] w_wr_data[*] srm_busy srm_done srm_residue_valid srm_residue_o[*] srm_ones_count[*] srm_total_count[*] srm_count_shortfall srm_stalled}]
set_output_delay -clock clk -max [expr {$clk_period*0.35}] $dig_out
set_output_delay -clock clk -min [expr {-$clk_period*0.05}] $dig_out
set_output_delay -clock clk -max [expr {$clk_period*0.45}] [get_ports {dac_p_force[*] dac_n_force[*]}]
set_output_delay -clock clk -min 0.0 [get_ports {dac_p_force[*] dac_n_force[*]}]
set_load -max $output_load_ff [all_outputs]
# Inherited external output-min = -0.5 ns on digital outputs is a
# FEASIBILITY ASSUMPTION, not a supplied receiver specification. Retained
# unchanged here for fair baseline comparison.
# Original specifies only a maximum load; min stays unspecified/zero for hold.
set_max_transition 0.8 [current_design]
set_max_fanout 24 [current_design]
if {[llength [all_clocks]] != 2} { error "Expected two independent clocks" }

# Resolve source register and synchronizer-D pins from preserved RTL net names.
# This fails loudly if synthesis has lost a synchronizer boundary.
set cdc_pin_map {}
set cdc_map_file [file join [file dirname [info script]] ../results/cdc_pin_map.tcl]
if {[file exists $cdc_map_file] && ![info exists capture_cdc_mapping]} {source $cdc_map_file}
proc reg_q_pin {netname} {
 global cdc_pin_map
 if {[dict exists $cdc_pin_map $netname]} {
  set pin [get_pins -quiet [dict get $cdc_pin_map $netname]]
  if {[llength $pin] != 1} {error "Frozen CDC source pin lost for $netname"}
  return $pin
 }
 set pins {}
 foreach net [get_nets -quiet $netname] {
  foreach p [get_pins -of_objects $net] {
   if {[get_property $p direction] == "output"} {lappend pins $p}
  }
 }
 if {[llength $pins] != 1} {error "Expected one register Q for $netname, got [llength $pins]"}
 dict set cdc_pin_map $netname [get_full_name [lindex $pins 0]]
 return [lindex $pins 0]
}
proc reg_d_pin {qnetname} {
 set q [reg_q_pin $qnetname]
 set cell [get_cells -of_objects $q]
 set p [get_pins -quiet [get_full_name $cell]/D]
 if {[llength $p] != 1} {error "Missing register D for $qnetname"}
 return $p
}
set cdc_entries {}
foreach row {
 {req_active req_s1 clk dec_clk}
 {dec_ack ack_s1 dec_clk clk}
 {dec_done done_s1 dec_clk clk}
} {
 lassign $row src dst launch capture
 set srcpin [reg_q_pin u_srm_residue.$src]
 set dstpin [reg_d_pin u_srm_residue.$dst]
 set bound [expr {$launch eq "clk" ? 0.8*$clk_period : 0.8*$dec_period}]
 set_max_delay $bound -ignore_clock_latency -from [get_cells -of_objects $srcpin] -to $dstpin
 set_false_path -hold -from [get_cells -of_objects $srcpin] -to $dstpin
 lappend cdc_entries [list scalar $src $dst $bound $srcpin $dstpin]
}
foreach pair {{ones_g ones_g_s1} {total_g tot_g_s1}} {
 lassign $pair src dst
 for {set bit 0} {$bit < 5} {incr bit} {
  set sn [format {u_srm_residue.%s[%d]} $src $bit]
  set dn [format {u_srm_residue.%s[%d]} $dst $bit]
  set sp [reg_q_pin $sn]
  set dp [reg_d_pin $dn]
  set bound [expr {0.8*$dec_period}]
  set_max_delay $bound -ignore_clock_latency -from [get_cells -of_objects $sp] -to $dp
  set_false_path -hold -from [get_cells -of_objects $sp] -to $dp
  lappend cdc_entries [list gray $sn $dn $bound $sp $dp]
 }
}
puts "CDC_ENTRY_MAX_DELAY_CONSTRAINTS [llength $cdc_entries]"
# Native set_bus_skew is unavailable in this OpenSTA build. The bound above is
# applied from source flop (including clock-to-Q) and enforced per bit; a post-extraction min/max span audit checks each bus against
# the 3 ns source period. That independent audit is not an MTBF claim.

if {[info exists capture_cdc_mapping]} {
 set fp [open $cdc_map_file w]
 puts $fp "# Generated from the frozen mapped netlist before physical buffering."
 puts $fp [list set cdc_pin_map $cdc_pin_map]
 close $fp
}
