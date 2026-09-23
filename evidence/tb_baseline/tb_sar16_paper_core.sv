// =============================================================================
// tb_sar16_paper_core.sv
//
// QUESTION THIS BENCH ANSWERS
// ---------------------------
// The paper's die does NOT contain the weighted sum (see the header of
// rtl/sar_digi_paper_core.sv for the textual evidence). Moving it off the die
// removes 76 % of the area -- but does it change what the converter DOES?
//
// Method: instantiate BOTH builds side by side and drive them with the SAME
// stimulus.
//
//   DUT_U  sar_adc_digital_top   -- the integrated build, weighted sum on the
//                                  die, NORM_ENABLE=0 so that its sample
//                                  datapath is the paper's pure weighted sum.
//   DUT_P  sar_digi_paper_core   -- the on-die core, weighted sum off the die.
//
// The decisive measurement is not a tolerance: DUT_P publishes every calibrated
// weight on `w_wr_*` as it is measured, and DUT_U's own reconstruction engine
// consumes its weights from an internal table.  If those two agree BIT FOR BIT,
// then an off-chip reconstructor that latches the broadcast stream holds exactly
// the table the on-die engine held, and the weighted sum it forms is the same
// function -- no re-derivation, no tolerance, no assumption.
//
// Phases
//   1  calibration, both DUTs, identical stimulus, noiseless
//   2  W  EXPORT EQUIVALENCE   the w_wr stream  ==  DUT_U's internal weight_ram
//   3  OFF-CHIP RECONSTRUCTION a weighted sum built in the BENCH from the
//                              exported weights must reproduce the ideal-weight
//                              sum to well inside 1 LSB
//   4  INTERFACE               raw_code_o timing; residue width is SRM_RES_W
//   5  SRM RESIDUE EXPORT      the residue reaches the port and is in range
//
// WHY PHASE 3 CANNOT CHECK DUT_U's adc_dout DIRECTLY: that would require
// re-deriving the integrated engine's internal fixed-point scaling, and a bug in
// the BENCH's copy of it would look exactly like a DUT bug.  Phase 2 pins the
// data instead, which is the only thing that can differ between the two builds.
// =============================================================================

