#!/bin/bash
K=/home/<user>/Project/DESIGN/14BIT_ADC/smic18
STD_CDL=$K/digital/sc/lvs_netlist/smic18.cdl
echo "=== kit CDL: do the mismatching names exist as .SUBCKT? ==="
for n in _sdw2v _sup2v _pdw2v _pup2v _pmp2b _nand2b _invv _smn2b _smp2b _bitcoreb _mx2v; do
    c=$(grep -ci "^[[:space:]]*\.SUBCKT[[:space:]]\+$n\b" $STD_CDL)
    printf "   %-12s %s\n" "$n" "$c"
done
echo
echo "=== how many .SUBCKT in the kit CDL, and their naming style ==="
grep -ci '^[[:space:]]*\.subckt' $STD_CDL
grep -i '^[[:space:]]*\.subckt' $STD_CDL | head -12
echo
echo "=== does the source netlist (v2lvs output) use those names? ==="
grep -c 'X.*_sdw2v\|_sdw2v' /home/<user>/sar16_work/proj_paper_core/calibre/lvs/sar16.cdl
grep -o '_sdw2v\|_sup2v\|_pmp2b\|_nand2b' /home/<user>/sar16_work/proj_paper_core/calibre/lvs/sar16.cdl | sort | uniq -c
echo
echo "=== what the extracted layout netlist calls them ==="
grep -o '_sdw2v\|_sup2v\|_pmp2b\|_nand2b\|_invv' /home/<user>/sar16_work/proj_paper_core/calibre/lvs/svdb/sar_digi_paper_core.sp | sort | uniq -c | head
