#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
cat > /tmp/wv2.tcl <<'TCL'
set PNR /home/<user>/sar16_work/proj_paper_core/pnr
puts "WV-BEGIN"
catch {open_lib $PNR/sar16_pnr_paper_core}
catch {open_block sar16_route_paper_core}
puts "CURRENT=[get_object_name [current_block]]"
puts "TERMS=[sizeof_collection [get_terminals -quiet *]]"

puts "--- variant 1: baseline (no -include) ---"
if {[catch {write_lef -design sar_digi_paper_core /tmp/v1.lef} m]} { puts "V1-FAIL $m" } else { puts "V1-OK" }

puts "--- variant 2: -include cell ---"
if {[catch {write_lef -design sar_digi_paper_core -include cell /tmp/v2.lef} m]} { puts "V2-FAIL $m" } else { puts "V2-OK" }

puts "--- variant 3: -include {cell tech} ---"
if {[catch {write_lef -design sar_digi_paper_core -include {cell tech} /tmp/v3.lef} m]} { puts "V3-FAIL $m" } else { puts "V3-OK" }

puts "--- variant 4: -include tech ---"
if {[catch {write_lef -design sar_digi_paper_core -include tech /tmp/v4.lef} m]} { puts "V4-FAIL $m" } else { puts "V4-OK" }

puts "--- variant 5: block as -design, no tech ---"
if {[catch {write_lef -design sar16_route_paper_core -include cell /tmp/v5.lef} m]} { puts "V5-FAIL $m" } else { puts "V5-OK" }

puts "--- variant 6: -library current ---"
if {[catch {write_lef -library sar16_pnr_paper_core -include cell /tmp/v6.lef} m]} { puts "V6-FAIL $m" } else { puts "V6-OK" }
puts "WV-END"
exit 0
TCL
rm -f $PC/fc_wv2.log
fc_shell -f /tmp/wv2.tcl < /dev/null > $PC/fc_wv2.log 2>&1
grep -aE 'WV-BEGIN|CURRENT=|TERMS=|V[0-9]-(OK|FAIL)|WV-END' $PC/fc_wv2.log | head -20
echo
echo "=== census each written lef ==="
for f in /tmp/v1.lef /tmp/v2.lef /tmp/v3.lef /tmp/v4.lef /tmp/v5.lef /tmp/v6.lef; do
    if [ -f "$f" ]; then
        printf "   %-10s %8s B  MACRO=%-5s blockMACRO=%-3s PIN=%s\n" "$(basename $f)" \
          "$(stat -c%s $f)" "$(grep -c '^MACRO' $f)" "$(grep -c '^MACRO sar_digi_paper_core' $f)" "$(grep -c '^  PIN' $f)"
    else printf "   %-10s NOT WRITTEN\n" "$(basename $f)"; fi
done
rm -f /tmp/wv2.tcl
echo
echo "=== kit test progress ==="
wc -l $PC/kitcheck/kit_lvs_results.csv 2>/dev/null
