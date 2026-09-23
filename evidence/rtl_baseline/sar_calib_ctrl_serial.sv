`timescale 1ns/1ps

// =============================================================================
// File Name   : sar_calib_ctrl_serial.sv
// Module Name : sar_calib_ctrl_serial
// Version     : 4.2  (paper-aligned; supersedes 3.0)
// Description : Split-sampling SAR ADC foreground recursive calibration
//               controller (serial / multi-cycle compute variant).
//
// Functionality :
//   Implements the paper's "measure-then-set" recursive bit-weight calibration.
//   The already-known lower capacitors act as the reference DAC used to measure
//   the actual weight of the next higher capacitor through a SAR search. The
//   result is averaged over AVG_LOOPS in each of two conversion directions and
//   written back both to the external weight interface and to the shadow RAM, so
//   the next bit up can be measured with a larger reference DAC.
//
//   Mapping to Huang 2024 (HKUST) Ch.4 §4.5, Figure 4.16 / 4.17:
//     * LSB section b0..b5 (MAX_CALIB_BIT) is the always-trusted calibration DAC
//     * target bits b6..b19 are measured recursively, lowest first
//     * two conversion directions: D_W = (D_W+ - D_W-) / 2 cancels V_os   (4.19)
//     * 32 repeats -> 64x averaging -> weight noise sigma(W)/8
//     * MSB protection: calibrating b18 forces b17, calibrating b19 forces
//       b17 and b18, so v_DAC,x stays at W17 instead of the full swing and the
//       over-range issue of §4.5 is avoided
//
// -----------------------------------------------------------------------------
// CHANGELOG vs v4.1  (v4.2 -- pure timing, no functional change)
// -----------------------------------------------------------------------------
// [FIX T1] The finalize's half-LSB add no longer exists as an adder.
//
//     v4.1 pipelined the finalize into
//         stage 1: accumulator + 2^AVG_SHIFT
//         stage 2: (stage1 >>> (AVG_SHIFT+1)) + HALF_LSB
//     Stage 2 is a CONSTANT add, so synthesis built a ripple incrementer whose
//     carry runs from bit (FRAC-1) to bit WEIGHT_WIDTH-1. STA on the routed
//     block with SPEF measured 39 levels of logic in 9.70 ns of a 10.00 ns
//     period: slow-corner slack +0.0377 ns, i.e. exactly 0.000 once the
//     +/-3 % OCV derate is applied. Pipelining had already been tried; it
//     moved the critical path instead of removing it.
//
//     floor(x/n) + k == floor((x + k*n)/n) lets the two steps be written as a
//     single constant add, and because `accumulator` is only ever initialised
//     and accumulated, that constant can be planted in the initial value. The
//     add then leaves the critical path entirely:
//         S_INIT_TARGET: accumulator <= ROUND_K
//         finalize     : calc_result  = accumulator >>> (AVG_SHIFT+1)
//     `avg_rounded` and `calc_result_ext` become wiring / a shift. Bit-exact
//     (verified by p_round_fold_guard over 131 072 values, both signs), zero
//     added latency, and it REMOVES a 37-bit and a 31-bit adder from the
//     design instead of adding logic. The parameter ROUND_HALF_LSB and the
//     external behaviour of calc_result_wire / w_wr_data are unchanged.
//
// -----------------------------------------------------------------------------
// CHANGELOG vs v3.0
// -----------------------------------------------------------------------------
//  [FIX P1] The half-LSB search bias is now removed.  THIS IS THE HEADLINE
//     CHANGE OF v4.0 AND IT IS A REAL ACCURACY DEFECT IN v3.0.
//
//     The measurement is a SAR search for the largest reference-DAC code whose
//     voltage does not exceed the target, i.e. it quantises DOWNWARD:
//
//         m * W0  <=  W_k  <  (m + 1) * W0        =>  E[m * W0] = W_k - W0/2
//
//     so every measured bit weight came out systematically low by exactly half
//     of the calibration DAC's own LSB.  For the split-cap weight table
//     (W6 = 33.53 * W0) that is 0.5 / 33.53 = 1.49 %, which is precisely the
//     figure v3.0's header documented and then chose to absorb in the
//     reconstruction's full-scale normalisation.
//
//     Absorbing it in the normalisation is not equivalent, and v3.0's own
//     reasoning ("a pure GAIN error, harmless for INL/DNL") does not hold: the
//     bias is an absolute -W0/2 on EVERY measured weight, not a scaling.  The
//     reconstructed code is sum(b_k * (W_k - W0/2)), so the error term
//     -W0/2 * popcount(b) depends on how many bits happen to be set, which is a
//     code-dependent (i.e. linearity) error, not a gain.  The normalisation can
//     only remove the part of it that happens to look like a gain.
//
//     v4.0 adds the missing half LSB to the averaged measurement, turning the
//     estimator from round-down into round-to-nearest.  ROUND_HALF_LSB = 0
//     reproduces v3.0 exactly so the A/B in tb/tb_sar16_v4.sv can quantify it.
//
//  [FIX P2] Calibration-DAC over-range is now detected and reported.
//     The paper is explicit that this is a designed-in limit, not a corner
//     case: "the redundancy of the calibration DAC provides a 4-sigma cover
//     range for the offset" (§4.5), with sigma(V_os) = 300 uV from Monte Carlo
//     and a redundancy bound of +/-1.2 mV.  A 4-sigma design means the tail is
//     *expected* to be exercised across a production spread.  v3.0 had no
//     detection at all: when the offset exceeded the redundancy the search
//     railed on the calibration-DAC limit, the saturated code was written back
//     as if it were a legal weight, and `calib_done` was raised anyway.  The
//     chip would then run with a silently wrong weight table.
//
//     v4.0 flags a railed search per averaging loop (`o_loop_overrange`) and
//     latches the run-level status in `calib_overrange`.  `calib_done` still
//     rises -- the calibration did complete -- but a host can now refuse to
//     trust the table, which is the entire purpose of a redundancy budget.
//
//  [ASIC] Over-range detection adds only a per-loop mask compare; the search,
//     averaging and drive-matrix datapath are unchanged from v3.0, so the
//     timing characteristics of the verified flow are preserved.
// =============================================================================

module sar_calib_ctrl_serial #(
    parameter int CAP_NUM        = 20,   // Total capacitor bit count (bit 0 ~ 19)
    parameter int WEIGHT_WIDTH   = 30,   // Signed Q8 weight width; 256 = 1 weight LSB
    parameter int COMP_WAIT_CYC  = 16,   // Comparator / DAC settling time in clocks
    parameter int AVG_LOOPS      = 32,   // Averaging count (power of two)
    parameter int MAX_CALIB_BIT  = 5,    // Highest bit of the calibration-free LSB segment
    parameter int REF_WEIGHT_LSB = 256,  // Ideal weight of bit 0 in Q8 units

    // --- v4.0 options -------------------------------------------------------
    // 1 = round-to-nearest (add REF_WEIGHT_LSB/2 to every measured weight).
    // 0 = exact v3.0 behaviour, kept for A/B measurement of the bias.
    parameter bit ROUND_HALF_LSB = 1'b1,
    // 1 = enable calibration-DAC over-range detection and reporting.
    parameter bit DETECT_OVERRANGE = 1'b1
)(
    // --- Global Signals ---
    input  logic                          clk,
    input  logic                          rst_n,          // Asynchronous, active low

    // --- Control Plane ---
    input  logic                          start_calib,    // Level or pulse; high in idle starts a run
    output logic                          calib_done,     // Sticky: high from completion until restart
    output logic                          calib_done_pulse, // One-clock strobe at completion
    output logic                          calib_mode_en,  // High while a calibration run is in progress

    // --- Analog Front End ---
    input  logic                          comp_out,       // Comparator result (1: Vp > Vn)
    output logic [CAP_NUM-1:0]            dac_p_force,
    output logic [CAP_NUM-1:0]            dac_n_force,

    // --- Register File Write-Back ---
    output logic                          w_wr_en,
    output logic [4:0]                    w_wr_addr,
    output logic signed [WEIGHT_WIDTH-1:0] w_wr_data,

    // --- v4.0 status --------------------------------------------------------
    output logic                          calib_overrange, // sticky: any measured bit railed during this run
    output logic [CAP_NUM-1:0]            overrange_bits   // per-bit map of railed measurements
);

    localparam int AVG_SHIFT      = $clog2(AVG_LOOPS);
    localparam int ACCUM_W        = WEIGHT_WIDTH + AVG_SHIFT + 2;
    localparam int CAP_IDX_WIDTH  = (CAP_NUM <= 2) ? 1 : $clog2(CAP_NUM);
    localparam int CALC_CNT_WIDTH = (CAP_NUM <= 1) ? 1 : $clog2(CAP_NUM + 1);
    localparam int WAIT_CNT_WIDTH = (COMP_WAIT_CYC <= 1) ? 1 : $clog2(COMP_WAIT_CYC + 1);
    localparam int AVG_CNT_WIDTH  = (AVG_LOOPS <= 1) ? 1 : $clog2(AVG_LOOPS);

    localparam int PROTECT_START_BIT     = CAP_NUM - 2;   // bit 18
    localparam int PROTECT_LOW_BIT       = CAP_NUM - 3;   // bit 17
    localparam int PROTECT_SEARCH_TOPBIT = CAP_NUM - 4;   // bit 16

    localparam logic [CAP_IDX_WIDTH-1:0]  LAST_TARGET_BIT  = CAP_NUM - 1;
    localparam logic [CAP_IDX_WIDTH-1:0]  FIRST_TARGET_BIT = MAX_CALIB_BIT + 1;
    localparam logic [CAP_IDX_WIDTH-1:0]  PROT_START_IDX   = PROTECT_START_BIT;
    localparam logic [CAP_IDX_WIDTH-1:0]  PROT_SEARCH_IDX  = PROTECT_SEARCH_TOPBIT;
    localparam logic [WAIT_CNT_WIDTH-1:0] WAIT_INIT        = COMP_WAIT_CYC;
    localparam logic [CALC_CNT_WIDTH-1:0] CALC_LAST        = CAP_NUM;
    localparam logic [AVG_CNT_WIDTH-1:0]  AVG_LAST         = AVG_LOOPS - 1;

    localparam logic signed [WEIGHT_WIDTH-1:0] REF_WEIGHT_INIT = REF_WEIGHT_LSB;

    // Round-to-nearest correction: half of the calibration DAC's own LSB.
    localparam logic signed [WEIGHT_WIDTH-1:0] HALF_LSB =
        ROUND_HALF_LSB ? WEIGHT_WIDTH'(REF_WEIGHT_LSB / 2) : '0;

    // -------------------------------------------------------------------------
    // v4.2: the entire finalize step is collapsed into ONE constant that is
    // planted in the accumulator's INITIAL VALUE.
    //
    // v4.1 evaluated the finalize as two arithmetic steps chained through a
    // pipeline register:
    //     stage 1:  avg_rounded = accumulator + 2^AVG_SHIFT
    //     stage 2:  calc_result = (avg_rounded >>> (AVG_SHIFT+1)) + HALF_LSB
    // Stage 2 is an add of a CONSTANT whose lowest set bit sits at bit
    // (FRAC-1) of the weight, so synthesis mapped it to a naive ripple
    // incrementer. The carry then had to walk from that bit up to bit
    // WEIGHT_WIDTH-1 of the result, and PrimeTime on the routed database with
    // parasitics measured exactly that -- 39 levels of logic in 9.70 ns of a
    // 10.00 ns period, slow-corner slack +0.0377 ns, i.e. WNS 0.000 as soon as
    // the +/-3 % OCV derate this block is signed off with is applied. Pipelining
    // had already been tried once (that is what produced stage 1 / stage 2 at
    // all); it moved the path rather than removing it.
    //
    // The two steps are algebraically ONE rounding step. Verilog's `>>>` on a
    // signed value is exactly floor-division by 2^n, and
    //     floor(x/n) + k  ==  floor((x + k*n)/n)          integer k, n > 0
    // so with n = 2^(AVG_SHIFT+1) and k = HALF_LSB
    //     (accumulator + 2^S) >>> (S+1) + H
    //   = (accumulator + 2^S + H*2^(S+1)) >>> (S+1)
    //   = (accumulator + ROUND_K)         >>> (S+1)
    // One add of one constant -- and because `accumulator` is only ever
    // INITIALISED to zero and then accumulated, that constant belongs in the
    // initial value, not at the end:
    //     S_INIT_TARGET: accumulator <= ROUND_K
    //     S_UPDATE_*:    calc_result  = accumulator >>> (AVG_SHIFT+1)
    // The add therefore leaves the critical path completely instead of being
    // re-pipelined: with the bias planted up front, stage 1 and stage 2 are
    // pure wiring and not one gate is left between `accumulator` and
    // `w_wr_data`. This is exact, not an approximation -- see the exhaustive
    // fold guard in the parameter-check block below, which compares this form
    // against the literal v4.1 form bit for bit.
    //
    // The shift by (AVG_SHIFT+1) is deliberately KEPT rather than merged into
    // the accumulator's width: `calc_result_r` latches it, so the three-stage
    // write-back pipeline and therefore the calibration's cycle count
    // (207 352 cycles) are unchanged. Stage 1/2 are now delay-only stages; they
    // can be collapsed in a later revision, but collapsing them here would
    // change the documented latency and invalidate every existing timing
    // assertion for no functional gain.
    // -------------------------------------------------------------------------
    localparam logic signed [ACCUM_W-1:0] ROUND_K =
          (ACCUM_W'(1) <<< AVG_SHIFT)
        + (ACCUM_W'(HALF_LSB) <<< (AVG_SHIFT + 1));

    // =========================================================================
    // Parameter guards (elaboration / simulation only)
    // =========================================================================
`ifndef SYNTHESIS
    initial begin : p_parameter_guard
        if (CAP_NUM != 20)
            $error("sar_calib_ctrl_serial v4: MSB protection flow is qualified for CAP_NUM=20 only.");
        if (WEIGHT_WIDTH < 30)
            $error("sar_calib_ctrl_serial v4: WEIGHT_WIDTH must be >= 30 for the Q8 split-weight range.");
        if (COMP_WAIT_CYC < 4)
            $error("sar_calib_ctrl_serial v4: COMP_WAIT_CYC must be >= 4 so the 2-flop comparator synchronizer stays inside the settling window.");
        if (AVG_LOOPS < 1)
            $error("sar_calib_ctrl_serial v4: AVG_LOOPS must be >= 1.");
        if ((AVG_LOOPS & (AVG_LOOPS - 1)) != 0)
            $error("sar_calib_ctrl_serial v4: AVG_LOOPS must be a power of two.");
        if (MAX_CALIB_BIT < 0)
            $error("sar_calib_ctrl_serial v4: MAX_CALIB_BIT must be non-negative.");
        if (MAX_CALIB_BIT >= CAP_NUM - 4)
            $error("sar_calib_ctrl_serial v4: MAX_CALIB_BIT must leave the 3 protected bits free.");
        if (REF_WEIGHT_LSB <= 0)
            $error("sar_calib_ctrl_serial v4: REF_WEIGHT_LSB must be positive.");
        if ((REF_WEIGHT_LSB % 2) != 0 && ROUND_HALF_LSB)
            $error("sar_calib_ctrl_serial v4: ROUND_HALF_LSB needs an even REF_WEIGHT_LSB or the half-LSB correction truncates.");

        // ---------------------------------------------------------------------
        // v4.2 guards for the round-bias fold
        // ---------------------------------------------------------------------
        // Headroom. |accumulator| never exceeds 2^(WEIGHT_WIDTH+AVG_SHIFT) -- it
        // is a full-scale weight accumulated over AVG_LOOPS two-sided
        // measurements -- and the container holds 2^(ACCUM_W-1). ROUND_K must
        // fit in what is left over, otherwise planting it up front would wrap
        // for large inputs instead of merely moving an add.
        if ((ACCUM_W - 1) < (WEIGHT_WIDTH + AVG_SHIFT))
            $error("sar_calib_ctrl_serial v4.2: ACCUM_W does not hold the accumulator's reachable range.");
        if (ROUND_K > (ACCUM_W'(1) <<< (ACCUM_W - 2)))
            $error("sar_calib_ctrl_serial v4.2: ROUND_K leaves no accumulator headroom in ACCUM_W bits.");

        // The fold is exact only because `>>>` is floor-division, and it stays
        // CORRECT only if ROUND_K really was built from the same AVG_SHIFT and
        // HALF_LSB that the folded expression uses. A width or signedness slip
        // there would bias every calibrated weight by half an LSB: invisible in
        // any waveform, and it would merely look like a slightly worse ADC.
        // So compare the folded form against the literal v4.1 two-step form,
        // bit for bit, over an exhaustive 16-bit sweep in both signs. The
        // sweep is deliberately narrow enough that no truncation or overflow
        // occurs, i.e. it tests the IDENTITY; wrap-around is covered by the
        // two guards above.
        begin : p_round_fold_guard
            logic signed [ACCUM_W-1:0]      a_f;
            logic signed [WEIGHT_WIDTH+1:0] ref_f;
            logic signed [WEIGHT_WIDTH+1:0] new_f;
            int unsigned                    bad_f;
            bad_f = 0;
            for (int unsigned i = 0; i < 32'h1_0000; i++) begin
                for (int unsigned sgn = 0; sgn < 2; sgn++) begin
                    a_f = (sgn == 0)
                        ? ACCUM_W'($signed({ {(ACCUM_W-16){1'b0}}, i[15:0]}))
                        : ACCUM_W'(-$signed({ {(ACCUM_W-16){1'b0}}, i[15:0]}));

                    // literal v4.1: (a + 2^S) >>> (S+1) + H
                    ref_f = (a_f + (ACCUM_W'(1) <<< AVG_SHIFT)) >>> (AVG_SHIFT + 1);
                    ref_f = ref_f + HALF_LSB;

                    // v4.2: a already carries the bias, so one shift
                    new_f = ACCUM_W'(a_f + ROUND_K) >>> (AVG_SHIFT + 1);

                    if (ref_f !== new_f) bad_f = bad_f + 1;
                end
            end
            if (bad_f != 0)
                $error("sar_calib_ctrl_serial v4.2: round-bias fold disagrees with the literal v4.1 form on %0d of 131072 values.", bad_f);
        end
    end
`endif

    // =========================================================================
    // 1. State machine
    // =========================================================================
    typedef enum logic [3:0] {
        S_IDLE,
        S_INIT_TARGET,

        S_PHASE_P_SETUP,
        S_PHASE_P_SAR,
        S_PHASE_P_CALC,

        S_PHASE_N_SETUP,
        S_PHASE_N_SAR,
        S_PHASE_N_CALC,

        S_ACCUMULATE,
        // The finalize is PIPELINED over three cycles. History, because both
        // revisions of it are in this file's changelog and only the second one
        // actually worked:
        //   v4.1 pipelined the two ADDS, which moved the slow-corner critical
        //        path from `accumulator -> shadow_weights` onto stage 2's
        //        constant add without shortening it (39 levels, 9.70 ns).
        //   v4.2 removed the adds entirely by folding the round bias into the
        //        accumulator's initial value, so S_UPDATE_ROUND and
        //        S_UPDATE_FINAL are now DELAY-ONLY stages.
        // The states are kept because they hold the calibration's cycle count
        // at 207 352: dropping them would change the documented latency, break
        // the cycle-count assertions in tb/tb_sar16_paper_core.sv, and gain
        // nothing, since the logic they would drop is already gone.
        S_UPDATE_ROUND,
        S_UPDATE_FINAL,
        S_UPDATE_WEIGHT,
        S_DONE
    } state_t;

    state_t state, next_state;

    // =========================================================================
    // 2. Internal signals
    // =========================================================================
    logic [CAP_IDX_WIDTH-1:0]  target_bit;
    logic [AVG_CNT_WIDTH-1:0]  avg_cnt;
    logic [WAIT_CNT_WIDTH-1:0] wait_cnt;

    logic [CAP_IDX_WIDTH-1:0]  sar_ptr;
    logic [CAP_NUM-1:0]        sar_code;

    logic [CALC_CNT_WIDTH-1:0] calc_cnt;
    logic signed [WEIGHT_WIDTH+5:0] temp_acc;

    logic signed [ACCUM_W-1:0]      accumulator;
    logic signed [WEIGHT_WIDTH-1:0] meas_val_p;
    logic signed [WEIGHT_WIDTH-1:0] meas_val_n;

    // --- pipelined finalize (v4.1 shape, v4.2 arithmetic-free content) ------
    // "calc_result_wire" is kept as the name the testbenches probe, and it now
    // carries the value that is actually written back.
    logic signed [WEIGHT_WIDTH-1:0] calc_result_wire;

    // Stage 1 and stage 2 no longer compute anything: v4.2 planted the round
    // bias in the accumulator's initial value, so stage 1 latches the
    // accumulator as-is and stage 2 shifts it. They survive purely to hold the
    // write-back latency (and therefore the calibration's cycle count) at the
    // value every existing timing assertion was written against.
    logic signed [ACCUM_W-1:0]      avg_rounded_r;   // stage 1: accumulator snapshot
    logic signed [WEIGHT_WIDTH+1:0] calc_result_r;   // stage 2: >>>(AVG_SHIFT+1)
    logic                           orr_r;           // over-range status travelling with the result
    logic [CAP_IDX_WIDTH-1:0]       wr_idx_r;        // which bit this result belongs to

    // Combinational INPUTS of the two pipeline stages. Declared HERE, next to the
    // registers, and not down in section 4b where the expressions live: the
    // always_ff above uses them, and this toolchain rejects a reference to a
    // symbol that is declared later in the file
    //     Error-[IND] Identifier 'avg_rounded' has not been declared yet.
    // (Same trap as the LUT leaf in the SRM estimator. The declaration only has to
    // precede its first USE, so the always_comb itself may stay further down.)
    logic signed [ACCUM_W-1:0]      avg_rounded;
    logic signed [WEIGHT_WIDTH+1:0] calc_result_ext;

    // Shadow RAM: holds the currently known weight of every bit.
    logic signed [WEIGHT_WIDTH-1:0] shadow_weights [CAP_NUM];

    // [ASIC] Two-flop synchronizer for the asynchronous comparator output.
    logic comp_out_r, comp_out_rr;

    logic signed [WEIGHT_WIDTH+5:0] compensated_meas;
    logic phase_p_active;
    logic phase_n_active;
    logic [CAP_NUM-1:0] target_drive_code;
    logic [CAP_NUM-1:0] protected_sar_code;

    // --- v4.0 over-range detection -----------------------------------------
    logic [CAP_NUM-1:0] search_mask;      // bits actually exercised by the search
    logic               rail_high;        // search saturated at the top of its range
    logic               rail_low;         // search saturated at the bottom
    logic               loop_overrange;
    logic               overrange_acc;    // OR over the averaging loops of this target

    assign phase_p_active = (state == S_PHASE_P_SETUP) ||
                            (state == S_PHASE_P_SAR)   ||
                            (state == S_PHASE_P_CALC);
    assign phase_n_active = (state == S_PHASE_N_SETUP) ||
                            (state == S_PHASE_N_SAR)   ||
                            (state == S_PHASE_N_CALC);

    // Digital restoration of the MSB-protection weight that was force-set
    // during the search and is therefore not present in the measured code.
    always_comb begin
        compensated_meas = temp_acc;
        if (target_bit == PROTECT_START_BIT) begin
            compensated_meas = compensated_meas + shadow_weights[PROTECT_LOW_BIT];
        end else if (target_bit == CAP_NUM - 1) begin
            compensated_meas = compensated_meas + shadow_weights[PROTECT_START_BIT]
                                               + shadow_weights[PROTECT_LOW_BIT];
        end
    end

    always_comb begin
        target_drive_code = '0;
        target_drive_code[target_bit] = 1'b1;

        protected_sar_code = sar_code;
        if (target_bit == PROTECT_START_BIT) begin
            protected_sar_code[PROTECT_LOW_BIT] = 1'b1;
        end else if (target_bit == CAP_NUM - 1) begin
            protected_sar_code[PROTECT_START_BIT] = 1'b1;
            protected_sar_code[PROTECT_LOW_BIT]   = 1'b1;
        end
    end

    // The set of bits the search is allowed to toggle: everything below the
    // target, except that the protected bits are deliberately skipped.
    always_comb begin
        search_mask = '0;
        if (target_bit >= PROT_START_IDX) begin
            for (int i = 0; i <= PROTECT_SEARCH_TOPBIT; i++)
                if (DETECT_OVERRANGE) search_mask[i] = 1'b1;
        end else begin
            for (int i = 0; i < CAP_NUM; i++)
                if (DETECT_OVERRANGE && (i < target_bit)) search_mask[i] = 1'b1;
        end
    end

    // A railed search means the calibration DAC could not reach the target, i.e.
    // V_os (plus the weight mismatch) exceeded the +/-W5 redundancy budget.
    assign rail_high    = DETECT_OVERRANGE && ((sar_code & search_mask) == search_mask);
    assign rail_low     = DETECT_OVERRANGE && ((sar_code & search_mask) == '0);
    assign loop_overrange = rail_high | rail_low;

    // =========================================================================
    // 3. State transition logic
    // =========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;
        else        state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            S_IDLE:          next_state = start_calib ? S_INIT_TARGET : S_IDLE;
            S_INIT_TARGET:   next_state = S_PHASE_P_SETUP;

            S_PHASE_P_SETUP: next_state = S_PHASE_P_SAR;
            S_PHASE_P_SAR:   next_state = ((wait_cnt == 0) && (sar_ptr == 0))
                                       ? S_PHASE_P_CALC : S_PHASE_P_SAR;
            S_PHASE_P_CALC:  next_state = (calc_cnt == CAP_NUM)
                                       ? S_PHASE_N_SETUP : S_PHASE_P_CALC;

            S_PHASE_N_SETUP: next_state = S_PHASE_N_SAR;
            S_PHASE_N_SAR:   next_state = ((wait_cnt == 0) && (sar_ptr == 0))
                                       ? S_PHASE_N_CALC : S_PHASE_N_SAR;
            S_PHASE_N_CALC:  next_state = (calc_cnt == CAP_NUM)
                                       ? S_ACCUMULATE : S_PHASE_N_CALC;

            S_ACCUMULATE:    next_state = (avg_cnt == AVG_LAST)
                                       ? S_UPDATE_ROUND : S_PHASE_P_SETUP;

            // Three cycles instead of one: latch the rounding sum, then the
            // shifted/offset result, then write it into the array. Each stage is
            // a short path; the previous single-cycle form was not.
            S_UPDATE_ROUND:  next_state = S_UPDATE_FINAL;
            S_UPDATE_FINAL:  next_state = S_UPDATE_WEIGHT;

            S_UPDATE_WEIGHT: next_state = (wr_idx_r == LAST_TARGET_BIT)
                                       ? S_DONE : S_INIT_TARGET;

            // Re-armable terminal state (v3.0 fix, retained).
            S_DONE:          next_state = start_calib ? S_INIT_TARGET : S_DONE;
            default:         next_state = S_IDLE;
        endcase
    end

    // =========================================================================
    // 4. Datapath
    // =========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            calib_done       <= 1'b0;
            calib_done_pulse <= 1'b0;
            calib_mode_en    <= 1'b0;
            target_bit       <= FIRST_TARGET_BIT;
            avg_cnt          <= '0;
            sar_code         <= '0;
            sar_ptr          <= '0;
            wait_cnt         <= '0;
            accumulator      <= '0;
            w_wr_en          <= 1'b0;
            w_wr_addr        <= '0;
            w_wr_data        <= '0;
            comp_out_r       <= 1'b0;
            comp_out_rr      <= 1'b0;
            meas_val_p       <= '0;
            meas_val_n       <= '0;
            calc_cnt         <= '0;
            temp_acc         <= '0;
            calib_overrange  <= 1'b0;
            overrange_bits   <= '0;
            overrange_acc    <= 1'b0;
            // v4.1 pipeline registers
            avg_rounded_r    <= '0;
            calc_result_r    <= '0;
            orr_r            <= 1'b0;
            wr_idx_r         <= FIRST_TARGET_BIT;

            // Calibration starts above MAX_CALIB_BIT; the LSB segment is the
            // trusted reference and is loaded with its ideal binary weights.
            for (int i = 0; i < CAP_NUM; i++) begin
                if (i <= MAX_CALIB_BIT)
                    shadow_weights[i] <= REF_WEIGHT_INIT <<< i;
                else
                    shadow_weights[i] <= '0;
            end
        end else begin
            w_wr_en          <= 1'b0;
            calib_done_pulse <= 1'b0;
            comp_out_r       <= comp_out;
            comp_out_rr      <= comp_out_r;

            case (state)
                S_IDLE: begin
                    calib_done    <= 1'b0;
                    calib_mode_en <= 1'b0;
                    target_bit    <= FIRST_TARGET_BIT;
                    // v4.0: the over-range status is per RUN, not per chip and not
                    // per target. A sticky-forever flag would make one out-of-spec
                    // calibration poison every later (perfectly good) run, which
                    // defeats the purpose of reporting it at all; a per-TARGET
                    // reset silently reports only the last target. Cleared here and
                    // on re-arm (S_DONE), never in S_INIT_TARGET.
                    calib_overrange <= 1'b0;
                    overrange_bits  <= '0;
                end

                S_INIT_TARGET: begin
                    calib_mode_en <= 1'b1;
                    calib_done    <= 1'b0;
                    // NOTE: the per-RUN resets (target_bit, calib_overrange,
                    // overrange_bits) are deliberately NOT here. This state is
                    // also the between-targets state
                    // (S_UPDATE_WEIGHT -> S_INIT_TARGET -> S_PHASE_P_SETUP), so a
                    // reset here happens fourteen times per run:
                    //   * resetting target_bit would pin the sweep to
                    //     FIRST_TARGET_BIT and write the same bit repeatedly;
                    //   * resetting the over-range status would leave only the
                    //     LAST target's flag standing, silently turning a
                    //     completely railed calibration into a one-bit report.
                    // They live in the run-entry states (S_IDLE, and S_DONE when
                    // re-armed) instead. Everything below IS genuinely per-target.
                    // v4.2: the accumulator starts at the folded round bias, not
                    // at zero. `accumulator` is only ever initialised and then
                    // accumulated (no comparison, no reload anywhere else in this
                    // file), so starting at ROUND_K is bit-for-bit identical to
                    // adding ROUND_K at the end -- but the add happens once, here,
                    // instead of on the critical path. See the ROUND_K block in
                    // section 0 for the derivation and the fold guard.
                    accumulator   <= ROUND_K;
                    avg_cnt       <= '0;
                    overrange_acc <= 1'b0;
                end

                S_PHASE_P_SETUP, S_PHASE_N_SETUP: begin
                    sar_code <= '0;
                    // Skip the protected bits so their forced weights are not
                    // counted twice by the digital restoration above.
                    if (target_bit >= PROT_START_IDX)
                        sar_ptr <= PROT_SEARCH_IDX;
                    else
                        sar_ptr <= target_bit - 1'b1;
                    wait_cnt <= WAIT_INIT;
                end

                S_PHASE_P_SAR, S_PHASE_N_SAR: begin
                    if (wait_cnt == WAIT_INIT) begin
                        sar_code[sar_ptr] <= 1'b1;          // Trial bit
                        wait_cnt <= wait_cnt - 1'b1;
                    end else if (wait_cnt > 0) begin
                        wait_cnt <= wait_cnt - 1'b1;
                    end else begin
                        // Decide on the synchronized comparator result.
                        if (((state == S_PHASE_P_SAR) && !comp_out_rr) ||
                            ((state == S_PHASE_N_SAR) &&  comp_out_rr)) begin
                            sar_code[sar_ptr] <= 1'b0;
                        end
                        if (sar_ptr > 0) begin
                            sar_ptr  <= sar_ptr - 1'b1;
                            wait_cnt <= WAIT_INIT;
                        end else begin
                            calc_cnt <= '0;
                            temp_acc <= '0;
                        end
                    end
                end

                S_PHASE_P_CALC, S_PHASE_N_CALC: begin
                    if (calc_cnt < CALC_LAST) begin
                        if (sar_code[calc_cnt])
                            temp_acc <= temp_acc + shadow_weights[calc_cnt];
                        calc_cnt <= calc_cnt + 1'b1;
                    end else begin
                        // v4.0: accumulate the over-range status of this loop.
                        overrange_acc <= overrange_acc | loop_overrange;

                        if (state == S_PHASE_P_CALC)
                            meas_val_p <= $signed(compensated_meas[WEIGHT_WIDTH-1:0]);
                        else
                            meas_val_n <= $signed(compensated_meas[WEIGHT_WIDTH-1:0]);
                    end
                end

                S_ACCUMULATE: begin
                    accumulator <= accumulator + meas_val_p + meas_val_n;
                    avg_cnt     <= avg_cnt + 1'b1;
                end

                // ---- finalize pipeline: stage 1 (delay only in v4.2) ---------
                // Snapshot the accumulator, which already carries the folded
                // round bias from S_INIT_TARGET -- there is deliberately no add
                // here any more. `target_bit` and `overrange_acc` travel with
                // the result so the write stage never has to look at live state.
                S_UPDATE_ROUND: begin
                    avg_rounded_r <= avg_rounded;
                    wr_idx_r      <= target_bit;
                    orr_r         <= overrange_acc;
                end

                // ---- stage 2 (delay / shift only in v4.2) --------------------
                S_UPDATE_FINAL: begin
                    calc_result_r <= calc_result_ext;
                end

                // ---- stage 3: write-back -------------------------------------
                S_UPDATE_WEIGHT: begin
                    w_wr_data <= calc_result_r[WEIGHT_WIDTH-1:0];
                    w_wr_addr <= wr_idx_r[4:0];
                    w_wr_en   <= 1'b1;

                    shadow_weights[wr_idx_r] <= calc_result_r[WEIGHT_WIDTH-1:0];

                    // v4.0: latch the run-level over-range status for this bit.
                    overrange_bits[wr_idx_r] <= orr_r;
                    if (orr_r) calib_overrange <= 1'b1;

                    if (wr_idx_r == LAST_TARGET_BIT) begin
                        calib_done       <= 1'b1;
                        calib_done_pulse <= 1'b1;
                        calib_mode_en    <= 1'b0;
                    end else begin
                        target_bit <= wr_idx_r + 1'b1;
                    end
                end

                S_DONE: begin
                    // Hold the completion status; the shadow RAM and the write
                    // interface keep their last values so an external weight
                    // read-back is still possible after completion.
                    calib_done    <= 1'b1;
                    calib_mode_en <= 1'b0;
                    // v4.0 FIX: re-arm must restart the sweep from the first
                    // target. S_DONE is the ONLY entry into S_INIT_TARGET that
                    // bypasses S_IDLE, and S_IDLE is where the cold-start reset
                    // lives, so the re-arm path used to inherit
                    // target_bit == LAST_TARGET_BIT from the previous run. The
                    // controller then calibrated that single leftover bit, raised
                    // calib_done, and published it as a complete table -- every
                    // observable looked exactly like a full run, and the only
                    // trace was the cost: one target instead of fourteen.
                    //
                    // Found by tb/tb_sar16_v4.sv Phase 3b/3c, which re-run the
                    // controller and count the write-backs. Do not move this into
                    // S_INIT_TARGET: that state is also the between-targets state.
                    if (start_calib) begin
                        target_bit      <= FIRST_TARGET_BIT;
                        calib_overrange <= 1'b0;
                        overrange_bits  <= '0;
                    end
                end

                default: begin
                    calib_done    <= 1'b0;
                    calib_mode_en <= 1'b0;
                    target_bit    <= FIRST_TARGET_BIT;
                    avg_cnt       <= '0;
                    sar_code      <= '0;
                    sar_ptr       <= '0;
                    wait_cnt      <= '0;
                    accumulator   <= '0;
                    meas_val_p    <= '0;
                    meas_val_n    <= '0;
                    calc_cnt      <= '0;
                    temp_acc      <= '0;
                    // v4.1 pipeline registers: reset them here too, otherwise the
                    // write stage could publish a stale/X result on the first
                    // target after a cold start.
                    avg_rounded_r <= '0;
                    calc_result_r <= '0;
                    orr_r         <= 1'b0;
                    wr_idx_r      <= FIRST_TARGET_BIT;
                end
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // Round-to-nearest average over the (P+N) accumulator, plus the v4.0
    // half-LSB search-bias correction.
    //
    //   average = round( accumulator / (2 * AVG_LOOPS) )  +  W0/2
    //
    // v4.2: the bias is NOT applied here any more. It is planted in the
    // accumulator's initial value at S_INIT_TARGET (see the ROUND_K block in
    // section 0), so the whole finalize is now arithmetic-free:
    //   * `avg_rounded`     is the accumulator itself, and
    //   * `calc_result_ext` is an arithmetic shift of a register.
    // The rounding term stays explicitly wide and signed so that shift is
    // arithmetic for negative accumulators.
    //
    // The two always_comb names are kept on purpose: they preserve the
    // three-stage write-back latency (and therefore the 207 352-cycle
    // calibration count) exactly, and they keep every testbench probe that
    // reads `calc_result_wire` meaningful.
    // -------------------------------------------------------------------------
    always_comb avg_rounded = accumulator;

    // NOTE the source is the REGISTERED stage-1 value, not `avg_rounded`.
    // Stage 1 stays a register so the write-back stays three cycles deep; that
    // is what keeps the cycle count unchanged. Stage 2 carries no logic at all.
    always_comb calc_result_ext = avg_rounded_r >>> (AVG_SHIFT + 1);

    // The value being written back, i.e. stage 3's input. Kept under this name
    // because the testbenches probe it.
    assign calc_result_wire = $signed(calc_result_r[WEIGHT_WIDTH-1:0]);

    // =========================================================================
    // 5. DAC drive matrix with MSB protection
    // =========================================================================
    always_comb begin
        dac_p_force = '0;
        dac_n_force = '0;

        if (phase_p_active) begin
            dac_p_force = target_drive_code;
            dac_n_force = protected_sar_code;
        end else if (phase_n_active) begin
            dac_p_force = protected_sar_code;
            dac_n_force = target_drive_code;
        end
    end

`ifndef SYNTHESIS
    // The measurement must be strictly positive for every calibrated bit: the
    // target weight is always larger than the reference DAC's own LSB. A
    // non-positive result means the drive matrix or the comparator polarity is
    // wired backwards, which is otherwise very hard to see in a waveform.
    always_ff @(posedge clk) begin
        if (rst_n && (state == S_UPDATE_WEIGHT) && (calc_result_r <= 0))
            $error("sar_calib_ctrl_serial v4: measured weight for bit %0d is %0d (non-positive).",
                   wr_idx_r, calc_result_r);
    end
`endif

endmodule
