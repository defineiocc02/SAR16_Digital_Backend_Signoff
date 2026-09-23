#!/bin/bash
# F5: turn the collection handles into names and counts -- the previous query returned
# handles (_sel3/_sel4/_sel5) which means non-empty, but a handle is not a proof.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/f5
rm -rf $W; mkdir -p $W
cat > $W/q.tcl <<'TCL'
fconfigure stdout -buffering line
set PC /home/<user>/sar16_work/proj_paper_core
if {[catch {open_lib $PC/pnr/sar16_pnr_paper_core} e]} { puts "FAIL open_lib $e"; exit 0 }
puts "OK open_lib"
foreach pat {*TIEHI* *TIELO* *TIE*} {
    if {[catch {set c [get_lib_cells -quiet $pat]} e]} { puts "Q $pat ERR $e" ; continue }
    puts "Q $pat count=[sizeof_collection $c] names=[get_object_name $c]"
}
puts "--- are they used by the design? ---"
foreach pat {*TIEHI* *TIELO*} {
    if {[catch {set c [get_cells -hier -quiet $pat]} e]} { puts "U $pat ERR $e" ; continue }
    puts "U $pat used_in_design=[sizeof_collection $c]"
}
puts "F5_DONE"
exit 0
TCL
cd $PC || exit 1
stdbuf -oL -eL timeout 900 fc_shell -f $W/q.tcl > $W/q.log 2>&1
echo "rc=$?"
grep -a -E '^(OK|Q |U |FAIL|F5_DONE)' $W/q.log | head -20
echo "=== F5_DONE ==="
