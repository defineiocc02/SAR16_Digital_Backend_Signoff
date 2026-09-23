#!/bin/bash
# FIX 16: the positive control for FIX 15 -- run the SAME stimulus on the RTL and read the
# SAME top-level ports, with the bus ranges declared correctly.  If the delivered netlist's
# numbers equal the RTL's, the netlist is functionally correct on this path end to end and
# the earlier "total_count reads 0" was purely a readout defect of my own testbench.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/fix16
rm -rf $W; mkdir -p $W

cat > $W/tb_r.sv <<'SVEOF'
`timescale 1ns/1ps
module tb_r;
  reg clk = 0, dec_clk = 0, rst_n = 0;
  reg start_calib = 0, calib_comp_out = 0, data_valid_i = 0;
  reg [19:0] raw_bits_i = 0;
  reg srm_start = 0, srm_decision_valid = 0, srm_decision_bit = 0, residue_consume_i = 0;
  wire calib_done, calib_done_pulse, calib_mode_en, calib_overrange, raw_code_valid_o;
  wire [19:0] dac_p_force, dac_n_force, calib_overrange_bits, raw_code_o;
  wire w_wr_en; wire [4:0] w_wr_addr; wire [29:0] w_wr_data;
  wire srm_busy, srm_done, srm_residue_valid, srm_count_shortfall, srm_stalled;
  wire [4:0] srm_ones_count, srm_total_count;      // <-- full width (FIX 15's defect)
  wire [9:0] srm_residue_o;
  integer i;

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
    .srm_start(srm_start), .srm_decision_valid(srm_decision_valid),
    .srm_decision_bit(srm_decision_bit), .residue_consume_i(residue_consume_i),
    .srm_busy(srm_busy), .srm_done(srm_done), .srm_residue_valid(srm_residue_valid),
    .srm_ones_count(srm_ones_count), .srm_total_count(srm_total_count),
    .srm_count_shortfall(srm_count_shortfall), .srm_stalled(srm_stalled),
    .srm_residue_o(srm_residue_o)
  );
  always #5 clk = ~clk;
  always #10 dec_clk = ~dec_clk;

  initial begin
    // IDENTICAL stimulus to FIX 15 (the netlist run), so the two are directly comparable.
    rst_n = 0; #200; rst_n = 1; #100;
    srm_start = 1; #20; srm_start = 0; #60;
    srm_decision_valid = 1;
    for (i = 0; i < 40; i = i + 1) begin
      srm_decision_bit = ((i % 3) == 0) ? 1'b1 : 1'b0;
      @(posedge dec_clk);
    end
    srm_decision_valid = 0;
    #4000;
    $display("RTL  state=%b cap_tot=%0d cap_one=%0d", dut.u_srm_residue.state,
             dut.u_srm_residue.cap_total, dut.u_srm_residue.cap_ones);
    $display("RTL  TOP total=%0d ones=%0d shortfall=%b stalled=%b residue=%0d residue_valid=%b",
             srm_total_count, srm_ones_count, srm_count_shortfall, srm_stalled,
             $signed(srm_residue_o), srm_residue_valid);
    $display("RTL  TOP raw residue bits = %b", srm_residue_o);
    $finish;
  end
endmodule
SVEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps \
      -o $W/simv_r \
      $PC/rtl/sar_calib_ctrl_serial.sv $PC/rtl/srm_residue_estimator.sv \
      $PC/rtl/srm_residue_lut.sv $PC/rtl/sar_digi_paper_core.sv \
      $W/tb_r.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -m4 -E '^Error|Error-\[' $W/build.log | sed 's/^/  /'
if [ -x $W/simv_r ]; then
    timeout 900 $W/simv_r -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    grep -a '^RTL' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== FIX16_DONE ==="
