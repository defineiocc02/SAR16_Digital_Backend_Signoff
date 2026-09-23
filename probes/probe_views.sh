#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
echo "=== view directories physically present in the library ==="
find $PC/pnr/sar16_pnr_paper_core -maxdepth 2 | head -30
echo
cat > /tmp/lv.tcl <<'TCL'
set PNR /home/<user>/sar16_work/proj_paper_core/pnr
puts "LV-BEGIN"
catch {open_lib $PNR/sar16_pnr_paper_core}
foreach c {get_blocks get_designs get_views get_libs current_lib} {
    puts [format "  %-14s %s" $c [expr {[llength [info commands $c]] > 0 ? "EXISTS" : "absent"}]]
}
puts "LIBS: [get_object_name [current_lib]]"
if {[llength [info commands get_blocks]]} {
    puts "BLOCKS: [get_object_name [get_blocks -quiet *]]"
}
if {[llength [info commands get_designs]]} {
    puts "DESIGNS: [get_object_name [get_designs -quiet *]]"
}
if {[llength [info commands get_views]]} {
    catch {puts "VIEWS(sar_digi_paper_core): [get_object_name [get_views -quiet -of_objects [get_designs -quiet sar_digi_paper_core]]]"}
    catch {puts "VIEWS(route): [get_object_name [get_views -quiet -of_objects [get_designs -quiet sar16_route_paper_core]]]"}
}
puts "LV-END"
exit 0
TCL
rm -f $PC/fc_lv.log
fc_shell -f /tmp/lv.tcl < /dev/null > $PC/fc_lv.log 2>&1
sed -n '/LV-BEGIN/,/LV-END/p' $PC/fc_lv.log | grep -aE 'LV-|EXISTS|absent|LIBS:|BLOCKS:|DESIGNS:|VIEWS' | head -20
rm -f /tmp/lv.tcl
echo
echo "=== kit test progress ==="
wc -l $PC/kitcheck/kit_lvs_results.csv 2>/dev/null
tail -2 /tmp/ka.out 2>/dev/null
