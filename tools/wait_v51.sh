#!/bin/bash
# Wait for the v5.1 reproduce run, then report the decisive numbers.
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/logs/repro_v51.log
for i in $(seq 1 120); do
    if grep -q 'REPRO status=' "$L" 2>/dev/null; then break; fi
    sleep 10
done

echo "############ v5.1 FLOW DONE ############"
echo
echo "=== stage markers ==="
grep -nE '### STAGE|DC_ARM|FC_RC|DRC_RC|STA_DONE|REPRO status' "$L" | tail -20
echo
echo "=== the pin constraint line actually present in the script? ==="
grep -n 'stacking_allowed' "$PC/scripts/fc_pnr_paper_core.tcl"
grep -an 'set_block_pin_constraints' "$L" | head -5
echo
echo "=== did place_pins still place all pins? ==="
grep -anE 'Number of block ports|Number of pins created|place_pins' "$PC/logs/fc_pnr.log" | tail -8
echo
echo "=== result env ==="
grep -E 'dc_area_typical|delivered_gds_bytes|delivered_gds_md5|die_|drc_results|lvs_verdict|fc_util|sta_(typical|slow|fast)_clk_slack' "$PC/reports/RESULT_CURRENT.env"
echo
echo "=== shorts now ==="
grep -ac '^SHORT' "$PC/calibre/lvs/lvs.rep.shorts"
grep -a '^SHORT' "$PC/calibre/lvs/lvs.rep.shorts"
echo
echo "=== LVS object counts ==="
sed -n '/INITIAL NUMBERS OF OBJECTS/,/Total Inst/p' "$PC/calibre/lvs/lvs.rep" | head -14
echo
echo "=== stash artifacts for local analysis ==="
mkdir -p /tmp/handover51
cp -p "$PC/calibre/sar_digi_paper_core_merged.gds" /tmp/handover51/ 2>/dev/null
cp -p "$PC/calibre/lvs/lvs.rep.shorts"                /tmp/handover51/ 2>/dev/null
cp -p "$PC/calibre/lvs/svdb/sar_digi_paper_core.sp"   /tmp/handover51/ 2>/dev/null
cp -p "$PC/calibre/lvs/sar16.cdl"                     /tmp/handover51/ 2>/dev/null
ls -la /tmp/handover51/
echo "WAITER_DONE"
