#!/bin/bash
# Probe: how does the deck associate labels with nets, and what pin-placement
# controls does this release actually offer?
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/calibre/lvs

echo "########## A. deck: layer map + TEXT handling ##########"
grep -nE 'LAYER MAP|TEXT|PORT|LABEL' $L/mylvs.lvs | head -40

echo
echo "########## B. what layer is the pin text drawn on in the delivered GDS ##########"
echo "   (extraction report said layer 62 'M2' and 63 'M3' for the pin labels)"
grep -nE 'LAYER 6[0-9]|6[0-9] +[A-Z]' $L/mylvs.lvs | head -20

echo
echo "########## C. place_pins usage in THIS release ##########"
man place_pins 2>&1 | head -70

echo
echo "########## D. pin-related commands that exist ##########"
cat > /tmp/pinprobe.tcl <<'TCL'
puts "PINPROBE-BEGIN"
foreach c {place_pins set_pin_physical_constraints create_pin_guide set_individual_pin_constraints \
           edit_pin create_boundary set_block_pin_constraints remove_pin_guide set_pin_constraints} {
    puts [format "  %-34s %s" $c [expr {[llength [info commands $c]] > 0 ? "EXISTS" : "absent"}]]
}
puts "PINPROBE-END"
exit 0
TCL
echo "--- fc_shell command existence ---"
fc_shell -no_gui -f /tmp/pinprobe.tcl 2>&1 | grep -a 'PINPROBE\|  [a-z_]' | head -20
