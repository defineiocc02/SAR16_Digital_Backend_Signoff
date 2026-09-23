# =============================================================================
# File Name   : sar_digi_paper_core.sdc
# Target      : SMIC 0.18um 1P6M standard cells (Artisan/SMIC18)
# Tool        : Synopsys Design Compiler / PrimeTime / Fusion Compiler
# Top         : sar_digi_paper_core
# -----------------------------------------------------------------------------
# WHAT THIS IS
#   Constraints for the ON-DIE digital of the Huang-2024 split-sampling 16-bit
#   5-MS/s SAR ADC -- i.e. "a calibration logic" + "an SRM counter" (Sec. 4.3.1)
#   and nothing else.  The off-chip weighted-sum reconstructor is modelled in
#   RTL (sar_reconstruction.sv) but is NOT part of this netlist, so its ports
#   (adc_dout, data_valid_out, overrange, norm_ready, norm_busy, weight_sum)
#   are absent here and only here.
#
# RELATION TO sar_adc_digital_top.sdc
#   Same clock plan, same IO assumptions, same design-rule budgets.  The ONLY
#   differences are DESIGN_NAME and the port lists in sections 4 and 5, because
#   the integrated top has the reconstruction datapath and this core does not.
#   Everything else is deliberately identical so that the two syntheses are
#   comparable line for line -- which is the whole point of having both.
#
# READ ME FIRST
#   This is a BLOCK-LEVEL constraint file.  It is deliberately not a chip-level
#   signoff file:
#     * The analog side (comparator, CDAC, bias) is outside these clock domains.
#     * `calib_comp_out` is an ASYNCHRONOUS input.  Static timing cannot prove
#       that a comparator decision is captured correctly; that is a CDC
#       property.  The RTL contains a two-flop synchronizer, and a CDC lint
#       pass (e.g. SpyGlass) is required IN ADDITION to this SDC.
#     * Digital standard-cell I/O delays are assumed, not extracted.
# =============================================================================

# -----------------------------------------------------------------------------
# 0. Design and clock parameters
# -----------------------------------------------------------------------------
set DESIGN_NAME       sar_digi_paper_core

set CLK_NAME          clk
set CLK_PERIOD        [expr {10.0}]
set CLK_HALF          [expr {$CLK_PERIOD / 2.0}]

# Decision-domain clock. The paper times one SRM comparison at ~3 ns, so the
# counter must close at that rate. 3.0 ns = 333 MHz is the constraint; the
# achieved Fmax is reported by STA and is what actually matters.
set DCLK_NAME         dec_clk
set DCLK_PERIOD       [expr {3.0}]
set DCLK_HALF         [expr {$DCLK_PERIOD / 2.0}]

# Fraction of the period allowed for external logic on synchronous ports.
# IO_MIN_FRAC is the ASSUMED external HOLD requirement at the boundary; it is
# applied as a negative `-min` output delay and is the ONLY known source of
# timing violations for output ports. At synthesis the clock is ideal, so a
# launching flop has no insertion delay to push data out and the external hold
# requirement cannot be met; there is nothing for DC to optimise. The correct
# places to close them are (a) clock-tree insertion delay and output hold
# buffers in place & route, or (b) relaxing this assumption.
set IO_MAX_FRAC       0.35
set IO_MIN_FRAC       0.05
set IO_MAX_DELAY      [expr {$CLK_PERIOD * $IO_MAX_FRAC}]
set IO_MIN_DELAY      [expr {$CLK_PERIOD * $IO_MIN_FRAC}]

# Comparator input: the asynchronous source is assumed close to the capturing
# edge. The real relaxation comes from the calibration FSM, which waits
# COMP_WAIT_CYC (=16) clocks after applying the DAC trial before sampling.
set CMP_MAX_DELAY     [expr {$CLK_PERIOD * 0.10}]

# -----------------------------------------------------------------------------
# 1. Clock definitions
# -----------------------------------------------------------------------------
# PORTABILITY TRAP - do not "tidy" these lines:
#   `-waveform {0.0 $CLK_HALF}` does NOT work. Braces in TCL suppress variable
#   substitution, so DC receives the literal token "$CLK_HALF" as the second
#   waveform edge, rejects the whole command, and says NOTHING. No clock is
#   created; the only symptom is a cascade of
#       Warning: Can't find clock 'clk' in design '...'
#   from every set_clock_* / set_input_delay / set_output_delay below. Use
#   `[list ...]` (or a double-quoted string) whenever an edge list has to
#   contain a variable.
# -----------------------------------------------------------------------------
create_clock -name $CLK_NAME  -period $CLK_PERIOD  -waveform [list 0.0 $CLK_HALF]  [get_ports $CLK_NAME]
create_clock -name $DCLK_NAME -period $DCLK_PERIOD -waveform [list 0.0 $DCLK_HALF] [get_ports $DCLK_NAME]

set_clock_uncertainty -setup [expr {$CLK_PERIOD * 0.02}]  [get_clocks $CLK_NAME]
set_clock_uncertainty -hold  [expr {$CLK_PERIOD * 0.005}] [get_clocks $CLK_NAME]
set_clock_uncertainty -setup [expr {$DCLK_PERIOD * 0.02}]  [get_clocks $DCLK_NAME]
set_clock_uncertainty -hold  [expr {$DCLK_PERIOD * 0.005}] [get_clocks $DCLK_NAME]

set_clock_latency -source 0.0 [get_clocks $CLK_NAME]
set_clock_latency -source 0.0 [get_clocks $DCLK_NAME]

