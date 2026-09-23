#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
cat > /tmp/wv.tcl <<'TCL'
set PNR /home/<user>/sar16_work/proj_paper_core/pnr
puts "WV-BEGIN"
catch {open_lib $PNR/sar16_pnr_paper_core}
puts "--- blocks in the library ---"
catch {puts "BLOCKS: [get_blocks -quiet *]"}
puts "--- views of our block ---"
catch {puts "VIEWS: [get_views -quiet -of_objects [get_blocks -quiet sar_digi_paper_core]]"}
catch {open_block sar16_route_paper_core}
puts "CURRENT=[get_object_name [current_block]]"

foreach v {
    {"baseline"        {write_lef -design sar_digi_paper_core /tmp/v1.lef}}
    {"-include cell"   {write_lef -design sar_digi_paper_core -include cell /tmp/v2.lef}}
    {"-include c,t"    {write_lef -design sar_digi_paper_core -include {cell tech} /tmp/v3.lef}}
    {"-include tech"   {write_lef -design sar_digi_paper_core -include tech /tmp/v4.lef}}
} {
    set lbl [lindex $v 0]; set sc [lindex $v 1]
    if {[catch {uplevel 1 $sc} m]} { puts "WV-FAIL $lbl -> $m" } else { puts "WV-OK   $lbl" }
}
puts "WV-END"
exit 0
TCL
rm -f $PC/fc_wv.log
fc_shell -f /tmp/wv.tcl < /dev/null > $PC/fc_wv.log 2>&1
sed -n '/WV-BEGIN/,/WV-END/p' $PC/fc_wv.log | grep -aE 'WV-|BLOCKS|VIEWS|CURRENT|FAIL' | head -25
echo
echo "=== census each written lef ==="
for f in /tmp/v1.lef /tmp/v2.lef /tmp/v3.lef /tmp/v4.lef; do
    if [ -f "$f" ]; then
        b=$(stat -c%s $f)
        m=$(grep -c '^MACRO' $f)
        bm=$(grep -c '^MACRO sar_digi_paper_core' $f)
        p=$(grep -c '^  PIN' $f)
        printf "   %-14s %8s B  MACRO=%-5s blockMACRO=%-3s PIN=%s\n" "$(basename $f)" "$b" "$m" "$bm" "$p"
    else printf "   %-14s NOT WRITTEN\n" "$(basename $f)"; fi
done
rm -f /tmp/wv.tcl
echo
echo "=== kit test progress ==="
wc -l $PC/kitcheck/kit_lvs_results.csv 2>/dev/null
