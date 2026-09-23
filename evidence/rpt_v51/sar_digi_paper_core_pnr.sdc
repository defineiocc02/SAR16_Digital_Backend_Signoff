################################################################################
#
# Design name:  sar_digi_paper_core
#
# Created by fc write_sdc on Fri Sep 18 20:24:16 2026
#
################################################################################

set sdc_version 2.1
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA

################################################################################
#
# Units
# time_unit               : 1e-09
# resistance_unit         : 1000
# capacitive_load_unit    : 1e-12
# voltage_unit            : 1
# current_unit            : 0.001
# power_unit              : 1e-12
################################################################################


# Mode: default
# Corner: default
# Scenario: default

# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 62; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 74
create_clock -name clk -period 10 -waveform {0 5} [get_ports {clk}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 64; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 75
create_clock -name dec_clk -period 3 -waveform {0 1.5} [get_ports {dec_clk}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 85
set_clock_groups -name clk_domains -asynchronous -group [get_clocks {clk}] \
    -group [get_clocks {dec_clk}]
set_propagated_clock [get_clocks {clk}]
set_propagated_clock [get_clocks {dec_clk}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 88
set_false_path -from [get_ports {rst_n}]
set_load -max -pin_load 0.05 [get_ports {calib_done}]
set_load -max -pin_load 0.05 [get_ports {calib_done_pulse}]
set_load -max -pin_load 0.05 [get_ports {calib_mode_en}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[19]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[18]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[17]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[16]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[15]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[14]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[13]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[12]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[11]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[10]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[9]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[8]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[7]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[6]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[5]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[4]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[3]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[2]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[1]}]
set_load -max -pin_load 0.05 [get_ports {dac_p_force[0]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[19]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[18]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[17]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[16]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[15]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[14]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[13]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[12]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[11]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[10]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[9]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[8]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[7]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[6]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[5]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[4]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[3]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[2]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[1]}]
set_load -max -pin_load 0.05 [get_ports {dac_n_force[0]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[19]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[18]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[17]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[16]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[15]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[14]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[13]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[12]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[11]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[10]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[9]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[8]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[7]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[6]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[5]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[4]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[3]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[2]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[1]}]
set_load -max -pin_load 0.05 [get_ports {calib_overrange_bits[0]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[19]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[18]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[17]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[16]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[15]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[14]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[13]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[12]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[11]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[10]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[9]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[8]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[7]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[6]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[5]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[4]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[3]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[2]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[1]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_o[0]}]
set_load -max -pin_load 0.05 [get_ports {raw_code_valid_o}]
set_load -max -pin_load 0.05 [get_ports {w_wr_en}]
set_load -max -pin_load 0.05 [get_ports {w_wr_addr[4]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_addr[3]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_addr[2]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_addr[1]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_addr[0]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[29]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[28]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[27]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[26]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[25]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[24]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[23]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[22]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[21]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[20]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[19]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[18]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[17]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[16]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[15]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[14]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[13]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[12]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[11]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[10]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[9]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[8]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[7]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[6]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[5]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[4]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[3]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[2]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[1]}]
set_load -max -pin_load 0.05 [get_ports {w_wr_data[0]}]
set_load -max -pin_load 0.05 [get_ports {srm_busy}]
set_load -max -pin_load 0.05 [get_ports {srm_done}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_valid}]
set_load -max -pin_load 0.05 [get_ports {srm_ones_count[4]}]
set_load -max -pin_load 0.05 [get_ports {srm_ones_count[3]}]
set_load -max -pin_load 0.05 [get_ports {srm_ones_count[2]}]
set_load -max -pin_load 0.05 [get_ports {srm_ones_count[1]}]
set_load -max -pin_load 0.05 [get_ports {srm_ones_count[0]}]
set_load -max -pin_load 0.05 [get_ports {srm_total_count[4]}]
set_load -max -pin_load 0.05 [get_ports {srm_total_count[3]}]
set_load -max -pin_load 0.05 [get_ports {srm_total_count[2]}]
set_load -max -pin_load 0.05 [get_ports {srm_total_count[1]}]
set_load -max -pin_load 0.05 [get_ports {srm_total_count[0]}]
set_load -max -pin_load 0.05 [get_ports {srm_count_shortfall}]
set_load -max -pin_load 0.05 [get_ports {srm_stalled}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[9]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[8]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[7]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[6]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[5]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[4]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[3]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[2]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[1]}]
set_load -max -pin_load 0.05 [get_ports {srm_residue_o[0]}]
# Warning: Libcell power domain derates are skipped!

