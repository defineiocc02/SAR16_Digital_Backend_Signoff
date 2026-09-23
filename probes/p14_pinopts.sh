#!/bin/bash
# Probe the pin-placement controls of this FC release.  The run is finished, so
# a short fc_shell invocation cannot steal a licence from anything.
PC=/home/<user>/sar16_work/proj_paper_core
T=/tmp/pinprobe2.tcl
cat > $T <<'TCL'
puts "PINPROBE-BEGIN"
foreach c {place_pins set_pin_physical_constraints set_individual_pin_constraints \
           create_pin_guide edit_pin set_block_pin_constraints remove_pin_guide \
           set_pin_constraints create_boundary set_keepout_margin set_pnet_options} {
    puts [format "  %-34s %s" $c [expr {[llength [info commands $c]] > 0 ? "EXISTS" : "absent"}]]
}
puts "--- bogus-arg usage strings ---"
foreach c {place_pins set_pin_physical_constraints edit_pin} {
    if {[catch {$c -zzzbogus} u]} { puts "USAGE[$c]: $u" } else { puts "USAGE[$c]: (no error)" }
}
puts "PINPROBE-END"
exit 0
TCL
rm -f $PC/fc_pinprobe2.log
fc_shell -no_gui -f $T > $PC/fc_pinprobe2.log 2>&1
echo "log bytes: $(stat -c%s $PC/fc_pinprobe2.log)"
echo "=== existence table ==="
grep -a 'EXISTS\|absent' $PC/fc_pinprobe2.log | head -15
echo
echo "=== usage strings ==="
grep -a 'USAGE\[' $PC/fc_pinprobe2.log | head -8
echo
echo "=== man place_pins (goes to stdout) ==="
man place_pins 2>&1 | head -45
rm -f /tmp/pinprobe2.tcl
