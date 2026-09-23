#!/bin/bash
# F3 experiment: give the block its own abstract and see whether write_lef emits
# MACRO sar_digi_paper_core.  Uses the SAVED block, so no P&R re-run is needed.
PC=/home/<user>/sar16_work/proj_paper_core
cat > /tmp/f3.tcl <<'TCL'
set PNR /home/<user>/sar16_work/proj_paper_core/pnr
puts "F3-BEGIN"
if {[catch {open_lib $PNR/sar16_pnr_paper_core} m]} { puts "F3-LIB-FAIL $m"; exit 0 }
puts "F3-LIB-OK"
if {[catch {open_block sar16_route_paper_core} m]} { puts "F3-OPENBLOCK-FAIL $m"; exit 0 }
puts "F3-BLOCK=[get_object_name [current_block]]"
puts "F3-TERMS=[sizeof_collection [get_terminals -quiet *]]"

# baseline: what does write_lef -design give BEFORE create_abstract?
catch {write_lef -design sar_digi_paper_core /tmp/f3_before.lef}
if {[file exists /tmp/f3_before.lef]} {
    set fh [open /tmp/f3_before.lef r]; set t [read $fh]; close $fh
    puts "F3-BEFORE bytes=[file size /tmp/f3_before.lef] MACRO=[llength [regexp -all -inline {^MACRO } $t]] BLOCKMACRO=[llength [regexp -all -inline {^MACRO sar_digi_paper_core} $t]]"
}

# F3 attempt
if {[catch {create_abstract -blocks sar_digi_paper_core -target_use implementation} m]} {
    puts "F3-ABSTRACT-FAIL $m"
} else { puts "F3-ABSTRACT-OK" }

catch {write_lef -design sar_digi_paper_core /tmp/f3_after.lef}
if {[file exists /tmp/f3_after.lef]} {
    set fh [open /tmp/f3_after.lef r]; set t [read $fh]; close $fh
    puts "F3-AFTER bytes=[file size /tmp/f3_after.lef] MACRO=[llength [regexp -all -inline {^MACRO } $t]] BLOCKMACRO=[llength [regexp -all -inline {^MACRO sar_digi_paper_core} $t]] PIN=[llength [regexp -all -inline {\n  PIN } $t]]"
}
puts "F3-END"
exit 0
TCL
rm -f $PC/fc_f3.log
fc_shell -f /tmp/f3.tcl < /dev/null > $PC/fc_f3.log 2>&1
echo "log bytes: $(stat -c%s $PC/fc_f3.log)"
sed -n '/F3-BEGIN/,$p' $PC/fc_f3.log | head -40
echo
echo "=== lef results ==="
for f in /tmp/f3_before.lef /tmp/f3_after.lef; do
    if [ -f "$f" ]; then
        echo "--- $f  $(stat -c%s $f) B"
        grep -c '^MACRO' $f
        grep -c '^MACRO sar_digi_paper_core' $f
    else echo "--- $f  NOT WRITTEN"; fi
done
rm -f /tmp/f3.tcl
