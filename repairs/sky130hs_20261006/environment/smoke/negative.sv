module negative(input clk); reg [3:0] counter=0; always @(posedge clk) begin counter<=counter+1; assert(counter!=4'd2); end endmodule
