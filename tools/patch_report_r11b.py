#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round 11b: the B.5 red flag said HFSNET_119 has no driver.  It does
(HFSINV_6951_589 drives it); the undriven one is its input HFSNET_124 / port
HFSNET_8.  Append a precise correction right after it."""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

A = '    pb.append("<h3>B.6 '
i = t.find(A)
print("B.6 at %d" % i)
assert i > 0

NEW = r'''    pb.append(note("<b>\u8be5\u7ea6\u675f\u7684\u7cbe\u786e\u8868\u8ff0\uff08\u7b2c 11 \u8f6e\u6821\u6b63\uff09</b>\uff1a"
                   "\u65e0\u9a71\u52a8\u7684\u662f<b>6 \u6839\u6839\u7f51\u7edc</b>"
                   "\uff08<code>HFSNET_8</code> \u53ca\u5176\u7236\u5c42\u522b\u540d <code>HFSNET_124</code>\u3001"
                   "\u4ee5\u53ca <code>HFSNET_330/346/362/363/364</code>\uff09\uff1b"
                   "<code>HFSNET_119</code> <b>\u662f\u6709\u9a71\u52a8\u7684</b>"
                   "\uff08\u7531 <code>HFSINV_6951_589</code> \u9a71\u52a8\uff0c\u5b83\u7684\u8f93\u5165\u5c31\u662f\u90a3\u6839\u65e0\u9a71\u52a8\u7684\u6839\uff09\u3002"
                   "\u8fd9\u4e9b tie \u7f51\u7edc\u4e0e 85 \u4e2a <code>HFSINV</code> "
                   "<b>\u5728\u7248\u56fe\u91cc\u90fd\u5b58\u5728</b>\uff08SPEF \u5b9e\u6d4b\uff09\uff0c"
                   "\u7f3a\u7684\u53ea\u662f\u300c\u6839\u7f51\u7edc\u7684\u5e38\u91cf\u503c\u6ca1\u88ab\u5199\u8fdb\u7f51\u8868\u300d\u3002"
                   "\u5b83\u4e0d\u662f LVS \u4e0d\u6536\u655b\u7684\u539f\u56e0\uff08\u5df2\u7528\u5355\u53d8\u91cf\u5b9e\u9a8c\u8bc1\u4f2a\uff0c\u89c1 1.8\uff09\u3002"))
'''

t = t[:i] + NEW + t[i:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("appended, new length %d" % len(t))
