module formal(input clk); reg[3:0] counter=0; reg past_valid=0; always @(posedge clk) begin counter<=counter+1; past_valid<=1; if(past_valid) assert(counter==$past(counter+4'd1)); end endmodule
