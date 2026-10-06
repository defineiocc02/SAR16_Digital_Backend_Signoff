module calib_publish_formal(input clk);
  (* anyseq *) reg rst_n, start_calib, comp_out;
  wire calib_done, calib_done_pulse, calib_mode_en, w_wr_en, calib_overrange;
  wire [19:0] dac_p_force,dac_n_force,overrange_bits;
  wire [4:0] w_wr_addr;
  wire signed [29:0] w_wr_data;
  sar_calib_ctrl_serial dut(.*);
  // External observation ports are connected to unchanged RTL by adapter.ys.
  (* keep *) wire [3:0] f_state;
  (* keep *) wire [4:0] f_target, f_wridx, f_sarptr, f_wait, f_calc, f_avg;
  reg past_valid=0;
  always @(posedge clk) begin
    past_valid<=1;
    if (!past_valid) assume(!rst_n); else assume(rst_n);
  end
  always @(posedge clk) if(past_valid && rst_n) begin
    p_state_legal: assert(f_state<=12);
    p_target_range: assert(f_target>=6 && f_target<=19);
    p_write_index_range: assert(f_wridx>=6 && f_wridx<=19);
    p_sar_pointer_range: assert(f_sarptr<=16);
    p_settle_count_range: assert(f_wait<=16);
    p_calc_count_range: assert(f_calc<=20);
    p_publication_address: assert(!w_wr_en || (w_wr_addr>=6 && w_wr_addr<=19));
    p_last_write_completion: assert(!calib_done_pulse || (calib_done && w_wr_en && w_wr_addr==19 && !calib_mode_en));
    p_pipeline_identity: assert(!((f_state==10)||(f_state==11)) || f_wridx==f_target);
    p_sar_pointer_below_target: assert(!((f_state==3)||(f_state==6)) || f_sarptr<((f_target>=18)?17:f_target));
    if($past(rst_n)) begin
      p_write_strobe: assert(!$past(w_wr_en) || !w_wr_en);
      p_done_strobe: assert(!$past(calib_done_pulse) || !calib_done_pulse);
      p_write_qualified:assert(w_wr_en==($past(f_state)==11));
      p_write_address_identity:assert(!w_wr_en || w_wr_addr==$past(f_wridx));
      p_final_write_pulse:assert(calib_done_pulse==($past(f_state)==11 && $past(f_wridx)==19));
      p_done_sticky:assert(!($past(calib_done) && $past(f_state)!=1) || calib_done);
      p_rearm_first_bit:assert(!($past(f_state)==12 && $past(start_calib)) || f_target==6);
    end
    c_start: cover(f_state==1);
    c_search: cover(f_state==3 && f_wait==15);
  end
endmodule