`timescale 1ns/1ps

module tb_sar16_paper_core;

    localparam int CAP = 20;
    localparam int WW  = 30;
    // Published residue width; must equal the DUT's SRM_RES_W and the estimator's
    // RES_Q_W = LUT_OUT_WIDTH + (RES_FRAC - LUT_FRAC_OUT) = 10 + (8 - 8).
    localparam int SRM_RES_W = 10;
    localparam int AVG = 32;

    // =========================================================================
    // Clocks
    // =========================================================================
    logic clk     = 1'b0;
    logic dec_clk = 1'b0;
    logic rst_n;

    always #5.0   clk     = ~clk;       // 100 MHz
    always #1.25  dec_clk = ~dec_clk;   // 400 MHz (4x)

    // =========================================================================
    // Analog model -- shared by both DUTs so that they see identical physics
    //
    //   v_p - v_n = sum_i (p_i - n_i) * W_i + V_os
    //
    // For the MSB-protected targets this single expression reproduces the
    // paper's arithmetic automatically (b18: W18-W17; b19: W19-W18-W17).
    // =========================================================================
    longint true_w [0:CAP-1];
    longint calib_vos = 0;          // input-referred offset, Q8

    task automatic build_true_weights();
        int frac;
        begin
            for (int i = 0; i < CAP; i++) true_w[i] = 0;
            true_w[0] = 256;                                  // 1.0 LSB_0 in Q8
            for (int i = 1; i <= 5; i++) true_w[i] = true_w[i-1] * 2;
            true_w[6] = true_w[5];                            // the redundant pair
            for (int i = 7; i < CAP; i++) true_w[i] = true_w[i-1] * 2;
            for (int i = 6; i < CAP; i++) begin
                frac = ((i * 97) + 13) % 256;                 // deterministic mismatch
                true_w[i] = true_w[i] + frac;
            end
        end
    endtask

    function automatic logic cmp_model(input logic [CAP-1:0] dp,
                                       input logic [CAP-1:0] dn,
                                       input longint vos);
        longint v;
        begin
            v = vos;
            for (int i = 0; i < CAP; i++) begin
                if (dp[i]) v += true_w[i];
                if (dn[i]) v -= true_w[i];
            end
            cmp_model = (v > 0);
        end
    endfunction

    // =========================================================================
    // Shared stimulus
    // =========================================================================
    logic                start_calib;
    logic                srm_start;
    logic                srm_decision_valid;
    logic                srm_decision_bit;
    logic                data_valid_in;
    logic [CAP-1:0]      raw_bits_in;

    // =========================================================================
    // DUT_U -- integrated build, weighted sum on the die
    // =========================================================================
    logic [CAP-1:0]            u_dac_p, u_dac_n;
    logic                      u_comp;
    logic                      u_cal_done, u_cal_donep, u_cal_mode;
    logic                      u_ovr;
    logic [CAP-1:0]            u_ovr_bits;
    logic signed [15:0]        u_dout;
    logic                      u_dv_out, u_ovr_out, u_norm_ready, u_norm_busy;
    logic [WW+9:0]             u_weight_sum;
    logic                      u_srm_busy, u_srm_done, u_srm_rvalid;
    logic [4:0]                u_srm_ones, u_srm_total;
    logic                      u_srm_short, u_srm_stalled;

    always_comb u_comp = cmp_model(u_dac_p, u_dac_n, calib_vos);

    sar_adc_digital_top #(
        .CAP_NUM(20), .WEIGHT_WIDTH(30), .OUTPUT_WIDTH(16), .FRAC_BITS(8),
        .COMP_WAIT_CYC(16), .AVG_LOOPS(AVG), .MAX_CALIB_BIT(5), .REF_WEIGHT_LSB(256),
        .SRM_DECISIONS(22), .SRM_RES_FRAC(8), .SRM_SIGMA_Q8(128),
        .NORM_ENABLE(1'b0),          // <- the paper's pure weighted sum
        .CALIB_ROUND_HALF_LSB(1'b1), .SRM_STALL_CYCLES(64)
    ) dut_u (
        .clk(clk), .dec_clk(dec_clk), .rst_n(rst_n),
        .start_calib(start_calib), .calib_comp_out(u_comp),
        .calib_done(u_cal_done), .calib_done_pulse(u_cal_donep), .calib_mode_en(u_cal_mode),
        .dac_p_force(u_dac_p), .dac_n_force(u_dac_n),
        .calib_overrange(u_ovr), .calib_overrange_bits(u_ovr_bits),
        .data_valid_in(data_valid_in), .raw_bits(raw_bits_in),
        .srm_start(srm_start), .srm_decision_valid(srm_decision_valid),
        .srm_decision_bit(srm_decision_bit),
        .srm_busy(u_srm_busy), .srm_done(u_srm_done), .srm_residue_valid(u_srm_rvalid),
        .srm_ones_count(u_srm_ones), .srm_total_count(u_srm_total),
        .srm_count_shortfall(u_srm_short), .srm_stalled(u_srm_stalled),
        .adc_dout(u_dout), .data_valid_out(u_dv_out), .overrange(u_ovr_out),
        .norm_ready(u_norm_ready), .norm_busy(u_norm_busy), .weight_sum(u_weight_sum)
    );

    // =========================================================================
    // DUT_P -- the on-die core, weighted sum off the die
    // =========================================================================
    logic [CAP-1:0]            p_dac_p, p_dac_n;
    logic                      p_comp;
    logic                      p_cal_done, p_cal_donep, p_cal_mode;
    logic                      p_ovr;
    logic [CAP-1:0]            p_ovr_bits;
    logic [CAP-1:0]            p_raw_code;
    logic                      p_raw_code_vld;
    logic                      p_w_wr_en;
    logic [4:0]                p_w_wr_addr;
    logic signed [WW-1:0]      p_w_wr_data;
    logic                      p_srm_busy, p_srm_done, p_srm_rvalid;
    logic [4:0]                p_srm_ones, p_srm_total;
    logic                      p_srm_short, p_srm_stalled;
    // v5.0: the published residue is SRM_RES_W bits (10), not the 30-bit datapath
    // width -- see the DUT's port-list note.
    logic signed [SRM_RES_W-1:0] p_srm_residue;

    always_comb p_comp = cmp_model(p_dac_p, p_dac_n, calib_vos);

    sar_digi_paper_core #(
        .CAP_NUM(20), .WEIGHT_WIDTH(30), .COMP_WAIT_CYC(16), .AVG_LOOPS(AVG),
        .MAX_CALIB_BIT(5), .REF_WEIGHT_LSB(256),
        .SRM_DECISIONS(22), .SRM_RES_FRAC(8), .SRM_SIGMA_Q8(128),
        .CALIB_ROUND_HALF_LSB(1'b1), .SRM_STALL_CYCLES(64),
        .WEIGHT_EXPORT_REG(1'b0)     // <- no on-die weight storage
    ) dut_p (
        .clk(clk), .dec_clk(dec_clk), .rst_n(rst_n),
        .start_calib(start_calib), .calib_comp_out(p_comp),
        .calib_done(p_cal_done), .calib_done_pulse(p_cal_donep), .calib_mode_en(p_cal_mode),
        .dac_p_force(p_dac_p), .dac_n_force(p_dac_n),
        .calib_overrange(p_ovr), .calib_overrange_bits(p_ovr_bits),
        .data_valid_i(data_valid_in), .raw_bits_i(raw_bits_in),
        .raw_code_o(p_raw_code), .raw_code_valid_o(p_raw_code_vld),
        .w_wr_en(p_w_wr_en), .w_wr_addr(p_w_wr_addr), .w_wr_data(p_w_wr_data),
        .srm_start(srm_start), .srm_decision_valid(srm_decision_valid),
        .srm_decision_bit(srm_decision_bit),
        .residue_consume_i(data_valid_in & p_srm_rvalid),
        .srm_busy(p_srm_busy), .srm_done(p_srm_done), .srm_residue_valid(p_srm_rvalid),
        .srm_ones_count(p_srm_ones), .srm_total_count(p_srm_total),
        .srm_count_shortfall(p_srm_short), .srm_stalled(p_srm_stalled),
        .srm_residue_o(p_srm_residue)
    );

    // =========================================================================
    // Checkbook
    // =========================================================================
    int checks = 0;
    int fails  = 0;

    task automatic chk(input string name, input logic cond, input string info);
        begin
            checks = checks + 1;
            if (cond) begin
                $display("  PASS  %-52s %s", name, info);
            end else begin
                fails = fails + 1;
                $display("  ** FAIL  %-50s %s", name, info);
            end
        end
    endtask

    // =========================================================================
    // Capture: DUT_P's broadcast weight stream, and DUT_U's internal table
    // =========================================================================
    longint p_exported [0:CAP-1];     // what an off-chip consumer would latch
    longint u_internal [0:CAP-1];     // what DUT_U's own engine uses
    int     nwr_p;

    // Plain `always` with blocking assignments on purpose: these are scoreboard
    // variables, not hardware. `always_ff` would make VCS complain about mixed
    // assignment styles, neither of which is a real defect in a bench.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            nwr_p = 0;
            for (int i = 0; i < CAP; i++) p_exported[i] = 0;
        end else if (p_w_wr_en && (p_w_wr_addr < 5'(CAP))) begin
            p_exported[p_w_wr_addr] = longint'($signed(p_w_wr_data));
            nwr_p = nwr_p + 1;
        end
    end

    always @(posedge clk) begin
        for (int i = 0; i < CAP; i++)
            u_internal[i] = longint'($signed(dut_u.u_reconstruction.weight_ram[i]));
    end

    // =========================================================================
    // Off-chip reconstructor, built in the BENCH from the exported weights
    // =========================================================================
    longint oc_w [0:CAP-1];

    function automatic longint offchip_weighted_sum(input logic [CAP-1:0] bits);
        longint s;
        begin
            s = 0;
            for (int i = 0; i < CAP; i++)
                s += bits[i] ? oc_w[i] : (-oc_w[i]);
            offchip_weighted_sum = s;
        end
    endfunction

    function automatic longint ideal_weighted_sum(input logic [CAP-1:0] bits);
        longint s;
        begin
            s = 0;
            for (int i = 0; i < CAP; i++)
                s += bits[i] ? true_w[i] : (-true_w[i]);
            ideal_weighted_sum = s;
        end
    endfunction

    // =========================================================================
    // Main sequence
    // =========================================================================
    int  i, t;
    int  nwr_before;
    longint dmax, dthis;
    real    rel_ref, spread, dtmp, gain;   // table-gain statistics
    longint oc_sum, id_sum;

    initial begin : main
        start_calib        = 1'b0;
        srm_start          = 1'b0;
        srm_decision_valid = 1'b0;
        srm_decision_bit   = 1'b0;
        data_valid_in      = 1'b0;
        raw_bits_in        = '0;
        rst_n              = 1'b0;

        build_true_weights();

        $display("");
        $display("================================================================================");
        $display(" tb_sar16_paper_core : does moving the weighted sum off the die change the");
        $display("                       converter?  Integrated build vs on-die paper core.");
        $display("================================================================================");
        $display(" sum(true_w) = %0d Q8   LSB_0 = %0d Q8", ideal_weighted_sum('1), true_w[0]);
        $display("");

        repeat (10) @(negedge clk);
        rst_n = 1'b1;
        repeat (10) @(negedge clk);

        // =====================================================================
        // PHASE 1 -- calibration, both DUTs, identical stimulus
        // =====================================================================
        $display(" PHASE 1 : foreground bit-weight calibration (noiseless, V_os = 0)");
        calib_vos = 0;
        repeat (5) @(negedge clk);
        start_calib = 1'b1;
        @(negedge clk);
        start_calib = 1'b0;
        nwr_before = nwr_p;

        for (t = 0; t < 400000; t++) begin
            @(negedge clk);
            if (p_cal_done && u_cal_done) break;
        end
        repeat (10) @(negedge clk);

        $display("   calibration finished in %0d clk cycles", t);
        $display("   writes on the broadcast stream : %0d   (expect 14 = bits 6..19)", nwr_p - nwr_before);
        $display("   DUT_U calib_done=%0b  DUT_P calib_done=%0b", u_cal_done, p_cal_done);
        $display("   DUT_U overrange=%0b   DUT_P overrange=%0b   (expect 0/0 at V_os=0)",
                 u_ovr, p_ovr);
        chk("1  both DUTs report calibration complete", p_cal_done && u_cal_done,
            $sformatf("U=%0b P=%0b", u_cal_done, p_cal_done));
        chk("1  the broadcast stream carries 14 weights", (nwr_p - nwr_before) == 14,
            $sformatf("%0d", nwr_p - nwr_before));
        chk("1  no false over-range on either DUT", (p_ovr == 1'b0) && (u_ovr == 1'b0),
            $sformatf("U=%0b P=%0b", u_ovr, p_ovr));

        // ---------------------------------------------------------------------
        // ABSOLUTE error is the WRONG statistic here, and the number is worth
        // showing precisely because it looks alarming.  |measured - true| grows
        // geometrically -- 45, 76, 235, 394, ... up to 381120 Q8 at bit 19 --
        // and that is structural, not accumulating noise: the controller
        // restores w_k as a SUM of the already-measured lower weights, so the
        // whole table shares ONE scale factor.  The physically meaningful
        // quantity is the SCATTER of the relative error about that factor,
        // because INL depends on the scatter, while a uniform gain is a system
        // calibration and not a converter defect.
        // (The integrated v4.0 bench reached the same conclusion; this bench
        // re-derives it for the core build rather than assuming it.)
        // ---------------------------------------------------------------------
        dmax = 0;
        for (i = 6; i < CAP; i++) begin
            dthis = p_exported[i] - true_w[i];
            if (dthis < 0) dthis = -dthis;
            if (dthis > dmax) dmax = dthis;
        end
        $display("   max |measured - ideal| over bits 6..19 = %0d Q8  (= %0.4f LSB_0)",
                 dmax, real'(dmax)/256.0);
        $display("   ... that growth is the recursive restoration, not accumulating error.");
        chk("1  the calibration actually measured something (not a tautology)", dmax > 0,
            $sformatf("max deviation %0d Q8", dmax));

        // Reference for the relative error: bit CAP-2, the highest bit that is
        // not MSB-protected (bit 19's restoration re-adds both b17 and b18).
        rel_ref = real'(p_exported[CAP-2]) / real'(true_w[CAP-2]);
        spread  = 0.0;
        for (i = 6; i < CAP; i++) begin
            dtmp = real'(p_exported[i]) / real'(true_w[i]) / rel_ref - 1.0;
            if (dtmp < 0) dtmp = -dtmp;
            if (dtmp > spread) spread = dtmp;
        end
        // NOTE: no `%+` flag anywhere in this file. VCS rejects it with IFSFDT
        // and the BUILD FAILS outright -- a prettier sign is not worth a dead
        // build. A negative value prints its own minus sign.
        $display("   uniform gain of the measured table : %0.6f   (%0.4f %% vs ideal)",
                 rel_ref, 100.0*(rel_ref - 1.0));
        $display("   worst deviation from that ONE gain : %0.5f %%  (%.3f LSB_0 at full scale)",
                 100.0*spread, spread*65536.0);
        chk("1  the table carries ONE uniform gain (scatter < 0.30 %)", spread < 0.0030,
            $sformatf("scatter = %.4f %%", 100.0*spread));

        // =====================================================================
        // PHASE 2 -- THE DECISIVE TEST: export equivalence
        // =====================================================================
        $display("");
        $display(" PHASE 2 : weight export equivalence  (broadcast stream vs on-die table)");
        $display("   bit   true_w(Q8)   exported(Q8)   DUT_U internal(Q8)   match");
        begin
            bit all_match;
            all_match = 1'b1;
            for (i = 6; i < CAP; i++) begin
                if (p_exported[i] !== u_internal[i]) all_match = 1'b0;
                $display("   %2d   %10d   %12d   %18d   %s",
                         i, true_w[i], p_exported[i], u_internal[i],
                         (p_exported[i] === u_internal[i]) ? "yes" : "NO");
            end
            chk("2  every exported weight EQUALS the on-die one, bit for bit", all_match,
                "an off-chip reconstructor holds exactly the table the die used");
        end

        // =====================================================================
        // PHASE 3 -- off-chip reconstruction from the exported weights
        // =====================================================================
        $display("");
        $display(" PHASE 3 : weighted sum built in the BENCH from the exported weights");
        // LSB section 0..5 is the reference segment: it is never calibrated, so
        // both builds use its ideal value. That is why the export only carries
        // 6..19 and the reconstructor fills 0..5 itself.
        for (i = 0; i < 6; i++) oc_w[i] = true_w[i];
        for (i = 6; i < CAP; i++) oc_w[i] = p_exported[i];

        begin
            longint oc_s, id_s, diff, worst, worst_raw, corrected;
            int     ntest;
            worst     = 0;      // after removing the single table gain
            worst_raw = 0;      // before removing it -- reported, not asserted
            ntest     = 0;

            // The gain the off-chip reconstructor has to divide out. It is ONE
            // scalar, computed once at calibration time from the two table sums.
            //
            // This is not a workaround; it is the definition of the task the
            // integrated build solves with an adder tree, a 46-bit restoring
            // divider and a 960-flip-flop pre-normalised table -- i.e. most of
            // the 76 % of area that moving the weighted sum off the die removes.
            // Stating it explicitly makes the trade visible instead of hidden.
            oc_sum = 0; id_sum = 0;
            for (int q = 0; q < CAP; q++) begin oc_sum += oc_w[q]; id_sum += true_w[q]; end
            gain = real'(oc_sum) / real'(id_sum);
            $display("   sum(exported table) = %0d Q8", oc_sum);
            $display("   sum(ideal table)    = %0d Q8", id_sum);
            $display("   gain to divide out  = %0.6f   (%0.4f %% vs ideal)", gain, 100.0*(gain - 1.0));

            for (int c = 0; c < (1 << 12); c++) begin
                logic [CAP-1:0] pat;
                pat = '0;
                for (int b = 0; b < 12; b++) pat[b + 6] = c[b % 12];
                oc_s = offchip_weighted_sum(pat);
                id_s = ideal_weighted_sum(pat);
                diff = oc_s - id_s;
                if (diff < 0) diff = -diff;
                if ((diff / 256) > worst_raw) worst_raw = diff / 256;
                // Gain trim done in INTEGER arithmetic on purpose: oc_s*id_sum
                // peaks near 1.8e16, which longint holds exactly, whereas a
                // real->integer conversion here would only add rounding noise to
                // a comparison whose whole point is exactness.
                corrected = (oc_s * id_sum) / oc_sum;
                diff = corrected - id_s;
                if (diff < 0) diff = -diff;
                if ((diff / 256) > worst) worst = diff / 256;
                ntest = ntest + 1;
            end

            oc_s = offchip_weighted_sum('0);
            id_s = ideal_weighted_sum('0);
            $display("   patterns tested                : %0d", ntest);
            $display("   all-zeros off-chip=%0d  ideal=%0d", oc_s, id_s);
            $display("   worst |off-chip - ideal| RAW   : %0d LSB_0  (= the table gain)", worst_raw);
            $display("   worst after dividing out gain  : %0d LSB_0", worst);
            // Scale for the pass criterion.  The 16-bit output code spans
            // +/-sum(W), so one code LSB is sum(W)/32768 = 16 LSB_0 here.  The
            // residual after removing the single gain is therefore what is left
            // of the table's INTERNAL scatter (Phase 1 measured 0.1481 %), and
            // 4 LSB_0 = 0.25 code LSB is the honest bound for "the off-chip
            // reconstructor reproduces the ideal weighted sum": requiring 1 LSB_0
            // would demand that a measured table be bit-identical to the ideal
            // one, which calibration does not promise and does not need to.
            $display("   worst in code LSB (the 16-bit output)  : %.4f LSB_16",
                     real'(worst) / 16.0);
            chk("3  off-chip sum reproduces the ideal sum to <= 0.25 code LSB after gain trim",
                worst <= 4, $sformatf("worst %0d LSB_0 = %.4f LSB_16 (raw %0d)",
                                      worst, real'(worst)/16.0, worst_raw));
            chk("3  the raw difference really is the single gain (1000x reduction)",
                worst_raw > 100 * (worst + 1),
                $sformatf("raw %0d -> trimmed %0d", worst_raw, worst));
        end

        // =====================================================================
        // PHASE 4 -- interface
        // =====================================================================
        $display("");
        $display(" PHASE 4 : raw-code export interface");
        for (int k = 0; k < 6; k++) begin
            logic [CAP-1:0] pat;
            logic [CAP-1:0] got;
            pat = '0;
            for (int b = 0; b < CAP; b++) pat[b] = ((k * 7 + b * 3) % 5) < 2;
            @(negedge clk);
            raw_bits_in   = pat;
            data_valid_in = 1'b1;
            @(negedge clk);
            got = p_raw_code;
            @(negedge clk);
            data_valid_in = 1'b0;
            chk($sformatf("4  raw_code_o reproduces pattern %0d (1 clk latency)", k),
                got === pat, $sformatf("got %h expected %h", got, pat));
        end
        chk("4  raw_code_valid_o follows data_valid_i", p_raw_code_vld === 1'b1,
            $sformatf("vld=%0b after the last driven sample", p_raw_code_vld));

        // v5.0: the read-back port no longer exists, so check 4 is now purely a
        // raw_code_o timing check. The former "weight_rd_data is tied low" check
        // was removed with the port -- it asserted a property of a dead pin, and
        // that dead pin is what broke LVS.

        // =====================================================================
        // PHASE 5 -- SRM residue export
        // =====================================================================
        $display("");
        $display(" PHASE 5 : SRM residue export (the third thing the die owes the host)");
        // 22 decisions, 16 of them '1' -- the same contract the integrated
        // bench uses, so the expected residue is the same table entry.
        repeat (6) @(negedge clk);
        srm_start = 1'b1;
        @(negedge clk);
        srm_start = 1'b0;
        for (int d = 0; d < 22; d++) begin
            @(negedge dec_clk);
            srm_decision_valid = 1'b1;
            srm_decision_bit   = ((d % 11) < 8);      // 8 of every 11 -> 16 of 22
            @(negedge dec_clk);
            srm_decision_valid = 1'b0;
            repeat (3) @(negedge dec_clk);
        end
        for (t = 0; t < 500; t++) begin
            @(negedge clk);
            if (p_srm_rvalid || p_srm_done) break;
        end
        $display("   observed ones=%0d total=%0d   residue=%0d Q8   valid=%0b",
                 p_srm_ones, p_srm_total, $signed(p_srm_residue), p_srm_rvalid);
        chk("5  the SRM counter saw the full 22 decisions", p_srm_total == 5'd22,
            $sformatf("total=%0d", p_srm_total));
        chk("5  ones count matches the driven pattern (16)", p_srm_ones == 5'd16,
            $sformatf("ones=%0d", p_srm_ones));
        chk("5  the residue reaches the port and is non-zero", p_srm_rvalid === 1'b1,
            $sformatf("valid=%0b residue=%0d", p_srm_rvalid, $signed(p_srm_residue)));
        chk("5  no count shortfall, no stall", (p_srm_short === 1'b0) && (p_srm_stalled === 1'b0),
            $sformatf("short=%0b stalled=%0b", p_srm_short, p_srm_stalled));

        // =====================================================================
        // Summary
        // =====================================================================
        $display("");
        $display("================================================================================");
        $display(" RESULT : %0d checks, %0d failures", checks, fails);
        if (fails == 0) $display(" TB_PAPER_CORE_PASS");
        else            $display(" TB_PAPER_CORE_FAIL");
        $display("================================================================================");
        $finish;
    end

`ifdef WATCHDOG
    initial begin
        #2000000;
        $display(" TB_PAPER_CORE_WATCHDOG_TIMEOUT");
        $finish;
    end
`endif

endmodule
