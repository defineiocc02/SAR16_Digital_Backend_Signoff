`timescale 1ns/1ps

// =============================================================================
// File Name   : srm_residue_estimator.sv
// Module Name : srm_residue_estimator
// Version     : 4.1  (acknowledged ownership / fail-closed timeout repair)
// Description : Statistical residue measurement (SRM) digital estimator.
//
// REPAIRED PROTOCOL (2026-10-05)
//   * start is accepted only when busy=0 and local reset release is complete.
//   * done publishes one result; busy may remain 1 while retirement is drained.
//   * timeout publishes counts=0, residue=0, shortfall=1 and stalled=1. The
//     zero payload is a sentinel, not an estimate from partial observations.
//   * A stopped dec_clk cannot block the watchdog publication, but it CAN keep
//     busy high indefinitely. Restart dec_clk or assert common reset to recover.
//   * Requests while busy are ignored. At a ready edge start wins over consume.
//   * Input decisions must begin after decision-domain arm. There is no public
//     arm-ready port; any fixed wait must be validated for the actual clocks.
//   * clk/dec_clk reset assert asynchronously and release through local 2FF
//     chains. Wait at least three local rising edges before normal use.
//
// Historical design commentary below is not a new paper-equivalence claim.
// The shipped LUT default remains signed 10-bit Q8, with 22 decisions.
//
// -----------------------------------------------------------------------------
// WHY v4 EXISTS -- the v3.0 throughput contract was unsatisfiable
// -----------------------------------------------------------------------------
// v3.0 counted decisions on `clk` and advanced `ones_count` at most once per
// clock:
//
//     end else if (busy && decision_valid) begin
//         ones_count <= next_ones_count[4:0];
//
// The paper (Huang 2024, HKUST, Ch.4 §4.3.3 and §4.4) states that the two-stage
// auto-zeroed pre-amplifier plus dynamic latch produces one decision per ~3 ns,
// and that T_SRM is ~70 ns for the chosen 20-25 comparisons:
//
//     "every SRM comparison consumes around 3 ns"
//     "an SRM comparison number of 20 to 25 is appropriate ... T_SRM of ~70 ns"
//
// 22 decisions inside 70 ns is a 314 MHz decision rate. The digital clock in
// this design is 100 MHz. A 1-decision-per-clock counter therefore observes at
// most 100/314 = 32 % of the decisions the latch actually makes. P is biased
// downward, and since v_res = sigma * Phi^-1(P) is a *non-linear* map the error
// is not a scale factor that the reconstruction gain normalisation can absorb:
// it is a systematic, input-independent residue offset. SRM stops reducing
// noise and starts injecting it. The v3.0 GLS testbench never caught this
// because it generated exactly one `decision_valid` per `clk` -- it tested the
// counter against its own clock, not against the latch.
//
// The architecture in the paper separates the domains explicitly:
//
//     "a two-stage AZ pre-amplifier, a latch, an asynchronous digital SAR logic,
//      a calibration logic, and an SRM counter"                        [p.74]
//
// i.e. the SRM counter lives in the *decision* domain, not the housekeeping
// domain. v4.0 implements exactly that:
//
//   * `dec_clk` -- comparator/latch decision clock (~300 MHz). Counts EVERY
//                  `decision_valid`. No throughput ceiling.
//   * `clk`     -- housekeeping clock (100 MHz). Applies the LUT, owns the
//                  handshake with the reconstruction datapath.
//   * CDC       -- registered Gray readout of frozen counters, qualified by a
//                  four-phase request/acknowledge/retire handshake. Timeout
//                  publishes a flagged zero payload, then drains the old arm
//                  before busy can drop. Physical CDC/RDC checks are required.
//
// -----------------------------------------------------------------------------
// WHY sigma IS A PORT-LEVEL PARAMETER
// -----------------------------------------------------------------------------
// The paper's estimator is
//
//     v_res = sqrt(2) * sigma(v_n,comp,in) * erfinv(2P - 1)              (4.13)
//
// and `sigma(v_n,comp,in)` is the RMS input-referred noise of the pre-amplifier
// and latch -- a *measured physical quantity of the analog front end*, not a
// design constant. Phi^-1(p) = sqrt(2)*erf^-1(2p-1), so (4.13) is identical to
// v_res = sigma * Phi^-1(P); v3.0's arithmetic was right, but it baked
// sigma = 0.5 LSB into a literal table together with N = 22, and an
// elaboration-time $error refused any other DECISION_COUNT. A LUT built for one
// sigma is wrong for another by exactly that ratio, so the residue estimate
// carries a proportional error the normalisation stage cannot see.
//
// v4.0 exposes SIGMA_Q8, DECISION_COUNT and RES_FRAC, and gen/gen_srm_lut.py
// regenerates the table. Run with (--sigma-lsb 0.5 --res-frac 8 --out-width 16)
// the generator reproduces the v3.0 table *value for value*, which is what makes
// the v3-vs-v4 A/B in tb/tb_sar16_v4.sv exact rather than approximate.
//
// Worked example from the paper's own noise budget (Table 4.1 / §4.4):
//     IRN of the pre-amplifier      = 59.1 uVrms
//     DAC LSB                       = 80 uV
//     sigma                         = 59.1 / 80 = 0.7388 LSB  (Q8 = 189)
//     -> python gen/gen_srm_lut.py --n 22 --sigma-uv 59.1 --lsb-uv 80 --emit-paper
// Note that in the paper's own 5-bit output format the estimator then saturates
// at +/-1.0 LSB, which is the redundancy bound of the calibration DAC, not a
// numerical accident -- see docs/.
//
// Fixed-point contract (unchanged from v3.0, see FIXED_POINT_CONTRACT.md):
//   `residue_q` is Q(RES_FRAC) and 2^RES_FRAC == exactly one output-code LSB.
//   The reconstruction injects it after shifting into its 16-fractional-bit
//   output-code domain, so RES_FRAC <= 16 is required.
// =============================================================================

module srm_residue_estimator #(
    // --- SRM estimator definition -------------------------------------------
    parameter int DECISION_COUNT = 22,   // paper: 20..25 optimal, T_SRM ~70 ns
    parameter int RESIDUE_WIDTH  = 30,   // signed width handed to the datapath
    parameter int RES_FRAC       = 8,    // 8 = Q8 (v3.0 compatible); 4 = paper's 5-bit format
    parameter int SIGMA_Q8       = 128,  // sigma in Q8 LSB (128 = 0.5 LSB)

    // --- LUT shape (the table itself now lives in rtl/srm_residue_lut.sv) ----
    // v4.0 baked the table HERE, 16 bits wide and 23 entries. Both numbers were
    // waste, and neither was visible while the table had no area of its own:
    //   * the entries peak at +/-382 Q8, so 16 bits carried 6 bits of nothing;
    //   * v_res(k) = -v_res(N-k) holds EXACTLY (Phi^-1 is odd about p = 1/2),
    //     so the upper half never needed storing.
    // LUT_FRAC_OUT trades precision for area: 4 -> 1/16 LSB steps, 3 -> 1/8 LSB.
    // See the leaf's header for the measured area/precision curve.
    // Defaults = the measured optimum (see rtl/srm_residue_lut.sv for the sweep).
    // The WIDEST LOSSLESS setting (10-bit entries at FRAC_OUT = 8) is also the
    // smallest overall, because entry width is not what drives this table's cost
    // -- the 5-bit-to-entry decode is.
    parameter int LUT_FRAC_OUT   = 8,    // LUT output binary point
    parameter int LUT_OUT_WIDTH  = 10,   // signed width of a LUT entry
    parameter bit LUT_HALF_TABLE = 1'b1, // exploit the exact odd symmetry

    // --- Watchdog -----------------------------------------------------------
    // If the latch never delivers DECISION_COUNT decisions the sample would hang
    // forever (the paper's chip has the same structural risk). STALL_CYCLES > 0
    // enables a housekeeping-domain watchdog that completes the measurement with
    // count_shortfall set. At 100 MHz, 64 cycles = 640 ns, i.e. 9x T_SRM.
    parameter int STALL_CYCLES   = 64
)(
    // -------------------------------------------------------------------------
    // Decision domain -- comparator / latch clock (~300 MHz)
    // -------------------------------------------------------------------------
    input  logic                    dec_clk,
    input  logic                    decision_valid,   // in dec_clk domain
    input  logic                    decision_bit,     // in dec_clk domain, qualified by decision_valid

    // -------------------------------------------------------------------------
    // Housekeeping domain -- 100 MHz
    // -------------------------------------------------------------------------
    input  logic                    clk,
    input  logic                    rst_n,            // asynchronous, active low, common to both domains
    input  logic                    start,            // one-clock pulse to begin acquisition
    input  logic                    residue_consume,  // clears residue_valid once consumed

    output logic                    busy,             // acquisition OR pending retire/drain
    output logic                    done,             // one-clock completion strobe
    output logic                    residue_valid,    // one-shot: fresh until consumed

    output logic [4:0]              ones_count,       // "1" decisions observed (port width matches v3.0)
    output logic [4:0]              total_count,      // decisions observed (== DECISION_COUNT unless shortfall)
    output logic                    count_shortfall,  // no usable complete measurement
    output logic                    stalled,          // sticky: watchdog fired this run

    output logic signed [RESIDUE_WIDTH-1:0] residue_q
);

    // =========================================================================
    // 0. Derived constants
    // =========================================================================
    // 5 bits is both the paper's LUT index width and the v3.0 port width, so it
    // is fixed rather than derived -- derived parameter defaults are re-evaluated
    // only in some elaboration orders, and a silently mismatched counter width is
    // exactly the class of bug this rewrite exists to remove.
    localparam int CNT_W = 5;
    localparam logic [CNT_W-1:0] DEC_TARGET  = DECISION_COUNT;

    // =========================================================================
    // 1. Parameter guards (elaboration / simulation only)
    // =========================================================================
`ifndef SYNTHESIS
    initial begin : p_parameter_guard
        if (DECISION_COUNT < 2)
            $error("srm_residue_estimator v4: DECISION_COUNT must be >= 2.");
        if (DECISION_COUNT > 31)
            $error("srm_residue_estimator v4: DECISION_COUNT must be <= 31 to fit the 5-bit LUT index.");
        if (RES_FRAC < 1 || RES_FRAC > 16)
            $error("srm_residue_estimator v4: RES_FRAC must be in [1,16] so the residue lands in the 16-fractional-bit code domain.");
        if (RESIDUE_WIDTH < LUT_OUT_WIDTH)
            $error("srm_residue_estimator v4: RESIDUE_WIDTH must be >= LUT_OUT_WIDTH.");
        if (LUT_FRAC_OUT > RES_FRAC)
            $error("srm_residue_estimator v4: LUT_FRAC_OUT must be <= RES_FRAC. The shift-back would become a RIGHT shift and the residue would lose scale rather than gain precision -- a silent 2x error on every sample.");
        if ((LUT_OUT_WIDTH + (RES_FRAC - LUT_FRAC_OUT)) > RESIDUE_WIDTH)
            $error("srm_residue_estimator v4: LUT_OUT_WIDTH + (RES_FRAC - LUT_FRAC_OUT) = %0d exceeds RESIDUE_WIDTH = %0d, so the published residue would be truncated. Raise RESIDUE_WIDTH or lower the LUT precision.", LUT_OUT_WIDTH + (RES_FRAC - LUT_FRAC_OUT), RESIDUE_WIDTH);
        if (SIGMA_Q8 < 1)
            $error("srm_residue_estimator v4: SIGMA_Q8 must be positive.");
        if (STALL_CYCLES < 0)
            $error("srm_residue_estimator v4: STALL_CYCLES must be >= 0 (0 disables the watchdog).");
        // The LUT is ROM, so the design point lives in the table, not in these
        // parameters. The consistency checks against the baked table are in
        // section 2b, immediately after the generated block (a localparam cannot
        // be referenced before it is declared).
    end
