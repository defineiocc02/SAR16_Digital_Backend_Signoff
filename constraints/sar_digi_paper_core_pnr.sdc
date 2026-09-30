# MAINTAINED CANDIDATE, 2026-09-30. Derived from the immutable v5.1 evidence SDC.
# Tcl mock checks cover error propagation and required port presence only.
# Not yet validated with Fusion Compiler or used to produce the archived GDS.
# Source this instead of the baseline SDC after restoring the private FC flow.
# Numeric clock / IO assumptions remain 10 ns / 3 ns and must be reviewed.
# =============================================================================
# File Name : sar_digi_paper_core_pnr.sdc
# Purpose   : Place & route constraints for the ON-DIE digital core
#             (calibration logic + SRM counter; no reconstruction datapath).
# Tool      : Fusion Compiler W-2024.09-SP3 (ICC2 family)
# Top       : sar_digi_paper_core
# -----------------------------------------------------------------------------
# DERIVED FROM : constraints/sar_adc_digital_top_pnr.sdc
#
# The two files are intentionally near-identical so that the physical result of
# the core and of the integrated top can be compared directly.  The ONLY changes
# are DESIGN_NAME and the port lists, because this core has no reconstruction
# datapath and therefore no adc_dout / data_valid_out / overrange / norm_* /
# weight_sum ports.  Everything numeric is unchanged, so any timing delta between
# the two blocks is attributable to the design and not to a constraint edit.
#
# The three families of change that the parent file already documents (kept here
# for a reader who opens this file first):
#   1. `[current_design]` -> `[current_block]` - the ICC2/FC block object.
#   2. every required timing command uses sdc_apply and propagates failure.
#      A failed command aborts the sourced constraint file for the caller.
#   3. a final guard that hard-fails if EITHER clock was not created.
#
# DELIBERATELY KEPT, not relaxed: the output hold requirement (IO_MIN_FRAC 0.05
# -> set_output_delay -min), so that place & route has to demonstrate the fix
# with real clock-tree insertion delay instead of erasing the evidence.
#
# ABSOLUTE clock transition, not period-scaled: the v3.0 lesson - a period-scaled
# transition exceeds the library max_transition at low frequency and the tool then
# inserts buffers chasing a modelling artefact.
# =============================================================================

set DESIGN_NAME  sar_digi_paper_core
set CLK_NAME     clk
set CLK_PERIOD   10.0
set CLK_HALF     [expr {$CLK_PERIOD / 2.0}]

set DCLK_NAME    dec_clk
set DCLK_PERIOD  3.0
set DCLK_HALF    [expr {$DCLK_PERIOD / 2.0}]

set IO_MAX_FRAC  0.35
set IO_MIN_FRAC  0.05
set IO_MAX_DELAY [expr {$CLK_PERIOD * $IO_MAX_FRAC}]
set IO_MIN_DELAY [expr {$CLK_PERIOD * $IO_MIN_FRAC}]
set CMP_MAX_DELAY [expr {$CLK_PERIOD * 0.10}]

# Required constraints fail immediately; do not redefine Tcl's built-in try.
proc sdc_apply {args} {
    if {[catch {uplevel 1 $args} message]} {
        error "Required SDC command failed: [lindex $args 0]: $message"
    }
}

# Presence only: actual widths, collections and timing semantics need FC validation.
foreach port_pattern {
    clk dec_clk rst_n start_calib calib_comp_out data_valid_i raw_bits_i[*]
    srm_start srm_decision_valid srm_decision_bit residue_consume_i
    calib_done calib_done_pulse calib_mode_en calib_overrange calib_overrange_bits[*]
    dac_p_force[*] dac_n_force[*] raw_code_o[*] raw_code_valid_o
    w_wr_en w_wr_addr[*] w_wr_data[*] srm_busy srm_done srm_residue_valid
    srm_residue_o[*] srm_ones_count[*] srm_total_count[*] srm_count_shortfall srm_stalled
} {
    if {[sizeof_collection [get_ports -quiet $port_pattern]] == 0} {
        error "Required SDC port pattern is missing: $port_pattern"
    }
}

# --- 1. clocks ---------------------------------------------------------------
# `[list 0.0 $CLK_HALF]`, never `{0.0 $CLK_HALF}` - braces suppress variable
# substitution and the tool receives the literal token, which it rejects WITHOUT
# an error, leaving the design clockless.
sdc_apply create_clock -name $CLK_NAME  -period $CLK_PERIOD  \
                 -waveform [list 0.0 $CLK_HALF]  [get_ports $CLK_NAME]
sdc_apply create_clock -name $DCLK_NAME -period $DCLK_PERIOD \
                 -waveform [list 0.0 $DCLK_HALF] [get_ports $DCLK_NAME]

sdc_apply set_propagated_clock [get_clocks $CLK_NAME]
sdc_apply set_propagated_clock [get_clocks $DCLK_NAME]

