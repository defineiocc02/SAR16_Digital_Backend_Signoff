`timescale 1ns/1ps
module tb_srm_repair;
  reg clk=0, dec_clk=0, dec_enable=1, rst_n=0;
  real dec_half=1.5;
  always #5 clk=~clk;
  always begin #(dec_half); if(dec_enable) dec_clk=~dec_clk; else dec_clk=0; end
  reg start=0,residue_consume=0,decision_valid=0,decision_bit=0;
  wire busy,done,residue_valid,count_shortfall,stalled;
  wire [4:0] ones_count,total_count;
  wire signed [9:0] residue_q;
  srm_residue_estimator #(.RESIDUE_WIDTH(10)) dut(.*);
  integer pubs=0, arms=0, accepts=0, checks=0;
  always @(posedge clk) begin
    if(rst_n && dut.clk_rst_n && dut.accept_request) accepts++;
    #0.001;
    if(done) begin
      pubs++;
      $display("PUB time=%0.3f ns n=%0d ones=%0d total=%0d q=%0d short=%0d stall=%0d busy=%0d",$realtime,pubs,ones_count,total_count,residue_q,count_shortfall,stalled,busy);
    end
  end
  always @(posedge dec_clk) if(rst_n && dut.dec_rst_n && dut.arm_dec) arms++;
  task automatic ck(input bit ok,input string name);
    if(!ok) $fatal(1,"REPAIR_FAIL: %s",name);
    checks++;
  endtask
  task automatic reset_all;
    @(negedge clk); rst_n=0; start=0; residue_consume=0; decision_valid=0;
    dec_enable=1; dec_half=1.5;
    repeat(4) @(negedge clk);
    rst_n=1;
    repeat(4) @(negedge clk);
  endtask
  task automatic request(input int hold_cycles=1, input bit consume=0);
    wait(!busy); @(negedge clk); start=1; residue_consume=consume;
    repeat(hold_cycles) @(negedge clk);
    start=0; residue_consume=0;
  endtask
  task automatic feed(input int n,input bit bit_value);
    // Testbench observes arm, never writes/forces internal state.
    wait(dut.dec_run); @(negedge dec_clk);
    decision_valid=1; decision_bit=bit_value;
    repeat(n) @(negedge dec_clk);
    decision_valid=0;
  endtask
  task automatic expect_normal(input int n_ones);
    wait(done); #0.002;
    ck(total_count==22 && ones_count==n_ones && !count_shortfall && !stalled,"fresh complete counts");
    if(n_ones==0) ck(residue_q==-258,"zero decisions LUT value");
    if(n_ones==22) ck(residue_q==258,"one decisions LUT value");
    ck(residue_valid,"published valid");
    wait(!busy); @(negedge clk);
  endtask
  integer p0,a0,r0;
  initial begin
    reset_all();
    p0=pubs; a0=arms; r0=accepts;
    fork request(2); feed(22,1); join
    expect_normal(22);
    ck(pubs==p0+1 && arms==a0+1 && accepts==r0+1,"two-cycle start arms once");
    fork request(1,1); feed(22,0); join
    expect_normal(0);
    ck(arms==a0+2 && accepts==r0+2,"simultaneous consume/start accepted once");

    // Timeout with an old partial acquisition, followed by late old ones.
    request(); feed(20,1);
    wait(done); #0.002;
    ck(count_shortfall && stalled && ones_count==0 && total_count==0 && residue_q==0,"timeout fail-closed payload");
    ck(busy,"timeout publication is not unsafe rearm readiness");
    p0=pubs; r0=accepts;
    @(negedge clk); start=1; decision_valid=1; decision_bit=1;
    @(negedge clk); start=0; decision_valid=0;
    ck(accepts==r0,"start during drain ignored");
    wait(!busy);
    fork request(); feed(22,0); join
    expect_normal(0);
    ck(pubs==p0+1,"late old completion cannot publish a new result");

    // A request cannot disappear while the decision clock is stopped.
    @(negedge dec_clk); dec_enable=0;
    request();
    wait(done); #0.002;
    ck(stalled && count_shortfall && total_count==0 && residue_q==0,"stopped-clock timeout");
    r0=accepts; a0=arms; p0=pubs;
    repeat(200) @(negedge clk);
    ck(busy && pubs==p0 && arms==a0,"stopped clock remains safely busy without duplicate done");
    start=1; repeat(3) @(negedge clk); start=0;
    ck(accepts==r0,"stopped-clock rearm prohibited");
    dec_enable=1; wait(!busy);
    ck(arms==a0+1,"timed-out pending request acknowledged and drained");
    fork request(); feed(22,1); join
    expect_normal(22);

    // Stop after arm; watchdog remains independent of the decision clock.
    request(); feed(7,1); @(negedge dec_clk); dec_enable=0;
    wait(done); #0.002;
    ck(stalled && count_shortfall && total_count==0,"post-arm stopped-clock timeout");
    repeat(100) @(negedge clk); ck(busy,"retire acknowledgement required");
    dec_enable=1; wait(!busy);
    fork request(); feed(22,0); join
    expect_normal(0);

    // Slow decision clock: repeated timeout and rearm cannot alias generations.
    dec_half=18.5;
    repeat(4) begin
      request(); feed(3,1); wait(done); #0.002;
      ck(stalled && count_shortfall && total_count==0,"slow-clock fail-closed timeout");
      wait(!busy);
    end
    dec_half=1.5;
    fork request(); feed(22,0); join
    expect_normal(0);

    // Async reset aborts both pending arm and published/draining transactions.
    request(); feed(5,1); @(negedge dec_clk); dec_enable=0;
    @(negedge clk); rst_n=0; #0.01;
    ck(!busy && !done && !residue_valid,"asynchronous reset clears publication");
    repeat(3) @(negedge clk); rst_n=1;
    repeat(4) @(negedge clk); dec_enable=1;
    repeat(4) @(negedge clk);
    ck(!done && !residue_valid,"reset does not replay pending acquisition");
    fork request(); feed(22,0); join
    expect_normal(0);
    $display("SRM_REPAIR_PASS checks=%0d publications=%0d accepted_requests=%0d arms=%0d",checks,pubs,accepts,arms);
    $finish;
  end
  initial begin #50000; $fatal(1,"test timeout"); end
endmodule
