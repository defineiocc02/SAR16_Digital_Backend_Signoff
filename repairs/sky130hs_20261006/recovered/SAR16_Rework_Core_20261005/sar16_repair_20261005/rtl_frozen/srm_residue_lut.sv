// =============================================================================
// srm_residue_lut -- the SRM inverse-normal lookup table, as its own leaf
// =============================================================================
// PAPER (Sec. 4.5): "such a lookup table can be implemented with simple
// combination logic with a 5-bit input and a 5-bit output. From digital
// synthesis estimation, the lookup table only accounts for a small area of
// 22 um x 22 um and a power of 4.7 uW running at 5 MHz/s."
//
// WHY THIS MODULE EXISTS
// ----------------------
// v4.0 baked the table as a function INSIDE srm_residue_estimator, 16 bits wide,
// 23 entries. Two things were wrong with that, and neither was visible because
// the table had no area of its own:
//
//   1. WIDTH. The entries peak at +/-382 Q8 (the paper's own sigma = 0.7388 LSB
//      design point) -- i.e. 10 bits signed. Storing 16 bits put 6 bits of pure
//      waste in every one of the 23 entries.
//   2. SYMMETRY. v_res(k) = -v_res(N-k) holds EXACTLY, not approximately: the
//      table is sigma*Phi^-1((k+0.5)/(N+1)) and Phi^-1(1-p) = -Phi^-1(p). Only
//      k <= N/2 needs to be stored; the upper half is a negation.
//
//   Extracting the table as a leaf also makes its area MEASURABLE. Before this,
//   the only number available was the whole estimator (11 280 um^2), and quoting
//   that against the paper's 484 um^2 was comparing two different things.
//
// SCALING
// -------
//   The stored entries are in Q(RES_FRAC) -- the estimator's own interface
//   format, so the table stays valid if the datapath changes. FRAC_OUT is the
//   LUT's OUTPUT binary point: an output of `e` means v_res = e * 2^-FRAC_OUT
//   LSB. The output is produced as `entry >>> (RES_FRAC - FRAC_OUT)`, so the
//   precision cost is exactly 2^-FRAC_OUT LSB per step, i.e. quantisation noise
//   2^-FRAC_OUT/sqrt(12), and the area cost is (RES_FRAC - FRAC_OUT) fewer bits
//   per entry. That trade is the whole point of the parameter.
//
//   Because FRAC_OUT is a constant, the shift is constant-folded and the
//   synthesised ROM carries only OUT_WIDTH bits per entry.
//
// MEASURED CONFIGURATIONS (SMIC 180 nm, DC, typical.db -- see the report)
//   OUT_WIDTH=16 FRAC_OUT=8 : the original v4.0 behaviour, for A/B
//   OUT_WIDTH=10 FRAC_OUT=8 : lossless (10 bits cover +/-382 Q8)
//   OUT_WIDTH= 6 FRAC_OUT=4 : 1/16 LSB steps, noise 0.018 LSB  <- DEFAULT
//   OUT_WIDTH= 5 FRAC_OUT=3 : 1/8  LSB steps, noise 0.036 LSB
// =============================================================================

