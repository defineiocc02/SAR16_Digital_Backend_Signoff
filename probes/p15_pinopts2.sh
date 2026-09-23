#!/bin/bash
# Correct invocation this time: this release rejects -no_gui (CMD-010).
PC=/home/<user>/sar16_work/proj_paper_core
T=/tmp/pinprobe3.tcl
cat > $T <<'TCL'
puts "PINPROBE-BEGIN"
foreach c {place_pins set_pin_physical_constraints set_individual_pin_constraints \
           create_pin_guide edit_pin set_block_pin_constraints remove_pin_guide \
           set_pin_constraints create_boundary set_keepout_margin set_pnet_options \
           create_abstract write_lef_abstract} {
    puts [format "  %-34s %s" $c [expr {[llength [info commands $c]] > 0 ? "EXISTS" : "absent"}]]
}
puts "--- bogus-arg usage strings ---"
foreach c {place_pins set_pin_physical_constraints edit_pin create_abstract} {
    if {[catch {$c -zzzbogus} u]} { puts "USAGE[$c]: $u" } else { puts "USAGE[$c]: (no error raised)" }
}
puts "PINPROBE-END"
exit 0
TCL
rm -f $PC/fc_pinprobe3.log
fc_shell -f $T > $PC/fc_pinprobe3.log 2>&1
echo "log bytes: $(stat -c%s $PC/fc_pinprobe3.log)"
echo
echo "=== existence table ==="
grep -a 'EXISTS\|absent' $PC/fc_pinprobe3.log | head -20
echo
echo "=== usage strings ==="
grep -a 'USAGE\[' $PC/fc_pinprobe3.log | head -10
echo
echo "=== did it reach the end? (proves the probe itself ran) ==="
grep -ac 'PINPROBE-BEGIN' $PC/fc_pinprobe3.log
grep -ac 'PINPROBE-END' $PC/fc_pinprobe3.log
rm -f /tmp/pinprobe3.tcl