# Absolute, not period-scaled: a period-scaled slew at a long period exceeds the
# library max_transition and the tool inserts buffers chasing it, costing more
# area than the lower frequency saved.
set_clock_transition 0.15 [get_clocks $CLK_NAME]
set_clock_transition 0.10 [get_clocks $DCLK_NAME]

# -----------------------------------------------------------------------------
# 2. Clock-domain crossing
# -----------------------------------------------------------------------------
# The clk <-> dec_clk boundary is synchroniser-protected by construction:
#   clk -> dec_clk : `go_tgl` (single bit, toggle) -> 3-flop chain -> edge detect
#   dec_clk -> clk : `dec_done_tgl` (single bit, toggle) -> 2-flop chain; and the
#                    counter readout `ones_g` / `tot_g` GRAY-coded (2 x 5 bit)
#                    -> 2-flop chains.
# Everything crossing the boundary is a single-bit toggle or a gray-coded bus,
# i.e. exactly the case that is declared asynchronous and verified by a CDC lint
# rather than by STA. The lint is NOT optional and is NOT delivered by this file.
set_clock_groups -asynchronous -name clk_domains \
    -group [get_clocks $CLK_NAME] -group [get_clocks $DCLK_NAME]

# -----------------------------------------------------------------------------
# 3. Asynchronous reset
# -----------------------------------------------------------------------------
set_false_path -from [get_ports rst_n]

# -----------------------------------------------------------------------------
# 4. Input delays
# -----------------------------------------------------------------------------
# --- 4a. clk-domain synchronous inputs ---
set DIG_IN_PORTS [get_ports {
    start_calib
    data_valid_i
    raw_bits_i[*]
    srm_start
    residue_consume_i
}]
set_input_delay -clock $CLK_NAME -max $IO_MAX_DELAY $DIG_IN_PORTS
set_input_delay -clock $CLK_NAME -min $IO_MIN_DELAY $DIG_IN_PORTS

# --- 4b. dec_clk-domain inputs (the latch decision stream) ---
set DEC_IN_PORTS [get_ports {
    srm_decision_valid
    srm_decision_bit
}]
set_input_delay -clock $DCLK_NAME -max [expr {$DCLK_PERIOD * 0.35}] $DEC_IN_PORTS
set_input_delay -clock $DCLK_NAME -min [expr {$DCLK_PERIOD * 0.05}] $DEC_IN_PORTS

# --- 4c. Asynchronous comparator input ---
set_input_delay -clock $CLK_NAME -max $CMP_MAX_DELAY [get_ports calib_comp_out]
set_input_delay -clock $CLK_NAME -min 0.0              [get_ports calib_comp_out]

set_input_transition -max [expr {$CLK_PERIOD * 0.02}] \
    [remove_from_collection [all_inputs] [get_ports [list $CLK_NAME $DCLK_NAME]]]
set_input_transition -min 0.0 \
    [remove_from_collection [all_inputs] [get_ports [list $CLK_NAME $DCLK_NAME]]]

# -----------------------------------------------------------------------------
# 5. Output delays
# -----------------------------------------------------------------------------
# All of these are registered in the clk domain.  The SRM counter itself lives in
# dec_clk, but its result is read out through the gray synchroniser and published
# by the clk-domain FSM, so the boundary is a clk-domain register either way.
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
set_output_delay -clock $CLK_NAME -max $IO_MAX_DELAY $DIG_OUT_PORTS
set_output_delay -clock $CLK_NAME -min [expr {-$IO_MIN_DELAY}] $DIG_OUT_PORTS

# --- 5b. Analog-facing DAC control bus ---
# Drives the CDAC switch drivers across the digital/analog boundary. Looser than
# the digital ports because analog switch settling, not digital delay, dominates.
set_output_delay -clock $CLK_NAME -max [expr {$CLK_PERIOD * 0.45}] [get_ports {dac_p_force[*] dac_n_force[*]}]
set_output_delay -clock $CLK_NAME -min 0.0                          [get_ports {dac_p_force[*] dac_n_force[*]}]

set_load -max 0.05 [all_outputs]

# -----------------------------------------------------------------------------
# 6. Design rule constraints
# -----------------------------------------------------------------------------
# Library defaults are loose (typical 3.0 ns / fast 2.3 ns / slow 4.5 ns), which
# puts cells in the extreme corner of the delay tables. 0.8 ns keeps them in a
# well-characterised region at 1.8 V / 25 C and is achievable.
set_max_transition 0.8 [current_design]
set_max_fanout 24 [current_design]

# -----------------------------------------------------------------------------
# 7. Timing exceptions
# -----------------------------------------------------------------------------
# No legitimate multicycle paths.  Both remaining blocks complete in one clock:
#   * The calibration FSM's binary search takes its decision from the value
#     captured by the comparator synchronizer, not from a combinational analog
#     readback.
#   * The SRM counters are simple increment/decrement in the dec_clk domain.
# Adding a multicycle here would hide a real violation.
#
# NOTE for whoever retargets the clock: the CALIBRATION FSM's cost is
# period-proportional by construction (COMP_WAIT_CYC=16 waits, AVG_LOOPS=32,
# 20 SAR steps per target, 14 targets). Measured on the RTL testbench:
#     207 324 clk cycles per full 14-bit calibration
# i.e. 2.07 ms at 100 MHz. Slowing the clock lengthens calibration as well as
# the per-sample path, so a frequency change must be checked against the
# startup-time budget, not just the sample rate.
