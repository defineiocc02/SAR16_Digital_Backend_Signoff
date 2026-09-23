#!/bin/bash
# Quantify the BOUNDARY hold requirement -- without touching the baseline SDC.
#
# All 39 hold violations are boundary paths (zero internal flop->flop at every
# corner).  They come from three PLACEHOLDER assumptions in the sign-off SDC:
#   DIG_IN_PORTS   set_input_delay  -min  0.5   (IO_MIN_FRAC 0.05)
#   calib_comp_out set_input_delay  -min  0.0
#   DIG_OUT_PORTS  set_output_delay -min -0.5
# The STA script already provides the sanctioned overlay hook (SDC_EXTRA), so the
# experiment states the assumptions in an overlay and re-measures.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
PNR=$PC/pnr
TOP=sar_digi_paper_core
W=/tmp/holdexp
rm -rf $W; mkdir -p $W

echo "=== snapshot the baseline reports so I can prove they are untouched ==="
md5sum $PNR/reports/sta/sta_pc_*_pc_hold.rpt > $W/before.md5
wc -l < $W/before.md5

cat > $W/ovl.sdc <<'SDC'
# Overlay: restate ONLY the three placeholder boundary hold assumptions.
# The base sign-off SDC is not modified in any way.
set_input_delay -clock clk -min 0.70 [get_ports {raw_bits_i[*] data_valid_i start_calib srm_start residue_consume_i}]
set_input_delay -clock clk -min 0.03 [get_ports calib_comp_out]
set_output_delay -clock clk -min -0.45 [get_ports {calib_done calib_done_pulse calib_mode_en calib_overrange calib_overrange_bits[*] raw_code_o[*] raw_code_valid_o w_wr_en w_wr_addr[*] w_wr_data[*] srm_busy srm_done srm_residue_valid srm_residue_o[*] srm_ones_count[*] srm_total_count[*] srm_count_shortfall srm_stalled}]
SDC
echo "=== overlay written ==="
cat $W/ovl.sdc | sed 's/^/   /'

echo
echo "=== does the STA script name its reports by TAG? ==="
grep -nE 'TAG' $PC/scripts/sta_pt_paper_core.tcl | head -6

echo
echo "############ re-measuring with the overlay ############"
for C in typical slow fast; do
    echo "## corner = $C"
    pt_shell -f $PC/scripts/sta_pt_paper_core.tcl \
             -x "set CORNER $C ; set TAG holdfix ; set PNR_TAG {} ; set DER_LATE 1.0 ; set DER_EARLY 1.0 ; set SDC_EXTRA $W/ovl.sdc" \
             -output_log_file "$W/sta_${C}.log" \
             > "$W/sta_${C}.stdout" 2>&1
    echo "   PT_RC=$?"
    grep -aE '^STA_RESULT|^STA_WORST_HOLD|^STA_DONE|sourcing constraint overlay' "$W/sta_${C}.stdout" | sed 's/^/   /'
done

echo
echo "=== baseline reports untouched? ==="
md5sum -c $W/before.md5 2>&1 | grep -c OK
echo "   (count of unchanged baseline hold reports; expect 5)"

echo
echo "=== any holdfix reports produced? ==="
ls -la $PNR/reports/sta/*holdfix* 2>/dev/null | head
