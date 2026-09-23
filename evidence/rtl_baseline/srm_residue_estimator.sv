`timescale 1ns/1ps

// =============================================================================
// File Name   : srm_residue_estimator.sv
// Module Name : srm_residue_estimator
// Version     : 4.0  (paper-aligned; supersedes 3.0)
// Description : Statistical residue measurement (SRM) digital estimator.
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
//   * CDC       -- one-way, monotone, gray-coded readout of two frozen
//                  counters. Safe by construction: a binary up-counter's gray
//                  image changes in exactly one bit per increment, so no
//                  incoherent multi-bit capture is possible; the values are
//                  additionally sampled only after `dec_done` has frozen them,
//                  through a synchroniser chain of identical depth.
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

    output logic                    busy,
    output logic                    done,             // one-clock completion strobe
    output logic                    residue_valid,    // one-shot: fresh until consumed

    output logic [4:0]              ones_count,       // "1" decisions observed (port width matches v3.0)
    output logic [4:0]              total_count,      // decisions observed (== DECISION_COUNT unless shortfall)
    output logic                    count_shortfall,  // measurement used < DECISION_COUNT samples
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
    // A binary up-counter's gray image differs from its predecessor in exactly
    // one bit, so a multi-bit 2-flop synchroniser of the gray word can never
    // capture a torn intermediate value.
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
    // 4. `start` (clk) -> decision domain, toggle handshake
    //    A toggle is used instead of a pulse because dec_clk may be slower than
    //    clk, in which case a one-clk pulse could be missed entirely.
    // =========================================================================
    logic go_tgl;                                // clk domain
    logic go_tgl_s1, go_tgl_s2, go_tgl_s3;       // dec domain sync chain

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) go_tgl <= 1'b0;
        else if (start && !busy) go_tgl <= ~go_tgl;
    end

    always_ff @(posedge dec_clk or negedge rst_n) begin
        if (!rst_n) begin
            go_tgl_s1 <= 1'b0;
            go_tgl_s2 <= 1'b0;
            go_tgl_s3 <= 1'b0;
        end else begin
            go_tgl_s1 <= go_tgl;
            go_tgl_s2 <= go_tgl_s1;
            go_tgl_s3 <= go_tgl_s2;
        end
    end

    wire arm_dec = (go_tgl_s2 ^ go_tgl_s3);      // any edge -> one dec_clk pulse

    // =========================================================================
    // 5. Decision-domain counters -- one increment per decision, always
    // =========================================================================
    logic [CNT_W-1:0] dec_ones;      // number of "1" decisions
    logic [CNT_W-1:0] dec_total;     // number of decisions observed
    logic             dec_run;       // high from arm until dec_total == DECISION_COUNT
    logic             dec_done_tgl;  // TOGGLES once per completed measurement

    // The completion indicator is a TOGGLE, not a level, and that choice is
    // load-bearing. A level would be indistinguishable from the previous
    // measurement's completion for the few housekeeping cycles it takes the
    // synchroniser to drain: measured directly, the first version of this
    // module left dec_done high from the previous run, so a freshly armed
    // measurement saw `measure_done` already true, captured the counters while
    // they were still being cleared, and published a garbage count (the
    // symptom was a LUT index of 28 against a maximum of 22). A toggle has
    // exactly one edge per measurement, so the edge detector in the
    // housekeeping domain can only ever fire for the measurement it belongs to,
    // whatever the clock ratio and however short the measurement is.
    always_ff @(posedge dec_clk or negedge rst_n) begin
        if (!rst_n) begin
            dec_ones     <= '0;
            dec_total    <= '0;
            dec_run      <= 1'b0;
            dec_done_tgl <= 1'b0;
        end else if (arm_dec) begin
            dec_ones  <= '0;
            dec_total <= '0;
            dec_run   <= 1'b1;
        end else if (dec_run && decision_valid) begin
            // Every decision is counted. There is deliberately no per-clock
            // ceiling here: that is the entire point of the v4 architecture.
            if (decision_bit) dec_ones <= dec_ones + 1'b1;

            if (dec_total == DEC_TARGET - 1'b1) begin
                dec_total    <= DEC_TARGET;
                dec_run      <= 1'b0;            // freeze both counters
                dec_done_tgl <= ~dec_done_tgl;   // exactly one edge per measurement
            end else begin
                dec_total <= dec_total + 1'b1;
            end
        end
    end

    // =========================================================================
    // 6. dec -> clk readout (gray sync, sampled only once frozen)
    //    `dec_done` and the two gray words travel through synchroniser chains of
    //    identical depth, so when dec_done_s2 is high the counters have provably
    //    been stable for at least (2 dec_clk + 2 clk) and cannot tear.
    // =========================================================================
    logic [CNT_W-1:0] ones_g, total_g;
    always_comb begin
        ones_g  = bin2gray(dec_ones);
        total_g = bin2gray(dec_total);
    end

    logic [CNT_W-1:0] ones_g_s1, ones_g_s2;
    logic [CNT_W-1:0] tot_g_s1,  tot_g_s2;
    logic             tgl_s1, tgl_s2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ones_g_s1 <= '0;   ones_g_s2 <= '0;
            tot_g_s1  <= '0;   tot_g_s2  <= '0;
            tgl_s1 <= 1'b0;    tgl_s2 <= 1'b0;
        end else begin
            ones_g_s1 <= ones_g;       ones_g_s2 <= ones_g_s1;
            tot_g_s1  <= total_g;      tot_g_s2  <= tot_g_s1;
            tgl_s1 <= dec_done_tgl;    tgl_s2 <= tgl_s1;
        end
    end

    // =========================================================================
    // 7. Housekeeping FSM
    // =========================================================================
    typedef enum logic [2:0] {
        S_IDLE,
        S_ARM,        // handshake toggled; the decision domain is about to start
        S_WAIT,       // counting decisions
        S_SETTLE,     // dec_done seen; one cycle of margin before the LUT
        S_LUT,        // apply the LUT and publish residue_valid
        S_HOLD        // hold residue_valid until consumed
    } state_t;

    state_t state, next_state;

    logic [CNT_W-1:0] cap_ones, cap_total;
    logic             cap_shortfall;

    // Width DERIVED from STALL_CYCLES instead of a flat 32. At the default
    // STALL_CYCLES = 64 this is 7 bits: 25 flip-flops fewer, ~1.2k um^2 in this
    // library, for a counter that can never legitimately exceed 64 (it is cleared
    // in S_ARM and only counts up inside S_WAIT). Found by asking what the
    // estimator's 131 registers actually ARE -- a question that only became
    // answerable once the LUT was extracted and its own area stopped hiding them.
    localparam int STALL_W = (STALL_CYCLES < 2) ? 1 : $clog2(STALL_CYCLES + 1);
    logic [STALL_W-1:0] stall_cnt;
    logic             done_pending;   // sticky: this measurement completed
    logic             tgl_ref;        // synchronised toggle value captured at arm

    wire stall_trip = (STALL_CYCLES > 0) && (state == S_WAIT) &&
                      (stall_cnt >= STALL_W'(STALL_CYCLES));

    // "This measurement finished" is decided by comparing the synchronised
    // toggle against the value latched at ARM time, not by edge-detecting a
    // synchronised pulse. Both are valid, but the comparison additionally
    // survives a pulse that would have been narrower than a housekeeping clock,
    // and -- the reason it is here -- it can never be satisfied by state left
    // over from the previous measurement. If the re-arm handshake itself fails
    // (which is exactly what happened when `busy` was left stuck high and
    // suppressed the toggle), no toggle difference can appear, `done_pending`
    // stays low, the watchdog fires, and the shortfall flag reports it. The
    // earlier, pulse-based version captured the PREVIOUS measurement's counters
    // and published them as a fresh result.
    wire done_now = (tgl_s2 != tgl_ref);

    always_comb begin
        next_state = state;
        case (state)
            S_IDLE:   next_state = start ? S_ARM : S_IDLE;
            S_ARM:    next_state = S_WAIT;
            S_WAIT:   next_state = ((done_pending || done_now) || stall_trip)
                                   ? S_SETTLE : S_WAIT;
            S_SETTLE: next_state = S_LUT;
            S_LUT:    next_state = S_HOLD;
            S_HOLD:   next_state = residue_consume ? S_IDLE
                                  : (start ? S_ARM : S_HOLD);
            default:  next_state = S_IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;
        else        state <= next_state;
    end

    // Capture happens exactly on the S_WAIT -> S_SETTLE edge, once this
    // measurement's completion has been observed. On the watchdog path whatever
    // the counters currently hold is read and the shortfall is recorded rather
    // than silently presenting a low count as a valid estimate -- and the same
    // comparison catches an incoherent capture independently of the watchdog, so
    // a CDC mistake cannot hide behind a plausible-looking residue.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cap_ones      <= '0;
            cap_total     <= '0;
            cap_shortfall <= 1'b0;
            stall_cnt     <= '0;
            done_pending  <= 1'b0;
            tgl_ref       <= 1'b0;
        end else begin
            if (state == S_ARM) begin
                stall_cnt    <= '0;
                done_pending <= 1'b0;
                tgl_ref      <= tgl_s2;   // remember the previous run's toggle
            end else if (state == S_WAIT) begin
                stall_cnt <= stall_cnt + 1'b1;
                if (done_now) done_pending <= 1'b1;
            end

            if ((state == S_WAIT) && (done_pending || done_now || stall_trip)) begin
                cap_ones      <= gray2bin(ones_g_s2);
                cap_total     <= gray2bin(tot_g_s2);
                cap_shortfall <= stall_trip | ~(done_pending | done_now)
                                            | (gray2bin(tot_g_s2) != DEC_TARGET);
            end
        end
    end

    // =========================================================================
    // 8. Status / handshake outputs
    // =========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
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

            case (state)
                S_IDLE: begin
                    busy      <= 1'b0;
                    stalled   <= 1'b0;
                end

                S_ARM: begin
                    busy            <= 1'b1;
                    stalled         <= 1'b0;
                    // Clear the published value so a downstream block that
                    // ignores residue_valid can never read stale data.
                    residue_q_small <= '0;
                    residue_valid   <= 1'b0;
                    count_shortfall <= 1'b0;
                    ones_count      <= '0;
                    total_count     <= '0;
                end

                S_WAIT: begin
                    busy <= 1'b1;
                    if (stall_trip) stalled <= 1'b1;
                end

                S_SETTLE: busy <= 1'b1;   // one cycle of margin

                S_LUT: begin
                    // `busy` MUST drop as soon as the result is published. It
                    // gates the `start && !busy` condition that toggles the
                    // re-arm handshake, so a `busy` that is never cleared
                    // silently disables every measurement after the first one:
                    // the decision domain is never armed again, the watchdog
                    // eventually fires, and the stale previous counters are
                    // published as a fresh result.
                    busy            <= 1'b0;
                    ones_count      <= cap_ones;
                    total_count     <= cap_total;
                    count_shortfall <= cap_shortfall;
                    // Store only the significant bits: lut_out widened by the
                    // shift-back. The low LUT_SHIFT bits are structurally zero,
                    // which is precisely why the register does not need them.
                    residue_q_small <= $signed({lut_out, {LUT_SHIFT{1'b0}}});
                    residue_valid   <= 1'b1;
                    done            <= 1'b1;
                end

                S_HOLD: begin
                    busy <= 1'b0;
                    if (residue_consume) residue_valid <= 1'b0;
                end

                default: ;
            endcase
        end
    end

`ifndef SYNTHESIS
    // The LUT index is `cap_ones`, which must never exceed DECISION_COUNT. The
    // generated `default:` entry covers out-of-range indices, but reaching it
    // means the counters were read while still moving -- a CDC bug, not a benign
    // case. Fail loudly instead of silently returning 258.
    always_ff @(posedge clk) begin
        if (rst_n && (state == S_LUT) && (cap_ones > DEC_TARGET))
            $error("srm_residue_estimator v4: LUT index %0d exceeds DECISION_COUNT=%0d -- incoherent CDC capture.",
                   cap_ones, DECISION_COUNT);
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
