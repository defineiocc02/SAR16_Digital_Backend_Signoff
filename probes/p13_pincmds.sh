#!/bin/bash
# Which pin-placement controls does THIS release actually have?
PC=/home/<user>/sar16_work/proj_paper_core
cat > /tmp/pinprobe.tcl <<'TCL'
puts "PINPROBE-BEGIN"
foreach c {place_pins set_pin_physical_constraints set_individual_pin_constraints \
           create_pin_guide edit_pin set_block_pin_constraints remove_pin_guide \
           set_pin_constraints create_boundary set_keepout_margin} {
    puts [format "  %-34s %s" $c [expr {[llength [info commands $c]] > 0 ? "EXISTS" : "absent"}]]
}
puts "--- usage: place_pins -zzzbogus ---"
if {[catch {place_pins -zzzbogus} u]} { puts "  $u" }
puts "--- usage: set_pin_physical_constraints -zzzbogus ---"
if {[catch {set_pin_physical_constraints -zzzbogus} u]} { puts "  $u" }
puts "PINPROBE-END"
exit 0
TCL
rm -f $PC/fc_pinprobe.log
fc_shell -no_gui -f /tmp/pinprobe.tcl > $PC/fc_pinprobe.log 2>&1
grep -a 'PINPROBE\|EXISTS\|absent\|usage\|  -' $PC/fc_pinprobe.log | head -40
echo
echo "=== also: how does the current script call place_pins? ==="
grep -n 'place_pins' -A4 -B2 $PC/scripts/fc_pnr_paper_core.tcl
echo
echo "=== and what layers does the block use for pins now? ==="
grep -anE 'pin|layer.*METAL' $PC/scripts/fc_pnr_paper_core.tcl | sed -n '1,40p'
