module calib_formal(input clk);
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
  // Exact control-cycle ranking function for DEFAULT parameters only.
  // m=min(target,17), L=45+34*m, target cost=4+32*L.
  // Rank counts the remaining active clk edges until the final publication.
  integer rank, tail, m, loop_len, local_rank, loops_after;
  integer i;
  always @* begin
    m = (f_target >= 18) ? 17 : f_target;
    loop_len=45+34*m;
    case(f_target)
      6: loops_after=(31-f_avg)*249;
      7: loops_after=(31-f_avg)*283;
      8: loops_after=(31-f_avg)*317;
      9: loops_after=(31-f_avg)*351;
      10: loops_after=(31-f_avg)*385;
      11: loops_after=(31-f_avg)*419;
      12: loops_after=(31-f_avg)*453;
      13: loops_after=(31-f_avg)*487;
      14: loops_after=(31-f_avg)*521;
      15: loops_after=(31-f_avg)*555;
      16: loops_after=(31-f_avg)*589;
      17: loops_after=(31-f_avg)*623;
      18: loops_after=(31-f_avg)*623;
      19: loops_after=(31-f_avg)*623;
      default:loops_after=0;
    endcase
    tail=0;
    for(i=6;i<=19;i=i+1)
      if(i>f_target) tail=tail+4+32*(45+34*((i>=18)?17:i));
    local_rank=0;
    case(f_state)
      1: local_rank=4+32*loop_len;
      2: local_rank=(loops_after+loop_len)+3;
      3: local_rank=loops_after+3+1+(22+17*m)+21+(17*f_sarptr+f_wait+1);
      4: local_rank=loops_after+3+1+(22+17*m)+(21-f_calc);
      5: local_rank=loops_after+3+1+(22+17*m);
      6: local_rank=loops_after+3+1+21+(17*f_sarptr+f_wait+1);
      7: local_rank=loops_after+3+1+(21-f_calc);
      8: local_rank=loops_after+4;
      9: local_rank=3;
      10:local_rank=2;
      11:local_rank=1;
      default:local_rank=0;
    endcase
    rank=((f_state>0)&&(f_state<12)) ? tail+local_rank : 0;
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
    p_sar_pointer_below_target: assert(!((f_state==3)||(f_state==6)) || f_sarptr<m);
    p_rank_positive: assert(!((f_state>0)&&(f_state<12)) || (rank>0 && rank<=207352));
    if($past(rst_n)) begin
      p_write_strobe: assert(!$past(w_wr_en) || !w_wr_en);
      p_done_strobe: assert(!$past(calib_done_pulse) || !calib_done_pulse);
      if($past(f_state)>0 && $past(f_state)<12)
        p_progress: assert(rank==$past(rank)-1);
      if(($past(f_state)==0 || $past(f_state)==12) && $past(start_calib))
        p_start_rank: assert(rank==207352);
    end
    c_start: cover(f_state==1);
    c_search: cover(f_state==3 && f_wait==15);
  end
endmodule
