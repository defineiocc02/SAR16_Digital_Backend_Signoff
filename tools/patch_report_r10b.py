#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Repair the round-10 section 1.7 block.

The first attempt embedded real newlines inside single-quoted Python literals (the
patch script interpreted \\n itself), so the generator no longer parsed.  This script
replaces the whole 1.7 region using a RAW string, so every \\n stays a backslash-n in
the generated source.  Apostrophes inside generated literals are avoided by using
double-quoted literals there.
"""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

START = '    p1.append("<h3>1.7 '
END = '    # ---- P2 \u65f6\u5e8f ----'
i = t.find(START)
j = t.find(END, i)
print("1.7 block: %d .. %d" % (i, j))
assert i > 0 and j > i

NEW = r'''    p1.append("<h3>1.7 \u6700\u540e\u4e00\u6761 LVS \u9519\u8bef\u7684\u771f\u56e0\uff1a"
              "<b>\u4ea4\u4ed8\u7684\u7f51\u8868\u6ca1\u6709\u63cf\u8ff0\u5b83\u81ea\u5df1\u7684\u7248\u56fe</b>\uff08\u7b2c 10 \u8f6e\uff09</h3>")
    p1.append("<p>\u7b2c 1.6 \u8282\u628a\u6b8b\u5dee\u6536\u655b\u5230\u300c\u552f\u4e00\u4e00\u6761\u9519\u8bef\u7f51 = VDD\u300d\u4e4b\u540e\uff0c"
              "\u6cbf\u8fd9\u6761\u7ebf\u6316\u5230\u5e95\uff0c\u5f97\u5230\u4e00\u4e2a<b>\u6bd4 LVS \u672c\u8eab\u91cd\u8981\u5f97\u591a</b>\u7684\u7ed3\u8bba\u3002</p>")
    p1.append("<h4>\u5e38\u91cf tie \u662f\u7528 85 \u4e2a\u771f\u5b9e\u53cd\u76f8\u5668\u9020\u51fa\u6765\u7684\uff0c"
              "\u800c\u6839\u7f51\u7edc\u60ac\u7a7a</h4>")
    p1.append("<pre>// pnr/out/sar_digi_paper_core_pnr.v\n"
              "CLKINVX3 HFSINV_106_588   ( .A ( HFSNET_8 ) , .Y ( HFSNET_4 ) ) ;\n"
              "CLKINVX4 HFSINV_246_605   ( .A ( HFSNET_8 ) , .Y ( HFSNET_6 ) ) ;\n"
              "INVX3    HFSINV_15018_625 ( .A ( HFSNET_8 ) , .Y ( HFSNET_9 ) ) ;</pre>")
    p1.append(tbl(["\u9879", "\u5b9e\u6d4b"], [
        ["<code>HFSINV_*</code> \u5b9e\u4f8b\uff08Verilog / CDL\uff09", "<b>85 / 85</b>"],
        ["\u5b83\u4eec\u7684 <code>.A</code>", "\u5168\u90e8\u662f <code>HFSNET_8</code>"],
        ["<code>HFSNET_8</code> \u7684\u9a71\u52a8",
         b("\u6ca1\u6709\uff08\u5168\u6587\u4ef6\u65e0 assign / wire / \u4efb\u4f55 .Y\uff09", 2)],
        ["Verilog \u91cc <code>HFSNET</code> \u7684\u4f4d\u7f6e",
         "\u5b9e\u4f8b\u8fde\u63a5 1830 \u5904\u3001\u7aef\u53e3\u58f0\u660e 8 \u5904\u3001\u7aef\u53e3\u8868 8 \u5904\uff1b<b>\u65e0\u4e00\u5904\u662f\u9a71\u52a8</b>"],
        ["\u7248\u56fe\u62bd\u53d6\u91cc\u7684 <code>HFSNET</code> / <code>HFSINV</code>", "<b>0 / 0</b>"],
    ]))
    p1.append(note("<b>\u4e24\u8fb9\u81ea\u6d3d\u7684\u89e3\u91ca</b>\uff1a<code>HFSNET_8</code> \u662f\u5e38\u91cf\u6839\uff08\u903b\u8f91 0\uff09\uff0c"
                   "\u5176\u4f59 <code>HFSNET_*</code> \u662f\u5b83\u7ecf\u8fc7 85 \u4e2a\u53cd\u76f8\u5668\u7684"
                   "<b>\u53cd\u76f8\u526f\u672c</b>\uff08\u903b\u8f91 1 = VDD\uff09\uff1b\u7248\u56fe\u628a\u90a3\u4e00\u7ea7\u5e38\u91cf\u4f20\u64ad\u6389\u4e86\uff0c"
                   "\u8d1f\u8f7d\u76f4\u63a5\u63a5\u5230\u7535\u6e90\u8f68 \u2014\u2014 \u8fd9\u662f<b>\u6b63\u786e\u4e14\u5e38\u89c4</b>\u7684 P&R \u884c\u4e3a\u3002"))
    p1.append("<h4>\u540c\u4e00\u4e2a\u5751\u91cc\u6700\u4e25\u91cd\u7684\u4e00\u6761\uff1a\u4e24\u4e2a\u6700\u5927\u5b50\u6a21\u5757\u7684 "
              "<code>rst_n</code> \u4e5f\u60ac\u7a7a</h4>")
    p1.append("<pre>sar_calib_ctrl_serial_... u_calib_ctrl (\n"
              "    .clk ( ctosc_gls_0 ) , .rst_n ( HFSNET_119 ) , ...\n"
              "srm_residue_estimator_... u_srm_residue (\n"
              "    .dec_clk ( dec_clk ) , ... .rst_n ( HFSNET_119 ) , ...\n"
              "\n"
              "// \u800c\u9876\u5c42 RTL \u5199\u5f97\u6e05\u6e05\u695a\u695a\uff1artl/sar_digi_paper_core.sv\n"
              "input  logic rst_n,   // asynchronous, active low, common to both domains\n"
              ") u_calib_ctrl  ( ... .rst_n (rst_n), ...\n"
              ") u_srm_residue ( ... .rst_n (rst_n), ...</pre>")
    p1.append(note("<code>HFSNET_119</code> \u540c\u6837<b>\u6ca1\u6709\u4efb\u4f55\u9a71\u52a8</b>\uff0c"
                   "\u800c\u9876\u5c42 <code>rst_n</code> \u7aef\u53e3\u5728 P&R \u7f51\u8868\u91cc"
                   "<b>\u4e00\u6b21\u90fd\u6ca1\u88ab\u7528\u5230</b>\u3002"
                   "\u62ff\u8fd9\u4efd <code>.v</code> \u505a\u95e8\u7ea7\u4eff\u771f\uff0c"
                   "\u4e24\u6839\u6839\u5e38\u91cf\u7f51\u662f\u60ac\u7a7a\u7684\uff0c"
                   "<code>rst_n</code> \u4e0e\u6240\u6709 tie \u90fd\u662f <code>x</code>\uff1b"
                   "\u800c\u7248\u56fe\u6309\u5e38\u91cf\u4f20\u64ad\u63a5\u5230\u4e86\u7535\u6e90\u8f68\u3002"
                   "<b>\u7f51\u8868\u4e0e\u7845\u5728\u8fd9\u4e00\u9879\u4e0a\u4e0d\u4e00\u81f4\uff0c\u4e14\u7f51\u8868\u81ea\u8eab\u4e0d\u81ea\u6d3d\u3002</b>"))
    p1.append("<h4>\u4fee\u590d\u5c1d\u8bd5\uff1a\u505a\u4e86\u4e00\u6b21\uff0c\u7ed3\u8bba\u662f\u300c\u4e0d\u80fd\u90a3\u6837\u4fee\u300d</h4>")
    p1.append(tbl(["\u5c1d\u8bd5", "\u6539\u6cd5", "v2lvs", "LVS \u7ed3\u679c"], [
        ["\u7b2c 1 \u7248", "\u81ea\u52a8\u6362\u884c\u4e22\u4e86\u7aef\u53e3\u8868\u7684\u9017\u53f7",
         b("rc=1\uff0c\u65e0 CDL", 2),
         "\u672a\u8dd1\uff08<b>\u5224\u636e\u662f\u8f93\u51fa\u6587\u4ef6\u4e0d\u5b58\u5728\uff0c\u4e0d\u662f\u8fd4\u56de\u7801</b>\uff09"],
        ["\u7b2c 2 \u7248",
         "\u628a <code>HFSNET_*</code> <b>\u5168\u90e8</b>\u6539\u6210 <code>1&#39;b1</code>",
         "rc=0\uff0cCDL \u91cc HFSNET=0",
         b("\u4ecd INCORRECT\uff0cVDD \u53d8\u6210 637 vs 2063", 2)],
    ]))
    p1.append(note("<b>\u7b2c 2 \u7248\u628a VDD \u8fde\u63a5\u6570\u4ece 161 \u62ac\u5230 2063 = \u6539\u9519\u4e86</b>\uff1a"
                   "<code>HFSNET_8</code> \u662f\u5e38\u91cf\u6839\uff0c\u5176\u4f59\u662f\u7ecf\u8fc7 85 \u4e2a\u53cd\u76f8\u5668\u7684"
                   "<b>\u53cd\u76f8\u526f\u672c</b>\uff0c\u5168\u63a5 VDD \u7b49\u4e8e\u628a 85 \u4e2a\u53cd\u76f8\u5668\u7684\u8f93\u51fa\u4e5f\u77ed\u5230 VDD\u3002"
                   "\u62a5\u544a\u7ed9\u51fa\u7684\u53cd\u4f8b\u4e00\u773c\u53ef\u8fa8\uff1a"
                   "<code>Y: VDD</code> \u4e24\u8fb9\u90fd\u5bf9\uff0c\u800c <code>A</code> \u7248\u56fe\u4fa7\u662f "
                   "<code>300</code>\u3001\u6e90\u4fa7\u53d8\u6210\u4e86 <code>VDD</code>\u3002"
                   "<b>\u628a\u5f00\u5173\u5168\u62e7\u5230\u4e00\u8fb9\u4e0d\u662f\u4fee\u590d\uff0c\u662f\u53e6\u4e00\u4e2a\u9519\u8bef\u3002</b>"))
    p1.append("<h4>\u6b63\u786e\u7684\u4fee\u6cd5\uff08\u5df2\u786e\u5b9a\uff0c\u4e0b\u4e00\u8f6e\u6267\u884c\uff09</h4>")
    p1.append("<ul>"
              "<li><b>\u53ea\u628a\u6ca1\u6709\u9a71\u52a8\u7684\u300c\u6839\u300d\u7f51\u7edc\u63a5\u5e38\u91cf</b>"
              "\uff08<code>HFSNET_8</code> \u2192 <code>1&#39;b0</code>\uff0c"
              "<code>HFSNET_119</code> \u5f85\u5b9a\uff09\uff0c"
              "\u8ba9 85 \u4e2a <code>HFSINV</code> \u901a\u8fc7\u771f\u5b9e\u53cd\u76f8\u5668\u628a\u503c\u4f20\u4e0b\u53bb\uff1b</li>"
              "<li><b>\u66f4\u6839\u672c\uff1a\u8ba9\u7f51\u8868\u91cd\u65b0\u5bfc\u51fa\u4ee5\u5339\u914d\u7248\u56fe</b> "
              "\u2014\u2014 \u65e2\u7136\u7248\u56fe\u5df2\u505a\u5e38\u91cf\u4f20\u64ad\uff0c"
              "<code>.v</code> \u5c31\u4e0d\u8be5\u518d\u5e26 <code>HFSINV</code> \u4e0e <code>HFSNET</code>\u3002"
              "\u8fd9\u4e5f\u662f\u4ea4\u4ed8\u4ef6\u5e94\u8be5\u6709\u7684\u6837\u5b50\u3002</li>"
              "</ul>")
    p1.append(note("<b>\u53e6\u4e00\u4e2a\u672c\u8f6e\u5fc5\u987b\u6807\u4e3a\u672a\u51b3\u7684\u91cf</b>\uff1a\u65b0\u5199\u7684\u5b9e\u4f8b census \u7ed9\u51fa"
                   "\u4ea4\u4ed8\u7f51\u8868 <b>3626 \u4e2a\u5b9e\u4f8b / 109 \u79cd</b>\u3001"
                   "\u7248\u56fe\u62bd\u53d6 <b>3606 / 89 \u79cd</b>\uff0c\u5dee\u7684 20 \u4e2a\u662f"
                   "<b>20 \u79cd\u5404 1 \u4e2a</b>\u3002\u4f46\u8fd9\u4e0e\u7b2c 5 \u8f6e\u5b9e\u6d4b"
                   "\uff08GDS \u9876\u5c42 3626 \u4e2a\u653e\u7f6e / 109 \u79cd = \u5c55\u5e73\u7f51\u8868 3626 / 109 \u79cd\uff0c"
                   "\u9010\u9879\u96f6\u5dee\uff09<b>\u76f4\u63a5\u77db\u76fe</b>\uff0c\u800c\u4e14"
                   "\u672c\u8f6e\u4e3a\u6b64\u5199\u7684 GDS \u7ed3\u6784\u63a2\u9488<b>\u6ca1\u901a\u8fc7\u81ea\u5df1\u7684\u5bf9\u7167</b>"
                   "\uff08\u5bf9\u7167\u7ec4 <code>NAND2XL</code>\u3001<code>DFFSXL</code> \u660e\u660e\u6709\u51e0\u4f55\u5374\u88ab\u62a5\u6210 "
                   "<code>elements=0</code>\uff09\u2014\u2014 <b>\u63a2\u9488\u65e0\u6548\uff0c\u6240\u4ee5\u8fd9\u4e00\u6761\u672c\u8f6e\u4e0d\u5916\u63a8\u3002</b>"
                   "\u4e0b\u4e00\u8f6e\u7528\u7b2c\u4e09\u79cd\u72ec\u7acb\u53e3\u5f84\u88c1\u5b9a\uff0c"
                   "\u5224\u636e\u662f<b>\u5148\u8ba9\u5bf9\u7167\u7ec4\u7ed9\u51fa\u5df2\u77e5\u6b63\u786e\u7684\u6570</b>\u3002"))
'''

t = t[:i] + NEW + t[j:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("1.7 block replaced, new length %d" % len(t))