sdc_apply set_clock_uncertainty -setup [expr {$CLK_PERIOD  * 0.02}]  [get_clocks $CLK_NAME]
sdc_apply set_clock_uncertainty -hold  [expr {$CLK_PERIOD  * 0.005}] [get_clocks $CLK_NAME]
sdc_apply set_clock_uncertainty -setup [expr {$DCLK_PERIOD * 0.02}]  [get_clocks $DCLK_NAME]
sdc_apply set_clock_uncertainty -hold  [expr {$DCLK_PERIOD * 0.005}] [get_clocks $DCLK_NAME]

sdc_apply set_clock_latency -source 0.0 [get_clocks $CLK_NAME]
sdc_apply set_clock_latency -source 0.0 [get_clocks $DCLK_NAME]

sdc_apply set_clock_transition 0.15 [get_clocks $CLK_NAME]
sdc_apply set_clock_transition 0.10 [get_clocks $DCLK_NAME]

# --- 2. clock-domain crossing ------------------------------------------------
# All clk <-> dec_clk crossings are single-bit toggles or gray-coded buses behind
# two-flop synchronisers, so they are declared asynchronous and verified by CDC
# lint rather than by STA. The lint is NOT performed by this flow.
sdc_apply set_clock_groups -asynchronous -name clk_domains \
    -group [get_clocks $CLK_NAME] -group [get_clocks $DCLK_NAME]

# --- 3. asynchronous reset ---------------------------------------------------
sdc_apply set_false_path -from [get_ports rst_n]

# --- 4. input delays ---------------------------------------------------------
set DIG_IN_PORTS [get_ports {
    start_calib
    data_valid_i
    raw_bits_i[*]
    srm_start
    residue_consume_i
}]
sdc_apply set_input_delay -clock $CLK_NAME -max $IO_MAX_DELAY $DIG_IN_PORTS
sdc_apply set_input_delay -clock $CLK_NAME -min $IO_MIN_DELAY $DIG_IN_PORTS

set DEC_IN_PORTS [get_ports {
    srm_decision_valid
    srm_decision_bit
}]
sdc_apply set_input_delay -clock $DCLK_NAME -max [expr {$DCLK_PERIOD * 0.35}] $DEC_IN_PORTS
sdc_apply set_input_delay -clock $DCLK_NAME -min [expr {$DCLK_PERIOD * 0.05}] $DEC_IN_PORTS

# Comparator output is asynchronous to clk; only its max (setup) side is
# meaningful, and it is captured by the two-flop synchroniser in the RTL.
sdc_apply set_input_delay -clock $CLK_NAME -max $CMP_MAX_DELAY [get_ports calib_comp_out]
sdc_apply set_input_delay -clock $CLK_NAME -min 0.0              [get_ports calib_comp_out]

sdc_apply set_input_transition -max [expr {$CLK_PERIOD * 0.02}] \
    [remove_from_collection [all_inputs] [get_ports [list $CLK_NAME $DCLK_NAME]]]
sdc_apply set_input_transition -min 0.0 \
    [remove_from_collection [all_inputs] [get_ports [list $CLK_NAME $DCLK_NAME]]]

# --- 5. output delays --------------------------------------------------------
set DIG_OUT_PORTS [get_ports {
    calib_done
    calib_done_pulse
    calib_mode_en
    calib_overrange
    calib_overrange_bits[*]
    raw_code_o[*]
    raw_code_valid_o
    w_wr_en
    w_wr_addr[*]
    w_wr_data[*]
    srm_busy
    srm_done
    srm_residue_valid
    srm_residue_o[*]
    srm_ones_count[*]
    srm_total_count[*]
    srm_count_shortfall
    srm_stalled
}]

sdc_apply set_output_delay -clock $CLK_NAME -max $IO_MAX_DELAY $DIG_OUT_PORTS
sdc_apply set_output_delay -clock $CLK_NAME -min [expr {-$IO_MIN_DELAY}] $DIG_OUT_PORTS

# Analog-facing CDAC control bus: budget dominated by switch settling, not by
# digital delay. Same 45% assumption as synthesis.
sdc_apply set_output_delay -clock $CLK_NAME -max [expr {$CLK_PERIOD * 0.45}] \
    [get_ports {dac_p_force[*] dac_n_force[*]}]
sdc_apply set_output_delay -clock $CLK_NAME -min 0.0 \
    [get_ports {dac_p_force[*] dac_n_force[*]}]

sdc_apply set_load -max 0.05 [all_outputs]

# --- 6. design rules ---------------------------------------------------------
sdc_apply set_max_transition 0.8 [current_block]
sdc_apply set_max_fanout     24  [current_block]

# --- 7. guard ----------------------------------------------------------------
set sdc_fail 0
foreach C [list $CLK_NAME $DCLK_NAME] {
    if {[sizeof_collection [get_clocks -quiet $C]] == 0} {
        puts "ERROR: SDC failed to create clock '$C'; every timing report below"
        puts "       would be meaningless. Aborting."
        set sdc_fail 1
    } else {
        puts "INFO: SDC applied, clock '$C' period = [get_attribute [get_clocks $C] period] ns"
    }
}
if {$sdc_fail} { error "Required SDC clocks missing" }
