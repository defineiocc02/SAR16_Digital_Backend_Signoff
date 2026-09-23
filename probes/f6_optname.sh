#!/bin/bash
# F6 (fix step 2a): find the EXACT tie-cell control in this FC version, instead of
# guessing the option name.  Every attempt is caught and printed.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/f6
rm -rf $W; mkdir -p $W
cat > $W/q.tcl <<'TCL'
fconfigure stdout -buffering line
set PC /home/<user>/sar16_work/proj_paper_core
if {[catch {open_lib $PC/pnr/sar16_pnr_paper_core} e]} { puts "FAIL open_lib $e"; exit 0 }
puts "OK open_lib"
puts "--- A. app options containing 'tie' ---"
foreach cmd {
    {get_app_options *tie*}
    {report_app_options -non_default *tie*}
    {list_app_options -pattern *tie*}
} {
    if {[catch {eval $cmd} r]} { puts "A TRY $cmd -> ERR $r" } else { puts "A TRY $cmd -> $r" }
}
puts "--- B. what does the tool say about connect_tie_cells / constant handling? ---"
foreach c {connect_tie_cells set_tie_cell} {
    if {[catch {help $c} r]} { puts "B $c -> ERR" } else { puts "B $c -> OK" }
}
puts "--- C. search the option space by prefix ---"
foreach pfx {opt.tie opt.common.tie opt.insert.tie place.tie} {
    if {[catch {get_app_options ${pfx}*} r]} { puts "C $pfx -> ERR $r" } else { puts "C $pfx -> $r" }
}
puts "F6_DONE"
exit 0
TCL
cd $PC || exit 1
stdbuf -oL -eL timeout 900 fc_shell -f $W/q.tcl > $W/q.log 2>&1
echo "rc=$?"
grep -a -E '^(OK|A |B |C |FAIL|F6_DONE)' $W/q.log | head -30
echo "=== F6_DONE ==="
