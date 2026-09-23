// Fusion Compiler Version W-2024.09-SP3 Verilog Writer
// Generated on 9/18/2026 at 20:10:40
// Library Name: sar16_pnr_paper_core
// Block Name: sar_digi_paper_core
// User Label: 
// Write Command: write_verilog /home/<user>/sar16_work/proj_paper_core/pnr/out/sar_digi_paper_core_pnr.v
module SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_1 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1614 ) ) ;
AND2X4 main_gate ( .A ( net1614 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_2 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1614 ) ) ;
AND2X2 main_gate ( .A ( net1614 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_3 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1614 ) ) ;
AND2X2 main_gate ( .A ( net1614 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_4 ( 
    CLK , EN , ENCLK , TE , ctosc_gls_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ctosc_gls_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ctosc_gls_0 ) , .Q ( net1614 ) ) ;
AND2X2 main_gate ( .A ( net1614 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_0 ( 
    CLK , EN , ENCLK , TE , ctosc_gls_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ctosc_gls_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ctosc_gls_0 ) , .Q ( net1614 ) ) ;
AND2X1 main_gate ( .A ( net1614 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module srm_residue_lut_22_128_8_8_10_1 ( cnt , v_res ) ;
input  [4:0] cnt ;
output [9:0] v_res ;

INVXL U3 ( .A ( n8 ) , .Y ( n13 ) ) ;
NOR2XL U6 ( .A ( n52 ) , .B ( n50 ) , .Y ( n22 ) ) ;
AOI211XL U7 ( .A0 ( n52 ) , .A1 ( n38 ) , .B0 ( n50 ) , .C0 ( n26 ) , 
    .Y ( n27 ) ) ;
AOI21XL U8 ( .A0 ( n15 ) , .A1 ( n29 ) , .B0 ( n14 ) , .Y ( n26 ) ) ;
INVXL U9 ( .A ( n52 ) , .Y ( n14 ) ) ;
INVXL U10 ( .A ( n21 ) , .Y ( n1 ) ) ;
MXI2XL U11 ( .A ( n48 ) , .B ( n57 ) , .S0 ( n33 ) , .Y ( v_res[5] ) ) ;
MXI2XL U12 ( .A ( n48 ) , .B ( n57 ) , .S0 ( n47 ) , .Y ( v_res[7] ) ) ;
MXI2XL U13 ( .A ( n48 ) , .B ( n57 ) , .S0 ( n27 ) , .Y ( v_res[4] ) ) ;
NAND2XL U14 ( .A ( n57 ) , .B ( n56 ) , .Y ( n55 ) ) ;
MXI2XL U15 ( .A ( n57 ) , .B ( n48 ) , .S0 ( n39 ) , .Y ( v_res[6] ) ) ;
XOR2XL U16 ( .A ( n48 ) , .B ( n26 ) , .Y ( v_res[3] ) ) ;
INVXL U17 ( .A ( n48 ) , .Y ( n57 ) ) ;
OAI211XL U18 ( .A0 ( n42 ) , .A1 ( n37 ) , .B0 ( n20 ) , .C0 ( n19 ) , 
    .Y ( v_res[1] ) ) ;
AOI211XL U19 ( .A0 ( n32 ) , .A1 ( n50 ) , .B0 ( n31 ) , .C0 ( n30 ) , 
    .Y ( n33 ) ) ;
NAND2XL U20 ( .A ( n54 ) , .B ( n53 ) , .Y ( n56 ) ) ;
NOR2XL U23 ( .A ( n22 ) , .B ( n21 ) , .Y ( n25 ) ) ;
OAI2BB2XL U24 ( .B0 ( n18 ) , .B1 ( n17 ) , .A0N ( n16 ) , .A1N ( n50 ) , 
    .Y ( v_res[0] ) ) ;
OAI211XL U25 ( .A0 ( n38 ) , .A1 ( n37 ) , .B0 ( n36 ) , .C0 ( n54 ) , 
    .Y ( n39 ) ) ;
NOR2BXL U26 ( .AN ( n44 ) , .B ( n38 ) , .Y ( n31 ) ) ;
NAND2XL U27 ( .A ( n35 ) , .B ( n34 ) , .Y ( n54 ) ) ;
AOI22XL U28 ( .A0 ( n46 ) , .A1 ( n45 ) , .B0 ( n44 ) , .B1 ( n43 ) , 
    .Y ( n47 ) ) ;
NOR2XL U29 ( .A ( n14 ) , .B ( n32 ) , .Y ( n44 ) ) ;
NOR2XL U30 ( .A ( n40 ) , .B ( n15 ) , .Y ( n34 ) ) ;
INVXL U32 ( .A ( n16 ) , .Y ( n32 ) ) ;
NAND2XL U35 ( .A ( n10 ) , .B ( cnt[1] ) , .Y ( n9 ) ) ;
AOI21XL U36 ( .A0 ( cnt[4] ) , .A1 ( n6 ) , .B0 ( cnt[2] ) , .Y ( n7 ) ) ;
INVXL U37 ( .A ( cnt[0] ) , .Y ( n43 ) ) ;
AND3X1 U39 ( .A ( cnt[1] ) , .B ( cnt[2] ) , .C ( cnt[0] ) , .Y ( n11 ) ) ;
NOR2X1 U40 ( .A ( n8 ) , .B ( n11 ) , .Y ( n42 ) ) ;
AOI211XL U41 ( .A0 ( n52 ) , .A1 ( n51 ) , .B0 ( n50 ) , .C0 ( n49 ) , 
    .Y ( n53 ) ) ;
NOR2X1 U42 ( .A ( n41 ) , .B ( n36 ) , .Y ( n50 ) ) ;
NOR2X2 U43 ( .A ( n35 ) , .B ( n40 ) , .Y ( n52 ) ) ;
AOI211X1 U45 ( .A0 ( n49 ) , .A1 ( n51 ) , .B0 ( n31 ) , .C0 ( n34 ) , 
    .Y ( n24 ) ) ;
AOI21X1 U46 ( .A0 ( cnt[2] ) , .A1 ( cnt[3] ) , .B0 ( cnt[4] ) , .Y ( n21 ) ) ;
NOR2XL U47 ( .A ( n14 ) , .B ( n16 ) , .Y ( n49 ) ) ;
OAI21X1 U48 ( .A0 ( n10 ) , .A1 ( cnt[1] ) , .B0 ( n9 ) , .Y ( n16 ) ) ;
NAND2XL U49 ( .A ( cnt[1] ) , .B ( cnt[0] ) , .Y ( n6 ) ) ;
AOI21XL U50 ( .A0 ( cnt[2] ) , .A1 ( n1 ) , .B0 ( n7 ) , .Y ( n8 ) ) ;
NOR2XL U52 ( .A ( n21 ) , .B ( cnt[0] ) , .Y ( n10 ) ) ;
NAND2XL U53 ( .A ( n42 ) , .B ( n16 ) , .Y ( n15 ) ) ;
NAND3XL U54 ( .A ( n35 ) , .B ( n51 ) , .C ( n15 ) , .Y ( n45 ) ) ;
AND2XL U55 ( .A ( n45 ) , .B ( n21 ) , .Y ( v_res[9] ) ) ;
OAI21XL U56 ( .A0 ( cnt[3] ) , .A1 ( n11 ) , .B0 ( cnt[4] ) , .Y ( n12 ) ) ;
NOR2XL U57 ( .A ( n13 ) , .B ( cnt[0] ) , .Y ( n38 ) ) ;
NAND2XL U58 ( .A ( cnt[0] ) , .B ( n42 ) , .Y ( n29 ) ) ;
NAND2XL U59 ( .A ( cnt[0] ) , .B ( n15 ) , .Y ( n18 ) ) ;
OAI21XL U60 ( .A0 ( n42 ) , .A1 ( n16 ) , .B0 ( n52 ) , .Y ( n17 ) ) ;
INVXL U61 ( .A ( n49 ) , .Y ( n37 ) ) ;
AOI22XL U62 ( .A0 ( n52 ) , .A1 ( n18 ) , .B0 ( n1 ) , .B1 ( v_res[0] ) , 
    .Y ( n20 ) ) ;
NAND2XL U63 ( .A ( n50 ) , .B ( n32 ) , .Y ( n19 ) ) ;
NAND2XL U64 ( .A ( n25 ) , .B ( n24 ) , .Y ( n23 ) ) ;
OAI21XL U65 ( .A0 ( n25 ) , .A1 ( n24 ) , .B0 ( n23 ) , .Y ( v_res[2] ) ) ;
OAI21XL U66 ( .A0 ( n42 ) , .A1 ( n43 ) , .B0 ( n49 ) , .Y ( n28 ) ) ;
OAI31XL U67 ( .A0 ( cnt[1] ) , .A1 ( n40 ) , .A2 ( n29 ) , .B0 ( n28 ) , 
    .Y ( n30 ) ) ;
AOI21XL U68 ( .A0 ( n42 ) , .A1 ( n41 ) , .B0 ( n40 ) , .Y ( n46 ) ) ;
OAI21XL U69 ( .A0 ( n57 ) , .A1 ( n56 ) , .B0 ( n55 ) , .Y ( v_res[8] ) ) ;
INVXL U5 ( .A ( n12 ) , .Y ( n40 ) ) ;
NAND2BXL U21 ( .AN ( n51 ) , .B ( n12 ) , .Y ( n36 ) ) ;
NAND2XL U31 ( .A ( n13 ) , .B ( n43 ) , .Y ( n51 ) ) ;
INVXL U33 ( .A ( n41 ) , .Y ( n35 ) ) ;
NAND2BXL U34 ( .AN ( n11 ) , .B ( cnt[3] ) , .Y ( n41 ) ) ;
INVXL ctmTdsLR_1_830 ( .A ( n1 ) , .Y ( tmp_net122 ) ) ;
OAI22X2 ctmTdsLR_2_831 ( .A0 ( n24 ) , .A1 ( tmp_net122 ) , .B0 ( n22 ) , 
    .B1 ( n21 ) , .Y ( n48 ) ) ;
endmodule


module srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64 ( 
    dec_clk , decision_valid , decision_bit , clk , rst_n , start , 
    residue_consume , busy , done , residue_valid , ones_count , total_count , 
    count_shortfall , stalled , residue_q , HFSNET_5 , HFSNET_6 , HFSNET_7 , 
    HFSNET_9 ) ;
input  dec_clk ;
input  decision_valid ;
input  decision_bit ;
input  clk ;
input  rst_n ;
input  start ;
input  residue_consume ;
output busy ;
output done ;
output residue_valid ;
output [4:0] ones_count ;
output [4:0] total_count ;
output count_shortfall ;
output stalled ;
output [9:0] residue_q ;
input  HFSNET_5 ;
input  HFSNET_6 ;
input  HFSNET_7 ;
input  HFSNET_9 ;

wire [4:0] dec_total ;
wire [4:0] dec_ones ;
wire [4:0] ones_g_s2 ;
wire [4:0] tot_g_s2 ;
wire [2:0] state ;
wire [6:0] stall_cnt ;
wire [4:0] cap_ones ;
wire [4:0] cap_total ;
wire [9:0] lut_out ;

srm_residue_lut_22_128_8_8_10_1 u_lut ( .cnt ( cap_ones ) , 
    .v_res ( lut_out ) ) ;
SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_0 clk_gate_dec_ones_reg ( 
    .CLK ( dec_clk ) , .EN ( N43 ) , .ENCLK ( net1622 ) , .TE ( 1'b0 ) , 
    .ctosc_gls_0 ( ctosc_gls_0 ) ) ;
SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_4 clk_gate_dec_total_reg ( 
    .CLK ( dec_clk ) , .EN ( N49 ) , .ENCLK ( net1628 ) , .TE ( 1'b0 ) , 
    .ctosc_gls_0 ( ctosc_gls_0 ) ) ;
SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_3 clk_gate_cap_ones_reg ( 
    .CLK ( clk ) , .EN ( N105 ) , .ENCLK ( net1633 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_2 clk_gate_stall_cnt_reg ( 
    .CLK ( clk ) , .EN ( n124 ) , .ENCLK ( net1638 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64_1 clk_gate_residue_q_small_reg ( 
    .CLK ( clk ) , .EN ( n123 ) , .ENCLK ( net1643 ) , .TE ( 1'b0 ) ) ;
DFFSX1 dec_run_reg ( .D ( n79 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .QN ( dec_run ) ) ;
DFFSX1 tgl_s2_reg ( .D ( n142 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tgl_s2 ) ) ;
DFFSX1 done_pending_reg ( .D ( n84 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( done_pending ) ) ;
DFFSXL \cap_total_reg[4] ( .D ( n126 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_total[4] ) ) ;
DFFSX1 \state_reg[1] ( .D ( n72 ) , .CK ( clk ) , .SN ( HFSNET_8 ) , 
    .Q ( n81 ) , .QN ( state[1] ) ) ;
DFFSX1 \state_reg[2] ( .D ( n71 ) , .CK ( clk ) , .SN ( rst_n ) , 
    .Q ( n131 ) , .QN ( state[2] ) ) ;
DFFSX1 \stall_cnt_reg[6] ( .D ( n85 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( stall_cnt[6] ) ) ;
DFFSX1 \stall_cnt_reg[5] ( .D ( n86 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( stall_cnt[5] ) ) ;
DFFSX1 \stall_cnt_reg[4] ( .D ( n87 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( stall_cnt[4] ) ) ;
DFFSX1 \stall_cnt_reg[3] ( .D ( n88 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( stall_cnt[3] ) ) ;
DFFSX1 \stall_cnt_reg[2] ( .D ( n89 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( stall_cnt[2] ) ) ;
DFFSX1 \stall_cnt_reg[1] ( .D ( n90 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( stall_cnt[1] ) ) ;
DFFSX1 \stall_cnt_reg[0] ( .D ( n91 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( stall_cnt[0] ) ) ;
DFFSX1 \tot_g_s2_reg[0] ( .D ( n141 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tot_g_s2[0] ) ) ;
DFFSX1 \dec_total_reg[2] ( .D ( n120 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .Q ( n75 ) , .QN ( dec_total[2] ) ) ;
DFFSX1 \tot_g_s2_reg[1] ( .D ( n140 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tot_g_s2[1] ) ) ;
DFFSX1 \tot_g_s2_reg[3] ( .D ( n139 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tot_g_s2[3] ) ) ;
DFFSXL \cap_total_reg[3] ( .D ( n63 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_total[3] ) ) ;
DFFSX1 \tot_g_s2_reg[2] ( .D ( n138 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tot_g_s2[2] ) ) ;
DFFSXL \cap_total_reg[2] ( .D ( n60 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_total[2] ) ) ;
DFFSXL cap_shortfall_reg ( .D ( n59 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_shortfall ) ) ;
DFFSXL \cap_total_reg[0] ( .D ( n58 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_total[0] ) ) ;
DFFSXL \cap_total_reg[1] ( .D ( n57 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_total[1] ) ) ;
DFFSX1 \ones_g_s2_reg[0] ( .D ( n137 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( ones_g_s2[0] ) ) ;
DFFSX1 \ones_g_s2_reg[1] ( .D ( n136 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .QN ( ones_g_s2[1] ) ) ;
DFFSX1 \dec_ones_reg[3] ( .D ( n114 ) , .CK ( net1622 ) , .SN ( HFSNET_9 ) , 
    .Q ( n144 ) , .QN ( dec_ones[3] ) ) ;
DFFSX1 \ones_g_s2_reg[2] ( .D ( n135 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( ones_g_s2[2] ) ) ;
DFFSXL \cap_ones_reg[4] ( .D ( n125 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_ones[4] ) ) ;
DFFSX1 \ones_g_s2_reg[3] ( .D ( n133 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( ones_g_s2[3] ) ) ;
DFFSX1 \cap_ones_reg[3] ( .D ( n45 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_ones[3] ) ) ;
DFFSX1 tgl_ref_reg ( .D ( n37 ) , .CK ( net1638 ) , .SN ( HFSNET_8 ) , 
    .QN ( tgl_ref ) ) ;
DFFSX1 \tot_g_s1_reg[4] ( .D ( n128 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n143 ) ) ;
DFFSX1 tgl_s1_reg ( .D ( n129 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n142 ) ) ;
DFFSX1 \tot_g_s1_reg[0] ( .D ( n69 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n141 ) ) ;
DFFSX1 \tot_g_s1_reg[1] ( .D ( n67 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n140 ) ) ;
DFFSX1 \tot_g_s1_reg[3] ( .D ( n65 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n139 ) ) ;
DFFSX1 \tot_g_s1_reg[2] ( .D ( n62 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n138 ) ) ;
DFFSX1 \ones_g_s1_reg[0] ( .D ( n56 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n137 ) ) ;
DFFSX1 \ones_g_s1_reg[1] ( .D ( n54 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .Q ( n136 ) ) ;
DFFSX1 \ones_g_s1_reg[2] ( .D ( n52 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n135 ) ) ;
DFFSX1 \ones_g_s1_reg[4] ( .D ( n78 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n134 ) ) ;
DFFSX1 \ones_g_s1_reg[3] ( .D ( n47 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n133 ) ) ;
DFFSX1 go_tgl_reg ( .D ( n39 ) , .CK ( clk ) , .SN ( rst_n ) , .Q ( n132 ) , 
    .QN ( go_tgl ) ) ;
DFFSX1 dec_done_tgl_reg ( .D ( n38 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .Q ( n129 ) ) ;
DFFSX1 \dec_total_reg[1] ( .D ( n121 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .Q ( n127 ) , .QN ( dec_total[1] ) ) ;
DFFSX1 \tot_g_s2_reg[4] ( .D ( n143 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n126 ) , .QN ( tot_g_s2[4] ) ) ;
DFFSX1 \ones_g_s2_reg[4] ( .D ( n134 ) , .CK ( clk ) , .SN ( HFSNET_8 ) , 
    .Q ( n125 ) , .QN ( ones_g_s2[4] ) ) ;
DFFSX1 go_tgl_s1_reg ( .D ( n132 ) , .CK ( ctosc_gls_0 ) , .SN ( HFSNET_9 ) , 
    .Q ( n82 ) ) ;
DFFSX1 \dec_total_reg[3] ( .D ( n119 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .Q ( n76 ) , .QN ( dec_total[3] ) ) ;
DFFSX1 done_reg ( .D ( n41 ) , .CK ( clk ) , .SN ( HFSNET_5 ) , .QN ( done ) ) ;
DFFSXL \residue_q_small_reg[9] ( .D ( n92 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[9] ) ) ;
DFFSXL \residue_q_small_reg[8] ( .D ( n93 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[8] ) ) ;
DFFSXL \residue_q_small_reg[7] ( .D ( n94 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[7] ) ) ;
DFFSXL \residue_q_small_reg[6] ( .D ( n95 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[6] ) ) ;
DFFSXL \residue_q_small_reg[5] ( .D ( n96 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[5] ) ) ;
DFFSXL \residue_q_small_reg[4] ( .D ( n97 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[4] ) ) ;
DFFSXL \residue_q_small_reg[3] ( .D ( n98 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[3] ) ) ;
DFFSXL \residue_q_small_reg[2] ( .D ( n99 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[2] ) ) ;
DFFSXL \residue_q_small_reg[1] ( .D ( n100 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[1] ) ) ;
DFFSXL \residue_q_small_reg[0] ( .D ( n101 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( residue_q[0] ) ) ;
DFFSXL \ones_count_reg[4] ( .D ( n103 ) , .CK ( net1643 ) , .SN ( HFSNET_5 ) , 
    .QN ( ones_count[4] ) ) ;
DFFSXL \ones_count_reg[3] ( .D ( n104 ) , .CK ( net1643 ) , .SN ( HFSNET_5 ) , 
    .QN ( ones_count[3] ) ) ;
DFFSXL \ones_count_reg[2] ( .D ( n105 ) , .CK ( net1643 ) , .SN ( HFSNET_5 ) , 
    .QN ( ones_count[2] ) ) ;
DFFSXL \ones_count_reg[1] ( .D ( n106 ) , .CK ( net1643 ) , .SN ( HFSNET_5 ) , 
    .QN ( ones_count[1] ) ) ;
DFFSXL \ones_count_reg[0] ( .D ( n107 ) , .CK ( net1643 ) , .SN ( HFSNET_5 ) , 
    .QN ( ones_count[0] ) ) ;
DFFSXL \total_count_reg[4] ( .D ( n108 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( total_count[4] ) ) ;
DFFSXL \total_count_reg[3] ( .D ( n109 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( total_count[3] ) ) ;
DFFSXL \total_count_reg[2] ( .D ( n110 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( total_count[2] ) ) ;
DFFSXL \total_count_reg[1] ( .D ( n111 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_8 ) , .QN ( total_count[1] ) ) ;
DFFSXL \total_count_reg[0] ( .D ( n112 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( total_count[0] ) ) ;
DFFSXL count_shortfall_reg ( .D ( n102 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_5 ) , .QN ( count_shortfall ) ) ;
DFFSX1 \dec_total_reg[0] ( .D ( n122 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .QN ( dec_total[0] ) ) ;
DFFSX1 go_tgl_s2_reg ( .D ( n82 ) , .CK ( ctosc_gls_0 ) , .SN ( HFSNET_9 ) , 
    .Q ( n80 ) , .QN ( go_tgl_s2 ) ) ;
DFFSXL \cap_ones_reg[2] ( .D ( n44 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_ones[2] ) ) ;
DFFSX1 \cap_ones_reg[0] ( .D ( n43 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_ones[0] ) ) ;
DFFSXL \cap_ones_reg[1] ( .D ( n42 ) , .CK ( net1633 ) , .SN ( HFSNET_8 ) , 
    .QN ( cap_ones[1] ) ) ;
DFFSX1 \dec_total_reg[4] ( .D ( n118 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .Q ( n128 ) , .QN ( dec_total[4] ) ) ;
DFFSX1 busy_reg ( .D ( n83 ) , .CK ( clk ) , .SN ( HFSNET_8 ) , 
    .QN ( aps_rename_5_ ) ) ;
DFFSX1 stalled_reg ( .D ( n70 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .QN ( stalled ) ) ;
DFFSX1 residue_valid_reg ( .D ( n40 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .QN ( aps_rename_6_ ) ) ;
DFFSX1 \state_reg[0] ( .D ( n73 ) , .CK ( clk ) , .SN ( HFSNET_8 ) , 
    .Q ( n130 ) , .QN ( state[0] ) ) ;
DFFSX1 \dec_ones_reg[4] ( .D ( n113 ) , .CK ( net1622 ) , .SN ( HFSNET_9 ) , 
    .Q ( n78 ) , .QN ( dec_ones[4] ) ) ;
DFFSX1 \dec_ones_reg[2] ( .D ( n115 ) , .CK ( net1622 ) , .SN ( HFSNET_9 ) , 
    .Q ( n77 ) , .QN ( dec_ones[2] ) ) ;
DFFSX1 \dec_ones_reg[0] ( .D ( n117 ) , .CK ( net1622 ) , .SN ( HFSNET_9 ) , 
    .QN ( dec_ones[0] ) ) ;
DFFSX1 \dec_ones_reg[1] ( .D ( n116 ) , .CK ( net1622 ) , .SN ( HFSNET_9 ) , 
    .QN ( dec_ones[1] ) ) ;
DFFSX1 go_tgl_s3_reg ( .D ( n80 ) , .CK ( ctosc_gls_0 ) , .SN ( HFSNET_9 ) , 
    .QN ( go_tgl_s3 ) ) ;
OAI21XL U3 ( .A0 ( n129 ) , .A1 ( n74 ) , .B0 ( n68 ) , .Y ( n38 ) ) ;
OAI21XL U4 ( .A0 ( n78 ) , .A1 ( n36 ) , .B0 ( n35 ) , .Y ( n113 ) ) ;
OAI21XL U5 ( .A0 ( n128 ) , .A1 ( n32 ) , .B0 ( n31 ) , .Y ( n118 ) ) ;
NAND2BXL U6 ( .AN ( dec_ones[0] ) , .B ( n33 ) , .Y ( n117 ) ) ;
OAI211XL U7 ( .A0 ( n29 ) , .A1 ( dec_total[3] ) , .B0 ( n33 ) , .C0 ( n32 ) , 
    .Y ( n119 ) ) ;
NAND2XL U8 ( .A ( n29 ) , .B ( dec_total[3] ) , .Y ( n32 ) ) ;
NAND2XL U9 ( .A ( n28 ) , .B ( dec_ones[3] ) , .Y ( n36 ) ) ;
NAND4BXL U10 ( .AN ( n23 ) , .B ( dec_total[0] ) , .C ( dec_total[2] ) , 
    .D ( n127 ) , .Y ( n66 ) ) ;
INVXL U11 ( .A ( n30 ) , .Y ( n64 ) ) ;
NAND2XL U12 ( .A ( dec_ones[1] ) , .B ( dec_ones[0] ) , .Y ( n24 ) ) ;
NAND2XL U13 ( .A ( dec_total[1] ) , .B ( dec_total[0] ) , .Y ( n26 ) ) ;
OAI21XL U14 ( .A0 ( dec_ones[1] ) , .A1 ( dec_ones[0] ) , .B0 ( n24 ) , 
    .Y ( n56 ) ) ;
CLKINVX4 HFSINV_12109_645 ( .A ( HFSNET_7 ) , .Y ( HFSNET_8 ) ) ;
AOI21XL U16 ( .A0 ( n78 ) , .A1 ( n36 ) , .B0 ( n34 ) , .Y ( n35 ) ) ;
AOI21XL U17 ( .A0 ( n128 ) , .A1 ( n32 ) , .B0 ( n34 ) , .Y ( n31 ) ) ;
AOI2BB1XL U18 ( .A0N ( n17 ) , .A1N ( stall_cnt[6] ) , .B0 ( n49 ) , 
    .Y ( N105 ) ) ;
OAI2BB2XL U19 ( .B0 ( tgl_ref ) , .B1 ( tgl_s2 ) , .A0N ( tgl_s2 ) , 
    .A1N ( tgl_ref ) , .Y ( n3 ) ) ;
NAND2XL U20 ( .A ( n131 ) , .B ( n81 ) , .Y ( n55 ) ) ;
BUFX1 ctosc_gls_inst_1569 ( .A ( dec_clk ) , .Y ( ctosc_gls_0 ) ) ;
NAND2XL U22 ( .A ( n7 ) , .B ( lut_out[8] ) , .Y ( n93 ) ) ;
NAND2XL U23 ( .A ( n7 ) , .B ( lut_out[7] ) , .Y ( n94 ) ) ;
NAND2XL U24 ( .A ( n7 ) , .B ( lut_out[6] ) , .Y ( n95 ) ) ;
NAND2XL U25 ( .A ( n7 ) , .B ( lut_out[5] ) , .Y ( n96 ) ) ;
NAND2XL U26 ( .A ( n7 ) , .B ( lut_out[4] ) , .Y ( n97 ) ) ;
NAND2XL U27 ( .A ( n12 ) , .B ( stall_cnt[4] ) , .Y ( n14 ) ) ;
INVXL U28 ( .A ( n11 ) , .Y ( n12 ) ) ;
NAND2XL U29 ( .A ( stall_cnt[3] ) , .B ( n8 ) , .Y ( n11 ) ) ;
INVXL U31 ( .A ( n34 ) , .Y ( n33 ) ) ;
NAND2BXL U32 ( .AN ( done_pending ) , .B ( n3 ) , .Y ( n17 ) ) ;
NAND2XL U33 ( .A ( n30 ) , .B ( n34 ) , .Y ( N49 ) ) ;
AOI2BB2XL U35 ( .B0 ( dec_ones[1] ) , .B1 ( n77 ) , .A0N ( n77 ) , 
    .A1N ( dec_ones[1] ) , .Y ( n54 ) ) ;
NAND3X1 U36 ( .A ( n30 ) , .B ( decision_valid ) , .C ( dec_run ) , 
    .Y ( n34 ) ) ;
AOI2BB2XL U37 ( .B0 ( busy ) , .B1 ( state[1] ) , .A0N ( state[2] ) , 
    .A1N ( n53 ) , .Y ( n83 ) ) ;
MXI2XL U38 ( .A ( go_tgl ) , .B ( n132 ) , .S0 ( n61 ) , .Y ( n39 ) ) ;
MXI2X1 U39 ( .A ( go_tgl_s2 ) , .B ( n80 ) , .S0 ( go_tgl_s3 ) , .Y ( n30 ) ) ;
NOR2BXL U40 ( .AN ( start ) , .B ( busy ) , .Y ( n61 ) ) ;
NOR2XL U43 ( .A ( state[2] ) , .B ( n81 ) , .Y ( n21 ) ) ;
OAI21X1 U44 ( .A0 ( tot_g_s2[4] ) , .A1 ( tot_g_s2[3] ) , .B0 ( n6 ) , 
    .Y ( n63 ) ) ;
INVXL U46 ( .A ( n49 ) , .Y ( n46 ) ) ;
NAND2XL U47 ( .A ( n21 ) , .B ( n130 ) , .Y ( n49 ) ) ;
NOR2XL U49 ( .A ( state[0] ) , .B ( state[1] ) , .Y ( n53 ) ) ;
NAND2XL U50 ( .A ( state[2] ) , .B ( n53 ) , .Y ( n41 ) ) ;
NAND2XL U51 ( .A ( tot_g_s2[4] ) , .B ( tot_g_s2[3] ) , .Y ( n6 ) ) ;
MXI2X1 U52 ( .A ( ones_g_s2[4] ) , .B ( n125 ) , .S0 ( ones_g_s2[3] ) , 
    .Y ( n45 ) ) ;
AOI2BB2X1 U53 ( .B0 ( tot_g_s2[2] ) , .B1 ( n63 ) , .A0N ( n63 ) , 
    .A1N ( tot_g_s2[2] ) , .Y ( n60 ) ) ;
AOI2BB2X1 U54 ( .B0 ( tot_g_s2[1] ) , .B1 ( n60 ) , .A0N ( n60 ) , 
    .A1N ( tot_g_s2[1] ) , .Y ( n57 ) ) ;
OAI21XL U55 ( .A0 ( n130 ) , .A1 ( n55 ) , .B0 ( n49 ) , .Y ( n124 ) ) ;
OAI21XL U56 ( .A0 ( dec_total[0] ) , .A1 ( dec_total[1] ) , .B0 ( n26 ) , 
    .Y ( n69 ) ) ;
XOR2XL U57 ( .A ( ones_g_s2[2] ) , .B ( n45 ) , .Y ( n44 ) ) ;
XOR2XL U58 ( .A ( ones_g_s2[1] ) , .B ( n44 ) , .Y ( n42 ) ) ;
XOR2XL U59 ( .A ( ones_g_s2[0] ) , .B ( n42 ) , .Y ( n43 ) ) ;
AOI22XL U60 ( .A0 ( dec_total[3] ) , .A1 ( n75 ) , .B0 ( dec_total[2] ) , 
    .B1 ( n76 ) , .Y ( n62 ) ) ;
AOI22XL U61 ( .A0 ( dec_ones[3] ) , .A1 ( n77 ) , .B0 ( dec_ones[2] ) , 
    .B1 ( n144 ) , .Y ( n52 ) ) ;
AOI22XL U62 ( .A0 ( dec_total[2] ) , .A1 ( n127 ) , .B0 ( dec_total[1] ) , 
    .B1 ( n75 ) , .Y ( n67 ) ) ;
AOI22XL U63 ( .A0 ( dec_total[4] ) , .A1 ( n76 ) , .B0 ( dec_total[3] ) , 
    .B1 ( n128 ) , .Y ( n65 ) ) ;
AOI22XL U64 ( .A0 ( dec_ones[4] ) , .A1 ( n144 ) , .B0 ( dec_ones[3] ) , 
    .B1 ( n78 ) , .Y ( n47 ) ) ;
AOI22XL U65 ( .A0 ( state[0] ) , .A1 ( tgl_s2 ) , .B0 ( tgl_ref ) , 
    .B1 ( n130 ) , .Y ( n37 ) ) ;
OAI211XL U66 ( .A0 ( n21 ) , .A1 ( n3 ) , .B0 ( n130 ) , .C0 ( n17 ) , 
    .Y ( n84 ) ) ;
NOR2BXL U67 ( .AN ( stall_cnt[6] ) , .B ( n49 ) , .Y ( n4 ) ) ;
AOI21XL U68 ( .A0 ( stalled ) , .A1 ( n55 ) , .B0 ( n4 ) , .Y ( n70 ) ) ;
INVXL U69 ( .A ( n124 ) , .Y ( n72 ) ) ;
NAND4BXL U70 ( .AN ( n4 ) , .B ( tot_g_s2[2] ) , .C ( tot_g_s2[0] ) , 
    .D ( n17 ) , .Y ( n5 ) ) ;
NOR3XL U71 ( .A ( tot_g_s2[1] ) , .B ( n6 ) , .C ( n5 ) , .Y ( n59 ) ) ;
INVX2 U72 ( .A ( n41 ) , .Y ( n7 ) ) ;
NAND2XL U73 ( .A ( n7 ) , .B ( cap_total[4] ) , .Y ( n108 ) ) ;
NAND2XL U74 ( .A ( n7 ) , .B ( cap_shortfall ) , .Y ( n102 ) ) ;
NAND2XL U75 ( .A ( n7 ) , .B ( cap_total[3] ) , .Y ( n109 ) ) ;
NAND2XL U76 ( .A ( n7 ) , .B ( cap_total[0] ) , .Y ( n112 ) ) ;
NAND2XL U77 ( .A ( n7 ) , .B ( cap_total[2] ) , .Y ( n110 ) ) ;
NAND2XL U78 ( .A ( n7 ) , .B ( cap_total[1] ) , .Y ( n111 ) ) ;
NAND2XL U79 ( .A ( n7 ) , .B ( cap_ones[3] ) , .Y ( n104 ) ) ;
NAND2XL U80 ( .A ( n7 ) , .B ( cap_ones[4] ) , .Y ( n103 ) ) ;
NAND2XL U81 ( .A ( n7 ) , .B ( cap_ones[2] ) , .Y ( n105 ) ) ;
NAND2XL U82 ( .A ( n7 ) , .B ( cap_ones[1] ) , .Y ( n106 ) ) ;
NAND2XL U83 ( .A ( n7 ) , .B ( cap_ones[0] ) , .Y ( n107 ) ) ;
NAND3XL U84 ( .A ( stall_cnt[0] ) , .B ( stall_cnt[2] ) , 
    .C ( stall_cnt[1] ) , .Y ( n9 ) ) ;
INVXL U85 ( .A ( n9 ) , .Y ( n8 ) ) ;
OAI211XL U86 ( .A0 ( n8 ) , .A1 ( stall_cnt[3] ) , .B0 ( n46 ) , .C0 ( n11 ) , 
    .Y ( n88 ) ) ;
NAND2XL U87 ( .A ( stall_cnt[1] ) , .B ( stall_cnt[0] ) , .Y ( n13 ) ) ;
INVXL U88 ( .A ( n13 ) , .Y ( n10 ) ) ;
OAI211XL U89 ( .A0 ( n10 ) , .A1 ( stall_cnt[2] ) , .B0 ( n46 ) , .C0 ( n9 ) , 
    .Y ( n89 ) ) ;
OAI211XL U90 ( .A0 ( n12 ) , .A1 ( stall_cnt[4] ) , .B0 ( n46 ) , 
    .C0 ( n14 ) , .Y ( n87 ) ) ;
OAI211XL U91 ( .A0 ( stall_cnt[0] ) , .A1 ( stall_cnt[1] ) , .B0 ( n46 ) , 
    .C0 ( n13 ) , .Y ( n90 ) ) ;
INVXL U92 ( .A ( n14 ) , .Y ( n15 ) ) ;
NAND2XL U93 ( .A ( stall_cnt[5] ) , .B ( n15 ) , .Y ( n48 ) ) ;
OAI211XL U94 ( .A0 ( n15 ) , .A1 ( stall_cnt[5] ) , .B0 ( n46 ) , 
    .C0 ( n48 ) , .Y ( n86 ) ) ;
OAI211XL U95 ( .A0 ( residue_consume ) , .A1 ( n131 ) , .B0 ( state[0] ) , 
    .C0 ( n81 ) , .Y ( n16 ) ) ;
AOI21XL U96 ( .A0 ( HFSNET_1 ) , .A1 ( n16 ) , .B0 ( n7 ) , .Y ( n40 ) ) ;
AOI211XL U97 ( .A0 ( state[0] ) , .A1 ( residue_consume ) , .B0 ( n131 ) , 
    .C0 ( state[1] ) , .Y ( n18 ) ) ;
AOI211XL U98 ( .A0 ( n53 ) , .A1 ( start ) , .B0 ( N105 ) , .C0 ( n18 ) , 
    .Y ( n73 ) ) ;
OR3XL U99 ( .A ( residue_consume ) , .B ( n131 ) , .C ( state[1] ) , 
    .Y ( n19 ) ) ;
OAI21XL U100 ( .A0 ( start ) , .A1 ( n19 ) , .B0 ( n41 ) , .Y ( n20 ) ) ;
AOI21XL U101 ( .A0 ( state[0] ) , .A1 ( n21 ) , .B0 ( n20 ) , .Y ( n71 ) ) ;
NAND2XL U102 ( .A ( n7 ) , .B ( lut_out[9] ) , .Y ( n92 ) ) ;
NAND2XL U103 ( .A ( n7 ) , .B ( lut_out[0] ) , .Y ( n101 ) ) ;
NAND2XL U104 ( .A ( n7 ) , .B ( lut_out[1] ) , .Y ( n100 ) ) ;
NAND2XL U105 ( .A ( n7 ) , .B ( lut_out[2] ) , .Y ( n99 ) ) ;
NAND2XL U106 ( .A ( n7 ) , .B ( lut_out[3] ) , .Y ( n98 ) ) ;
NAND2XL U107 ( .A ( dec_total[4] ) , .B ( n76 ) , .Y ( n23 ) ) ;
AOI21XL U108 ( .A0 ( dec_run ) , .A1 ( n66 ) , .B0 ( n64 ) , .Y ( n79 ) ) ;
OR2XL U109 ( .A ( n56 ) , .B ( n34 ) , .Y ( n116 ) ) ;
OR2XL U110 ( .A ( n69 ) , .B ( n34 ) , .Y ( n121 ) ) ;
AOI21XL U111 ( .A0 ( n24 ) , .A1 ( n77 ) , .B0 ( n28 ) , .Y ( n25 ) ) ;
NAND2XL U112 ( .A ( n33 ) , .B ( n25 ) , .Y ( n115 ) ) ;
AOI21XL U113 ( .A0 ( n75 ) , .A1 ( n26 ) , .B0 ( n29 ) , .Y ( n27 ) ) ;
NAND2XL U114 ( .A ( n33 ) , .B ( n27 ) , .Y ( n120 ) ) ;
OAI211XL U115 ( .A0 ( dec_ones[3] ) , .A1 ( n28 ) , .B0 ( n33 ) , 
    .C0 ( n36 ) , .Y ( n114 ) ) ;
OAI2BB1XL U116 ( .A0N ( n33 ) , .A1N ( decision_bit ) , .B0 ( n30 ) , 
    .Y ( N43 ) ) ;
NAND2BXL U117 ( .AN ( dec_total[0] ) , .B ( n33 ) , .Y ( n122 ) ) ;
NAND2BXL U118 ( .AN ( stall_cnt[0] ) , .B ( n46 ) , .Y ( n91 ) ) ;
INVXL U119 ( .A ( n48 ) , .Y ( n51 ) ) ;
AOI21XL U120 ( .A0 ( stall_cnt[6] ) , .A1 ( n51 ) , .B0 ( n49 ) , .Y ( n50 ) ) ;
OAI21XL U121 ( .A0 ( stall_cnt[6] ) , .A1 ( n51 ) , .B0 ( n50 ) , .Y ( n85 ) ) ;
AOI2BB2XL U123 ( .B0 ( tot_g_s2[0] ) , .B1 ( n57 ) , .A0N ( n57 ) , 
    .A1N ( tot_g_s2[0] ) , .Y ( n58 ) ) ;
OAI21XL U124 ( .A0 ( n130 ) , .A1 ( n55 ) , .B0 ( n41 ) , .Y ( n123 ) ) ;
OR2XL U125 ( .A ( n66 ) , .B ( n64 ) , .Y ( n74 ) ) ;
NAND2XL U126 ( .A ( n129 ) , .B ( n74 ) , .Y ( n68 ) ) ;
NOR2XL U30 ( .A ( n24 ) , .B ( n77 ) , .Y ( n28 ) ) ;
NOR2XL U34 ( .A ( n26 ) , .B ( n75 ) , .Y ( n29 ) ) ;
INVXL HFSINV_4_445 ( .A ( residue_valid ) , .Y ( HFSNET_1 ) ) ;
INVXL HFSINV_38_447 ( .A ( aps_rename_6_ ) , .Y ( residue_valid ) ) ;
CLKBUFX3 HFSBUF_59_500 ( .A ( aps_rename_5_ ) , .Y ( busy ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_1_2 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( HFSNET_0 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
CLKBUFXL HFSBUF_2_272 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_1 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_2 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_3 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_4 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_5 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_2 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_2 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_2 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_6 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_2 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_2 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_2 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_7 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( ZBUF_2_12 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
BUFX1 ZBUF_2_inst_1624 ( .A ( net1652 ) , .Y ( ZBUF_2_12 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_8 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_9 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_10 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_11 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_12 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_13 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_14 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_15 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_16 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_17 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_18 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_19 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_20 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
CLKBUFX3 HFSBUF_2_267 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_21 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_22 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( ropt_net_506 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
BUFXL ropt_mt_inst_2193 ( .A ( net1652 ) , .Y ( ropt_net_506 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_23 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
CLKBUFX3 HFSBUF_2_265 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_24 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_25 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( HFSNET_0 ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( ZBUF_2_12 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
INVXL HFSINV_95_504 ( .A ( EN ) , .Y ( HFSNET_0 ) ) ;
BUFX1 ZBUF_2_inst_1616 ( .A ( net1652 ) , .Y ( ZBUF_2_12 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_26 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_27 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
BUFX1 HFSBUF_2_271 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_28 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( ZBUF_2_12 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
BUFX1 ZBUF_2_inst_1617 ( .A ( net1652 ) , .Y ( ZBUF_2_12 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_29 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
CLKBUFX3 HFSBUF_2_270 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_30 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_31 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
CLKBUFX3 HFSBUF_2_268 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_32 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_33 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_0 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module sar_calib_ctrl_serial_20_30_16_32_5_256_1_1 ( clk , rst_n , 
    start_calib , calib_done , calib_done_pulse , calib_mode_en , comp_out , 
    dac_p_force , dac_n_force , w_wr_en , w_wr_addr , w_wr_data , 
    calib_overrange , overrange_bits , HFSNET_351 , HFSNET_365 , HFSNET_371 , 
    HFSNET_381 , HFSNET_382 , ZBUF_24_2 , ZBUF_22_2 , ZCTSNET_411 , 
    ZCTSNET_413 , gre_a_BUF_36_0 , gre_a_BUF_36_1 , gre_a_BUF_36_2 , 
    gre_a_BUF_36_3 ) ;
input  clk ;
input  rst_n ;
input  start_calib ;
output calib_done ;
output calib_done_pulse ;
output calib_mode_en ;
input  comp_out ;
output [19:0] dac_p_force ;
output [19:0] dac_n_force ;
output w_wr_en ;
output [4:0] w_wr_addr ;
output [29:0] w_wr_data ;
output calib_overrange ;
output [19:0] overrange_bits ;
input  HFSNET_351 ;
input  HFSNET_365 ;
input  HFSNET_371 ;
input  HFSNET_381 ;
input  HFSNET_382 ;
input  ZBUF_24_2 ;
input  ZBUF_22_2 ;
input  ZCTSNET_411 ;
input  ZCTSNET_413 ;
input  gre_a_BUF_36_0 ;
input  gre_a_BUF_36_1 ;
input  gre_a_BUF_36_2 ;
input  gre_a_BUF_36_3 ;

wire [3:0] state ;
wire [29:0] temp_acc ;
wire [4:0] target_bit ;
wire [19:0] protected_sar_code ;
wire [18:17] sar_code ;
wire [4:0] wait_cnt ;
wire [4:0] sar_ptr ;
wire [4:0] calc_cnt ;
wire [4:0] avg_cnt ;
wire [4:0] wr_idx_r ;
wire [29:0] calc_result_r ;
wire [35:0] accumulator ;
wire [28:0] meas_val_p ;
wire [28:0] meas_val_n ;
wire [35:6] avg_rounded_r ;

SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_0 \clk_gate_shadow_weights_reg[0] ( 
    .CLK ( clk ) , .EN ( N1842 ) , .ENCLK ( net1660 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_33 \clk_gate_shadow_weights_reg[1] ( 
    .CLK ( clk ) , .EN ( N1841 ) , .ENCLK ( net1666 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_32 \clk_gate_shadow_weights_reg[2] ( 
    .CLK ( clk ) , .EN ( N1840 ) , .ENCLK ( net1671 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_31 \clk_gate_shadow_weights_reg[3] ( 
    .CLK ( clk ) , .EN ( N1839 ) , .ENCLK ( net1676 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_30 \clk_gate_shadow_weights_reg[4] ( 
    .CLK ( clk ) , .EN ( N1838 ) , .ENCLK ( net1681 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_29 \clk_gate_shadow_weights_reg[5] ( 
    .CLK ( clk ) , .EN ( N1837 ) , .ENCLK ( net1686 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_28 \clk_gate_shadow_weights_reg[6] ( 
    .CLK ( clk ) , .EN ( HFSNET_252 ) , .ENCLK ( net1691 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_27 \clk_gate_shadow_weights_reg[7] ( 
    .CLK ( clk ) , .EN ( N1835 ) , .ENCLK ( net1696 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_26 \clk_gate_shadow_weights_reg[8] ( 
    .CLK ( clk ) , .EN ( N1834 ) , .ENCLK ( net1701 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_25 \clk_gate_shadow_weights_reg[9] ( 
    .CLK ( clk ) , .EN ( N1833 ) , .ENCLK ( net1706 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_24 \clk_gate_shadow_weights_reg[10] ( 
    .CLK ( clk ) , .EN ( N1832 ) , .ENCLK ( net1711 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_23 \clk_gate_shadow_weights_reg[11] ( 
    .CLK ( clk ) , .EN ( N1831 ) , .ENCLK ( net1716 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_22 \clk_gate_shadow_weights_reg[12] ( 
    .CLK ( clk ) , .EN ( N1830 ) , .ENCLK ( net1721 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_21 \clk_gate_shadow_weights_reg[13] ( 
    .CLK ( clk ) , .EN ( HFSNET_269 ) , .ENCLK ( net1726 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_20 \clk_gate_shadow_weights_reg[14] ( 
    .CLK ( clk ) , .EN ( N1828 ) , .ENCLK ( net1731 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_19 \clk_gate_shadow_weights_reg[15] ( 
    .CLK ( clk ) , .EN ( N1827 ) , .ENCLK ( net1736 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_18 \clk_gate_shadow_weights_reg[16] ( 
    .CLK ( clk ) , .EN ( HFSNET_250 ) , .ENCLK ( net1741 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_17 \clk_gate_shadow_weights_reg[17] ( 
    .CLK ( clk ) , .EN ( N1825 ) , .ENCLK ( net1746 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_16 \clk_gate_shadow_weights_reg[18] ( 
    .CLK ( ZCTSNET_412 ) , .EN ( N1824 ) , .ENCLK ( net1751 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_411 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_15 \clk_gate_shadow_weights_reg[19] ( 
    .CLK ( clk ) , .EN ( N1823 ) , .ENCLK ( net1756 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_14 clk_gate_calib_done_reg ( 
    .CLK ( clk ) , .EN ( N1485 ) , .ENCLK ( net1761 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_13 clk_gate_target_bit_reg ( 
    .CLK ( clk ) , .EN ( N1488 ) , .ENCLK ( net1766 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_411 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_12 clk_gate_avg_cnt_reg ( 
    .CLK ( ZCTSNET_411 ) , .EN ( N1536 ) , .ENCLK ( net1771 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_11 clk_gate_accumulator_reg ( 
    .CLK ( ZCTSNET_411 ) , .EN ( N1536 ) , .ENCLK ( net1776 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_10 clk_gate_sar_ptr_reg ( 
    .CLK ( clk ) , .EN ( N1602 ) , .ENCLK ( net1781 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_9 clk_gate_wait_cnt_reg ( 
    .CLK ( clk ) , .EN ( N1608 ) , .ENCLK ( net1786 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_8 clk_gate_w_wr_addr_reg ( 
    .CLK ( clk ) , .EN ( N1822 ) , .ENCLK ( net1791 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_7 clk_gate_w_wr_data_reg ( 
    .CLK ( clk ) , .EN ( N1822 ) , .ENCLK ( net1796 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_412 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_6 clk_gate_meas_val_p_reg ( 
    .CLK ( clk ) , .EN ( N1692 ) , .ENCLK ( net1801 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_2 ( ZCTSNET_411 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_5 clk_gate_meas_val_n_reg ( 
    .CLK ( clk ) , .EN ( N1723 ) , .ENCLK ( net1806 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_2 ( ZCTSNET_411 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_4 clk_gate_calc_cnt_reg ( 
    .CLK ( clk ) , .EN ( N1614 ) , .ENCLK ( net1811 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_3 clk_gate_avg_rounded_r_reg ( 
    .CLK ( ZCTSNET_408 ) , .EN ( N1754 ) , .ENCLK ( net1816 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_411 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_2 clk_gate_avg_rounded_r_reg_0 ( 
    .CLK ( ZCTSNET_408 ) , .EN ( N1754 ) , .ENCLK ( net1821 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_411 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_1 clk_gate_calc_result_r_reg ( 
    .CLK ( ZCTSNET_408 ) , .EN ( N1791 ) , .ENCLK ( net1826 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_411 ) ) ;
DFFSX1 comp_out_rr_reg ( .D ( n2233 ) , .CK ( clk ) , .SN ( HFSNET_380 ) , 
    .QN ( comp_out_rr ) ) ;
DFFSX1 \state_reg[3] ( .D ( n822 ) , .CK ( clk ) , .SN ( HFSNET_381 ) , 
    .Q ( n2172 ) , .QN ( state[3] ) ) ;
DFFSXL \accumulator_reg[19] ( .D ( n945 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[19] ) ) ;
DFFSXL \accumulator_reg[9] ( .D ( n954 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[9] ) ) ;
DFFSX1 \accumulator_reg[5] ( .D ( n817 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_352 ) , .QN ( accumulator[5] ) ) ;
DFFSXL \accumulator_reg[4] ( .D ( n958 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_352 ) , .QN ( accumulator[4] ) ) ;
DFFSXL \accumulator_reg[3] ( .D ( n959 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_352 ) , .QN ( accumulator[3] ) ) ;
DFFSXL \accumulator_reg[2] ( .D ( n960 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_353 ) , .QN ( accumulator[2] ) ) ;
DFFSXL \avg_cnt_reg[3] ( .D ( n964 ) , .CK ( net1771 ) , .SN ( HFSNET_354 ) , 
    .QN ( avg_cnt[3] ) ) ;
DFFSXL \avg_cnt_reg[2] ( .D ( n965 ) , .CK ( net1771 ) , .SN ( HFSNET_354 ) , 
    .QN ( avg_cnt[2] ) ) ;
DFFSXL \avg_cnt_reg[1] ( .D ( n966 ) , .CK ( net1771 ) , .SN ( HFSNET_354 ) , 
    .QN ( avg_cnt[1] ) ) ;
DFFSXL \avg_cnt_reg[0] ( .D ( n967 ) , .CK ( net1771 ) , .SN ( HFSNET_354 ) , 
    .QN ( avg_cnt[0] ) ) ;
DFFSXL \avg_rounded_r_reg[17] ( .D ( n878 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[17] ) ) ;
DFFSXL \calc_result_r_reg[11] ( .D ( n848 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[11] ) ) ;
DFFSXL \shadow_weights_reg[19][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_397 ) , .SN ( HFSNET_359 ) , 
    .QN ( \shadow_weights[19][11] ) ) ;
DFFSXL \avg_rounded_r_reg[16] ( .D ( n879 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[16] ) ) ;
DFFSXL \calc_result_r_reg[10] ( .D ( n849 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_355 ) , .QN ( calc_result_r[10] ) ) ;
DFFSXL \shadow_weights_reg[19][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][10] ) ) ;
DFFSXL \avg_rounded_r_reg[15] ( .D ( n880 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[15] ) ) ;
DFFSXL \shadow_weights_reg[19][9] ( .D ( n69 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][9] ) ) ;
DFFSXL \avg_rounded_r_reg[14] ( .D ( n881 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[14] ) ) ;
DFFSXL \shadow_weights_reg[19][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][8] ) ) ;
DFFSXL \calc_result_r_reg[7] ( .D ( n852 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_354 ) , .QN ( calc_result_r[7] ) ) ;
DFFSXL \shadow_weights_reg[19][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][7] ) ) ;
DFFSXL \avg_rounded_r_reg[12] ( .D ( HFSNET_7 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[12] ) ) ;
DFFSXL \calc_result_r_reg[6] ( .D ( n853 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_354 ) , .QN ( calc_result_r[6] ) ) ;
DFFSXL \shadow_weights_reg[19][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[19][6] ) ) ;
DFFSXL \avg_rounded_r_reg[11] ( .D ( HFSNET_8 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[11] ) ) ;
DFFSXL \calc_result_r_reg[5] ( .D ( n854 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_355 ) , .QN ( calc_result_r[5] ) ) ;
DFFSXL \shadow_weights_reg[19][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[19][5] ) ) ;
DFFSXL \avg_rounded_r_reg[10] ( .D ( n885 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[10] ) ) ;
DFFSXL \calc_result_r_reg[4] ( .D ( n855 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[4] ) ) ;
DFFSXL \shadow_weights_reg[19][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][4] ) ) ;
DFFSXL \avg_rounded_r_reg[9] ( .D ( n886 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[9] ) ) ;
DFFSXL \calc_result_r_reg[3] ( .D ( n856 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_355 ) , .QN ( calc_result_r[3] ) ) ;
DFFSXL \shadow_weights_reg[19][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][3] ) ) ;
DFFSXL \calc_result_r_reg[2] ( .D ( n857 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_355 ) , .QN ( calc_result_r[2] ) ) ;
DFFSXL \shadow_weights_reg[19][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][2] ) ) ;
DFFSXL \avg_rounded_r_reg[7] ( .D ( n888 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[7] ) ) ;
DFFSXL \calc_result_r_reg[1] ( .D ( n858 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[1] ) ) ;
DFFSXL \shadow_weights_reg[19][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][1] ) ) ;
DFFSXL \avg_rounded_r_reg[6] ( .D ( HFSNET_3 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[6] ) ) ;
DFFSXL \calc_result_r_reg[0] ( .D ( n859 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_354 ) , .QN ( calc_result_r[0] ) ) ;
DFFSXL \shadow_weights_reg[19][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][0] ) ) ;
DFFSXL \shadow_weights_reg[2][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_399 ) , .SN ( HFSNET_357 ) , 
    .QN ( \shadow_weights[2][11] ) ) ;
DFFSXL \shadow_weights_reg[2][9] ( .D ( n69 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[2][9] ) ) ;
DFFSXL \shadow_weights_reg[2][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[2][8] ) ) ;
DFFSXL \shadow_weights_reg[2][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[2][7] ) ) ;
DFFSXL \shadow_weights_reg[2][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[2][6] ) ) ;
DFFSXL \shadow_weights_reg[2][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[2][5] ) ) ;
DFFSXL \shadow_weights_reg[2][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[2][3] ) ) ;
DFFSXL \shadow_weights_reg[2][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[2][2] ) ) ;
DFFSXL \shadow_weights_reg[2][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[2][1] ) ) ;
DFFSXL \shadow_weights_reg[2][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[2][0] ) ) ;
DFFSXL \shadow_weights_reg[3][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[3][10] ) ) ;
DFFSXL \shadow_weights_reg[3][9] ( .D ( n69 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[3][9] ) ) ;
DFFSXL \shadow_weights_reg[3][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[3][8] ) ) ;
DFFSXL \shadow_weights_reg[3][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[3][7] ) ) ;
DFFSXL \shadow_weights_reg[3][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[3][6] ) ) ;
DFFSXL \shadow_weights_reg[3][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[3][5] ) ) ;
DFFSXL \shadow_weights_reg[3][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[3][4] ) ) ;
DFFSXL \shadow_weights_reg[3][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[3][3] ) ) ;
DFFSXL \shadow_weights_reg[3][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[3][2] ) ) ;
DFFSXL \shadow_weights_reg[3][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[3][1] ) ) ;
DFFSXL \shadow_weights_reg[6][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_403 ) , .SN ( HFSNET_361 ) , 
    .QN ( \shadow_weights[6][11] ) ) ;
DFFSXL \shadow_weights_reg[6][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[6][10] ) ) ;
DFFSXL \shadow_weights_reg[6][9] ( .D ( n69 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[6][9] ) ) ;
DFFSXL \shadow_weights_reg[6][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][8] ) ) ;
DFFSXL \shadow_weights_reg[6][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][7] ) ) ;
DFFSXL \shadow_weights_reg[6][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][6] ) ) ;
DFFSXL \shadow_weights_reg[6][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][5] ) ) ;
DFFSXL \shadow_weights_reg[6][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][4] ) ) ;
DFFSXL \shadow_weights_reg[6][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][3] ) ) ;
DFFSXL \shadow_weights_reg[6][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][2] ) ) ;
DFFSXL \shadow_weights_reg[6][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][1] ) ) ;
DFFSXL \shadow_weights_reg[6][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][0] ) ) ;
DFFSXL \shadow_weights_reg[7][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_404 ) , .SN ( HFSNET_375 ) , 
    .QN ( \shadow_weights[7][11] ) ) ;
DFFSXL \shadow_weights_reg[7][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[7][10] ) ) ;
DFFSXL \shadow_weights_reg[7][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[7][8] ) ) ;
DFFSXL \shadow_weights_reg[7][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[7][7] ) ) ;
DFFSXL \shadow_weights_reg[7][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[7][6] ) ) ;
DFFSXL \shadow_weights_reg[7][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[7][5] ) ) ;
DFFSXL \shadow_weights_reg[7][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[7][4] ) ) ;
DFFSXL \shadow_weights_reg[7][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[7][3] ) ) ;
DFFSXL \shadow_weights_reg[7][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[7][2] ) ) ;
DFFSXL \shadow_weights_reg[7][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[7][1] ) ) ;
DFFSXL \shadow_weights_reg[7][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[7][0] ) ) ;
DFFSXL \shadow_weights_reg[10][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_388 ) , .SN ( HFSNET_369 ) , 
    .QN ( \shadow_weights[10][11] ) ) ;
DFFSXL \shadow_weights_reg[10][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[10][10] ) ) ;
DFFSXL \shadow_weights_reg[10][9] ( .D ( n69 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[10][9] ) ) ;
DFFSXL \shadow_weights_reg[10][8] ( .D ( n70 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[10][8] ) ) ;
DFFSXL \shadow_weights_reg[10][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[10][7] ) ) ;
DFFSXL \shadow_weights_reg[10][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[10][5] ) ) ;
DFFSXL \shadow_weights_reg[10][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[10][4] ) ) ;
DFFSXL \shadow_weights_reg[10][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[10][3] ) ) ;
DFFSXL \shadow_weights_reg[10][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[10][2] ) ) ;
DFFSXL \shadow_weights_reg[10][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[10][1] ) ) ;
DFFSXL \shadow_weights_reg[10][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[10][0] ) ) ;
DFFSXL \shadow_weights_reg[14][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_392 ) , .SN ( HFSNET_377 ) , 
    .QN ( \shadow_weights[14][11] ) ) ;
DFFSXL \shadow_weights_reg[14][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][10] ) ) ;
DFFSXL \shadow_weights_reg[14][9] ( .D ( n69 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][9] ) ) ;
DFFSXL \shadow_weights_reg[14][8] ( .D ( n70 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][8] ) ) ;
DFFSXL \shadow_weights_reg[14][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[14][7] ) ) ;
DFFSXL \shadow_weights_reg[14][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][6] ) ) ;
DFFSXL \shadow_weights_reg[14][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][5] ) ) ;
DFFSXL \shadow_weights_reg[14][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[14][4] ) ) ;
DFFSXL \shadow_weights_reg[14][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[14][2] ) ) ;
DFFSXL \shadow_weights_reg[14][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][1] ) ) ;
DFFSXL \shadow_weights_reg[14][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][0] ) ) ;
DFFSXL \shadow_weights_reg[15][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_393 ) , .SN ( HFSNET_361 ) , 
    .QN ( \shadow_weights[15][11] ) ) ;
DFFSXL \shadow_weights_reg[15][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[15][10] ) ) ;
DFFSXL \shadow_weights_reg[15][9] ( .D ( n69 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[15][9] ) ) ;
DFFSXL \shadow_weights_reg[15][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[15][8] ) ) ;
DFFSXL \shadow_weights_reg[15][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[15][6] ) ) ;
DFFSXL \shadow_weights_reg[15][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[15][5] ) ) ;
DFFSXL \shadow_weights_reg[15][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[15][4] ) ) ;
DFFSXL \shadow_weights_reg[15][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[15][3] ) ) ;
DFFSXL \shadow_weights_reg[15][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[15][2] ) ) ;
DFFSXL \shadow_weights_reg[15][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[15][1] ) ) ;
DFFSXL \shadow_weights_reg[15][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[15][0] ) ) ;
DFFSXL \shadow_weights_reg[0][10] ( .D ( HFSNET_301 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[0][10] ) ) ;
DFFSXL \shadow_weights_reg[0][9] ( .D ( n69 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[0][9] ) ) ;
DFFSXL \shadow_weights_reg[0][7] ( .D ( HFSNET_341 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[0][7] ) ) ;
DFFSXL \shadow_weights_reg[0][6] ( .D ( HFSNET_339 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][6] ) ) ;
DFFSXL \shadow_weights_reg[0][5] ( .D ( HFSNET_337 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[0][5] ) ) ;
DFFSXL \shadow_weights_reg[0][4] ( .D ( HFSNET_336 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][4] ) ) ;
DFFSXL \shadow_weights_reg[0][3] ( .D ( HFSNET_332 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[0][3] ) ) ;
DFFSXL \shadow_weights_reg[0][2] ( .D ( HFSNET_327 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][2] ) ) ;
DFFSXL \shadow_weights_reg[0][1] ( .D ( HFSNET_317 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[0][1] ) ) ;
DFFSXL \shadow_weights_reg[0][0] ( .D ( HFSNET_311 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][0] ) ) ;
DFFSXL \shadow_weights_reg[5][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_402 ) , .SN ( HFSNET_377 ) , 
    .QN ( \shadow_weights[5][11] ) ) ;
DFFSXL \shadow_weights_reg[5][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[5][10] ) ) ;
DFFSXL \shadow_weights_reg[5][9] ( .D ( n69 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[5][9] ) ) ;
DFFSXL \shadow_weights_reg[5][8] ( .D ( n70 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[5][8] ) ) ;
DFFSXL \shadow_weights_reg[5][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[5][6] ) ) ;
DFFSXL \shadow_weights_reg[5][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[5][5] ) ) ;
DFFSXL \shadow_weights_reg[5][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[5][4] ) ) ;
DFFSXL \shadow_weights_reg[5][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[5][3] ) ) ;
DFFSXL \shadow_weights_reg[5][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[5][2] ) ) ;
DFFSXL \shadow_weights_reg[5][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[5][1] ) ) ;
DFFSXL \shadow_weights_reg[5][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[5][0] ) ) ;
DFFSXL \shadow_weights_reg[8][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( net1701 ) , .SN ( HFSNET_360 ) , .QN ( \shadow_weights[8][11] ) ) ;
DFFSXL \shadow_weights_reg[8][10] ( .D ( HFSNET_301 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[8][10] ) ) ;
DFFSXL \shadow_weights_reg[8][9] ( .D ( n69 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[8][9] ) ) ;
DFFSXL \shadow_weights_reg[8][8] ( .D ( n70 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[8][8] ) ) ;
DFFSXL \shadow_weights_reg[8][7] ( .D ( HFSNET_341 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[8][7] ) ) ;
DFFSXL \shadow_weights_reg[8][6] ( .D ( HFSNET_339 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[8][6] ) ) ;
DFFSXL \shadow_weights_reg[8][5] ( .D ( HFSNET_337 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[8][5] ) ) ;
DFFSXL \shadow_weights_reg[8][3] ( .D ( HFSNET_332 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[8][3] ) ) ;
DFFSXL \shadow_weights_reg[8][2] ( .D ( HFSNET_327 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[8][2] ) ) ;
DFFSXL \shadow_weights_reg[8][1] ( .D ( HFSNET_317 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[8][1] ) ) ;
DFFSXL \shadow_weights_reg[8][0] ( .D ( HFSNET_311 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[8][0] ) ) ;
DFFSXL \shadow_weights_reg[12][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_390 ) , .SN ( HFSNET_378 ) , 
    .QN ( \shadow_weights[12][11] ) ) ;
DFFSX1 \shadow_weights_reg[12][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[12][10] ) ) ;
DFFSXL \shadow_weights_reg[12][9] ( .D ( n69 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[12][9] ) ) ;
DFFSXL \shadow_weights_reg[12][8] ( .D ( n70 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[12][8] ) ) ;
DFFSXL \shadow_weights_reg[12][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[12][7] ) ) ;
DFFSXL \shadow_weights_reg[12][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[12][6] ) ) ;
DFFSXL \shadow_weights_reg[12][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[12][5] ) ) ;
DFFSXL \shadow_weights_reg[12][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[12][4] ) ) ;
DFFSXL \shadow_weights_reg[12][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[12][3] ) ) ;
DFFSXL \shadow_weights_reg[12][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[12][2] ) ) ;
DFFSXL \shadow_weights_reg[12][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[12][0] ) ) ;
DFFSXL \shadow_weights_reg[13][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_391 ) , .SN ( HFSNET_368 ) , 
    .QN ( \shadow_weights[13][11] ) ) ;
DFFSXL \shadow_weights_reg[13][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[13][10] ) ) ;
DFFSXL \shadow_weights_reg[13][9] ( .D ( n69 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[13][9] ) ) ;
DFFSXL \shadow_weights_reg[13][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[13][8] ) ) ;
DFFSXL \shadow_weights_reg[13][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[13][7] ) ) ;
DFFSXL \shadow_weights_reg[13][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[13][6] ) ) ;
DFFSXL \shadow_weights_reg[13][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[13][5] ) ) ;
DFFSXL \shadow_weights_reg[13][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[13][4] ) ) ;
DFFSXL \shadow_weights_reg[13][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[13][3] ) ) ;
DFFSXL \shadow_weights_reg[13][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[13][2] ) ) ;
DFFSXL \shadow_weights_reg[13][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[13][1] ) ) ;
DFFSXL \shadow_weights_reg[13][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[13][0] ) ) ;
DFFSXL \shadow_weights_reg[1][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_398 ) , .SN ( HFSNET_374 ) , 
    .QN ( \shadow_weights[1][11] ) ) ;
DFFSXL \shadow_weights_reg[1][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[1][8] ) ) ;
DFFSXL \shadow_weights_reg[1][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[1][7] ) ) ;
DFFSXL \shadow_weights_reg[1][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[1][6] ) ) ;
DFFSXL \shadow_weights_reg[1][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[1][5] ) ) ;
DFFSXL \shadow_weights_reg[1][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[1][4] ) ) ;
DFFSXL \shadow_weights_reg[1][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[1][3] ) ) ;
DFFSXL \shadow_weights_reg[1][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[1][2] ) ) ;
DFFSXL \shadow_weights_reg[1][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[1][1] ) ) ;
DFFSXL \shadow_weights_reg[1][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[1][0] ) ) ;
DFFSXL \shadow_weights_reg[9][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_406 ) , .SN ( HFSNET_377 ) , 
    .QN ( \shadow_weights[9][11] ) ) ;
DFFSXL \shadow_weights_reg[9][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[9][10] ) ) ;
DFFSXL \shadow_weights_reg[9][9] ( .D ( n69 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[9][9] ) ) ;
DFFSXL \shadow_weights_reg[9][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[9][8] ) ) ;
DFFSXL \shadow_weights_reg[9][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[9][7] ) ) ;
DFFSXL \shadow_weights_reg[9][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[9][5] ) ) ;
DFFSXL \shadow_weights_reg[9][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[9][4] ) ) ;
DFFSXL \shadow_weights_reg[9][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[9][3] ) ) ;
DFFSXL \shadow_weights_reg[9][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[9][2] ) ) ;
DFFSXL \shadow_weights_reg[9][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[9][1] ) ) ;
DFFSXL \shadow_weights_reg[9][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[9][0] ) ) ;
DFFSXL \avg_rounded_r_reg[20] ( .D ( n875 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[20] ) ) ;
DFFSXL \calc_result_r_reg[14] ( .D ( n845 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_354 ) , .QN ( calc_result_r[14] ) ) ;
DFFSXL \shadow_weights_reg[19][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][14] ) ) ;
DFFSXL \shadow_weights_reg[15][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[15][14] ) ) ;
DFFSXL \shadow_weights_reg[14][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][14] ) ) ;
DFFSXL \shadow_weights_reg[13][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[13][14] ) ) ;
DFFSXL \shadow_weights_reg[12][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[12][14] ) ) ;
DFFSXL \shadow_weights_reg[10][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[10][14] ) ) ;
DFFSXL \shadow_weights_reg[8][14] ( .D ( HFSNET_312 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[8][14] ) ) ;
DFFSXL \shadow_weights_reg[7][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[7][14] ) ) ;
DFFSXL \shadow_weights_reg[6][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[6][14] ) ) ;
DFFSXL \shadow_weights_reg[5][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[5][14] ) ) ;
DFFSXL \shadow_weights_reg[3][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[3][14] ) ) ;
DFFSXL \shadow_weights_reg[2][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[2][14] ) ) ;
DFFSXL \shadow_weights_reg[1][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[1][14] ) ) ;
DFFSXL \shadow_weights_reg[0][14] ( .D ( HFSNET_312 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][14] ) ) ;
DFFSXL \avg_rounded_r_reg[19] ( .D ( n876 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[19] ) ) ;
DFFSXL \calc_result_r_reg[13] ( .D ( n846 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_366 ) , .QN ( calc_result_r[13] ) ) ;
DFFSXL \shadow_weights_reg[19][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_397 ) , .SN ( HFSNET_359 ) , 
    .QN ( \shadow_weights[19][13] ) ) ;
DFFSXL \shadow_weights_reg[15][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_393 ) , .SN ( HFSNET_361 ) , 
    .QN ( \shadow_weights[15][13] ) ) ;
DFFSXL \shadow_weights_reg[14][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_392 ) , .SN ( HFSNET_374 ) , 
    .QN ( \shadow_weights[14][13] ) ) ;
DFFSXL \shadow_weights_reg[13][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_391 ) , .SN ( HFSNET_361 ) , 
    .QN ( \shadow_weights[13][13] ) ) ;
DFFSXL \shadow_weights_reg[10][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_388 ) , .SN ( HFSNET_360 ) , 
    .QN ( \shadow_weights[10][13] ) ) ;
DFFSXL \shadow_weights_reg[9][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_406 ) , .SN ( HFSNET_375 ) , 
    .QN ( \shadow_weights[9][13] ) ) ;
DFFSXL \shadow_weights_reg[8][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( net1701 ) , .SN ( HFSNET_360 ) , .QN ( \shadow_weights[8][13] ) ) ;
DFFSXL \shadow_weights_reg[7][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_404 ) , .SN ( HFSNET_375 ) , 
    .QN ( \shadow_weights[7][13] ) ) ;
DFFSXL \shadow_weights_reg[6][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_403 ) , .SN ( HFSNET_357 ) , 
    .QN ( \shadow_weights[6][13] ) ) ;
DFFSXL \shadow_weights_reg[3][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_400 ) , .SN ( HFSNET_358 ) , 
    .QN ( \shadow_weights[3][13] ) ) ;
DFFSXL \shadow_weights_reg[2][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_399 ) , .SN ( HFSNET_357 ) , 
    .QN ( \shadow_weights[2][13] ) ) ;
DFFSXL \shadow_weights_reg[1][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_398 ) , .SN ( HFSNET_358 ) , 
    .QN ( \shadow_weights[1][13] ) ) ;
DFFSXL \shadow_weights_reg[0][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( net1660 ) , .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][13] ) ) ;
DFFSXL \avg_rounded_r_reg[18] ( .D ( HFSNET_2 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[18] ) ) ;
DFFSXL \calc_result_r_reg[12] ( .D ( n847 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_366 ) , .QN ( calc_result_r[12] ) ) ;
DFFSXL \shadow_weights_reg[19][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_397 ) , .SN ( HFSNET_356 ) , 
    .QN ( \shadow_weights[19][12] ) ) ;
DFFSXL \shadow_weights_reg[14][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_392 ) , .SN ( HFSNET_379 ) , 
    .QN ( \shadow_weights[14][12] ) ) ;
DFFSXL \shadow_weights_reg[13][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_391 ) , .SN ( HFSNET_357 ) , 
    .QN ( \shadow_weights[13][12] ) ) ;
DFFSXL \shadow_weights_reg[10][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_388 ) , .SN ( HFSNET_356 ) , 
    .QN ( \shadow_weights[10][12] ) ) ;
DFFSXL \shadow_weights_reg[9][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_406 ) , .SN ( HFSNET_374 ) , 
    .QN ( \shadow_weights[9][12] ) ) ;
DFFSXL \shadow_weights_reg[8][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( net1701 ) , .SN ( HFSNET_356 ) , .QN ( \shadow_weights[8][12] ) ) ;
DFFSXL \shadow_weights_reg[7][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_404 ) , .SN ( HFSNET_358 ) , 
    .QN ( \shadow_weights[7][12] ) ) ;
DFFSXL \shadow_weights_reg[6][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_403 ) , .SN ( HFSNET_358 ) , 
    .QN ( \shadow_weights[6][12] ) ) ;
DFFSXL \shadow_weights_reg[5][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_402 ) , .SN ( HFSNET_379 ) , 
    .QN ( \shadow_weights[5][12] ) ) ;
DFFSXL \shadow_weights_reg[3][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_400 ) , .SN ( HFSNET_358 ) , 
    .QN ( \shadow_weights[3][12] ) ) ;
DFFSXL \shadow_weights_reg[2][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_399 ) , .SN ( HFSNET_357 ) , 
    .QN ( \shadow_weights[2][12] ) ) ;
DFFSXL \shadow_weights_reg[1][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_398 ) , .SN ( HFSNET_358 ) , 
    .QN ( \shadow_weights[1][12] ) ) ;
DFFSXL \shadow_weights_reg[0][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( net1660 ) , .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][12] ) ) ;
DFFSX1 \wait_cnt_reg[0] ( .D ( n927 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_379 ) , .QN ( wait_cnt[0] ) ) ;
DFFSX1 \wait_cnt_reg[4] ( .D ( n790 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_379 ) , .QN ( wait_cnt[4] ) ) ;
DFFSX1 \wait_cnt_reg[1] ( .D ( n926 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .QN ( wait_cnt[1] ) ) ;
DFFSX1 \wait_cnt_reg[3] ( .D ( n924 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_379 ) , .QN ( wait_cnt[3] ) ) ;
DFFSXL \avg_rounded_r_reg[35] ( .D ( n860 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[35] ) ) ;
DFFSXL \calc_result_r_reg[29] ( .D ( n830 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[29] ) ) ;
DFFSXL \shadow_weights_reg[19][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[19][29] ) ) ;
DFFSXL \shadow_weights_reg[14][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[14][29] ) ) ;
DFFSXL \shadow_weights_reg[13][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[13][29] ) ) ;
DFFSXL \shadow_weights_reg[12][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[12][29] ) ) ;
DFFSXL \shadow_weights_reg[10][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[10][29] ) ) ;
DFFSXL \shadow_weights_reg[9][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[9][29] ) ) ;
DFFSXL \shadow_weights_reg[8][29] ( .D ( HFSNET_323 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[8][29] ) ) ;
DFFSXL \shadow_weights_reg[7][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[7][29] ) ) ;
DFFSXL \shadow_weights_reg[6][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[6][29] ) ) ;
DFFSXL \shadow_weights_reg[5][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[5][29] ) ) ;
DFFSXL \shadow_weights_reg[3][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[3][29] ) ) ;
DFFSXL \shadow_weights_reg[1][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[1][29] ) ) ;
DFFSXL \shadow_weights_reg[0][29] ( .D ( HFSNET_323 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[0][29] ) ) ;
DFFSXL \avg_rounded_r_reg[34] ( .D ( n861 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[34] ) ) ;
DFFSXL \calc_result_r_reg[28] ( .D ( n831 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_365 ) , .QN ( calc_result_r[28] ) ) ;
DFFSX1 \shadow_weights_reg[19][28] ( .D ( n2306 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[19][28] ) ) ;
DFFSX1 \shadow_weights_reg[17][28] ( .D ( n2306 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[17][28] ) ) ;
DFFSXL \shadow_weights_reg[14][28] ( .D ( n2306 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[14][28] ) ) ;
DFFSXL \shadow_weights_reg[13][28] ( .D ( n2306 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[13][28] ) ) ;
DFFSX1 \shadow_weights_reg[12][28] ( .D ( n2306 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[12][28] ) ) ;
DFFSXL \shadow_weights_reg[10][28] ( .D ( n2306 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[10][28] ) ) ;
DFFSXL \shadow_weights_reg[9][28] ( .D ( n2306 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[9][28] ) ) ;
DFFSXL \shadow_weights_reg[8][28] ( .D ( n2306 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[8][28] ) ) ;
DFFSXL \shadow_weights_reg[7][28] ( .D ( n2306 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[7][28] ) ) ;
DFFSXL \shadow_weights_reg[6][28] ( .D ( n2306 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[6][28] ) ) ;
DFFSXL \shadow_weights_reg[3][28] ( .D ( n2306 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[3][28] ) ) ;
DFFSXL \shadow_weights_reg[2][28] ( .D ( n2306 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[2][28] ) ) ;
DFFSXL \shadow_weights_reg[1][28] ( .D ( n2306 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[1][28] ) ) ;
DFFSXL \shadow_weights_reg[0][28] ( .D ( n2306 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[0][28] ) ) ;
DFFSXL \avg_rounded_r_reg[33] ( .D ( n862 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[33] ) ) ;
DFFSXL \calc_result_r_reg[27] ( .D ( n832 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_366 ) , .QN ( calc_result_r[27] ) ) ;
DFFSXL \shadow_weights_reg[19][27] ( .D ( n2305 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[19][27] ) ) ;
DFFSXL \shadow_weights_reg[17][27] ( .D ( n2305 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[17][27] ) ) ;
DFFSXL \shadow_weights_reg[14][27] ( .D ( n2305 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[14][27] ) ) ;
DFFSXL \shadow_weights_reg[13][27] ( .D ( n2305 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[13][27] ) ) ;
DFFSXL \shadow_weights_reg[12][27] ( .D ( n2305 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[12][27] ) ) ;
DFFSXL \shadow_weights_reg[10][27] ( .D ( n2305 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_380 ) , .QN ( \shadow_weights[10][27] ) ) ;
DFFSXL \shadow_weights_reg[9][27] ( .D ( n2305 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[9][27] ) ) ;
DFFSXL \shadow_weights_reg[8][27] ( .D ( n2305 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[8][27] ) ) ;
DFFSXL \shadow_weights_reg[6][27] ( .D ( n2305 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[6][27] ) ) ;
DFFSXL \shadow_weights_reg[5][27] ( .D ( n2305 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[5][27] ) ) ;
DFFSXL \shadow_weights_reg[3][27] ( .D ( n2305 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[3][27] ) ) ;
DFFSXL \shadow_weights_reg[2][27] ( .D ( n2305 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[2][27] ) ) ;
DFFSXL \shadow_weights_reg[1][27] ( .D ( n2305 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[1][27] ) ) ;
DFFSXL \shadow_weights_reg[0][27] ( .D ( n2305 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[0][27] ) ) ;
DFFSXL \avg_rounded_r_reg[32] ( .D ( n863 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[32] ) ) ;
DFFSXL \shadow_weights_reg[19][26] ( .D ( n71 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[19][26] ) ) ;
DFFSXL \shadow_weights_reg[17][26] ( .D ( n71 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[17][26] ) ) ;
DFFSXL \shadow_weights_reg[14][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[14][26] ) ) ;
DFFSXL \shadow_weights_reg[13][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[13][26] ) ) ;
DFFSXL \shadow_weights_reg[12][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[12][26] ) ) ;
DFFSXL \shadow_weights_reg[10][26] ( .D ( n71 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[10][26] ) ) ;
DFFSXL \shadow_weights_reg[9][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[9][26] ) ) ;
DFFSXL \shadow_weights_reg[7][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[7][26] ) ) ;
DFFSXL \shadow_weights_reg[6][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[6][26] ) ) ;
DFFSXL \shadow_weights_reg[5][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[5][26] ) ) ;
DFFSXL \shadow_weights_reg[3][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[3][26] ) ) ;
DFFSXL \shadow_weights_reg[2][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[2][26] ) ) ;
DFFSXL \shadow_weights_reg[1][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[1][26] ) ) ;
DFFSXL \shadow_weights_reg[0][26] ( .D ( HFSNET_299 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[0][26] ) ) ;
DFFSXL \avg_rounded_r_reg[31] ( .D ( n864 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[31] ) ) ;
DFFSXL \calc_result_r_reg[25] ( .D ( n834 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_366 ) , .QN ( calc_result_r[25] ) ) ;
DFFSXL \shadow_weights_reg[19][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[19][25] ) ) ;
DFFSX1 \shadow_weights_reg[17][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[17][25] ) ) ;
DFFSXL \shadow_weights_reg[14][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[14][25] ) ) ;
DFFSXL \shadow_weights_reg[13][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[13][25] ) ) ;
DFFSXL \shadow_weights_reg[12][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[12][25] ) ) ;
DFFSXL \shadow_weights_reg[9][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[9][25] ) ) ;
DFFSXL \shadow_weights_reg[8][25] ( .D ( HFSNET_322 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[8][25] ) ) ;
DFFSXL \shadow_weights_reg[7][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[7][25] ) ) ;
DFFSXL \shadow_weights_reg[6][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[6][25] ) ) ;
DFFSXL \shadow_weights_reg[5][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[5][25] ) ) ;
DFFSXL \shadow_weights_reg[3][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[3][25] ) ) ;
DFFSXL \shadow_weights_reg[2][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[2][25] ) ) ;
DFFSXL \shadow_weights_reg[1][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[1][25] ) ) ;
DFFSXL \shadow_weights_reg[0][25] ( .D ( HFSNET_322 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[0][25] ) ) ;
DFFSXL \avg_rounded_r_reg[30] ( .D ( n865 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[30] ) ) ;
DFFSXL \calc_result_r_reg[24] ( .D ( n835 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[24] ) ) ;
DFFSXL \shadow_weights_reg[19][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[19][24] ) ) ;
DFFSXL \shadow_weights_reg[17][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[17][24] ) ) ;
DFFSXL \shadow_weights_reg[14][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[14][24] ) ) ;
DFFSXL \shadow_weights_reg[12][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[12][24] ) ) ;
DFFSXL \shadow_weights_reg[10][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[10][24] ) ) ;
DFFSXL \shadow_weights_reg[9][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[9][24] ) ) ;
DFFSXL \shadow_weights_reg[8][24] ( .D ( HFSNET_321 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[8][24] ) ) ;
DFFSXL \shadow_weights_reg[7][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[7][24] ) ) ;
DFFSXL \shadow_weights_reg[6][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[6][24] ) ) ;
DFFSXL \shadow_weights_reg[5][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[5][24] ) ) ;
DFFSXL \shadow_weights_reg[3][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[3][24] ) ) ;
DFFSXL \shadow_weights_reg[2][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[2][24] ) ) ;
DFFSXL \shadow_weights_reg[1][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[1][24] ) ) ;
DFFSXL \shadow_weights_reg[0][24] ( .D ( HFSNET_321 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[0][24] ) ) ;
DFFSX1 \accumulator_reg[29] ( .D ( HFSNET_67 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .QN ( accumulator[29] ) ) ;
DFFSXL \avg_rounded_r_reg[29] ( .D ( n866 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_363 ) , .QN ( avg_rounded_r[29] ) ) ;
DFFSXL \calc_result_r_reg[23] ( .D ( n836 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[23] ) ) ;
DFFSXL \shadow_weights_reg[17][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[17][23] ) ) ;
DFFSXL \shadow_weights_reg[14][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[14][23] ) ) ;
DFFSXL \shadow_weights_reg[13][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[13][23] ) ) ;
DFFSXL \shadow_weights_reg[12][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[12][23] ) ) ;
DFFSXL \shadow_weights_reg[10][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[10][23] ) ) ;
DFFSXL \shadow_weights_reg[9][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[9][23] ) ) ;
DFFSXL \shadow_weights_reg[8][23] ( .D ( HFSNET_320 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[8][23] ) ) ;
DFFSXL \shadow_weights_reg[7][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[7][23] ) ) ;
DFFSXL \shadow_weights_reg[6][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[6][23] ) ) ;
DFFSXL \shadow_weights_reg[5][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[5][23] ) ) ;
DFFSXL \shadow_weights_reg[3][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[3][23] ) ) ;
DFFSXL \shadow_weights_reg[2][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[2][23] ) ) ;
DFFSXL \shadow_weights_reg[1][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[1][23] ) ) ;
DFFSXL \shadow_weights_reg[0][23] ( .D ( HFSNET_320 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[0][23] ) ) ;
DFFSXL \avg_rounded_r_reg[28] ( .D ( n867 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_363 ) , .QN ( avg_rounded_r[28] ) ) ;
DFFSXL \calc_result_r_reg[22] ( .D ( n837 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[22] ) ) ;
DFFSXL \shadow_weights_reg[19][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[19][22] ) ) ;
DFFSXL \shadow_weights_reg[17][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[17][22] ) ) ;
DFFSXL \shadow_weights_reg[14][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[14][22] ) ) ;
DFFSXL \shadow_weights_reg[13][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[13][22] ) ) ;
DFFSXL \shadow_weights_reg[12][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[12][22] ) ) ;
DFFSXL \shadow_weights_reg[10][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[10][22] ) ) ;
DFFSXL \shadow_weights_reg[9][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[9][22] ) ) ;
DFFSXL \shadow_weights_reg[8][22] ( .D ( HFSNET_319 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[8][22] ) ) ;
DFFSXL \shadow_weights_reg[7][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[7][22] ) ) ;
DFFSXL \shadow_weights_reg[6][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[6][22] ) ) ;
DFFSXL \shadow_weights_reg[5][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[5][22] ) ) ;
DFFSXL \shadow_weights_reg[3][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[3][22] ) ) ;
DFFSXL \shadow_weights_reg[1][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[1][22] ) ) ;
DFFSXL \shadow_weights_reg[0][22] ( .D ( HFSNET_319 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[0][22] ) ) ;
DFFSXL \accumulator_reg[27] ( .D ( HFSNET_69 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .QN ( accumulator[27] ) ) ;
DFFSXL \avg_rounded_r_reg[27] ( .D ( n868 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[27] ) ) ;
DFFSXL \calc_result_r_reg[21] ( .D ( n838 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_365 ) , .QN ( calc_result_r[21] ) ) ;
DFFSXL \shadow_weights_reg[19][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[19][21] ) ) ;
DFFSX1 \shadow_weights_reg[17][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_365 ) , .QN ( \shadow_weights[17][21] ) ) ;
DFFSXL \shadow_weights_reg[14][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[14][21] ) ) ;
DFFSXL \shadow_weights_reg[13][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[13][21] ) ) ;
DFFSXL \shadow_weights_reg[12][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[12][21] ) ) ;
DFFSXL \shadow_weights_reg[10][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[10][21] ) ) ;
DFFSXL \shadow_weights_reg[9][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[9][21] ) ) ;
DFFSXL \shadow_weights_reg[8][21] ( .D ( HFSNET_318 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[8][21] ) ) ;
DFFSXL \shadow_weights_reg[7][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[7][21] ) ) ;
DFFSXL \shadow_weights_reg[5][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[5][21] ) ) ;
DFFSXL \shadow_weights_reg[3][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[3][21] ) ) ;
DFFSXL \shadow_weights_reg[2][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[2][21] ) ) ;
DFFSXL \shadow_weights_reg[1][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[1][21] ) ) ;
DFFSXL \shadow_weights_reg[0][21] ( .D ( HFSNET_318 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[0][21] ) ) ;
DFFSXL \accumulator_reg[26] ( .D ( HFSNET_70 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .QN ( accumulator[26] ) ) ;
DFFSXL \avg_rounded_r_reg[26] ( .D ( n869 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[26] ) ) ;
DFFSXL \calc_result_r_reg[20] ( .D ( n839 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_366 ) , .QN ( calc_result_r[20] ) ) ;
DFFSXL \shadow_weights_reg[19][20] ( .D ( n2299 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[19][20] ) ) ;
DFFSXL \shadow_weights_reg[17][20] ( .D ( n2299 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[17][20] ) ) ;
DFFSXL \shadow_weights_reg[14][20] ( .D ( n2299 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[14][20] ) ) ;
DFFSXL \shadow_weights_reg[13][20] ( .D ( n2299 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[13][20] ) ) ;
DFFSXL \shadow_weights_reg[12][20] ( .D ( n2299 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[12][20] ) ) ;
DFFSXL \shadow_weights_reg[10][20] ( .D ( n2299 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[10][20] ) ) ;
DFFSXL \shadow_weights_reg[8][20] ( .D ( n2299 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[8][20] ) ) ;
DFFSXL \shadow_weights_reg[7][20] ( .D ( n2299 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[7][20] ) ) ;
DFFSXL \shadow_weights_reg[6][20] ( .D ( n2299 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[6][20] ) ) ;
DFFSXL \shadow_weights_reg[5][20] ( .D ( n2299 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[5][20] ) ) ;
DFFSXL \shadow_weights_reg[3][20] ( .D ( n2299 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[3][20] ) ) ;
DFFSXL \shadow_weights_reg[2][20] ( .D ( n2299 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[2][20] ) ) ;
DFFSXL \shadow_weights_reg[1][20] ( .D ( n2299 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[1][20] ) ) ;
DFFSXL \shadow_weights_reg[0][20] ( .D ( n2299 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[0][20] ) ) ;
DFFSXL \accumulator_reg[25] ( .D ( HFSNET_71 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .QN ( accumulator[25] ) ) ;
DFFSXL \avg_rounded_r_reg[25] ( .D ( n870 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[25] ) ) ;
DFFSX1 \calc_result_r_reg[19] ( .D ( n840 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_365 ) , .QN ( calc_result_r[19] ) ) ;
DFFSXL \shadow_weights_reg[19][19] ( .D ( n2298 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[19][19] ) ) ;
DFFSX1 \shadow_weights_reg[17][19] ( .D ( n2298 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[17][19] ) ) ;
DFFSXL \shadow_weights_reg[14][19] ( .D ( n2298 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[14][19] ) ) ;
DFFSXL \shadow_weights_reg[12][19] ( .D ( n2298 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[12][19] ) ) ;
DFFSXL \shadow_weights_reg[10][19] ( .D ( n2298 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[10][19] ) ) ;
DFFSXL \shadow_weights_reg[9][19] ( .D ( n2298 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[9][19] ) ) ;
DFFSXL \shadow_weights_reg[8][19] ( .D ( n2298 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[8][19] ) ) ;
DFFSXL \shadow_weights_reg[7][19] ( .D ( n2298 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[7][19] ) ) ;
DFFSXL \shadow_weights_reg[6][19] ( .D ( n2298 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[6][19] ) ) ;
DFFSXL \shadow_weights_reg[5][19] ( .D ( n2298 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[5][19] ) ) ;
DFFSXL \shadow_weights_reg[3][19] ( .D ( n2298 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[3][19] ) ) ;
DFFSXL \shadow_weights_reg[2][19] ( .D ( n2298 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[2][19] ) ) ;
DFFSXL \shadow_weights_reg[1][19] ( .D ( n2298 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[1][19] ) ) ;
DFFSXL \shadow_weights_reg[0][19] ( .D ( n2298 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[0][19] ) ) ;
DFFSXL \accumulator_reg[24] ( .D ( HFSNET_12 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_354 ) , .QN ( accumulator[24] ) ) ;
DFFSXL \avg_rounded_r_reg[24] ( .D ( n871 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[24] ) ) ;
DFFSXL \calc_result_r_reg[18] ( .D ( n841 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[18] ) ) ;
DFFSX1 \shadow_weights_reg[17][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[17][18] ) ) ;
DFFSXL \shadow_weights_reg[14][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][18] ) ) ;
DFFSXL \shadow_weights_reg[13][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[13][18] ) ) ;
DFFSXL \shadow_weights_reg[12][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[12][18] ) ) ;
DFFSXL \shadow_weights_reg[10][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[10][18] ) ) ;
DFFSXL \shadow_weights_reg[9][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[9][18] ) ) ;
DFFSXL \shadow_weights_reg[8][18] ( .D ( HFSNET_316 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[8][18] ) ) ;
DFFSXL \shadow_weights_reg[7][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[7][18] ) ) ;
DFFSXL \shadow_weights_reg[6][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[6][18] ) ) ;
DFFSXL \shadow_weights_reg[5][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[5][18] ) ) ;
DFFSXL \shadow_weights_reg[3][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[3][18] ) ) ;
DFFSX1 \shadow_weights_reg[2][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[2][18] ) ) ;
DFFSXL \shadow_weights_reg[1][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[1][18] ) ) ;
DFFSXL \shadow_weights_reg[0][18] ( .D ( HFSNET_316 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][18] ) ) ;
DFFSXL \avg_rounded_r_reg[23] ( .D ( n872 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[23] ) ) ;
DFFSXL \calc_result_r_reg[17] ( .D ( n842 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_355 ) , .QN ( calc_result_r[17] ) ) ;
DFFSXL \shadow_weights_reg[19][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[19][17] ) ) ;
DFFSXL \shadow_weights_reg[14][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[14][17] ) ) ;
DFFSXL \shadow_weights_reg[13][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[13][17] ) ) ;
DFFSXL \shadow_weights_reg[12][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[12][17] ) ) ;
DFFSXL \shadow_weights_reg[10][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[10][17] ) ) ;
DFFSXL \shadow_weights_reg[9][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[9][17] ) ) ;
DFFSXL \shadow_weights_reg[8][17] ( .D ( HFSNET_315 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[8][17] ) ) ;
DFFSXL \shadow_weights_reg[7][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[7][17] ) ) ;
DFFSXL \shadow_weights_reg[6][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[6][17] ) ) ;
DFFSXL \shadow_weights_reg[5][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[5][17] ) ) ;
DFFSXL \shadow_weights_reg[3][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[3][17] ) ) ;
DFFSXL \shadow_weights_reg[2][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[2][17] ) ) ;
DFFSXL \shadow_weights_reg[0][17] ( .D ( HFSNET_315 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[0][17] ) ) ;
DFFSXL \accumulator_reg[22] ( .D ( HFSNET_10 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_351 ) , .QN ( accumulator[22] ) ) ;
DFFSXL \avg_rounded_r_reg[22] ( .D ( n873 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_363 ) , .QN ( avg_rounded_r[22] ) ) ;
DFFSXL \calc_result_r_reg[16] ( .D ( n843 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .QN ( calc_result_r[16] ) ) ;
DFFSXL \shadow_weights_reg[19][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[19][16] ) ) ;
DFFSXL \shadow_weights_reg[14][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[14][16] ) ) ;
DFFSXL \shadow_weights_reg[13][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[13][16] ) ) ;
DFFSXL \shadow_weights_reg[12][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[12][16] ) ) ;
DFFSXL \shadow_weights_reg[10][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[10][16] ) ) ;
DFFSXL \shadow_weights_reg[9][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[9][16] ) ) ;
DFFSXL \shadow_weights_reg[8][16] ( .D ( HFSNET_314 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[8][16] ) ) ;
DFFSXL \shadow_weights_reg[7][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[7][16] ) ) ;
DFFSX1 \shadow_weights_reg[6][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[6][16] ) ) ;
DFFSXL \shadow_weights_reg[5][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[5][16] ) ) ;
DFFSXL \shadow_weights_reg[2][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[2][16] ) ) ;
DFFSXL \shadow_weights_reg[1][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[1][16] ) ) ;
DFFSXL \shadow_weights_reg[0][16] ( .D ( HFSNET_314 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[0][16] ) ) ;
DFFSX1 \accumulator_reg[21] ( .D ( HFSNET_9 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_354 ) , .QN ( accumulator[21] ) ) ;
DFFSXL \avg_rounded_r_reg[21] ( .D ( n874 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_365 ) , .QN ( avg_rounded_r[21] ) ) ;
DFFSXL \calc_result_r_reg[15] ( .D ( n844 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_365 ) , .QN ( calc_result_r[15] ) ) ;
DFFSXL \shadow_weights_reg[19][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[19][15] ) ) ;
DFFSXL \shadow_weights_reg[14][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[14][15] ) ) ;
DFFSXL \shadow_weights_reg[13][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[13][15] ) ) ;
DFFSXL \shadow_weights_reg[12][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[12][15] ) ) ;
DFFSXL \shadow_weights_reg[10][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[10][15] ) ) ;
DFFSXL \shadow_weights_reg[9][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[9][15] ) ) ;
DFFSXL \shadow_weights_reg[8][15] ( .D ( HFSNET_313 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[8][15] ) ) ;
DFFSXL \shadow_weights_reg[7][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[7][15] ) ) ;
DFFSXL \shadow_weights_reg[5][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[5][15] ) ) ;
DFFSXL \shadow_weights_reg[3][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[3][15] ) ) ;
DFFSXL \shadow_weights_reg[2][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[2][15] ) ) ;
DFFSXL \shadow_weights_reg[1][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[1][15] ) ) ;
DFFSXL \shadow_weights_reg[0][15] ( .D ( HFSNET_313 ) , .CK ( net1660 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[0][15] ) ) ;
DFFSX1 \sar_code_reg[0] ( .D ( n773 ) , .CK ( clk ) , .SN ( HFSNET_380 ) , 
    .Q ( n2185 ) , .QN ( protected_sar_code[0] ) ) ;
DFFSX1 \sar_code_reg[4] ( .D ( n769 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2190 ) , .QN ( protected_sar_code[4] ) ) ;
DFFSX1 \sar_code_reg[5] ( .D ( n768 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2191 ) , .QN ( protected_sar_code[5] ) ) ;
DFFSX1 \sar_code_reg[13] ( .D ( n760 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2188 ) , .QN ( protected_sar_code[13] ) ) ;
DFFSXL \sar_code_reg[17] ( .D ( n756 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .QN ( sar_code[17] ) ) ;
DFFSXL \sar_code_reg[18] ( .D ( n755 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .QN ( sar_code[18] ) ) ;
DFFSXL \temp_acc_reg[18] ( .D ( n2329 ) , .CK ( n2326 ) , .SN ( HFSNET_353 ) , 
    .Q ( n2205 ) , .QN ( temp_acc[18] ) ) ;
DFFSXL \temp_acc_reg[19] ( .D ( n2330 ) , .CK ( n2326 ) , .SN ( HFSNET_364 ) , 
    .Q ( n2203 ) , .QN ( temp_acc[19] ) ) ;
DFFSXL \temp_acc_reg[20] ( .D ( n2331 ) , .CK ( n2326 ) , .SN ( HFSNET_364 ) , 
    .Q ( n2204 ) , .QN ( temp_acc[20] ) ) ;
DFFSXL \temp_acc_reg[21] ( .D ( n2332 ) , .CK ( n2326 ) , .SN ( HFSNET_364 ) , 
    .Q ( n2206 ) , .QN ( temp_acc[21] ) ) ;
DFFSXL \meas_val_p_reg[21] ( .D ( n902 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_p[21] ) ) ;
DFFSXL \temp_acc_reg[22] ( .D ( n2333 ) , .CK ( n2326 ) , .SN ( HFSNET_364 ) , 
    .Q ( n2207 ) , .QN ( temp_acc[22] ) ) ;
DFFSXL \meas_val_p_reg[22] ( .D ( n901 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_p[22] ) ) ;
DFFSXL \temp_acc_reg[23] ( .D ( n2334 ) , .CK ( n2326 ) , .SN ( HFSNET_351 ) , 
    .Q ( n2213 ) , .QN ( temp_acc[23] ) ) ;
DFFSXL \meas_val_p_reg[23] ( .D ( n900 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_p[23] ) ) ;
DFFSXL \temp_acc_reg[24] ( .D ( n2335 ) , .CK ( n2326 ) , .SN ( HFSNET_351 ) , 
    .Q ( n2212 ) , .QN ( temp_acc[24] ) ) ;
DFFSXL \meas_val_p_reg[24] ( .D ( n899 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_p[24] ) ) ;
DFFSXL \temp_acc_reg[25] ( .D ( n2336 ) , .CK ( n2326 ) , .SN ( HFSNET_351 ) , 
    .Q ( n2211 ) , .QN ( temp_acc[25] ) ) ;
DFFSXL \meas_val_p_reg[25] ( .D ( n898 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_p[25] ) ) ;
DFFSXL \temp_acc_reg[26] ( .D ( n2337 ) , .CK ( n2326 ) , .SN ( rst_n ) , 
    .Q ( n2210 ) , .QN ( temp_acc[26] ) ) ;
DFFSXL \meas_val_p_reg[26] ( .D ( n897 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_p[26] ) ) ;
DFFSXL \temp_acc_reg[27] ( .D ( n2338 ) , .CK ( n2326 ) , .SN ( rst_n ) , 
    .Q ( n2209 ) , .QN ( temp_acc[27] ) ) ;
DFFSXL \meas_val_p_reg[27] ( .D ( n896 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_p[27] ) ) ;
DFFSXL \temp_acc_reg[28] ( .D ( n2339 ) , .CK ( n2326 ) , .SN ( HFSNET_351 ) , 
    .Q ( n2208 ) , .QN ( temp_acc[28] ) ) ;
DFFSXL \meas_val_n_reg[28] ( .D ( n895 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_n[28] ) ) ;
DFFSXL \meas_val_n_reg[27] ( .D ( n896 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_n[27] ) ) ;
DFFSXL \meas_val_n_reg[26] ( .D ( n897 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_n[26] ) ) ;
DFFSXL \meas_val_n_reg[25] ( .D ( n898 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_n[25] ) ) ;
DFFSXL \meas_val_n_reg[24] ( .D ( n899 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_n[24] ) ) ;
DFFSXL \meas_val_n_reg[23] ( .D ( n900 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_n[23] ) ) ;
DFFSXL \meas_val_n_reg[22] ( .D ( n901 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_n[22] ) ) ;
DFFSXL \meas_val_n_reg[21] ( .D ( n902 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_n[21] ) ) ;
DFFSXL \meas_val_n_reg[1] ( .D ( n922 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_n[1] ) ) ;
DFFSXL \meas_val_n_reg[0] ( .D ( n923 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_n[0] ) ) ;
DFFSX1 overrange_acc_reg ( .D ( n826 ) , .CK ( clk ) , .SN ( HFSNET_381 ) , 
    .QN ( overrange_acc ) ) ;
DFFSXL orr_r_reg ( .D ( n893 ) , .CK ( net1821 ) , .SN ( HFSNET_381 ) , 
    .QN ( orr_r ) ) ;
DFFSXL \wr_idx_r_reg[2] ( .D ( N1787 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_365 ) , .Q ( wr_idx_r[2] ) , .QN ( n2159 ) ) ;
DFFSXL \shadow_weights_reg[2][10] ( .D ( calc_result_r[10] ) , 
    .CK ( ZCTSNET_399 ) , .SN ( HFSNET_356 ) , .Q ( \shadow_weights[2][10] ) ) ;
DFFSX1 \shadow_weights_reg[0][8] ( .D ( calc_result_r[8] ) , .CK ( net1660 ) , 
    .SN ( HFSNET_369 ) , .Q ( \shadow_weights[0][8] ) ) ;
DFFSXL \shadow_weights_reg[1][9] ( .D ( calc_result_r[9] ) , 
    .CK ( ZCTSNET_398 ) , .SN ( HFSNET_358 ) , .Q ( \shadow_weights[1][9] ) ) ;
DFFSXL \shadow_weights_reg[5][13] ( .D ( gre_a_INV_6_54 ) , 
    .CK ( ZCTSNET_402 ) , .SN ( HFSNET_379 ) , .Q ( \shadow_weights[5][13] ) ) ;
DFFSXL \shadow_weights_reg[4][12] ( .D ( gre_a_INV_6_55 ) , 
    .CK ( ZCTSNET_401 ) , .SN ( HFSNET_379 ) , .Q ( \shadow_weights[4][12] ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_1_2 clk_gate_temp_acc_reg_0 ( 
    .CLK ( clk ) , .EN ( n2328 ) , .ENCLK ( n2326 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_411 ) ) ;
DFFSX1 comp_out_r_reg ( .D ( n825 ) , .CK ( clk ) , .SN ( HFSNET_380 ) , 
    .Q ( n2233 ) ) ;
DFFSXL \temp_acc_reg[16] ( .D ( n2324 ) , .CK ( n2326 ) , .SN ( HFSNET_353 ) , 
    .Q ( n2232 ) , .QN ( temp_acc[16] ) ) ;
DFFSXL \temp_acc_reg[17] ( .D ( n2325 ) , .CK ( n2326 ) , .SN ( HFSNET_353 ) , 
    .Q ( n2231 ) , .QN ( temp_acc[17] ) ) ;
DFFSXL \temp_acc_reg[7] ( .D ( n2315 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2230 ) , .QN ( temp_acc[7] ) ) ;
DFFSXL \temp_acc_reg[15] ( .D ( n2323 ) , .CK ( n2326 ) , .SN ( HFSNET_352 ) , 
    .Q ( n2229 ) , .QN ( temp_acc[15] ) ) ;
DFFSX1 \temp_acc_reg[4] ( .D ( n2312 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2228 ) , .QN ( temp_acc[4] ) ) ;
DFFSXL \temp_acc_reg[10] ( .D ( n2318 ) , .CK ( n2326 ) , .SN ( HFSNET_352 ) , 
    .Q ( n2227 ) , .QN ( temp_acc[10] ) ) ;
DFFSXL \temp_acc_reg[12] ( .D ( n2320 ) , .CK ( n2326 ) , .SN ( HFSNET_352 ) , 
    .Q ( n2226 ) , .QN ( temp_acc[12] ) ) ;
DFFSXL \temp_acc_reg[14] ( .D ( n2322 ) , .CK ( n2326 ) , .SN ( HFSNET_352 ) , 
    .Q ( n2225 ) , .QN ( temp_acc[14] ) ) ;
DFFSX1 \temp_acc_reg[6] ( .D ( n2314 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2224 ) , .QN ( temp_acc[6] ) ) ;
DFFSXL \temp_acc_reg[8] ( .D ( n2316 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2223 ) , .QN ( temp_acc[8] ) ) ;
DFFSXL \temp_acc_reg[1] ( .D ( n2309 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2221 ) , .QN ( temp_acc[1] ) ) ;
DFFSX1 \temp_acc_reg[3] ( .D ( n2311 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2220 ) , .QN ( temp_acc[3] ) ) ;
DFFSXL \temp_acc_reg[11] ( .D ( n2319 ) , .CK ( n2326 ) , .SN ( HFSNET_352 ) , 
    .Q ( n2219 ) , .QN ( temp_acc[11] ) ) ;
DFFSXL \temp_acc_reg[13] ( .D ( n2321 ) , .CK ( n2326 ) , .SN ( HFSNET_352 ) , 
    .Q ( n2218 ) , .QN ( temp_acc[13] ) ) ;
DFFSX1 \temp_acc_reg[2] ( .D ( n2310 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2217 ) , .QN ( temp_acc[2] ) ) ;
DFFSX1 \temp_acc_reg[5] ( .D ( n2313 ) , .CK ( n2326 ) , .SN ( HFSNET_352 ) , 
    .Q ( n2216 ) , .QN ( temp_acc[5] ) ) ;
DFFSXL \temp_acc_reg[29] ( .D ( n2340 ) , .CK ( n2326 ) , .SN ( HFSNET_351 ) , 
    .Q ( n2214 ) , .QN ( temp_acc[29] ) ) ;
DFFSXL \accumulator_reg[35] ( .D ( n929 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_354 ) , .Q ( n2201 ) , .QN ( accumulator[35] ) ) ;
DFFSXL \accumulator_reg[34] ( .D ( n930 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .Q ( n2200 ) , .QN ( accumulator[34] ) ) ;
DFFSXL \accumulator_reg[33] ( .D ( n931 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .Q ( n2198 ) , .QN ( accumulator[33] ) ) ;
DFFSX1 \sar_ptr_reg[2] ( .D ( n793 ) , .CK ( net1781 ) , .SN ( HFSNET_379 ) , 
    .Q ( n2197 ) , .QN ( sar_ptr[2] ) ) ;
DFFSXL \accumulator_reg[32] ( .D ( n932 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .Q ( n2196 ) , .QN ( accumulator[32] ) ) ;
DFFSXL \accumulator_reg[31] ( .D ( n933 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .Q ( n2195 ) , .QN ( accumulator[31] ) ) ;
DFFSXL \accumulator_reg[30] ( .D ( HFSNET_66 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .Q ( n2194 ) , .QN ( accumulator[30] ) ) ;
DFFSXL \meas_val_n_reg[29] ( .D ( n894 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_351 ) , .Q ( n2193 ) ) ;
DFFSXL \sar_code_reg[19] ( .D ( n754 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .Q ( n2192 ) , .QN ( protected_sar_code[19] ) ) ;
DFFSXL \calc_cnt_reg[2] ( .D ( n971 ) , .CK ( net1811 ) , .SN ( HFSNET_380 ) , 
    .Q ( n2176 ) , .QN ( calc_cnt[2] ) ) ;
DFFSXL \calc_cnt_reg[1] ( .D ( n972 ) , .CK ( net1811 ) , .SN ( HFSNET_380 ) , 
    .Q ( n2174 ) , .QN ( calc_cnt[1] ) ) ;
DFFSXL \calc_cnt_reg[0] ( .D ( n973 ) , .CK ( net1811 ) , .SN ( HFSNET_380 ) , 
    .Q ( n2173 ) , .QN ( calc_cnt[0] ) ) ;
DFFSXL \shadow_weights_reg[17][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_363 ) , .Q ( n2170 ) , .QN ( \shadow_weights[17][29] ) ) ;
DFFSXL \meas_val_p_reg[29] ( .D ( n894 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_351 ) , .Q ( n2169 ) ) ;
DFFSXL \wr_idx_r_reg[0] ( .D ( n892 ) , .CK ( net1821 ) , .SN ( HFSNET_365 ) , 
    .Q ( n2162 ) , .QN ( wr_idx_r[0] ) ) ;
DFFSX1 calib_done_pulse_reg ( .D ( n823 ) , .CK ( clk ) , .SN ( HFSNET_380 ) , 
    .QN ( calib_done_pulse ) ) ;
DFFSX1 w_wr_en_reg ( .D ( n815 ) , .CK ( ZCTSNET_408 ) , .SN ( HFSNET_365 ) , 
    .QN ( w_wr_en ) ) ;
DFFSXL \w_wr_addr_reg[0] ( .D ( HFSNET_246 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_369 ) , .QN ( w_wr_addr[0] ) ) ;
DFFSXL \w_wr_data_reg[11] ( .D ( gre_a_INV_1788_54 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_357 ) , .QN ( w_wr_data[11] ) ) ;
DFFSXL \w_wr_data_reg[10] ( .D ( HFSNET_301 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_360 ) , .QN ( w_wr_data[10] ) ) ;
DFFSXL \w_wr_data_reg[9] ( .D ( n69 ) , .CK ( net1796 ) , .SN ( HFSNET_361 ) , 
    .QN ( w_wr_data[9] ) ) ;
DFFSXL \w_wr_data_reg[8] ( .D ( HFSNET_296 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_361 ) , .QN ( w_wr_data[8] ) ) ;
DFFSXL \w_wr_data_reg[7] ( .D ( HFSNET_341 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_357 ) , .QN ( w_wr_data[7] ) ) ;
DFFSXL \w_wr_data_reg[6] ( .D ( HFSNET_339 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_357 ) , .QN ( w_wr_data[6] ) ) ;
DFFSXL \w_wr_data_reg[5] ( .D ( HFSNET_337 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[5] ) ) ;
DFFSXL \w_wr_data_reg[4] ( .D ( HFSNET_336 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_358 ) , .QN ( w_wr_data[4] ) ) ;
DFFSXL \w_wr_data_reg[3] ( .D ( HFSNET_332 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_357 ) , .QN ( w_wr_data[3] ) ) ;
DFFSXL \w_wr_data_reg[2] ( .D ( HFSNET_327 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_358 ) , .QN ( w_wr_data[2] ) ) ;
DFFSXL \w_wr_data_reg[1] ( .D ( HFSNET_317 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_358 ) , .QN ( w_wr_data[1] ) ) ;
DFFSXL \w_wr_data_reg[0] ( .D ( HFSNET_311 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_358 ) , .QN ( w_wr_data[0] ) ) ;
DFFSXL \w_wr_addr_reg[4] ( .D ( n65 ) , .CK ( net1791 ) , .SN ( HFSNET_369 ) , 
    .QN ( w_wr_addr[4] ) ) ;
DFFSXL \w_wr_addr_reg[3] ( .D ( n2160 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_369 ) , .QN ( w_wr_addr[3] ) ) ;
DFFSXL \w_wr_addr_reg[2] ( .D ( HFSNET_290 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_369 ) , .QN ( w_wr_addr[2] ) ) ;
DFFSXL \w_wr_addr_reg[1] ( .D ( n2177 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_369 ) , .QN ( w_wr_addr[1] ) ) ;
DFFSXL \w_wr_data_reg[14] ( .D ( HFSNET_312 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_357 ) , .QN ( w_wr_data[14] ) ) ;
DFFSXL \w_wr_data_reg[13] ( .D ( gre_a_INV_1970_54 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_357 ) , .QN ( w_wr_data[13] ) ) ;
DFFSXL \w_wr_data_reg[12] ( .D ( gre_a_INV_1896_55 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_357 ) , .QN ( w_wr_data[12] ) ) ;
DFFSXL \w_wr_data_reg[29] ( .D ( HFSNET_323 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[29] ) ) ;
DFFSX1 \w_wr_data_reg[28] ( .D ( n2306 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[28] ) ) ;
DFFSXL \w_wr_data_reg[27] ( .D ( n2305 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[27] ) ) ;
DFFSXL \w_wr_data_reg[26] ( .D ( n71 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_367 ) , .QN ( w_wr_data[26] ) ) ;
DFFSXL \w_wr_data_reg[25] ( .D ( HFSNET_322 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_369 ) , .QN ( w_wr_data[25] ) ) ;
DFFSXL \w_wr_data_reg[24] ( .D ( HFSNET_321 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_369 ) , .QN ( w_wr_data[24] ) ) ;
DFFSXL \w_wr_data_reg[23] ( .D ( HFSNET_320 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[23] ) ) ;
DFFSXL \w_wr_data_reg[22] ( .D ( HFSNET_319 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[22] ) ) ;
DFFSXL \w_wr_data_reg[21] ( .D ( HFSNET_318 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[21] ) ) ;
DFFSXL \w_wr_data_reg[20] ( .D ( n2299 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[20] ) ) ;
DFFSXL \w_wr_data_reg[19] ( .D ( n2298 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_368 ) , .QN ( w_wr_data[19] ) ) ;
DFFSXL \w_wr_data_reg[18] ( .D ( HFSNET_316 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_369 ) , .QN ( w_wr_data[18] ) ) ;
DFFSXL \w_wr_data_reg[17] ( .D ( HFSNET_315 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_369 ) , .QN ( w_wr_data[17] ) ) ;
DFFSXL \w_wr_data_reg[16] ( .D ( HFSNET_314 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_361 ) , .QN ( w_wr_data[16] ) ) ;
DFFSXL \w_wr_data_reg[15] ( .D ( HFSNET_313 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_361 ) , .QN ( w_wr_data[15] ) ) ;
DFFSX1 calib_done_reg ( .D ( n774 ) , .CK ( net1761 ) , .SN ( HFSNET_371 ) , 
    .QN ( calib_done ) ) ;
DFFSX1 calib_mode_en_reg ( .D ( n968 ) , .CK ( net1761 ) , 
    .SN ( HFSNET_381 ) , .QN ( calib_mode_en ) ) ;
DFFSXL \shadow_weights_reg[17][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][17] ) ) ;
DFFSXL \accumulator_reg[20] ( .D ( n944 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[20] ) ) ;
DFFSXL \meas_val_n_reg[20] ( .D ( n903 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_n[20] ) ) ;
DFFSXL \shadow_weights_reg[17][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][16] ) ) ;
DFFSXL \meas_val_n_reg[19] ( .D ( n904 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_n[19] ) ) ;
DFFSXL \meas_val_p_reg[0] ( .D ( n923 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_p[0] ) ) ;
DFFSXL \accumulator_reg[0] ( .D ( n962 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_352 ) , .QN ( accumulator[0] ) ) ;
DFFSXL \meas_val_p_reg[3] ( .D ( n920 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_p[3] ) ) ;
DFFSXL \meas_val_n_reg[3] ( .D ( n920 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_n[3] ) ) ;
DFFSXL \meas_val_p_reg[1] ( .D ( n922 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_p[1] ) ) ;
DFFSXL \meas_val_p_reg[11] ( .D ( n912 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[11] ) ) ;
DFFSXL \meas_val_n_reg[11] ( .D ( n912 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[11] ) ) ;
DFFSXL \shadow_weights_reg[17][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][15] ) ) ;
DFFSXL \accumulator_reg[11] ( .D ( n952 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[11] ) ) ;
DFFSXL \accumulator_reg[1] ( .D ( n961 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_352 ) , .QN ( accumulator[1] ) ) ;
DFFSXL \shadow_weights_reg[17][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][7] ) ) ;
DFFSXL \meas_val_p_reg[10] ( .D ( n913 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_p[10] ) ) ;
DFFSXL \meas_val_n_reg[10] ( .D ( n913 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_n[10] ) ) ;
DFFSXL \accumulator_reg[10] ( .D ( n953 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[10] ) ) ;
DFFSXL \meas_val_p_reg[6] ( .D ( n917 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_p[6] ) ) ;
DFFSXL \meas_val_p_reg[14] ( .D ( n909 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[14] ) ) ;
DFFSXL \meas_val_n_reg[6] ( .D ( n917 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[6] ) ) ;
DFFSXL \meas_val_n_reg[14] ( .D ( n909 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[14] ) ) ;
DFFSXL \accumulator_reg[6] ( .D ( n957 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[6] ) ) ;
DFFSXL \accumulator_reg[14] ( .D ( n950 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_353 ) , .QN ( accumulator[14] ) ) ;
DFFSXL \meas_val_p_reg[13] ( .D ( n910 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[13] ) ) ;
DFFSXL \meas_val_p_reg[7] ( .D ( n916 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_p[7] ) ) ;
DFFSXL \meas_val_n_reg[13] ( .D ( n910 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[13] ) ) ;
DFFSXL \meas_val_n_reg[7] ( .D ( n916 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_n[7] ) ) ;
DFFSXL \accumulator_reg[13] ( .D ( n818 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[13] ) ) ;
DFFSXL \accumulator_reg[7] ( .D ( n956 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_352 ) , .QN ( accumulator[7] ) ) ;
DFFSXL \meas_val_n_reg[4] ( .D ( n919 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_n[4] ) ) ;
DFFSXL \meas_val_p_reg[4] ( .D ( n919 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[4] ) ) ;
DFFSXL \accumulator_reg[12] ( .D ( n951 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[12] ) ) ;
DFFSXL \meas_val_n_reg[12] ( .D ( n911 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[12] ) ) ;
DFFSXL \meas_val_p_reg[12] ( .D ( n911 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[12] ) ) ;
DFFSXL \meas_val_n_reg[9] ( .D ( n914 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_n[9] ) ) ;
DFFSXL \meas_val_p_reg[9] ( .D ( n914 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_p[9] ) ) ;
DFFSXL \accumulator_reg[18] ( .D ( n946 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[18] ) ) ;
DFFSXL \meas_val_n_reg[5] ( .D ( n918 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_n[5] ) ) ;
DFFSXL \meas_val_p_reg[5] ( .D ( n918 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[5] ) ) ;
DFFSXL \accumulator_reg[15] ( .D ( n949 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[15] ) ) ;
DFFSXL \temp_acc_reg[9] ( .D ( n2317 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2215 ) , .QN ( temp_acc[9] ) ) ;
DFFSXL \meas_val_p_reg[18] ( .D ( n905 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[18] ) ) ;
DFFSXL \accumulator_reg[8] ( .D ( n955 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_352 ) , .QN ( accumulator[8] ) ) ;
DFFSXL \meas_val_p_reg[8] ( .D ( n915 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[8] ) ) ;
DFFSXL \meas_val_p_reg[15] ( .D ( n908 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[15] ) ) ;
DFFSXL \meas_val_n_reg[2] ( .D ( n921 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[2] ) ) ;
DFFSXL \meas_val_p_reg[2] ( .D ( n921 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_352 ) , .QN ( meas_val_p[2] ) ) ;
DFFSXL \accumulator_reg[16] ( .D ( n948 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[16] ) ) ;
DFFSXL \meas_val_p_reg[16] ( .D ( n907 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_p[16] ) ) ;
DFFSXL \accumulator_reg[17] ( .D ( n947 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_364 ) , .QN ( accumulator[17] ) ) ;
DFFSXL \meas_val_p_reg[17] ( .D ( n906 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_p[17] ) ) ;
DFFSXL \meas_val_p_reg[19] ( .D ( n904 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_p[19] ) ) ;
DFFSXL \meas_val_n_reg[15] ( .D ( n908 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[15] ) ) ;
DFFSXL \temp_acc_reg[0] ( .D ( n2308 ) , .CK ( n2326 ) , .SN ( HFSNET_362 ) , 
    .Q ( n2222 ) , .QN ( temp_acc[0] ) ) ;
DFFSX1 \state_reg[2] ( .D ( n819 ) , .CK ( clk ) , .SN ( HFSNET_380 ) , 
    .Q ( n68 ) , .QN ( state[2] ) ) ;
DFFSXL \shadow_weights_reg[15][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[15][15] ) ) ;
DFFSXL \shadow_weights_reg[11][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[11][15] ) ) ;
DFFSXL \shadow_weights_reg[4][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[4][15] ) ) ;
DFFSXL \shadow_weights_reg[18][15] ( .D ( HFSNET_313 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][15] ) ) ;
DFFSXL \shadow_weights_reg[16][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[16][15] ) ) ;
DFFSXL \shadow_weights_reg[15][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[15][16] ) ) ;
DFFSXL \shadow_weights_reg[11][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[11][16] ) ) ;
DFFSXL \shadow_weights_reg[4][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[4][16] ) ) ;
DFFSXL \shadow_weights_reg[18][16] ( .D ( HFSNET_314 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][16] ) ) ;
DFFSXL \shadow_weights_reg[16][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[16][16] ) ) ;
DFFSXL \shadow_weights_reg[15][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[15][17] ) ) ;
DFFSXL \shadow_weights_reg[11][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][17] ) ) ;
DFFSXL \shadow_weights_reg[4][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[4][17] ) ) ;
DFFSXL \shadow_weights_reg[18][17] ( .D ( HFSNET_315 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][17] ) ) ;
DFFSXL \shadow_weights_reg[16][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[16][17] ) ) ;
DFFSXL \shadow_weights_reg[15][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[15][29] ) ) ;
DFFSXL \shadow_weights_reg[11][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[11][29] ) ) ;
DFFSXL \shadow_weights_reg[4][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[4][29] ) ) ;
DFFSXL \shadow_weights_reg[18][29] ( .D ( HFSNET_323 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[18][29] ) ) ;
DFFSXL \shadow_weights_reg[16][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[16][29] ) ) ;
DFFSXL \shadow_weights_reg[15][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[15][7] ) ) ;
DFFSXL \shadow_weights_reg[11][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[11][7] ) ) ;
DFFSXL \shadow_weights_reg[4][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[4][7] ) ) ;
DFFSXL \shadow_weights_reg[18][7] ( .D ( HFSNET_341 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[18][7] ) ) ;
DFFSXL \shadow_weights_reg[16][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[16][7] ) ) ;
DFFSX2 \calc_result_r_reg[26] ( .D ( n833 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .Q ( n71 ) ) ;
DFFSXL \shadow_weights_reg[15][26] ( .D ( n71 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[15][26] ) ) ;
DFFSXL \shadow_weights_reg[11][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[11][26] ) ) ;
DFFSXL \shadow_weights_reg[4][26] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[4][26] ) ) ;
DFFSXL \shadow_weights_reg[18][26] ( .D ( n71 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[18][26] ) ) ;
DFFSXL \shadow_weights_reg[16][26] ( .D ( n71 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[16][26] ) ) ;
DFFSXL \shadow_weights_reg[15][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[15][18] ) ) ;
DFFSXL \shadow_weights_reg[11][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][18] ) ) ;
DFFSXL \shadow_weights_reg[4][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[4][18] ) ) ;
DFFSXL \shadow_weights_reg[18][18] ( .D ( HFSNET_316 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[18][18] ) ) ;
DFFSXL \shadow_weights_reg[16][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[16][18] ) ) ;
DFFSXL \shadow_weights_reg[15][19] ( .D ( n2298 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[15][19] ) ) ;
DFFSXL \shadow_weights_reg[11][19] ( .D ( n2298 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[11][19] ) ) ;
DFFSXL \shadow_weights_reg[4][19] ( .D ( n2298 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[4][19] ) ) ;
DFFSXL \shadow_weights_reg[18][19] ( .D ( n2298 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[18][19] ) ) ;
DFFSXL \shadow_weights_reg[16][19] ( .D ( n2298 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[16][19] ) ) ;
DFFSXL \shadow_weights_reg[15][20] ( .D ( n2299 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[15][20] ) ) ;
DFFSXL \shadow_weights_reg[11][20] ( .D ( n2299 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[11][20] ) ) ;
DFFSXL \shadow_weights_reg[4][20] ( .D ( n2299 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[4][20] ) ) ;
DFFSXL \shadow_weights_reg[18][20] ( .D ( n2299 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_365 ) , .QN ( \shadow_weights[18][20] ) ) ;
DFFSXL \shadow_weights_reg[16][20] ( .D ( n2299 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[16][20] ) ) ;
DFFSXL \shadow_weights_reg[15][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_380 ) , .QN ( \shadow_weights[15][21] ) ) ;
DFFSXL \shadow_weights_reg[11][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[11][21] ) ) ;
DFFSXL \shadow_weights_reg[4][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[4][21] ) ) ;
DFFSXL \shadow_weights_reg[18][21] ( .D ( HFSNET_318 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_365 ) , .QN ( \shadow_weights[18][21] ) ) ;
DFFSXL \shadow_weights_reg[16][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[16][21] ) ) ;
DFFSXL \shadow_weights_reg[15][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[15][22] ) ) ;
DFFSXL \shadow_weights_reg[11][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[11][22] ) ) ;
DFFSXL \shadow_weights_reg[4][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[4][22] ) ) ;
DFFSXL \shadow_weights_reg[18][22] ( .D ( HFSNET_319 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[18][22] ) ) ;
DFFSXL \shadow_weights_reg[16][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[16][22] ) ) ;
DFFSXL \shadow_weights_reg[15][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[15][23] ) ) ;
DFFSXL \shadow_weights_reg[11][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[11][23] ) ) ;
DFFSXL \shadow_weights_reg[4][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[4][23] ) ) ;
DFFSXL \shadow_weights_reg[18][23] ( .D ( HFSNET_320 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[18][23] ) ) ;
DFFSXL \shadow_weights_reg[16][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[16][23] ) ) ;
DFFSXL \shadow_weights_reg[15][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[15][24] ) ) ;
DFFSXL \shadow_weights_reg[11][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[11][24] ) ) ;
DFFSXL \shadow_weights_reg[4][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[4][24] ) ) ;
DFFSXL \shadow_weights_reg[18][24] ( .D ( HFSNET_321 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_365 ) , .QN ( \shadow_weights[18][24] ) ) ;
DFFSXL \shadow_weights_reg[16][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[16][24] ) ) ;
DFFSXL \shadow_weights_reg[15][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_380 ) , .QN ( \shadow_weights[15][25] ) ) ;
DFFSXL \shadow_weights_reg[11][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[11][25] ) ) ;
DFFSXL \shadow_weights_reg[4][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[4][25] ) ) ;
DFFSXL \shadow_weights_reg[18][25] ( .D ( HFSNET_322 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_365 ) , .QN ( \shadow_weights[18][25] ) ) ;
DFFSXL \shadow_weights_reg[16][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[16][25] ) ) ;
DFFSXL \shadow_weights_reg[15][27] ( .D ( n2305 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[15][27] ) ) ;
DFFSXL \shadow_weights_reg[11][27] ( .D ( n2305 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[11][27] ) ) ;
DFFSXL \shadow_weights_reg[4][27] ( .D ( n2305 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[4][27] ) ) ;
DFFSXL \shadow_weights_reg[18][27] ( .D ( n2305 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[18][27] ) ) ;
DFFSXL \shadow_weights_reg[16][27] ( .D ( n2305 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[16][27] ) ) ;
DFFSXL \shadow_weights_reg[15][28] ( .D ( n2306 ) , .CK ( ZCTSNET_393 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[15][28] ) ) ;
DFFSXL \shadow_weights_reg[11][28] ( .D ( n2306 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_379 ) , .QN ( \shadow_weights[11][28] ) ) ;
DFFSXL \shadow_weights_reg[4][28] ( .D ( n2306 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[4][28] ) ) ;
DFFSXL \shadow_weights_reg[18][28] ( .D ( n2306 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[18][28] ) ) ;
DFFSXL \shadow_weights_reg[16][28] ( .D ( n2306 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[16][28] ) ) ;
DFFSXL \shadow_weights_reg[11][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][14] ) ) ;
DFFSXL \shadow_weights_reg[4][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[4][14] ) ) ;
DFFSXL \shadow_weights_reg[18][14] ( .D ( HFSNET_312 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[18][14] ) ) ;
DFFSXL \shadow_weights_reg[16][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[16][14] ) ) ;
DFFSXL \shadow_weights_reg[17][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[17][14] ) ) ;
DFFSXL \shadow_weights_reg[11][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][0] ) ) ;
DFFSXL \shadow_weights_reg[4][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[4][0] ) ) ;
DFFSXL \shadow_weights_reg[18][0] ( .D ( HFSNET_311 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][0] ) ) ;
DFFSXL \shadow_weights_reg[16][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[16][0] ) ) ;
DFFSXL \shadow_weights_reg[17][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][0] ) ) ;
DFFSXL \shadow_weights_reg[11][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][1] ) ) ;
DFFSXL \shadow_weights_reg[4][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[4][1] ) ) ;
DFFSXL \shadow_weights_reg[18][1] ( .D ( HFSNET_317 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][1] ) ) ;
DFFSXL \shadow_weights_reg[16][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[16][1] ) ) ;
DFFSXL \shadow_weights_reg[17][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][1] ) ) ;
DFFSXL \shadow_weights_reg[11][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][2] ) ) ;
DFFSXL \shadow_weights_reg[4][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[4][2] ) ) ;
DFFSXL \shadow_weights_reg[18][2] ( .D ( HFSNET_327 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[18][2] ) ) ;
DFFSXL \shadow_weights_reg[16][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[16][2] ) ) ;
DFFSXL \shadow_weights_reg[17][2] ( .D ( HFSNET_327 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][2] ) ) ;
DFFSXL \shadow_weights_reg[11][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][3] ) ) ;
DFFSXL \shadow_weights_reg[4][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[4][3] ) ) ;
DFFSXL \shadow_weights_reg[18][3] ( .D ( HFSNET_332 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[18][3] ) ) ;
DFFSXL \shadow_weights_reg[16][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[16][3] ) ) ;
DFFSXL \shadow_weights_reg[17][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][3] ) ) ;
DFFSXL \shadow_weights_reg[11][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[11][4] ) ) ;
DFFSXL \shadow_weights_reg[4][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[4][4] ) ) ;
DFFSXL \shadow_weights_reg[18][4] ( .D ( HFSNET_336 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][4] ) ) ;
DFFSXL \shadow_weights_reg[16][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[16][4] ) ) ;
DFFSXL \shadow_weights_reg[17][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[17][4] ) ) ;
DFFSXL \shadow_weights_reg[11][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[11][5] ) ) ;
DFFSXL \shadow_weights_reg[4][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[4][5] ) ) ;
DFFSXL \shadow_weights_reg[18][5] ( .D ( HFSNET_337 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[18][5] ) ) ;
DFFSXL \shadow_weights_reg[16][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[16][5] ) ) ;
DFFSXL \shadow_weights_reg[17][5] ( .D ( HFSNET_337 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][5] ) ) ;
DFFSXL \shadow_weights_reg[11][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][6] ) ) ;
DFFSXL \shadow_weights_reg[4][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[4][6] ) ) ;
DFFSXL \shadow_weights_reg[18][6] ( .D ( HFSNET_339 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[18][6] ) ) ;
DFFSXL \shadow_weights_reg[16][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[16][6] ) ) ;
DFFSXL \shadow_weights_reg[17][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][6] ) ) ;
DFFSX2 \calc_result_r_reg[8] ( .D ( n851 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_355 ) , .Q ( n70 ) , .QN ( calc_result_r[8] ) ) ;
DFFSXL \shadow_weights_reg[11][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][8] ) ) ;
DFFSXL \shadow_weights_reg[4][8] ( .D ( n70 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[4][8] ) ) ;
DFFSXL \shadow_weights_reg[18][8] ( .D ( HFSNET_295 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[18][8] ) ) ;
DFFSXL \shadow_weights_reg[16][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[16][8] ) ) ;
DFFSXL \shadow_weights_reg[17][8] ( .D ( HFSNET_296 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][8] ) ) ;
DFFSX4 \calc_result_r_reg[9] ( .D ( n850 ) , .CK ( net1826 ) , 
    .SN ( HFSNET_363 ) , .Q ( n69 ) , .QN ( calc_result_r[9] ) ) ;
DFFSXL \shadow_weights_reg[11][9] ( .D ( n69 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[11][9] ) ) ;
DFFSXL \shadow_weights_reg[4][9] ( .D ( n69 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_368 ) , .QN ( \shadow_weights[4][9] ) ) ;
DFFSXL \shadow_weights_reg[18][9] ( .D ( n69 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][9] ) ) ;
DFFSXL \shadow_weights_reg[16][9] ( .D ( n69 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[16][9] ) ) ;
DFFSXL \shadow_weights_reg[17][9] ( .D ( n69 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][9] ) ) ;
DFFSXL \shadow_weights_reg[15][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_393 ) , .SN ( HFSNET_357 ) , 
    .QN ( \shadow_weights[15][12] ) ) ;
DFFSXL \shadow_weights_reg[11][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_389 ) , .SN ( HFSNET_374 ) , 
    .QN ( \shadow_weights[11][12] ) ) ;
DFFSXL \shadow_weights_reg[18][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( net1751 ) , .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][12] ) ) ;
DFFSXL \shadow_weights_reg[16][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_394 ) , .SN ( HFSNET_356 ) , 
    .QN ( \shadow_weights[16][12] ) ) ;
DFFSXL \shadow_weights_reg[17][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_395 ) , .SN ( HFSNET_363 ) , 
    .QN ( \shadow_weights[17][12] ) ) ;
DFFSXL \shadow_weights_reg[11][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_389 ) , .SN ( HFSNET_375 ) , 
    .QN ( \shadow_weights[11][13] ) ) ;
DFFSXL \shadow_weights_reg[4][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_401 ) , .SN ( HFSNET_379 ) , 
    .QN ( \shadow_weights[4][13] ) ) ;
DFFSXL \shadow_weights_reg[18][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( net1751 ) , .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][13] ) ) ;
DFFSXL \shadow_weights_reg[16][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_394 ) , .SN ( HFSNET_356 ) , 
    .QN ( \shadow_weights[16][13] ) ) ;
DFFSXL \shadow_weights_reg[17][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_395 ) , .SN ( HFSNET_359 ) , 
    .QN ( \shadow_weights[17][13] ) ) ;
DFFSXL \shadow_weights_reg[11][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_389 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[11][10] ) ) ;
DFFSXL \shadow_weights_reg[4][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_401 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[4][10] ) ) ;
DFFSXL \shadow_weights_reg[18][10] ( .D ( HFSNET_301 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[18][10] ) ) ;
DFFSXL \shadow_weights_reg[16][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_394 ) , 
    .SN ( HFSNET_362 ) , .QN ( \shadow_weights[16][10] ) ) ;
DFFSXL \shadow_weights_reg[17][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_395 ) , 
    .SN ( HFSNET_359 ) , .QN ( \shadow_weights[17][10] ) ) ;
DFFSXL \shadow_weights_reg[11][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_389 ) , .SN ( HFSNET_377 ) , 
    .QN ( \shadow_weights[11][11] ) ) ;
DFFSXL \shadow_weights_reg[4][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_401 ) , .SN ( HFSNET_368 ) , 
    .QN ( \shadow_weights[4][11] ) ) ;
DFFSXL \shadow_weights_reg[18][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( net1751 ) , .SN ( HFSNET_355 ) , .QN ( \shadow_weights[18][11] ) ) ;
DFFSXL \shadow_weights_reg[16][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_394 ) , .SN ( HFSNET_359 ) , 
    .QN ( \shadow_weights[16][11] ) ) ;
DFFSXL \shadow_weights_reg[17][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( ZCTSNET_395 ) , .SN ( HFSNET_359 ) , 
    .QN ( \shadow_weights[17][11] ) ) ;
DFFSX1 \calc_cnt_reg[3] ( .D ( n970 ) , .CK ( net1811 ) , .SN ( HFSNET_380 ) , 
    .Q ( n2175 ) , .QN ( calc_cnt[3] ) ) ;
DFFSX1 \calc_cnt_reg[4] ( .D ( n969 ) , .CK ( net1811 ) , .SN ( HFSNET_380 ) , 
    .Q ( n2161 ) , .QN ( calc_cnt[4] ) ) ;
DFFSX2 \wr_idx_r_reg[1] ( .D ( N1786 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_355 ) , .Q ( wr_idx_r[1] ) , .QN ( n2177 ) ) ;
DFFSX2 \target_bit_reg[2] ( .D ( N1491 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .Q ( target_bit[2] ) , .QN ( n2179 ) ) ;
DFFSX2 \target_bit_reg[4] ( .D ( n827 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .Q ( n2178 ) , .QN ( target_bit[4] ) ) ;
DFFSX2 \target_bit_reg[3] ( .D ( n828 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .Q ( n2202 ) , .QN ( target_bit[3] ) ) ;
DFFSX2 \overrange_bits_reg[10] ( .D ( n707 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[10] ) ) ;
DFFSX2 \overrange_bits_reg[11] ( .D ( n706 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[11] ) ) ;
DFFSX2 \overrange_bits_reg[12] ( .D ( n705 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[12] ) ) ;
DFFSX2 \overrange_bits_reg[13] ( .D ( n704 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[13] ) ) ;
DFFSX2 \overrange_bits_reg[14] ( .D ( n703 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[14] ) ) ;
DFFSX2 \overrange_bits_reg[15] ( .D ( n702 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[15] ) ) ;
DFFSX2 \wr_idx_r_reg[3] ( .D ( n891 ) , .CK ( net1821 ) , .SN ( HFSNET_365 ) , 
    .Q ( n2160 ) , .QN ( wr_idx_r[3] ) ) ;
DFFSX2 \target_bit_reg[1] ( .D ( N1490 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .Q ( target_bit[1] ) , .QN ( n2158 ) ) ;
DFFSX2 \overrange_bits_reg[0] ( .D ( n717 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .QN ( overrange_bits[0] ) ) ;
DFFSX2 \overrange_bits_reg[1] ( .D ( n716 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .QN ( overrange_bits[1] ) ) ;
DFFSXL \overrange_bits_reg[2] ( .D ( n715 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .QN ( aps_rename_4_ ) ) ;
DFFSXL \meas_val_n_reg[18] ( .D ( n905 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[18] ) ) ;
DFFSXL \meas_val_n_reg[8] ( .D ( n915 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_353 ) , .QN ( meas_val_n[8] ) ) ;
DFFSXL \meas_val_n_reg[16] ( .D ( n907 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_n[16] ) ) ;
DFFSXL \meas_val_n_reg[17] ( .D ( n906 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_n[17] ) ) ;
DFFSXL \overrange_bits_reg[7] ( .D ( n710 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .QN ( aps_rename_3_ ) ) ;
DFFSX2 \target_bit_reg[0] ( .D ( n829 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .Q ( n2163 ) , .QN ( target_bit[0] ) ) ;
DFFSXL \meas_val_p_reg[20] ( .D ( n903 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_364 ) , .QN ( meas_val_p[20] ) ) ;
DFFSX2 \wr_idx_r_reg[4] ( .D ( n890 ) , .CK ( net1821 ) , .SN ( HFSNET_365 ) , 
    .Q ( n65 ) , .QN ( wr_idx_r[4] ) ) ;
DFFSX1 \state_reg[0] ( .D ( n821 ) , .CK ( clk ) , .SN ( HFSNET_380 ) , 
    .Q ( n2171 ) , .QN ( state[0] ) ) ;
DFFSX1 calib_overrange_reg ( .D ( n698 ) , .CK ( ZCTSNET_408 ) , 
    .SN ( HFSNET_381 ) , .QN ( calib_overrange ) ) ;
DFFSX1 \overrange_bits_reg[6] ( .D ( n711 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[6] ) ) ;
DFFSX2 \overrange_bits_reg[8] ( .D ( n709 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[8] ) ) ;
DFFSX1 \overrange_bits_reg[16] ( .D ( n701 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[16] ) ) ;
DFFSXL \overrange_bits_reg[17] ( .D ( n700 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .QN ( aps_rename_2_ ) ) ;
DFFSXL \overrange_bits_reg[18] ( .D ( n699 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_381 ) , .QN ( aps_rename_1_ ) ) ;
DFFSX1 \overrange_bits_reg[19] ( .D ( n697 ) , .CK ( net1761 ) , 
    .SN ( HFSNET_381 ) , .QN ( overrange_bits[19] ) ) ;
DFFSX2 \overrange_bits_reg[3] ( .D ( n714 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[3] ) ) ;
DFFSX2 \overrange_bits_reg[4] ( .D ( n713 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[4] ) ) ;
DFFSX2 \overrange_bits_reg[5] ( .D ( n712 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[5] ) ) ;
DFFSX2 \overrange_bits_reg[9] ( .D ( n708 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[9] ) ) ;
DFFSX1 \sar_code_reg[15] ( .D ( n758 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2182 ) , .QN ( protected_sar_code[15] ) ) ;
DFFSX1 \sar_code_reg[7] ( .D ( n766 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2180 ) , .QN ( protected_sar_code[7] ) ) ;
DFFSX1 \sar_code_reg[9] ( .D ( n764 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .Q ( n2167 ) , .QN ( protected_sar_code[9] ) ) ;
DFFSX1 \sar_code_reg[11] ( .D ( n762 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2164 ) , .QN ( protected_sar_code[11] ) ) ;
DFFSX1 \sar_code_reg[2] ( .D ( n771 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2165 ) , .QN ( protected_sar_code[2] ) ) ;
DFFSX1 \sar_code_reg[6] ( .D ( n767 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .Q ( n2168 ) , .QN ( protected_sar_code[6] ) ) ;
DFFSX1 \sar_code_reg[10] ( .D ( n763 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .Q ( n2166 ) , .QN ( protected_sar_code[10] ) ) ;
DFFSX1 \sar_code_reg[1] ( .D ( n772 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2186 ) , .QN ( protected_sar_code[1] ) ) ;
DFFSX1 \sar_ptr_reg[0] ( .D ( n791 ) , .CK ( net1781 ) , .SN ( HFSNET_380 ) , 
    .Q ( n2199 ) , .QN ( sar_ptr[0] ) ) ;
DFFSXL \sar_ptr_reg[1] ( .D ( n792 ) , .CK ( net1781 ) , .SN ( HFSNET_380 ) , 
    .QN ( sar_ptr[1] ) ) ;
DFFSX1 \sar_code_reg[3] ( .D ( n770 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2181 ) , .QN ( protected_sar_code[3] ) ) ;
DFFSX1 \sar_code_reg[8] ( .D ( n765 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_372 ) , .Q ( n2183 ) , .QN ( protected_sar_code[8] ) ) ;
DFFSXL \sar_code_reg[14] ( .D ( n759 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .Q ( n2184 ) , .QN ( protected_sar_code[14] ) ) ;
DFFSXL \avg_cnt_reg[4] ( .D ( n963 ) , .CK ( net1771 ) , .SN ( HFSNET_351 ) , 
    .QN ( avg_cnt[4] ) ) ;
DFFSXL \avg_rounded_r_reg[13] ( .D ( n882 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[13] ) ) ;
DFFSXL \avg_rounded_r_reg[8] ( .D ( n887 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_354 ) , .QN ( avg_rounded_r[8] ) ) ;
DFFSXL \shadow_weights_reg[2][4] ( .D ( HFSNET_336 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[2][4] ) ) ;
DFFSXL \shadow_weights_reg[3][0] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[3][0] ) ) ;
DFFSXL \shadow_weights_reg[7][9] ( .D ( n69 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[7][9] ) ) ;
DFFSXL \shadow_weights_reg[10][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[10][6] ) ) ;
DFFSXL \shadow_weights_reg[14][3] ( .D ( HFSNET_332 ) , .CK ( ZCTSNET_392 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[14][3] ) ) ;
DFFSXL \shadow_weights_reg[0][11] ( .D ( gre_a_INV_1788_54 ) , 
    .CK ( net1660 ) , .SN ( HFSNET_357 ) , .QN ( \shadow_weights[0][11] ) ) ;
DFFSXL \shadow_weights_reg[5][7] ( .D ( HFSNET_341 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[5][7] ) ) ;
DFFSXL \shadow_weights_reg[8][4] ( .D ( HFSNET_336 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[8][4] ) ) ;
DFFSXL \shadow_weights_reg[12][1] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_390 ) , 
    .SN ( HFSNET_378 ) , .QN ( \shadow_weights[12][1] ) ) ;
DFFSXL \shadow_weights_reg[1][10] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[1][10] ) ) ;
DFFSXL \shadow_weights_reg[9][6] ( .D ( HFSNET_339 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_376 ) , .QN ( \shadow_weights[9][6] ) ) ;
DFFSXL \shadow_weights_reg[9][14] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_377 ) , .QN ( \shadow_weights[9][14] ) ) ;
DFFSXL \shadow_weights_reg[12][13] ( .D ( gre_a_INV_1970_54 ) , 
    .CK ( ZCTSNET_390 ) , .SN ( HFSNET_374 ) , 
    .QN ( \shadow_weights[12][13] ) ) ;
DFFSXL \shadow_weights_reg[12][12] ( .D ( gre_a_INV_1896_55 ) , 
    .CK ( ZCTSNET_390 ) , .SN ( HFSNET_379 ) , 
    .QN ( \shadow_weights[12][12] ) ) ;
DFFSXL \wait_cnt_reg[2] ( .D ( n925 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .QN ( wait_cnt[2] ) ) ;
DFFSXL \shadow_weights_reg[2][29] ( .D ( HFSNET_323 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[2][29] ) ) ;
DFFSXL \shadow_weights_reg[5][28] ( .D ( n2306 ) , .CK ( ZCTSNET_402 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[5][28] ) ) ;
DFFSXL \shadow_weights_reg[7][27] ( .D ( n2305 ) , .CK ( ZCTSNET_404 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[7][27] ) ) ;
DFFSXL \shadow_weights_reg[8][26] ( .D ( n71 ) , .CK ( net1701 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[8][26] ) ) ;
DFFSXL \shadow_weights_reg[10][25] ( .D ( HFSNET_322 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_366 ) , .QN ( \shadow_weights[10][25] ) ) ;
DFFSXL \shadow_weights_reg[13][24] ( .D ( HFSNET_321 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_370 ) , .QN ( \shadow_weights[13][24] ) ) ;
DFFSXL \shadow_weights_reg[19][23] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_363 ) , .QN ( \shadow_weights[19][23] ) ) ;
DFFSXL \accumulator_reg[28] ( .D ( HFSNET_68 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_365 ) , .QN ( accumulator[28] ) ) ;
DFFSXL \shadow_weights_reg[2][22] ( .D ( HFSNET_319 ) , .CK ( ZCTSNET_399 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[2][22] ) ) ;
DFFSXL \shadow_weights_reg[6][21] ( .D ( HFSNET_318 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_367 ) , .QN ( \shadow_weights[6][21] ) ) ;
DFFSXL \shadow_weights_reg[9][20] ( .D ( n2299 ) , .CK ( ZCTSNET_406 ) , 
    .SN ( HFSNET_374 ) , .QN ( \shadow_weights[9][20] ) ) ;
DFFSXL \shadow_weights_reg[13][19] ( .D ( n2298 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[13][19] ) ) ;
DFFSXL \shadow_weights_reg[19][18] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_397 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[19][18] ) ) ;
DFFSXL \accumulator_reg[23] ( .D ( HFSNET_11 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_354 ) , .QN ( accumulator[23] ) ) ;
DFFSXL \shadow_weights_reg[1][17] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_398 ) , 
    .SN ( HFSNET_375 ) , .QN ( \shadow_weights[1][17] ) ) ;
DFFSXL \shadow_weights_reg[3][16] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_400 ) , 
    .SN ( HFSNET_373 ) , .QN ( \shadow_weights[3][16] ) ) ;
DFFSXL \shadow_weights_reg[6][15] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_403 ) , 
    .SN ( HFSNET_369 ) , .QN ( \shadow_weights[6][15] ) ) ;
DFFSXL \meas_val_p_reg[28] ( .D ( n895 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_351 ) , .QN ( meas_val_p[28] ) ) ;
DFFSXL \shadow_weights_reg[3][11] ( .D ( gre_a_INV_302_54 ) , 
    .CK ( ZCTSNET_400 ) , .SN ( HFSNET_358 ) , .Q ( \shadow_weights[3][11] ) ) ;
DFFSX1 \state_reg[1] ( .D ( n816 ) , .CK ( clk ) , .SN ( HFSNET_371 ) , 
    .Q ( n67 ) , .QN ( state[1] ) ) ;
DFFSXL \sar_ptr_reg[4] ( .D ( n820 ) , .CK ( net1781 ) , .SN ( HFSNET_380 ) , 
    .QN ( sar_ptr[4] ) ) ;
DFFSX1 \sar_code_reg[16] ( .D ( n757 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .Q ( n2189 ) , .QN ( protected_sar_code[16] ) ) ;
DFFSX1 \sar_code_reg[12] ( .D ( n761 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_380 ) , .Q ( n2187 ) , .QN ( protected_sar_code[12] ) ) ;
DFFSXL \sar_ptr_reg[3] ( .D ( n794 ) , .CK ( net1781 ) , .SN ( HFSNET_379 ) , 
    .Q ( n1 ) , .QN ( sar_ptr[3] ) ) ;
OAI221XL U3 ( .A0 ( N1841 ) , .A1 ( overrange_bits[1] ) , .B0 ( n2138 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n716 ) ) ;
OAI221XL U4 ( .A0 ( N1842 ) , .A1 ( overrange_bits[0] ) , .B0 ( HFSNET_261 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n717 ) ) ;
OAI221XL U5 ( .A0 ( N1838 ) , .A1 ( overrange_bits[4] ) , .B0 ( HFSNET_253 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n713 ) ) ;
OAI221XL U6 ( .A0 ( N1840 ) , .A1 ( overrange_bits[2] ) , .B0 ( n2139 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n715 ) ) ;
OAI221XL U7 ( .A0 ( N1839 ) , .A1 ( overrange_bits[3] ) , .B0 ( HFSNET_275 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n714 ) ) ;
AND2X1 U8 ( .A ( n1991 ) , .B ( n1990 ) , .Y ( n2009 ) ) ;
OR2X1 U9 ( .A ( n1989 ) , .B ( n1988 ) , .Y ( n1996 ) ) ;
OAI21XL U10 ( .A0 ( n1693 ) , .A1 ( n2076 ) , .B0 ( n315 ) , .Y ( n1696 ) ) ;
INVX4 HFSINV_1604_607 ( .A ( n55 ) , .Y ( HFSNET_345 ) ) ;
AOI21XL U12 ( .A0 ( n1552 ) , .A1 ( n1551 ) , .B0 ( n1550 ) , .Y ( n1578 ) ) ;
INVXL U13 ( .A ( n829 ) , .Y ( n559 ) ) ;
NOR2X1 U14 ( .A ( n665 ) , .B ( n664 ) , .Y ( N1823 ) ) ;
INVXL U16 ( .A ( N1822 ) , .Y ( n815 ) ) ;
NOR2XL U17 ( .A ( sar_ptr[0] ) , .B ( sar_ptr[1] ) , .Y ( n2112 ) ) ;
OAI21XL U18 ( .A0 ( n739 ) , .A1 ( n738 ) , .B0 ( n737 ) , .Y ( n981 ) ) ;
OAI21XL U19 ( .A0 ( n1113 ) , .A1 ( n1112 ) , .B0 ( n1111 ) , .Y ( n1224 ) ) ;
OAI21XL U20 ( .A0 ( n1839 ) , .A1 ( n1849 ) , .B0 ( n1840 ) , .Y ( n1828 ) ) ;
CLKINVX3 U21 ( .A ( n1322 ) , .Y ( n1687 ) ) ;
OAI21XL U23 ( .A0 ( n547 ) , .A1 ( n551 ) , .B0 ( n552 ) , .Y ( n492 ) ) ;
OAI21XL U24 ( .A0 ( n218 ) , .A1 ( n101 ) , .B0 ( n100 ) , .Y ( n110 ) ) ;
OAI21XL U25 ( .A0 ( n449 ) , .A1 ( n447 ) , .B0 ( n450 ) , .Y ( n467 ) ) ;
OAI21XL U26 ( .A0 ( n159 ) , .A1 ( n215 ) , .B0 ( n160 ) , .Y ( n145 ) ) ;
OAI21XL U27 ( .A0 ( n524 ) , .A1 ( n532 ) , .B0 ( n525 ) , .Y ( n591 ) ) ;
OAI21XL U28 ( .A0 ( n111 ) , .A1 ( n155 ) , .B0 ( n112 ) , .Y ( n103 ) ) ;
OAI21XL U29 ( .A0 ( n337 ) , .A1 ( n336 ) , .B0 ( n335 ) , .Y ( n359 ) ) ;
INVXL U30 ( .A ( n618 ) , .Y ( n557 ) ) ;
OAI21XL U31 ( .A0 ( n168 ) , .A1 ( n172 ) , .B0 ( n169 ) , .Y ( n174 ) ) ;
XOR2XL U32 ( .A ( n218 ) , .B ( n217 ) , .Y ( n1904 ) ) ;
NAND2BXL ctmTdsLR_1_965 ( .AN ( n218 ) , .B ( n144 ) , .Y ( tmp_net209 ) ) ;
XNOR2XL U34 ( .A ( n213 ) , .B ( n212 ) , .Y ( n1913 ) ) ;
XNOR2XL U35 ( .A ( n185 ) , .B ( n184 ) , .Y ( n1949 ) ) ;
XNOR2XL U36 ( .A ( n283 ) , .B ( n270 ) , .Y ( n272 ) ) ;
XNOR2XL U37 ( .A ( n264 ) , .B ( n259 ) , .Y ( n1716 ) ) ;
NAND2BXL ctmTdsLR_2_966 ( .AN ( n145 ) , .B ( tmp_net209 ) , .Y ( n167 ) ) ;
XOR2XL U39 ( .A ( n1792 ) , .B ( n1791 ) , .Y ( n1796 ) ) ;
XNOR2XL U40 ( .A ( n1552 ) , .B ( n1496 ) , .Y ( n1497 ) ) ;
XOR2X1 ctmTdsLR_1_2030 ( .A ( tmp_net208 ) , .B ( tmp_net444 ) , 
    .Y ( n1021 ) ) ;
OAI221XL U42 ( .A0 ( N1837 ) , .A1 ( overrange_bits[5] ) , 
    .B0 ( HFSNET_273 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n712 ) ) ;
INVXL U43 ( .A ( N1823 ) , .Y ( n823 ) ) ;
CLKINVX4 HFSINV_10161_614 ( .A ( HFSNET_382 ) , .Y ( HFSNET_352 ) ) ;
INVX3 HFSINV_10018_615 ( .A ( HFSNET_382 ) , .Y ( HFSNET_353 ) ) ;
INVX4 HFSINV_3239_610 ( .A ( n1875 ) , .Y ( HFSNET_348 ) ) ;
NAND2XL U47 ( .A ( n1556 ) , .B ( HFSNET_347 ) , .Y ( n930 ) ) ;
OAI21XL ctmTdsLR_1_2010 ( .A0 ( n1466 ) , .A1 ( n1414 ) , .B0 ( tmp_net433 ) , 
    .Y ( n1415 ) ) ;
NAND2XL U49 ( .A ( n1497 ) , .B ( HFSNET_347 ) , .Y ( n931 ) ) ;
NAND2XL U50 ( .A ( n1625 ) , .B ( n1875 ) , .Y ( n2339 ) ) ;
XOR2X1 U51 ( .A ( n1565 ) , .B ( n1564 ) , .Y ( n1567 ) ) ;
AND2XL ctmTdsLR_4_1929_roptpi_2088 ( .A ( HFSNET_345 ) , .B ( n2215 ) , 
    .Y ( tmp_net388 ) ) ;
INVXL U54 ( .A ( n276 ) , .Y ( n277 ) ) ;
AOI22XL ctmTdsLR_1_699 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][26] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][26] ) , 
    .Y ( tmp_net31 ) ) ;
NAND2XL ctmTdsLR_1_1857_roptpi_2089 ( .A ( n813 ) , .B ( n811 ) , 
    .Y ( tmp_net213 ) ) ;
NAND3XL ctmTdsLR_1_1959 ( .A ( tmp_net191 ) , .B ( n1036 ) , 
    .C ( tmp_net406 ) , .Y ( HFSNET_132 ) ) ;
XOR2X1 U58 ( .A ( n1821 ) , .B ( n1820 ) , .Y ( n1826 ) ) ;
NOR2XL U59 ( .A ( n1716 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1717 ) ) ;
OAI21XL U60 ( .A0 ( n1852 ) , .A1 ( n1781 ) , .B0 ( n1780 ) , .Y ( n1807 ) ) ;
NAND2XL U61 ( .A ( n1499 ) , .B ( n1388 ) , .Y ( n1503 ) ) ;
OAI21XL U62 ( .A0 ( n1762 ) , .A1 ( n1771 ) , .B0 ( n1763 ) , .Y ( n1750 ) ) ;
OAI21XL U63 ( .A0 ( n1508 ) , .A1 ( n1525 ) , .B0 ( n1509 ) , .Y ( n1568 ) ) ;
NAND2XL U64 ( .A ( n1835 ) , .B ( \shadow_weights[18][15] ) , .Y ( n1831 ) ) ;
AOI211XL U65 ( .A0 ( HFSNET_345 ) , .A1 ( n2225 ) , .B0 ( n1845 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1846 ) ) ;
NOR2XL U66 ( .A ( HFSNET_155 ) , .B ( temp_acc[27] ) , .Y ( n1607 ) ) ;
NAND2XL U67 ( .A ( HFSNET_128 ) , .B ( temp_acc[1] ) , .Y ( n737 ) ) ;
INVXL U68 ( .A ( n2119 ) , .Y ( n2122 ) ) ;
INVXL U69 ( .A ( n2093 ) , .Y ( n2096 ) ) ;
AOI211XL U70 ( .A0 ( HFSNET_345 ) , .A1 ( n2218 ) , .B0 ( n1854 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1855 ) ) ;
AOI211XL U71 ( .A0 ( HFSNET_345 ) , .A1 ( n2226 ) , .B0 ( n1866 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1867 ) ) ;
INVXL U72 ( .A ( n1917 ) , .Y ( n1930 ) ) ;
NAND2XL ctmTdsLR_1_693 ( .A ( n440 ) , .B ( HFSNET_347 ) , .Y ( HFSNET_10 ) ) ;
NOR2XL U74 ( .A ( n1908 ) , .B ( n1899 ) , .Y ( n220 ) ) ;
NAND2XL U75 ( .A ( n1894 ) , .B ( HFSNET_244 ) , .Y ( n1890 ) ) ;
AOI211XL U76 ( .A0 ( HFSNET_345 ) , .A1 ( n2216 ) , .B0 ( n1932 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1933 ) ) ;
CLKINVX4 HFSINV_9538_616 ( .A ( HFSNET_382 ) , .Y ( HFSNET_354 ) ) ;
OR2XL U78 ( .A ( n1931 ) , .B ( \shadow_weights[18][5] ) , .Y ( n1928 ) ) ;
CLKINVX4 HFSINV_8799_617 ( .A ( HFSNET_382 ) , .Y ( HFSNET_355 ) ) ;
INVXL U80 ( .A ( n1626 ) , .Y ( n1628 ) ) ;
AND4XL ctmTdsLR_3_2083_roptpi_2090 ( .A ( tmp_net17 ) , .B ( tmp_net19 ) , 
    .C ( tmp_net20 ) , .D ( tmp_net18 ) , .Y ( tmp_net470 ) ) ;
NOR2XL U82 ( .A ( n1949 ) , .B ( \shadow_weights[18][3] ) , .Y ( n1944 ) ) ;
NAND2XL U83 ( .A ( n1875 ) , .B ( n1985 ) , .Y ( n2068 ) ) ;
CLKINVX4 HFSINV_7962_618 ( .A ( HFSNET_382 ) , .Y ( HFSNET_356 ) ) ;
CLKINVX8 HFSINV_7345_619 ( .A ( HFSNET_382 ) , .Y ( HFSNET_357 ) ) ;
AOI21XL U86 ( .A0 ( n399 ) , .A1 ( n591 ) , .B0 ( n398 ) , .Y ( n400 ) ) ;
CLKINVX8 HFSINV_2011_608 ( .A ( n292 ) , .Y ( HFSNET_346 ) ) ;
AOI22XL U88 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( protected_sar_code[12] ) , 
    .B0 ( n1669 ) , .B1 ( protected_sar_code[8] ) , .Y ( n1675_CDR2 ) ) ;
OAI2BB1XL ctmTdsLR_1_906 ( .A0N ( n192 ) , .A1N ( n200 ) , .B0 ( n190 ) , 
    .Y ( tmp_net170 ) ) ;
CLKINVX8 HFSINV_7499_620 ( .A ( HFSNET_382 ) , .Y ( HFSNET_358 ) ) ;
CLKINVX4 HFSINV_7042_621 ( .A ( HFSNET_382 ) , .Y ( HFSNET_359 ) ) ;
INVX4 HFSINV_6657_622 ( .A ( HFSNET_382 ) , .Y ( HFSNET_360 ) ) ;
CLKINVX8 HFSINV_6844_623 ( .A ( HFSNET_382 ) , .Y ( HFSNET_361 ) ) ;
INVXL gre_a_INV_302_inst_2154 ( .A ( gre_a_INV_1788_54 ) , 
    .Y ( gre_a_INV_302_54 ) ) ;
INVXL U95 ( .A ( n581 ) , .Y ( n582 ) ) ;
INVXL U96 ( .A ( n508 ) , .Y ( n509 ) ) ;
OR2XL U97 ( .A ( n463 ) , .B ( n462 ) , .Y ( n510 ) ) ;
NAND2XL U98 ( .A ( n393 ) , .B ( n392 ) , .Y ( n525 ) ) ;
INVXL U99 ( .A ( n106 ) , .Y ( n118 ) ) ;
INVXL U100 ( .A ( n140 ) , .Y ( n90 ) ) ;
INVXL U101 ( .A ( n131 ) , .Y ( n126 ) ) ;
NAND2XL U102 ( .A ( n371 ) , .B ( n370 ) , .Y ( n480 ) ) ;
CLKINVX4 HFSINV_6480_624 ( .A ( HFSNET_382 ) , .Y ( HFSNET_362 ) ) ;
OR2XL U104 ( .A ( temp_acc[17] ) , .B ( \shadow_weights[17][17] ) , 
    .Y ( n128 ) ) ;
NAND2XL U105 ( .A ( temp_acc[19] ) , .B ( \shadow_weights[17][19] ) , 
    .Y ( n136 ) ) ;
OR2XL U106 ( .A ( temp_acc[20] ) , .B ( \shadow_weights[17][20] ) , 
    .Y ( n242 ) ) ;
OR2XL U107 ( .A ( temp_acc[24] ) , .B ( \shadow_weights[17][24] ) , 
    .Y ( n252 ) ) ;
OR2XL U108 ( .A ( temp_acc[22] ) , .B ( \shadow_weights[17][22] ) , 
    .Y ( n233 ) ) ;
NAND2XL U109 ( .A ( temp_acc[5] ) , .B ( \shadow_weights[17][5] ) , 
    .Y ( n194 ) ) ;
NAND2XL U110 ( .A ( temp_acc[18] ) , .B ( \shadow_weights[17][18] ) , 
    .Y ( n140 ) ) ;
NOR2XL U111 ( .A ( n2171 ) , .B ( state[1] ) , .Y ( n654 ) ) ;
XOR2X1 U112 ( .A ( n1495 ) , .B ( n1147 ) , .Y ( n1148 ) ) ;
NOR2XL U113 ( .A ( n293 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n294 ) ) ;
NOR2XL U114 ( .A ( n272 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n273 ) ) ;
AOI21XL U115 ( .A0 ( n1800 ) , .A1 ( n1798 ) , .B0 ( n1787 ) , .Y ( n1792 ) ) ;
NOR2XL U116 ( .A ( n1708 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1709 ) ) ;
INVXL U117 ( .A ( n1712 ) , .Y ( n260 ) ) ;
OAI21XL U118 ( .A0 ( n1423 ) , .A1 ( n1422 ) , .B0 ( n1421 ) , .Y ( n1442 ) ) ;
AOI211XL U119 ( .A0 ( HFSNET_345 ) , .A1 ( n2211 ) , .B0 ( n1726 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1727 ) ) ;
AOI211XL U120 ( .A0 ( HFSNET_345 ) , .A1 ( n2212 ) , .B0 ( n1737 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1738 ) ) ;
OAI21XL U121 ( .A0 ( n1780 ) , .A1 ( n229 ) , .B0 ( n228 ) , .Y ( n230 ) ) ;
NOR2XL U122 ( .A ( n1233 ) , .B ( n1422 ) , .Y ( n1236 ) ) ;
AOI211XL U124 ( .A0 ( HFSNET_345 ) , .A1 ( n2229 ) , .B0 ( n1836 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1837 ) ) ;
OR2XL U125 ( .A ( HFSNET_157 ) , .B ( temp_acc[28] ) , .Y ( n1632 ) ) ;
XNOR2X1 ctmTdsLR_2_907 ( .A ( tmp_net170 ) , .B ( n196 ) , .Y ( n1931 ) ) ;
INVXL U127 ( .A ( n1760 ) , .Y ( n1772 ) ) ;
NOR2XL U130 ( .A ( n1835 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1836 ) ) ;
OAI21XL U131 ( .A0 ( n1426 ) , .A1 ( n1443 ) , .B0 ( n1427 ) , .Y ( n1486 ) ) ;
NOR2XL U132 ( .A ( HFSNET_166 ) , .B ( temp_acc[25] ) , .Y ( n1530 ) ) ;
NOR2XL U133 ( .A ( HFSNET_171 ) , .B ( temp_acc[12] ) , .Y ( n1424 ) ) ;
NOR2XL U134 ( .A ( copt_gre_net_480 ) , .B ( temp_acc[14] ) , .Y ( n1490 ) ) ;
OR2XL U135 ( .A ( n2131 ) , .B ( n2100 ) , .Y ( n318 ) ) ;
AOI211XL U136 ( .A0 ( HFSNET_345 ) , .A1 ( n2203 ) , .B0 ( n1794 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1795 ) ) ;
AOI211XL U137 ( .A0 ( HFSNET_345 ) , .A1 ( n2231 ) , .B0 ( n1814 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1816 ) ) ;
AOI211XL U138 ( .A0 ( HFSNET_345 ) , .A1 ( n2230 ) , .B0 ( n1914 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1915 ) ) ;
AOI211XL U139 ( .A0 ( HFSNET_345 ) , .A1 ( n2227 ) , .B0 ( n1887 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1888 ) ) ;
NOR2XL U140 ( .A ( n1793 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1794 ) ) ;
INVXL U141 ( .A ( n1786 ) , .Y ( n1798 ) ) ;
AOI211XL U142 ( .A0 ( HFSNET_345 ) , .A1 ( n2232 ) , .B0 ( n1824 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1825 ) ) ;
NOR2XL U143 ( .A ( n1801 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1802 ) ) ;
AOI211XL U144 ( .A0 ( HFSNET_345 ) , .A1 ( n2223 ) , .B0 ( n1905 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1906 ) ) ;
NOR2XL U145 ( .A ( n1823 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1824 ) ) ;
NAND2XL U146 ( .A ( n2099 ) , .B ( sar_ptr[2] ) , .Y ( n2110 ) ) ;
NOR2XL U147 ( .A ( n1886 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1887 ) ) ;
OAI21XL U148 ( .A0 ( n521 ) , .A1 ( n520 ) , .B0 ( n519 ) , .Y ( n531 ) ) ;
NAND2XL U149 ( .A ( n1656 ) , .B ( n1982 ) , .Y ( N1608 ) ) ;
CLKINVX8 HFSINV_6348_625 ( .A ( HFSNET_382 ) , .Y ( HFSNET_363 ) ) ;
CLKINVX4 HFSINV_10702_626 ( .A ( HFSNET_382 ) , .Y ( HFSNET_364 ) ) ;
CLKINVX8 HFSINV_1575_628 ( .A ( HFSNET_382 ) , .Y ( HFSNET_366 ) ) ;
CLKINVX4 HFSINV_717_629 ( .A ( HFSNET_382 ) , .Y ( HFSNET_367 ) ) ;
CLKINVX8 HFSINV_1073_630 ( .A ( HFSNET_382 ) , .Y ( HFSNET_368 ) ) ;
CLKINVX8 HFSINV_907_631 ( .A ( HFSNET_382 ) , .Y ( HFSNET_369 ) ) ;
CLKINVX8 HFSINV_555_632 ( .A ( HFSNET_382 ) , .Y ( HFSNET_370 ) ) ;
CLKINVX2 HFSINV_4293_634 ( .A ( HFSNET_382 ) , .Y ( HFSNET_372 ) ) ;
AOI211XL U158 ( .A0 ( HFSNET_345 ) , .A1 ( n2221 ) , .B0 ( HFSNET_348 ) , 
    .C0 ( n1966 ) , .Y ( n1967 ) ) ;
AOI211XL U159 ( .A0 ( HFSNET_345 ) , .A1 ( n2222 ) , .B0 ( HFSNET_348 ) , 
    .C0 ( n1973 ) , .Y ( n1975 ) ) ;
CLKINVX8 HFSINV_2284_635 ( .A ( HFSNET_382 ) , .Y ( HFSNET_373 ) ) ;
OR2XL U161 ( .A ( n1939 ) , .B ( \shadow_weights[18][4] ) , .Y ( n1936 ) ) ;
CLKINVX2 U162 ( .A ( n2118 ) , .Y ( n2134 ) ) ;
CLKINVX8 HFSINV_2457_636 ( .A ( HFSNET_382 ) , .Y ( HFSNET_374 ) ) ;
CLKINVX4 HFSINV_2739_637 ( .A ( HFSNET_382 ) , .Y ( HFSNET_375 ) ) ;
CLKINVX4 HFSINV_2589_638 ( .A ( HFSNET_382 ) , .Y ( HFSNET_376 ) ) ;
CLKINVX8 HFSINV_2970_639 ( .A ( HFSNET_382 ) , .Y ( HFSNET_377 ) ) ;
CLKINVX4 HFSINV_3411_640 ( .A ( HFSNET_382 ) , .Y ( HFSNET_378 ) ) ;
OR2XL U168 ( .A ( n1957 ) , .B ( \shadow_weights[18][2] ) , .Y ( n1954 ) ) ;
CLKINVX8 gre_a_INV_6610_inst_2186 ( .A ( n1305 ) , .Y ( gre_a_INV_6610_58 ) ) ;
CLKINVX8 HFSINV_2119_641 ( .A ( HFSNET_382 ) , .Y ( HFSNET_379 ) ) ;
NAND2XL U171 ( .A ( n579 ) , .B ( wait_cnt[4] ) , .Y ( n474 ) ) ;
INVXL U172 ( .A ( n2032 ) , .Y ( n2012 ) ) ;
AND2X1 U173 ( .A ( n55 ) , .B ( n2163 ) , .Y ( n1735 ) ) ;
NAND2XL ctmTdsLR_1_967 ( .A ( n126 ) , .B ( n128 ) , .Y ( tmp_net210 ) ) ;
CLKINVX8 gre_a_INV_5313_inst_2188 ( .A ( n1301 ) , .Y ( gre_a_INV_5313_58 ) ) ;
INVX4 U177 ( .A ( n1320 ) , .Y ( n1290 ) ) ;
BUFXL ropt_mt_inst_2191 ( .A ( n1192_CDR1 ) , .Y ( ropt_net_504 ) ) ;
CLKINVX3 U179 ( .A ( n1308 ) , .Y ( n1278 ) ) ;
CLKINVX4 HFSINV_4670_642 ( .A ( HFSNET_382 ) , .Y ( HFSNET_380 ) ) ;
NAND2BXL ctmTdsLR_1_648 ( .AN ( HFSNET_285 ) , .B ( n102 ) , .Y ( tmp_net1 ) ) ;
NAND2BXL ctmTdsLR_2_649 ( .AN ( n103 ) , .B ( tmp_net1 ) , .Y ( n119 ) ) ;
NAND2XL ctmTdsLR_1_650 ( .A ( n2058 ) , .B ( protected_sar_code[1] ) , 
    .Y ( tmp_net2 ) ) ;
OAI221XL ctmTdsLR_2_651 ( .A0 ( n2049 ) , .A1 ( n2181 ) , .B0 ( n2046 ) , 
    .B1 ( n2183 ) , .C0 ( tmp_net2 ) , .Y ( n2064_CDR2 ) ) ;
CLKINVX8 gre_a_INV_6625_inst_2189 ( .A ( n993 ) , .Y ( gre_a_INV_6625_58 ) ) ;
INVXL U186 ( .A ( n692 ) , .Y ( n693 ) ) ;
INVX4 gre_a_INV_1788_inst_2155 ( .A ( calc_result_r[11] ) , 
    .Y ( gre_a_INV_1788_54 ) ) ;
NOR2XL U188 ( .A ( n2073 ) , .B ( n2031 ) , .Y ( n2032 ) ) ;
INVXL U189 ( .A ( n811 ) , .Y ( n812 ) ) ;
OAI211XL ctmTdsLR_1_652 ( .A0 ( HFSNET_127 ) , .A1 ( temp_acc[0] ) , 
    .B0 ( n738 ) , .C0 ( n1875 ) , .Y ( n2308 ) ) ;
AOI222XL ctmTdsLR_1_653 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][23] ) , 
    .B0 ( n1687 ) , .B1 ( \shadow_weights[2][23] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][23] ) , .Y ( tmp_net3 ) ) ;
CLKINVX8 gre_a_INV_6238_inst_2187 ( .A ( n1297 ) , .Y ( gre_a_INV_6238_58 ) ) ;
CLKINVX8 HFSINV_1142_609 ( .A ( n322 ) , .Y ( HFSNET_347 ) ) ;
NOR2X1 U194 ( .A ( n824 ) , .B ( n2194 ) , .Y ( n1081 ) ) ;
INVXL U195 ( .A ( n241 ) , .Y ( n91 ) ) ;
NOR2XL U196 ( .A ( n718 ) , .B ( n696 ) , .Y ( n805 ) ) ;
OR2XL U197 ( .A ( n420 ) , .B ( n419 ) , .Y ( n434 ) ) ;
INVXL U198 ( .A ( n2112 ) , .Y ( n2100 ) ) ;
INVXL U200 ( .A ( n261 ) , .Y ( n262 ) ) ;
NOR2XL U201 ( .A ( n586 ) , .B ( n585 ) , .Y ( n643 ) ) ;
NAND2BXL U202 ( .AN ( wait_cnt[2] ) , .B ( n1984 ) , .Y ( n580 ) ) ;
NOR2XL U203 ( .A ( n513 ) , .B ( n512 ) , .Y ( n562 ) ) ;
INVXL U204 ( .A ( n250 ) , .Y ( n251 ) ) ;
INVXL U205 ( .A ( n232 ) , .Y ( n92 ) ) ;
NAND2XL ctmTdsLR_2_654 ( .A ( n1319 ) , .B ( \shadow_weights[13][23] ) , 
    .Y ( tmp_net4 ) ) ;
NAND4XL ctmTdsLR_3_655 ( .A ( tmp_net3 ) , .B ( n1382_CDR2 ) , .C ( n1379 ) , 
    .D ( tmp_net4 ) , .Y ( HFSNET_161 ) ) ;
INVXL ctmTdsLR_1_656 ( .A ( n550 ) , .Y ( tmp_net5 ) ) ;
OAI21XL ctmTdsLR_2_657 ( .A0 ( tmp_net5 ) , .A1 ( n546 ) , .B0 ( n547 ) , 
    .Y ( tmp_net6 ) ) ;
OAI21XL ctmTdsLR_1_1936 ( .A0 ( n1893 ) , .A1 ( n1892 ) , .B0 ( tmp_net393 ) , 
    .Y ( n1897 ) ) ;
OAI2BB1XL ctmTdsLR_1_659 ( .A0N ( n501 ) , .A1N ( n550 ) , .B0 ( n499 ) , 
    .Y ( tmp_net7 ) ) ;
XNOR2X1 ctmTdsLR_2_660 ( .A ( tmp_net7 ) , .B ( n505 ) , .Y ( n507 ) ) ;
NAND2BXL ctmTdsLR_1_661 ( .AN ( n594 ) , .B ( n590 ) , .Y ( tmp_net8 ) ) ;
NAND2XL U214 ( .A ( n654 ) , .B ( n297 ) , .Y ( n968 ) ) ;
NOR2XL U215 ( .A ( target_bit[0] ) , .B ( n2179 ) , .Y ( n2006 ) ) ;
NAND2XL U216 ( .A ( temp_acc[22] ) , .B ( \shadow_weights[17][22] ) , 
    .Y ( n232 ) ) ;
OR2XL U217 ( .A ( n2198 ) , .B ( accumulator[32] ) , .Y ( n1551 ) ) ;
NOR2XL U218 ( .A ( temp_acc[19] ) , .B ( \shadow_weights[17][19] ) , 
    .Y ( n135 ) ) ;
NAND2XL U219 ( .A ( temp_acc[24] ) , .B ( \shadow_weights[17][24] ) , 
    .Y ( n250 ) ) ;
NAND2XL U220 ( .A ( temp_acc[20] ) , .B ( \shadow_weights[17][20] ) , 
    .Y ( n241 ) ) ;
NAND2XL U221 ( .A ( temp_acc[25] ) , .B ( \shadow_weights[17][25] ) , 
    .Y ( n256 ) ) ;
OR2XL U222 ( .A ( n2195 ) , .B ( accumulator[30] ) , .Y ( n1144 ) ) ;
NOR2XL U223 ( .A ( temp_acc[27] ) , .B ( \shadow_weights[17][27] ) , 
    .Y ( n268 ) ) ;
NAND2XL U224 ( .A ( temp_acc[21] ) , .B ( \shadow_weights[17][21] ) , 
    .Y ( n237 ) ) ;
NAND2XL U225 ( .A ( temp_acc[23] ) , .B ( \shadow_weights[17][23] ) , 
    .Y ( n95 ) ) ;
OR2XL U226 ( .A ( temp_acc[28] ) , .B ( \shadow_weights[17][28] ) , 
    .Y ( n282 ) ) ;
NOR2XL U227 ( .A ( temp_acc[21] ) , .B ( \shadow_weights[17][21] ) , 
    .Y ( n236 ) ) ;
NAND2BXL ctmTdsLR_2_662 ( .AN ( n591 ) , .B ( tmp_net8 ) , .Y ( n604 ) ) ;
NAND2XL U229 ( .A ( n1575 ) , .B ( n1875 ) , .Y ( n2333 ) ) ;
NAND2XL U230 ( .A ( n1605 ) , .B ( n1875 ) , .Y ( n2338 ) ) ;
AOI21XL ctmTdsLR_1_2067 ( .A0 ( n1922 ) , .A1 ( n1921 ) , .B0 ( tmp_net463 ) , 
    .Y ( n1926 ) ) ;
NAND2XL U232 ( .A ( n1567 ) , .B ( n1875 ) , .Y ( n2323 ) ) ;
NAND2XL U233 ( .A ( n1528 ) , .B ( n1875 ) , .Y ( n2331 ) ) ;
NAND2XL U234 ( .A ( n1522 ) , .B ( n1875 ) , .Y ( n2330 ) ) ;
NAND2XL U235 ( .A ( n1492 ) , .B ( n1875 ) , .Y ( n2322 ) ) ;
NAND2XL U236 ( .A ( n1548 ) , .B ( n1875 ) , .Y ( n2337 ) ) ;
NAND2XL U237 ( .A ( n1513 ) , .B ( n1875 ) , .Y ( n2332 ) ) ;
NAND2XL U238 ( .A ( n1148 ) , .B ( HFSNET_347 ) , .Y ( n932 ) ) ;
NAND2XL U239 ( .A ( n1431 ) , .B ( n1875 ) , .Y ( n2321 ) ) ;
OAI21XL ctmTdsLR_1_2044 ( .A0 ( n1938 ) , .A1 ( n1937 ) , .B0 ( tmp_net451 ) , 
    .Y ( n1943 ) ) ;
AOI21XL U241 ( .A0 ( n1570 ) , .A1 ( n1569 ) , .B0 ( n1568 ) , .Y ( n1574 ) ) ;
NAND2XL U242 ( .A ( n1462 ) , .B ( n1875 ) , .Y ( n2334 ) ) ;
NAND2XL U243 ( .A ( n1455 ) , .B ( n1875 ) , .Y ( n2325 ) ) ;
AOI21XL U244 ( .A0 ( n1560 ) , .A1 ( n1559 ) , .B0 ( n1558 ) , .Y ( n1565 ) ) ;
AND2XL ctmTdsLR_2_939_roptpi_2091 ( .A ( n1319 ) , 
    .B ( \shadow_weights[13][6] ) , .Y ( tmp_net192 ) ) ;
NAND2XL U246 ( .A ( n1502 ) , .B ( n1875 ) , .Y ( n2329 ) ) ;
NOR2XL ctmTdsLR_2_2068 ( .A ( n1922 ) , .B ( n1921 ) , .Y ( tmp_net463 ) ) ;
NAND2XL U248 ( .A ( n1484 ) , .B ( n1875 ) , .Y ( n2336 ) ) ;
AOI21XL ctmTdsLR_1_2069 ( .A0 ( n1574 ) , .A1 ( n1573 ) , .B0 ( tmp_net464 ) , 
    .Y ( n1575 ) ) ;
NAND2XL ctmTdsLR_2_2045 ( .A ( n1938 ) , .B ( n1937 ) , .Y ( tmp_net451 ) ) ;
NAND2XL U251 ( .A ( n1446 ) , .B ( n1875 ) , .Y ( n2320 ) ) ;
NAND2XL U253 ( .A ( n1084 ) , .B ( HFSNET_347 ) , .Y ( n933 ) ) ;
NAND2XL U254 ( .A ( n1441 ) , .B ( n1875 ) , .Y ( n2319 ) ) ;
NAND2XL U255 ( .A ( n1415 ) , .B ( n1875 ) , .Y ( n2335 ) ) ;
OR4XL ctmTdsLR_1_1926 ( .A ( tmp_net387 ) , .B ( n1895 ) , .C ( HFSNET_348 ) , 
    .D ( tmp_net388 ) , .Y ( n914 ) ) ;
NOR2XL ctmTdsLR_2_2070 ( .A ( n1574 ) , .B ( n1573 ) , .Y ( tmp_net464 ) ) ;
OAI2BB1XL ctmTdsLR_1_682 ( .A0N ( n118 ) , .A1N ( n119 ) , .B0 ( n116 ) , 
    .Y ( tmp_net22 ) ) ;
NAND2XL U261 ( .A ( n1132 ) , .B ( n1875 ) , .Y ( n2318 ) ) ;
NAND2XL U262 ( .A ( n1141 ) , .B ( n1875 ) , .Y ( n2315 ) ) ;
NAND2XL U263 ( .A ( n1420 ) , .B ( n1875 ) , .Y ( n2324 ) ) ;
NAND2BXL ctmTdsLR_1_980 ( .AN ( n521 ) , .B ( n466 ) , .Y ( tmp_net217 ) ) ;
XOR2XL U265 ( .A ( n1531 ) , .B ( n1483 ) , .Y ( n1484 ) ) ;
XNOR2XL U266 ( .A ( n1715 ) , .B ( n1714 ) , .Y ( n1719 ) ) ;
BUFXL ZBUF_2_inst_2092 ( .A ( tmp_net100 ) , .Y ( ZBUF_2_0 ) ) ;
NAND2BXL ctmTdsLR_2_981 ( .AN ( n467 ) , .B ( tmp_net217 ) , .Y ( n539 ) ) ;
INVXL gre_a_INV_6_inst_2156 ( .A ( gre_a_INV_1970_54 ) , 
    .Y ( gre_a_INV_6_54 ) ) ;
NAND2XL U270 ( .A ( n1109 ) , .B ( n1875 ) , .Y ( n2317 ) ) ;
XNOR2XL U271 ( .A ( n1145 ) , .B ( n1083 ) , .Y ( n1084 ) ) ;
XOR2XL U272 ( .A ( n1489 ) , .B ( n1445 ) , .Y ( n1446 ) ) ;
NAND2XL ctmTdsLR_2_2011 ( .A ( n1466 ) , .B ( n1414 ) , .Y ( tmp_net433 ) ) ;
OAI211XL ctmTdsLR_2_968 ( .A0 ( n125 ) , .A1 ( n89 ) , .B0 ( tmp_net210 ) , 
    .C0 ( n127 ) , .Y ( n143 ) ) ;
XNOR2X1 ctmTdsLR_2_683 ( .A ( tmp_net22 ) , .B ( n123 ) , .Y ( n1835 ) ) ;
AOI211XL U277 ( .A0 ( HFSNET_345 ) , .A1 ( n2209 ) , .B0 ( n1709 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1710 ) ) ;
NAND2XL ctmTdsLR_1_1975 ( .A ( tmp_net414 ) , .B ( n617 ) , 
    .Y ( tmp_net342 ) ) ;
AOI21XL U279 ( .A0 ( HFSNET_293 ) , .A1 ( n1457 ) , .B0 ( n1456 ) , 
    .Y ( n1461 ) ) ;
NAND2XL U280 ( .A ( n1090 ) , .B ( n1875 ) , .Y ( n2314 ) ) ;
NOR2XL ctmTdsLR_2_1927 ( .A ( n1897 ) , .B ( HFSNET_346 ) , 
    .Y ( tmp_net387 ) ) ;
NAND2XL ctmTdsLR_1_982 ( .A ( n492 ) , .B ( n495 ) , .Y ( tmp_net218 ) ) ;
NOR2BX1 ctmTdsLR_2_2031 ( .AN ( n1052 ) , .B ( n1054 ) , .Y ( tmp_net444 ) ) ;
XOR2XL U284 ( .A ( n1082 ) , .B ( n974 ) , .Y ( n975 ) ) ;
AOI21XL U285 ( .A0 ( n1466 ) , .A1 ( n1465 ) , .B0 ( n1464 ) , .Y ( n1531 ) ) ;
AOI21XL ctmTdsLR_1_2046 ( .A0 ( tmp_net219 ) , .A1 ( tmp_net419 ) , 
    .B0 ( tmp_net453 ) , .Y ( n431 ) ) ;
NAND2XL U287 ( .A ( n1079 ) , .B ( n1875 ) , .Y ( n2316 ) ) ;
NAND2XL U288 ( .A ( n1021 ) , .B ( n1875 ) , .Y ( n2313 ) ) ;
INVX4 gre_a_INV_2893_inst_2182 ( .A ( n729 ) , .Y ( gre_a_INV_2893_58 ) ) ;
OAI21XL ctmTdsLR_1_2012 ( .A0 ( tmp_net21 ) , .A1 ( n1453 ) , 
    .B0 ( tmp_net435 ) , .Y ( n1455 ) ) ;
XOR2XL U291 ( .A ( n1135 ) , .B ( n1089 ) , .Y ( n1090 ) ) ;
OAI21XL ctmTdsLR_1_2071 ( .A0 ( n1560 ) , .A1 ( n1491 ) , .B0 ( tmp_net465 ) , 
    .Y ( n1492 ) ) ;
NAND2XL U293 ( .A ( n803 ) , .B ( n1875 ) , .Y ( n2311 ) ) ;
INVXL HFSINV_250_554 ( .A ( n1417 ) , .Y ( HFSNET_293 ) ) ;
NAND2XL U295 ( .A ( n1713 ) , .B ( n1712 ) , .Y ( n1714 ) ) ;
MX2XL ctmTdsLR_1_969 ( .A ( n725 ) , .B ( n663 ) , .S0 ( comp_out_rr ) , 
    .Y ( HFSNET_117 ) ) ;
XOR2XL U297 ( .A ( n1423 ) , .B ( n1078 ) , .Y ( n1079 ) ) ;
AOI222XL ctmTdsLR_1_970 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][22] ) , 
    .B0 ( n1687 ) , .B1 ( \shadow_weights[2][22] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][22] ) , .Y ( tmp_net211 ) ) ;
XNOR2XL U299 ( .A ( n1774 ) , .B ( n1773 ) , .Y ( n1778 ) ) ;
AOI21XL U300 ( .A0 ( n1774 ) , .A1 ( n1751 ) , .B0 ( n1750 ) , .Y ( n1755 ) ) ;
OAI211XL ctmTdsLR_2_983 ( .A0 ( n455 ) , .A1 ( n418 ) , .B0 ( tmp_net218 ) , 
    .C0 ( n494 ) , .Y ( n435 ) ) ;
AOI211XL U303 ( .A0 ( HFSNET_345 ) , .A1 ( n2210 ) , .B0 ( n1717 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1718 ) ) ;
OAI21XL ctmTdsLR_1_1916 ( .A0 ( n1903 ) , .A1 ( n1902 ) , .B0 ( tmp_net383 ) , 
    .Y ( n1907 ) ) ;
NAND2XL U305 ( .A ( n1000 ) , .B ( n1875 ) , .Y ( n2312 ) ) ;
NAND2XL U306 ( .A ( n778 ) , .B ( n1875 ) , .Y ( n2310 ) ) ;
XNOR2XL U307 ( .A ( n1087 ) , .B ( n999 ) , .Y ( n1000 ) ) ;
NAND2XL ctmTdsLR_2_971 ( .A ( n1319 ) , .B ( \shadow_weights[13][22] ) , 
    .Y ( tmp_net212 ) ) ;
NAND2XL U309 ( .A ( n1457 ) , .B ( n1459 ) , .Y ( n1398 ) ) ;
AOI221XL ctmTdsLR_1_1737 ( .A0 ( gre_a_INV_6625_58 ) , 
    .A1 ( \shadow_weights[15][15] ) , .B0 ( ZBUF_20020_1 ) , 
    .B1 ( \shadow_weights[0][15] ) , .C0 ( tmp_net261 ) , .Y ( tmp_net262 ) ) ;
NAND2XL U311 ( .A ( n691 ) , .B ( n1875 ) , .Y ( n2309 ) ) ;
AOI21XL ctmTdsLR_1_1997 ( .A0 ( HFSNET_285 ) , .A1 ( n157 ) , 
    .B0 ( tmp_net427 ) , .Y ( n1865 ) ) ;
NAND2XL ctmTdsLR_1_848 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[6] ) , 
    .Y ( HFSNET_3 ) ) ;
CLKINVX8 gre_a_INV_1970_inst_2157 ( .A ( calc_result_r[13] ) , 
    .Y ( gre_a_INV_1970_54 ) ) ;
XOR2XL U316 ( .A ( n806 ) , .B ( n720 ) , .Y ( n721 ) ) ;
NOR2BXL ctmTdsLR_1_829 ( .AN ( n733 ) , .B ( n732 ) , .Y ( n651 ) ) ;
AOI222XL ctmTdsLR_1_832 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][25] ) , 
    .B0 ( n1687 ) , .B1 ( \shadow_weights[2][25] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][25] ) , .Y ( tmp_net123 ) ) ;
XOR2XL U322 ( .A ( n690 ) , .B ( n738 ) , .Y ( n691 ) ) ;
NAND2XL ctmTdsLR_2_1917 ( .A ( tmp_net382 ) , .B ( n1900 ) , .Y ( n1902 ) ) ;
INVXL U324 ( .A ( n1504 ) , .Y ( n1505 ) ) ;
INVXL ctmTdsLR_2_1976 ( .A ( n631 ) , .Y ( tmp_net414 ) ) ;
INVXL gre_a_INV_6_inst_2158 ( .A ( gre_a_INV_1896_55 ) , 
    .Y ( gre_a_INV_6_55 ) ) ;
NOR2XL U327 ( .A ( n1725 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1726 ) ) ;
AOI21XL U328 ( .A0 ( n1807 ) , .A1 ( n1819 ) , .B0 ( n1806 ) , .Y ( n1812 ) ) ;
INVXL U329 ( .A ( n1503 ) , .Y ( n1506 ) ) ;
AOI21XL ctmTdsLR_2_1960 ( .A0 ( gre_a_INV_6625_58 ) , 
    .A1 ( \shadow_weights[15][6] ) , .B0 ( tmp_net192 ) , .Y ( tmp_net406 ) ) ;
NAND2XL U332 ( .A ( n1002 ) , .B ( n1053 ) , .Y ( n999 ) ) ;
NAND2XL U334 ( .A ( n1449 ) , .B ( n1447 ) , .Y ( n1419 ) ) ;
XOR2XL U337 ( .A ( n644 ) , .B ( n588 ) , .Y ( n589 ) ) ;
INVX4 gre_a_INV_1896_inst_2159 ( .A ( calc_result_r[12] ) , 
    .Y ( gre_a_INV_1896_55 ) ) ;
AND4X2 ctmTdsLR_2_1727 ( .A ( n1209_CDR2 ) , .B ( tmp_net252 ) , 
    .C ( tmp_net253 ) , .D ( ZBUF_2_53 ) , .Y ( tmp_net254 ) ) ;
NAND2XL U340 ( .A ( n1434 ) , .B ( n1432 ) , .Y ( n1131 ) ) ;
INVXL U343 ( .A ( n1224 ) , .Y ( n1114 ) ) ;
AOI21XL ctmTdsLR_1_1966 ( .A0 ( n1582 ) , .A1 ( tmp_net409 ) , 
    .B0 ( tmp_net410 ) , .Y ( n1583 ) ) ;
AOI211XL U345 ( .A0 ( HFSNET_345 ) , .A1 ( n2213 ) , .B0 ( n1746 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1747 ) ) ;
XOR2XL U347 ( .A ( n1852 ) , .B ( n1851 ) , .Y ( n1856 ) ) ;
NAND4X1 ctmTdsLR_3_972 ( .A ( HFSNET_75 ) , .B ( tmp_net211 ) , 
    .C ( tmp_net212 ) , .D ( n1365 ) , .Y ( HFSNET_165 ) ) ;
AOI21XL ctmTdsLR_1_805 ( .A0 ( n1779 ) , .A1 ( n1827 ) , .B0 ( n1828 ) , 
    .Y ( tmp_net106 ) ) ;
NOR2XL U354 ( .A ( n1736 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1737 ) ) ;
NAND2XL U355 ( .A ( n1086 ) , .B ( n1058 ) , .Y ( n1060 ) ) ;
INVXL U357 ( .A ( n981 ) , .Y ( n779 ) ) ;
NAND2XL ctmTdsLR_2_2072 ( .A ( n1560 ) , .B ( n1491 ) , .Y ( tmp_net465 ) ) ;
NAND2X2 ctmTdsLR_1_1889 ( .A ( n573 ) , .B ( n315 ) , .Y ( n2133 ) ) ;
XOR2X1 ctmTdsLR_2_806 ( .A ( tmp_net106 ) , .B ( n1833 ) , .Y ( n1838 ) ) ;
NAND2XL U368 ( .A ( n1586 ) , .B ( n1584 ) , .Y ( n1547 ) ) ;
AOI21XL U369 ( .A0 ( n1783 ) , .A1 ( n227 ) , .B0 ( n226 ) , .Y ( n228 ) ) ;
NAND2XL U372 ( .A ( n1572 ) , .B ( n1571 ) , .Y ( n1573 ) ) ;
NOR2XL ctmTdsLR_2_1998 ( .A ( HFSNET_285 ) , .B ( n157 ) , .Y ( tmp_net427 ) ) ;
NOR2XL U375 ( .A ( n976 ) , .B ( n979 ) , .Y ( n982 ) ) ;
INVXL U377 ( .A ( n1463 ) , .Y ( n1464 ) ) ;
INVXL U379 ( .A ( n1584 ) , .Y ( n1585 ) ) ;
NAND3XL ctmTdsLR_1_1740 ( .A ( n2178 ) , .B ( n2158 ) , .C ( target_bit[3] ) , 
    .Y ( n2024 ) ) ;
NOR2XL U383 ( .A ( n1745 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1746 ) ) ;
NAND2XL U386 ( .A ( n1465 ) , .B ( n1463 ) , .Y ( n1414 ) ) ;
AOI211XL U387 ( .A0 ( HFSNET_345 ) , .A1 ( n2207 ) , .B0 ( n1757 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1758 ) ) ;
NAND2XL U388 ( .A ( n1753 ) , .B ( n1751 ) , .Y ( n247 ) ) ;
CLKINVX8 gre_a_INV_8759_inst_2185 ( .A ( n1299 ) , .Y ( gre_a_INV_8759_58 ) ) ;
NAND2XL U391 ( .A ( n1459 ) , .B ( n1458 ) , .Y ( n1460 ) ) ;
BUFXL ZBUF_2_inst_2097 ( .A ( n1358_CDR2 ) , .Y ( ZBUF_2_26 ) ) ;
AOI211XL ctmTdsLR_1_684 ( .A0 ( n732 ) , .A1 ( n733 ) , .B0 ( n735 ) , 
    .C0 ( n731 ) , .Y ( n822 ) ) ;
INVXL U396 ( .A ( n1418 ) , .Y ( n1449 ) ) ;
NAND2XL U397 ( .A ( n1632 ) , .B ( n1630 ) , .Y ( n1624 ) ) ;
NAND2XL U398 ( .A ( n1753 ) , .B ( n1752 ) , .Y ( n1754 ) ) ;
INVXL U400 ( .A ( n1163 ) , .Y ( n1434 ) ) ;
XNOR2XL U402 ( .A ( n584 ) , .B ( n566 ) , .Y ( n567 ) ) ;
OAI21XL ctmTdsLR_1_2032 ( .A0 ( n1512 ) , .A1 ( n1511 ) , .B0 ( tmp_net445 ) , 
    .Y ( n1513 ) ) ;
INVXL U405 ( .A ( n1022 ) , .Y ( n1002 ) ) ;
AND4X4 ctmTdsLR_2_1761 ( .A ( tmp_net67 ) , .B ( tmp_net68 ) , 
    .C ( tmp_net65 ) , .D ( tmp_net66 ) , .Y ( tmp_net275 ) ) ;
NAND2XL ctmTdsLR_2_833 ( .A ( n1319 ) , .B ( \shadow_weights[13][25] ) , 
    .Y ( tmp_net124 ) ) ;
NAND2XL U409 ( .A ( n1832 ) , .B ( n1831 ) , .Y ( n1833 ) ) ;
NOR2XL U410 ( .A ( n1756 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1757 ) ) ;
AOI21XL U413 ( .A0 ( n2127 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2126 ) ) ;
OR2XL U414 ( .A ( HFSNET_158 ) , .B ( temp_acc[24] ) , .Y ( n1465 ) ) ;
NAND2XL U415 ( .A ( HFSNET_158 ) , .B ( temp_acc[24] ) , .Y ( n1463 ) ) ;
NAND2XL U416 ( .A ( n1756 ) , .B ( \shadow_weights[18][22] ) , .Y ( n1752 ) ) ;
XOR2XL U417 ( .A ( n563 ) , .B ( n515 ) , .Y ( n516 ) ) ;
AOI21XL U418 ( .A0 ( n2130 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2129 ) ) ;
OR2XL U419 ( .A ( HFSNET_161 ) , .B ( temp_acc[23] ) , .Y ( n1459 ) ) ;
NAND2XL U420 ( .A ( HFSNET_161 ) , .B ( temp_acc[23] ) , .Y ( n1458 ) ) ;
NAND2XL U421 ( .A ( HFSNET_136 ) , .B ( temp_acc[11] ) , .Y ( n1437 ) ) ;
NAND2XL U422 ( .A ( HFSNET_166 ) , .B ( temp_acc[25] ) , .Y ( n1529 ) ) ;
NAND2XL U423 ( .A ( HFSNET_165 ) , .B ( temp_acc[22] ) , .Y ( n1571 ) ) ;
NAND2XL U424 ( .A ( HFSNET_162 ) , .B ( temp_acc[21] ) , .Y ( n1509 ) ) ;
XOR2XL U425 ( .A ( n1912 ) , .B ( n1911 ) , .Y ( n1916 ) ) ;
XOR2XL U426 ( .A ( n609 ) , .B ( n608 ) , .Y ( n610 ) ) ;
INVXL U427 ( .A ( n1486 ) , .Y ( n1487 ) ) ;
NAND2XL U428 ( .A ( ZBUF_24_19 ) , .B ( temp_acc[26] ) , .Y ( n1584 ) ) ;
AOI21XL U429 ( .A0 ( n2124 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2123 ) ) ;
OR2XL U430 ( .A ( ZBUF_24_19 ) , .B ( temp_acc[26] ) , .Y ( n1586 ) ) ;
NAND2XL U431 ( .A ( HFSNET_131 ) , .B ( temp_acc[5] ) , .Y ( n1052 ) ) ;
NAND2XL U433 ( .A ( HFSNET_157 ) , .B ( temp_acc[28] ) , .Y ( n1630 ) ) ;
NAND2XL U434 ( .A ( HFSNET_164 ) , .B ( temp_acc[17] ) , .Y ( n1451 ) ) ;
NAND2XL U435 ( .A ( HFSNET_133 ) , .B ( temp_acc[7] ) , .Y ( n1137 ) ) ;
AOI21XL U436 ( .A0 ( n2121 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2120 ) ) ;
NAND2XL U437 ( .A ( HFSNET_159 ) , .B ( temp_acc[19] ) , .Y ( n1518 ) ) ;
AOI211X4 U438 ( .A0 ( n2070 ) , .A1 ( protected_sar_code[0] ) , 
    .B0 ( n2069 ) , .C0 ( n2068 ) , .Y ( n2071 ) ) ;
INVXL U439 ( .A ( n1485 ) , .Y ( n1488 ) ) ;
NAND2XL U440 ( .A ( HFSNET_130 ) , .B ( temp_acc[3] ) , .Y ( n977 ) ) ;
NAND2XL U441 ( .A ( HFSNET_155 ) , .B ( temp_acc[27] ) , .Y ( n1606 ) ) ;
NAND2XL U442 ( .A ( n1772 ) , .B ( n1771 ) , .Y ( n1773 ) ) ;
AOI21XL U443 ( .A0 ( n2095 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2094 ) ) ;
NAND2XL U444 ( .A ( n1485 ) , .B ( n1231 ) , .Y ( n1233 ) ) ;
AOI21XL U445 ( .A0 ( n1231 ) , .A1 ( n1486 ) , .B0 ( n1230 ) , .Y ( n1232 ) ) ;
AOI21XL U446 ( .A0 ( n2098 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2097 ) ) ;
NAND2XL U448 ( .A ( HFSNET_134 ) , .B ( temp_acc[9] ) , .Y ( n1111 ) ) ;
INVXL U449 ( .A ( n1831 ) , .Y ( n225 ) ) ;
AOI211XL U450 ( .A0 ( HFSNET_345 ) , .A1 ( n2206 ) , .B0 ( n1768 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1769 ) ) ;
NAND2XL ctmTdsLR_1_986 ( .A ( n975 ) , .B ( HFSNET_347 ) , .Y ( HFSNET_66 ) ) ;
OAI2BB1XL ctmTdsLR_1_987 ( .A0N ( n1444 ) , .A1N ( n1442 ) , .B0 ( n1443 ) , 
    .Y ( tmp_net220 ) ) ;
NOR2XL U455 ( .A ( n2128 ) , .B ( n2122 ) , .Y ( n2121 ) ) ;
NAND2XL ctmTdsLR_1_849 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[11] ) , 
    .Y ( HFSNET_8 ) ) ;
AOI222XL ctmTdsLR_1_912 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][13] ) , 
    .B0 ( n1291 ) , .B1 ( \shadow_weights[13][13] ) , .C0 ( n1290 ) , 
    .C1 ( \shadow_weights[6][13] ) , .Y ( tmp_net173 ) ) ;
NOR2XL U459 ( .A ( n2096 ) , .B ( n2132 ) , .Y ( n2098 ) ) ;
AOI21XL U460 ( .A0 ( n2187 ) , .A1 ( n2114 ) , .B0 ( n2133 ) , .Y ( n2113 ) ) ;
AOI211XL U461 ( .A0 ( HFSNET_345 ) , .A1 ( n2204 ) , .B0 ( n1776 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1777 ) ) ;
NAND2XL U463 ( .A ( n222 ) , .B ( n1859 ) , .Y ( n224 ) ) ;
NAND2XL ctmTdsLR_2_2013 ( .A ( tmp_net434 ) , .B ( n1451 ) , .Y ( n1453 ) ) ;
NOR2XL U465 ( .A ( n2096 ) , .B ( n2128 ) , .Y ( n2095 ) ) ;
NAND2XL ctmTdsLR_2_2033 ( .A ( n1512 ) , .B ( n1511 ) , .Y ( tmp_net445 ) ) ;
OAI2BB1XL ctmTdsLR_2_913 ( .A0N ( \shadow_weights[0][13] ) , 
    .A1N ( ZBUF_20020_1 ) , .B0 ( tmp_net173 ) , .Y ( tmp_net174 ) ) ;
NAND2XL U468 ( .A ( n1767 ) , .B ( \shadow_weights[18][21] ) , .Y ( n1763 ) ) ;
AOI31XL U469 ( .A0 ( n2067 ) , .A1 ( n2066_CDR2 ) , .A2 ( n2065_CDR2 ) , 
    .B0 ( protected_sar_code[0] ) , .Y ( n2069 ) ) ;
OAI2BB1XL ctmTdsLR_1_976 ( .A0N ( n1434 ) , .A1N ( n1435 ) , .B0 ( n1432 ) , 
    .Y ( tmp_net215 ) ) ;
NOR2XL U472 ( .A ( n2128 ) , .B ( n2131 ) , .Y ( n2130 ) ) ;
AOI21XL U473 ( .A0 ( n2188 ) , .A1 ( n2117 ) , .B0 ( n2133 ) , .Y ( n2116 ) ) ;
AOI21XL U474 ( .A0 ( n222 ) , .A1 ( n1858 ) , .B0 ( n221 ) , .Y ( n223 ) ) ;
NOR2XL U475 ( .A ( n1767 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1768 ) ) ;
NOR2XL U476 ( .A ( n2132 ) , .B ( n2131 ) , .Y ( n2136 ) ) ;
INVXL U477 ( .A ( n1557 ) , .Y ( n1558 ) ) ;
INVXL U478 ( .A ( n1490 ) , .Y ( n1559 ) ) ;
CLKINVX8 ctmTdsLR_1_1853 ( .A ( tmp_net342 ) , .Y ( ZBUF_20020_1 ) ) ;
INVXL U481 ( .A ( n1424 ) , .Y ( n1444 ) ) ;
NOR2XL U482 ( .A ( n2125 ) , .B ( n2131 ) , .Y ( n2127 ) ) ;
AOI21XL U483 ( .A0 ( n1930 ) , .A1 ( n1928 ) , .B0 ( n1918 ) , .Y ( n1922 ) ) ;
AOI21XL U484 ( .A0 ( n2191 ) , .A1 ( n2092 ) , .B0 ( n2133 ) , .Y ( n2091 ) ) ;
XNOR2XL U485 ( .A ( n1930 ) , .B ( n1929 ) , .Y ( n1934 ) ) ;
CLKINVX8 gre_a_INV_2586_inst_2181 ( .A ( n1735 ) , .Y ( gre_a_INV_2586_58 ) ) ;
NAND2XL ctmTdsLR_1_663 ( .A ( n1918 ) , .B ( n1920 ) , .Y ( tmp_net9 ) ) ;
NAND2XL U488 ( .A ( n1782 ) , .B ( n227 ) , .Y ( n229 ) ) ;
AOI21XL ctmTdsLR_3_914 ( .A0 ( gre_a_INV_6625_58 ) , 
    .A1 ( \shadow_weights[15][13] ) , .B0 ( tmp_net174 ) , .Y ( tmp_net175 ) ) ;
OAI21XL ctmTdsLR_1_2034 ( .A0 ( n1521 ) , .A1 ( n1520 ) , .B0 ( tmp_net446 ) , 
    .Y ( n1522 ) ) ;
NOR2BXL ctmTdsLR_2_1984 ( .AN ( n427 ) , .B ( n426 ) , .Y ( tmp_net419 ) ) ;
OAI2BB1XL ctmTdsLR_1_978 ( .A0N ( n1632 ) , .A1N ( n1633 ) , .B0 ( n1630 ) , 
    .Y ( tmp_net216 ) ) ;
AOI21XL ctmTdsLR_1_2073 ( .A0 ( n1516 ) , .A1 ( n1501 ) , .B0 ( tmp_net467 ) , 
    .Y ( n1502 ) ) ;
XNOR2XL U494 ( .A ( n511 ) , .B ( n464 ) , .Y ( n465 ) ) ;
AOI21XL U495 ( .A0 ( n604 ) , .A1 ( n603 ) , .B0 ( n602 ) , .Y ( n609 ) ) ;
OR3XL ctmTdsLR_1_850 ( .A ( n614 ) , .B ( calc_cnt[3] ) , .C ( calc_cnt[4] ) , 
    .Y ( n1210 ) ) ;
INVXL ctmTdsLR_3_2014 ( .A ( n1450 ) , .Y ( tmp_net434 ) ) ;
AOI21XL U498 ( .A0 ( n2190 ) , .A1 ( n2090 ) , .B0 ( n2133 ) , .Y ( n2089 ) ) ;
NOR2XL U499 ( .A ( n2132 ) , .B ( n2122 ) , .Y ( n2124 ) ) ;
NAND2XL U501 ( .A ( n1891 ) , .B ( n1890 ) , .Y ( n1892 ) ) ;
AND4XL ctmTdsLR_1_1890 ( .A ( n1151_CDR2 ) , .B ( ZBUF_2_46 ) , .C ( n1159 ) , 
    .D ( tmp_net195 ) , .Y ( tmp_net363 ) ) ;
AOI21XL U503 ( .A0 ( n2081 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2080 ) ) ;
OAI21XL ctmTdsLR_1_1985 ( .A0 ( n352 ) , .A1 ( n351 ) , .B0 ( tmp_net421 ) , 
    .Y ( n353 ) ) ;
NAND2XL U505 ( .A ( HFSNET_172 ) , .B ( temp_acc[8] ) , .Y ( n1112 ) ) ;
NOR4BX1 U506 ( .AN ( n1336_CDR2 ) , .B ( n1335_CDR2 ) , .C ( n1334_CDR2 ) , 
    .D ( HFSNET_53 ) , .Y ( n1340_CDR2 ) ) ;
NAND2XL ctmTdsLR_1_685 ( .A ( n422 ) , .B ( HFSNET_347 ) , .Y ( HFSNET_9 ) ) ;
NAND2XL U510 ( .A ( n2112 ) , .B ( n2093 ) , .Y ( n2090 ) ) ;
NAND2XL U512 ( .A ( n2093 ) , .B ( n2115 ) , .Y ( n2092 ) ) ;
NOR4BX1 U514 ( .AN ( n1350_CDR1 ) , .B ( n1349_CDR1 ) , .C ( n1348_CDR1 ) , 
    .D ( n1347_CDR1 ) , .Y ( n1354_CDR1 ) ) ;
NAND2XL U515 ( .A ( HFSNET_173 ) , .B ( temp_acc[15] ) , .Y ( n1562 ) ) ;
NAND2XL U516 ( .A ( copt_gre_net_480 ) , .B ( temp_acc[14] ) , .Y ( n1557 ) ) ;
NAND2XL U517 ( .A ( HFSNET_171 ) , .B ( temp_acc[12] ) , .Y ( n1443 ) ) ;
XOR2XL U518 ( .A ( n594 ) , .B ( n534 ) , .Y ( n535 ) ) ;
NOR4BX1 U519 ( .AN ( n1378_CDR2 ) , .B ( n1377_CDR2 ) , .C ( n1376_CDR1 ) , 
    .D ( HFSNET_88 ) , .Y ( n1382_CDR2 ) ) ;
NAND2XL U520 ( .A ( n1798 ) , .B ( n1797 ) , .Y ( n1799 ) ) ;
XOR2XL U521 ( .A ( n490 ) , .B ( n489 ) , .Y ( n491 ) ) ;
NAND2XL U522 ( .A ( HFSNET_168 ) , .B ( temp_acc[13] ) , .Y ( n1427 ) ) ;
AOI21XL U524 ( .A0 ( n2083 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2082 ) ) ;
AOI211XL U525 ( .A0 ( HFSNET_345 ) , .A1 ( n2219 ) , .B0 ( n1876 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1877 ) ) ;
NAND2XL ctmTdsLR_1_851 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[18] ) , 
    .Y ( HFSNET_2 ) ) ;
AOI21XL U527 ( .A0 ( n2088 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2087 ) ) ;
AOI21XL U528 ( .A0 ( n2085 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2084 ) ) ;
NAND2XL U530 ( .A ( n1819 ) , .B ( n1818 ) , .Y ( n1820 ) ) ;
XOR2XL U531 ( .A ( n461 ) , .B ( n439 ) , .Y ( n440 ) ) ;
NAND2XL U532 ( .A ( n2115 ) , .B ( n2119 ) , .Y ( n2117 ) ) ;
AOI22XL ctmTdsLR_3_1728 ( .A0 ( gre_a_INV_6238_58 ) , 
    .A1 ( \shadow_weights[1][15] ) , .B0 ( n1266 ) , 
    .B1 ( \shadow_weights[3][15] ) , .Y ( tmp_net252 ) ) ;
NOR2XL U535 ( .A ( n1844 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1845 ) ) ;
AOI222XL ctmTdsLR_1_686 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][3] ) , 
    .B0 ( n1292 ) , .B1 ( \shadow_weights[2][3] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][3] ) , .Y ( tmp_net23 ) ) ;
NAND4XL U537 ( .A ( n1692_CDR2 ) , .B ( n1691_CDR2 ) , .C ( n1690_CDR2 ) , 
    .D ( n1689 ) , .Y ( n1694 ) ) ;
XOR2XL U538 ( .A ( n544 ) , .B ( n543 ) , .Y ( n545 ) ) ;
NOR4BX1 U539 ( .AN ( n1618_CDR1 ) , .B ( n1617_CDR1 ) , .C ( n1616_CDR1 ) , 
    .D ( n1615_CDR2 ) , .Y ( n1622_CDR2 ) ) ;
NAND2X1 ctmTdsLR_4_915 ( .A ( ropt_net_504 ) , .B ( tmp_net175 ) , 
    .Y ( HFSNET_168 ) ) ;
NOR2XL U542 ( .A ( n1775 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1776 ) ) ;
AOI21XL U543 ( .A0 ( n2102 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2101 ) ) ;
NAND2XL U544 ( .A ( n1844 ) , .B ( \shadow_weights[18][14] ) , .Y ( n1840 ) ) ;
AOI21XL U545 ( .A0 ( n2104 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2103 ) ) ;
NAND2XL U546 ( .A ( n2112 ) , .B ( n2119 ) , .Y ( n2114 ) ) ;
XOR2XL U547 ( .A ( n497 ) , .B ( n496 ) , .Y ( n498 ) ) ;
AOI21XL U548 ( .A0 ( n2109 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2108 ) ) ;
AOI211XL ctmTdsLR_2_1763 ( .A0 ( HFSNET_342 ) , 
    .A1 ( \shadow_weights[7][29] ) , .B0 ( tmp_net276 ) , .C0 ( tmp_net277 ) , 
    .Y ( tmp_net278 ) ) ;
AOI21XL U550 ( .A0 ( n2106 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2105 ) ) ;
INVXL U551 ( .A ( n1797 ) , .Y ( n1787 ) ) ;
OAI2BB1XL U552 ( .A0N ( \shadow_weights[1][6] ) , .A1N ( gre_a_INV_6238_58 ) , 
    .B0 ( n1025_CDR1 ) , .Y ( n1030_CDR2 ) ) ;
NAND2XL U553 ( .A ( n1813 ) , .B ( \shadow_weights[18][17] ) , .Y ( n1809 ) ) ;
BUFX12 ZCTSBUF_207_1337 ( .A ( net1786 ) , .Y ( ZCTSNET_384 ) ) ;
OAI2BB1XL U555 ( .A0N ( \shadow_weights[7][1] ) , .A1N ( HFSNET_342 ) , 
    .B0 ( n674_CDR1 ) , .Y ( n681_CDR1 ) ) ;
NOR2XL U556 ( .A ( n1874 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1876 ) ) ;
AOI21XL U557 ( .A0 ( n244 ) , .A1 ( n242 ) , .B0 ( n91 ) , .Y ( n240 ) ) ;
NOR2XL U558 ( .A ( n1813 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1814 ) ) ;
NOR2XL U559 ( .A ( n2125 ) , .B ( n2086 ) , .Y ( n2083 ) ) ;
OAI2BB1XL U560 ( .A0N ( \shadow_weights[3][10] ) , .A1N ( n1266 ) , 
    .B0 ( n1118_CDR2 ) , .Y ( n1123_CDR2 ) ) ;
XOR2XL U561 ( .A ( n1948 ) , .B ( n1947 ) , .Y ( n1952 ) ) ;
INVXL U562 ( .A ( n1818 ) , .Y ( n1806 ) ) ;
NOR2XL U563 ( .A ( n2128 ) , .B ( n2086 ) , .Y ( n2085 ) ) ;
NAND3XL ctmTdsLR_1_1891 ( .A ( ZBUF_2_38 ) , .B ( ZBUF_2_18 ) , 
    .C ( tmp_net364 ) , .Y ( HFSNET_131 ) ) ;
NAND2XL U565 ( .A ( n1865 ) , .B ( HFSNET_226 ) , .Y ( n1861 ) ) ;
NOR2XL U566 ( .A ( n2132 ) , .B ( n2086 ) , .Y ( n2088 ) ) ;
OAI2BB1XL U567 ( .A0N ( \shadow_weights[12][27] ) , 
    .A1N ( gre_a_INV_5313_58 ) , .B0 ( n1590_CDR2 ) , .Y ( n1595_CDR2 ) ) ;
AOI21XL U568 ( .A0 ( n539 ) , .A1 ( n538 ) , .B0 ( n537 ) , .Y ( n544 ) ) ;
OAI2BB1XL U569 ( .A0N ( \shadow_weights[7][28] ) , .A1N ( HFSNET_342 ) , 
    .B0 ( n1611_CDR1 ) , .Y ( n1616_CDR1 ) ) ;
NOR2XL U571 ( .A ( n2132 ) , .B ( n2107 ) , .Y ( n2109 ) ) ;
NAND2XL ctmTdsLR_4_2015 ( .A ( tmp_net21 ) , .B ( n1453 ) , 
    .Y ( tmp_net435 ) ) ;
NOR2XL U573 ( .A ( n2128 ) , .B ( n2107 ) , .Y ( n2106 ) ) ;
INVXL U574 ( .A ( n1879 ) , .Y ( n1891 ) ) ;
NOR2BXL ctmTdsLR_2_1810 ( .AN ( n1360_CDR2 ) , .B ( tmp_net309 ) , 
    .Y ( tmp_net310 ) ) ;
NAND2XL ctmTdsLR_2_808 ( .A ( HFSNET_342 ) , .B ( \shadow_weights[7][0] ) , 
    .Y ( tmp_net107 ) ) ;
NOR2XL U578 ( .A ( n2125 ) , .B ( n2107 ) , .Y ( n2104 ) ) ;
AOI21XL U579 ( .A0 ( n550 ) , .A1 ( n493 ) , .B0 ( n492 ) , .Y ( n497 ) ) ;
NAND2XL U580 ( .A ( n1793 ) , .B ( \shadow_weights[18][19] ) , .Y ( n1789 ) ) ;
INVXL ctmTdsLR_3_1764 ( .A ( n1634_CDR1 ) , .Y ( tmp_net276 ) ) ;
OAI2BB1XL U582 ( .A0N ( \shadow_weights[12][19] ) , 
    .A1N ( gre_a_INV_5313_58 ) , .B0 ( n1307_CDR2 ) , .Y ( n1316_CDR2 ) ) ;
XNOR2XL U583 ( .A ( n435 ) , .B ( n421 ) , .Y ( n422 ) ) ;
NOR2XL U584 ( .A ( n2100 ) , .B ( n2107 ) , .Y ( n2102 ) ) ;
NAND4XL ctmTdsLR_3_1811 ( .A ( n1359_CDR1 ) , .B ( tmp_net307 ) , 
    .C ( ZBUF_2_26 ) , .D ( tmp_net308 ) , .Y ( tmp_net309 ) ) ;
AOI221XL ctmTdsLR_1_1858 ( .A0 ( gre_a_INV_6625_58 ) , 
    .A1 ( \shadow_weights[15][29] ) , .B0 ( n1319 ) , 
    .B1 ( \shadow_weights[13][29] ) , .C0 ( tmp_net344 ) , .Y ( tmp_net345 ) ) ;
AOI21XL U587 ( .A0 ( n550 ) , .A1 ( n486 ) , .B0 ( n485 ) , .Y ( n490 ) ) ;
OAI2BB1XL ctmTdsLR_2_687 ( .A0N ( \shadow_weights[15][3] ) , 
    .A1N ( gre_a_INV_6625_58 ) , .B0 ( tmp_net23 ) , .Y ( tmp_net24 ) ) ;
NAND3XL ctmTdsLR_1_1741 ( .A ( target_bit[1] ) , .B ( n2178 ) , 
    .C ( target_bit[3] ) , .Y ( n2030 ) ) ;
INVXL U590 ( .A ( n531 ) , .Y ( n594 ) ) ;
OAI2BB1XL ctmTdsLR_2_1859 ( .A0N ( \shadow_weights[2][29] ) , .A1N ( n1687 ) , 
    .B0 ( tmp_net343 ) , .Y ( tmp_net344 ) ) ;
INVXL U592 ( .A ( n1805 ) , .Y ( n1819 ) ) ;
OAI2BB1XL U593 ( .A0N ( \shadow_weights[9][20] ) , .A1N ( n1662 ) , 
    .B0 ( n1329_CDR2 ) , .Y ( n1334_CDR2 ) ) ;
NOR2XL U595 ( .A ( n2100 ) , .B ( n2086 ) , .Y ( n2081 ) ) ;
AOI22XL ctmTdsLR_4_1812 ( .A0 ( gre_a_INV_6610_58 ) , 
    .A1 ( \shadow_weights[11][22] ) , .B0 ( n1662 ) , 
    .B1 ( \shadow_weights[9][22] ) , .Y ( tmp_net307 ) ) ;
AOI22XL ctmTdsLR_3_1860 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][29] ) , 
    .B0 ( ZBUF_20020_1 ) , .B1 ( \shadow_weights[0][29] ) , 
    .Y ( tmp_net343 ) ) ;
NOR2XL U598 ( .A ( n1853 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1854 ) ) ;
NAND2XL ctmTdsLR_2_1937 ( .A ( n1893 ) , .B ( n1892 ) , .Y ( tmp_net393 ) ) ;
OAI2BB1XL U600 ( .A0N ( \shadow_weights[14][16] ) , .A1N ( n1270 ) , 
    .B0 ( n1239_CDR2 ) , .Y ( n1244_CDR2 ) ) ;
NAND3XL ctmTdsLR_1_916 ( .A ( n1253_CDR1 ) , .B ( n1252_CDR2 ) , 
    .C ( n1261_CDR2 ) , .Y ( tmp_net176 ) ) ;
NAND4XL ctmTdsLR_2_917 ( .A ( tmp_net166 ) , .B ( n1262 ) , 
    .C ( tmp_net165 ) , .D ( n1251_CDR2 ) , .Y ( tmp_net177 ) ) ;
OAI2BB1XL U603 ( .A0N ( \shadow_weights[7][4] ) , .A1N ( HFSNET_342 ) , 
    .B0 ( n985_CDR1 ) , .Y ( n990_CDR1 ) ) ;
OAI2BB1XL U604 ( .A0N ( \shadow_weights[11][24] ) , 
    .A1N ( gre_a_INV_6610_58 ) , .B0 ( n1401_CDR2 ) , .Y ( n1406_CDR2 ) ) ;
NOR2XL U605 ( .A ( n1865 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1866 ) ) ;
OAI2BB1XL U606 ( .A0N ( \shadow_weights[11][21] ) , 
    .A1N ( gre_a_INV_6610_58 ) , .B0 ( n1343_CDR1 ) , .Y ( n1348_CDR1 ) ) ;
AOI211XL U607 ( .A0 ( HFSNET_345 ) , .A1 ( n2205 ) , .B0 ( n1802 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1803 ) ) ;
NAND2X1 ctmTdsLR_4_1729 ( .A ( gre_a_INV_8759_58 ) , 
    .B ( \shadow_weights[4][15] ) , .Y ( tmp_net253 ) ) ;
OAI2BB1XL U609 ( .A0N ( \shadow_weights[11][23] ) , 
    .A1N ( gre_a_INV_6610_58 ) , .B0 ( n1371_CDR1 ) , .Y ( n1376_CDR1 ) ) ;
NAND4XL ctmTdsLR_4_1765 ( .A ( tmp_net94 ) , .B ( n1640_CDR1 ) , 
    .C ( n1644_CDR2 ) , .D ( tmp_net93 ) , .Y ( tmp_net277 ) ) ;
NAND2XL ctmTdsLR_2_2074 ( .A ( tmp_net466 ) , .B ( n1514 ) , .Y ( n1501 ) ) ;
NAND2XL ctmTdsLR_1_852 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[12] ) , 
    .Y ( HFSNET_7 ) ) ;
NOR3X2 ctmTdsLR_1_1766 ( .A ( tmp_net279 ) , .B ( tmp_net280 ) , 
    .C ( tmp_net281 ) , .Y ( tmp_net201 ) ) ;
AOI21XL U615 ( .A0 ( n531 ) , .A1 ( n533 ) , .B0 ( n523 ) , .Y ( n528 ) ) ;
NOR2XL U617 ( .A ( n1894 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1895 ) ) ;
NAND2XL U618 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][22] ) , 
    .Y ( n1365 ) ) ;
INVXL U619 ( .A ( n455 ) , .Y ( n550 ) ) ;
AOI222XL ctmTdsLR_2_1892 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][5] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][5] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][5] ) , .Y ( tmp_net364 ) ) ;
NAND3XL ctmTdsLR_1_1861 ( .A ( ZBUF_2_39 ) , .B ( tmp_net349 ) , 
    .C ( ZBUF_2_54 ) , .Y ( HFSNET_134 ) ) ;
NAND2XL U623 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][0] ) , 
    .Y ( n632 ) ) ;
OAI2BB1XL ctmTdsLR_1_697 ( .A0N ( n1772 ) , .A1N ( n1774 ) , .B0 ( n1771 ) , 
    .Y ( tmp_net30 ) ) ;
NAND2XL U625 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][10] ) , 
    .Y ( n1126 ) ) ;
NAND2XL U626 ( .A ( gre_a_INV_6625_58 ) , .B ( protected_sar_code[15] ) , 
    .Y ( n1689 ) ) ;
NAND2XL U627 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][23] ) , 
    .Y ( n1379 ) ) ;
OR2XL U628 ( .A ( n1697 ) , .B ( n1696 ) , .Y ( N1614 ) ) ;
NAND2XL U629 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][24] ) , 
    .Y ( n1409 ) ) ;
OR4X1 ctmTdsLR_1_1893 ( .A ( tmp_net365 ) , .B ( tmp_net331 ) , 
    .C ( tmp_net328 ) , .D ( tmp_net366 ) , .Y ( HFSNET_133 ) ) ;
NOR4BX1 U632 ( .AN ( n1202_CDR2 ) , .B ( n1201_CDR2 ) , .C ( n1200_CDR1 ) , 
    .D ( copt_gre_net_475 ) , .Y ( n1206_CDR2 ) ) ;
INVXL ctmTdsLR_3_1918 ( .A ( n1899 ) , .Y ( tmp_net382 ) ) ;
NAND2XL U634 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][12] ) , 
    .Y ( n1175 ) ) ;
NAND2XL ctmTdsLR_5_1813 ( .A ( gre_a_INV_6238_58 ) , 
    .B ( \shadow_weights[1][22] ) , .Y ( tmp_net308 ) ) ;
NAND2XL U637 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][11] ) , 
    .Y ( n1159 ) ) ;
XOR2X1 ctmTdsLR_2_1967 ( .A ( n2201 ) , .B ( accumulator[34] ) , 
    .Y ( tmp_net409 ) ) ;
NAND2XL U639 ( .A ( n1801 ) , .B ( \shadow_weights[18][18] ) , .Y ( n1797 ) ) ;
AOI211XL U640 ( .A0 ( HFSNET_345 ) , .A1 ( n2224 ) , .B0 ( n1924 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1925 ) ) ;
NAND2XL ctmTdsLR_4_1919 ( .A ( n1903 ) , .B ( n1902 ) , .Y ( tmp_net383 ) ) ;
NAND2XL U643 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][16] ) , 
    .Y ( n1247 ) ) ;
NAND2XL U644 ( .A ( n1886 ) , .B ( \shadow_weights[18][10] ) , .Y ( n1882 ) ) ;
OAI21XL ctmTdsLR_1_1920 ( .A0 ( n1435 ) , .A1 ( n1131 ) , .B0 ( tmp_net384 ) , 
    .Y ( n1132 ) ) ;
NAND2XL U646 ( .A ( n1913 ) , .B ( \shadow_weights[18][7] ) , .Y ( n1909 ) ) ;
NOR2XL U647 ( .A ( n1913 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1914 ) ) ;
NAND4XL ctmTdsLR_2_1767 ( .A ( n632 ) , .B ( ZBUF_2_36 ) , .C ( tmp_net264 ) , 
    .D ( tmp_net159 ) , .Y ( tmp_net279 ) ) ;
INVXL U650 ( .A ( n1927 ) , .Y ( n1918 ) ) ;
NAND2XL ctmTdsLR_2_1738 ( .A ( tmp_net255 ) , .B ( tmp_net260 ) , 
    .Y ( tmp_net261 ) ) ;
NAND2XL U652 ( .A ( n1928 ) , .B ( n1920 ) , .Y ( n205 ) ) ;
NAND2XL ctmTdsLR_2_1921 ( .A ( n1435 ) , .B ( n1131 ) , .Y ( tmp_net384 ) ) ;
OAI21XL ctmTdsLR_1_1922 ( .A0 ( n802 ) , .A1 ( n801 ) , .B0 ( tmp_net385 ) , 
    .Y ( n803 ) ) ;
INVXL ctmTdsLR_3_1768 ( .A ( tmp_net265 ) , .Y ( tmp_net280 ) ) ;
NAND2XL U656 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][20] ) , 
    .Y ( n1337 ) ) ;
NAND2XL ctmTdsLR_2_1923 ( .A ( n802 ) , .B ( n801 ) , .Y ( tmp_net385 ) ) ;
NAND2XL U658 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][2] ) , 
    .Y ( n750 ) ) ;
AND2XL ctmTdsLR_2_1894 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][7] ) , 
    .Y ( tmp_net365 ) ) ;
NAND2XL ctmTdsLR_2_1986 ( .A ( tmp_net420 ) , .B ( n355 ) , .Y ( n351 ) ) ;
NAND2XL U661 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][17] ) , 
    .Y ( n1262 ) ) ;
NAND2XL U662 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][27] ) , 
    .Y ( n1598 ) ) ;
NAND2XL U663 ( .A ( gre_a_INV_6625_58 ) , .B ( \shadow_weights[15][25] ) , 
    .Y ( n1477 ) ) ;
OAI211XL ctmTdsLR_2_664 ( .A0 ( n1917 ) , .A1 ( n205 ) , .B0 ( tmp_net9 ) , 
    .C0 ( n1919 ) , .Y ( n1898 ) ) ;
INVXL ctmTdsLR_3_2075 ( .A ( n1515 ) , .Y ( tmp_net466 ) ) ;
AOI21XL U666 ( .A0 ( n110 ) , .A1 ( n156 ) , .B0 ( n109 ) , .Y ( n115 ) ) ;
NOR3XL U667 ( .A ( state[0] ) , .B ( state[3] ) , .C ( n657 ) , .Y ( n662 ) ) ;
AOI222XL ctmTdsLR_3_1739 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][15] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][15] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][15] ) , .Y ( tmp_net260 ) ) ;
AOI211XL U669 ( .A0 ( HFSNET_345 ) , .A1 ( n2220 ) , .B0 ( n1950 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1951 ) ) ;
AOI21XL U670 ( .A0 ( n134 ) , .A1 ( n132 ) , .B0 ( n126 ) , .Y ( n130 ) ) ;
OAI2BB1XL U671 ( .A0N ( \shadow_weights[7][13] ) , .A1N ( HFSNET_342 ) , 
    .B0 ( n1181_CDR2 ) , .Y ( n1186_CDR2 ) ) ;
NOR2XL U672 ( .A ( n1923 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1924 ) ) ;
NAND2XL U673 ( .A ( n1904 ) , .B ( \shadow_weights[18][8] ) , .Y ( n1900 ) ) ;
NAND2XL ctmTdsLR_5_1730 ( .A ( HFSNET_342 ) , .B ( \shadow_weights[7][15] ) , 
    .Y ( tmp_net255 ) ) ;
OAI2BB1XL U676 ( .A0N ( \shadow_weights[7][12] ) , .A1N ( HFSNET_342 ) , 
    .B0 ( n1167_CDR1 ) , .Y ( n1172_CDR1 ) ) ;
AOI211X1 ctmTdsLR_2_1862 ( .A0 ( gre_a_INV_6625_58 ) , 
    .A1 ( \shadow_weights[15][9] ) , .B0 ( tmp_net346 ) , .C0 ( tmp_net348 ) , 
    .Y ( tmp_net349 ) ) ;
OAI2BB1XL U678 ( .A0N ( \shadow_weights[1][14] ) , 
    .A1N ( gre_a_INV_6238_58 ) , .B0 ( n1195_CDR1 ) , .Y ( n1200_CDR1 ) ) ;
NOR2XL U679 ( .A ( n1904 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1905 ) ) ;
AOI211XL U680 ( .A0 ( HFSNET_345 ) , .A1 ( n2228 ) , .B0 ( n1940 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1942 ) ) ;
INVXL U681 ( .A ( n1935 ) , .Y ( n189 ) ) ;
NAND4XL U682 ( .A ( n968 ) , .B ( n1658 ) , .C ( n1657 ) , .D ( n823 ) , 
    .Y ( N1485 ) ) ;
AOI211XL U683 ( .A0 ( HFSNET_345 ) , .A1 ( n2217 ) , .B0 ( n1958 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n1959 ) ) ;
NAND2XL U684 ( .A ( n1923 ) , .B ( \shadow_weights[18][6] ) , .Y ( n1919 ) ) ;
NAND2XL U685 ( .A ( n1931 ) , .B ( \shadow_weights[18][5] ) , .Y ( n1927 ) ) ;
AOI222XL ctmTdsLR_2_1743 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][8] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][8] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][8] ) , .Y ( tmp_net263 ) ) ;
XNOR2X1 ctmTdsLR_2_698 ( .A ( tmp_net30 ) , .B ( n1765 ) , .Y ( n1770 ) ) ;
AOI21XL ctmTdsLR_1_1924 ( .A0 ( n1461 ) , .A1 ( n1460 ) , .B0 ( tmp_net386 ) , 
    .Y ( n1462 ) ) ;
BUFX1 ZBUF_2_inst_1615 ( .A ( tmp_net61 ) , .Y ( ZBUF_2_12 ) ) ;
NOR2XL ctmTdsLR_2_1925 ( .A ( n1461 ) , .B ( n1460 ) , .Y ( tmp_net386 ) ) ;
OAI21XL ctmTdsLR_1_1930 ( .A0 ( tmp_net6 ) , .A1 ( n554 ) , 
    .B0 ( tmp_net390 ) , .Y ( n556 ) ) ;
NAND2XL U692 ( .A ( n1370_CDR2 ) , .B ( n1369_CDR2 ) , .Y ( n1377_CDR2 ) ) ;
NAND4XL ctmTdsLR_4_1769 ( .A ( tmp_net107 ) , .B ( tmp_net266 ) , 
    .C ( n621 ) , .D ( n615 ) , .Y ( tmp_net281 ) ) ;
OAI2BB1XL ctmTdsLR_3_1863 ( .A0N ( \shadow_weights[0][9] ) , 
    .A1N ( ZBUF_20020_1 ) , .B0 ( tmp_net43 ) , .Y ( tmp_net346 ) ) ;
OAI21XL ctmTdsLR_1_1999 ( .A0 ( n604 ) , .A1 ( n596 ) , .B0 ( tmp_net428 ) , 
    .Y ( n597 ) ) ;
NAND2XL ctmTdsLR_2_1931 ( .A ( tmp_net6 ) , .B ( n554 ) , .Y ( tmp_net390 ) ) ;
AOI222XL ctmTdsLR_3_706 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][7] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][7] ) , 
    .C0 ( \shadow_weights[19][7] ) , .C1 ( n1281 ) , .Y ( tmp_net37 ) ) ;
NAND2XL U699 ( .A ( n1682_CDR2 ) , .B ( n1681_CDR2 ) , .Y ( n1683_CDR2 ) ) ;
NAND2XL U700 ( .A ( n1304_CDR2 ) , .B ( n1303_CDR2 ) , .Y ( n1317_CDR2 ) ) ;
AOI222XL ctmTdsLR_1_926 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][24] ) , 
    .B0 ( n1687 ) , .B1 ( \shadow_weights[2][24] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][24] ) , .Y ( tmp_net183 ) ) ;
NAND2XL ctmTdsLR_4_1864 ( .A ( n1093 ) , .B ( tmp_net347 ) , 
    .Y ( tmp_net348 ) ) ;
AOI222XL ctmTdsLR_5_1865 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][9] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][9] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][9] ) , .Y ( tmp_net347 ) ) ;
AOI2BB2XL U704 ( .B0 ( n2078 ) , .B1 ( n2077 ) , .A0N ( n2076 ) , 
    .A1N ( n2075 ) , .Y ( n793 ) ) ;
NAND2BXL ctmTdsLR_1_853 ( .AN ( n1821 ) , .B ( n1782 ) , .Y ( tmp_net132 ) ) ;
INVX4 gre_a_INV_2154_inst_2178 ( .A ( n1416 ) , .Y ( gre_a_INV_2154_58 ) ) ;
OAI2BB1XL ctmTdsLR_2_1715 ( .A0N ( n165 ) , .A1N ( n167 ) , .B0 ( n164 ) , 
    .Y ( tmp_net244 ) ) ;
NAND2XL ctmTdsLR_2_927 ( .A ( n1319 ) , .B ( \shadow_weights[13][24] ) , 
    .Y ( tmp_net184 ) ) ;
NAND4XL ctmTdsLR_3_928 ( .A ( tmp_net183 ) , .B ( n1409 ) , 
    .C ( n1408_CDR2 ) , .D ( tmp_net184 ) , .Y ( tmp_net185 ) ) ;
OR4X1 ctmTdsLR_4_929 ( .A ( n1406_CDR2 ) , .B ( HFSNET_100 ) , 
    .C ( tmp_net185 ) , .D ( n1407_CDR2 ) , .Y ( HFSNET_158 ) ) ;
AOI22XL U711 ( .A0 ( n1670 ) , .A1 ( protected_sar_code[16] ) , 
    .B0 ( n1668 ) , .B1 ( protected_sar_code[10] ) , .Y ( n1691_CDR2 ) ) ;
OAI2BB1XL ctmTdsLR_3_1895 ( .A0N ( \shadow_weights[15][7] ) , 
    .A1N ( gre_a_INV_6625_58 ) , .B0 ( tmp_net155 ) , .Y ( tmp_net366 ) ) ;
NAND2XL ctmTdsLR_2_1815 ( .A ( ZBUF_2_20 ) , .B ( n1063 ) , 
    .Y ( tmp_net311 ) ) ;
OAI2BB1XL ctmTdsLR_3_1816 ( .A0N ( \shadow_weights[7][8] ) , 
    .A1N ( HFSNET_342 ) , .B0 ( n1062_CDR1 ) , .Y ( tmp_net312 ) ) ;
BUFX1 ZBUF_17_inst_1710 ( .A ( N1827 ) , .Y ( ZBUF_17_0 ) ) ;
NAND3XL ctmTdsLR_4_1817 ( .A ( n1064 ) , .B ( ZBUF_2_51 ) , 
    .C ( n1071_CDR2 ) , .Y ( tmp_net313 ) ) ;
AOI21XL ctmTdsLR_1_1932 ( .A0 ( n1707 ) , .A1 ( n1706 ) , .B0 ( tmp_net392 ) , 
    .Y ( n1711 ) ) ;
NAND2BXL ctmTdsLR_2_854 ( .AN ( n1783 ) , .B ( tmp_net132 ) , .Y ( n1800 ) ) ;
AOI222XL ctmTdsLR_1_855 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][8] ) , 
    .B0 ( ZBUF_20020_1 ) , .B1 ( \shadow_weights[0][8] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][8] ) , .Y ( tmp_net133 ) ) ;
AOI222XL ctmTdsLR_3_672 ( .A0 ( \shadow_weights[18][15] ) , .A1 ( n1280 ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][15] ) , 
    .C0 ( \shadow_weights[19][15] ) , .C1 ( n1281 ) , .Y ( tmp_net15 ) ) ;
OAI2BB1XL ctmTdsLR_1_733 ( .A0N ( n1891 ) , .A1N ( n1893 ) , .B0 ( n1890 ) , 
    .Y ( tmp_net54 ) ) ;
NAND2XL ctmTdsLR_1_691 ( .A ( n1753 ) , .B ( n1750 ) , .Y ( tmp_net27 ) ) ;
XNOR2XL ctmTdsLR_2_734 ( .A ( n1884 ) , .B ( tmp_net54 ) , .Y ( n1889 ) ) ;
NAND2XL U725 ( .A ( n1328_CDR2 ) , .B ( n1327_CDR1 ) , .Y ( n1335_CDR2 ) ) ;
AOI22XL U726 ( .A0 ( n1671 ) , .A1 ( sar_code[18] ) , .B0 ( n1673 ) , 
    .B1 ( sar_code[17] ) , .Y ( n1690_CDR2 ) ) ;
NAND2XL U727 ( .A ( n1400_CDR2 ) , .B ( n1399_CDR2 ) , .Y ( n1407_CDR2 ) ) ;
NAND2XL ctmTdsLR_1_735 ( .A ( n1278 ) , .B ( \shadow_weights[8][4] ) , 
    .Y ( tmp_net55 ) ) ;
NAND2XL ctmTdsLR_2_1933 ( .A ( tmp_net391 ) , .B ( n1704 ) , .Y ( n1706 ) ) ;
NAND2XL ctmTdsLR_2_736 ( .A ( n1277 ) , .B ( \shadow_weights[10][4] ) , 
    .Y ( tmp_net56 ) ) ;
NAND2XL U732 ( .A ( n1117 ) , .B ( n1116 ) , .Y ( n1124 ) ) ;
CLKBUFX2 ZBUF_4201_inst_2101 ( .A ( n2030 ) , .Y ( ZBUF_4201_28 ) ) ;
NAND2XL ctmTdsLR_1_1744 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][0] ) , 
    .Y ( tmp_net264 ) ) ;
OAI2BB1XL ctmTdsLR_1_1896 ( .A0N ( \shadow_weights[0][2] ) , 
    .A1N ( ZBUF_20020_1 ) , .B0 ( tmp_net368 ) , .Y ( HFSNET_129 ) ) ;
NAND2XL ctmTdsLR_1_930 ( .A ( n721 ) , .B ( HFSNET_347 ) , .Y ( HFSNET_68 ) ) ;
INVXL ctmTdsLR_3_1934 ( .A ( n1703 ) , .Y ( tmp_net391 ) ) ;
NOR2XL ctmTdsLR_4_1935 ( .A ( n1707 ) , .B ( n1706 ) , .Y ( tmp_net392 ) ) ;
NAND2XL U739 ( .A ( n1939 ) , .B ( \shadow_weights[18][4] ) , .Y ( n1935 ) ) ;
NAND2XL U740 ( .A ( n1024_CDR1 ) , .B ( n1023_CDR2 ) , .Y ( n1031_CDR2 ) ) ;
CLKBUFX8 ZCTSBUF_255_1341 ( .A ( net1711 ) , .Y ( ZCTSNET_388 ) ) ;
OAI21XL ctmTdsLR_1_1938 ( .A0 ( n1864 ) , .A1 ( n1863 ) , .B0 ( tmp_net395 ) , 
    .Y ( n1868 ) ) ;
AOI222XL ctmTdsLR_3_737 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][4] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][4] ) , 
    .C0 ( \shadow_weights[19][4] ) , .C1 ( n1281 ) , .Y ( tmp_net57 ) ) ;
NAND3BXL ctmTdsLR_3_1868 ( .AN ( n681_CDR1 ) , .B ( tmp_net286 ) , 
    .C ( n683_CDR1 ) , .Y ( tmp_net350 ) ) ;
INVXL U746 ( .A ( n376 ) , .Y ( n443 ) ) ;
NOR4BBXL ctmTdsLR_2_1897 ( .AN ( tmp_net367 ) , .BN ( n750 ) , 
    .C ( tmp_net321 ) , .D ( copt_gre_net_482 ) , .Y ( tmp_net368 ) ) ;
AOI222XL ctmTdsLR_2_1745 ( .A0 ( gre_a_INV_8759_58 ) , 
    .A1 ( \shadow_weights[4][0] ) , .B0 ( gre_a_INV_5313_58 ) , 
    .B1 ( \shadow_weights[12][0] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][0] ) , .Y ( tmp_net265 ) ) ;
NAND2XL ctmTdsLR_1_840 ( .A ( n589 ) , .B ( HFSNET_347 ) , .Y ( HFSNET_70 ) ) ;
NAND2XL ctmTdsLR_2_1939 ( .A ( tmp_net394 ) , .B ( n1861 ) , .Y ( n1863 ) ) ;
AOI222XL ctmTdsLR_2_813 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][5] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][5] ) , 
    .C0 ( gre_a_INV_6238_58 ) , .C1 ( \shadow_weights[1][5] ) , 
    .Y ( tmp_net111 ) ) ;
NOR3XL ctmTdsLR_2_1819 ( .A ( tmp_net293 ) , .B ( tmp_net271 ) , 
    .C ( tmp_net316 ) , .Y ( tmp_net317 ) ) ;
NAND3XL ctmTdsLR_3_1820 ( .A ( tmp_net314 ) , .B ( tmp_net315 ) , 
    .C ( n1008_CDR1 ) , .Y ( tmp_net316 ) ) ;
INVXL ctmTdsLR_3_1940 ( .A ( n1860 ) , .Y ( tmp_net394 ) ) ;
NAND2XL ctmTdsLR_4_738 ( .A ( n1279 ) , .B ( \shadow_weights[16][4] ) , 
    .Y ( tmp_net58 ) ) ;
OAI2BB1XL ctmTdsLR_2_856 ( .A0N ( \shadow_weights[13][8] ) , .A1N ( n1319 ) , 
    .B0 ( tmp_net133 ) , .Y ( tmp_net134 ) ) ;
INVXL U759 ( .A ( n1953 ) , .Y ( n177 ) ) ;
NAND2XL U760 ( .A ( n984 ) , .B ( n983_CDR1 ) , .Y ( n991_CDR1 ) ) ;
AOI222X1 ctmTdsLR_1_938 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][6] ) , 
    .B0 ( n1292 ) , .B1 ( \shadow_weights[2][6] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][6] ) , .Y ( tmp_net191 ) ) ;
NAND2X1 ctmTdsLR_4_1821 ( .A ( gre_a_INV_5313_58 ) , 
    .B ( \shadow_weights[12][5] ) , .Y ( tmp_net314 ) ) ;
NAND2XL U763 ( .A ( n1949 ) , .B ( \shadow_weights[18][3] ) , .Y ( n1945 ) ) ;
AOI222XL ctmTdsLR_3_1898 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][2] ) , 
    .B0 ( n1687 ) , .B1 ( \shadow_weights[2][2] ) , .C0 ( n1319 ) , 
    .C1 ( \shadow_weights[13][2] ) , .Y ( tmp_net367 ) ) ;
NAND2XL ctmTdsLR_1_675 ( .A ( n1278 ) , .B ( \shadow_weights[8][16] ) , 
    .Y ( tmp_net17 ) ) ;
NAND2XL ctmTdsLR_5_1822 ( .A ( gre_a_INV_8759_58 ) , 
    .B ( \shadow_weights[4][5] ) , .Y ( tmp_net315 ) ) ;
NAND3XL ctmTdsLR_1_1899 ( .A ( tmp_net369 ) , .B ( tmp_net370 ) , 
    .C ( tmp_net373 ) , .Y ( HFSNET_128 ) ) ;
NAND2XL U769 ( .A ( n1238_CDR2 ) , .B ( n1237_CDR1 ) , .Y ( n1245_CDR2 ) ) ;
NOR2XL ctmTdsLR_3_1968 ( .A ( n1582 ) , .B ( tmp_net409 ) , 
    .Y ( tmp_net410 ) ) ;
NAND3XL U771 ( .A ( n1676_CDR2 ) , .B ( n1675_CDR2 ) , .C ( n1674_CDR2 ) , 
    .Y ( n1684_CDR2 ) ) ;
NAND2XL ctmTdsLR_2_676 ( .A ( n1277 ) , .B ( \shadow_weights[10][16] ) , 
    .Y ( tmp_net18 ) ) ;
AOI222XL ctmTdsLR_3_677 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][16] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][16] ) , 
    .C0 ( \shadow_weights[19][16] ) , .C1 ( n1281 ) , .Y ( tmp_net19 ) ) ;
NAND2XL ctmTdsLR_4_678 ( .A ( n1279 ) , .B ( \shadow_weights[16][16] ) , 
    .Y ( tmp_net20 ) ) ;
BUFXL ZBUF_2_inst_2103 ( .A ( n1635_CDR2 ) , .Y ( ZBUF_2_30 ) ) ;
AOI22XL U776 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][10] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][10] ) , 
    .Y ( n1125_CDR2 ) ) ;
AOI222XL ctmTdsLR_1_941 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][10] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][10] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][10] ) , .Y ( tmp_net193 ) ) ;
AOI22XL U778 ( .A0 ( n1660 ) , .A1 ( \shadow_weights[3][25] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][25] ) , 
    .Y ( n1476_CDR1 ) ) ;
AOI22XL U779 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][25] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][25] ) , .Y ( n1467_CDR2 ) ) ;
OAI2BB1XL ctmTdsLR_2_1824 ( .A0N ( \shadow_weights[7][2] ) , 
    .A1N ( HFSNET_342 ) , .B0 ( copt_gre_net_474 ) , .Y ( tmp_net318 ) ) ;
AOI22XL U781 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][25] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][25] ) , 
    .Y ( n1468_CDR2 ) ) ;
AOI22XL U782 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][19] ) , 
    .B0 ( n1660 ) , .B1 ( \shadow_weights[3][19] ) , .Y ( n1318_CDR2 ) ) ;
AOI22XL U783 ( .A0 ( n1266 ) , .A1 ( \shadow_weights[3][17] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][17] ) , 
    .Y ( n1261_CDR2 ) ) ;
AOI22XL U784 ( .A0 ( n1668 ) , .A1 ( \shadow_weights[10][25] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][25] ) , .Y ( n1472_CDR2 ) ) ;
NAND4XL ctmTdsLR_3_1825 ( .A ( tmp_net319 ) , .B ( ZBUF_2_31 ) , 
    .C ( tmp_net320 ) , .D ( copt_gre_net_476 ) , .Y ( tmp_net321 ) ) ;
NAND2XL ctmTdsLR_2_942 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][10] ) , 
    .Y ( tmp_net194 ) ) ;
AOI22XL U787 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][21] ) , 
    .B0 ( n1660 ) , .B1 ( \shadow_weights[3][21] ) , .Y ( n1350_CDR1 ) ) ;
AOI22XL U788 ( .A0 ( n1668 ) , .A1 ( \shadow_weights[10][23] ) , 
    .B0 ( n1669 ) , .B1 ( \shadow_weights[8][23] ) , .Y ( n1374_CDR1 ) ) ;
OR4XL ctmTdsLR_1_1731 ( .A ( tmp_net251 ) , .B ( tmp_net24 ) , 
    .C ( ZBUF_2_33 ) , .D ( tmp_net258 ) , .Y ( HFSNET_130 ) ) ;
AOI22XL ctmTdsLR_4_1826 ( .A0 ( n1266 ) , .A1 ( \shadow_weights[3][2] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][2] ) , 
    .Y ( tmp_net319 ) ) ;
NAND2XL ctmTdsLR_5_1827 ( .A ( gre_a_INV_6238_58 ) , 
    .B ( \shadow_weights[1][2] ) , .Y ( tmp_net320 ) ) ;
AOI22XL U792 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][10] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][10] ) , .Y ( n1116 ) ) ;
NAND2XL ctmTdsLR_4_1941 ( .A ( n1864 ) , .B ( n1863 ) , .Y ( tmp_net395 ) ) ;
AOI21XL ctmTdsLR_1_1942 ( .A0 ( n1812 ) , .A1 ( n1811 ) , .B0 ( tmp_net397 ) , 
    .Y ( n1817 ) ) ;
NAND4X1 ctmTdsLR_3_943 ( .A ( tmp_net194 ) , .B ( n1129_CDR1 ) , 
    .C ( n1126 ) , .D ( tmp_net193 ) , .Y ( HFSNET_135 ) ) ;
NAND3BXL ctmTdsLR_3_1871 ( .AN ( tmp_net318 ) , .B ( ZBUF_2_32 ) , 
    .C ( n742_CDR1 ) , .Y ( tmp_net352 ) ) ;
AOI22XL U797 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][23] ) , 
    .B0 ( HFSNET_342 ) , .B1 ( \shadow_weights[7][23] ) , .Y ( n1369_CDR2 ) ) ;
AOI22XL U798 ( .A0 ( n1660 ) , .A1 ( \shadow_weights[3][23] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][23] ) , 
    .Y ( n1378_CDR2 ) ) ;
AOI22X1 U799 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][23] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][23] ) , .Y ( n1370_CDR2 ) ) ;
NAND2XL ctmTdsLR_2_1900 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][1] ) , 
    .Y ( tmp_net369 ) ) ;
AOI22X1 U801 ( .A0 ( n1266 ) , .A1 ( \shadow_weights[3][3] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][3] ) , 
    .Y ( n789_CDR1 ) ) ;
OAI211XL ctmTdsLR_2_692 ( .A0 ( n1749 ) , .A1 ( n247 ) , .B0 ( tmp_net27 ) , 
    .C0 ( n1752 ) , .Y ( n1729 ) ) ;
NAND2XL ctmTdsLR_2_1943 ( .A ( tmp_net396 ) , .B ( n1809 ) , .Y ( n1811 ) ) ;
AOI22XL U804 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][26] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][26] ) , .Y ( n1537_CDR1 ) ) ;
AOI22XL ctmTdsLR_1_820 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][24] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][24] ) , .Y ( tmp_net117 ) ) ;
INVXL ctmTdsLR_3_1944 ( .A ( n1808 ) , .Y ( tmp_net396 ) ) ;
AOI22XL U808 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][3] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][3] ) , 
    .Y ( n781_CDR2 ) ) ;
AOI222XL ctmTdsLR_1_944 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][11] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][11] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][11] ) , .Y ( tmp_net195 ) ) ;
NAND2XL U810 ( .A ( n1957 ) , .B ( \shadow_weights[18][2] ) , .Y ( n1953 ) ) ;
AOI22XL U811 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][19] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][19] ) , 
    .Y ( n1304_CDR2 ) ) ;
NAND2XL U812 ( .A ( n1965 ) , .B ( \shadow_weights[18][1] ) , .Y ( n1962 ) ) ;
AOI22XL U813 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][3] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][3] ) , .Y ( n780_CDR2 ) ) ;
AOI22XL U814 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][17] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][17] ) , 
    .Y ( n1252_CDR2 ) ) ;
NAND3BXL ctmTdsLR_3_1874 ( .AN ( n990_CDR1 ) , .B ( tmp_net288 ) , 
    .C ( n992_CDR2 ) , .Y ( tmp_net354 ) ) ;
AOI22XL U816 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][11] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][11] ) , .Y ( n1150_CDR1 ) ) ;
NOR3XL ctmTdsLR_2_1829 ( .A ( tmp_net324 ) , .B ( tmp_net325 ) , 
    .C ( tmp_net272 ) , .Y ( tmp_net326 ) ) ;
AOI22XL U818 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][4] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][4] ) , 
    .Y ( n983_CDR1 ) ) ;
AOI22XL ctmTdsLR_2_821 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][24] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][24] ) , .Y ( tmp_net118 ) ) ;
AOI22XL U820 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][20] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][20] ) , 
    .Y ( n1328_CDR2 ) ) ;
AOI22XL U821 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][3] ) , .B0 ( n1277 ) , 
    .B1 ( \shadow_weights[10][3] ) , .Y ( n785_CDR1 ) ) ;
AOI22XL U822 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][4] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][4] ) , .Y ( n984 ) ) ;
NAND4XL ctmTdsLR_3_1830 ( .A ( tmp_net322 ) , .B ( tmp_net323 ) , 
    .C ( n1537_CDR1 ) , .D ( n1535_CDR2 ) , .Y ( tmp_net324 ) ) ;
AOI22XL U824 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][20] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][20] ) , 
    .Y ( n1336_CDR2 ) ) ;
NAND3XL ctmTdsLR_3_822 ( .A ( n1404_CDR1 ) , .B ( tmp_net117 ) , 
    .C ( tmp_net118 ) , .Y ( HFSNET_100 ) ) ;
AOI22XL U827 ( .A0 ( n1668 ) , .A1 ( \shadow_weights[10][24] ) , 
    .B0 ( n1669 ) , .B1 ( \shadow_weights[8][24] ) , .Y ( n1404_CDR1 ) ) ;
AOI22XL U828 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][27] ) , 
    .B0 ( n1660 ) , .B1 ( \shadow_weights[3][27] ) , .Y ( n1597_CDR2 ) ) ;
AOI22XL U829 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][4] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][4] ) , .Y ( n992_CDR2 ) ) ;
AOI22XL U830 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][11] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][11] ) , 
    .Y ( n1149_CDR1 ) ) ;
AOI22XL U831 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][5] ) , .B0 ( n1277 ) , 
    .B1 ( \shadow_weights[10][5] ) , .Y ( n1008_CDR1 ) ) ;
AOI22XL U832 ( .A0 ( n1660 ) , .A1 ( \shadow_weights[3][24] ) , 
    .B0 ( n1662 ) , .B1 ( \shadow_weights[9][24] ) , .Y ( n1408_CDR2 ) ) ;
AOI22X1 U833 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][17] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][17] ) , .Y ( n1251_CDR2 ) ) ;
AOI222XL ctmTdsLR_4_1831 ( .A0 ( n1671 ) , .A1 ( HFSNET_241 ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][26] ) , 
    .C0 ( gre_a_INV_5313_58 ) , .C1 ( \shadow_weights[12][26] ) , 
    .Y ( tmp_net322 ) ) ;
AOI22XL U835 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][10] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][10] ) , 
    .Y ( n1117 ) ) ;
AOI22XL U836 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][24] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][24] ) , .Y ( n1400_CDR2 ) ) ;
AOI22XL U837 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][24] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][24] ) , 
    .Y ( n1399_CDR2 ) ) ;
NOR2XL ctmTdsLR_4_1945 ( .A ( n1812 ) , .B ( n1811 ) , .Y ( tmp_net397 ) ) ;
AOI22XL U839 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][6] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][6] ) , .Y ( n1023_CDR2 ) ) ;
AOI22XL U840 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][6] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][6] ) , 
    .Y ( n1024_CDR1 ) ) ;
BUFX12 ZCTSBUF_251_1342 ( .A ( net1716 ) , .Y ( ZCTSNET_389 ) ) ;
AOI22XL U842 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][16] ) , 
    .B0 ( HFSNET_342 ) , .B1 ( \shadow_weights[7][16] ) , .Y ( n1246_CDR2 ) ) ;
AOI22X1 U843 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][18] ) , 
    .B0 ( n1278 ) , .B1 ( \shadow_weights[8][18] ) , .Y ( n1285_CDR1 ) ) ;
AOI22XL U844 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][6] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][6] ) , .Y ( n1032_CDR2 ) ) ;
NAND2XL ctmTdsLR_5_1832 ( .A ( n1679 ) , .B ( \shadow_weights[14][26] ) , 
    .Y ( tmp_net323 ) ) ;
AOI22X1 U846 ( .A0 ( n1266 ) , .A1 ( \shadow_weights[3][16] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][16] ) , 
    .Y ( n1238_CDR2 ) ) ;
AOI22XL U847 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][18] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][18] ) , .Y ( n1272_CDR1 ) ) ;
NAND2XL ctmTdsLR_2_945 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][11] ) , 
    .Y ( tmp_net196 ) ) ;
AOI22XL U849 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][18] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][18] ) , .Y ( n1273_CDR2 ) ) ;
AOI222XL ctmTdsLR_3_742 ( .A0 ( HFSNET_225 ) , .A1 ( n1280 ) , 
    .B0 ( \shadow_weights[19][11] ) , .B1 ( n1281 ) , .C0 ( n1282 ) , 
    .C1 ( \shadow_weights[17][11] ) , .Y ( tmp_net61 ) ) ;
AOI21XL ctmTdsLR_1_1946 ( .A0 ( n240 ) , .A1 ( n239 ) , .B0 ( tmp_net399 ) , 
    .Y ( n1767 ) ) ;
BUFX8 ZCTSBUF_247_1343 ( .A ( net1721 ) , .Y ( ZCTSNET_390 ) ) ;
NAND4X1 ctmTdsLR_3_946 ( .A ( tmp_net196 ) , .B ( tmp_net363 ) , 
    .C ( tmp_net333 ) , .D ( ZBUF_2_12 ) , .Y ( HFSNET_136 ) ) ;
AOI22XL U855 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][16] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][16] ) , .Y ( n1237_CDR1 ) ) ;
AOI22XL U856 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][9] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][9] ) , 
    .Y ( n1091 ) ) ;
INVXL ctmTdsLR_3_1901 ( .A ( tmp_net350 ) , .Y ( tmp_net370 ) ) ;
AOI22XL U858 ( .A0 ( n1266 ) , .A1 ( \shadow_weights[3][9] ) , .B0 ( n1268 ) , 
    .B1 ( \shadow_weights[5][9] ) , .Y ( n1092_CDR1 ) ) ;
AOI22XL U859 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][9] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][9] ) , 
    .Y ( n1100_CDR1 ) ) ;
NAND2XL U860 ( .A ( n346 ) , .B ( avg_cnt[3] ) , .Y ( n1978 ) ) ;
AOI22XL U861 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][1] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][1] ) , .Y ( n683_CDR1 ) ) ;
INVXL ctmTdsLR_6_1833 ( .A ( tmp_net301 ) , .Y ( tmp_net325 ) ) ;
NAND2XL ctmTdsLR_2_1947 ( .A ( tmp_net398 ) , .B ( n237 ) , .Y ( n239 ) ) ;
NAND2XL ctmTdsLR_1_823 ( .A ( n567 ) , .B ( HFSNET_347 ) , .Y ( HFSNET_71 ) ) ;
AOI211XL ctmTdsLR_4_1902 ( .A0 ( gre_a_INV_6625_58 ) , 
    .A1 ( \shadow_weights[15][1] ) , .B0 ( HFSNET_20 ) , .C0 ( tmp_net372 ) , 
    .Y ( tmp_net373 ) ) ;
OAI2BB1XL ctmTdsLR_5_1903 ( .A0N ( \shadow_weights[13][1] ) , .A1N ( n1319 ) , 
    .B0 ( tmp_net371 ) , .Y ( tmp_net372 ) ) ;
NAND3XL ctmTdsLR_2_1835 ( .A ( ZBUF_2_13 ) , .B ( tmp_net327 ) , 
    .C ( n1039_CDR1 ) , .Y ( tmp_net328 ) ) ;
BUFX8 ZCTSBUF_251_1344 ( .A ( net1726 ) , .Y ( ZCTSNET_391 ) ) ;
OAI2BB1XL ctmTdsLR_1_680 ( .A0N ( n1449 ) , .A1N ( HFSNET_293 ) , 
    .B0 ( n1447 ) , .Y ( tmp_net21 ) ) ;
NAND2XL ctmTdsLR_2_2035 ( .A ( n1521 ) , .B ( n1520 ) , .Y ( tmp_net446 ) ) ;
INVXL ctmTdsLR_3_1948 ( .A ( n236 ) , .Y ( tmp_net398 ) ) ;
AOI22XL U872 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][4] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][4] ) , 
    .Y ( n985_CDR1 ) ) ;
INVX4 U874 ( .A ( n1300 ) , .Y ( n1268 ) ) ;
AOI22X2 U875 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][11] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][11] ) , .Y ( n1151_CDR2 ) ) ;
AOI22XL U876 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][1] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][1] ) , .Y ( n674_CDR1 ) ) ;
NAND2XL ctmTdsLR_3_1836 ( .A ( HFSNET_342 ) , .B ( \shadow_weights[7][7] ) , 
    .Y ( tmp_net327 ) ) ;
NAND2XL U878 ( .A ( n315 ) , .B ( n1416 ) , .Y ( N1791 ) ) ;
AOI22X1 U879 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][7] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][7] ) , .Y ( n1039_CDR1 ) ) ;
AOI222XL ctmTdsLR_1_709 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][7] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][7] ) , 
    .C0 ( gre_a_INV_8759_58 ) , .C1 ( \shadow_weights[4][7] ) , 
    .Y ( tmp_net39 ) ) ;
AOI22XL U881 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][6] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][6] ) , 
    .Y ( n1025_CDR1 ) ) ;
CLKBUFX4 U882 ( .A ( n1291 ) , .Y ( n1319 ) ) ;
INVX4 U883 ( .A ( n1298 ) , .Y ( n1266 ) ) ;
CLKINVX3 U884 ( .A ( n1322 ) , .Y ( n1292 ) ) ;
AOI22X1 U885 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][3] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][3] ) , .Y ( n782 ) ) ;
AOI22XL U886 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][26] ) , 
    .B0 ( HFSNET_342 ) , .B1 ( \shadow_weights[7][26] ) , .Y ( n1534_CDR1 ) ) ;
AOI22XL U887 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][23] ) , 
    .B0 ( n1662 ) , .B1 ( \shadow_weights[9][23] ) , .Y ( n1371_CDR1 ) ) ;
NAND4X1 ctmTdsLR_3_949 ( .A ( tmp_net278 ) , .B ( tmp_net345 ) , 
    .C ( ZBUF_2_30 ) , .D ( n1636_CDR2 ) , .Y ( HFSNET_73 ) ) ;
OAI2BB1X1 U889 ( .A0N ( n1985 ) , .A1N ( n1989 ) , .B0 ( n315 ) , 
    .Y ( N1692 ) ) ;
AOI22XL U890 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][17] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][17] ) , .Y ( n1253_CDR1 ) ) ;
AOI22XL U891 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][2] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][2] ) , 
    .Y ( n742_CDR1 ) ) ;
AOI22XL U892 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][24] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][24] ) , 
    .Y ( n1401_CDR2 ) ) ;
INVXL ctmTdsLR_1_1879 ( .A ( tmp_net358 ) , .Y ( ZBUF_24_19 ) ) ;
NAND2XL U894 ( .A ( n2034 ) , .B ( n2006 ) , .Y ( n2008 ) ) ;
AOI22XL U895 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][16] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][16] ) , .Y ( n1239_CDR2 ) ) ;
AOI22XL U896 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][18] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][18] ) , .Y ( n1276_CDR2 ) ) ;
AOI22X1 U897 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][10] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][10] ) , 
    .Y ( n1118_CDR2 ) ) ;
INVX4 U898 ( .A ( n1302 ) , .Y ( n1270 ) ) ;
AOI22X1 U899 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][9] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][9] ) , .Y ( n1093 ) ) ;
NAND3XL U900 ( .A ( n968 ) , .B ( n315 ) , .C ( n322 ) , .Y ( N1536 ) ) ;
NAND2XL U901 ( .A ( n1993 ) , .B ( n1992 ) , .Y ( n2004 ) ) ;
INVXL U902 ( .A ( n666 ) , .Y ( n664 ) ) ;
AOI22XL U903 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][25] ) , 
    .B0 ( n1662 ) , .B1 ( \shadow_weights[9][25] ) , .Y ( n1469_CDR1 ) ) ;
NAND4XL ctmTdsLR_4_1837 ( .A ( ZBUF_2_50 ) , .B ( tmp_net329 ) , 
    .C ( ZBUF_2_49 ) , .D ( tmp_net330 ) , .Y ( tmp_net331 ) ) ;
CLKINVX3 U905 ( .A ( n1309 ) , .Y ( n1277 ) ) ;
NAND2XL U906 ( .A ( n156 ) , .B ( n155 ) , .Y ( n157 ) ) ;
INVXL U907 ( .A ( n174 ) , .Y ( n180 ) ) ;
INVX3 U908 ( .A ( n1310 ) , .Y ( n1279 ) ) ;
NAND2XL U915 ( .A ( n192 ) , .B ( n190 ) , .Y ( n188 ) ) ;
INVX4 U918 ( .A ( n1306 ) , .Y ( n1274 ) ) ;
NAND2XL U919 ( .A ( n165 ) , .B ( n164 ) , .Y ( n166 ) ) ;
INVXL U920 ( .A ( n2024 ) , .Y ( n2034 ) ) ;
NAND2XL U922 ( .A ( n199 ) , .B ( n76 ) , .Y ( n78 ) ) ;
CLKINVX3 U923 ( .A ( n1311 ) , .Y ( n1281 ) ) ;
AND4XL ctmTdsLR_2_1880 ( .A ( tmp_net326 ) , .B ( n1534_CDR1 ) , 
    .C ( tmp_net300 ) , .D ( tmp_net297 ) , .Y ( tmp_net358 ) ) ;
AOI222XL ctmTdsLR_1_711 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][2] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][2] ) , 
    .C0 ( n1270 ) , .C1 ( \shadow_weights[14][2] ) , .Y ( tmp_net40 ) ) ;
NAND2XL U927 ( .A ( n2009 ) , .B ( n2010 ) , .Y ( n2017 ) ) ;
INVXL U929 ( .A ( n487 ) , .Y ( n411 ) ) ;
OAI21XL ctmTdsLR_1_2016 ( .A0 ( tmp_net215 ) , .A1 ( n1439 ) , 
    .B0 ( tmp_net437 ) , .Y ( n1441 ) ) ;
INVXL U933 ( .A ( n432 ) , .Y ( n433 ) ) ;
NAND2XL U934 ( .A ( n118 ) , .B ( n116 ) , .Y ( n107 ) ) ;
AOI21XL U936 ( .A0 ( n82 ) , .A1 ( n103 ) , .B0 ( n81 ) , .Y ( n83 ) ) ;
BUFX1 ZBUF_2_inst_1028 ( .A ( tmp_net37 ) , .Y ( ZBUF_2_13 ) ) ;
CLKINVX3 U938 ( .A ( n675 ) , .Y ( n1671 ) ) ;
CLKINVX3 U939 ( .A ( n676 ) , .Y ( n1673 ) ) ;
NAND2XL U941 ( .A ( avg_cnt[2] ) , .B ( n344 ) , .Y ( n345 ) ) ;
OR3X2 U943 ( .A ( n1990 ) , .B ( state[2] ) , .C ( n2172 ) , .Y ( n322 ) ) ;
INVXL U944 ( .A ( n2115 ) , .Y ( n2125 ) ) ;
NAND2XL U946 ( .A ( n808 ) , .B ( n807 ) , .Y ( n811 ) ) ;
NAND2XL U947 ( .A ( n132 ) , .B ( n128 ) , .Y ( n89 ) ) ;
OR2XL U948 ( .A ( n808 ) , .B ( n807 ) , .Y ( n813 ) ) ;
OR2XL U951 ( .A ( n646 ) , .B ( n645 ) , .Y ( n694 ) ) ;
NAND2XL U952 ( .A ( n586 ) , .B ( n585 ) , .Y ( n642 ) ) ;
NAND2XL U953 ( .A ( n128 ) , .B ( n127 ) , .Y ( n129 ) ) ;
NAND2XL U954 ( .A ( n646 ) , .B ( n645 ) , .Y ( n692 ) ) ;
NAND2XL U955 ( .A ( n718 ) , .B ( n696 ) , .Y ( n804 ) ) ;
NAND2XL U956 ( .A ( n565 ) , .B ( n564 ) , .Y ( n581 ) ) ;
NAND2XL U957 ( .A ( n397 ) , .B ( n396 ) , .Y ( n606 ) ) ;
OR2XL U958 ( .A ( n565 ) , .B ( n564 ) , .Y ( n583 ) ) ;
NAND2XL U960 ( .A ( n513 ) , .B ( n512 ) , .Y ( n561 ) ) ;
NAND2XL U961 ( .A ( n132 ) , .B ( n131 ) , .Y ( n133 ) ) ;
NAND2XL U962 ( .A ( n463 ) , .B ( n462 ) , .Y ( n508 ) ) ;
NAND2XL U964 ( .A ( n410 ) , .B ( n409 ) , .Y ( n487 ) ) ;
NAND2XL U965 ( .A ( n437 ) , .B ( n436 ) , .Y ( n459 ) ) ;
NOR2XL U966 ( .A ( n437 ) , .B ( n436 ) , .Y ( n460 ) ) ;
NAND2XL U967 ( .A ( n420 ) , .B ( n419 ) , .Y ( n432 ) ) ;
NAND2XL U968 ( .A ( n413 ) , .B ( n412 ) , .Y ( n552 ) ) ;
NAND2XL U969 ( .A ( n415 ) , .B ( n414 ) , .Y ( n494 ) ) ;
NAND2XL ctmTdsLR_2_2017 ( .A ( tmp_net436 ) , .B ( n1437 ) , .Y ( n1439 ) ) ;
INVXL U972 ( .A ( n155 ) , .Y ( n109 ) ) ;
INVXL U973 ( .A ( n280 ) , .Y ( n281 ) ) ;
INVXL U974 ( .A ( n108 ) , .Y ( n156 ) ) ;
INVXL U977 ( .A ( n187 ) , .Y ( n192 ) ) ;
AOI22XL ctmTdsLR_6_1904 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][1] ) , 
    .B0 ( n1292 ) , .B1 ( \shadow_weights[2][1] ) , .Y ( tmp_net371 ) ) ;
INVXL U979 ( .A ( n1142 ) , .Y ( n1143 ) ) ;
NAND2XL U982 ( .A ( n242 ) , .B ( n241 ) , .Y ( n243 ) ) ;
OAI2BB1XL ctmTdsLR_2_1732 ( .A0N ( \shadow_weights[7][3] ) , 
    .A1N ( HFSNET_342 ) , .B0 ( n780_CDR2 ) , .Y ( tmp_net256 ) ) ;
INVXL U986 ( .A ( n148 ) , .Y ( n165 ) ) ;
INVXL U988 ( .A ( n1549 ) , .Y ( n1550 ) ) ;
NAND2XL U989 ( .A ( n824 ) , .B ( n2194 ) , .Y ( n1080 ) ) ;
NAND2XL U992 ( .A ( n2158 ) , .B ( n2010 ) , .Y ( n2072 ) ) ;
NAND2XL U993 ( .A ( N1822 ) , .B ( n2162 ) , .Y ( n829 ) ) ;
NAND2XL U994 ( .A ( n141 ) , .B ( n140 ) , .Y ( n142 ) ) ;
INVXL U996 ( .A ( n2020 ) , .Y ( n2047 ) ) ;
NOR2XL ctmTdsLR_4_1949 ( .A ( n240 ) , .B ( n239 ) , .Y ( tmp_net399 ) ) ;
AOI222X1 ctmTdsLR_3_715 ( .A0 ( HFSNET_244 ) , .A1 ( n1280 ) , .B0 ( n1282 ) , 
    .B1 ( \shadow_weights[17][9] ) , .C0 ( \shadow_weights[19][9] ) , 
    .C1 ( n1281 ) , .Y ( tmp_net43 ) ) ;
INVXL U999 ( .A ( n1988 ) , .Y ( n64 ) ) ;
INVXL U1000 ( .A ( n654 ) , .Y ( n63 ) ) ;
NAND2XL U1001 ( .A ( temp_acc[7] ) , .B ( \shadow_weights[17][7] ) , 
    .Y ( n210 ) ) ;
NAND2XL U1002 ( .A ( temp_acc[11] ) , .B ( \shadow_weights[17][11] ) , 
    .Y ( n151 ) ) ;
NAND2XL U1003 ( .A ( temp_acc[13] ) , .B ( \shadow_weights[17][13] ) , 
    .Y ( n112 ) ) ;
NAND2XL U1004 ( .A ( temp_acc[15] ) , .B ( \shadow_weights[17][15] ) , 
    .Y ( n121 ) ) ;
OR2XL U1005 ( .A ( temp_acc[16] ) , .B ( \shadow_weights[17][16] ) , 
    .Y ( n132 ) ) ;
NAND2XL U1006 ( .A ( temp_acc[16] ) , .B ( \shadow_weights[17][16] ) , 
    .Y ( n131 ) ) ;
NAND2XL U1007 ( .A ( n2195 ) , .B ( accumulator[30] ) , .Y ( n1142 ) ) ;
NAND2XL U1008 ( .A ( temp_acc[17] ) , .B ( \shadow_weights[17][17] ) , 
    .Y ( n127 ) ) ;
OR2XL U1009 ( .A ( temp_acc[18] ) , .B ( \shadow_weights[17][18] ) , 
    .Y ( n141 ) ) ;
NOR2XL U1010 ( .A ( n2196 ) , .B ( accumulator[31] ) , .Y ( n1494 ) ) ;
NAND2XL U1011 ( .A ( n2196 ) , .B ( accumulator[31] ) , .Y ( n1493 ) ) ;
OR2X1 U1012 ( .A ( n319 ) , .B ( state[1] ) , .Y ( n729 ) ) ;
NAND2XL U1013 ( .A ( n2198 ) , .B ( accumulator[32] ) , .Y ( n1549 ) ) ;
NAND2XL U1014 ( .A ( n2200 ) , .B ( accumulator[33] ) , .Y ( n1576 ) ) ;
NAND2XL U1015 ( .A ( temp_acc[28] ) , .B ( \shadow_weights[17][28] ) , 
    .Y ( n280 ) ) ;
NAND2XL U1016 ( .A ( temp_acc[26] ) , .B ( \shadow_weights[17][26] ) , 
    .Y ( n261 ) ) ;
NAND2XL U1017 ( .A ( temp_acc[27] ) , .B ( \shadow_weights[17][27] ) , 
    .Y ( n267 ) ) ;
OR2XL U1018 ( .A ( temp_acc[26] ) , .B ( \shadow_weights[17][26] ) , 
    .Y ( n263 ) ) ;
NAND2XL ctmTdsLR_5_1838 ( .A ( gre_a_INV_5313_58 ) , 
    .B ( \shadow_weights[12][7] ) , .Y ( tmp_net329 ) ) ;
AOI22XL ctmTdsLR_6_1839 ( .A0 ( n1266 ) , .A1 ( \shadow_weights[3][7] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][7] ) , 
    .Y ( tmp_net330 ) ) ;
AOI21XL ctmTdsLR_1_1950 ( .A0 ( n139 ) , .A1 ( n138 ) , .B0 ( tmp_net401 ) , 
    .Y ( n1793 ) ) ;
OR4X1 ctmTdsLR_1_1905 ( .A ( tmp_net134 ) , .B ( tmp_net311 ) , 
    .C ( tmp_net313 ) , .D ( tmp_net375 ) , .Y ( HFSNET_172 ) ) ;
NAND3XL U1024 ( .A ( state[0] ) , .B ( state[3] ) , .C ( n68 ) , .Y ( n319 ) ) ;
NOR2XL U1026 ( .A ( state[2] ) , .B ( state[3] ) , .Y ( n297 ) ) ;
NOR2XL U1027 ( .A ( target_bit[2] ) , .B ( target_bit[0] ) , .Y ( n2010 ) ) ;
OAI21X1 U1028 ( .A0 ( n1857 ) , .A1 ( n224 ) , .B0 ( n223 ) , .Y ( n1779 ) ) ;
OAI21XL U1029 ( .A0 ( ZBUF_4201_28 ) , .A1 ( n2025 ) , .B0 ( n2029 ) , 
    .Y ( n57 ) ) ;
NAND2XL ctmTdsLR_2_1951 ( .A ( tmp_net400 ) , .B ( n136 ) , .Y ( n138 ) ) ;
OAI21XL U1031 ( .A0 ( n502 ) , .A1 ( n499 ) , .B0 ( n503 ) , .Y ( n485 ) ) ;
NAND2XL U1032 ( .A ( n2173 ) , .B ( calc_cnt[1] ) , .Y ( n630 ) ) ;
OAI21XL U1033 ( .A0 ( n1947 ) , .A1 ( n1944 ) , .B0 ( n1945 ) , .Y ( n1938 ) ) ;
NAND2XL U1034 ( .A ( sar_ptr[1] ) , .B ( n2199 ) , .Y ( n2128 ) ) ;
NOR2X2 U1035 ( .A ( n2076 ) , .B ( n474 ) , .Y ( n2118 ) ) ;
NAND2XL ctmTdsLR_1_718 ( .A ( n465 ) , .B ( HFSNET_347 ) , .Y ( HFSNET_11 ) ) ;
NAND2X2 U1037 ( .A ( n2020 ) , .B ( n2158 ) , .Y ( n2018 ) ) ;
OAI221XL U1038 ( .A0 ( HFSNET_249 ) , .A1 ( overrange_bits[9] ) , 
    .B0 ( N1833 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n708 ) ) ;
NAND2XL U1039 ( .A ( n2009 ) , .B ( n2033 ) , .Y ( n2015 ) ) ;
OR2X4 U1040 ( .A ( n1989 ) , .B ( n733 ) , .Y ( n1875 ) ) ;
NOR2X1 U1041 ( .A ( n56 ) , .B ( n1990 ) , .Y ( n1989 ) ) ;
CLKINVX3 U1042 ( .A ( n676 ) , .Y ( n1282 ) ) ;
CLKINVX3 U1043 ( .A ( n675 ) , .Y ( n1280 ) ) ;
NAND2X1 U1044 ( .A ( calc_cnt[0] ) , .B ( n2174 ) , .Y ( n626 ) ) ;
AND4XL ctmTdsLR_2_1779 ( .A ( tmp_net75 ) , .B ( tmp_net76 ) , 
    .C ( tmp_net73 ) , .D ( tmp_net74 ) , .Y ( tmp_net286 ) ) ;
OAI21XL U1046 ( .A0 ( n665 ) , .A1 ( n658 ) , .B0 ( N1822 ) , .Y ( n1655 ) ) ;
NOR2X2 U1047 ( .A ( n67 ) , .B ( n319 ) , .Y ( N1822 ) ) ;
NOR2XL U1048 ( .A ( n580 ) , .B ( wait_cnt[3] ) , .Y ( n579 ) ) ;
INVXL HFSINV_123_506 ( .A ( N1826 ) , .Y ( HFSNET_250 ) ) ;
NAND3XL U1050 ( .A ( n639 ) , .B ( n638 ) , .C ( start_calib ) , .Y ( n659 ) ) ;
NOR2XL U1051 ( .A ( n68 ) , .B ( n2172 ) , .Y ( n638 ) ) ;
OAI21XL U1052 ( .A0 ( n2073 ) , .A1 ( n2024 ) , .B0 ( n2053 ) , .Y ( n2054 ) ) ;
OAI21XL U1053 ( .A0 ( n2073 ) , .A1 ( ZBUF_4201_28 ) , .B0 ( n2178 ) , 
    .Y ( n2056 ) ) ;
NAND2X1 U1054 ( .A ( target_bit[0] ) , .B ( target_bit[2] ) , .Y ( n2073 ) ) ;
NOR2XL U1055 ( .A ( wait_cnt[1] ) , .B ( wait_cnt[0] ) , .Y ( n1984 ) ) ;
NAND2XL U1058 ( .A ( sar_ptr[0] ) , .B ( sar_ptr[1] ) , .Y ( n2132 ) ) ;
OAI21XL U1063 ( .A0 ( n2179 ) , .A1 ( n2024 ) , .B0 ( n2053 ) , .Y ( n2050 ) ) ;
AOI2BB1XL U1064 ( .A0N ( n2179 ) , .A1N ( ZBUF_4201_28 ) , 
    .B0 ( target_bit[4] ) , .Y ( n2053 ) ) ;
INVXL ctmTdsLR_3_1952 ( .A ( n135 ) , .Y ( tmp_net400 ) ) ;
AND2X2 U1066 ( .A ( n55 ) , .B ( target_bit[0] ) , .Y ( n292 ) ) ;
OAI22XL U1067 ( .A0 ( ZBUF_145_35 ) , .A1 ( n2000 ) , .B0 ( n2183 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[8] ) ) ;
OAI22XL U1068 ( .A0 ( n2019 ) , .A1 ( n2012 ) , .B0 ( n2180 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[7] ) ) ;
OAI22XL U1069 ( .A0 ( ZBUF_145_35 ) , .A1 ( n1999 ) , .B0 ( n2167 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[9] ) ) ;
OAI22X2 U1070 ( .A0 ( n2000 ) , .A1 ( n2031 ) , .B0 ( n2011 ) , 
    .B1 ( n2165 ) , .Y ( dac_p_force[2] ) ) ;
NAND2XL U1071 ( .A ( n2010 ) , .B ( n1996 ) , .Y ( n2000 ) ) ;
OAI22XL U1072 ( .A0 ( ZBUF_4201_28 ) , .A1 ( n2000 ) , .B0 ( n2166 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[10] ) ) ;
OAI22XL U1073 ( .A0 ( n2016 ) , .A1 ( n2180 ) , .B0 ( n2012 ) , 
    .B1 ( n2011 ) , .Y ( dac_n_force[7] ) ) ;
OAI22XL U1074 ( .A0 ( ZBUF_4201_28 ) , .A1 ( n1999 ) , .B0 ( n2164 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[11] ) ) ;
OAI22XL U1075 ( .A0 ( n2002 ) , .A1 ( n2016 ) , .B0 ( gre_a_INV_2586_58 ) , 
    .B1 ( n2007 ) , .Y ( dac_n_force[18] ) ) ;
OAI22X2 U1076 ( .A0 ( n1999 ) , .A1 ( n2031 ) , .B0 ( n2007 ) , 
    .B1 ( n2181 ) , .Y ( dac_p_force[3] ) ) ;
OAI22XL U1077 ( .A0 ( n2019 ) , .A1 ( n2182 ) , .B0 ( ZBUF_4201_28 ) , 
    .B1 ( n2013 ) , .Y ( dac_n_force[15] ) ) ;
OAI22XL U1078 ( .A0 ( n2019 ) , .A1 ( n2188 ) , .B0 ( ZBUF_145_35 ) , 
    .B1 ( n2013 ) , .Y ( dac_n_force[13] ) ) ;
OAI22XL U1079 ( .A0 ( n2019 ) , .A1 ( n2184 ) , .B0 ( ZBUF_4201_28 ) , 
    .B1 ( n2014 ) , .Y ( dac_n_force[14] ) ) ;
OAI22XL U1080 ( .A0 ( n2016 ) , .A1 ( n2168 ) , .B0 ( n2031 ) , 
    .B1 ( n2014 ) , .Y ( dac_n_force[6] ) ) ;
OAI22XL U1081 ( .A0 ( n2016 ) , .A1 ( n2181 ) , .B0 ( n2015 ) , 
    .B1 ( n2031 ) , .Y ( dac_n_force[3] ) ) ;
OAI22XL U1082 ( .A0 ( n2016 ) , .A1 ( n2167 ) , .B0 ( ZBUF_145_35 ) , 
    .B1 ( n2015 ) , .Y ( dac_n_force[9] ) ) ;
OAI22XL U1083 ( .A0 ( n2019 ) , .A1 ( n2164 ) , .B0 ( ZBUF_4201_28 ) , 
    .B1 ( n2015 ) , .Y ( dac_n_force[11] ) ) ;
OAI22X2 U1084 ( .A0 ( n2007 ) , .A1 ( n2168 ) , .B0 ( n1998 ) , 
    .B1 ( n2031 ) , .Y ( dac_p_force[6] ) ) ;
OAI22XL U1085 ( .A0 ( n2016 ) , .A1 ( n2186 ) , .B0 ( n2018 ) , 
    .B1 ( n2015 ) , .Y ( dac_n_force[1] ) ) ;
OAI22XL U1086 ( .A0 ( n2016 ) , .A1 ( n2190 ) , .B0 ( n2018 ) , 
    .B1 ( n2014 ) , .Y ( dac_n_force[4] ) ) ;
OAI22XL U1087 ( .A0 ( n2016 ) , .A1 ( n2191 ) , .B0 ( n2018 ) , 
    .B1 ( n2013 ) , .Y ( dac_n_force[5] ) ) ;
OAI22X2 U1088 ( .A0 ( n2007 ) , .A1 ( n2186 ) , .B0 ( n1999 ) , 
    .B1 ( n2018 ) , .Y ( dac_p_force[1] ) ) ;
NAND2XL U1089 ( .A ( n1996 ) , .B ( n2033 ) , .Y ( n1999 ) ) ;
OAI22X2 U1090 ( .A0 ( n2007 ) , .A1 ( n2190 ) , .B0 ( n1998 ) , 
    .B1 ( n2018 ) , .Y ( dac_p_force[4] ) ) ;
OAI22X2 U1091 ( .A0 ( n2007 ) , .A1 ( n2191 ) , .B0 ( n1997 ) , 
    .B1 ( n2018 ) , .Y ( dac_p_force[5] ) ) ;
OAI22XL U1092 ( .A0 ( n2019 ) , .A1 ( n2185 ) , .B0 ( n2018 ) , 
    .B1 ( n2017 ) , .Y ( dac_n_force[0] ) ) ;
CLKINVX2 U1093 ( .A ( n1996 ) , .Y ( n2019 ) ) ;
OAI22XL U1094 ( .A0 ( n2016 ) , .A1 ( n2165 ) , .B0 ( n2017 ) , 
    .B1 ( n2031 ) , .Y ( dac_n_force[2] ) ) ;
OAI22XL U1095 ( .A0 ( n2016 ) , .A1 ( n2183 ) , .B0 ( ZBUF_145_35 ) , 
    .B1 ( n2017 ) , .Y ( dac_n_force[8] ) ) ;
OAI22XL U1096 ( .A0 ( n2016 ) , .A1 ( n2166 ) , .B0 ( ZBUF_4201_28 ) , 
    .B1 ( n2017 ) , .Y ( dac_n_force[10] ) ) ;
CLKINVX2 U1097 ( .A ( n1996 ) , .Y ( n2016 ) ) ;
OAI22XL U1098 ( .A0 ( n2185 ) , .A1 ( n2007 ) , .B0 ( n2000 ) , 
    .B1 ( n2018 ) , .Y ( dac_p_force[0] ) ) ;
OAI22XL U1099 ( .A0 ( n2002 ) , .A1 ( n2007 ) , .B0 ( n2016 ) , 
    .B1 ( gre_a_INV_2586_58 ) , .Y ( dac_p_force[18] ) ) ;
NOR2BX1 U1100 ( .AN ( n1988 ) , .B ( n2171 ) , .Y ( n725 ) ) ;
NOR3XL U1101 ( .A ( n67 ) , .B ( state[2] ) , .C ( state[3] ) , .Y ( n1988 ) ) ;
AOI222XL ctmTdsLR_3_721 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][8] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][8] ) , 
    .C0 ( \shadow_weights[19][8] ) , .C1 ( n1281 ) , .Y ( tmp_net47 ) ) ;
NOR2XL ctmTdsLR_4_1953 ( .A ( n139 ) , .B ( n138 ) , .Y ( tmp_net401 ) ) ;
NAND2BXL ctmTdsLR_2_1906 ( .AN ( tmp_net312 ) , .B ( tmp_net374 ) , 
    .Y ( tmp_net375 ) ) ;
NOR3X2 U1106 ( .A ( state[0] ) , .B ( n67 ) , .C ( n56 ) , .Y ( n663 ) ) ;
AOI222XL ctmTdsLR_1_724 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][2] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][2] ) , 
    .C0 ( \shadow_weights[19][2] ) , .C1 ( n1281 ) , .Y ( tmp_net49 ) ) ;
NAND2XL ctmTdsLR_2_725 ( .A ( n1279 ) , .B ( \shadow_weights[16][2] ) , 
    .Y ( tmp_net50 ) ) ;
NAND2XL ctmTdsLR_3_1907 ( .A ( gre_a_INV_6625_58 ) , 
    .B ( \shadow_weights[15][8] ) , .Y ( tmp_net374 ) ) ;
NAND2XL ctmTdsLR_1_727 ( .A ( n1456 ) , .B ( n1459 ) , .Y ( tmp_net51 ) ) ;
OAI211X1 ctmTdsLR_2_728 ( .A0 ( n1417 ) , .A1 ( n1398 ) , .B0 ( tmp_net51 ) , 
    .C0 ( n1458 ) , .Y ( n1466 ) ) ;
OAI21XL ctmTdsLR_1_1954 ( .A0 ( n271 ) , .A1 ( n279 ) , .B0 ( tmp_net402 ) , 
    .Y ( n275 ) ) ;
AND3XL ctmTdsLR_2_1841 ( .A ( tmp_net332 ) , .B ( n1150_CDR1 ) , 
    .C ( ZBUF_2_45 ) , .Y ( tmp_net333 ) ) ;
CLKINVX2 U1114 ( .A ( n1311 ) , .Y ( n1672 ) ) ;
INVX2 U1115 ( .A ( n1309 ) , .Y ( n1668 ) ) ;
INVX2 U1116 ( .A ( n1306 ) , .Y ( n1662 ) ) ;
CLKINVX3 U1117 ( .A ( n1302 ) , .Y ( n1679 ) ) ;
INVX2 U1118 ( .A ( n1300 ) , .Y ( n1677 ) ) ;
INVX2 U1119 ( .A ( n1298 ) , .Y ( n1660 ) ) ;
CLKINVX2 U1120 ( .A ( n1310 ) , .Y ( n1670 ) ) ;
AOI222XL ctmTdsLR_3_1842 ( .A0 ( gre_a_INV_6238_58 ) , 
    .A1 ( \shadow_weights[1][11] ) , .B0 ( n1266 ) , 
    .B1 ( \shadow_weights[3][11] ) , .C0 ( gre_a_INV_6610_58 ) , 
    .C1 ( \shadow_weights[11][11] ) , .Y ( tmp_net332 ) ) ;
NAND2XL ctmTdsLR_1_748 ( .A ( n1278 ) , .B ( \shadow_weights[8][10] ) , 
    .Y ( tmp_net65 ) ) ;
OAI22XL U1124 ( .A0 ( n2019 ) , .A1 ( n2021 ) , .B0 ( n2003 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[17] ) ) ;
OAI22XL U1125 ( .A0 ( n2019 ) , .A1 ( n2004 ) , .B0 ( n2189 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[16] ) ) ;
OAI22XL U1126 ( .A0 ( ZBUF_4201_28 ) , .A1 ( n1997 ) , .B0 ( n2182 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[15] ) ) ;
OAI22XL U1127 ( .A0 ( ZBUF_4201_28 ) , .A1 ( n1998 ) , .B0 ( n2184 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[14] ) ) ;
OAI22XL U1128 ( .A0 ( ZBUF_145_35 ) , .A1 ( n1997 ) , .B0 ( n2188 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[13] ) ) ;
OAI22XL U1129 ( .A0 ( n2019 ) , .A1 ( n2008 ) , .B0 ( n2187 ) , 
    .B1 ( n2011 ) , .Y ( dac_p_force[12] ) ) ;
CLKINVX2 U1130 ( .A ( n2009 ) , .Y ( n2011 ) ) ;
OAI21XL U1132 ( .A0 ( n426 ) , .A1 ( n423 ) , .B0 ( n427 ) , .Y ( n441 ) ) ;
OAI21XL U1133 ( .A0 ( n1881 ) , .A1 ( n1890 ) , .B0 ( n1882 ) , .Y ( n1858 ) ) ;
OAI21XL U1134 ( .A0 ( n1450 ) , .A1 ( n1447 ) , .B0 ( n1451 ) , .Y ( n1498 ) ) ;
OAI21XL U1135 ( .A0 ( n1054 ) , .A1 ( n1053 ) , .B0 ( n1052 ) , .Y ( n1085 ) ) ;
OAI21XL U1136 ( .A0 ( n193 ) , .A1 ( n190 ) , .B0 ( n194 ) , .Y ( n198 ) ) ;
OAI21XL U1137 ( .A0 ( n644 ) , .A1 ( n643 ) , .B0 ( n642 ) , .Y ( n695 ) ) ;
OAI21XL U1138 ( .A0 ( n461 ) , .A1 ( n460 ) , .B0 ( n459 ) , .Y ( n511 ) ) ;
OAI21XL U1139 ( .A0 ( n1707 ) , .A1 ( n1703 ) , .B0 ( n1704 ) , .Y ( n279 ) ) ;
NAND2XL ctmTdsLR_2_749 ( .A ( n1277 ) , .B ( \shadow_weights[10][10] ) , 
    .Y ( tmp_net66 ) ) ;
NAND2XL ctmTdsLR_4_953 ( .A ( tmp_net77 ) , .B ( tmp_net201 ) , 
    .Y ( HFSNET_127 ) ) ;
BUFX8 ZCTSBUF_251_1345 ( .A ( net1731 ) , .Y ( ZCTSNET_392 ) ) ;
XNOR2XL U1145 ( .A ( n1956 ) , .B ( n1955 ) , .Y ( n1960 ) ) ;
NOR3X4 U1146 ( .A ( wr_idx_r[4] ) , .B ( wr_idx_r[3] ) , .C ( n671 ) , 
    .Y ( N1841 ) ) ;
NAND2X1 U1147 ( .A ( n666 ) , .B ( n2177 ) , .Y ( n671 ) ) ;
OAI21XL U1148 ( .A0 ( n2031 ) , .A1 ( n2025 ) , .B0 ( n2049 ) , .Y ( n2045 ) ) ;
NOR2X1 U1149 ( .A ( n2047 ) , .B ( target_bit[2] ) , .Y ( n2049 ) ) ;
NAND2X2 U1150 ( .A ( target_bit[1] ) , .B ( n2020 ) , .Y ( n2031 ) ) ;
NOR2X1 U1151 ( .A ( target_bit[3] ) , .B ( target_bit[4] ) , .Y ( n2020 ) ) ;
NAND2X1 U1153 ( .A ( n559 ) , .B ( n2159 ) , .Y ( n669 ) ) ;
NOR2X1 U1154 ( .A ( n2163 ) , .B ( target_bit[2] ) , .Y ( n2033 ) ) ;
NOR2XL U1155 ( .A ( n2076 ) , .B ( n1627 ) , .Y ( n641 ) ) ;
NOR2X2 U1156 ( .A ( n725 ) , .B ( n663 ) , .Y ( n2076 ) ) ;
NOR2BXL U1157 ( .AN ( n579 ) , .B ( wait_cnt[4] ) , .Y ( n1627 ) ) ;
AOI222X1 ctmTdsLR_3_750 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][10] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][10] ) , 
    .C0 ( \shadow_weights[19][10] ) , .C1 ( n1281 ) , .Y ( tmp_net67 ) ) ;
NAND2XL ctmTdsLR_4_751 ( .A ( n1279 ) , .B ( \shadow_weights[16][10] ) , 
    .Y ( tmp_net68 ) ) ;
NOR2X4 U1160 ( .A ( n627 ) , .B ( n626 ) , .Y ( n1291 ) ) ;
NOR2BX1 ctmTdsLR_1_1843 ( .AN ( n1276_CDR2 ) , .B ( tmp_net337 ) , 
    .Y ( n1296_CDR1 ) ) ;
INVX2 U1163 ( .A ( n1320 ) , .Y ( n1686 ) ) ;
INVX2 U1167 ( .A ( n1308 ) , .Y ( n1669 ) ) ;
NAND2XL ctmTdsLR_1_753 ( .A ( n1278 ) , .B ( \shadow_weights[8][17] ) , 
    .Y ( tmp_net69 ) ) ;
OAI22XL U1170 ( .A0 ( n2019 ) , .A1 ( n2189 ) , .B0 ( n2007 ) , 
    .B1 ( n2004 ) , .Y ( dac_n_force[16] ) ) ;
OAI22XL U1171 ( .A0 ( n2019 ) , .A1 ( n2192 ) , .B0 ( HFSNET_346 ) , 
    .B1 ( n2007 ) , .Y ( dac_n_force[19] ) ) ;
OAI22X1 U1172 ( .A0 ( n2019 ) , .A1 ( n2003 ) , .B0 ( n2021 ) , 
    .B1 ( n2007 ) , .Y ( dac_n_force[17] ) ) ;
OAI22XL U1173 ( .A0 ( n2019 ) , .A1 ( n2187 ) , .B0 ( n2008 ) , 
    .B1 ( n2007 ) , .Y ( dac_n_force[12] ) ) ;
OAI22XL U1174 ( .A0 ( n2016 ) , .A1 ( HFSNET_346 ) , .B0 ( n2192 ) , 
    .B1 ( n2007 ) , .Y ( dac_p_force[19] ) ) ;
CLKINVX2 U1175 ( .A ( n2009 ) , .Y ( n2007 ) ) ;
NAND2XL ctmTdsLR_2_754 ( .A ( n1277 ) , .B ( \shadow_weights[10][17] ) , 
    .Y ( tmp_net70 ) ) ;
AOI222X1 ctmTdsLR_3_755 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][17] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][17] ) , 
    .C0 ( \shadow_weights[19][17] ) , .C1 ( n1281 ) , .Y ( tmp_net71 ) ) ;
INVX4 HFSINV_622_598 ( .A ( calc_result_r[5] ) , .Y ( HFSNET_337 ) ) ;
NAND2XL ctmTdsLR_4_756 ( .A ( n1279 ) , .B ( \shadow_weights[16][17] ) , 
    .Y ( tmp_net72 ) ) ;
AOI222XL ctmTdsLR_1_954 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][20] ) , 
    .B0 ( ZBUF_20020_1 ) , .B1 ( \shadow_weights[0][20] ) , .C0 ( n1687 ) , 
    .C1 ( \shadow_weights[2][20] ) , .Y ( tmp_net202 ) ) ;
NAND2XL ctmTdsLR_1_758 ( .A ( n516 ) , .B ( HFSNET_347 ) , .Y ( HFSNET_12 ) ) ;
CLKINVX8 HFSINV_710_578 ( .A ( calc_result_r[1] ) , .Y ( HFSNET_317 ) ) ;
NAND2XL ctmTdsLR_1_759 ( .A ( n1278 ) , .B ( \shadow_weights[8][1] ) , 
    .Y ( tmp_net73 ) ) ;
INVX4 HFSINV_710_573 ( .A ( calc_result_r[14] ) , .Y ( HFSNET_312 ) ) ;
INVX4 U1188 ( .A ( calc_result_r[28] ) , .Y ( n2306 ) ) ;
INVX4 U1189 ( .A ( calc_result_r[27] ) , .Y ( n2305 ) ) ;
INVX4 HFSINV_1117_583 ( .A ( calc_result_r[25] ) , .Y ( HFSNET_322 ) ) ;
INVX4 HFSINV_733_582 ( .A ( calc_result_r[24] ) , .Y ( HFSNET_321 ) ) ;
INVX4 HFSINV_722_581 ( .A ( calc_result_r[23] ) , .Y ( HFSNET_320 ) ) ;
INVX4 HFSINV_957_580 ( .A ( calc_result_r[22] ) , .Y ( HFSNET_319 ) ) ;
INVX4 HFSINV_777_579 ( .A ( calc_result_r[21] ) , .Y ( HFSNET_318 ) ) ;
CLKINVX3 U1195 ( .A ( calc_result_r[20] ) , .Y ( n2299 ) ) ;
CLKINVX3 U1196 ( .A ( calc_result_r[19] ) , .Y ( n2298 ) ) ;
INVX4 HFSINV_655_577 ( .A ( calc_result_r[18] ) , .Y ( HFSNET_316 ) ) ;
NAND2XL ctmTdsLR_2_760 ( .A ( n1277 ) , .B ( \shadow_weights[10][1] ) , 
    .Y ( tmp_net74 ) ) ;
INVX4 HFSINV_753_584 ( .A ( calc_result_r[29] ) , .Y ( HFSNET_323 ) ) ;
INVX4 HFSINV_702_576 ( .A ( calc_result_r[17] ) , .Y ( HFSNET_315 ) ) ;
CLKINVX8 HFSINV_651_575 ( .A ( calc_result_r[16] ) , .Y ( HFSNET_314 ) ) ;
INVX4 HFSINV_697_574 ( .A ( calc_result_r[15] ) , .Y ( HFSNET_313 ) ) ;
CLKBUFX3 U1203 ( .A ( orr_r ) , .Y ( n2157 ) ) ;
AOI222XL ctmTdsLR_3_761 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][1] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][1] ) , 
    .C0 ( \shadow_weights[19][1] ) , .C1 ( n1281 ) , .Y ( tmp_net75 ) ) ;
AOI21XL U1206 ( .A0 ( n143 ) , .A1 ( n141 ) , .B0 ( n90 ) , .Y ( n139 ) ) ;
OAI21XL U1207 ( .A0 ( n139 ) , .A1 ( n135 ) , .B0 ( n136 ) , .Y ( n244 ) ) ;
OAI21XL U1208 ( .A0 ( n240 ) , .A1 ( n236 ) , .B0 ( n237 ) , .Y ( n235 ) ) ;
OAI21XL U1209 ( .A0 ( n1082 ) , .A1 ( n1081 ) , .B0 ( n1080 ) , .Y ( n1145 ) ) ;
OAI21XL U1210 ( .A0 ( n1495 ) , .A1 ( n1494 ) , .B0 ( n1493 ) , .Y ( n1552 ) ) ;
OAI21XL U1211 ( .A0 ( n1724 ) , .A1 ( n1720 ) , .B0 ( n1721 ) , .Y ( n1715 ) ) ;
OAI21XL U1212 ( .A0 ( n563 ) , .A1 ( n562 ) , .B0 ( n561 ) , .Y ( n584 ) ) ;
OAI21XL U1213 ( .A0 ( n275 ) , .A1 ( HFSNET_346 ) , .B0 ( n274 ) , 
    .Y ( n895 ) ) ;
NOR2XL U1214 ( .A ( temp_acc[8] ) , .B ( \shadow_weights[17][8] ) , 
    .Y ( n214 ) ) ;
NOR2XL U1215 ( .A ( temp_acc[9] ) , .B ( \shadow_weights[17][9] ) , 
    .Y ( n159 ) ) ;
NOR2XL U1216 ( .A ( n214 ) , .B ( n159 ) , .Y ( n144 ) ) ;
NOR2XL U1217 ( .A ( temp_acc[10] ) , .B ( \shadow_weights[17][10] ) , 
    .Y ( n148 ) ) ;
NOR2XL U1218 ( .A ( temp_acc[11] ) , .B ( \shadow_weights[17][11] ) , 
    .Y ( n150 ) ) ;
NOR2XL U1219 ( .A ( n148 ) , .B ( n150 ) , .Y ( n80 ) ) ;
NAND2XL U1220 ( .A ( n144 ) , .B ( n80 ) , .Y ( n101 ) ) ;
NOR2XL U1221 ( .A ( temp_acc[12] ) , .B ( HFSNET_209 ) , .Y ( n108 ) ) ;
NOR2XL U1222 ( .A ( temp_acc[13] ) , .B ( \shadow_weights[17][13] ) , 
    .Y ( n111 ) ) ;
NOR2XL U1223 ( .A ( n108 ) , .B ( n111 ) , .Y ( n102 ) ) ;
NOR2XL U1224 ( .A ( temp_acc[14] ) , .B ( HFSNET_211 ) , .Y ( n106 ) ) ;
NOR2XL U1225 ( .A ( temp_acc[15] ) , .B ( \shadow_weights[17][15] ) , 
    .Y ( n120 ) ) ;
NOR2XL U1226 ( .A ( n106 ) , .B ( n120 ) , .Y ( n82 ) ) ;
NAND2XL U1227 ( .A ( n102 ) , .B ( n82 ) , .Y ( n84 ) ) ;
NOR2XL U1228 ( .A ( n101 ) , .B ( n84 ) , .Y ( n86 ) ) ;
NOR2XL U1229 ( .A ( temp_acc[2] ) , .B ( \shadow_weights[17][2] ) , 
    .Y ( n179 ) ) ;
NOR2XL U1230 ( .A ( temp_acc[3] ) , .B ( \shadow_weights[17][3] ) , 
    .Y ( n181 ) ) ;
NOR2XL U1231 ( .A ( n179 ) , .B ( n181 ) , .Y ( n74 ) ) ;
NOR2XL U1232 ( .A ( temp_acc[1] ) , .B ( \shadow_weights[17][1] ) , 
    .Y ( n168 ) ) ;
NAND2XL U1234 ( .A ( temp_acc[1] ) , .B ( \shadow_weights[17][1] ) , 
    .Y ( n169 ) ) ;
NAND2XL U1235 ( .A ( temp_acc[2] ) , .B ( \shadow_weights[17][2] ) , 
    .Y ( n178 ) ) ;
NAND2XL U1236 ( .A ( temp_acc[3] ) , .B ( \shadow_weights[17][3] ) , 
    .Y ( n182 ) ) ;
OAI21XL U1237 ( .A0 ( n181 ) , .A1 ( n178 ) , .B0 ( n182 ) , .Y ( n73 ) ) ;
AOI21XL U1238 ( .A0 ( n74 ) , .A1 ( n174 ) , .B0 ( n73 ) , .Y ( n186 ) ) ;
NOR2XL U1239 ( .A ( temp_acc[4] ) , .B ( \shadow_weights[17][4] ) , 
    .Y ( n187 ) ) ;
NOR2XL U1240 ( .A ( temp_acc[5] ) , .B ( \shadow_weights[17][5] ) , 
    .Y ( n193 ) ) ;
NOR2XL U1241 ( .A ( n187 ) , .B ( n193 ) , .Y ( n199 ) ) ;
NOR2XL U1242 ( .A ( temp_acc[6] ) , .B ( \shadow_weights[17][6] ) , 
    .Y ( n207 ) ) ;
NOR2XL U1243 ( .A ( temp_acc[7] ) , .B ( \shadow_weights[17][7] ) , 
    .Y ( n209 ) ) ;
NOR2XL U1244 ( .A ( n207 ) , .B ( n209 ) , .Y ( n76 ) ) ;
NAND2XL U1245 ( .A ( temp_acc[4] ) , .B ( \shadow_weights[17][4] ) , 
    .Y ( n190 ) ) ;
NAND2XL U1246 ( .A ( temp_acc[6] ) , .B ( \shadow_weights[17][6] ) , 
    .Y ( n206 ) ) ;
OAI21XL U1247 ( .A0 ( n209 ) , .A1 ( n206 ) , .B0 ( n210 ) , .Y ( n75 ) ) ;
AOI21XL U1248 ( .A0 ( n76 ) , .A1 ( n198 ) , .B0 ( n75 ) , .Y ( n77 ) ) ;
OAI21XL U1249 ( .A0 ( n186 ) , .A1 ( n78 ) , .B0 ( n77 ) , .Y ( n99 ) ) ;
NAND2XL U1250 ( .A ( temp_acc[8] ) , .B ( \shadow_weights[17][8] ) , 
    .Y ( n215 ) ) ;
NAND2XL U1251 ( .A ( temp_acc[9] ) , .B ( \shadow_weights[17][9] ) , 
    .Y ( n160 ) ) ;
NAND2XL U1252 ( .A ( temp_acc[10] ) , .B ( \shadow_weights[17][10] ) , 
    .Y ( n164 ) ) ;
OAI21XL U1253 ( .A0 ( n150 ) , .A1 ( n164 ) , .B0 ( n151 ) , .Y ( n79 ) ) ;
AOI21XL U1254 ( .A0 ( n80 ) , .A1 ( n145 ) , .B0 ( n79 ) , .Y ( n100 ) ) ;
NAND2XL U1255 ( .A ( temp_acc[12] ) , .B ( HFSNET_209 ) , .Y ( n155 ) ) ;
NAND2XL U1256 ( .A ( temp_acc[14] ) , .B ( HFSNET_211 ) , .Y ( n116 ) ) ;
OAI21XL U1257 ( .A0 ( n120 ) , .A1 ( n116 ) , .B0 ( n121 ) , .Y ( n81 ) ) ;
OAI21XL U1258 ( .A0 ( n100 ) , .A1 ( n84 ) , .B0 ( n83 ) , .Y ( n85 ) ) ;
AOI21XL U1259 ( .A0 ( n86 ) , .A1 ( n99 ) , .B0 ( n85 ) , .Y ( n125 ) ) ;
AOI21XL U1261 ( .A0 ( n235 ) , .A1 ( n233 ) , .B0 ( n92 ) , .Y ( n98 ) ) ;
NOR2XL U1262 ( .A ( temp_acc[23] ) , .B ( \shadow_weights[17][23] ) , 
    .Y ( n94 ) ) ;
OAI21XL U1263 ( .A0 ( n98 ) , .A1 ( n94 ) , .B0 ( n95 ) , .Y ( n253 ) ) ;
NAND2XL U1264 ( .A ( n252 ) , .B ( n250 ) , .Y ( n93 ) ) ;
XNOR2X1 U1265 ( .A ( n253 ) , .B ( n93 ) , .Y ( n1736 ) ) ;
NOR2XL U1266 ( .A ( n1736 ) , .B ( \shadow_weights[18][24] ) , .Y ( n1730 ) ) ;
XOR2X1 U1269 ( .A ( n98 ) , .B ( n97 ) , .Y ( n1745 ) ) ;
NOR2XL U1270 ( .A ( n1745 ) , .B ( \shadow_weights[18][23] ) , .Y ( n1740 ) ) ;
NOR2XL U1271 ( .A ( n1730 ) , .B ( n1740 ) , .Y ( n249 ) ) ;
INVXL U1272 ( .A ( n99 ) , .Y ( n218 ) ) ;
NAND2XL ctmTdsLR_4_762 ( .A ( n1279 ) , .B ( \shadow_weights[16][1] ) , 
    .Y ( tmp_net76 ) ) ;
XNOR2X1 U1274 ( .A ( n119 ) , .B ( n107 ) , .Y ( n1844 ) ) ;
NOR2XL U1275 ( .A ( n1844 ) , .B ( \shadow_weights[18][14] ) , .Y ( n1839 ) ) ;
XOR2X1 U1276 ( .A ( n115 ) , .B ( n114 ) , .Y ( n1853 ) ) ;
NOR2XL U1277 ( .A ( n1853 ) , .B ( \shadow_weights[18][13] ) , .Y ( n1848 ) ) ;
NOR2XL U1278 ( .A ( n1839 ) , .B ( n1848 ) , .Y ( n1827 ) ) ;
NAND4XL ctmTdsLR_2_1844 ( .A ( n1272_CDR1 ) , .B ( tmp_net336 ) , 
    .C ( n1273_CDR2 ) , .D ( n1285_CDR1 ) , .Y ( tmp_net337 ) ) ;
OR2XL U1280 ( .A ( n1835 ) , .B ( \shadow_weights[18][15] ) , .Y ( n1832 ) ) ;
NAND2XL U1281 ( .A ( n1827 ) , .B ( n1832 ) , .Y ( n1781 ) ) ;
INVXL U1282 ( .A ( n125 ) , .Y ( n134 ) ) ;
XOR2X1 U1283 ( .A ( n130 ) , .B ( n129 ) , .Y ( n1813 ) ) ;
NOR2XL U1284 ( .A ( n1813 ) , .B ( \shadow_weights[18][17] ) , .Y ( n1808 ) ) ;
XNOR2X1 U1285 ( .A ( n134 ) , .B ( n133 ) , .Y ( n1823 ) ) ;
NOR2XL U1286 ( .A ( n1823 ) , .B ( \shadow_weights[18][16] ) , .Y ( n1805 ) ) ;
NOR2XL U1287 ( .A ( n1808 ) , .B ( n1805 ) , .Y ( n1782 ) ) ;
AOI21XL ctmTdsLR_1_1962 ( .A0 ( n1873 ) , .A1 ( n1872 ) , .B0 ( tmp_net408 ) , 
    .Y ( n1878 ) ) ;
NOR2XL U1289 ( .A ( n1793 ) , .B ( \shadow_weights[18][19] ) , .Y ( n1788 ) ) ;
XNOR2X1 U1290 ( .A ( n143 ) , .B ( n142 ) , .Y ( n1801 ) ) ;
NOR2XL U1291 ( .A ( n1801 ) , .B ( \shadow_weights[18][18] ) , .Y ( n1786 ) ) ;
NOR2XL U1292 ( .A ( n1788 ) , .B ( n1786 ) , .Y ( n227 ) ) ;
NOR2XL U1293 ( .A ( n1781 ) , .B ( n229 ) , .Y ( n231 ) ) ;
NAND3XL ctmTdsLR_3_1733 ( .A ( n789_CDR1 ) , .B ( ZBUF_2_42 ) , 
    .C ( tmp_net257 ) , .Y ( tmp_net258 ) ) ;
NOR2XL U1295 ( .A ( n1874 ) , .B ( HFSNET_225 ) , .Y ( n1869 ) ) ;
INVXL ctmTdsLR_3_2018 ( .A ( n1436 ) , .Y ( tmp_net436 ) ) ;
NOR2XL U1297 ( .A ( n1865 ) , .B ( HFSNET_226 ) , .Y ( n1860 ) ) ;
NOR2XL U1298 ( .A ( n1869 ) , .B ( n1860 ) , .Y ( n222 ) ) ;
OAI21XL U1299 ( .A0 ( n218 ) , .A1 ( n214 ) , .B0 ( n215 ) , .Y ( n163 ) ) ;
XNOR2X1 U1300 ( .A ( n163 ) , .B ( n162 ) , .Y ( n1894 ) ) ;
NOR2XL U1301 ( .A ( n1894 ) , .B ( HFSNET_244 ) , .Y ( n1879 ) ) ;
XNOR2X1 U1302 ( .A ( n167 ) , .B ( n166 ) , .Y ( n1886 ) ) ;
NOR2XL U1303 ( .A ( n1886 ) , .B ( \shadow_weights[18][10] ) , .Y ( n1881 ) ) ;
NOR2XL U1304 ( .A ( n1879 ) , .B ( n1881 ) , .Y ( n1859 ) ) ;
XOR2XL U1307 ( .A ( n171 ) , .B ( n172 ) , .Y ( n1965 ) ) ;
NOR2XL U1308 ( .A ( n1965 ) , .B ( \shadow_weights[18][1] ) , .Y ( n1961 ) ) ;
OAI21XL U1311 ( .A0 ( n1961 ) , .A1 ( n1969 ) , .B0 ( n1962 ) , .Y ( n1955 ) ) ;
XOR2X1 U1314 ( .A ( n180 ) , .B ( n176 ) , .Y ( n1957 ) ) ;
AOI21XL U1315 ( .A0 ( n1955 ) , .A1 ( n1954 ) , .B0 ( n177 ) , .Y ( n1947 ) ) ;
OAI21XL U1316 ( .A0 ( n180 ) , .A1 ( n179 ) , .B0 ( n178 ) , .Y ( n185 ) ) ;
INVXL U1317 ( .A ( n186 ) , .Y ( n200 ) ) ;
XNOR2X1 U1318 ( .A ( n200 ) , .B ( n188 ) , .Y ( n1939 ) ) ;
AOI21XL U1319 ( .A0 ( n1938 ) , .A1 ( n1936 ) , .B0 ( n189 ) , .Y ( n1917 ) ) ;
AOI21XL U1320 ( .A0 ( n200 ) , .A1 ( n199 ) , .B0 ( n198 ) , .Y ( n208 ) ) ;
XOR2X1 U1321 ( .A ( n208 ) , .B ( n202 ) , .Y ( n1923 ) ) ;
OR2XL U1322 ( .A ( n1923 ) , .B ( \shadow_weights[18][6] ) , .Y ( n1920 ) ) ;
OAI21XL U1323 ( .A0 ( n208 ) , .A1 ( n207 ) , .B0 ( n206 ) , .Y ( n213 ) ) ;
NOR2XL U1324 ( .A ( n1913 ) , .B ( \shadow_weights[18][7] ) , .Y ( n1908 ) ) ;
NOR2XL U1325 ( .A ( n1904 ) , .B ( \shadow_weights[18][8] ) , .Y ( n1899 ) ) ;
OAI21XL U1326 ( .A0 ( n1909 ) , .A1 ( n1899 ) , .B0 ( n1900 ) , .Y ( n219 ) ) ;
AOI21XL U1327 ( .A0 ( n1898 ) , .A1 ( n220 ) , .B0 ( n219 ) , .Y ( n1857 ) ) ;
NAND2XL U1328 ( .A ( n1874 ) , .B ( HFSNET_225 ) , .Y ( n1870 ) ) ;
OAI21XL U1329 ( .A0 ( n1870 ) , .A1 ( n1860 ) , .B0 ( n1861 ) , .Y ( n221 ) ) ;
NAND2XL U1330 ( .A ( n1853 ) , .B ( \shadow_weights[18][13] ) , .Y ( n1849 ) ) ;
AOI21XL U1331 ( .A0 ( n1828 ) , .A1 ( n1832 ) , .B0 ( n225 ) , .Y ( n1780 ) ) ;
NAND2XL U1332 ( .A ( n1823 ) , .B ( \shadow_weights[18][16] ) , .Y ( n1818 ) ) ;
OAI21XL U1333 ( .A0 ( n1808 ) , .A1 ( n1818 ) , .B0 ( n1809 ) , .Y ( n1783 ) ) ;
OAI21XL U1334 ( .A0 ( n1788 ) , .A1 ( n1797 ) , .B0 ( n1789 ) , .Y ( n226 ) ) ;
AOI21X1 U1335 ( .A0 ( n231 ) , .A1 ( n1779 ) , .B0 ( n230 ) , .Y ( n1749 ) ) ;
NAND2XL U1336 ( .A ( n233 ) , .B ( n232 ) , .Y ( n234 ) ) ;
XNOR2X1 U1337 ( .A ( n235 ) , .B ( n234 ) , .Y ( n1756 ) ) ;
OR2XL U1338 ( .A ( n1756 ) , .B ( \shadow_weights[18][22] ) , .Y ( n1753 ) ) ;
NAND2XL ctmTdsLR_2_1963 ( .A ( tmp_net407 ) , .B ( n1870 ) , .Y ( n1872 ) ) ;
NOR2XL U1340 ( .A ( n1767 ) , .B ( \shadow_weights[18][21] ) , .Y ( n1762 ) ) ;
XNOR2X1 U1341 ( .A ( n244 ) , .B ( n243 ) , .Y ( n1775 ) ) ;
NOR2XL U1342 ( .A ( n1775 ) , .B ( HFSNET_234 ) , .Y ( n1760 ) ) ;
NOR2XL U1343 ( .A ( n1762 ) , .B ( n1760 ) , .Y ( n1751 ) ) ;
NAND2XL U1344 ( .A ( n1775 ) , .B ( HFSNET_234 ) , .Y ( n1771 ) ) ;
NAND2XL U1345 ( .A ( n1745 ) , .B ( \shadow_weights[18][23] ) , .Y ( n1741 ) ) ;
NAND2XL U1346 ( .A ( n1736 ) , .B ( \shadow_weights[18][24] ) , .Y ( n1731 ) ) ;
OAI21XL U1347 ( .A0 ( n1730 ) , .A1 ( n1741 ) , .B0 ( n1731 ) , .Y ( n248 ) ) ;
AOI21XL U1348 ( .A0 ( n249 ) , .A1 ( n1729 ) , .B0 ( n248 ) , .Y ( n1724 ) ) ;
AOI21XL U1349 ( .A0 ( n253 ) , .A1 ( n252 ) , .B0 ( n251 ) , .Y ( n258 ) ) ;
NOR2XL U1350 ( .A ( temp_acc[25] ) , .B ( \shadow_weights[17][25] ) , 
    .Y ( n257 ) ) ;
XOR2X1 U1353 ( .A ( n258 ) , .B ( n255 ) , .Y ( n1725 ) ) ;
NOR2XL U1354 ( .A ( n1725 ) , .B ( \shadow_weights[18][25] ) , .Y ( n1720 ) ) ;
NAND2XL U1355 ( .A ( n1725 ) , .B ( \shadow_weights[18][25] ) , .Y ( n1721 ) ) ;
OAI21XL U1356 ( .A0 ( n258 ) , .A1 ( n257 ) , .B0 ( n256 ) , .Y ( n264 ) ) ;
NAND2XL U1357 ( .A ( n263 ) , .B ( n261 ) , .Y ( n259 ) ) ;
OR2XL U1358 ( .A ( n1716 ) , .B ( HFSNET_241 ) , .Y ( n1713 ) ) ;
NAND2XL U1359 ( .A ( n1716 ) , .B ( HFSNET_241 ) , .Y ( n1712 ) ) ;
AOI21XL U1360 ( .A0 ( n1715 ) , .A1 ( n1713 ) , .B0 ( n260 ) , .Y ( n1707 ) ) ;
AOI21XL U1361 ( .A0 ( n264 ) , .A1 ( n263 ) , .B0 ( n262 ) , .Y ( n269 ) ) ;
NAND2XL ctmTdsLR_2_2047 ( .A ( tmp_net452 ) , .B ( n423 ) , 
    .Y ( tmp_net219 ) ) ;
NOR2XL U1365 ( .A ( n1708 ) , .B ( \shadow_weights[18][27] ) , .Y ( n1703 ) ) ;
NAND2XL U1366 ( .A ( n1708 ) , .B ( \shadow_weights[18][27] ) , .Y ( n1704 ) ) ;
OAI21XL U1367 ( .A0 ( n269 ) , .A1 ( n268 ) , .B0 ( n267 ) , .Y ( n283 ) ) ;
NAND2XL U1368 ( .A ( n282 ) , .B ( n280 ) , .Y ( n270 ) ) ;
OR2XL U1369 ( .A ( n272 ) , .B ( \shadow_weights[18][28] ) , .Y ( n278 ) ) ;
NAND2XL U1370 ( .A ( n272 ) , .B ( \shadow_weights[18][28] ) , .Y ( n276 ) ) ;
NAND2XL U1371 ( .A ( n278 ) , .B ( n276 ) , .Y ( n271 ) ) ;
INVXL ctmTdsLR_3_1964 ( .A ( n1869 ) , .Y ( tmp_net407 ) ) ;
NOR2XL U1373 ( .A ( n2178 ) , .B ( target_bit[3] ) , .Y ( n1993 ) ) ;
NOR2XL U1375 ( .A ( n67 ) , .B ( n2171 ) , .Y ( n723 ) ) ;
AND2X2 U1376 ( .A ( n1991 ) , .B ( n723 ) , .Y ( n733 ) ) ;
AOI211XL U1377 ( .A0 ( HFSNET_345 ) , .A1 ( n2208 ) , .B0 ( n273 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n274 ) ) ;
AOI21XL U1378 ( .A0 ( n279 ) , .A1 ( n278 ) , .B0 ( n277 ) , .Y ( n291 ) ) ;
AOI21XL U1379 ( .A0 ( n283 ) , .A1 ( n282 ) , .B0 ( n281 ) , .Y ( n287 ) ) ;
XOR2X1 U1383 ( .A ( n287 ) , .B ( n286 ) , .Y ( n293 ) ) ;
NOR2XL ctmTdsLR_4_1965 ( .A ( n1873 ) , .B ( n1872 ) , .Y ( tmp_net408 ) ) ;
AOI211XL U1385 ( .A0 ( HFSNET_345 ) , .A1 ( n2214 ) , .B0 ( n294 ) , 
    .C0 ( HFSNET_348 ) , .Y ( n295 ) ) ;
OAI21XL U1386 ( .A0 ( n296 ) , .A1 ( HFSNET_346 ) , .B0 ( n295 ) , 
    .Y ( n894 ) ) ;
NAND3XL U1387 ( .A ( wr_idx_r[1] ) , .B ( n65 ) , .C ( n2160 ) , .Y ( n667 ) ) ;
NAND2X1 U1388 ( .A ( n559 ) , .B ( wr_idx_r[2] ) , .Y ( n577 ) ) ;
INVXL HFSINV_11_511 ( .A ( N1838 ) , .Y ( HFSNET_253 ) ) ;
NAND3XL U1390 ( .A ( n2177 ) , .B ( n65 ) , .C ( n2160 ) , .Y ( n600 ) ) ;
NOR2X2 U1391 ( .A ( n600 ) , .B ( n577 ) , .Y ( N1838 ) ) ;
NAND3XL U1392 ( .A ( wr_idx_r[1] ) , .B ( wr_idx_r[3] ) , .C ( n65 ) , 
    .Y ( n668 ) ) ;
NOR2X2 U1393 ( .A ( n577 ) , .B ( n668 ) , .Y ( N1828 ) ) ;
NAND3XL U1394 ( .A ( wr_idx_r[3] ) , .B ( n2177 ) , .C ( n65 ) , .Y ( n598 ) ) ;
NOR2X4 U1395 ( .A ( n577 ) , .B ( n598 ) , .Y ( N1830 ) ) ;
NOR2X2 U1396 ( .A ( n669 ) , .B ( n600 ) , .Y ( N1842 ) ) ;
NOR2X2 U1397 ( .A ( n669 ) , .B ( n598 ) , .Y ( N1834 ) ) ;
AOI222XL ctmTdsLR_1_764 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][0] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][0] ) , 
    .C0 ( \shadow_weights[19][0] ) , .C1 ( n1281 ) , .Y ( tmp_net77 ) ) ;
AND4XL ctmTdsLR_2_1783 ( .A ( tmp_net57 ) , .B ( tmp_net55 ) , 
    .C ( tmp_net58 ) , .D ( tmp_net56 ) , .Y ( tmp_net288 ) ) ;
AOI222XL ctmTdsLR_1_859 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][12] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][12] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][12] ) , .Y ( tmp_net136 ) ) ;
NAND2X2 ctmTdsLR_1_767 ( .A ( n672_CDR1 ) , .B ( n673_CDR1 ) , 
    .Y ( HFSNET_20 ) ) ;
NAND2XL U1402 ( .A ( n2160 ) , .B ( wr_idx_r[4] ) , .Y ( n670 ) ) ;
NAND2BXL U1403 ( .AN ( n670 ) , .B ( wr_idx_r[1] ) , .Y ( n665 ) ) ;
NAND2XL U1404 ( .A ( wr_idx_r[0] ) , .B ( n2159 ) , .Y ( n658 ) ) ;
NOR2XL U1405 ( .A ( n815 ) , .B ( n658 ) , .Y ( n666 ) ) ;
AOI21XL U1407 ( .A0 ( n2189 ) , .A1 ( n318 ) , .B0 ( n2133 ) , .Y ( n317 ) ) ;
OAI21XL U1408 ( .A0 ( n2118 ) , .A1 ( n318 ) , .B0 ( n317 ) , .Y ( n757 ) ) ;
NAND2XL U1409 ( .A ( n639 ) , .B ( n638 ) , .Y ( n722 ) ) ;
AND2XL U1410 ( .A ( n722 ) , .B ( n815 ) , .Y ( n774 ) ) ;
INVXL U1411 ( .A ( comp_out ) , .Y ( n825 ) ) ;
OR2XL U1412 ( .A ( avg_cnt[0] ) , .B ( n322 ) , .Y ( n967 ) ) ;
NAND2XL U1413 ( .A ( target_bit[0] ) , .B ( gre_a_INV_2893_58 ) , 
    .Y ( n892 ) ) ;
NOR3XL U1414 ( .A ( n67 ) , .B ( state[2] ) , .C ( state[0] ) , .Y ( n652 ) ) ;
NAND2XL U1415 ( .A ( state[3] ) , .B ( n652 ) , .Y ( n1416 ) ) ;
NAND2XL U1416 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[22] ) , 
    .Y ( n843 ) ) ;
NAND2XL U1417 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[34] ) , 
    .Y ( n831 ) ) ;
NAND2XL U1418 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[23] ) , 
    .Y ( n842 ) ) ;
NAND2XL U1419 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[6] ) , 
    .Y ( n859 ) ) ;
NAND2XL U1420 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[25] ) , 
    .Y ( n840 ) ) ;
NAND2XL U1421 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[24] ) , 
    .Y ( n841 ) ) ;
NAND2XL U1422 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[29] ) , 
    .Y ( n836 ) ) ;
NAND2XL U1423 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[27] ) , 
    .Y ( n838 ) ) ;
NAND2XL U1424 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[31] ) , 
    .Y ( n834 ) ) ;
NAND2XL U1425 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[30] ) , 
    .Y ( n835 ) ) ;
NAND2XL U1426 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[32] ) , 
    .Y ( n833 ) ) ;
NAND2XL U1427 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[33] ) , 
    .Y ( n832 ) ) ;
NAND2XL U1428 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[35] ) , 
    .Y ( n830 ) ) ;
NAND2XL U1429 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[28] ) , 
    .Y ( n837 ) ) ;
NAND2XL U1430 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[21] ) , 
    .Y ( n844 ) ) ;
NAND2XL U1431 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[26] ) , 
    .Y ( n839 ) ) ;
NAND2XL U1432 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[20] ) , 
    .Y ( n845 ) ) ;
NAND2XL U1433 ( .A ( overrange_acc ) , .B ( gre_a_INV_2893_58 ) , 
    .Y ( n893 ) ) ;
OR2XL U1434 ( .A ( meas_val_p[0] ) , .B ( accumulator[0] ) , .Y ( n328 ) ) ;
NAND2XL U1435 ( .A ( meas_val_p[0] ) , .B ( accumulator[0] ) , .Y ( n326 ) ) ;
NAND2XL U1436 ( .A ( n328 ) , .B ( n326 ) , .Y ( n321 ) ) ;
XNOR2XL U1437 ( .A ( n321 ) , .B ( meas_val_n[0] ) , .Y ( n323 ) ) ;
NAND2XL U1438 ( .A ( n323 ) , .B ( HFSNET_347 ) , .Y ( n962 ) ) ;
NOR2XL U1439 ( .A ( n324 ) , .B ( meas_val_n[1] ) , .Y ( n336 ) ) ;
NAND2XL U1441 ( .A ( n324 ) , .B ( meas_val_n[1] ) , .Y ( n335 ) ) ;
INVXL U1443 ( .A ( n326 ) , .Y ( n327 ) ) ;
AOI21XL U1444 ( .A0 ( n328 ) , .A1 ( meas_val_n[0] ) , .B0 ( n327 ) , 
    .Y ( n337 ) ) ;
XOR2XL U1445 ( .A ( n329 ) , .B ( n337 ) , .Y ( n330 ) ) ;
NAND2XL U1446 ( .A ( n330 ) , .B ( HFSNET_347 ) , .Y ( n961 ) ) ;
NAND2XL U1447 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[23] ) , 
    .Y ( n872 ) ) ;
NAND2XL U1448 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[22] ) , 
    .Y ( n873 ) ) ;
NAND2XL U1449 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[21] ) , 
    .Y ( n874 ) ) ;
NAND2XL U1450 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[9] ) , 
    .Y ( n886 ) ) ;
NAND2XL U1451 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[19] ) , 
    .Y ( n876 ) ) ;
NAND2XL U1452 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[7] ) , 
    .Y ( n888 ) ) ;
NAND2XL U1453 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[15] ) , 
    .Y ( n880 ) ) ;
NAND2XL ctmTdsLR_2_955 ( .A ( n1319 ) , .B ( \shadow_weights[13][20] ) , 
    .Y ( tmp_net203 ) ) ;
NAND2XL ctmTdsLR_1_768 ( .A ( n1278 ) , .B ( \shadow_weights[8][12] ) , 
    .Y ( tmp_net79 ) ) ;
NAND2XL U1456 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[17] ) , 
    .Y ( n878 ) ) ;
NAND2XL U1457 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[14] ) , 
    .Y ( n881 ) ) ;
NAND2XL U1458 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[8] ) , 
    .Y ( n887 ) ) ;
NAND2XL U1459 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[10] ) , 
    .Y ( n885 ) ) ;
NAND4X1 ctmTdsLR_3_956 ( .A ( tmp_net202 ) , .B ( n1340_CDR2 ) , 
    .C ( n1337 ) , .D ( tmp_net203 ) , .Y ( HFSNET_154 ) ) ;
NAND2XL ctmTdsLR_2_769 ( .A ( n1277 ) , .B ( \shadow_weights[10][12] ) , 
    .Y ( tmp_net80 ) ) ;
NAND2XL U1462 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[20] ) , 
    .Y ( n875 ) ) ;
NAND2XL U1463 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[16] ) , 
    .Y ( n879 ) ) ;
NAND2XL U1464 ( .A ( target_bit[4] ) , .B ( gre_a_INV_2893_58 ) , 
    .Y ( n890 ) ) ;
NAND2XL U1465 ( .A ( target_bit[3] ) , .B ( gre_a_INV_2893_58 ) , 
    .Y ( n891 ) ) ;
ADDHXL U1466 ( .A ( meas_val_p[1] ) , .B ( accumulator[1] ) , .CO ( n332 ) , 
    .S ( n324 ) ) ;
NOR2XL U1467 ( .A ( n333 ) , .B ( n332 ) , .Y ( n354 ) ) ;
NAND2XL U1469 ( .A ( n333 ) , .B ( n332 ) , .Y ( n356 ) ) ;
INVXL U1471 ( .A ( n359 ) , .Y ( n347 ) ) ;
XOR2XL U1472 ( .A ( n338 ) , .B ( n347 ) , .Y ( n339 ) ) ;
NAND2XL U1473 ( .A ( n339 ) , .B ( HFSNET_347 ) , .Y ( n960 ) ) ;
NOR3XL U1474 ( .A ( HFSNET_290 ) , .B ( n2162 ) , .C ( n2177 ) , .Y ( n340 ) ) ;
NAND2XL U1475 ( .A ( wr_idx_r[3] ) , .B ( n340 ) , .Y ( n1987 ) ) ;
OAI211XL U1476 ( .A0 ( wr_idx_r[3] ) , .A1 ( n340 ) , .B0 ( N1822 ) , 
    .C0 ( n1987 ) , .Y ( n828 ) ) ;
NAND2XL U1477 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[9] ) , 
    .Y ( n856 ) ) ;
NAND2XL U1478 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[15] ) , 
    .Y ( n850 ) ) ;
NAND2XL U1479 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[12] ) , 
    .Y ( n853 ) ) ;
NAND2XL U1480 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[10] ) , 
    .Y ( n855 ) ) ;
NAND2XL U1481 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[16] ) , 
    .Y ( n849 ) ) ;
NAND2XL U1482 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[7] ) , 
    .Y ( n858 ) ) ;
NAND2XL U1483 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[18] ) , 
    .Y ( n847 ) ) ;
NAND2XL U1484 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[11] ) , 
    .Y ( n854 ) ) ;
NAND2XL U1485 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[8] ) , 
    .Y ( n857 ) ) ;
NAND2XL U1486 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[13] ) , 
    .Y ( n852 ) ) ;
NAND2XL U1487 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[17] ) , 
    .Y ( n848 ) ) ;
NAND2XL U1488 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[14] ) , 
    .Y ( n851 ) ) ;
NAND2XL U1489 ( .A ( gre_a_INV_2154_58 ) , .B ( avg_rounded_r[19] ) , 
    .Y ( n846 ) ) ;
NAND2XL U1490 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[25] ) , 
    .Y ( n870 ) ) ;
NAND2XL U1491 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[32] ) , 
    .Y ( n863 ) ) ;
NAND2XL U1492 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[26] ) , 
    .Y ( n869 ) ) ;
NAND2XL U1493 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[33] ) , 
    .Y ( n862 ) ) ;
NAND2XL U1494 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[28] ) , 
    .Y ( n867 ) ) ;
NAND2XL U1495 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[31] ) , 
    .Y ( n864 ) ) ;
NAND2XL U1496 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[30] ) , 
    .Y ( n865 ) ) ;
NAND2XL U1497 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[34] ) , 
    .Y ( n861 ) ) ;
NAND2XL U1498 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[27] ) , 
    .Y ( n868 ) ) ;
NAND2XL U1499 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[29] ) , 
    .Y ( n866 ) ) ;
NAND2XL U1500 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[13] ) , 
    .Y ( n882 ) ) ;
NAND2XL U1501 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[24] ) , 
    .Y ( n871 ) ) ;
NAND2XL U1502 ( .A ( gre_a_INV_2893_58 ) , .B ( accumulator[35] ) , 
    .Y ( n860 ) ) ;
NAND2XL U1503 ( .A ( avg_cnt[1] ) , .B ( avg_cnt[0] ) , .Y ( n343 ) ) ;
OAI211XL U1504 ( .A0 ( avg_cnt[1] ) , .A1 ( avg_cnt[0] ) , 
    .B0 ( HFSNET_347 ) , .C0 ( n343 ) , .Y ( n966 ) ) ;
INVXL U1505 ( .A ( n343 ) , .Y ( n344 ) ) ;
OAI211XL U1506 ( .A0 ( n344 ) , .A1 ( avg_cnt[2] ) , .B0 ( HFSNET_347 ) , 
    .C0 ( n345 ) , .Y ( n965 ) ) ;
INVXL U1507 ( .A ( n345 ) , .Y ( n346 ) ) ;
OAI211XL U1508 ( .A0 ( n346 ) , .A1 ( avg_cnt[3] ) , .B0 ( HFSNET_347 ) , 
    .C0 ( n1978 ) , .Y ( n964 ) ) ;
OAI21XL U1509 ( .A0 ( n347 ) , .A1 ( n354 ) , .B0 ( n356 ) , .Y ( n352 ) ) ;
CMPR32X1 U1510 ( .A ( meas_val_p[2] ) , .B ( meas_val_n[2] ) , 
    .C ( accumulator[2] ) , .CO ( n348 ) , .S ( n333 ) ) ;
NOR2XL U1511 ( .A ( n349 ) , .B ( n348 ) , .Y ( n357 ) ) ;
NAND2XL U1513 ( .A ( n349 ) , .B ( n348 ) , .Y ( n355 ) ) ;
NAND2XL ctmTdsLR_2_2000 ( .A ( n604 ) , .B ( n596 ) , .Y ( tmp_net428 ) ) ;
NAND2XL U1516 ( .A ( n353 ) , .B ( HFSNET_347 ) , .Y ( n959 ) ) ;
NOR2XL U1517 ( .A ( n357 ) , .B ( n354 ) , .Y ( n360 ) ) ;
OAI21XL U1518 ( .A0 ( n357 ) , .A1 ( n356 ) , .B0 ( n355 ) , .Y ( n358 ) ) ;
AOI21XL U1519 ( .A0 ( n360 ) , .A1 ( n359 ) , .B0 ( n358 ) , .Y ( n376 ) ) ;
CMPR32X1 U1520 ( .A ( meas_val_p[3] ) , .B ( meas_val_n[3] ) , 
    .C ( accumulator[3] ) , .CO ( n361 ) , .S ( n349 ) ) ;
NOR2XL U1521 ( .A ( n362 ) , .B ( n361 ) , .Y ( n365 ) ) ;
INVXL U1522 ( .A ( n365 ) , .Y ( n425 ) ) ;
NAND2XL U1523 ( .A ( n362 ) , .B ( n361 ) , .Y ( n423 ) ) ;
NAND2XL U1524 ( .A ( n425 ) , .B ( n423 ) , .Y ( n363 ) ) ;
XNOR2XL U1525 ( .A ( n443 ) , .B ( n363 ) , .Y ( n364 ) ) ;
NAND2XL U1526 ( .A ( n364 ) , .B ( HFSNET_347 ) , .Y ( n958 ) ) ;
CMPR32X1 U1527 ( .A ( meas_val_p[4] ) , .B ( meas_val_n[4] ) , 
    .C ( accumulator[4] ) , .CO ( n366 ) , .S ( n362 ) ) ;
NOR2XL U1528 ( .A ( n367 ) , .B ( n366 ) , .Y ( n426 ) ) ;
NOR2XL U1529 ( .A ( n426 ) , .B ( n365 ) , .Y ( n442 ) ) ;
CMPR32X1 U1530 ( .A ( meas_val_p[5] ) , .B ( meas_val_n[5] ) , 
    .C ( accumulator[5] ) , .CO ( n368 ) , .S ( n367 ) ) ;
NOR2XL U1531 ( .A ( n369 ) , .B ( n368 ) , .Y ( n477 ) ) ;
ADDFX1 U1532 ( .A ( meas_val_p[6] ) , .B ( meas_val_n[6] ) , 
    .CI ( accumulator[6] ) , .CO ( n370 ) , .S ( n369 ) ) ;
NOR2XL U1533 ( .A ( n371 ) , .B ( n370 ) , .Y ( n479 ) ) ;
NOR2XL U1534 ( .A ( n477 ) , .B ( n479 ) , .Y ( n373 ) ) ;
NAND2XL U1535 ( .A ( n442 ) , .B ( n373 ) , .Y ( n375 ) ) ;
NAND2XL U1536 ( .A ( n367 ) , .B ( n366 ) , .Y ( n427 ) ) ;
NAND2XL U1537 ( .A ( n369 ) , .B ( n368 ) , .Y ( n476 ) ) ;
OAI21XL U1538 ( .A0 ( n476 ) , .A1 ( n479 ) , .B0 ( n480 ) , .Y ( n372 ) ) ;
AOI21XL U1539 ( .A0 ( n373 ) , .A1 ( n441 ) , .B0 ( n372 ) , .Y ( n374 ) ) ;
OAI21XL U1540 ( .A0 ( n376 ) , .A1 ( n375 ) , .B0 ( n374 ) , .Y ( n403 ) ) ;
INVXL U1541 ( .A ( n403 ) , .Y ( n521 ) ) ;
CMPR32X1 U1542 ( .A ( meas_val_p[7] ) , .B ( meas_val_n[7] ) , 
    .C ( accumulator[7] ) , .CO ( n377 ) , .S ( n371 ) ) ;
NOR2XL U1543 ( .A ( n378 ) , .B ( n377 ) , .Y ( n448 ) ) ;
NAND2XL U1545 ( .A ( n378 ) , .B ( n377 ) , .Y ( n447 ) ) ;
XOR2XL U1547 ( .A ( n521 ) , .B ( n380 ) , .Y ( n381 ) ) ;
NAND2XL U1548 ( .A ( n381 ) , .B ( HFSNET_347 ) , .Y ( n955 ) ) ;
CMPR32X1 U1549 ( .A ( meas_val_p[8] ) , .B ( meas_val_n[8] ) , 
    .C ( accumulator[8] ) , .CO ( n382 ) , .S ( n378 ) ) ;
NOR2XL U1550 ( .A ( n383 ) , .B ( n382 ) , .Y ( n449 ) ) ;
NOR2XL U1551 ( .A ( n448 ) , .B ( n449 ) , .Y ( n466 ) ) ;
CMPR32X1 U1552 ( .A ( meas_val_p[9] ) , .B ( meas_val_n[9] ) , 
    .C ( accumulator[9] ) , .CO ( n384 ) , .S ( n383 ) ) ;
NOR2XL U1553 ( .A ( n385 ) , .B ( n384 ) , .Y ( n470 ) ) ;
ADDFX1 U1554 ( .A ( meas_val_p[10] ) , .B ( meas_val_n[10] ) , 
    .CI ( accumulator[10] ) , .CO ( n386 ) , .S ( n385 ) ) ;
NOR2XL U1555 ( .A ( n387 ) , .B ( n386 ) , .Y ( n540 ) ) ;
NOR2XL U1556 ( .A ( n470 ) , .B ( n540 ) , .Y ( n389 ) ) ;
NAND2XL U1557 ( .A ( n466 ) , .B ( n389 ) , .Y ( n520 ) ) ;
CMPR32X1 U1558 ( .A ( meas_val_p[11] ) , .B ( meas_val_n[11] ) , 
    .C ( accumulator[11] ) , .CO ( n390 ) , .S ( n387 ) ) ;
NOR2XL U1559 ( .A ( n391 ) , .B ( n390 ) , .Y ( n522 ) ) ;
ADDFX1 U1560 ( .A ( meas_val_p[12] ) , .B ( meas_val_n[12] ) , 
    .CI ( accumulator[12] ) , .CO ( n392 ) , .S ( n391 ) ) ;
NOR2XL U1561 ( .A ( n393 ) , .B ( n392 ) , .Y ( n524 ) ) ;
NOR2XL U1562 ( .A ( n522 ) , .B ( n524 ) , .Y ( n590 ) ) ;
CMPR32X1 U1563 ( .A ( meas_val_p[13] ) , .B ( meas_val_n[13] ) , 
    .C ( accumulator[13] ) , .CO ( n394 ) , .S ( n393 ) ) ;
NOR2XL U1564 ( .A ( n395 ) , .B ( n394 ) , .Y ( n595 ) ) ;
ADDFX1 U1565 ( .A ( meas_val_p[14] ) , .B ( meas_val_n[14] ) , 
    .CI ( accumulator[14] ) , .CO ( n396 ) , .S ( n395 ) ) ;
NOR2XL U1566 ( .A ( n397 ) , .B ( n396 ) , .Y ( n605 ) ) ;
NOR2XL U1567 ( .A ( n595 ) , .B ( n605 ) , .Y ( n399 ) ) ;
NAND2XL U1568 ( .A ( n590 ) , .B ( n399 ) , .Y ( n401 ) ) ;
NOR2XL U1569 ( .A ( n520 ) , .B ( n401 ) , .Y ( n404 ) ) ;
NAND2XL U1570 ( .A ( n383 ) , .B ( n382 ) , .Y ( n450 ) ) ;
NAND2XL U1571 ( .A ( n385 ) , .B ( n384 ) , .Y ( n536 ) ) ;
NAND2XL U1572 ( .A ( n387 ) , .B ( n386 ) , .Y ( n541 ) ) ;
OAI21XL U1573 ( .A0 ( n540 ) , .A1 ( n536 ) , .B0 ( n541 ) , .Y ( n388 ) ) ;
AOI21XL U1574 ( .A0 ( n389 ) , .A1 ( n467 ) , .B0 ( n388 ) , .Y ( n519 ) ) ;
NAND2XL U1575 ( .A ( n391 ) , .B ( n390 ) , .Y ( n532 ) ) ;
NAND2XL U1576 ( .A ( n395 ) , .B ( n394 ) , .Y ( n601 ) ) ;
OAI21XL U1577 ( .A0 ( n605 ) , .A1 ( n601 ) , .B0 ( n606 ) , .Y ( n398 ) ) ;
OAI21XL U1578 ( .A0 ( n519 ) , .A1 ( n401 ) , .B0 ( n400 ) , .Y ( n402 ) ) ;
AOI21X1 U1579 ( .A0 ( n404 ) , .A1 ( n403 ) , .B0 ( n402 ) , .Y ( n455 ) ) ;
CMPR32X1 U1580 ( .A ( meas_val_p[15] ) , .B ( meas_val_n[15] ) , 
    .C ( accumulator[15] ) , .CO ( n405 ) , .S ( n397 ) ) ;
NOR2XL U1581 ( .A ( n406 ) , .B ( n405 ) , .Y ( n456 ) ) ;
ADDFHXL U1582 ( .A ( meas_val_p[16] ) , .B ( meas_val_n[16] ) , 
    .CI ( accumulator[16] ) , .CO ( n407 ) , .S ( n406 ) ) ;
NOR2XL U1583 ( .A ( n408 ) , .B ( n407 ) , .Y ( n502 ) ) ;
NOR2XL U1584 ( .A ( n456 ) , .B ( n502 ) , .Y ( n486 ) ) ;
CMPR32X1 U1585 ( .A ( meas_val_p[17] ) , .B ( meas_val_n[17] ) , 
    .C ( accumulator[17] ) , .CO ( n409 ) , .S ( n408 ) ) ;
OR2XL U1586 ( .A ( n410 ) , .B ( n409 ) , .Y ( n488 ) ) ;
NAND2XL U1587 ( .A ( n486 ) , .B ( n488 ) , .Y ( n546 ) ) ;
ADDFHXL U1588 ( .A ( meas_val_p[18] ) , .B ( meas_val_n[18] ) , 
    .CI ( accumulator[18] ) , .CO ( n412 ) , .S ( n410 ) ) ;
NOR2XL U1589 ( .A ( n413 ) , .B ( n412 ) , .Y ( n551 ) ) ;
NOR2XL U1590 ( .A ( n546 ) , .B ( n551 ) , .Y ( n493 ) ) ;
ADDFHXL U1591 ( .A ( meas_val_p[19] ) , .B ( meas_val_n[19] ) , 
    .CI ( accumulator[19] ) , .CO ( n414 ) , .S ( n413 ) ) ;
OR2XL U1592 ( .A ( n415 ) , .B ( n414 ) , .Y ( n495 ) ) ;
NAND2XL U1593 ( .A ( n493 ) , .B ( n495 ) , .Y ( n418 ) ) ;
NAND2XL U1594 ( .A ( n406 ) , .B ( n405 ) , .Y ( n499 ) ) ;
NAND2XL U1595 ( .A ( n408 ) , .B ( n407 ) , .Y ( n503 ) ) ;
AOI21XL U1596 ( .A0 ( n485 ) , .A1 ( n488 ) , .B0 ( n411 ) , .Y ( n547 ) ) ;
CMPR32X1 U1598 ( .A ( meas_val_p[20] ) , .B ( meas_val_n[20] ) , 
    .C ( accumulator[20] ) , .CO ( n419 ) , .S ( n415 ) ) ;
NAND2XL U1599 ( .A ( n434 ) , .B ( n432 ) , .Y ( n421 ) ) ;
AOI222XL ctmTdsLR_3_770 ( .A0 ( HFSNET_226 ) , .A1 ( n1280 ) , .B0 ( n1282 ) , 
    .B1 ( HFSNET_209 ) , .C0 ( \shadow_weights[19][12] ) , .C1 ( n1281 ) , 
    .Y ( tmp_net81 ) ) ;
BUFXL ZBUF_2_inst_1037 ( .A ( tmp_net15 ) , .Y ( ZBUF_2_17 ) ) ;
CLKBUFX3 ZBUF_2_inst_1038 ( .A ( tmp_net111 ) , .Y ( ZBUF_2_18 ) ) ;
AOI211XL ctmTdsLR_3_1845 ( .A0 ( gre_a_INV_6610_58 ) , 
    .A1 ( \shadow_weights[11][18] ) , .B0 ( tmp_net334 ) , 
    .C0 ( tmp_net335 ) , .Y ( tmp_net336 ) ) ;
CLKINVX1 HFSINV_370_552 ( .A ( n968 ) , .Y ( HFSNET_291 ) ) ;
AOI21XL U1607 ( .A0 ( n431 ) , .A1 ( HFSNET_347 ) , .B0 ( HFSNET_291 ) , 
    .Y ( n817 ) ) ;
AOI21XL U1608 ( .A0 ( n435 ) , .A1 ( n434 ) , .B0 ( n433 ) , .Y ( n461 ) ) ;
ADDFHXL U1609 ( .A ( meas_val_p[21] ) , .B ( meas_val_n[21] ) , 
    .CI ( accumulator[21] ) , .CO ( n436 ) , .S ( n420 ) ) ;
NAND2XL ctmTdsLR_4_771 ( .A ( n1279 ) , .B ( \shadow_weights[16][12] ) , 
    .Y ( tmp_net82 ) ) ;
AOI21XL U1613 ( .A0 ( n443 ) , .A1 ( n442 ) , .B0 ( n441 ) , .Y ( n478 ) ) ;
XOR2XL U1616 ( .A ( n478 ) , .B ( n445 ) , .Y ( n446 ) ) ;
NAND2XL U1617 ( .A ( n446 ) , .B ( HFSNET_347 ) , .Y ( n957 ) ) ;
OAI21XL U1618 ( .A0 ( n521 ) , .A1 ( n448 ) , .B0 ( n447 ) , .Y ( n453 ) ) ;
XNOR2XL U1621 ( .A ( n453 ) , .B ( n452 ) , .Y ( n454 ) ) ;
NAND2XL U1622 ( .A ( n454 ) , .B ( HFSNET_347 ) , .Y ( n954 ) ) ;
INVXL U1623 ( .A ( n456 ) , .Y ( n501 ) ) ;
NAND2XL U1624 ( .A ( n501 ) , .B ( n499 ) , .Y ( n457 ) ) ;
XNOR2XL U1625 ( .A ( n550 ) , .B ( n457 ) , .Y ( n458 ) ) ;
NAND2XL U1626 ( .A ( n458 ) , .B ( HFSNET_347 ) , .Y ( n948 ) ) ;
ADDFHXL U1627 ( .A ( meas_val_p[22] ) , .B ( meas_val_n[22] ) , 
    .CI ( accumulator[22] ) , .CO ( n462 ) , .S ( n437 ) ) ;
NAND2XL U1628 ( .A ( n510 ) , .B ( n508 ) , .Y ( n464 ) ) ;
NAND2XL ctmTdsLR_2_860 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][12] ) , 
    .Y ( tmp_net137 ) ) ;
NAND2XL ctmTdsLR_1_1908 ( .A ( n1296_CDR1 ) , .B ( tmp_net378 ) , 
    .Y ( HFSNET_160 ) ) ;
INVXL U1632 ( .A ( n470 ) , .Y ( n538 ) ) ;
NAND2XL U1633 ( .A ( n538 ) , .B ( n536 ) , .Y ( n471 ) ) ;
XNOR2XL U1634 ( .A ( n539 ) , .B ( n471 ) , .Y ( n472 ) ) ;
NAND2XL U1635 ( .A ( n472 ) , .B ( HFSNET_347 ) , .Y ( n953 ) ) ;
AOI2BB1XL U1636 ( .A0N ( n579 ) , .A1N ( wait_cnt[4] ) , .B0 ( n2076 ) , 
    .Y ( n475 ) ) ;
INVXL U1637 ( .A ( n573 ) , .Y ( n473 ) ) ;
AOI21XL U1638 ( .A0 ( n475 ) , .A1 ( n474 ) , .B0 ( n473 ) , .Y ( n790 ) ) ;
NAND2XL U1639 ( .A ( n1875 ) , .B ( n2173 ) , .Y ( n973 ) ) ;
OAI21XL U1640 ( .A0 ( n478 ) , .A1 ( n477 ) , .B0 ( n476 ) , .Y ( n483 ) ) ;
XNOR2XL U1643 ( .A ( n483 ) , .B ( n482 ) , .Y ( n484 ) ) ;
NAND2XL U1644 ( .A ( n484 ) , .B ( HFSNET_347 ) , .Y ( n956 ) ) ;
NAND2XL U1645 ( .A ( n488 ) , .B ( n487 ) , .Y ( n489 ) ) ;
NAND2XL U1646 ( .A ( n491 ) , .B ( HFSNET_347 ) , .Y ( n946 ) ) ;
NAND2XL U1647 ( .A ( n495 ) , .B ( n494 ) , .Y ( n496 ) ) ;
NAND2XL U1648 ( .A ( n498 ) , .B ( HFSNET_347 ) , .Y ( n944 ) ) ;
NAND4XL ctmTdsLR_5_772 ( .A ( tmp_net79 ) , .B ( tmp_net80 ) , 
    .C ( tmp_net81 ) , .D ( tmp_net82 ) , .Y ( HFSNET_41 ) ) ;
NAND2XL U1652 ( .A ( n507 ) , .B ( HFSNET_347 ) , .Y ( n947 ) ) ;
AOI21XL U1653 ( .A0 ( n511 ) , .A1 ( n510 ) , .B0 ( n509 ) , .Y ( n563 ) ) ;
ADDFHXL U1654 ( .A ( meas_val_p[23] ) , .B ( meas_val_n[23] ) , 
    .CI ( accumulator[23] ) , .CO ( n512 ) , .S ( n463 ) ) ;
BUFX12 ZCTSBUF_255_1346 ( .A ( net1736 ) , .Y ( ZCTSNET_393 ) ) ;
AOI22XL U1658 ( .A0 ( target_bit[0] ) , .A1 ( n2158 ) , 
    .B0 ( target_bit[1] ) , .B1 ( n2163 ) , .Y ( n518 ) ) ;
AOI21XL U1660 ( .A0 ( n2100 ) , .A1 ( n2132 ) , .B0 ( n2076 ) , .Y ( n517 ) ) ;
AOI21XL U1661 ( .A0 ( n518 ) , .A1 ( n2078 ) , .B0 ( n517 ) , .Y ( n792 ) ) ;
INVXL U1662 ( .A ( n522 ) , .Y ( n533 ) ) ;
INVXL U1663 ( .A ( n532 ) , .Y ( n523 ) ) ;
XOR2XL U1666 ( .A ( n528 ) , .B ( n527 ) , .Y ( n530 ) ) ;
AOI21XL U1667 ( .A0 ( n530 ) , .A1 ( HFSNET_347 ) , .B0 ( HFSNET_291 ) , 
    .Y ( n818 ) ) ;
NAND2XL U1668 ( .A ( n533 ) , .B ( n532 ) , .Y ( n534 ) ) ;
NAND2XL U1669 ( .A ( n535 ) , .B ( HFSNET_347 ) , .Y ( n951 ) ) ;
INVXL U1670 ( .A ( n536 ) , .Y ( n537 ) ) ;
NAND2XL U1673 ( .A ( n545 ) , .B ( HFSNET_347 ) , .Y ( n952 ) ) ;
NOR2XL U1674 ( .A ( calc_cnt[0] ) , .B ( calc_cnt[1] ) , .Y ( n617 ) ) ;
NAND2XL U1675 ( .A ( calc_cnt[0] ) , .B ( calc_cnt[1] ) , .Y ( n618 ) ) ;
NAND3XL U1676 ( .A ( n1875 ) , .B ( n629 ) , .C ( n618 ) , .Y ( n972 ) ) ;
NAND2XL ctmTdsLR_1_773 ( .A ( n1278 ) , .B ( \shadow_weights[8][13] ) , 
    .Y ( tmp_net83 ) ) ;
NAND2XL ctmTdsLR_2_774 ( .A ( n1277 ) , .B ( \shadow_weights[10][13] ) , 
    .Y ( tmp_net84 ) ) ;
NAND2XL U1681 ( .A ( n556 ) , .B ( HFSNET_347 ) , .Y ( n945 ) ) ;
NAND2XL U1682 ( .A ( n557 ) , .B ( calc_cnt[2] ) , .Y ( n614 ) ) ;
OAI211XL U1683 ( .A0 ( calc_cnt[2] ) , .A1 ( n557 ) , .B0 ( n1875 ) , 
    .C0 ( n614 ) , .Y ( n971 ) ) ;
INVXL U1684 ( .A ( n614 ) , .Y ( n558 ) ) ;
OAI211XL U1686 ( .A0 ( calc_cnt[3] ) , .A1 ( n558 ) , .B0 ( n1875 ) , 
    .C0 ( n1698 ) , .Y ( n970 ) ) ;
INVXL U1687 ( .A ( n2076 ) , .Y ( n1629 ) ) ;
AOI22XL U1688 ( .A0 ( n2078 ) , .A1 ( n2163 ) , .B0 ( n2199 ) , 
    .B1 ( n1629 ) , .Y ( n791 ) ) ;
NOR2XL U1689 ( .A ( wr_idx_r[1] ) , .B ( n815 ) , .Y ( n576 ) ) ;
AOI22XL U1690 ( .A0 ( wr_idx_r[1] ) , .A1 ( n559 ) , .B0 ( wr_idx_r[0] ) , 
    .B1 ( n576 ) , .Y ( n560 ) ) ;
INVXL U1691 ( .A ( n638 ) , .Y ( n1658 ) ) ;
NAND3XL U1692 ( .A ( n639 ) , .B ( n68 ) , .C ( n2172 ) , .Y ( n1657 ) ) ;
NAND3XL U1693 ( .A ( n560 ) , .B ( n1658 ) , .C ( n1657 ) , .Y ( N1490 ) ) ;
ADDFHXL U1694 ( .A ( meas_val_p[24] ) , .B ( meas_val_n[24] ) , 
    .CI ( accumulator[24] ) , .CO ( n564 ) , .S ( n513 ) ) ;
NAND2XL U1695 ( .A ( n583 ) , .B ( n581 ) , .Y ( n566 ) ) ;
INVXL U1696 ( .A ( n2072 ) , .Y ( n1992 ) ) ;
NAND2XL U1697 ( .A ( n1992 ) , .B ( n2202 ) , .Y ( n571 ) ) ;
OAI21XL U1698 ( .A0 ( n1992 ) , .A1 ( n2202 ) , .B0 ( n571 ) , .Y ( n569 ) ) ;
NOR2XL U1699 ( .A ( n2100 ) , .B ( sar_ptr[2] ) , .Y ( n2074 ) ) ;
NAND2XL U1700 ( .A ( n2074 ) , .B ( n1 ) , .Y ( n570 ) ) ;
OAI21XL U1701 ( .A0 ( n2074 ) , .A1 ( n1 ) , .B0 ( n570 ) , .Y ( n568 ) ) ;
AOI22XL U1702 ( .A0 ( n2078 ) , .A1 ( n569 ) , .B0 ( n1629 ) , .B1 ( n568 ) , 
    .Y ( n794 ) ) ;
NOR2XL U1703 ( .A ( n570 ) , .B ( sar_ptr[4] ) , .Y ( n1626 ) ) ;
AOI21XL U1704 ( .A0 ( n570 ) , .A1 ( sar_ptr[4] ) , .B0 ( n1626 ) , 
    .Y ( n574 ) ) ;
AOI22XL U1705 ( .A0 ( target_bit[4] ) , .A1 ( n571 ) , .B0 ( n2020 ) , 
    .B1 ( n1992 ) , .Y ( n572 ) ) ;
OAI22XL U1706 ( .A0 ( n2076 ) , .A1 ( n574 ) , .B0 ( n573 ) , .B1 ( n572 ) , 
    .Y ( n575 ) ) ;
INVXL U1707 ( .A ( n575 ) , .Y ( n820 ) ) ;
AOI22XL U1708 ( .A0 ( wr_idx_r[1] ) , .A1 ( n666 ) , .B0 ( wr_idx_r[2] ) , 
    .B1 ( n576 ) , .Y ( n578 ) ) ;
NAND4XL U1709 ( .A ( n578 ) , .B ( n1658 ) , .C ( n1657 ) , .D ( n577 ) , 
    .Y ( N1491 ) ) ;
AOI32XL U1710 ( .A0 ( wait_cnt[1] ) , .A1 ( n641 ) , .A2 ( wait_cnt[0] ) , 
    .B0 ( n1984 ) , .B1 ( n641 ) , .Y ( n926 ) ) ;
AOI32XL U1711 ( .A0 ( wait_cnt[3] ) , .A1 ( n641 ) , .A2 ( n580 ) , 
    .B0 ( n579 ) , .B1 ( n641 ) , .Y ( n924 ) ) ;
AOI21XL U1712 ( .A0 ( n584 ) , .A1 ( n583 ) , .B0 ( n582 ) , .Y ( n644 ) ) ;
ADDFHXL U1713 ( .A ( meas_val_p[25] ) , .B ( meas_val_n[25] ) , 
    .CI ( accumulator[25] ) , .CO ( n585 ) , .S ( n565 ) ) ;
OR4X1 ctmTdsLR_1_1887 ( .A ( tmp_net177 ) , .B ( tmp_net176 ) , 
    .C ( tmp_net340 ) , .D ( tmp_net362 ) , .Y ( HFSNET_164 ) ) ;
NAND4XL ctmTdsLR_2_1785 ( .A ( tmp_net289 ) , .B ( tmp_net290 ) , 
    .C ( tmp_net291 ) , .D ( tmp_net292 ) , .Y ( tmp_net293 ) ) ;
INVXL U1718 ( .A ( n595 ) , .Y ( n603 ) ) ;
NAND2XL U1719 ( .A ( n603 ) , .B ( n601 ) , .Y ( n596 ) ) ;
NAND2XL U1720 ( .A ( n597 ) , .B ( HFSNET_347 ) , .Y ( n950 ) ) ;
NAND3XL U1721 ( .A ( N1822 ) , .B ( wr_idx_r[2] ) , .C ( wr_idx_r[0] ) , 
    .Y ( n599 ) ) ;
NOR2XL U1722 ( .A ( n668 ) , .B ( n599 ) , .Y ( N1827 ) ) ;
INVXL HFSINV_11_530 ( .A ( N1835 ) , .Y ( HFSNET_270 ) ) ;
NOR2X1 U1724 ( .A ( n667 ) , .B ( n599 ) , .Y ( N1835 ) ) ;
NOR2X1 U1725 ( .A ( n600 ) , .B ( n599 ) , .Y ( N1837 ) ) ;
INVXL U1726 ( .A ( n601 ) , .Y ( n602 ) ) ;
NAND2XL U1729 ( .A ( n610 ) , .B ( HFSNET_347 ) , .Y ( n949 ) ) ;
NOR2XL U1730 ( .A ( calc_cnt[2] ) , .B ( calc_cnt[3] ) , .Y ( n1659 ) ) ;
OR2XL U1732 ( .A ( n631 ) , .B ( n626 ) , .Y ( n1297 ) ) ;
OR2X1 U1733 ( .A ( n631 ) , .B ( n618 ) , .Y ( n1298 ) ) ;
NOR2XL U1734 ( .A ( n2176 ) , .B ( calc_cnt[4] ) , .Y ( n611 ) ) ;
NAND2XL U1735 ( .A ( n611 ) , .B ( n2175 ) , .Y ( n628 ) ) ;
OR2XL U1736 ( .A ( n628 ) , .B ( n629 ) , .Y ( n1299 ) ) ;
OR2XL U1737 ( .A ( n628 ) , .B ( n626 ) , .Y ( n1300 ) ) ;
NAND2XL ctmTdsLR_3_1786 ( .A ( gre_a_INV_6625_58 ) , 
    .B ( \shadow_weights[15][5] ) , .Y ( tmp_net289 ) ) ;
NAND2XL U1739 ( .A ( n611 ) , .B ( calc_cnt[3] ) , .Y ( n627 ) ) ;
OR2XL U1740 ( .A ( n627 ) , .B ( n629 ) , .Y ( n1301 ) ) ;
OR2XL U1741 ( .A ( n627 ) , .B ( n630 ) , .Y ( n1302 ) ) ;
NAND2XL ctmTdsLR_4_1787 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][5] ) , 
    .Y ( tmp_net290 ) ) ;
NAND4XL ctmTdsLR_3_861 ( .A ( n1174 ) , .B ( n1175 ) , .C ( tmp_net136 ) , 
    .D ( tmp_net137 ) , .Y ( tmp_net138 ) ) ;
INVX4 HFSINV_256_603 ( .A ( n1210 ) , .Y ( HFSNET_342 ) ) ;
AOI22XL ctmTdsLR_1_957 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][14] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][14] ) , .Y ( tmp_net204 ) ) ;
NAND3XL U1746 ( .A ( n2176 ) , .B ( n2161 ) , .C ( calc_cnt[3] ) , 
    .Y ( n616 ) ) ;
OR2XL U1747 ( .A ( n616 ) , .B ( n618 ) , .Y ( n1305 ) ) ;
OR2XL U1748 ( .A ( n616 ) , .B ( n626 ) , .Y ( n1306 ) ) ;
AOI22XL U1749 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][0] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][0] ) , .Y ( n615 ) ) ;
OR2XL U1750 ( .A ( n616 ) , .B ( n629 ) , .Y ( n1308 ) ) ;
OR2XL U1751 ( .A ( n616 ) , .B ( n630 ) , .Y ( n1309 ) ) ;
AOI22X1 U1752 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][0] ) , 
    .B0 ( n1278 ) , .B1 ( \shadow_weights[8][0] ) , .Y ( n621 ) ) ;
OR2X1 U1753 ( .A ( n630 ) , .B ( n2161 ) , .Y ( n675 ) ) ;
OR4X2 ctmTdsLR_4_862 ( .A ( n1173_CDR1 ) , .B ( HFSNET_41 ) , 
    .C ( n1172_CDR1 ) , .D ( tmp_net138 ) , .Y ( HFSNET_171 ) ) ;
OR2X1 U1755 ( .A ( n626 ) , .B ( n2161 ) , .Y ( n676 ) ) ;
OR2XL U1756 ( .A ( n618 ) , .B ( n2161 ) , .Y ( n1311 ) ) ;
AOI222XL ctmTdsLR_1_863 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][21] ) , 
    .B0 ( n1687 ) , .B1 ( \shadow_weights[2][21] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][21] ) , .Y ( tmp_net139 ) ) ;
OAI2BB1XL ctmTdsLR_2_864 ( .A0N ( \shadow_weights[15][21] ) , 
    .A1N ( gre_a_INV_6625_58 ) , .B0 ( tmp_net139 ) , .Y ( tmp_net140 ) ) ;
AOI21XL ctmTdsLR_3_865 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][21] ) , 
    .B0 ( tmp_net140 ) , .Y ( tmp_net141 ) ) ;
OR2XL U1760 ( .A ( n628 ) , .B ( n630 ) , .Y ( n1320 ) ) ;
OR2X1 U1761 ( .A ( n631 ) , .B ( n630 ) , .Y ( n1322 ) ) ;
OR2XL U1762 ( .A ( n1698 ) , .B ( calc_cnt[4] ) , .Y ( n993 ) ) ;
CLKBUFX8 ZCTSBUF_255_1347 ( .A ( net1741 ) , .Y ( ZCTSNET_394 ) ) ;
AND2X4 U1766 ( .A ( n659 ) , .B ( n1657 ) , .Y ( n640 ) ) ;
INVXL ctmTdsLR_3_1987 ( .A ( n357 ) , .Y ( tmp_net420 ) ) ;
AOI22XL U1768 ( .A0 ( n2157 ) , .A1 ( N1822 ) , .B0 ( n640 ) , 
    .B1 ( calib_overrange ) , .Y ( n698 ) ) ;
INVXL U1769 ( .A ( n641 ) , .Y ( n1982 ) ) ;
OR2XL U1770 ( .A ( wait_cnt[0] ) , .B ( n1982 ) , .Y ( n927 ) ) ;
ADDFHXL U1771 ( .A ( meas_val_p[26] ) , .B ( meas_val_n[26] ) , 
    .CI ( accumulator[26] ) , .CO ( n645 ) , .S ( n586 ) ) ;
AOI21X1 ctmTdsLR_2_1909 ( .A0 ( ZBUF_20020_1 ) , 
    .A1 ( \shadow_weights[0][18] ) , .B0 ( tmp_net377 ) , .Y ( tmp_net378 ) ) ;
NOR2BX2 U1773 ( .AN ( avg_cnt[4] ) , .B ( n1978 ) , .Y ( n1979 ) ) ;
NAND2XL U1774 ( .A ( n1627 ) , .B ( n1626 ) , .Y ( n1693 ) ) ;
NAND2X2 ctmTdsLR_4_866 ( .A ( n1354_CDR1 ) , .B ( tmp_net141 ) , 
    .Y ( HFSNET_162 ) ) ;
AOI222XL ctmTdsLR_1_867 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][19] ) , 
    .B0 ( n1687 ) , .B1 ( \shadow_weights[2][19] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][19] ) , .Y ( tmp_net142 ) ) ;
AOI211XL U1778 ( .A0 ( n725 ) , .A1 ( n1693 ) , .B0 ( n652 ) , .C0 ( n651 ) , 
    .Y ( n660 ) ) ;
OAI21XL U1779 ( .A0 ( n1979 ) , .A1 ( n322 ) , .B0 ( n660 ) , .Y ( n653 ) ) ;
AOI211XL U1780 ( .A0 ( n654 ) , .A1 ( n1658 ) , .B0 ( n663 ) , .C0 ( n653 ) , 
    .Y ( n816 ) ) ;
INVXL U1781 ( .A ( n1693 ) , .Y ( n726 ) ) ;
INVXL U1782 ( .A ( n732 ) , .Y ( n655 ) ) ;
OAI21XL U1783 ( .A0 ( n655 ) , .A1 ( state[1] ) , .B0 ( state[2] ) , 
    .Y ( n656 ) ) ;
OAI21XL U1784 ( .A0 ( start_calib ) , .A1 ( state[2] ) , .B0 ( n656 ) , 
    .Y ( n657 ) ) ;
NAND2XL U1785 ( .A ( n1979 ) , .B ( HFSNET_347 ) , .Y ( n730 ) ) ;
NAND4XL U1786 ( .A ( n660 ) , .B ( n1655 ) , .C ( n659 ) , .D ( n730 ) , 
    .Y ( n661 ) ) ;
AOI211XL U1787 ( .A0 ( n726 ) , .A1 ( n663 ) , .B0 ( n662 ) , .C0 ( n661 ) , 
    .Y ( n821 ) ) ;
NOR2X1 U1788 ( .A ( n664 ) , .B ( n667 ) , .Y ( N1839 ) ) ;
NOR2X1 U1789 ( .A ( n664 ) , .B ( n668 ) , .Y ( N1831 ) ) ;
NOR2XL U1790 ( .A ( n665 ) , .B ( n669 ) , .Y ( N1824 ) ) ;
NOR2X1 U1791 ( .A ( n670 ) , .B ( n671 ) , .Y ( N1825 ) ) ;
NOR2X2 U1792 ( .A ( n669 ) , .B ( n667 ) , .Y ( N1840 ) ) ;
NOR2X2 U1793 ( .A ( n669 ) , .B ( n668 ) , .Y ( N1832 ) ) ;
AOI22XL U1794 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][1] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][1] ) , .Y ( n673_CDR1 ) ) ;
AOI22XL U1795 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][1] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][1] ) , .Y ( n672_CDR1 ) ) ;
OAI2BB1XL ctmTdsLR_2_868 ( .A0N ( \shadow_weights[13][19] ) , .A1N ( n1319 ) , 
    .B0 ( tmp_net142 ) , .Y ( tmp_net143 ) ) ;
AOI21XL ctmTdsLR_3_869 ( .A0 ( gre_a_INV_6625_58 ) , 
    .A1 ( \shadow_weights[15][19] ) , .B0 ( tmp_net143 ) , .Y ( tmp_net144 ) ) ;
NAND2X1 ctmTdsLR_4_870 ( .A ( n1326_CDR2 ) , .B ( tmp_net144 ) , 
    .Y ( HFSNET_159 ) ) ;
AOI222XL ctmTdsLR_1_871 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][28] ) , 
    .B0 ( ZBUF_20020_1 ) , .B1 ( \shadow_weights[0][28] ) , .C0 ( n1687 ) , 
    .C1 ( \shadow_weights[2][28] ) , .Y ( tmp_net145 ) ) ;
OAI2BB1XL ctmTdsLR_3_1910 ( .A0N ( \shadow_weights[15][18] ) , 
    .A1N ( gre_a_INV_6625_58 ) , .B0 ( tmp_net376 ) , .Y ( tmp_net377 ) ) ;
AOI222XL ctmTdsLR_4_1911 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][18] ) , 
    .B0 ( n1291 ) , .B1 ( \shadow_weights[13][18] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][18] ) , .Y ( tmp_net376 ) ) ;
OAI2BB1XL ctmTdsLR_2_958 ( .A0N ( \shadow_weights[2][14] ) , .A1N ( n1292 ) , 
    .B0 ( tmp_net204 ) , .Y ( tmp_net205 ) ) ;
NOR2XL U1803 ( .A ( HFSNET_128 ) , .B ( temp_acc[1] ) , .Y ( n739 ) ) ;
AOI21XL U1804 ( .A0 ( n695 ) , .A1 ( n694 ) , .B0 ( n693 ) , .Y ( n806 ) ) ;
ADDFHXL U1805 ( .A ( meas_val_p[27] ) , .B ( meas_val_n[27] ) , 
    .CI ( accumulator[27] ) , .CO ( n696 ) , .S ( n646 ) ) ;
AOI21XL U1809 ( .A0 ( n732 ) , .A1 ( n723 ) , .B0 ( n56 ) , .Y ( n724 ) ) ;
NAND3XL U1813 ( .A ( n730 ) , .B ( n729 ) , .C ( n1416 ) , .Y ( n731 ) ) ;
NAND2XL ctmTdsLR_1_778 ( .A ( n1278 ) , .B ( \shadow_weights[8][14] ) , 
    .Y ( tmp_net87 ) ) ;
NAND2XL ctmTdsLR_2_779 ( .A ( n1277 ) , .B ( \shadow_weights[10][14] ) , 
    .Y ( tmp_net88 ) ) ;
AOI222XL ctmTdsLR_3_780 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][14] ) , 
    .B0 ( n1282 ) , .B1 ( HFSNET_211 ) , .C0 ( \shadow_weights[19][14] ) , 
    .C1 ( n1281 ) , .Y ( tmp_net89 ) ) ;
NAND2XL ctmTdsLR_4_781 ( .A ( n1279 ) , .B ( \shadow_weights[16][14] ) , 
    .Y ( tmp_net90 ) ) ;
AOI22X1 U1818 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][2] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][2] ) , .Y ( n745_CDR2 ) ) ;
NAND4XL ctmTdsLR_5_782 ( .A ( tmp_net87 ) , .B ( tmp_net89 ) , 
    .C ( tmp_net90 ) , .D ( tmp_net88 ) , .Y ( HFSNET_45 ) ) ;
AOI22XL ctmTdsLR_1_783 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][20] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][20] ) , .Y ( tmp_net91 ) ) ;
AND2XL ctmTdsLR_2_1888 ( .A ( HFSNET_342 ) , .B ( \shadow_weights[7][17] ) , 
    .Y ( tmp_net362 ) ) ;
AOI22XL ctmTdsLR_2_784 ( .A0 ( n1671 ) , .A1 ( HFSNET_234 ) , .B0 ( n1672 ) , 
    .B1 ( \shadow_weights[19][20] ) , .Y ( tmp_net92 ) ) ;
NOR2XL U1823 ( .A ( HFSNET_129 ) , .B ( temp_acc[2] ) , .Y ( n976 ) ) ;
NAND2XL U1824 ( .A ( HFSNET_129 ) , .B ( temp_acc[2] ) , .Y ( n978 ) ) ;
OAI21XL U1825 ( .A0 ( n779 ) , .A1 ( n976 ) , .B0 ( n978 ) , .Y ( n802 ) ) ;
AOI22XL U1826 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][3] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][3] ) , .Y ( n784 ) ) ;
AOI22XL U1827 ( .A0 ( n1282 ) , .A1 ( \shadow_weights[17][3] ) , 
    .B0 ( n1281 ) , .B1 ( \shadow_weights[19][3] ) , .Y ( n783 ) ) ;
NAND3XL ctmTdsLR_3_785 ( .A ( n1332_CDR1 ) , .B ( tmp_net91 ) , 
    .C ( tmp_net92 ) , .Y ( HFSNET_53 ) ) ;
NOR2XL U1830 ( .A ( HFSNET_130 ) , .B ( temp_acc[3] ) , .Y ( n979 ) ) ;
OAI21XL U1831 ( .A0 ( n806 ) , .A1 ( n805 ) , .B0 ( n804 ) , .Y ( n814 ) ) ;
ADDFHXL U1832 ( .A ( meas_val_p[28] ) , .B ( meas_val_n[28] ) , 
    .CI ( accumulator[28] ) , .CO ( n807 ) , .S ( n718 ) ) ;
OR4XL ctmTdsLR_1_1912 ( .A ( tmp_net379 ) , .B ( copt_gre_net_478 ) , 
    .C ( copt_gre_net_479 ) , .D ( tmp_net381 ) , .Y ( HFSNET_163 ) ) ;
AOI21X1 U1834 ( .A0 ( n814 ) , .A1 ( n813 ) , .B0 ( n812 ) , .Y ( n1082 ) ) ;
CMPR32X1 U1835 ( .A ( accumulator[29] ) , .B ( n2169 ) , .C ( n2193 ) , 
    .CO ( n824 ) , .S ( n808 ) ) ;
OAI21XL U1838 ( .A0 ( n979 ) , .A1 ( n978 ) , .B0 ( n977 ) , .Y ( n980 ) ) ;
AOI21XL U1839 ( .A0 ( n982 ) , .A1 ( n981 ) , .B0 ( n980 ) , .Y ( n1061 ) ) ;
INVXL U1840 ( .A ( n1061 ) , .Y ( n1087 ) ) ;
OAI2BB1XL ctmTdsLR_2_872 ( .A0N ( \shadow_weights[15][28] ) , 
    .A1N ( gre_a_INV_6625_58 ) , .B0 ( tmp_net145 ) , .Y ( tmp_net146 ) ) ;
AOI21XL ctmTdsLR_3_873 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][28] ) , 
    .B0 ( tmp_net146 ) , .Y ( tmp_net147 ) ) ;
AND2XL ctmTdsLR_2_1913 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][4] ) , 
    .Y ( tmp_net379 ) ) ;
NOR2XL U1844 ( .A ( HFSNET_163 ) , .B ( temp_acc[4] ) , .Y ( n1022 ) ) ;
NAND2XL U1845 ( .A ( HFSNET_163 ) , .B ( temp_acc[4] ) , .Y ( n1053 ) ) ;
NAND2XL ctmTdsLR_4_874 ( .A ( n1622_CDR2 ) , .B ( tmp_net147 ) , 
    .Y ( HFSNET_157 ) ) ;
AOI222XL ctmTdsLR_1_875 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][27] ) , 
    .B0 ( n1687 ) , .B1 ( \shadow_weights[2][27] ) , .C0 ( ZBUF_20020_1 ) , 
    .C1 ( \shadow_weights[0][27] ) , .Y ( tmp_net148 ) ) ;
NAND2XL ctmTdsLR_2_876 ( .A ( n1319 ) , .B ( \shadow_weights[13][27] ) , 
    .Y ( tmp_net149 ) ) ;
BUFXL ZBUF_2_inst_1045 ( .A ( tmp_net47 ) , .Y ( ZBUF_2_20 ) ) ;
NOR2XL U1850 ( .A ( HFSNET_131 ) , .B ( temp_acc[5] ) , .Y ( n1054 ) ) ;
NOR2XL U1851 ( .A ( n1022 ) , .B ( n1054 ) , .Y ( n1086 ) ) ;
NAND4XL ctmTdsLR_3_877 ( .A ( n1598 ) , .B ( tmp_net148 ) , 
    .C ( tmp_net149 ) , .D ( n1597_CDR2 ) , .Y ( tmp_net150 ) ) ;
OR4X2 ctmTdsLR_4_878 ( .A ( n1596_CDR1 ) , .B ( n1595_CDR2 ) , 
    .C ( n1594_CDR2 ) , .D ( tmp_net150 ) , .Y ( HFSNET_155 ) ) ;
NOR4BX2 U1854 ( .AN ( n1032_CDR2 ) , .B ( n1031_CDR2 ) , .C ( n1030_CDR2 ) , 
    .D ( HFSNET_103 ) , .Y ( n1036 ) ) ;
AOI221XL ctmTdsLR_3_959 ( .A0 ( ZBUF_20020_1 ) , 
    .A1 ( \shadow_weights[0][14] ) , .B0 ( gre_a_INV_6625_58 ) , 
    .B1 ( \shadow_weights[15][14] ) , .C0 ( tmp_net205 ) , .Y ( tmp_net206 ) ) ;
NOR2XL U1856 ( .A ( HFSNET_132 ) , .B ( temp_acc[6] ) , .Y ( n1134 ) ) ;
AOI22XL ctmTdsLR_1_786 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][29] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][29] ) , .Y ( tmp_net93 ) ) ;
AOI22XL ctmTdsLR_2_787 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][29] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][29] ) , .Y ( tmp_net94 ) ) ;
OAI2BB1XL ctmTdsLR_3_1914 ( .A0N ( \shadow_weights[15][4] ) , 
    .A1N ( gre_a_INV_6625_58 ) , .B0 ( tmp_net380 ) , .Y ( tmp_net381 ) ) ;
NAND2XL ctmTdsLR_4_960 ( .A ( n1206_CDR2 ) , .B ( tmp_net206 ) , 
    .Y ( HFSNET_170 ) ) ;
NOR2XL U1861 ( .A ( HFSNET_133 ) , .B ( temp_acc[7] ) , .Y ( n1136 ) ) ;
NOR2XL U1862 ( .A ( n1134 ) , .B ( n1136 ) , .Y ( n1058 ) ) ;
NAND2XL U1863 ( .A ( HFSNET_132 ) , .B ( temp_acc[6] ) , .Y ( n1133 ) ) ;
OAI21XL U1864 ( .A0 ( n1136 ) , .A1 ( n1133 ) , .B0 ( n1137 ) , .Y ( n1057 ) ) ;
AOI21XL U1865 ( .A0 ( n1058 ) , .A1 ( n1085 ) , .B0 ( n1057 ) , .Y ( n1059 ) ) ;
OAI21XL U1866 ( .A0 ( n1061 ) , .A1 ( n1060 ) , .B0 ( n1059 ) , .Y ( n1235 ) ) ;
INVXL U1867 ( .A ( n1235 ) , .Y ( n1423 ) ) ;
AOI22XL U1868 ( .A0 ( n1266 ) , .A1 ( \shadow_weights[3][8] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][8] ) , 
    .Y ( n1071_CDR2 ) ) ;
AOI22X2 U1869 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][8] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][8] ) , .Y ( n1063 ) ) ;
AOI22X1 U1870 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][8] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][8] ) , 
    .Y ( n1062_CDR1 ) ) ;
AOI222XL ctmTdsLR_4_1915 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][4] ) , 
    .B0 ( n1292 ) , .B1 ( \shadow_weights[2][4] ) , .C0 ( n1319 ) , 
    .C1 ( \shadow_weights[13][4] ) , .Y ( tmp_net380 ) ) ;
AOI22XL U1872 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][8] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][8] ) , .Y ( n1064 ) ) ;
OAI2BB1XL ctmTdsLR_4_1846 ( .A0N ( \shadow_weights[1][18] ) , 
    .A1N ( gre_a_INV_6238_58 ) , .B0 ( ZBUF_2_0 ) , .Y ( tmp_net334 ) ) ;
NAND2XL ctmTdsLR_2_1955 ( .A ( n271 ) , .B ( n279 ) , .Y ( tmp_net402 ) ) ;
NAND2XL ctmTdsLR_1_2001 ( .A ( n694 ) , .B ( n692 ) , .Y ( tmp_net423 ) ) ;
OAI21XL ctmTdsLR_1_1956 ( .A0 ( n291 ) , .A1 ( tmp_net403 ) , 
    .B0 ( tmp_net404 ) , .Y ( n296 ) ) ;
NOR2XL U1877 ( .A ( HFSNET_172 ) , .B ( temp_acc[8] ) , .Y ( n1110 ) ) ;
NAND2XL U1880 ( .A ( n1144 ) , .B ( n1142 ) , .Y ( n1083 ) ) ;
AOI21XL U1881 ( .A0 ( n1087 ) , .A1 ( n1086 ) , .B0 ( n1085 ) , .Y ( n1135 ) ) ;
OAI21XL U1882 ( .A0 ( n1423 ) , .A1 ( n1110 ) , .B0 ( n1112 ) , .Y ( n1108 ) ) ;
NAND2XL ctmTdsLR_1_791 ( .A ( n1278 ) , .B ( \shadow_weights[8][6] ) , 
    .Y ( tmp_net96 ) ) ;
NAND2XL ctmTdsLR_2_792 ( .A ( n1277 ) , .B ( \shadow_weights[10][6] ) , 
    .Y ( tmp_net97 ) ) ;
OAI2BB1XL ctmTdsLR_5_1847 ( .A0N ( \shadow_weights[9][18] ) , .A1N ( n1274 ) , 
    .B0 ( tmp_net101 ) , .Y ( tmp_net335 ) ) ;
NOR2XL U1887 ( .A ( HFSNET_134 ) , .B ( temp_acc[9] ) , .Y ( n1113 ) ) ;
NOR2XL U1888 ( .A ( n1110 ) , .B ( n1113 ) , .Y ( n1164 ) ) ;
AND4XL ctmTdsLR_1_2002 ( .A ( tmp_net310 ) , .B ( n1355_CDR1 ) , 
    .C ( n1356_CDR2 ) , .D ( n1357_CDR2 ) , .Y ( HFSNET_75 ) ) ;
XOR2X1 ctmTdsLR_2_1957 ( .A ( n293 ) , .B ( \shadow_weights[18][29] ) , 
    .Y ( tmp_net403 ) ) ;
OAI21XL ctmTdsLR_1_2003 ( .A0 ( n1108 ) , .A1 ( n1107 ) , .B0 ( tmp_net429 ) , 
    .Y ( n1109 ) ) ;
CLKBUFX8 ZCTSBUF_251_1348 ( .A ( net1746 ) , .Y ( ZCTSNET_395 ) ) ;
NOR2XL U1893 ( .A ( HFSNET_135 ) , .B ( temp_acc[10] ) , .Y ( n1163 ) ) ;
NAND2XL U1894 ( .A ( HFSNET_135 ) , .B ( temp_acc[10] ) , .Y ( n1432 ) ) ;
OAI21XL U1895 ( .A0 ( n1135 ) , .A1 ( n1134 ) , .B0 ( n1133 ) , .Y ( n1140 ) ) ;
AOI21XL U1896 ( .A0 ( n1145 ) , .A1 ( n1144 ) , .B0 ( n1143 ) , .Y ( n1495 ) ) ;
NAND2XL ctmTdsLR_3_1958 ( .A ( n291 ) , .B ( tmp_net403 ) , 
    .Y ( tmp_net404 ) ) ;
OAI21XL ctmTdsLR_1_1969 ( .A0 ( n1843 ) , .A1 ( n1842 ) , .B0 ( tmp_net412 ) , 
    .Y ( n1847 ) ) ;
NAND2XL ctmTdsLR_2_1970 ( .A ( tmp_net411 ) , .B ( n1840 ) , .Y ( n1842 ) ) ;
AOI222XL ctmTdsLR_3_793 ( .A0 ( \shadow_weights[19][6] ) , .A1 ( n1281 ) , 
    .B0 ( n1280 ) , .B1 ( \shadow_weights[18][6] ) , .C0 ( n1282 ) , 
    .C1 ( \shadow_weights[17][6] ) , .Y ( tmp_net98 ) ) ;
NOR2XL U1903 ( .A ( HFSNET_136 ) , .B ( temp_acc[11] ) , .Y ( n1436 ) ) ;
NOR2XL U1904 ( .A ( n1163 ) , .B ( n1436 ) , .Y ( n1225 ) ) ;
NAND2XL U1905 ( .A ( n1164 ) , .B ( n1225 ) , .Y ( n1422 ) ) ;
AOI22XL U1906 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][12] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][12] ) , .Y ( n1174 ) ) ;
AOI22XL U1907 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][12] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][12] ) , .Y ( n1166_CDR1 ) ) ;
AOI22XL U1908 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][12] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][12] ) , 
    .Y ( n1165_CDR1 ) ) ;
NAND2XL U1909 ( .A ( n1166_CDR1 ) , .B ( n1165_CDR1 ) , .Y ( n1173_CDR1 ) ) ;
AOI22X1 U1910 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][12] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][12] ) , .Y ( n1167_CDR1 ) ) ;
AOI222XL ctmTdsLR_1_885 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][7] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][7] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][7] ) , .Y ( tmp_net155 ) ) ;
INVXL ctmTdsLR_3_1971 ( .A ( n1839 ) , .Y ( tmp_net411 ) ) ;
NAND2XL ctmTdsLR_4_1972 ( .A ( n1843 ) , .B ( n1842 ) , .Y ( tmp_net412 ) ) ;
NAND2XL ctmTdsLR_4_794 ( .A ( n1279 ) , .B ( \shadow_weights[16][6] ) , 
    .Y ( tmp_net99 ) ) ;
AOI22XL U1915 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][13] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][13] ) , .Y ( n1188 ) ) ;
AOI22XL U1916 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][13] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][13] ) , .Y ( n1180_CDR2 ) ) ;
AOI22XL U1917 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][13] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][13] ) , .Y ( n1179 ) ) ;
NAND2XL U1918 ( .A ( n1180_CDR2 ) , .B ( n1179 ) , .Y ( n1187_CDR2 ) ) ;
AOI22XL U1919 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][13] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][13] ) , .Y ( n1181_CDR2 ) ) ;
OAI21XL ctmTdsLR_1_1973 ( .A0 ( HFSNET_293 ) , .A1 ( n1419 ) , 
    .B0 ( tmp_net413 ) , .Y ( n1420 ) ) ;
NAND2XL ctmTdsLR_2_1974 ( .A ( HFSNET_293 ) , .B ( n1419 ) , 
    .Y ( tmp_net413 ) ) ;
NOR3XL ctmTdsLR_1_1977 ( .A ( n1187_CDR2 ) , .B ( n1186_CDR2 ) , 
    .C ( tmp_net417 ) , .Y ( n1192_CDR1 ) ) ;
NAND4X1 ctmTdsLR_5_795 ( .A ( tmp_net98 ) , .B ( tmp_net96 ) , 
    .C ( tmp_net99 ) , .D ( tmp_net97 ) , .Y ( HFSNET_103 ) ) ;
NOR2XL U1924 ( .A ( HFSNET_168 ) , .B ( temp_acc[13] ) , .Y ( n1426 ) ) ;
NOR2XL U1925 ( .A ( n1424 ) , .B ( n1426 ) , .Y ( n1485 ) ) ;
AOI22XL U1926 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][14] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][14] ) , .Y ( n1202_CDR2 ) ) ;
AOI22XL U1927 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][14] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][14] ) , .Y ( n1194_CDR2 ) ) ;
AOI22XL U1928 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][14] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][14] ) , 
    .Y ( n1193_CDR1 ) ) ;
NAND2XL U1929 ( .A ( n1194_CDR2 ) , .B ( n1193_CDR1 ) , .Y ( n1201_CDR2 ) ) ;
AOI22XL U1930 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][14] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][14] ) , .Y ( n1195_CDR1 ) ) ;
NAND2XL ctmTdsLR_1_891 ( .A ( n1319 ) , .B ( \shadow_weights[13][0] ) , 
    .Y ( tmp_net159 ) ) ;
AOI222XL ctmTdsLR_5_1788 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][5] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][5] ) , 
    .C0 ( gre_a_INV_6610_58 ) , .C1 ( \shadow_weights[11][5] ) , 
    .Y ( tmp_net291 ) ) ;
NAND2XL ctmTdsLR_4_1734 ( .A ( n1319 ) , .B ( \shadow_weights[13][3] ) , 
    .Y ( tmp_net257 ) ) ;
AOI222XL ctmTdsLR_1_796 ( .A0 ( \shadow_weights[18][18] ) , .A1 ( n1280 ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][18] ) , 
    .C0 ( \shadow_weights[19][18] ) , .C1 ( n1281 ) , .Y ( tmp_net100 ) ) ;
AOI222XL ctmTdsLR_3_1746 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][0] ) , 
    .B0 ( n1266 ) , .B1 ( \shadow_weights[3][0] ) , 
    .C0 ( gre_a_INV_6238_58 ) , .C1 ( \shadow_weights[1][0] ) , 
    .Y ( tmp_net266 ) ) ;
NAND2XL ctmTdsLR_2_797 ( .A ( n1279 ) , .B ( \shadow_weights[16][18] ) , 
    .Y ( tmp_net101 ) ) ;
NAND2XL ctmTdsLR_2_1978 ( .A ( tmp_net416 ) , .B ( n1188 ) , 
    .Y ( tmp_net417 ) ) ;
INVX2 ctmTdsLR_3_1979 ( .A ( tmp_net415 ) , .Y ( tmp_net416 ) ) ;
AOI22XL U1939 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][15] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][15] ) , .Y ( n1209_CDR2 ) ) ;
AOI222XL ctmTdsLR_2_1748 ( .A0 ( n1279 ) , .A1 ( \shadow_weights[16][0] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][0] ) , .C0 ( n1270 ) , 
    .C1 ( \shadow_weights[14][0] ) , .Y ( tmp_net267 ) ) ;
NAND4X1 ctmTdsLR_3_801 ( .A ( tmp_net262 ) , .B ( tmp_net254 ) , 
    .C ( ZBUF_2_17 ) , .D ( ZBUF_2_52 ) , .Y ( HFSNET_173 ) ) ;
NAND4XL ctmTdsLR_4_1980 ( .A ( tmp_net273 ) , .B ( tmp_net83 ) , 
    .C ( tmp_net84 ) , .D ( tmp_net274 ) , .Y ( tmp_net415 ) ) ;
BUFX8 ZCTSBUF_255_1350 ( .A ( net1756 ) , .Y ( ZCTSNET_397 ) ) ;
NOR2XL U1944 ( .A ( HFSNET_173 ) , .B ( temp_acc[15] ) , .Y ( n1561 ) ) ;
NOR2XL U1945 ( .A ( n1490 ) , .B ( n1561 ) , .Y ( n1231 ) ) ;
OAI21XL U1946 ( .A0 ( n1436 ) , .A1 ( n1432 ) , .B0 ( n1437 ) , .Y ( n1223 ) ) ;
AOI21XL U1947 ( .A0 ( n1225 ) , .A1 ( n1224 ) , .B0 ( n1223 ) , .Y ( n1421 ) ) ;
OAI21XL U1948 ( .A0 ( n1561 ) , .A1 ( n1557 ) , .B0 ( n1562 ) , .Y ( n1230 ) ) ;
OAI21XL U1949 ( .A0 ( n1421 ) , .A1 ( n1233 ) , .B0 ( n1232 ) , .Y ( n1234 ) ) ;
AOI21X1 U1950 ( .A0 ( n1235 ) , .A1 ( n1236 ) , .B0 ( n1234 ) , .Y ( n1417 ) ) ;
AOI222XL ctmTdsLR_2_1750 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][7] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][7] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][7] ) , .Y ( tmp_net268 ) ) ;
OAI21XL ctmTdsLR_1_1981 ( .A0 ( n1800 ) , .A1 ( n1799 ) , .B0 ( tmp_net418 ) , 
    .Y ( n1804 ) ) ;
NOR2XL U1953 ( .A ( HFSNET_167 ) , .B ( temp_acc[16] ) , .Y ( n1418 ) ) ;
AOI22X1 ctmTdsLR_6_1789 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][5] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][5] ) , .Y ( tmp_net292 ) ) ;
NAND2XL ctmTdsLR_2_1982 ( .A ( n1800 ) , .B ( n1799 ) , .Y ( tmp_net418 ) ) ;
BUFX8 ZCTSBUF_251_1351 ( .A ( net1666 ) , .Y ( ZCTSNET_398 ) ) ;
NOR2XL U1957 ( .A ( HFSNET_164 ) , .B ( temp_acc[17] ) , .Y ( n1450 ) ) ;
NOR2XL U1958 ( .A ( n1418 ) , .B ( n1450 ) , .Y ( n1499 ) ) ;
BUFX12 ZCTSBUF_247_1352 ( .A ( net1671 ) , .Y ( ZCTSNET_399 ) ) ;
AOI222X1 ctmTdsLR_1_899 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][17] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][17] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][17] ) , .Y ( tmp_net165 ) ) ;
NAND2XL ctmTdsLR_2_900 ( .A ( ZBUF_20020_1 ) , .B ( \shadow_weights[0][17] ) , 
    .Y ( tmp_net166 ) ) ;
NAND2XL ctmTdsLR_4_1988 ( .A ( n352 ) , .B ( n351 ) , .Y ( tmp_net421 ) ) ;
NOR2XL U1963 ( .A ( HFSNET_160 ) , .B ( temp_acc[18] ) , .Y ( n1515 ) ) ;
AOI22XL U1964 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][19] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][19] ) , .Y ( n1303_CDR2 ) ) ;
AOI22XL U1965 ( .A0 ( gre_a_INV_6610_58 ) , .A1 ( \shadow_weights[11][19] ) , 
    .B0 ( HFSNET_342 ) , .B1 ( \shadow_weights[7][19] ) , .Y ( n1307_CDR2 ) ) ;
AOI22XL U1966 ( .A0 ( n1672 ) , .A1 ( \shadow_weights[19][19] ) , 
    .B0 ( n1669 ) , .B1 ( \shadow_weights[8][19] ) , .Y ( n1314_CDR1 ) ) ;
AOI22XL U1967 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][19] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][19] ) , .Y ( n1313_CDR2 ) ) ;
AOI22XL U1968 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][19] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][19] ) , .Y ( n1312_CDR2 ) ) ;
NAND3XL U1969 ( .A ( n1314_CDR1 ) , .B ( n1313_CDR2 ) , .C ( n1312_CDR2 ) , 
    .Y ( n1315_CDR2 ) ) ;
NOR4BX1 U1970 ( .AN ( n1318_CDR2 ) , .B ( n1317_CDR2 ) , .C ( n1316_CDR2 ) , 
    .D ( n1315_CDR2 ) , .Y ( n1326_CDR2 ) ) ;
NOR2XL U1971 ( .A ( HFSNET_159 ) , .B ( temp_acc[19] ) , .Y ( n1517 ) ) ;
NOR2XL U1972 ( .A ( n1515 ) , .B ( n1517 ) , .Y ( n1388 ) ) ;
AOI22XL U1973 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][20] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][20] ) , .Y ( n1327_CDR1 ) ) ;
AOI22XL U1974 ( .A0 ( n1660 ) , .A1 ( \shadow_weights[3][20] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][20] ) , 
    .Y ( n1329_CDR2 ) ) ;
AOI22XL U1975 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][20] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][20] ) , .Y ( n1332_CDR1 ) ) ;
BUFX8 ZCTSBUF_251_1353 ( .A ( net1676 ) , .Y ( ZCTSNET_400 ) ) ;
BUFX12 ZCTSBUF_255_1354 ( .A ( net1681 ) , .Y ( ZCTSNET_401 ) ) ;
AOI22XL ctmTdsLR_1_903 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][23] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][23] ) , .Y ( tmp_net168 ) ) ;
NOR2XL U1979 ( .A ( HFSNET_154 ) , .B ( temp_acc[20] ) , .Y ( n1524 ) ) ;
AOI22XL U1980 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][21] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][21] ) , .Y ( n1342_CDR1 ) ) ;
AOI22XL U1981 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][21] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][21] ) , 
    .Y ( n1341_CDR1 ) ) ;
NAND2XL U1982 ( .A ( n1342_CDR1 ) , .B ( n1341_CDR1 ) , .Y ( n1349_CDR1 ) ) ;
AOI22XL U1983 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][21] ) , 
    .B0 ( HFSNET_342 ) , .B1 ( \shadow_weights[7][21] ) , .Y ( n1343_CDR1 ) ) ;
AOI22XL U1984 ( .A0 ( n1668 ) , .A1 ( \shadow_weights[10][21] ) , 
    .B0 ( n1669 ) , .B1 ( \shadow_weights[8][21] ) , .Y ( n1346_CDR1 ) ) ;
AOI22XL U1985 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][21] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][21] ) , .Y ( n1345_CDR1 ) ) ;
AOI22XL U1986 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][21] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][21] ) , .Y ( n1344_CDR1 ) ) ;
NAND3XL U1987 ( .A ( n1346_CDR1 ) , .B ( n1345_CDR1 ) , .C ( n1344_CDR1 ) , 
    .Y ( n1347_CDR1 ) ) ;
NOR2XL U1988 ( .A ( HFSNET_162 ) , .B ( temp_acc[21] ) , .Y ( n1508 ) ) ;
NOR2XL U1989 ( .A ( n1524 ) , .B ( n1508 ) , .Y ( n1569 ) ) ;
AOI22XL U1990 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][22] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][22] ) , 
    .Y ( n1356_CDR2 ) ) ;
AOI22XL U1991 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][22] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][22] ) , .Y ( n1355_CDR1 ) ) ;
XOR2X1 ctmTdsLR_1_1989 ( .A ( tmp_net244 ) , .B ( tmp_net422 ) , 
    .Y ( n1874 ) ) ;
AOI22XL U1993 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][22] ) , 
    .B0 ( n1660 ) , .B1 ( \shadow_weights[3][22] ) , .Y ( n1357_CDR2 ) ) ;
AOI22X2 U1994 ( .A0 ( n1668 ) , .A1 ( \shadow_weights[10][22] ) , 
    .B0 ( n1669 ) , .B1 ( \shadow_weights[8][22] ) , .Y ( n1360_CDR2 ) ) ;
AOI22X1 U1995 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][22] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][22] ) , .Y ( n1359_CDR1 ) ) ;
AOI22XL U1996 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][22] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][22] ) , .Y ( n1358_CDR2 ) ) ;
AOI22XL ctmTdsLR_2_904 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][23] ) , 
    .B0 ( \shadow_weights[19][23] ) , .B1 ( n1672 ) , .Y ( tmp_net169 ) ) ;
OR2XL U1998 ( .A ( HFSNET_165 ) , .B ( temp_acc[22] ) , .Y ( n1572 ) ) ;
NAND2XL U1999 ( .A ( n1569 ) , .B ( n1572 ) , .Y ( n1394 ) ) ;
NOR2XL U2000 ( .A ( n1503 ) , .B ( n1394 ) , .Y ( n1457 ) ) ;
NAND2XL ctmTdsLR_1_961 ( .A ( n1568 ) , .B ( n1572 ) , .Y ( tmp_net207 ) ) ;
OAI211XL ctmTdsLR_2_962 ( .A0 ( n1504 ) , .A1 ( n1394 ) , .B0 ( tmp_net207 ) , 
    .C0 ( n1571 ) , .Y ( n1456 ) ) ;
NAND2XL U2003 ( .A ( HFSNET_167 ) , .B ( temp_acc[16] ) , .Y ( n1447 ) ) ;
NAND2XL U2004 ( .A ( HFSNET_160 ) , .B ( temp_acc[18] ) , .Y ( n1514 ) ) ;
OAI21XL U2005 ( .A0 ( n1517 ) , .A1 ( n1514 ) , .B0 ( n1518 ) , .Y ( n1387 ) ) ;
AOI21XL U2006 ( .A0 ( n1388 ) , .A1 ( n1498 ) , .B0 ( n1387 ) , .Y ( n1504 ) ) ;
NAND2XL U2007 ( .A ( HFSNET_154 ) , .B ( temp_acc[20] ) , .Y ( n1525 ) ) ;
NAND3XL ctmTdsLR_3_905 ( .A ( n1374_CDR1 ) , .B ( tmp_net168 ) , 
    .C ( tmp_net169 ) , .Y ( HFSNET_88 ) ) ;
OAI2BB1XL ctmTdsLR_1_963 ( .A0N ( n1002 ) , .A1N ( n1087 ) , .B0 ( n1053 ) , 
    .Y ( tmp_net208 ) ) ;
NAND2XL U2010 ( .A ( n315 ) , .B ( n729 ) , .Y ( N1754 ) ) ;
INVXL U2013 ( .A ( n1442 ) , .Y ( n1489 ) ) ;
NAND2XL U2014 ( .A ( n1444 ) , .B ( n1443 ) , .Y ( n1445 ) ) ;
AOI22X1 U2015 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][25] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][25] ) , .Y ( n1471_CDR1 ) ) ;
AOI22XL U2016 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][25] ) , 
    .B0 ( n1669 ) , .B1 ( \shadow_weights[8][25] ) , .Y ( n1470_CDR1 ) ) ;
OAI21XL U2017 ( .A0 ( n1489 ) , .A1 ( n1488 ) , .B0 ( n1487 ) , .Y ( n1560 ) ) ;
NAND2XL U2018 ( .A ( n1559 ) , .B ( n1557 ) , .Y ( n1491 ) ) ;
NAND2XL U2019 ( .A ( n1551 ) , .B ( n1549 ) , .Y ( n1496 ) ) ;
AOI21XL U2020 ( .A0 ( HFSNET_293 ) , .A1 ( n1499 ) , .B0 ( n1498 ) , 
    .Y ( n1516 ) ) ;
AOI21XL U2021 ( .A0 ( HFSNET_293 ) , .A1 ( n1506 ) , .B0 ( n1505 ) , 
    .Y ( n1523 ) ) ;
OAI21XL U2022 ( .A0 ( n1523 ) , .A1 ( n1524 ) , .B0 ( n1525 ) , .Y ( n1512 ) ) ;
OAI21XL U2023 ( .A0 ( n1516 ) , .A1 ( n1515 ) , .B0 ( n1514 ) , .Y ( n1521 ) ) ;
INVXL U2024 ( .A ( n1523 ) , .Y ( n1570 ) ) ;
OAI21XL U2025 ( .A0 ( n1531 ) , .A1 ( n1530 ) , .B0 ( n1529 ) , .Y ( n1587 ) ) ;
NOR2BX1 ctmTdsLR_2_1990 ( .AN ( n151 ) , .B ( n150 ) , .Y ( tmp_net422 ) ) ;
AOI22XL U2027 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][26] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][26] ) , .Y ( n1535_CDR2 ) ) ;
NOR2XL U2028 ( .A ( n2200 ) , .B ( accumulator[33] ) , .Y ( n1577 ) ) ;
XOR2X1 U2031 ( .A ( n1578 ) , .B ( n1554 ) , .Y ( n1556 ) ) ;
OAI21XL U2034 ( .A0 ( n1578 ) , .A1 ( n1577 ) , .B0 ( n1576 ) , .Y ( n1582 ) ) ;
NAND2XL ctmTdsLR_1_1991 ( .A ( tmp_net425 ) , .B ( HFSNET_347 ) , 
    .Y ( HFSNET_69 ) ) ;
NAND2XL U2039 ( .A ( n1583 ) , .B ( HFSNET_347 ) , .Y ( n929 ) ) ;
AOI21XL U2040 ( .A0 ( n1587 ) , .A1 ( n1586 ) , .B0 ( n1585 ) , .Y ( n1608 ) ) ;
AOI22XL U2041 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][27] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][27] ) , .Y ( n1589_CDR1 ) ) ;
AOI22XL U2042 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][27] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][27] ) , 
    .Y ( n1588_CDR1 ) ) ;
NAND2XL U2043 ( .A ( n1589_CDR1 ) , .B ( n1588_CDR1 ) , .Y ( n1596_CDR1 ) ) ;
AOI22XL U2044 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][27] ) , 
    .B0 ( n1662 ) , .B1 ( \shadow_weights[9][27] ) , .Y ( n1590_CDR2 ) ) ;
AOI22XL U2045 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][27] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][27] ) , .Y ( n1593_CDR2 ) ) ;
AOI22XL U2046 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][27] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][27] ) , .Y ( n1592_CDR1 ) ) ;
AOI22XL U2047 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][27] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][27] ) , .Y ( n1591_CDR1 ) ) ;
NAND3XL U2048 ( .A ( n1593_CDR2 ) , .B ( n1592_CDR1 ) , .C ( n1591_CDR1 ) , 
    .Y ( n1594_CDR2 ) ) ;
AOI21XL ctmTdsLR_1_2036 ( .A0 ( n1744 ) , .A1 ( n1743 ) , .B0 ( tmp_net448 ) , 
    .Y ( n1748 ) ) ;
OAI21XL U2050 ( .A0 ( n1608 ) , .A1 ( n1607 ) , .B0 ( n1606 ) , .Y ( n1633 ) ) ;
AOI22XL U2051 ( .A0 ( n1660 ) , .A1 ( \shadow_weights[3][28] ) , 
    .B0 ( gre_a_INV_6238_58 ) , .B1 ( \shadow_weights[1][28] ) , 
    .Y ( n1618_CDR1 ) ) ;
AOI22XL U2052 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( \shadow_weights[4][28] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][28] ) , .Y ( n1610_CDR1 ) ) ;
AOI22XL U2053 ( .A0 ( gre_a_INV_5313_58 ) , .A1 ( \shadow_weights[12][28] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][28] ) , .Y ( n1609_CDR1 ) ) ;
NAND2XL U2054 ( .A ( n1610_CDR1 ) , .B ( n1609_CDR1 ) , .Y ( n1617_CDR1 ) ) ;
AOI22XL U2055 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][28] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][28] ) , 
    .Y ( n1611_CDR1 ) ) ;
AOI22XL U2056 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][28] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][28] ) , .Y ( n1614_CDR2 ) ) ;
AOI22XL U2057 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][28] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][28] ) , .Y ( n1613_CDR1 ) ) ;
AOI22XL U2058 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][28] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][28] ) , .Y ( n1612_CDR2 ) ) ;
NAND3XL U2059 ( .A ( n1614_CDR2 ) , .B ( n1613_CDR1 ) , .C ( n1612_CDR2 ) , 
    .Y ( n1615_CDR2 ) ) ;
NAND2XL ctmTdsLR_3_2048 ( .A ( n443 ) , .B ( n425 ) , .Y ( tmp_net452 ) ) ;
AOI31XL U2061 ( .A0 ( n1629 ) , .A1 ( n1628 ) , .A2 ( n1627 ) , 
    .B0 ( n2133 ) , .Y ( n1656 ) ) ;
INVXL U2062 ( .A ( n1656 ) , .Y ( N1602 ) ) ;
BUFX8 ZCTSBUF_255_1355 ( .A ( net1686 ) , .Y ( ZCTSNET_402 ) ) ;
AOI22X1 U2064 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( \shadow_weights[1][29] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( \shadow_weights[11][29] ) , 
    .Y ( n1644_CDR2 ) ) ;
AOI22XL U2065 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][29] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][29] ) , .Y ( n1635_CDR2 ) ) ;
AOI22XL U2066 ( .A0 ( n1660 ) , .A1 ( \shadow_weights[3][29] ) , 
    .B0 ( gre_a_INV_8759_58 ) , .B1 ( \shadow_weights[4][29] ) , 
    .Y ( n1634_CDR1 ) ) ;
NAND4XL ctmTdsLR_1_1852 ( .A ( tmp_net69 ) , .B ( tmp_net71 ) , 
    .C ( tmp_net72 ) , .D ( tmp_net70 ) , .Y ( tmp_net340 ) ) ;
AOI22XL U2068 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][29] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][29] ) , 
    .Y ( n1636_CDR2 ) ) ;
OAI21XL ctmTdsLR_2_1992 ( .A0 ( n695 ) , .A1 ( tmp_net423 ) , 
    .B0 ( tmp_net424 ) , .Y ( tmp_net425 ) ) ;
AOI22XL U2070 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][29] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][29] ) , .Y ( n1640_CDR1 ) ) ;
BUFX12 ZCTSBUF_255_1356 ( .A ( net1691 ) , .Y ( ZCTSNET_403 ) ) ;
BUFX12 ZCTSBUF_255_1357 ( .A ( net1696 ) , .Y ( ZCTSNET_404 ) ) ;
AOI222XL ctmTdsLR_2_1713 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][15] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][15] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][15] ) , .Y ( tmp_net243 ) ) ;
BUFX16 ZCTSBUF_255_1359 ( .A ( net1706 ) , .Y ( ZCTSNET_406 ) ) ;
OR4X1 ctmTdsLR_1_1718 ( .A ( tmp_net248 ) , .B ( tmp_net249 ) , 
    .C ( n1244_CDR2 ) , .D ( n1245_CDR2 ) , .Y ( HFSNET_167 ) ) ;
NAND2XL ctmTdsLR_4_2019 ( .A ( tmp_net215 ) , .B ( n1439 ) , 
    .Y ( tmp_net437 ) ) ;
BUFX1 ZCTSBUF_675_1361 ( .A ( clk ) , .Y ( ZCTSNET_408 ) ) ;
NAND3XL U2079 ( .A ( n640 ) , .B ( n315 ) , .C ( n1655 ) , .Y ( N1488 ) ) ;
NOR2XL U2080 ( .A ( n1659 ) , .B ( n2161 ) , .Y ( n1985 ) ) ;
NOR2XL U2081 ( .A ( HFSNET_348 ) , .B ( n1985 ) , .Y ( n1697 ) ) ;
AOI22XL U2083 ( .A0 ( n1660 ) , .A1 ( protected_sar_code[3] ) , 
    .B0 ( gre_a_INV_6610_58 ) , .B1 ( protected_sar_code[11] ) , 
    .Y ( n1665_CDR2 ) ) ;
AOI22XL U2084 ( .A0 ( gre_a_INV_6238_58 ) , .A1 ( protected_sar_code[1] ) , 
    .B0 ( n1662 ) , .B1 ( protected_sar_code[9] ) , .Y ( n1664_CDR2 ) ) ;
OAI211XL U2085 ( .A0 ( n1210 ) , .A1 ( n2180 ) , .B0 ( n1665_CDR2 ) , 
    .C0 ( n1664_CDR2 ) , .Y ( n1685_CDR2 ) ) ;
AOI22XL U2086 ( .A0 ( n1686 ) , .A1 ( protected_sar_code[6] ) , 
    .B0 ( n1319 ) , .B1 ( protected_sar_code[13] ) , .Y ( n1676_CDR2 ) ) ;
AOI22XL U2087 ( .A0 ( ZBUF_20020_1 ) , .A1 ( protected_sar_code[0] ) , 
    .B0 ( n1672 ) , .B1 ( protected_sar_code[19] ) , .Y ( n1674_CDR2 ) ) ;
AOI22XL U2088 ( .A0 ( n1677 ) , .A1 ( protected_sar_code[5] ) , 
    .B0 ( n1679 ) , .B1 ( protected_sar_code[14] ) , .Y ( n1682_CDR2 ) ) ;
AOI22XL U2089 ( .A0 ( gre_a_INV_8759_58 ) , .A1 ( protected_sar_code[4] ) , 
    .B0 ( n1687 ) , .B1 ( protected_sar_code[2] ) , .Y ( n1681_CDR2 ) ) ;
NOR3XL U2090 ( .A ( n1685_CDR2 ) , .B ( n1684_CDR2 ) , .C ( n1683_CDR2 ) , 
    .Y ( n1692_CDR2 ) ) ;
AOI21XL U2091 ( .A0 ( n1697 ) , .A1 ( n1694 ) , .B0 ( n1696 ) , .Y ( n1695 ) ) ;
INVXL U2092 ( .A ( n1695 ) , .Y ( n2328 ) ) ;
OAI21XL U2095 ( .A0 ( gre_a_INV_6625_58 ) , .A1 ( n1701 ) , .B0 ( n1875 ) , 
    .Y ( n969 ) ) ;
NAND2XL ctmTdsLR_4_1994 ( .A ( n695 ) , .B ( tmp_net423 ) , 
    .Y ( tmp_net424 ) ) ;
OAI21XL U2097 ( .A0 ( n1711 ) , .A1 ( HFSNET_346 ) , .B0 ( n1710 ) , 
    .Y ( n896 ) ) ;
OAI21XL U2098 ( .A0 ( n1719 ) , .A1 ( HFSNET_346 ) , .B0 ( n1718 ) , 
    .Y ( n897 ) ) ;
OAI21XL U2099 ( .A0 ( n1728 ) , .A1 ( HFSNET_346 ) , .B0 ( n1727 ) , 
    .Y ( n898 ) ) ;
INVXL U2100 ( .A ( n1729 ) , .Y ( n1744 ) ) ;
OAI21XL U2101 ( .A0 ( n1744 ) , .A1 ( n1740 ) , .B0 ( n1741 ) , .Y ( n1734 ) ) ;
OAI21XL U2102 ( .A0 ( n1739 ) , .A1 ( HFSNET_346 ) , .B0 ( n1738 ) , 
    .Y ( n899 ) ) ;
OAI21XL U2103 ( .A0 ( n1748 ) , .A1 ( HFSNET_346 ) , .B0 ( n1747 ) , 
    .Y ( n900 ) ) ;
INVXL U2104 ( .A ( n1749 ) , .Y ( n1774 ) ) ;
OAI21XL U2105 ( .A0 ( n1759 ) , .A1 ( HFSNET_346 ) , .B0 ( n1758 ) , 
    .Y ( n901 ) ) ;
OAI21XL U2106 ( .A0 ( n1770 ) , .A1 ( HFSNET_346 ) , .B0 ( n1769 ) , 
    .Y ( n902 ) ) ;
OAI21XL U2107 ( .A0 ( n1778 ) , .A1 ( HFSNET_346 ) , .B0 ( n1777 ) , 
    .Y ( n903 ) ) ;
INVXL U2108 ( .A ( n1779 ) , .Y ( n1852 ) ) ;
INVXL U2109 ( .A ( n1807 ) , .Y ( n1821 ) ) ;
OAI21XL U2110 ( .A0 ( n1796 ) , .A1 ( HFSNET_346 ) , .B0 ( n1795 ) , 
    .Y ( n904 ) ) ;
OAI21XL U2111 ( .A0 ( n1804 ) , .A1 ( HFSNET_346 ) , .B0 ( n1803 ) , 
    .Y ( n905 ) ) ;
OAI21XL U2112 ( .A0 ( n1817 ) , .A1 ( HFSNET_346 ) , .B0 ( n1816 ) , 
    .Y ( n906 ) ) ;
OAI21XL U2113 ( .A0 ( n1826 ) , .A1 ( HFSNET_346 ) , .B0 ( n1825 ) , 
    .Y ( n907 ) ) ;
OAI21X1 U2115 ( .A0 ( n1838 ) , .A1 ( HFSNET_346 ) , .B0 ( n1837 ) , 
    .Y ( n908 ) ) ;
OAI21XL U2116 ( .A0 ( n1852 ) , .A1 ( n1848 ) , .B0 ( n1849 ) , .Y ( n1843 ) ) ;
OAI21X1 U2117 ( .A0 ( n1847 ) , .A1 ( HFSNET_346 ) , .B0 ( n1846 ) , 
    .Y ( n909 ) ) ;
OAI21X1 U2118 ( .A0 ( n1856 ) , .A1 ( HFSNET_346 ) , .B0 ( n1855 ) , 
    .Y ( n910 ) ) ;
INVXL U2119 ( .A ( n1857 ) , .Y ( n1893 ) ) ;
AOI21XL U2120 ( .A0 ( n1893 ) , .A1 ( n1859 ) , .B0 ( n1858 ) , .Y ( n1873 ) ) ;
OAI21XL U2121 ( .A0 ( n1873 ) , .A1 ( n1869 ) , .B0 ( n1870 ) , .Y ( n1864 ) ) ;
OAI21XL U2122 ( .A0 ( n1868 ) , .A1 ( HFSNET_346 ) , .B0 ( n1867 ) , 
    .Y ( n911 ) ) ;
OAI21X1 U2123 ( .A0 ( n1878 ) , .A1 ( HFSNET_346 ) , .B0 ( n1877 ) , 
    .Y ( n912 ) ) ;
OAI21X1 U2124 ( .A0 ( n1889 ) , .A1 ( HFSNET_346 ) , .B0 ( n1888 ) , 
    .Y ( n913 ) ) ;
NOR3X2 ctmTdsLR_1_1995 ( .A ( n1124 ) , .B ( n1123_CDR2 ) , 
    .C ( tmp_net426 ) , .Y ( n1129_CDR1 ) ) ;
OAI21XL U2126 ( .A0 ( n1912 ) , .A1 ( n1908 ) , .B0 ( n1909 ) , .Y ( n1903 ) ) ;
OAI21X1 U2127 ( .A0 ( n1907 ) , .A1 ( HFSNET_346 ) , .B0 ( n1906 ) , 
    .Y ( n915 ) ) ;
OAI21XL U2128 ( .A0 ( n1916 ) , .A1 ( HFSNET_346 ) , .B0 ( n1915 ) , 
    .Y ( n916 ) ) ;
NAND2XL U2129 ( .A ( n1920 ) , .B ( n1919 ) , .Y ( n1921 ) ) ;
OAI21X1 U2130 ( .A0 ( n1926 ) , .A1 ( HFSNET_346 ) , .B0 ( n1925 ) , 
    .Y ( n917 ) ) ;
NAND2XL U2131 ( .A ( n1928 ) , .B ( n1927 ) , .Y ( n1929 ) ) ;
NOR2XL U2132 ( .A ( n1931 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1932 ) ) ;
OAI21XL U2133 ( .A0 ( n1934 ) , .A1 ( HFSNET_346 ) , .B0 ( n1933 ) , 
    .Y ( n918 ) ) ;
NAND2XL U2134 ( .A ( n1936 ) , .B ( n1935 ) , .Y ( n1937 ) ) ;
NOR2XL U2135 ( .A ( n1939 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1940 ) ) ;
OAI21XL U2136 ( .A0 ( n1943 ) , .A1 ( HFSNET_346 ) , .B0 ( n1942 ) , 
    .Y ( n919 ) ) ;
NOR2XL U2139 ( .A ( n1949 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1950 ) ) ;
OAI21XL U2140 ( .A0 ( n1952 ) , .A1 ( HFSNET_346 ) , .B0 ( n1951 ) , 
    .Y ( n920 ) ) ;
NAND2XL U2141 ( .A ( n1954 ) , .B ( n1953 ) , .Y ( n1956 ) ) ;
NOR2XL U2142 ( .A ( n1957 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1958 ) ) ;
OAI21XL U2143 ( .A0 ( n1960 ) , .A1 ( HFSNET_346 ) , .B0 ( n1959 ) , 
    .Y ( n921 ) ) ;
XOR2XL U2146 ( .A ( n1964 ) , .B ( n1969 ) , .Y ( n1968 ) ) ;
NOR2XL U2147 ( .A ( n1965 ) , .B ( gre_a_INV_2586_58 ) , .Y ( n1966 ) ) ;
OAI21XL U2148 ( .A0 ( n1968 ) , .A1 ( HFSNET_346 ) , .B0 ( n1967 ) , 
    .Y ( n922 ) ) ;
NOR2XL U2151 ( .A ( gre_a_INV_2586_58 ) , .B ( n1971 ) , .Y ( n1973 ) ) ;
INVXL U2154 ( .A ( n1978 ) , .Y ( n1981 ) ) ;
NOR2XL U2155 ( .A ( n1979 ) , .B ( n322 ) , .Y ( n1980 ) ) ;
OAI21XL U2156 ( .A0 ( n1981 ) , .A1 ( avg_cnt[4] ) , .B0 ( n1980 ) , 
    .Y ( n963 ) ) ;
AOI21XL U2157 ( .A0 ( wait_cnt[2] ) , .A1 ( n1984 ) , .B0 ( n1982 ) , 
    .Y ( n1983 ) ) ;
OAI21XL U2158 ( .A0 ( n1984 ) , .A1 ( wait_cnt[2] ) , .B0 ( n1983 ) , 
    .Y ( n925 ) ) ;
OAI21X1 U2159 ( .A0 ( n2158 ) , .A1 ( n729 ) , .B0 ( n315 ) , .Y ( N1786 ) ) ;
OAI21XL U2160 ( .A0 ( n2179 ) , .A1 ( n729 ) , .B0 ( n315 ) , .Y ( N1787 ) ) ;
OAI21XL U2161 ( .A0 ( n2068 ) , .A1 ( n1989 ) , .B0 ( n315 ) , .Y ( N1723 ) ) ;
AOI21XL U2162 ( .A0 ( n65 ) , .A1 ( n1987 ) , .B0 ( n815 ) , .Y ( n1986 ) ) ;
OAI21XL U2163 ( .A0 ( n65 ) , .A1 ( n1987 ) , .B0 ( n1986 ) , .Y ( n827 ) ) ;
NAND3XL U2165 ( .A ( n2033 ) , .B ( n1993 ) , .C ( n2158 ) , .Y ( n2021 ) ) ;
INVXL U2167 ( .A ( n2073 ) , .Y ( n2005 ) ) ;
NAND2XL U2168 ( .A ( n2005 ) , .B ( n1996 ) , .Y ( n1997 ) ) ;
NAND3XL U2169 ( .A ( n1996 ) , .B ( n2163 ) , .C ( target_bit[2] ) , 
    .Y ( n1998 ) ) ;
CLKBUFX3 ZBUF_2_inst_2105 ( .A ( tmp_net49 ) , .Y ( ZBUF_2_31 ) ) ;
NAND2XL U2171 ( .A ( n2005 ) , .B ( n2009 ) , .Y ( n2013 ) ) ;
NAND2XL U2172 ( .A ( n2009 ) , .B ( n2006 ) , .Y ( n2014 ) ) ;
INVXL U2173 ( .A ( n2033 ) , .Y ( n2025 ) ) ;
AOI2BB1X1 U2174 ( .A0N ( n2031 ) , .A1N ( n2179 ) , .B0 ( n2047 ) , 
    .Y ( n2041 ) ) ;
NAND2XL U2175 ( .A ( n2073 ) , .B ( n2041 ) , .Y ( n2044 ) ) ;
AOI22XL U2176 ( .A0 ( n2190 ) , .A1 ( n2044 ) , .B0 ( n2186 ) , 
    .B1 ( n2058 ) , .Y ( n2040_CDR1 ) ) ;
NAND2XL U2177 ( .A ( n2022 ) , .B ( n2021 ) , .Y ( n2051 ) ) ;
AOI22XL U2178 ( .A0 ( n2166 ) , .A1 ( n57 ) , .B0 ( n2050 ) , .B1 ( n2164 ) , 
    .Y ( n2023_CDR2 ) ) ;
OAI21XL U2179 ( .A0 ( n2053 ) , .A1 ( protected_sar_code[13] ) , 
    .B0 ( n2023_CDR2 ) , .Y ( n2028_CDR2 ) ) ;
INVXL U2180 ( .A ( n2050 ) , .Y ( n2029 ) ) ;
OAI21XL U2181 ( .A0 ( ZBUF_4201_28 ) , .A1 ( n2025 ) , .B0 ( n2029 ) , 
    .Y ( n2055 ) ) ;
AOI22XL U2182 ( .A0 ( n2056 ) , .A1 ( n2184 ) , .B0 ( n2189 ) , 
    .B1 ( n2051 ) , .Y ( n2026_CDR2 ) ) ;
OAI2BB1XL U2183 ( .A0N ( n2187 ) , .A1N ( n2054 ) , .B0 ( n2026_CDR2 ) , 
    .Y ( n2027_CDR2 ) ) ;
AOI211XL U2184 ( .A0 ( n2057 ) , .A1 ( n2167 ) , .B0 ( n2028_CDR2 ) , 
    .C0 ( n2027_CDR2 ) , .Y ( n2039_CDR2 ) ) ;
NAND2XL U2185 ( .A ( ZBUF_4201_28 ) , .B ( n2029 ) , .Y ( n2057 ) ) ;
NAND2XL U2186 ( .A ( n2049 ) , .B ( n2031 ) , .Y ( n2058 ) ) ;
AOI22XL U2187 ( .A0 ( n2165 ) , .A1 ( n2045 ) , .B0 ( target_bit[4] ) , 
    .B1 ( n2182 ) , .Y ( n2038_CDR2 ) ) ;
NOR2XL U2188 ( .A ( n2032 ) , .B ( n2047 ) , .Y ( n2042 ) ) ;
OAI22XL U2189 ( .A0 ( protected_sar_code[6] ) , .A1 ( n2042 ) , 
    .B0 ( protected_sar_code[5] ) , .B1 ( n2041 ) , .Y ( n2036 ) ) ;
AOI21XL U2190 ( .A0 ( n2034 ) , .A1 ( n2033 ) , .B0 ( n2057 ) , .Y ( n2046 ) ) ;
OAI22XL U2191 ( .A0 ( n2049 ) , .A1 ( protected_sar_code[3] ) , 
    .B0 ( protected_sar_code[8] ) , .B1 ( n2046 ) , .Y ( n2035 ) ) ;
AOI211XL U2192 ( .A0 ( n2047 ) , .A1 ( n2180 ) , .B0 ( n2036 ) , 
    .C0 ( n2035 ) , .Y ( n2037_CDR1 ) ) ;
NAND4XL U2193 ( .A ( n2037_CDR1 ) , .B ( n2039_CDR2 ) , .C ( n2040_CDR1 ) , 
    .D ( n2038_CDR2 ) , .Y ( n2070 ) ) ;
OAI22XL U2194 ( .A0 ( n2168 ) , .A1 ( n2042 ) , .B0 ( n2191 ) , 
    .B1 ( n2041 ) , .Y ( n2043 ) ) ;
INVXL U2195 ( .A ( n2043 ) , .Y ( n2067 ) ) ;
AOI22XL U2196 ( .A0 ( protected_sar_code[7] ) , .A1 ( n2047 ) , 
    .B0 ( protected_sar_code[4] ) , .B1 ( n2044 ) , .Y ( n2066_CDR2 ) ) ;
NAND2XL ctmTdsLR_3_1720 ( .A ( ZBUF_20020_1 ) , 
    .B ( \shadow_weights[0][16] ) , .Y ( tmp_net246 ) ) ;
BUFX16 ZCTSBUF_6604_1367 ( .A ( ZCTSNET_413 ) , .Y ( ZCTSNET_412 ) ) ;
AOI22XL U2199 ( .A0 ( protected_sar_code[2] ) , .A1 ( n2045 ) , 
    .B0 ( target_bit[4] ) , .B1 ( protected_sar_code[15] ) , 
    .Y ( n2052_CDR2 ) ) ;
OAI21XL U2200 ( .A0 ( n2053 ) , .A1 ( n2188 ) , .B0 ( n2052_CDR2 ) , 
    .Y ( n2063_CDR2 ) ) ;
AOI22XL U2201 ( .A0 ( protected_sar_code[16] ) , .A1 ( n2051 ) , 
    .B0 ( protected_sar_code[10] ) , .B1 ( n2055 ) , .Y ( n2061_CDR1 ) ) ;
AOI22XL U2202 ( .A0 ( protected_sar_code[12] ) , .A1 ( n2054 ) , 
    .B0 ( protected_sar_code[14] ) , .B1 ( n2056 ) , .Y ( n2060_CDR1 ) ) ;
AOI22XL U2203 ( .A0 ( protected_sar_code[9] ) , .A1 ( n2057 ) , 
    .B0 ( protected_sar_code[11] ) , .B1 ( n2050 ) , .Y ( n2059_CDR2 ) ) ;
NAND3XL U2204 ( .A ( n2061_CDR1 ) , .B ( n2060_CDR1 ) , .C ( n2059_CDR2 ) , 
    .Y ( n2062_CDR2 ) ) ;
NOR3XL U2205 ( .A ( n2064_CDR2 ) , .B ( n2063_CDR2 ) , .C ( n2062_CDR2 ) , 
    .Y ( n2065_CDR2 ) ) ;
OAI21XL U2206 ( .A0 ( overrange_acc ) , .A1 ( n2071 ) , .B0 ( n968 ) , 
    .Y ( n826 ) ) ;
OAI211XL U2207 ( .A0 ( n2179 ) , .A1 ( n2158 ) , .B0 ( n2073 ) , 
    .C0 ( n2072 ) , .Y ( n2077 ) ) ;
AOI21XL U2208 ( .A0 ( n2100 ) , .A1 ( sar_ptr[2] ) , .B0 ( n2074 ) , 
    .Y ( n2075 ) ) ;
NOR2XL U2209 ( .A ( n2079 ) , .B ( sar_ptr[4] ) , .Y ( n2099 ) ) ;
NAND3XL U2210 ( .A ( n2099 ) , .B ( n1 ) , .C ( n2197 ) , .Y ( n2086 ) ) ;
OAI21XL U2211 ( .A0 ( protected_sar_code[0] ) , .A1 ( n2081 ) , 
    .B0 ( n2080 ) , .Y ( n773 ) ) ;
NOR2XL U2212 ( .A ( sar_ptr[1] ) , .B ( n2199 ) , .Y ( n2115 ) ) ;
OAI21XL U2213 ( .A0 ( protected_sar_code[1] ) , .A1 ( n2083 ) , 
    .B0 ( n2082 ) , .Y ( n772 ) ) ;
OAI21XL U2214 ( .A0 ( protected_sar_code[2] ) , .A1 ( n2085 ) , 
    .B0 ( n2084 ) , .Y ( n771 ) ) ;
OAI21XL U2215 ( .A0 ( protected_sar_code[3] ) , .A1 ( n2088 ) , 
    .B0 ( n2087 ) , .Y ( n770 ) ) ;
NOR2XL U2216 ( .A ( n2110 ) , .B ( sar_ptr[3] ) , .Y ( n2093 ) ) ;
OAI21XL U2217 ( .A0 ( n2118 ) , .A1 ( n2090 ) , .B0 ( n2089 ) , .Y ( n769 ) ) ;
OAI21XL U2218 ( .A0 ( n2092 ) , .A1 ( n2118 ) , .B0 ( n2091 ) , .Y ( n768 ) ) ;
OAI21XL U2219 ( .A0 ( protected_sar_code[6] ) , .A1 ( n2095 ) , 
    .B0 ( n2094 ) , .Y ( n767 ) ) ;
OAI21XL U2220 ( .A0 ( protected_sar_code[7] ) , .A1 ( n2098 ) , 
    .B0 ( n2097 ) , .Y ( n766 ) ) ;
NAND3XL U2221 ( .A ( sar_ptr[3] ) , .B ( n2099 ) , .C ( n2197 ) , 
    .Y ( n2107 ) ) ;
OAI21XL U2222 ( .A0 ( protected_sar_code[8] ) , .A1 ( n2102 ) , 
    .B0 ( n2101 ) , .Y ( n765 ) ) ;
OAI21XL U2223 ( .A0 ( protected_sar_code[9] ) , .A1 ( n2104 ) , 
    .B0 ( n2103 ) , .Y ( n764 ) ) ;
OAI21XL U2224 ( .A0 ( protected_sar_code[10] ) , .A1 ( n2106 ) , 
    .B0 ( n2105 ) , .Y ( n763 ) ) ;
OAI21XL U2225 ( .A0 ( protected_sar_code[11] ) , .A1 ( n2109 ) , 
    .B0 ( n2108 ) , .Y ( n762 ) ) ;
NOR2XL U2226 ( .A ( n1 ) , .B ( n2110 ) , .Y ( n2119 ) ) ;
OAI21XL U2227 ( .A0 ( n2118 ) , .A1 ( n2114 ) , .B0 ( n2113 ) , .Y ( n761 ) ) ;
OAI21XL U2228 ( .A0 ( n2118 ) , .A1 ( n2117 ) , .B0 ( n2116 ) , .Y ( n760 ) ) ;
OAI21XL U2229 ( .A0 ( protected_sar_code[14] ) , .A1 ( n2121 ) , 
    .B0 ( n2120 ) , .Y ( n759 ) ) ;
OAI21XL U2230 ( .A0 ( protected_sar_code[15] ) , .A1 ( n2124 ) , 
    .B0 ( n2123 ) , .Y ( n758 ) ) ;
OAI21XL U2231 ( .A0 ( sar_code[17] ) , .A1 ( n2127 ) , .B0 ( n2126 ) , 
    .Y ( n756 ) ) ;
OAI21XL U2232 ( .A0 ( sar_code[18] ) , .A1 ( n2130 ) , .B0 ( n2129 ) , 
    .Y ( n755 ) ) ;
AOI21XL U2233 ( .A0 ( n2136 ) , .A1 ( n2134 ) , .B0 ( n2133 ) , .Y ( n2135 ) ) ;
OAI21XL U2234 ( .A0 ( protected_sar_code[19] ) , .A1 ( n2136 ) , 
    .B0 ( n2135 ) , .Y ( n754 ) ) ;
INVXL HFSINV_11_519 ( .A ( N1842 ) , .Y ( HFSNET_261 ) ) ;
INVXL U2236 ( .A ( N1841 ) , .Y ( n2138 ) ) ;
INVXL U2237 ( .A ( N1840 ) , .Y ( n2139 ) ) ;
INVXL HFSINV_4_535 ( .A ( N1839 ) , .Y ( HFSNET_275 ) ) ;
AOI222X1 ctmTdsLR_4_1721 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][16] ) , 
    .B0 ( n1291 ) , .B1 ( \shadow_weights[13][16] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][16] ) , .Y ( tmp_net247 ) ) ;
INVXL HFSINV_164_533 ( .A ( N1837 ) , .Y ( HFSNET_273 ) ) ;
INVXL HFSINV_142_509 ( .A ( N1836 ) , .Y ( HFSNET_252 ) ) ;
OAI221XL U2242 ( .A0 ( HFSNET_252 ) , .A1 ( ZBUF_24_2 ) , .B0 ( N1836 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n711 ) ) ;
INVXL ctmTdsLR_5_1722 ( .A ( n1246_CDR2 ) , .Y ( tmp_net249 ) ) ;
OAI221XL U2244 ( .A0 ( N1835 ) , .A1 ( overrange_bits[7] ) , 
    .B0 ( HFSNET_270 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n710 ) ) ;
INVXL HFSINV_89_522 ( .A ( N1834 ) , .Y ( HFSNET_264 ) ) ;
OAI221XL U2246 ( .A0 ( N1834 ) , .A1 ( overrange_bits[8] ) , 
    .B0 ( HFSNET_264 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n709 ) ) ;
AOI222XL ctmTdsLR_2_1752 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][9] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][9] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][9] ) , .Y ( tmp_net269 ) ) ;
INVXL HFSINV_180_543 ( .A ( N1832 ) , .Y ( HFSNET_282 ) ) ;
OAI221XL U2249 ( .A0 ( N1832 ) , .A1 ( overrange_bits[10] ) , 
    .B0 ( HFSNET_282 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n707 ) ) ;
INVXL HFSINV_186_538 ( .A ( N1831 ) , .Y ( HFSNET_278 ) ) ;
OAI221XL U2251 ( .A0 ( N1831 ) , .A1 ( overrange_bits[11] ) , 
    .B0 ( HFSNET_278 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n706 ) ) ;
INVXL HFSINV_11_516 ( .A ( N1830 ) , .Y ( HFSNET_258 ) ) ;
OAI221XL U2253 ( .A0 ( N1830 ) , .A1 ( overrange_bits[12] ) , 
    .B0 ( HFSNET_258 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n705 ) ) ;
NAND2XL ctmTdsLR_2_1996 ( .A ( tmp_net275 ) , .B ( n1125_CDR2 ) , 
    .Y ( tmp_net426 ) ) ;
OAI221XL U2255 ( .A0 ( HFSNET_269 ) , .A1 ( overrange_bits[13] ) , 
    .B0 ( N1829 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n704 ) ) ;
INVXL HFSINV_86_514 ( .A ( N1828 ) , .Y ( HFSNET_256 ) ) ;
OAI221XL U2257 ( .A0 ( N1828 ) , .A1 ( overrange_bits[14] ) , 
    .B0 ( HFSNET_256 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n703 ) ) ;
INVXL HFSINV_167_525 ( .A ( ZBUF_17_0 ) , .Y ( HFSNET_266 ) ) ;
OAI221XL U2259 ( .A0 ( ZBUF_17_0 ) , .A1 ( overrange_bits[15] ) , 
    .B0 ( HFSNET_266 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n702 ) ) ;
OR3XL U1158 ( .A ( wr_idx_r[1] ) , .B ( n670 ) , .C ( n669 ) , .Y ( N1826 ) ) ;
OAI221XL U2261 ( .A0 ( HFSNET_250 ) , .A1 ( ZBUF_22_2 ) , .B0 ( N1826 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n701 ) ) ;
INVXL HFSINV_4_540 ( .A ( N1825 ) , .Y ( HFSNET_280 ) ) ;
OAI221XL U2263 ( .A0 ( N1825 ) , .A1 ( overrange_bits[17] ) , 
    .B0 ( HFSNET_280 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n700 ) ) ;
INVXL U2264 ( .A ( N1824 ) , .Y ( n2155 ) ) ;
OAI221XL U2265 ( .A0 ( N1824 ) , .A1 ( overrange_bits[18] ) , .B0 ( n2155 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n699 ) ) ;
OAI221XL U2266 ( .A0 ( N1823 ) , .A1 ( overrange_bits[19] ) , .B0 ( n823 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n697 ) ) ;
INVXL U15 ( .A ( n639 ) , .Y ( n1990 ) ) ;
INVXL U1057 ( .A ( n617 ) , .Y ( n629 ) ) ;
NAND2XL U1731 ( .A ( n1659 ) , .B ( n2161 ) , .Y ( n631 ) ) ;
OAI2BB1XL U22 ( .A0N ( n2343 ) , .A1N ( n292 ) , .B0 ( n1975 ) , .Y ( n923 ) ) ;
NAND4XL ctmTdsLR_3_1725 ( .A ( n782 ) , .B ( n785_CDR1 ) , .C ( n784 ) , 
    .D ( n783 ) , .Y ( tmp_net251 ) ) ;
AOI211XL U123 ( .A0 ( n726 ) , .A1 ( n725 ) , .B0 ( n735 ) , .C0 ( n724 ) , 
    .Y ( n819 ) ) ;
NOR2BX1 U128 ( .AN ( n1698 ) , .B ( n2161 ) , .Y ( n1701 ) ) ;
NAND2XL U129 ( .A ( calc_cnt[3] ) , .B ( n558 ) , .Y ( n1698 ) ) ;
OAI21XL U199 ( .A0 ( start_calib ) , .A1 ( n722 ) , .B0 ( n823 ) , 
    .Y ( n735 ) ) ;
OAI2BB1XL ctmTdsLR_2_1754 ( .A0N ( \shadow_weights[13][5] ) , .A1N ( n1319 ) , 
    .B0 ( tmp_net270 ) , .Y ( tmp_net271 ) ) ;
NAND2XL U256 ( .A ( temp_acc[0] ) , .B ( HFSNET_127 ) , .Y ( n738 ) ) ;
OAI21XL U259 ( .A0 ( \shadow_weights[18][0] ) , .A1 ( n1971 ) , 
    .B0 ( n1969 ) , .Y ( n2343 ) ) ;
NAND2XL U274 ( .A ( \shadow_weights[18][0] ) , .B ( n1971 ) , .Y ( n1969 ) ) ;
NOR2XL U302 ( .A ( n292 ) , .B ( sar_code[18] ) , .Y ( n2002 ) ) ;
NOR2XL U313 ( .A ( n55 ) , .B ( sar_code[17] ) , .Y ( n2003 ) ) ;
AOI22XL ctmTdsLR_3_1755 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][5] ) , 
    .B0 ( n1292 ) , .B1 ( \shadow_weights[2][5] ) , .Y ( tmp_net270 ) ) ;
NAND2XL ctmTdsLR_2_2004 ( .A ( n1108 ) , .B ( n1107 ) , .Y ( tmp_net429 ) ) ;
OAI21XL ctmTdsLR_1_2005 ( .A0 ( n1140 ) , .A1 ( n1139 ) , .B0 ( tmp_net430 ) , 
    .Y ( n1141 ) ) ;
XNOR2XL U331 ( .A ( HFSNET_73 ) , .B ( temp_acc[29] ) , .Y ( n1652 ) ) ;
NAND2BXL U333 ( .AN ( n1110 ) , .B ( n1112 ) , .Y ( n1078 ) ) ;
NAND2BXL U335 ( .AN ( n1908 ) , .B ( n1909 ) , .Y ( n1911 ) ) ;
NAND2BXL U336 ( .AN ( n1881 ) , .B ( n1882 ) , .Y ( n1884 ) ) ;
NAND2BXL U341 ( .AN ( n1788 ) , .B ( n1789 ) , .Y ( n1791 ) ) ;
NOR2XL ctmTdsLR_4_2049 ( .A ( tmp_net219 ) , .B ( tmp_net419 ) , 
    .Y ( tmp_net453 ) ) ;
NAND2XL ctmTdsLR_2_2037 ( .A ( tmp_net447 ) , .B ( n1741 ) , .Y ( n1743 ) ) ;
NAND2BXL U349 ( .AN ( n1577 ) , .B ( n1576 ) , .Y ( n1554 ) ) ;
NOR2XL ctmTdsLR_4_2076 ( .A ( n1516 ) , .B ( n1501 ) , .Y ( tmp_net467 ) ) ;
NAND2BXL U352 ( .AN ( n605 ) , .B ( n606 ) , .Y ( n608 ) ) ;
NAND2BXL U353 ( .AN ( n551 ) , .B ( n552 ) , .Y ( n554 ) ) ;
NAND2BXL U356 ( .AN ( n524 ) , .B ( n525 ) , .Y ( n527 ) ) ;
NAND2BXL U358 ( .AN ( n479 ) , .B ( n480 ) , .Y ( n482 ) ) ;
NAND2XL ctmTdsLR_2_2006 ( .A ( n1140 ) , .B ( n1139 ) , .Y ( tmp_net430 ) ) ;
OAI211XL ctmTdsLR_1_2007 ( .A0 ( tmp_net216 ) , .A1 ( tmp_net431 ) , 
    .B0 ( tmp_net432 ) , .C0 ( n1875 ) , .Y ( n2340 ) ) ;
INVXL ctmTdsLR_2_2008 ( .A ( n1652 ) , .Y ( tmp_net431 ) ) ;
NAND2BXL U362 ( .AN ( n1517 ) , .B ( n1518 ) , .Y ( n1520 ) ) ;
INVXL ctmTdsLR_3_2038 ( .A ( n1740 ) , .Y ( tmp_net447 ) ) ;
NAND2BXL U367 ( .AN ( n979 ) , .B ( n977 ) , .Y ( n801 ) ) ;
NAND2BXL U370 ( .AN ( n1530 ) , .B ( n1529 ) , .Y ( n1483 ) ) ;
NAND2BXL U371 ( .AN ( n1113 ) , .B ( n1111 ) , .Y ( n1107 ) ) ;
NAND2BXL U374 ( .AN ( n1136 ) , .B ( n1137 ) , .Y ( n1139 ) ) ;
NAND2BXL U376 ( .AN ( n1508 ) , .B ( n1509 ) , .Y ( n1511 ) ) ;
NAND2BXL U378 ( .AN ( n1561 ) , .B ( n1562 ) , .Y ( n1564 ) ) ;
NAND2BXL U380 ( .AN ( n477 ) , .B ( n476 ) , .Y ( n445 ) ) ;
NAND2BXL U381 ( .AN ( n448 ) , .B ( n447 ) , .Y ( n380 ) ) ;
NAND2XL ctmTdsLR_3_2009 ( .A ( tmp_net216 ) , .B ( tmp_net431 ) , 
    .Y ( tmp_net432 ) ) ;
AOI21XL ctmTdsLR_1_2020 ( .A0 ( n1608 ) , .A1 ( n1604 ) , .B0 ( tmp_net439 ) , 
    .Y ( n1605 ) ) ;
NAND2BXL U390 ( .AN ( n1848 ) , .B ( n1849 ) , .Y ( n1851 ) ) ;
NAND2BXL U392 ( .AN ( n1762 ) , .B ( n1763 ) , .Y ( n1765 ) ) ;
BUFX1 ZBUF_2_inst_2106 ( .A ( tmp_net40 ) , .Y ( ZBUF_2_32 ) ) ;
NAND2BXL U399 ( .AN ( n1134 ) , .B ( n1133 ) , .Y ( n1089 ) ) ;
AOI21XL ctmTdsLR_1_2077 ( .A0 ( n779 ) , .A1 ( n777 ) , .B0 ( tmp_net469 ) , 
    .Y ( n778 ) ) ;
OAI21XL ctmTdsLR_1_2050 ( .A0 ( n1587 ) , .A1 ( n1547 ) , .B0 ( tmp_net454 ) , 
    .Y ( n1548 ) ) ;
NAND2BXL U411 ( .AN ( n1961 ) , .B ( n1962 ) , .Y ( n1964 ) ) ;
NAND2BXL U412 ( .AN ( n1081 ) , .B ( n1080 ) , .Y ( n974 ) ) ;
NAND2BXL U432 ( .AN ( n805 ) , .B ( n804 ) , .Y ( n720 ) ) ;
NAND2BXL U447 ( .AN ( n643 ) , .B ( n642 ) , .Y ( n588 ) ) ;
NAND2BXL U451 ( .AN ( n562 ) , .B ( n561 ) , .Y ( n515 ) ) ;
NAND2BXL U452 ( .AN ( n354 ) , .B ( n356 ) , .Y ( n338 ) ) ;
NOR2XL ctmTdsLR_4_2039 ( .A ( n1744 ) , .B ( n1743 ) , .Y ( tmp_net448 ) ) ;
NAND2BXL U462 ( .AN ( n739 ) , .B ( n737 ) , .Y ( n690 ) ) ;
CLKBUFX2 ZBUF_2_inst_2107 ( .A ( tmp_net256 ) , .Y ( ZBUF_2_33 ) ) ;
NAND2BXL U480 ( .AN ( n540 ) , .B ( n541 ) , .Y ( n543 ) ) ;
NAND2BXL U507 ( .AN ( n502 ) , .B ( n503 ) , .Y ( n505 ) ) ;
NAND2XL ctmTdsLR_2_2021 ( .A ( tmp_net438 ) , .B ( n1606 ) , .Y ( n1604 ) ) ;
NAND2BXL U513 ( .AN ( n449 ) , .B ( n450 ) , .Y ( n452 ) ) ;
INVXL ctmTdsLR_3_2022 ( .A ( n1607 ) , .Y ( tmp_net438 ) ) ;
NAND2XL ctmTdsLR_2_2078 ( .A ( tmp_net468 ) , .B ( n978 ) , .Y ( n777 ) ) ;
NAND2BXL U534 ( .AN ( n336 ) , .B ( n335 ) , .Y ( n329 ) ) ;
NOR2XL ctmTdsLR_4_2023 ( .A ( n1608 ) , .B ( n1604 ) , .Y ( tmp_net439 ) ) ;
NAND2BXL U594 ( .AN ( n1944 ) , .B ( n1945 ) , .Y ( n1948 ) ) ;
NAND2BXL U614 ( .AN ( n460 ) , .B ( n459 ) , .Y ( n439 ) ) ;
NAND2BXL U631 ( .AN ( n1494 ) , .B ( n1493 ) , .Y ( n1147 ) ) ;
INVXL U641 ( .A ( n1898 ) , .Y ( n1912 ) ) ;
NAND2XL ctmTdsLR_1_2024 ( .A ( tmp_net442 ) , .B ( HFSNET_347 ) , 
    .Y ( HFSNET_67 ) ) ;
NAND4BX1 U873 ( .AN ( n2079 ) , .B ( sar_ptr[4] ) , .C ( n1 ) , .D ( n2197 ) , 
    .Y ( n2131 ) ) ;
AOI21XL U910 ( .A0 ( n1627 ) , .A1 ( HFSNET_117 ) , .B0 ( n2118 ) , 
    .Y ( n2079 ) ) ;
INVXL U911 ( .A ( target_bit[2] ) , .Y ( n2344 ) ) ;
AND3X1 U912 ( .A ( n2344 ) , .B ( n1993 ) , .C ( target_bit[1] ) , 
    .Y ( n55 ) ) ;
XNOR2XL U914 ( .A ( n2214 ) , .B ( n2170 ) , .Y ( n286 ) ) ;
NAND2XL ctmTdsLR_2_2051 ( .A ( n1587 ) , .B ( n1547 ) , .Y ( tmp_net454 ) ) ;
NAND2BXL U917 ( .AN ( n257 ) , .B ( n256 ) , .Y ( n255 ) ) ;
NAND2BXL U921 ( .AN ( n94 ) , .B ( n95 ) , .Y ( n97 ) ) ;
OAI21XL ctmTdsLR_2_2025 ( .A0 ( n814 ) , .A1 ( tmp_net213 ) , 
    .B0 ( tmp_net441 ) , .Y ( tmp_net442 ) ) ;
NAND2BXL U930 ( .AN ( n209 ) , .B ( n210 ) , .Y ( n212 ) ) ;
NAND2BXL U932 ( .AN ( n214 ) , .B ( n215 ) , .Y ( n217 ) ) ;
NAND2BXL U935 ( .AN ( n111 ) , .B ( n112 ) , .Y ( n114 ) ) ;
NAND2BXL U940 ( .AN ( n120 ) , .B ( n121 ) , .Y ( n123 ) ) ;
NAND2BXL U949 ( .AN ( n159 ) , .B ( n160 ) , .Y ( n162 ) ) ;
NAND2XL ctmTdsLR_4_2027 ( .A ( n814 ) , .B ( tmp_net213 ) , 
    .Y ( tmp_net441 ) ) ;
NAND2BXL U963 ( .AN ( n193 ) , .B ( n194 ) , .Y ( n196 ) ) ;
NAND2BXL U971 ( .AN ( n207 ) , .B ( n206 ) , .Y ( n202 ) ) ;
NAND2BXL U975 ( .AN ( n181 ) , .B ( n182 ) , .Y ( n184 ) ) ;
INVXL U976 ( .A ( n2345 ) , .Y ( n1971 ) ) ;
OAI21XL U980 ( .A0 ( \shadow_weights[17][0] ) , .A1 ( temp_acc[0] ) , 
    .B0 ( n172 ) , .Y ( n2345 ) ) ;
NAND2XL U981 ( .A ( \shadow_weights[17][0] ) , .B ( temp_acc[0] ) , 
    .Y ( n172 ) ) ;
NAND2BXL U983 ( .AN ( n179 ) , .B ( n178 ) , .Y ( n176 ) ) ;
NAND2BXL U985 ( .AN ( n168 ) , .B ( n169 ) , .Y ( n171 ) ) ;
OAI2BB1X1 U987 ( .A0N ( n1235 ) , .A1N ( n1164 ) , .B0 ( n1114 ) , 
    .Y ( n1435 ) ) ;
AOI21XL ctmTdsLR_1_2028 ( .A0 ( n1755 ) , .A1 ( n1754 ) , .B0 ( tmp_net443 ) , 
    .Y ( n1759 ) ) ;
NOR2XL ctmTdsLR_2_2029 ( .A ( n1755 ) , .B ( n1754 ) , .Y ( tmp_net443 ) ) ;
INVXL U995 ( .A ( n2347 ) , .Y ( n573 ) ) ;
AND2X1 U1023 ( .A ( n2022 ) , .B ( n2347 ) , .Y ( n2078 ) ) ;
OAI31X1 U1025 ( .A0 ( target_bit[3] ) , .A1 ( target_bit[2] ) , 
    .A2 ( target_bit[1] ) , .B0 ( target_bit[4] ) , .Y ( n2022 ) ) ;
NOR3BX2 U1056 ( .AN ( calc_cnt[2] ) , .B ( calc_cnt[3] ) , .C ( n1310 ) , 
    .Y ( n732 ) ) ;
NAND2XL U1059 ( .A ( calc_cnt[4] ) , .B ( n617 ) , .Y ( n1310 ) ) ;
NAND2X2 U1060 ( .A ( n638 ) , .B ( n1990 ) , .Y ( n315 ) ) ;
OAI22XL U1061 ( .A0 ( n64 ) , .A1 ( state[0] ) , .B0 ( n56 ) , .B1 ( n63 ) , 
    .Y ( n2347 ) ) ;
NOR2XL U1131 ( .A ( state[0] ) , .B ( state[1] ) , .Y ( n639 ) ) ;
INVXL U1143 ( .A ( n1991 ) , .Y ( n56 ) ) ;
NOR2XL U1152 ( .A ( n68 ) , .B ( state[3] ) , .Y ( n1991 ) ) ;
OAI2BB1XL ctmTdsLR_2_1757 ( .A0N ( \shadow_weights[3][26] ) , .A1N ( n1660 ) , 
    .B0 ( tmp_net31 ) , .Y ( tmp_net272 ) ) ;
AOI222XL ctmTdsLR_1_1758 ( .A0 ( n1282 ) , .A1 ( \shadow_weights[17][13] ) , 
    .B0 ( n1281 ) , .B1 ( \shadow_weights[19][13] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][13] ) , .Y ( tmp_net273 ) ) ;
NAND2XL ctmTdsLR_2_1759 ( .A ( n1280 ) , .B ( \shadow_weights[18][13] ) , 
    .Y ( tmp_net274 ) ) ;
AOI222XL ctmTdsLR_2_1791 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][11] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][11] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][11] ) , .Y ( tmp_net294 ) ) ;
AOI21XL ctmTdsLR_1_2040 ( .A0 ( n269 ) , .A1 ( n266 ) , .B0 ( tmp_net450 ) , 
    .Y ( n1708 ) ) ;
AOI21XL ctmTdsLR_2_1793 ( .A0 ( HFSNET_342 ) , .A1 ( \shadow_weights[7][9] ) , 
    .B0 ( tmp_net295 ) , .Y ( tmp_net296 ) ) ;
NAND3XL ctmTdsLR_3_1794 ( .A ( n1100_CDR1 ) , .B ( n1092_CDR1 ) , 
    .C ( ZBUF_2_40 ) , .Y ( tmp_net295 ) ) ;
NAND2XL ctmTdsLR_2_2041 ( .A ( tmp_net449 ) , .B ( n267 ) , .Y ( n266 ) ) ;
NAND2XL ctmTdsLR_2_1796 ( .A ( gre_a_INV_6625_58 ) , 
    .B ( \shadow_weights[15][26] ) , .Y ( tmp_net297 ) ) ;
AOI21XL ctmTdsLR_3_1797 ( .A0 ( n1687 ) , .A1 ( \shadow_weights[2][26] ) , 
    .B0 ( tmp_net299 ) , .Y ( tmp_net300 ) ) ;
OAI2BB1XL ctmTdsLR_4_1798 ( .A0N ( \shadow_weights[4][26] ) , 
    .A1N ( gre_a_INV_8759_58 ) , .B0 ( tmp_net298 ) , .Y ( tmp_net299 ) ) ;
AOI22XL ctmTdsLR_5_1799 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][26] ) , 
    .B0 ( n1686 ) , .B1 ( \shadow_weights[6][26] ) , .Y ( tmp_net298 ) ) ;
AOI22XL ctmTdsLR_6_1800 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][26] ) , 
    .B0 ( ZBUF_20020_1 ) , .B1 ( \shadow_weights[0][26] ) , 
    .Y ( tmp_net301 ) ) ;
NAND3X1 ctmTdsLR_1_1801 ( .A ( tmp_net305 ) , .B ( n1477 ) , 
    .C ( tmp_net123 ) , .Y ( HFSNET_166 ) ) ;
NOR3XL ctmTdsLR_2_1802 ( .A ( tmp_net302 ) , .B ( tmp_net303 ) , 
    .C ( tmp_net304 ) , .Y ( tmp_net305 ) ) ;
NAND3XL ctmTdsLR_3_1803 ( .A ( n1467_CDR2 ) , .B ( n1471_CDR1 ) , 
    .C ( n1476_CDR1 ) , .Y ( tmp_net302 ) ) ;
NAND4XL ctmTdsLR_4_1804 ( .A ( n1468_CDR2 ) , .B ( n1469_CDR1 ) , 
    .C ( n1470_CDR1 ) , .D ( n1472_CDR2 ) , .Y ( tmp_net303 ) ) ;
OAI2BB1XL ctmTdsLR_5_1805 ( .A0N ( \shadow_weights[7][25] ) , 
    .A1N ( HFSNET_342 ) , .B0 ( tmp_net124 ) , .Y ( tmp_net304 ) ) ;
INVXL ctmTdsLR_3_2042 ( .A ( n268 ) , .Y ( tmp_net449 ) ) ;
NOR2XL ctmTdsLR_4_2043 ( .A ( n269 ) , .B ( n266 ) , .Y ( tmp_net450 ) ) ;
OAI21XL ctmTdsLR_1_2052 ( .A0 ( n1633 ) , .A1 ( n1624 ) , .B0 ( tmp_net455 ) , 
    .Y ( n1625 ) ) ;
NAND2XL ctmTdsLR_2_2053 ( .A ( n1633 ) , .B ( n1624 ) , .Y ( tmp_net455 ) ) ;
AOI222XL ctmTdsLR_1_2054 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][15] ) , 
    .B0 ( gre_a_INV_5313_58 ) , .B1 ( \shadow_weights[12][15] ) , 
    .C0 ( n1270 ) , .C1 ( \shadow_weights[14][15] ) , .Y ( tmp_net456 ) ) ;
OAI21XL ctmTdsLR_1_2055 ( .A0 ( tmp_net220 ) , .A1 ( n1429 ) , 
    .B0 ( tmp_net458 ) , .Y ( n1431 ) ) ;
NAND2XL ctmTdsLR_2_2056 ( .A ( tmp_net457 ) , .B ( n1427 ) , .Y ( n1429 ) ) ;
INVXL ctmTdsLR_3_2057 ( .A ( n1426 ) , .Y ( tmp_net457 ) ) ;
NAND2XL ctmTdsLR_4_2058 ( .A ( tmp_net220 ) , .B ( n1429 ) , 
    .Y ( tmp_net458 ) ) ;
OAI21XL ctmTdsLR_1_2059 ( .A0 ( n1570 ) , .A1 ( n1527 ) , .B0 ( tmp_net460 ) , 
    .Y ( n1528 ) ) ;
NAND2XL ctmTdsLR_2_2060 ( .A ( tmp_net459 ) , .B ( n1525 ) , .Y ( n1527 ) ) ;
INVXL ctmTdsLR_3_2061 ( .A ( n1524 ) , .Y ( tmp_net459 ) ) ;
NAND2XL ctmTdsLR_4_2062 ( .A ( n1570 ) , .B ( n1527 ) , .Y ( tmp_net460 ) ) ;
OAI21XL ctmTdsLR_1_2063 ( .A0 ( n1734 ) , .A1 ( n1733 ) , .B0 ( tmp_net462 ) , 
    .Y ( n1739 ) ) ;
NAND2XL ctmTdsLR_2_2064 ( .A ( tmp_net461 ) , .B ( n1731 ) , .Y ( n1733 ) ) ;
INVXL ctmTdsLR_3_2065 ( .A ( n1730 ) , .Y ( tmp_net461 ) ) ;
NAND2XL ctmTdsLR_4_2066 ( .A ( n1734 ) , .B ( n1733 ) , .Y ( tmp_net462 ) ) ;
CLKBUFX2 copt_gre_mt_inst_2141 ( .A ( tmp_net352 ) , .Y ( copt_gre_net_482 ) ) ;
INVXL ctmTdsLR_3_2079 ( .A ( n976 ) , .Y ( tmp_net468 ) ) ;
NOR2XL ctmTdsLR_4_2080 ( .A ( n779 ) , .B ( n777 ) , .Y ( tmp_net469 ) ) ;
NAND4XL ctmTdsLR_1_2081 ( .A ( tmp_net246 ) , .B ( n1247 ) , 
    .C ( tmp_net470 ) , .D ( tmp_net247 ) , .Y ( tmp_net248 ) ) ;
AOI21XL ctmTdsLR_1_2084 ( .A0 ( n1724 ) , .A1 ( n1723 ) , .B0 ( tmp_net473 ) , 
    .Y ( n1728 ) ) ;
NAND2XL ctmTdsLR_2_2085 ( .A ( tmp_net472 ) , .B ( n1721 ) , .Y ( n1723 ) ) ;
INVXL ctmTdsLR_3_2086 ( .A ( n1720 ) , .Y ( tmp_net472 ) ) ;
NOR2XL ctmTdsLR_4_2087 ( .A ( n1724 ) , .B ( n1723 ) , .Y ( tmp_net473 ) ) ;
BUFX1 ZBUF_145_inst_2112 ( .A ( n2024 ) , .Y ( ZBUF_145_35 ) ) ;
BUFXL ZBUF_2_inst_2114 ( .A ( tmp_net267 ) , .Y ( ZBUF_2_36 ) ) ;
BUFXL ZBUF_2_inst_2116 ( .A ( tmp_net317 ) , .Y ( ZBUF_2_38 ) ) ;
CLKBUFX2 ZBUF_2_inst_2117 ( .A ( tmp_net296 ) , .Y ( ZBUF_2_39 ) ) ;
BUFXL ZBUF_2_inst_2118 ( .A ( tmp_net269 ) , .Y ( ZBUF_2_40 ) ) ;
CLKBUFX3 ZBUF_2_inst_2120 ( .A ( n781_CDR2 ) , .Y ( ZBUF_2_42 ) ) ;
CLKBUFX3 ZBUF_2_inst_2123 ( .A ( tmp_net294 ) , .Y ( ZBUF_2_45 ) ) ;
BUFX1 ZBUF_2_inst_2124 ( .A ( n1149_CDR1 ) , .Y ( ZBUF_2_46 ) ) ;
CLKBUFX2 ZBUF_2_inst_2127 ( .A ( tmp_net268 ) , .Y ( ZBUF_2_49 ) ) ;
BUFXL ZBUF_2_inst_2128 ( .A ( tmp_net39 ) , .Y ( ZBUF_2_50 ) ) ;
BUFXL ZBUF_2_inst_2129 ( .A ( tmp_net263 ) , .Y ( ZBUF_2_51 ) ) ;
CLKBUFX2 ZBUF_2_inst_2130 ( .A ( tmp_net456 ) , .Y ( ZBUF_2_52 ) ) ;
BUFX1 ZBUF_2_inst_2131 ( .A ( tmp_net243 ) , .Y ( ZBUF_2_53 ) ) ;
CLKBUFX3 ZBUF_2_inst_2132 ( .A ( n1091 ) , .Y ( ZBUF_2_54 ) ) ;
CLKBUFX2 copt_gre_mt_inst_2133 ( .A ( n745_CDR2 ) , .Y ( copt_gre_net_474 ) ) ;
CLKBUFX3 copt_gre_mt_inst_2134 ( .A ( HFSNET_45 ) , .Y ( copt_gre_net_475 ) ) ;
CLKBUFX3 copt_gre_mt_inst_2135 ( .A ( tmp_net50 ) , .Y ( copt_gre_net_476 ) ) ;
CLKBUFX2 copt_gre_mt_inst_2137 ( .A ( tmp_net354 ) , .Y ( copt_gre_net_478 ) ) ;
CLKBUFX2 copt_gre_mt_inst_2138 ( .A ( n991_CDR1 ) , .Y ( copt_gre_net_479 ) ) ;
CLKBUFX3 copt_gre_mt_inst_2139 ( .A ( HFSNET_170 ) , .Y ( copt_gre_net_480 ) ) ;
BUFX2 HFSBUF_32_437 ( .A ( aps_rename_2_ ) , .Y ( overrange_bits[17] ) ) ;
BUFX2 HFSBUF_17_438 ( .A ( aps_rename_1_ ) , .Y ( overrange_bits[18] ) ) ;
CLKBUFX2 HFSBUF_32_440 ( .A ( aps_rename_4_ ) , .Y ( overrange_bits[2] ) ) ;
CLKBUFX2 HFSBUF_32_441 ( .A ( aps_rename_3_ ) , .Y ( overrange_bits[7] ) ) ;
CLKBUFX2 HFSBUF_51_461 ( .A ( \shadow_weights[17][12] ) , .Y ( HFSNET_209 ) ) ;
BUFX1 HFSBUF_66_463 ( .A ( \shadow_weights[17][14] ) , .Y ( HFSNET_211 ) ) ;
BUFX1 HFSBUF_47_477 ( .A ( \shadow_weights[18][11] ) , .Y ( HFSNET_225 ) ) ;
BUFX1 HFSBUF_47_478 ( .A ( \shadow_weights[18][12] ) , .Y ( HFSNET_226 ) ) ;
BUFX1 HFSBUF_47_486 ( .A ( \shadow_weights[18][20] ) , .Y ( HFSNET_234 ) ) ;
BUFX1 HFSBUF_66_493 ( .A ( \shadow_weights[18][26] ) , .Y ( HFSNET_241 ) ) ;
BUFX1 HFSBUF_47_496 ( .A ( \shadow_weights[18][9] ) , .Y ( HFSNET_244 ) ) ;
BUFXL HFSBUF_46_498 ( .A ( n2162 ) , .Y ( HFSNET_246 ) ) ;
INVXL HFSINV_63_503 ( .A ( N1833 ) , .Y ( HFSNET_249 ) ) ;
OR3XL U1049 ( .A ( wr_idx_r[4] ) , .B ( n2160 ) , .C ( n671 ) , .Y ( N1833 ) ) ;
OR2XL U1389 ( .A ( n667 ) , .B ( n577 ) , .Y ( N1836 ) ) ;
INVX1 HFSINV_130_528 ( .A ( N1829 ) , .Y ( HFSNET_269 ) ) ;
OR2XL U1723 ( .A ( n598 ) , .B ( n599 ) , .Y ( N1829 ) ) ;
INVXL HFSINV_190_546 ( .A ( n110 ) , .Y ( HFSNET_285 ) ) ;
BUFX1 HFSBUF_17_551 ( .A ( n2159 ) , .Y ( HFSNET_290 ) ) ;
INVXL HFSINV_4_556 ( .A ( HFSNET_297 ) , .Y ( HFSNET_295 ) ) ;
CLKINVX3 HFSINV_561_557 ( .A ( HFSNET_297 ) , .Y ( HFSNET_296 ) ) ;
INVXL HFSINV_644_558 ( .A ( n70 ) , .Y ( HFSNET_297 ) ) ;
BUFX2 HFSBUF_541_560 ( .A ( n71 ) , .Y ( HFSNET_299 ) ) ;
INVX4 HFSINV_904_562 ( .A ( calc_result_r[10] ) , .Y ( HFSNET_301 ) ) ;
INVX4 HFSINV_529_572 ( .A ( calc_result_r[0] ) , .Y ( HFSNET_311 ) ) ;
INVX4 HFSINV_603_588 ( .A ( calc_result_r[2] ) , .Y ( HFSNET_327 ) ) ;
INVX4 HFSINV_606_593 ( .A ( calc_result_r[3] ) , .Y ( HFSNET_332 ) ) ;
INVX4 HFSINV_412_597 ( .A ( calc_result_r[4] ) , .Y ( HFSNET_336 ) ) ;
CLKINVX8 HFSINV_801_600 ( .A ( calc_result_r[6] ) , .Y ( HFSNET_339 ) ) ;
CLKINVX8 HFSINV_758_602 ( .A ( calc_result_r[7] ) , .Y ( HFSNET_341 ) ) ;
endmodule


module sar_digi_paper_core ( clk , dec_clk , rst_n , start_calib , 
    calib_comp_out , calib_done , calib_done_pulse , calib_mode_en , 
    dac_p_force , dac_n_force , calib_overrange , calib_overrange_bits , 
    data_valid_i , raw_bits_i , raw_code_o , raw_code_valid_o , w_wr_en , 
    w_wr_addr , w_wr_data , srm_start , srm_decision_valid , 
    srm_decision_bit , residue_consume_i , srm_busy , srm_done , 
    srm_residue_valid , srm_ones_count , srm_total_count , 
    srm_count_shortfall , srm_stalled , srm_residue_o ) ;
input  clk ;
input  dec_clk ;
input  rst_n ;
input  start_calib ;
input  calib_comp_out ;
output calib_done ;
output calib_done_pulse ;
output calib_mode_en ;
output [19:0] dac_p_force ;
output [19:0] dac_n_force ;
output calib_overrange ;
output [19:0] calib_overrange_bits ;
input  data_valid_i ;
input  [19:0] raw_bits_i ;
output [19:0] raw_code_o ;
output raw_code_valid_o ;
output w_wr_en ;
output [4:0] w_wr_addr ;
output [29:0] w_wr_data ;
input  srm_start ;
input  srm_decision_valid ;
input  srm_decision_bit ;
input  residue_consume_i ;
output srm_busy ;
output srm_done ;
output srm_residue_valid ;
output [4:0] srm_ones_count ;
output [4:0] srm_total_count ;
output srm_count_shortfall ;
output srm_stalled ;
output [9:0] srm_residue_o ;

sar_calib_ctrl_serial_20_30_16_32_5_256_1_1 u_calib_ctrl ( 
    .clk ( ZCTSNET_133 ) , .rst_n ( HFSNET_124 ) , 
    .start_calib ( start_calib ) , .calib_done ( aps_rename_7_ ) , 
    .calib_done_pulse ( aps_rename_8_ ) , .calib_mode_en ( aps_rename_9_ ) , 
    .comp_out ( calib_comp_out ) ,
    .dac_p_force ( { aps_rename_10_ , aps_rename_11_ , aps_rename_12_ , 
        aps_rename_13_ , aps_rename_14_ , aps_rename_15_ , aps_rename_16_ , 
        aps_rename_17_ , aps_rename_18_ , aps_rename_19_ , aps_rename_20_ , 
        aps_rename_21_ , aps_rename_22_ , dac_p_force[6] , dac_p_force[5] , 
        dac_p_force[4] , dac_p_force[3] , dac_p_force[2] , dac_p_force[1] , 
        aps_rename_23_ } ) ,
    .dac_n_force ( { aps_rename_24_ , aps_rename_25_ , aps_rename_26_ , 
        aps_rename_27_ , aps_rename_28_ , aps_rename_29_ , aps_rename_30_ , 
        aps_rename_31_ , aps_rename_32_ , aps_rename_33_ , aps_rename_34_ , 
        aps_rename_35_ , aps_rename_36_ , aps_rename_37_ , aps_rename_38_ , 
        aps_rename_39_ , aps_rename_40_ , aps_rename_41_ , aps_rename_42_ , 
        aps_rename_43_ } ) ,
    .w_wr_en ( aps_rename_69_ ) ,
    .w_wr_addr ( { aps_rename_70_ , aps_rename_71_ , aps_rename_72_ , 
        aps_rename_73_ , aps_rename_74_ } ) ,
    .w_wr_data ( { aps_rename_75_ , aps_rename_76_ , aps_rename_77_ , 
        aps_rename_78_ , aps_rename_79_ , aps_rename_80_ , aps_rename_81_ , 
        aps_rename_82_ , aps_rename_83_ , aps_rename_84_ , aps_rename_85_ , 
        aps_rename_86_ , aps_rename_87_ , aps_rename_88_ , aps_rename_89_ , 
        aps_rename_90_ , aps_rename_91_ , aps_rename_92_ , aps_rename_93_ , 
        aps_rename_94_ , aps_rename_95_ , aps_rename_96_ , aps_rename_97_ , 
        aps_rename_98_ , aps_rename_99_ , aps_rename_100_ , aps_rename_101_ , 
        aps_rename_102_ , aps_rename_103_ , aps_rename_104_ } ) ,
    .calib_overrange ( aps_rename_44_ ) ,
    .overrange_bits ( { aps_rename_45_ , calib_overrange_bits[18] , 
        calib_overrange_bits[17] , aps_rename_46_ , calib_overrange_bits[15] , 
        calib_overrange_bits[14] , calib_overrange_bits[13] , 
        calib_overrange_bits[12] , calib_overrange_bits[11] , 
        calib_overrange_bits[10] , calib_overrange_bits[9] , 
        calib_overrange_bits[8] , calib_overrange_bits[7] , aps_rename_47_ , 
        calib_overrange_bits[5] , calib_overrange_bits[4] , 
        calib_overrange_bits[3] , calib_overrange_bits[2] , 
        calib_overrange_bits[1] , calib_overrange_bits[0] } ) ,
    .HFSNET_351 ( HFSNET_125 ) , .HFSNET_365 ( HFSNET_126 ) , 
    .HFSNET_371 ( HFSNET_127 ) , .HFSNET_381 ( HFSNET_128 ) , 
    .HFSNET_382 ( HFSNET_130 ) , .ZBUF_24_2 ( calib_overrange_bits[6] ) , 
    .ZBUF_22_2 ( calib_overrange_bits[16] ) , .ZCTSNET_411 ( ZCTSNET_134 ) , 
    .ZCTSNET_413 ( clk ) , .gre_a_BUF_36_0 ( gre_a_BUF_36_55 ) , 
    .gre_a_BUF_36_1 ( gre_a_BUF_36_56 ) , 
    .gre_a_BUF_36_2 ( gre_a_BUF_36_57 ) , 
    .gre_a_BUF_36_3 ( gre_a_BUF_36_58 ) ) ;
srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64 u_srm_residue ( 
    .dec_clk ( dec_clk ) , .decision_valid ( srm_decision_valid ) , 
    .decision_bit ( srm_decision_bit ) , .clk ( ZCTSNET_133 ) , 
    .rst_n ( HFSNET_124 ) , .start ( srm_start ) , 
    .residue_consume ( residue_consume_i ) , .busy ( srm_busy ) , 
    .done ( aps_rename_105_ ) , .residue_valid ( aps_rename_106_ ) ,
    .ones_count ( { aps_rename_107_ , aps_rename_108_ , aps_rename_109_ , 
        aps_rename_110_ , aps_rename_111_ } ) ,
    .total_count ( { aps_rename_112_ , aps_rename_113_ , aps_rename_114_ , 
        aps_rename_115_ , aps_rename_116_ } ) ,
    .count_shortfall ( aps_rename_117_ ) , .stalled ( aps_rename_118_ ) ,
    .residue_q ( { aps_rename_119_ , aps_rename_120_ , aps_rename_121_ , 
        aps_rename_122_ , aps_rename_123_ , aps_rename_124_ , 
        aps_rename_125_ , aps_rename_126_ , aps_rename_127_ , 
        aps_rename_128_ } ) ,
    .HFSNET_5 ( HFSNET_127 ) , .HFSNET_6 ( HFSNET_128 ) , 
    .HFSNET_7 ( HFSNET_130 ) , .HFSNET_9 ( rst_n ) ) ;
DFFSX1 raw_code_valid_o_reg ( .D ( HFSNET_113 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_125 ) , .QN ( aps_rename_68_ ) ) ;
DFFSX1 \raw_code_o_reg[19] ( .D ( n40 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_125 ) , .QN ( aps_rename_48_ ) ) ;
DFFSX1 \raw_code_o_reg[18] ( .D ( n38 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_125 ) , .QN ( aps_rename_49_ ) ) ;
DFFSX1 \raw_code_o_reg[17] ( .D ( n36 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_50_ ) ) ;
DFFSX1 \raw_code_o_reg[16] ( .D ( n34 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_51_ ) ) ;
DFFSX1 \raw_code_o_reg[15] ( .D ( n32 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_52_ ) ) ;
DFFSX1 \raw_code_o_reg[14] ( .D ( n30 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_53_ ) ) ;
DFFSX1 \raw_code_o_reg[13] ( .D ( n28 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_54_ ) ) ;
DFFSX1 \raw_code_o_reg[12] ( .D ( n26 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_55_ ) ) ;
DFFSX1 \raw_code_o_reg[11] ( .D ( n24 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_56_ ) ) ;
DFFSX1 \raw_code_o_reg[10] ( .D ( n22 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_57_ ) ) ;
DFFSX1 \raw_code_o_reg[9] ( .D ( n20 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_128 ) , .QN ( aps_rename_58_ ) ) ;
DFFSX1 \raw_code_o_reg[8] ( .D ( n18 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_128 ) , .QN ( aps_rename_59_ ) ) ;
DFFSX1 \raw_code_o_reg[7] ( .D ( n16 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_128 ) , .QN ( aps_rename_60_ ) ) ;
DFFSX1 \raw_code_o_reg[6] ( .D ( HFSNET_119 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_128 ) , .QN ( aps_rename_61_ ) ) ;
DFFSX1 \raw_code_o_reg[5] ( .D ( n12 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_124 ) , .QN ( aps_rename_62_ ) ) ;
DFFSX1 \raw_code_o_reg[4] ( .D ( HFSNET_118 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_128 ) , .QN ( aps_rename_63_ ) ) ;
DFFSX1 \raw_code_o_reg[3] ( .D ( HFSNET_117 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_128 ) , .QN ( aps_rename_64_ ) ) ;
DFFSX1 \raw_code_o_reg[2] ( .D ( HFSNET_116 ) , .CK ( ZCTSNET_133 ) , 
    .SN ( HFSNET_128 ) , .QN ( aps_rename_65_ ) ) ;
DFFSX1 \raw_code_o_reg[1] ( .D ( HFSNET_115 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_125 ) , .QN ( aps_rename_66_ ) ) ;
DFFSX1 \raw_code_o_reg[0] ( .D ( HFSNET_114 ) , .CK ( ZCTSNET_134 ) , 
    .SN ( HFSNET_126 ) , .QN ( aps_rename_67_ ) ) ;
INVXL U19 ( .A ( raw_bits_i[16] ) , .Y ( n34 ) ) ;
INVXL U8 ( .A ( raw_bits_i[5] ) , .Y ( n12 ) ) ;
INVXL HFSINV_4_341 ( .A ( raw_bits_i[4] ) , .Y ( HFSNET_118 ) ) ;
INVXL U12 ( .A ( raw_bits_i[9] ) , .Y ( n20 ) ) ;
INVXL U16 ( .A ( raw_bits_i[13] ) , .Y ( n28 ) ) ;
CLKINVXL U10 ( .A ( raw_bits_i[7] ) , .Y ( n16 ) ) ;
INVXL U18 ( .A ( raw_bits_i[15] ) , .Y ( n32 ) ) ;
INVX2 HFSINV_4_337 ( .A ( raw_bits_i[0] ) , .Y ( HFSNET_114 ) ) ;
INVXL U20 ( .A ( raw_bits_i[17] ) , .Y ( n36 ) ) ;
INVXL U21 ( .A ( raw_bits_i[18] ) , .Y ( n38 ) ) ;
INVXL HFSINV_4_342 ( .A ( raw_bits_i[6] ) , .Y ( HFSNET_119 ) ) ;
INVXL U15 ( .A ( raw_bits_i[12] ) , .Y ( n26 ) ) ;
INVXL U14 ( .A ( raw_bits_i[11] ) , .Y ( n24 ) ) ;
INVXL U22 ( .A ( raw_bits_i[19] ) , .Y ( n40 ) ) ;
INVXL HFSINV_4_336 ( .A ( data_valid_i ) , .Y ( HFSNET_113 ) ) ;
INVXL HFSINV_4_340 ( .A ( raw_bits_i[3] ) , .Y ( HFSNET_117 ) ) ;
INVXL HFSINV_4_338 ( .A ( raw_bits_i[1] ) , .Y ( HFSNET_115 ) ) ;
INVXL HFSINV_4_339 ( .A ( raw_bits_i[2] ) , .Y ( HFSNET_116 ) ) ;
INVXL U11 ( .A ( raw_bits_i[8] ) , .Y ( n18 ) ) ;
INVXL U13 ( .A ( raw_bits_i[10] ) , .Y ( n22 ) ) ;
INVXL U17 ( .A ( raw_bits_i[14] ) , .Y ( n30 ) ) ;
CLKBUFX2 HFSBUF_2_40 ( .A ( aps_rename_67_ ) , .Y ( raw_code_o[0] ) ) ;
CLKBUFX2 HFSBUF_2_41 ( .A ( aps_rename_57_ ) , .Y ( raw_code_o[10] ) ) ;
CLKBUFX2 HFSBUF_2_42 ( .A ( aps_rename_56_ ) , .Y ( raw_code_o[11] ) ) ;
CLKBUFX2 HFSBUF_2_51 ( .A ( aps_rename_66_ ) , .Y ( raw_code_o[1] ) ) ;
BUFX2 HFSBUF_2_52 ( .A ( aps_rename_65_ ) , .Y ( raw_code_o[2] ) ) ;
BUFX2 HFSBUF_2_53 ( .A ( aps_rename_64_ ) , .Y ( raw_code_o[3] ) ) ;
CLKBUFX2 HFSBUF_2_54 ( .A ( aps_rename_63_ ) , .Y ( raw_code_o[4] ) ) ;
BUFX2 HFSBUF_2_55 ( .A ( aps_rename_62_ ) , .Y ( raw_code_o[5] ) ) ;
CLKBUFX2 HFSBUF_2_56 ( .A ( aps_rename_61_ ) , .Y ( raw_code_o[6] ) ) ;
CLKBUFX2 HFSBUF_2_57 ( .A ( aps_rename_60_ ) , .Y ( raw_code_o[7] ) ) ;
CLKBUFX2 HFSBUF_2_58 ( .A ( aps_rename_59_ ) , .Y ( raw_code_o[8] ) ) ;
CLKBUFX2 HFSBUF_2_59 ( .A ( aps_rename_58_ ) , .Y ( raw_code_o[9] ) ) ;
CLKBUFX2 HFSBUF_2_60 ( .A ( aps_rename_68_ ) , .Y ( raw_code_valid_o ) ) ;
BUFX1 HFSBUF_2_61 ( .A ( aps_rename_21_ ) , .Y ( dac_p_force[8] ) ) ;
BUFX1 HFSBUF_2_62 ( .A ( aps_rename_22_ ) , .Y ( dac_p_force[7] ) ) ;
CLKBUFX2 HFSBUF_2_63 ( .A ( aps_rename_20_ ) , .Y ( dac_p_force[9] ) ) ;
CLKBUFX2 HFSBUF_2_64 ( .A ( aps_rename_19_ ) , .Y ( dac_p_force[10] ) ) ;
CLKBUFX2 HFSBUF_2_65 ( .A ( aps_rename_36_ ) , .Y ( dac_n_force[7] ) ) ;
CLKBUFX2 HFSBUF_2_66 ( .A ( aps_rename_18_ ) , .Y ( dac_p_force[11] ) ) ;
CLKBUFX2 HFSBUF_2_67 ( .A ( aps_rename_25_ ) , .Y ( dac_n_force[18] ) ) ;
CLKBUFX2 HFSBUF_2_68 ( .A ( aps_rename_29_ ) , .Y ( dac_n_force[14] ) ) ;
CLKBUFX2 HFSBUF_2_69 ( .A ( aps_rename_37_ ) , .Y ( dac_n_force[6] ) ) ;
CLKBUFX3 HFSBUF_2_70 ( .A ( aps_rename_40_ ) , .Y ( dac_n_force[3] ) ) ;
CLKBUFX2 HFSBUF_2_71 ( .A ( aps_rename_34_ ) , .Y ( dac_n_force[9] ) ) ;
CLKBUFX3 HFSBUF_2_72 ( .A ( aps_rename_42_ ) , .Y ( dac_n_force[1] ) ) ;
CLKBUFX2 HFSBUF_2_73 ( .A ( aps_rename_39_ ) , .Y ( dac_n_force[4] ) ) ;
CLKBUFX2 HFSBUF_2_74 ( .A ( aps_rename_38_ ) , .Y ( dac_n_force[5] ) ) ;
CLKBUFX3 HFSBUF_2_75 ( .A ( aps_rename_43_ ) , .Y ( dac_n_force[0] ) ) ;
CLKBUFX3 HFSBUF_2_76 ( .A ( aps_rename_41_ ) , .Y ( dac_n_force[2] ) ) ;
BUFX1 HFSBUF_2_77 ( .A ( aps_rename_35_ ) , .Y ( dac_n_force[8] ) ) ;
CLKBUFXL HFSBUF_2_78 ( .A ( aps_rename_33_ ) , .Y ( dac_n_force[10] ) ) ;
BUFX1 HFSBUF_2_79 ( .A ( aps_rename_23_ ) , .Y ( dac_p_force[0] ) ) ;
CLKBUFX2 HFSBUF_2_80 ( .A ( aps_rename_11_ ) , .Y ( dac_p_force[18] ) ) ;
CLKBUFX2 HFSBUF_2_81 ( .A ( aps_rename_12_ ) , .Y ( dac_p_force[17] ) ) ;
BUFX1 HFSBUF_2_82 ( .A ( aps_rename_13_ ) , .Y ( dac_p_force[16] ) ) ;
CLKBUFX2 HFSBUF_2_83 ( .A ( aps_rename_14_ ) , .Y ( dac_p_force[15] ) ) ;
CLKBUFX2 HFSBUF_2_84 ( .A ( aps_rename_15_ ) , .Y ( dac_p_force[14] ) ) ;
CLKBUFX2 HFSBUF_2_85 ( .A ( aps_rename_16_ ) , .Y ( dac_p_force[13] ) ) ;
CLKBUFX2 HFSBUF_2_86 ( .A ( aps_rename_17_ ) , .Y ( dac_p_force[12] ) ) ;
CLKBUFX2 HFSBUF_2_87 ( .A ( aps_rename_27_ ) , .Y ( dac_n_force[16] ) ) ;
CLKBUFX2 HFSBUF_2_88 ( .A ( aps_rename_24_ ) , .Y ( dac_n_force[19] ) ) ;
CLKBUFX2 HFSBUF_2_89 ( .A ( aps_rename_26_ ) , .Y ( dac_n_force[17] ) ) ;
CLKBUFX2 HFSBUF_2_90 ( .A ( aps_rename_31_ ) , .Y ( dac_n_force[12] ) ) ;
CLKBUFX2 HFSBUF_2_91 ( .A ( aps_rename_10_ ) , .Y ( dac_p_force[19] ) ) ;
CLKBUFX2 HFSBUF_2_260 ( .A ( aps_rename_8_ ) , .Y ( calib_done_pulse ) ) ;
CLKBUFX2 HFSBUF_2_261 ( .A ( aps_rename_7_ ) , .Y ( calib_done ) ) ;
CLKBUFX2 HFSBUF_2_262 ( .A ( aps_rename_9_ ) , .Y ( calib_mode_en ) ) ;
CLKBUFX2 HFSBUF_2_277 ( .A ( aps_rename_74_ ) , .Y ( w_wr_addr[0] ) ) ;
CLKBUFX2 HFSBUF_2_278 ( .A ( aps_rename_73_ ) , .Y ( w_wr_addr[1] ) ) ;
CLKBUFX2 HFSBUF_2_279 ( .A ( aps_rename_72_ ) , .Y ( w_wr_addr[2] ) ) ;
CLKBUFX2 HFSBUF_2_280 ( .A ( aps_rename_71_ ) , .Y ( w_wr_addr[3] ) ) ;
CLKBUFX2 HFSBUF_2_281 ( .A ( aps_rename_70_ ) , .Y ( w_wr_addr[4] ) ) ;
CLKBUFX2 HFSBUF_2_282 ( .A ( aps_rename_104_ ) , .Y ( w_wr_data[0] ) ) ;
CLKBUFX2 HFSBUF_2_283 ( .A ( aps_rename_94_ ) , .Y ( w_wr_data[10] ) ) ;
CLKBUFX2 HFSBUF_2_284 ( .A ( aps_rename_93_ ) , .Y ( w_wr_data[11] ) ) ;
CLKBUFX2 HFSBUF_2_285 ( .A ( aps_rename_92_ ) , .Y ( w_wr_data[12] ) ) ;
CLKBUFX2 HFSBUF_2_286 ( .A ( aps_rename_91_ ) , .Y ( w_wr_data[13] ) ) ;
CLKBUFX2 HFSBUF_2_287 ( .A ( aps_rename_90_ ) , .Y ( w_wr_data[14] ) ) ;
BUFX1 HFSBUF_2_288 ( .A ( aps_rename_89_ ) , .Y ( w_wr_data[15] ) ) ;
BUFX1 HFSBUF_2_289 ( .A ( aps_rename_88_ ) , .Y ( w_wr_data[16] ) ) ;
CLKBUFX2 HFSBUF_2_290 ( .A ( aps_rename_87_ ) , .Y ( w_wr_data[17] ) ) ;
CLKBUFX2 HFSBUF_2_291 ( .A ( aps_rename_86_ ) , .Y ( w_wr_data[18] ) ) ;
CLKBUFX2 HFSBUF_2_292 ( .A ( aps_rename_85_ ) , .Y ( w_wr_data[19] ) ) ;
CLKBUFX3 HFSBUF_2_293 ( .A ( aps_rename_103_ ) , .Y ( w_wr_data[1] ) ) ;
CLKBUFX2 HFSBUF_2_294 ( .A ( aps_rename_84_ ) , .Y ( w_wr_data[20] ) ) ;
CLKBUFX2 HFSBUF_2_295 ( .A ( aps_rename_83_ ) , .Y ( w_wr_data[21] ) ) ;
CLKBUFX2 HFSBUF_2_296 ( .A ( aps_rename_82_ ) , .Y ( w_wr_data[22] ) ) ;
CLKBUFX2 HFSBUF_2_297 ( .A ( aps_rename_81_ ) , .Y ( w_wr_data[23] ) ) ;
CLKBUFX2 HFSBUF_2_298 ( .A ( aps_rename_80_ ) , .Y ( w_wr_data[24] ) ) ;
CLKBUFX2 HFSBUF_2_299 ( .A ( aps_rename_79_ ) , .Y ( w_wr_data[25] ) ) ;
CLKBUFX2 HFSBUF_2_300 ( .A ( aps_rename_78_ ) , .Y ( w_wr_data[26] ) ) ;
CLKBUFX2 HFSBUF_2_301 ( .A ( aps_rename_77_ ) , .Y ( w_wr_data[27] ) ) ;
CLKBUFX2 HFSBUF_2_302 ( .A ( aps_rename_76_ ) , .Y ( w_wr_data[28] ) ) ;
CLKBUFX2 HFSBUF_2_303 ( .A ( aps_rename_75_ ) , .Y ( w_wr_data[29] ) ) ;
CLKBUFX2 HFSBUF_2_304 ( .A ( aps_rename_102_ ) , .Y ( w_wr_data[2] ) ) ;
CLKBUFX2 HFSBUF_2_305 ( .A ( aps_rename_101_ ) , .Y ( w_wr_data[3] ) ) ;
CLKBUFX2 HFSBUF_2_306 ( .A ( aps_rename_100_ ) , .Y ( w_wr_data[4] ) ) ;
CLKBUFX2 HFSBUF_2_307 ( .A ( aps_rename_99_ ) , .Y ( w_wr_data[5] ) ) ;
CLKBUFX2 HFSBUF_2_308 ( .A ( aps_rename_98_ ) , .Y ( w_wr_data[6] ) ) ;
CLKBUFX3 HFSBUF_2_309 ( .A ( aps_rename_97_ ) , .Y ( w_wr_data[7] ) ) ;
CLKBUFX2 HFSBUF_2_310 ( .A ( aps_rename_96_ ) , .Y ( w_wr_data[8] ) ) ;
CLKBUFX2 HFSBUF_2_311 ( .A ( aps_rename_95_ ) , .Y ( w_wr_data[9] ) ) ;
CLKBUFX2 HFSBUF_2_312 ( .A ( aps_rename_69_ ) , .Y ( w_wr_en ) ) ;
CLKBUFX4 HFSBUF_2_314 ( .A ( aps_rename_117_ ) , .Y ( srm_count_shortfall ) ) ;
CLKBUFX3 HFSBUF_2_315 ( .A ( aps_rename_105_ ) , .Y ( srm_done ) ) ;
BUFX2 HFSBUF_2_316 ( .A ( aps_rename_111_ ) , .Y ( srm_ones_count[0] ) ) ;
BUFX2 HFSBUF_2_317 ( .A ( aps_rename_110_ ) , .Y ( srm_ones_count[1] ) ) ;
CLKBUFX8 HFSBUF_2_318 ( .A ( aps_rename_109_ ) , .Y ( srm_ones_count[2] ) ) ;
CLKBUFX8 HFSBUF_2_319 ( .A ( aps_rename_108_ ) , .Y ( srm_ones_count[3] ) ) ;
CLKBUFX8 HFSBUF_2_320 ( .A ( aps_rename_107_ ) , .Y ( srm_ones_count[4] ) ) ;
CLKBUFX3 HFSBUF_2_321 ( .A ( aps_rename_128_ ) , .Y ( srm_residue_o[0] ) ) ;
CLKBUFX3 HFSBUF_2_322 ( .A ( aps_rename_127_ ) , .Y ( srm_residue_o[1] ) ) ;
CLKBUFX3 HFSBUF_2_323 ( .A ( aps_rename_126_ ) , .Y ( srm_residue_o[2] ) ) ;
CLKBUFX3 HFSBUF_2_324 ( .A ( aps_rename_125_ ) , .Y ( srm_residue_o[3] ) ) ;
CLKBUFX2 HFSBUF_2_325 ( .A ( aps_rename_124_ ) , .Y ( srm_residue_o[4] ) ) ;
CLKBUFX2 HFSBUF_2_326 ( .A ( aps_rename_123_ ) , .Y ( srm_residue_o[5] ) ) ;
CLKBUFX3 HFSBUF_2_327 ( .A ( aps_rename_122_ ) , .Y ( srm_residue_o[6] ) ) ;
CLKBUFX2 HFSBUF_2_328 ( .A ( aps_rename_121_ ) , .Y ( srm_residue_o[7] ) ) ;
CLKBUFX3 HFSBUF_2_329 ( .A ( aps_rename_120_ ) , .Y ( srm_residue_o[8] ) ) ;
CLKBUFX2 HFSBUF_2_330 ( .A ( aps_rename_119_ ) , .Y ( srm_residue_o[9] ) ) ;
CLKBUFX4 HFSBUF_2_331 ( .A ( aps_rename_116_ ) , .Y ( srm_total_count[0] ) ) ;
CLKBUFX4 HFSBUF_2_332 ( .A ( aps_rename_115_ ) , .Y ( srm_total_count[1] ) ) ;
CLKBUFX4 HFSBUF_2_333 ( .A ( aps_rename_114_ ) , .Y ( srm_total_count[2] ) ) ;
CLKBUFX4 HFSBUF_2_334 ( .A ( aps_rename_113_ ) , .Y ( srm_total_count[3] ) ) ;
CLKBUFX4 HFSBUF_2_335 ( .A ( aps_rename_112_ ) , .Y ( srm_total_count[4] ) ) ;
BUFX2 HFSBUF_9_435 ( .A ( aps_rename_44_ ) , .Y ( calib_overrange ) ) ;
BUFX2 HFSBUF_9_439 ( .A ( aps_rename_45_ ) , .Y ( calib_overrange_bits[19] ) ) ;
CLKINVX8 HFSINV_11_446 ( .A ( aps_rename_106_ ) , .Y ( srm_residue_valid ) ) ;
BUFX4 HFSBUF_9_448 ( .A ( aps_rename_118_ ) , .Y ( srm_stalled ) ) ;
CLKINVX4 HFSINV_11374_613 ( .A ( HFSNET_130 ) , .Y ( HFSNET_124 ) ) ;
CLKINVX4 HFSINV_6191_627 ( .A ( HFSNET_130 ) , .Y ( HFSNET_125 ) ) ;
CLKINVX8 HFSINV_367_633 ( .A ( HFSNET_130 ) , .Y ( HFSNET_126 ) ) ;
CLKINVX3 HFSINV_5477_643 ( .A ( HFSNET_130 ) , .Y ( HFSNET_127 ) ) ;
CLKINVX8 HFSINV_5855_644 ( .A ( HFSNET_130 ) , .Y ( HFSNET_128 ) ) ;
CLKBUFX2 ZBUF_24_inst_1021 ( .A ( aps_rename_47_ ) , 
    .Y ( calib_overrange_bits[6] ) ) ;
INVX16 HFSINV_12329_647 ( .A ( rst_n ) , .Y ( HFSNET_130 ) ) ;
BUFX2 ZBUF_22_inst_1034 ( .A ( aps_rename_46_ ) , 
    .Y ( calib_overrange_bits[16] ) ) ;
CLKBUFX2 ZBUF_2_inst_1041 ( .A ( aps_rename_32_ ) , .Y ( dac_n_force[11] ) ) ;
CLKBUFX2 ZBUF_2_inst_1047 ( .A ( aps_rename_30_ ) , .Y ( dac_n_force[13] ) ) ;
CLKBUFX2 ZBUF_2_inst_1048 ( .A ( aps_rename_28_ ) , .Y ( dac_n_force[15] ) ) ;
CLKBUFXL copt_gre_h_inst_2142 ( .A ( aps_rename_51_ ) , 
    .Y ( raw_code_o[16] ) ) ;
CLKBUFXL copt_gre_h_inst_2143 ( .A ( aps_rename_53_ ) , 
    .Y ( raw_code_o[14] ) ) ;
BUFX16 ZCTSBUF_9314_1366 ( .A ( clk ) , .Y ( ZCTSNET_133 ) ) ;
CLKBUFX8 ZCTSBUF_8899_1368 ( .A ( clk ) , .Y ( ZCTSNET_134 ) ) ;
CLKBUFXL copt_gre_h_inst_2144 ( .A ( aps_rename_52_ ) , 
    .Y ( raw_code_o[15] ) ) ;
CLKBUFXL copt_gre_h_inst_2145 ( .A ( aps_rename_54_ ) , 
    .Y ( raw_code_o[13] ) ) ;
CLKBUFXL copt_gre_h_inst_2146 ( .A ( aps_rename_48_ ) , 
    .Y ( raw_code_o[19] ) ) ;
CLKBUFXL copt_gre_h_inst_2147 ( .A ( aps_rename_55_ ) , 
    .Y ( raw_code_o[12] ) ) ;
CLKBUFXL copt_gre_h_inst_2148 ( .A ( aps_rename_50_ ) , 
    .Y ( raw_code_o[17] ) ) ;
CLKBUFXL copt_gre_h_inst_2149 ( .A ( aps_rename_49_ ) , 
    .Y ( raw_code_o[18] ) ) ;
endmodule


