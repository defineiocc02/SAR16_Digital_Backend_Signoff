#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round 9b: B.4 said the LVS error split was "尚未归因" and its parsed row was broken
("MP None").  Replace it with the measured table and make B.5 point at section 1.6."""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

A = '    pb.append("<h3>B.4 '
B = '    pb.append("<h3>B.5 '
i = t.find(A)
j = t.find(B)
print("B.4 at %d, B.5 at %d" % (i, j))
assert i > 0 and j > i

NEW = '''    pb.append("<h3>B.4 LVS \u9519\u8bef\u5206\u89e3\uff08\u7b2c 9 \u8f6e\u5df2\u5f52\u56e0\uff0c\u8be6\u89c1 1.6\uff09</h3>")
    pb.append(tbl(["\u53e3\u5f84", "\u57fa\u7ebf deck\uff08<code>INJECT LOGIC YES</code>\uff09",
                   "\u672c\u8f6e\u6700\u4f73\uff08<code>INJECT NO</code>\uff0b\u5355\u5143\u9ed1\u76d2\uff09"], [
        ["\u4e0d\u540c\u7aef\u53e3\u6570", "178 vs 179 \u2192 \u53d8\u6362\u540e 178 = 178", "178 = 178"],
        ["\u4e0d\u540c\u7f51\u8868\u6570", "12146 vs 12255\uff08\u2212109\uff09", "4753 vs 4784\uff08\u221231\uff09"],
        ["\u4e0d\u540c\u5668\u4ef6\u6570", "MN +306 / MP +354\uff0c\u539f\u59cb\u5408\u8ba1 <b>+660</b>",
         "<b>\u603b\u5668\u4ef6 3799 = 3799 \u76f8\u7b49</b>"],
        ["VDD \u8fde\u63a5\u6570", "14636 vs 13702\uff08+934\uff09", "\u2014\uff08\u5373 +660 \u7684\u53e6\u4e00\u79cd\u91cf\u6cd5\uff09"],
        ["incorrect nets", "50\uff08\u53d7 <code>LVS REPORT MAXIMUM 50</code> \u622a\u65ad\uff09",
         "<b>6</b> \u4e2a\u9519\u8bef\u7f51\u5757"],
    ]))
    pb.append(note("\u57fa\u7ebf\u7684\u56db\u4e2a\u9519\u8bef\u7c7b\uff08\u4e0d\u540c nets / \u4e0d\u540c instances / "
                   "connectivity / property\uff09\u6709\u4e00\u534a\u6765\u81ea kit deck \u7684 "
                   "<code>LVS INJECT LOGIC YES</code>\uff1b\u5173\u6389\u5b83\u4ee5\u540e\u5668\u4ef6\u603b\u6570\u7cbe\u786e\u76f8\u7b49\u3001"
                   "\u7aef\u53e3\u76f8\u7b49\u3001\u9ed1\u76d2\u540e\u6bcf\u4e2a\u5355\u5143\u7684\u5b9e\u4f8b\u6570\u9010\u4e2a\u76f8\u7b49\u3002"
                   "\u5269\u4e0b\u7684\u51c0\u5dee\u5f02\u662f<b>\u7248\u56fe\u7f51\u8868\u6bd4\u6e90\u5c11 109\uff08\u5e73\u94fa\uff09/ "
                   "31\uff08\u9ed1\u76d2\uff09\u4e2a\u7f51</b>\uff0c\u5f62\u6001\u4e0e\u5e76\u8054\u624b\u6307\u5408\u5e76\u4e00\u81f4\u3002"))
    pb.append("<h4>LEF \u8ba1\u6570\u5b9e\u6d4b\uff08\u672c\u8f6e\u91cd\u6570\uff0c\u542b\u7ed3\u6784\u81ea\u68c0\uff09</h4>")
    pb.append(tbl(["\u6587\u4ef6", "MACRO", "PIN", "\u7ed3\u6784\u81ea\u68c0", "\u5757\u81ea\u8eab MACRO"], [
        ["v5.1 <code>sar_digi_paper_core.lef</code>", "<b>109</b>", "<b>630</b>", "CLEAN", "<b>\u65e0</b>"],
        ["v5.0 <code>sar_digi_paper_core.lef</code>", "112", "651", "CLEAN", "<b>\u65e0</b>"],
        ["\u65e7\u4ea4\u4ed8 README \u58f0\u79f0", "115", "665", "\u2014", "\u65e0"],
    ]))
    pb.append(note("\u53e3\u5f84\uff1a<code>MACRO</code> = \u9876\u5c42 <code>MACRO &lt;name&gt;</code> \u5757\uff1b"
                   "<code>PIN</code> = \u5b8f\u5185\u7b2c\u4e00\u5c42 <code>PIN &lt;name&gt;</code> \u5757\uff1b"
                   "\u81ea\u68c0 = \u6bcf\u4e2a <code>END</code> \u90fd\u80fd\u6b63\u786e\u95ed\u5408\u3001\u5230 EOF \u6df1\u5ea6\u5f52\u96f6\u3002"
                   "\uff08<code>END &lt;name&gt;</code> \u4e5f\u7528\u6765\u6536 LAYER/SITE \u5757\uff0c"
                   "\u6240\u4ee5\u201c<code>END &lt;name&gt;</code> \u6761\u6570 = MACRO + PIN\u201d\u8fd9\u4e2a\u81ea\u68c0\u662f\u9519\u7684\uff0c"
                   "\u5df2\u6362\u6210\u4e25\u683c\u5757\u5d4c\u5957\u3002\uff09"
                   "\u65e7 README \u7684 115/665 \u5bf9\u4e0d\u4e0a\u4efb\u4f55\u4e00\u7248\u6587\u4ef6\u3002"))
'''

t = t[:i] + NEW + t[j:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("B.4 replaced, new length %d" % len(t))
