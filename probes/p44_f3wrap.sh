#!/bin/bash
# Round 12b (F3): try to build a parent wrapper around the block and then call
# create_abstract from that parent.  Every step is wrapped so the output shows what
# exists in this FC version instead of dying on the first unknown command.
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/f3wrap
rm -rf $W; mkdir -p $W
echo "=== library handling in the existing P&R script ==="
grep -n -E 'open_lib|create_lib|open_mw_lib|create_mw_lib|read_ndm|link_block|current_design|copy_block|set_ref' \
     $PC/scripts/fc_pnr_paper_core.tcl | head -20
echo ""
cat > $W/f3.tcl <<'TCL'
set PRJ /home/<user>/sar16_work/proj_paper_core
set LIB $PRJ/pnr/sar16_pnr_paper_core
set W   /tmp/f3wrap
proc step {label script} {
    if {[catch {uplevel #0 $script} e]} { puts "FAIL $label -> $e" ; return 0 }
    puts "OK   $label"
    return 1
}
puts "--- S0 open library ---"
if {![step open_lib "open_lib $LIB"]} { step open_mw_lib "open_mw_lib $LIB" }
puts "--- S1 what is in the library ---"
if {[catch {set blocks [get_blocks -quiet]} e]} { puts "FAIL get_blocks -> $e" } else { puts "blocks: $blocks" }
if {[catch {set designs [get_designs -quiet]} e]} { puts "FAIL get_designs -> $e" } else { puts "designs: $designs" }
puts "--- S2 create a parent block ---"
step create_block "create_block sar16_wrap_top"
puts "--- S3 instantiate the block in the parent ---"
if {![step create_cell_ref "create_cell U_DUT sar_digi_paper_core"]} {
    step create_cell_ref2 "create_cell -reference sar_digi_paper_core U_DUT"
}
if {[catch {set cells [get_cells -quiet]} e]} { puts "FAIL get_cells -> $e" } else { puts "cells: $cells" }
puts "--- S4 create_abstract from the parent ---"
if {[catch {create_abstract -blocks sar_digi_paper_core -force_recreate} e]} {
    puts "FAIL create_abstract -> $e"
    catch {puts "help: [create_abstract -help]"}
} else { puts "OK   create_abstract" }
puts "--- S5 write_lef and check for the block macro ---"
if {[catch {write_lef -design sar16_wrap_top $W/wrap.lef} e]} { puts "FAIL write_lef -> $e" } else {
    puts "OK   write_lef"
}
if {[catch {set n [exec grep -c "^MACRO sar16_wrap_top" $W/wrap.lef]} e]} { puts "no wrap lef: $e" } else {
    puts "WRAP_MACRO=$n"
}
puts "F3_DONE"
exit 0
TCL
cd $W || exit 1
timeout 600 fc_shell -f $W/f3.tcl < /dev/null > $W/f3.log 2>&1
echo "fc_shell rc=$?"
echo "--- log (filtered) ---"
grep -a -E '^(OK|FAIL|---|blocks:|designs:|cells:|WRAP_MACRO|F3_DONE)' $W/f3.log | head -40
echo "--- log tail ---"
tail -15 $W/f3.log
echo "--- outputs ---"
ls -la $W 2>/dev/null | head -10
echo "=== DONE ==="
