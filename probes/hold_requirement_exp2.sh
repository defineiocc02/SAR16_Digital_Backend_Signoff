#!/bin/bash
# Tighten the overlay until hold is clean, to state the boundary requirement exactly.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/holdexp

cat > $W/ovl2.sdc <<'SDC'
set_input_delay  -clock clk -min 0.72 [get_ports {raw_bits_i[*] data_valid_i start_calib srm_start residue_consume_i}]
set_input_delay  -clock clk -min 0.04 [get_ports calib_comp_out]
set_output_delay -clock clk -min -0.44 [get_ports {calib_done calib_done_pulse calib_mode_en calib_overrange calib_overrange_bits[*] raw_code_o[*] raw_code_valid_o w_wr_en w_wr_addr[*] w_wr_data[*] srm_busy srm_done srm_residue_valid srm_residue_o[*] srm_ones_count[*] srm_total_count[*] srm_count_shortfall srm_stalled}]
SDC

echo "=== variant 2: input -min 0.72 / comp 0.04 / output -min -0.44 ==="
for C in typical slow fast; do
    pt_shell -f $PC/scripts/sta_pt_paper_core.tcl \
             -x "set CORNER $C ; set TAG hf2 ; set PNR_TAG {} ; set DER_LATE 1.0 ; set DER_EARLY 1.0 ; set SDC_EXTRA $W/ovl2.sdc" \
             -output_log_file "$W/sta2_${C}.log" > "$W/sta2_${C}.stdout" 2>&1
    printf "   %-8s PT_RC=%s\n" "$C" "$?"
    grep -aE '^STA_RESULT|^STA_WORST_HOLD' "$W/sta2_${C}.stdout" | sed 's/^/      /'
done

echo
echo "=== and a clearly generous pair, to show the trend and give margin ==="
cat > $W/ovl3.sdc <<'SDC'
set_input_delay  -clock clk -min 0.80 [get_ports {raw_bits_i[*] data_valid_i start_calib srm_start residue_consume_i}]
set_input_delay  -clock clk -min 0.10 [get_ports calib_comp_out]
set_output_delay -clock clk -min -0.40 [get_ports {calib_done calib_done_pulse calib_mode_en calib_overrange calib_overrange_bits[*] raw_code_o[*] raw_code_valid_o w_wr_en w_wr_addr[*] w_wr_data[*] srm_busy srm_done srm_residue_valid srm_residue_o[*] srm_ones_count[*] srm_total_count[*] srm_count_shortfall srm_stalled}]
SDC
for C in typical slow fast; do
    pt_shell -f $PC/scripts/sta_pt_paper_core.tcl \
             -x "set CORNER $C ; set TAG hf3 ; set PNR_TAG {} ; set DER_LATE 1.0 ; set DER_EARLY 1.0 ; set SDC_EXTRA $W/ovl3.sdc" \
             -output_log_file "$W/sta3_${C}.log" > "$W/sta3_${C}.stdout" 2>&1
    printf "   %-8s PT_RC=%s\n" "$C" "$?"
    grep -aE '^STA_RESULT' "$W/sta3_${C}.stdout" | sed 's/^/      /'
done

echo
echo "=== setup must be untouched by a hold-only change ==="
for C in typical slow fast; do
    printf "   %-8s " "$C"; grep -aE '^STA_RESULT' $W/sta2_${C}.stdout | sed 's/.*viol_setup=\([0-9]*\).*wns_setup=\([-\d.]*\).*/setup viol=\1 wns=\2/'
done

echo
echo "=== baseline reports still untouched ==="
md5sum -c $W/before.md5 2>&1 | grep -c OK