`endif

    // =========================================================================
    // 2. SRM inverse-normal LUT -- now its own leaf
    // ---------------------------------------------------------------------
    //   v_res(c) = sigma * Phi^-1( (c + 0.5) / (N + 1) )
    //   entry(c) = round(v_res(c) * 2^RES_FRAC)
    //
    // The function, the table and the design-point check all live in
    //     rtl/srm_residue_lut.sv
    // and the leaf is instantiated at the bottom of this file. v4.0 kept a
    // 23-entry / 16-bit copy here; BOTH numbers were waste -- the entries peak at
    // +/-382 Q8 (i.e. 10 bits, not 16) and v_res(k) = -v_res(N-k) holds exactly.
    // See the leaf's header for the measured area/precision curve, and the report
    // for what it saves.
    //
    // Regenerating for the paper's own design point, sigma = 0.7388 LSB
    // (Table 4.1: pre-amplifier IRN 59.1 uVrms over a DAC LSB of 80 uV):
    //     python gen/gen_srm_lut.py --n 22 --sigma-uv 59.1 --lsb-uv 80 \
    //            --res-frac 8 --out-width 6 --frac-out 4
    // and re-paste into the leaf; its elaboration guard refuses a half-edit.
    //
    // NOTE the sign convention when pasting: `-16'sd258`, never `16'sd-258`.
    // VCS rejects the latter ("Unexpected character '-'") -- the unary minus must
    // be OUTSIDE the based literal. This cost a build on the v4.0 line.
    // =========================================================================

    // =========================================================================
    // 2b. LUT consistency guard -- MOVED with the table
    // ---------------------------------------------------------------------
    // rtl/srm_residue_lut.sv now owns both the table and the check that
    // (SIGMA_Q8, DECISION_COUNT) match it. It ADDITIONALLY asserts that the table
    // really is odd-symmetric before allowing the half-table folding -- which is
    // what turns "the symmetry is exact" from a claim in a comment into something
    // the elaboration actually verifies.
    // =========================================================================

    // =========================================================================
    // 3. CDC primitives
    // =========================================================================
    // Register Gray words at the source. A monotonic increment changes one bit;
    // rearm clears are multi-bit and are excluded from successful capture by
    // the transaction handshake. This does not replace physical CDC analysis.
    function automatic logic [CNT_W-1:0] bin2gray(input logic [CNT_W-1:0] b);
        bin2gray = b ^ (b >> 1);
    endfunction

    function automatic logic [CNT_W-1:0] gray2bin(input logic [CNT_W-1:0] g);
        logic [CNT_W-1:0] b;
        begin
            // b = g ^ (g>>1) ^ (g>>2) ^ ... ^ (g>>(W-1)), evaluated against the
            // ORIGINAL g each time.
            //
            // Traps worth recording, because the first version of this function
            // fell into the second one and it cost a debugging round:
            //
            //  * `b = b ^ (b >> 1)` iterated (W-1) times is NOT equivalent. In
            //    GF(2)[x]/x^W that is multiplication by (1+x)^(W-1), and
            //    (1+x)^4 = 1 + x^4 (binomial coefficients mod 2), so for W = 5 it
            //    decodes only g ^ (g>>4). Concretely gray 5'b11000 (= binary 16)
            //    decoded to 25 instead of 16 -- which is exactly how this was
            //    caught: the estimator reported a LUT index of 28 for a count
            //    that could only be 0..22.
            //  * no non-linearity is needed, so a plain loop over the original
            //    g is both correct and clear; the synthesised cost is identical.
            b = g;
            for (int i = 1; i < CNT_W; i++) b = b ^ (g >> i);
            gray2bin = b;
        end
    endfunction

    // Sign-extend the LUT output to the datapath width and shift it back up to
    // the Q(RES_FRAC) interface.
    //
    // LUT_SHIFT is a localparam, so the shift is constant-folded and the low
    // bits are provably zero -- which is exactly the precision the LUT traded
    // for area. LUT_FRAC_OUT > RES_FRAC would make this a RIGHT shift and
    // silently scale every residue down; the parameter guard rejects that.
    localparam int LUT_SHIFT = RES_FRAC - LUT_FRAC_OUT;

    // The published residue register is RES_Q_W wide, NOT RESIDUE_WIDTH wide.
    // Registering the full datapath width stores 20 bits that are provably zero
    // on EVERY sample (the LUT computed LUT_OUT_WIDTH bits; the shift-back
    // re-adds LUT_SHIFT zeros) -- 20 of the estimator's 131 flip-flops, ~1k um^2
    // in this library. The port still PRESENTS RESIDUE_WIDTH bits, sign-extended
    // combinationally, so the interface is unchanged and the port keeps its
    // registered timing reference.
    localparam int RES_Q_W = LUT_OUT_WIDTH + LUT_SHIFT;

    logic signed [RES_Q_W-1:0] residue_q_small;

    // Declared HERE, not next to the instantiation at the bottom of the file.
    // An `always_ff` further down uses it, and this toolchain rejects a reference
    // to a symbol declared later:
    //     Error: ...srm_residue_estimator.sv:NNN: The symbol 'lut_out' is not
    //     defined. (VER-956)
    // which cost a full scan run before it was spotted. The INSTANTIATION can
    // stay at the bottom, because a declaration only has to precede its first
    // USE and the port connection there is itself a use of an already-declared
    // symbol.
    logic signed [LUT_OUT_WIDTH-1:0] lut_out;

    function automatic logic signed [RESIDUE_WIDTH-1:0] sext_res(
        input logic signed [RES_Q_W-1:0] v
    );
        begin
            sext_res = $signed({{(RESIDUE_WIDTH-RES_Q_W){v[RES_Q_W-1]}}, v});
        end
    endfunction

    // always_comb, not `assign`: residue_q is declared `output logic`, and a
    // continuous assignment to a variable is not portable. The three writes that
    // used to target residue_q directly now target residue_q_small, so there is
    // still exactly one driver per bit.
    always_comb residue_q = sext_res(residue_q_small);

    // =========================================================================
    // 4. Reset release and four-phase transaction ownership
    // =========================================================================
    // Assertion is asynchronous; release takes two local rising edges. External
    // requests must wait until release. A stopped domain remains safely reset.
    (* ASYNC_REG = "TRUE" *) logic clk_rst_s1, clk_rst_s2;
    (* ASYNC_REG = "TRUE" *) logic dec_rst_s1, dec_rst_s2;
    wire clk_rst_n = clk_rst_s2;
    wire dec_rst_n = dec_rst_s2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_rst_s1 <= 1'b0;
            clk_rst_s2 <= 1'b0;
        end else begin
            clk_rst_s1 <= 1'b1;
            clk_rst_s2 <= clk_rst_s1;
        end
    end
    always_ff @(posedge dec_clk or negedge rst_n) begin
        if (!rst_n) begin
            dec_rst_s1 <= 1'b0;
            dec_rst_s2 <= 1'b0;
        end else begin
            dec_rst_s1 <= 1'b1;
            dec_rst_s2 <= dec_rst_s1;
        end
    end

    // req_active is held until the decision domain acknowledges the arm. Even
    // if the watchdog fires before that acknowledgement, the request is not
    // withdrawn early: otherwise a stopped dec_clk could hide a pending arm.
    // After publication the request is lowered, and busy remains asserted until
    // both acknowledgement and completion return low. There is never more than
    // one outstanding request, so no old completion can own a new transaction.
    logic req_active;
    (* ASYNC_REG = "TRUE" *) logic req_s1, req_s2;
    (* ASYNC_REG = "TRUE" *) logic ack_s1, ack_s2;
    (* ASYNC_REG = "TRUE" *) logic done_s1, done_s2;

    always_ff @(posedge dec_clk or negedge dec_rst_n) begin
        if (!dec_rst_n) begin
            req_s1 <= 1'b0;
            req_s2 <= 1'b0;
        end else begin
            req_s1 <= req_active;
            req_s2 <= req_s1;
        end
    end

    // =========================================================================
    // 5. Decision-domain acquisition and registered Gray source words
    // =========================================================================
    logic [CNT_W-1:0] dec_ones, dec_total;
    logic [CNT_W-1:0] ones_g, total_g;
    logic dec_run, dec_ack, dec_done;
    wire arm_dec = req_s2 && !dec_ack;

    always_ff @(posedge dec_clk or negedge dec_rst_n) begin
        if (!dec_rst_n) begin
            dec_ones  <= '0;
            dec_total <= '0;
            ones_g    <= '0;
            total_g   <= '0;
            dec_run   <= 1'b0;
            dec_ack   <= 1'b0;
            dec_done  <= 1'b0;
        end else if (!req_s2) begin
            // Retire/cancel. Keep payload frozen until the next acknowledged
            // arm; no moving partial count is ever published on timeout.
            dec_run  <= 1'b0;
            dec_ack  <= 1'b0;
            dec_done <= 1'b0;
        end else if (arm_dec) begin
            dec_ones  <= '0;
            dec_total <= '0;
            ones_g    <= '0;
            total_g   <= '0;
            dec_run   <= 1'b1;
            dec_ack   <= 1'b1;
            dec_done  <= 1'b0;
        end else if (dec_run && decision_valid) begin
            if (decision_bit) begin
                dec_ones <= dec_ones + 1'b1;
                ones_g   <= bin2gray(dec_ones + 1'b1);
            end
            dec_total <= dec_total + 1'b1;
            total_g   <= bin2gray(dec_total + 1'b1);
            if (dec_total == DEC_TARGET - 1'b1) begin
                dec_run  <= 1'b0;
                dec_done <= 1'b1;
            end
        end
    end

    // Registered Gray words avoid the source combinational binary-to-Gray
    // glitch hazard. Arm clearing can change multiple Gray bits, so this is a
    // bundled frozen-data handshake, not an unconditional live-count CDC claim.
    // The receiver uses counts only after this request's held completion. Real
    // implementation still needs synchronizer placement and bounded data delay.
    (* ASYNC_REG = "TRUE" *) logic [CNT_W-1:0] ones_g_s1, ones_g_s2;
    (* ASYNC_REG = "TRUE" *) logic [CNT_W-1:0] tot_g_s1, tot_g_s2;
    always_ff @(posedge clk or negedge clk_rst_n) begin
        if (!clk_rst_n) begin
            ones_g_s1 <= '0;
            ones_g_s2 <= '0;
            tot_g_s1  <= '0;
            tot_g_s2  <= '0;
            ack_s1    <= 1'b0;
            ack_s2    <= 1'b0;
            done_s1   <= 1'b0;
            done_s2   <= 1'b0;
        end else begin
            ones_g_s1 <= ones_g;
            ones_g_s2 <= ones_g_s1;
            tot_g_s1  <= total_g;
            tot_g_s2  <= tot_g_s1;
            ack_s1    <= dec_ack;
            ack_s2    <= ack_s1;
            done_s1   <= dec_done;
            done_s2   <= done_s1;
        end
    end

    // =========================================================================
    // 6. Housekeeping FSM and shared acceptance predicate
    // =========================================================================
    typedef enum logic [2:0] {
        S_IDLE, S_WAIT, S_SETTLE, S_LUT, S_DRAIN, S_HOLD
    } state_t;
    state_t state;
    wire accept_request = start && !busy &&
                          ((state == S_IDLE) || (state == S_HOLD));
    logic [CNT_W-1:0] cap_ones, cap_total;
    logic cap_shortfall;
    localparam int STALL_W = (STALL_CYCLES < 2) ? 1 : $clog2(STALL_CYCLES + 1);
    logic [STALL_W-1:0] stall_cnt;
    wire stall_trip = (STALL_CYCLES > 0) && (state == S_WAIT) &&
                      (stall_cnt >= STALL_W'(STALL_CYCLES));
    wire done_now = req_active && ack_s2 && done_s2;

    always_ff @(posedge clk or negedge clk_rst_n) begin
        if (!clk_rst_n) begin
            state           <= S_IDLE;
            req_active      <= 1'b0;
            cap_ones        <= '0;
            cap_total       <= '0;
            cap_shortfall   <= 1'b0;
            stall_cnt       <= '0;
            busy            <= 1'b0;
            done            <= 1'b0;
            residue_valid   <= 1'b0;
            residue_q_small <= '0;
            ones_count      <= '0;
            total_count     <= '0;
            count_shortfall <= 1'b0;
            stalled         <= 1'b0;
        end else begin
            done <= 1'b0;
            if (residue_consume) residue_valid <= 1'b0;

            // Start wins over consume when both are present at a ready edge.
            // busy is asserted on THIS acceptance edge, not a cycle later.
            if (accept_request) begin
                state           <= S_WAIT;
                req_active      <= 1'b1;
                busy            <= 1'b1;
                stall_cnt       <= '0;
                residue_valid   <= 1'b0;
                residue_q_small <= '0;
                ones_count      <= '0;
                total_count     <= '0;
                count_shortfall <= 1'b0;
                stalled         <= 1'b0;
            end else begin
                case (state)
                    S_IDLE: ;
                    S_WAIT: begin
                        // Completion wins a simultaneous watchdog edge. A
                        // timeout never samples unfrozen or old count buses.
                        if (done_now) begin
                            cap_shortfall <= 1'b0;
                            state         <= S_SETTLE;
                        end else if (stall_trip) begin
                            cap_ones      <= '0;
                            cap_total     <= '0;
                            cap_shortfall <= 1'b1;
                            stalled       <= 1'b1;
                            if (ack_s2) req_active <= 1'b0;
                            state <= S_SETTLE;
                        end else if (STALL_CYCLES > 0) begin
                            stall_cnt <= stall_cnt + 1'b1;
                        end
                    end
                    S_SETTLE: begin
                        // One full destination-clock settling interval after
                        // observing completion before capturing the payload.
                        if (!cap_shortfall) begin
                            cap_ones      <= gray2bin(ones_g_s2);
                            cap_total     <= gray2bin(tot_g_s2);
                            cap_shortfall <= (gray2bin(tot_g_s2) != DEC_TARGET);
                        end
                        if (ack_s2) req_active <= 1'b0;
                        state <= S_LUT;
                    end
                    S_LUT: begin
                        ones_count      <= cap_ones;
                        total_count     <= cap_total;
                        count_shortfall <= cap_shortfall;
                        // A failed measurement has a neutral payload. The
                        // consumer MUST inspect error flags and validity.
                        if (cap_shortfall) residue_q_small <= '0;
                        else residue_q_small <= $signed({lut_out, {LUT_SHIFT{1'b0}}});
                        residue_valid <= 1'b1;
                        done          <= 1'b1;
                        state         <= S_DRAIN;
                    end
                    S_DRAIN: begin
                        if (req_active && ack_s2) req_active <= 1'b0;
                        if (!req_active && !ack_s2 && !done_s2) begin
                            busy  <= 1'b0;
                            state <= S_HOLD;
                        end
                    end
                    S_HOLD: begin
                        if (residue_consume) state <= S_IDLE;
                    end
                    default: begin
                        // Safe recovery cannot reopen acceptance while a
                        // request is outstanding; reset is the recovery path.
                        busy <= 1'b1;
                        state <= S_DRAIN;
                    end
                endcase
            end
        end
    end

`ifndef SYNTHESIS
    always_ff @(posedge clk) begin
        if (clk_rst_n && (state == S_LUT) && (cap_ones > DEC_TARGET))
            $error("srm_residue_estimator: LUT index exceeds DECISION_COUNT");
    end
`endif

    // =========================================================================
    // 9. SRM inverse-normal LUT -- its own leaf
    // ---------------------------------------------------------------------
    // Instantiated here, at the bottom, because its index is `cap_ones` and its
    // result is consumed in the S_LUT branch above. The leaf owns the table and
    // the check that (SIGMA_Q8, DECISION_COUNT) match it; see its header for the
    // width/symmetry reasoning and the measured area/precision curve.
    // =========================================================================
    // (`lut_out` is declared near the top of section 3, where it is used.)
    srm_residue_lut #(
        .DECISION_COUNT (DECISION_COUNT),
        .SIGMA_Q8       (SIGMA_Q8),
        .RES_FRAC       (RES_FRAC),
        .FRAC_OUT       (LUT_FRAC_OUT),
        .OUT_WIDTH      (LUT_OUT_WIDTH),
        .HALF_TABLE     (LUT_HALF_TABLE)
    ) u_lut (
        .cnt   (cap_ones),
        .v_res (lut_out)
    );

endmodule
