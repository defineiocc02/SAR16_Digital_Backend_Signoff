// =============================================================================
// tb_sar16_core_pwr.sv - gate-level ACTIVITY TB for the on-die core.
//
// Purpose: produce SAIF files so PrimeTime can be given MEASURED switching
// activity instead of the tool's default assumption. Everything reported so far
// came from `report_power` with PWR-414/PWR-415 warnings (unannotated), which this
// project's own experience says over-estimates by roughly an order of magnitude --
// and the estimate put 84 % of the power in a FOREGROUND engine that only runs
// once at power-up, which is exactly the kind of number that default activity gets
// wrong.
//
// Why SAIF and not VCD: 945 flops over ten thousand cycles would make a VCD of
// several GB, while a SAIF is an averaged toggle/probability summary of a window
// and stays in the hundreds of kB. `read_saif` in PrimeTime consumes it directly.
//
// Two windows are captured, because the two modes have completely different
// activity and are amortised completely differently:
//
//   core_operating.saif   start_calib held low -> the calibration engine sits in
//                         S_IDLE while conversions and SRM bursts run. This is the
//                         mode that lasts forever, so this is the datasheet power.
//   core_calib.saif       start_calib asserted -> the foreground calibration runs.
//                         One shot of 207 352 cycles at power-up, then never again.
//
// The calibration window is 30 000 cycles rather than the full 207 352: the
// sequence is periodic (14 targets x 32 averaging loops of the same shape), so a
// one-loop window is a representative average, and 30 k cycles keeps the GLS
// runtime to seconds instead of tens of minutes.
//
// Timing is deliberately ZERO-DELAY (`+nospecify`): activity annotation does not
// need delays, and the project has already established that this library's
// specify blocks default to 1.0 ns per cell, which without +nospecify turns a
// 20-level path into 20 ns against a 10 ns clock and rolls the whole design into
// X. See the smoke-test notes in the project memory.
// =============================================================================
`timescale 1ns/1ps

module tb_sar16_core_pwr;

    localparam int CAP = 20;
    localparam int OP_CYCLES   = 3000;      // operating window
    localparam int CAL_CYCLES  = 30000;     // calibration window

    logic clk = 1'b0;
    logic dec_clk = 1'b0;
    logic rst_n = 1'b0;

    logic                  start_calib = 1'b0;
    logic                  calib_comp_out;
    logic                  calib_done, calib_done_pulse, calib_mode_en, calib_overrange;
    logic [CAP-1:0]        dac_p_force, dac_n_force, calib_overrange_bits;

    logic                  data_valid_i = 1'b0;
    logic [CAP-1:0]        raw_bits_i = '0;
    logic [CAP-1:0]        raw_code_o;
    logic                  raw_code_valid_o;

    logic                  w_wr_en;
    logic [4:0]            w_wr_addr;
    logic signed [29:0]    w_wr_data;

    logic                  srm_start = 1'b0;
    logic                  srm_decision_valid = 1'b0;
    logic                  srm_decision_bit = 1'b0;
    logic                  residue_consume_i = 1'b0;
    logic                  srm_busy, srm_done, srm_residue_valid;
    logic                  srm_count_shortfall, srm_stalled;
    logic [4:0]            srm_ones_count, srm_total_count;
    logic signed [9:0]     srm_residue_o;

    // ---------------------------------------------------------------- the DUT
    sar_digi_paper_core dut (
        .clk(clk), .dec_clk(dec_clk), .rst_n(rst_n),
        .start_calib(start_calib), .calib_comp_out(calib_comp_out),
        .calib_done(calib_done), .calib_done_pulse(calib_done_pulse),
        .calib_mode_en(calib_mode_en),
        .dac_p_force(dac_p_force), .dac_n_force(dac_n_force),
        .calib_overrange(calib_overrange), .calib_overrange_bits(calib_overrange_bits),
        .data_valid_i(data_valid_i), .raw_bits_i(raw_bits_i),
        .raw_code_o(raw_code_o), .raw_code_valid_o(raw_code_valid_o),
        .w_wr_en(w_wr_en), .w_wr_addr(w_wr_addr), .w_wr_data(w_wr_data),
        .srm_start(srm_start),
        .srm_decision_valid(srm_decision_valid), .srm_decision_bit(srm_decision_bit),
        .residue_consume_i(residue_consume_i),
        .srm_busy(srm_busy), .srm_done(srm_done), .srm_residue_valid(srm_residue_valid),
        .srm_ones_count(srm_ones_count), .srm_total_count(srm_total_count),
        .srm_count_shortfall(srm_count_shortfall), .srm_stalled(srm_stalled),
        .srm_residue_o(srm_residue_o)
    );

    // ------------------------------------------------------------- clocking
    always #5.0  clk     = ~clk;        // 100 MHz
    always #1.5  dec_clk = ~dec_clk;    // 333 MHz, matching the 3 ns constraint

    // ------------------------------------------------- comparator + weights
    // Identical model to the RTL TB, so the activity is representative of a real
    // calibration rather than of a stuck comparator.
    longint true_w [0:CAP-1];
    initial for (int i = 0; i < CAP; i++) true_w[i] = 256 <<< i;

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

    always_comb calib_comp_out = cmp_model(dac_p_force, dac_n_force, 0);

    // --------------------------------------------------- stimulus generators
    // Pseudo-random but DETERMINISTIC (LFSR, fixed seed) so two runs annotate the
    // same activity and the power number is reproducible.
    logic [15:0] lfsr = 16'hACE1;
    always @(posedge clk) lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};

    // one conversion burst every 8 clocks: present a code and start an SRM run
    logic [3:0] conv_div = '0;
    always @(posedge clk) begin
        if (!rst_n) begin
            conv_div <= '0;
            data_valid_i <= 1'b0;
            srm_start    <= 1'b0;
        end else begin
            conv_div <= conv_div + 4'd1;
            data_valid_i <= (conv_div == 4'd0);
            raw_bits_i   <= lfsr[CAP-1:0];
            srm_start    <= (conv_div == 4'd4);
            residue_consume_i <= srm_residue_valid;
        end
    end

    // 22 decisions per burst on the decision clock
    logic [5:0] dec_div = '0;
    logic       dec_run = 1'b0;
    always @(posedge dec_clk) begin
        if (!rst_n) begin
            dec_div <= '0; dec_run <= 1'b0; srm_decision_valid <= 1'b0; srm_decision_bit <= 1'b0;
        end else begin
            if (dec_div == 6'd0) dec_run <= 1'b1;
            srm_decision_valid <= dec_run & (dec_div < 6'd22);
            srm_decision_bit   <= lfsr[7] ^ lfsr[3];
            dec_div <= (dec_div + 6'd1) % 6'd48;
        end
    end

    // -------------------------------------------------------------- SAIF I/O
    // NOT a task taking a filename: `$toggle_report` requires its first argument to
    // be a string LITERAL, exactly like `$dumpfile`. Passing a string variable is
    // rejected at run time with
    //     Warning-[SAIF_REPORT_ARG_CHECK] Invalid first argument when trying to
    //     report SAIF information to a file.
    // and -- this is the dangerous part -- the task then does nothing while the
    // surrounding $display still reports success. The runner catches it by
    // checking that the file exists and is non-empty, which is the only check that
    // would have.
    task automatic saif_finish();
        begin
            $toggle_stop;
        end
    endtask

    // ------------------------------------------------------------------ main
    initial begin
        $display("TB_CORE_PWR: gate-level activity TB, zero-delay by design");
        repeat (20) @(posedge clk);
        rst_n = 1'b1;
        repeat (20) @(posedge clk);

        // ---- (a) OPERATING MODE ------------------------------------------
        // Calibration is NOT started: the scheduler sits in S_IDLE, which is also
        // where it spends all of its life after the one-shot calibration. What runs
        // is the conversion path, the raw-code export and the SRM burst.
        start_calib = 1'b0;
        repeat (64) @(posedge clk);          // let activity settle before sampling
        $set_toggle_region(dut);
        $toggle_start;
        repeat (OP_CYCLES) @(posedge clk);
        saif_finish;
        $toggle_report("core_operating.saif", 1.0e-9, "tb_sar16_core_pwr.dut");
        $display("SAIF_WRITTEN core_operating.saif over %0d clk cycles", OP_CYCLES);

        // ---- (b) CALIBRATION MODE ----------------------------------------
        start_calib = 1'b1;
        repeat (4) @(posedge clk);
        start_calib = 1'b0;
        $set_toggle_region(dut);
        $toggle_start;
        repeat (CAL_CYCLES) @(posedge clk);
        saif_finish;
        $toggle_report("core_calib.saif", 1.0e-9, "tb_sar16_core_pwr.dut");
        $display("SAIF_WRITTEN core_calib.saif over %0d clk cycles", CAL_CYCLES);

        $display("TB_CORE_PWR done: calib_mode_en=%0b calib_done=%0b", calib_mode_en, calib_done);
        $finish;
    end

    // A hung GLS run must end loudly rather than stall the queue.
    initial begin
        #20_000_000;                          // 20 ms of sim time
        $display("TB_CORE_PWR: TIMEOUT");
        $finish;
    end

endmodule
