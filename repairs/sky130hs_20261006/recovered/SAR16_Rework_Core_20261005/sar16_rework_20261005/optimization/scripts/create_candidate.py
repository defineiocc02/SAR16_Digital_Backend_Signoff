from pathlib import Path
R=Path(__file__).resolve().parents[3]; src=R/'sar16_repair_20261005/rtl_frozen/sar_calib_ctrl_serial.sv'; dst=R/'sar16_rework_20261005/repo/rtl_optimized/sar_calib_ctrl_serial.sv'
s=src.read_text()
a='''    // Shadow RAM: holds the currently known weight of every bit.
    logic signed [WEIGHT_WIDTH-1:0] shadow_weights [CAP_NUM];'''
b='''    // Shadow-weight read view: the six trusted reference weights are constants,
    // while every measured weight retains its full WEIGHT_WIDTH-bit register.
    // The indexed read below remains a combinational mux over this complete view.
    // Only the proven CAP_NUM=20 / MAX_CALIB_BIT=5 configuration uses constants;
    // other parameter combinations retain the original dynamic storage behavior.
    localparam bit CONST_TRUSTED_REFERENCE = (CAP_NUM == 20) && (MAX_CALIB_BIT == 5);
    wire signed [WEIGHT_WIDTH-1:0] shadow_weights [CAP_NUM];

    generate
        if (CONST_TRUSTED_REFERENCE) begin : g_const_reference
            for (genvar i = 0; i < CAP_NUM; i++) begin : g_weight
                if (i <= MAX_CALIB_BIT) begin : g_trusted
                    assign shadow_weights[i] = REF_WEIGHT_INIT <<< i;
                end else begin : g_measured
                    logic signed [WEIGHT_WIDTH-1:0] weight_r;
                    assign shadow_weights[i] = weight_r;
                    always_ff @(posedge clk or negedge rst_n) begin
                        if (!rst_n)
                            weight_r <= '0;
                        else if ((state == S_UPDATE_WEIGHT) &&
                                 (wr_idx_r == CAP_IDX_WIDTH'(i)))
                            weight_r <= calc_result_r[WEIGHT_WIDTH-1:0];
                    end
                end
            end
        end else begin : g_original_reference
            logic signed [WEIGHT_WIDTH-1:0] weights_r [CAP_NUM];
            for (genvar i = 0; i < CAP_NUM; i++) begin : g_read
                assign shadow_weights[i] = weights_r[i];
            end
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    for (int i = 0; i < CAP_NUM; i++) begin
                        if (i <= MAX_CALIB_BIT)
                            weights_r[i] <= REF_WEIGHT_INIT <<< i;
                        else
                            weights_r[i] <= '0;
                    end
                end else if (state == S_UPDATE_WEIGHT) begin
                    weights_r[wr_idx_r] <= calc_result_r[WEIGHT_WIDTH-1:0];
                end
            end
        end
    endgenerate'''
assert s.count(a)==1;s=s.replace(a,b)
a='''            // Calibration starts above MAX_CALIB_BIT; the LSB segment is the
            // trusted reference and is loaded with its ideal binary weights.
            for (int i = 0; i < CAP_NUM; i++) begin
                if (i <= MAX_CALIB_BIT)
                    shadow_weights[i] <= REF_WEIGHT_INIT <<< i;
                else
                    shadow_weights[i] <= '0;
            end
'''
assert s.count(a)==1;s=s.replace(a,'')
a='''                    shadow_weights[wr_idx_r] <= calc_result_r[WEIGHT_WIDTH-1:0];

'''
assert s.count(a)==1;s=s.replace(a,'')
dst.write_text(s)
