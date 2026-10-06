###############################################################################
# Created by write_sdc
# Tue Oct  6 13:46:38 2026
###############################################################################
current_design sar_digi_paper_core
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty -setup 0.2000 clk
set_clock_uncertainty -hold 0.0500 clk
set_propagated_clock [get_clocks {clk}]
create_clock -name dec_clk -period 3.0000 [get_ports {dec_clk}]
set_clock_transition 0.1000 [get_clocks {dec_clk}]
set_clock_uncertainty -setup 0.0600 dec_clk
set_clock_uncertainty -hold 0.0150 dec_clk
set_propagated_clock [get_clocks {dec_clk}]
set_clock_latency -source 0.0000 [get_clocks {clk}]
set_clock_latency -source 0.0000 [get_clocks {dec_clk}]
set_input_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_comp_out}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_comp_out}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {data_valid_i}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {data_valid_i}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[0]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[0]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[10]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[10]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[11]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[11]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[12]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[12]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[13]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[13]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[14]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[14]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[15]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[15]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[16]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[16]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[17]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[17]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[18]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[18]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[19]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[19]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[1]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[1]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[2]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[2]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[3]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[3]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[4]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[4]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[5]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[5]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[6]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[6]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[7]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[7]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[8]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[8]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_bits_i[9]}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_bits_i[9]}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {residue_consume_i}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {residue_consume_i}]
set_input_delay 0.1500 -clock [get_clocks {dec_clk}] -min -add_delay [get_ports {srm_decision_bit}]
set_input_delay 1.0500 -clock [get_clocks {dec_clk}] -max -add_delay [get_ports {srm_decision_bit}]
set_input_delay 0.1500 -clock [get_clocks {dec_clk}] -min -add_delay [get_ports {srm_decision_valid}]
set_input_delay 1.0500 -clock [get_clocks {dec_clk}] -max -add_delay [get_ports {srm_decision_valid}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_start}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_start}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {start_calib}]
set_input_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {start_calib}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_done}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_done}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_done_pulse}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_done_pulse}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_mode_en}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_mode_en}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[0]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[10]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[10]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[11]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[11]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[12]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[12]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[13]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[13]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[14]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[14]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[15]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[15]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[16]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[16]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[17]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[17]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[18]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[18]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[19]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[19]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[1]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[2]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[2]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[3]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[3]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[4]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[4]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[5]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[5]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[6]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[6]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[7]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[7]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[8]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[8]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {calib_overrange_bits[9]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {calib_overrange_bits[9]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[0]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[0]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[10]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[10]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[11]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[11]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[12]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[12]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[13]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[13]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[14]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[14]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[15]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[15]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[16]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[16]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[17]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[17]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[18]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[18]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[19]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[19]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[1]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[1]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[2]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[2]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[3]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[3]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[4]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[4]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[5]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[5]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[6]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[6]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[7]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[7]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[8]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[8]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_n_force[9]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_n_force[9]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[0]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[0]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[10]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[10]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[11]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[11]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[12]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[12]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[13]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[13]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[14]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[14]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[15]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[15]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[16]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[16]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[17]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[17]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[18]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[18]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[19]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[19]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[1]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[1]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[2]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[2]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[3]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[3]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[4]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[4]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[5]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[5]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[6]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[6]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[7]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[7]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[8]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[8]}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {dac_p_force[9]}]
set_output_delay 4.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {dac_p_force[9]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[0]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[10]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[10]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[11]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[11]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[12]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[12]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[13]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[13]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[14]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[14]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[15]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[15]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[16]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[16]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[17]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[17]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[18]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[18]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[19]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[19]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[1]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[2]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[2]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[3]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[3]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[4]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[4]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[5]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[5]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[6]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[6]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[7]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[7]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[8]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[8]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_o[9]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_o[9]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {raw_code_valid_o}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {raw_code_valid_o}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_busy}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_busy}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_count_shortfall}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_count_shortfall}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_done}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_done}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_ones_count[0]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_ones_count[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_ones_count[1]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_ones_count[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_ones_count[2]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_ones_count[2]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_ones_count[3]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_ones_count[3]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_ones_count[4]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_ones_count[4]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[0]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[1]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[2]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[2]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[3]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[3]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[4]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[4]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[5]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[5]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[6]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[6]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[7]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[7]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[8]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[8]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_o[9]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_o[9]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_residue_valid}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_residue_valid}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_stalled}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_stalled}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_total_count[0]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_total_count[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_total_count[1]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_total_count[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_total_count[2]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_total_count[2]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_total_count[3]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_total_count[3]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {srm_total_count[4]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {srm_total_count[4]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_addr[0]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_addr[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_addr[1]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_addr[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_addr[2]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_addr[2]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_addr[3]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_addr[3]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_addr[4]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_addr[4]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[0]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[0]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[10]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[10]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[11]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[11]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[12]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[12]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[13]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[13]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[14]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[14]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[15]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[15]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[16]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[16]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[17]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[17]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[18]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[18]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[19]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[19]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[1]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[1]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[20]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[20]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[21]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[21]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[22]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[22]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[23]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[23]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[24]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[24]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[25]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[25]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[26]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[26]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[27]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[27]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[28]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[28]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[29]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[29]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[2]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[2]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[3]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[3]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[4]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[4]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[5]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[5]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[6]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[6]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[7]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[7]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[8]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[8]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_data[9]}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_data[9]}]
set_output_delay -0.5000 -clock [get_clocks {clk}] -min -add_delay [get_ports {w_wr_en}]
set_output_delay 3.5000 -clock [get_clocks {clk}] -max -add_delay [get_ports {w_wr_en}]
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6100_}]\
    -to [get_pins {_6101_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6120_}]\
    -to [get_pins {_6179_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6121_}]\
    -to [get_pins {_6180_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6122_}]\
    -to [get_pins {_6181_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6123_}]\
    -to [get_pins {_6182_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6124_}]\
    -to [get_pins {_6183_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6125_}]\
    -to [get_pins {_6130_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6126_}]\
    -to [get_pins {_6131_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6127_}]\
    -to [get_pins {_6132_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6128_}]\
    -to [get_pins {_6133_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6129_}]\
    -to [get_pins {_6134_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6136_}]\
    -to [get_pins {_6112_/D}] 2.4000
set_max_delay -ignore_clock_latency\
    -from [get_cells {_6148_}]\
    -to [get_pins {_6185_/D}] 8.0000
set_false_path -hold\
    -from [get_cells {_6100_}]\
    -to [get_pins {_6101_/D}]
set_false_path -hold\
    -from [get_cells {_6120_}]\
    -to [get_pins {_6179_/D}]
set_false_path -hold\
    -from [get_cells {_6121_}]\
    -to [get_pins {_6180_/D}]
set_false_path -hold\
    -from [get_cells {_6122_}]\
    -to [get_pins {_6181_/D}]
set_false_path -hold\
    -from [get_cells {_6123_}]\
    -to [get_pins {_6182_/D}]
set_false_path -hold\
    -from [get_cells {_6124_}]\
    -to [get_pins {_6183_/D}]
set_false_path -hold\
    -from [get_cells {_6125_}]\
    -to [get_pins {_6130_/D}]
set_false_path -hold\
    -from [get_cells {_6126_}]\
    -to [get_pins {_6131_/D}]
set_false_path -hold\
    -from [get_cells {_6127_}]\
    -to [get_pins {_6132_/D}]
set_false_path -hold\
    -from [get_cells {_6128_}]\
    -to [get_pins {_6133_/D}]
set_false_path -hold\
    -from [get_cells {_6129_}]\
    -to [get_pins {_6134_/D}]
set_false_path -hold\
    -from [get_cells {_6136_}]\
    -to [get_pins {_6112_/D}]
set_false_path -hold\
    -from [get_cells {_6148_}]\
    -to [get_pins {_6185_/D}]
set_false_path\
    -from [get_ports {rst_n}]\
    -to [list [get_pins {_5350_/RESET_B}]\
           [get_pins {_5351_/RESET_B}]\
           [get_pins {_5352_/RESET_B}]\
           [get_pins {_5353_/RESET_B}]\
           [get_pins {_5354_/RESET_B}]\
           [get_pins {_5355_/RESET_B}]\
           [get_pins {_5356_/RESET_B}]\
           [get_pins {_5357_/RESET_B}]\
           [get_pins {_5358_/RESET_B}]\
           [get_pins {_5359_/RESET_B}]\
           [get_pins {_5360_/RESET_B}]\
           [get_pins {_5361_/RESET_B}]\
           [get_pins {_5362_/RESET_B}]\
           [get_pins {_5363_/RESET_B}]\
           [get_pins {_5364_/RESET_B}]\
           [get_pins {_5365_/RESET_B}]\
           [get_pins {_5366_/RESET_B}]\
           [get_pins {_5367_/RESET_B}]\
           [get_pins {_5368_/RESET_B}]\
           [get_pins {_5369_/RESET_B}]\
           [get_pins {_5370_/RESET_B}]\
           [get_pins {_5371_/RESET_B}]\
           [get_pins {_5372_/RESET_B}]\
           [get_pins {_5373_/RESET_B}]\
           [get_pins {_5374_/RESET_B}]\
           [get_pins {_5375_/RESET_B}]\
           [get_pins {_5376_/RESET_B}]\
           [get_pins {_5377_/RESET_B}]\
           [get_pins {_5378_/RESET_B}]\
           [get_pins {_5379_/RESET_B}]\
           [get_pins {_5380_/RESET_B}]\
           [get_pins {_5381_/RESET_B}]\
           [get_pins {_5382_/RESET_B}]\
           [get_pins {_5383_/RESET_B}]\
           [get_pins {_5384_/RESET_B}]\
           [get_pins {_5385_/RESET_B}]\
           [get_pins {_5386_/RESET_B}]\
           [get_pins {_5387_/RESET_B}]\
           [get_pins {_5388_/RESET_B}]\
           [get_pins {_5389_/RESET_B}]\
           [get_pins {_5390_/RESET_B}]\
           [get_pins {_5391_/RESET_B}]\
           [get_pins {_5392_/RESET_B}]\
           [get_pins {_5393_/RESET_B}]\
           [get_pins {_5394_/RESET_B}]\
           [get_pins {_5395_/RESET_B}]\
           [get_pins {_5396_/RESET_B}]\
           [get_pins {_5397_/RESET_B}]\
           [get_pins {_5398_/RESET_B}]\
           [get_pins {_5399_/RESET_B}]\
           [get_pins {_5400_/RESET_B}]\
           [get_pins {_5401_/RESET_B}]\
           [get_pins {_5402_/RESET_B}]\
           [get_pins {_5403_/RESET_B}]\
           [get_pins {_5404_/RESET_B}]\
           [get_pins {_5405_/RESET_B}]\
           [get_pins {_5406_/RESET_B}]\
           [get_pins {_5407_/RESET_B}]\
           [get_pins {_5408_/RESET_B}]\
           [get_pins {_5409_/RESET_B}]\
           [get_pins {_5410_/RESET_B}]\
           [get_pins {_5411_/RESET_B}]\
           [get_pins {_5412_/RESET_B}]\
           [get_pins {_5413_/RESET_B}]\
           [get_pins {_5414_/RESET_B}]\
           [get_pins {_5415_/RESET_B}]\
           [get_pins {_5416_/RESET_B}]\
           [get_pins {_5417_/RESET_B}]\
           [get_pins {_5418_/RESET_B}]\
           [get_pins {_5419_/RESET_B}]\
           [get_pins {_5420_/RESET_B}]\
           [get_pins {_5421_/RESET_B}]\
           [get_pins {_5422_/RESET_B}]\
           [get_pins {_5423_/RESET_B}]\
           [get_pins {_5424_/RESET_B}]\
           [get_pins {_5425_/RESET_B}]\
           [get_pins {_5426_/RESET_B}]\
           [get_pins {_5427_/RESET_B}]\
           [get_pins {_5428_/RESET_B}]\
           [get_pins {_5429_/RESET_B}]\
           [get_pins {_5430_/RESET_B}]\
           [get_pins {_5431_/RESET_B}]\
           [get_pins {_5432_/RESET_B}]\
           [get_pins {_5433_/RESET_B}]\
           [get_pins {_5434_/RESET_B}]\
           [get_pins {_5435_/RESET_B}]\
           [get_pins {_5436_/RESET_B}]\
           [get_pins {_5437_/RESET_B}]\
           [get_pins {_5438_/RESET_B}]\
           [get_pins {_5439_/RESET_B}]\
           [get_pins {_5440_/RESET_B}]\
           [get_pins {_5441_/RESET_B}]\
           [get_pins {_5442_/RESET_B}]\
           [get_pins {_5443_/RESET_B}]\
           [get_pins {_5444_/RESET_B}]\
           [get_pins {_5445_/RESET_B}]\
           [get_pins {_5446_/RESET_B}]\
           [get_pins {_5447_/RESET_B}]\
           [get_pins {_5448_/RESET_B}]\
           [get_pins {_5449_/RESET_B}]\
           [get_pins {_5450_/RESET_B}]\
           [get_pins {_5451_/RESET_B}]\
           [get_pins {_5452_/RESET_B}]\
           [get_pins {_5453_/RESET_B}]\
           [get_pins {_5454_/RESET_B}]\
           [get_pins {_5455_/RESET_B}]\
           [get_pins {_5456_/RESET_B}]\
           [get_pins {_5457_/RESET_B}]\
           [get_pins {_5458_/RESET_B}]\
           [get_pins {_5459_/RESET_B}]\
           [get_pins {_5460_/RESET_B}]\
           [get_pins {_5461_/RESET_B}]\
           [get_pins {_5462_/RESET_B}]\
           [get_pins {_5463_/RESET_B}]\
           [get_pins {_5464_/RESET_B}]\
           [get_pins {_5465_/RESET_B}]\
           [get_pins {_5466_/RESET_B}]\
           [get_pins {_5467_/RESET_B}]\
           [get_pins {_5468_/RESET_B}]\
           [get_pins {_5469_/RESET_B}]\
           [get_pins {_5470_/RESET_B}]\
           [get_pins {_5471_/RESET_B}]\
           [get_pins {_5472_/RESET_B}]\
           [get_pins {_5473_/RESET_B}]\
           [get_pins {_5474_/RESET_B}]\
           [get_pins {_5475_/RESET_B}]\
           [get_pins {_5476_/RESET_B}]\
           [get_pins {_5477_/RESET_B}]\
           [get_pins {_5478_/RESET_B}]\
           [get_pins {_5479_/RESET_B}]\
           [get_pins {_5480_/RESET_B}]\
           [get_pins {_5481_/RESET_B}]\
           [get_pins {_5482_/RESET_B}]\
           [get_pins {_5483_/RESET_B}]\
           [get_pins {_5484_/RESET_B}]\
           [get_pins {_5485_/RESET_B}]\
           [get_pins {_5486_/RESET_B}]\
           [get_pins {_5487_/RESET_B}]\
           [get_pins {_5488_/RESET_B}]\
           [get_pins {_5489_/RESET_B}]\
           [get_pins {_5490_/RESET_B}]\
           [get_pins {_5491_/RESET_B}]\
           [get_pins {_5492_/RESET_B}]\
           [get_pins {_5493_/RESET_B}]\
           [get_pins {_5494_/RESET_B}]\
           [get_pins {_5495_/RESET_B}]\
           [get_pins {_5496_/RESET_B}]\
           [get_pins {_5497_/RESET_B}]\
           [get_pins {_5498_/RESET_B}]\
           [get_pins {_5499_/RESET_B}]\
           [get_pins {_5500_/RESET_B}]\
           [get_pins {_5501_/RESET_B}]\
           [get_pins {_5502_/RESET_B}]\
           [get_pins {_5503_/RESET_B}]\
           [get_pins {_5504_/RESET_B}]\
           [get_pins {_5505_/RESET_B}]\
           [get_pins {_5506_/RESET_B}]\
           [get_pins {_5507_/RESET_B}]\
           [get_pins {_5508_/RESET_B}]\
           [get_pins {_5509_/RESET_B}]\
           [get_pins {_5510_/RESET_B}]\
           [get_pins {_5511_/RESET_B}]\
           [get_pins {_5512_/RESET_B}]\
           [get_pins {_5513_/RESET_B}]\
           [get_pins {_5514_/RESET_B}]\
           [get_pins {_5515_/RESET_B}]\
           [get_pins {_5516_/RESET_B}]\
           [get_pins {_5517_/RESET_B}]\
           [get_pins {_5518_/RESET_B}]\
           [get_pins {_5519_/RESET_B}]\
           [get_pins {_5520_/RESET_B}]\
           [get_pins {_5521_/RESET_B}]\
           [get_pins {_5522_/RESET_B}]\
           [get_pins {_5523_/RESET_B}]\
           [get_pins {_5524_/RESET_B}]\
           [get_pins {_5525_/RESET_B}]\
           [get_pins {_5526_/RESET_B}]\
           [get_pins {_5527_/RESET_B}]\
           [get_pins {_5528_/RESET_B}]\
           [get_pins {_5529_/RESET_B}]\
           [get_pins {_5530_/RESET_B}]\
           [get_pins {_5531_/RESET_B}]\
           [get_pins {_5532_/RESET_B}]\
           [get_pins {_5533_/RESET_B}]\
           [get_pins {_5534_/RESET_B}]\
           [get_pins {_5535_/RESET_B}]\
           [get_pins {_5536_/RESET_B}]\
           [get_pins {_5537_/RESET_B}]\
           [get_pins {_5538_/RESET_B}]\
           [get_pins {_5539_/RESET_B}]\
           [get_pins {_5540_/RESET_B}]\
           [get_pins {_5541_/RESET_B}]\
           [get_pins {_5542_/RESET_B}]\
           [get_pins {_5543_/RESET_B}]\
           [get_pins {_5544_/RESET_B}]\
           [get_pins {_5545_/RESET_B}]\
           [get_pins {_5546_/RESET_B}]\
           [get_pins {_5547_/RESET_B}]\
           [get_pins {_5548_/RESET_B}]\
           [get_pins {_5549_/RESET_B}]\
           [get_pins {_5550_/RESET_B}]\
           [get_pins {_5551_/RESET_B}]\
           [get_pins {_5552_/RESET_B}]\
           [get_pins {_5553_/RESET_B}]\
           [get_pins {_5554_/RESET_B}]\
           [get_pins {_5555_/RESET_B}]\
           [get_pins {_5556_/RESET_B}]\
           [get_pins {_5557_/RESET_B}]\
           [get_pins {_5558_/RESET_B}]\
           [get_pins {_5559_/RESET_B}]\
           [get_pins {_5560_/RESET_B}]\
           [get_pins {_5561_/RESET_B}]\
           [get_pins {_5562_/RESET_B}]\
           [get_pins {_5563_/RESET_B}]\
           [get_pins {_5564_/RESET_B}]\
           [get_pins {_5565_/RESET_B}]\
           [get_pins {_5566_/RESET_B}]\
           [get_pins {_5567_/RESET_B}]\
           [get_pins {_5568_/RESET_B}]\
           [get_pins {_5569_/RESET_B}]\
           [get_pins {_5570_/RESET_B}]\
           [get_pins {_5571_/RESET_B}]\
           [get_pins {_5572_/RESET_B}]\
           [get_pins {_5573_/RESET_B}]\
           [get_pins {_5574_/RESET_B}]\
           [get_pins {_5575_/RESET_B}]\
           [get_pins {_5576_/RESET_B}]\
           [get_pins {_5577_/RESET_B}]\
           [get_pins {_5578_/RESET_B}]\
           [get_pins {_5579_/RESET_B}]\
           [get_pins {_5580_/RESET_B}]\
           [get_pins {_5581_/RESET_B}]\
           [get_pins {_5582_/RESET_B}]\
           [get_pins {_5583_/RESET_B}]\
           [get_pins {_5584_/RESET_B}]\
           [get_pins {_5585_/RESET_B}]\
           [get_pins {_5586_/RESET_B}]\
           [get_pins {_5587_/RESET_B}]\
           [get_pins {_5588_/RESET_B}]\
           [get_pins {_5589_/RESET_B}]\
           [get_pins {_5590_/RESET_B}]\
           [get_pins {_5591_/RESET_B}]\
           [get_pins {_5592_/RESET_B}]\
           [get_pins {_5593_/RESET_B}]\
           [get_pins {_5594_/RESET_B}]\
           [get_pins {_5595_/RESET_B}]\
           [get_pins {_5596_/RESET_B}]\
           [get_pins {_5597_/RESET_B}]\
           [get_pins {_5598_/RESET_B}]\
           [get_pins {_5599_/RESET_B}]\
           [get_pins {_5600_/RESET_B}]\
           [get_pins {_5601_/RESET_B}]\
           [get_pins {_5602_/RESET_B}]\
           [get_pins {_5603_/RESET_B}]\
           [get_pins {_5604_/RESET_B}]\
           [get_pins {_5605_/RESET_B}]\
           [get_pins {_5606_/RESET_B}]\
           [get_pins {_5607_/RESET_B}]\
           [get_pins {_5608_/RESET_B}]\
           [get_pins {_5609_/RESET_B}]\
           [get_pins {_5610_/RESET_B}]\
           [get_pins {_5611_/RESET_B}]\
           [get_pins {_5612_/RESET_B}]\
           [get_pins {_5613_/RESET_B}]\
           [get_pins {_5614_/RESET_B}]\
           [get_pins {_5615_/RESET_B}]\
           [get_pins {_5616_/RESET_B}]\
           [get_pins {_5617_/RESET_B}]\
           [get_pins {_5618_/RESET_B}]\
           [get_pins {_5619_/RESET_B}]\
           [get_pins {_5620_/RESET_B}]\
           [get_pins {_5621_/RESET_B}]\
           [get_pins {_5622_/RESET_B}]\
           [get_pins {_5623_/RESET_B}]\
           [get_pins {_5624_/RESET_B}]\
           [get_pins {_5625_/RESET_B}]\
           [get_pins {_5626_/RESET_B}]\
           [get_pins {_5627_/RESET_B}]\
           [get_pins {_5628_/RESET_B}]\
           [get_pins {_5629_/RESET_B}]\
           [get_pins {_5630_/RESET_B}]\
           [get_pins {_5631_/RESET_B}]\
           [get_pins {_5632_/RESET_B}]\
           [get_pins {_5633_/RESET_B}]\
           [get_pins {_5634_/RESET_B}]\
           [get_pins {_5635_/RESET_B}]\
           [get_pins {_5636_/RESET_B}]\
           [get_pins {_5637_/RESET_B}]\
           [get_pins {_5638_/RESET_B}]\
           [get_pins {_5639_/RESET_B}]\
           [get_pins {_5640_/RESET_B}]\
           [get_pins {_5641_/RESET_B}]\
           [get_pins {_5642_/RESET_B}]\
           [get_pins {_5643_/RESET_B}]\
           [get_pins {_5644_/RESET_B}]\
           [get_pins {_5645_/RESET_B}]\
           [get_pins {_5646_/RESET_B}]\
           [get_pins {_5647_/RESET_B}]\
           [get_pins {_5648_/RESET_B}]\
           [get_pins {_5649_/RESET_B}]\
           [get_pins {_5650_/RESET_B}]\
           [get_pins {_5651_/RESET_B}]\
           [get_pins {_5652_/RESET_B}]\
           [get_pins {_5653_/RESET_B}]\
           [get_pins {_5654_/RESET_B}]\
           [get_pins {_5655_/RESET_B}]\
           [get_pins {_5656_/RESET_B}]\
           [get_pins {_5657_/RESET_B}]\
           [get_pins {_5658_/RESET_B}]\
           [get_pins {_5659_/RESET_B}]\
           [get_pins {_5660_/RESET_B}]\
           [get_pins {_5661_/RESET_B}]\
           [get_pins {_5662_/RESET_B}]\
           [get_pins {_5663_/RESET_B}]\
           [get_pins {_5664_/RESET_B}]\
           [get_pins {_5665_/RESET_B}]\
           [get_pins {_5666_/RESET_B}]\
           [get_pins {_5667_/RESET_B}]\
           [get_pins {_5668_/RESET_B}]\
           [get_pins {_5669_/RESET_B}]\
           [get_pins {_5670_/RESET_B}]\
           [get_pins {_5671_/RESET_B}]\
           [get_pins {_5672_/RESET_B}]\
           [get_pins {_5673_/RESET_B}]\
           [get_pins {_5674_/RESET_B}]\
           [get_pins {_5675_/RESET_B}]\
           [get_pins {_5676_/RESET_B}]\
           [get_pins {_5677_/RESET_B}]\
           [get_pins {_5678_/RESET_B}]\
           [get_pins {_5679_/RESET_B}]\
           [get_pins {_5680_/RESET_B}]\
           [get_pins {_5681_/RESET_B}]\
           [get_pins {_5682_/RESET_B}]\
           [get_pins {_5683_/RESET_B}]\
           [get_pins {_5684_/RESET_B}]\
           [get_pins {_5685_/RESET_B}]\
           [get_pins {_5686_/RESET_B}]\
           [get_pins {_5687_/RESET_B}]\
           [get_pins {_5688_/RESET_B}]\
           [get_pins {_5689_/RESET_B}]\
           [get_pins {_5690_/RESET_B}]\
           [get_pins {_5691_/RESET_B}]\
           [get_pins {_5692_/RESET_B}]\
           [get_pins {_5693_/RESET_B}]\
           [get_pins {_5694_/RESET_B}]\
           [get_pins {_5695_/RESET_B}]\
           [get_pins {_5696_/RESET_B}]\
           [get_pins {_5697_/RESET_B}]\
           [get_pins {_5698_/RESET_B}]\
           [get_pins {_5699_/RESET_B}]\
           [get_pins {_5700_/RESET_B}]\
           [get_pins {_5701_/RESET_B}]\
           [get_pins {_5702_/RESET_B}]\
           [get_pins {_5703_/RESET_B}]\
           [get_pins {_5704_/RESET_B}]\
           [get_pins {_5705_/RESET_B}]\
           [get_pins {_5706_/RESET_B}]\
           [get_pins {_5707_/RESET_B}]\
           [get_pins {_5708_/RESET_B}]\
           [get_pins {_5709_/RESET_B}]\
           [get_pins {_5710_/RESET_B}]\
           [get_pins {_5711_/RESET_B}]\
           [get_pins {_5712_/RESET_B}]\
           [get_pins {_5713_/RESET_B}]\
           [get_pins {_5714_/RESET_B}]\
           [get_pins {_5715_/RESET_B}]\
           [get_pins {_5716_/RESET_B}]\
           [get_pins {_5717_/RESET_B}]\
           [get_pins {_5718_/RESET_B}]\
           [get_pins {_5719_/RESET_B}]\
           [get_pins {_5720_/RESET_B}]\
           [get_pins {_5721_/RESET_B}]\
           [get_pins {_5722_/RESET_B}]\
           [get_pins {_5723_/RESET_B}]\
           [get_pins {_5724_/RESET_B}]\
           [get_pins {_5725_/RESET_B}]\
           [get_pins {_5726_/RESET_B}]\
           [get_pins {_5727_/RESET_B}]\
           [get_pins {_5728_/RESET_B}]\
           [get_pins {_5729_/RESET_B}]\
           [get_pins {_5730_/RESET_B}]\
           [get_pins {_5731_/RESET_B}]\
           [get_pins {_5732_/RESET_B}]\
           [get_pins {_5733_/RESET_B}]\
           [get_pins {_5734_/RESET_B}]\
           [get_pins {_5735_/RESET_B}]\
           [get_pins {_5736_/RESET_B}]\
           [get_pins {_5737_/RESET_B}]\
           [get_pins {_5738_/RESET_B}]\
           [get_pins {_5739_/RESET_B}]\
           [get_pins {_5740_/RESET_B}]\
           [get_pins {_5741_/RESET_B}]\
           [get_pins {_5742_/RESET_B}]\
           [get_pins {_5743_/RESET_B}]\
           [get_pins {_5744_/RESET_B}]\
           [get_pins {_5745_/RESET_B}]\
           [get_pins {_5746_/RESET_B}]\
           [get_pins {_5747_/RESET_B}]\
           [get_pins {_5748_/RESET_B}]\
           [get_pins {_5749_/RESET_B}]\
           [get_pins {_5750_/RESET_B}]\
           [get_pins {_5751_/RESET_B}]\
           [get_pins {_5752_/RESET_B}]\
           [get_pins {_5753_/RESET_B}]\
           [get_pins {_5754_/RESET_B}]\
           [get_pins {_5755_/RESET_B}]\
           [get_pins {_5756_/RESET_B}]\
           [get_pins {_5757_/RESET_B}]\
           [get_pins {_5758_/RESET_B}]\
           [get_pins {_5759_/RESET_B}]\
           [get_pins {_5760_/RESET_B}]\
           [get_pins {_5761_/RESET_B}]\
           [get_pins {_5762_/RESET_B}]\
           [get_pins {_5763_/RESET_B}]\
           [get_pins {_5764_/RESET_B}]\
           [get_pins {_5765_/RESET_B}]\
           [get_pins {_5766_/RESET_B}]\
           [get_pins {_5767_/RESET_B}]\
           [get_pins {_5768_/RESET_B}]\
           [get_pins {_5769_/RESET_B}]\
           [get_pins {_5770_/RESET_B}]\
           [get_pins {_5771_/RESET_B}]\
           [get_pins {_5772_/RESET_B}]\
           [get_pins {_5773_/RESET_B}]\
           [get_pins {_5774_/RESET_B}]\
           [get_pins {_5775_/RESET_B}]\
           [get_pins {_5776_/RESET_B}]\
           [get_pins {_5777_/RESET_B}]\
           [get_pins {_5778_/RESET_B}]\
           [get_pins {_5779_/RESET_B}]\
           [get_pins {_5780_/RESET_B}]\
           [get_pins {_5781_/RESET_B}]\
           [get_pins {_5782_/RESET_B}]\
           [get_pins {_5783_/RESET_B}]\
           [get_pins {_5784_/RESET_B}]\
           [get_pins {_5785_/RESET_B}]\
           [get_pins {_5786_/RESET_B}]\
           [get_pins {_5787_/RESET_B}]\
           [get_pins {_5788_/RESET_B}]\
           [get_pins {_5789_/RESET_B}]\
           [get_pins {_5790_/RESET_B}]\
           [get_pins {_5791_/RESET_B}]\
           [get_pins {_5792_/RESET_B}]\
           [get_pins {_5793_/RESET_B}]\
           [get_pins {_5794_/RESET_B}]\
           [get_pins {_5795_/RESET_B}]\
           [get_pins {_5796_/RESET_B}]\
           [get_pins {_5797_/RESET_B}]\
           [get_pins {_5798_/RESET_B}]\
           [get_pins {_5799_/RESET_B}]\
           [get_pins {_5800_/RESET_B}]\
           [get_pins {_5801_/RESET_B}]\
           [get_pins {_5802_/RESET_B}]\
           [get_pins {_5803_/RESET_B}]\
           [get_pins {_5804_/RESET_B}]\
           [get_pins {_5805_/RESET_B}]\
           [get_pins {_5806_/RESET_B}]\
           [get_pins {_5807_/RESET_B}]\
           [get_pins {_5808_/RESET_B}]\
           [get_pins {_5809_/RESET_B}]\
           [get_pins {_5810_/RESET_B}]\
           [get_pins {_5811_/RESET_B}]\
           [get_pins {_5812_/RESET_B}]\
           [get_pins {_5813_/RESET_B}]\
           [get_pins {_5814_/RESET_B}]\
           [get_pins {_5815_/RESET_B}]\
           [get_pins {_5816_/RESET_B}]\
           [get_pins {_5817_/RESET_B}]\
           [get_pins {_5818_/RESET_B}]\
           [get_pins {_5819_/RESET_B}]\
           [get_pins {_5820_/RESET_B}]\
           [get_pins {_5821_/RESET_B}]\
           [get_pins {_5822_/RESET_B}]\
           [get_pins {_5823_/RESET_B}]\
           [get_pins {_5824_/RESET_B}]\
           [get_pins {_5825_/RESET_B}]\
           [get_pins {_5826_/RESET_B}]\
           [get_pins {_5827_/RESET_B}]\
           [get_pins {_5828_/RESET_B}]\
           [get_pins {_5829_/RESET_B}]\
           [get_pins {_5830_/RESET_B}]\
           [get_pins {_5831_/RESET_B}]\
           [get_pins {_5832_/RESET_B}]\
           [get_pins {_5833_/RESET_B}]\
           [get_pins {_5834_/RESET_B}]\
           [get_pins {_5835_/RESET_B}]\
           [get_pins {_5836_/RESET_B}]\
           [get_pins {_5837_/RESET_B}]\
           [get_pins {_5838_/RESET_B}]\
           [get_pins {_5839_/RESET_B}]\
           [get_pins {_5840_/RESET_B}]\
           [get_pins {_5841_/RESET_B}]\
           [get_pins {_5842_/RESET_B}]\
           [get_pins {_5843_/RESET_B}]\
           [get_pins {_5844_/RESET_B}]\
           [get_pins {_5845_/RESET_B}]\
           [get_pins {_5846_/RESET_B}]\
           [get_pins {_5847_/RESET_B}]\
           [get_pins {_5848_/RESET_B}]\
           [get_pins {_5849_/RESET_B}]\
           [get_pins {_5850_/RESET_B}]\
           [get_pins {_5851_/RESET_B}]\
           [get_pins {_5852_/RESET_B}]\
           [get_pins {_5853_/RESET_B}]\
           [get_pins {_5854_/RESET_B}]\
           [get_pins {_5855_/RESET_B}]\
           [get_pins {_5856_/RESET_B}]\
           [get_pins {_5857_/RESET_B}]\
           [get_pins {_5858_/RESET_B}]\
           [get_pins {_5859_/RESET_B}]\
           [get_pins {_5860_/RESET_B}]\
           [get_pins {_5861_/RESET_B}]\
           [get_pins {_5862_/RESET_B}]\
           [get_pins {_5863_/RESET_B}]\
           [get_pins {_5864_/RESET_B}]\
           [get_pins {_5865_/RESET_B}]\
           [get_pins {_5866_/RESET_B}]\
           [get_pins {_5867_/RESET_B}]\
           [get_pins {_5868_/RESET_B}]\
           [get_pins {_5869_/RESET_B}]\
           [get_pins {_5870_/RESET_B}]\
           [get_pins {_5871_/RESET_B}]\
           [get_pins {_5872_/RESET_B}]\
           [get_pins {_5873_/RESET_B}]\
           [get_pins {_5874_/RESET_B}]\
           [get_pins {_5875_/RESET_B}]\
           [get_pins {_5876_/RESET_B}]\
           [get_pins {_5877_/RESET_B}]\
           [get_pins {_5878_/RESET_B}]\
           [get_pins {_5879_/RESET_B}]\
           [get_pins {_5880_/RESET_B}]\
           [get_pins {_5881_/RESET_B}]\
           [get_pins {_5882_/RESET_B}]\
           [get_pins {_5883_/RESET_B}]\
           [get_pins {_5884_/RESET_B}]\
           [get_pins {_5885_/RESET_B}]\
           [get_pins {_5886_/RESET_B}]\
           [get_pins {_5887_/RESET_B}]\
           [get_pins {_5888_/RESET_B}]\
           [get_pins {_5889_/RESET_B}]\
           [get_pins {_5890_/RESET_B}]\
           [get_pins {_5891_/RESET_B}]\
           [get_pins {_5892_/RESET_B}]\
           [get_pins {_5893_/RESET_B}]\
           [get_pins {_5894_/RESET_B}]\
           [get_pins {_5895_/RESET_B}]\
           [get_pins {_5896_/RESET_B}]\
           [get_pins {_5897_/RESET_B}]\
           [get_pins {_5898_/RESET_B}]\
           [get_pins {_5899_/RESET_B}]\
           [get_pins {_5900_/RESET_B}]\
           [get_pins {_5901_/RESET_B}]\
           [get_pins {_5902_/RESET_B}]\
           [get_pins {_5903_/RESET_B}]\
           [get_pins {_5904_/RESET_B}]\
           [get_pins {_5905_/RESET_B}]\
           [get_pins {_5906_/RESET_B}]\
           [get_pins {_5907_/RESET_B}]\
           [get_pins {_5908_/RESET_B}]\
           [get_pins {_5909_/RESET_B}]\
           [get_pins {_5910_/RESET_B}]\
           [get_pins {_5911_/RESET_B}]\
           [get_pins {_5912_/RESET_B}]\
           [get_pins {_5913_/RESET_B}]\
           [get_pins {_5914_/RESET_B}]\
           [get_pins {_5915_/RESET_B}]\
           [get_pins {_5916_/RESET_B}]\
           [get_pins {_5917_/RESET_B}]\
           [get_pins {_5918_/RESET_B}]\
           [get_pins {_5919_/RESET_B}]\
           [get_pins {_5920_/RESET_B}]\
           [get_pins {_5921_/RESET_B}]\
           [get_pins {_5922_/RESET_B}]\
           [get_pins {_5923_/RESET_B}]\
           [get_pins {_5924_/RESET_B}]\
           [get_pins {_5925_/RESET_B}]\
           [get_pins {_5926_/RESET_B}]\
           [get_pins {_5927_/RESET_B}]\
           [get_pins {_5928_/RESET_B}]\
           [get_pins {_5929_/RESET_B}]\
           [get_pins {_5930_/RESET_B}]\
           [get_pins {_5931_/RESET_B}]\
           [get_pins {_5932_/RESET_B}]\
           [get_pins {_5933_/RESET_B}]\
           [get_pins {_5934_/RESET_B}]\
           [get_pins {_5935_/RESET_B}]\
           [get_pins {_5936_/RESET_B}]\
           [get_pins {_5937_/RESET_B}]\
           [get_pins {_5938_/RESET_B}]\
           [get_pins {_5939_/RESET_B}]\
           [get_pins {_5940_/RESET_B}]\
           [get_pins {_5941_/RESET_B}]\
           [get_pins {_5942_/RESET_B}]\
           [get_pins {_5943_/RESET_B}]\
           [get_pins {_5944_/RESET_B}]\
           [get_pins {_5945_/RESET_B}]\
           [get_pins {_5946_/RESET_B}]\
           [get_pins {_5947_/RESET_B}]\
           [get_pins {_5948_/RESET_B}]\
           [get_pins {_5949_/RESET_B}]\
           [get_pins {_5950_/RESET_B}]\
           [get_pins {_5951_/RESET_B}]\
           [get_pins {_5952_/RESET_B}]\
           [get_pins {_5953_/RESET_B}]\
           [get_pins {_5954_/RESET_B}]\
           [get_pins {_5955_/RESET_B}]\
           [get_pins {_5956_/RESET_B}]\
           [get_pins {_5957_/RESET_B}]\
           [get_pins {_5958_/RESET_B}]\
           [get_pins {_5959_/RESET_B}]\
           [get_pins {_5960_/RESET_B}]\
           [get_pins {_5961_/RESET_B}]\
           [get_pins {_5962_/RESET_B}]\
           [get_pins {_5963_/RESET_B}]\
           [get_pins {_5964_/RESET_B}]\
           [get_pins {_5965_/RESET_B}]\
           [get_pins {_5966_/RESET_B}]\
           [get_pins {_5967_/RESET_B}]\
           [get_pins {_5968_/RESET_B}]\
           [get_pins {_5969_/RESET_B}]\
           [get_pins {_5970_/RESET_B}]\
           [get_pins {_5971_/RESET_B}]\
           [get_pins {_5972_/RESET_B}]\
           [get_pins {_5973_/RESET_B}]\
           [get_pins {_5974_/RESET_B}]\
           [get_pins {_5975_/RESET_B}]\
           [get_pins {_5976_/RESET_B}]\
           [get_pins {_5977_/RESET_B}]\
           [get_pins {_5978_/RESET_B}]\
           [get_pins {_5979_/RESET_B}]\
           [get_pins {_5980_/RESET_B}]\
           [get_pins {_5981_/RESET_B}]\
           [get_pins {_5982_/RESET_B}]\
           [get_pins {_5983_/RESET_B}]\
           [get_pins {_5984_/RESET_B}]\
           [get_pins {_5985_/RESET_B}]\
           [get_pins {_5986_/RESET_B}]\
           [get_pins {_5987_/RESET_B}]\
           [get_pins {_5988_/RESET_B}]\
           [get_pins {_5989_/RESET_B}]\
           [get_pins {_5990_/RESET_B}]\
           [get_pins {_5991_/RESET_B}]\
           [get_pins {_5992_/RESET_B}]\
           [get_pins {_5993_/RESET_B}]\
           [get_pins {_5994_/RESET_B}]\
           [get_pins {_5995_/RESET_B}]\
           [get_pins {_5996_/RESET_B}]\
           [get_pins {_5997_/RESET_B}]\
           [get_pins {_5998_/RESET_B}]\
           [get_pins {_5999_/RESET_B}]\
           [get_pins {_6000_/RESET_B}]\
           [get_pins {_6001_/RESET_B}]\
           [get_pins {_6002_/RESET_B}]\
           [get_pins {_6003_/RESET_B}]\
           [get_pins {_6004_/RESET_B}]\
           [get_pins {_6005_/RESET_B}]\
           [get_pins {_6006_/RESET_B}]\
           [get_pins {_6007_/RESET_B}]\
           [get_pins {_6008_/RESET_B}]\
           [get_pins {_6009_/RESET_B}]\
           [get_pins {_6010_/RESET_B}]\
           [get_pins {_6011_/RESET_B}]\
           [get_pins {_6012_/RESET_B}]\
           [get_pins {_6013_/RESET_B}]\
           [get_pins {_6014_/RESET_B}]\
           [get_pins {_6015_/RESET_B}]\
           [get_pins {_6016_/RESET_B}]\
           [get_pins {_6017_/RESET_B}]\
           [get_pins {_6018_/RESET_B}]\
           [get_pins {_6019_/RESET_B}]\
           [get_pins {_6020_/RESET_B}]\
           [get_pins {_6021_/RESET_B}]\
           [get_pins {_6022_/RESET_B}]\
           [get_pins {_6023_/RESET_B}]\
           [get_pins {_6024_/RESET_B}]\
           [get_pins {_6025_/RESET_B}]\
           [get_pins {_6026_/RESET_B}]\
           [get_pins {_6027_/RESET_B}]\
           [get_pins {_6028_/RESET_B}]\
           [get_pins {_6029_/RESET_B}]\
           [get_pins {_6030_/RESET_B}]\
           [get_pins {_6031_/RESET_B}]\
           [get_pins {_6032_/RESET_B}]\
           [get_pins {_6033_/RESET_B}]\
           [get_pins {_6034_/RESET_B}]\
           [get_pins {_6035_/RESET_B}]\
           [get_pins {_6036_/RESET_B}]\
           [get_pins {_6037_/RESET_B}]\
           [get_pins {_6038_/RESET_B}]\
           [get_pins {_6045_/RESET_B}]\
           [get_pins {_6046_/RESET_B}]\
           [get_pins {_6047_/RESET_B}]\
           [get_pins {_6048_/RESET_B}]\
           [get_pins {_6049_/RESET_B}]\
           [get_pins {_6050_/RESET_B}]\
           [get_pins {_6051_/RESET_B}]\
           [get_pins {_6052_/RESET_B}]\
           [get_pins {_6053_/RESET_B}]\
           [get_pins {_6054_/RESET_B}]\
           [get_pins {_6055_/RESET_B}]\
           [get_pins {_6056_/RESET_B}]\
           [get_pins {_6057_/RESET_B}]\
           [get_pins {_6058_/RESET_B}]\
           [get_pins {_6059_/RESET_B}]\
           [get_pins {_6060_/RESET_B}]\
           [get_pins {_6061_/RESET_B}]\
           [get_pins {_6062_/RESET_B}]\
           [get_pins {_6063_/RESET_B}]\
           [get_pins {_6064_/RESET_B}]\
           [get_pins {_6065_/RESET_B}]\
           [get_pins {_6066_/RESET_B}]\
           [get_pins {_6067_/RESET_B}]\
           [get_pins {_6068_/RESET_B}]\
           [get_pins {_6069_/RESET_B}]\
           [get_pins {_6070_/RESET_B}]\
           [get_pins {_6071_/RESET_B}]\
           [get_pins {_6072_/RESET_B}]\
           [get_pins {_6073_/RESET_B}]\
           [get_pins {_6074_/RESET_B}]\
           [get_pins {_6075_/RESET_B}]\
           [get_pins {_6076_/RESET_B}]\
           [get_pins {_6077_/RESET_B}]\
           [get_pins {_6078_/RESET_B}]\
           [get_pins {_6079_/RESET_B}]\
           [get_pins {_6080_/RESET_B}]\
           [get_pins {_6081_/RESET_B}]\
           [get_pins {_6082_/RESET_B}]\
           [get_pins {_6083_/RESET_B}]\
           [get_pins {_6084_/RESET_B}]\
           [get_pins {_6085_/RESET_B}]\
           [get_pins {_6088_/RESET_B}]\
           [get_pins {_6089_/RESET_B}]\
           [get_pins {_6090_/RESET_B}]\
           [get_pins {_6091_/RESET_B}]\
           [get_pins {_6092_/RESET_B}]\
           [get_pins {_6093_/RESET_B}]\
           [get_pins {_6094_/RESET_B}]\
           [get_pins {_6095_/RESET_B}]\
           [get_pins {_6098_/RESET_B}]\
           [get_pins {_6099_/RESET_B}]\
           [get_pins {_6184_/RESET_B}]\
           [get_pins {_6191_/RESET_B}]\
           [get_pins {_6193_/RESET_B}]\
           [get_pins {_6194_/RESET_B}]\
           [get_pins {_6195_/RESET_B}]]
###############################################################################
# Environment
###############################################################################
set_load -pin_load -rise -max 0.0500 [get_ports {calib_done}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_done}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_done_pulse}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_done_pulse}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_mode_en}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_mode_en}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_valid_o}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_valid_o}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_busy}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_busy}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_count_shortfall}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_count_shortfall}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_done}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_done}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_valid}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_valid}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_stalled}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_stalled}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_en}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_en}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[19]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[19]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[18]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[18]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[17]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[17]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[16]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[16]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[15]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[15]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[14]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[14]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[13]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[13]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[12]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[12]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[11]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[11]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[10]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[10]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[9]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[9]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[8]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[8]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[7]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[7]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[6]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[6]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[5]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[5]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {calib_overrange_bits[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {calib_overrange_bits[0]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[19]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[19]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[18]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[18]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[17]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[17]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[16]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[16]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[15]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[15]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[14]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[14]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[13]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[13]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[12]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[12]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[11]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[11]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[10]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[10]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[9]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[9]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[8]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[8]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[7]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[7]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[6]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[6]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[5]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[5]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_n_force[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_n_force[0]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[19]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[19]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[18]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[18]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[17]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[17]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[16]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[16]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[15]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[15]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[14]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[14]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[13]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[13]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[12]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[12]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[11]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[11]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[10]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[10]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[9]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[9]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[8]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[8]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[7]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[7]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[6]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[6]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[5]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[5]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {dac_p_force[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {dac_p_force[0]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[19]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[19]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[18]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[18]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[17]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[17]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[16]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[16]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[15]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[15]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[14]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[14]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[13]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[13]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[12]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[12]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[11]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[11]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[10]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[10]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[9]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[9]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[8]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[8]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[7]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[7]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[6]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[6]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[5]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[5]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {raw_code_o[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {raw_code_o[0]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_ones_count[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_ones_count[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_ones_count[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_ones_count[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_ones_count[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_ones_count[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_ones_count[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_ones_count[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_ones_count[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_ones_count[0]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[9]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[9]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[8]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[8]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[7]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[7]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[6]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[6]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[5]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[5]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_residue_o[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_residue_o[0]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_total_count[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_total_count[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_total_count[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_total_count[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_total_count[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_total_count[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_total_count[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_total_count[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {srm_total_count[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {srm_total_count[0]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_addr[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_addr[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_addr[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_addr[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_addr[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_addr[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_addr[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_addr[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_addr[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_addr[0]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[29]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[29]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[28]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[28]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[27]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[27]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[26]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[26]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[25]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[25]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[24]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[24]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[23]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[23]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[22]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[22]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[21]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[21]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[20]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[20]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[19]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[19]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[18]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[18]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[17]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[17]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[16]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[16]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[15]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[15]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[14]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[14]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[13]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[13]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[12]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[12]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[11]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[11]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[10]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[10]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[9]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[9]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[8]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[8]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[7]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[7]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[6]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[6]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[5]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[5]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[4]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[4]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[3]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[3]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[2]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[2]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[1]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[1]}]
set_load -pin_load -rise -max 0.0500 [get_ports {w_wr_data[0]}]
set_load -pin_load -fall -max 0.0500 [get_ports {w_wr_data[0]}]
set_input_transition -min 0.0000 [get_ports {calib_comp_out}]
set_input_transition -max 0.2000 [get_ports {calib_comp_out}]
set_input_transition -min 0.0000 [get_ports {data_valid_i}]
set_input_transition -max 0.2000 [get_ports {data_valid_i}]
set_input_transition -min 0.0000 [get_ports {residue_consume_i}]
set_input_transition -max 0.2000 [get_ports {residue_consume_i}]
set_input_transition -min 0.0000 [get_ports {rst_n}]
set_input_transition -max 0.2000 [get_ports {rst_n}]
set_input_transition -min 0.0000 [get_ports {srm_decision_bit}]
set_input_transition -max 0.2000 [get_ports {srm_decision_bit}]
set_input_transition -min 0.0000 [get_ports {srm_decision_valid}]
set_input_transition -max 0.2000 [get_ports {srm_decision_valid}]
set_input_transition -min 0.0000 [get_ports {srm_start}]
set_input_transition -max 0.2000 [get_ports {srm_start}]
set_input_transition -min 0.0000 [get_ports {start_calib}]
set_input_transition -max 0.2000 [get_ports {start_calib}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[19]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[19]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[18]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[18]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[17]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[17]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[16]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[16]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[15]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[15]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[14]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[14]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[13]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[13]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[12]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[12]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[11]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[11]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[10]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[10]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[9]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[9]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[8]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[8]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[7]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[7]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[6]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[6]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[5]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[5]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[4]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[4]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[3]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[3]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[2]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[2]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[1]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[1]}]
set_input_transition -min 0.0000 [get_ports {raw_bits_i[0]}]
set_input_transition -max 0.2000 [get_ports {raw_bits_i[0]}]
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.8000 [current_design]
set_max_fanout 24.0000 [current_design]