`default_nettype none

module srm_residue_lut #(
    parameter int DECISION_COUNT = 22,
    parameter int SIGMA_Q8       = 128,   // sigma in Q8 LSB (128 = 0.5 LSB)
    parameter int RES_FRAC       = 8,     // Q(RES_FRAC): the estimator's format
    // DEFAULTS ARE THE MEASURED OPTIMUM, not the smallest width. Sweeping
    // (FRAC_OUT, OUT_WIDTH, HALF_TABLE) over five configurations gave:
    //     FO=8 OW=10 HALF=1 -> LUT 671.9 um^2, estimator 8189.6   <-- BEST
    //     FO=8 OW=10 HALF=0 -> LUT 655.3 um^2, estimator 8648.6
    //     FO=4 OW= 6 HALF=1 -> LUT 655.3 um^2, estimator 8598.7
    //     FO=3 OW= 5 HALF=1 -> LUT 815.0 um^2, estimator 8332.6
    //     FO=8 OW=16 HALF=0 -> LUT 671.9 um^2, estimator 8658.6
    // Two things fall out of that table and neither was expected:
    //   * the WIDEST-but-lossless setting is ALSO the smallest overall;
    //   * the 5-bit setting that mirrors the paper's own description ("a 5-bit
    //     input and a 5-bit output") is the WORST of the five.
    // The reason is that entry width does not drive this table's cost -- the
    // 5-bit-to-23-entry DECODE does. Shrinking the stored value while the decode
    // tree stays put buys nothing and, at 5 bits, perturbs the optimiser into a
    // worse structure than the lossless one.
    parameter int FRAC_OUT       = 8,     // LUT output binary point
    parameter int OUT_WIDTH      = 10,    // signed width of an entry
    parameter bit HALF_TABLE     = 1'b1   // use the exact odd symmetry
)(
    input  logic [4:0]                  cnt,     // "1" decisions, 0..DECISION_COUNT
    output logic signed [OUT_WIDTH-1:0] v_res
);

    localparam int CNT_W = 5;
    localparam int MID   = DECISION_COUNT / 2;      // 11 for N = 22
    localparam int SHIFT = RES_FRAC - FRAC_OUT;

    // -------------------------------------------------------------------------
    // Guards (elaboration / simulation only)
    // -------------------------------------------------------------------------
`ifndef SYNTHESIS
    initial begin : p_guard
        logic signed [15:0] vmax, vmin, s;
        if (DECISION_COUNT < 2 || DECISION_COUNT > 31)
            $error("srm_residue_lut: DECISION_COUNT must be in [2,31] to fit the 5-bit index.");
        if (FRAC_OUT > RES_FRAC)
            $error("srm_residue_lut: FRAC_OUT must be <= RES_FRAC (the LUT cannot invent precision).");
        if (OUT_WIDTH < 2)
            $error("srm_residue_lut: OUT_WIDTH must be >= 2.");
        // The parameter combination must not clip the table. This is the check
        // that makes OUT_WIDTH a safe knob: shrinking it is fine, shrinking it
        // PAST the table's peak would silently wrap and corrupt every residue.
        vmax = 0; vmin = 0;
        for (int k = 0; k <= DECISION_COUNT; k++) begin
            s = tbl_q8(CNT_W'(k));
            if (s > vmax) vmax = s;
            if (s < vmin) vmin = s;
        end
        if ((vmax >>> SHIFT) > ((1 << (OUT_WIDTH - 1)) - 1))
            $error("srm_residue_lut: OUT_WIDTH=%0d too small -- max entry %0d Q8 shifted by %0d needs more. Raise OUT_WIDTH or raise FRAC_OUT.", OUT_WIDTH, vmax, SHIFT);
        if ((vmin >>> SHIFT) < -(1 << (OUT_WIDTH - 1)))
            $error("srm_residue_lut: OUT_WIDTH=%0d too small -- min entry %0d Q8 shifted by %0d needs more. Raise OUT_WIDTH or raise FRAC_OUT.", OUT_WIDTH, vmin, SHIFT);
    end
`endif

    // -------------------------------------------------------------------------
    // The table: entries 0 .. floor(N/2), in Q(RES_FRAC), SIGNED.
    //
    //   v_res(k) = sigma * Phi^-1( (k + 0.5) / (N + 1) )
    //
    // Generated for (N = 22, sigma = 0.5 LSB, Q8) -- the v3.0-compatible design
    // point. Regenerate with
    //     python gen/gen_srm_lut.py --n 22 --sigma-uv <IRN> --lsb-uv <LSB>
    // and re-paste; the LUT_* localparams below are checked against the module
    // parameters at elaboration.
    //
    // NOTE the sign convention: `-16'sd258`, never `16'sd-258`. VCS rejects the
    // latter with "Unexpected character '-'" -- the unary minus must be OUTSIDE
    // the based literal. This cost a build on the v4.0 line.
    // -------------------------------------------------------------------------
    localparam int LUT_DECISION_COUNT = 22;
    localparam int LUT_SIGMA_Q8       = 128;

    function automatic logic signed [15:0] tbl_q8(input logic [CNT_W-1:0] i);
        begin
            case (i)
                5'd0  : tbl_q8 = -16'sd258;
                5'd1  : tbl_q8 = -16'sd194;
                5'd2  : tbl_q8 = -16'sd158;
                5'd3  : tbl_q8 = -16'sd131;
                5'd4  : tbl_q8 = -16'sd110;
                5'd5  : tbl_q8 = -16'sd91;
                5'd6  : tbl_q8 = -16'sd74;
                5'd7  : tbl_q8 = -16'sd58;
                5'd8  : tbl_q8 = -16'sd43;
                5'd9  : tbl_q8 = -16'sd28;
                5'd10 : tbl_q8 = -16'sd14;
                5'd11 : tbl_q8 = 16'sd0;
                default: tbl_q8 = 16'sd0;
            endcase
        end
    endfunction

    // -------------------------------------------------------------------------
    // Address folding
    // -------------------------------------------------------------------------
    logic signed [15:0] selected;
    logic               negate;

    generate
        if (HALF_TABLE) begin : g_half
            // v_res(k) = -v_res(N-k): fold the upper half onto the lower half and
            // negate. Exact, not an approximation -- the inverse Gaussian CDF is
            // odd about p = 1/2.
            always_comb begin
                negate   = (cnt > CNT_W'(MID));
                selected = tbl_q8(negate ? (CNT_W'(DECISION_COUNT) - cnt) : cnt);
            end
            assign v_res = OUT_WIDTH'((negate ? -selected : selected) >>> SHIFT);
        end else begin : g_full
            // Full table, for measuring what the symmetry is worth. Every entry
            // 0..N is spelled out, so the two builds differ in exactly one thing.
            always_comb begin
                negate   = 1'b0;
                selected = tbl_full_q8(cnt);
            end
            assign v_res = OUT_WIDTH'(selected >>> SHIFT);
        end
    endgenerate

    function automatic logic signed [15:0] tbl_full_q8(input logic [CNT_W-1:0] i);
        begin
            case (i)
                5'd0  : tbl_full_q8 = -16'sd258;
                5'd1  : tbl_full_q8 = -16'sd194;
                5'd2  : tbl_full_q8 = -16'sd158;
                5'd3  : tbl_full_q8 = -16'sd131;
                5'd4  : tbl_full_q8 = -16'sd110;
                5'd5  : tbl_full_q8 = -16'sd91;
                5'd6  : tbl_full_q8 = -16'sd74;
                5'd7  : tbl_full_q8 = -16'sd58;
                5'd8  : tbl_full_q8 = -16'sd43;
                5'd9  : tbl_full_q8 = -16'sd28;
                5'd10 : tbl_full_q8 = -16'sd14;
                5'd11 : tbl_full_q8 = 16'sd0;
                5'd12 : tbl_full_q8 = 16'sd14;
                5'd13 : tbl_full_q8 = 16'sd28;
                5'd14 : tbl_full_q8 = 16'sd43;
                5'd15 : tbl_full_q8 = 16'sd58;
                5'd16 : tbl_full_q8 = 16'sd74;
                5'd17 : tbl_full_q8 = 16'sd91;
                5'd18 : tbl_full_q8 = 16'sd110;
                5'd19 : tbl_full_q8 = 16'sd131;
                5'd20 : tbl_full_q8 = 16'sd158;
                5'd21 : tbl_full_q8 = 16'sd194;
                5'd22 : tbl_full_q8 = 16'sd258;
                default: tbl_full_q8 = 16'sd258;
            endcase
        end
    endfunction

    // -------------------------------------------------------------------------
    // Consistency of the baked table with the requested design point
    // -------------------------------------------------------------------------
`ifndef SYNTHESIS
    initial begin : p_lut_guard
        if (SIGMA_Q8 != LUT_SIGMA_Q8)
            $error("srm_residue_lut: SIGMA_Q8=%0d does not match the baked table (LUT_SIGMA_Q8=%0d). Regenerate with gen/gen_srm_lut.py; do not just change the parameter.", SIGMA_Q8, LUT_SIGMA_Q8);
        if (DECISION_COUNT != LUT_DECISION_COUNT)
            $error("srm_residue_lut: DECISION_COUNT=%0d does not match the baked table (LUT_DECISION_COUNT=%0d).", DECISION_COUNT, LUT_DECISION_COUNT);
        // The symmetry the folding relies on must actually hold for this table.
        for (int k = 0; k <= DECISION_COUNT; k++) begin
            if (tbl_full_q8(CNT_W'(k)) != -tbl_full_q8(CNT_W'(DECISION_COUNT - k)))
                $error("srm_residue_lut: the table is NOT odd-symmetric at k=%0d; HALF_TABLE cannot be used.", k);
        end
    end
`endif

endmodule

`default_nettype wire
