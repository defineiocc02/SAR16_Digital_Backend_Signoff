`timescale 1ns/1ps
// Characterization of the immutable baseline, including known limitations.
// PASS means the stated behavior was reproduced; it does not mean risks are fixed.
module calibration_quant_case #(
    parameter real TARGET = 33.53,
    parameter real OFFSET = 0.0,
    parameter int LOOPS = 32,
    parameter bit ROUNDING = 1,
    parameter int EXPECTED_Q8 = 8576,
    parameter int CASE_ID = 0
)(output logic finished = 0);
    logic clk=0, rst_n=0, start_calib=0;
    always #5 clk=~clk;
    wire [19:0] dac_p_force, dac_n_force, overrange_bits;
    wire calib_done, calib_done_pulse, calib_mode_en, calib_overrange, w_wr_en;
    wire [4:0] w_wr_addr;
    wire signed [29:0] w_wr_data;
    real difference;
    logic comp_out;
    always_comb begin
        difference=OFFSET;
        for(int i=0;i<20;i++) begin
            if(i<=5) begin
                if(dac_p_force[i]) difference=difference+(1<<i);
                if(dac_n_force[i]) difference=difference-(1<<i);
            end else if(i==6) begin
                if(dac_p_force[i]) difference=difference+TARGET;
                if(dac_n_force[i]) difference=difference-TARGET;
            end
        end
        comp_out=(difference>0.0);
    end
    sar_calib_ctrl_serial #(.AVG_LOOPS(LOOPS),.ROUND_HALF_LSB(ROUNDING)) dut(.*);
    initial begin
        repeat(5) @(negedge clk); rst_n=1;
        repeat(5) @(negedge clk); start_calib=1;
        @(negedge clk); start_calib=0;
        wait(w_wr_en); #0.002;
        if(w_wr_addr!=6 || w_wr_data!=EXPECTED_Q8)
            $fatal(1,"REVIEW_FAIL calibration case=%0d addr=%0d data=%0d expected=%0d",CASE_ID,w_wr_addr,w_wr_data,EXPECTED_Q8);
        $display("CAL_QUANT_REPRO case=%0d target_lsb=%0.5f offset_lsb=%0.5f loops=%0d round_half=%0d measured_q8=%0d",CASE_ID,TARGET,OFFSET,LOOPS,ROUNDING,w_wr_data);
        rst_n=0; finished=1;
    end
endmodule

module srm_boundary_case #(parameter int CASE_ID=0)(output logic finished=0);
    logic clk=0,dec_clk=0,rst_n=0,start=0,residue_consume=0;
    always #5 clk=~clk;
    always #1.5 dec_clk=~dec_clk;
    logic decision_valid=0,decision_bit=0;
    wire busy,done,residue_valid,count_shortfall,stalled;
    wire [4:0] ones_count,total_count;
    wire signed [9:0] residue_q;
    srm_residue_estimator #(.RESIDUE_WIDTH(10)) dut(.*);
    int publications=0;
    realtime accepted_ns,last_done_ns;
    always @(posedge clk) begin
        #0.001;
        if(done) begin publications++; last_done_ns=$realtime-0.001; end
    end
    task automatic pulse_start;
        start=1; @(posedge clk); accepted_ns=$realtime;
        #0.001; @(negedge clk); start=0;
    endtask
    task automatic stream(input int n,input bit value);
        @(negedge dec_clk);
        for(int k=0;k<n;k++) begin
            decision_valid=1; decision_bit=value;
            @(posedge dec_clk); @(negedge dec_clk);
        end
        decision_valid=0;
    endtask
    initial begin
        repeat(5) @(negedge clk); rst_n=1;
        repeat(5) @(negedge clk);
        if(CASE_ID==2) begin
            // A two-clk start is outside the documented one-cycle contract.
            start=1; @(posedge clk); accepted_ns=$realtime; #0.001;
            fork
                begin repeat(2) @(negedge clk); start=0; end
                begin #12; stream(22,1); end
            join
            wait(done); #0.002;
            if(total_count!=21 || !count_shortfall || !stalled)
                $fatal(1,"REVIEW_FAIL held-start counterexample changed total=%0d",total_count);
            $display("SRM_BOUNDARY_REPRO kind=held_start total=%0d shortfall=%0d stalled=%0d",total_count,count_shortfall,stalled);
        end else begin
            pulse_start();
            #(accepted_ns+12.001-$realtime);
            stream(CASE_ID==0 ? 20 : 22,1);
            wait(done); #0.002;
            if(CASE_ID==0) begin
                if(total_count!=20 || !count_shortfall || !stalled || last_done_ns!=785.0)
                    $fatal(1,"REVIEW_FAIL timeout precondition");
                // Old measurement completes just before a fresh one-cycle start.
                fork
                    begin
                        #(788.0-$realtime);
                        stream(2,1); // old edges 790.5, 793.5 ns
                    end
                    begin
                        @(negedge clk); pulse_start(); // accepted at 795 ns
                        #(accepted_ns+12.001-$realtime);
                        stream(22,0); // new first edge 811.5, last 874.5 ns
                    end
                join
                #0.002;
                if(publications!=2 || last_done_ns!=835.0 || total_count!=22 || ones_count!=22 || count_shortfall || stalled || residue_q!=258)
                    $fatal(1,"REVIEW_FAIL stale-completion counterexample changed pubs=%0d done=%0.3f total=%0d ones=%0d",publications,last_done_ns,total_count,ones_count);
                $display("SRM_BOUNDARY_REPRO kind=late_old_done new_requested_ones=0 published_ones=%0d total=%0d shortfall=%0d new_start_to_done_ns=%0.3f",ones_count,total_count,count_shortfall,last_done_ns-accepted_ns);
            end else begin
                if(total_count!=22 || count_shortfall || stalled)
                    $fatal(1,"REVIEW_FAIL start-consume precondition");
                @(negedge clk); start=1; residue_consume=1;
                @(posedge clk); accepted_ns=$realtime; #0.001;
                @(negedge clk); start=0; residue_consume=0;
                #(accepted_ns+12.001-$realtime); stream(22,0);
                repeat(20) @(posedge clk); #0.002;
                if(publications!=1 || busy || residue_valid)
                    $fatal(1,"REVIEW_FAIL start-consume counterexample changed");
                $display("SRM_BOUNDARY_REPRO kind=start_consume requests=2 publications=%0d busy=%0d valid=%0d",publications,busy,residue_valid);
            end
        end
        rst_n=0; finished=1;
    end
endmodule

module lut_format_case(output logic finished=0);
    logic [4:0] cnt=0;
    wire signed [9:0] default_q8,shifted_q9,coarse_q4;
    srm_residue_lut baseline(.cnt(cnt),.v_res(default_q8));
    srm_residue_lut #(.RES_FRAC(9),.FRAC_OUT(8)) changed_fraction(.cnt(cnt),.v_res(shifted_q9));
    srm_residue_lut #(.FRAC_OUT(4)) coarse(.cnt(cnt),.v_res(coarse_q4));
    logic clk=0,dec_clk=0,rst_n=0,start=0,residue_consume=0,decision_valid=0,decision_bit=0;
    always #5 clk=~clk;
    always #1.5 dec_clk=~dec_clk;
    wire busy,done,residue_valid,count_shortfall,stalled;
    wire [4:0] ones_count,total_count;
    wire signed [10:0] residue_q;
    srm_residue_estimator #(.RES_FRAC(9),.RESIDUE_WIDTH(11)) estimator_q9(.*);
    int negative;
    initial begin
        #0.002;
        if(default_q8!=-258 || shifted_q9!=-129)
            $fatal(1,"REVIEW_FAIL fraction counterexample changed");
        cnt=1; #0.002; negative=int'(coarse_q4);
        cnt=21; #0.002;
        if(negative!=-13 || coarse_q4!=12 || negative+int'(coarse_q4)!=-1)
            $fatal(1,"REVIEW_FAIL truncation counterexample changed");
        $display("LUT_FORMAT_REPRO kind=coarse_asymmetry k1_q4=%0d k21_q4=%0d pair_sum_q4=%0d",negative,coarse_q4,negative+int'(coarse_q4));
        repeat(5) @(negedge clk); rst_n=1;
        repeat(5) @(negedge clk); start=1;
        @(posedge clk); #0.001;
        fork
            begin @(negedge clk); start=0; end
            begin
                #12; @(negedge dec_clk);
                for(int k=0;k<22;k++) begin
                    decision_valid=1; decision_bit=0;
                    @(posedge dec_clk); @(negedge dec_clk);
                end
                decision_valid=0;
            end
        join
        wait(done); #0.002;
        if(total_count!=22 || count_shortfall || residue_q!=-258)
            $fatal(1,"REVIEW_FAIL Q9 published counterexample changed");
        $display("LUT_FORMAT_REPRO kind=q9_scale published_q9=%0d expected_rescaled_q9=-516",residue_q);
        rst_n=0; finished=1;
    end
endmodule

module tb_rtl_review;
    wire [10:0] finished;
    calibration_quant_case #(.TARGET(33.0),.EXPECTED_Q8(8448),.CASE_ID(0)) c0(finished[0]);
    calibration_quant_case #(.TARGET(33.05),.EXPECTED_Q8(8576),.CASE_ID(1)) c1(finished[1]);
    calibration_quant_case #(.TARGET(33.53),.EXPECTED_Q8(8576),.CASE_ID(2)) c2(finished[2]);
    calibration_quant_case #(.TARGET(33.99),.EXPECTED_Q8(8576),.CASE_ID(3)) c3(finished[3]);
    calibration_quant_case #(.TARGET(33.53),.LOOPS(1),.EXPECTED_Q8(8576),.CASE_ID(4)) c4(finished[4]);
    calibration_quant_case #(.TARGET(33.53),.OFFSET(0.5),.EXPECTED_Q8(8704),.CASE_ID(5)) c5(finished[5]);
    calibration_quant_case #(.TARGET(33.53),.ROUNDING(0),.EXPECTED_Q8(8448),.CASE_ID(6)) c6(finished[6]);
    for(genvar i=0;i<3;i++) begin : boundaries
        srm_boundary_case #(.CASE_ID(i)) boundary(finished[7+i]);
    end
    lut_format_case formats(finished[10]);
    initial begin
        wait(&finished);
        $display("RTL_REVIEW_CHARACTERIZATION_PASS calibration_cases=7 srm_boundary_cases=3 lut_format_cases=2");
        $finish;
    end
    initial begin #1000000; $fatal(1,"REVIEW_FAIL global timeout"); end
endmodule
