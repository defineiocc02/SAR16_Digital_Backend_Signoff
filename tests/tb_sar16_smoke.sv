`timescale 1ns/1ps
// Standalone, two-state, zero-delay protocol tests for the immutable v5.1 RTL.
// No forced internal nets, missing integrated DUT or standard-cell library needed.
module tb_sar16_smoke;
    logic clk = 0, dec_clk = 0, rst_n = 0;
    always #5 clk = ~clk;
    always #1.5 dec_clk = ~dec_clk;
    logic start_calib = 0, calib_comp_out;
    logic data_valid_i = 0;
    logic [19:0] raw_bits_i = 0;
    logic srm_start = 0, srm_decision_valid = 0, srm_decision_bit = 0;
    logic residue_consume_i = 0;
    wire calib_done, calib_done_pulse, calib_mode_en, calib_overrange;
    wire [19:0] dac_p_force, dac_n_force, calib_overrange_bits, raw_code_o;
    wire raw_code_valid_o, w_wr_en;
    wire [4:0] w_wr_addr;
    wire signed [29:0] w_wr_data;
    wire srm_busy, srm_done, srm_residue_valid, srm_count_shortfall, srm_stalled;
    wire [4:0] srm_ones_count, srm_total_count;
    wire signed [9:0] srm_residue_o;
    sar_digi_paper_core dut (.*);

    logic [4:0] lut_index = 0;
    wire signed [9:0] lut_half, lut_full;
    srm_residue_lut #(.HALF_TABLE(1)) half_lut (.cnt(lut_index), .v_res(lut_half));
    srm_residue_lut #(.HALF_TABLE(0)) full_lut (.cnt(lut_index), .v_res(lut_full));
    int checks = 0;
    int writes = 0;
    int next_address = 6;
    logic monitor_calibration = 0;

    // Noiseless redundant CDAC reference, for protocol execution only.
    // Numerical calibration accuracy is intentionally not accepted by this bench.
    always_comb begin : comparator_reference
        longint voltage;
        longint weight;
        voltage = 0;
        for (int index = 0; index < 20; index++) begin
            weight = 64'd256 << ((index <= 5) ? index : index-1);
            if (dac_p_force[index]) voltage += weight;
            if (dac_n_force[index]) voltage -= weight;
        end
        calib_comp_out = (voltage > 0);
    end

    task automatic require(input logic condition, input string message);
        if (condition !== 1'b1) $fatal(1, "SMOKE_FAIL: %s", message);
        checks++;
    endtask

    function automatic int expected_residue(input int ones);
        int folded;
        int value;
        folded = (ones > 11) ? 22-ones : ones;
        case (folded)
            0: value = -258; 1: value = -194; 2: value = -158;
            3: value = -131; 4: value = -110; 5: value = -91;
            6: value = -74; 7: value = -58; 8: value = -43;
            9: value = -28; 10: value = -14; 11: value = 0;
            default: value = 99999;
        endcase
        return (ones > 11) ? -value : value;
    endfunction

    task automatic request_srm;
        @(negedge clk); srm_start = 1;
        @(negedge clk); srm_start = 0;
        // No ready output exists. Give the start toggle eight decision cycles.
        repeat (8) @(negedge dec_clk);
    endtask

    task automatic wait_srm;
        int cycles;
        cycles = 0;
        while (!srm_done && cycles < 100) begin
            @(negedge clk);
            cycles++;
        end
        require(srm_done, "SRM did not complete before the test deadline");
    endtask

    task automatic consume_srm;
        @(negedge clk); residue_consume_i = 1;
        @(negedge clk); residue_consume_i = 0;
        require(!srm_residue_valid, "residue_consume did not clear valid");
    endtask

    task automatic measure(input int ones, input bit consume);
        time requested;
        requested = $time;
        request_srm;
        for (int decision = 0; decision < 22; decision++) begin
            srm_decision_valid = 1;
            srm_decision_bit = (decision < ones);
            @(negedge dec_clk);
        end
        srm_decision_valid = 0;
        wait_srm;
        require(srm_total_count == 22, "normal SRM total must be 22");
        require(int'(srm_ones_count) == ones, "normal SRM ones count");
        require(int'($signed(srm_residue_o)) == expected_residue(ones), "signed Q8 residue");
        require(srm_residue_valid && !srm_busy, "published result handshake");
        require(!srm_count_shortfall && !srm_stalled, "normal measurement status");
        $display("SRM ones=%0d residue_q8=%0d request_to_observed_done_ns=%0d", ones,
                 $signed(srm_residue_o), $time-requested);
        repeat (3) @(negedge clk);
        require(srm_residue_valid && !srm_done, "valid persists; done is a strobe");
        if (consume) consume_srm;
    endtask

    always @(posedge clk) begin
        #0.1;
        if (monitor_calibration && w_wr_en) begin
            require(int'(w_wr_addr) == next_address, "calibration publish address order");
            require($signed(w_wr_data) > 0, "calibration publishes positive weight");
            writes++;
            next_address++;
        end
    end

    task automatic calibrate;
        int cycles;
        writes = 0; next_address = 6; monitor_calibration = 1;
        @(negedge clk); start_calib = 1;
        @(negedge clk); start_calib = 0;
        repeat (2) @(negedge clk);
        require(!calib_done, "restart must clear sticky calibration completion");
        cycles = 0;
        while (!calib_done && cycles < 300000) begin
            @(negedge clk);
            cycles++;
        end
        require(calib_done, "calibration completion deadline");
        require(writes == 14 && next_address == 20, "full calibration publishes bits 6..19 once");
        require(calib_done_pulse && !calib_mode_en, "calibration terminal handshake");
        repeat (2) @(negedge clk);
        require(calib_done && !calib_done_pulse, "calibration done sticky/pulse semantics");
        monitor_calibration = 0;
        $display("CALIB_PROTOCOL_PASS writes=%0d observed_wait_cycles=%0d", writes, cycles);
    endtask

    initial begin
        repeat (6) @(negedge clk);
        rst_n = 1;
        repeat (3) @(negedge clk);
        require(!srm_busy && !srm_residue_valid && !calib_done, "reset status");

        for (int count = 0; count <= 22; count++) begin
            lut_index = 5'(count); #0.1;
            require(int'($signed(lut_half)) == expected_residue(count), "half LUT mapping");
            require(lut_half === lut_full, "half and full LUT outputs agree");
        end
        @(negedge clk); raw_bits_i = 20'habcde; data_valid_i = 1;
        @(negedge clk);
        require(raw_code_o == 20'habcde && raw_code_valid_o, "registered raw export");
        data_valid_i = 0;
        @(negedge clk);
        require(!raw_code_valid_o, "raw valid drops on next sampled cycle");

        measure(0, 1);
        measure(1, 1);
        measure(7, 0);
        measure(11, 1); // Re-arm directly from HOLD without consuming the previous result.
        measure(22, 1);

        request_srm; // Watchdog: no decisions. Flagged residue must be discarded by the consumer.
        wait_srm;
        require(srm_count_shortfall && srm_stalled && srm_total_count == 0,
                "watchdog must publish explicit shortfall/stall status");
        consume_srm;
        measure(7, 1); // Recover after watchdog; a new start re-arms the decision domain.

        request_srm;
        @(negedge clk); rst_n = 0;
        repeat (3) @(negedge clk);
        require(!srm_busy && !srm_residue_valid && srm_total_count == 0, "reset during acquisition");
        rst_n = 1;
        repeat (3) @(negedge clk);
        calibrate;
        calibrate; // Restart must perform a second full 14-target sweep.
        $display("SAR16_SMOKE_PASS checks=%0d", checks);
        $finish;
    end
    initial begin
        #8_000_000;
        $fatal(1, "SMOKE_FAIL: global timeout");
    end
endmodule
