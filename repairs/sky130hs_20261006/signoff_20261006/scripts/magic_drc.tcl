set w $::env(SAR16_SIGNOFF)
drc off
gds readonly true
gds rescale false
cif istyle sky130()
gds maskhints true
gds read $w/results/baseline.gds
load sar_digi_paper_core
select top cell
expand
drc euclidean on
drc style drc(full)
drc on
drc check
drc catchup
set oscale [cif scale out]
set fout [open $w/reports/magic_drc_full.rpt w]
set tsv [open $w/reports/magic_drc_full.tsv w]
puts $tsv "rule\txmin_um\tymin_um\txmax_um\tymax_um"
set count 0
set drcresult [drc listall why]
foreach {errtype coordlist} $drcresult {
 puts $fout $errtype
 puts $fout "----------------------------------------"
 foreach coord $coordlist {
  lassign $coord x1 y1 x2 y2
  set coords [list [expr {$oscale*$x1}] [expr {$oscale*$y1}] [expr {$oscale*$x2}] [expr {$oscale*$y2}]]
  puts $fout $coords
  puts $tsv "$errtype\t[join $coords \t]"
  incr count
 }
}
puts $fout "RAW_RECTANGLE_COUNT $count"
close $fout
close $tsv
puts "MAGIC_FULL_DRC_RAW_RECTANGLE_COUNT $count"
feedback save $w/reports/magic_drc_feedback.txt
quit -noprompt
