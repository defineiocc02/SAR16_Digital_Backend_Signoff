set work $::env(SAR16_IMPL_DIR)
read_db $work/results/extracted.odb
set f [open $work/reports/antenna_target_instances.rpt w]
set b [ord::get_db_block]
set dbu [$b getDbUnitsPerMicron]
foreach name {net106 net108} {
 set n [$b findNet $name]
 puts $f "NET $name"
 foreach it [$n getITerms] {
  set i [$it getInst]
  set bb [$i getBBox]
  puts $f "  [$i getName]/[[$it getMTerm] getName] CELL [[$i getMaster] getName] BBOX [expr {double([$bb xMin])/$dbu}] [expr {double([$bb yMin])/$dbu}] [expr {double([$bb xMax])/$dbu}] [expr {double([$bb yMax])/$dbu}]"
 }
}
close $f
check_antennas -net net106 -verbose -report_file $work/reports/antenna_net106.rpt
check_antennas -net net108 -verbose -report_file $work/reports/antenna_net108.rpt
exit
