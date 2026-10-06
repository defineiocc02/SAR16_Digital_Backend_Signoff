# Signal-flow-aware edge plan. All are movable IO slots on the selected edge.
# Calibration controls and raw sampling enter west; digital exports exit east.
set_io_pin_constraint -pin_names {clk rst_n start_calib calib_comp_out data_valid_i raw_bits_i[*]} -region left:*
set_io_pin_constraint -pin_names {dac_p_force[*] dac_n_force[*]} -region top:*
set_io_pin_constraint -pin_names {w_wr_en w_wr_addr[*] w_wr_data[*] calib_done calib_done_pulse calib_mode_en calib_overrange calib_overrange_bits[*] raw_code_o[*] raw_code_valid_o} -region right:*
# The faster decision domain and SRM handshake stay physically near south edge.
set_io_pin_constraint -pin_names {dec_clk srm_start srm_decision_valid srm_decision_bit residue_consume_i srm_busy srm_done srm_residue_valid srm_residue_o[*] srm_ones_count[*] srm_total_count[*] srm_count_shortfall srm_stalled} -region bottom:*