set_clock_latency -source 0 [get_clocks {clk}]
set_clock_latency -source 0 [get_clocks {dec_clk}]
# Set latency for io paths.
# -origin useful_skew
set_clock_latency -rise 0.476952 [get_clocks {clk}]
# -origin useful_skew
set_clock_latency -fall 0.100441 [get_clocks {clk}]
# -origin useful_skew
set_clock_latency -rise 0.245485 [get_clocks {dec_clk}]
# -origin useful_skew
set_clock_latency -fall 0.22192 [get_clocks {dec_clk}]
# Set propagated on clock sources to avoid removing latency for IO paths.
set_propagated_clock  [get_ports {clk}]
set_propagated_clock  [get_ports {dec_clk}]
set_clock_uncertainty -setup 0.2 [get_clocks {clk}]
set_clock_uncertainty -hold 0.05 [get_clocks {clk}]
set_clock_uncertainty -setup 0.06 [get_clocks {dec_clk}]
set_clock_uncertainty -hold 0.015 [get_clocks {dec_clk}]
set_clock_transition 0.15 [get_clocks {clk}]
set_clock_transition 0.1 [get_clocks {dec_clk}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {rst_n}]
set_input_transition -max 0.2 [get_ports {rst_n}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {start_calib}]
set_input_transition -max 0.2 [get_ports {start_calib}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {calib_comp_out}]
set_input_transition -max 0.2 [get_ports {calib_comp_out}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {data_valid_i}]
set_input_transition -max 0.2 [get_ports {data_valid_i}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[19]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[19]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[18]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[18]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[17]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[17]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[16]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[16]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[15]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[15]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[14]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[14]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[13]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[13]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[12]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[12]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[11]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[11]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[10]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[10]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[9]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[9]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[8]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[8]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[7]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[7]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[6]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[6]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[5]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[5]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[4]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[3]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[2]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[1]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {raw_bits_i[0]}]
set_input_transition -max 0.2 [get_ports {raw_bits_i[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {srm_start}]
set_input_transition -max 0.2 [get_ports {srm_start}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {srm_decision_valid}]
set_input_transition -max 0.2 [get_ports {srm_decision_valid}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {srm_decision_bit}]
set_input_transition -max 0.2 [get_ports {srm_decision_bit}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 114; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 116
set_input_transition -min 0 [get_ports {residue_consume_i}]
set_input_transition -max 0.2 [get_ports {residue_consume_i}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {start_calib}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {start_calib}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 110; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 111
set_input_delay -clock [get_clocks {clk}] -min 0 [get_ports {calib_comp_out}]
set_input_delay -clock [get_clocks {clk}] -max 1 [get_ports {calib_comp_out}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {calib_done}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {calib_done}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_done_pulse}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_done_pulse}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {calib_mode_en}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {calib_mode_en}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[19]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[19]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[18]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[18]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[17]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[17]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[16]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[16]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[15]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[15]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[14]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[14]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[13]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[13]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[12]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[12]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[11]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[11]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[10]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_p_force[10]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[9]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[9]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[8]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[8]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[7]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[7]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[6]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[6]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[5]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[5]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[4]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[3]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[2]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[1]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_p_force[0]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_p_force[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[19]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[19]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[18]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[18]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[17]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[17]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[16]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[16]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[15]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[15]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[14]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[14]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[13]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[13]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[12]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[12]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[11]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[11]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[10]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports \
    {dac_n_force[10]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[9]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[9]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[8]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[8]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[7]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[7]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[6]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[6]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[5]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[5]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[4]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[3]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[2]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[1]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 146; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 148
set_output_delay -clock [get_clocks {clk}] -min 0 [get_ports {dac_n_force[0]}]
set_output_delay -clock [get_clocks {clk}] -max 4.5 [get_ports {dac_n_force[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[19]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[19]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[18]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[18]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[17]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[17]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[16]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[16]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[15]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[15]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[14]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[14]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[13]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[13]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[12]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[12]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[11]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[11]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[10]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[10]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[9]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[9]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[8]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[8]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[7]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[7]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[6]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[6]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[5]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[5]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[4]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[3]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[2]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[1]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {calib_overrange_bits[0]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {calib_overrange_bits[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {data_valid_i}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {data_valid_i}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[19]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[19]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[18]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[18]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[17]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[17]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[16]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[16]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[15]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[15]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[14]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[14]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[13]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[13]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[12]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[12]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[11]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[11]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[10]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[10]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[9]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[9]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[8]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[8]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[7]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[7]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[6]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[6]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[5]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[5]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[4]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[3]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[2]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[1]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {raw_bits_i[0]}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_bits_i[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[19]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[19]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[18]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[18]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[17]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[17]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[16]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[16]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[15]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[15]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[14]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[14]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[13]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[13]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[12]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[12]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[11]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[11]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_o[10]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[10]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[9]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[9]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[8]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[8]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[7]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[7]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[6]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[6]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[5]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[5]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[4]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[3]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[2]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[1]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {raw_code_o[0]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {raw_code_o[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {raw_code_valid_o}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {raw_code_valid_o}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_en}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_en}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_addr[4]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_addr[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_addr[3]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_addr[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_addr[2]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_addr[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_addr[1]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_addr[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_addr[0]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_addr[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[29]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[29]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[28]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[28]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[27]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[27]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[26]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[26]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[25]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[25]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[24]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[24]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[23]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[23]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[22]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[22]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[21]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[21]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[20]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[20]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[19]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[19]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[18]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[18]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[17]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[17]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[16]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[16]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[15]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[15]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[14]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[14]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[13]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[13]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[12]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[12]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[11]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[11]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[10]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[10]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[9]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[9]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[8]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[8]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[7]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[7]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[6]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[6]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[5]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[5]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[4]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[3]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[2]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[1]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {w_wr_data[0]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {w_wr_data[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports {srm_start}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {srm_start}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 105; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 106
set_input_delay -clock [get_clocks {dec_clk}] -min 0.15 [get_ports \
    {srm_decision_valid}]
set_input_delay -clock [get_clocks {dec_clk}] -max 1.05 [get_ports \
    {srm_decision_valid}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 105; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 106
set_input_delay -clock [get_clocks {dec_clk}] -min 0.15 [get_ports \
    {srm_decision_bit}]
set_input_delay -clock [get_clocks {dec_clk}] -max 1.05 [get_ports \
    {srm_decision_bit}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 98; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 99
set_input_delay -clock [get_clocks {clk}] -min 0.5 [get_ports \
    {residue_consume_i}]
set_input_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {residue_consume_i}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {srm_busy}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {srm_busy}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {srm_done}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {srm_done}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_valid}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_valid}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_ones_count[4]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_ones_count[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_ones_count[3]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_ones_count[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_ones_count[2]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_ones_count[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_ones_count[1]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_ones_count[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_ones_count[0]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_ones_count[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_total_count[4]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_total_count[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_total_count[3]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_total_count[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_total_count[2]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_total_count[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_total_count[1]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_total_count[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_total_count[0]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_total_count[0]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_count_shortfall}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_count_shortfall}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports {srm_stalled}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports {srm_stalled}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[9]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[9]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[8]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[8]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[7]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[7]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[6]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[6]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[5]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[5]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[4]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[4]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[3]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[3]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[2]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[2]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[1]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[1]}]
# /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 140; \
#   /home/<user>/sar16_work/proj_paper_core/constraints/sar_digi_paper_core_pnr.sdc, \
#   line 141
set_output_delay -clock [get_clocks {clk}] -min -0.5 [get_ports \
    {srm_residue_o[0]}]
set_output_delay -clock [get_clocks {clk}] -max 3.5 [get_ports \
    {srm_residue_o[0]}]
set_max_transition 0.8 [current_design]
