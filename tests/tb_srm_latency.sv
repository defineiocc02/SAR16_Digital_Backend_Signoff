`timescale 1ns/1ps
// A protocol timing experiment. No analog model, cell delays or CDC proof.
module srm_latency_case #(
    parameter real PHASE_NS = 0.0,
    parameter int CASE_ID = 0,
    parameter int STREAM_DELAY_NS = 12,
    parameter int SAMPLES = 100
)(output logic finished = 0);
    logic clk = 0, dec_clk = 0, rst_n = 0;
    always #5 clk = ~clk;
    initial begin
        #(PHASE_NS);
        forever #1.5 dec_clk = ~dec_clk;
    end
    logic start = 0, residue_consume = 0;
    logic decision_valid = 0, decision_bit = 0;
    wire busy, done, residue_valid, count_shortfall, stalled;
    wire [4:0] ones_count, total_count;
    wire signed [9:0] residue_q;
    srm_residue_estimator #(.RESIDUE_WIDTH(10)) dut (.*);
    realtime accepted_ns, first_ns, last_ns, published_ns;
    realtime latency_min = 1.0e9, latency_max = 0;
    realtime after_last_min = 1.0e9, after_last_max = 0;
    int published = 0;
    int target_ones;

    function automatic int expected(input int ones);
        int k, value;
        k = (ones > 11) ? 22-ones : ones;
        case (k)
            0: value=-258; 1: value=-194; 2: value=-158;
            3: value=-131; 4: value=-110; 5: value=-91;
            6: value=-74; 7: value=-58; 8: value=-43;
            9: value=-28; 10: value=-14; 11: value=0;
            default: value=999;
        endcase
        return (ones > 11) ? -value : value;
    endfunction

    always @(posedge clk) begin
        #0.001;
        if (done) begin
            published_ns = $realtime - 0.001;
            published++;
            if (STREAM_DELAY_NS >= 12) begin
                if (total_count != 22 || int'(ones_count) != target_ones ||
                    int'($signed(residue_q)) != expected(target_ones) ||
                    !residue_valid || count_shortfall || stalled || busy)
                    $fatal(1, "LATENCY_FAIL case=%0d total=%0d ones=%0d target=%0d", CASE_ID, total_count, ones_count, target_ones);
            end
            if (published_ns-accepted_ns < latency_min) latency_min=published_ns-accepted_ns;
            if (published_ns-accepted_ns > latency_max) latency_max=published_ns-accepted_ns;
            if (published_ns-last_ns < after_last_min) after_last_min=published_ns-last_ns;
            if (published_ns-last_ns > after_last_max) after_last_max=published_ns-last_ns;
        end
    end

    initial begin
        repeat (5) @(negedge clk);
        rst_n = 1;
        repeat (5) @(negedge clk);
        for (int sample_no=0; sample_no<SAMPLES; sample_no++) begin
            // Starts every 20 clk cycles, exactly 200 ns, in S_HOLD after run 1.
            if (busy) $fatal(1,"LATENCY_FAIL still busy at 200 ns deadline");
            if (sample_no>0 && $realtime+5.0-accepted_ns != 200.0)
                $fatal(1,"LATENCY_FAIL request spacing is not 200 ns");
            target_ones = sample_no % 23;
            start=1;
            @(posedge clk);
            accepted_ns=$realtime;
            #0.001;
            fork
                begin
                    @(negedge clk); start=0;
                end
                begin
                    #(STREAM_DELAY_NS);
                    @(negedge dec_clk);
                    for(int k=0;k<22;k++) begin
                        decision_valid=1;
                        decision_bit=(k<target_ones);
                        @(posedge dec_clk);
                        if(k==0) first_ns=$realtime;
                        if(k==21) last_ns=$realtime;
                        @(negedge dec_clk);
                    end
                    decision_valid=0;
                end
            join
            if (STREAM_DELAY_NS < 12) begin
                wait(done);
                #0.002;
                if (total_count != 20 || !count_shortfall || !stalled)
                    $fatal(1,"LATENCY_FAIL early-stream counterexample changed");
                $display("EARLY_STREAM phase=%0.2f total=%0d ones=%0d shortfall=%0d stalled=%0d start_to_done_ns=%0.3f", PHASE_NS,total_count,ones_count,count_shortfall,stalled,published_ns-accepted_ns);
            end else begin
                // Wait only until the next request's negedge, 195 ns after acceptance.
                #(accepted_ns+195.0-$realtime);
                if (published != sample_no+1) $fatal(1,"LATENCY_FAIL missing publication");
            end
        end
        if(STREAM_DELAY_NS>=12)
            $display("LATENCY_PASS case=%0d phase_ns=%0.2f samples=%0d accepted_to_done_min_ns=%0.3f accepted_to_done_max_ns=%0.3f last_to_done_min_ns=%0.3f last_to_done_max_ns=%0.3f first_to_last_ns=%0.3f",CASE_ID,PHASE_NS,published,latency_min,latency_max,after_last_min,after_last_max,last_ns-first_ns);
        finished=1;
    end
endmodule

module tb_srm_latency;
    wire [12:0] finished;
    for (genvar index=0; index<12; index++) begin : phase_cases
        srm_latency_case #(.PHASE_NS(index*0.25),.CASE_ID(index)) test_case(.finished(finished[index]));
    end
    srm_latency_case #(.PHASE_NS(0.0),.CASE_ID(12),.STREAM_DELAY_NS(0),.SAMPLES(1)) early_case(.finished(finished[12]));
    initial begin
        wait(&finished);
        $display("SRM_LATENCY_EXPERIMENT_PASS phases=12 normal_samples=1200");
        $finish;
    end
    initial begin
        #100000;
        $fatal(1,"LATENCY_FAIL global timeout");
    end
endmodule
