#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round 24: add 1.12.1 -- the handover starting point, refined by rounds 22-23, so the
next owner does not re-walk the two paths that were already falsified."""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

A = '    # ---- P2 \u65f6\u5e8f ----'
i = t.find(A)
assert i > 0

NEW = r'''    p1.append("<h4>1.12.1 \u4ea4\u63a5\u7ed9\u4e0b\u4e00\u4efb\u7684\u8d77\u70b9\uff08\u7ecf\u7b2c 22\u201323 \u8f6e\u4fee\u6b63\uff09</h4>")
    p1.append("<p>\u7b2c 22 \u8f6e\u628a\u90a3 9 \u6761\u7f51\u9010\u5f15\u811a\u644a\u5f00\uff0c\u5f62\u6001\u7ec8\u4e8e\u6e05\u695a\uff1a"
              "<b>\u7248\u56fe\u5728\u82e5\u5e72\u5904\u6bd4\u6e90\u4fa7\u591a\u5408\u5e76\u4e86\u7f51\u7edc</b>\u3002\u6700\u6e05\u695a\u7684\u4e00\u4f8b\uff1a</p>")
    p1.append("<pre>X1/X534(84.05,347.36)  NOR4BXL     Xu_calib_ctrl/XctmTdsLR_2_1933  NOR4BXL\n"
              "  Y:  X1/486                            Y:  Xu_calib_ctrl/tmp_net323\n"
              "  B:  X1/486                            ** Xu_calib_ctrl/tmp_net323 **\n"
              "  ** X1/486 **                          B:  Xu_calib_ctrl/n1186_CDR1</pre>")
    p1.append(note("\u7248\u56fe\u4fa7 <code>Y</code> \u4e0e <code>B</code> \u540c\u5728 <code>X1/486</code>\uff0c"
                   "\u6e90\u4fa7\u5206\u5c5e <code>tmp_net323</code> \u4e0e <code>n1186_CDR1</code>\u3002"
                   "\u8fd9\u4e0e\u300c\u7248\u56fe\u7f51\u8868\u6bd4\u6e90\u5c11 31 \u4e2a\u7f51\u300d\u65b9\u5411\u4e00\u81f4\u3002"))
    p1.append(note("<b>\u7b2c 23 \u8f6e\u53c8\u6392\u6389\u4e00\u6761\u9519\u8def</b>\uff1a\u90a3\u6279\u5668\u4ef6\u5c5e\u4e8e "
                   "<code>XctmTdsLR_*</code> \u5757\uff0c\u6e90\u4fa7\u6709 <b>486 \u4e2a\u4e00\u6b21\u6027\u5b9e\u4f8b</b>\uff0c"
                   "\u800c\u7248\u56fe\u62bd\u53d6\u91cc\u662f 0\u3002\u4f46\u62a5\u544a\u81ea\u5df1\u5df2\u628a\u4e24\u8fb9\u914d\u4e0a\u4e86\u5bf9"
                   "\uff08<code>X2/M34</code> \u2194 <code>Xu_calib_ctrl/XctmTdsLR_1_1905/M9</code>\uff09"
                   "\u21d2 <b>\u53c8\u662f\u300c\u6539\u540d\u300d\u800c\u4e0d\u662f\u300c\u7f3a\u5931\u300d</b>\u3002"
                   "\uff08\u540c\u4e00\u4e2a\u5751\u7b2c 11 \u8f6e\u8bb0\u8fc7\u4e00\u6b21\uff09"))
    p1.append(tbl(["\u5df2\u7ecf\u8d70\u4e0d\u901a\u7684\u8def", "\u7ed3\u8bba"], [
        ["\u67e5\u5668\u4ef6\u6570\u5dee\u5f52\u56e0\uff08\u624b\u6307\u5408\u5e76 / INJECT LOGIC / tie \u94fe\uff09",
         "\u90fd\u5df2\u5b9a\u91cf\u6216\u8bc1\u4f2a\uff08\u00a71.6\u2013\u00a71.8\uff09"],
        ["\u67e5\u5355\u5143\u662f\u5426\u7f3a\u5931 / \u672a\u9ed1\u76d2", "\u5df2\u5173\u95ed\uff08\u00a71.12\uff0c109 \u4e2a\u540d\u5b57\u96f6\u544a\u8b66\uff09"],
        ["\u67e5\u300c\u7248\u56fe\u91cc\u6ca1\u6709\u67d0\u4e2a\u540d\u5b57\u300d", "\u5df2\u8bc1\u660e\u4e0d\u53ef\u4f5c\u4e3a\u5224\u636e\uff08\u00a71.7.1\u3001\u00a71.12.1\uff09"],
    ]))
    p1.append(note("<b>\u5efa\u8bae\u7684\u4e0b\u4e00\u6b65\uff08\u8fd8\u6ca1\u6709\u4eba\u8d70\u8fc7\uff09</b>\uff1a\u4e0d\u8981\u518d\u67e5\u5668\u4ef6\u6570\u6216\u540d\u5b57\uff0c"
                   "\u76f4\u63a5\u9488\u5bf9 <code>XctmTdsLR_*</code> \u533a\u57df\u7684<b>\u7f51\u7edc\u5212\u5206</b>\u505a\u5355\u53d8\u91cf\u5b9e\u9a8c\u3002"
                   "\u6700\u76f4\u63a5\u7684\u4e00\u4e2a\uff1a\u5728 deck \u91cc\u628a\u62bd\u53d6\u4fa7\u7684\u5e76\u8054\u5408\u5e76\u5f00\u5173\u5173\u6389"
                   "\uff08<code>LVS REDUCE PARALLEL MOS NO</code>\uff09\u8dd1\u4e00\u6b21\uff0c"
                   "\u8ba9\u4e24\u8fb9\u90fd\u505c\u5728\u539f\u59cb\u5668\u4ef6\u7ea7\uff0c\u770b\u90a3 31 \u4e2a\u7f51\u7684\u5dee\u662f\u5426\u968f\u4e4b\u6539\u53d8 \u2014\u2014 "
                   "\u82e5\u4e0d\u53d8\uff0c\u8bf4\u660e\u7f51\u5dee<b>\u4e0d\u662f</b>\u5408\u5e76\u9020\u6210\u7684\uff0c\u65b9\u5411\u5c31\u5f97\u6362\uff1b"
                   "\u82e5\u53d8\uff0c\u5c31\u627e\u5230\u4e86\u673a\u5236\u3002\u8fd9\u662f\u4e00\u4e2a\u80fd\u76f4\u63a5\u5224\u771f\u5047\u7684\u5b9e\u9a8c\u3002"))
'''

t = t[:i] + NEW + t[i:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("inserted, new length %d" % len(t))
