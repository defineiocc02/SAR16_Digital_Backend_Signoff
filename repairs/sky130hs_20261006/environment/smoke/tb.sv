module tb;
  reg clk=0;
  always #5 clk=~clk;
  reg rst=1, en=0;
  wire [3:0] q;
  counter dut(clk,rst,en,q);
  initial begin
    @(negedge clk); rst=0; en=1;
    repeat(5) @(negedge clk);
    if(q!==5) $fatal(1,"bad counter");
    $display("SIMULATION_SMOKE_PASS");
    $finish;
  end
endmodule
