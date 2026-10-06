set w $::env(SAR16_CANDIDATE)
read_db $w/results/routed.odb
set_thread_count 4
set b [ord::get_db_block]
set diodes 0
set dt 0
foreach i [$b getInsts] {
 if {[string match *diode* [[$i getMaster] getName]]} {incr diodes}
 foreach t [$i getITerms] {if {[string match *DIODE* [[$t getMTerm] getName]]} {incr dt}}
}
puts "DIODE_INSTANCES $diodes DIODE_PIN_TERMINALS $dt"
if {$diodes!=0 || $dt!=0} {error "Diode presence in diode-free candidate"}
check_antennas -verbose -report_file $w/reports/antenna_fresh_full.rpt
check_antennas -net clk -verbose -report_file $w/reports/antenna_clk_jumper.rpt
check_antennas -net clknet_4_8_0_clk -verbose -report_file $w/reports/antenna_clock_branch_jumper.rpt
check_antennas -net _0827_ -verbose -report_file $w/reports/antenna_signal_m2_jumper.rpt
puts "FINAL_CONNECTIVITY [design_is_routed]"
exit
