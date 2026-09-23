#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Add the closing summary (结语) as its own top-level section with a TOC entry.

Raw string, so every \n stays a backslash-n in the generated source (the round-10
mistake).  Apostrophes inside generated literals are written as &#39;.
"""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

A = '    body = ('
i = t.find(A)
print("body anchor at %d" % i)
assert i > 0

NEW = r'''    pb.append("<h2 id=\"z\">\u7ed3\u8bed \u00b7 \u63a5\u624b\u603b\u7ed3</h2>")
    pb.append("<h3>Z.1 \u4e00\u53e5\u8bdd\u7ed3\u8bba</h3>")
    pb.append(note("<b>WorkBuddy \u7684\u6570\u5b57\u540e\u7aef\u4efb\u52a1\u5df2\u63a5\u624b\u5e76\u63a8\u8fdb\u5230 v5.1\uff1a"
                   "\u771f\u5b9e\u7f3a\u9677\u5df2\u4fee\u590d\u5e76\u9a8c\u8bc1\uff08Calibre \u77ed\u8def 35 \u2192 0\u3001\u7aef\u53e3 178 = 178\uff09\uff0c"
                   "\u4e09\u89d2\u65f6\u5e8f\u5168\u90e8\u4e3a\u6b63\u4e14\u5757\u5185 hold \u96f6\u8fdd\u4f8b\uff0c"
                   "GDS/\u5e03\u7ebf/\u529f\u80fd\u6570\u636e\u5747\u4e3a\u540c\u4e00\u6b21\u8fd0\u884c\u7684 v5.1 \u53e3\u5f84\uff1b"
                   "<b>\u4f46 LVS \u672a\u6536\u655b\uff0c\u4e0d\u5f97\u636e\u672c\u5305\u5ba3\u79f0\u6d41\u7247\u5c31\u7eea\u3002</b>"
                   "\u6b8b\u5dee\u5df2\u5b9a\u91cf\u5f52\u56e0\u5230 86 %\uff0c\u5269\u4f59 9 \u6761\u7f51\u7684\u5f62\u6001\u5df2\u67e5\u6e05\u3001"
                   "\u4f46\u5c1a\u65e0\u5224\u522b\u5b9e\u9a8c\u3002"))
    pb.append("<h3>Z.2 \u4ea4\u4ed8\u72b6\u6001</h3>")
    pb.append(tbl(["\u7bc7", "\u5185\u5bb9", "\u72b6\u6001"], [
        ["\u7b2c 1 \u7bc7", "\u7f3a\u9677\u5b9a\u4f4d\u4e0e\u4fee\u590d\uff08\u00a71.1\u2013\u00a71.12.1\uff09", b("\u5df2\u4ea4\u4ed8", 0)],
        ["\u7b2c 2 \u7bc7", "\u65f6\u5e8f\u7b7e\u6838\uff08\u4e09\u89d2 + OCV derate + hold \u8fb9\u754c\u5b9a\u91cf\uff09", b("\u5df2\u4ea4\u4ed8", 0)],
        ["\u7b2c 3 \u7bc7", "GDS \u4e0e\u5e03\u7ebf\uff08\u5408\u5e76\u3001DRC\u3001LEF\uff09", b("\u5df2\u4ea4\u4ed8", 0)],
        ["\u7b2c 4 \u7bc7", "\u529f\u80fd\u4e0e\u63a5\u53e3", b("\u5df2\u4ea4\u4ed8", 0)],
        ["\u9644 A / \u9644 B", "\u5de5\u4f5c\u8bb0\u5f55\u6574\u7406\u5f52\u6863 / \u4ea4\u4ed8\u6e05\u5355\u4e0e\u7ed3\u8bba\u8fb9\u754c", b("\u5df2\u4ea4\u4ed8", 0)],
        ["**LVS \u5e73\u94fa\u53e3\u5f84\u6536\u655b**", "**\u672a\u5b8c\u6210**\uff08\u89c1 Z.3\uff09", b("**\u672a\u95ed\u5408**", 2)],
    ]))
    pb.append("<h3>Z.3 \u5173\u952e\u6570\u5b57\uff08\u5747\u4e3a\u5b9e\u6d4b\uff09</h3>")
    pb.append(tbl(["\u9879", "\u503c"], [
        ["Calibre \u77ed\u8def", "<b>0</b>\uff08<code>lvs.rep.shorts</code> \u4e0d\u518d\u751f\u6210\uff09"],
        ["LVS \u7aef\u53e3", "<b>178 = 178</b>"],
        ["clk slack\uff08typ / slow / fast\uff09", "+0.9807 / **+0.7947** / +1.0732 ns"],
        ["slow derate p0/p3/p5/p8", "+0.7947 / +0.7597 / +0.7363 / +0.7013\uff08\u5168\u7ebf\u4e3a\u6b63\uff09"],
        ["\u5757\u5185 flop\u2192flop hold \u8fdd\u4f8b", "<b>0</b>\uff08\u4e09\u89d2\uff09"],
        ["hold \u63a5\u53e3\u8981\u6c42", "\u8f93\u5165 \u2265 0.72 ns / <code>calib_comp_out</code> \u2265 0.04 ns / \u8f93\u51fa\u63a5\u6536 \u2264 0.44 ns"],
        ["\u4ea4\u4ed8 GDS", "4 243 084 B\uff0cmd5 <code>e8462461\u2026</code>\uff0c225 struct / 19 \u5c42\u5bf9"],
        ["die", "430.520 \u00d7 429.340 \u00b5m = 184 839.457 \u00b5m\u00b2"],
        ["DRC", "421 \u6761\u89c4\u5219 / 3 402 \u6761\u7ed3\u679c"],
        ["\u4ea4\u4ed8 LEF", "179 611 B\uff0c**109 MACRO / 630 PIN**\uff08\u4e25\u683c\u5d4c\u5957\u53e3\u5f84 + \u81ea\u68c0\uff09"],
        ["\u5757\u81ea\u8eab abstract", b("**\u4e0d\u53ef\u884c**\uff088 \u6761\u8def\u5f84\u5168\u90e8\u4e3a\u8d1f\uff09", 2)],
    ]))
    pb.append("<h3>Z.4 \u672a\u95ed\u5408\u9879\u4e0e\u7ed3\u8bba\u8fb9\u754c</h3>")
    pb.append("<ul>"
              "<li><b>LVS \u4ecd <code>INCORRECT</code></b>\uff1a\u7aef\u53e3\u76f8\u7b49\u3001\u5355\u5143\u7c7b\u578b\u9010\u884c\u76f8\u7b49\uff0c"
              "\u4f46 <code>Nets \u221231</code>\u3001<code>MP \u22123</code>\uff0c65 \u6761 incorrect net \u4e2d 56 \u6761\u5df2\u5f52\u56e0\u3001"
              "<b>9 \u6761\u672a\u5f52\u56e0</b>\u3002</li>"
              "<li><b>\u4ea4\u4ed8\u7684 P&amp;R \u7f51\u8868\u81ea\u8eab\u4e0d\u81ea\u6d3d</b>\uff1a85 \u4e2a tie \u53cd\u76f8\u5668\u7684\u6839\u7f51\u7edc "
              "<code>HFSNET_8</code> \u65e0\u9a71\u52a8\uff0c\u4e24\u4e2a\u6700\u5927\u5b50\u6a21\u5757\u7684 <code>rst_n</code> \u8d70\u7684\u662f\u5b83\u7684\u53cd\u76f8\u5668\u94fe"
              "\uff0c\u800c\u9876\u5c42 RTL \u63a5\u7684\u662f <code>rst_n</code>\u3002"
              "\u21d2 <b>\u4e0d\u5f97\u636e\u73b0\u6709 <code>.v</code> \u505a\u95e8\u7ea7\u4eff\u771f\u7b7e\u6838\u3002</b></li>"
              "<li><b>\u5757\u81ea\u8eab abstract \u7f3a\u5931</b>\uff1aL EF \u4e0d\u80fd\u4f5c\u4e3a\u8be5\u5757\u7684\u96c6\u6210 abstract\u3002</li>"
              "<li>DRC \u7684 <code>BD_*</code> \u5c5e\u82af\u7247\u7ea7\u89c4\u5219\uff0c<b>\u8c41\u514d\u987b\u6279\u51c6\uff0c\u672c\u5305\u4e0d\u5ba3\u544a\u8c41\u514d</b>\u3002</li>"
              "\u3000<li>\u529f\u8017\u4e3a\u672a\u6807\u6ce8\u6d3b\u52a8\u7387\u7684\u7ed3\u679c\uff0c<b>\u4e0d\u53ef\u4f5c\u4e3a\u7b7e\u6838\u503c</b>\u3002</li>"
              "</ul>")
    pb.append("<h3>Z.5 \u53ef\u4fe1\u5ea6\u8bf4\u660e</h3>")
    pb.append(note("\u672c\u62a5\u544a\u5305\u542b\u56db\u6b21<b>\u81ea\u6211\u7ea0\u6b63</b>\uff0c\u5747\u5199\u5728\u6b63\u6587\u91cc\u800c\u975e\u62b9\u53bb\uff1a"
                   "\uff08i\uff09\u7b2c 10 \u8f6e\u300c\u7248\u56fe\u91cc\u6ca1\u6709 <code>HFSNET</code>/<code>HFSINV</code>\u300d\u2014\u2014 \u540d\u5b57\u4e0d\u7b49\u4e8e\u5b58\u5728\uff1b"
                   "\uff08ii\uff09\u7b2c 10 \u8f6e\u300c20 \u4e2a\u53ea\u5728\u7f51\u8868\u91cc\u7684\u5355\u5143\u300d\u2014\u2014 \u5de5\u5177\u6f0f\u6570\uff1b"
                   "\uff08iii\uff09\u7b2c 10 \u8f6e\u300ctie \u94fe\u662f\u6700\u540e\u4e00\u4e2a LVS \u9519\u8bef\u7684\u771f\u56e0\u300d\u2014\u2014 \u7b2c 11 \u8f6e\u5b9e\u9a8c\u8bc1\u4f2a\uff1b"
                   "\uff08iv\uff09\u7b2c 18/19 \u8f6e\u300c\u677e\u6563\u5668\u4ef6\u662f\u8fb9\u754c\u51e0\u4f55\u5408\u5e76\u7684\u4ea7\u7269\u300d\u2014\u2014 \u7b2c 22/23 \u8f6e\u8bc1\u660e\u5b83\u4eec\u5c5e\u4e8e\u8bbe\u8ba1\u81ea\u5e26\u7684\u6676\u4f53\u7ba1\u7ea7\u5c42\u6b21\u3002"
                   "\u6bcf\u4e00\u6761\u90fd\u6807\u660e\u4e86\u5b83\u662f\u600e\u4e48\u88ab\u63a8\u7ffb\u7684\u3002"
                   "\u672c\u62a5\u544a\u4e0d\u5305\u542b\u672a\u505a\u5bf9\u7167\u7684\u6d4b\u91cf\u7ed3\u8bba\u3002"))
    pb.append("<h3>Z.6 \u5efa\u8bae\u7684\u4e0b\u4e00\u6b65</h3>")
    pb.append(tbl(["\u52a8\u4f5c", "\u5224\u636e"], [
        ["\u628a <code>LVS INJECT LOGIC NO</code> \u5199\u8fdb\u9879\u76ee deck",
         "\u672c\u5757\u9002\u7528\uff08\u5668\u4ef6\u6570\u7b49\u4e3a\u8bc1\uff09"],
        ["\u8dd1 <code>LVS REDUCE PARALLEL MOS NO</code>\uff0c\u770b 31 \u4e2a\u7f51\u5dee\u662f\u5426\u6539\u53d8",
         "\u6539\u53d8 \u21d2 \u627e\u5230\u673a\u5236\uff1b\u4e0d\u53d8 \u21d2 \u7f51\u5dee\u4e0d\u662f\u5408\u5e76\u9020\u6210\u7684\uff0c\u65b9\u5411\u5f97\u6362"],
        ["\u91cd\u65b0\u5bfc\u51fa P&amp;R \u7f51\u8868\uff08\u89e3\u51b3\u5e38\u91cf\u6839\u60ac\u7a7a\uff09",
         "\u91cd\u65b0\u9a8c\u8bc1 <code>.v</code> \u91cc\u4e0d\u518d\u51fa\u73b0\u65e0\u9a71\u52a8\u7684 <code>HFSNET_*</code>"],
        ["\u5bf9 9 \u6761\u672a\u5f52\u56e0\u7f51\u9010\u6761\u5904\u7f6e",
         "\u9010\u6761\u7ed9\u51fa\u7ed3\u8bba\uff0c\u800c\u4e0d\u662f\u7528\u6bd4\u4f8b\u63cf\u8ff0"],
    ]))
'''

t = t[:i] + NEW + t[i:]

# --- TOC entry ---
old_li = None
for cand in t.splitlines():
    if 'href="#c"' in cand and '</li>' in cand:
        old_li = cand
        break
print('TOC anchor: %s' % (old_li.strip() if old_li else 'NOT FOUND'))
assert old_li is not None
new_li = old_li.replace('</li>', '</li>\n           \'<li><a href="#z">\u7ed3\u8bed \u00b7 \u63a5\u624b\u603b\u7ed3</a></li>\'')
t = t.replace(old_li, new_li, 1)

io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("added, new length %d" % len(t))
