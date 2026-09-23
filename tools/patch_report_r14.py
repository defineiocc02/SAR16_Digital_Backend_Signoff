#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round 14: 1.10.1 -- the report cap was hiding 15 more incorrect nets; re-measure
the correlation with the cap raised."""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

A = '    p1.append("<h3>1.11 F3'
i = t.find(A)
print("1.11 at %d" % i)
assert i > 0

NEW = r'''    p1.append("<h4>1.10.1 \u628a\u62a5\u544a\u4e0a\u9650\u653e\u5f00\u540e\u7684\u590d\u6d4b\uff08\u7b2c 14 \u8f6e\uff09</h4>")
    p1.append("<p>\u4e0a\u9762\u7684 50 \u6761\u662f\u88ab <code>LVS REPORT MAXIMUM 50</code> \u622a\u65ad\u8fc7\u7684\u3002"
              "\u628a\u5b83\u6539\u6210 <b>500</b> \u540e\u91cd\u8dd1\uff0817 s\uff0c\u62a5\u544a 493 KB \u2192 <b>1 832 KB</b>\uff09\uff1a</p>")
    p1.append(tbl(["\u53e3\u5f84", "\u622a\u65ad\uff0850\uff09", "\u653e\u5f00\uff08500\uff09"], [
        ["incorrect nets \u6761\u6570", "50", b("**65**", 1)],
        ["\u81f3\u5c11\u8e29\u4e2d\u4e00\u4e2a\u53d7\u5f71\u54cd master", "42", b("**56**", 1)],
        ["\u4e00\u4e2a\u90fd\u6ca1\u8e29\u4e2d", "8", b("**9**", 2)],
        ["Ports / Nets / MP", "178 = 178 / 4753 vs 4784 / 95 vs 98", "\u9010\u4f4d\u76f8\u540c"],
    ]))
    p1.append(note("<b>\u8bfb\u6cd5</b>\uff1a\u6bd4\u4f8b\u7a33\u5b9a\u5728 <b>86 %</b>\uff0856/65\uff09\u2014\u2014 "
                   "\u539f\u6765\u90a3 50 \u6761\u786e\u5b9e\u662f\u88ab\u622a\u65ad\u7684\uff0c\u4f46<b>\u53e6\u5916 9 \u6761\u4e0d\u662f</b>\uff1a"
                   "\u5373\u4f7f\u628a\u5668\u4ef6\u5217\u8868\u653e\u5f00\uff0c\u5b83\u4eec\u4ecd\u7136\u4e00\u4e2a\u90fd\u4e0d\u8e29\u3002"
                   "\u8fd9 9 \u6761\u7684\u5668\u4ef6\u6e05\u5355\u91cc\u51fa\u73b0\u7684\u662f\u666e\u901a\u5355\u5143"
                   "\uff08<code>NAND2XL</code>\u3001<code>INVXL</code>\u3001<code>NOR4BXL</code>\u2026\uff09"
                   "\u52a0\u4e0a<b>\u677e\u6563\u5668\u4ef6</b> <code>MP(P18) x5</code>\u3001<code>MN(N18) x2</code>\u3002"))
    p1.append(note("<b>\u6240\u4ee5\u8fb9\u754c\u7aef\u53e3\u5047\u8bbe\u662f\u300c\u4e3b\u56e0\u300d\u800c\u4e0d\u662f\u300c\u5168\u90e8\u539f\u56e0\u300d</b>\uff1a"
                   "\u5b83\u89e3\u91ca\u4e86 86 %\u3002\u5269\u4e0b 9 \u6761\u4e0e\u677e\u6563\u5668\u4ef6\u6709\u5173\uff0c"
                   "\u800c\u677e\u6563\u5668\u4ef6\u6b63\u662f <code>MP 95 vs 98</code>\uff08\u22123\uff09\u90a3\u4e2a\u8ba1\u6570\u5dee\u7684\u540c\u4e00\u6279\u4e1c\u897f \u2014\u2014 "
                   "\u4e24\u8005<b>\u53ef\u80fd\u540c\u6e90</b>\uff0c\u4f46\u672c\u8f6e\u4ecd\u7136\u6ca1\u6709\u505a\u51fa\u80fd\u533a\u5206\u5b83\u4eec\u7684\u5b9e\u9a8c\uff0c"
                   "<b>\u4e0d\u4e0b\u7ed3\u8bba\u3002</b>"))
'''

t = t[:i] + NEW + t[i:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("inserted, new length %d" % len(t))
