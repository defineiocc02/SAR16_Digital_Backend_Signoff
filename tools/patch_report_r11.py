#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round 11: insert 1.7.1 (two self-corrections) and 1.8 (the tie hypothesis is
falsified; what the LVS residual really is) before the P2 anchor.

Written with a RAW string so that every \\n I type stays a backslash-n in the
generated source -- the round-10 first attempt interpreted them itself and broke the
generator.  Apostrophes inside generated literals are written as &#39;.
"""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

ANCHOR = '    # ---- P2 \u65f6\u5e8f ----'
i = t.find(ANCHOR)
print("anchor at %d" % i)
assert i > 0

NEW = r'''    p1.append("<h3>1.7.1 \u81ea\u6211\u66f4\u6b63\uff08\u7b2c 11 \u8f6e\uff09\u2014\u2014 \u4e0a\u4e00\u8282\u6709\u4e24\u6761\u7ed3\u8bba\u662f\u9519\u7684</h3>")
    p1.append(tbl(["\u7b2c 10 \u8f6e\u7684\u8bf4\u6cd5", "\u5b9e\u6d4b", "\u88c1\u5b9a"], [
        ["\u300c\u7248\u56fe\u91cc\u6ca1\u6709 <code>HFSNET</code> / <code>HFSINV</code>\u300d",
         "SPEF\uff086 958 499 B\uff0cFC \u4ece\u540c\u4e00\u6570\u636e\u5e93\u5199\u51fa\u7684\u5bc4\u751f\u7f51\u8868\uff09\u91cc "
         "<b>HFSINV 85 \u884c / 85 \u4e2a\u5e26\u540d\u5b9e\u4f8b</b>\u3001<b>HFSNET 147 \u884c</b>",
         b("\u6211\u9519\u4e86", 2)],
        ["\u300c20 \u4e2a\u53ea\u6709\u7f51\u8868\u6709\u7684\u5355\u5143 / 3606 vs 3626\u300d",
         "Calibre \u81ea\u5df1\u7684\u5bf9\u7167\u8868\u5171 93 \u884c\uff0c"
         "<b>\u5355\u5143\u7c7b\u578b\u9010\u884c\u5168\u90e8\u76f8\u7b49</b>\uff1b\u552f\u4e00\u4e0d\u7b49\u662f "
         "<code>MP 95 vs 98</code> \u4e0e <code>Nets \u221231</code>",
         b("\u6211\u9519\u4e86", 2)],
    ]))
    p1.append(note("<b>\u4e3a\u4ec0\u4e48\u4f1a\u9519</b>\uff1a<code>HFSNET=0</code> \u8bf4\u7684\u662f\u300c\u540d\u5b57\u6ca1\u4fdd\u7559\u300d\uff0c"
                   "\u4e0d\u662f\u300c\u4e1c\u897f\u4e0d\u5728\u300d\u2014\u2014 "
                   "Calibre \u62bd\u53d6\u4f1a\u628a\u7f51\u7edc\u6539\u540d\u6210\u6570\u5b57\uff08<code>300</code>\u3001<code>637</code>\uff09\u3001"
                   "\u628a\u5b9e\u4f8b\u6539\u540d\u6210 <code>X7/X184</code>\u3002"
                   "<b>\u62ff\u300c\u540d\u5b57\u8ba1\u6570\u300d\u5f53\u300c\u5b58\u5728\u6027\u5224\u636e\u300d\u662f\u5224\u636e\u7528\u9519\u4e86\u4e00\u4fa7\u3002</b>"
                   "\u540c\u4e00\u7c7b\u9519\u8bef\u8fd9\u4e2a\u9879\u76ee\u5df2\u7ecf\u72af\u8fc7\u4e00\u6b21\u3002"))
    p1.append("<h4>tie \u94fe\u7684\u771f\u5b9e\u7ed3\u6784\uff08\u73b0\u5728\u662f\u786e\u8bc1\u7684\uff09</h4>")
    p1.append('<pre>HFSNET_8 (\u5b50\u5c42\u7aef\u53e3)  &lt;--  HFSNET_124 (\u7236\u5c42\u7f51\u7edc\uff0c\u65e0\u9a71\u52a8)\n'
              '        |\n'
              '        +-- HFSINV_6951_589 (.A=HFSNET_124 , .Y=HFSNET_119) --&gt; rst_n (u_calib_ctrl / u_srm_residue)\n'
              '        +-- \u53e6\u5916 84 \u4e2a HFSINV (.A=HFSNET_8) --&gt; HFSNET_4/6/9/... --&gt; \u5404 DFFSX* \u7684 SN</pre>')
    p1.append(tbl(["\u9879", "\u5b9e\u6d4b"], [
        ["\u88ab\u5f15\u7528\u7684 <code>HFSNET</code> \u7f51\u7edc", "139"],
        ["\u5176\u4e2d\u88ab\u67d0\u4e2a <code>.Y</code> \u9a71\u52a8", "133"],
        ["<b>\u6ca1\u6709\u9a71\u52a8\u7684\u6839\u7f51\u7edc</b>",
         b("6\uff1aHFSNET_8\u3001330\u3001346\u3001362\u3001363\u3001364", 2)],
        ["<code>HFSNET_8</code> \u4f5c\u4e3a <code>.Y</code>", "0"],
    ]))
    p1.append("<h3>1.8 tie \u5047\u8bbe\u88ab\u8bc1\u4f2a\uff1a\u63a5\u4e0a\u6839\u7f51\u7edc\u51e0\u4e4e\u4e0d\u6539\u53d8\u4efb\u4f55\u4e1c\u897f</h3>")
    p1.append("<p>\u53ea\u63a5\u90a3 6 \u6839\u6ca1\u6709\u9a71\u52a8\u7684\u6839\u7f51\u7edc\uff0885 \u4e2a <code>HFSINV</code> \u7684\u771f\u5b9e\u8fde\u7ebf\u4e00\u5f8b\u4e0d\u52a8\uff09\uff0c"
              "\u91cd\u65b0 v2lvs + \u8dd1 LVS\uff08\u9ed1\u76d2 + <code>INJECT LOGIC NO</code>\uff09\uff1a</p>")
    p1.append(tbl(["\u53d8\u4f53", "\u6539\u6cd5", "\u6e90\u4fa7 VDD \u8fde\u63a5\u6570", "\u7248\u56fe\u4fa7 VDD", "LVS"], [
        ["\u57fa\u7ebf", "\u4e0d\u6539\uff08\u6839\u60ac\u7a7a\uff09", "161", "637", "INCORRECT"],
        ["<b>L1</b>", "6 \u6839 \u2192 <code>1&#39;b0</code>", b("161", 2), "637", "INCORRECT"],
        ["<b>L2</b>", "6 \u6839 \u2192 <code>1&#39;b1</code>", b("262", 1), "637", "INCORRECT"],
        ["<b>L3</b>", "6 \u6839 \u2192 <code>1&#39;b0</code>\uff0c<code>HFSNET_119</code> \u2192 <code>1&#39;b1</code>",
         "161", "637", "INCORRECT"],
        ["\u7b2c 10 \u8f6e\u90a3\u6b21", "\u5168\u90e8 <code>HFSNET</code> \u2192 <code>1&#39;b1</code>", "2063", "637", "INCORRECT"],
    ]))
    p1.append(note("<b>\u8bfb\u6cd5</b>\uff1aL1 \u4e0e\u57fa\u7ebf<b>\u9010\u4f4d\u76f8\u540c</b>\uff0cL2 \u53ea\u628a 161 \u62ac\u5230 262\uff0c"
                   "<code>MP 95 vs 98</code>\u3001<code>Nets 4753 vs 4784</code>\u3001\u9519\u8bef\u7c7b\u578b\u96c6\u5408"
                   "<b>\u5168\u90fd\u4e00\u5b57\u4e0d\u53d8</b>\u3002"
                   "\u21d2 <b>tie \u94fe\u4e0d\u662f\u8fd9\u6761 LVS \u6b8b\u5dee\u7684\u539f\u56e0\u3002</b>"
                   "\u7b2c 10 \u8f6e\u628a\u5b83\u5f53\u6210\u300c\u6700\u540e\u4e00\u4e2a LVS \u9519\u8bef\u7684\u771f\u56e0\u300d\u662f"
                   "<b>\u8fc7\u5ea6\u5f52\u56e0</b>\uff0c\u672c\u8f6e\u64a4\u56de\u8be5\u5b9a\u8bba\u3002"
                   "\u5b83\u4ecd\u7136\u662f\u4e00\u4e2a<b>\u771f\u5b9e\u7684\u4ea4\u4ed8\u4ef6\u7f3a\u9677</b>"
                   "\uff08\u5e38\u91cf\u6839\u6ca1\u5199\u51fa\u6765\u3001<code>rst_n</code> \u5728\u7f51\u8868\u91cc\u8d70\u7684\u662f\u53cd\u76f8\u5668\u94fe"
                   "\u800c\u4e0d\u662f\u9876\u5c42\u7aef\u53e3\uff09\uff0c<b>\u4f46\u4e0d\u662f LVS \u4e0d\u6536\u655b\u7684\u539f\u56e0\u3002</b>"))
    p1.append("<h4>\u7b2c 11 \u8f6e\u4e4b\u540e\uff0cLVS \u6b8b\u5dee\u7684\u51c6\u786e\u63cf\u8ff0</h4>")
    p1.append(tbl(["\u9879", "\u7248\u56fe", "\u6e90", "\u5dee"], [
        ["Ports", "178", "178", b("0 \u2713", 0)],
        ["\u5355\u5143\u7c7b\u578b\u9010\u884c\uff08\u62a5\u544a 93 \u884c\uff09", "\u2014", "\u2014", b("\u5168\u90e8\u76f8\u7b49 \u2713", 0)],
        ["Nets", "4753", "4784", "\u221231"],
        ["MP (4 pins)", "95", "98", "\u22123"],
        ["VDD \u8fde\u63a5\u6570", "637", "161", "\u2212476"],
    ]))
    p1.append(note("<b>\u4e0b\u4e00\u6b65\u65b9\u5411\uff08\u4e0d\u518d\u5f80 tie \u94fe\u4e0a\u627e\uff09</b>\uff1a"
                   "\uff08a\uff09\u90a3 3 \u4e2a\u53ea\u5728\u6e90\u4fa7\u5b58\u5728\u7684 MP \u5355\u7ba1\uff08ICV \u5757\u91cc\u7684\u677e\u6563\u5668\u4ef6\uff09\uff1b"
                   "\uff08b\uff0931 \u6761\u7f51\u5dee\u7684\u5177\u4f53\u5bf9\u8c61"
                   "\uff08<code>lvsF_boxed_injectno.rep</code> \u7684 INCORRECT NETS \u6bb5\uff09\uff1b"
                   "\uff08c\uff09VDD \u8fde\u63a5\u6570\u7684\u7edf\u8ba1\u53e3\u5f84"
                   "\uff08<code>LVS CELL SUPPLY NO</code> \u4e0b\u5355\u5143\u7535\u6e90\u5f15\u811a\u7b97\u4e0d\u7b97\u3001\u4e24\u8fb9\u662f\u5426\u540c\u4e00\u53e3\u5f84\uff09\u3002"))
'''

t = t[:i] + NEW + t[i:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("inserted, new length %d" % len(t))
