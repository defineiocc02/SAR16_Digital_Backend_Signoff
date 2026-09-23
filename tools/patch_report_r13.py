#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round 13: 1.10 (correlation test of the boundary-port explanation) and 1.11 (F3:
the parent-wrapper route is now tried and negative), plus a correction to B.3."""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

NEW = r'''    p1.append("<h3>1.10 \u8fb9\u754c\u7aef\u53e3\u5047\u8bbe\u7684\u76f8\u5173\u6027\u68c0\u9a8c\uff08\u7b2c 13 \u8f6e\uff09</h3>")
    p1.append("<p>1.9 \u8282\u8bf4\u300c50 \u6761 incorrect nets \u6765\u81ea 15 \u4e2a\u591a\u7aef\u53e3\u5355\u5143\u7684\u914d\u5bf9\u6b67\u4e49\u300d\u3002"
              "\u628a\u6bcf\u6761 incorrect net \u4e0a\u7684\u5668\u4ef6\u7c7b\u578b\u644a\u5f00\uff0c\u770b\u5b83\u662f\u5426\u771f\u7684\u90fd\u8e29\u5728\u90a3 15 \u4e2a master \u4e0a\uff1a</p>")
    p1.append(tbl(["\u68c0\u9a8c", "\u7ed3\u679c"], [
        ["incorrect nets \u603b\u6570", "50"],
        ["**\u81f3\u5c11\u8e29\u4e2d\u4e00\u4e2a\u53d7\u5f71\u54cd master**", b("**42 / 50**", 1)],
        ["\u4e00\u4e2a\u90fd\u6ca1\u8e29\u4e2d", "8"],
    ]))
    p1.append(note("\u51fa\u73b0\u6700\u591a\u7684\u5c31\u662f\u591a\u7aef\u53e3\u6700\u4e25\u91cd\u7684\u90a3\u51e0\u4e2a\uff1a"
                   "<code>TLATNXL</code>\uff082 \u4e2a\u591a\u51fa\u7aef\u53e3\uff09\u51fa\u73b0\u5728 <b>14</b> \u6761\u7f51\u4e0a\uff0c"
                   "<code>DFFSX1</code>\u3001<code>AOI21XL</code>\u3001<code>DFFSXL</code>\u3001<code>DFFSX2</code> \u5404\u81ea\u6210\u7247\u51fa\u73b0\u3002"
                   "\u800c\u5269\u4e0b 8 \u6761\u7684\u5668\u4ef6\u6e05\u5355\u91cc\u4ecd\u51fa\u73b0 <code>MP(P18)</code> \u7b49\u677e\u6563\u5668\u4ef6\uff0c"
                   "\u4e0e\u62a5\u544a\u5bf9\u6bcf\u6761\u7f51\u7684\u5668\u4ef6\u5217\u8868\u6709\u622a\u65ad\u76f8\u4e00\u81f4\uff0c"
                   "\u6240\u4ee5\u8fd9 8 \u6761<b>\u4e0d\u6784\u6210\u53cd\u8bc1</b>\uff0c\u4f46\u4e5f\u4e0d\u80fd\u8bf4\u5b83\u4eec\u5df2\u88ab\u89e3\u91ca\u3002"))
    p1.append("<h3>1.11 F3\uff08\u5757\u81ea\u8eab abstract\uff09\uff1a\u6700\u540e\u4e00\u4e2a\u5019\u9009\u8def\u5f84\u4e5f\u5df2\u6392\u9664</h3>")
    p1.append("<p>\u7b2c 5 \u8f6e\u7559\u4e0b\u7684\u552f\u4e00\u672a\u8bd5\u5019\u9009\u662f\u300c\u5148\u9020\u7236\u5c42 wrapper \u4f8b\u5316\u672c\u5757\uff0c\u518d\u4ece\u7236\u5c42\u8c03 "
              "<code>create_abstract</code>\u300d\u3002\u672c\u8f6e\u8dd1\u4e86\uff086 s\uff0crc=0\uff0c\u65e5\u5fd7 7 097 B\uff09\uff1a</p>")
    p1.append(tbl(["\u6b65\u9aa4", "\u7ed3\u679c"], [
        ["<code>open_lib pnr/sar16_pnr_paper_core</code>", "OK"],
        ["<code>get_blocks</code> / <code>get_designs</code>", b("\u8fd4\u56de\u7a7a", 2)],
        ["<code>current_design sar_digi_paper_core</code>", b("FAIL", 2)],
        ["<code>create_block sar16_wrap_top</code>", "OK"],
        ["<code>create_cell U_DUT sar_digi_paper_core</code>", "OK\uff08\u5757\u80fd\u88ab\u5f15\u7528\uff09"],
        ["<code>create_abstract -blocks sar_digi_paper_core</code>", b("FAIL", 2)],
        ["<code>create_abstract -all_blocks</code>", b("FAIL \u2192 0", 2)],
        ["<code>write_lef -design sar16_wrap_top</code>", "3 709 B\uff0c<b><code>MACRO sar*</code> = 0</b>"],
        ["<code>write_lef -design sar_digi_paper_core</code>",
         "179 596 B\uff0c<b><code>MACRO sar*</code> = 0</b>\uff08\u4e0e\u7b2c 5 \u8f6e <code>-design</code> \u53d8\u4f53\u5b57\u8282\u6570\u76f8\u540c\uff09"],
    ]))
    p1.append(note("<b>\u7ed3\u8bba</b>\uff1a\u5728 FC W-2024.09-SP3 + \u672c\u9879\u76ee\u5e93\u8bbe\u7f6e\u4e0b\uff0c"
                   "\u300c\u9876\u5c42\u5757 + \u65e0\u7236\u5c42\u300d\u4e0e\u300c\u9020\u7236\u5c42 wrapper\u300d<b>\u4e24\u6761\u8def\u90fd\u4e0d\u4ea7\u51fa\u5757\u81ea\u8eab abstract</b>\u3002"
                   "\u7b2c 5 \u8f6e\u7684\u516d\u4e2a <code>write_lef</code> \u53d8\u4f53 + <code>create_abstract</code> \u4e24\u79cd\u8c03\u7528\u65b9\u5f0f\uff0c"
                   "\u5171 <b>8 \u6761\u8def\u5f84\u5168\u90e8\u4e3a\u8d1f</b>\u3002"
                   "\u21d2 <b>LEF \u4e0d\u80fd\u4f5c\u4e3a\u8be5\u5757\u7684\u96c6\u6210 abstract\uff0c\u8fd9\u662f\u672c\u6d41\u7a0b/\u672c\u7248\u672c\u7684\u786e\u5b9a\u6027\u7ed3\u8bba\uff0c"
                   "\u4e0d\u518d\u662f\u300c\u672a\u9a8c\u8bc1\u300d\u3002</b>"))
    p1.append(note("<b>\u65b9\u6cd5\u8bb0\u5f55</b>\uff1a\u4e0a\u4e00\u6b21\u88f8\u8c03 <code>fc_shell</code> \u65e5\u5fd7\u662f 0 \u5b57\u8282\u3001\u88ab\u8bef\u5224\u4e3a\u300c\u6ca1\u8dd1\u8d77\u6765\u300d\u3002"
                   "\u771f\u56e0\u662f <b>fc_shell \u5728\u975e tty \u4e0b\u7f13\u51b2 stdout\uff0c\u88ab kill \u65f6\u7f13\u51b2\u5168\u4e22</b>\uff0c"
                   "\u52a0 <code>stdbuf -oL</code> \u540e\u540c\u4e00\u4e2a\u811a\u672c <b>22 s \u6b63\u5e38\u8dd1\u5b8c</b>\u3002"
                   "\u53e6\uff1a<code>run_pnr_paper_core.sh</code> \u5f00\u5934\u6709 <code>rm -rf $PRJ/pnr</code>\uff0c"
                   "**\u60f3\u590d\u7528\u5b83\u7684\u73af\u5883\u5c31\u4f1a\u5220\u6389 P&R \u4ea7\u7269** \u2014\u2014 \u672c\u8f6e\u6539\u4e3a\u76f4\u63a5\u8c03 "
                   "<code>fc_shell</code>\uff0c\u9879\u76ee\u6811 mtime \u626b\u63cf\u786e\u8ba4\u96f6\u5199\u5165\u3002"))
'''

A = '    # ---- P2 \u65f6\u5e8f ----'
i = t.find(A)
assert i > 0
t = t[:i] + NEW + t[i:]

# --- B.3 / B.4 boundary: record that the last F3 candidate is now negative ---
B4 = '    pb.append("<h3>B.4 '
j = t.find(B4)
print("1.10/1.11 at %d, B.4 at %d" % (i, j))
assert j > i
FLAG = r'''    pb.append(note("<b>F3 \u72b6\u6001\u66f4\u65b0\uff08\u7b2c 13 \u8f6e\uff09</b>\uff1a"
                   "\u4e0a\u9762\u5199\u7684\u300c\u552f\u4e00\u672a\u8bd5\u7684\u5019\u9009\u662f\u9020\u7236\u5c42 wrapper\u300d"
                   "<b>\u5df2\u7ecf\u8bd5\u8fc7\uff0c\u7ed3\u679c\u4e3a\u8d1f</b>\uff1a"
                   "<code>create_block</code> + <code>create_cell U_DUT sar_digi_paper_core</code> \u90fd\u6210\u529f\uff0c"
                   "\u4f46 <code>create_abstract -blocks/-all_blocks</code> \u5747\u5931\u8d25\uff0c"
                   "<code>write_lef -design sar16_wrap_top</code> \u53ea\u6709 3 709 B \u4e14 "
                   "<code>MACRO sar*</code> = 0\u3002"
                   "\u21d2 \u5171 <b>8 \u6761\u8def\u5f84\u5168\u90e8\u4e3a\u8d1f</b>\uff0c"
                   "\u8be6\u89c1 1.11\u3002"))
'''
t = t[:j] + FLAG + t[j:]

io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("updated, new length %d" % len(t))
