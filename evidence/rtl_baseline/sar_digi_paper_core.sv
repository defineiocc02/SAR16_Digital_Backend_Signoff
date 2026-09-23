// =============================================================================
// sar_digi_paper_core -- the ON-DIE digital of the Huang-2024 split-sampling
//                        16-bit 5-MS/s SAR ADC
// =============================================================================
//
// WHY THIS MODULE EXISTS
// ----------------------
// `sar_adc_digital_top` (the v4.0 line) instantiates a reconstruction engine
// that turns the 20 raw SAR decision bits into a calibrated 16-bit code:
//
//     dout = sum_i (+/-) W_i     then subtract v_res
//
// On the SMIC 180 nm flow that datapath costs a 20-entry 48-bit weight table,
// a 20-way 48-bit add/subtract tree, a 46-bit restoring divider, a per-weight
// 30-bit multiplier and a SECOND 600-flip-flop weight table.  **None of it is
// in the paper.**  The evidence, from the primary text:
//
//   * Sec. 4.3.1 lists the complete die contents verbatim: "The ADC consists of
//     the 20-pF Cs sampling network, a 1-pF DAC, a 2-bit flash ADC, a 2-stage AZ
//     pre-amplifier, a latch, an asynchronous digital SAR logic, a calibration
//     logic, and an SRM counter."
//     A reconstruction engine, a weight RAM, a multiplier, an adder tree and a
//     normaliser are ALL absent from that list.
//
//   * The paper DOES perform a digital synthesis estimate, and reports exactly
//     one digital block: "From digital synthesis estimation, the lookup table
//     only accounts for a small area of 22 um x 22 um and a power of 4.7 uW
//     running at 5 MHz/s." (Sec. 4.5).  There is no area entry anywhere for a
//     reconstruction datapath.
//
//   * "reconstruct" appears twice in the whole thesis, both times as prose.
//     Sec. 4.6.2 is a MEASUREMENT description: "The calibrated bit weights are
//     used to reconstruct a 1-kHz full-scale input signal sampled by the ADC at
//     1 MS/s."  That is a bench procedure, not a circuit.
//
//   * Sec. 4.3.1 says v_res "is subtracted from the ADC's output in the digital
//     domain", but never places that digital domain on the die.
//
// So the weighted sum lives OFF CHIP.  The die therefore has to export exactly
// three things and nothing more:
//
//     1. the raw SAR decision word        -> raw_code_o / raw_code_valid_o
//     2. the calibrated bit weights       -> w_wr_en / w_wr_addr / w_wr_data
//     3. the SRM residue estimate         -> srm_residue_o / srm_residue_valid_o
//
// This module is that die.  Comparing its synthesised area against the
// reconstruction-included build is the honest way to state what moving the
// weighted sum on chip would cost -- which a real product often does, and which
// is why `sar_adc_digital_top` is kept as the integrated variant.
//
// WHAT IS *NOT* HERE, AND WHY
// ---------------------------
//   * No SAR logic.  `raw_bits_i` is an INPUT of this core, so the successive
//     approximation sequencer lives in the analogue-side block.  This core is
//     therefore a strict SUBSET of the paper's on-die digital: the paper's list
//     also includes "an asynchronous digital SAR logic".  Any area comparison
//     against the paper must say so.
//   * No flash sequencer / MUX-array control.  Same reason.
//   * No weighted sum, no normalisation, no residue subtraction.
//
// INTERFACE NOTES
// ---------------
//   * The weights leave the die as a PUBLISH stream, not as a read-back register
//     file: `w_wr_en` / `w_wr_addr` / `w_wr_data`.  Calibration is a foreground
//     one-shot event whose consumer is waiting for `calib_done`, so nothing
//     races.  v4.3 additionally carried a flat 20:1 read-back port
//     (`weight_rd_*`); it was removed in v5.0 -- see the port-list note for the
//     LVS evidence (30 pins tied to VSS, 29 unmatched ports).  The optional
//     register file is still selectable with WEIGHT_EXPORT_REG, and its measured
//     cost (39 248 um^2, 24 % of the core) is why it defaults to 0.
//   * `srm_residue_o` is published in the estimator's own RES_Q_W bits (10), not
//     in the 30-bit datapath width.  Exporting the datapath width made 20 pins
//     literal copies of the sign bit, which the router turned into net aliases.
//   * `residue_consume_i` is the handshake that tells the SRM estimator its
//     published residue has been taken.  With an off-chip consumer, tie it to
//     `raw_code_valid_o` (one residue per conversion) or to an explicit ack.
// =============================================================================

