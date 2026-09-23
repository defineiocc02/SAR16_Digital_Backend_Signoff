#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
cat > /tmp/wl.tcl <<'TCL'
puts "WL-BEGIN"
write_lef -help
puts "WL-END"
exit 0
TCL
rm -f $PC/fc_wl.log
fc_shell -f /tmp/wl.tcl < /dev/null > $PC/fc_wl.log 2>&1
sed -n '/WL-BEGIN/,/WL-END/p' $PC/fc_wl.log | head -70
rm -f /tmp/wl.tcl
echo
echo "=== kit consistency test progress ==="
wc -l $PC/kitcheck/kit_lvs_results.csv 2>/dev/null
tail -3 /tmp/ka.out 2>/dev/null
