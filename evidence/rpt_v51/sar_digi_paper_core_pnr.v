// Fusion Compiler Version W-2024.09-SP3 Verilog Writer
// Generated on 9/18/2026 at 20:24:16
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
AND3X1 U39 ( .A ( cnt[2] ) , .B ( cnt[1] ) , .C ( cnt[0] ) , .Y ( n11 ) ) ;
NOR2X2 U40 ( .A ( n11 ) , .B ( n8 ) , .Y ( n42 ) ) ;
AOI211XL U41 ( .A0 ( n52 ) , .A1 ( n51 ) , .B0 ( n50 ) , .C0 ( n49 ) , 
    .Y ( n53 ) ) ;
NOR2X1 U42 ( .A ( n41 ) , .B ( n36 ) , .Y ( n50 ) ) ;
NOR2X1 U43 ( .A ( n35 ) , .B ( n40 ) , .Y ( n52 ) ) ;
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
INVXL ctmTdsLR_1_845 ( .A ( n1 ) , .Y ( tmp_net151 ) ) ;
OAI22X2 ctmTdsLR_2_846 ( .A0 ( n24 ) , .A1 ( tmp_net151 ) , .B0 ( n22 ) , 
    .B1 ( n21 ) , .Y ( n48 ) ) ;
endmodule


module srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64 ( 
    dec_clk , decision_valid , decision_bit , clk , rst_n , start , 
    residue_consume , busy , done , residue_valid , ones_count , total_count , 
    count_shortfall , stalled , residue_q , HFSNET_5 , HFSNET_7 , HFSNET_8 ) ;
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
input  HFSNET_7 ;
input  HFSNET_8 ;

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
DFFSX1 dec_run_reg ( .D ( n79 ) , .CK ( net1628 ) , .SN ( HFSNET_4 ) , 
    .QN ( dec_run ) ) ;
DFFSX1 tgl_s2_reg ( .D ( n142 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tgl_s2 ) ) ;
DFFSX1 done_pending_reg ( .D ( n84 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( done_pending ) ) ;
DFFSXL \cap_total_reg[4] ( .D ( n126 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_total[4] ) ) ;
DFFSX1 \state_reg[1] ( .D ( n72 ) , .CK ( clk ) , .SN ( HFSNET_7 ) , 
    .Q ( n81 ) , .QN ( state[1] ) ) ;
DFFSX1 \state_reg[2] ( .D ( n71 ) , .CK ( clk ) , .SN ( HFSNET_7 ) , 
    .Q ( n131 ) , .QN ( state[2] ) ) ;
DFFSX1 \stall_cnt_reg[6] ( .D ( n85 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( stall_cnt[6] ) ) ;
DFFSX1 \stall_cnt_reg[5] ( .D ( n86 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( stall_cnt[5] ) ) ;
DFFSX1 \stall_cnt_reg[4] ( .D ( n87 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( stall_cnt[4] ) ) ;
DFFSX1 \stall_cnt_reg[3] ( .D ( n88 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( stall_cnt[3] ) ) ;
DFFSX1 \stall_cnt_reg[2] ( .D ( n89 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( stall_cnt[2] ) ) ;
DFFSX1 \stall_cnt_reg[1] ( .D ( n90 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( stall_cnt[1] ) ) ;
DFFSX1 \stall_cnt_reg[0] ( .D ( n91 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( stall_cnt[0] ) ) ;
DFFSX1 \tot_g_s2_reg[0] ( .D ( n141 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .QN ( tot_g_s2[0] ) ) ;
DFFSX1 \dec_total_reg[2] ( .D ( n120 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .Q ( n75 ) , .QN ( dec_total[2] ) ) ;
DFFSX1 \tot_g_s2_reg[1] ( .D ( n140 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tot_g_s2[1] ) ) ;
DFFSX1 \tot_g_s2_reg[3] ( .D ( n139 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tot_g_s2[3] ) ) ;
DFFSXL \cap_total_reg[3] ( .D ( n63 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_total[3] ) ) ;
DFFSX1 \tot_g_s2_reg[2] ( .D ( n138 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( tot_g_s2[2] ) ) ;
DFFSXL \cap_total_reg[2] ( .D ( n60 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_total[2] ) ) ;
DFFSXL cap_shortfall_reg ( .D ( n59 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_shortfall ) ) ;
DFFSXL \cap_total_reg[0] ( .D ( n58 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_total[0] ) ) ;
DFFSXL \cap_total_reg[1] ( .D ( n57 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_total[1] ) ) ;
DFFSX1 \ones_g_s2_reg[0] ( .D ( n137 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .QN ( ones_g_s2[0] ) ) ;
DFFSX1 \ones_g_s2_reg[1] ( .D ( n136 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .QN ( ones_g_s2[1] ) ) ;
DFFSX1 \dec_ones_reg[3] ( .D ( n114 ) , .CK ( net1622 ) , .SN ( HFSNET_4 ) , 
    .Q ( n144 ) , .QN ( dec_ones[3] ) ) ;
DFFSX1 \ones_g_s2_reg[2] ( .D ( n135 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .QN ( ones_g_s2[2] ) ) ;
DFFSXL \cap_ones_reg[4] ( .D ( n125 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_ones[4] ) ) ;
DFFSX1 \ones_g_s2_reg[3] ( .D ( n133 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .QN ( ones_g_s2[3] ) ) ;
DFFSX1 \cap_ones_reg[3] ( .D ( n45 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_ones[3] ) ) ;
DFFSX1 tgl_ref_reg ( .D ( n37 ) , .CK ( net1638 ) , .SN ( HFSNET_9 ) , 
    .QN ( tgl_ref ) ) ;
DFFSX1 \tot_g_s1_reg[4] ( .D ( n128 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .Q ( n143 ) ) ;
DFFSX1 tgl_s1_reg ( .D ( n129 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n142 ) ) ;
DFFSX1 \tot_g_s1_reg[0] ( .D ( n69 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .Q ( n141 ) ) ;
DFFSX1 \tot_g_s1_reg[1] ( .D ( n67 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n140 ) ) ;
DFFSX1 \tot_g_s1_reg[3] ( .D ( n65 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n139 ) ) ;
DFFSX1 \tot_g_s1_reg[2] ( .D ( n62 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .Q ( n138 ) ) ;
DFFSX1 \ones_g_s1_reg[0] ( .D ( n56 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .Q ( n137 ) ) ;
DFFSX1 \ones_g_s1_reg[1] ( .D ( n54 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .Q ( n136 ) ) ;
DFFSX1 \ones_g_s1_reg[2] ( .D ( n52 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .Q ( n135 ) ) ;
DFFSX1 \ones_g_s1_reg[4] ( .D ( n78 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .Q ( n134 ) ) ;
DFFSX1 \ones_g_s1_reg[3] ( .D ( n47 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .Q ( n133 ) ) ;
DFFSX1 go_tgl_reg ( .D ( n39 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n132 ) , .QN ( go_tgl ) ) ;
DFFSX1 dec_done_tgl_reg ( .D ( n38 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .Q ( n129 ) ) ;
DFFSX1 \dec_total_reg[1] ( .D ( n121 ) , .CK ( net1628 ) , .SN ( HFSNET_9 ) , 
    .Q ( n127 ) , .QN ( dec_total[1] ) ) ;
DFFSX1 \tot_g_s2_reg[4] ( .D ( n143 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n126 ) , .QN ( tot_g_s2[4] ) ) ;
DFFSX1 \ones_g_s2_reg[4] ( .D ( n134 ) , .CK ( clk ) , .SN ( HFSNET_4 ) , 
    .Q ( n125 ) , .QN ( ones_g_s2[4] ) ) ;
DFFSX1 go_tgl_s1_reg ( .D ( n132 ) , .CK ( ctosc_gls_0 ) , .SN ( HFSNET_4 ) , 
    .Q ( n82 ) ) ;
DFFSX1 \dec_total_reg[3] ( .D ( n119 ) , .CK ( net1628 ) , .SN ( HFSNET_4 ) , 
    .Q ( n76 ) , .QN ( dec_total[3] ) ) ;
DFFSX1 done_reg ( .D ( n41 ) , .CK ( clk ) , .SN ( HFSNET_5 ) , .QN ( done ) ) ;
DFFSXL \residue_q_small_reg[9] ( .D ( n92 ) , .CK ( net1643 ) , 
    .SN ( rst_n ) , .QN ( residue_q[9] ) ) ;
DFFSXL \residue_q_small_reg[8] ( .D ( n93 ) , .CK ( net1643 ) , 
    .SN ( rst_n ) , .QN ( residue_q[8] ) ) ;
DFFSXL \residue_q_small_reg[7] ( .D ( n94 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_6 ) , .QN ( residue_q[7] ) ) ;
DFFSXL \residue_q_small_reg[6] ( .D ( n95 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_6 ) , .QN ( residue_q[6] ) ) ;
DFFSXL \residue_q_small_reg[5] ( .D ( n96 ) , .CK ( net1643 ) , 
    .SN ( rst_n ) , .QN ( residue_q[5] ) ) ;
DFFSXL \residue_q_small_reg[4] ( .D ( n97 ) , .CK ( net1643 ) , 
    .SN ( rst_n ) , .QN ( residue_q[4] ) ) ;
DFFSXL \residue_q_small_reg[3] ( .D ( n98 ) , .CK ( net1643 ) , 
    .SN ( rst_n ) , .QN ( residue_q[3] ) ) ;
DFFSXL \residue_q_small_reg[2] ( .D ( n99 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_6 ) , .QN ( residue_q[2] ) ) ;
DFFSXL \residue_q_small_reg[1] ( .D ( n100 ) , .CK ( net1643 ) , 
    .SN ( rst_n ) , .QN ( residue_q[1] ) ) ;
DFFSXL \residue_q_small_reg[0] ( .D ( n101 ) , .CK ( net1643 ) , 
    .SN ( rst_n ) , .QN ( residue_q[0] ) ) ;
DFFSXL \ones_count_reg[4] ( .D ( n103 ) , .CK ( net1643 ) , .SN ( HFSNET_6 ) , 
    .QN ( ones_count[4] ) ) ;
DFFSXL \ones_count_reg[3] ( .D ( n104 ) , .CK ( net1643 ) , .SN ( HFSNET_6 ) , 
    .QN ( ones_count[3] ) ) ;
DFFSXL \ones_count_reg[2] ( .D ( n105 ) , .CK ( net1643 ) , .SN ( HFSNET_6 ) , 
    .QN ( ones_count[2] ) ) ;
DFFSXL \ones_count_reg[1] ( .D ( n106 ) , .CK ( net1643 ) , .SN ( rst_n ) , 
    .QN ( ones_count[1] ) ) ;
DFFSXL \ones_count_reg[0] ( .D ( n107 ) , .CK ( net1643 ) , .SN ( HFSNET_6 ) , 
    .QN ( ones_count[0] ) ) ;
DFFSXL \total_count_reg[4] ( .D ( n108 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_6 ) , .QN ( total_count[4] ) ) ;
DFFSXL \total_count_reg[3] ( .D ( n109 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_6 ) , .QN ( total_count[3] ) ) ;
DFFSXL \total_count_reg[2] ( .D ( n110 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_6 ) , .QN ( total_count[2] ) ) ;
DFFSXL \total_count_reg[1] ( .D ( n111 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_6 ) , .QN ( total_count[1] ) ) ;
DFFSXL \total_count_reg[0] ( .D ( n112 ) , .CK ( net1643 ) , 
    .SN ( HFSNET_6 ) , .QN ( total_count[0] ) ) ;
DFFSXL count_shortfall_reg ( .D ( n102 ) , .CK ( net1643 ) , .SN ( rst_n ) , 
    .QN ( count_shortfall ) ) ;
DFFSX1 \dec_total_reg[0] ( .D ( n122 ) , .CK ( net1628 ) , .SN ( HFSNET_4 ) , 
    .QN ( dec_total[0] ) ) ;
DFFSX1 go_tgl_s2_reg ( .D ( n82 ) , .CK ( ctosc_gls_0 ) , .SN ( HFSNET_4 ) , 
    .Q ( n80 ) , .QN ( go_tgl_s2 ) ) ;
DFFSXL \cap_ones_reg[2] ( .D ( n44 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_ones[2] ) ) ;
DFFSX1 \cap_ones_reg[0] ( .D ( n43 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_ones[0] ) ) ;
DFFSX1 \cap_ones_reg[1] ( .D ( n42 ) , .CK ( net1633 ) , .SN ( HFSNET_6 ) , 
    .QN ( cap_ones[1] ) ) ;
DFFSX1 \dec_total_reg[4] ( .D ( n118 ) , .CK ( net1628 ) , .SN ( HFSNET_4 ) , 
    .Q ( n128 ) , .QN ( dec_total[4] ) ) ;
DFFSX1 busy_reg ( .D ( n83 ) , .CK ( clk ) , .SN ( HFSNET_7 ) , 
    .QN ( aps_rename_7_ ) ) ;
DFFSX1 stalled_reg ( .D ( n70 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .QN ( stalled ) ) ;
DFFSX1 residue_valid_reg ( .D ( n40 ) , .CK ( clk ) , .SN ( HFSNET_6 ) , 
    .QN ( aps_rename_8_ ) ) ;
DFFSX1 \state_reg[0] ( .D ( n73 ) , .CK ( clk ) , .SN ( HFSNET_9 ) , 
    .Q ( n130 ) , .QN ( state[0] ) ) ;
DFFSX1 \dec_ones_reg[4] ( .D ( n113 ) , .CK ( net1622 ) , .SN ( HFSNET_4 ) , 
    .Q ( n78 ) , .QN ( dec_ones[4] ) ) ;
DFFSX1 \dec_ones_reg[2] ( .D ( n115 ) , .CK ( net1622 ) , .SN ( HFSNET_4 ) , 
    .Q ( n77 ) , .QN ( dec_ones[2] ) ) ;
DFFSX1 \dec_ones_reg[0] ( .D ( n117 ) , .CK ( net1622 ) , .SN ( HFSNET_4 ) , 
    .QN ( dec_ones[0] ) ) ;
DFFSX1 \dec_ones_reg[1] ( .D ( n116 ) , .CK ( net1622 ) , .SN ( HFSNET_4 ) , 
    .QN ( dec_ones[1] ) ) ;
DFFSX1 go_tgl_s3_reg ( .D ( n80 ) , .CK ( ctosc_gls_0 ) , .SN ( HFSNET_4 ) , 
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
CLKINVX3 HFSINV_106_588 ( .A ( HFSNET_8 ) , .Y ( HFSNET_4 ) ) ;
AOI21XL U16 ( .A0 ( n78 ) , .A1 ( n36 ) , .B0 ( n34 ) , .Y ( n35 ) ) ;
AOI21XL U17 ( .A0 ( n128 ) , .A1 ( n32 ) , .B0 ( n34 ) , .Y ( n31 ) ) ;
AOI2BB1XL U18 ( .A0N ( n17 ) , .A1N ( stall_cnt[6] ) , .B0 ( n49 ) , 
    .Y ( N105 ) ) ;
OAI2BB2XL U19 ( .B0 ( tgl_ref ) , .B1 ( tgl_s2 ) , .A0N ( tgl_s2 ) , 
    .A1N ( tgl_ref ) , .Y ( n3 ) ) ;
NAND2XL U20 ( .A ( n81 ) , .B ( n131 ) , .Y ( n55 ) ) ;
CLKINVX4 HFSINV_246_605 ( .A ( HFSNET_8 ) , .Y ( HFSNET_6 ) ) ;
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
NAND3XL U36 ( .A ( n30 ) , .B ( decision_valid ) , .C ( dec_run ) , 
    .Y ( n34 ) ) ;
AOI2BB2XL U37 ( .B0 ( busy ) , .B1 ( state[1] ) , .A0N ( state[2] ) , 
    .A1N ( n53 ) , .Y ( n83 ) ) ;
MXI2XL U38 ( .A ( go_tgl ) , .B ( n132 ) , .S0 ( n61 ) , .Y ( n39 ) ) ;
MXI2X1 U39 ( .A ( go_tgl_s2 ) , .B ( n80 ) , .S0 ( go_tgl_s3 ) , .Y ( n30 ) ) ;
NOR2BXL U40 ( .AN ( start ) , .B ( busy ) , .Y ( n61 ) ) ;
INVX3 HFSINV_15018_625 ( .A ( HFSNET_8 ) , .Y ( HFSNET_9 ) ) ;
BUFX1 ctosc_gls_inst_1717 ( .A ( dec_clk ) , .Y ( ctosc_gls_0 ) ) ;
NOR2XL U43 ( .A ( n81 ) , .B ( state[2] ) , .Y ( n21 ) ) ;
OAI21XL U44 ( .A0 ( tot_g_s2[3] ) , .A1 ( tot_g_s2[4] ) , .B0 ( n6 ) , 
    .Y ( n63 ) ) ;
INVXL U46 ( .A ( n49 ) , .Y ( n46 ) ) ;
NAND2XL U47 ( .A ( n21 ) , .B ( n130 ) , .Y ( n49 ) ) ;
NOR2XL U49 ( .A ( state[0] ) , .B ( state[1] ) , .Y ( n53 ) ) ;
NAND2XL U50 ( .A ( state[2] ) , .B ( n53 ) , .Y ( n41 ) ) ;
NAND2XL U51 ( .A ( tot_g_s2[4] ) , .B ( tot_g_s2[3] ) , .Y ( n6 ) ) ;
MXI2XL U52 ( .A ( ones_g_s2[4] ) , .B ( n125 ) , .S0 ( ones_g_s2[3] ) , 
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
NAND3XL U84 ( .A ( stall_cnt[0] ) , .B ( stall_cnt[1] ) , 
    .C ( stall_cnt[2] ) , .Y ( n9 ) ) ;
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
AOI21XL U96 ( .A0 ( residue_valid ) , .A1 ( n16 ) , .B0 ( n7 ) , .Y ( n40 ) ) ;
AOI211XL U97 ( .A0 ( state[0] ) , .A1 ( residue_consume ) , .B0 ( state[1] ) , 
    .C0 ( n131 ) , .Y ( n18 ) ) ;
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
CLKBUFX8 HFSBUF_17_420 ( .A ( aps_rename_8_ ) , .Y ( residue_valid ) ) ;
CLKBUFX3 HFSBUF_77_475 ( .A ( aps_rename_7_ ) , .Y ( busy ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_1_2 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_1 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
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
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
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
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_6 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_1 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_7 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_8 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_9 ( 
    CLK , EN , ENCLK , TE ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
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
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
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
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( CLK ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( ZCTSNET_0 ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_15 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
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
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_18 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_19 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_20 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_1 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_21 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_1 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
BUFX1 HFSBUF_2_251 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_22 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_23 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_2 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_2 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_2 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( HFSNET_0 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
BUFX1 HFSBUF_2_250 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_24 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_25 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_2 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_2 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_2 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( HFSNET_0 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
CLKBUFX3 HFSBUF_2_257 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_26 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_27 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_2 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_2 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_2 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
CLKBUFX3 HFSBUF_2_256 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_28 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( ZBUF_2_0 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
BUFX1 ZBUF_2_inst_1763 ( .A ( net1652 ) , .Y ( ZBUF_2_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_29 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_2 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_2 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_2 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_30 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X4 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_31 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_1 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
CLKBUFX3 HFSBUF_2_254 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_32 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_2 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_2 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_2 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_33 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_1 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_1 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_1 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( HFSNET_0 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
BUFX1 HFSBUF_2_252 ( .A ( net1652 ) , .Y ( HFSNET_0 ) ) ;
endmodule


module SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_0 ( 
    CLK , EN , ENCLK , TE , ZCTSNET_0 ) ;
input  CLK ;
input  EN ;
output ENCLK ;
input  TE ;
input  ZCTSNET_0 ;

TLATNXL latch ( .D ( EN ) , .GN ( ZCTSNET_0 ) , .Q ( net1652 ) ) ;
AND2X2 main_gate ( .A ( net1652 ) , .B ( CLK ) , .Y ( ENCLK ) ) ;
endmodule


module sar_calib_ctrl_serial_20_30_16_32_5_256_1_1 ( clk , rst_n , 
    start_calib , calib_done , calib_done_pulse , calib_mode_en , comp_out , 
    dac_p_force , dac_n_force , w_wr_en , w_wr_addr , w_wr_data , 
    calib_overrange , overrange_bits , HFSNET_330 , HFSNET_346 , HFSNET_362 , 
    HFSNET_363 , HFSNET_364 , ZBUF_24_0 , ZBUF_24_1 , ZBUF_24_2 , ZBUF_22_2 , 
    ZBUF_24_3 , ZCTSNET_392 , ZCTSNET_393 , ZCTSNET_394 , gre_a_BUF_36_0 , 
    gre_a_BUF_36_1 , gre_a_BUF_36_2 , gre_a_BUF_36_3 , gre_a_BUF_36_4 ) ;
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
input  HFSNET_330 ;
input  HFSNET_346 ;
input  HFSNET_362 ;
input  HFSNET_363 ;
input  HFSNET_364 ;
input  ZBUF_24_0 ;
input  ZBUF_24_1 ;
input  ZBUF_24_2 ;
input  ZBUF_22_2 ;
input  ZBUF_24_3 ;
input  ZCTSNET_392 ;
input  ZCTSNET_393 ;
input  ZCTSNET_394 ;
input  gre_a_BUF_36_0 ;
input  gre_a_BUF_36_1 ;
input  gre_a_BUF_36_2 ;
input  gre_a_BUF_36_3 ;
input  gre_a_BUF_36_4 ;

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
    .CLK ( ZCTSNET_389 ) , .EN ( N1842 ) , .ENCLK ( net1660 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_33 \clk_gate_shadow_weights_reg[1] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( N1841 ) , .ENCLK ( net1666 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_32 \clk_gate_shadow_weights_reg[2] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1840 ) , .ENCLK ( net1671 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_2 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_31 \clk_gate_shadow_weights_reg[3] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( N1839 ) , .ENCLK ( net1676 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_30 \clk_gate_shadow_weights_reg[4] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( HFSNET_234 ) , .ENCLK ( net1681 ) , 
    .TE ( 1'b0 ) , .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_29 \clk_gate_shadow_weights_reg[5] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( N1837 ) , .ENCLK ( net1686 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_2 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_28 \clk_gate_shadow_weights_reg[6] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1836 ) , .ENCLK ( net1691 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_27 \clk_gate_shadow_weights_reg[7] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( N1835 ) , .ENCLK ( net1696 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_2 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_26 \clk_gate_shadow_weights_reg[8] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1834 ) , .ENCLK ( net1701 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_25 \clk_gate_shadow_weights_reg[9] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( N1833 ) , .ENCLK ( net1706 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_2 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_24 \clk_gate_shadow_weights_reg[10] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1832 ) , .ENCLK ( net1711 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_23 \clk_gate_shadow_weights_reg[11] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( N1831 ) , .ENCLK ( net1716 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_2 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_22 \clk_gate_shadow_weights_reg[12] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( N1830 ) , .ENCLK ( net1721 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_21 \clk_gate_shadow_weights_reg[13] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( HFSNET_250 ) , .ENCLK ( net1726 ) , 
    .TE ( 1'b0 ) , .ZCTSNET_1 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_20 \clk_gate_shadow_weights_reg[14] ( 
    .CLK ( ZCTSNET_390 ) , .EN ( N1828 ) , .ENCLK ( net1731 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_19 \clk_gate_shadow_weights_reg[15] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1827 ) , .ENCLK ( net1736 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_18 \clk_gate_shadow_weights_reg[16] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1826 ) , .ENCLK ( net1741 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_17 \clk_gate_shadow_weights_reg[17] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1825 ) , .ENCLK ( net1746 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_16 \clk_gate_shadow_weights_reg[18] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1824 ) , .ENCLK ( net1751 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_15 \clk_gate_shadow_weights_reg[19] ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1823 ) , .ENCLK ( net1756 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_14 clk_gate_calib_done_reg ( 
    .CLK ( ZCTSNET_391 ) , .EN ( N1485 ) , .ENCLK ( net1761 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( clk ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_13 clk_gate_target_bit_reg ( 
    .CLK ( ZCTSNET_391 ) , .EN ( N1488 ) , .ENCLK ( net1766 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_393 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_12 clk_gate_avg_cnt_reg ( 
    .CLK ( ZCTSNET_393 ) , .EN ( N1536 ) , .ENCLK ( net1771 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_11 clk_gate_accumulator_reg ( 
    .CLK ( ZCTSNET_393 ) , .EN ( N1536 ) , .ENCLK ( net1776 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_10 clk_gate_sar_ptr_reg ( 
    .CLK ( ZCTSNET_391 ) , .EN ( N1602 ) , .ENCLK ( net1781 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_9 clk_gate_wait_cnt_reg ( 
    .CLK ( ZCTSNET_391 ) , .EN ( N1608 ) , .ENCLK ( net1786 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_8 clk_gate_w_wr_addr_reg ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1822 ) , .ENCLK ( net1791 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_7 clk_gate_w_wr_data_reg ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1822 ) , .ENCLK ( net1796 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_6 clk_gate_meas_val_p_reg ( 
    .CLK ( ZCTSNET_392 ) , .EN ( N1692 ) , .ENCLK ( net1801 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_393 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_5 clk_gate_meas_val_n_reg ( 
    .CLK ( ZCTSNET_392 ) , .EN ( N1723 ) , .ENCLK ( net1806 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_1 ( ZCTSNET_393 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_4 clk_gate_calc_cnt_reg ( 
    .CLK ( ZCTSNET_391 ) , .EN ( N1614 ) , .ENCLK ( net1811 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_3 clk_gate_avg_rounded_r_reg ( 
    .CLK ( ZCTSNET_393 ) , .EN ( N1754 ) , .ENCLK ( net1816 ) , .TE ( 1'b0 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_2 clk_gate_avg_rounded_r_reg_0 ( 
    .CLK ( ZCTSNET_391 ) , .EN ( N1754 ) , .ENCLK ( net1821 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_393 ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_1 clk_gate_calc_result_r_reg ( 
    .CLK ( ZCTSNET_389 ) , .EN ( N1791 ) , .ENCLK ( net1826 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
DFFSX1 comp_out_rr_reg ( .D ( n2233 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_345 ) , .QN ( comp_out_rr ) ) ;
DFFSX1 \state_reg[3] ( .D ( n822 ) , .CK ( ZCTSNET_391 ) , .SN ( rst_n ) , 
    .Q ( n2172 ) , .QN ( state[3] ) ) ;
DFFSXL \accumulator_reg[19] ( .D ( n945 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_349 ) , .QN ( accumulator[19] ) ) ;
DFFSXL \accumulator_reg[9] ( .D ( n954 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_349 ) , .QN ( accumulator[9] ) ) ;
DFFSX1 \accumulator_reg[5] ( .D ( n817 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[5] ) ) ;
DFFSXL \accumulator_reg[4] ( .D ( n958 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[4] ) ) ;
DFFSXL \accumulator_reg[3] ( .D ( n959 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[3] ) ) ;
DFFSXL \accumulator_reg[2] ( .D ( n960 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[2] ) ) ;
DFFSXL \avg_cnt_reg[3] ( .D ( n964 ) , .CK ( net1771 ) , .SN ( HFSNET_362 ) , 
    .QN ( avg_cnt[3] ) ) ;
DFFSXL \avg_cnt_reg[2] ( .D ( n965 ) , .CK ( net1771 ) , .SN ( HFSNET_362 ) , 
    .QN ( avg_cnt[2] ) ) ;
DFFSXL \avg_cnt_reg[1] ( .D ( n966 ) , .CK ( net1771 ) , .SN ( HFSNET_349 ) , 
    .QN ( avg_cnt[1] ) ) ;
DFFSXL \avg_cnt_reg[0] ( .D ( n967 ) , .CK ( net1771 ) , .SN ( HFSNET_349 ) , 
    .QN ( avg_cnt[0] ) ) ;
DFFSXL \avg_rounded_r_reg[17] ( .D ( n878 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_348 ) , .QN ( avg_rounded_r[17] ) ) ;
DFFSX1 \calc_result_r_reg[11] ( .D ( n848 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_358 ) , .QN ( calc_result_r[11] ) ) ;
DFFSXL \shadow_weights_reg[19][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[19][11] ) ) ;
DFFSXL \avg_rounded_r_reg[16] ( .D ( n879 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_348 ) , .QN ( avg_rounded_r[16] ) ) ;
DFFSXL \calc_result_r_reg[10] ( .D ( n849 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_358 ) , .QN ( calc_result_r[10] ) ) ;
DFFSXL \shadow_weights_reg[19][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_378 ) , .SN ( HFSNET_356 ) , 
    .QN ( \shadow_weights[19][10] ) ) ;
DFFSXL \avg_rounded_r_reg[15] ( .D ( HFSNET_2 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_358 ) , .QN ( avg_rounded_r[15] ) ) ;
DFFSXL \shadow_weights_reg[19][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_378 ) , .SN ( HFSNET_351 ) , 
    .QN ( \shadow_weights[19][9] ) ) ;
DFFSXL \avg_rounded_r_reg[14] ( .D ( HFSNET_4 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_358 ) , .QN ( avg_rounded_r[14] ) ) ;
DFFSXL \shadow_weights_reg[19][8] ( .D ( n70 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[19][8] ) ) ;
DFFSXL \calc_result_r_reg[7] ( .D ( n852 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_357 ) , .QN ( calc_result_r[7] ) ) ;
DFFSXL \shadow_weights_reg[19][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[19][7] ) ) ;
DFFSXL \avg_rounded_r_reg[12] ( .D ( n883 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_348 ) , .QN ( avg_rounded_r[12] ) ) ;
DFFSXL \calc_result_r_reg[6] ( .D ( n853 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[6] ) ) ;
DFFSXL \shadow_weights_reg[19][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[19][6] ) ) ;
DFFSXL \avg_rounded_r_reg[11] ( .D ( n884 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_360 ) , .QN ( avg_rounded_r[11] ) ) ;
DFFSXL \calc_result_r_reg[5] ( .D ( n854 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[5] ) ) ;
DFFSXL \shadow_weights_reg[19][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[19][5] ) ) ;
DFFSXL \avg_rounded_r_reg[10] ( .D ( HFSNET_5 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_361 ) , .QN ( avg_rounded_r[10] ) ) ;
DFFSXL \calc_result_r_reg[4] ( .D ( n855 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_361 ) , .QN ( calc_result_r[4] ) ) ;
DFFSXL \shadow_weights_reg[19][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[19][4] ) ) ;
DFFSXL \avg_rounded_r_reg[9] ( .D ( n886 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_348 ) , .QN ( avg_rounded_r[9] ) ) ;
DFFSXL \calc_result_r_reg[3] ( .D ( n856 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_357 ) , .QN ( calc_result_r[3] ) ) ;
DFFSXL \shadow_weights_reg[19][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[19][3] ) ) ;
DFFSXL \calc_result_r_reg[2] ( .D ( n857 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[2] ) ) ;
DFFSXL \shadow_weights_reg[19][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[19][2] ) ) ;
DFFSXL \avg_rounded_r_reg[7] ( .D ( n888 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_348 ) , .QN ( avg_rounded_r[7] ) ) ;
DFFSXL \calc_result_r_reg[1] ( .D ( n858 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[1] ) ) ;
DFFSXL \shadow_weights_reg[19][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[19][1] ) ) ;
DFFSXL \avg_rounded_r_reg[6] ( .D ( HFSNET_3 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_361 ) , .QN ( avg_rounded_r[6] ) ) ;
DFFSXL \calc_result_r_reg[0] ( .D ( n859 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[0] ) ) ;
DFFSXL \shadow_weights_reg[19][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[19][0] ) ) ;
DFFSXL \shadow_weights_reg[2][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[2][11] ) ) ;
DFFSXL \shadow_weights_reg[2][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_380 ) , .SN ( HFSNET_354 ) , .QN ( \shadow_weights[2][9] ) ) ;
DFFSXL \shadow_weights_reg[2][8] ( .D ( n70 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[2][8] ) ) ;
DFFSXL \shadow_weights_reg[2][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[2][7] ) ) ;
DFFSXL \shadow_weights_reg[2][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[2][6] ) ) ;
DFFSXL \shadow_weights_reg[2][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[2][5] ) ) ;
DFFSXL \shadow_weights_reg[2][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[2][3] ) ) ;
DFFSXL \shadow_weights_reg[2][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[2][2] ) ) ;
DFFSXL \shadow_weights_reg[2][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[2][1] ) ) ;
DFFSXL \shadow_weights_reg[2][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[2][0] ) ) ;
DFFSXL \shadow_weights_reg[3][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_381 ) , .SN ( HFSNET_352 ) , 
    .QN ( \shadow_weights[3][10] ) ) ;
DFFSXL \shadow_weights_reg[3][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_381 ) , .SN ( HFSNET_333 ) , .QN ( \shadow_weights[3][9] ) ) ;
DFFSXL \shadow_weights_reg[3][8] ( .D ( n70 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[3][8] ) ) ;
DFFSXL \shadow_weights_reg[3][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[3][7] ) ) ;
DFFSXL \shadow_weights_reg[3][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[3][6] ) ) ;
DFFSXL \shadow_weights_reg[3][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[3][5] ) ) ;
DFFSXL \shadow_weights_reg[3][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[3][4] ) ) ;
DFFSXL \shadow_weights_reg[3][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[3][3] ) ) ;
DFFSXL \shadow_weights_reg[3][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[3][2] ) ) ;
DFFSXL \shadow_weights_reg[3][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[3][1] ) ) ;
DFFSXL \shadow_weights_reg[6][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][11] ) ) ;
DFFSXL \shadow_weights_reg[6][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_384 ) , .SN ( HFSNET_353 ) , 
    .QN ( \shadow_weights[6][10] ) ) ;
DFFSXL \shadow_weights_reg[6][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_384 ) , .SN ( HFSNET_353 ) , .QN ( \shadow_weights[6][9] ) ) ;
DFFSXL \shadow_weights_reg[6][8] ( .D ( n70 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][8] ) ) ;
DFFSXL \shadow_weights_reg[6][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][7] ) ) ;
DFFSXL \shadow_weights_reg[6][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][6] ) ) ;
DFFSXL \shadow_weights_reg[6][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][5] ) ) ;
DFFSXL \shadow_weights_reg[6][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][4] ) ) ;
DFFSXL \shadow_weights_reg[6][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][3] ) ) ;
DFFSXL \shadow_weights_reg[6][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[6][2] ) ) ;
DFFSXL \shadow_weights_reg[6][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][1] ) ) ;
DFFSXL \shadow_weights_reg[6][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][0] ) ) ;
DFFSXL \shadow_weights_reg[7][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[7][11] ) ) ;
DFFSXL \shadow_weights_reg[7][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_385 ) , .SN ( HFSNET_338 ) , 
    .QN ( \shadow_weights[7][10] ) ) ;
DFFSXL \shadow_weights_reg[7][8] ( .D ( n70 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[7][8] ) ) ;
DFFSXL \shadow_weights_reg[7][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[7][7] ) ) ;
DFFSXL \shadow_weights_reg[7][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[7][6] ) ) ;
DFFSXL \shadow_weights_reg[7][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[7][5] ) ) ;
DFFSX1 \shadow_weights_reg[7][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[7][4] ) ) ;
DFFSXL \shadow_weights_reg[7][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[7][3] ) ) ;
DFFSXL \shadow_weights_reg[7][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[7][2] ) ) ;
DFFSXL \shadow_weights_reg[7][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[7][1] ) ) ;
DFFSXL \shadow_weights_reg[7][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[7][0] ) ) ;
DFFSXL \shadow_weights_reg[10][11] ( .D ( HFSNET_288 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[10][11] ) ) ;
DFFSXL \shadow_weights_reg[10][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1711 ) , .SN ( HFSNET_354 ) , .QN ( \shadow_weights[10][10] ) ) ;
DFFSXL \shadow_weights_reg[10][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( net1711 ) , .SN ( HFSNET_351 ) , .QN ( \shadow_weights[10][9] ) ) ;
DFFSXL \shadow_weights_reg[10][8] ( .D ( n70 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[10][8] ) ) ;
DFFSXL \shadow_weights_reg[10][7] ( .D ( HFSNET_320 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[10][7] ) ) ;
DFFSXL \shadow_weights_reg[10][5] ( .D ( HFSNET_316 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[10][5] ) ) ;
DFFSXL \shadow_weights_reg[10][4] ( .D ( HFSNET_315 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[10][4] ) ) ;
DFFSXL \shadow_weights_reg[10][3] ( .D ( HFSNET_314 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[10][3] ) ) ;
DFFSXL \shadow_weights_reg[10][2] ( .D ( HFSNET_313 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[10][2] ) ) ;
DFFSXL \shadow_weights_reg[10][1] ( .D ( HFSNET_308 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[10][1] ) ) ;
DFFSXL \shadow_weights_reg[10][0] ( .D ( HFSNET_297 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[10][0] ) ) ;
DFFSXL \shadow_weights_reg[14][11] ( .D ( HFSNET_288 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][11] ) ) ;
DFFSXL \shadow_weights_reg[14][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1731 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[14][10] ) ) ;
DFFSXL \shadow_weights_reg[14][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( net1731 ) , .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][9] ) ) ;
DFFSXL \shadow_weights_reg[14][8] ( .D ( n70 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[14][8] ) ) ;
DFFSXL \shadow_weights_reg[14][7] ( .D ( HFSNET_320 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][7] ) ) ;
DFFSXL \shadow_weights_reg[14][6] ( .D ( HFSNET_317 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[14][6] ) ) ;
DFFSXL \shadow_weights_reg[14][5] ( .D ( HFSNET_316 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][5] ) ) ;
DFFSXL \shadow_weights_reg[14][4] ( .D ( HFSNET_315 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][4] ) ) ;
DFFSXL \shadow_weights_reg[14][2] ( .D ( HFSNET_313 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][2] ) ) ;
DFFSXL \shadow_weights_reg[14][1] ( .D ( HFSNET_308 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[14][1] ) ) ;
DFFSXL \shadow_weights_reg[14][0] ( .D ( HFSNET_297 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[14][0] ) ) ;
DFFSXL \shadow_weights_reg[15][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[15][11] ) ) ;
DFFSXL \shadow_weights_reg[15][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_374 ) , .SN ( HFSNET_353 ) , 
    .QN ( \shadow_weights[15][10] ) ) ;
DFFSXL \shadow_weights_reg[15][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_374 ) , .SN ( HFSNET_353 ) , 
    .QN ( \shadow_weights[15][9] ) ) ;
DFFSXL \shadow_weights_reg[15][8] ( .D ( n70 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[15][8] ) ) ;
DFFSXL \shadow_weights_reg[15][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[15][6] ) ) ;
DFFSXL \shadow_weights_reg[15][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[15][5] ) ) ;
DFFSXL \shadow_weights_reg[15][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[15][4] ) ) ;
DFFSXL \shadow_weights_reg[15][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[15][3] ) ) ;
DFFSXL \shadow_weights_reg[15][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[15][2] ) ) ;
DFFSXL \shadow_weights_reg[15][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[15][1] ) ) ;
DFFSXL \shadow_weights_reg[15][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[15][0] ) ) ;
DFFSXL \shadow_weights_reg[0][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_369 ) , .SN ( HFSNET_351 ) , 
    .QN ( \shadow_weights[0][10] ) ) ;
DFFSXL \shadow_weights_reg[0][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_369 ) , .SN ( HFSNET_355 ) , .QN ( \shadow_weights[0][9] ) ) ;
DFFSXL \shadow_weights_reg[0][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[0][7] ) ) ;
DFFSXL \shadow_weights_reg[0][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[0][6] ) ) ;
DFFSXL \shadow_weights_reg[0][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[0][5] ) ) ;
DFFSXL \shadow_weights_reg[0][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[0][4] ) ) ;
DFFSXL \shadow_weights_reg[0][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[0][3] ) ) ;
DFFSXL \shadow_weights_reg[0][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[0][2] ) ) ;
DFFSXL \shadow_weights_reg[0][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[0][1] ) ) ;
DFFSXL \shadow_weights_reg[0][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[0][0] ) ) ;
DFFSXL \shadow_weights_reg[5][11] ( .D ( HFSNET_288 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[5][11] ) ) ;
DFFSXL \shadow_weights_reg[5][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1686 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[5][10] ) ) ;
DFFSXL \shadow_weights_reg[5][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( net1686 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[5][9] ) ) ;
DFFSXL \shadow_weights_reg[5][8] ( .D ( n70 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[5][8] ) ) ;
DFFSXL \shadow_weights_reg[5][6] ( .D ( HFSNET_317 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[5][6] ) ) ;
DFFSXL \shadow_weights_reg[5][5] ( .D ( HFSNET_316 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[5][5] ) ) ;
DFFSXL \shadow_weights_reg[5][4] ( .D ( HFSNET_315 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[5][4] ) ) ;
DFFSXL \shadow_weights_reg[5][3] ( .D ( HFSNET_314 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[5][3] ) ) ;
DFFSXL \shadow_weights_reg[5][2] ( .D ( HFSNET_313 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[5][2] ) ) ;
DFFSXL \shadow_weights_reg[5][1] ( .D ( HFSNET_308 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[5][1] ) ) ;
DFFSXL \shadow_weights_reg[5][0] ( .D ( HFSNET_297 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[5][0] ) ) ;
DFFSXL \shadow_weights_reg[8][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[8][11] ) ) ;
DFFSXL \shadow_weights_reg[8][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_386 ) , .SN ( HFSNET_354 ) , 
    .QN ( \shadow_weights[8][10] ) ) ;
DFFSXL \shadow_weights_reg[8][9] ( .D ( n69 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[8][9] ) ) ;
DFFSXL \shadow_weights_reg[8][8] ( .D ( n70 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[8][8] ) ) ;
DFFSXL \shadow_weights_reg[8][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[8][7] ) ) ;
DFFSXL \shadow_weights_reg[8][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[8][6] ) ) ;
DFFSXL \shadow_weights_reg[8][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[8][5] ) ) ;
DFFSXL \shadow_weights_reg[8][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[8][3] ) ) ;
DFFSXL \shadow_weights_reg[8][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[8][2] ) ) ;
DFFSXL \shadow_weights_reg[8][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[8][1] ) ) ;
DFFSXL \shadow_weights_reg[8][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[8][0] ) ) ;
DFFSXL \shadow_weights_reg[12][11] ( .D ( HFSNET_288 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[12][11] ) ) ;
DFFSXL \shadow_weights_reg[12][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1721 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[12][10] ) ) ;
DFFSXL \shadow_weights_reg[12][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( net1721 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[12][9] ) ) ;
DFFSXL \shadow_weights_reg[12][8] ( .D ( n70 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[12][8] ) ) ;
DFFSXL \shadow_weights_reg[12][7] ( .D ( HFSNET_320 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[12][7] ) ) ;
DFFSXL \shadow_weights_reg[12][6] ( .D ( HFSNET_317 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[12][6] ) ) ;
DFFSXL \shadow_weights_reg[12][5] ( .D ( HFSNET_316 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[12][5] ) ) ;
DFFSXL \shadow_weights_reg[12][4] ( .D ( HFSNET_315 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[12][4] ) ) ;
DFFSXL \shadow_weights_reg[12][3] ( .D ( HFSNET_314 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[12][3] ) ) ;
DFFSXL \shadow_weights_reg[12][2] ( .D ( HFSNET_313 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[12][2] ) ) ;
DFFSXL \shadow_weights_reg[12][0] ( .D ( HFSNET_297 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[12][0] ) ) ;
DFFSXL \shadow_weights_reg[13][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[13][11] ) ) ;
DFFSXL \shadow_weights_reg[13][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_372 ) , .SN ( HFSNET_353 ) , 
    .QN ( \shadow_weights[13][10] ) ) ;
DFFSXL \shadow_weights_reg[13][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_372 ) , .SN ( HFSNET_353 ) , 
    .QN ( \shadow_weights[13][9] ) ) ;
DFFSXL \shadow_weights_reg[13][8] ( .D ( n70 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[13][8] ) ) ;
DFFSXL \shadow_weights_reg[13][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[13][7] ) ) ;
DFFSXL \shadow_weights_reg[13][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[13][6] ) ) ;
DFFSXL \shadow_weights_reg[13][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[13][5] ) ) ;
DFFSXL \shadow_weights_reg[13][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[13][4] ) ) ;
DFFSXL \shadow_weights_reg[13][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[13][3] ) ) ;
DFFSXL \shadow_weights_reg[13][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[13][2] ) ) ;
DFFSXL \shadow_weights_reg[13][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[13][1] ) ) ;
DFFSXL \shadow_weights_reg[13][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[13][0] ) ) ;
DFFSXL \shadow_weights_reg[1][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[1][11] ) ) ;
DFFSXL \shadow_weights_reg[1][8] ( .D ( n70 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[1][8] ) ) ;
DFFSXL \shadow_weights_reg[1][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[1][7] ) ) ;
DFFSXL \shadow_weights_reg[1][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[1][6] ) ) ;
DFFSXL \shadow_weights_reg[1][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[1][5] ) ) ;
DFFSXL \shadow_weights_reg[1][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[1][4] ) ) ;
DFFSXL \shadow_weights_reg[1][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[1][3] ) ) ;
DFFSXL \shadow_weights_reg[1][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[1][2] ) ) ;
DFFSXL \shadow_weights_reg[1][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[1][1] ) ) ;
DFFSXL \shadow_weights_reg[1][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[1][0] ) ) ;
DFFSXL \shadow_weights_reg[9][11] ( .D ( HFSNET_288 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[9][11] ) ) ;
DFFSXL \shadow_weights_reg[9][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1706 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[9][10] ) ) ;
DFFSXL \shadow_weights_reg[9][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( net1706 ) , .SN ( HFSNET_338 ) , .QN ( \shadow_weights[9][9] ) ) ;
DFFSXL \shadow_weights_reg[9][8] ( .D ( n70 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[9][8] ) ) ;
DFFSXL \shadow_weights_reg[9][7] ( .D ( HFSNET_320 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[9][7] ) ) ;
DFFSXL \shadow_weights_reg[9][5] ( .D ( HFSNET_316 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[9][5] ) ) ;
DFFSXL \shadow_weights_reg[9][4] ( .D ( HFSNET_315 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[9][4] ) ) ;
DFFSXL \shadow_weights_reg[9][3] ( .D ( HFSNET_314 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[9][3] ) ) ;
DFFSXL \shadow_weights_reg[9][2] ( .D ( HFSNET_313 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[9][2] ) ) ;
DFFSXL \shadow_weights_reg[9][1] ( .D ( HFSNET_308 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[9][1] ) ) ;
DFFSXL \shadow_weights_reg[9][0] ( .D ( HFSNET_297 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[9][0] ) ) ;
DFFSXL \avg_rounded_r_reg[20] ( .D ( HFSNET_6 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_361 ) , .QN ( avg_rounded_r[20] ) ) ;
DFFSXL \calc_result_r_reg[14] ( .D ( n845 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[14] ) ) ;
DFFSXL \shadow_weights_reg[19][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[19][14] ) ) ;
DFFSXL \shadow_weights_reg[15][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[15][14] ) ) ;
DFFSXL \shadow_weights_reg[14][14] ( .D ( HFSNET_298 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[14][14] ) ) ;
DFFSXL \shadow_weights_reg[13][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[13][14] ) ) ;
DFFSXL \shadow_weights_reg[12][14] ( .D ( HFSNET_298 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[12][14] ) ) ;
DFFSXL \shadow_weights_reg[10][14] ( .D ( HFSNET_298 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[10][14] ) ) ;
DFFSXL \shadow_weights_reg[8][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[8][14] ) ) ;
DFFSXL \shadow_weights_reg[7][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[7][14] ) ) ;
DFFSXL \shadow_weights_reg[6][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[6][14] ) ) ;
DFFSXL \shadow_weights_reg[5][14] ( .D ( HFSNET_298 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[5][14] ) ) ;
DFFSXL \shadow_weights_reg[3][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[3][14] ) ) ;
DFFSXL \shadow_weights_reg[2][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[2][14] ) ) ;
DFFSXL \shadow_weights_reg[1][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[1][14] ) ) ;
DFFSXL \shadow_weights_reg[0][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[0][14] ) ) ;
DFFSX1 \avg_rounded_r_reg[19] ( .D ( HFSNET_1 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[19] ) ) ;
DFFSXL \calc_result_r_reg[13] ( .D ( n846 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_344 ) , .QN ( calc_result_r[13] ) ) ;
DFFSXL \shadow_weights_reg[19][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_378 ) , .SN ( HFSNET_354 ) , 
    .QN ( \shadow_weights[19][13] ) ) ;
DFFSXL \shadow_weights_reg[15][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_374 ) , .SN ( HFSNET_352 ) , 
    .QN ( \shadow_weights[15][13] ) ) ;
DFFSXL \shadow_weights_reg[14][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( net1731 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[14][13] ) ) ;
DFFSXL \shadow_weights_reg[13][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_372 ) , .SN ( HFSNET_352 ) , 
    .QN ( \shadow_weights[13][13] ) ) ;
DFFSXL \shadow_weights_reg[10][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( net1711 ) , .SN ( HFSNET_354 ) , .QN ( \shadow_weights[10][13] ) ) ;
DFFSXL \shadow_weights_reg[9][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( net1706 ) , .SN ( HFSNET_334 ) , .QN ( \shadow_weights[9][13] ) ) ;
DFFSXL \shadow_weights_reg[8][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_386 ) , .SN ( HFSNET_354 ) , 
    .QN ( \shadow_weights[8][13] ) ) ;
DFFSXL \shadow_weights_reg[7][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_385 ) , .SN ( HFSNET_338 ) , 
    .QN ( \shadow_weights[7][13] ) ) ;
DFFSX1 \shadow_weights_reg[6][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_384 ) , .SN ( HFSNET_335 ) , 
    .QN ( \shadow_weights[6][13] ) ) ;
DFFSXL \shadow_weights_reg[3][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_381 ) , .SN ( HFSNET_338 ) , 
    .QN ( \shadow_weights[3][13] ) ) ;
DFFSXL \shadow_weights_reg[2][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_380 ) , .SN ( HFSNET_333 ) , 
    .QN ( \shadow_weights[2][13] ) ) ;
DFFSXL \shadow_weights_reg[1][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_379 ) , .SN ( HFSNET_338 ) , 
    .QN ( \shadow_weights[1][13] ) ) ;
DFFSXL \shadow_weights_reg[0][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_369 ) , .SN ( HFSNET_335 ) , 
    .QN ( \shadow_weights[0][13] ) ) ;
DFFSXL \avg_rounded_r_reg[18] ( .D ( n877 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[18] ) ) ;
DFFSXL \calc_result_r_reg[12] ( .D ( n847 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_346 ) , .QN ( calc_result_r[12] ) ) ;
DFFSXL \shadow_weights_reg[19][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_378 ) , .SN ( HFSNET_354 ) , 
    .QN ( \shadow_weights[19][12] ) ) ;
DFFSXL \shadow_weights_reg[14][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( net1731 ) , .SN ( HFSNET_343 ) , .QN ( \shadow_weights[14][12] ) ) ;
DFFSXL \shadow_weights_reg[13][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_372 ) , .SN ( HFSNET_353 ) , 
    .QN ( \shadow_weights[13][12] ) ) ;
DFFSXL \shadow_weights_reg[10][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( net1711 ) , .SN ( HFSNET_354 ) , .QN ( \shadow_weights[10][12] ) ) ;
DFFSXL \shadow_weights_reg[9][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( net1706 ) , .SN ( HFSNET_335 ) , .QN ( \shadow_weights[9][12] ) ) ;
DFFSXL \shadow_weights_reg[8][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_386 ) , .SN ( HFSNET_351 ) , 
    .QN ( \shadow_weights[8][12] ) ) ;
DFFSXL \shadow_weights_reg[7][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_385 ) , .SN ( HFSNET_333 ) , 
    .QN ( \shadow_weights[7][12] ) ) ;
DFFSXL \shadow_weights_reg[6][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_384 ) , .SN ( HFSNET_353 ) , 
    .QN ( \shadow_weights[6][12] ) ) ;
DFFSXL \shadow_weights_reg[5][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( net1686 ) , .SN ( HFSNET_331 ) , .QN ( \shadow_weights[5][12] ) ) ;
DFFSXL \shadow_weights_reg[3][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_381 ) , .SN ( HFSNET_333 ) , 
    .QN ( \shadow_weights[3][12] ) ) ;
DFFSXL \shadow_weights_reg[2][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_380 ) , .SN ( HFSNET_333 ) , 
    .QN ( \shadow_weights[2][12] ) ) ;
DFFSXL \shadow_weights_reg[1][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_379 ) , .SN ( HFSNET_333 ) , 
    .QN ( \shadow_weights[1][12] ) ) ;
DFFSXL \shadow_weights_reg[0][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_369 ) , .SN ( HFSNET_333 ) , 
    .QN ( \shadow_weights[0][12] ) ) ;
DFFSX1 \wait_cnt_reg[0] ( .D ( n927 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .QN ( wait_cnt[0] ) ) ;
DFFSX1 \wait_cnt_reg[4] ( .D ( n790 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .QN ( wait_cnt[4] ) ) ;
DFFSX1 \wait_cnt_reg[1] ( .D ( n926 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .QN ( wait_cnt[1] ) ) ;
DFFSX1 \wait_cnt_reg[3] ( .D ( n924 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .QN ( wait_cnt[3] ) ) ;
DFFSXL \avg_rounded_r_reg[35] ( .D ( n860 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_360 ) , .QN ( avg_rounded_r[35] ) ) ;
DFFSXL \calc_result_r_reg[29] ( .D ( n830 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_361 ) , .QN ( calc_result_r[29] ) ) ;
DFFSX1 \shadow_weights_reg[19][29] ( .D ( n2307 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[19][29] ) ) ;
DFFSX1 \shadow_weights_reg[14][29] ( .D ( n2307 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][29] ) ) ;
DFFSX1 \shadow_weights_reg[13][29] ( .D ( n2307 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[13][29] ) ) ;
DFFSX1 \shadow_weights_reg[12][29] ( .D ( n2307 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[12][29] ) ) ;
DFFSX1 \shadow_weights_reg[10][29] ( .D ( n2307 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[10][29] ) ) ;
DFFSX1 \shadow_weights_reg[9][29] ( .D ( n2307 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[9][29] ) ) ;
DFFSX1 \shadow_weights_reg[8][29] ( .D ( n2307 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[8][29] ) ) ;
DFFSX1 \shadow_weights_reg[7][29] ( .D ( n2307 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[7][29] ) ) ;
DFFSX1 \shadow_weights_reg[6][29] ( .D ( n2307 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[6][29] ) ) ;
DFFSX1 \shadow_weights_reg[5][29] ( .D ( n2307 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[5][29] ) ) ;
DFFSX1 \shadow_weights_reg[3][29] ( .D ( n2307 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[3][29] ) ) ;
DFFSX1 \shadow_weights_reg[1][29] ( .D ( n2307 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[1][29] ) ) ;
DFFSX1 \shadow_weights_reg[0][29] ( .D ( n2307 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[0][29] ) ) ;
DFFSXL \avg_rounded_r_reg[34] ( .D ( n861 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[34] ) ) ;
DFFSXL \calc_result_r_reg[28] ( .D ( n831 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_346 ) , .QN ( calc_result_r[28] ) ) ;
DFFSXL \shadow_weights_reg[19][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[19][28] ) ) ;
DFFSX1 \shadow_weights_reg[17][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[17][28] ) ) ;
DFFSXL \shadow_weights_reg[14][28] ( .D ( HFSNET_312 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[14][28] ) ) ;
DFFSXL \shadow_weights_reg[13][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[13][28] ) ) ;
DFFSXL \shadow_weights_reg[12][28] ( .D ( HFSNET_312 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[12][28] ) ) ;
DFFSXL \shadow_weights_reg[10][28] ( .D ( HFSNET_312 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[10][28] ) ) ;
DFFSXL \shadow_weights_reg[9][28] ( .D ( HFSNET_312 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[9][28] ) ) ;
DFFSXL \shadow_weights_reg[8][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[8][28] ) ) ;
DFFSXL \shadow_weights_reg[7][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[7][28] ) ) ;
DFFSXL \shadow_weights_reg[6][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[6][28] ) ) ;
DFFSXL \shadow_weights_reg[3][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[3][28] ) ) ;
DFFSXL \shadow_weights_reg[2][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[2][28] ) ) ;
DFFSXL \shadow_weights_reg[1][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[1][28] ) ) ;
DFFSXL \shadow_weights_reg[0][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[0][28] ) ) ;
DFFSXL \avg_rounded_r_reg[33] ( .D ( n862 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_330 ) , .QN ( avg_rounded_r[33] ) ) ;
DFFSXL \calc_result_r_reg[27] ( .D ( n832 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_344 ) , .QN ( calc_result_r[27] ) ) ;
DFFSX1 \shadow_weights_reg[19][27] ( .D ( n2305 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[19][27] ) ) ;
DFFSX1 \shadow_weights_reg[17][27] ( .D ( n2305 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[17][27] ) ) ;
DFFSX1 \shadow_weights_reg[14][27] ( .D ( n2305 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[14][27] ) ) ;
DFFSX1 \shadow_weights_reg[13][27] ( .D ( n2305 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[13][27] ) ) ;
DFFSX1 \shadow_weights_reg[12][27] ( .D ( n2305 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[12][27] ) ) ;
DFFSX1 \shadow_weights_reg[10][27] ( .D ( n2305 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[10][27] ) ) ;
DFFSX1 \shadow_weights_reg[9][27] ( .D ( n2305 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[9][27] ) ) ;
DFFSX1 \shadow_weights_reg[8][27] ( .D ( n2305 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[8][27] ) ) ;
DFFSX1 \shadow_weights_reg[6][27] ( .D ( n2305 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[6][27] ) ) ;
DFFSX1 \shadow_weights_reg[5][27] ( .D ( n2305 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[5][27] ) ) ;
DFFSX1 \shadow_weights_reg[3][27] ( .D ( n2305 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[3][27] ) ) ;
DFFSX1 \shadow_weights_reg[2][27] ( .D ( n2305 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[2][27] ) ) ;
DFFSX1 \shadow_weights_reg[1][27] ( .D ( n2305 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[1][27] ) ) ;
DFFSX1 \shadow_weights_reg[0][27] ( .D ( n2305 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[0][27] ) ) ;
DFFSXL \avg_rounded_r_reg[32] ( .D ( n863 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[32] ) ) ;
DFFSXL \shadow_weights_reg[19][26] ( .D ( n71 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[19][26] ) ) ;
DFFSX1 \shadow_weights_reg[17][26] ( .D ( n71 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[17][26] ) ) ;
DFFSXL \shadow_weights_reg[14][26] ( .D ( ZBUF_754_28 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[14][26] ) ) ;
DFFSXL \shadow_weights_reg[13][26] ( .D ( ZBUF_754_28 ) , 
    .CK ( ZCTSNET_372 ) , .SN ( HFSNET_332 ) , 
    .QN ( \shadow_weights[13][26] ) ) ;
DFFSXL \shadow_weights_reg[12][26] ( .D ( ZBUF_754_28 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_331 ) , .QN ( \shadow_weights[12][26] ) ) ;
DFFSXL \shadow_weights_reg[10][26] ( .D ( ZBUF_754_28 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[10][26] ) ) ;
DFFSXL \shadow_weights_reg[9][26] ( .D ( ZBUF_754_28 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[9][26] ) ) ;
DFFSXL \shadow_weights_reg[7][26] ( .D ( ZBUF_754_28 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[7][26] ) ) ;
DFFSXL \shadow_weights_reg[6][26] ( .D ( ZBUF_754_28 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[6][26] ) ) ;
DFFSXL \shadow_weights_reg[5][26] ( .D ( ZBUF_754_28 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[5][26] ) ) ;
DFFSXL \shadow_weights_reg[3][26] ( .D ( ZBUF_754_28 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[3][26] ) ) ;
DFFSXL \shadow_weights_reg[2][26] ( .D ( ZBUF_754_28 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[2][26] ) ) ;
DFFSXL \shadow_weights_reg[1][26] ( .D ( ZBUF_754_28 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[1][26] ) ) ;
DFFSXL \shadow_weights_reg[0][26] ( .D ( ZBUF_754_28 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[0][26] ) ) ;
DFFSXL \avg_rounded_r_reg[31] ( .D ( n864 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[31] ) ) ;
DFFSXL \calc_result_r_reg[25] ( .D ( n834 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_346 ) , .QN ( calc_result_r[25] ) ) ;
DFFSX1 \shadow_weights_reg[19][25] ( .D ( n2304 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[19][25] ) ) ;
DFFSX1 \shadow_weights_reg[17][25] ( .D ( n2304 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[17][25] ) ) ;
DFFSX1 \shadow_weights_reg[14][25] ( .D ( n2304 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[14][25] ) ) ;
DFFSX1 \shadow_weights_reg[13][25] ( .D ( n2304 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[13][25] ) ) ;
DFFSX1 \shadow_weights_reg[12][25] ( .D ( n2304 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[12][25] ) ) ;
DFFSX1 \shadow_weights_reg[9][25] ( .D ( n2304 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[9][25] ) ) ;
DFFSX1 \shadow_weights_reg[8][25] ( .D ( n2304 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[8][25] ) ) ;
DFFSX1 \shadow_weights_reg[7][25] ( .D ( n2304 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[7][25] ) ) ;
DFFSX1 \shadow_weights_reg[6][25] ( .D ( n2304 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[6][25] ) ) ;
DFFSX1 \shadow_weights_reg[5][25] ( .D ( n2304 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_331 ) , .QN ( \shadow_weights[5][25] ) ) ;
DFFSX1 \shadow_weights_reg[3][25] ( .D ( n2304 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[3][25] ) ) ;
DFFSX1 \shadow_weights_reg[2][25] ( .D ( n2304 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[2][25] ) ) ;
DFFSX1 \shadow_weights_reg[1][25] ( .D ( n2304 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[1][25] ) ) ;
DFFSX1 \shadow_weights_reg[0][25] ( .D ( n2304 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[0][25] ) ) ;
DFFSXL \avg_rounded_r_reg[30] ( .D ( n865 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[30] ) ) ;
DFFSXL \calc_result_r_reg[24] ( .D ( n835 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_346 ) , .QN ( calc_result_r[24] ) ) ;
DFFSXL \shadow_weights_reg[19][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[19][24] ) ) ;
DFFSX1 \shadow_weights_reg[17][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[17][24] ) ) ;
DFFSXL \shadow_weights_reg[14][24] ( .D ( HFSNET_311 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[14][24] ) ) ;
DFFSXL \shadow_weights_reg[12][24] ( .D ( HFSNET_311 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[12][24] ) ) ;
DFFSXL \shadow_weights_reg[10][24] ( .D ( HFSNET_311 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[10][24] ) ) ;
DFFSXL \shadow_weights_reg[9][24] ( .D ( HFSNET_311 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[9][24] ) ) ;
DFFSXL \shadow_weights_reg[8][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[8][24] ) ) ;
DFFSXL \shadow_weights_reg[7][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[7][24] ) ) ;
DFFSXL \shadow_weights_reg[6][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[6][24] ) ) ;
DFFSXL \shadow_weights_reg[5][24] ( .D ( HFSNET_311 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[5][24] ) ) ;
DFFSXL \shadow_weights_reg[3][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[3][24] ) ) ;
DFFSXL \shadow_weights_reg[2][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[2][24] ) ) ;
DFFSXL \shadow_weights_reg[1][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[1][24] ) ) ;
DFFSXL \shadow_weights_reg[0][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[0][24] ) ) ;
DFFSX1 \accumulator_reg[29] ( .D ( n935 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .QN ( accumulator[29] ) ) ;
DFFSXL \avg_rounded_r_reg[29] ( .D ( n866 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_360 ) , .QN ( avg_rounded_r[29] ) ) ;
DFFSXL \calc_result_r_reg[23] ( .D ( n836 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[23] ) ) ;
DFFSX1 \shadow_weights_reg[17][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[17][23] ) ) ;
DFFSXL \shadow_weights_reg[14][23] ( .D ( HFSNET_310 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][23] ) ) ;
DFFSXL \shadow_weights_reg[13][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[13][23] ) ) ;
DFFSXL \shadow_weights_reg[12][23] ( .D ( HFSNET_310 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[12][23] ) ) ;
DFFSXL \shadow_weights_reg[10][23] ( .D ( HFSNET_310 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[10][23] ) ) ;
DFFSXL \shadow_weights_reg[9][23] ( .D ( HFSNET_310 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[9][23] ) ) ;
DFFSXL \shadow_weights_reg[8][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[8][23] ) ) ;
DFFSXL \shadow_weights_reg[7][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[7][23] ) ) ;
DFFSXL \shadow_weights_reg[6][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[6][23] ) ) ;
DFFSXL \shadow_weights_reg[5][23] ( .D ( HFSNET_310 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[5][23] ) ) ;
DFFSXL \shadow_weights_reg[3][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[3][23] ) ) ;
DFFSXL \shadow_weights_reg[2][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[2][23] ) ) ;
DFFSXL \shadow_weights_reg[1][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[1][23] ) ) ;
DFFSXL \shadow_weights_reg[0][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[0][23] ) ) ;
DFFSXL \avg_rounded_r_reg[28] ( .D ( HFSNET_7 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_361 ) , .QN ( avg_rounded_r[28] ) ) ;
DFFSXL \calc_result_r_reg[22] ( .D ( n837 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_361 ) , .QN ( calc_result_r[22] ) ) ;
DFFSXL \shadow_weights_reg[19][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[19][22] ) ) ;
DFFSXL \shadow_weights_reg[17][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[17][22] ) ) ;
DFFSXL \shadow_weights_reg[14][22] ( .D ( HFSNET_309 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[14][22] ) ) ;
DFFSXL \shadow_weights_reg[13][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[13][22] ) ) ;
DFFSXL \shadow_weights_reg[12][22] ( .D ( HFSNET_309 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[12][22] ) ) ;
DFFSXL \shadow_weights_reg[10][22] ( .D ( HFSNET_309 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[10][22] ) ) ;
DFFSXL \shadow_weights_reg[9][22] ( .D ( HFSNET_309 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[9][22] ) ) ;
DFFSXL \shadow_weights_reg[8][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[8][22] ) ) ;
DFFSXL \shadow_weights_reg[7][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[7][22] ) ) ;
DFFSXL \shadow_weights_reg[6][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[6][22] ) ) ;
DFFSXL \shadow_weights_reg[5][22] ( .D ( HFSNET_309 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[5][22] ) ) ;
DFFSXL \shadow_weights_reg[3][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[3][22] ) ) ;
DFFSXL \shadow_weights_reg[1][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[1][22] ) ) ;
DFFSXL \shadow_weights_reg[0][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[0][22] ) ) ;
DFFSX1 \accumulator_reg[27] ( .D ( n937 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_330 ) , .QN ( accumulator[27] ) ) ;
DFFSXL \avg_rounded_r_reg[27] ( .D ( n868 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[27] ) ) ;
DFFSXL \calc_result_r_reg[21] ( .D ( n838 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_346 ) , .QN ( calc_result_r[21] ) ) ;
DFFSX1 \shadow_weights_reg[19][21] ( .D ( n2300 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[19][21] ) ) ;
DFFSX1 \shadow_weights_reg[17][21] ( .D ( n2300 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[17][21] ) ) ;
DFFSX1 \shadow_weights_reg[14][21] ( .D ( n2300 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[14][21] ) ) ;
DFFSXL \shadow_weights_reg[13][21] ( .D ( n2300 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[13][21] ) ) ;
DFFSXL \shadow_weights_reg[12][21] ( .D ( n2300 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[12][21] ) ) ;
DFFSXL \shadow_weights_reg[10][21] ( .D ( n2300 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[10][21] ) ) ;
DFFSX1 \shadow_weights_reg[9][21] ( .D ( n2300 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[9][21] ) ) ;
DFFSXL \shadow_weights_reg[8][21] ( .D ( n2300 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[8][21] ) ) ;
DFFSXL \shadow_weights_reg[7][21] ( .D ( n2300 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[7][21] ) ) ;
DFFSXL \shadow_weights_reg[5][21] ( .D ( n2300 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[5][21] ) ) ;
DFFSX1 \shadow_weights_reg[3][21] ( .D ( n2300 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[3][21] ) ) ;
DFFSXL \shadow_weights_reg[2][21] ( .D ( n2300 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[2][21] ) ) ;
DFFSXL \shadow_weights_reg[1][21] ( .D ( n2300 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[1][21] ) ) ;
DFFSXL \shadow_weights_reg[0][21] ( .D ( n2300 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[0][21] ) ) ;
DFFSX1 \accumulator_reg[26] ( .D ( n938 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_330 ) , .QN ( accumulator[26] ) ) ;
DFFSXL \avg_rounded_r_reg[26] ( .D ( n869 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[26] ) ) ;
DFFSXL \calc_result_r_reg[20] ( .D ( n839 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_346 ) , .QN ( calc_result_r[20] ) ) ;
DFFSX1 \shadow_weights_reg[19][20] ( .D ( n2299 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[19][20] ) ) ;
DFFSX1 \shadow_weights_reg[17][20] ( .D ( n2299 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[17][20] ) ) ;
DFFSX1 \shadow_weights_reg[14][20] ( .D ( n2299 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[14][20] ) ) ;
DFFSXL \shadow_weights_reg[13][20] ( .D ( n2299 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[13][20] ) ) ;
DFFSX1 \shadow_weights_reg[12][20] ( .D ( n2299 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[12][20] ) ) ;
DFFSX1 \shadow_weights_reg[10][20] ( .D ( n2299 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[10][20] ) ) ;
DFFSX1 \shadow_weights_reg[8][20] ( .D ( n2299 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[8][20] ) ) ;
DFFSX1 \shadow_weights_reg[7][20] ( .D ( n2299 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[7][20] ) ) ;
DFFSXL \shadow_weights_reg[6][20] ( .D ( n2299 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[6][20] ) ) ;
DFFSX1 \shadow_weights_reg[5][20] ( .D ( n2299 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[5][20] ) ) ;
DFFSX1 \shadow_weights_reg[3][20] ( .D ( n2299 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[3][20] ) ) ;
DFFSXL \shadow_weights_reg[2][20] ( .D ( n2299 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[2][20] ) ) ;
DFFSX1 \shadow_weights_reg[1][20] ( .D ( n2299 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[1][20] ) ) ;
DFFSXL \shadow_weights_reg[0][20] ( .D ( n2299 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[0][20] ) ) ;
DFFSX1 \accumulator_reg[25] ( .D ( n939 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .QN ( accumulator[25] ) ) ;
DFFSXL \avg_rounded_r_reg[25] ( .D ( n870 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[25] ) ) ;
DFFSXL \calc_result_r_reg[19] ( .D ( n840 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_346 ) , .QN ( calc_result_r[19] ) ) ;
DFFSXL \shadow_weights_reg[19][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[19][19] ) ) ;
DFFSXL \shadow_weights_reg[17][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[17][19] ) ) ;
DFFSXL \shadow_weights_reg[14][19] ( .D ( HFSNET_304 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][19] ) ) ;
DFFSXL \shadow_weights_reg[12][19] ( .D ( HFSNET_304 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[12][19] ) ) ;
DFFSXL \shadow_weights_reg[10][19] ( .D ( HFSNET_304 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[10][19] ) ) ;
DFFSXL \shadow_weights_reg[9][19] ( .D ( HFSNET_304 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[9][19] ) ) ;
DFFSXL \shadow_weights_reg[8][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[8][19] ) ) ;
DFFSXL \shadow_weights_reg[7][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[7][19] ) ) ;
DFFSXL \shadow_weights_reg[6][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[6][19] ) ) ;
DFFSXL \shadow_weights_reg[5][19] ( .D ( HFSNET_304 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[5][19] ) ) ;
DFFSXL \shadow_weights_reg[3][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[3][19] ) ) ;
DFFSXL \shadow_weights_reg[2][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[2][19] ) ) ;
DFFSXL \shadow_weights_reg[1][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[1][19] ) ) ;
DFFSXL \shadow_weights_reg[0][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[0][19] ) ) ;
DFFSX1 \accumulator_reg[24] ( .D ( n940 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .QN ( accumulator[24] ) ) ;
DFFSXL \avg_rounded_r_reg[24] ( .D ( n871 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_360 ) , .QN ( avg_rounded_r[24] ) ) ;
DFFSXL \calc_result_r_reg[18] ( .D ( n841 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[18] ) ) ;
DFFSX1 \shadow_weights_reg[17][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[17][18] ) ) ;
DFFSXL \shadow_weights_reg[14][18] ( .D ( HFSNET_303 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[14][18] ) ) ;
DFFSXL \shadow_weights_reg[13][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[13][18] ) ) ;
DFFSXL \shadow_weights_reg[12][18] ( .D ( HFSNET_303 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[12][18] ) ) ;
DFFSXL \shadow_weights_reg[10][18] ( .D ( HFSNET_303 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[10][18] ) ) ;
DFFSXL \shadow_weights_reg[9][18] ( .D ( HFSNET_303 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[9][18] ) ) ;
DFFSXL \shadow_weights_reg[8][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[8][18] ) ) ;
DFFSXL \shadow_weights_reg[7][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[7][18] ) ) ;
DFFSXL \shadow_weights_reg[6][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[6][18] ) ) ;
DFFSXL \shadow_weights_reg[5][18] ( .D ( HFSNET_303 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[5][18] ) ) ;
DFFSXL \shadow_weights_reg[3][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[3][18] ) ) ;
DFFSXL \shadow_weights_reg[2][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[2][18] ) ) ;
DFFSXL \shadow_weights_reg[1][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[1][18] ) ) ;
DFFSXL \shadow_weights_reg[0][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[0][18] ) ) ;
DFFSXL \avg_rounded_r_reg[23] ( .D ( n872 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_360 ) , .QN ( avg_rounded_r[23] ) ) ;
DFFSXL \calc_result_r_reg[17] ( .D ( n842 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_360 ) , .QN ( calc_result_r[17] ) ) ;
DFFSXL \shadow_weights_reg[19][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[19][17] ) ) ;
DFFSXL \shadow_weights_reg[14][17] ( .D ( HFSNET_302 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[14][17] ) ) ;
DFFSXL \shadow_weights_reg[13][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[13][17] ) ) ;
DFFSXL \shadow_weights_reg[12][17] ( .D ( HFSNET_302 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[12][17] ) ) ;
DFFSXL \shadow_weights_reg[10][17] ( .D ( HFSNET_302 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[10][17] ) ) ;
DFFSXL \shadow_weights_reg[9][17] ( .D ( HFSNET_302 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[9][17] ) ) ;
DFFSXL \shadow_weights_reg[8][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[8][17] ) ) ;
DFFSXL \shadow_weights_reg[7][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[7][17] ) ) ;
DFFSXL \shadow_weights_reg[6][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[6][17] ) ) ;
DFFSXL \shadow_weights_reg[5][17] ( .D ( HFSNET_302 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[5][17] ) ) ;
DFFSXL \shadow_weights_reg[3][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[3][17] ) ) ;
DFFSXL \shadow_weights_reg[2][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[2][17] ) ) ;
DFFSXL \shadow_weights_reg[0][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[0][17] ) ) ;
DFFSXL \accumulator_reg[22] ( .D ( n942 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .QN ( accumulator[22] ) ) ;
DFFSXL \avg_rounded_r_reg[22] ( .D ( HFSNET_0 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_361 ) , .QN ( avg_rounded_r[22] ) ) ;
DFFSXL \calc_result_r_reg[16] ( .D ( n843 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_361 ) , .QN ( calc_result_r[16] ) ) ;
DFFSXL \shadow_weights_reg[19][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[19][16] ) ) ;
DFFSXL \shadow_weights_reg[14][16] ( .D ( HFSNET_301 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[14][16] ) ) ;
DFFSXL \shadow_weights_reg[13][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[13][16] ) ) ;
DFFSXL \shadow_weights_reg[12][16] ( .D ( HFSNET_301 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[12][16] ) ) ;
DFFSXL \shadow_weights_reg[10][16] ( .D ( HFSNET_301 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[10][16] ) ) ;
DFFSXL \shadow_weights_reg[9][16] ( .D ( HFSNET_301 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[9][16] ) ) ;
DFFSXL \shadow_weights_reg[8][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[8][16] ) ) ;
DFFSXL \shadow_weights_reg[7][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[7][16] ) ) ;
DFFSX1 \shadow_weights_reg[6][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[6][16] ) ) ;
DFFSXL \shadow_weights_reg[5][16] ( .D ( HFSNET_301 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[5][16] ) ) ;
DFFSXL \shadow_weights_reg[2][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[2][16] ) ) ;
DFFSXL \shadow_weights_reg[1][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[1][16] ) ) ;
DFFSXL \shadow_weights_reg[0][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[0][16] ) ) ;
DFFSX1 \accumulator_reg[21] ( .D ( HFSNET_9 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_330 ) , .QN ( accumulator[21] ) ) ;
DFFSXL \avg_rounded_r_reg[21] ( .D ( n874 ) , .CK ( net1816 ) , 
    .SN ( HFSNET_346 ) , .QN ( avg_rounded_r[21] ) ) ;
DFFSX1 \calc_result_r_reg[15] ( .D ( n844 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_346 ) , .QN ( calc_result_r[15] ) ) ;
DFFSXL \shadow_weights_reg[19][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[19][15] ) ) ;
DFFSXL \shadow_weights_reg[14][15] ( .D ( HFSNET_299 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[14][15] ) ) ;
DFFSXL \shadow_weights_reg[13][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[13][15] ) ) ;
DFFSXL \shadow_weights_reg[12][15] ( .D ( HFSNET_299 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[12][15] ) ) ;
DFFSXL \shadow_weights_reg[10][15] ( .D ( HFSNET_299 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[10][15] ) ) ;
DFFSXL \shadow_weights_reg[9][15] ( .D ( HFSNET_299 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[9][15] ) ) ;
DFFSXL \shadow_weights_reg[8][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_354 ) , .QN ( \shadow_weights[8][15] ) ) ;
DFFSXL \shadow_weights_reg[7][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[7][15] ) ) ;
DFFSXL \shadow_weights_reg[5][15] ( .D ( HFSNET_299 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[5][15] ) ) ;
DFFSXL \shadow_weights_reg[3][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[3][15] ) ) ;
DFFSXL \shadow_weights_reg[2][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[2][15] ) ) ;
DFFSXL \shadow_weights_reg[1][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[1][15] ) ) ;
DFFSXL \shadow_weights_reg[0][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[0][15] ) ) ;
DFFSX1 \sar_code_reg[0] ( .D ( n773 ) , .CK ( ZCTSNET_391 ) , .SN ( rst_n ) , 
    .Q ( n2185 ) , .QN ( protected_sar_code[0] ) ) ;
DFFSX1 \sar_code_reg[4] ( .D ( n769 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .Q ( n2190 ) , .QN ( protected_sar_code[4] ) ) ;
DFFSX1 \sar_code_reg[5] ( .D ( n768 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .Q ( n2191 ) , .QN ( protected_sar_code[5] ) ) ;
DFFSX1 \sar_code_reg[13] ( .D ( n760 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_331 ) , .Q ( n2188 ) , .QN ( protected_sar_code[13] ) ) ;
DFFSXL \sar_code_reg[17] ( .D ( n756 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_331 ) , .QN ( sar_code[17] ) ) ;
DFFSXL \sar_code_reg[18] ( .D ( n755 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_331 ) , .QN ( sar_code[18] ) ) ;
DFFSXL \temp_acc_reg[18] ( .D ( n2329 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2205 ) , .QN ( temp_acc[18] ) ) ;
DFFSXL \temp_acc_reg[19] ( .D ( n2330 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2203 ) , .QN ( temp_acc[19] ) ) ;
DFFSXL \temp_acc_reg[20] ( .D ( n2331 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2204 ) , .QN ( temp_acc[20] ) ) ;
DFFSXL \temp_acc_reg[21] ( .D ( n2332 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2206 ) , .QN ( temp_acc[21] ) ) ;
DFFSXL \meas_val_p_reg[21] ( .D ( n902 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_p[21] ) ) ;
DFFSXL \temp_acc_reg[22] ( .D ( n2333 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2207 ) , .QN ( temp_acc[22] ) ) ;
DFFSXL \meas_val_p_reg[22] ( .D ( n901 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_p[22] ) ) ;
DFFSXL \temp_acc_reg[23] ( .D ( n2334 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2213 ) , .QN ( temp_acc[23] ) ) ;
DFFSX1 \meas_val_p_reg[23] ( .D ( n900 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_p[23] ) ) ;
DFFSXL \temp_acc_reg[24] ( .D ( n2335 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2212 ) , .QN ( temp_acc[24] ) ) ;
DFFSXL \meas_val_p_reg[24] ( .D ( n899 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_362 ) , .QN ( meas_val_p[24] ) ) ;
DFFSXL \temp_acc_reg[25] ( .D ( n2336 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_362 ) , .Q ( n2211 ) , .QN ( temp_acc[25] ) ) ;
DFFSX1 \meas_val_p_reg[25] ( .D ( n898 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_362 ) , .QN ( meas_val_p[25] ) ) ;
DFFSXL \temp_acc_reg[26] ( .D ( n2337 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_362 ) , .Q ( n2210 ) , .QN ( temp_acc[26] ) ) ;
DFFSXL \meas_val_p_reg[26] ( .D ( n897 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_362 ) , .QN ( meas_val_p[26] ) ) ;
DFFSXL \temp_acc_reg[27] ( .D ( n2338 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_362 ) , .Q ( n2209 ) , .QN ( temp_acc[27] ) ) ;
DFFSXL \meas_val_p_reg[27] ( .D ( n896 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_p[27] ) ) ;
DFFSXL \temp_acc_reg[28] ( .D ( n2339 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2208 ) , .QN ( temp_acc[28] ) ) ;
DFFSX1 \meas_val_n_reg[28] ( .D ( n895 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_362 ) , .QN ( meas_val_n[28] ) ) ;
DFFSXL \meas_val_n_reg[27] ( .D ( n896 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[27] ) ) ;
DFFSXL \meas_val_n_reg[26] ( .D ( n897 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_362 ) , .QN ( meas_val_n[26] ) ) ;
DFFSXL \meas_val_n_reg[25] ( .D ( n898 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_362 ) , .QN ( meas_val_n[25] ) ) ;
DFFSXL \meas_val_n_reg[24] ( .D ( n899 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[24] ) ) ;
DFFSX1 \meas_val_n_reg[23] ( .D ( n900 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[23] ) ) ;
DFFSXL \meas_val_n_reg[22] ( .D ( n901 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[22] ) ) ;
DFFSXL \meas_val_n_reg[21] ( .D ( n902 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[21] ) ) ;
DFFSXL \meas_val_n_reg[1] ( .D ( n922 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[1] ) ) ;
DFFSXL \meas_val_n_reg[0] ( .D ( n923 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[0] ) ) ;
DFFSX1 overrange_acc_reg ( .D ( n826 ) , .CK ( ZCTSNET_391 ) , .SN ( rst_n ) , 
    .QN ( overrange_acc ) ) ;
DFFSXL orr_r_reg ( .D ( n893 ) , .CK ( net1821 ) , .SN ( HFSNET_330 ) , 
    .QN ( orr_r ) ) ;
DFFSXL \wr_idx_r_reg[2] ( .D ( N1787 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_330 ) , .Q ( wr_idx_r[2] ) , .QN ( n2159 ) ) ;
DFFSXL \shadow_weights_reg[2][10] ( .D ( gre_a_INV_6_47 ) , 
    .CK ( ZCTSNET_380 ) , .SN ( HFSNET_351 ) , .Q ( \shadow_weights[2][10] ) ) ;
DFFSXL \shadow_weights_reg[0][8] ( .D ( calc_result_r[8] ) , 
    .CK ( ZCTSNET_369 ) , .SN ( HFSNET_355 ) , .Q ( \shadow_weights[0][8] ) ) ;
DFFSXL \shadow_weights_reg[1][9] ( .D ( calc_result_r[9] ) , 
    .CK ( ZCTSNET_379 ) , .SN ( HFSNET_334 ) , .Q ( \shadow_weights[1][9] ) ) ;
DFFSXL \shadow_weights_reg[5][13] ( .D ( gre_a_INV_6_48 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .Q ( \shadow_weights[5][13] ) ) ;
DFFSXL \shadow_weights_reg[4][12] ( .D ( gre_a_INV_6_49 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_331 ) , .Q ( \shadow_weights[4][12] ) ) ;
SNPS_CLOCK_GATE_HIGH_sar_calib_ctrl_serial_20_30_16_32_5_256_1_1_1_2 clk_gate_temp_acc_reg_0 ( 
    .CLK ( ZCTSNET_389 ) , .EN ( n2328 ) , .ENCLK ( n2326 ) , .TE ( 1'b0 ) , 
    .ZCTSNET_0 ( ZCTSNET_391 ) ) ;
DFFSX1 comp_out_r_reg ( .D ( HFSNET_112 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_345 ) , .Q ( n2233 ) ) ;
DFFSXL \temp_acc_reg[16] ( .D ( n2324 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2232 ) , .QN ( temp_acc[16] ) ) ;
DFFSXL \temp_acc_reg[17] ( .D ( n2325 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_347 ) , .Q ( n2231 ) , .QN ( temp_acc[17] ) ) ;
DFFSXL \temp_acc_reg[7] ( .D ( n2315 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2230 ) , .QN ( temp_acc[7] ) ) ;
DFFSXL \temp_acc_reg[15] ( .D ( n2323 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_347 ) , .Q ( n2229 ) , .QN ( temp_acc[15] ) ) ;
DFFSX1 \temp_acc_reg[4] ( .D ( n2312 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2228 ) , .QN ( temp_acc[4] ) ) ;
DFFSXL \temp_acc_reg[10] ( .D ( n2318 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_356 ) , .Q ( n2227 ) , .QN ( temp_acc[10] ) ) ;
DFFSXL \temp_acc_reg[12] ( .D ( n2320 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_347 ) , .Q ( n2226 ) , .QN ( temp_acc[12] ) ) ;
DFFSXL \temp_acc_reg[14] ( .D ( n2322 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_347 ) , .Q ( n2225 ) , .QN ( temp_acc[14] ) ) ;
DFFSXL \temp_acc_reg[6] ( .D ( n2314 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_356 ) , .Q ( n2224 ) , .QN ( temp_acc[6] ) ) ;
DFFSX1 \temp_acc_reg[8] ( .D ( n2316 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2223 ) , .QN ( temp_acc[8] ) ) ;
DFFSXL \temp_acc_reg[1] ( .D ( n2309 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2221 ) , .QN ( temp_acc[1] ) ) ;
DFFSXL \temp_acc_reg[3] ( .D ( n2311 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2220 ) , .QN ( temp_acc[3] ) ) ;
DFFSXL \temp_acc_reg[11] ( .D ( n2319 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_356 ) , .Q ( n2219 ) , .QN ( temp_acc[11] ) ) ;
DFFSXL \temp_acc_reg[13] ( .D ( n2321 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_347 ) , .Q ( n2218 ) , .QN ( temp_acc[13] ) ) ;
DFFSX1 \temp_acc_reg[2] ( .D ( n2310 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2217 ) , .QN ( temp_acc[2] ) ) ;
DFFSXL \temp_acc_reg[5] ( .D ( n2313 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_347 ) , .Q ( n2216 ) , .QN ( temp_acc[5] ) ) ;
DFFSXL \temp_acc_reg[29] ( .D ( n2340 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_360 ) , .Q ( n2214 ) , .QN ( temp_acc[29] ) ) ;
DFFSXL \accumulator_reg[35] ( .D ( n929 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .Q ( n2201 ) , .QN ( accumulator[35] ) ) ;
DFFSXL \accumulator_reg[34] ( .D ( n930 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .Q ( n2200 ) , .QN ( accumulator[34] ) ) ;
DFFSXL \accumulator_reg[33] ( .D ( n931 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_330 ) , .Q ( n2198 ) , .QN ( accumulator[33] ) ) ;
DFFSX1 \sar_ptr_reg[2] ( .D ( n793 ) , .CK ( net1781 ) , .SN ( HFSNET_331 ) , 
    .Q ( n2197 ) , .QN ( sar_ptr[2] ) ) ;
DFFSXL \accumulator_reg[32] ( .D ( n932 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_330 ) , .Q ( n2196 ) , .QN ( accumulator[32] ) ) ;
DFFSXL \accumulator_reg[31] ( .D ( n933 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_330 ) , .Q ( n2195 ) , .QN ( accumulator[31] ) ) ;
DFFSXL \accumulator_reg[30] ( .D ( n934 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .Q ( n2194 ) , .QN ( accumulator[30] ) ) ;
DFFSXL \meas_val_n_reg[29] ( .D ( n894 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_362 ) , .Q ( n2193 ) ) ;
DFFSXL \sar_code_reg[19] ( .D ( n754 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_345 ) , .Q ( n2192 ) , .QN ( protected_sar_code[19] ) ) ;
DFFSXL \calc_cnt_reg[2] ( .D ( n971 ) , .CK ( net1811 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2176 ) , .QN ( calc_cnt[2] ) ) ;
DFFSXL \calc_cnt_reg[1] ( .D ( n972 ) , .CK ( net1811 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2174 ) , .QN ( calc_cnt[1] ) ) ;
DFFSXL \calc_cnt_reg[0] ( .D ( n973 ) , .CK ( net1811 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2173 ) , .QN ( calc_cnt[0] ) ) ;
DFFSXL \shadow_weights_reg[17][29] ( .D ( n2307 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_361 ) , .Q ( n2170 ) , .QN ( \shadow_weights[17][29] ) ) ;
DFFSXL \meas_val_p_reg[29] ( .D ( n894 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_362 ) , .Q ( n2169 ) ) ;
DFFSXL \wr_idx_r_reg[0] ( .D ( n892 ) , .CK ( net1821 ) , .SN ( HFSNET_346 ) , 
    .Q ( n2162 ) , .QN ( wr_idx_r[0] ) ) ;
DFFSX1 calib_done_pulse_reg ( .D ( n823 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( rst_n ) , .QN ( calib_done_pulse ) ) ;
DFFSX1 w_wr_en_reg ( .D ( n815 ) , .CK ( ZCTSNET_391 ) , .SN ( HFSNET_361 ) , 
    .QN ( w_wr_en ) ) ;
DFFSXL \w_wr_addr_reg[0] ( .D ( HFSNET_228 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_addr[0] ) ) ;
DFFSXL \w_wr_data_reg[11] ( .D ( HFSNET_288 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_354 ) , .QN ( w_wr_data[11] ) ) ;
DFFSXL \w_wr_data_reg[10] ( .D ( gre_a_INV_1810_47 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_354 ) , .QN ( w_wr_data[10] ) ) ;
DFFSXL \w_wr_data_reg[9] ( .D ( gre_a_BUF_1102_49 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_354 ) , .QN ( w_wr_data[9] ) ) ;
DFFSXL \w_wr_data_reg[8] ( .D ( n70 ) , .CK ( net1796 ) , .SN ( HFSNET_354 ) , 
    .QN ( w_wr_data[8] ) ) ;
DFFSXL \w_wr_data_reg[7] ( .D ( HFSNET_320 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_351 ) , .QN ( w_wr_data[7] ) ) ;
DFFSXL \w_wr_data_reg[6] ( .D ( HFSNET_317 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[6] ) ) ;
DFFSXL \w_wr_data_reg[5] ( .D ( HFSNET_316 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[5] ) ) ;
DFFSXL \w_wr_data_reg[4] ( .D ( HFSNET_315 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_351 ) , .QN ( w_wr_data[4] ) ) ;
DFFSXL \w_wr_data_reg[3] ( .D ( HFSNET_314 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_354 ) , .QN ( w_wr_data[3] ) ) ;
DFFSXL \w_wr_data_reg[2] ( .D ( HFSNET_313 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_353 ) , .QN ( w_wr_data[2] ) ) ;
DFFSXL \w_wr_data_reg[1] ( .D ( HFSNET_308 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[1] ) ) ;
DFFSXL \w_wr_data_reg[0] ( .D ( HFSNET_297 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_353 ) , .QN ( w_wr_data[0] ) ) ;
DFFSX1 \w_wr_addr_reg[4] ( .D ( n65 ) , .CK ( net1791 ) , .SN ( HFSNET_355 ) , 
    .QN ( w_wr_addr[4] ) ) ;
DFFSXL \w_wr_addr_reg[3] ( .D ( n2160 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_addr[3] ) ) ;
DFFSXL \w_wr_addr_reg[2] ( .D ( HFSNET_271 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_addr[2] ) ) ;
DFFSXL \w_wr_addr_reg[1] ( .D ( n2177 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_addr[1] ) ) ;
DFFSXL \w_wr_data_reg[14] ( .D ( HFSNET_298 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_354 ) , .QN ( w_wr_data[14] ) ) ;
DFFSXL \w_wr_data_reg[13] ( .D ( gre_a_INV_1726_48 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_353 ) , .QN ( w_wr_data[13] ) ) ;
DFFSXL \w_wr_data_reg[12] ( .D ( gre_a_INV_1764_49 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_353 ) , .QN ( w_wr_data[12] ) ) ;
DFFSX1 \w_wr_data_reg[29] ( .D ( n2307 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[29] ) ) ;
DFFSXL \w_wr_data_reg[28] ( .D ( HFSNET_312 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[28] ) ) ;
DFFSX1 \w_wr_data_reg[27] ( .D ( n2305 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_350 ) , .QN ( w_wr_data[27] ) ) ;
DFFSXL \w_wr_data_reg[26] ( .D ( n71 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_350 ) , .QN ( w_wr_data[26] ) ) ;
DFFSX1 \w_wr_data_reg[25] ( .D ( n2304 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[25] ) ) ;
DFFSXL \w_wr_data_reg[24] ( .D ( HFSNET_311 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_350 ) , .QN ( w_wr_data[24] ) ) ;
DFFSXL \w_wr_data_reg[23] ( .D ( HFSNET_310 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[23] ) ) ;
DFFSXL \w_wr_data_reg[22] ( .D ( HFSNET_309 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[22] ) ) ;
DFFSXL \w_wr_data_reg[21] ( .D ( n2300 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_350 ) , .QN ( w_wr_data[21] ) ) ;
DFFSX1 \w_wr_data_reg[20] ( .D ( n2299 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[20] ) ) ;
DFFSXL \w_wr_data_reg[19] ( .D ( HFSNET_304 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[19] ) ) ;
DFFSXL \w_wr_data_reg[18] ( .D ( HFSNET_303 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[18] ) ) ;
DFFSXL \w_wr_data_reg[17] ( .D ( HFSNET_302 ) , .CK ( net1791 ) , 
    .SN ( HFSNET_355 ) , .QN ( w_wr_data[17] ) ) ;
DFFSXL \w_wr_data_reg[16] ( .D ( HFSNET_301 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_354 ) , .QN ( w_wr_data[16] ) ) ;
DFFSXL \w_wr_data_reg[15] ( .D ( HFSNET_299 ) , .CK ( net1796 ) , 
    .SN ( HFSNET_354 ) , .QN ( w_wr_data[15] ) ) ;
DFFSX1 calib_done_reg ( .D ( n774 ) , .CK ( net1761 ) , .SN ( rst_n ) , 
    .QN ( calib_done ) ) ;
DFFSX1 calib_mode_en_reg ( .D ( n968 ) , .CK ( net1761 ) , .SN ( rst_n ) , 
    .QN ( calib_mode_en ) ) ;
DFFSXL \shadow_weights_reg[17][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][17] ) ) ;
DFFSXL \accumulator_reg[20] ( .D ( n944 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_348 ) , .QN ( accumulator[20] ) ) ;
DFFSXL \meas_val_n_reg[20] ( .D ( n903 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[20] ) ) ;
DFFSXL \shadow_weights_reg[17][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][16] ) ) ;
DFFSXL \meas_val_n_reg[19] ( .D ( n904 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[19] ) ) ;
DFFSXL \meas_val_p_reg[0] ( .D ( n923 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[0] ) ) ;
DFFSXL \accumulator_reg[0] ( .D ( n962 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[0] ) ) ;
DFFSXL \meas_val_p_reg[3] ( .D ( n920 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[3] ) ) ;
DFFSXL \meas_val_n_reg[3] ( .D ( n920 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[3] ) ) ;
DFFSXL \meas_val_p_reg[1] ( .D ( n922 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[1] ) ) ;
DFFSXL \meas_val_p_reg[11] ( .D ( n912 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[11] ) ) ;
DFFSXL \meas_val_n_reg[11] ( .D ( n912 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_n[11] ) ) ;
DFFSXL \shadow_weights_reg[17][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][15] ) ) ;
DFFSXL \accumulator_reg[11] ( .D ( n952 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_348 ) , .QN ( accumulator[11] ) ) ;
DFFSXL \accumulator_reg[1] ( .D ( n961 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[1] ) ) ;
DFFSXL \shadow_weights_reg[17][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][7] ) ) ;
DFFSXL \meas_val_p_reg[10] ( .D ( n913 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[10] ) ) ;
DFFSXL \meas_val_n_reg[10] ( .D ( n913 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[10] ) ) ;
DFFSXL \accumulator_reg[10] ( .D ( n953 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_348 ) , .QN ( accumulator[10] ) ) ;
DFFSXL \meas_val_p_reg[6] ( .D ( n917 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[6] ) ) ;
DFFSXL \meas_val_p_reg[14] ( .D ( n909 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[14] ) ) ;
DFFSXL \meas_val_n_reg[6] ( .D ( n917 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[6] ) ) ;
DFFSXL \meas_val_n_reg[14] ( .D ( n909 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[14] ) ) ;
DFFSXL \accumulator_reg[6] ( .D ( n957 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_348 ) , .QN ( accumulator[6] ) ) ;
DFFSXL \accumulator_reg[14] ( .D ( n950 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[14] ) ) ;
DFFSXL \meas_val_p_reg[13] ( .D ( n910 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[13] ) ) ;
DFFSXL \meas_val_p_reg[7] ( .D ( n916 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[7] ) ) ;
DFFSXL \meas_val_n_reg[13] ( .D ( n910 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_n[13] ) ) ;
DFFSXL \meas_val_n_reg[7] ( .D ( n916 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[7] ) ) ;
DFFSX1 \accumulator_reg[13] ( .D ( n818 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_348 ) , .QN ( accumulator[13] ) ) ;
DFFSXL \accumulator_reg[7] ( .D ( n956 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[7] ) ) ;
DFFSXL \meas_val_n_reg[4] ( .D ( n919 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[4] ) ) ;
DFFSXL \meas_val_p_reg[4] ( .D ( n919 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[4] ) ) ;
DFFSXL \accumulator_reg[12] ( .D ( n951 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_348 ) , .QN ( accumulator[12] ) ) ;
DFFSXL \meas_val_n_reg[12] ( .D ( n911 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_n[12] ) ) ;
DFFSXL \meas_val_p_reg[12] ( .D ( n911 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[12] ) ) ;
DFFSXL \meas_val_n_reg[9] ( .D ( n914 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[9] ) ) ;
DFFSXL \meas_val_p_reg[9] ( .D ( n914 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_p[9] ) ) ;
DFFSXL \accumulator_reg[18] ( .D ( n946 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_349 ) , .QN ( accumulator[18] ) ) ;
DFFSXL \meas_val_n_reg[5] ( .D ( n918 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[5] ) ) ;
DFFSXL \meas_val_p_reg[5] ( .D ( n918 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[5] ) ) ;
DFFSXL \accumulator_reg[15] ( .D ( n949 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_347 ) , .QN ( accumulator[15] ) ) ;
DFFSXL \temp_acc_reg[9] ( .D ( n2317 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2215 ) , .QN ( temp_acc[9] ) ) ;
DFFSXL \meas_val_p_reg[18] ( .D ( n905 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[18] ) ) ;
DFFSXL \accumulator_reg[8] ( .D ( n955 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_349 ) , .QN ( accumulator[8] ) ) ;
DFFSXL \meas_val_p_reg[8] ( .D ( n915 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[8] ) ) ;
DFFSXL \meas_val_p_reg[15] ( .D ( n908 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[15] ) ) ;
DFFSXL \meas_val_n_reg[2] ( .D ( n921 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_n[2] ) ) ;
DFFSXL \meas_val_p_reg[2] ( .D ( n921 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[2] ) ) ;
DFFSXL \accumulator_reg[16] ( .D ( n948 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_348 ) , .QN ( accumulator[16] ) ) ;
DFFSXL \meas_val_p_reg[16] ( .D ( n907 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_347 ) , .QN ( meas_val_p[16] ) ) ;
DFFSXL \accumulator_reg[17] ( .D ( n947 ) , .CK ( net1776 ) , 
    .SN ( HFSNET_348 ) , .QN ( accumulator[17] ) ) ;
DFFSXL \meas_val_p_reg[17] ( .D ( n906 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_p[17] ) ) ;
DFFSXL \meas_val_p_reg[19] ( .D ( n904 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_p[19] ) ) ;
DFFSXL \meas_val_n_reg[15] ( .D ( n908 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_n[15] ) ) ;
DFFSXL \temp_acc_reg[0] ( .D ( n2308 ) , .CK ( ZCTSNET_388 ) , 
    .SN ( HFSNET_357 ) , .Q ( n2222 ) , .QN ( temp_acc[0] ) ) ;
DFFSX1 \state_reg[2] ( .D ( n819 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_345 ) , .Q ( n68 ) , .QN ( state[2] ) ) ;
DFFSXL \shadow_weights_reg[15][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[15][15] ) ) ;
DFFSXL \shadow_weights_reg[11][15] ( .D ( HFSNET_299 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][15] ) ) ;
DFFSXL \shadow_weights_reg[4][15] ( .D ( HFSNET_299 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[4][15] ) ) ;
DFFSXL \shadow_weights_reg[18][15] ( .D ( HFSNET_299 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[18][15] ) ) ;
DFFSXL \shadow_weights_reg[16][15] ( .D ( HFSNET_299 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[16][15] ) ) ;
DFFSXL \shadow_weights_reg[15][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_353 ) , .QN ( \shadow_weights[15][16] ) ) ;
DFFSXL \shadow_weights_reg[11][16] ( .D ( HFSNET_301 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[11][16] ) ) ;
DFFSXL \shadow_weights_reg[4][16] ( .D ( HFSNET_301 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[4][16] ) ) ;
DFFSXL \shadow_weights_reg[18][16] ( .D ( HFSNET_301 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][16] ) ) ;
DFFSXL \shadow_weights_reg[16][16] ( .D ( HFSNET_301 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][16] ) ) ;
DFFSXL \shadow_weights_reg[15][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[15][17] ) ) ;
DFFSXL \shadow_weights_reg[11][17] ( .D ( HFSNET_302 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[11][17] ) ) ;
DFFSXL \shadow_weights_reg[4][17] ( .D ( HFSNET_302 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[4][17] ) ) ;
DFFSXL \shadow_weights_reg[18][17] ( .D ( HFSNET_302 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][17] ) ) ;
DFFSXL \shadow_weights_reg[16][17] ( .D ( HFSNET_302 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][17] ) ) ;
DFFSXL \shadow_weights_reg[15][29] ( .D ( n2307 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[15][29] ) ) ;
DFFSXL \shadow_weights_reg[11][29] ( .D ( n2307 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[11][29] ) ) ;
DFFSXL \shadow_weights_reg[4][29] ( .D ( n2307 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[4][29] ) ) ;
DFFSXL \shadow_weights_reg[18][29] ( .D ( n2307 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[18][29] ) ) ;
DFFSXL \shadow_weights_reg[16][29] ( .D ( n2307 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[16][29] ) ) ;
DFFSXL \shadow_weights_reg[15][7] ( .D ( HFSNET_320 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_352 ) , .QN ( \shadow_weights[15][7] ) ) ;
DFFSXL \shadow_weights_reg[11][7] ( .D ( HFSNET_320 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][7] ) ) ;
DFFSXL \shadow_weights_reg[4][7] ( .D ( HFSNET_320 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[4][7] ) ) ;
DFFSXL \shadow_weights_reg[18][7] ( .D ( HFSNET_320 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][7] ) ) ;
DFFSXL \shadow_weights_reg[16][7] ( .D ( HFSNET_320 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][7] ) ) ;
DFFSX1 \calc_result_r_reg[26] ( .D ( n833 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_361 ) , .Q ( n71 ) ) ;
DFFSXL \shadow_weights_reg[15][26] ( .D ( ZBUF_754_28 ) , 
    .CK ( ZCTSNET_374 ) , .SN ( HFSNET_344 ) , 
    .QN ( \shadow_weights[15][26] ) ) ;
DFFSXL \shadow_weights_reg[11][26] ( .D ( ZBUF_754_28 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[11][26] ) ) ;
DFFSXL \shadow_weights_reg[4][26] ( .D ( ZBUF_754_28 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[4][26] ) ) ;
DFFSXL \shadow_weights_reg[18][26] ( .D ( n71 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[18][26] ) ) ;
DFFSXL \shadow_weights_reg[16][26] ( .D ( n71 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[16][26] ) ) ;
DFFSXL \shadow_weights_reg[15][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[15][18] ) ) ;
DFFSXL \shadow_weights_reg[11][18] ( .D ( HFSNET_303 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[11][18] ) ) ;
DFFSXL \shadow_weights_reg[4][18] ( .D ( HFSNET_303 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[4][18] ) ) ;
DFFSXL \shadow_weights_reg[18][18] ( .D ( HFSNET_303 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[18][18] ) ) ;
DFFSXL \shadow_weights_reg[16][18] ( .D ( HFSNET_303 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][18] ) ) ;
DFFSXL \shadow_weights_reg[15][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[15][19] ) ) ;
DFFSXL \shadow_weights_reg[11][19] ( .D ( HFSNET_304 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[11][19] ) ) ;
DFFSXL \shadow_weights_reg[4][19] ( .D ( HFSNET_304 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[4][19] ) ) ;
DFFSXL \shadow_weights_reg[18][19] ( .D ( HFSNET_304 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[18][19] ) ) ;
DFFSXL \shadow_weights_reg[16][19] ( .D ( HFSNET_304 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][19] ) ) ;
DFFSXL \shadow_weights_reg[15][20] ( .D ( n2299 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[15][20] ) ) ;
DFFSXL \shadow_weights_reg[11][20] ( .D ( n2299 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[11][20] ) ) ;
DFFSXL \shadow_weights_reg[4][20] ( .D ( n2299 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[4][20] ) ) ;
DFFSXL \shadow_weights_reg[18][20] ( .D ( n2299 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[18][20] ) ) ;
DFFSXL \shadow_weights_reg[16][20] ( .D ( n2299 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[16][20] ) ) ;
DFFSXL \shadow_weights_reg[15][21] ( .D ( n2300 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[15][21] ) ) ;
DFFSXL \shadow_weights_reg[11][21] ( .D ( n2300 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[11][21] ) ) ;
DFFSXL \shadow_weights_reg[4][21] ( .D ( n2300 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[4][21] ) ) ;
DFFSXL \shadow_weights_reg[18][21] ( .D ( n2300 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[18][21] ) ) ;
DFFSXL \shadow_weights_reg[16][21] ( .D ( n2300 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[16][21] ) ) ;
DFFSXL \shadow_weights_reg[15][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_333 ) , .QN ( \shadow_weights[15][22] ) ) ;
DFFSXL \shadow_weights_reg[11][22] ( .D ( HFSNET_309 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[11][22] ) ) ;
DFFSXL \shadow_weights_reg[4][22] ( .D ( HFSNET_309 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[4][22] ) ) ;
DFFSXL \shadow_weights_reg[18][22] ( .D ( HFSNET_309 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[18][22] ) ) ;
DFFSXL \shadow_weights_reg[16][22] ( .D ( HFSNET_309 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][22] ) ) ;
DFFSXL \shadow_weights_reg[15][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[15][23] ) ) ;
DFFSXL \shadow_weights_reg[11][23] ( .D ( HFSNET_310 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[11][23] ) ) ;
DFFSXL \shadow_weights_reg[4][23] ( .D ( HFSNET_310 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[4][23] ) ) ;
DFFSXL \shadow_weights_reg[18][23] ( .D ( HFSNET_310 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[18][23] ) ) ;
DFFSXL \shadow_weights_reg[16][23] ( .D ( HFSNET_310 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][23] ) ) ;
DFFSXL \shadow_weights_reg[15][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[15][24] ) ) ;
DFFSXL \shadow_weights_reg[11][24] ( .D ( HFSNET_311 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[11][24] ) ) ;
DFFSXL \shadow_weights_reg[4][24] ( .D ( HFSNET_311 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[4][24] ) ) ;
DFFSXL \shadow_weights_reg[18][24] ( .D ( HFSNET_311 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_360 ) , .QN ( \shadow_weights[18][24] ) ) ;
DFFSXL \shadow_weights_reg[16][24] ( .D ( HFSNET_311 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][24] ) ) ;
DFFSXL \shadow_weights_reg[15][25] ( .D ( n2304 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[15][25] ) ) ;
DFFSXL \shadow_weights_reg[11][25] ( .D ( n2304 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[11][25] ) ) ;
DFFSXL \shadow_weights_reg[4][25] ( .D ( n2304 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[4][25] ) ) ;
DFFSXL \shadow_weights_reg[18][25] ( .D ( n2304 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[18][25] ) ) ;
DFFSXL \shadow_weights_reg[16][25] ( .D ( n2304 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[16][25] ) ) ;
DFFSXL \shadow_weights_reg[15][27] ( .D ( n2305 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[15][27] ) ) ;
DFFSXL \shadow_weights_reg[11][27] ( .D ( n2305 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[11][27] ) ) ;
DFFSXL \shadow_weights_reg[4][27] ( .D ( n2305 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[4][27] ) ) ;
DFFSXL \shadow_weights_reg[18][27] ( .D ( n2305 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[18][27] ) ) ;
DFFSXL \shadow_weights_reg[16][27] ( .D ( n2305 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[16][27] ) ) ;
DFFSXL \shadow_weights_reg[15][28] ( .D ( HFSNET_312 ) , .CK ( ZCTSNET_374 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[15][28] ) ) ;
DFFSXL \shadow_weights_reg[11][28] ( .D ( HFSNET_312 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[11][28] ) ) ;
DFFSXL \shadow_weights_reg[4][28] ( .D ( HFSNET_312 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[4][28] ) ) ;
DFFSXL \shadow_weights_reg[18][28] ( .D ( HFSNET_312 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[18][28] ) ) ;
DFFSXL \shadow_weights_reg[16][28] ( .D ( HFSNET_312 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_346 ) , .QN ( \shadow_weights[16][28] ) ) ;
DFFSXL \shadow_weights_reg[11][14] ( .D ( HFSNET_298 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][14] ) ) ;
DFFSXL \shadow_weights_reg[4][14] ( .D ( HFSNET_298 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[4][14] ) ) ;
DFFSXL \shadow_weights_reg[18][14] ( .D ( HFSNET_298 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][14] ) ) ;
DFFSXL \shadow_weights_reg[16][14] ( .D ( HFSNET_298 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][14] ) ) ;
DFFSXL \shadow_weights_reg[17][14] ( .D ( HFSNET_298 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][14] ) ) ;
DFFSXL \shadow_weights_reg[11][0] ( .D ( HFSNET_297 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][0] ) ) ;
DFFSXL \shadow_weights_reg[4][0] ( .D ( HFSNET_297 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[4][0] ) ) ;
DFFSXL \shadow_weights_reg[18][0] ( .D ( HFSNET_297 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][0] ) ) ;
DFFSXL \shadow_weights_reg[16][0] ( .D ( HFSNET_297 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][0] ) ) ;
DFFSXL \shadow_weights_reg[17][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][0] ) ) ;
DFFSXL \shadow_weights_reg[11][1] ( .D ( HFSNET_308 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[11][1] ) ) ;
DFFSXL \shadow_weights_reg[4][1] ( .D ( HFSNET_308 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[4][1] ) ) ;
DFFSXL \shadow_weights_reg[18][1] ( .D ( HFSNET_308 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][1] ) ) ;
DFFSXL \shadow_weights_reg[16][1] ( .D ( HFSNET_308 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[16][1] ) ) ;
DFFSXL \shadow_weights_reg[17][1] ( .D ( HFSNET_308 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[17][1] ) ) ;
DFFSXL \shadow_weights_reg[11][2] ( .D ( HFSNET_313 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][2] ) ) ;
DFFSXL \shadow_weights_reg[4][2] ( .D ( HFSNET_313 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[4][2] ) ) ;
DFFSXL \shadow_weights_reg[18][2] ( .D ( HFSNET_313 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][2] ) ) ;
DFFSXL \shadow_weights_reg[16][2] ( .D ( HFSNET_313 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][2] ) ) ;
DFFSXL \shadow_weights_reg[17][2] ( .D ( HFSNET_313 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][2] ) ) ;
DFFSXL \shadow_weights_reg[11][3] ( .D ( HFSNET_314 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][3] ) ) ;
DFFSXL \shadow_weights_reg[4][3] ( .D ( HFSNET_314 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[4][3] ) ) ;
DFFSXL \shadow_weights_reg[18][3] ( .D ( HFSNET_314 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][3] ) ) ;
DFFSXL \shadow_weights_reg[16][3] ( .D ( HFSNET_314 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][3] ) ) ;
DFFSXL \shadow_weights_reg[17][3] ( .D ( HFSNET_314 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][3] ) ) ;
DFFSXL \shadow_weights_reg[11][4] ( .D ( HFSNET_315 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][4] ) ) ;
DFFSXL \shadow_weights_reg[4][4] ( .D ( HFSNET_315 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[4][4] ) ) ;
DFFSXL \shadow_weights_reg[18][4] ( .D ( HFSNET_315 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][4] ) ) ;
DFFSXL \shadow_weights_reg[16][4] ( .D ( HFSNET_315 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][4] ) ) ;
DFFSXL \shadow_weights_reg[17][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[17][4] ) ) ;
DFFSXL \shadow_weights_reg[11][5] ( .D ( HFSNET_316 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][5] ) ) ;
DFFSXL \shadow_weights_reg[4][5] ( .D ( HFSNET_316 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[4][5] ) ) ;
DFFSXL \shadow_weights_reg[18][5] ( .D ( HFSNET_316 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][5] ) ) ;
DFFSXL \shadow_weights_reg[16][5] ( .D ( HFSNET_316 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[16][5] ) ) ;
DFFSXL \shadow_weights_reg[17][5] ( .D ( HFSNET_316 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][5] ) ) ;
DFFSXL \shadow_weights_reg[11][6] ( .D ( HFSNET_317 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][6] ) ) ;
DFFSXL \shadow_weights_reg[4][6] ( .D ( HFSNET_317 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[4][6] ) ) ;
DFFSXL \shadow_weights_reg[18][6] ( .D ( HFSNET_317 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][6] ) ) ;
DFFSXL \shadow_weights_reg[16][6] ( .D ( HFSNET_317 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][6] ) ) ;
DFFSXL \shadow_weights_reg[17][6] ( .D ( HFSNET_317 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[17][6] ) ) ;
DFFSX4 \calc_result_r_reg[8] ( .D ( n851 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_358 ) , .Q ( n70 ) , .QN ( calc_result_r[8] ) ) ;
DFFSXL \shadow_weights_reg[11][8] ( .D ( n70 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][8] ) ) ;
DFFSXL \shadow_weights_reg[4][8] ( .D ( n70 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[4][8] ) ) ;
DFFSXL \shadow_weights_reg[18][8] ( .D ( n70 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][8] ) ) ;
DFFSXL \shadow_weights_reg[16][8] ( .D ( n70 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][8] ) ) ;
DFFSXL \shadow_weights_reg[17][8] ( .D ( n70 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][8] ) ) ;
DFFSX1 \calc_result_r_reg[9] ( .D ( n850 ) , .CK ( ZCTSNET_366 ) , 
    .SN ( HFSNET_358 ) , .Q ( n69 ) , .QN ( calc_result_r[9] ) ) ;
DFFSXL \shadow_weights_reg[11][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( net1716 ) , .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][9] ) ) ;
DFFSXL \shadow_weights_reg[4][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( net1681 ) , .SN ( HFSNET_340 ) , .QN ( \shadow_weights[4][9] ) ) ;
DFFSXL \shadow_weights_reg[18][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( net1751 ) , .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][9] ) ) ;
DFFSXL \shadow_weights_reg[16][9] ( .D ( n69 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_358 ) , .QN ( \shadow_weights[16][9] ) ) ;
DFFSXL \shadow_weights_reg[17][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_376 ) , .SN ( HFSNET_357 ) , 
    .QN ( \shadow_weights[17][9] ) ) ;
DFFSXL \shadow_weights_reg[15][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_374 ) , .SN ( HFSNET_333 ) , 
    .QN ( \shadow_weights[15][12] ) ) ;
DFFSXL \shadow_weights_reg[11][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( net1716 ) , .SN ( HFSNET_334 ) , .QN ( \shadow_weights[11][12] ) ) ;
DFFSXL \shadow_weights_reg[18][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( net1751 ) , .SN ( HFSNET_356 ) , .QN ( \shadow_weights[18][12] ) ) ;
DFFSXL \shadow_weights_reg[16][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( net1741 ) , .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][12] ) ) ;
DFFSXL \shadow_weights_reg[17][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( ZCTSNET_376 ) , .SN ( HFSNET_361 ) , 
    .QN ( \shadow_weights[17][12] ) ) ;
DFFSXL \shadow_weights_reg[11][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( net1716 ) , .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][13] ) ) ;
DFFSXL \shadow_weights_reg[4][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( net1681 ) , .SN ( HFSNET_343 ) , .QN ( \shadow_weights[4][13] ) ) ;
DFFSXL \shadow_weights_reg[18][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( net1751 ) , .SN ( HFSNET_356 ) , .QN ( \shadow_weights[18][13] ) ) ;
DFFSXL \shadow_weights_reg[16][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( net1741 ) , .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][13] ) ) ;
DFFSXL \shadow_weights_reg[17][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( ZCTSNET_376 ) , .SN ( HFSNET_356 ) , 
    .QN ( \shadow_weights[17][13] ) ) ;
DFFSXL \shadow_weights_reg[11][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1716 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[11][10] ) ) ;
DFFSXL \shadow_weights_reg[4][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1681 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[4][10] ) ) ;
DFFSXL \shadow_weights_reg[18][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1751 ) , .SN ( HFSNET_357 ) , .QN ( \shadow_weights[18][10] ) ) ;
DFFSXL \shadow_weights_reg[16][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( net1741 ) , .SN ( HFSNET_357 ) , .QN ( \shadow_weights[16][10] ) ) ;
DFFSXL \shadow_weights_reg[17][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_376 ) , .SN ( HFSNET_356 ) , 
    .QN ( \shadow_weights[17][10] ) ) ;
DFFSXL \shadow_weights_reg[11][11] ( .D ( HFSNET_288 ) , .CK ( net1716 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[11][11] ) ) ;
DFFSXL \shadow_weights_reg[4][11] ( .D ( HFSNET_288 ) , .CK ( net1681 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[4][11] ) ) ;
DFFSXL \shadow_weights_reg[18][11] ( .D ( HFSNET_288 ) , .CK ( net1751 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[18][11] ) ) ;
DFFSXL \shadow_weights_reg[16][11] ( .D ( HFSNET_288 ) , .CK ( net1741 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[16][11] ) ) ;
DFFSXL \shadow_weights_reg[17][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_376 ) , 
    .SN ( HFSNET_356 ) , .QN ( \shadow_weights[17][11] ) ) ;
DFFSX1 \calc_cnt_reg[3] ( .D ( n970 ) , .CK ( net1811 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2175 ) , .QN ( calc_cnt[3] ) ) ;
DFFSX1 \calc_cnt_reg[4] ( .D ( n969 ) , .CK ( net1811 ) , .SN ( HFSNET_344 ) , 
    .Q ( n2161 ) , .QN ( calc_cnt[4] ) ) ;
DFFSX2 \wr_idx_r_reg[1] ( .D ( N1786 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_346 ) , .Q ( wr_idx_r[1] ) , .QN ( n2177 ) ) ;
DFFSX2 \target_bit_reg[2] ( .D ( N1491 ) , .CK ( net1766 ) , .SN ( rst_n ) , 
    .Q ( target_bit[2] ) , .QN ( n2179 ) ) ;
DFFSX2 \target_bit_reg[4] ( .D ( n827 ) , .CK ( net1766 ) , .SN ( rst_n ) , 
    .Q ( n2178 ) , .QN ( target_bit[4] ) ) ;
DFFSX1 \target_bit_reg[3] ( .D ( n828 ) , .CK ( net1766 ) , .SN ( rst_n ) , 
    .Q ( n2202 ) , .QN ( target_bit[3] ) ) ;
DFFSX2 \overrange_bits_reg[10] ( .D ( n707 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_363 ) , .QN ( overrange_bits[10] ) ) ;
DFFSX1 \overrange_bits_reg[11] ( .D ( n706 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[11] ) ) ;
DFFSX1 \overrange_bits_reg[12] ( .D ( n705 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[12] ) ) ;
DFFSX1 \overrange_bits_reg[13] ( .D ( n704 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_363 ) , .QN ( overrange_bits[13] ) ) ;
DFFSX1 \overrange_bits_reg[14] ( .D ( n703 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( aps_rename_5_ ) ) ;
DFFSX1 \overrange_bits_reg[15] ( .D ( n702 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_363 ) , .QN ( aps_rename_4_ ) ) ;
DFFSX2 \wr_idx_r_reg[3] ( .D ( n891 ) , .CK ( net1821 ) , .SN ( HFSNET_346 ) , 
    .Q ( n2160 ) , .QN ( wr_idx_r[3] ) ) ;
DFFSX1 \target_bit_reg[1] ( .D ( N1490 ) , .CK ( net1766 ) , .SN ( rst_n ) , 
    .Q ( target_bit[1] ) , .QN ( n2158 ) ) ;
DFFSX2 \overrange_bits_reg[0] ( .D ( n717 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[0] ) ) ;
DFFSX2 \overrange_bits_reg[1] ( .D ( n716 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[1] ) ) ;
DFFSX2 \overrange_bits_reg[2] ( .D ( n715 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[2] ) ) ;
DFFSXL \meas_val_n_reg[18] ( .D ( n905 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_n[18] ) ) ;
DFFSXL \meas_val_n_reg[8] ( .D ( n915 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[8] ) ) ;
DFFSXL \meas_val_n_reg[16] ( .D ( n907 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_348 ) , .QN ( meas_val_n[16] ) ) ;
DFFSXL \meas_val_n_reg[17] ( .D ( n906 ) , .CK ( net1806 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_n[17] ) ) ;
DFFSX1 \overrange_bits_reg[7] ( .D ( n710 ) , .CK ( net1766 ) , 
    .SN ( rst_n ) , .QN ( aps_rename_6_ ) ) ;
DFFSX2 \target_bit_reg[0] ( .D ( n829 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .Q ( n2163 ) , .QN ( target_bit[0] ) ) ;
DFFSXL \meas_val_p_reg[20] ( .D ( n903 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_349 ) , .QN ( meas_val_p[20] ) ) ;
DFFSX2 \wr_idx_r_reg[4] ( .D ( n890 ) , .CK ( net1821 ) , .SN ( HFSNET_346 ) , 
    .Q ( n65 ) , .QN ( wr_idx_r[4] ) ) ;
DFFSX1 \state_reg[0] ( .D ( n821 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_345 ) , .Q ( n2171 ) , .QN ( state[0] ) ) ;
DFFSX1 calib_overrange_reg ( .D ( n698 ) , .CK ( ZCTSNET_391 ) , 
    .SN ( HFSNET_330 ) , .QN ( aps_rename_1_ ) ) ;
DFFSX1 \overrange_bits_reg[6] ( .D ( n711 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[6] ) ) ;
DFFSX2 \overrange_bits_reg[8] ( .D ( n709 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_363 ) , .QN ( overrange_bits[8] ) ) ;
DFFSX1 \overrange_bits_reg[16] ( .D ( n701 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( aps_rename_3_ ) ) ;
DFFSX1 \overrange_bits_reg[17] ( .D ( n700 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( aps_rename_2_ ) ) ;
DFFSX1 \overrange_bits_reg[18] ( .D ( n699 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[18] ) ) ;
DFFSX1 \overrange_bits_reg[19] ( .D ( n697 ) , .CK ( net1761 ) , 
    .SN ( rst_n ) , .QN ( overrange_bits[19] ) ) ;
DFFSX2 \overrange_bits_reg[3] ( .D ( n714 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[3] ) ) ;
DFFSX1 \overrange_bits_reg[4] ( .D ( n713 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_330 ) , .QN ( overrange_bits[4] ) ) ;
DFFSX2 \overrange_bits_reg[5] ( .D ( n712 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_363 ) , .QN ( overrange_bits[5] ) ) ;
DFFSX2 \overrange_bits_reg[9] ( .D ( n708 ) , .CK ( net1766 ) , 
    .SN ( HFSNET_363 ) , .QN ( overrange_bits[9] ) ) ;
DFFSX1 \sar_code_reg[15] ( .D ( n758 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_331 ) , .Q ( n2182 ) , .QN ( protected_sar_code[15] ) ) ;
DFFSXL \sar_code_reg[7] ( .D ( n766 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .Q ( n2180 ) , .QN ( protected_sar_code[7] ) ) ;
DFFSX1 \sar_code_reg[9] ( .D ( n764 ) , .CK ( net1786 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2167 ) , .QN ( protected_sar_code[9] ) ) ;
DFFSX1 \sar_code_reg[11] ( .D ( n762 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_331 ) , .Q ( n2164 ) , .QN ( protected_sar_code[11] ) ) ;
DFFSXL \sar_code_reg[2] ( .D ( n771 ) , .CK ( net1786 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2165 ) , .QN ( protected_sar_code[2] ) ) ;
DFFSXL \sar_code_reg[6] ( .D ( n767 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .Q ( n2168 ) , .QN ( protected_sar_code[6] ) ) ;
DFFSX1 \sar_code_reg[10] ( .D ( n763 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_331 ) , .Q ( n2166 ) , .QN ( protected_sar_code[10] ) ) ;
DFFSX1 \sar_code_reg[1] ( .D ( n772 ) , .CK ( net1786 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2186 ) , .QN ( protected_sar_code[1] ) ) ;
DFFSX1 \sar_ptr_reg[0] ( .D ( n791 ) , .CK ( net1781 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2199 ) , .QN ( sar_ptr[0] ) ) ;
DFFSXL \sar_ptr_reg[1] ( .D ( n792 ) , .CK ( net1781 ) , .SN ( HFSNET_345 ) , 
    .QN ( sar_ptr[1] ) ) ;
DFFSX1 \sar_code_reg[3] ( .D ( n770 ) , .CK ( net1786 ) , .SN ( HFSNET_345 ) , 
    .Q ( n2181 ) , .QN ( protected_sar_code[3] ) ) ;
DFFSX1 \sar_code_reg[8] ( .D ( n765 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .Q ( n2183 ) , .QN ( protected_sar_code[8] ) ) ;
DFFSX1 \sar_code_reg[14] ( .D ( n759 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_331 ) , .Q ( n2184 ) , .QN ( protected_sar_code[14] ) ) ;
DFFSXL \avg_cnt_reg[4] ( .D ( n963 ) , .CK ( net1771 ) , .SN ( HFSNET_362 ) , 
    .QN ( avg_cnt[4] ) ) ;
DFFSXL \avg_rounded_r_reg[13] ( .D ( n882 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_348 ) , .QN ( avg_rounded_r[13] ) ) ;
DFFSXL \avg_rounded_r_reg[8] ( .D ( n887 ) , .CK ( net1821 ) , 
    .SN ( HFSNET_348 ) , .QN ( avg_rounded_r[8] ) ) ;
DFFSXL \shadow_weights_reg[2][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[2][4] ) ) ;
DFFSXL \shadow_weights_reg[3][0] ( .D ( HFSNET_297 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[3][0] ) ) ;
DFFSXL \shadow_weights_reg[7][9] ( .D ( gre_a_BUF_1102_49 ) , 
    .CK ( ZCTSNET_385 ) , .SN ( HFSNET_334 ) , .QN ( \shadow_weights[7][9] ) ) ;
DFFSXL \shadow_weights_reg[10][6] ( .D ( HFSNET_317 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[10][6] ) ) ;
DFFSXL \shadow_weights_reg[14][3] ( .D ( HFSNET_314 ) , .CK ( net1731 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[14][3] ) ) ;
DFFSXL \shadow_weights_reg[0][11] ( .D ( HFSNET_288 ) , .CK ( ZCTSNET_369 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[0][11] ) ) ;
DFFSXL \shadow_weights_reg[5][7] ( .D ( HFSNET_320 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_343 ) , .QN ( \shadow_weights[5][7] ) ) ;
DFFSXL \shadow_weights_reg[8][4] ( .D ( HFSNET_315 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_351 ) , .QN ( \shadow_weights[8][4] ) ) ;
DFFSXL \shadow_weights_reg[12][1] ( .D ( HFSNET_308 ) , .CK ( net1721 ) , 
    .SN ( HFSNET_339 ) , .QN ( \shadow_weights[12][1] ) ) ;
DFFSXL \shadow_weights_reg[1][10] ( .D ( gre_a_INV_1810_47 ) , 
    .CK ( ZCTSNET_379 ) , .SN ( HFSNET_338 ) , 
    .QN ( \shadow_weights[1][10] ) ) ;
DFFSXL \shadow_weights_reg[9][6] ( .D ( HFSNET_317 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_338 ) , .QN ( \shadow_weights[9][6] ) ) ;
DFFSXL \shadow_weights_reg[9][14] ( .D ( HFSNET_298 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_340 ) , .QN ( \shadow_weights[9][14] ) ) ;
DFFSXL \shadow_weights_reg[12][13] ( .D ( gre_a_INV_1726_48 ) , 
    .CK ( net1721 ) , .SN ( HFSNET_339 ) , .QN ( \shadow_weights[12][13] ) ) ;
DFFSXL \shadow_weights_reg[12][12] ( .D ( gre_a_INV_1764_49 ) , 
    .CK ( net1721 ) , .SN ( HFSNET_343 ) , .QN ( \shadow_weights[12][12] ) ) ;
DFFSXL \wait_cnt_reg[2] ( .D ( n925 ) , .CK ( net1786 ) , .SN ( HFSNET_331 ) , 
    .QN ( wait_cnt[2] ) ) ;
DFFSXL \shadow_weights_reg[2][29] ( .D ( n2307 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[2][29] ) ) ;
DFFSXL \shadow_weights_reg[5][28] ( .D ( HFSNET_312 ) , .CK ( net1686 ) , 
    .SN ( HFSNET_336 ) , .QN ( \shadow_weights[5][28] ) ) ;
DFFSXL \shadow_weights_reg[7][27] ( .D ( n2305 ) , .CK ( ZCTSNET_385 ) , 
    .SN ( HFSNET_342 ) , .QN ( \shadow_weights[7][27] ) ) ;
DFFSXL \shadow_weights_reg[8][26] ( .D ( ZBUF_754_28 ) , .CK ( ZCTSNET_386 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[8][26] ) ) ;
DFFSXL \shadow_weights_reg[10][25] ( .D ( n2304 ) , .CK ( net1711 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[10][25] ) ) ;
DFFSXL \shadow_weights_reg[13][24] ( .D ( HFSNET_311 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[13][24] ) ) ;
DFFSXL \shadow_weights_reg[19][23] ( .D ( HFSNET_310 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_361 ) , .QN ( \shadow_weights[19][23] ) ) ;
DFFSXL \accumulator_reg[28] ( .D ( n936 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .QN ( accumulator[28] ) ) ;
DFFSXL \shadow_weights_reg[2][22] ( .D ( HFSNET_309 ) , .CK ( ZCTSNET_380 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[2][22] ) ) ;
DFFSXL \shadow_weights_reg[6][21] ( .D ( n2300 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_344 ) , .QN ( \shadow_weights[6][21] ) ) ;
DFFSXL \shadow_weights_reg[9][20] ( .D ( n2299 ) , .CK ( net1706 ) , 
    .SN ( HFSNET_332 ) , .QN ( \shadow_weights[9][20] ) ) ;
DFFSXL \shadow_weights_reg[13][19] ( .D ( HFSNET_304 ) , .CK ( ZCTSNET_372 ) , 
    .SN ( HFSNET_350 ) , .QN ( \shadow_weights[13][19] ) ) ;
DFFSXL \shadow_weights_reg[19][18] ( .D ( HFSNET_303 ) , .CK ( ZCTSNET_378 ) , 
    .SN ( HFSNET_355 ) , .QN ( \shadow_weights[19][18] ) ) ;
DFFSXL \accumulator_reg[23] ( .D ( n941 ) , .CK ( net1771 ) , 
    .SN ( HFSNET_362 ) , .QN ( accumulator[23] ) ) ;
DFFSXL \shadow_weights_reg[1][17] ( .D ( HFSNET_302 ) , .CK ( ZCTSNET_379 ) , 
    .SN ( HFSNET_337 ) , .QN ( \shadow_weights[1][17] ) ) ;
DFFSXL \shadow_weights_reg[3][16] ( .D ( HFSNET_301 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_334 ) , .QN ( \shadow_weights[3][16] ) ) ;
DFFSXL \shadow_weights_reg[6][15] ( .D ( HFSNET_299 ) , .CK ( ZCTSNET_384 ) , 
    .SN ( HFSNET_335 ) , .QN ( \shadow_weights[6][15] ) ) ;
DFFSXL \meas_val_p_reg[28] ( .D ( n895 ) , .CK ( net1801 ) , 
    .SN ( HFSNET_362 ) , .QN ( meas_val_p[28] ) ) ;
DFFSXL \shadow_weights_reg[3][11] ( .D ( HFSNET_289 ) , .CK ( ZCTSNET_381 ) , 
    .SN ( HFSNET_334 ) , .Q ( \shadow_weights[3][11] ) ) ;
DFFSX1 \state_reg[1] ( .D ( n816 ) , .CK ( ZCTSNET_391 ) , .SN ( rst_n ) , 
    .Q ( n67 ) , .QN ( state[1] ) ) ;
DFFSXL \sar_ptr_reg[4] ( .D ( n820 ) , .CK ( net1781 ) , .SN ( HFSNET_345 ) , 
    .QN ( sar_ptr[4] ) ) ;
DFFSX1 \sar_code_reg[16] ( .D ( n757 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_345 ) , .Q ( n2189 ) , .QN ( protected_sar_code[16] ) ) ;
DFFSX1 \sar_code_reg[12] ( .D ( n761 ) , .CK ( net1786 ) , 
    .SN ( HFSNET_345 ) , .Q ( n2187 ) , .QN ( protected_sar_code[12] ) ) ;
DFFSXL \sar_ptr_reg[3] ( .D ( n794 ) , .CK ( net1781 ) , .SN ( HFSNET_345 ) , 
    .Q ( n1 ) , .QN ( sar_ptr[3] ) ) ;
OAI221XL U3 ( .A0 ( N1841 ) , .A1 ( overrange_bits[1] ) , .B0 ( n2138 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n716 ) ) ;
OAI221XL U4 ( .A0 ( N1842 ) , .A1 ( overrange_bits[0] ) , .B0 ( HFSNET_240 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n717 ) ) ;
OAI221XL U5 ( .A0 ( HFSNET_234 ) , .A1 ( ZBUF_22_2 ) , .B0 ( N1838 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n713 ) ) ;
OAI221XL U6 ( .A0 ( ZBUF_17_14 ) , .A1 ( overrange_bits[2] ) , 
    .B0 ( HFSNET_260 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n715 ) ) ;
OAI221XL U7 ( .A0 ( N1839 ) , .A1 ( overrange_bits[3] ) , .B0 ( HFSNET_255 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n714 ) ) ;
AND2X1 U8 ( .A ( n1991 ) , .B ( n1990 ) , .Y ( n2009 ) ) ;
OR2XL U9 ( .A ( n1989 ) , .B ( n1988 ) , .Y ( n1996 ) ) ;
OAI21XL U10 ( .A0 ( n1693 ) , .A1 ( n2076 ) , .B0 ( n315 ) , .Y ( n1696 ) ) ;
AOI21XL U12 ( .A0 ( n1552 ) , .A1 ( n1551 ) , .B0 ( n1550 ) , .Y ( n1578 ) ) ;
INVXL U13 ( .A ( n829 ) , .Y ( n559 ) ) ;
NOR2X1 U14 ( .A ( n665 ) , .B ( n664 ) , .Y ( N1823 ) ) ;
INVX1 U16 ( .A ( N1822 ) , .Y ( n815 ) ) ;
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
INVXL ctmTdsLR_1_638 ( .A ( n550 ) , .Y ( tmp_net5 ) ) ;
XNOR2XL U34 ( .A ( n213 ) , .B ( n212 ) , .Y ( n1913 ) ) ;
AOI21XL ctmTdsLR_1_2224 ( .A0 ( n1135 ) , .A1 ( n1089 ) , .B0 ( tmp_net497 ) , 
    .Y ( n1090 ) ) ;
XNOR2XL U36 ( .A ( n283 ) , .B ( n270 ) , .Y ( n272 ) ) ;
XNOR2XL U37 ( .A ( n264 ) , .B ( n259 ) , .Y ( n1716 ) ) ;
NAND2XL ctmTdsLR_1_672 ( .A ( n1278 ) , .B ( \shadow_weights[8][7] ) , 
    .Y ( tmp_net27 ) ) ;
AOI21XL ctmTdsLR_1_2199 ( .A0 ( n115 ) , .A1 ( n114 ) , .B0 ( tmp_net485 ) , 
    .Y ( n1853 ) ) ;
XNOR2XL U40 ( .A ( n1552 ) , .B ( n1496 ) , .Y ( n1497 ) ) ;
XOR2XL U41 ( .A ( n1755 ) , .B ( n1754 ) , .Y ( n1759 ) ) ;
OAI221XL U42 ( .A0 ( N1837 ) , .A1 ( overrange_bits[5] ) , 
    .B0 ( HFSNET_253 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n712 ) ) ;
INVXL U43 ( .A ( N1823 ) , .Y ( n823 ) ) ;
CLKINVX3 HFSINV_363_590 ( .A ( HFSNET_364 ) , .Y ( HFSNET_331 ) ) ;
CLKINVX4 HFSINV_5261_591 ( .A ( HFSNET_364 ) , .Y ( HFSNET_332 ) ) ;
CLKINVX4 HFSINV_2547_584 ( .A ( HFSNET_328 ) , .Y ( HFSNET_327 ) ) ;
NAND2XL U47 ( .A ( n1556 ) , .B ( HFSNET_325 ) , .Y ( n930 ) ) ;
NAND2XL ctmTdsLR_2_2200 ( .A ( tmp_net484 ) , .B ( n112 ) , .Y ( n114 ) ) ;
NAND2XL U49 ( .A ( n1497 ) , .B ( HFSNET_325 ) , .Y ( n931 ) ) ;
OAI21XL ctmTdsLR_1_2178 ( .A0 ( n604 ) , .A1 ( n596 ) , .B0 ( tmp_net473 ) , 
    .Y ( n597 ) ) ;
OAI21XL ctmTdsLR_1_2099 ( .A0 ( n1938 ) , .A1 ( n1937 ) , .B0 ( tmp_net434 ) , 
    .Y ( n1943 ) ) ;
NOR2BXL U346_roptpi_2243 ( .AN ( n1451 ) , .B ( n1450 ) , .Y ( n1453 ) ) ;
INVXL U54 ( .A ( n276 ) , .Y ( n277 ) ) ;
NAND3XL ctmTdsLR_1_1936 ( .A ( n2178 ) , .B ( n2158 ) , .C ( target_bit[3] ) , 
    .Y ( n2024 ) ) ;
OAI21XL ctmTdsLR_1_2115 ( .A0 ( n1903 ) , .A1 ( n1902 ) , .B0 ( tmp_net443 ) , 
    .Y ( n1907 ) ) ;
XOR2X1 U57 ( .A ( n1812 ) , .B ( n1811 ) , .Y ( n1817 ) ) ;
XOR2X1 U58 ( .A ( n1821 ) , .B ( n1820 ) , .Y ( n1826 ) ) ;
NOR2XL U59 ( .A ( n1716 ) , .B ( ZBUF_1431_14 ) , .Y ( n1717 ) ) ;
OAI21XL U60 ( .A0 ( n1852 ) , .A1 ( n1781 ) , .B0 ( n1780 ) , .Y ( n1807 ) ) ;
NAND2XL U61 ( .A ( n1499 ) , .B ( n1388 ) , .Y ( n1503 ) ) ;
OAI21XL U62 ( .A0 ( n1762 ) , .A1 ( n1771 ) , .B0 ( n1763 ) , .Y ( n1750 ) ) ;
OAI21XL U63 ( .A0 ( n1508 ) , .A1 ( n1525 ) , .B0 ( n1509 ) , .Y ( n1568 ) ) ;
NAND2XL U64 ( .A ( n1835 ) , .B ( \shadow_weights[18][15] ) , .Y ( n1831 ) ) ;
AOI211XL U65 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2225 ) , .B0 ( n1845 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1846 ) ) ;
NOR2XL U66 ( .A ( HFSNET_145 ) , .B ( temp_acc[27] ) , .Y ( n1607 ) ) ;
NAND2XL U67 ( .A ( HFSNET_118 ) , .B ( temp_acc[1] ) , .Y ( n737 ) ) ;
INVXL U68 ( .A ( n2119 ) , .Y ( n2122 ) ) ;
INVXL U69 ( .A ( n2093 ) , .Y ( n2096 ) ) ;
AOI211XL U70 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2218 ) , .B0 ( n1854 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1855 ) ) ;
AOI211XL U71 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2226 ) , .B0 ( n1866 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1867 ) ) ;
INVXL U72 ( .A ( n1917 ) , .Y ( n1930 ) ) ;
AOI21XL U73 ( .A0 ( n119 ) , .A1 ( n118 ) , .B0 ( n117 ) , .Y ( n124 ) ) ;
NOR2XL U74 ( .A ( n1908 ) , .B ( n1899 ) , .Y ( n220 ) ) ;
NAND2XL U75 ( .A ( n1894 ) , .B ( \shadow_weights[18][9] ) , .Y ( n1890 ) ) ;
AOI211XL U76 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2216 ) , .B0 ( n1932 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1933 ) ) ;
CLKINVX8 HFSINV_1122_592 ( .A ( HFSNET_341 ) , .Y ( HFSNET_333 ) ) ;
OR2XL U78 ( .A ( n1931 ) , .B ( \shadow_weights[18][5] ) , .Y ( n1928 ) ) ;
CLKINVX4 HFSINV_955_593 ( .A ( HFSNET_341 ) , .Y ( HFSNET_334 ) ) ;
INVXL U80 ( .A ( n1626 ) , .Y ( n1628 ) ) ;
AND2XL U397_roptpi_2244 ( .A ( n1632 ) , .B ( n1630 ) , .Y ( n1624 ) ) ;
NOR2XL U82 ( .A ( n1949 ) , .B ( \shadow_weights[18][3] ) , .Y ( n1944 ) ) ;
NAND2XL U83 ( .A ( HFSNET_329 ) , .B ( n1985 ) , .Y ( n2068 ) ) ;
CLKINVX4 HFSINV_792_594 ( .A ( HFSNET_341 ) , .Y ( HFSNET_335 ) ) ;
CLKINVX4 HFSINV_1524_595 ( .A ( HFSNET_341 ) , .Y ( HFSNET_336 ) ) ;
AOI21XL U86 ( .A0 ( n399 ) , .A1 ( n591 ) , .B0 ( n398 ) , .Y ( n400 ) ) ;
AOI22XL U88 ( .A0 ( n1671 ) , .A1 ( sar_code[18] ) , .B0 ( n1673 ) , 
    .B1 ( sar_code[17] ) , .Y ( n1675_CDR2 ) ) ;
NAND2XL ctmTdsLR_1_911 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][14] ) , 
    .Y ( tmp_net193 ) ) ;
INVX3 HFSINV_1817_596 ( .A ( HFSNET_341 ) , .Y ( HFSNET_337 ) ) ;
CLKINVX4 HFSINV_1669_597 ( .A ( HFSNET_341 ) , .Y ( HFSNET_338 ) ) ;
CLKINVX4 HFSINV_2067_598 ( .A ( HFSNET_341 ) , .Y ( HFSNET_339 ) ) ;
CLKINVX8 HFSINV_2730_599 ( .A ( HFSNET_341 ) , .Y ( HFSNET_340 ) ) ;
INVXL HFSINV_4602_585 ( .A ( n1875 ) , .Y ( HFSNET_328 ) ) ;
INVXL U95 ( .A ( n581 ) , .Y ( n582 ) ) ;
INVXL U96 ( .A ( n508 ) , .Y ( n509 ) ) ;
OR2XL U97 ( .A ( n463 ) , .B ( n462 ) , .Y ( n510 ) ) ;
NAND2XL U98 ( .A ( n393 ) , .B ( n392 ) , .Y ( n525 ) ) ;
INVXL U99 ( .A ( n106 ) , .Y ( n118 ) ) ;
INVXL U100 ( .A ( n140 ) , .Y ( n90 ) ) ;
INVXL U101 ( .A ( n131 ) , .Y ( n126 ) ) ;
NAND2XL U102 ( .A ( n371 ) , .B ( n370 ) , .Y ( n480 ) ) ;
INVX3 HFSINV_3891_600 ( .A ( HFSNET_342 ) , .Y ( HFSNET_341 ) ) ;
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
NOR2XL U113 ( .A ( n293 ) , .B ( ZBUF_1431_14 ) , .Y ( n294 ) ) ;
NOR2XL U114 ( .A ( n272 ) , .B ( ZBUF_1431_14 ) , .Y ( n273 ) ) ;
AOI21XL U115 ( .A0 ( n1800 ) , .A1 ( n1798 ) , .B0 ( n1787 ) , .Y ( n1792 ) ) ;
NOR2XL U116 ( .A ( n1708 ) , .B ( ZBUF_1431_14 ) , .Y ( n1709 ) ) ;
INVXL U117 ( .A ( n1712 ) , .Y ( n260 ) ) ;
OAI21XL U118 ( .A0 ( n1423 ) , .A1 ( n1422 ) , .B0 ( n1421 ) , .Y ( n1442 ) ) ;
AOI211XL U119 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2211 ) , .B0 ( n1726 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1727 ) ) ;
AOI211XL U120 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2212 ) , .B0 ( n1737 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1738 ) ) ;
OAI21XL U121 ( .A0 ( n1780 ) , .A1 ( n229 ) , .B0 ( n228 ) , .Y ( n230 ) ) ;
NOR2XL U122 ( .A ( n1422 ) , .B ( n1233 ) , .Y ( n1236 ) ) ;
AOI211XL U124 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2229 ) , .B0 ( n1836 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1837 ) ) ;
OR2XL U125 ( .A ( HFSNET_147 ) , .B ( temp_acc[28] ) , .Y ( n1632 ) ) ;
NAND2BXL ctmTdsLR_1_978 ( .AN ( n521 ) , .B ( n466 ) , .Y ( tmp_net241 ) ) ;
INVXL U127 ( .A ( n1760 ) , .Y ( n1772 ) ) ;
NOR2XL U130 ( .A ( n1835 ) , .B ( ZBUF_1431_14 ) , .Y ( n1836 ) ) ;
OAI21XL U131 ( .A0 ( n1426 ) , .A1 ( n1443 ) , .B0 ( n1427 ) , .Y ( n1486 ) ) ;
NOR2XL U132 ( .A ( HFSNET_156 ) , .B ( temp_acc[25] ) , .Y ( n1530 ) ) ;
NOR2XL U133 ( .A ( HFSNET_160 ) , .B ( temp_acc[12] ) , .Y ( n1424 ) ) ;
NOR2XL U134 ( .A ( HFSNET_159 ) , .B ( temp_acc[14] ) , .Y ( n1490 ) ) ;
OR2XL U135 ( .A ( n2131 ) , .B ( n2100 ) , .Y ( n318 ) ) ;
AOI211XL U136 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2203 ) , .B0 ( n1794 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1795 ) ) ;
AOI211XL U137 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2231 ) , .B0 ( n1814 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1816 ) ) ;
AOI211XL U138 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2230 ) , .B0 ( n1914 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1915 ) ) ;
AOI211XL U139 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2227 ) , .B0 ( n1887 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1888 ) ) ;
NOR2XL U140 ( .A ( n1793 ) , .B ( ZBUF_1431_14 ) , .Y ( n1794 ) ) ;
INVXL U141 ( .A ( n1786 ) , .Y ( n1798 ) ) ;
AOI211XL U142 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2232 ) , .B0 ( n1824 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1825 ) ) ;
NOR2XL U143 ( .A ( n1801 ) , .B ( ZBUF_1431_14 ) , .Y ( n1802 ) ) ;
AOI211XL U144 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2223 ) , .B0 ( n1905 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1906 ) ) ;
NOR2XL U145 ( .A ( n1823 ) , .B ( ZBUF_1431_14 ) , .Y ( n1824 ) ) ;
NAND2XL U146 ( .A ( n2099 ) , .B ( sar_ptr[2] ) , .Y ( n2110 ) ) ;
NOR2XL U147 ( .A ( n1886 ) , .B ( ZBUF_1431_14 ) , .Y ( n1887 ) ) ;
OAI21XL U148 ( .A0 ( n521 ) , .A1 ( n520 ) , .B0 ( n519 ) , .Y ( n531 ) ) ;
NAND2XL U149 ( .A ( n1656 ) , .B ( n1982 ) , .Y ( N1608 ) ) ;
CLKINVX4 HFSINV_4202_601 ( .A ( HFSNET_364 ) , .Y ( HFSNET_342 ) ) ;
INVX4 HFSINV_4613_602 ( .A ( HFSNET_364 ) , .Y ( HFSNET_343 ) ) ;
CLKINVX8 HFSINV_520_603 ( .A ( HFSNET_364 ) , .Y ( HFSNET_344 ) ) ;
CLKINVX3 HFSINV_6510_604 ( .A ( HFSNET_364 ) , .Y ( HFSNET_345 ) ) ;
CLKINVX8 HFSINV_7880_607 ( .A ( HFSNET_364 ) , .Y ( HFSNET_347 ) ) ;
CLKINVX4 HFSINV_8037_608 ( .A ( HFSNET_364 ) , .Y ( HFSNET_348 ) ) ;
CLKINVX4 HFSINV_7698_609 ( .A ( HFSNET_364 ) , .Y ( HFSNET_349 ) ) ;
INVX4 HFSINV_11467_610 ( .A ( HFSNET_359 ) , .Y ( HFSNET_350 ) ) ;
AOI211XL U158 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2221 ) , 
    .B0 ( HFSNET_327 ) , .C0 ( n1966 ) , .Y ( n1967 ) ) ;
AOI211XL U159 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2222 ) , 
    .B0 ( HFSNET_327 ) , .C0 ( n1973 ) , .Y ( n1975 ) ) ;
CLKINVX8 HFSINV_8782_611 ( .A ( HFSNET_359 ) , .Y ( HFSNET_351 ) ) ;
OR2XL U161 ( .A ( n1939 ) , .B ( \shadow_weights[18][4] ) , .Y ( n1936 ) ) ;
CLKINVX2 U162 ( .A ( n2118 ) , .Y ( n2134 ) ) ;
CLKINVX4 HFSINV_9181_612 ( .A ( HFSNET_359 ) , .Y ( HFSNET_352 ) ) ;
CLKINVX3 HFSINV_9045_613 ( .A ( HFSNET_359 ) , .Y ( HFSNET_353 ) ) ;
CLKINVX4 HFSINV_8934_614 ( .A ( HFSNET_359 ) , .Y ( HFSNET_354 ) ) ;
CLKINVX8 HFSINV_8622_615 ( .A ( HFSNET_359 ) , .Y ( HFSNET_355 ) ) ;
INVX4 HFSINV_10061_616 ( .A ( HFSNET_359 ) , .Y ( HFSNET_356 ) ) ;
OR2XL U168 ( .A ( n1957 ) , .B ( \shadow_weights[18][2] ) , .Y ( n1954 ) ) ;
MX2XL ctmTdsLR_1_877 ( .A ( n725 ) , .B ( n663 ) , .S0 ( comp_out_rr ) , 
    .Y ( n314 ) ) ;
CLKINVX8 HFSINV_10240_617 ( .A ( HFSNET_359 ) , .Y ( HFSNET_357 ) ) ;
NAND2XL U171 ( .A ( n579 ) , .B ( wait_cnt[4] ) , .Y ( n474 ) ) ;
INVXL U172 ( .A ( n2032 ) , .Y ( n2012 ) ) ;
OR2XL ctmTdsLR_1_2062 ( .A ( tmp_net412 ) , .B ( tmp_net403 ) , 
    .Y ( HFSNET_121 ) ) ;
NAND2X2 U174 ( .A ( n573 ) , .B ( n315 ) , .Y ( n316 ) ) ;
CLKINVX3 U175 ( .A ( n1297 ) , .Y ( n1267 ) ) ;
BUFXL ropt_mt_inst_2351 ( .A ( n1104 ) , .Y ( ropt_net_530 ) ) ;
CLKINVX3 U177 ( .A ( n1320 ) , .Y ( n1290 ) ) ;
INVX4 U178 ( .A ( n1301 ) , .Y ( n1271 ) ) ;
CLKINVX3 U179 ( .A ( n1308 ) , .Y ( n1278 ) ) ;
CLKINVX8 HFSINV_10909_618 ( .A ( HFSNET_359 ) , .Y ( HFSNET_358 ) ) ;
INVX4 HFSINV_11870_619 ( .A ( HFSNET_360 ) , .Y ( HFSNET_359 ) ) ;
CLKINVX8 HFSINV_12227_620 ( .A ( HFSNET_364 ) , .Y ( HFSNET_360 ) ) ;
CLKINVX4 HFSINV_12586_621 ( .A ( HFSNET_364 ) , .Y ( HFSNET_361 ) ) ;
OAI2BB1XL ctmTdsLR_1_627 ( .A0N ( n192 ) , .A1N ( n200 ) , .B0 ( n190 ) , 
    .Y ( tmp_net0 ) ) ;
CLKINVX3 U185 ( .A ( n1305 ) , .Y ( n1275 ) ) ;
INVXL U186 ( .A ( n692 ) , .Y ( n693 ) ) ;
INVX4 HFSINV_4577_586 ( .A ( n1875 ) , .Y ( HFSNET_329 ) ) ;
NOR2XL U188 ( .A ( n2073 ) , .B ( n2031 ) , .Y ( n2032 ) ) ;
INVXL U189 ( .A ( n811 ) , .Y ( n812 ) ) ;
XNOR2X1 ctmTdsLR_2_628 ( .A ( tmp_net0 ) , .B ( n196 ) , .Y ( n1931 ) ) ;
NAND2BXL ctmTdsLR_1_629 ( .AN ( n218 ) , .B ( n144 ) , .Y ( tmp_net1 ) ) ;
CLKINVX8 gre_a_INV_6696_inst_2347 ( .A ( n1299 ) , .Y ( gre_a_INV_6696_54 ) ) ;
CLKINVX8 HFSINV_1920_582 ( .A ( n322 ) , .Y ( HFSNET_325 ) ) ;
NOR2XL U194 ( .A ( n824 ) , .B ( n2194 ) , .Y ( n1081 ) ) ;
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
NAND2BXL ctmTdsLR_2_630 ( .AN ( n145 ) , .B ( tmp_net1 ) , .Y ( n167 ) ) ;
NAND2XL ctmTdsLR_1_631 ( .A ( n126 ) , .B ( n128 ) , .Y ( tmp_net2 ) ) ;
OAI211XL ctmTdsLR_2_632 ( .A0 ( n125 ) , .A1 ( n89 ) , .B0 ( tmp_net2 ) , 
    .C0 ( n127 ) , .Y ( n143 ) ) ;
NAND2XL ctmTdsLR_1_633 ( .A ( n2047 ) , .B ( protected_sar_code[7] ) , 
    .Y ( tmp_net3 ) ) ;
OAI221XL ctmTdsLR_2_634 ( .A0 ( n2049 ) , .A1 ( n2181 ) , .B0 ( n2046 ) , 
    .B1 ( n2183 ) , .C0 ( tmp_net3 ) , .Y ( n2064 ) ) ;
NAND2XL ctmTdsLR_1_635 ( .A ( HFSNET_177 ) , .B ( HFSNET_325 ) , 
    .Y ( HFSNET_117 ) ) ;
OAI2BB1XL ctmTdsLR_1_636 ( .A0N ( n1449 ) , .A1N ( HFSNET_275 ) , 
    .B0 ( n1447 ) , .Y ( tmp_net4 ) ) ;
INVXL gre_a_INV_6_inst_2301 ( .A ( gre_a_INV_1810_47 ) , 
    .Y ( gre_a_INV_6_47 ) ) ;
NAND2XL U214 ( .A ( n297 ) , .B ( n654 ) , .Y ( n968 ) ) ;
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
OAI21XL ctmTdsLR_2_639 ( .A0 ( tmp_net5 ) , .A1 ( n546 ) , .B0 ( n547 ) , 
    .Y ( tmp_net6 ) ) ;
NAND2XL U229 ( .A ( n1575 ) , .B ( HFSNET_329 ) , .Y ( n2333 ) ) ;
NAND2XL U230 ( .A ( n1605 ) , .B ( HFSNET_329 ) , .Y ( n2338 ) ) ;
NAND2XL ctmTdsLR_2_2179 ( .A ( n604 ) , .B ( n596 ) , .Y ( tmp_net473 ) ) ;
NAND2XL U232 ( .A ( n1567 ) , .B ( HFSNET_329 ) , .Y ( n2323 ) ) ;
NAND2XL U233 ( .A ( n1528 ) , .B ( HFSNET_329 ) , .Y ( n2331 ) ) ;
NAND2XL U234 ( .A ( n1522 ) , .B ( HFSNET_329 ) , .Y ( n2330 ) ) ;
NAND2XL U235 ( .A ( n1492 ) , .B ( HFSNET_329 ) , .Y ( n2322 ) ) ;
NAND2XL U236 ( .A ( n1548 ) , .B ( HFSNET_329 ) , .Y ( n2337 ) ) ;
NAND2XL U237 ( .A ( n1513 ) , .B ( HFSNET_329 ) , .Y ( n2332 ) ) ;
NAND2XL U238 ( .A ( n1148 ) , .B ( HFSNET_325 ) , .Y ( n932 ) ) ;
NAND2XL U239 ( .A ( n1431 ) , .B ( HFSNET_329 ) , .Y ( n2321 ) ) ;
AOI21XL ctmTdsLR_1_2107 ( .A0 ( n1922 ) , .A1 ( n1921 ) , .B0 ( tmp_net438 ) , 
    .Y ( n1926 ) ) ;
AOI21XL U241 ( .A0 ( n1570 ) , .A1 ( n1569 ) , .B0 ( n1568 ) , .Y ( n1574 ) ) ;
NAND2XL U242 ( .A ( n1462 ) , .B ( HFSNET_329 ) , .Y ( n2334 ) ) ;
BUFX1 ZBUF_2_inst_2246 ( .A ( \shadow_weights[12][8] ) , .Y ( ZBUF_2_2 ) ) ;
NAND2XL ctmTdsLR_2_2100 ( .A ( n1938 ) , .B ( n1937 ) , .Y ( tmp_net434 ) ) ;
XNOR2XL U245 ( .A ( n1560 ) , .B ( n1491 ) , .Y ( n1492 ) ) ;
NAND2XL U246 ( .A ( n1502 ) , .B ( HFSNET_329 ) , .Y ( n2329 ) ) ;
NAND2XL ctmTdsLR_2_2225 ( .A ( tmp_net496 ) , .B ( n1133 ) , .Y ( n1089 ) ) ;
NAND2XL U248 ( .A ( n1484 ) , .B ( HFSNET_329 ) , .Y ( n2336 ) ) ;
XNOR2XL U249 ( .A ( n1570 ) , .B ( n1527 ) , .Y ( n1528 ) ) ;
OAI21XL ctmTdsLR_1_2216 ( .A0 ( n185 ) , .A1 ( n184 ) , .B0 ( tmp_net492 ) , 
    .Y ( n1949 ) ) ;
NAND2XL U251 ( .A ( n1446 ) , .B ( HFSNET_329 ) , .Y ( n2320 ) ) ;
NAND2XL U253 ( .A ( n1084 ) , .B ( HFSNET_325 ) , .Y ( n933 ) ) ;
NAND2XL U254 ( .A ( n1441 ) , .B ( HFSNET_329 ) , .Y ( n2319 ) ) ;
NAND2XL U255 ( .A ( n1415 ) , .B ( HFSNET_329 ) , .Y ( n2335 ) ) ;
OAI21XL ctmTdsLR_1_2234 ( .A0 ( n1956 ) , .A1 ( n1955 ) , .B0 ( tmp_net501 ) , 
    .Y ( n1960 ) ) ;
NOR2XL ctmTdsLR_2_2108 ( .A ( n1922 ) , .B ( n1921 ) , .Y ( tmp_net438 ) ) ;
NAND2XL ctmTdsLR_2_2116 ( .A ( tmp_net442 ) , .B ( n1900 ) , .Y ( n1902 ) ) ;
NAND2XL U261 ( .A ( n1132 ) , .B ( HFSNET_329 ) , .Y ( n2318 ) ) ;
NAND2XL U262 ( .A ( n1141 ) , .B ( HFSNET_329 ) , .Y ( n2315 ) ) ;
NAND2XL U263 ( .A ( n1420 ) , .B ( HFSNET_329 ) , .Y ( n2324 ) ) ;
NAND2BXL ctmTdsLR_2_979 ( .AN ( n467 ) , .B ( tmp_net241 ) , .Y ( n539 ) ) ;
NAND2XL ctmTdsLR_2_2217 ( .A ( n185 ) , .B ( n184 ) , .Y ( tmp_net492 ) ) ;
INVXL ctmTdsLR_1_2123 ( .A ( tmp_net445 ) , .Y ( HFSNET_122 ) ) ;
INVXL ctmTdsLR_3_2201 ( .A ( n111 ) , .Y ( tmp_net484 ) ) ;
NAND2XL U268 ( .A ( n975 ) , .B ( HFSNET_325 ) , .Y ( n934 ) ) ;
INVXL gre_a_INV_6897_inst_2340 ( .A ( gre_a_INV_7090_53 ) , 
    .Y ( gre_a_INV_6897_53 ) ) ;
NAND2XL U270 ( .A ( n1109 ) , .B ( HFSNET_329 ) , .Y ( n2317 ) ) ;
XNOR2XL U271 ( .A ( n1145 ) , .B ( n1083 ) , .Y ( n1084 ) ) ;
BUFX1 ZBUF_2_inst_2247 ( .A ( tmp_net334 ) , .Y ( ZBUF_2_14 ) ) ;
OAI21XL ctmTdsLR_1_2180 ( .A0 ( tmp_net243 ) , .A1 ( n429 ) , 
    .B0 ( tmp_net474 ) , .Y ( n431 ) ) ;
NAND2XL U275 ( .A ( n810 ) , .B ( HFSNET_325 ) , .Y ( n935 ) ) ;
OAI2BB1XL ctmTdsLR_1_641 ( .A0N ( n501 ) , .A1N ( n550 ) , .B0 ( n499 ) , 
    .Y ( tmp_net7 ) ) ;
AOI211XL U277 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2209 ) , .B0 ( n1709 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1710 ) ) ;
XNOR2XL U278 ( .A ( HFSNET_275 ) , .B ( n1419 ) , .Y ( n1420 ) ) ;
AOI21XL U279 ( .A0 ( HFSNET_275 ) , .A1 ( n1457 ) , .B0 ( n1456 ) , 
    .Y ( n1461 ) ) ;
NAND2XL U280 ( .A ( n1090 ) , .B ( HFSNET_329 ) , .Y ( n2314 ) ) ;
XNOR2XL U281 ( .A ( n1435 ) , .B ( n1131 ) , .Y ( n1132 ) ) ;
NAND2XL ctmTdsLR_1_980 ( .A ( n492 ) , .B ( n495 ) , .Y ( tmp_net242 ) ) ;
INVXL ctmTdsLR_3_2226 ( .A ( n1134 ) , .Y ( tmp_net496 ) ) ;
XOR2XL U284 ( .A ( n1082 ) , .B ( n974 ) , .Y ( n975 ) ) ;
AOI21X1 U285 ( .A0 ( n1466 ) , .A1 ( n1465 ) , .B0 ( n1464 ) , .Y ( n1531 ) ) ;
XOR2XL U286 ( .A ( n1744 ) , .B ( n1743 ) , .Y ( n1748 ) ) ;
NAND2XL U287 ( .A ( n1079 ) , .B ( HFSNET_329 ) , .Y ( n2316 ) ) ;
NAND2XL U288 ( .A ( n1021 ) , .B ( HFSNET_329 ) , .Y ( n2313 ) ) ;
INVX4 gre_a_INV_1810_inst_2302 ( .A ( calc_result_r[10] ) , 
    .Y ( gre_a_INV_1810_47 ) ) ;
XNOR2XL U290 ( .A ( n1108 ) , .B ( n1107 ) , .Y ( n1109 ) ) ;
NAND2XL ctmTdsLR_2_2235 ( .A ( n1956 ) , .B ( n1955 ) , .Y ( tmp_net501 ) ) ;
NOR2XL ctmTdsLR_4_2202 ( .A ( n115 ) , .B ( n114 ) , .Y ( tmp_net485 ) ) ;
NAND2XL U293 ( .A ( n803 ) , .B ( HFSNET_329 ) , .Y ( n2311 ) ) ;
INVXL HFSINV_304_530 ( .A ( n1417 ) , .Y ( HFSNET_275 ) ) ;
NAND2XL U295 ( .A ( n1713 ) , .B ( n1712 ) , .Y ( n1714 ) ) ;
NAND3XL ctmTdsLR_1_1937 ( .A ( target_bit[1] ) , .B ( n2178 ) , 
    .C ( target_bit[3] ) , .Y ( n2030 ) ) ;
XOR2XL U297 ( .A ( n1423 ) , .B ( n1078 ) , .Y ( n1079 ) ) ;
AND3XL ctmTdsLR_1_2095 ( .A ( tmp_net432 ) , .B ( n789_CDR1 ) , 
    .C ( n782_CDR1 ) , .Y ( tmp_net45 ) ) ;
XNOR2XL U299 ( .A ( n1774 ) , .B ( n1773 ) , .Y ( n1778 ) ) ;
AOI21XL U300 ( .A0 ( n1774 ) , .A1 ( n1751 ) , .B0 ( n1750 ) , .Y ( n1755 ) ) ;
XNOR2XL U301 ( .A ( n814 ) , .B ( n809 ) , .Y ( n810 ) ) ;
AOI211XL U303 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2210 ) , .B0 ( n1717 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1718 ) ) ;
NAND2XL U304 ( .A ( n721 ) , .B ( HFSNET_325 ) , .Y ( n936 ) ) ;
NAND2XL U305 ( .A ( n1000 ) , .B ( HFSNET_329 ) , .Y ( n2312 ) ) ;
NAND2XL U306 ( .A ( n778 ) , .B ( HFSNET_329 ) , .Y ( n2310 ) ) ;
XNOR2XL U307 ( .A ( n1087 ) , .B ( n999 ) , .Y ( n1000 ) ) ;
NAND2XL ctmTdsLR_2_2096 ( .A ( HFSNET_322 ) , .B ( \shadow_weights[7][3] ) , 
    .Y ( tmp_net432 ) ) ;
NAND2XL U309 ( .A ( n1457 ) , .B ( n1459 ) , .Y ( n1398 ) ) ;
NAND4BXL ctmTdsLR_2_2063 ( .AN ( n1011_CDR1 ) , .B ( tmp_net211 ) , 
    .C ( tmp_net410 ) , .D ( tmp_net411 ) , .Y ( tmp_net412 ) ) ;
NAND2XL U311 ( .A ( n691 ) , .B ( HFSNET_329 ) , .Y ( n2309 ) ) ;
AOI222XL ctmTdsLR_3_2064 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][5] ) , 
    .B0 ( n1319 ) , .B1 ( \shadow_weights[13][5] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][5] ) , .Y ( tmp_net410 ) ) ;
NAND2XL U314 ( .A ( n648 ) , .B ( HFSNET_325 ) , .Y ( n937 ) ) ;
XNOR2XL U315 ( .A ( n802 ) , .B ( n801 ) , .Y ( n803 ) ) ;
XOR2XL U316 ( .A ( n806 ) , .B ( n720 ) , .Y ( n721 ) ) ;
NAND2XL U319 ( .A ( n589 ) , .B ( HFSNET_325 ) , .Y ( n938 ) ) ;
OAI21XL ctmTdsLR_1_2218 ( .A0 ( n1587 ) , .A1 ( n1547 ) , .B0 ( tmp_net493 ) , 
    .Y ( n1548 ) ) ;
AOI21XL ctmTdsLR_1_2236 ( .A0 ( n1574 ) , .A1 ( n1573 ) , .B0 ( tmp_net502 ) , 
    .Y ( n1575 ) ) ;
XNOR2XL U323 ( .A ( n695 ) , .B ( n647 ) , .Y ( n648 ) ) ;
INVXL U324 ( .A ( n1504 ) , .Y ( n1505 ) ) ;
NAND2XL ctmTdsLR_2_2181 ( .A ( tmp_net243 ) , .B ( n429 ) , 
    .Y ( tmp_net474 ) ) ;
XOR2XL U326 ( .A ( n779 ) , .B ( n777 ) , .Y ( n778 ) ) ;
NOR2XL U327 ( .A ( n1725 ) , .B ( ZBUF_1431_14 ) , .Y ( n1726 ) ) ;
AOI21XL U328 ( .A0 ( n1807 ) , .A1 ( n1819 ) , .B0 ( n1806 ) , .Y ( n1812 ) ) ;
INVXL U329 ( .A ( n1503 ) , .Y ( n1506 ) ) ;
AOI21XL ctmTdsLR_1_2155 ( .A0 ( n1873 ) , .A1 ( n1872 ) , .B0 ( tmp_net462 ) , 
    .Y ( n1878 ) ) ;
NAND2XL U332 ( .A ( n1002 ) , .B ( n1053 ) , .Y ( n999 ) ) ;
NAND2XL U334 ( .A ( n1449 ) , .B ( n1447 ) , .Y ( n1419 ) ) ;
XOR2XL U337 ( .A ( n644 ) , .B ( n588 ) , .Y ( n589 ) ) ;
NAND2XL U338 ( .A ( n567 ) , .B ( HFSNET_325 ) , .Y ( n939 ) ) ;
AND3XL ctmTdsLR_2_1939 ( .A ( tmp_net309 ) , .B ( tmp_net93 ) , 
    .C ( tmp_net308 ) , .Y ( tmp_net324 ) ) ;
NAND2XL U340 ( .A ( n1434 ) , .B ( n1432 ) , .Y ( n1131 ) ) ;
INVXL U343 ( .A ( n1224 ) , .Y ( n1114 ) ) ;
OAI21XL ctmTdsLR_1_2165 ( .A0 ( n352 ) , .A1 ( n351 ) , .B0 ( tmp_net467 ) , 
    .Y ( n353 ) ) ;
AOI211XL U345 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2213 ) , .B0 ( n1746 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1747 ) ) ;
XOR2XL U347 ( .A ( n1852 ) , .B ( n1851 ) , .Y ( n1856 ) ) ;
AOI222XL ctmTdsLR_1_677 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][7] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][7] ) , 
    .C0 ( n1270 ) , .C1 ( \shadow_weights[14][7] ) , .Y ( tmp_net31 ) ) ;
NAND2XL ctmTdsLR_2_2156 ( .A ( tmp_net461 ) , .B ( n1870 ) , .Y ( n1872 ) ) ;
NOR2XL U354 ( .A ( n1736 ) , .B ( ZBUF_1431_14 ) , .Y ( n1737 ) ) ;
NAND2XL U355 ( .A ( n1058 ) , .B ( n1086 ) , .Y ( n1060 ) ) ;
INVXL U357 ( .A ( n981 ) , .Y ( n779 ) ) ;
OAI211XL ctmTdsLR_2_981 ( .A0 ( n455 ) , .A1 ( n418 ) , .B0 ( tmp_net242 ) , 
    .C0 ( n494 ) , .Y ( n435 ) ) ;
NAND2BXL ctmTdsLR_1_959 ( .AN ( n1821 ) , .B ( n1782 ) , .Y ( tmp_net228 ) ) ;
AOI21XL U365 ( .A0 ( n1893 ) , .A1 ( n1891 ) , .B0 ( n1880 ) , .Y ( n1885 ) ) ;
NAND2XL U368 ( .A ( n1586 ) , .B ( n1584 ) , .Y ( n1547 ) ) ;
AOI21XL U369 ( .A0 ( n1783 ) , .A1 ( n227 ) , .B0 ( n226 ) , .Y ( n228 ) ) ;
NAND2XL U372 ( .A ( n1572 ) , .B ( n1571 ) , .Y ( n1573 ) ) ;
OAI2BB1XL ctmTdsLR_1_982 ( .A0N ( n425 ) , .A1N ( n443 ) , .B0 ( n423 ) , 
    .Y ( tmp_net243 ) ) ;
NOR2XL U375 ( .A ( n976 ) , .B ( n979 ) , .Y ( n982 ) ) ;
INVXL U377 ( .A ( n1463 ) , .Y ( n1464 ) ) ;
INVXL U379 ( .A ( n1584 ) , .Y ( n1585 ) ) ;
NAND2XL ctmTdsLR_4_2065 ( .A ( n1688 ) , .B ( \shadow_weights[15][5] ) , 
    .Y ( tmp_net411 ) ) ;
NOR2XL U383 ( .A ( n1745 ) , .B ( ZBUF_1431_14 ) , .Y ( n1746 ) ) ;
NAND2XL U386 ( .A ( n1465 ) , .B ( n1463 ) , .Y ( n1414 ) ) ;
AOI211XL U387 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2207 ) , .B0 ( n1757 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1758 ) ) ;
NAND2XL U388 ( .A ( n1753 ) , .B ( n1751 ) , .Y ( n247 ) ) ;
AND4XL ctmTdsLR_2_2124 ( .A ( n1036_CDR1 ) , .B ( tmp_net214 ) , 
    .C ( tmp_net215 ) , .D ( tmp_net216 ) , .Y ( tmp_net445 ) ) ;
NAND2XL U391 ( .A ( n1459 ) , .B ( n1458 ) , .Y ( n1460 ) ) ;
INVXL ctmTdsLR_3_2157 ( .A ( n1869 ) , .Y ( tmp_net461 ) ) ;
XNOR2X1 ctmTdsLR_2_642 ( .A ( tmp_net7 ) , .B ( n505 ) , .Y ( n507 ) ) ;
INVXL U396 ( .A ( n1418 ) , .Y ( n1449 ) ) ;
CLKINVX8 gre_a_INV_4409_inst_2346 ( .A ( n1298 ) , .Y ( gre_a_INV_4409_54 ) ) ;
NAND2XL U398 ( .A ( n1753 ) , .B ( n1752 ) , .Y ( n1754 ) ) ;
INVXL U400 ( .A ( n1163 ) , .Y ( n1434 ) ) ;
XNOR2XL U402 ( .A ( n584 ) , .B ( n566 ) , .Y ( n567 ) ) ;
AOI222XL ctmTdsLR_1_679 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][2] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][2] ) , 
    .C0 ( n1270 ) , .C1 ( \shadow_weights[14][2] ) , .Y ( tmp_net32 ) ) ;
INVXL U405 ( .A ( n1022 ) , .Y ( n1002 ) ) ;
OR4X1 ctmTdsLR_1_2066 ( .A ( tmp_net399 ) , .B ( tmp_net413 ) , 
    .C ( tmp_net415 ) , .D ( HFSNET_92 ) , .Y ( HFSNET_119 ) ) ;
INVXL ctmTdsLR_3_2117 ( .A ( n1899 ) , .Y ( tmp_net442 ) ) ;
NAND2XL ctmTdsLR_2_2219 ( .A ( n1587 ) , .B ( n1547 ) , .Y ( tmp_net493 ) ) ;
NAND2XL U409 ( .A ( n1832 ) , .B ( n1831 ) , .Y ( n1833 ) ) ;
NOR2XL U410 ( .A ( n1756 ) , .B ( ZBUF_1431_14 ) , .Y ( n1757 ) ) ;
AOI21XL U413 ( .A0 ( n2127 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2126 ) ) ;
OR2XL U414 ( .A ( HFSNET_148 ) , .B ( temp_acc[24] ) , .Y ( n1465 ) ) ;
NAND2XL U415 ( .A ( HFSNET_148 ) , .B ( temp_acc[24] ) , .Y ( n1463 ) ) ;
NAND2XL U416 ( .A ( n1756 ) , .B ( \shadow_weights[18][22] ) , .Y ( n1752 ) ) ;
XOR2XL U417 ( .A ( n563 ) , .B ( n515 ) , .Y ( n516 ) ) ;
AOI21XL U418 ( .A0 ( n2130 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2129 ) ) ;
OR2XL U419 ( .A ( HFSNET_151 ) , .B ( temp_acc[23] ) , .Y ( n1459 ) ) ;
NAND2XL U420 ( .A ( HFSNET_151 ) , .B ( temp_acc[23] ) , .Y ( n1458 ) ) ;
NAND2XL U421 ( .A ( ZBUF_17_27 ) , .B ( temp_acc[11] ) , .Y ( n1437 ) ) ;
NAND2XL U422 ( .A ( HFSNET_156 ) , .B ( temp_acc[25] ) , .Y ( n1529 ) ) ;
NAND2XL U423 ( .A ( HFSNET_155 ) , .B ( temp_acc[22] ) , .Y ( n1571 ) ) ;
NAND2XL U424 ( .A ( HFSNET_152 ) , .B ( temp_acc[21] ) , .Y ( n1509 ) ) ;
XOR2XL U425 ( .A ( n1912 ) , .B ( n1911 ) , .Y ( n1916 ) ) ;
XOR2XL U426 ( .A ( n609 ) , .B ( n608 ) , .Y ( n610 ) ) ;
INVXL U427 ( .A ( n1486 ) , .Y ( n1487 ) ) ;
NAND2XL U428 ( .A ( HFSNET_146 ) , .B ( temp_acc[26] ) , .Y ( n1584 ) ) ;
AOI21XL U429 ( .A0 ( n2124 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2123 ) ) ;
OR2XL U430 ( .A ( HFSNET_146 ) , .B ( temp_acc[26] ) , .Y ( n1586 ) ) ;
NAND2XL U431 ( .A ( HFSNET_121 ) , .B ( temp_acc[5] ) , .Y ( n1052 ) ) ;
NAND2XL U433 ( .A ( HFSNET_147 ) , .B ( temp_acc[28] ) , .Y ( n1630 ) ) ;
NAND2XL U434 ( .A ( HFSNET_154 ) , .B ( temp_acc[17] ) , .Y ( n1451 ) ) ;
NAND2XL U435 ( .A ( HFSNET_123 ) , .B ( temp_acc[7] ) , .Y ( n1137 ) ) ;
AOI21XL U436 ( .A0 ( n2121 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2120 ) ) ;
NAND2XL U437 ( .A ( ZBUF_28_24 ) , .B ( temp_acc[19] ) , .Y ( n1518 ) ) ;
AOI211X4 U438 ( .A0 ( n2070 ) , .A1 ( protected_sar_code[0] ) , 
    .B0 ( n2069 ) , .C0 ( n2068 ) , .Y ( n2071 ) ) ;
INVXL U439 ( .A ( n1485 ) , .Y ( n1488 ) ) ;
NAND2XL U440 ( .A ( HFSNET_120 ) , .B ( temp_acc[3] ) , .Y ( n977 ) ) ;
NAND2XL U441 ( .A ( HFSNET_145 ) , .B ( temp_acc[27] ) , .Y ( n1606 ) ) ;
NAND2XL U442 ( .A ( n1772 ) , .B ( n1771 ) , .Y ( n1773 ) ) ;
AOI21XL U443 ( .A0 ( n2095 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2094 ) ) ;
NAND2XL U444 ( .A ( n1485 ) , .B ( n1231 ) , .Y ( n1233 ) ) ;
AOI21XL U445 ( .A0 ( n1231 ) , .A1 ( n1486 ) , .B0 ( n1230 ) , .Y ( n1232 ) ) ;
AOI21XL U446 ( .A0 ( n2098 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2097 ) ) ;
NAND2XL U448 ( .A ( ZBUF_17_24 ) , .B ( temp_acc[9] ) , .Y ( n1111 ) ) ;
INVXL U449 ( .A ( n1831 ) , .Y ( n225 ) ) ;
AOI211XL U450 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2206 ) , .B0 ( n1768 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1769 ) ) ;
AOI21XL ctmTdsLR_1_2203 ( .A0 ( n1531 ) , .A1 ( n1483 ) , .B0 ( tmp_net487 ) , 
    .Y ( n1484 ) ) ;
AND2XL ctmTdsLR_2_2067 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][2] ) , 
    .Y ( tmp_net413 ) ) ;
NOR2XL U455 ( .A ( n2128 ) , .B ( n2122 ) , .Y ( n2121 ) ) ;
NOR2BXL ctmTdsLR_1_842 ( .AN ( n733 ) , .B ( n732 ) , .Y ( n651 ) ) ;
NAND2BXL ctmTdsLR_2_960 ( .AN ( n1783 ) , .B ( tmp_net228 ) , .Y ( n1800 ) ) ;
NOR2XL U459 ( .A ( n2096 ) , .B ( n2132 ) , .Y ( n2098 ) ) ;
AOI21XL U460 ( .A0 ( n2187 ) , .A1 ( n2114 ) , .B0 ( n316 ) , .Y ( n2113 ) ) ;
AOI211XL U461 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2204 ) , .B0 ( n1776 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1777 ) ) ;
NAND2XL U463 ( .A ( n222 ) , .B ( n1859 ) , .Y ( n224 ) ) ;
NAND2XL ctmTdsLR_2_2204 ( .A ( tmp_net486 ) , .B ( n1529 ) , .Y ( n1483 ) ) ;
NOR2XL U465 ( .A ( n2096 ) , .B ( n2128 ) , .Y ( n2095 ) ) ;
NAND2XL ctmTdsLR_1_961 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][10] ) , 
    .Y ( tmp_net229 ) ) ;
NAND3XL ctmTdsLR_1_2087 ( .A ( tmp_net238 ) , .B ( n1371_CDR2 ) , 
    .C ( tmp_net428 ) , .Y ( HFSNET_151 ) ) ;
NAND2XL U468 ( .A ( n1767 ) , .B ( HFSNET_217 ) , .Y ( n1763 ) ) ;
AOI31XL U469 ( .A0 ( n2067 ) , .A1 ( n2066_CDR2 ) , .A2 ( n2065_CDR2 ) , 
    .B0 ( protected_sar_code[0] ) , .Y ( n2069 ) ) ;
NAND2X1 ctmTdsLR_1_843 ( .A ( n55 ) , .B ( n2163 ) , .Y ( HFSNET_323 ) ) ;
NOR2XL U472 ( .A ( n2128 ) , .B ( n2131 ) , .Y ( n2130 ) ) ;
AOI21XL U473 ( .A0 ( n2188 ) , .A1 ( n2117 ) , .B0 ( n316 ) , .Y ( n2116 ) ) ;
AOI21XL U474 ( .A0 ( n222 ) , .A1 ( n1858 ) , .B0 ( n221 ) , .Y ( n223 ) ) ;
NOR2XL U475 ( .A ( n1767 ) , .B ( ZBUF_1431_14 ) , .Y ( n1768 ) ) ;
NOR2XL U476 ( .A ( n2132 ) , .B ( n2131 ) , .Y ( n2136 ) ) ;
OAI21XL ctmTdsLR_1_2101 ( .A0 ( n1512 ) , .A1 ( n1511 ) , .B0 ( tmp_net435 ) , 
    .Y ( n1513 ) ) ;
INVXL U478 ( .A ( n1490 ) , .Y ( n1559 ) ) ;
OAI2BB1X1 ctmTdsLR_2_680 ( .A0N ( \shadow_weights[12][2] ) , .A1N ( n1271 ) , 
    .B0 ( tmp_net32 ) , .Y ( HFSNET_92 ) ) ;
INVXL U481 ( .A ( n1424 ) , .Y ( n1444 ) ) ;
NOR2XL U482 ( .A ( n2125 ) , .B ( n2131 ) , .Y ( n2127 ) ) ;
AOI21XL U483 ( .A0 ( n1930 ) , .A1 ( n1928 ) , .B0 ( n1918 ) , .Y ( n1922 ) ) ;
AOI21XL U484 ( .A0 ( n2191 ) , .A1 ( n2092 ) , .B0 ( n316 ) , .Y ( n2091 ) ) ;
XNOR2XL U485 ( .A ( n1930 ) , .B ( n1929 ) , .Y ( n1934 ) ) ;
INVX4 gre_a_INV_7090_inst_2341 ( .A ( n729 ) , .Y ( gre_a_INV_7090_53 ) ) ;
OAI211XL ctmTdsLR_1_984 ( .A0 ( ZBUF_187_13 ) , .A1 ( temp_acc[0] ) , 
    .B0 ( n738 ) , .C0 ( HFSNET_329 ) , .Y ( n2308 ) ) ;
NAND2XL U488 ( .A ( n1782 ) , .B ( n227 ) , .Y ( n229 ) ) ;
INVXL ctmTdsLR_3_2205 ( .A ( n1530 ) , .Y ( tmp_net486 ) ) ;
AOI222XL ctmTdsLR_2_962 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][10] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][10] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][10] ) , .Y ( tmp_net230 ) ) ;
NOR2BXL ctmTdsLR_1_2016 ( .AN ( n617 ) , .B ( n631 ) , .Y ( HFSNET_321 ) ) ;
NAND2XL ctmTdsLR_1_915 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][22] ) , 
    .Y ( tmp_net196 ) ) ;
NOR2XL ctmTdsLR_4_2158 ( .A ( n1873 ) , .B ( n1872 ) , .Y ( tmp_net462 ) ) ;
XNOR2XL U494 ( .A ( n511 ) , .B ( n464 ) , .Y ( n465 ) ) ;
AOI21XL U495 ( .A0 ( n604 ) , .A1 ( n603 ) , .B0 ( n602 ) , .Y ( n609 ) ) ;
NAND2XL ctmTdsLR_1_880 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[15] ) , 
    .Y ( HFSNET_2 ) ) ;
NAND2XL ctmTdsLR_1_804 ( .A ( n1278 ) , .B ( \shadow_weights[8][10] ) , 
    .Y ( tmp_net123 ) ) ;
AOI21XL U498 ( .A0 ( n2190 ) , .A1 ( n2090 ) , .B0 ( n316 ) , .Y ( n2089 ) ) ;
NOR2XL U499 ( .A ( n2132 ) , .B ( n2122 ) , .Y ( n2124 ) ) ;
OAI2BB1XL ctmTdsLR_3_2068 ( .A0N ( \shadow_weights[15][2] ) , .A1N ( n1702 ) , 
    .B0 ( tmp_net414 ) , .Y ( tmp_net415 ) ) ;
NAND2XL U501 ( .A ( n1891 ) , .B ( n1890 ) , .Y ( n1892 ) ) ;
AOI222XL ctmTdsLR_4_2069 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][2] ) , 
    .B0 ( n1319 ) , .B1 ( \shadow_weights[13][2] ) , .C0 ( n1687 ) , 
    .C1 ( \shadow_weights[2][2] ) , .Y ( tmp_net414 ) ) ;
AOI21XL U503 ( .A0 ( n2081 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2080 ) ) ;
XOR2X1 ctmTdsLR_1_2070 ( .A ( tmp_net416 ) , .B ( temp_acc[29] ) , 
    .Y ( n1652 ) ) ;
NAND2XL U505 ( .A ( HFSNET_161 ) , .B ( temp_acc[8] ) , .Y ( n1112 ) ) ;
NOR4BX1 U506 ( .AN ( n1336_CDR2 ) , .B ( n1335_CDR1 ) , .C ( n1334_CDR2 ) , 
    .D ( HFSNET_49 ) , .Y ( n1340_CDR2 ) ) ;
NAND2BXL ctmTdsLR_1_658 ( .AN ( n158 ) , .B ( n102 ) , .Y ( tmp_net19 ) ) ;
NAND2XL U510 ( .A ( n2112 ) , .B ( n2093 ) , .Y ( n2090 ) ) ;
NOR4BXL U511 ( .AN ( n1408_CDR2 ) , .B ( n1407_CDR1 ) , .C ( n1406_CDR2 ) , 
    .D ( HFSNET_91 ) , .Y ( n1412_CDR2 ) ) ;
NAND2XL U512 ( .A ( n2093 ) , .B ( n2115 ) , .Y ( n2092 ) ) ;
AOI22X1 ctmTdsLR_2_2088 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][23] ) , .B0 ( gre_a_INV_4409_54 ) , 
    .B1 ( \shadow_weights[3][23] ) , .Y ( tmp_net428 ) ) ;
NAND2XL U515 ( .A ( HFSNET_162 ) , .B ( temp_acc[15] ) , .Y ( n1562 ) ) ;
NAND2XL U516 ( .A ( HFSNET_159 ) , .B ( temp_acc[14] ) , .Y ( n1557 ) ) ;
NAND2XL U517 ( .A ( HFSNET_160 ) , .B ( temp_acc[12] ) , .Y ( n1443 ) ) ;
XOR2XL U518 ( .A ( n594 ) , .B ( n534 ) , .Y ( n535 ) ) ;
NOR2XL ctmTdsLR_4_2206 ( .A ( n1531 ) , .B ( n1483 ) , .Y ( tmp_net487 ) ) ;
NAND2XL U520 ( .A ( n1798 ) , .B ( n1797 ) , .Y ( n1799 ) ) ;
XOR2XL U521 ( .A ( n490 ) , .B ( n489 ) , .Y ( n491 ) ) ;
NAND2XL U522 ( .A ( HFSNET_158 ) , .B ( temp_acc[13] ) , .Y ( n1427 ) ) ;
AOI21XL U524 ( .A0 ( n2083 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2082 ) ) ;
AOI211XL U525 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2219 ) , .B0 ( n1876 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1877 ) ) ;
AOI222XL ctmTdsLR_2_916 ( .A0 ( n1687 ) , .A1 ( \shadow_weights[2][22] ) , 
    .B0 ( n1686 ) , .B1 ( \shadow_weights[6][22] ) , .C0 ( n1688 ) , 
    .C1 ( \shadow_weights[15][22] ) , .Y ( tmp_net197 ) ) ;
AOI21XL U527 ( .A0 ( n2088 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2087 ) ) ;
AOI21XL U528 ( .A0 ( n2085 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2084 ) ) ;
NAND2XL U530 ( .A ( n1819 ) , .B ( n1818 ) , .Y ( n1820 ) ) ;
XOR2XL U531 ( .A ( n461 ) , .B ( n439 ) , .Y ( n440 ) ) ;
NAND2XL U532 ( .A ( n2115 ) , .B ( n2119 ) , .Y ( n2117 ) ) ;
XNOR2X1 ctmTdsLR_1_1881 ( .A ( tmp_net285 ) , .B ( n153 ) , .Y ( n1874 ) ) ;
NOR2XL U535 ( .A ( n1844 ) , .B ( ZBUF_1431_14 ) , .Y ( n1845 ) ) ;
NAND2BXL ctmTdsLR_2_659 ( .AN ( n103 ) , .B ( tmp_net19 ) , .Y ( n119 ) ) ;
NAND4XL U537 ( .A ( n1692_CDR2 ) , .B ( n1691_CDR2 ) , .C ( n1690_CDR2 ) , 
    .D ( n1689 ) , .Y ( n1694 ) ) ;
XOR2XL U538 ( .A ( n544 ) , .B ( n543 ) , .Y ( n545 ) ) ;
NOR2X1 ctmTdsLR_2_2071 ( .A ( tmp_net330 ) , .B ( tmp_net379 ) , 
    .Y ( tmp_net416 ) ) ;
NAND3XL ctmTdsLR_2_2018 ( .A ( n1636_CDR1 ) , .B ( tmp_net377 ) , 
    .C ( tmp_net378 ) , .Y ( tmp_net379 ) ) ;
NOR2XL U542 ( .A ( n1775 ) , .B ( ZBUF_1431_14 ) , .Y ( n1776 ) ) ;
AOI21XL U543 ( .A0 ( n2102 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2101 ) ) ;
NAND2XL U544 ( .A ( n1844 ) , .B ( \shadow_weights[18][14] ) , .Y ( n1840 ) ) ;
AOI21XL U545 ( .A0 ( n2104 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2103 ) ) ;
NAND2XL U546 ( .A ( n2112 ) , .B ( n2119 ) , .Y ( n2114 ) ) ;
XOR2XL U547 ( .A ( n497 ) , .B ( n496 ) , .Y ( n498 ) ) ;
AOI21XL U548 ( .A0 ( n2109 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2108 ) ) ;
NAND2X1 ctmTdsLR_1_1993 ( .A ( tmp_net339 ) , .B ( tmp_net364 ) , 
    .Y ( HFSNET_118 ) ) ;
AOI21XL U550 ( .A0 ( n2106 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2105 ) ) ;
INVXL U551 ( .A ( n1797 ) , .Y ( n1787 ) ) ;
AOI21XL ctmTdsLR_2_1994 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][1] ) , .B0 ( tmp_net363 ) , .Y ( tmp_net364 ) ) ;
NAND2XL U553 ( .A ( n1813 ) , .B ( \shadow_weights[18][17] ) , .Y ( n1809 ) ) ;
OAI2BB1XL ctmTdsLR_1_964 ( .A0N ( n1434 ) , .A1N ( n1435 ) , .B0 ( n1432 ) , 
    .Y ( tmp_net231 ) ) ;
NAND4XL ctmTdsLR_3_1995 ( .A ( tmp_net342 ) , .B ( n673_CDR1 ) , 
    .C ( tmp_net361 ) , .D ( tmp_net362 ) , .Y ( tmp_net363 ) ) ;
NOR2XL U556 ( .A ( n1874 ) , .B ( ZBUF_1431_14 ) , .Y ( n1876 ) ) ;
AOI21XL U557 ( .A0 ( n244 ) , .A1 ( n242 ) , .B0 ( n91 ) , .Y ( n240 ) ) ;
NOR2XL U558 ( .A ( n1813 ) , .B ( ZBUF_1431_14 ) , .Y ( n1814 ) ) ;
NOR2XL U559 ( .A ( n2125 ) , .B ( n2086 ) , .Y ( n2083 ) ) ;
OAI2BB1XL U560 ( .A0N ( \shadow_weights[7][10] ) , .A1N ( HFSNET_322 ) , 
    .B0 ( n1118_CDR1 ) , .Y ( n1123_CDR1 ) ) ;
XOR2XL U561 ( .A ( n1948 ) , .B ( n1947 ) , .Y ( n1952 ) ) ;
INVXL U562 ( .A ( n1818 ) , .Y ( n1806 ) ) ;
NOR2XL U563 ( .A ( n2128 ) , .B ( n2086 ) , .Y ( n2085 ) ) ;
NAND2XL ctmTdsLR_3_917 ( .A ( n1319 ) , .B ( \shadow_weights[13][22] ) , 
    .Y ( tmp_net198 ) ) ;
NAND2XL U565 ( .A ( n1865 ) , .B ( \shadow_weights[18][12] ) , .Y ( n1861 ) ) ;
NOR2XL U566 ( .A ( n2132 ) , .B ( n2086 ) , .Y ( n2088 ) ) ;
OR2XL ctmTdsLR_1_2072 ( .A ( tmp_net419 ) , .B ( ZBUF_2_29 ) , 
    .Y ( HFSNET_153 ) ) ;
AOI21XL U568 ( .A0 ( n539 ) , .A1 ( n538 ) , .B0 ( n537 ) , .Y ( n544 ) ) ;
NAND2XL ctmTdsLR_4_1996 ( .A ( n1702 ) , .B ( \shadow_weights[15][1] ) , 
    .Y ( tmp_net361 ) ) ;
NOR2XL U571 ( .A ( n2132 ) , .B ( n2107 ) , .Y ( n2109 ) ) ;
NOR2BX2 ctmTdsLR_1_2089 ( .AN ( avg_cnt[4] ) , .B ( n1978 ) , 
    .Y ( HFSNET_177 ) ) ;
NOR2XL U573 ( .A ( n2128 ) , .B ( n2107 ) , .Y ( n2106 ) ) ;
INVXL U574 ( .A ( n1879 ) , .Y ( n1891 ) ) ;
OAI2BB1XL U575 ( .A0N ( \shadow_weights[7][2] ) , .A1N ( HFSNET_322 ) , 
    .B0 ( n742_CDR2 ) , .Y ( n747_CDR2 ) ) ;
OAI2BB1XL U576 ( .A0N ( \shadow_weights[11][5] ) , .A1N ( n1275 ) , 
    .B0 ( n1005_CDR1 ) , .Y ( n1010_CDR1 ) ) ;
INVXL U577 ( .A ( n1890 ) , .Y ( n1880 ) ) ;
NOR2XL U578 ( .A ( n2125 ) , .B ( n2107 ) , .Y ( n2104 ) ) ;
AOI21XL U579 ( .A0 ( n550 ) , .A1 ( n493 ) , .B0 ( n492 ) , .Y ( n497 ) ) ;
NAND2XL U580 ( .A ( n1793 ) , .B ( \shadow_weights[18][19] ) , .Y ( n1789 ) ) ;
OAI2BB1XL U581 ( .A0N ( \shadow_weights[9][26] ) , .A1N ( n1662 ) , 
    .B0 ( n1534_CDR2 ) , .Y ( n1539_CDR2 ) ) ;
AOI222XL ctmTdsLR_5_1997 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][1] ) , 
    .B0 ( n1292 ) , .B1 ( \shadow_weights[2][1] ) , .C0 ( n1319 ) , 
    .C1 ( \shadow_weights[13][1] ) , .Y ( tmp_net362 ) ) ;
XNOR2XL U583 ( .A ( n435 ) , .B ( n421 ) , .Y ( n422 ) ) ;
NOR2XL U584 ( .A ( n2100 ) , .B ( n2107 ) , .Y ( n2102 ) ) ;
OAI2BB1XL U585 ( .A0N ( \shadow_weights[11][25] ) , .A1N ( n1663 ) , 
    .B0 ( n1469_CDR2 ) , .Y ( n1474_CDR2 ) ) ;
OAI2BB1XL U586 ( .A0N ( \shadow_weights[11][18] ) , .A1N ( n1275 ) , 
    .B0 ( n1276_CDR2 ) , .Y ( n1287_CDR2 ) ) ;
AOI21XL U587 ( .A0 ( n550 ) , .A1 ( n486 ) , .B0 ( n485 ) , .Y ( n490 ) ) ;
NAND2XL ctmTdsLR_1_660 ( .A ( n422 ) , .B ( HFSNET_325 ) , .Y ( HFSNET_9 ) ) ;
NAND2XL ctmTdsLR_1_661 ( .A ( n1278 ) , .B ( \shadow_weights[8][18] ) , 
    .Y ( tmp_net20 ) ) ;
INVXL U590 ( .A ( n531 ) , .Y ( n594 ) ) ;
NAND4BXL ctmTdsLR_2_2073 ( .AN ( n991_CDR2 ) , .B ( tmp_net199 ) , 
    .C ( tmp_net417 ) , .D ( tmp_net418 ) , .Y ( tmp_net419 ) ) ;
INVXL U592 ( .A ( n1805 ) , .Y ( n1819 ) ) ;
OAI2BB1XL U593 ( .A0N ( \shadow_weights[3][20] ) , 
    .A1N ( gre_a_INV_4409_54 ) , .B0 ( n1329_CDR2 ) , .Y ( n1334_CDR2 ) ) ;
NOR2XL U595 ( .A ( n2100 ) , .B ( n2086 ) , .Y ( n2081 ) ) ;
OAI2BB1XL U596 ( .A0N ( \shadow_weights[7][9] ) , .A1N ( HFSNET_322 ) , 
    .B0 ( n1093 ) , .Y ( n1098 ) ) ;
AOI222XL ctmTdsLR_3_2074 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][4] ) , 
    .B0 ( n1319 ) , .B1 ( \shadow_weights[13][4] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][4] ) , .Y ( tmp_net417 ) ) ;
NOR2XL U598 ( .A ( n1853 ) , .B ( ZBUF_1431_14 ) , .Y ( n1854 ) ) ;
AOI211XL U599 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2215 ) , .B0 ( n1895 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1896 ) ) ;
OAI2BB1XL ctmTdsLR_2_1882 ( .A0N ( n165 ) , .A1N ( n167 ) , .B0 ( n164 ) , 
    .Y ( tmp_net285 ) ) ;
INVXL HFSINV_34_398 ( .A ( n1226 ) , .Y ( HFSNET_160 ) ) ;
NAND2XL ctmTdsLR_1_881 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[6] ) , 
    .Y ( HFSNET_3 ) ) ;
OAI2BB1XL U603 ( .A0N ( \shadow_weights[9][4] ) , .A1N ( n1274 ) , 
    .B0 ( n985_CDR1 ) , .Y ( n990_CDR1 ) ) ;
OAI2BB1XL U604 ( .A0N ( \shadow_weights[11][24] ) , .A1N ( n1663 ) , 
    .B0 ( n1401_CDR2 ) , .Y ( n1406_CDR2 ) ) ;
NOR2XL U605 ( .A ( n1865 ) , .B ( ZBUF_1431_14 ) , .Y ( n1866 ) ) ;
OAI2BB1XL U606 ( .A0N ( \shadow_weights[7][21] ) , .A1N ( HFSNET_322 ) , 
    .B0 ( n1343_CDR2 ) , .Y ( n1348_CDR2 ) ) ;
AOI211XL U607 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2205 ) , .B0 ( n1802 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1803 ) ) ;
NAND2XL ctmTdsLR_2_2102 ( .A ( n1512 ) , .B ( n1511 ) , .Y ( tmp_net435 ) ) ;
INVX1 ctmTdsLR_1_2090 ( .A ( tmp_net429 ) , .Y ( ZBUF_17_27 ) ) ;
AOI222X1 ctmTdsLR_1_1883 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][19] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][19] ) , .C0 ( n1673 ) , 
    .C1 ( \shadow_weights[17][19] ) , .Y ( tmp_net286 ) ) ;
OAI21XL ctmTdsLR_1_2109 ( .A0 ( tmp_net6 ) , .A1 ( n554 ) , 
    .B0 ( tmp_net439 ) , .Y ( n556 ) ) ;
NAND2XL ctmTdsLR_4_2075 ( .A ( n1688 ) , .B ( \shadow_weights[15][4] ) , 
    .Y ( tmp_net418 ) ) ;
OAI2BB1XL U613 ( .A0N ( \shadow_weights[3][17] ) , 
    .A1N ( gre_a_INV_4409_54 ) , .B0 ( n1253_CDR2 ) , .Y ( n1259_CDR2 ) ) ;
AOI21XL U615 ( .A0 ( n531 ) , .A1 ( n533 ) , .B0 ( n523 ) , .Y ( n528 ) ) ;
INVXL gre_a_INV_6_inst_2304 ( .A ( gre_a_INV_1726_48 ) , 
    .Y ( gre_a_INV_6_48 ) ) ;
NOR2XL U617 ( .A ( n1894 ) , .B ( ZBUF_1431_14 ) , .Y ( n1895 ) ) ;
XNOR2X1 ctmTdsLR_2_965 ( .A ( tmp_net231 ) , .B ( n1439 ) , .Y ( n1441 ) ) ;
INVXL U619 ( .A ( n455 ) , .Y ( n550 ) ) ;
NAND2XL ctmTdsLR_1_882 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[14] ) , 
    .Y ( HFSNET_4 ) ) ;
AND3XL ctmTdsLR_2_1941 ( .A ( tmp_net314 ) , .B ( tmp_net313 ) , 
    .C ( tmp_net41 ) , .Y ( tmp_net325 ) ) ;
AOI22XL ctmTdsLR_3_2019 ( .A0 ( n1688 ) , .A1 ( \shadow_weights[15][29] ) , 
    .B0 ( n1319 ) , .B1 ( \shadow_weights[13][29] ) , .Y ( tmp_net377 ) ) ;
NAND2XL ctmTdsLR_1_883 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[10] ) , 
    .Y ( HFSNET_5 ) ) ;
AOI211XL ctmTdsLR_1_706 ( .A0 ( n732 ) , .A1 ( n733 ) , .B0 ( n735 ) , 
    .C0 ( n731 ) , .Y ( n822 ) ) ;
NAND2XL U625 ( .A ( n1688 ) , .B ( \shadow_weights[15][10] ) , .Y ( n1126 ) ) ;
NAND2XL U626 ( .A ( n1688 ) , .B ( protected_sar_code[15] ) , .Y ( n1689 ) ) ;
INVX4 gre_a_INV_2579_inst_2348 ( .A ( n55 ) , .Y ( gre_a_INV_2579_54 ) ) ;
OR2XL U628 ( .A ( n1697 ) , .B ( n1696 ) , .Y ( N1614 ) ) ;
AOI222XL ctmTdsLR_4_2020 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][29] ) , .B0 ( n1686 ) , 
    .B1 ( \shadow_weights[6][29] ) , .C0 ( n1687 ) , 
    .C1 ( \shadow_weights[2][29] ) , .Y ( tmp_net378 ) ) ;
AND4XL ctmTdsLR_2_2091 ( .A ( n1162_CDR2 ) , .B ( tmp_net218 ) , 
    .C ( tmp_net217 ) , .D ( tmp_net219 ) , .Y ( tmp_net429 ) ) ;
OR2XL ctmTdsLR_1_2076 ( .A ( tmp_net397 ) , .B ( tmp_net422 ) , 
    .Y ( HFSNET_123 ) ) ;
NAND4XL ctmTdsLR_2_2077 ( .A ( tmp_net136 ) , .B ( ZBUF_2_47 ) , 
    .C ( tmp_net421 ) , .D ( tmp_net135 ) , .Y ( tmp_net422 ) ) ;
NAND2XL ctmTdsLR_1_884 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[20] ) , 
    .Y ( HFSNET_6 ) ) ;
NAND2XL ctmTdsLR_1_707 ( .A ( n1918 ) , .B ( n1920 ) , .Y ( tmp_net51 ) ) ;
AOI21XL ctmTdsLR_1_2131 ( .A0 ( n1582 ) , .A1 ( tmp_net449 ) , 
    .B0 ( tmp_net450 ) , .Y ( n1583 ) ) ;
NAND2XL ctmTdsLR_3_968 ( .A ( n1319 ) , .B ( \shadow_weights[13][21] ) , 
    .Y ( tmp_net234 ) ) ;
NOR2BXL ctmTdsLR_1_2021 ( .AN ( ZBUF_2_26 ) , .B ( tmp_net382 ) , 
    .Y ( n1368_CDR2 ) ) ;
NAND2XL U639 ( .A ( n1801 ) , .B ( \shadow_weights[18][18] ) , .Y ( n1797 ) ) ;
AOI211XL U640 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2224 ) , .B0 ( n1924 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1925 ) ) ;
AND3XL ctmTdsLR_3_2078 ( .A ( n1046_CDR1 ) , .B ( tmp_net420 ) , 
    .C ( n1039_CDR1 ) , .Y ( tmp_net421 ) ) ;
NAND2XL ctmTdsLR_4_2079 ( .A ( HFSNET_322 ) , .B ( \shadow_weights[7][7] ) , 
    .Y ( tmp_net420 ) ) ;
NAND2XL U644 ( .A ( n1886 ) , .B ( \shadow_weights[18][10] ) , .Y ( n1882 ) ) ;
AOI222XL ctmTdsLR_1_970 ( .A0 ( n1687 ) , .A1 ( \shadow_weights[2][23] ) , 
    .B0 ( n1661 ) , .B1 ( \shadow_weights[1][23] ) , .C0 ( n1702 ) , 
    .C1 ( \shadow_weights[15][23] ) , .Y ( tmp_net235 ) ) ;
NAND2XL U646 ( .A ( n1913 ) , .B ( \shadow_weights[18][7] ) , .Y ( n1909 ) ) ;
NOR2XL U647 ( .A ( n1913 ) , .B ( ZBUF_1431_14 ) , .Y ( n1914 ) ) ;
NAND4X1 ctmTdsLR_1_2001 ( .A ( ZBUF_2_4 ) , .B ( tmp_net354 ) , 
    .C ( tmp_net144 ) , .D ( tmp_net367 ) , .Y ( HFSNET_161 ) ) ;
NAND2XL ctmTdsLR_2_971 ( .A ( n1319 ) , .B ( \shadow_weights[13][23] ) , 
    .Y ( tmp_net236 ) ) ;
INVXL U650 ( .A ( n1927 ) , .Y ( n1918 ) ) ;
NAND2XL ctmTdsLR_1_919 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][4] ) , 
    .Y ( tmp_net199 ) ) ;
NAND2XL U652 ( .A ( n1928 ) , .B ( n1920 ) , .Y ( n205 ) ) ;
NAND4XL ctmTdsLR_2_2022 ( .A ( tmp_net381 ) , .B ( n1356_CDR1 ) , 
    .C ( n1364_CDR2 ) , .D ( ZBUF_2_14 ) , .Y ( tmp_net382 ) ) ;
NAND3XL ctmTdsLR_1_2092 ( .A ( tmp_net430 ) , .B ( tmp_net431 ) , 
    .C ( tmp_net133 ) , .Y ( HFSNET_42 ) ) ;
NOR2BXL ctmTdsLR_2_2002 ( .AN ( n1071 ) , .B ( n1069_CDR2 ) , 
    .Y ( tmp_net367 ) ) ;
NAND3XL ctmTdsLR_3_972 ( .A ( tmp_net235 ) , .B ( n1378_CDR1 ) , 
    .C ( tmp_net236 ) , .Y ( tmp_net237 ) ) ;
NOR3X1 ctmTdsLR_4_973 ( .A ( tmp_net237 ) , .B ( n1377_CDR2 ) , 
    .C ( HFSNET_78 ) , .Y ( tmp_net238 ) ) ;
AOI22XL ctmTdsLR_2_2093 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][15] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][15] ) , .Y ( tmp_net430 ) ) ;
AOI222XL ctmTdsLR_3_2094 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][15] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][15] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][15] ) , .Y ( tmp_net431 ) ) ;
OAI211XL ctmTdsLR_2_708 ( .A0 ( n1917 ) , .A1 ( n205 ) , .B0 ( tmp_net51 ) , 
    .C0 ( n1919 ) , .Y ( n1898 ) ) ;
NAND2XL ctmTdsLR_1_885 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[28] ) , 
    .Y ( HFSNET_7 ) ) ;
NAND2XL ctmTdsLR_1_852 ( .A ( tmp_net141 ) , .B ( n1476_CDR2 ) , 
    .Y ( tmp_net156 ) ) ;
NAND4XL ctmTdsLR_2_853 ( .A ( tmp_net142 ) , .B ( n1471_CDR1 ) , 
    .C ( n1467_CDR1 ) , .D ( n1470_CDR1 ) , .Y ( tmp_net157 ) ) ;
NAND2BXL ctmTdsLR_1_643 ( .AN ( n594 ) , .B ( n590 ) , .Y ( tmp_net8 ) ) ;
NAND2BXL ctmTdsLR_2_644 ( .AN ( n591 ) , .B ( tmp_net8 ) , .Y ( n604 ) ) ;
AOI21XL U666 ( .A0 ( n110 ) , .A1 ( n156 ) , .B0 ( n109 ) , .Y ( n115 ) ) ;
NOR3XL U667 ( .A ( state[0] ) , .B ( state[3] ) , .C ( n657 ) , .Y ( n662 ) ) ;
OAI2BB1XL U668 ( .A0N ( \shadow_weights[3][15] ) , 
    .A1N ( gre_a_INV_4409_54 ) , .B0 ( n1209_CDR1 ) , .Y ( n1215_CDR1 ) ) ;
AOI211XL U669 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2220 ) , .B0 ( n1950 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1951 ) ) ;
AOI21XL U670 ( .A0 ( n134 ) , .A1 ( n132 ) , .B0 ( n126 ) , .Y ( n130 ) ) ;
OAI2BB1XL U671 ( .A0N ( \shadow_weights[7][13] ) , .A1N ( HFSNET_322 ) , 
    .B0 ( n1181_CDR1 ) , .Y ( n1186_CDR1 ) ) ;
NOR2XL U672 ( .A ( n1923 ) , .B ( ZBUF_1431_14 ) , .Y ( n1924 ) ) ;
NAND2XL U673 ( .A ( n1904 ) , .B ( \shadow_weights[18][8] ) , .Y ( n1900 ) ) ;
NAND3X1 ctmTdsLR_1_2080 ( .A ( tmp_net193 ) , .B ( tmp_net426 ) , 
    .C ( tmp_net324 ) , .Y ( HFSNET_159 ) ) ;
OAI2BB1XL U676 ( .A0N ( \shadow_weights[7][12] ) , .A1N ( HFSNET_322 ) , 
    .B0 ( n1167_CDR2 ) , .Y ( n1172_CDR2 ) ) ;
OAI2BB1XL U677 ( .A0N ( \shadow_weights[7][8] ) , .A1N ( HFSNET_322 ) , 
    .B0 ( n1064_CDR2 ) , .Y ( n1069_CDR2 ) ) ;
OAI2BB1X1 U678 ( .A0N ( \shadow_weights[7][14] ) , .A1N ( HFSNET_322 ) , 
    .B0 ( n1195_CDR2 ) , .Y ( n1200_CDR2 ) ) ;
NOR2XL U679 ( .A ( n1904 ) , .B ( ZBUF_1431_14 ) , .Y ( n1905 ) ) ;
AOI211XL U680 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2228 ) , .B0 ( n1940 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1942 ) ) ;
INVXL U681 ( .A ( n1935 ) , .Y ( n189 ) ) ;
NAND4XL U682 ( .A ( n968 ) , .B ( n1658 ) , .C ( n1657 ) , .D ( n823 ) , 
    .Y ( N1485 ) ) ;
AOI211XL U683 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2217 ) , .B0 ( n1958 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n1959 ) ) ;
NAND2XL U684 ( .A ( n1923 ) , .B ( \shadow_weights[18][6] ) , .Y ( n1919 ) ) ;
NAND2XL U685 ( .A ( n1931 ) , .B ( \shadow_weights[18][5] ) , .Y ( n1927 ) ) ;
NAND2XL ctmTdsLR_2_1884 ( .A ( gre_a_INV_4409_54 ) , 
    .B ( \shadow_weights[3][19] ) , .Y ( tmp_net287 ) ) ;
AOI222XL ctmTdsLR_2_1886 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][6] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][6] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][6] ) , .Y ( tmp_net288 ) ) ;
NAND2XL ctmTdsLR_3_854 ( .A ( n1468_CDR2 ) , .B ( n1472_CDR1 ) , 
    .Y ( tmp_net158 ) ) ;
INVX4 gre_a_INV_1726_inst_2305 ( .A ( calc_result_r[13] ) , 
    .Y ( gre_a_INV_1726_48 ) ) ;
OR4XL ctmTdsLR_4_855 ( .A ( tmp_net156 ) , .B ( n1474_CDR2 ) , 
    .C ( tmp_net157 ) , .D ( tmp_net158 ) , .Y ( HFSNET_156 ) ) ;
XNOR2X1 ctmTdsLR_1_2097 ( .A ( tmp_net433 ) , .B ( n1564 ) , .Y ( n1567 ) ) ;
NAND2XL U692 ( .A ( n1370_CDR2 ) , .B ( n1369_CDR2 ) , .Y ( n1377_CDR2 ) ) ;
AOI211XL ctmTdsLR_1_1870 ( .A0 ( HFSNET_322 ) , 
    .A1 ( \shadow_weights[7][16] ) , .B0 ( tmp_net277 ) , .C0 ( tmp_net280 ) , 
    .Y ( n1250_CDR2 ) ) ;
CLKBUFX8 ZCTSBUF_255_1368 ( .A ( net1826 ) , .Y ( ZCTSNET_366 ) ) ;
INVXL gre_a_INV_6_inst_2306 ( .A ( gre_a_INV_1764_49 ) , 
    .Y ( gre_a_INV_6_49 ) ) ;
OR3X1 ctmTdsLR_1_886 ( .A ( n614 ) , .B ( calc_cnt[4] ) , .C ( calc_cnt[3] ) , 
    .Y ( n1210 ) ) ;
NAND3XL ctmTdsLR_1_809 ( .A ( tmp_net110 ) , .B ( n1532_CDR2 ) , 
    .C ( n1537_CDR2 ) , .Y ( tmp_net127 ) ) ;
OAI2BB1XL ctmTdsLR_2_2098 ( .A0N ( n1559 ) , .A1N ( n1560 ) , .B0 ( n1557 ) , 
    .Y ( tmp_net433 ) ) ;
NAND2XL U699 ( .A ( n1682_CDR2 ) , .B ( n1681_CDR2 ) , .Y ( n1683_CDR2 ) ) ;
NAND4XL ctmTdsLR_2_810 ( .A ( n1533_CDR2 ) , .B ( tmp_net109 ) , 
    .C ( n1535_CDR2 ) , .D ( n1536_CDR1 ) , .Y ( tmp_net128 ) ) ;
NAND4XL ctmTdsLR_1_856 ( .A ( n1592_CDR1 ) , .B ( n1591_CDR1 ) , 
    .C ( n1589_CDR2 ) , .D ( n1593_CDR2 ) , .Y ( tmp_net159 ) ) ;
NOR3XL ctmTdsLR_2_2081 ( .A ( tmp_net425 ) , .B ( n1200_CDR2 ) , 
    .C ( n1201_CDR2 ) , .Y ( tmp_net426 ) ) ;
NAND2XL U703 ( .A ( n1273_CDR1 ) , .B ( n1272_CDR1 ) , .Y ( n1288_CDR1 ) ) ;
AOI2BB2XL U704 ( .B0 ( n2078 ) , .B1 ( n2077 ) , .A0N ( n2076 ) , 
    .A1N ( n2075 ) , .Y ( n793 ) ) ;
NOR3XL ctmTdsLR_3_811 ( .A ( n1539_CDR2 ) , .B ( tmp_net127 ) , 
    .C ( tmp_net128 ) , .Y ( tmp_net129 ) ) ;
OAI2BB1XL ctmTdsLR_1_976 ( .A0N ( n1632 ) , .A1N ( n1633 ) , .B0 ( n1630 ) , 
    .Y ( tmp_net240 ) ) ;
CLKINVX8 gre_a_INV_1764_inst_2307 ( .A ( calc_result_r[12] ) , 
    .Y ( gre_a_INV_1764_49 ) ) ;
NAND3XL ctmTdsLR_3_2082 ( .A ( tmp_net423 ) , .B ( tmp_net424 ) , 
    .C ( n1202_CDR1 ) , .Y ( tmp_net425 ) ) ;
NAND2XL ctmTdsLR_4_2083 ( .A ( n1688 ) , .B ( \shadow_weights[15][14] ) , 
    .Y ( tmp_net423 ) ) ;
NOR2BX1 ctmTdsLR_2_857 ( .AN ( tmp_net139 ) , .B ( tmp_net159 ) , 
    .Y ( tmp_net160 ) ) ;
AOI22XL U711 ( .A0 ( ZBUF_3430_2 ) , .A1 ( protected_sar_code[0] ) , 
    .B0 ( n1677 ) , .B1 ( protected_sar_code[5] ) , .Y ( n1691_CDR2 ) ) ;
NAND3XL ctmTdsLR_1_1862 ( .A ( tmp_net20 ) , .B ( tmp_net272 ) , 
    .C ( tmp_net273 ) , .Y ( HFSNET_97 ) ) ;
AOI21XL ctmTdsLR_1_887 ( .A0 ( n1779 ) , .A1 ( n1827 ) , .B0 ( n1828 ) , 
    .Y ( tmp_net176 ) ) ;
NAND2XL ctmTdsLR_4_812 ( .A ( tmp_net129 ) , .B ( n1541_CDR1 ) , 
    .Y ( HFSNET_146 ) ) ;
AOI21XL ctmTdsLR_1_2207 ( .A0 ( n1608 ) , .A1 ( n1604 ) , .B0 ( tmp_net489 ) , 
    .Y ( n1605 ) ) ;
XOR2X1 ctmTdsLR_2_888 ( .A ( tmp_net176 ) , .B ( n1833 ) , .Y ( n1838 ) ) ;
AOI222X1 ctmTdsLR_1_813 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][15] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][15] ) , 
    .C0 ( n1270 ) , .C1 ( \shadow_weights[14][15] ) , .Y ( tmp_net130 ) ) ;
AOI222XL ctmTdsLR_5_2084 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][14] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][14] ) , .C0 ( n1292 ) , 
    .C1 ( \shadow_weights[2][14] ) , .Y ( tmp_net424 ) ) ;
OAI21XL ctmTdsLR_1_2103 ( .A0 ( n1734 ) , .A1 ( n1733 ) , .B0 ( tmp_net437 ) , 
    .Y ( n1739 ) ) ;
AOI222XL ctmTdsLR_2_1863 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][18] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][18] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][18] ) , .Y ( tmp_net272 ) ) ;
OAI2BB1X1 ctmTdsLR_2_814 ( .A0N ( \shadow_weights[12][15] ) , .A1N ( n1271 ) , 
    .B0 ( tmp_net130 ) , .Y ( HFSNET_41 ) ) ;
AOI22XL ctmTdsLR_1_860 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][0] ) , 
    .B0 ( n1702 ) , .B1 ( \shadow_weights[15][0] ) , .Y ( tmp_net162 ) ) ;
AOI22XL ctmTdsLR_3_1864 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][18] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][18] ) , .Y ( tmp_net273 ) ) ;
AND3X2 ctmTdsLR_2_1943 ( .A ( tmp_net301 ) , .B ( tmp_net300 ) , 
    .C ( tmp_net64 ) , .Y ( tmp_net326 ) ) ;
NAND2XL U725 ( .A ( n1328_CDR1 ) , .B ( n1327 ) , .Y ( n1335_CDR1 ) ) ;
AOI22XL U726 ( .A0 ( n1687 ) , .A1 ( protected_sar_code[2] ) , .B0 ( n1686 ) , 
    .B1 ( protected_sar_code[6] ) , .Y ( n1690_CDR2 ) ) ;
NAND2XL U727 ( .A ( n1400_CDR1 ) , .B ( n1399_CDR1 ) , .Y ( n1407_CDR1 ) ) ;
NAND2XL ctmTdsLR_2_2104 ( .A ( tmp_net436 ) , .B ( n1731 ) , .Y ( n1733 ) ) ;
NAND2XL ctmTdsLR_1_711 ( .A ( n1456 ) , .B ( n1459 ) , .Y ( tmp_net53 ) ) ;
INVXL ctmTdsLR_3_2105 ( .A ( n1730 ) , .Y ( tmp_net436 ) ) ;
OAI211X1 ctmTdsLR_2_712 ( .A0 ( n1417 ) , .A1 ( n1398 ) , .B0 ( tmp_net53 ) , 
    .C0 ( n1458 ) , .Y ( n1466 ) ) ;
NAND2XL U732 ( .A ( n1117_CDR2 ) , .B ( n1116_CDR2 ) , .Y ( n1124_CDR2 ) ) ;
NAND3XL ctmTdsLR_2_1871 ( .A ( n1238_CDR2 ) , .B ( n1237_CDR2 ) , 
    .C ( n1239_CDR2 ) , .Y ( tmp_net277 ) ) ;
NAND2XL ctmTdsLR_1_717 ( .A ( n1278 ) , .B ( \shadow_weights[8][4] ) , 
    .Y ( tmp_net56 ) ) ;
CLKINVX4 gre_a_INV_2209_inst_2339 ( .A ( n2009 ) , .Y ( gre_a_INV_2209_53 ) ) ;
BUFX8 ZCTSBUF_247_1371 ( .A ( net1660 ) , .Y ( ZCTSNET_369 ) ) ;
INVXL ctmTdsLR_1_889 ( .A ( n1261_CDR2 ) , .Y ( tmp_net177 ) ) ;
AOI222XL ctmTdsLR_2_1858 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][16] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][16] ) , .C0 ( n1280 ) , 
    .C1 ( \shadow_weights[18][16] ) , .Y ( tmp_net269 ) ) ;
NAND2XL U739 ( .A ( n1939 ) , .B ( \shadow_weights[18][4] ) , .Y ( n1935 ) ) ;
NAND2XL ctmTdsLR_4_2106 ( .A ( n1734 ) , .B ( n1733 ) , .Y ( tmp_net437 ) ) ;
NAND2XL ctmTdsLR_2_2110 ( .A ( tmp_net6 ) , .B ( n554 ) , .Y ( tmp_net439 ) ) ;
AOI21XL ctmTdsLR_1_2111 ( .A0 ( n1723 ) , .A1 ( n1724 ) , .B0 ( tmp_net441 ) , 
    .Y ( n1728 ) ) ;
AOI222XL ctmTdsLR_3_1859 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][16] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][16] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][16] ) , .Y ( tmp_net270 ) ) ;
NAND2XL ctmTdsLR_2_2112 ( .A ( tmp_net440 ) , .B ( n1721 ) , .Y ( n1723 ) ) ;
NAND4XL ctmTdsLR_2_890 ( .A ( tmp_net346 ) , .B ( tmp_net347 ) , 
    .C ( tmp_net348 ) , .D ( tmp_net349 ) , .Y ( tmp_net178 ) ) ;
INVXL U746 ( .A ( n376 ) , .Y ( n443 ) ) ;
INVXL ctmTdsLR_3_2113 ( .A ( n1720 ) , .Y ( tmp_net440 ) ) ;
AND3X4 ctmTdsLR_2_1945 ( .A ( tmp_net294 ) , .B ( tmp_net56 ) , 
    .C ( tmp_net293 ) , .Y ( tmp_net327 ) ) ;
NAND2X1 U749 ( .A ( n1004_CDR2 ) , .B ( n1003_CDR2 ) , .Y ( n1011_CDR1 ) ) ;
NOR2XL ctmTdsLR_4_2114 ( .A ( n1724 ) , .B ( n1723 ) , .Y ( tmp_net441 ) ) ;
BUFX16 ZCTSBUF_251_1374 ( .A ( net1726 ) , .Y ( ZCTSNET_372 ) ) ;
NAND2XL ctmTdsLR_4_2118 ( .A ( n1903 ) , .B ( n1902 ) , .Y ( tmp_net443 ) ) ;
BUFX4 ZBUF_3430_inst_1002 ( .A ( HFSNET_321 ) , .Y ( ZBUF_3430_2 ) ) ;
NAND2XL ctmTdsLR_3_929 ( .A ( n1319 ) , .B ( \shadow_weights[13][28] ) , 
    .Y ( tmp_net207 ) ) ;
BUFX1 ropt_mt_inst_2352 ( .A ( n2182 ) , .Y ( ropt_net_531 ) ) ;
CLKBUFX3 ctmTdsLR_1_2119 ( .A ( calc_result_r[11] ) , .Y ( HFSNET_289 ) ) ;
AOI21XL ctmTdsLR_3_2023 ( .A0 ( HFSNET_322 ) , 
    .A1 ( \shadow_weights[7][22] ) , .B0 ( tmp_net380 ) , .Y ( tmp_net381 ) ) ;
NAND2XL ctmTdsLR_3_817 ( .A ( n1279 ) , .B ( \shadow_weights[16][15] ) , 
    .Y ( tmp_net133 ) ) ;
INVXL U759 ( .A ( n1953 ) , .Y ( n177 ) ) ;
NAND2X2 U760 ( .A ( n984 ) , .B ( n983_CDR2 ) , .Y ( n991_CDR2 ) ) ;
NAND2XL ctmTdsLR_4_2024 ( .A ( n1357_CDR1 ) , .B ( n1355_CDR2 ) , 
    .Y ( tmp_net380 ) ) ;
NAND3X1 ctmTdsLR_1_2120 ( .A ( n1250_CDR2 ) , .B ( tmp_net117 ) , 
    .C ( tmp_net118 ) , .Y ( ZBUF_24_23 ) ) ;
NAND2XL U763 ( .A ( n1949 ) , .B ( \shadow_weights[18][3] ) , .Y ( n1945 ) ) ;
OAI21XL ctmTdsLR_1_2121 ( .A0 ( n1714 ) , .A1 ( n1715 ) , .B0 ( tmp_net444 ) , 
    .Y ( n1719 ) ) ;
NAND4XL ctmTdsLR_2_1947 ( .A ( n1634_CDR2 ) , .B ( tmp_net328 ) , 
    .C ( tmp_net329 ) , .D ( n1635_CDR2 ) , .Y ( tmp_net330 ) ) ;
BUFX1 ZBUF_2_inst_1004 ( .A ( tmp_net39 ) , .Y ( ZBUF_2_4 ) ) ;
INVX1 ctmTdsLR_1_2025 ( .A ( tmp_net383 ) , .Y ( ZBUF_187_13 ) ) ;
NAND3XL ctmTdsLR_1_2006 ( .A ( tmp_net370 ) , .B ( tmp_net371 ) , 
    .C ( tmp_net372 ) , .Y ( HFSNET_78 ) ) ;
AOI22XL ctmTdsLR_3_1887 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][6] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][6] ) , .Y ( tmp_net289 ) ) ;
AOI22XL ctmTdsLR_2_2007 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][23] ) , 
    .B0 ( n1671 ) , .B1 ( \shadow_weights[18][23] ) , .Y ( tmp_net370 ) ) ;
NAND3XL U771 ( .A ( n1676_CDR2 ) , .B ( n1675_CDR2 ) , .C ( n1674_CDR2 ) , 
    .Y ( n1684_CDR2 ) ) ;
NAND2XL ctmTdsLR_1_653 ( .A ( n1278 ) , .B ( \shadow_weights[8][13] ) , 
    .Y ( tmp_net15 ) ) ;
NAND4XL ctmTdsLR_3_1872 ( .A ( tmp_net278 ) , .B ( tmp_net279 ) , 
    .C ( ZBUF_2_24 ) , .D ( ZBUF_2_42 ) , .Y ( tmp_net280 ) ) ;
NAND2XL ctmTdsLR_4_1873 ( .A ( n1267 ) , .B ( \shadow_weights[1][16] ) , 
    .Y ( tmp_net278 ) ) ;
NAND2XL ctmTdsLR_5_1874 ( .A ( gre_a_INV_4409_54 ) , 
    .B ( \shadow_weights[3][16] ) , .Y ( tmp_net279 ) ) ;
AOI22XL U776 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][10] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][10] ) , .Y ( n1125_CDR1 ) ) ;
NAND4XL ctmTdsLR_3_891 ( .A ( ZBUF_2_27 ) , .B ( tmp_net165 ) , 
    .C ( tmp_net74 ) , .D ( n1252_CDR1 ) , .Y ( tmp_net179 ) ) ;
AOI22XL U778 ( .A0 ( n1661 ) , .A1 ( \shadow_weights[1][25] ) , 
    .B0 ( HFSNET_322 ) , .B1 ( \shadow_weights[7][25] ) , .Y ( n1476_CDR2 ) ) ;
AOI22X1 U779 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][25] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][25] ) , .Y ( n1467_CDR1 ) ) ;
AOI22XL ctmTdsLR_3_2008 ( .A0 ( n1672 ) , .A1 ( \shadow_weights[19][23] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][23] ) , .Y ( tmp_net371 ) ) ;
AOI22XL U781 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][25] ) , 
    .B0 ( n1680 ) , .B1 ( \shadow_weights[12][25] ) , .Y ( n1468_CDR2 ) ) ;
AOI22XL ctmTdsLR_1_820 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][7] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][7] ) , .Y ( tmp_net135 ) ) ;
AOI22XL U783 ( .A0 ( n1267 ) , .A1 ( \shadow_weights[1][17] ) , 
    .B0 ( HFSNET_322 ) , .B1 ( \shadow_weights[7][17] ) , .Y ( n1261_CDR2 ) ) ;
AOI22XL U784 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][25] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][25] ) , .Y ( n1472_CDR1 ) ) ;
AOI222XL ctmTdsLR_2_821 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][7] ) , 
    .B0 ( n1291 ) , .B1 ( \shadow_weights[13][7] ) , .C0 ( ZBUF_3430_2 ) , 
    .C1 ( \shadow_weights[0][7] ) , .Y ( tmp_net136 ) ) ;
AOI22XL U786 ( .A0 ( n1267 ) , .A1 ( \shadow_weights[1][5] ) , .B0 ( n1274 ) , 
    .B1 ( \shadow_weights[9][5] ) , .Y ( n1012_CDR1 ) ) ;
AOI22XL U787 ( .A0 ( n1661 ) , .A1 ( \shadow_weights[1][21] ) , 
    .B0 ( n1663 ) , .B1 ( \shadow_weights[11][21] ) , .Y ( n1350_CDR2 ) ) ;
OR4X1 ctmTdsLR_4_892 ( .A ( tmp_net177 ) , .B ( tmp_net178 ) , 
    .C ( n1259_CDR2 ) , .D ( tmp_net179 ) , .Y ( HFSNET_154 ) ) ;
NAND4XL ctmTdsLR_1_1875 ( .A ( tmp_net281 ) , .B ( tmp_net282 ) , 
    .C ( tmp_net283 ) , .D ( tmp_net284 ) , .Y ( tmp_net115 ) ) ;
AOI22XL U790 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][5] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][5] ) , .Y ( n1004_CDR2 ) ) ;
AOI22XL ctmTdsLR_4_2009 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][23] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][23] ) , .Y ( tmp_net372 ) ) ;
AOI22XL U792 ( .A0 ( n1271 ) , .A1 ( \shadow_weights[12][10] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][10] ) , .Y ( n1116_CDR2 ) ) ;
AOI22XL U793 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][5] ) , 
    .B0 ( n1271 ) , .B1 ( \shadow_weights[12][5] ) , .Y ( n1003_CDR2 ) ) ;
NAND2XL ctmTdsLR_2_2122 ( .A ( n1714 ) , .B ( n1715 ) , .Y ( tmp_net444 ) ) ;
INVX1 ctmTdsLR_1_2125 ( .A ( tmp_net446 ) , .Y ( HFSNET_155 ) ) ;
AOI22XL U796 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][2] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][2] ) , .Y ( n749_CDR1 ) ) ;
AOI22XL U797 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][23] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][23] ) , .Y ( n1369_CDR2 ) ) ;
AOI22XL U798 ( .A0 ( n1663 ) , .A1 ( \shadow_weights[11][23] ) , 
    .B0 ( n1680 ) , .B1 ( \shadow_weights[12][23] ) , .Y ( n1378_CDR1 ) ) ;
AOI22XL U799 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][23] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][23] ) , 
    .Y ( n1370_CDR2 ) ) ;
NAND2XL ctmTdsLR_2_1876 ( .A ( n1679 ) , .B ( \shadow_weights[14][19] ) , 
    .Y ( tmp_net281 ) ) ;
AOI22XL U801 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][3] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][3] ) , .Y ( n789_CDR1 ) ) ;
NAND2XL ctmTdsLR_3_1877 ( .A ( n1671 ) , .B ( \shadow_weights[18][19] ) , 
    .Y ( tmp_net282 ) ) ;
AOI22XL U803 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][3] ) , 
    .B0 ( ZBUF_3430_2 ) , .B1 ( \shadow_weights[0][3] ) , .Y ( n796_CDR2 ) ) ;
AOI22XL U804 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][26] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][26] ) , .Y ( n1537_CDR2 ) ) ;
AND4XL ctmTdsLR_2_2126 ( .A ( tmp_net196 ) , .B ( n1368_CDR2 ) , 
    .C ( tmp_net198 ) , .D ( tmp_net197 ) , .Y ( tmp_net446 ) ) ;
AOI21XL ctmTdsLR_1_2127 ( .A0 ( n1707 ) , .A1 ( n1706 ) , .B0 ( tmp_net448 ) , 
    .Y ( n1711 ) ) ;
AOI22XL U808 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][3] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][3] ) , .Y ( n781_CDR2 ) ) ;
NAND2XL ctmTdsLR_2_2128 ( .A ( tmp_net447 ) , .B ( n1704 ) , .Y ( n1706 ) ) ;
NAND2XL U810 ( .A ( n1957 ) , .B ( \shadow_weights[18][2] ) , .Y ( n1953 ) ) ;
INVXL ctmTdsLR_1_2010 ( .A ( tmp_net373 ) , .Y ( ZBUF_28_24 ) ) ;
NAND2XL U812 ( .A ( n1965 ) , .B ( \shadow_weights[18][1] ) , .Y ( n1962 ) ) ;
AOI22XL U813 ( .A0 ( n1271 ) , .A1 ( \shadow_weights[12][3] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][3] ) , .Y ( n780_CDR2 ) ) ;
AOI22X2 U814 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][17] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][17] ) , .Y ( n1252_CDR1 ) ) ;
AOI22X1 U815 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][26] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][26] ) , 
    .Y ( n1532_CDR2 ) ) ;
AOI22XL U816 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][11] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][11] ) , .Y ( n1150 ) ) ;
AOI22XL U817 ( .A0 ( n1680 ) , .A1 ( \shadow_weights[12][26] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][26] ) , .Y ( n1533_CDR2 ) ) ;
AOI22XL U818 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][4] ) , 
    .B0 ( n1271 ) , .B1 ( \shadow_weights[12][4] ) , .Y ( n983_CDR2 ) ) ;
AOI22XL ctmTdsLR_1_824 ( .A0 ( n1687 ) , .A1 ( \shadow_weights[2][27] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][27] ) , .Y ( tmp_net138 ) ) ;
AOI22XL U820 ( .A0 ( n1663 ) , .A1 ( \shadow_weights[11][20] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][20] ) , .Y ( n1328_CDR1 ) ) ;
AOI22XL U821 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][3] ) , .B0 ( n1277 ) , 
    .B1 ( \shadow_weights[10][3] ) , .Y ( n785 ) ) ;
AOI22XL U822 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][4] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][4] ) , .Y ( n984 ) ) ;
AOI22XL U823 ( .A0 ( n1661 ) , .A1 ( \shadow_weights[1][26] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][26] ) , 
    .Y ( n1541_CDR1 ) ) ;
AOI22XL U824 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][20] ) , 
    .B0 ( n1662 ) , .B1 ( \shadow_weights[9][20] ) , .Y ( n1336_CDR2 ) ) ;
CLKINVX8 HFSINV_1906_581 ( .A ( n292 ) , .Y ( HFSNET_324 ) ) ;
AOI22XL ctmTdsLR_1_864 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][17] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][17] ) , .Y ( tmp_net165 ) ) ;
AOI222XL ctmTdsLR_2_825 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][27] ) , 
    .B0 ( ZBUF_3430_2 ) , .B1 ( \shadow_weights[0][27] ) , .C0 ( n1686 ) , 
    .C1 ( \shadow_weights[6][27] ) , .Y ( tmp_net139 ) ) ;
AOI22XL U828 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][27] ) , 
    .B0 ( n1680 ) , .B1 ( \shadow_weights[12][27] ) , .Y ( n1597_CDR2 ) ) ;
AOI22XL U829 ( .A0 ( n1267 ) , .A1 ( \shadow_weights[1][4] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][4] ) , 
    .Y ( n992_CDR2 ) ) ;
AOI22XL U830 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][11] ) , 
    .B0 ( n1271 ) , .B1 ( \shadow_weights[12][11] ) , .Y ( n1149_CDR1 ) ) ;
INVXL ctmTdsLR_3_2129 ( .A ( n1703 ) , .Y ( tmp_net447 ) ) ;
AOI22XL U832 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][24] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][24] ) , 
    .Y ( n1408_CDR2 ) ) ;
NAND2X1 ctmTdsLR_1_2159 ( .A ( tmp_net92 ) , .B ( tmp_net463 ) , 
    .Y ( HFSNET_35 ) ) ;
NAND2XL ctmTdsLR_1_722 ( .A ( n1278 ) , .B ( \shadow_weights[8][11] ) , 
    .Y ( tmp_net60 ) ) ;
AOI22XL U835 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][10] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][10] ) , .Y ( n1117_CDR2 ) ) ;
AOI22XL U836 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][24] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][24] ) , .Y ( n1400_CDR1 ) ) ;
AOI22XL U837 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][24] ) , 
    .B0 ( n1661 ) , .B1 ( \shadow_weights[1][24] ) , .Y ( n1399_CDR1 ) ) ;
AOI22XL U838 ( .A0 ( n1663 ) , .A1 ( \shadow_weights[11][22] ) , 
    .B0 ( n1661 ) , .B1 ( \shadow_weights[1][22] ) , .Y ( n1364_CDR2 ) ) ;
AOI22XL U839 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][6] ) , 
    .B0 ( n1271 ) , .B1 ( \shadow_weights[12][6] ) , .Y ( n1023_CDR1 ) ) ;
AOI22X1 U840 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][6] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][6] ) , .Y ( n1024_CDR1 ) ) ;
OR4X1 ctmTdsLR_1_2012 ( .A ( tmp_net376 ) , .B ( n1348_CDR2 ) , 
    .C ( n1349_CDR1 ) , .D ( HFSNET_50 ) , .Y ( HFSNET_152 ) ) ;
AOI22XL ctmTdsLR_2_1889 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][29] ) , 
    .B0 ( n1671 ) , .B1 ( \shadow_weights[18][29] ) , .Y ( tmp_net290 ) ) ;
AOI222XL ctmTdsLR_1_681 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][9] ) , 
    .B0 ( \shadow_weights[17][9] ) , .B1 ( n1282 ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][9] ) , .Y ( tmp_net33 ) ) ;
AOI22XL U844 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][6] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][6] ) , .Y ( n1032_CDR1 ) ) ;
NAND4XL ctmTdsLR_2_2013 ( .A ( tmp_net374 ) , .B ( tmp_net375 ) , 
    .C ( tmp_net234 ) , .D ( n1350_CDR2 ) , .Y ( tmp_net376 ) ) ;
AOI22XL U846 ( .A0 ( n1271 ) , .A1 ( \shadow_weights[12][16] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][16] ) , .Y ( n1238_CDR2 ) ) ;
AOI22XL U847 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][18] ) , 
    .B0 ( n1271 ) , .B1 ( \shadow_weights[12][18] ) , .Y ( n1272_CDR1 ) ) ;
AND4XL ctmTdsLR_2_2026 ( .A ( tmp_net187 ) , .B ( tmp_net186 ) , 
    .C ( n612_CDR1 ) , .D ( n625_CDR2 ) , .Y ( tmp_net383 ) ) ;
AOI22XL U849 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][18] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][18] ) , .Y ( n1273_CDR1 ) ) ;
NAND2XL ctmTdsLR_3_2014 ( .A ( n1702 ) , .B ( \shadow_weights[15][21] ) , 
    .Y ( tmp_net374 ) ) ;
AOI22XL U851 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][18] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][18] ) , .Y ( n1289 ) ) ;
AOI222XL ctmTdsLR_4_2015 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][21] ) , .B0 ( n1687 ) , 
    .B1 ( \shadow_weights[2][21] ) , .C0 ( n1686 ) , 
    .C1 ( \shadow_weights[6][21] ) , .Y ( tmp_net375 ) ) ;
OR2XL ctmTdsLR_1_2027 ( .A ( tmp_net386 ) , .B ( tmp_net333 ) , 
    .Y ( HFSNET_147 ) ) ;
AOI22XL ctmTdsLR_3_1890 ( .A0 ( n1672 ) , .A1 ( \shadow_weights[19][29] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][29] ) , .Y ( tmp_net291 ) ) ;
AOI22XL U855 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][16] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][16] ) , .Y ( n1237_CDR2 ) ) ;
NAND4XL ctmTdsLR_2_2028 ( .A ( n1610_CDR2 ) , .B ( tmp_net384 ) , 
    .C ( tmp_net385 ) , .D ( tmp_net207 ) , .Y ( tmp_net386 ) ) ;
AOI222XL ctmTdsLR_3_1948 ( .A0 ( n1661 ) , .A1 ( \shadow_weights[1][29] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][29] ) , 
    .C0 ( n1663 ) , .C1 ( \shadow_weights[11][29] ) , .Y ( tmp_net328 ) ) ;
NAND2X1 ctmTdsLR_1_727 ( .A ( n1278 ) , .B ( \shadow_weights[8][5] ) , 
    .Y ( tmp_net64 ) ) ;
AOI22XL U859 ( .A0 ( n1267 ) , .A1 ( \shadow_weights[1][9] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][9] ) , .Y ( n1100 ) ) ;
NAND2XL U860 ( .A ( n346 ) , .B ( avg_cnt[3] ) , .Y ( n1978 ) ) ;
NAND2XL ctmTdsLR_3_2029 ( .A ( n1702 ) , .B ( \shadow_weights[15][28] ) , 
    .Y ( tmp_net384 ) ) ;
AND3XL ctmTdsLR_4_1949 ( .A ( tmp_net290 ) , .B ( tmp_net291 ) , 
    .C ( tmp_net292 ) , .Y ( tmp_net329 ) ) ;
AOI22XL U863 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][7] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][7] ) , .Y ( n1046_CDR1 ) ) ;
NOR2XL ctmTdsLR_4_2130 ( .A ( n1707 ) , .B ( n1706 ) , .Y ( tmp_net448 ) ) ;
AOI222XL ctmTdsLR_4_2030 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][28] ) , .B0 ( n1686 ) , 
    .B1 ( \shadow_weights[6][28] ) , .C0 ( n1687 ) , 
    .C1 ( \shadow_weights[2][28] ) , .Y ( tmp_net385 ) ) ;
AOI22XL U866 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][0] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][0] ) , .Y ( n625_CDR2 ) ) ;
AOI211X1 ctmTdsLR_1_2031 ( .A0 ( HFSNET_322 ) , 
    .A1 ( \shadow_weights[7][11] ) , .B0 ( tmp_net389 ) , .C0 ( tmp_net390 ) , 
    .Y ( n1162_CDR2 ) ) ;
NAND4XL ctmTdsLR_1_1865 ( .A ( n796_CDR2 ) , .B ( ZBUF_2_36 ) , 
    .C ( tmp_net274 ) , .D ( tmp_net45 ) , .Y ( HFSNET_120 ) ) ;
NAND2XL ctmTdsLR_4_1878 ( .A ( n1677 ) , .B ( \shadow_weights[5][19] ) , 
    .Y ( tmp_net283 ) ) ;
NAND2XL ctmTdsLR_5_1879 ( .A ( n1670 ) , .B ( \shadow_weights[16][19] ) , 
    .Y ( tmp_net284 ) ) ;
NAND2XL ctmTdsLR_1_666 ( .A ( n1568 ) , .B ( n1572 ) , .Y ( tmp_net24 ) ) ;
AOI22XL U872 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][4] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][4] ) , .Y ( n985_CDR1 ) ) ;
CLKINVX3 U874 ( .A ( n1300 ) , .Y ( n1268 ) ) ;
AOI22XL U875 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][11] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][11] ) , .Y ( n1151_CDR2 ) ) ;
AOI22XL U876 ( .A0 ( n1275 ) , .A1 ( \shadow_weights[11][1] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][1] ) , .Y ( n674_CDR2 ) ) ;
AOI22XL U877 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][5] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][5] ) , 
    .Y ( n1005_CDR1 ) ) ;
NAND2XL U878 ( .A ( n315 ) , .B ( n1416 ) , .Y ( N1791 ) ) ;
AOI22XL U879 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][7] ) , .B0 ( n1275 ) , 
    .B1 ( \shadow_weights[11][7] ) , .Y ( n1039_CDR1 ) ) ;
NAND4XL ctmTdsLR_2_2032 ( .A ( tmp_net387 ) , .B ( tmp_net388 ) , 
    .C ( n1150 ) , .D ( n1151_CDR2 ) , .Y ( tmp_net389 ) ) ;
AOI22XL U881 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][6] ) , .B0 ( n1275 ) , 
    .B1 ( \shadow_weights[11][6] ) , .Y ( n1025 ) ) ;
CLKBUFX4 U882 ( .A ( n1291 ) , .Y ( n1319 ) ) ;
CLKINVX3 U884 ( .A ( n1322 ) , .Y ( n1292 ) ) ;
AOI22XL U885 ( .A0 ( n1275 ) , .A1 ( \shadow_weights[11][3] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][3] ) , .Y ( n782_CDR1 ) ) ;
AOI22XL U886 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][26] ) , 
    .B0 ( n1663 ) , .B1 ( \shadow_weights[11][26] ) , .Y ( n1534_CDR2 ) ) ;
AOI22X2 U887 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][23] ) , 
    .B0 ( HFSNET_322 ) , .B1 ( \shadow_weights[7][23] ) , .Y ( n1371_CDR2 ) ) ;
NAND2XL ctmTdsLR_1_935 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][5] ) , 
    .Y ( tmp_net211 ) ) ;
OAI2BB1X1 U889 ( .A0N ( n1985 ) , .A1N ( n1989 ) , .B0 ( n315 ) , 
    .Y ( N1692 ) ) ;
AOI22XL U890 ( .A0 ( n1275 ) , .A1 ( \shadow_weights[11][17] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][17] ) , .Y ( n1253_CDR2 ) ) ;
AOI22XL U891 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][2] ) , .B0 ( n1275 ) , 
    .B1 ( \shadow_weights[11][2] ) , .Y ( n742_CDR2 ) ) ;
AOI22XL U892 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][24] ) , 
    .B0 ( n1680 ) , .B1 ( \shadow_weights[12][24] ) , .Y ( n1401_CDR2 ) ) ;
AOI222XL ctmTdsLR_1_828 ( .A0 ( n1686 ) , .A1 ( \shadow_weights[6][25] ) , 
    .B0 ( ZBUF_3430_2 ) , .B1 ( \shadow_weights[0][25] ) , .C0 ( n1319 ) , 
    .C1 ( \shadow_weights[13][25] ) , .Y ( tmp_net141 ) ) ;
NAND2XL U894 ( .A ( n2034 ) , .B ( n2006 ) , .Y ( n2008 ) ) ;
AOI22XL U895 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][16] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][16] ) , .Y ( n1239_CDR2 ) ) ;
AOI22XL U896 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][18] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][18] ) , .Y ( n1276_CDR2 ) ) ;
AOI22XL U897 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][10] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][10] ) , .Y ( n1118_CDR1 ) ) ;
CLKINVX3 U898 ( .A ( n1302 ) , .Y ( n1270 ) ) ;
AOI22XL U899 ( .A0 ( n1275 ) , .A1 ( \shadow_weights[11][9] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][9] ) , .Y ( n1093 ) ) ;
NAND3XL U900 ( .A ( n968 ) , .B ( n315 ) , .C ( n322 ) , .Y ( N1536 ) ) ;
NAND2XL U901 ( .A ( n1993 ) , .B ( n1992 ) , .Y ( n2004 ) ) ;
INVXL U902 ( .A ( n666 ) , .Y ( n664 ) ) ;
AOI22XL U903 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][25] ) , 
    .B0 ( n1662 ) , .B1 ( \shadow_weights[9][25] ) , .Y ( n1469_CDR2 ) ) ;
XOR2X1 ctmTdsLR_2_2132 ( .A ( n2201 ) , .B ( accumulator[34] ) , 
    .Y ( tmp_net449 ) ) ;
CLKINVX3 U905 ( .A ( n1309 ) , .Y ( n1277 ) ) ;
NAND2XL U906 ( .A ( n156 ) , .B ( n155 ) , .Y ( n157 ) ) ;
INVXL U907 ( .A ( n174 ) , .Y ( n180 ) ) ;
CLKINVX3 U908 ( .A ( n1310 ) , .Y ( n1279 ) ) ;
OAI211XL ctmTdsLR_2_667 ( .A0 ( n1504 ) , .A1 ( n1394 ) , .B0 ( tmp_net24 ) , 
    .C0 ( n1571 ) , .Y ( n1456 ) ) ;
OAI2BB1XL ctmTdsLR_1_668 ( .A0N ( n1772 ) , .A1N ( n1774 ) , .B0 ( n1771 ) , 
    .Y ( tmp_net25 ) ) ;
NAND2XL U915 ( .A ( n192 ) , .B ( n190 ) , .Y ( n188 ) ) ;
CLKINVX3 U918 ( .A ( n1306 ) , .Y ( n1274 ) ) ;
NAND2XL U919 ( .A ( n165 ) , .B ( n164 ) , .Y ( n166 ) ) ;
INVXL U920 ( .A ( n2024 ) , .Y ( n2034 ) ) ;
NAND2XL U922 ( .A ( n199 ) , .B ( n76 ) , .Y ( n78 ) ) ;
CLKINVX3 U923 ( .A ( n1311 ) , .Y ( n1281 ) ) ;
NAND2XL ctmTdsLR_2_682 ( .A ( n1278 ) , .B ( \shadow_weights[8][9] ) , 
    .Y ( tmp_net34 ) ) ;
AOI22XL ctmTdsLR_3_683 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][9] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][9] ) , .Y ( tmp_net35 ) ) ;
NAND2XL U927 ( .A ( n2009 ) , .B ( n2010 ) , .Y ( n2017 ) ) ;
NOR2XL ctmTdsLR_4_2227 ( .A ( n1135 ) , .B ( n1089 ) , .Y ( tmp_net497 ) ) ;
INVXL U929 ( .A ( n487 ) , .Y ( n411 ) ) ;
NOR2XL U1040 ( .A ( n1989 ) , .B ( n733 ) , .Y ( n1875 ) ) ;
INVXL U933 ( .A ( n432 ) , .Y ( n433 ) ) ;
NAND2XL U934 ( .A ( n118 ) , .B ( n116 ) , .Y ( n107 ) ) ;
AOI21XL U936 ( .A0 ( n82 ) , .A1 ( n103 ) , .B0 ( n81 ) , .Y ( n83 ) ) ;
NOR2XL ctmTdsLR_3_2133 ( .A ( n1582 ) , .B ( tmp_net449 ) , 
    .Y ( tmp_net450 ) ) ;
CLKINVX3 U938 ( .A ( n675 ) , .Y ( n1671 ) ) ;
CLKINVX3 U939 ( .A ( n676 ) , .Y ( n1673 ) ) ;
NAND2XL U941 ( .A ( avg_cnt[2] ) , .B ( n344 ) , .Y ( n345 ) ) ;
OR3X2 U943 ( .A ( n1990 ) , .B ( state[2] ) , .C ( n2172 ) , .Y ( n322 ) ) ;
INVXL U944 ( .A ( n2115 ) , .Y ( n2125 ) ) ;
NAND2XL ctmTdsLR_1_670 ( .A ( n1753 ) , .B ( n1750 ) , .Y ( tmp_net26 ) ) ;
NAND2XL U946 ( .A ( n808 ) , .B ( n807 ) , .Y ( n811 ) ) ;
NAND2XL U947 ( .A ( n132 ) , .B ( n128 ) , .Y ( n89 ) ) ;
OR2XL U948 ( .A ( n808 ) , .B ( n807 ) , .Y ( n813 ) ) ;
INVX2 U950 ( .A ( n1416 ) , .Y ( n320 ) ) ;
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
INVXL U970 ( .A ( n116 ) , .Y ( n117 ) ) ;
INVXL U972 ( .A ( n155 ) , .Y ( n109 ) ) ;
INVXL U973 ( .A ( n280 ) , .Y ( n281 ) ) ;
INVXL U974 ( .A ( n108 ) , .Y ( n156 ) ) ;
INVXL U977 ( .A ( n187 ) , .Y ( n192 ) ) ;
OAI211XL ctmTdsLR_2_671 ( .A0 ( n1749 ) , .A1 ( n247 ) , .B0 ( tmp_net26 ) , 
    .C0 ( n1752 ) , .Y ( n1729 ) ) ;
INVXL U979 ( .A ( n1142 ) , .Y ( n1143 ) ) ;
NAND2XL U982 ( .A ( n242 ) , .B ( n241 ) , .Y ( n243 ) ) ;
AOI22XL ctmTdsLR_4_1891 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][29] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][29] ) , .Y ( tmp_net292 ) ) ;
INVXL U986 ( .A ( n148 ) , .Y ( n165 ) ) ;
INVXL U988 ( .A ( n1549 ) , .Y ( n1550 ) ) ;
NAND2XL U989 ( .A ( n824 ) , .B ( n2194 ) , .Y ( n1080 ) ) ;
NAND2XL U992 ( .A ( n2158 ) , .B ( n2010 ) , .Y ( n2072 ) ) ;
NAND2XL U993 ( .A ( N1822 ) , .B ( n2162 ) , .Y ( n829 ) ) ;
NAND2XL U994 ( .A ( n141 ) , .B ( n140 ) , .Y ( n142 ) ) ;
INVXL U996 ( .A ( n2020 ) , .Y ( n2047 ) ) ;
NAND3XL ctmTdsLR_4_684 ( .A ( tmp_net33 ) , .B ( tmp_net34 ) , 
    .C ( tmp_net35 ) , .Y ( HFSNET_90 ) ) ;
AOI222XL ctmTdsLR_1_685 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][8] ) , 
    .B0 ( \shadow_weights[17][8] ) , .B1 ( n1282 ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][8] ) , .Y ( tmp_net36 ) ) ;
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
OR2XL U1012 ( .A ( n319 ) , .B ( state[1] ) , .Y ( n729 ) ) ;
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
AOI22XL ctmTdsLR_2_829 ( .A0 ( n1687 ) , .A1 ( \shadow_weights[2][25] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][25] ) , .Y ( tmp_net142 ) ) ;
AOI222XL ctmTdsLR_1_896 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][9] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][9] ) , .C0 ( ZBUF_3430_2 ) , 
    .C1 ( \shadow_weights[0][9] ) , .Y ( tmp_net182 ) ) ;
AND3X4 ctmTdsLR_3_2033 ( .A ( tmp_net351 ) , .B ( tmp_net60 ) , 
    .C ( tmp_net350 ) , .Y ( tmp_net387 ) ) ;
NAND4XL ctmTdsLR_2_1951 ( .A ( n1609_CDR2 ) , .B ( tmp_net331 ) , 
    .C ( tmp_net332 ) , .D ( n1611_CDR2 ) , .Y ( tmp_net333 ) ) ;
NAND3XL U1024 ( .A ( state[0] ) , .B ( state[3] ) , .C ( n68 ) , .Y ( n319 ) ) ;
NOR2XL U1026 ( .A ( state[3] ) , .B ( state[2] ) , .Y ( n297 ) ) ;
NOR2XL U1027 ( .A ( target_bit[2] ) , .B ( target_bit[0] ) , .Y ( n2010 ) ) ;
OAI21XL U1028 ( .A0 ( n1857 ) , .A1 ( n224 ) , .B0 ( n223 ) , .Y ( n1779 ) ) ;
OAI21XL U1029 ( .A0 ( ZBUF_786_30 ) , .A1 ( n2025 ) , .B0 ( n2029 ) , 
    .Y ( n57 ) ) ;
AOI22X1 ctmTdsLR_2_897 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][9] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][9] ) , .Y ( tmp_net183 ) ) ;
OAI21XL U1031 ( .A0 ( n502 ) , .A1 ( n499 ) , .B0 ( n503 ) , .Y ( n485 ) ) ;
NAND2XL U1032 ( .A ( n2173 ) , .B ( calc_cnt[1] ) , .Y ( n630 ) ) ;
OAI21XL U1033 ( .A0 ( n1947 ) , .A1 ( n1944 ) , .B0 ( n1945 ) , .Y ( n1938 ) ) ;
NAND2XL U1034 ( .A ( sar_ptr[1] ) , .B ( n2199 ) , .Y ( n2128 ) ) ;
NOR2X2 U1035 ( .A ( n2076 ) , .B ( n474 ) , .Y ( n2118 ) ) ;
OAI21XL ctmTdsLR_1_2134 ( .A0 ( n1893 ) , .A1 ( n1892 ) , .B0 ( tmp_net451 ) , 
    .Y ( n1897 ) ) ;
NAND2X2 U1037 ( .A ( n2020 ) , .B ( n2158 ) , .Y ( n2018 ) ) ;
OAI221XL U1038 ( .A0 ( N1833 ) , .A1 ( overrange_bits[9] ) , 
    .B0 ( HFSNET_229 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n708 ) ) ;
NAND2X2 U1039 ( .A ( n2009 ) , .B ( n2033 ) , .Y ( n2015 ) ) ;
AOI222XL ctmTdsLR_1_689 ( .A0 ( gre_a_INV_6696_54 ) , 
    .A1 ( \shadow_weights[4][8] ) , .B0 ( n1268 ) , 
    .B1 ( \shadow_weights[5][8] ) , .C0 ( n1270 ) , 
    .C1 ( \shadow_weights[14][8] ) , .Y ( tmp_net39 ) ) ;
NOR2XL U1041 ( .A ( n1990 ) , .B ( n56 ) , .Y ( n1989 ) ) ;
INVX4 U1042 ( .A ( n676 ) , .Y ( n1282 ) ) ;
CLKINVX3 U1043 ( .A ( n675 ) , .Y ( n1280 ) ) ;
NAND2X1 U1044 ( .A ( calc_cnt[0] ) , .B ( n2174 ) , .Y ( n626 ) ) ;
AOI222XL ctmTdsLR_3_1952 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][28] ) , 
    .B0 ( n1661 ) , .B1 ( \shadow_weights[1][28] ) , 
    .C0 ( gre_a_INV_6696_54 ) , .C1 ( \shadow_weights[4][28] ) , 
    .Y ( tmp_net331 ) ) ;
OAI21XL U1046 ( .A0 ( n665 ) , .A1 ( n658 ) , .B0 ( N1822 ) , .Y ( n1655 ) ) ;
NOR2X2 U1047 ( .A ( n67 ) , .B ( n319 ) , .Y ( N1822 ) ) ;
NOR2XL U1048 ( .A ( wait_cnt[3] ) , .B ( n580 ) , .Y ( n579 ) ) ;
NOR3X2 U1049 ( .A ( wr_idx_r[4] ) , .B ( n2160 ) , .C ( n671 ) , 
    .Y ( N1833 ) ) ;
NAND3XL U1050 ( .A ( n639 ) , .B ( n638 ) , .C ( start_calib ) , .Y ( n659 ) ) ;
NOR2XL U1051 ( .A ( n68 ) , .B ( n2172 ) , .Y ( n638 ) ) ;
OAI21XL U1052 ( .A0 ( n2073 ) , .A1 ( n2024 ) , .B0 ( n2053 ) , .Y ( n2054 ) ) ;
OAI21XL U1053 ( .A0 ( n2073 ) , .A1 ( ZBUF_786_30 ) , .B0 ( n2178 ) , 
    .Y ( n2056 ) ) ;
NAND2XL U1054 ( .A ( target_bit[2] ) , .B ( target_bit[0] ) , .Y ( n2073 ) ) ;
NOR2XL U1055 ( .A ( wait_cnt[1] ) , .B ( wait_cnt[0] ) , .Y ( n1984 ) ) ;
NAND2X1 U1058 ( .A ( sar_ptr[0] ) , .B ( sar_ptr[1] ) , .Y ( n2132 ) ) ;
AOI222XL ctmTdsLR_1_691 ( .A0 ( gre_a_INV_6696_54 ) , 
    .A1 ( \shadow_weights[4][9] ) , .B0 ( n1268 ) , 
    .B1 ( \shadow_weights[5][9] ) , .C0 ( n1270 ) , 
    .C1 ( \shadow_weights[14][9] ) , .Y ( tmp_net40 ) ) ;
OAI21XL U1063 ( .A0 ( n2179 ) , .A1 ( n2024 ) , .B0 ( n2053 ) , .Y ( n2050 ) ) ;
AOI2BB1XL U1064 ( .A0N ( n2179 ) , .A1N ( ZBUF_786_30 ) , 
    .B0 ( target_bit[4] ) , .Y ( n2053 ) ) ;
OAI2BB1XL ctmTdsLR_2_692 ( .A0N ( \shadow_weights[12][9] ) , .A1N ( n1271 ) , 
    .B0 ( tmp_net40 ) , .Y ( HFSNET_82 ) ) ;
AND2X2 U1066 ( .A ( n55 ) , .B ( target_bit[0] ) , .Y ( n292 ) ) ;
OAI22X2 U1067 ( .A0 ( n2000 ) , .A1 ( ZBUF_171_40 ) , 
    .B0 ( gre_a_INV_2209_53 ) , .B1 ( n2183 ) , .Y ( dac_p_force[8] ) ) ;
OAI22X2 U1068 ( .A0 ( n2019 ) , .A1 ( n2012 ) , .B0 ( gre_a_INV_2209_53 ) , 
    .B1 ( HFSNET_269 ) , .Y ( dac_p_force[7] ) ) ;
OAI22XL U1069 ( .A0 ( ZBUF_171_40 ) , .A1 ( n1999 ) , .B0 ( n2167 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[9] ) ) ;
OAI22XL U1070 ( .A0 ( n2031 ) , .A1 ( n2000 ) , .B0 ( n2165 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[2] ) ) ;
NAND2XL U1071 ( .A ( n1996 ) , .B ( n2010 ) , .Y ( n2000 ) ) ;
OAI22X2 U1072 ( .A0 ( n2000 ) , .A1 ( ZBUF_786_30 ) , 
    .B0 ( gre_a_INV_2209_53 ) , .B1 ( n2166 ) , .Y ( dac_p_force[10] ) ) ;
OAI22XL U1073 ( .A0 ( n2016 ) , .A1 ( HFSNET_269 ) , .B0 ( n2012 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_n_force[7] ) ) ;
OAI22XL U1074 ( .A0 ( ZBUF_786_30 ) , .A1 ( n1999 ) , .B0 ( n2164 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[11] ) ) ;
OAI22XL U1075 ( .A0 ( n2002 ) , .A1 ( n2016 ) , .B0 ( HFSNET_323 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_n_force[18] ) ) ;
OAI22X2 U1076 ( .A0 ( n1999 ) , .A1 ( n2031 ) , .B0 ( gre_a_INV_2209_53 ) , 
    .B1 ( n2181 ) , .Y ( dac_p_force[3] ) ) ;
OAI22XL U1077 ( .A0 ( n2019 ) , .A1 ( ropt_net_531 ) , .B0 ( ZBUF_786_30 ) , 
    .B1 ( n2013 ) , .Y ( dac_n_force[15] ) ) ;
OAI22XL U1078 ( .A0 ( n2019 ) , .A1 ( n2188 ) , .B0 ( ZBUF_171_40 ) , 
    .B1 ( n2013 ) , .Y ( dac_n_force[13] ) ) ;
OAI22XL U1079 ( .A0 ( n2019 ) , .A1 ( n2184 ) , .B0 ( ZBUF_786_30 ) , 
    .B1 ( n2014 ) , .Y ( dac_n_force[14] ) ) ;
OAI22XL U1080 ( .A0 ( n2016 ) , .A1 ( n2168 ) , .B0 ( n2014 ) , 
    .B1 ( n2031 ) , .Y ( dac_n_force[6] ) ) ;
OAI22XL U1081 ( .A0 ( n2016 ) , .A1 ( n2181 ) , .B0 ( n2015 ) , 
    .B1 ( n2031 ) , .Y ( dac_n_force[3] ) ) ;
OAI22XL U1082 ( .A0 ( n2016 ) , .A1 ( n2167 ) , .B0 ( ZBUF_171_40 ) , 
    .B1 ( n2015 ) , .Y ( dac_n_force[9] ) ) ;
OAI22XL U1083 ( .A0 ( n2019 ) , .A1 ( n2164 ) , .B0 ( ZBUF_786_30 ) , 
    .B1 ( n2015 ) , .Y ( dac_n_force[11] ) ) ;
OAI22X2 U1084 ( .A0 ( gre_a_INV_2209_53 ) , .A1 ( n2168 ) , .B0 ( n1998 ) , 
    .B1 ( n2031 ) , .Y ( dac_p_force[6] ) ) ;
OAI22XL U1085 ( .A0 ( n2016 ) , .A1 ( n2186 ) , .B0 ( n2018 ) , 
    .B1 ( n2015 ) , .Y ( dac_n_force[1] ) ) ;
OAI22XL U1086 ( .A0 ( n2016 ) , .A1 ( n2190 ) , .B0 ( n2018 ) , 
    .B1 ( n2014 ) , .Y ( dac_n_force[4] ) ) ;
OAI22XL U1087 ( .A0 ( n2016 ) , .A1 ( n2191 ) , .B0 ( n2018 ) , 
    .B1 ( n2013 ) , .Y ( dac_n_force[5] ) ) ;
OAI22X2 U1088 ( .A0 ( gre_a_INV_2209_53 ) , .A1 ( n2186 ) , .B0 ( n1999 ) , 
    .B1 ( n2018 ) , .Y ( dac_p_force[1] ) ) ;
NAND2X1 U1089 ( .A ( n1996 ) , .B ( n2033 ) , .Y ( n1999 ) ) ;
OAI22X2 U1090 ( .A0 ( gre_a_INV_2209_53 ) , .A1 ( n2190 ) , .B0 ( n1998 ) , 
    .B1 ( n2018 ) , .Y ( dac_p_force[4] ) ) ;
OAI22X2 U1091 ( .A0 ( gre_a_INV_2209_53 ) , .A1 ( n2191 ) , .B0 ( n1997 ) , 
    .B1 ( n2018 ) , .Y ( dac_p_force[5] ) ) ;
OAI22XL U1092 ( .A0 ( n2019 ) , .A1 ( n2185 ) , .B0 ( n2018 ) , 
    .B1 ( n2017 ) , .Y ( dac_n_force[0] ) ) ;
CLKINVX2 U1093 ( .A ( n1996 ) , .Y ( n2019 ) ) ;
OAI22XL U1094 ( .A0 ( n2016 ) , .A1 ( n2165 ) , .B0 ( n2017 ) , 
    .B1 ( n2031 ) , .Y ( dac_n_force[2] ) ) ;
OAI22XL U1095 ( .A0 ( n2016 ) , .A1 ( n2183 ) , .B0 ( ZBUF_171_40 ) , 
    .B1 ( n2017 ) , .Y ( dac_n_force[8] ) ) ;
OAI22XL U1096 ( .A0 ( n2016 ) , .A1 ( n2166 ) , .B0 ( ZBUF_786_30 ) , 
    .B1 ( n2017 ) , .Y ( dac_n_force[10] ) ) ;
CLKINVX2 U1097 ( .A ( n1996 ) , .Y ( n2016 ) ) ;
OAI22XL U1098 ( .A0 ( n2185 ) , .A1 ( gre_a_INV_2209_53 ) , .B0 ( n2000 ) , 
    .B1 ( n2018 ) , .Y ( dac_p_force[0] ) ) ;
OAI22XL U1099 ( .A0 ( n2002 ) , .A1 ( gre_a_INV_2209_53 ) , .B0 ( n2016 ) , 
    .B1 ( HFSNET_323 ) , .Y ( dac_p_force[18] ) ) ;
NOR2BX1 U1100 ( .AN ( n1988 ) , .B ( n2171 ) , .Y ( n725 ) ) ;
NOR3XL U1101 ( .A ( n67 ) , .B ( state[2] ) , .C ( state[3] ) , .Y ( n1988 ) ) ;
INVX2 U1102 ( .A ( n993 ) , .Y ( n1702 ) ) ;
NAND2XL ctmTdsLR_1_693 ( .A ( n1278 ) , .B ( \shadow_weights[8][2] ) , 
    .Y ( tmp_net41 ) ) ;
AND3XL ctmTdsLR_4_1953 ( .A ( tmp_net307 ) , .B ( tmp_net305 ) , 
    .C ( tmp_net306 ) , .Y ( tmp_net332 ) ) ;
AOI22XL ctmTdsLR_4_2034 ( .A0 ( gre_a_INV_4409_54 ) , 
    .A1 ( \shadow_weights[3][11] ) , .B0 ( n1267 ) , 
    .B1 ( \shadow_weights[1][11] ) , .Y ( tmp_net388 ) ) ;
NOR3X2 U1106 ( .A ( state[0] ) , .B ( n67 ) , .C ( n56 ) , .Y ( n663 ) ) ;
AOI222XL ctmTdsLR_2_1955 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][22] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][22] ) , .C0 ( n1670 ) , 
    .C1 ( \shadow_weights[16][22] ) , .Y ( tmp_net334 ) ) ;
NAND3XL ctmTdsLR_1_1956 ( .A ( tmp_net335 ) , .B ( tmp_net76 ) , 
    .C ( tmp_net336 ) , .Y ( HFSNET_36 ) ) ;
NAND2XL ctmTdsLR_2_2135 ( .A ( n1893 ) , .B ( n1892 ) , .Y ( tmp_net451 ) ) ;
AOI222XL ctmTdsLR_2_699 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][3] ) , 
    .B0 ( n1319 ) , .B1 ( \shadow_weights[13][3] ) , .C0 ( n1702 ) , 
    .C1 ( \shadow_weights[15][3] ) , .Y ( tmp_net46 ) ) ;
OR3X1 ctmTdsLR_1_1880 ( .A ( tmp_net190 ) , .B ( HFSNET_41 ) , 
    .C ( HFSNET_42 ) , .Y ( HFSNET_162 ) ) ;
INVXL ctmTdsLR_5_2035 ( .A ( n1149_CDR1 ) , .Y ( tmp_net390 ) ) ;
AOI22XL ctmTdsLR_1_702 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][13] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][13] ) , .Y ( tmp_net48 ) ) ;
INVX2 U1114 ( .A ( n1311 ) , .Y ( n1672 ) ) ;
INVX2 U1115 ( .A ( n1309 ) , .Y ( n1668 ) ) ;
CLKINVX3 U1116 ( .A ( n1306 ) , .Y ( n1662 ) ) ;
INVX2 U1117 ( .A ( n1302 ) , .Y ( n1679 ) ) ;
INVX2 U1118 ( .A ( n1300 ) , .Y ( n1677 ) ) ;
CLKINVX2 U1120 ( .A ( n1310 ) , .Y ( n1670 ) ) ;
AOI222XL ctmTdsLR_2_703 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][13] ) , 
    .B0 ( ZBUF_3430_2 ) , .B1 ( \shadow_weights[0][13] ) , .C0 ( n1290 ) , 
    .C1 ( \shadow_weights[6][13] ) , .Y ( tmp_net49 ) ) ;
AOI22XL ctmTdsLR_2_1957 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][12] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][12] ) , .Y ( tmp_net335 ) ) ;
INVX2 U1123 ( .A ( n1416 ) , .Y ( n341 ) ) ;
OAI22XL U1124 ( .A0 ( n2019 ) , .A1 ( n2021 ) , .B0 ( n2003 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[17] ) ) ;
OAI22XL U1125 ( .A0 ( n2019 ) , .A1 ( n2004 ) , .B0 ( n2189 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[16] ) ) ;
OAI22XL U1126 ( .A0 ( ZBUF_786_30 ) , .A1 ( n1997 ) , .B0 ( ropt_net_531 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[15] ) ) ;
OAI22XL U1127 ( .A0 ( ZBUF_786_30 ) , .A1 ( n1998 ) , .B0 ( n2184 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[14] ) ) ;
OAI22XL U1128 ( .A0 ( ZBUF_171_40 ) , .A1 ( n1997 ) , .B0 ( n2188 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[13] ) ) ;
OAI22XL U1129 ( .A0 ( n2019 ) , .A1 ( n2008 ) , .B0 ( n2187 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[12] ) ) ;
OAI21XL U1132 ( .A0 ( n426 ) , .A1 ( n423 ) , .B0 ( n427 ) , .Y ( n441 ) ) ;
OAI21XL U1133 ( .A0 ( n1881 ) , .A1 ( n1890 ) , .B0 ( n1882 ) , .Y ( n1858 ) ) ;
OAI21XL U1134 ( .A0 ( n1450 ) , .A1 ( n1447 ) , .B0 ( n1451 ) , .Y ( n1498 ) ) ;
OAI21XL U1135 ( .A0 ( n1054 ) , .A1 ( n1053 ) , .B0 ( n1052 ) , .Y ( n1085 ) ) ;
OAI21XL U1136 ( .A0 ( n193 ) , .A1 ( n190 ) , .B0 ( n194 ) , .Y ( n198 ) ) ;
OAI21XL U1137 ( .A0 ( n644 ) , .A1 ( n643 ) , .B0 ( n642 ) , .Y ( n695 ) ) ;
OAI21XL U1138 ( .A0 ( n461 ) , .A1 ( n460 ) , .B0 ( n459 ) , .Y ( n511 ) ) ;
OAI21XL U1139 ( .A0 ( n1707 ) , .A1 ( n1703 ) , .B0 ( n1704 ) , .Y ( n279 ) ) ;
AOI222XL ctmTdsLR_3_1958 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][12] ) , 
    .B0 ( n1282 ) , .B1 ( HFSNET_191 ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][12] ) , .Y ( tmp_net336 ) ) ;
BUFX12 ZCTSBUF_251_1376 ( .A ( net1736 ) , .Y ( ZCTSNET_374 ) ) ;
CLKINVXL ctmTdsLR_1_2136 ( .A ( tmp_net452 ) , .Y ( HFSNET_125 ) ) ;
CLKBUFX3 ZBUF_2_inst_2250 ( .A ( HFSNET_89 ) , .Y ( ZBUF_2_17 ) ) ;
NOR3X2 U1146 ( .A ( wr_idx_r[4] ) , .B ( wr_idx_r[3] ) , .C ( n671 ) , 
    .Y ( N1841 ) ) ;
NAND2XL U1147 ( .A ( n666 ) , .B ( n2177 ) , .Y ( n671 ) ) ;
OAI21XL U1148 ( .A0 ( n2031 ) , .A1 ( n2025 ) , .B0 ( n2049 ) , .Y ( n2045 ) ) ;
NOR2XL U1149 ( .A ( target_bit[2] ) , .B ( n2047 ) , .Y ( n2049 ) ) ;
NAND2X2 U1150 ( .A ( target_bit[1] ) , .B ( n2020 ) , .Y ( n2031 ) ) ;
NOR2X1 U1151 ( .A ( target_bit[3] ) , .B ( target_bit[4] ) , .Y ( n2020 ) ) ;
NAND2X1 U1153 ( .A ( n559 ) , .B ( n2159 ) , .Y ( n669 ) ) ;
NOR2X1 U1154 ( .A ( n2163 ) , .B ( target_bit[2] ) , .Y ( n2033 ) ) ;
NOR2X1 U1155 ( .A ( n2076 ) , .B ( n1627 ) , .Y ( n641 ) ) ;
NOR2X2 U1156 ( .A ( n725 ) , .B ( n663 ) , .Y ( n2076 ) ) ;
NOR2BXL U1157 ( .AN ( n579 ) , .B ( wait_cnt[4] ) , .Y ( n1627 ) ) ;
NOR3X2 U1158 ( .A ( wr_idx_r[1] ) , .B ( n670 ) , .C ( n669 ) , .Y ( N1826 ) ) ;
AND4XL ctmTdsLR_2_2137 ( .A ( tmp_net230 ) , .B ( HFSNET_32 ) , .C ( n1126 ) , 
    .D ( tmp_net229 ) , .Y ( tmp_net452 ) ) ;
NOR2X4 U1160 ( .A ( n627 ) , .B ( n626 ) , .Y ( n1291 ) ) ;
NAND3X1 ctmTdsLR_1_2036 ( .A ( tmp_net160 ) , .B ( tmp_net392 ) , 
    .C ( tmp_net138 ) , .Y ( HFSNET_145 ) ) ;
INVX4 U1162 ( .A ( n993 ) , .Y ( n1688 ) ) ;
INVX2 U1163 ( .A ( n1320 ) , .Y ( n1686 ) ) ;
INVX2 U1164 ( .A ( n1297 ) , .Y ( n1661 ) ) ;
CLKINVX3 U1165 ( .A ( n1301 ) , .Y ( n1680 ) ) ;
INVX2 U1167 ( .A ( n1308 ) , .Y ( n1669 ) ) ;
INVX2 U1168 ( .A ( n1305 ) , .Y ( n1663 ) ) ;
AND4XL ctmTdsLR_2_1962 ( .A ( n674_CDR2 ) , .B ( ZBUF_2_32 ) , 
    .C ( tmp_net338 ) , .D ( tmp_net310 ) , .Y ( tmp_net339 ) ) ;
OAI22XL U1170 ( .A0 ( n2019 ) , .A1 ( n2189 ) , .B0 ( gre_a_INV_2209_53 ) , 
    .B1 ( n2004 ) , .Y ( dac_n_force[16] ) ) ;
OAI22XL U1171 ( .A0 ( n2019 ) , .A1 ( n2192 ) , .B0 ( HFSNET_324 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_n_force[19] ) ) ;
OAI22XL U1172 ( .A0 ( n2019 ) , .A1 ( n2003 ) , .B0 ( n2021 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_n_force[17] ) ) ;
OAI22XL U1173 ( .A0 ( n2019 ) , .A1 ( n2187 ) , .B0 ( n2008 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_n_force[12] ) ) ;
OAI22XL U1174 ( .A0 ( n2016 ) , .A1 ( HFSNET_324 ) , .B0 ( n2192 ) , 
    .B1 ( gre_a_INV_2209_53 ) , .Y ( dac_p_force[19] ) ) ;
NAND2XL ctmTdsLR_3_1963 ( .A ( gre_a_INV_4409_54 ) , 
    .B ( \shadow_weights[3][1] ) , .Y ( tmp_net338 ) ) ;
AOI21XL ctmTdsLR_4_1964 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][1] ) , 
    .B0 ( tmp_net341 ) , .Y ( tmp_net342 ) ) ;
INVX4 HFSINV_995_572 ( .A ( calc_result_r[6] ) , .Y ( HFSNET_317 ) ) ;
INVX4 HFSINV_1213_571 ( .A ( calc_result_r[5] ) , .Y ( HFSNET_316 ) ) ;
INVX4 HFSINV_615_570 ( .A ( calc_result_r[4] ) , .Y ( HFSNET_315 ) ) ;
INVX4 HFSINV_1401_569 ( .A ( calc_result_r[3] ) , .Y ( HFSNET_314 ) ) ;
INVX4 HFSINV_746_568 ( .A ( calc_result_r[2] ) , .Y ( HFSNET_313 ) ) ;
NAND3XL ctmTdsLR_5_1965 ( .A ( n672_CDR1 ) , .B ( tmp_net340 ) , 
    .C ( tmp_net88 ) , .Y ( tmp_net341 ) ) ;
INVX4 HFSINV_908_552 ( .A ( calc_result_r[0] ) , .Y ( HFSNET_297 ) ) ;
INVX4 HFSINV_847_553 ( .A ( calc_result_r[14] ) , .Y ( HFSNET_298 ) ) ;
INVX3 HFSINV_897_567 ( .A ( calc_result_r[28] ) , .Y ( HFSNET_312 ) ) ;
INVX3 U1189 ( .A ( calc_result_r[27] ) , .Y ( n2305 ) ) ;
INVX4 U1190 ( .A ( calc_result_r[25] ) , .Y ( n2304 ) ) ;
INVX4 HFSINV_685_566 ( .A ( calc_result_r[24] ) , .Y ( HFSNET_311 ) ) ;
INVX4 HFSINV_781_565 ( .A ( calc_result_r[23] ) , .Y ( HFSNET_310 ) ) ;
INVX4 HFSINV_548_564 ( .A ( calc_result_r[22] ) , .Y ( HFSNET_309 ) ) ;
INVX4 U1194 ( .A ( calc_result_r[21] ) , .Y ( n2300 ) ) ;
INVX3 U1195 ( .A ( calc_result_r[20] ) , .Y ( n2299 ) ) ;
INVX4 HFSINV_585_559 ( .A ( calc_result_r[19] ) , .Y ( HFSNET_304 ) ) ;
INVX4 HFSINV_487_558 ( .A ( calc_result_r[18] ) , .Y ( HFSNET_303 ) ) ;
AND4XL ctmTdsLR_2_2037 ( .A ( n1588_CDR2 ) , .B ( n1590_CDR2 ) , 
    .C ( n1597_CDR2 ) , .D ( tmp_net391 ) , .Y ( tmp_net392 ) ) ;
INVX3 U1199 ( .A ( calc_result_r[29] ) , .Y ( n2307 ) ) ;
INVX4 HFSINV_564_557 ( .A ( calc_result_r[17] ) , .Y ( HFSNET_302 ) ) ;
INVX4 HFSINV_962_556 ( .A ( calc_result_r[16] ) , .Y ( HFSNET_301 ) ) ;
INVX4 HFSINV_764_554 ( .A ( calc_result_r[15] ) , .Y ( HFSNET_299 ) ) ;
CLKBUFX3 U1203 ( .A ( orr_r ) , .Y ( n2157 ) ) ;
NAND2XL ctmTdsLR_3_2038 ( .A ( n1661 ) , .B ( \shadow_weights[1][27] ) , 
    .Y ( tmp_net391 ) ) ;
AOI21XL U1206 ( .A0 ( n143 ) , .A1 ( n141 ) , .B0 ( n90 ) , .Y ( n139 ) ) ;
OAI21XL U1207 ( .A0 ( n139 ) , .A1 ( n135 ) , .B0 ( n136 ) , .Y ( n244 ) ) ;
OAI21XL U1208 ( .A0 ( n240 ) , .A1 ( n236 ) , .B0 ( n237 ) , .Y ( n235 ) ) ;
OAI21XL U1209 ( .A0 ( n1082 ) , .A1 ( n1081 ) , .B0 ( n1080 ) , .Y ( n1145 ) ) ;
OAI21XL U1210 ( .A0 ( n1495 ) , .A1 ( n1494 ) , .B0 ( n1493 ) , .Y ( n1552 ) ) ;
OAI21XL U1211 ( .A0 ( n1724 ) , .A1 ( n1720 ) , .B0 ( n1721 ) , .Y ( n1715 ) ) ;
OAI21XL U1212 ( .A0 ( n563 ) , .A1 ( n562 ) , .B0 ( n561 ) , .Y ( n584 ) ) ;
OAI21XL U1213 ( .A0 ( n275 ) , .A1 ( HFSNET_324 ) , .B0 ( n274 ) , 
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
NOR2XL U1221 ( .A ( temp_acc[12] ) , .B ( HFSNET_191 ) , .Y ( n108 ) ) ;
NOR2XL U1222 ( .A ( temp_acc[13] ) , .B ( \shadow_weights[17][13] ) , 
    .Y ( n111 ) ) ;
NOR2XL U1223 ( .A ( n108 ) , .B ( n111 ) , .Y ( n102 ) ) ;
NOR2XL U1224 ( .A ( temp_acc[14] ) , .B ( \shadow_weights[17][14] ) , 
    .Y ( n106 ) ) ;
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
NAND2XL U1255 ( .A ( temp_acc[12] ) , .B ( HFSNET_191 ) , .Y ( n155 ) ) ;
NAND2XL U1256 ( .A ( temp_acc[14] ) , .B ( \shadow_weights[17][14] ) , 
    .Y ( n116 ) ) ;
OAI21XL U1257 ( .A0 ( n120 ) , .A1 ( n116 ) , .B0 ( n121 ) , .Y ( n81 ) ) ;
OAI21XL U1258 ( .A0 ( n100 ) , .A1 ( n84 ) , .B0 ( n83 ) , .Y ( n85 ) ) ;
AOI21XL U1259 ( .A0 ( n86 ) , .A1 ( n99 ) , .B0 ( n85 ) , .Y ( n125 ) ) ;
NAND2XL ctmTdsLR_3_739 ( .A ( n1279 ) , .B ( \shadow_weights[16][17] ) , 
    .Y ( tmp_net74 ) ) ;
AOI21XL U1261 ( .A0 ( n235 ) , .A1 ( n233 ) , .B0 ( n92 ) , .Y ( n98 ) ) ;
NOR2XL U1262 ( .A ( temp_acc[23] ) , .B ( \shadow_weights[17][23] ) , 
    .Y ( n94 ) ) ;
OAI21XL U1263 ( .A0 ( n98 ) , .A1 ( n94 ) , .B0 ( n95 ) , .Y ( n253 ) ) ;
NAND2XL U1264 ( .A ( n252 ) , .B ( n250 ) , .Y ( n93 ) ) ;
XNOR2X1 U1265 ( .A ( n253 ) , .B ( n93 ) , .Y ( n1736 ) ) ;
NOR2XL U1266 ( .A ( n1736 ) , .B ( \shadow_weights[18][24] ) , .Y ( n1730 ) ) ;
NAND2XL ctmTdsLR_2_2166 ( .A ( tmp_net466 ) , .B ( n355 ) , .Y ( n351 ) ) ;
NOR2XL U1270 ( .A ( n1745 ) , .B ( \shadow_weights[18][23] ) , .Y ( n1740 ) ) ;
NOR2XL U1271 ( .A ( n1730 ) , .B ( n1740 ) , .Y ( n249 ) ) ;
INVXL U1272 ( .A ( n99 ) , .Y ( n218 ) ) ;
INVXL U1273 ( .A ( n110 ) , .Y ( n158 ) ) ;
XNOR2X1 U1274 ( .A ( n119 ) , .B ( n107 ) , .Y ( n1844 ) ) ;
NOR2XL U1275 ( .A ( n1844 ) , .B ( \shadow_weights[18][14] ) , .Y ( n1839 ) ) ;
OAI21XL ctmTdsLR_1_2220 ( .A0 ( n1466 ) , .A1 ( n1414 ) , .B0 ( tmp_net494 ) , 
    .Y ( n1415 ) ) ;
NOR2XL U1277 ( .A ( n1853 ) , .B ( \shadow_weights[18][13] ) , .Y ( n1848 ) ) ;
NOR2XL U1278 ( .A ( n1839 ) , .B ( n1848 ) , .Y ( n1827 ) ) ;
XOR2X1 U1279 ( .A ( n124 ) , .B ( n123 ) , .Y ( n1835 ) ) ;
OR2XL U1280 ( .A ( n1835 ) , .B ( \shadow_weights[18][15] ) , .Y ( n1832 ) ) ;
NAND2XL U1281 ( .A ( n1827 ) , .B ( n1832 ) , .Y ( n1781 ) ) ;
INVXL U1282 ( .A ( n125 ) , .Y ( n134 ) ) ;
XOR2X1 U1283 ( .A ( n130 ) , .B ( n129 ) , .Y ( n1813 ) ) ;
NOR2XL U1284 ( .A ( n1813 ) , .B ( \shadow_weights[18][17] ) , .Y ( n1808 ) ) ;
XNOR2X1 U1285 ( .A ( n134 ) , .B ( n133 ) , .Y ( n1823 ) ) ;
NOR2XL U1286 ( .A ( n1823 ) , .B ( \shadow_weights[18][16] ) , .Y ( n1805 ) ) ;
NOR2XL U1287 ( .A ( n1808 ) , .B ( n1805 ) , .Y ( n1782 ) ) ;
NAND2XL ctmTdsLR_2_2160 ( .A ( gre_a_INV_6696_54 ) , 
    .B ( \shadow_weights[4][12] ) , .Y ( tmp_net463 ) ) ;
NOR2XL U1289 ( .A ( n1793 ) , .B ( \shadow_weights[18][19] ) , .Y ( n1788 ) ) ;
XNOR2X1 U1290 ( .A ( n143 ) , .B ( n142 ) , .Y ( n1801 ) ) ;
NOR2XL U1291 ( .A ( n1801 ) , .B ( \shadow_weights[18][18] ) , .Y ( n1786 ) ) ;
NOR2XL U1292 ( .A ( n1788 ) , .B ( n1786 ) , .Y ( n227 ) ) ;
NOR2XL U1293 ( .A ( n1781 ) , .B ( n229 ) , .Y ( n231 ) ) ;
AOI22XL ctmTdsLR_2_1893 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][4] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][4] ) , .Y ( tmp_net293 ) ) ;
NOR2XL U1295 ( .A ( n1874 ) , .B ( \shadow_weights[18][11] ) , .Y ( n1869 ) ) ;
XOR2X1 U1296 ( .A ( n158 ) , .B ( n157 ) , .Y ( n1865 ) ) ;
NOR2XL U1297 ( .A ( n1865 ) , .B ( \shadow_weights[18][12] ) , .Y ( n1860 ) ) ;
NOR2XL U1298 ( .A ( n1869 ) , .B ( n1860 ) , .Y ( n222 ) ) ;
OAI21XL U1299 ( .A0 ( n218 ) , .A1 ( n214 ) , .B0 ( n215 ) , .Y ( n163 ) ) ;
XNOR2X1 U1300 ( .A ( n163 ) , .B ( n162 ) , .Y ( n1894 ) ) ;
NOR2XL U1301 ( .A ( n1894 ) , .B ( \shadow_weights[18][9] ) , .Y ( n1879 ) ) ;
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
NAND2XL U1328 ( .A ( n1874 ) , .B ( \shadow_weights[18][11] ) , .Y ( n1870 ) ) ;
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
XOR2X1 U1339 ( .A ( n240 ) , .B ( n239 ) , .Y ( n1767 ) ) ;
NOR2XL U1340 ( .A ( n1767 ) , .B ( HFSNET_217 ) , .Y ( n1762 ) ) ;
XNOR2X1 U1341 ( .A ( n244 ) , .B ( n243 ) , .Y ( n1775 ) ) ;
NOR2XL U1342 ( .A ( n1775 ) , .B ( HFSNET_216 ) , .Y ( n1760 ) ) ;
NOR2XL U1343 ( .A ( n1762 ) , .B ( n1760 ) , .Y ( n1751 ) ) ;
NAND2XL U1344 ( .A ( n1775 ) , .B ( HFSNET_216 ) , .Y ( n1771 ) ) ;
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
OR2XL U1358 ( .A ( n1716 ) , .B ( \shadow_weights[18][26] ) , .Y ( n1713 ) ) ;
NAND2XL U1359 ( .A ( n1716 ) , .B ( \shadow_weights[18][26] ) , .Y ( n1712 ) ) ;
AOI21XL U1360 ( .A0 ( n1715 ) , .A1 ( n1713 ) , .B0 ( n260 ) , .Y ( n1707 ) ) ;
AOI21XL U1361 ( .A0 ( n264 ) , .A1 ( n263 ) , .B0 ( n262 ) , .Y ( n269 ) ) ;
XOR2X1 U1364 ( .A ( n269 ) , .B ( n266 ) , .Y ( n1708 ) ) ;
NOR2XL U1365 ( .A ( n1708 ) , .B ( \shadow_weights[18][27] ) , .Y ( n1703 ) ) ;
NAND2XL U1366 ( .A ( n1708 ) , .B ( \shadow_weights[18][27] ) , .Y ( n1704 ) ) ;
OAI21XL U1367 ( .A0 ( n269 ) , .A1 ( n268 ) , .B0 ( n267 ) , .Y ( n283 ) ) ;
NAND2XL U1368 ( .A ( n282 ) , .B ( n280 ) , .Y ( n270 ) ) ;
OR2XL U1369 ( .A ( n272 ) , .B ( \shadow_weights[18][28] ) , .Y ( n278 ) ) ;
NAND2XL U1370 ( .A ( n272 ) , .B ( \shadow_weights[18][28] ) , .Y ( n276 ) ) ;
NAND2XL U1371 ( .A ( n278 ) , .B ( n276 ) , .Y ( n271 ) ) ;
AOI21XL ctmTdsLR_1_2161 ( .A0 ( n98 ) , .A1 ( n97 ) , .B0 ( tmp_net465 ) , 
    .Y ( n1745 ) ) ;
NOR2XL U1373 ( .A ( n2178 ) , .B ( target_bit[3] ) , .Y ( n1993 ) ) ;
NOR2XL U1375 ( .A ( n67 ) , .B ( n2171 ) , .Y ( n723 ) ) ;
AND2X1 U1376 ( .A ( n1991 ) , .B ( n723 ) , .Y ( n733 ) ) ;
AOI211XL U1377 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2208 ) , .B0 ( n273 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n274 ) ) ;
AOI21XL U1378 ( .A0 ( n279 ) , .A1 ( n278 ) , .B0 ( n277 ) , .Y ( n291 ) ) ;
AOI21XL U1379 ( .A0 ( n283 ) , .A1 ( n282 ) , .B0 ( n281 ) , .Y ( n287 ) ) ;
XOR2X1 U1383 ( .A ( n287 ) , .B ( n286 ) , .Y ( n293 ) ) ;
XOR2X1 U1384 ( .A ( n291 ) , .B ( n290 ) , .Y ( n296 ) ) ;
AOI211XL U1385 ( .A0 ( gre_a_INV_2579_54 ) , .A1 ( n2214 ) , .B0 ( n294 ) , 
    .C0 ( HFSNET_327 ) , .Y ( n295 ) ) ;
OAI21XL U1386 ( .A0 ( n296 ) , .A1 ( HFSNET_324 ) , .B0 ( n295 ) , 
    .Y ( n894 ) ) ;
NAND3XL U1387 ( .A ( wr_idx_r[1] ) , .B ( n65 ) , .C ( n2160 ) , .Y ( n667 ) ) ;
NAND2X1 U1388 ( .A ( n559 ) , .B ( wr_idx_r[2] ) , .Y ( n577 ) ) ;
NOR2XL U1389 ( .A ( n667 ) , .B ( n577 ) , .Y ( N1836 ) ) ;
NAND3XL U1390 ( .A ( n2177 ) , .B ( n65 ) , .C ( n2160 ) , .Y ( n600 ) ) ;
INVXL HFSINV_11_484 ( .A ( N1828 ) , .Y ( HFSNET_235 ) ) ;
NAND3X1 U1392 ( .A ( wr_idx_r[1] ) , .B ( wr_idx_r[3] ) , .C ( n65 ) , 
    .Y ( n668 ) ) ;
NOR2X4 U1393 ( .A ( n577 ) , .B ( n668 ) , .Y ( N1828 ) ) ;
NAND3XL U1394 ( .A ( wr_idx_r[3] ) , .B ( n2177 ) , .C ( n65 ) , .Y ( n598 ) ) ;
NOR2X2 U1395 ( .A ( n577 ) , .B ( n598 ) , .Y ( N1830 ) ) ;
NOR2X2 U1396 ( .A ( n669 ) , .B ( n600 ) , .Y ( N1842 ) ) ;
NOR2X1 U1397 ( .A ( n669 ) , .B ( n598 ) , .Y ( N1834 ) ) ;
AOI222XL ctmTdsLR_4_740 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][17] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][17] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][17] ) , .Y ( tmp_net75 ) ) ;
AOI21X1 ctmTdsLR_1_2138 ( .A0 ( n1885 ) , .A1 ( n1884 ) , .B0 ( tmp_net454 ) , 
    .Y ( n1889 ) ) ;
NAND2XL ctmTdsLR_1_742 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[19] ) , 
    .Y ( HFSNET_1 ) ) ;
NAND2XL ctmTdsLR_1_743 ( .A ( n1278 ) , .B ( \shadow_weights[8][12] ) , 
    .Y ( tmp_net76 ) ) ;
NAND2XL U1402 ( .A ( n2160 ) , .B ( wr_idx_r[4] ) , .Y ( n670 ) ) ;
NAND2BXL U1403 ( .AN ( n670 ) , .B ( wr_idx_r[1] ) , .Y ( n665 ) ) ;
NAND2XL U1404 ( .A ( wr_idx_r[0] ) , .B ( HFSNET_271 ) , .Y ( n658 ) ) ;
NOR2XL U1405 ( .A ( n815 ) , .B ( n658 ) , .Y ( n666 ) ) ;
AOI21XL U1407 ( .A0 ( n2189 ) , .A1 ( n318 ) , .B0 ( n316 ) , .Y ( n317 ) ) ;
OAI21XL U1408 ( .A0 ( n2118 ) , .A1 ( n318 ) , .B0 ( n317 ) , .Y ( n757 ) ) ;
NAND2XL U1409 ( .A ( n639 ) , .B ( n638 ) , .Y ( n722 ) ) ;
AND2XL U1410 ( .A ( n722 ) , .B ( n815 ) , .Y ( n774 ) ) ;
INVXL HFSINV_4_321 ( .A ( comp_out ) , .Y ( HFSNET_112 ) ) ;
OR2XL U1412 ( .A ( avg_cnt[0] ) , .B ( n322 ) , .Y ( n967 ) ) ;
NAND2XL U1413 ( .A ( target_bit[0] ) , .B ( gre_a_INV_7090_53 ) , 
    .Y ( n892 ) ) ;
NOR3XL U1414 ( .A ( state[2] ) , .B ( state[0] ) , .C ( n67 ) , .Y ( n652 ) ) ;
NAND2XL U1415 ( .A ( state[3] ) , .B ( n652 ) , .Y ( n1416 ) ) ;
NAND2XL U1416 ( .A ( n320 ) , .B ( avg_rounded_r[22] ) , .Y ( n843 ) ) ;
NAND2XL U1417 ( .A ( n320 ) , .B ( avg_rounded_r[34] ) , .Y ( n831 ) ) ;
NAND2XL U1418 ( .A ( n320 ) , .B ( avg_rounded_r[23] ) , .Y ( n842 ) ) ;
NAND2XL U1419 ( .A ( n320 ) , .B ( avg_rounded_r[6] ) , .Y ( n859 ) ) ;
NAND2XL U1420 ( .A ( n320 ) , .B ( avg_rounded_r[25] ) , .Y ( n840 ) ) ;
NAND2XL U1421 ( .A ( n320 ) , .B ( avg_rounded_r[24] ) , .Y ( n841 ) ) ;
NAND2XL U1422 ( .A ( n320 ) , .B ( avg_rounded_r[29] ) , .Y ( n836 ) ) ;
NAND2XL U1423 ( .A ( n320 ) , .B ( avg_rounded_r[27] ) , .Y ( n838 ) ) ;
NAND2XL U1424 ( .A ( n320 ) , .B ( avg_rounded_r[31] ) , .Y ( n834 ) ) ;
NAND2XL U1425 ( .A ( n320 ) , .B ( avg_rounded_r[30] ) , .Y ( n835 ) ) ;
NAND2XL U1426 ( .A ( n320 ) , .B ( avg_rounded_r[32] ) , .Y ( n833 ) ) ;
NAND2XL U1427 ( .A ( n320 ) , .B ( avg_rounded_r[33] ) , .Y ( n832 ) ) ;
NAND2XL U1428 ( .A ( n320 ) , .B ( avg_rounded_r[35] ) , .Y ( n830 ) ) ;
NAND2XL U1429 ( .A ( n320 ) , .B ( avg_rounded_r[28] ) , .Y ( n837 ) ) ;
NAND2XL U1430 ( .A ( n320 ) , .B ( avg_rounded_r[21] ) , .Y ( n844 ) ) ;
NAND2XL U1431 ( .A ( n341 ) , .B ( avg_rounded_r[26] ) , .Y ( n839 ) ) ;
NAND2XL U1432 ( .A ( n341 ) , .B ( avg_rounded_r[20] ) , .Y ( n845 ) ) ;
NAND2XL U1433 ( .A ( overrange_acc ) , .B ( gre_a_INV_7090_53 ) , 
    .Y ( n893 ) ) ;
OR2XL U1434 ( .A ( meas_val_p[0] ) , .B ( accumulator[0] ) , .Y ( n328 ) ) ;
NAND2XL U1435 ( .A ( meas_val_p[0] ) , .B ( accumulator[0] ) , .Y ( n326 ) ) ;
NAND2XL U1436 ( .A ( n328 ) , .B ( n326 ) , .Y ( n321 ) ) ;
XNOR2XL U1437 ( .A ( n321 ) , .B ( meas_val_n[0] ) , .Y ( n323 ) ) ;
NAND2XL U1438 ( .A ( n323 ) , .B ( HFSNET_325 ) , .Y ( n962 ) ) ;
NOR2XL U1439 ( .A ( n324 ) , .B ( meas_val_n[1] ) , .Y ( n336 ) ) ;
NAND2XL U1441 ( .A ( n324 ) , .B ( meas_val_n[1] ) , .Y ( n335 ) ) ;
INVXL U1443 ( .A ( n326 ) , .Y ( n327 ) ) ;
AOI21XL U1444 ( .A0 ( n328 ) , .A1 ( meas_val_n[0] ) , .B0 ( n327 ) , 
    .Y ( n337 ) ) ;
XOR2XL U1445 ( .A ( n329 ) , .B ( n337 ) , .Y ( n330 ) ) ;
NAND2XL U1446 ( .A ( n330 ) , .B ( HFSNET_325 ) , .Y ( n961 ) ) ;
NAND2XL U1447 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[23] ) , 
    .Y ( n872 ) ) ;
AOI222XL ctmTdsLR_1_832 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][8] ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][8] ) , .C0 ( n1688 ) , 
    .C1 ( \shadow_weights[15][8] ) , .Y ( tmp_net144 ) ) ;
NAND2XL U1449 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[21] ) , 
    .Y ( n874 ) ) ;
NAND2XL U1450 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[9] ) , 
    .Y ( n886 ) ) ;
NAND2XL ctmTdsLR_2_2139 ( .A ( tmp_net453 ) , .B ( n1882 ) , .Y ( n1884 ) ) ;
NAND2XL U1452 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[7] ) , 
    .Y ( n888 ) ) ;
NAND2XL ctmTdsLR_1_939 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][6] ) , 
    .Y ( tmp_net214 ) ) ;
NAND2XL U1454 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[18] ) , 
    .Y ( n877 ) ) ;
AOI22XL ctmTdsLR_2_940 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][6] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][6] ) , .Y ( tmp_net215 ) ) ;
NAND2XL U1456 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[17] ) , 
    .Y ( n878 ) ) ;
AOI22XL ctmTdsLR_3_941 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][6] ) , 
    .B0 ( n1292 ) , .B1 ( \shadow_weights[2][6] ) , .Y ( tmp_net216 ) ) ;
NAND2XL U1458 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[8] ) , 
    .Y ( n887 ) ) ;
INVXL ctmTdsLR_3_2140 ( .A ( n1881 ) , .Y ( tmp_net453 ) ) ;
NAND2XL U1460 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[12] ) , 
    .Y ( n883 ) ) ;
NAND2XL U1461 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[11] ) , 
    .Y ( n884 ) ) ;
NAND2XL ctmTdsLR_1_943 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][11] ) , 
    .Y ( tmp_net217 ) ) ;
NAND2XL U1463 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[16] ) , 
    .Y ( n879 ) ) ;
NAND2XL U1464 ( .A ( target_bit[4] ) , .B ( gre_a_INV_7090_53 ) , 
    .Y ( n890 ) ) ;
NAND2XL U1465 ( .A ( target_bit[3] ) , .B ( gre_a_INV_7090_53 ) , 
    .Y ( n891 ) ) ;
ADDHXL U1466 ( .A ( meas_val_p[1] ) , .B ( accumulator[1] ) , .CO ( n332 ) , 
    .S ( n324 ) ) ;
NOR2XL U1467 ( .A ( n333 ) , .B ( n332 ) , .Y ( n354 ) ) ;
NAND2XL U1469 ( .A ( n333 ) , .B ( n332 ) , .Y ( n356 ) ) ;
INVXL U1471 ( .A ( n359 ) , .Y ( n347 ) ) ;
XOR2XL U1472 ( .A ( n338 ) , .B ( n347 ) , .Y ( n339 ) ) ;
NAND2XL U1473 ( .A ( n339 ) , .B ( HFSNET_325 ) , .Y ( n960 ) ) ;
NOR3XL U1474 ( .A ( HFSNET_271 ) , .B ( n2162 ) , .C ( n2177 ) , .Y ( n340 ) ) ;
NAND2XL U1475 ( .A ( wr_idx_r[3] ) , .B ( n340 ) , .Y ( n1987 ) ) ;
OAI211XL U1476 ( .A0 ( wr_idx_r[3] ) , .A1 ( n340 ) , .B0 ( N1822 ) , 
    .C0 ( n1987 ) , .Y ( n828 ) ) ;
NAND2XL U1477 ( .A ( n341 ) , .B ( avg_rounded_r[9] ) , .Y ( n856 ) ) ;
NAND2XL U1478 ( .A ( n341 ) , .B ( avg_rounded_r[15] ) , .Y ( n850 ) ) ;
NAND2XL U1479 ( .A ( n341 ) , .B ( avg_rounded_r[12] ) , .Y ( n853 ) ) ;
NAND2XL U1480 ( .A ( n341 ) , .B ( avg_rounded_r[10] ) , .Y ( n855 ) ) ;
NAND2XL U1481 ( .A ( n341 ) , .B ( avg_rounded_r[16] ) , .Y ( n849 ) ) ;
NAND2XL U1482 ( .A ( n341 ) , .B ( avg_rounded_r[7] ) , .Y ( n858 ) ) ;
NAND2XL U1483 ( .A ( n341 ) , .B ( avg_rounded_r[18] ) , .Y ( n847 ) ) ;
NAND2XL U1484 ( .A ( n341 ) , .B ( avg_rounded_r[11] ) , .Y ( n854 ) ) ;
NAND2XL U1485 ( .A ( n341 ) , .B ( avg_rounded_r[8] ) , .Y ( n857 ) ) ;
NAND2XL U1486 ( .A ( n341 ) , .B ( avg_rounded_r[13] ) , .Y ( n852 ) ) ;
NAND2XL U1487 ( .A ( n341 ) , .B ( avg_rounded_r[17] ) , .Y ( n848 ) ) ;
NAND2XL U1488 ( .A ( n341 ) , .B ( avg_rounded_r[14] ) , .Y ( n851 ) ) ;
NAND2XL U1489 ( .A ( n341 ) , .B ( avg_rounded_r[19] ) , .Y ( n846 ) ) ;
NAND2XL U1490 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[25] ) , 
    .Y ( n870 ) ) ;
NAND2XL U1491 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[32] ) , 
    .Y ( n863 ) ) ;
NAND2XL U1492 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[26] ) , 
    .Y ( n869 ) ) ;
NAND2XL U1493 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[33] ) , 
    .Y ( n862 ) ) ;
NAND3XL ctmTdsLR_1_2039 ( .A ( n1412_CDR2 ) , .B ( tmp_net393 ) , 
    .C ( tmp_net394 ) , .Y ( HFSNET_148 ) ) ;
NAND2XL U1495 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[31] ) , 
    .Y ( n864 ) ) ;
NAND2XL U1496 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[30] ) , 
    .Y ( n865 ) ) ;
NAND2XL U1497 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[34] ) , 
    .Y ( n861 ) ) ;
NAND2XL U1498 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[27] ) , 
    .Y ( n868 ) ) ;
NAND2XL U1499 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[29] ) , 
    .Y ( n866 ) ) ;
NAND2XL U1500 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[13] ) , 
    .Y ( n882 ) ) ;
NAND2XL U1501 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[24] ) , 
    .Y ( n871 ) ) ;
NAND2XL U1502 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[35] ) , 
    .Y ( n860 ) ) ;
NAND2XL U1503 ( .A ( avg_cnt[1] ) , .B ( avg_cnt[0] ) , .Y ( n343 ) ) ;
OAI211XL U1504 ( .A0 ( avg_cnt[1] ) , .A1 ( avg_cnt[0] ) , 
    .B0 ( HFSNET_325 ) , .C0 ( n343 ) , .Y ( n966 ) ) ;
INVXL U1505 ( .A ( n343 ) , .Y ( n344 ) ) ;
OAI211XL U1506 ( .A0 ( n344 ) , .A1 ( avg_cnt[2] ) , .B0 ( HFSNET_325 ) , 
    .C0 ( n345 ) , .Y ( n965 ) ) ;
INVXL U1507 ( .A ( n345 ) , .Y ( n346 ) ) ;
OAI211XL U1508 ( .A0 ( n346 ) , .A1 ( avg_cnt[3] ) , .B0 ( HFSNET_325 ) , 
    .C0 ( n1978 ) , .Y ( n964 ) ) ;
OAI21XL U1509 ( .A0 ( n347 ) , .A1 ( n354 ) , .B0 ( n356 ) , .Y ( n352 ) ) ;
CMPR32X1 U1510 ( .A ( meas_val_p[2] ) , .B ( meas_val_n[2] ) , 
    .C ( accumulator[2] ) , .CO ( n348 ) , .S ( n333 ) ) ;
NOR2XL U1511 ( .A ( n349 ) , .B ( n348 ) , .Y ( n357 ) ) ;
NAND2XL U1513 ( .A ( n349 ) , .B ( n348 ) , .Y ( n355 ) ) ;
OAI21XL ctmTdsLR_1_2182 ( .A0 ( n1429 ) , .A1 ( tmp_net244 ) , 
    .B0 ( tmp_net476 ) , .Y ( n1431 ) ) ;
NAND2XL U1516 ( .A ( n353 ) , .B ( HFSNET_325 ) , .Y ( n959 ) ) ;
NOR2XL U1517 ( .A ( n357 ) , .B ( n354 ) , .Y ( n360 ) ) ;
OAI21XL U1518 ( .A0 ( n357 ) , .A1 ( n356 ) , .B0 ( n355 ) , .Y ( n358 ) ) ;
AOI21XL U1519 ( .A0 ( n360 ) , .A1 ( n359 ) , .B0 ( n358 ) , .Y ( n376 ) ) ;
ADDFHXL U1520 ( .A ( meas_val_p[3] ) , .B ( meas_val_n[3] ) , 
    .CI ( accumulator[3] ) , .CO ( n361 ) , .S ( n349 ) ) ;
NOR2XL U1521 ( .A ( n362 ) , .B ( n361 ) , .Y ( n365 ) ) ;
INVXL U1522 ( .A ( n365 ) , .Y ( n425 ) ) ;
NAND2XL U1523 ( .A ( n362 ) , .B ( n361 ) , .Y ( n423 ) ) ;
NAND2XL U1524 ( .A ( n425 ) , .B ( n423 ) , .Y ( n363 ) ) ;
XNOR2XL U1525 ( .A ( n443 ) , .B ( n363 ) , .Y ( n364 ) ) ;
NAND2XL U1526 ( .A ( n364 ) , .B ( HFSNET_325 ) , .Y ( n958 ) ) ;
ADDFHXL U1527 ( .A ( meas_val_p[4] ) , .B ( meas_val_n[4] ) , 
    .CI ( accumulator[4] ) , .CO ( n366 ) , .S ( n362 ) ) ;
NOR2XL U1528 ( .A ( n367 ) , .B ( n366 ) , .Y ( n426 ) ) ;
NOR2XL U1529 ( .A ( n426 ) , .B ( n365 ) , .Y ( n442 ) ) ;
CMPR32X1 U1530 ( .A ( meas_val_p[5] ) , .B ( meas_val_n[5] ) , 
    .C ( accumulator[5] ) , .CO ( n368 ) , .S ( n367 ) ) ;
NOR2XL U1531 ( .A ( n369 ) , .B ( n368 ) , .Y ( n477 ) ) ;
ADDFHXL U1532 ( .A ( meas_val_p[6] ) , .B ( meas_val_n[6] ) , 
    .CI ( accumulator[6] ) , .CO ( n370 ) , .S ( n369 ) ) ;
NOR2XL U1533 ( .A ( n371 ) , .B ( n370 ) , .Y ( n479 ) ) ;
NOR2XL U1534 ( .A ( n477 ) , .B ( n479 ) , .Y ( n373 ) ) ;
NAND2XL U1535 ( .A ( n442 ) , .B ( n373 ) , .Y ( n375 ) ) ;
NAND2XL U1536 ( .A ( n367 ) , .B ( n366 ) , .Y ( n427 ) ) ;
NAND2XL U1537 ( .A ( n369 ) , .B ( n368 ) , .Y ( n476 ) ) ;
OAI21XL U1538 ( .A0 ( n479 ) , .A1 ( n476 ) , .B0 ( n480 ) , .Y ( n372 ) ) ;
AOI21XL U1539 ( .A0 ( n373 ) , .A1 ( n441 ) , .B0 ( n372 ) , .Y ( n374 ) ) ;
OAI21XL U1540 ( .A0 ( n376 ) , .A1 ( n375 ) , .B0 ( n374 ) , .Y ( n403 ) ) ;
INVXL U1541 ( .A ( n403 ) , .Y ( n521 ) ) ;
ADDFHXL U1542 ( .A ( meas_val_p[7] ) , .B ( meas_val_n[7] ) , 
    .CI ( accumulator[7] ) , .CO ( n377 ) , .S ( n371 ) ) ;
NOR2XL U1543 ( .A ( n378 ) , .B ( n377 ) , .Y ( n448 ) ) ;
NAND2XL U1545 ( .A ( n378 ) , .B ( n377 ) , .Y ( n447 ) ) ;
XOR2XL U1547 ( .A ( n521 ) , .B ( n380 ) , .Y ( n381 ) ) ;
NAND2XL U1548 ( .A ( n381 ) , .B ( HFSNET_325 ) , .Y ( n955 ) ) ;
CMPR32X1 U1549 ( .A ( meas_val_p[8] ) , .B ( meas_val_n[8] ) , 
    .C ( accumulator[8] ) , .CO ( n382 ) , .S ( n378 ) ) ;
NOR2XL U1550 ( .A ( n383 ) , .B ( n382 ) , .Y ( n449 ) ) ;
NOR2XL U1551 ( .A ( n448 ) , .B ( n449 ) , .Y ( n466 ) ) ;
ADDFHXL U1552 ( .A ( meas_val_p[9] ) , .B ( meas_val_n[9] ) , 
    .CI ( accumulator[9] ) , .CO ( n384 ) , .S ( n383 ) ) ;
NOR2XL U1553 ( .A ( n385 ) , .B ( n384 ) , .Y ( n470 ) ) ;
ADDFX1 U1554 ( .A ( meas_val_p[10] ) , .B ( meas_val_n[10] ) , 
    .CI ( accumulator[10] ) , .CO ( n386 ) , .S ( n385 ) ) ;
NOR2XL U1555 ( .A ( n387 ) , .B ( n386 ) , .Y ( n540 ) ) ;
NOR2XL U1556 ( .A ( n470 ) , .B ( n540 ) , .Y ( n389 ) ) ;
NAND2XL U1557 ( .A ( n466 ) , .B ( n389 ) , .Y ( n520 ) ) ;
CMPR32X1 U1558 ( .A ( meas_val_p[11] ) , .B ( meas_val_n[11] ) , 
    .C ( accumulator[11] ) , .CO ( n390 ) , .S ( n387 ) ) ;
NOR2XL U1559 ( .A ( n391 ) , .B ( n390 ) , .Y ( n522 ) ) ;
CMPR32X1 U1560 ( .A ( meas_val_p[12] ) , .B ( meas_val_n[12] ) , 
    .C ( accumulator[12] ) , .CO ( n392 ) , .S ( n391 ) ) ;
NOR2XL U1561 ( .A ( n393 ) , .B ( n392 ) , .Y ( n524 ) ) ;
NOR2XL U1562 ( .A ( n522 ) , .B ( n524 ) , .Y ( n590 ) ) ;
CMPR32X1 U1563 ( .A ( meas_val_p[13] ) , .B ( meas_val_n[13] ) , 
    .C ( accumulator[13] ) , .CO ( n394 ) , .S ( n393 ) ) ;
NOR2XL U1564 ( .A ( n395 ) , .B ( n394 ) , .Y ( n595 ) ) ;
ADDFHXL U1565 ( .A ( meas_val_p[14] ) , .B ( meas_val_n[14] ) , 
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
AOI21XL U1579 ( .A0 ( n404 ) , .A1 ( n403 ) , .B0 ( n402 ) , .Y ( n455 ) ) ;
ADDFHXL U1580 ( .A ( meas_val_p[15] ) , .B ( meas_val_n[15] ) , 
    .CI ( accumulator[15] ) , .CO ( n405 ) , .S ( n397 ) ) ;
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
CLKBUFX4 ZBUF_1431_inst_1018 ( .A ( HFSNET_323 ) , .Y ( ZBUF_1431_14 ) ) ;
ADDFHXL U1598 ( .A ( meas_val_p[20] ) , .B ( meas_val_n[20] ) , 
    .CI ( accumulator[20] ) , .CO ( n419 ) , .S ( n415 ) ) ;
NAND2XL U1599 ( .A ( n434 ) , .B ( n432 ) , .Y ( n421 ) ) ;
AND4XL ctmTdsLR_2_1866 ( .A ( ZBUF_2_33 ) , .B ( n785 ) , .C ( n784 ) , 
    .D ( n783 ) , .Y ( tmp_net274 ) ) ;
BUFX8 ZCTSBUF_251_1378 ( .A ( net1746 ) , .Y ( ZCTSNET_376 ) ) ;
BUFXL ZBUF_17_inst_1020 ( .A ( N1840 ) , .Y ( ZBUF_17_14 ) ) ;
NAND2XL ctmTdsLR_6_1966 ( .A ( n1267 ) , .B ( \shadow_weights[1][1] ) , 
    .Y ( tmp_net340 ) ) ;
CLKINVX1 HFSINV_337_527 ( .A ( n968 ) , .Y ( HFSNET_272 ) ) ;
AOI21XL U1607 ( .A0 ( n431 ) , .A1 ( HFSNET_325 ) , .B0 ( HFSNET_272 ) , 
    .Y ( n817 ) ) ;
AOI21XL U1608 ( .A0 ( n435 ) , .A1 ( n434 ) , .B0 ( n433 ) , .Y ( n461 ) ) ;
CMPR32X1 U1609 ( .A ( meas_val_p[21] ) , .B ( meas_val_n[21] ) , 
    .C ( accumulator[21] ) , .CO ( n436 ) , .S ( n420 ) ) ;
NAND2XL U1612 ( .A ( n440 ) , .B ( HFSNET_325 ) , .Y ( n942 ) ) ;
AOI21XL U1613 ( .A0 ( n443 ) , .A1 ( n442 ) , .B0 ( n441 ) , .Y ( n478 ) ) ;
XOR2XL U1616 ( .A ( n478 ) , .B ( n445 ) , .Y ( n446 ) ) ;
NAND2XL U1617 ( .A ( n446 ) , .B ( HFSNET_325 ) , .Y ( n957 ) ) ;
OAI21XL U1618 ( .A0 ( n521 ) , .A1 ( n448 ) , .B0 ( n447 ) , .Y ( n453 ) ) ;
XNOR2XL U1621 ( .A ( n453 ) , .B ( n452 ) , .Y ( n454 ) ) ;
NAND2XL U1622 ( .A ( n454 ) , .B ( HFSNET_325 ) , .Y ( n954 ) ) ;
INVXL U1623 ( .A ( n456 ) , .Y ( n501 ) ) ;
NAND2XL U1624 ( .A ( n501 ) , .B ( n499 ) , .Y ( n457 ) ) ;
XNOR2XL U1625 ( .A ( n550 ) , .B ( n457 ) , .Y ( n458 ) ) ;
NAND2XL U1626 ( .A ( n458 ) , .B ( HFSNET_325 ) , .Y ( n948 ) ) ;
ADDFHXL U1627 ( .A ( meas_val_p[22] ) , .B ( meas_val_n[22] ) , 
    .CI ( accumulator[22] ) , .CO ( n462 ) , .S ( n437 ) ) ;
NAND2XL U1628 ( .A ( n510 ) , .B ( n508 ) , .Y ( n464 ) ) ;
NAND2XL U1629 ( .A ( n465 ) , .B ( HFSNET_325 ) , .Y ( n941 ) ) ;
CLKBUFX8 ZCTSBUF_259_1380 ( .A ( net1756 ) , .Y ( ZCTSNET_378 ) ) ;
INVXL U1632 ( .A ( n470 ) , .Y ( n538 ) ) ;
NAND2XL U1633 ( .A ( n538 ) , .B ( n536 ) , .Y ( n471 ) ) ;
XNOR2XL U1634 ( .A ( n539 ) , .B ( n471 ) , .Y ( n472 ) ) ;
NAND2XL U1635 ( .A ( n472 ) , .B ( HFSNET_325 ) , .Y ( n953 ) ) ;
AOI2BB1XL U1636 ( .A0N ( n579 ) , .A1N ( wait_cnt[4] ) , .B0 ( n2076 ) , 
    .Y ( n475 ) ) ;
INVXL U1637 ( .A ( n573 ) , .Y ( n473 ) ) ;
AOI21XL U1638 ( .A0 ( n475 ) , .A1 ( n474 ) , .B0 ( n473 ) , .Y ( n790 ) ) ;
NAND2XL U1639 ( .A ( HFSNET_329 ) , .B ( n2173 ) , .Y ( n973 ) ) ;
OAI21XL U1640 ( .A0 ( n478 ) , .A1 ( n477 ) , .B0 ( n476 ) , .Y ( n483 ) ) ;
XNOR2XL U1643 ( .A ( n483 ) , .B ( n482 ) , .Y ( n484 ) ) ;
NAND2XL U1644 ( .A ( n484 ) , .B ( HFSNET_325 ) , .Y ( n956 ) ) ;
NAND2XL U1645 ( .A ( n488 ) , .B ( n487 ) , .Y ( n489 ) ) ;
NAND2XL U1646 ( .A ( n491 ) , .B ( HFSNET_325 ) , .Y ( n946 ) ) ;
NAND2XL U1647 ( .A ( n495 ) , .B ( n494 ) , .Y ( n496 ) ) ;
NAND2XL U1648 ( .A ( n498 ) , .B ( HFSNET_325 ) , .Y ( n944 ) ) ;
AOI22XL ctmTdsLR_2_2040 ( .A0 ( n1688 ) , .A1 ( \shadow_weights[15][24] ) , 
    .B0 ( n1319 ) , .B1 ( \shadow_weights[13][24] ) , .Y ( tmp_net393 ) ) ;
NAND2XL U1652 ( .A ( n507 ) , .B ( HFSNET_325 ) , .Y ( n947 ) ) ;
AOI21XL U1653 ( .A0 ( n511 ) , .A1 ( n510 ) , .B0 ( n509 ) , .Y ( n563 ) ) ;
ADDFHXL U1654 ( .A ( meas_val_p[23] ) , .B ( meas_val_n[23] ) , 
    .CI ( accumulator[23] ) , .CO ( n512 ) , .S ( n463 ) ) ;
NAND2XL U1657 ( .A ( n516 ) , .B ( HFSNET_325 ) , .Y ( n940 ) ) ;
AOI22XL U1658 ( .A0 ( target_bit[0] ) , .A1 ( n2158 ) , 
    .B0 ( target_bit[1] ) , .B1 ( n2163 ) , .Y ( n518 ) ) ;
AOI21XL U1660 ( .A0 ( n2100 ) , .A1 ( n2132 ) , .B0 ( n2076 ) , .Y ( n517 ) ) ;
AOI21XL U1661 ( .A0 ( n518 ) , .A1 ( n2078 ) , .B0 ( n517 ) , .Y ( n792 ) ) ;
INVXL U1662 ( .A ( n522 ) , .Y ( n533 ) ) ;
INVXL U1663 ( .A ( n532 ) , .Y ( n523 ) ) ;
XOR2XL U1666 ( .A ( n528 ) , .B ( n527 ) , .Y ( n530 ) ) ;
AOI21XL U1667 ( .A0 ( n530 ) , .A1 ( HFSNET_325 ) , .B0 ( HFSNET_272 ) , 
    .Y ( n818 ) ) ;
NAND2XL U1668 ( .A ( n533 ) , .B ( n532 ) , .Y ( n534 ) ) ;
NAND2XL U1669 ( .A ( n535 ) , .B ( HFSNET_325 ) , .Y ( n951 ) ) ;
INVXL U1670 ( .A ( n536 ) , .Y ( n537 ) ) ;
NAND2XL U1673 ( .A ( n545 ) , .B ( HFSNET_325 ) , .Y ( n952 ) ) ;
NOR2XL U1674 ( .A ( calc_cnt[0] ) , .B ( calc_cnt[1] ) , .Y ( n617 ) ) ;
NAND2XL U1675 ( .A ( calc_cnt[0] ) , .B ( calc_cnt[1] ) , .Y ( n618 ) ) ;
NAND3XL U1676 ( .A ( HFSNET_329 ) , .B ( n629 ) , .C ( n618 ) , .Y ( n972 ) ) ;
AOI222XL ctmTdsLR_3_2041 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][24] ) , .B0 ( n1686 ) , 
    .B1 ( \shadow_weights[6][24] ) , .C0 ( n1687 ) , 
    .C1 ( \shadow_weights[2][24] ) , .Y ( tmp_net394 ) ) ;
NOR2XL ctmTdsLR_4_2141 ( .A ( n1885 ) , .B ( n1884 ) , .Y ( tmp_net454 ) ) ;
NAND2XL U1681 ( .A ( n556 ) , .B ( HFSNET_325 ) , .Y ( n945 ) ) ;
NAND2XL U1682 ( .A ( n557 ) , .B ( calc_cnt[2] ) , .Y ( n614 ) ) ;
OAI211XL U1683 ( .A0 ( calc_cnt[2] ) , .A1 ( n557 ) , .B0 ( HFSNET_329 ) , 
    .C0 ( n614 ) , .Y ( n971 ) ) ;
INVXL U1684 ( .A ( n614 ) , .Y ( n558 ) ) ;
OAI211XL U1686 ( .A0 ( calc_cnt[3] ) , .A1 ( n558 ) , .B0 ( HFSNET_329 ) , 
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
CMPR32X1 U1694 ( .A ( meas_val_p[24] ) , .B ( meas_val_n[24] ) , 
    .C ( accumulator[24] ) , .CO ( n564 ) , .S ( n513 ) ) ;
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
ADDFX1 U1713 ( .A ( meas_val_p[25] ) , .B ( meas_val_n[25] ) , 
    .CI ( accumulator[25] ) , .CO ( n585 ) , .S ( n565 ) ) ;
OAI21XL ctmTdsLR_1_2142 ( .A0 ( n1864 ) , .A1 ( n1863 ) , .B0 ( tmp_net456 ) , 
    .Y ( n1868 ) ) ;
AOI222XL ctmTdsLR_2_749 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][22] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][22] ) , .C0 ( n1673 ) , 
    .C1 ( \shadow_weights[17][22] ) , .Y ( tmp_net81 ) ) ;
INVXL U1718 ( .A ( n595 ) , .Y ( n603 ) ) ;
NAND2XL U1719 ( .A ( n603 ) , .B ( n601 ) , .Y ( n596 ) ) ;
NAND2XL U1720 ( .A ( n597 ) , .B ( HFSNET_325 ) , .Y ( n950 ) ) ;
NAND3XL U1721 ( .A ( N1822 ) , .B ( wr_idx_r[2] ) , .C ( wr_idx_r[0] ) , 
    .Y ( n599 ) ) ;
NOR2X2 U1722 ( .A ( n668 ) , .B ( n599 ) , .Y ( N1827 ) ) ;
INVXL HFSINV_11_502 ( .A ( N1835 ) , .Y ( HFSNET_251 ) ) ;
NOR2X1 U1724 ( .A ( n667 ) , .B ( n599 ) , .Y ( N1835 ) ) ;
NOR2X1 U1725 ( .A ( n600 ) , .B ( n599 ) , .Y ( N1837 ) ) ;
INVXL U1726 ( .A ( n601 ) , .Y ( n602 ) ) ;
NAND2XL U1729 ( .A ( n610 ) , .B ( HFSNET_325 ) , .Y ( n949 ) ) ;
NOR2XL U1730 ( .A ( calc_cnt[2] ) , .B ( calc_cnt[3] ) , .Y ( n1659 ) ) ;
OR2XL U1732 ( .A ( n631 ) , .B ( n626 ) , .Y ( n1297 ) ) ;
OR2XL U1733 ( .A ( n631 ) , .B ( n618 ) , .Y ( n1298 ) ) ;
NOR2XL U1734 ( .A ( n2176 ) , .B ( calc_cnt[4] ) , .Y ( n611 ) ) ;
NAND2XL U1735 ( .A ( n611 ) , .B ( n2175 ) , .Y ( n628 ) ) ;
OR2XL U1736 ( .A ( n628 ) , .B ( n629 ) , .Y ( n1299 ) ) ;
OR2XL U1737 ( .A ( n628 ) , .B ( n626 ) , .Y ( n1300 ) ) ;
AOI22XL U1738 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][0] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][0] ) , .Y ( n613_CDR1 ) ) ;
NAND2XL U1739 ( .A ( n611 ) , .B ( calc_cnt[3] ) , .Y ( n627 ) ) ;
OR2XL U1740 ( .A ( n627 ) , .B ( n629 ) , .Y ( n1301 ) ) ;
OR2XL U1741 ( .A ( n627 ) , .B ( n630 ) , .Y ( n1302 ) ) ;
AOI22X1 U1742 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][0] ) , 
    .B0 ( n1271 ) , .B1 ( \shadow_weights[12][0] ) , .Y ( n612_CDR1 ) ) ;
AOI222XL ctmTdsLR_2_944 ( .A0 ( \shadow_weights[13][11] ) , .A1 ( n1291 ) , 
    .B0 ( n1290 ) , .B1 ( \shadow_weights[6][11] ) , .C0 ( n1688 ) , 
    .C1 ( \shadow_weights[15][11] ) , .Y ( tmp_net218 ) ) ;
CLKINVX8 HFSINV_224_578 ( .A ( n1210 ) , .Y ( HFSNET_322 ) ) ;
NAND2XL ctmTdsLR_3_945 ( .A ( n1292 ) , .B ( \shadow_weights[2][11] ) , 
    .Y ( tmp_net219 ) ) ;
NAND3XL U1746 ( .A ( n2176 ) , .B ( n2161 ) , .C ( calc_cnt[3] ) , 
    .Y ( n616 ) ) ;
OR2XL U1747 ( .A ( n616 ) , .B ( n618 ) , .Y ( n1305 ) ) ;
OR2XL U1748 ( .A ( n616 ) , .B ( n626 ) , .Y ( n1306 ) ) ;
AOI22XL U1749 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][0] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][0] ) , .Y ( n615_CDR1 ) ) ;
OR2XL U1750 ( .A ( n616 ) , .B ( n629 ) , .Y ( n1308 ) ) ;
OR2XL U1751 ( .A ( n616 ) , .B ( n630 ) , .Y ( n1309 ) ) ;
AOI211X2 ctmTdsLR_1_1967 ( .A0 ( HFSNET_322 ) , 
    .A1 ( \shadow_weights[7][6] ) , .B0 ( tmp_net344 ) , .C0 ( tmp_net345 ) , 
    .Y ( n1036_CDR1 ) ) ;
OR2XL U1753 ( .A ( n630 ) , .B ( n2161 ) , .Y ( n675 ) ) ;
NAND4XL ctmTdsLR_2_1968 ( .A ( tmp_net343 ) , .B ( n1032_CDR1 ) , 
    .C ( n1025 ) , .D ( n1024_CDR1 ) , .Y ( tmp_net344 ) ) ;
OR2X1 U1755 ( .A ( n626 ) , .B ( n2161 ) , .Y ( n676 ) ) ;
OR2XL U1756 ( .A ( n618 ) , .B ( n2161 ) , .Y ( n1311 ) ) ;
AOI22XL ctmTdsLR_1_835 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][18] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][18] ) , .Y ( tmp_net146 ) ) ;
NAND4XL ctmTdsLR_3_2044 ( .A ( copt_gre_net_509 ) , .B ( tmp_net303 ) , 
    .C ( tmp_net27 ) , .D ( tmp_net304 ) , .Y ( tmp_net397 ) ) ;
AND4XL ctmTdsLR_4_902 ( .A ( tmp_net185 ) , .B ( tmp_net162 ) , 
    .C ( n613_CDR1 ) , .D ( ZBUF_2_21 ) , .Y ( tmp_net187 ) ) ;
OR2XL U1760 ( .A ( n628 ) , .B ( n630 ) , .Y ( n1320 ) ) ;
OR2X1 U1761 ( .A ( n631 ) , .B ( n630 ) , .Y ( n1322 ) ) ;
OR2XL U1762 ( .A ( n1698 ) , .B ( calc_cnt[4] ) , .Y ( n993 ) ) ;
NAND2XL ctmTdsLR_4_2045 ( .A ( n1271 ) , .B ( \shadow_weights[12][7] ) , 
    .Y ( tmp_net396 ) ) ;
AND2X4 U1766 ( .A ( n659 ) , .B ( n1657 ) , .Y ( n640 ) ) ;
NAND2XL ctmTdsLR_2_2143 ( .A ( tmp_net455 ) , .B ( n1861 ) , .Y ( n1863 ) ) ;
AOI22XL U1768 ( .A0 ( n2157 ) , .A1 ( N1822 ) , .B0 ( n640 ) , 
    .B1 ( calib_overrange ) , .Y ( n698 ) ) ;
INVXL U1769 ( .A ( n641 ) , .Y ( n1982 ) ) ;
OR2XL U1770 ( .A ( wait_cnt[0] ) , .B ( n1982 ) , .Y ( n927 ) ) ;
ADDFHXL U1771 ( .A ( meas_val_p[26] ) , .B ( meas_val_n[26] ) , 
    .CI ( accumulator[26] ) , .CO ( n645 ) , .S ( n586 ) ) ;
NAND2XL U1772 ( .A ( n694 ) , .B ( n692 ) , .Y ( n647 ) ) ;
NAND2XL ctmTdsLR_1_753 ( .A ( gre_a_INV_7090_53 ) , .B ( accumulator[22] ) , 
    .Y ( HFSNET_0 ) ) ;
NAND2XL U1774 ( .A ( n1627 ) , .B ( n1626 ) , .Y ( n1693 ) ) ;
INVXL ctmTdsLR_3_2144 ( .A ( n1860 ) , .Y ( tmp_net455 ) ) ;
AOI22XL ctmTdsLR_1_904 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][15] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][15] ) , .Y ( tmp_net188 ) ) ;
AOI211XL U1778 ( .A0 ( n725 ) , .A1 ( n1693 ) , .B0 ( n652 ) , .C0 ( n651 ) , 
    .Y ( n660 ) ) ;
OAI21XL U1779 ( .A0 ( HFSNET_177 ) , .A1 ( n322 ) , .B0 ( n660 ) , 
    .Y ( n653 ) ) ;
AOI211XL U1780 ( .A0 ( n654 ) , .A1 ( n1658 ) , .B0 ( n663 ) , .C0 ( n653 ) , 
    .Y ( n816 ) ) ;
INVXL U1781 ( .A ( n1693 ) , .Y ( n726 ) ) ;
INVXL U1782 ( .A ( n732 ) , .Y ( n655 ) ) ;
OAI21XL U1783 ( .A0 ( n655 ) , .A1 ( state[1] ) , .B0 ( state[2] ) , 
    .Y ( n656 ) ) ;
OAI21XL U1784 ( .A0 ( start_calib ) , .A1 ( state[2] ) , .B0 ( n656 ) , 
    .Y ( n657 ) ) ;
CLKBUFX4 gre_a_BUF_1102_inst_2327 ( .A ( n69 ) , .Y ( gre_a_BUF_1102_49 ) ) ;
NAND4XL U1786 ( .A ( n660 ) , .B ( n1655 ) , .C ( n659 ) , .D ( HFSNET_117 ) , 
    .Y ( n661 ) ) ;
AOI211XL U1787 ( .A0 ( n726 ) , .A1 ( n663 ) , .B0 ( n662 ) , .C0 ( n661 ) , 
    .Y ( n821 ) ) ;
NOR2X1 U1788 ( .A ( n664 ) , .B ( n667 ) , .Y ( N1839 ) ) ;
NOR2X1 U1789 ( .A ( n664 ) , .B ( n668 ) , .Y ( N1831 ) ) ;
NOR2X1 U1790 ( .A ( n665 ) , .B ( n669 ) , .Y ( N1824 ) ) ;
NOR2X1 U1791 ( .A ( n670 ) , .B ( n671 ) , .Y ( N1825 ) ) ;
NOR2XL U1792 ( .A ( n669 ) , .B ( n667 ) , .Y ( N1840 ) ) ;
NOR2X1 U1793 ( .A ( n669 ) , .B ( n668 ) , .Y ( N1832 ) ) ;
AOI22X2 U1794 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][1] ) , 
    .B0 ( n1271 ) , .B1 ( \shadow_weights[12][1] ) , .Y ( n673_CDR1 ) ) ;
AOI22XL U1795 ( .A0 ( n1270 ) , .A1 ( \shadow_weights[14][1] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][1] ) , 
    .Y ( n672_CDR1 ) ) ;
NAND2XL ctmTdsLR_4_2145 ( .A ( n1864 ) , .B ( n1863 ) , .Y ( tmp_net456 ) ) ;
AOI222XL ctmTdsLR_2_836 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][18] ) , 
    .B0 ( n1291 ) , .B1 ( \shadow_weights[13][18] ) , .C0 ( ZBUF_3430_2 ) , 
    .C1 ( \shadow_weights[0][18] ) , .Y ( tmp_net147 ) ) ;
NAND3BXL ctmTdsLR_3_2048 ( .AN ( n747_CDR2 ) , .B ( tmp_net325 ) , 
    .C ( n749_CDR1 ) , .Y ( tmp_net399 ) ) ;
AND3XL ctmTdsLR_3_1969 ( .A ( tmp_net288 ) , .B ( tmp_net289 ) , 
    .C ( tmp_net105 ) , .Y ( tmp_net343 ) ) ;
BUFX8 ZCTSBUF_255_1381 ( .A ( net1666 ) , .Y ( ZCTSNET_379 ) ) ;
NAND3X1 ctmTdsLR_1_2146 ( .A ( n1296_CDR1 ) , .B ( tmp_net146 ) , 
    .C ( tmp_net147 ) , .Y ( ZBUF_17_23 ) ) ;
NOR4X1 ctmTdsLR_1_2147 ( .A ( tmp_net116 ) , .B ( tmp_net457 ) , 
    .C ( tmp_net114 ) , .D ( tmp_net115 ) , .Y ( tmp_net373 ) ) ;
NOR2XL U1803 ( .A ( HFSNET_118 ) , .B ( temp_acc[1] ) , .Y ( n739 ) ) ;
AOI21XL U1804 ( .A0 ( n695 ) , .A1 ( n694 ) , .B0 ( n693 ) , .Y ( n806 ) ) ;
CMPR32X1 U1805 ( .A ( meas_val_p[27] ) , .B ( meas_val_n[27] ) , 
    .C ( accumulator[27] ) , .CO ( n696 ) , .S ( n646 ) ) ;
AOI21XL U1809 ( .A0 ( n732 ) , .A1 ( n723 ) , .B0 ( n56 ) , .Y ( n724 ) ) ;
NAND3XL U1813 ( .A ( HFSNET_117 ) , .B ( n729 ) , .C ( n1416 ) , .Y ( n731 ) ) ;
INVXL ctmTdsLR_4_1970 ( .A ( n1023_CDR1 ) , .Y ( tmp_net345 ) ) ;
AOI222XL ctmTdsLR_2_755 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][0] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][0] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][0] ) , .Y ( tmp_net85 ) ) ;
NAND2XL ctmTdsLR_1_1971 ( .A ( ZBUF_3430_2 ) , .B ( \shadow_weights[0][17] ) , 
    .Y ( tmp_net346 ) ) ;
NAND2XL ctmTdsLR_2_1972 ( .A ( n1271 ) , .B ( \shadow_weights[12][17] ) , 
    .Y ( tmp_net347 ) ) ;
NAND2XL ctmTdsLR_2_2148 ( .A ( tmp_net192 ) , .B ( tmp_net191 ) , 
    .Y ( tmp_net457 ) ) ;
NAND2XL ctmTdsLR_1_759 ( .A ( n1278 ) , .B ( \shadow_weights[8][1] ) , 
    .Y ( tmp_net88 ) ) ;
AOI222XL ctmTdsLR_3_1973 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][17] ) , 
    .B0 ( n1291 ) , .B1 ( \shadow_weights[13][17] ) , .C0 ( n1270 ) , 
    .C1 ( \shadow_weights[14][17] ) , .Y ( tmp_net348 ) ) ;
AOI21XL ctmTdsLR_1_2149 ( .A0 ( n139 ) , .A1 ( n138 ) , .B0 ( tmp_net459 ) , 
    .Y ( n1793 ) ) ;
AOI22XL ctmTdsLR_4_1974 ( .A0 ( n1278 ) , .A1 ( \shadow_weights[8][17] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][17] ) , .Y ( tmp_net349 ) ) ;
NOR2XL U1823 ( .A ( HFSNET_119 ) , .B ( temp_acc[2] ) , .Y ( n976 ) ) ;
NAND2XL U1824 ( .A ( HFSNET_119 ) , .B ( temp_acc[2] ) , .Y ( n978 ) ) ;
OAI21XL U1825 ( .A0 ( n779 ) , .A1 ( n976 ) , .B0 ( n978 ) , .Y ( n802 ) ) ;
AOI22XL U1826 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][3] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][3] ) , .Y ( n784 ) ) ;
AOI22XL U1827 ( .A0 ( n1282 ) , .A1 ( \shadow_weights[17][3] ) , 
    .B0 ( n1281 ) , .B1 ( \shadow_weights[19][3] ) , .Y ( n783 ) ) ;
NAND2XL ctmTdsLR_2_2150 ( .A ( tmp_net458 ) , .B ( n136 ) , .Y ( n138 ) ) ;
BUFX8 ZCTSBUF_247_1382 ( .A ( net1671 ) , .Y ( ZCTSNET_380 ) ) ;
NOR2XL U1830 ( .A ( HFSNET_120 ) , .B ( temp_acc[3] ) , .Y ( n979 ) ) ;
OAI21XL U1831 ( .A0 ( n806 ) , .A1 ( n805 ) , .B0 ( n804 ) , .Y ( n814 ) ) ;
ADDFHXL U1832 ( .A ( meas_val_p[28] ) , .B ( meas_val_n[28] ) , 
    .CI ( accumulator[28] ) , .CO ( n807 ) , .S ( n718 ) ) ;
NAND2XL U1833 ( .A ( n813 ) , .B ( n811 ) , .Y ( n809 ) ) ;
AOI21XL U1834 ( .A0 ( n814 ) , .A1 ( n813 ) , .B0 ( n812 ) , .Y ( n1082 ) ) ;
CMPR32X1 U1835 ( .A ( accumulator[29] ) , .B ( n2169 ) , .C ( n2193 ) , 
    .CO ( n824 ) , .S ( n808 ) ) ;
OAI21XL U1838 ( .A0 ( n979 ) , .A1 ( n978 ) , .B0 ( n977 ) , .Y ( n980 ) ) ;
AOI21XL U1839 ( .A0 ( n982 ) , .A1 ( n981 ) , .B0 ( n980 ) , .Y ( n1061 ) ) ;
INVXL U1840 ( .A ( n1061 ) , .Y ( n1087 ) ) ;
AOI22XL ctmTdsLR_2_1976 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][11] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][11] ) , .Y ( tmp_net350 ) ) ;
AOI222X1 ctmTdsLR_3_1977 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][11] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][11] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][11] ) , .Y ( tmp_net351 ) ) ;
INVXL ctmTdsLR_3_2151 ( .A ( n135 ) , .Y ( tmp_net458 ) ) ;
NOR2XL U1844 ( .A ( HFSNET_153 ) , .B ( temp_acc[4] ) , .Y ( n1022 ) ) ;
NAND2XL U1845 ( .A ( HFSNET_153 ) , .B ( temp_acc[4] ) , .Y ( n1053 ) ) ;
NAND3XL ctmTdsLR_4_841 ( .A ( tmp_net315 ) , .B ( tmp_net316 ) , 
    .C ( tmp_net317 ) , .Y ( HFSNET_50 ) ) ;
NOR2XL ctmTdsLR_4_2152 ( .A ( n139 ) , .B ( n138 ) , .Y ( tmp_net459 ) ) ;
OAI21XL ctmTdsLR_1_2153 ( .A0 ( n271 ) , .A1 ( n279 ) , .B0 ( tmp_net460 ) , 
    .Y ( n275 ) ) ;
NOR2XL U1850 ( .A ( HFSNET_121 ) , .B ( temp_acc[5] ) , .Y ( n1054 ) ) ;
NOR2XL U1851 ( .A ( n1022 ) , .B ( n1054 ) , .Y ( n1086 ) ) ;
AOI22XL ctmTdsLR_1_868 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][12] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][12] ) , .Y ( tmp_net168 ) ) ;
AOI222XL ctmTdsLR_2_869 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][12] ) , 
    .B0 ( n1291 ) , .B1 ( \shadow_weights[13][12] ) , .C0 ( ZBUF_3430_2 ) , 
    .C1 ( \shadow_weights[0][12] ) , .Y ( tmp_net169 ) ) ;
NAND3BXL ctmTdsLR_3_2051 ( .AN ( n990_CDR1 ) , .B ( tmp_net327 ) , 
    .C ( n992_CDR2 ) , .Y ( tmp_net401 ) ) ;
NAND2XL ctmTdsLR_2_2154 ( .A ( n279 ) , .B ( n271 ) , .Y ( tmp_net460 ) ) ;
NOR2XL U1856 ( .A ( HFSNET_122 ) , .B ( temp_acc[6] ) , .Y ( n1134 ) ) ;
NAND2XL ctmTdsLR_2_2162 ( .A ( tmp_net464 ) , .B ( n95 ) , .Y ( n97 ) ) ;
AOI222XL ctmTdsLR_1_764 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][12] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][12] ) , .C0 ( n1271 ) , 
    .C1 ( \shadow_weights[12][12] ) , .Y ( tmp_net92 ) ) ;
NAND4BXL ctmTdsLR_3_870 ( .AN ( n1172_CDR2 ) , .B ( n1174_CDR1 ) , 
    .C ( tmp_net168 ) , .D ( tmp_net169 ) , .Y ( tmp_net170 ) ) ;
INVXL ctmTdsLR_3_2163 ( .A ( n94 ) , .Y ( tmp_net464 ) ) ;
NOR2XL U1861 ( .A ( HFSNET_123 ) , .B ( temp_acc[7] ) , .Y ( n1136 ) ) ;
NOR2XL U1862 ( .A ( n1134 ) , .B ( n1136 ) , .Y ( n1058 ) ) ;
NAND2XL U1863 ( .A ( HFSNET_122 ) , .B ( temp_acc[6] ) , .Y ( n1133 ) ) ;
OAI21XL U1864 ( .A0 ( n1136 ) , .A1 ( n1133 ) , .B0 ( n1137 ) , .Y ( n1057 ) ) ;
AOI21XL U1865 ( .A0 ( n1058 ) , .A1 ( n1085 ) , .B0 ( n1057 ) , .Y ( n1059 ) ) ;
OAI21XL U1866 ( .A0 ( n1061 ) , .A1 ( n1060 ) , .B0 ( n1059 ) , .Y ( n1235 ) ) ;
INVXL U1867 ( .A ( n1235 ) , .Y ( n1423 ) ) ;
AOI22XL U1868 ( .A0 ( n1267 ) , .A1 ( \shadow_weights[1][8] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][8] ) , .Y ( n1071 ) ) ;
INVXL ctmTdsLR_3_2167 ( .A ( n357 ) , .Y ( tmp_net466 ) ) ;
NAND2XL ctmTdsLR_1_766 ( .A ( n1278 ) , .B ( \shadow_weights[8][14] ) , 
    .Y ( tmp_net93 ) ) ;
AOI21XL ctmTdsLR_2_1979 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][8] ) , .B0 ( tmp_net353 ) , .Y ( tmp_net354 ) ) ;
AOI22XL U1872 ( .A0 ( n1275 ) , .A1 ( \shadow_weights[11][8] ) , 
    .B0 ( n1274 ) , .B1 ( \shadow_weights[9][8] ) , .Y ( n1064_CDR2 ) ) ;
NAND3X1 ctmTdsLR_3_1980 ( .A ( ZBUF_2_30 ) , .B ( ZBUF_2_45 ) , 
    .C ( tmp_net352 ) , .Y ( tmp_net353 ) ) ;
AOI22XL ctmTdsLR_4_1981 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][8] ) , 
    .B0 ( n1278 ) , .B1 ( \shadow_weights[8][8] ) , .Y ( tmp_net352 ) ) ;
NAND3XL ctmTdsLR_1_1982 ( .A ( tmp_net355 ) , .B ( tmp_net123 ) , 
    .C ( tmp_net356 ) , .Y ( HFSNET_89 ) ) ;
AOI22XL ctmTdsLR_2_1983 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][10] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][10] ) , .Y ( tmp_net355 ) ) ;
NOR2XL U1877 ( .A ( HFSNET_161 ) , .B ( temp_acc[8] ) , .Y ( n1110 ) ) ;
NAND2XL U1880 ( .A ( n1144 ) , .B ( n1142 ) , .Y ( n1083 ) ) ;
AOI21XL U1881 ( .A0 ( n1087 ) , .A1 ( n1086 ) , .B0 ( n1085 ) , .Y ( n1135 ) ) ;
OAI21XL U1882 ( .A0 ( n1423 ) , .A1 ( n1110 ) , .B0 ( n1112 ) , .Y ( n1108 ) ) ;
AOI222XL ctmTdsLR_3_1984 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][10] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][10] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][10] ) , .Y ( tmp_net356 ) ) ;
NOR2XL ctmTdsLR_4_2164 ( .A ( n98 ) , .B ( n97 ) , .Y ( tmp_net465 ) ) ;
NOR4BXL U1885 ( .AN ( n1100 ) , .B ( HFSNET_82 ) , .C ( n1098 ) , 
    .D ( HFSNET_90 ) , .Y ( n1104 ) ) ;
NOR2XL U1887 ( .A ( ZBUF_17_24 ) , .B ( temp_acc[9] ) , .Y ( n1113 ) ) ;
NOR2XL U1888 ( .A ( n1110 ) , .B ( n1113 ) , .Y ( n1164 ) ) ;
NOR3XL ctmTdsLR_4_871 ( .A ( tmp_net170 ) , .B ( HFSNET_36 ) , 
    .C ( HFSNET_35 ) , .Y ( n1226 ) ) ;
NAND2XL ctmTdsLR_4_2168 ( .A ( n352 ) , .B ( n351 ) , .Y ( tmp_net467 ) ) ;
NOR4BXL U1891 ( .AN ( n1125_CDR1 ) , .B ( n1124_CDR2 ) , .C ( n1123_CDR1 ) , 
    .D ( ZBUF_2_17 ) , .Y ( n1129_CDR2 ) ) ;
NOR2XL U1893 ( .A ( HFSNET_125 ) , .B ( temp_acc[10] ) , .Y ( n1163 ) ) ;
NAND2XL U1894 ( .A ( HFSNET_125 ) , .B ( temp_acc[10] ) , .Y ( n1432 ) ) ;
OAI21XL U1895 ( .A0 ( n1135 ) , .A1 ( n1134 ) , .B0 ( n1133 ) , .Y ( n1140 ) ) ;
AOI21XL U1896 ( .A0 ( n1145 ) , .A1 ( n1144 ) , .B0 ( n1143 ) , .Y ( n1495 ) ) ;
NAND3BXL ctmTdsLR_3_2054 ( .AN ( n1010_CDR1 ) , .B ( tmp_net326 ) , 
    .C ( n1012_CDR1 ) , .Y ( tmp_net403 ) ) ;
OAI21XL ctmTdsLR_1_2169 ( .A0 ( n1843 ) , .A1 ( n1842 ) , .B0 ( tmp_net469 ) , 
    .Y ( n1847 ) ) ;
NAND2XL ctmTdsLR_2_2170 ( .A ( tmp_net468 ) , .B ( n1840 ) , .Y ( n1842 ) ) ;
NOR2XL U1903 ( .A ( ZBUF_17_27 ) , .B ( temp_acc[11] ) , .Y ( n1436 ) ) ;
NOR2XL U1904 ( .A ( n1163 ) , .B ( n1436 ) , .Y ( n1225 ) ) ;
NAND2XL U1905 ( .A ( n1164 ) , .B ( n1225 ) , .Y ( n1422 ) ) ;
AOI22XL U1906 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][12] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][12] ) , .Y ( n1174_CDR1 ) ) ;
INVXL ctmTdsLR_3_2171 ( .A ( n1839 ) , .Y ( tmp_net468 ) ) ;
NAND2XL ctmTdsLR_4_2172 ( .A ( n1843 ) , .B ( n1842 ) , .Y ( tmp_net469 ) ) ;
AOI222XL ctmTdsLR_2_905 ( .A0 ( n1291 ) , .A1 ( \shadow_weights[13][15] ) , 
    .B0 ( \shadow_weights[6][15] ) , .B1 ( n1290 ) , .C0 ( ZBUF_3430_2 ) , 
    .C1 ( \shadow_weights[0][15] ) , .Y ( tmp_net189 ) ) ;
AOI22XL U1910 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][12] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][12] ) , .Y ( n1167_CDR2 ) ) ;
NAND4BXL ctmTdsLR_3_906 ( .AN ( n1215_CDR1 ) , .B ( tmp_net188 ) , 
    .C ( tmp_net189 ) , .D ( n1217_CDR1 ) , .Y ( tmp_net190 ) ) ;
AOI222X1 ctmTdsLR_3_1894 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][4] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][4] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][4] ) , .Y ( tmp_net294 ) ) ;
AOI222XL ctmTdsLR_1_908 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][19] ) , 
    .B0 ( n1686 ) , .B1 ( \shadow_weights[6][19] ) , .C0 ( ZBUF_3430_2 ) , 
    .C1 ( \shadow_weights[0][19] ) , .Y ( tmp_net191 ) ) ;
OAI21XL ctmTdsLR_1_2173 ( .A0 ( n1140 ) , .A1 ( n1139 ) , .B0 ( tmp_net470 ) , 
    .Y ( n1141 ) ) ;
AOI22XL U1915 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][13] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][13] ) , .Y ( n1188_CDR1 ) ) ;
AOI22X2 U1916 ( .A0 ( n1268 ) , .A1 ( \shadow_weights[5][13] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][13] ) , 
    .Y ( n1180_CDR1 ) ) ;
AOI22XL U1917 ( .A0 ( n1271 ) , .A1 ( \shadow_weights[12][13] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][13] ) , .Y ( n1179_CDR2 ) ) ;
NAND2XL ctmTdsLR_2_2174 ( .A ( n1140 ) , .B ( n1139 ) , .Y ( tmp_net470 ) ) ;
AOI22XL U1919 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][13] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][13] ) , .Y ( n1181_CDR1 ) ) ;
OAI211XL ctmTdsLR_1_2175 ( .A0 ( n1633 ) , .A1 ( n1624 ) , 
    .B0 ( tmp_net472 ) , .C0 ( HFSNET_329 ) , .Y ( n2339 ) ) ;
BUFXL ZBUF_2_inst_2251 ( .A ( tmp_net270 ) , .Y ( ZBUF_2_24 ) ) ;
NAND3XL ctmTdsLR_1_2059 ( .A ( n1340_CDR2 ) , .B ( tmp_net408 ) , 
    .C ( tmp_net409 ) , .Y ( HFSNET_144 ) ) ;
AOI22XL ctmTdsLR_2_2060 ( .A0 ( n1688 ) , .A1 ( \shadow_weights[15][20] ) , 
    .B0 ( n1319 ) , .B1 ( \shadow_weights[13][20] ) , .Y ( tmp_net408 ) ) ;
NOR2XL U1924 ( .A ( HFSNET_158 ) , .B ( temp_acc[13] ) , .Y ( n1426 ) ) ;
NOR2XL U1925 ( .A ( n1424 ) , .B ( n1426 ) , .Y ( n1485 ) ) ;
AOI22XL U1926 ( .A0 ( gre_a_INV_4409_54 ) , .A1 ( \shadow_weights[3][14] ) , 
    .B0 ( n1267 ) , .B1 ( \shadow_weights[1][14] ) , .Y ( n1202_CDR1 ) ) ;
AOI22XL U1927 ( .A0 ( n1271 ) , .A1 ( \shadow_weights[12][14] ) , 
    .B0 ( n1268 ) , .B1 ( \shadow_weights[5][14] ) , .Y ( n1194_CDR2 ) ) ;
AOI22XL U1928 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][14] ) , 
    .B0 ( n1270 ) , .B1 ( \shadow_weights[14][14] ) , .Y ( n1193_CDR2 ) ) ;
NAND2XL U1929 ( .A ( n1194_CDR2 ) , .B ( n1193_CDR2 ) , .Y ( n1201_CDR2 ) ) ;
AOI22XL U1930 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][14] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][14] ) , .Y ( n1195_CDR2 ) ) ;
AOI22XL ctmTdsLR_2_909 ( .A0 ( n1687 ) , .A1 ( \shadow_weights[2][19] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][19] ) , .Y ( tmp_net192 ) ) ;
AOI222XL ctmTdsLR_3_2061 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][20] ) , .B0 ( n1687 ) , 
    .B1 ( \shadow_weights[2][20] ) , .C0 ( n1686 ) , 
    .C1 ( \shadow_weights[6][20] ) , .Y ( tmp_net409 ) ) ;
NAND2XL ctmTdsLR_3_2177 ( .A ( n1633 ) , .B ( n1624 ) , .Y ( tmp_net472 ) ) ;
OAI2BB1XL ctmTdsLR_1_951 ( .A0N ( n1002 ) , .A1N ( n1087 ) , .B0 ( n1053 ) , 
    .Y ( tmp_net223 ) ) ;
AOI22XL U1935 ( .A0 ( n1267 ) , .A1 ( \shadow_weights[1][15] ) , 
    .B0 ( HFSNET_322 ) , .B1 ( \shadow_weights[7][15] ) , .Y ( n1217_CDR1 ) ) ;
XNOR2X1 ctmTdsLR_2_952 ( .A ( tmp_net223 ) , .B ( n1019 ) , .Y ( n1021 ) ) ;
NAND2XL ctmTdsLR_2_2183 ( .A ( tmp_net475 ) , .B ( n1443 ) , 
    .Y ( tmp_net244 ) ) ;
NAND2XL ctmTdsLR_3_2184 ( .A ( n1442 ) , .B ( n1444 ) , .Y ( tmp_net475 ) ) ;
AOI22XL U1939 ( .A0 ( n1274 ) , .A1 ( \shadow_weights[9][15] ) , 
    .B0 ( n1275 ) , .B1 ( \shadow_weights[11][15] ) , .Y ( n1209_CDR1 ) ) ;
NAND2XL ctmTdsLR_4_2185 ( .A ( n1429 ) , .B ( tmp_net244 ) , 
    .Y ( tmp_net476 ) ) ;
AOI21XL ctmTdsLR_1_2186 ( .A0 ( n1516 ) , .A1 ( n1501 ) , .B0 ( tmp_net478 ) , 
    .Y ( n1502 ) ) ;
NAND2XL ctmTdsLR_2_2187 ( .A ( tmp_net477 ) , .B ( n1514 ) , .Y ( n1501 ) ) ;
INVXL ctmTdsLR_3_2188 ( .A ( n1515 ) , .Y ( tmp_net477 ) ) ;
NOR2XL U1944 ( .A ( HFSNET_162 ) , .B ( temp_acc[15] ) , .Y ( n1561 ) ) ;
NOR2XL U1945 ( .A ( n1490 ) , .B ( n1561 ) , .Y ( n1231 ) ) ;
OAI21XL U1946 ( .A0 ( n1436 ) , .A1 ( n1432 ) , .B0 ( n1437 ) , .Y ( n1223 ) ) ;
AOI21XL U1947 ( .A0 ( n1225 ) , .A1 ( n1224 ) , .B0 ( n1223 ) , .Y ( n1421 ) ) ;
OAI21XL U1948 ( .A0 ( n1561 ) , .A1 ( n1557 ) , .B0 ( n1562 ) , .Y ( n1230 ) ) ;
OAI21XL U1949 ( .A0 ( n1233 ) , .A1 ( n1421 ) , .B0 ( n1232 ) , .Y ( n1234 ) ) ;
AOI21X1 U1950 ( .A0 ( n1236 ) , .A1 ( n1235 ) , .B0 ( n1234 ) , .Y ( n1417 ) ) ;
NOR2XL ctmTdsLR_4_2189 ( .A ( n1516 ) , .B ( n1501 ) , .Y ( tmp_net478 ) ) ;
NAND2XL ctmTdsLR_1_781 ( .A ( n1278 ) , .B ( \shadow_weights[8][6] ) , 
    .Y ( tmp_net105 ) ) ;
NOR2XL U1953 ( .A ( ZBUF_24_23 ) , .B ( temp_acc[16] ) , .Y ( n1418 ) ) ;
BUFXL ZBUF_2_inst_1035 ( .A ( tmp_net85 ) , .Y ( ZBUF_2_21 ) ) ;
NOR2XL U1957 ( .A ( HFSNET_154 ) , .B ( temp_acc[17] ) , .Y ( n1450 ) ) ;
NOR2XL U1958 ( .A ( n1418 ) , .B ( n1450 ) , .Y ( n1499 ) ) ;
OAI21XL ctmTdsLR_1_2190 ( .A0 ( n1800 ) , .A1 ( n1799 ) , .B0 ( tmp_net479 ) , 
    .Y ( n1804 ) ) ;
NAND2XL ctmTdsLR_2_2191 ( .A ( n1800 ) , .B ( n1799 ) , .Y ( tmp_net479 ) ) ;
OAI211XL ctmTdsLR_1_2192 ( .A0 ( tmp_net240 ) , .A1 ( tmp_net480 ) , 
    .B0 ( tmp_net481 ) , .C0 ( HFSNET_329 ) , .Y ( n2340 ) ) ;
NOR4BXL U1962 ( .AN ( n1289 ) , .B ( n1288_CDR1 ) , .C ( n1287_CDR2 ) , 
    .D ( copt_gre_net_507 ) , .Y ( n1296_CDR1 ) ) ;
NOR2XL U1963 ( .A ( ZBUF_17_23 ) , .B ( temp_acc[18] ) , .Y ( n1515 ) ) ;
AOI22XL U1964 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][19] ) , 
    .B0 ( n1680 ) , .B1 ( \shadow_weights[12][19] ) , .Y ( n1303_CDR2 ) ) ;
AOI21XL ctmTdsLR_1_1895 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][0] ) , 
    .B0 ( tmp_net296 ) , .Y ( tmp_net185 ) ) ;
AOI22X1 U1966 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][19] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][19] ) , .Y ( n1314_CDR1 ) ) ;
OAI2BB1XL ctmTdsLR_2_1896 ( .A0N ( \shadow_weights[8][0] ) , .A1N ( n1278 ) , 
    .B0 ( tmp_net295 ) , .Y ( tmp_net296 ) ) ;
AOI22XL ctmTdsLR_3_1897 ( .A0 ( n1279 ) , .A1 ( \shadow_weights[16][0] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][0] ) , .Y ( tmp_net295 ) ) ;
INVXL ctmTdsLR_2_2193 ( .A ( n1652 ) , .Y ( tmp_net480 ) ) ;
NOR2XL U1971 ( .A ( ZBUF_28_24 ) , .B ( temp_acc[19] ) , .Y ( n1517 ) ) ;
NOR2XL U1972 ( .A ( n1515 ) , .B ( n1517 ) , .Y ( n1388 ) ) ;
AOI22XL U1973 ( .A0 ( n1680 ) , .A1 ( \shadow_weights[12][20] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][20] ) , .Y ( n1327 ) ) ;
AOI22XL U1974 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][20] ) , 
    .B0 ( n1661 ) , .B1 ( \shadow_weights[1][20] ) , .Y ( n1329_CDR2 ) ) ;
NAND2XL ctmTdsLR_3_2194 ( .A ( tmp_net240 ) , .B ( tmp_net480 ) , 
    .Y ( tmp_net481 ) ) ;
BUFX8 ZCTSBUF_259_1383 ( .A ( net1676 ) , .Y ( ZCTSNET_381 ) ) ;
AOI21XL ctmTdsLR_1_2195 ( .A0 ( n1792 ) , .A1 ( n1791 ) , .B0 ( tmp_net483 ) , 
    .Y ( n1796 ) ) ;
NOR2XL U1979 ( .A ( HFSNET_144 ) , .B ( temp_acc[20] ) , .Y ( n1524 ) ) ;
AOI22XL U1980 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][21] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][21] ) , 
    .Y ( n1342_CDR2 ) ) ;
AOI22XL U1981 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][21] ) , 
    .B0 ( n1680 ) , .B1 ( \shadow_weights[12][21] ) , .Y ( n1341_CDR2 ) ) ;
NAND2XL U1982 ( .A ( n1342_CDR2 ) , .B ( n1341_CDR2 ) , .Y ( n1349_CDR1 ) ) ;
AOI22XL U1983 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][21] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][21] ) , 
    .Y ( n1343_CDR2 ) ) ;
NAND2XL ctmTdsLR_2_2196 ( .A ( tmp_net482 ) , .B ( n1789 ) , .Y ( n1791 ) ) ;
INVXL ctmTdsLR_3_2197 ( .A ( n1788 ) , .Y ( tmp_net482 ) ) ;
AOI222XL ctmTdsLR_2_1868 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][13] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][13] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][13] ) , .Y ( tmp_net275 ) ) ;
NOR2XL U1988 ( .A ( HFSNET_152 ) , .B ( temp_acc[21] ) , .Y ( n1508 ) ) ;
NOR2XL U1989 ( .A ( n1524 ) , .B ( n1508 ) , .Y ( n1569 ) ) ;
AOI22XL U1990 ( .A0 ( n1680 ) , .A1 ( \shadow_weights[12][22] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][22] ) , .Y ( n1356_CDR1 ) ) ;
AOI22XL U1991 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( \shadow_weights[4][22] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][22] ) , 
    .Y ( n1355_CDR2 ) ) ;
NOR2XL ctmTdsLR_4_2198 ( .A ( n1792 ) , .B ( n1791 ) , .Y ( tmp_net483 ) ) ;
AOI22XL U1993 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][22] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][22] ) , .Y ( n1357_CDR1 ) ) ;
AOI22XL ctmTdsLR_3_1869 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][13] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][13] ) , .Y ( tmp_net276 ) ) ;
AOI22XL ctmTdsLR_1_786 ( .A0 ( n1687 ) , .A1 ( \shadow_weights[2][26] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][26] ) , .Y ( tmp_net109 ) ) ;
OR2XL U1998 ( .A ( HFSNET_155 ) , .B ( temp_acc[22] ) , .Y ( n1572 ) ) ;
NAND2XL U1999 ( .A ( n1569 ) , .B ( n1572 ) , .Y ( n1394 ) ) ;
NOR2XL U2000 ( .A ( n1503 ) , .B ( n1394 ) , .Y ( n1457 ) ) ;
BUFXL ZBUF_2_inst_1050 ( .A ( tmp_net81 ) , .Y ( ZBUF_2_26 ) ) ;
NAND2XL U2003 ( .A ( ZBUF_24_23 ) , .B ( temp_acc[16] ) , .Y ( n1447 ) ) ;
NAND2XL U2004 ( .A ( ZBUF_17_23 ) , .B ( temp_acc[18] ) , .Y ( n1514 ) ) ;
OAI21XL U2005 ( .A0 ( n1517 ) , .A1 ( n1514 ) , .B0 ( n1518 ) , .Y ( n1387 ) ) ;
AOI21XL U2006 ( .A0 ( n1388 ) , .A1 ( n1498 ) , .B0 ( n1387 ) , .Y ( n1504 ) ) ;
NAND2XL U2007 ( .A ( HFSNET_144 ) , .B ( temp_acc[20] ) , .Y ( n1525 ) ) ;
AOI222X1 ctmTdsLR_2_787 ( .A0 ( n1319 ) , .A1 ( \shadow_weights[13][26] ) , 
    .B0 ( n1686 ) , .B1 ( \shadow_weights[6][26] ) , .C0 ( ZBUF_3430_2 ) , 
    .C1 ( \shadow_weights[0][26] ) , .Y ( tmp_net110 ) ) ;
BUFX1 ZBUF_2_inst_1051 ( .A ( tmp_net75 ) , .Y ( ZBUF_2_27 ) ) ;
NAND2XL U2010 ( .A ( n315 ) , .B ( gre_a_INV_6897_53 ) , .Y ( N1754 ) ) ;
INVXL U2013 ( .A ( n1442 ) , .Y ( n1489 ) ) ;
NAND2XL U2014 ( .A ( n1444 ) , .B ( n1443 ) , .Y ( n1445 ) ) ;
AOI22XL U2015 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][25] ) , 
    .B0 ( n1671 ) , .B1 ( \shadow_weights[18][25] ) , .Y ( n1471_CDR1 ) ) ;
AOI22XL U2016 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][25] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][25] ) , .Y ( n1470_CDR1 ) ) ;
OAI21XL U2017 ( .A0 ( n1489 ) , .A1 ( n1488 ) , .B0 ( n1487 ) , .Y ( n1560 ) ) ;
NAND2XL U2018 ( .A ( n1559 ) , .B ( n1557 ) , .Y ( n1491 ) ) ;
NAND2XL U2019 ( .A ( n1551 ) , .B ( n1549 ) , .Y ( n1496 ) ) ;
AOI21XL U2020 ( .A0 ( HFSNET_275 ) , .A1 ( n1499 ) , .B0 ( n1498 ) , 
    .Y ( n1516 ) ) ;
AOI21XL U2021 ( .A0 ( HFSNET_275 ) , .A1 ( n1506 ) , .B0 ( n1505 ) , 
    .Y ( n1523 ) ) ;
OAI21XL U2022 ( .A0 ( n1523 ) , .A1 ( n1524 ) , .B0 ( n1525 ) , .Y ( n1512 ) ) ;
OAI21XL U2023 ( .A0 ( n1516 ) , .A1 ( n1515 ) , .B0 ( n1514 ) , .Y ( n1521 ) ) ;
INVXL U2024 ( .A ( n1523 ) , .Y ( n1570 ) ) ;
OAI21XL U2025 ( .A0 ( n1531 ) , .A1 ( n1530 ) , .B0 ( n1529 ) , .Y ( n1587 ) ) ;
AOI22XL U2026 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][26] ) , 
    .B0 ( n1673 ) , .B1 ( \shadow_weights[17][26] ) , .Y ( n1536_CDR1 ) ) ;
AOI22XL U2027 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][26] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][26] ) , .Y ( n1535_CDR2 ) ) ;
NOR2XL U2028 ( .A ( n2200 ) , .B ( accumulator[33] ) , .Y ( n1577 ) ) ;
XOR2X1 U2031 ( .A ( n1578 ) , .B ( n1554 ) , .Y ( n1556 ) ) ;
OAI21XL U2034 ( .A0 ( n1578 ) , .A1 ( n1577 ) , .B0 ( n1576 ) , .Y ( n1582 ) ) ;
NAND2XL ctmTdsLR_2_2208 ( .A ( tmp_net488 ) , .B ( n1606 ) , .Y ( n1604 ) ) ;
NAND2XL U2039 ( .A ( n1583 ) , .B ( HFSNET_325 ) , .Y ( n929 ) ) ;
AOI21XL U2040 ( .A0 ( n1587 ) , .A1 ( n1586 ) , .B0 ( n1585 ) , .Y ( n1608 ) ) ;
AOI22X1 U2041 ( .A0 ( n1662 ) , .A1 ( \shadow_weights[9][27] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][27] ) , .Y ( n1589_CDR2 ) ) ;
AOI22XL U2042 ( .A0 ( n1679 ) , .A1 ( \shadow_weights[14][27] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][27] ) , 
    .Y ( n1588_CDR2 ) ) ;
INVXL ctmTdsLR_3_2209 ( .A ( n1607 ) , .Y ( tmp_net488 ) ) ;
AOI22XL U2044 ( .A0 ( n1663 ) , .A1 ( \shadow_weights[11][27] ) , 
    .B0 ( HFSNET_322 ) , .B1 ( \shadow_weights[7][27] ) , .Y ( n1590_CDR2 ) ) ;
AOI22XL U2045 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][27] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][27] ) , .Y ( n1593_CDR2 ) ) ;
AOI22XL U2046 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][27] ) , 
    .B0 ( n1671 ) , .B1 ( \shadow_weights[18][27] ) , .Y ( n1592_CDR1 ) ) ;
AOI22XL U2047 ( .A0 ( n1670 ) , .A1 ( \shadow_weights[16][27] ) , 
    .B0 ( n1672 ) , .B1 ( \shadow_weights[19][27] ) , .Y ( n1591_CDR1 ) ) ;
BUFX12 ZCTSBUF_255_1386 ( .A ( net1691 ) , .Y ( ZCTSNET_384 ) ) ;
NAND2XL ctmTdsLR_2_2221 ( .A ( n1466 ) , .B ( n1414 ) , .Y ( tmp_net494 ) ) ;
OAI21XL U2050 ( .A0 ( n1608 ) , .A1 ( n1607 ) , .B0 ( n1606 ) , .Y ( n1633 ) ) ;
NOR2XL ctmTdsLR_4_2210 ( .A ( n1608 ) , .B ( n1604 ) , .Y ( tmp_net489 ) ) ;
AOI22X1 U2052 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][28] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( \shadow_weights[3][28] ) , 
    .Y ( n1610_CDR2 ) ) ;
AOI22XL U2053 ( .A0 ( n1680 ) , .A1 ( \shadow_weights[12][28] ) , 
    .B0 ( n1677 ) , .B1 ( \shadow_weights[5][28] ) , .Y ( n1609_CDR2 ) ) ;
NAND3XL ctmTdsLR_1_2211 ( .A ( ropt_net_530 ) , .B ( tmp_net182 ) , 
    .C ( tmp_net183 ) , .Y ( ZBUF_17_24 ) ) ;
AOI22XL U2055 ( .A0 ( n1663 ) , .A1 ( \shadow_weights[11][28] ) , 
    .B0 ( n1662 ) , .B1 ( \shadow_weights[9][28] ) , .Y ( n1611_CDR2 ) ) ;
CLKBUFX3 ZBUF_754_inst_1055 ( .A ( n71 ) , .Y ( ZBUF_754_28 ) ) ;
CLKBUFX8 ZCTSBUF_255_1387 ( .A ( net1696 ) , .Y ( ZCTSNET_385 ) ) ;
BUFX8 ZCTSBUF_251_1388 ( .A ( net1701 ) , .Y ( ZCTSNET_386 ) ) ;
NAND3XL ctmTdsLR_1_1898 ( .A ( tmp_net297 ) , .B ( tmp_net298 ) , 
    .C ( tmp_net299 ) , .Y ( HFSNET_91 ) ) ;
AOI31XL U2061 ( .A0 ( n1629 ) , .A1 ( n1628 ) , .A2 ( n1627 ) , .B0 ( n316 ) , 
    .Y ( n1656 ) ) ;
INVXL U2062 ( .A ( n1656 ) , .Y ( N1602 ) ) ;
OAI21XL ctmTdsLR_1_2212 ( .A0 ( n1521 ) , .A1 ( n1520 ) , .B0 ( tmp_net491 ) , 
    .Y ( n1522 ) ) ;
AOI22X1 U2065 ( .A0 ( n1680 ) , .A1 ( \shadow_weights[12][29] ) , 
    .B0 ( gre_a_INV_6696_54 ) , .B1 ( \shadow_weights[4][29] ) , 
    .Y ( n1635_CDR2 ) ) ;
AOI22X1 U2066 ( .A0 ( n1677 ) , .A1 ( \shadow_weights[5][29] ) , 
    .B0 ( n1679 ) , .B1 ( \shadow_weights[14][29] ) , .Y ( n1634_CDR2 ) ) ;
NAND2XL ctmTdsLR_2_2213 ( .A ( tmp_net490 ) , .B ( n1518 ) , .Y ( n1520 ) ) ;
AOI22X1 U2068 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][29] ) , 
    .B0 ( n1662 ) , .B1 ( \shadow_weights[9][29] ) , .Y ( n1636_CDR1 ) ) ;
INVXL ctmTdsLR_3_2214 ( .A ( n1517 ) , .Y ( tmp_net490 ) ) ;
BUFXL ZBUF_2_inst_1061 ( .A ( tmp_net36 ) , .Y ( ZBUF_2_30 ) ) ;
CLKBUFX8 ZCTSBUF_255_1390 ( .A ( n2326 ) , .Y ( ZCTSNET_388 ) ) ;
BUFX16 ZCTSBUF_1453_1391 ( .A ( ZCTSNET_394 ) , .Y ( ZCTSNET_389 ) ) ;
BUFX12 ZCTSBUF_850_1392 ( .A ( ZCTSNET_394 ) , .Y ( ZCTSNET_390 ) ) ;
NAND3XL U2079 ( .A ( n640 ) , .B ( n315 ) , .C ( n1655 ) , .Y ( N1488 ) ) ;
NOR2XL U2080 ( .A ( n1659 ) , .B ( n2161 ) , .Y ( n1985 ) ) ;
NOR2XL U2081 ( .A ( HFSNET_327 ) , .B ( n1985 ) , .Y ( n1697 ) ) ;
AOI22XL U2083 ( .A0 ( gre_a_INV_6696_54 ) , .A1 ( protected_sar_code[4] ) , 
    .B0 ( n1679 ) , .B1 ( protected_sar_code[14] ) , .Y ( n1665_CDR2 ) ) ;
AOI22XL U2084 ( .A0 ( n1680 ) , .A1 ( protected_sar_code[12] ) , 
    .B0 ( n1663 ) , .B1 ( protected_sar_code[11] ) , .Y ( n1664_CDR2 ) ) ;
OAI211XL U2085 ( .A0 ( n1210 ) , .A1 ( n2180 ) , .B0 ( n1665_CDR2 ) , 
    .C0 ( n1664_CDR2 ) , .Y ( n1685_CDR2 ) ) ;
AOI22XL U2086 ( .A0 ( n1670 ) , .A1 ( protected_sar_code[16] ) , 
    .B0 ( n1668 ) , .B1 ( protected_sar_code[10] ) , .Y ( n1676_CDR2 ) ) ;
AOI22XL U2087 ( .A0 ( n1672 ) , .A1 ( protected_sar_code[19] ) , 
    .B0 ( n1669 ) , .B1 ( protected_sar_code[8] ) , .Y ( n1674_CDR2 ) ) ;
AOI22XL U2088 ( .A0 ( n1661 ) , .A1 ( protected_sar_code[1] ) , 
    .B0 ( gre_a_INV_4409_54 ) , .B1 ( protected_sar_code[3] ) , 
    .Y ( n1682_CDR2 ) ) ;
AOI22XL U2089 ( .A0 ( n1662 ) , .A1 ( protected_sar_code[9] ) , 
    .B0 ( n1319 ) , .B1 ( protected_sar_code[13] ) , .Y ( n1681_CDR2 ) ) ;
NOR3XL U2090 ( .A ( n1685_CDR2 ) , .B ( n1684_CDR2 ) , .C ( n1683_CDR2 ) , 
    .Y ( n1692_CDR2 ) ) ;
AOI21XL U2091 ( .A0 ( n1697 ) , .A1 ( n1694 ) , .B0 ( n1696 ) , .Y ( n1695 ) ) ;
INVXL U2092 ( .A ( n1695 ) , .Y ( n2328 ) ) ;
OAI21XL U2095 ( .A0 ( n1702 ) , .A1 ( n1701 ) , .B0 ( HFSNET_329 ) , 
    .Y ( n969 ) ) ;
NAND2XL ctmTdsLR_4_2215 ( .A ( n1521 ) , .B ( n1520 ) , .Y ( tmp_net491 ) ) ;
OAI21XL U2097 ( .A0 ( n1711 ) , .A1 ( HFSNET_324 ) , .B0 ( n1710 ) , 
    .Y ( n896 ) ) ;
OAI21XL U2098 ( .A0 ( n1719 ) , .A1 ( HFSNET_324 ) , .B0 ( n1718 ) , 
    .Y ( n897 ) ) ;
OAI21XL U2099 ( .A0 ( n1728 ) , .A1 ( HFSNET_324 ) , .B0 ( n1727 ) , 
    .Y ( n898 ) ) ;
INVXL U2100 ( .A ( n1729 ) , .Y ( n1744 ) ) ;
OAI21XL U2101 ( .A0 ( n1744 ) , .A1 ( n1740 ) , .B0 ( n1741 ) , .Y ( n1734 ) ) ;
OAI21XL U2102 ( .A0 ( n1739 ) , .A1 ( HFSNET_324 ) , .B0 ( n1738 ) , 
    .Y ( n899 ) ) ;
OAI21XL U2103 ( .A0 ( n1748 ) , .A1 ( HFSNET_324 ) , .B0 ( n1747 ) , 
    .Y ( n900 ) ) ;
INVXL U2104 ( .A ( n1749 ) , .Y ( n1774 ) ) ;
OAI21XL U2105 ( .A0 ( n1759 ) , .A1 ( HFSNET_324 ) , .B0 ( n1758 ) , 
    .Y ( n901 ) ) ;
OAI21XL U2106 ( .A0 ( n1770 ) , .A1 ( HFSNET_324 ) , .B0 ( n1769 ) , 
    .Y ( n902 ) ) ;
OAI21XL U2107 ( .A0 ( n1778 ) , .A1 ( HFSNET_324 ) , .B0 ( n1777 ) , 
    .Y ( n903 ) ) ;
INVXL U2108 ( .A ( n1779 ) , .Y ( n1852 ) ) ;
INVXL U2109 ( .A ( n1807 ) , .Y ( n1821 ) ) ;
OAI21XL U2110 ( .A0 ( n1796 ) , .A1 ( HFSNET_324 ) , .B0 ( n1795 ) , 
    .Y ( n904 ) ) ;
OAI21XL U2111 ( .A0 ( n1804 ) , .A1 ( HFSNET_324 ) , .B0 ( n1803 ) , 
    .Y ( n905 ) ) ;
OAI21XL U2112 ( .A0 ( n1817 ) , .A1 ( HFSNET_324 ) , .B0 ( n1816 ) , 
    .Y ( n906 ) ) ;
OAI21XL U2113 ( .A0 ( n1826 ) , .A1 ( HFSNET_324 ) , .B0 ( n1825 ) , 
    .Y ( n907 ) ) ;
OAI21XL U2115 ( .A0 ( n1838 ) , .A1 ( HFSNET_324 ) , .B0 ( n1837 ) , 
    .Y ( n908 ) ) ;
OAI21XL U2116 ( .A0 ( n1852 ) , .A1 ( n1848 ) , .B0 ( n1849 ) , .Y ( n1843 ) ) ;
OAI21XL U2117 ( .A0 ( n1847 ) , .A1 ( HFSNET_324 ) , .B0 ( n1846 ) , 
    .Y ( n909 ) ) ;
OAI21XL U2118 ( .A0 ( n1856 ) , .A1 ( HFSNET_324 ) , .B0 ( n1855 ) , 
    .Y ( n910 ) ) ;
INVXL U2119 ( .A ( n1857 ) , .Y ( n1893 ) ) ;
AOI21XL U2120 ( .A0 ( n1893 ) , .A1 ( n1859 ) , .B0 ( n1858 ) , .Y ( n1873 ) ) ;
OAI21XL U2121 ( .A0 ( n1873 ) , .A1 ( n1869 ) , .B0 ( n1870 ) , .Y ( n1864 ) ) ;
OAI21X1 U2122 ( .A0 ( n1868 ) , .A1 ( HFSNET_324 ) , .B0 ( n1867 ) , 
    .Y ( n911 ) ) ;
OAI21X1 U2123 ( .A0 ( n1878 ) , .A1 ( HFSNET_324 ) , .B0 ( n1877 ) , 
    .Y ( n912 ) ) ;
OAI21X1 U2124 ( .A0 ( n1889 ) , .A1 ( HFSNET_324 ) , .B0 ( n1888 ) , 
    .Y ( n913 ) ) ;
OAI21X1 U2125 ( .A0 ( n1897 ) , .A1 ( HFSNET_324 ) , .B0 ( n1896 ) , 
    .Y ( n914 ) ) ;
OAI21XL U2126 ( .A0 ( n1912 ) , .A1 ( n1908 ) , .B0 ( n1909 ) , .Y ( n1903 ) ) ;
OAI21X1 U2127 ( .A0 ( n1907 ) , .A1 ( HFSNET_324 ) , .B0 ( n1906 ) , 
    .Y ( n915 ) ) ;
OAI21X1 U2128 ( .A0 ( n1916 ) , .A1 ( HFSNET_324 ) , .B0 ( n1915 ) , 
    .Y ( n916 ) ) ;
NAND2XL U2129 ( .A ( n1919 ) , .B ( n1920 ) , .Y ( n1921 ) ) ;
OAI21XL U2130 ( .A0 ( n1926 ) , .A1 ( HFSNET_324 ) , .B0 ( n1925 ) , 
    .Y ( n917 ) ) ;
NAND2XL U2131 ( .A ( n1928 ) , .B ( n1927 ) , .Y ( n1929 ) ) ;
NOR2XL U2132 ( .A ( n1931 ) , .B ( ZBUF_1431_14 ) , .Y ( n1932 ) ) ;
OAI21XL U2133 ( .A0 ( n1934 ) , .A1 ( HFSNET_324 ) , .B0 ( n1933 ) , 
    .Y ( n918 ) ) ;
NAND2XL U2134 ( .A ( n1936 ) , .B ( n1935 ) , .Y ( n1937 ) ) ;
NOR2XL U2135 ( .A ( n1939 ) , .B ( ZBUF_1431_14 ) , .Y ( n1940 ) ) ;
OAI21XL U2136 ( .A0 ( n1943 ) , .A1 ( HFSNET_324 ) , .B0 ( n1942 ) , 
    .Y ( n919 ) ) ;
NOR2XL U2139 ( .A ( n1949 ) , .B ( ZBUF_1431_14 ) , .Y ( n1950 ) ) ;
OAI21XL U2140 ( .A0 ( n1952 ) , .A1 ( HFSNET_324 ) , .B0 ( n1951 ) , 
    .Y ( n920 ) ) ;
NAND2XL U2141 ( .A ( n1954 ) , .B ( n1953 ) , .Y ( n1956 ) ) ;
NOR2XL U2142 ( .A ( n1957 ) , .B ( ZBUF_1431_14 ) , .Y ( n1958 ) ) ;
OAI21XL U2143 ( .A0 ( n1960 ) , .A1 ( HFSNET_324 ) , .B0 ( n1959 ) , 
    .Y ( n921 ) ) ;
XOR2XL U2146 ( .A ( n1964 ) , .B ( n1969 ) , .Y ( n1968 ) ) ;
NOR2XL U2147 ( .A ( n1965 ) , .B ( ZBUF_1431_14 ) , .Y ( n1966 ) ) ;
OAI21X1 U2148 ( .A0 ( n1968 ) , .A1 ( HFSNET_324 ) , .B0 ( n1967 ) , 
    .Y ( n922 ) ) ;
NOR2XL U2151 ( .A ( ZBUF_1431_14 ) , .B ( n1971 ) , .Y ( n1973 ) ) ;
INVXL U2154 ( .A ( n1978 ) , .Y ( n1981 ) ) ;
NOR2XL U2155 ( .A ( HFSNET_177 ) , .B ( n322 ) , .Y ( n1980 ) ) ;
OAI21XL U2156 ( .A0 ( n1981 ) , .A1 ( avg_cnt[4] ) , .B0 ( n1980 ) , 
    .Y ( n963 ) ) ;
AOI21XL U2157 ( .A0 ( wait_cnt[2] ) , .A1 ( n1984 ) , .B0 ( n1982 ) , 
    .Y ( n1983 ) ) ;
OAI21XL U2158 ( .A0 ( n1984 ) , .A1 ( wait_cnt[2] ) , .B0 ( n1983 ) , 
    .Y ( n925 ) ) ;
OAI21XL U2159 ( .A0 ( n2158 ) , .A1 ( n729 ) , .B0 ( n315 ) , .Y ( N1786 ) ) ;
OAI21XL U2160 ( .A0 ( n2179 ) , .A1 ( n729 ) , .B0 ( n315 ) , .Y ( N1787 ) ) ;
OAI21X1 U2161 ( .A0 ( n2068 ) , .A1 ( n1989 ) , .B0 ( n315 ) , .Y ( N1723 ) ) ;
AOI21XL U2162 ( .A0 ( n65 ) , .A1 ( n1987 ) , .B0 ( n815 ) , .Y ( n1986 ) ) ;
OAI21XL U2163 ( .A0 ( n65 ) , .A1 ( n1987 ) , .B0 ( n1986 ) , .Y ( n827 ) ) ;
NAND3XL U2165 ( .A ( n2033 ) , .B ( n1993 ) , .C ( n2158 ) , .Y ( n2021 ) ) ;
INVXL U2167 ( .A ( n2073 ) , .Y ( n2005 ) ) ;
NAND2XL U2168 ( .A ( n2005 ) , .B ( n1996 ) , .Y ( n1997 ) ) ;
NAND3XL U2169 ( .A ( n1996 ) , .B ( n2163 ) , .C ( target_bit[2] ) , 
    .Y ( n1998 ) ) ;
NAND2XL U2171 ( .A ( n2005 ) , .B ( n2009 ) , .Y ( n2013 ) ) ;
NAND2XL U2172 ( .A ( n2009 ) , .B ( n2006 ) , .Y ( n2014 ) ) ;
INVXL U2173 ( .A ( n2033 ) , .Y ( n2025 ) ) ;
AOI2BB1XL U2174 ( .A0N ( n2179 ) , .A1N ( n2031 ) , .B0 ( n2047 ) , 
    .Y ( n2041 ) ) ;
NAND2XL U2175 ( .A ( n2073 ) , .B ( n2041 ) , .Y ( n2044 ) ) ;
AOI22XL U2176 ( .A0 ( n2165 ) , .A1 ( n2045 ) , .B0 ( n2057 ) , 
    .B1 ( n2167 ) , .Y ( n2040_CDR1 ) ) ;
NAND2XL U2177 ( .A ( n2022 ) , .B ( n2021 ) , .Y ( n2051 ) ) ;
AOI22XL U2178 ( .A0 ( n2054 ) , .A1 ( n2187 ) , .B0 ( n2050 ) , 
    .B1 ( n2164 ) , .Y ( n2023_CDR2 ) ) ;
OAI21XL U2179 ( .A0 ( n2053 ) , .A1 ( protected_sar_code[13] ) , 
    .B0 ( n2023_CDR2 ) , .Y ( n2028_CDR2 ) ) ;
INVXL U2180 ( .A ( n2050 ) , .Y ( n2029 ) ) ;
OAI21XL U2181 ( .A0 ( ZBUF_786_30 ) , .A1 ( n2025 ) , .B0 ( n2029 ) , 
    .Y ( n2055 ) ) ;
AOI22XL U2182 ( .A0 ( n2189 ) , .A1 ( n2051 ) , .B0 ( n2056 ) , 
    .B1 ( n2184 ) , .Y ( n2026_CDR2 ) ) ;
OAI2BB1XL U2183 ( .A0N ( n57 ) , .A1N ( n2166 ) , .B0 ( n2026_CDR2 ) , 
    .Y ( n2027_CDR2 ) ) ;
AOI211XL U2184 ( .A0 ( n2047 ) , .A1 ( HFSNET_269 ) , .B0 ( n2028_CDR2 ) , 
    .C0 ( n2027_CDR2 ) , .Y ( n2039_CDR2 ) ) ;
NAND2XL U2185 ( .A ( ZBUF_786_30 ) , .B ( n2029 ) , .Y ( n2057 ) ) ;
NAND2XL U2186 ( .A ( n2049 ) , .B ( n2031 ) , .Y ( n2058 ) ) ;
AOI22XL U2187 ( .A0 ( n2186 ) , .A1 ( n2058 ) , .B0 ( target_bit[4] ) , 
    .B1 ( ropt_net_531 ) , .Y ( n2038_CDR2 ) ) ;
NOR2XL U2188 ( .A ( n2032 ) , .B ( n2047 ) , .Y ( n2042 ) ) ;
OAI22XL U2189 ( .A0 ( protected_sar_code[6] ) , .A1 ( n2042 ) , 
    .B0 ( protected_sar_code[5] ) , .B1 ( n2041 ) , .Y ( n2036 ) ) ;
AOI21XL U2190 ( .A0 ( n2034 ) , .A1 ( n2033 ) , .B0 ( n2057 ) , .Y ( n2046 ) ) ;
OAI22XL U2191 ( .A0 ( n2049 ) , .A1 ( protected_sar_code[3] ) , 
    .B0 ( protected_sar_code[8] ) , .B1 ( n2046 ) , .Y ( n2035 ) ) ;
AOI211XL U2192 ( .A0 ( n2190 ) , .A1 ( n2044 ) , .B0 ( n2036 ) , 
    .C0 ( n2035 ) , .Y ( n2037_CDR1 ) ) ;
NAND4XL U2193 ( .A ( n2037_CDR1 ) , .B ( n2039_CDR2 ) , .C ( n2040_CDR1 ) , 
    .D ( n2038_CDR2 ) , .Y ( n2070 ) ) ;
OAI22XL U2194 ( .A0 ( n2168 ) , .A1 ( n2042 ) , .B0 ( n2191 ) , 
    .B1 ( n2041 ) , .Y ( n2043 ) ) ;
INVXL U2195 ( .A ( n2043 ) , .Y ( n2067 ) ) ;
AOI22XL U2196 ( .A0 ( protected_sar_code[10] ) , .A1 ( n2055 ) , 
    .B0 ( protected_sar_code[16] ) , .B1 ( n2051 ) , .Y ( n2066_CDR2 ) ) ;
AOI22XL ctmTdsLR_1_790 ( .A0 ( HFSNET_322 ) , .A1 ( \shadow_weights[7][19] ) , 
    .B0 ( n1663 ) , .B1 ( \shadow_weights[11][19] ) , .Y ( tmp_net112 ) ) ;
AOI22XL U2199 ( .A0 ( protected_sar_code[2] ) , .A1 ( n2045 ) , 
    .B0 ( protected_sar_code[1] ) , .B1 ( n2058 ) , .Y ( n2052_CDR2 ) ) ;
OAI21XL U2200 ( .A0 ( n2053 ) , .A1 ( n2188 ) , .B0 ( n2052_CDR2 ) , 
    .Y ( n2063_CDR2 ) ) ;
AOI22XL U2201 ( .A0 ( protected_sar_code[9] ) , .A1 ( n2057 ) , 
    .B0 ( protected_sar_code[12] ) , .B1 ( n2054 ) , .Y ( n2061_CDR2 ) ) ;
AOI22XL U2202 ( .A0 ( protected_sar_code[14] ) , .A1 ( n2056 ) , 
    .B0 ( target_bit[4] ) , .B1 ( protected_sar_code[15] ) , 
    .Y ( n2060_CDR2 ) ) ;
AOI22XL U2203 ( .A0 ( protected_sar_code[11] ) , .A1 ( n2050 ) , 
    .B0 ( protected_sar_code[4] ) , .B1 ( n2044 ) , .Y ( n2059_CDR2 ) ) ;
NAND3XL U2204 ( .A ( n2061_CDR2 ) , .B ( n2060_CDR2 ) , .C ( n2059_CDR2 ) , 
    .Y ( n2062_CDR2 ) ) ;
NOR3XL U2205 ( .A ( n2064 ) , .B ( n2063_CDR2 ) , .C ( n2062_CDR2 ) , 
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
AOI21XL U2233 ( .A0 ( n2136 ) , .A1 ( n2134 ) , .B0 ( n316 ) , .Y ( n2135 ) ) ;
OAI21XL U2234 ( .A0 ( protected_sar_code[19] ) , .A1 ( n2136 ) , 
    .B0 ( n2135 ) , .Y ( n754 ) ) ;
INVXL HFSINV_4_490 ( .A ( N1842 ) , .Y ( HFSNET_240 ) ) ;
INVXL U2236 ( .A ( N1841 ) , .Y ( n2138 ) ) ;
INVXL HFSINV_11_514 ( .A ( ZBUF_17_14 ) , .Y ( HFSNET_260 ) ) ;
INVXL HFSINV_45_508 ( .A ( N1839 ) , .Y ( HFSNET_255 ) ) ;
NAND3XL ctmTdsLR_2_791 ( .A ( n1303_CDR2 ) , .B ( n1314_CDR1 ) , 
    .C ( tmp_net112 ) , .Y ( tmp_net114 ) ) ;
INVXL HFSINV_11_505 ( .A ( N1837 ) , .Y ( HFSNET_253 ) ) ;
INVXL HFSINV_11_479 ( .A ( N1836 ) , .Y ( HFSNET_231 ) ) ;
OAI221XL U2242 ( .A0 ( N1836 ) , .A1 ( ZBUF_24_3 ) , .B0 ( HFSNET_231 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n711 ) ) ;
AOI22XL ctmTdsLR_2_1899 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][24] ) , 
    .B0 ( n1671 ) , .B1 ( \shadow_weights[18][24] ) , .Y ( tmp_net297 ) ) ;
OAI221XL U2244 ( .A0 ( N1835 ) , .A1 ( overrange_bits[7] ) , 
    .B0 ( HFSNET_251 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n710 ) ) ;
INVXL HFSINV_4_492 ( .A ( N1834 ) , .Y ( HFSNET_242 ) ) ;
OAI221XL U2246 ( .A0 ( N1834 ) , .A1 ( overrange_bits[8] ) , 
    .B0 ( HFSNET_242 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n709 ) ) ;
INVXL HFSINV_11_476 ( .A ( N1833 ) , .Y ( HFSNET_229 ) ) ;
INVXL HFSINV_4_517 ( .A ( N1832 ) , .Y ( HFSNET_262 ) ) ;
OAI221XL U2249 ( .A0 ( N1832 ) , .A1 ( overrange_bits[10] ) , 
    .B0 ( HFSNET_262 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n707 ) ) ;
INVXL HFSINV_4_511 ( .A ( N1831 ) , .Y ( HFSNET_258 ) ) ;
OAI221XL U2251 ( .A0 ( N1831 ) , .A1 ( ZBUF_24_0 ) , .B0 ( HFSNET_258 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n706 ) ) ;
INVXL HFSINV_4_488 ( .A ( N1830 ) , .Y ( HFSNET_238 ) ) ;
OAI221XL U2253 ( .A0 ( N1830 ) , .A1 ( ZBUF_24_2 ) , .B0 ( HFSNET_238 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n705 ) ) ;
NAND2XL ctmTdsLR_4_793 ( .A ( n1661 ) , .B ( \shadow_weights[1][19] ) , 
    .Y ( tmp_net113 ) ) ;
OAI221XL U2255 ( .A0 ( HFSNET_250 ) , .A1 ( ZBUF_24_1 ) , .B0 ( N1829 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n704 ) ) ;
NAND3XL ctmTdsLR_5_794 ( .A ( tmp_net113 ) , .B ( tmp_net286 ) , 
    .C ( tmp_net287 ) , .Y ( tmp_net116 ) ) ;
OAI221XL U2257 ( .A0 ( N1828 ) , .A1 ( overrange_bits[14] ) , 
    .B0 ( HFSNET_235 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n703 ) ) ;
INVXL HFSINV_4_495 ( .A ( N1827 ) , .Y ( HFSNET_245 ) ) ;
OAI221XL U2259 ( .A0 ( N1827 ) , .A1 ( overrange_bits[15] ) , 
    .B0 ( HFSNET_245 ) , .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n702 ) ) ;
INVXL U2260 ( .A ( N1826 ) , .Y ( n2153 ) ) ;
OAI221XL U2261 ( .A0 ( N1826 ) , .A1 ( overrange_bits[16] ) , .B0 ( n2153 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n701 ) ) ;
INVXL U2262 ( .A ( N1825 ) , .Y ( n2154 ) ) ;
OAI221XL U2263 ( .A0 ( N1825 ) , .A1 ( overrange_bits[17] ) , .B0 ( n2154 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n700 ) ) ;
INVXL U2264 ( .A ( N1824 ) , .Y ( n2155 ) ) ;
OAI221XL U2265 ( .A0 ( N1824 ) , .A1 ( overrange_bits[18] ) , .B0 ( n2155 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n699 ) ) ;
OAI221XL U2266 ( .A0 ( N1823 ) , .A1 ( overrange_bits[19] ) , .B0 ( n823 ) , 
    .B1 ( n2157 ) , .C0 ( n640 ) , .Y ( n697 ) ) ;
INVXL U15 ( .A ( n639 ) , .Y ( n1990 ) ) ;
INVXL U1057 ( .A ( n617 ) , .Y ( n629 ) ) ;
NAND2XL U1731 ( .A ( n1659 ) , .B ( n2161 ) , .Y ( n631 ) ) ;
OAI2BB1XL U22 ( .A0N ( n2343 ) , .A1N ( n292 ) , .B0 ( n1975 ) , .Y ( n923 ) ) ;
AOI211XL U123 ( .A0 ( n726 ) , .A1 ( n725 ) , .B0 ( n735 ) , .C0 ( n724 ) , 
    .Y ( n819 ) ) ;
NOR2BX1 U128 ( .AN ( n1698 ) , .B ( n2161 ) , .Y ( n1701 ) ) ;
NAND2XL U129 ( .A ( calc_cnt[3] ) , .B ( n558 ) , .Y ( n1698 ) ) ;
OAI21XL U199 ( .A0 ( start_calib ) , .A1 ( n722 ) , .B0 ( n823 ) , 
    .Y ( n735 ) ) ;
NAND2XL U256 ( .A ( temp_acc[0] ) , .B ( ZBUF_187_13 ) , .Y ( n738 ) ) ;
OAI21XL U259 ( .A0 ( \shadow_weights[18][0] ) , .A1 ( n1971 ) , 
    .B0 ( n1969 ) , .Y ( n2343 ) ) ;
NAND2XL U274 ( .A ( \shadow_weights[18][0] ) , .B ( n1971 ) , .Y ( n1969 ) ) ;
NOR2XL U302 ( .A ( n292 ) , .B ( sar_code[18] ) , .Y ( n2002 ) ) ;
NOR2XL U313 ( .A ( n55 ) , .B ( sar_code[17] ) , .Y ( n2003 ) ) ;
CLKBUFX8 ZCTSBUF_4055_1393 ( .A ( ZCTSNET_394 ) , .Y ( ZCTSNET_391 ) ) ;
XOR2X1 ctmTdsLR_1_2222 ( .A ( tmp_net25 ) , .B ( tmp_net495 ) , .Y ( n1770 ) ) ;
XNOR2XL U320 ( .A ( n293 ) , .B ( \shadow_weights[18][29] ) , .Y ( n290 ) ) ;
NOR2BX1 ctmTdsLR_2_2223 ( .AN ( n1763 ) , .B ( n1762 ) , .Y ( tmp_net495 ) ) ;
NAND2BXL U333 ( .AN ( n1110 ) , .B ( n1112 ) , .Y ( n1078 ) ) ;
NAND2BXL U335 ( .AN ( n1908 ) , .B ( n1909 ) , .Y ( n1911 ) ) ;
AOI21XL ctmTdsLR_1_2228 ( .A0 ( n690 ) , .A1 ( n738 ) , .B0 ( tmp_net499 ) , 
    .Y ( n691 ) ) ;
NAND2XL ctmTdsLR_2_2229 ( .A ( tmp_net498 ) , .B ( n737 ) , .Y ( n690 ) ) ;
NAND2BXL U342 ( .AN ( n1054 ) , .B ( n1052 ) , .Y ( n1019 ) ) ;
CLKBUFX2 ZBUF_2_inst_2253 ( .A ( tmp_net401 ) , .Y ( ZBUF_2_29 ) ) ;
NAND2BXL U349 ( .AN ( n1577 ) , .B ( n1576 ) , .Y ( n1554 ) ) ;
NAND2BXL U350 ( .AN ( n1426 ) , .B ( n1427 ) , .Y ( n1429 ) ) ;
NAND2BXL U352 ( .AN ( n605 ) , .B ( n606 ) , .Y ( n608 ) ) ;
NAND2BXL U353 ( .AN ( n551 ) , .B ( n552 ) , .Y ( n554 ) ) ;
NAND2BXL U356 ( .AN ( n524 ) , .B ( n525 ) , .Y ( n527 ) ) ;
NAND2BXL U358 ( .AN ( n479 ) , .B ( n480 ) , .Y ( n482 ) ) ;
INVXL ctmTdsLR_3_2230 ( .A ( n739 ) , .Y ( tmp_net498 ) ) ;
NOR2XL ctmTdsLR_4_2231 ( .A ( n690 ) , .B ( n738 ) , .Y ( tmp_net499 ) ) ;
AOI21XL ctmTdsLR_1_2232 ( .A0 ( n1461 ) , .A1 ( n1460 ) , .B0 ( tmp_net500 ) , 
    .Y ( n1462 ) ) ;
NOR2XL ctmTdsLR_2_2233 ( .A ( n1461 ) , .B ( n1460 ) , .Y ( tmp_net500 ) ) ;
NAND2BXL U366 ( .AN ( n1436 ) , .B ( n1437 ) , .Y ( n1439 ) ) ;
NAND2BXL U367 ( .AN ( n979 ) , .B ( n977 ) , .Y ( n801 ) ) ;
NOR2XL ctmTdsLR_2_2237 ( .A ( n1574 ) , .B ( n1573 ) , .Y ( tmp_net502 ) ) ;
NAND2BXL U371 ( .AN ( n1113 ) , .B ( n1111 ) , .Y ( n1107 ) ) ;
NAND2BXL U374 ( .AN ( n1136 ) , .B ( n1137 ) , .Y ( n1139 ) ) ;
NAND2BXL U376 ( .AN ( n1508 ) , .B ( n1509 ) , .Y ( n1511 ) ) ;
NAND2BXL U378 ( .AN ( n1561 ) , .B ( n1562 ) , .Y ( n1564 ) ) ;
NAND2BXL U380 ( .AN ( n477 ) , .B ( n476 ) , .Y ( n445 ) ) ;
NAND2BXL U381 ( .AN ( n448 ) , .B ( n447 ) , .Y ( n380 ) ) ;
NAND2BXL U384 ( .AN ( n1808 ) , .B ( n1809 ) , .Y ( n1811 ) ) ;
AOI21XL ctmTdsLR_1_2238 ( .A0 ( n1489 ) , .A1 ( n1445 ) , .B0 ( tmp_net503 ) , 
    .Y ( n1446 ) ) ;
NAND2BXL U390 ( .AN ( n1848 ) , .B ( n1849 ) , .Y ( n1851 ) ) ;
NOR2XL ctmTdsLR_2_2239 ( .A ( n1489 ) , .B ( n1445 ) , .Y ( tmp_net503 ) ) ;
OAI211XL ctmTdsLR_1_2240 ( .A0 ( tmp_net4 ) , .A1 ( n1453 ) , 
    .B0 ( tmp_net505 ) , .C0 ( HFSNET_329 ) , .Y ( n2325 ) ) ;
NAND2BXL U401 ( .AN ( n1524 ) , .B ( n1525 ) , .Y ( n1527 ) ) ;
NAND2BXL U403 ( .AN ( n1740 ) , .B ( n1741 ) , .Y ( n1743 ) ) ;
NAND2BXL U411 ( .AN ( n1961 ) , .B ( n1962 ) , .Y ( n1964 ) ) ;
NAND2BXL U412 ( .AN ( n1081 ) , .B ( n1080 ) , .Y ( n974 ) ) ;
NAND2BXL U432 ( .AN ( n805 ) , .B ( n804 ) , .Y ( n720 ) ) ;
NAND2BXL U447 ( .AN ( n643 ) , .B ( n642 ) , .Y ( n588 ) ) ;
NAND2BXL U451 ( .AN ( n562 ) , .B ( n561 ) , .Y ( n515 ) ) ;
NAND2BXL U452 ( .AN ( n354 ) , .B ( n356 ) , .Y ( n338 ) ) ;
NAND2XL ctmTdsLR_3_2242 ( .A ( tmp_net4 ) , .B ( n1453 ) , .Y ( tmp_net505 ) ) ;
NAND2BXL U471 ( .AN ( n976 ) , .B ( n978 ) , .Y ( n777 ) ) ;
NAND2BXL U480 ( .AN ( n540 ) , .B ( n541 ) , .Y ( n543 ) ) ;
NAND2BXL U507 ( .AN ( n502 ) , .B ( n503 ) , .Y ( n505 ) ) ;
NAND2BXL U509 ( .AN ( n426 ) , .B ( n427 ) , .Y ( n429 ) ) ;
NAND2BXL U513 ( .AN ( n449 ) , .B ( n450 ) , .Y ( n452 ) ) ;
NAND2BXL U534 ( .AN ( n336 ) , .B ( n335 ) , .Y ( n329 ) ) ;
CLKBUFX2 ZBUF_786_inst_2259 ( .A ( n2030 ) , .Y ( ZBUF_786_30 ) ) ;
NAND2BXL U594 ( .AN ( n1944 ) , .B ( n1945 ) , .Y ( n1948 ) ) ;
NAND2BXL U614 ( .AN ( n460 ) , .B ( n459 ) , .Y ( n439 ) ) ;
NAND2BXL U631 ( .AN ( n1494 ) , .B ( n1493 ) , .Y ( n1147 ) ) ;
INVXL U641 ( .A ( n1898 ) , .Y ( n1912 ) ) ;
NAND4BX1 U873 ( .AN ( n2079 ) , .B ( sar_ptr[4] ) , .C ( n1 ) , .D ( n2197 ) , 
    .Y ( n2131 ) ) ;
AOI21XL U910 ( .A0 ( n314 ) , .A1 ( n1627 ) , .B0 ( n2118 ) , .Y ( n2079 ) ) ;
INVXL U911 ( .A ( target_bit[2] ) , .Y ( n2344 ) ) ;
AND3X1 U912 ( .A ( n2344 ) , .B ( n1993 ) , .C ( target_bit[1] ) , 
    .Y ( n55 ) ) ;
XNOR2XL U914 ( .A ( n2214 ) , .B ( n2170 ) , .Y ( n286 ) ) ;
NAND2BXL U916 ( .AN ( n268 ) , .B ( n267 ) , .Y ( n266 ) ) ;
NAND2BXL U917 ( .AN ( n257 ) , .B ( n256 ) , .Y ( n255 ) ) ;
NAND2BXL U924 ( .AN ( n236 ) , .B ( n237 ) , .Y ( n239 ) ) ;
NAND2BXL U930 ( .AN ( n209 ) , .B ( n210 ) , .Y ( n212 ) ) ;
NAND2BXL U932 ( .AN ( n214 ) , .B ( n215 ) , .Y ( n217 ) ) ;
BUFXL ZBUF_2_inst_2262 ( .A ( tmp_net311 ) , .Y ( ZBUF_2_32 ) ) ;
NAND2BXL U940 ( .AN ( n120 ) , .B ( n121 ) , .Y ( n123 ) ) ;
NAND2BXL U942 ( .AN ( n150 ) , .B ( n151 ) , .Y ( n153 ) ) ;
NAND2BXL U949 ( .AN ( n159 ) , .B ( n160 ) , .Y ( n162 ) ) ;
CLKBUFX2 ZBUF_2_inst_2263 ( .A ( n788_CDR2 ) , .Y ( ZBUF_2_33 ) ) ;
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
AOI22XL ctmTdsLR_1_796 ( .A0 ( n1292 ) , .A1 ( \shadow_weights[2][16] ) , 
    .B0 ( n1688 ) , .B1 ( \shadow_weights[15][16] ) , .Y ( tmp_net117 ) ) ;
INVXL U995 ( .A ( n2347 ) , .Y ( n573 ) ) ;
AND2X1 U1023 ( .A ( n2022 ) , .B ( n2347 ) , .Y ( n2078 ) ) ;
OAI31XL U1025 ( .A0 ( target_bit[3] ) , .A1 ( target_bit[2] ) , 
    .A2 ( target_bit[1] ) , .B0 ( target_bit[4] ) , .Y ( n2022 ) ) ;
NOR3BX1 U1056 ( .AN ( calc_cnt[2] ) , .B ( calc_cnt[3] ) , .C ( n1310 ) , 
    .Y ( n732 ) ) ;
NAND2XL U1059 ( .A ( calc_cnt[4] ) , .B ( n617 ) , .Y ( n1310 ) ) ;
NAND2X2 U1060 ( .A ( n638 ) , .B ( n1990 ) , .Y ( n315 ) ) ;
OAI22XL U1061 ( .A0 ( state[0] ) , .A1 ( n64 ) , .B0 ( n56 ) , .B1 ( n63 ) , 
    .Y ( n2347 ) ) ;
NOR2XL U1131 ( .A ( state[1] ) , .B ( state[0] ) , .Y ( n639 ) ) ;
INVXL U1143 ( .A ( n1991 ) , .Y ( n56 ) ) ;
NOR2XL U1152 ( .A ( n68 ) , .B ( state[3] ) , .Y ( n1991 ) ) ;
AOI22XL ctmTdsLR_3_1900 ( .A0 ( n1672 ) , .A1 ( \shadow_weights[19][24] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][24] ) , .Y ( tmp_net298 ) ) ;
AOI22XL ctmTdsLR_4_1901 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][24] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][24] ) , .Y ( tmp_net299 ) ) ;
AOI22X1 ctmTdsLR_2_1903 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][5] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][5] ) , .Y ( tmp_net300 ) ) ;
AOI222XL ctmTdsLR_3_1904 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][5] ) , 
    .B0 ( n1281 ) , .B1 ( \shadow_weights[19][5] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][5] ) , .Y ( tmp_net301 ) ) ;
AOI221XL ctmTdsLR_1_1905 ( .A0 ( ZBUF_3430_2 ) , 
    .A1 ( \shadow_weights[0][0] ) , .B0 ( n1319 ) , 
    .B1 ( \shadow_weights[13][0] ) , .C0 ( tmp_net302 ) , .Y ( tmp_net186 ) ) ;
OAI2BB1XL ctmTdsLR_2_1906 ( .A0N ( \shadow_weights[2][0] ) , .A1N ( n1292 ) , 
    .B0 ( n615_CDR1 ) , .Y ( tmp_net302 ) ) ;
AOI222XL ctmTdsLR_2_797 ( .A0 ( n1290 ) , .A1 ( \shadow_weights[6][16] ) , 
    .B0 ( ZBUF_3430_2 ) , .B1 ( \shadow_weights[0][16] ) , 
    .C0 ( \shadow_weights[13][16] ) , .C1 ( n1291 ) , .Y ( tmp_net118 ) ) ;
BUFXL ZBUF_2_inst_2266 ( .A ( tmp_net46 ) , .Y ( ZBUF_2_36 ) ) ;
AOI222XL ctmTdsLR_2_1908 ( .A0 ( n1282 ) , .A1 ( \shadow_weights[17][7] ) , 
    .B0 ( n1280 ) , .B1 ( \shadow_weights[18][7] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][7] ) , .Y ( tmp_net303 ) ) ;
AOI22XL ctmTdsLR_3_1909 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][7] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][7] ) , .Y ( tmp_net304 ) ) ;
AOI22XL ctmTdsLR_2_1911 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][28] ) , 
    .B0 ( n1671 ) , .B1 ( \shadow_weights[18][28] ) , .Y ( tmp_net305 ) ) ;
AOI22XL ctmTdsLR_3_1912 ( .A0 ( n1672 ) , .A1 ( \shadow_weights[19][28] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][28] ) , .Y ( tmp_net306 ) ) ;
AOI22XL ctmTdsLR_4_1913 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][28] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][28] ) , .Y ( tmp_net307 ) ) ;
BUFX1 ZBUF_171_inst_2276 ( .A ( n2024 ) , .Y ( ZBUF_171_40 ) ) ;
AOI22XL ctmTdsLR_2_1915 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][14] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][14] ) , .Y ( tmp_net308 ) ) ;
AOI222XL ctmTdsLR_3_1916 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][14] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][14] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][14] ) , .Y ( tmp_net309 ) ) ;
AOI22X1 ctmTdsLR_2_1918 ( .A0 ( n1277 ) , .A1 ( \shadow_weights[10][1] ) , 
    .B0 ( n1279 ) , .B1 ( \shadow_weights[16][1] ) , .Y ( tmp_net310 ) ) ;
BUFX1 HFSBUF_2_138 ( .A ( n1129_CDR2 ) , .Y ( HFSNET_32 ) ) ;
AOI222XL ctmTdsLR_3_1919 ( .A0 ( n1280 ) , .A1 ( \shadow_weights[18][1] ) , 
    .B0 ( n1282 ) , .B1 ( \shadow_weights[17][1] ) , .C0 ( n1281 ) , 
    .C1 ( \shadow_weights[19][1] ) , .Y ( tmp_net311 ) ) ;
AOI222XL ctmTdsLR_2_1921 ( .A0 ( n1271 ) , .A1 ( ZBUF_2_2 ) , .B0 ( n1277 ) , 
    .B1 ( \shadow_weights[10][8] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][8] ) , .Y ( tmp_net312 ) ) ;
AOI22XL ctmTdsLR_2_1923 ( .A0 ( n1671 ) , .A1 ( \shadow_weights[18][2] ) , 
    .B0 ( n1277 ) , .B1 ( \shadow_weights[10][2] ) , .Y ( tmp_net313 ) ) ;
AOI222XL ctmTdsLR_3_1924 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][2] ) , 
    .B0 ( n1281 ) , .B1 ( \shadow_weights[19][2] ) , .C0 ( n1279 ) , 
    .C1 ( \shadow_weights[16][2] ) , .Y ( tmp_net314 ) ) ;
AOI22XL ctmTdsLR_1_1925 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][21] ) , 
    .B0 ( n1671 ) , .B1 ( HFSNET_217 ) , .Y ( tmp_net315 ) ) ;
AOI22XL ctmTdsLR_2_1926 ( .A0 ( n1672 ) , .A1 ( \shadow_weights[19][21] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][21] ) , .Y ( tmp_net316 ) ) ;
AOI22XL ctmTdsLR_3_1927 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][21] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][21] ) , .Y ( tmp_net317 ) ) ;
NAND3XL ctmTdsLR_1_1928 ( .A ( tmp_net318 ) , .B ( tmp_net319 ) , 
    .C ( tmp_net320 ) , .Y ( HFSNET_49 ) ) ;
AOI22XL ctmTdsLR_2_1929 ( .A0 ( n1669 ) , .A1 ( \shadow_weights[8][20] ) , 
    .B0 ( n1671 ) , .B1 ( HFSNET_216 ) , .Y ( tmp_net318 ) ) ;
AOI22XL ctmTdsLR_3_1930 ( .A0 ( n1672 ) , .A1 ( \shadow_weights[19][20] ) , 
    .B0 ( n1668 ) , .B1 ( \shadow_weights[10][20] ) , .Y ( tmp_net319 ) ) ;
AOI22XL ctmTdsLR_4_1931 ( .A0 ( n1673 ) , .A1 ( \shadow_weights[17][20] ) , 
    .B0 ( n1670 ) , .B1 ( \shadow_weights[16][20] ) , .Y ( tmp_net320 ) ) ;
NAND2X1 ctmTdsLR_1_1932 ( .A ( tmp_net49 ) , .B ( tmp_net323 ) , 
    .Y ( HFSNET_158 ) ) ;
NOR4BXL ctmTdsLR_2_1933 ( .AN ( tmp_net48 ) , .B ( n1186_CDR1 ) , 
    .C ( tmp_net321 ) , .D ( tmp_net322 ) , .Y ( tmp_net323 ) ) ;
NAND4X1 ctmTdsLR_3_1934 ( .A ( ZBUF_2_41 ) , .B ( tmp_net275 ) , 
    .C ( tmp_net15 ) , .D ( tmp_net276 ) , .Y ( tmp_net321 ) ) ;
NAND2XL ctmTdsLR_4_1935 ( .A ( n1180_CDR1 ) , .B ( n1188_CDR1 ) , 
    .Y ( tmp_net322 ) ) ;
BUFX1 ZBUF_2_inst_2281 ( .A ( n1179_CDR2 ) , .Y ( ZBUF_2_41 ) ) ;
BUFXL ZBUF_2_inst_2282 ( .A ( tmp_net269 ) , .Y ( ZBUF_2_42 ) ) ;
BUFXL ZBUF_2_inst_2287 ( .A ( tmp_net312 ) , .Y ( ZBUF_2_45 ) ) ;
BUFX1 ZBUF_2_inst_2289 ( .A ( tmp_net31 ) , .Y ( ZBUF_2_47 ) ) ;
CLKBUFX2 copt_gre_mt_inst_2291 ( .A ( HFSNET_97 ) , .Y ( copt_gre_net_507 ) ) ;
CLKBUFX3 copt_gre_mt_inst_2293 ( .A ( tmp_net396 ) , .Y ( copt_gre_net_509 ) ) ;
AND2XL U720 ( .A ( n781_CDR2 ) , .B ( n780_CDR2 ) , .Y ( n788_CDR2 ) ) ;
BUFX2 HFSBUF_24_407 ( .A ( aps_rename_1_ ) , .Y ( calib_overrange ) ) ;
BUFX2 HFSBUF_32_410 ( .A ( aps_rename_5_ ) , .Y ( overrange_bits[14] ) ) ;
CLKBUFX2 HFSBUF_32_411 ( .A ( aps_rename_4_ ) , .Y ( overrange_bits[15] ) ) ;
CLKBUFX2 HFSBUF_32_412 ( .A ( aps_rename_3_ ) , .Y ( overrange_bits[16] ) ) ;
BUFX2 HFSBUF_32_413 ( .A ( aps_rename_2_ ) , .Y ( overrange_bits[17] ) ) ;
BUFX2 HFSBUF_32_417 ( .A ( aps_rename_6_ ) , .Y ( overrange_bits[7] ) ) ;
BUFX1 HFSBUF_51_437 ( .A ( \shadow_weights[17][12] ) , .Y ( HFSNET_191 ) ) ;
BUFX1 HFSBUF_66_462 ( .A ( \shadow_weights[18][20] ) , .Y ( HFSNET_216 ) ) ;
BUFX1 HFSBUF_47_463 ( .A ( \shadow_weights[18][21] ) , .Y ( HFSNET_217 ) ) ;
CLKBUFXL HFSBUF_48_474 ( .A ( n2162 ) , .Y ( HFSNET_228 ) ) ;
INVXL HFSINV_138_482 ( .A ( N1838 ) , .Y ( HFSNET_234 ) ) ;
OR2XL U1391 ( .A ( n600 ) , .B ( n577 ) , .Y ( N1838 ) ) ;
INVXL HFSINV_159_500 ( .A ( N1829 ) , .Y ( HFSNET_250 ) ) ;
OR2XL U1723 ( .A ( n598 ) , .B ( n599 ) , .Y ( N1829 ) ) ;
CLKBUFXL HFSBUF_72_524 ( .A ( n2180 ) , .Y ( HFSNET_269 ) ) ;
BUFX1 HFSBUF_39_526 ( .A ( n2159 ) , .Y ( HFSNET_271 ) ) ;
INVX4 HFSINV_809_543 ( .A ( calc_result_r[11] ) , .Y ( HFSNET_288 ) ) ;
INVX4 HFSINV_603_563 ( .A ( calc_result_r[1] ) , .Y ( HFSNET_308 ) ) ;
INVX4 HFSINV_796_575 ( .A ( calc_result_r[7] ) , .Y ( HFSNET_320 ) ) ;
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
    .clk ( ctosc_gls_0 ) , .rst_n ( HFSNET_119 ) , 
    .start_calib ( start_calib ) , .calib_done ( aps_rename_9_ ) , 
    .calib_done_pulse ( aps_rename_10_ ) , .calib_mode_en ( aps_rename_11_ ) , 
    .comp_out ( calib_comp_out ) ,
    .dac_p_force ( { aps_rename_12_ , aps_rename_13_ , aps_rename_14_ , 
        aps_rename_15_ , aps_rename_16_ , aps_rename_17_ , aps_rename_18_ , 
        aps_rename_19_ , aps_rename_20_ , dac_p_force[10] , aps_rename_21_ , 
        dac_p_force[8] , dac_p_force[7] , dac_p_force[6] , dac_p_force[5] , 
        dac_p_force[4] , dac_p_force[3] , aps_rename_22_ , dac_p_force[1] , 
        aps_rename_23_ } ) ,
    .dac_n_force ( { aps_rename_24_ , aps_rename_25_ , aps_rename_26_ , 
        aps_rename_27_ , aps_rename_28_ , aps_rename_29_ , aps_rename_30_ , 
        aps_rename_31_ , aps_rename_32_ , aps_rename_33_ , aps_rename_34_ , 
        aps_rename_35_ , aps_rename_36_ , aps_rename_37_ , aps_rename_38_ , 
        aps_rename_39_ , aps_rename_40_ , aps_rename_41_ , aps_rename_42_ , 
        aps_rename_43_ } ) ,
    .w_wr_en ( aps_rename_72_ ) ,
    .w_wr_addr ( { aps_rename_73_ , aps_rename_74_ , aps_rename_75_ , 
        aps_rename_76_ , aps_rename_77_ } ) ,
    .w_wr_data ( { aps_rename_78_ , aps_rename_79_ , aps_rename_80_ , 
        aps_rename_81_ , aps_rename_82_ , aps_rename_83_ , aps_rename_84_ , 
        aps_rename_85_ , aps_rename_86_ , aps_rename_87_ , aps_rename_88_ , 
        aps_rename_89_ , aps_rename_90_ , aps_rename_91_ , aps_rename_92_ , 
        aps_rename_93_ , aps_rename_94_ , aps_rename_95_ , aps_rename_96_ , 
        aps_rename_97_ , aps_rename_98_ , aps_rename_99_ , aps_rename_100_ , 
        aps_rename_101_ , aps_rename_102_ , aps_rename_103_ , 
        aps_rename_104_ , aps_rename_105_ , aps_rename_106_ , 
        aps_rename_107_ } ) ,
    .calib_overrange ( calib_overrange ) ,
    .overrange_bits ( { aps_rename_44_ , aps_rename_45_ , 
        calib_overrange_bits[17] , calib_overrange_bits[16] , 
        calib_overrange_bits[15] , calib_overrange_bits[14] , aps_rename_46_ , 
        aps_rename_47_ , aps_rename_48_ , calib_overrange_bits[10] , 
        calib_overrange_bits[9] , calib_overrange_bits[8] , 
        calib_overrange_bits[7] , aps_rename_49_ , calib_overrange_bits[5] , 
        aps_rename_50_ , calib_overrange_bits[3] , calib_overrange_bits[2] , 
        calib_overrange_bits[1] , calib_overrange_bits[0] } ) ,
    .HFSNET_330 ( HFSNET_120 ) , .HFSNET_346 ( HFSNET_121 ) , 
    .HFSNET_362 ( HFSNET_122 ) , .HFSNET_363 ( HFSNET_123 ) , 
    .HFSNET_364 ( HFSNET_124 ) , .ZBUF_24_0 ( calib_overrange_bits[11] ) , 
    .ZBUF_24_1 ( calib_overrange_bits[13] ) , 
    .ZBUF_24_2 ( calib_overrange_bits[12] ) , 
    .ZBUF_22_2 ( calib_overrange_bits[4] ) , 
    .ZBUF_24_3 ( calib_overrange_bits[6] ) , .ZCTSNET_392 ( ZCTSNET_126 ) , 
    .ZCTSNET_393 ( ZCTSNET_127 ) , .ZCTSNET_394 ( clk ) , 
    .gre_a_BUF_36_0 ( gre_a_BUF_36_49 ) , 
    .gre_a_BUF_36_1 ( gre_a_BUF_36_50 ) , 
    .gre_a_BUF_36_2 ( gre_a_BUF_36_51 ) , 
    .gre_a_BUF_36_3 ( gre_a_BUF_36_52 ) , 
    .gre_a_BUF_36_4 ( gre_a_BUF_36_53 ) ) ;
srm_residue_estimator_DECISION_COUNT22_RESIDUE_WIDTH10_RES_FRAC8_SIGMA_Q8128_STALL_CYCLES64 u_srm_residue ( 
    .dec_clk ( dec_clk ) , .decision_valid ( srm_decision_valid ) , 
    .decision_bit ( srm_decision_bit ) , .clk ( ctosc_gls_0 ) , 
    .rst_n ( HFSNET_119 ) , .start ( srm_start ) , 
    .residue_consume ( residue_consume_i ) , .busy ( srm_busy ) , 
    .done ( aps_rename_108_ ) , .residue_valid ( srm_residue_valid ) ,
    .ones_count ( { aps_rename_109_ , aps_rename_110_ , aps_rename_111_ , 
        aps_rename_112_ , aps_rename_113_ } ) ,
    .total_count ( { aps_rename_114_ , aps_rename_115_ , aps_rename_116_ , 
        aps_rename_117_ , aps_rename_118_ } ) ,
    .count_shortfall ( aps_rename_119_ ) , .stalled ( aps_rename_120_ ) ,
    .residue_q ( { aps_rename_121_ , aps_rename_122_ , aps_rename_123_ , 
        aps_rename_124_ , aps_rename_125_ , aps_rename_126_ , 
        aps_rename_127_ , aps_rename_128_ , aps_rename_129_ , 
        aps_rename_130_ } ) ,
    .HFSNET_5 ( HFSNET_120 ) , .HFSNET_7 ( HFSNET_123 ) , 
    .HFSNET_8 ( HFSNET_124 ) ) ;
DFFSX1 raw_code_valid_o_reg ( .D ( n42 ) , .CK ( ZCTSNET_127 ) , 
    .SN ( HFSNET_122 ) , .QN ( aps_rename_71_ ) ) ;
DFFSX1 \raw_code_o_reg[19] ( .D ( n40 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_51_ ) ) ;
DFFSX1 \raw_code_o_reg[18] ( .D ( n38 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_52_ ) ) ;
DFFSX1 \raw_code_o_reg[17] ( .D ( n36 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_53_ ) ) ;
DFFSX1 \raw_code_o_reg[16] ( .D ( n34 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_54_ ) ) ;
DFFSX1 \raw_code_o_reg[15] ( .D ( n32 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_55_ ) ) ;
DFFSX1 \raw_code_o_reg[14] ( .D ( n30 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_56_ ) ) ;
DFFSX1 \raw_code_o_reg[13] ( .D ( n28 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_57_ ) ) ;
DFFSX1 \raw_code_o_reg[12] ( .D ( n26 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_58_ ) ) ;
DFFSX1 \raw_code_o_reg[11] ( .D ( n24 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_59_ ) ) ;
DFFSX1 \raw_code_o_reg[10] ( .D ( n22 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_60_ ) ) ;
DFFSX1 \raw_code_o_reg[9] ( .D ( n20 ) , .CK ( ctosc_gls_0 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_61_ ) ) ;
DFFSX1 \raw_code_o_reg[8] ( .D ( n18 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_62_ ) ) ;
DFFSX1 \raw_code_o_reg[7] ( .D ( n16 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_63_ ) ) ;
DFFSX1 \raw_code_o_reg[6] ( .D ( n14 ) , .CK ( ctosc_gls_0 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_64_ ) ) ;
DFFSX1 \raw_code_o_reg[5] ( .D ( n12 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_65_ ) ) ;
DFFSX1 \raw_code_o_reg[4] ( .D ( n10 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_66_ ) ) ;
DFFSX1 \raw_code_o_reg[3] ( .D ( n8 ) , .CK ( ZCTSNET_126 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_67_ ) ) ;
DFFSX1 \raw_code_o_reg[2] ( .D ( n6 ) , .CK ( ctosc_gls_0 ) , 
    .SN ( HFSNET_123 ) , .QN ( aps_rename_68_ ) ) ;
DFFSX1 \raw_code_o_reg[1] ( .D ( HFSNET_115 ) , .CK ( ZCTSNET_127 ) , 
    .SN ( HFSNET_121 ) , .QN ( aps_rename_69_ ) ) ;
DFFSX1 \raw_code_o_reg[0] ( .D ( HFSNET_114 ) , .CK ( ZCTSNET_127 ) , 
    .SN ( HFSNET_121 ) , .QN ( aps_rename_70_ ) ) ;
INVXL U19 ( .A ( raw_bits_i[16] ) , .Y ( n34 ) ) ;
INVXL U8 ( .A ( raw_bits_i[5] ) , .Y ( n12 ) ) ;
INVXL U7 ( .A ( raw_bits_i[4] ) , .Y ( n10 ) ) ;
INVXL U12 ( .A ( raw_bits_i[9] ) , .Y ( n20 ) ) ;
INVXL U16 ( .A ( raw_bits_i[13] ) , .Y ( n28 ) ) ;
INVXL U10 ( .A ( raw_bits_i[7] ) , .Y ( n16 ) ) ;
INVXL U18 ( .A ( raw_bits_i[15] ) , .Y ( n32 ) ) ;
CLKINVX1 HFSINV_4_322 ( .A ( raw_bits_i[0] ) , .Y ( HFSNET_114 ) ) ;
INVXL U20 ( .A ( raw_bits_i[17] ) , .Y ( n36 ) ) ;
INVXL U21 ( .A ( raw_bits_i[18] ) , .Y ( n38 ) ) ;
INVXL U9 ( .A ( raw_bits_i[6] ) , .Y ( n14 ) ) ;
INVXL U15 ( .A ( raw_bits_i[12] ) , .Y ( n26 ) ) ;
INVXL U14 ( .A ( raw_bits_i[11] ) , .Y ( n24 ) ) ;
INVXL U22 ( .A ( raw_bits_i[19] ) , .Y ( n40 ) ) ;
INVXL U23 ( .A ( data_valid_i ) , .Y ( n42 ) ) ;
INVXL U6 ( .A ( raw_bits_i[3] ) , .Y ( n8 ) ) ;
CLKINVX1 HFSINV_4_323 ( .A ( raw_bits_i[1] ) , .Y ( HFSNET_115 ) ) ;
INVXL U5 ( .A ( raw_bits_i[2] ) , .Y ( n6 ) ) ;
INVXL U11 ( .A ( raw_bits_i[8] ) , .Y ( n18 ) ) ;
INVXL U13 ( .A ( raw_bits_i[10] ) , .Y ( n22 ) ) ;
INVXL U17 ( .A ( raw_bits_i[14] ) , .Y ( n30 ) ) ;
CLKBUFX2 HFSBUF_2_40 ( .A ( aps_rename_70_ ) , .Y ( raw_code_o[0] ) ) ;
CLKBUFX2 HFSBUF_2_41 ( .A ( aps_rename_60_ ) , .Y ( raw_code_o[10] ) ) ;
CLKBUFX2 HFSBUF_2_42 ( .A ( aps_rename_59_ ) , .Y ( raw_code_o[11] ) ) ;
CLKBUFX2 HFSBUF_2_43 ( .A ( aps_rename_58_ ) , .Y ( raw_code_o[12] ) ) ;
CLKBUFX2 HFSBUF_2_44 ( .A ( aps_rename_57_ ) , .Y ( raw_code_o[13] ) ) ;
CLKBUFX2 HFSBUF_2_45 ( .A ( aps_rename_56_ ) , .Y ( raw_code_o[14] ) ) ;
CLKBUFX2 HFSBUF_2_46 ( .A ( aps_rename_55_ ) , .Y ( raw_code_o[15] ) ) ;
CLKBUFX2 HFSBUF_2_47 ( .A ( aps_rename_54_ ) , .Y ( raw_code_o[16] ) ) ;
CLKBUFX2 HFSBUF_2_48 ( .A ( aps_rename_53_ ) , .Y ( raw_code_o[17] ) ) ;
CLKBUFX2 HFSBUF_2_49 ( .A ( aps_rename_52_ ) , .Y ( raw_code_o[18] ) ) ;
CLKBUFX2 HFSBUF_2_50 ( .A ( aps_rename_51_ ) , .Y ( raw_code_o[19] ) ) ;
CLKBUFX2 HFSBUF_2_51 ( .A ( aps_rename_69_ ) , .Y ( raw_code_o[1] ) ) ;
BUFX2 HFSBUF_2_52 ( .A ( aps_rename_68_ ) , .Y ( raw_code_o[2] ) ) ;
BUFX2 HFSBUF_2_53 ( .A ( aps_rename_67_ ) , .Y ( raw_code_o[3] ) ) ;
BUFX2 HFSBUF_2_54 ( .A ( aps_rename_66_ ) , .Y ( raw_code_o[4] ) ) ;
CLKBUFX2 HFSBUF_2_55 ( .A ( aps_rename_65_ ) , .Y ( raw_code_o[5] ) ) ;
CLKBUFX2 HFSBUF_2_56 ( .A ( aps_rename_64_ ) , .Y ( raw_code_o[6] ) ) ;
BUFX2 HFSBUF_2_57 ( .A ( aps_rename_63_ ) , .Y ( raw_code_o[7] ) ) ;
CLKBUFX2 HFSBUF_2_58 ( .A ( aps_rename_62_ ) , .Y ( raw_code_o[8] ) ) ;
CLKBUFX2 HFSBUF_2_59 ( .A ( aps_rename_61_ ) , .Y ( raw_code_o[9] ) ) ;
BUFX2 HFSBUF_2_60 ( .A ( aps_rename_71_ ) , .Y ( raw_code_valid_o ) ) ;
BUFX1 HFSBUF_2_61 ( .A ( aps_rename_21_ ) , .Y ( dac_p_force[9] ) ) ;
BUFX1 HFSBUF_2_62 ( .A ( aps_rename_22_ ) , .Y ( dac_p_force[2] ) ) ;
CLKBUFX2 HFSBUF_2_63 ( .A ( aps_rename_36_ ) , .Y ( dac_n_force[7] ) ) ;
BUFX1 HFSBUF_2_64 ( .A ( aps_rename_20_ ) , .Y ( dac_p_force[11] ) ) ;
CLKBUFX3 HFSBUF_2_65 ( .A ( aps_rename_25_ ) , .Y ( dac_n_force[18] ) ) ;
CLKBUFX2 HFSBUF_2_66 ( .A ( aps_rename_28_ ) , .Y ( dac_n_force[15] ) ) ;
CLKBUFX2 HFSBUF_2_67 ( .A ( aps_rename_30_ ) , .Y ( dac_n_force[13] ) ) ;
CLKBUFX2 HFSBUF_2_68 ( .A ( aps_rename_29_ ) , .Y ( dac_n_force[14] ) ) ;
CLKBUFX2 HFSBUF_2_69 ( .A ( aps_rename_37_ ) , .Y ( dac_n_force[6] ) ) ;
CLKBUFX3 HFSBUF_2_70 ( .A ( aps_rename_40_ ) , .Y ( dac_n_force[3] ) ) ;
CLKBUFX2 HFSBUF_2_71 ( .A ( aps_rename_34_ ) , .Y ( dac_n_force[9] ) ) ;
CLKBUFX2 HFSBUF_2_72 ( .A ( aps_rename_32_ ) , .Y ( dac_n_force[11] ) ) ;
CLKBUFX3 HFSBUF_2_73 ( .A ( aps_rename_42_ ) , .Y ( dac_n_force[1] ) ) ;
CLKBUFX2 HFSBUF_2_74 ( .A ( aps_rename_39_ ) , .Y ( dac_n_force[4] ) ) ;
CLKBUFX2 HFSBUF_2_75 ( .A ( aps_rename_38_ ) , .Y ( dac_n_force[5] ) ) ;
CLKBUFX3 HFSBUF_2_76 ( .A ( aps_rename_43_ ) , .Y ( dac_n_force[0] ) ) ;
CLKBUFX3 HFSBUF_2_77 ( .A ( aps_rename_41_ ) , .Y ( dac_n_force[2] ) ) ;
CLKBUFX2 HFSBUF_2_78 ( .A ( aps_rename_35_ ) , .Y ( dac_n_force[8] ) ) ;
CLKBUFXL HFSBUF_2_79 ( .A ( aps_rename_33_ ) , .Y ( dac_n_force[10] ) ) ;
CLKBUFX2 HFSBUF_2_80 ( .A ( aps_rename_23_ ) , .Y ( dac_p_force[0] ) ) ;
CLKBUFX2 HFSBUF_2_81 ( .A ( aps_rename_13_ ) , .Y ( dac_p_force[18] ) ) ;
CLKBUFX2 HFSBUF_2_82 ( .A ( aps_rename_14_ ) , .Y ( dac_p_force[17] ) ) ;
BUFX1 HFSBUF_2_83 ( .A ( aps_rename_15_ ) , .Y ( dac_p_force[16] ) ) ;
CLKBUFX2 HFSBUF_2_84 ( .A ( aps_rename_16_ ) , .Y ( dac_p_force[15] ) ) ;
BUFX1 HFSBUF_2_85 ( .A ( aps_rename_17_ ) , .Y ( dac_p_force[14] ) ) ;
CLKBUFX2 HFSBUF_2_86 ( .A ( aps_rename_18_ ) , .Y ( dac_p_force[13] ) ) ;
BUFX1 HFSBUF_2_87 ( .A ( aps_rename_19_ ) , .Y ( dac_p_force[12] ) ) ;
CLKBUFX2 HFSBUF_2_88 ( .A ( aps_rename_27_ ) , .Y ( dac_n_force[16] ) ) ;
CLKBUFX2 HFSBUF_2_89 ( .A ( aps_rename_24_ ) , .Y ( dac_n_force[19] ) ) ;
CLKBUFX2 HFSBUF_2_90 ( .A ( aps_rename_26_ ) , .Y ( dac_n_force[17] ) ) ;
CLKBUFX2 HFSBUF_2_91 ( .A ( aps_rename_31_ ) , .Y ( dac_n_force[12] ) ) ;
CLKBUFX2 HFSBUF_2_92 ( .A ( aps_rename_12_ ) , .Y ( dac_p_force[19] ) ) ;
CLKBUFX2 HFSBUF_2_248 ( .A ( aps_rename_9_ ) , .Y ( calib_done ) ) ;
CLKBUFX2 HFSBUF_2_249 ( .A ( aps_rename_11_ ) , .Y ( calib_mode_en ) ) ;
CLKBUFX2 HFSBUF_2_261 ( .A ( aps_rename_77_ ) , .Y ( w_wr_addr[0] ) ) ;
CLKBUFX2 HFSBUF_2_262 ( .A ( aps_rename_76_ ) , .Y ( w_wr_addr[1] ) ) ;
CLKBUFX2 HFSBUF_2_263 ( .A ( aps_rename_75_ ) , .Y ( w_wr_addr[2] ) ) ;
CLKBUFX2 HFSBUF_2_264 ( .A ( aps_rename_74_ ) , .Y ( w_wr_addr[3] ) ) ;
CLKBUFX2 HFSBUF_2_265 ( .A ( aps_rename_73_ ) , .Y ( w_wr_addr[4] ) ) ;
CLKBUFX2 HFSBUF_2_266 ( .A ( aps_rename_107_ ) , .Y ( w_wr_data[0] ) ) ;
CLKBUFX2 HFSBUF_2_267 ( .A ( aps_rename_97_ ) , .Y ( w_wr_data[10] ) ) ;
CLKBUFX2 HFSBUF_2_268 ( .A ( aps_rename_96_ ) , .Y ( w_wr_data[11] ) ) ;
CLKBUFX2 HFSBUF_2_269 ( .A ( aps_rename_95_ ) , .Y ( w_wr_data[12] ) ) ;
CLKBUFX2 HFSBUF_2_270 ( .A ( aps_rename_94_ ) , .Y ( w_wr_data[13] ) ) ;
CLKBUFX2 HFSBUF_2_271 ( .A ( aps_rename_93_ ) , .Y ( w_wr_data[14] ) ) ;
CLKBUFX2 HFSBUF_2_272 ( .A ( aps_rename_92_ ) , .Y ( w_wr_data[15] ) ) ;
BUFX1 HFSBUF_2_273 ( .A ( aps_rename_91_ ) , .Y ( w_wr_data[16] ) ) ;
CLKBUFX2 HFSBUF_2_274 ( .A ( aps_rename_90_ ) , .Y ( w_wr_data[17] ) ) ;
CLKBUFX2 HFSBUF_2_275 ( .A ( aps_rename_89_ ) , .Y ( w_wr_data[18] ) ) ;
CLKBUFX2 HFSBUF_2_276 ( .A ( aps_rename_88_ ) , .Y ( w_wr_data[19] ) ) ;
CLKBUFX2 HFSBUF_2_277 ( .A ( aps_rename_106_ ) , .Y ( w_wr_data[1] ) ) ;
CLKBUFX2 HFSBUF_2_278 ( .A ( aps_rename_87_ ) , .Y ( w_wr_data[20] ) ) ;
CLKBUFX2 HFSBUF_2_279 ( .A ( aps_rename_86_ ) , .Y ( w_wr_data[21] ) ) ;
CLKBUFX2 HFSBUF_2_280 ( .A ( aps_rename_85_ ) , .Y ( w_wr_data[22] ) ) ;
CLKBUFX2 HFSBUF_2_281 ( .A ( aps_rename_84_ ) , .Y ( w_wr_data[23] ) ) ;
CLKBUFX2 HFSBUF_2_282 ( .A ( aps_rename_83_ ) , .Y ( w_wr_data[24] ) ) ;
CLKBUFX2 HFSBUF_2_283 ( .A ( aps_rename_82_ ) , .Y ( w_wr_data[25] ) ) ;
CLKBUFX2 HFSBUF_2_284 ( .A ( aps_rename_81_ ) , .Y ( w_wr_data[26] ) ) ;
CLKBUFX2 HFSBUF_2_285 ( .A ( aps_rename_80_ ) , .Y ( w_wr_data[27] ) ) ;
CLKBUFX2 HFSBUF_2_286 ( .A ( aps_rename_79_ ) , .Y ( w_wr_data[28] ) ) ;
CLKBUFX2 HFSBUF_2_287 ( .A ( aps_rename_78_ ) , .Y ( w_wr_data[29] ) ) ;
CLKBUFX2 HFSBUF_2_288 ( .A ( aps_rename_105_ ) , .Y ( w_wr_data[2] ) ) ;
CLKBUFX3 HFSBUF_2_289 ( .A ( aps_rename_104_ ) , .Y ( w_wr_data[3] ) ) ;
CLKBUFX2 HFSBUF_2_290 ( .A ( aps_rename_103_ ) , .Y ( w_wr_data[4] ) ) ;
CLKBUFX2 HFSBUF_2_291 ( .A ( aps_rename_102_ ) , .Y ( w_wr_data[5] ) ) ;
CLKBUFX2 HFSBUF_2_292 ( .A ( aps_rename_101_ ) , .Y ( w_wr_data[6] ) ) ;
CLKBUFX3 HFSBUF_2_293 ( .A ( aps_rename_100_ ) , .Y ( w_wr_data[7] ) ) ;
CLKBUFX2 HFSBUF_2_294 ( .A ( aps_rename_99_ ) , .Y ( w_wr_data[8] ) ) ;
CLKBUFX2 HFSBUF_2_295 ( .A ( aps_rename_98_ ) , .Y ( w_wr_data[9] ) ) ;
CLKBUFX2 HFSBUF_2_296 ( .A ( aps_rename_72_ ) , .Y ( w_wr_en ) ) ;
CLKBUFX2 HFSBUF_2_299 ( .A ( aps_rename_119_ ) , .Y ( srm_count_shortfall ) ) ;
BUFX4 HFSBUF_2_300 ( .A ( aps_rename_108_ ) , .Y ( srm_done ) ) ;
CLKBUFX4 HFSBUF_2_301 ( .A ( aps_rename_113_ ) , .Y ( srm_ones_count[0] ) ) ;
CLKBUFX4 HFSBUF_2_302 ( .A ( aps_rename_112_ ) , .Y ( srm_ones_count[1] ) ) ;
CLKBUFX8 HFSBUF_2_303 ( .A ( aps_rename_111_ ) , .Y ( srm_ones_count[2] ) ) ;
CLKBUFX8 HFSBUF_2_304 ( .A ( aps_rename_110_ ) , .Y ( srm_ones_count[3] ) ) ;
BUFX4 HFSBUF_2_305 ( .A ( aps_rename_109_ ) , .Y ( srm_ones_count[4] ) ) ;
CLKBUFX3 HFSBUF_2_306 ( .A ( aps_rename_130_ ) , .Y ( srm_residue_o[0] ) ) ;
CLKBUFX3 HFSBUF_2_307 ( .A ( aps_rename_129_ ) , .Y ( srm_residue_o[1] ) ) ;
CLKBUFX2 HFSBUF_2_308 ( .A ( aps_rename_128_ ) , .Y ( srm_residue_o[2] ) ) ;
CLKBUFX2 HFSBUF_2_309 ( .A ( aps_rename_127_ ) , .Y ( srm_residue_o[3] ) ) ;
CLKBUFX3 HFSBUF_2_310 ( .A ( aps_rename_126_ ) , .Y ( srm_residue_o[4] ) ) ;
CLKBUFX2 HFSBUF_2_311 ( .A ( aps_rename_125_ ) , .Y ( srm_residue_o[5] ) ) ;
CLKBUFX2 HFSBUF_2_312 ( .A ( aps_rename_124_ ) , .Y ( srm_residue_o[6] ) ) ;
CLKBUFX3 HFSBUF_2_313 ( .A ( aps_rename_123_ ) , .Y ( srm_residue_o[7] ) ) ;
CLKBUFX2 HFSBUF_2_314 ( .A ( aps_rename_122_ ) , .Y ( srm_residue_o[8] ) ) ;
CLKBUFX8 HFSBUF_2_315 ( .A ( aps_rename_121_ ) , .Y ( srm_residue_o[9] ) ) ;
CLKBUFX8 HFSBUF_2_317 ( .A ( aps_rename_117_ ) , .Y ( srm_total_count[1] ) ) ;
BUFX4 HFSBUF_2_318 ( .A ( aps_rename_116_ ) , .Y ( srm_total_count[2] ) ) ;
CLKBUFX4 HFSBUF_2_319 ( .A ( aps_rename_115_ ) , .Y ( srm_total_count[3] ) ) ;
BUFX4 HFSBUF_2_320 ( .A ( aps_rename_114_ ) , .Y ( srm_total_count[4] ) ) ;
CLKBUFX2 HFSBUF_9_414 ( .A ( aps_rename_45_ ) , 
    .Y ( calib_overrange_bits[18] ) ) ;
BUFX2 HFSBUF_9_415 ( .A ( aps_rename_44_ ) , .Y ( calib_overrange_bits[19] ) ) ;
BUFX4 HFSBUF_9_421 ( .A ( aps_rename_120_ ) , .Y ( srm_stalled ) ) ;
CLKINVX3 HFSINV_6951_589 ( .A ( HFSNET_124 ) , .Y ( HFSNET_119 ) ) ;
CLKINVX4 HFSINV_7577_606 ( .A ( HFSNET_124 ) , .Y ( HFSNET_120 ) ) ;
CLKINVX8 HFSINV_8439_622 ( .A ( HFSNET_124 ) , .Y ( HFSNET_121 ) ) ;
CLKINVX4 HFSINV_13612_623 ( .A ( HFSNET_124 ) , .Y ( HFSNET_122 ) ) ;
CLKINVX4 HFSINV_7443_624 ( .A ( HFSNET_124 ) , .Y ( HFSNET_123 ) ) ;
INVX8 HFSINV_15503_626 ( .A ( rst_n ) , .Y ( HFSNET_124 ) ) ;
CLKBUFX2 ZBUF_24_inst_1022 ( .A ( aps_rename_48_ ) , 
    .Y ( calib_overrange_bits[11] ) ) ;
CLKBUFX2 ZBUF_24_inst_1025 ( .A ( aps_rename_46_ ) , 
    .Y ( calib_overrange_bits[13] ) ) ;
CLKBUFX2 ZBUF_24_inst_1045 ( .A ( aps_rename_47_ ) , 
    .Y ( calib_overrange_bits[12] ) ) ;
CLKBUFX2 ZBUF_22_inst_1054 ( .A ( aps_rename_50_ ) , 
    .Y ( calib_overrange_bits[4] ) ) ;
CLKBUFX2 ZBUF_24_inst_1064 ( .A ( aps_rename_49_ ) , 
    .Y ( calib_overrange_bits[6] ) ) ;
BUFX1 copt_gre_h_inst_2295 ( .A ( aps_rename_10_ ) , .Y ( calib_done_pulse ) ) ;
BUFX2 ZCTSBUF_4939_1395 ( .A ( ZCTSNET_127 ) , .Y ( ZCTSNET_126 ) ) ;
CLKBUFX4 ZCTSBUF_5981_1396 ( .A ( clk ) , .Y ( ZCTSNET_127 ) ) ;
CLKBUFX8 ctosc_gls_inst_1718 ( .A ( clk ) , .Y ( ctosc_gls_0 ) ) ;
BUFX2 gre_a_BUF_4_inst_2337 ( .A ( aps_rename_118_ ) , 
    .Y ( srm_total_count[0] ) ) ;
endmodule


