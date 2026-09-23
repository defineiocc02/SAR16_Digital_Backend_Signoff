#!/bin/bash
# Round 13b: F3 retry.  Two mistakes last round are fixed here:
#   1. fc_shell buffers stdout when it is not a tty, so killing it lost the whole log
#      (0 bytes) -- this run uses `stdbuf -oL` and is allowed to finish.
#   2. the stage script does `rm -rf $PRJ/pnr` before running, so it must NOT be used;
#      fc_shell is invoked directly from $PRJ exactly like the stage does.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/f3c
rm -rf $W; mkdir -p $W
cat > $W/f3.tcl <<'TCL'
fconfigure stdout -buffering line
set PRJ /home/<user>/sar16_work/proj_paper_core
set LIB $PRJ/pnr/sar16_pnr_paper_core
set W   /tmp/f3c
proc step {label script} {
    if {[catch {uplevel #0 $script} e]} { puts "FAIL $label -> $e" ; flush stdout ; return 0 }
    puts "OK   $label" ; flush stdout ; return 1
}
puts "S0 cwd=[pwd]"
puts "S1 open existing library $LIB"
if {![step open_lib "open_lib $LIB"]} { step open_mw_lib "open_mw_lib $LIB" }
foreach q {get_blocks get_designs get_libs} {
    if {[catch {$q -quiet} r]} { puts "Q  $q -> ERR $r" } else { puts "Q  $q -> $r" }
}
flush stdout
puts "S2 current_design"
step current_design "current_design sar_digi_paper_core"
puts "S3 try create_abstract from this (parent-less) block"
if {[catch {create_abstract -blocks sar_digi_paper_core -force_recreate} e]} {
    puts "FAIL create_abstract -> $e"
} else { puts "OK   create_abstract" }
flush stdout
puts "S4 try a parent wrapper inside the same library"
step create_block "create_block sar16_wrap_top"
step create_cell_a "create_cell U_DUT sar_digi_paper_core"
step create_cell_b "create_cell -reference sar_digi_paper_core U_DUT2"
if {[catch {get_cells -quiet} r]} { puts "Q  get_cells -> ERR $r" } else { puts "Q  get_cells -> $r" }
flush stdout
puts "S5 create_abstract from the wrapper"
if {[catch {create_abstract -all_blocks -force_recreate} e]} {
    puts "FAIL create_abstract -all_blocks -> $e"
} else { puts "OK   create_abstract -all_blocks" }
flush stdout
puts "S6 write_lef and look for the wrapper/block macro"
if {[catch {write_lef -design sar16_wrap_top $W/wrap_top.lef} e]} { puts "FAIL write_lef wrap -> $e" } else { puts "OK   write_lef wrap" }
if {[catch {write_lef -design sar_digi_paper_core $W/block.lef} e]} { puts "FAIL write_lef block -> $e" } else { puts "OK   write_lef block" }
flush stdout
foreach f [list $W/wrap_top.lef $W/block.lef] {
    if {[file exists $f]} {
        set fh [open $f r] ; set n 0
        while {[gets $fh line] >= 0} { if {[string match "MACRO sar*" $line]} { incr n ; puts "   MACRO: $line" } }
        close $fh
        puts "LEF $f bytes=[file size $f] sar_macros=$n"
    } else { puts "LEF $f NOT WRITTEN" }
}
flush stdout
puts "F3_DONE"
exit 0
TCL
cd $PC || exit 1
echo "=== running fc_shell (line-buffered, 1800 s cap) ==="
stdbuf -oL -eL timeout 1800 fc_shell -f $W/f3.tcl > $W/f3.log 2>&1
echo "fc_shell rc=$? bytes=$(stat -c%s $W/f3.log)"
echo "=== filtered log ==="
grep -a -E '^(S[0-9]|OK|FAIL|Q |   MACRO|LEF |F3_DONE)' $W/f3.log | head -50
echo "=== log tail ==="
tail -12 $W/f3.log
echo "=== outputs ==="
ls -la $W | head -8
echo "=== project tree untouched? ==="
find $PC -newermt "2026-09-18 22:40" -type f 2>/dev/null | head
echo "=== DONE ==="
