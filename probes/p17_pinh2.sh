#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
cat > /tmp/pinh2.tcl <<'TCL'
puts "H2-BEGIN"
puts "=== set_individual_pin_constraints -help ==="
set_individual_pin_constraints -help
puts "H2-MID"
puts "=== create_pin_guide -help ==="
create_pin_guide -help
puts "H2-MID2"
puts "=== set_block_pin_constraints -help ==="
set_block_pin_constraints -help
puts "H2-END"
exit 0
TCL
rm -f $PC/fc_pinh2.log
fc_shell -f /tmp/pinh2.tcl < /dev/null > $PC/fc_pinh2.log 2>&1
echo "log bytes: $(stat -c%s $PC/fc_pinh2.log)"
sed -n '/H2-BEGIN/,$p' $PC/fc_pinh2.log | head -90
rm -f /tmp/pinh2.tcl