`default_nettype none

module sar_digi_paper_core #(
    parameter int  CAP_NUM           = 20,      // DAC bit count (16-bit + redundancy)
    parameter int  WEIGHT_WIDTH      = 30,      // signed, Q8: LSB_0 = 256
    parameter int  COMP_WAIT_CYC     = 16,
    parameter int  AVG_LOOPS         = 32,      // Sec. 4.5: "measured 32 times" -> 64x average
    parameter int  MAX_CALIB_BIT     = 5,       // Sec. 4.3.1: 6-bit LSB section reused
    parameter int  REF_WEIGHT_LSB    = 256,     // 1.0 LSB_0 in Q8
    parameter int  SRM_DECISIONS     = 22,      // Sec. 4.6.3: "22 extra decisions"
    parameter int  SRM_RES_FRAC      = 8,
    parameter int  SRM_SIGMA_Q8      = 128,     // MUST match the baked LUT (guarded in the estimator)
    parameter bit  CALIB_ROUND_HALF_LSB = 1'b1,
    parameter int  SRM_STALL_CYCLES  = 64,

    // How the calibrated weights leave the die.
    //   0 = STREAM (default, paper-aligned): no on-die weight storage at all.
    //       The off-chip reconstructor latches W_k off `w_wr_*` when the
    //       calibration logic publishes each measurement.  Costs zero flops.
    //   1 = REGFILE: additionally keep a flat 20 x 30 bit table with a read
    //       port, so the weights can be read back at any time.  Measured at
    //       39 248 um^2 in the SMIC 180 nm flow -- 24 % of the core -- which is
    //       why it is OFF by default.
    parameter bit  WEIGHT_EXPORT_REG = 1'b0,

    // -------------------------------------------------------------------------
    // Width of the PUBLISHED SRM residue, in bits.
    //
    // The estimator keeps its residue in RES_Q_W bits, where
    //     RES_Q_W = LUT_OUT_WIDTH + (RES_FRAC - LUT_FRAC_OUT)
    //             = 10            + (8 - 8)  = 10,
    // and only sign-extends it to the datapath width for the datapath's sake.
    //
    // v4.3 exported the datapath width (WEIGHT_WIDTH = 30).  That made bits
    // [29:10] literal copies of bit 9 -- 20 port pins carrying no information.
    // The router then implemented each copy as an ALIAS of the same net, so the
    // extracted layout had ONE net carrying 21 port labels:
    //     WARNING: Short circuit - Different names on one net: Net Id 448
    // and Calibre could not match 21 of the 232 ports.  Presenting RES_Q_W bits
    // removes the aliases at the source instead of patching the report.
    // -------------------------------------------------------------------------
    parameter int  SRM_RES_W         = 10
) (
    // -------------------------------------------------------------------------
    // Global
    // -------------------------------------------------------------------------
    input  logic clk,                   // housekeeping clock, 100 MHz
    input  logic dec_clk,               // comparator/latch decision clock, ~300 MHz
    input  logic rst_n,                 // asynchronous, active low, common to both domains

    // -------------------------------------------------------------------------
    // Calibration control -- "a calibration logic" (Sec. 4.3.1)
    // -------------------------------------------------------------------------
    input  logic start_calib,
    input  logic calib_comp_out,

    output logic calib_done,
    output logic calib_done_pulse,
    output logic calib_mode_en,
    output logic [CAP_NUM-1:0] dac_p_force,
    output logic [CAP_NUM-1:0] dac_n_force,
    output logic calib_overrange,
    output logic [CAP_NUM-1:0] calib_overrange_bits,

    // -------------------------------------------------------------------------
    // Raw SAR decision word -- produced by the analogue-side SAR logic
    // -------------------------------------------------------------------------
    input  logic data_valid_i,
    input  logic [CAP_NUM-1:0] raw_bits_i,

    output logic [CAP_NUM-1:0] raw_code_o,
    output logic               raw_code_valid_o,

    // -------------------------------------------------------------------------
    // Calibrated bit weights, exported for the OFF-CHIP weighted sum
    // -------------------------------------------------------------------------
    output logic                     w_wr_en,
    output logic [4:0]               w_wr_addr,
    output logic signed [WEIGHT_WIDTH-1:0] w_wr_data,

    // v4.3 also exported a READ-BACK port here (weight_rd_en / weight_rd_addr /
    // weight_rd_data).  Its only purpose was to keep the two WEIGHT_EXPORT_REG
    // builds byte-identical in interface, so that the register-file area A/B
    // stayed apples-to-apples.  In the stream build (WEIGHT_EXPORT_REG = 0) it
    // was `assign weight_rd_data = '0;`, so the layout tied all 30 pins to VSS:
    //     WARNING: Short circuit - Different names on one net: Net Id 463
    //     "VSS" ... "weight_rd_data[0]" ... "weight_rd_data[29]"
    // 30 dead pins, one extracted net, and 29 unmatched ports in LVS.
    // The A/B result is already recorded (39 248 um^2 of table = 24 % of the
    // core, which is why WEIGHT_EXPORT_REG defaults to 0), so the port is gone
    // and `w_wr_*` is the single publish path.  The parameter itself is kept so
    // that existing flows that pass it still elaborate.

    // -------------------------------------------------------------------------
    // SRM residue acquisition -- decision domain -- "an SRM counter"
    // -------------------------------------------------------------------------
    input  logic srm_start,
    input  logic srm_decision_valid,    // in dec_clk domain
    input  logic srm_decision_bit,      // in dec_clk domain
    input  logic residue_consume_i,

    output logic srm_busy,
    output logic srm_done,
    output logic srm_residue_valid,
    output logic [4:0] srm_ones_count,
    output logic [4:0] srm_total_count,
    output logic srm_count_shortfall,
    output logic srm_stalled,
    output logic signed [SRM_RES_W-1:0] srm_residue_o
);

    // -------------------------------------------------------------------------
    // Calibration weight write-back bus (the controller's own output)
    // -------------------------------------------------------------------------
    logic signed [SRM_RES_W-1:0] srm_residue_q;

    // -------------------------------------------------------------------------
    // Calibration controller ("a calibration logic")
    // -------------------------------------------------------------------------
    sar_calib_ctrl_serial #(
        .CAP_NUM           (CAP_NUM),
        .WEIGHT_WIDTH      (WEIGHT_WIDTH),
        .COMP_WAIT_CYC     (COMP_WAIT_CYC),
        .AVG_LOOPS         (AVG_LOOPS),
        .MAX_CALIB_BIT     (MAX_CALIB_BIT),
        .REF_WEIGHT_LSB    (REF_WEIGHT_LSB),
        .ROUND_HALF_LSB    (CALIB_ROUND_HALF_LSB),
        .DETECT_OVERRANGE  (1'b1)
    ) u_calib_ctrl (
        .clk               (clk),
        .rst_n             (rst_n),
        .start_calib       (start_calib),
        .calib_done        (calib_done),
        .calib_done_pulse  (calib_done_pulse),
        .calib_mode_en     (calib_mode_en),
        .comp_out          (calib_comp_out),
        .dac_p_force       (dac_p_force),
        .dac_n_force       (dac_n_force),
        .w_wr_en           (w_wr_en),
        .w_wr_addr         (w_wr_addr),
        .w_wr_data         (w_wr_data),
        .calib_overrange   (calib_overrange),
        .overrange_bits    (calib_overrange_bits)
    );

    // -------------------------------------------------------------------------
    // SRM residue estimator ("an SRM counter", plus the 5-in/5-out LUT of
    // Sec. 4.5; the LUT is a combinational case inside the estimator, so it
    // costs the same simple gates the paper describes and nothing else)
    // -------------------------------------------------------------------------
    srm_residue_estimator #(
        .DECISION_COUNT (SRM_DECISIONS),
        .RESIDUE_WIDTH  (SRM_RES_W),
        .RES_FRAC       (SRM_RES_FRAC),
        .SIGMA_Q8       (SRM_SIGMA_Q8),
        .STALL_CYCLES   (SRM_STALL_CYCLES)
    ) u_srm_residue (
        .dec_clk          (dec_clk),
        .decision_valid   (srm_decision_valid),
        .decision_bit     (srm_decision_bit),
        .clk              (clk),
        .rst_n            (rst_n),
        .start            (srm_start),
        .residue_consume  (residue_consume_i),
        .busy             (srm_busy),
        .done             (srm_done),
        .residue_valid    (srm_residue_valid),
        .ones_count       (srm_ones_count),
        .total_count      (srm_total_count),
        .count_shortfall  (srm_count_shortfall),
        .stalled          (srm_stalled),
        .residue_q        (srm_residue_q)
    );

    assign srm_residue_o = srm_residue_q;

    // -------------------------------------------------------------------------
    // Ideal (uncalibrated) weight ramp.  Used as the reset value of the optional
    // weight register file, and asserted by the elaboration guard below.
    // -------------------------------------------------------------------------
    function automatic logic signed [WEIGHT_WIDTH-1:0] seed_w(input int k);
        logic signed [WEIGHT_WIDTH-1:0] v;
        begin
            v = WEIGHT_WIDTH'(REF_WEIGHT_LSB);
            for (int i = 0; i < k; i++)
                v = v <<< 1;            // in WEIGHT_WIDTH bits: 256<<19 = 2^27 fits
            seed_w = v;
        end
    endfunction

    // =========================================================================
    // Raw SAR code export
    //
    // Registered rather than wired straight through.  On the real die these 20
    // flip-flops ARE the SAR logic's output register -- the paper's die has the
    // SAR logic, so it has these anyway.  Registering here (a) gives the
    // off-chip consumer a stable, edge-aligned sample, and (b) keeps this core
    // a faithful stand-in for "the die minus the analogue blocks" instead of a
    // pure wire, which would understate the area of that boundary.
    // =========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            raw_code_o       <= '0;
            raw_code_valid_o <= 1'b0;
        end else begin
            raw_code_o       <= raw_bits_i;
            raw_code_valid_o <= data_valid_i;
        end
    end

    // =========================================================================
    // Calibrated bit-weight STORE -- optional, OFF by default
    //
    // The die does NOT have to hold the weights.  Its consumer does: the
    // off-chip reconstructor needs all 20 of them to form sum_i (+/-) W_i, so it
    // must store them regardless.  Making the die store a second copy is pure
    // duplication -- and it is NOT in the paper's inventory either ("a
    // calibration logic, and an SRM counter"; Sec. 4.3.1).
    //
    // What the die owes the reconstructor is therefore only a TIMELY VIEW of each
    // measurement, which the `w_wr_en` / `w_wr_addr` / `w_wr_data` bus already
    // provides.  Calibration is a foreground, one-shot event and its consumer is
    // by definition listening for `calib_done`, so there is no race: nothing is
    // published before `start_calib`, and everything is published by the time
    // `calib_done` rises.
    //
    // Set WEIGHT_EXPORT_REG = 1 for the alternative (a flat 20 x 30 bit table
    // with a read port).  It is NOT the default because it measured 39 248 um^2
    // -- 24 % of the core -- in the SMIC 180 nm flow, which is the single largest
    // removable block in the design.
    //
    // When the register file is built, its reset value is the ideal binary ramp
    // W_k = LSB_0 << k, i.e. the uncalibrated converter's own weights, so the
    // port reads something sane before the first calibration run.  Calibration
    // then overwrites bits MAX_CALIB_BIT+1 .. CAP_NUM-1; the LSB section keeps its
    // ideal value because it is the reference segment (what the calibration DAC
    // measures against, not a target).
    // =========================================================================
    generate
        if (WEIGHT_EXPORT_REG) begin : g_weight_regfile

            logic signed [WEIGHT_WIDTH-1:0] weight_tab [0:CAP_NUM-1];

            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    for (int k = 0; k < CAP_NUM; k++)
                        weight_tab[k] <= seed_w(k);
                end else if (w_wr_en && (w_wr_addr < 5'(CAP_NUM))) begin
                    weight_tab[w_wr_addr] <= w_wr_data;
                end
            end

            // v4.3 drove weight_rd_data from this table through a read mux.  The
            // port no longer exists (see the port-list note), so the table is
            // written but not read back.  It is kept because the parameter is
            // still part of the interface to the flow scripts; a build that sets
            // WEIGHT_EXPORT_REG = 1 now simply has storage that nothing observes,
            // which the synthesiser removes -- exactly the "no on-die weight
            // storage" answer the paper gives.  `w_wr_*` publishes every
            // measurement in both builds.

        end else begin : g_weight_stream

            // No storage at all: the paper-aligned build.  A consumer uses
            // `w_wr_en` / `w_wr_addr` / `w_wr_data` to latch each weight as it is
            // published; there is no read-back path, and (since v5.0) no dead
            // read-back PORT either -- that port is what tied 30 pins to VSS and
            // made 29 of them unmatchable in LVS.

        end
    endgenerate

    // =========================================================================
    // Elaboration-time guards
    // =========================================================================
`ifdef SIMULATION
    initial begin
        if (CAP_NUM < 7)
            $error("sar_digi_paper_core: CAP_NUM must be >= 7 (6-bit LSB section + 1).");
        if (WEIGHT_WIDTH < 28)
            $error("sar_digi_paper_core: WEIGHT_WIDTH must hold LSB_0 << (CAP_NUM-1); 28 is the minimum for CAP_NUM=20, LSB_0=256.");
        // If the ideal ramp overflows the signed range the optional weight table
        // silently wraps and every downstream weight is garbage -- exactly the
        // class of defect that compiles cleanly.  Checked ARITHMETICALLY so it
        // fires whether or not the register file is built.
        if ((longint'(REF_WEIGHT_LSB) << (CAP_NUM-1)) > ((longint'(1) << (WEIGHT_WIDTH-2)) - 1))
            $error("sar_digi_paper_core: the ideal weight ramp LSB_0<<(CAP_NUM-1) overflows WEIGHT_WIDTH; raise WEIGHT_WIDTH.");
    end
`endif

endmodule

`default_nettype wire
