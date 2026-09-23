#!/bin/bash
# F7 (fix step 2b): are the tie-off suspects actually ENABLED?  Read their current values.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/f7
rm -rf $W; mkdir -p $W
cat > $W/q.tcl <<'TCL'
fconfigure stdout -buffering line
set PC /home/<user>/sar16_work/proj_paper_core
if {[catch {open_lib $PC/pnr/sar16_pnr_paper_core} e]} { puts "FAIL open_lib $e"; exit 0 }
puts "OK open_lib"
foreach o {
    compile.flow.tie_unused_hier_inputs_to_constants
    compile.flow.tie_all_unused_hier_inputs_to_constants
    compile.seqmap.allow_tieoffs_for_registers
    compile.seqmap.allow_tieoffs_for_latches
    opt.tie_cell.max_fanout
    opt.tie_cell.add_to_highest_hierarchy
    route.common.tie_off_mode
} {
    if {[catch {get_app_options $o} v]} { puts "V $o -> ERR (no such option)" } else { puts "V $o -> $v" }
}
puts "--- which of these are NON-DEFAULT in this session? ---"
if {[catch {report_app_options -non_default *tie*} r]} { puts "ND ERR $r" } else { puts "ND $r" }
puts "F7_DONE"
exit 0
TCL
cd $PC || exit 1
stdbuf -oL -eL timeout 900 fc_shell -f $W/q.tcl > $W/q.log 2>&1
echo "rc=$?"
grep -a -E '^(OK|V |ND |FAIL|F7_DONE)' $W/q.log | head -20
echo "=== F7_DONE ==="
