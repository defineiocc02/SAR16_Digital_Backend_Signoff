#!/bin/bash
# F4 (fix step 1, decisive): the library HAS TIEHI/TIELO, so FC's warning means the NDM
# does not expose them (or does not mark them as tie cells).  Ask FC directly.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/f4
rm -rf $W; mkdir -p $W

cat > $W/q.tcl <<'TCL'
fconfigure stdout -buffering line
set PC /home/<user>/sar16_work/proj_paper_core
proc step {label script} {
    if {[catch {uplevel #0 $script} e]} { puts "FAIL $label -> $e" ; flush stdout ; return 0 }
    puts "OK   $label" ; flush stdout ; return 1
}
puts "S1 open the design library (brings in the reference NDM)"
step open_lib "open_lib $PC/pnr/sar16_pnr_paper_core"
puts "S2 which libraries are known"
if {[catch {get_libs -quiet} r]} { puts "Q get_libs ERR $r" } else { puts "Q get_libs -> $r" }
puts "S3 any tie / constant cells in any library?"
foreach pat {*TIE* *tie* *CONST* *TIELO* *TIEHI*} {
    if {[catch {get_lib_cells -quiet $pat} r]} { puts "Q $pat ERR $r" } else { puts "Q $pat -> $r" }
}
puts "S4 the app options that control tie-cell handling"
foreach opt {opt.tie_cell.enable opt.common.tie_cell opt.tie_cell.tie_high_lib_cell} {
    if {[catch {get_app_options -quiet $opt} r]} { puts "OPT $opt -> (not present)" } else { puts "OPT $opt -> $r" }
}
puts "F4_DONE"
exit 0
TCL

cd $PC || exit 1
stdbuf -oL -eL timeout 900 fc_shell -f $W/q.tcl > $W/q.log 2>&1
echo "fc_shell rc=$?  log bytes=$(stat -c%s $W/q.log)"
echo "--- filtered ---"
grep -a -E '^(S[0-9]|OK|FAIL|Q |OPT |F4_DONE)' $W/q.log | head -30
echo "--- warnings about tie ---"
grep -a -i -E 'tie|constant' $W/q.log | head -10
echo "=== F4_DONE ==="
