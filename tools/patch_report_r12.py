#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round 12: append 1.9 -- the remaining LVS residual traced to 23 extra unlabeled
boundary ports on 15 cell masters."""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

ANCHOR = '    # ---- P2 \u65f6\u5e8f ----'
i = t.find(ANCHOR)
print("anchor at %d" % i)
assert i > 0

NEW = r'''    p1.append("<h3>1.9 LVS \u6b8b\u5dee\u7684\u6700\u540e\u4e00\u4e2a\u771f\u56e0\uff08\u7b2c 12 \u8f6e\uff09\uff1a"
              "<b>\u5355\u5143\u591a\u51fa 23 \u4e2a\u65e0\u6807\u6ce8\u8fb9\u754c\u7aef\u53e3</b></h3>")
    p1.append("<p>\u628a\u62a5\u544a\u7684 INCORRECT NETS \u9010\u6761\u644a\u5f00\uff0c\u51fa\u73b0\u4e00\u4e2a\u51b3\u5b9a\u6027\u7279\u5f81\uff1a</p>")
    p1.append(tbl(["disc", "\u7248\u56fe\u7f51\u540d", "\u6e90\u4fa7\u7f51\u540d", "\u7248\u56fe\u8fde\u63a5\u6570", "\u6e90\u8fde\u63a5\u6570"], [
        ["1", "<code>VDD</code>", "<code>VDD</code>", b("637", 2), b("161", 2)],
        ["2", "<code>CALIB_OVERRANGE_BITS[10]</code>", "\u540c\u540d", "3", b("3", 0)],
        ["4", "<code>X0/270</code>", "<code>Xu_calib_ctrl/n1112</code>", "7", b("7", 0)],
        ["18", "<code>347</code>", "<code>Xu_calib_ctrl/ZCTSNET_39\u2026</code>", "47", b("47", 0)],
        ["23", "<code>407</code>", "<code>Xu_calib_ctrl/net1766</code>", "27", b("27", 0)],
        ["24", "<code>890</code>", "<code>Xu_calib_ctrl/wr_idx_r[1\u2026</code>", "14", b("14", 0)],
        ["\u2026 4\u201350", "(\u540c\u5f62)", "", "", ""],
    ]))
    p1.append(note("<b>50 \u6761\u91cc 48 \u6761\u4e24\u8fb9\u8fde\u63a5\u6570\u9010\u4e00\u76f8\u7b49</b>\uff0c\u8fde\u540d\u5b57\u90fd\u4e00\u6837\u7684 "
                   "<code>CALIB_OVERRANGE_BITS[10]</code> \u4e5f\u88ab\u5224 incorrect\u3002"
                   "\u8fde\u63a5\u6570\u76f8\u7b49 + \u5224 incorrect = <b>\u914d\u5bf9/\u547d\u540d\u5c42\u9762\u7684\u95ee\u9898\uff0c\u4e0d\u662f\u62d3\u6251\u95ee\u9898\u3002</b>"))
    p1.append("<h4>\u591a\u51fa\u6765\u7684\u7aef\u53e3\u662f\u5355\u5143\u5185\u90e8\u8282\u70b9</h4>")
    p1.append("<pre>.SUBCKT DFFSX1 CK D 3 SN 5 QN VSS Q VDD\n"
              "** N=24 EP=9 IP=0 FDC=34\n"
              "M2  3 12 15 VSS n18 ...\n"
              "M3  16 11 3 VSS n18 ...\n"
              "M15 5 14 VSS VSS n18 ...\n"
              "M16 Q 5 VSS VSS n18 ...</pre>")
    p1.append(note("<code>DFFSX1</code> \u7684<b>\u903b\u8f91\u7aef\u53e3\u5e94\u4e3a 7 \u4e2a</b>"
                   "\uff08<code>CK D SN QN VSS Q VDD</code>\uff09\uff0c\u62bd\u53d6\u7ed3\u679c\u5374\u662f <b>9 \u4e2a</b>\uff1b"
                   "\u591a\u51fa\u7684 <code>3</code> \u548c <code>5</code> \u5728\u4f53\u5185\u662f<b>\u5185\u90e8\u8282\u70b9</b>"
                   "\uff08<code>3</code> \u51fa\u73b0\u5728 M2/M3/M6/M19/M20/M23\uff0c<code>5</code> \u51fa\u73b0\u5728 M15/M16\uff09\u3002"
                   "\u5934\u90e8 <code>EP=9 IP=0</code> \u8bf4\u660e Calibre \u628a\u5b83\u4eec\u5168\u5f53\u6210\u4e86\u5916\u90e8\u7aef\u53e3\u3002"))
    p1.append(tbl(["\u5355\u5143", "\u62bd\u53d6\u7aef\u53e3\u6570", "\u5176\u4e2d\u65e0\u6807\u6ce8", "\u65e0\u6807\u6ce8\u7684\u540d\u5b57"], [
        ["<code>CMPR32X1</code>", "11", "4", "<code>3 5 6 7</code>"],
        ["<code>DFFSXL</code>", "10", "3", "<code>3 4 6</code>"],
        ["<code>DFFSX1</code> / <code>DFFSX2</code>", "9", "2", "<code>3 5</code> / <code>3 4</code>"],
        ["<code>TLATNXL</code>", "7", "2", "<code>2 4</code>"],
        ["\u5176\u4f59 11 \u4e2a\u5355\u5143", "6\u20138", "\u5404 1", "\u2014"],
        ["<b>\u5408\u8ba1</b>", "", b("15 \u4e2a master / 23 \u4e2a\u7aef\u53e3", 1), ""],
        ["<b>\u5bf9\u7167\uff1a\u7aef\u53e3\u540d\u5b8c\u5168\u5e72\u51c0\u7684 master</b>", "", b("123 \u4e2a", 0), ""],
    ]))
    p1.append(note("<b>\u4e3a\u4ec0\u4e48\u4e0e\u7b2c 5 \u8f6e\u7684\u5e93\u81ea\u6d3d\u6d4b\u8bd5\u4e0d\u77db\u76fe</b>\uff1a\u90a3\u4e2a\u5b9e\u9a8c\u7528\u7684\u662f kit GDS \u7684"
                   "<b>\u5177\u540d\u5305\u88c5 cell</b>\uff08\u8f6e\u5ed3 + TEXT \u5f15\u811a\u540d + 1 \u4e2a SREF \u2192 \u5185\u90e8\u54c8\u5e0c\u540d cell\uff09\uff0c"
                   "\u5305\u88c5\u5c42\u7684\u7aef\u53e3\u6b63\u597d\u662f\u903b\u8f91\u7684 7 \u4e2a\uff1b"
                   "\u800c\u6211\u4eec\u7684\u5408\u5e76 GDS \u5728\u62bd\u53d6\u65f6\u90a3\u4e00\u5c42\u88ab<b>\u6298\u53e0</b>\u6389\u4e86\uff0c"
                   "\u76f4\u63a5\u62bd\u5230\u4e86\u5185\u5c42 cell\uff0c\u4e8e\u662f\u5185\u90e8\u8282\u70b9\u66b4\u9732\u6210\u7aef\u53e3\u3002"
                   "**\u4e24\u6761\u7ed3\u8bba\u4e0d\u51b2\u7a81\uff1a\u4e00\u4e2a\u6d4b\u7684\u662f\u5305\u88c5\u5c42\uff0c\u4e00\u4e2a\u62bd\u7684\u662f\u5185\u5c42\u3002**"))
    p1.append("<h4>\u56e0\u6b64\u9700\u8981\u4fee\u6b63\u7684\u8bf4\u6cd5</h4>")
    p1.append(tbl(["\u4e4b\u524d\u8bf4\u8fc7", "\u73b0\u5728\u5e94\u6539\u4e3a"], [
        ["\u300c\u6b8b\u5dee\u662f\u624b\u6307\u5408\u5e76/\u5de5\u5177\u5e7b\u5f71\u300d\uff08\u7b2c 9 \u8f6e\uff09",
         "\u90a3\u89e3\u91ca\u7684\u662f <b>+660 \u5668\u4ef6\u5dee</b>\uff1b\u7f51\u8868/\u8fde\u63a5\u5c42\u9762\u7684\u6b8b\u5dee<b>\u53e6\u6709\u5176\u56e0</b>"],
        ["\u300ctie \u94fe\u662f\u6700\u540e\u4e00\u4e2a LVS \u9519\u8bef\u7684\u771f\u56e0\u300d\uff08\u7b2c 10 \u8f6e\uff09",
         "\u5df2\u8bc1\u4f2a\uff08\u7b2c 11 \u8f6e\uff09"],
        ["\u300c\u6b8b\u5dee\u662f\u5668\u4ef6\u8bb0\u8d26\u5dee\u300d",
         "\u6536\u655b\u4e3a\uff1a<b>15 \u4e2a master \u591a\u51fa 23 \u4e2a\u65e0\u6807\u6ce8\u8fb9\u754c\u7aef\u53e3 "
         "\u2192 \u7aef\u53e3\u914d\u5bf9\u6b67\u4e49 \u2192 ~50 \u6761\u540c\u8fde\u63a5\u6570\u7f51\u7edc\u88ab\u5224 incorrect</b>"],
    ]))
    p1.append(note("<b>\u5269\u4f59\u672a\u89e3\u91ca\u91cf</b>\uff1a<code>MP 95 vs 98</code>\uff08\u22123\uff09\u3001"
                   "<code>VDD 637 vs 161</code>\u3002\u8fd9\u4e24\u9879\u4e0e\u7aef\u53e3\u95ee\u9898<b>\u53ef\u80fd\u540c\u6e90</b>"
                   "\uff08<code>DFFSX*</code> \u7684 <code>SN</code> \u5728\u7248\u56fe\u63a5 VDD\u3001\u5728\u6e90\u4fa7\u8d70 tie \u53cd\u76f8\u5668\u94fe\uff0c"
                   "\u7aef\u53e3\u6b67\u4e49\u914d\u5bf9\u51c6\u4f1a\u8fde\u5e26\u5f71\u54cd\uff09\uff0c"
                   "\u4f46<b>\u672c\u8f6e\u6ca1\u505a\u80fd\u533a\u5206\u5b83\u4eec\u7684\u5b9e\u9a8c\uff0c\u6240\u4ee5\u4e0d\u4e0b\u7ed3\u8bba\u3002</b>"
                   "\u4e0b\u4e00\u8f6e\u7684\u660e\u786e\u52a8\u4f5c\uff1a<b>\u8ba9\u62bd\u53d6\u4fdd\u7559\u5305\u88c5\u5c42</b>"
                   "\uff08\u6216\u8ba9\u9876\u5c42\u4f8b\u5316\u5305\u88c5 cell \u800c\u4e0d\u662f\u5185\u5c42 cell\uff09\uff0c\u91cd\u8dd1 LVS\uff0c"
                   "\u770b 50 \u6761 incorrect nets \u662f\u5426\u968f\u4e4b\u6d88\u5931\u3002"))
'''

t = t[:i] + NEW + t[i:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("inserted, new length %d" % len(t))
