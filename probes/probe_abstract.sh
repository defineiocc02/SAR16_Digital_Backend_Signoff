#!/bin/bash
# Which abstract / writer commands does this release actually have?
# (fc_shell keeps reading stdin after an error, so feed it /dev/null.)
PC=/home/<user>/sar16_work/proj_paper_core
cat > /tmp/ab.tcl <<'TCL'
puts "AB-BEGIN"
foreach c {create_abstract write_lef_abstract write_lef write_def write_gds \
           write_verilog write_block_summary create_boundary remove_boundary \
           set_boundary create_abstract_model abstract_model} {
    puts [format "  %-26s %s" $c [expr {[llength [info commands $c]] > 0 ? "EXISTS" : "absent"}]]
}
puts "AB-MID"
puts "=== create_abstract -help ==="
create_abstract -help
puts "AB-END"
exit 0
TCL
rm -f $PC/fc_ab.log
fc_shell -f /tmp/ab.tcl < /dev/null > $PC/fc_ab.log 2>&1
echo "log bytes: $(stat -c%s $PC/fc_ab.log)"
sed -n '/AB-BEGIN/,$p' $PC/fc_ab.log | head -60
rm -f /tmp/ab.tcl
