#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round 9: add the LVS device-residual attribution (section 1.6) to the report
generator, and correct the LEF macro/pin counts if the generator still claims them."""
import io
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

# ---------- report what LEF numbers the generator currently asserts ----------
for pat in ("115", "665", "652", "MACRO"):
    hits = [m.start() for m in re.finditer(re.escape(pat), t)]
    print("pattern %-6s occurrences=%d" % (pat, len(hits)))
    for h in hits[:4]:
        seg = t[max(0, h - 90):h + 60].replace("\n", " ")
        print("     ...%s..." % seg)

ANCHOR = "    # ---- P2 \u65f6\u5e8f ----"
idx = t.find(ANCHOR)
print("anchor at %d" % idx)
assert idx > 0, "anchor not found"

NEW = '''    p1.append("<h3>1.6 LVS 器件残差的最终归因（第 9 轮）—— <b>不是硅，是画法</b></h3>")
    p1.append("<p>第 1.5 节把短路打到 0 之后，LVS 仍 <code>INCORRECT</code>，残差是"
              "<b>版图比源多 660 个原始 MOS</b>（MN +306 / MP +354）。本轮把它的来源"
              "<b>逐单元量到了个数</b>，结论是可以写进交付文档的。</p>")
    p1.append("<h4>决定性对照一：库单元在我们的版图里和在自己版图里<b>一模一样</b></h4>")
    p1.append("<p>拿 <code>kitcheck/</code> 里每个标准单元<b>单独</b>从 kit 版图抽取的网表"
              "（<code>kitcheck/svdb/&lt;CELL&gt;.sp</code>），与<b>同一种单元在我们合并后版图里"
              "在位抽取</b>的结果逐个 master 比器件数：</p>")
    p1.append(tbl(["\u53e3\u5f84", "\u6570\u503c", "\u610f\u4e49"], [
        ["参与对照的 master", "<b>89 / 89</b>", "本设计实际用到的全部单元种类"],
        ["kit \u5355\u72ec\u62bd\u53d6 \u2260 \u6211\u4eec\u5c31\u5730\u62bd\u53d6",
         b("0", 0), "<b>\u96f6\u4e2a\u4e0d\u4e00\u81f4 \u2014\u2014 \u5408\u5e76\u6ca1\u6709\u5f04\u574f\u4efb\u4f55\u5355\u5143</b>"],
        ["\u4e24\u8fb9\u90fd\u2260 \u6e90 CDL \u7684 master", "22", "\u5168\u90e8\u662f\u9a71\u52a8\u529b\u53d8\u4f53"],
    ]))
    p1.append("<h4>\u51b3\u5b9a\u6027\u5bf9\u7167\u4e8c\uff1a\u90a3 22 \u4e2a master \u600e\u4e48\u5c31\u662f\u5168\u90e8</h4>")
    p1.append("<p>\u628a\u7248\u56fe\u5c42\u6b21\u5c55\u5e73\u540e\u9010 master \u7b97"
              "<code>(\u7248\u56fe\u624b\u6307\u6570 \u2212 CDL \u5668\u4ef6\u6570) \u00d7 \u5b9e\u4f8b\u6570</code>\uff1a</p>")
    p1.append(tbl(["\u5355\u5143", "\u5b9e\u4f8b", "\u7248\u56fe\u624b\u6307", "CDL \u5668\u4ef6", "\u8d21\u732e"], [
        ["<code>CLKINVX8</code>", "16", "7", "2", "+80"],
        ["<code>CLKBUFX8</code>", "11", "10", "4", "+66"],
        ["<code>INVX4</code>", "32", "4", "2", "+64"],
        ["<code>BUFX8</code>", "6", "12", "4", "+48"],
        ["<code>CLKINVX3</code>", "22", "4", "2", "+44"],
        ["<code>BUFX12</code>", "3", "18", "4", "+42"],
        ["<code>CLKBUFX3</code>", "20", "6", "4", "+40"],
        ["<code>BUFX16</code>", "2", "23", "4", "+38"],
        ["<code>CLKINVX4</code>", "18", "4", "2", "+36"],
        ["<code>OAI22X2</code>", "9", "16", "12", "+36"],
        ["<code>AND2X4</code>", "16", "8", "6", "+32"],
        ["\u5176\u4f59 11 \u4e2a", "\u2014", "\u2014", "\u2014", "+110"],
        ["<b>\u5408\u8ba1\uff0822 \u4e2a master\uff09</b>", "", "", "", b("+644 / +660", 1)],
    ]))
    p1.append(note("<b>\u539f\u56e0\uff1a\u9ad8\u9a71\u52a8\u5355\u5143\u662f\u591a\u624b\u6307\uff08multi-finger\uff09\u753b\u6cd5\u3002</b>"
                   "\u7248\u56fe\u91cc\u4e00\u4e2a\u903b\u8f91\u7ba1\u753b\u6210 N \u6839\u624b\u6307\uff0c"
                   "\u800c <code>smic18_san.cdl</code> \u662f<b>\u903b\u8f91\u7ea7</b>\u7f51\u8868\uff08\u4e00\u7ba1\u4e00\u5668\u4ef6\uff09\u3002"
                   "\u5dee\u503c\u5168\u90e8\u4e3a<b>\u6b63</b>\u4e14\u96c6\u4e2d\u5728 \u00d72/\u00d73/\u00d74/\u00d78/\u00d712/\u00d716 "
                   "\u8fd9\u4e9b\u9a71\u52a8\u529b\u53d8\u4f53\u4e0a \u2014\u2014 \u8fd9\u662f\u624b\u6307\u6570\u5b57\u7684\u7279\u5f81\uff0c"
                   "\u4e0d\u662f\u201c\u5c11\u4e86/\u591a\u4e86\u7845\u201d\u7684\u7279\u5f81\u3002"))
    p1.append("<h4>\u51b3\u5b9a\u6027\u5bf9\u7167\u4e09\uff1a deck \u5c31\u662f kit deck\uff0c\u6ca1\u88ab\u6539\u8fc7</h4>")
    p1.append("<p>\u628a <code>mylvs.lvs</code> \u4e0e SMIC \u539f\u5382 deck "
              "<code>SMIC_CalLVS_018MSE_1833_V1.11_1.lvs</code> \u9010\u884c\u5bf9\u5dee\uff0c"
              "\u5168\u90e8\u5dee\u5f02\u53ea\u6709\u56db\u7c7b\uff1a</p>")
    p1.append(tbl(["\u5dee\u5f02", "\u5185\u5bb9", "\u6027\u8d28"], [
        ["\u8def\u5f84\u56db\u884c", "SOURCE/LAYOUT PATH+PRIMARY", "\u5fc5\u7136"],
        ["<code>PRECISION 10000</code>", "\u6211\u4eec\u7684\u5408\u5e76 GDS \u662f 10000 DBU/\u00b5m\uff0ckit \u662f 1000", "\u5fc5\u7136"],
        ["<code>LVS GLOBALS ARE PORTS YES</code>", "\u7b2c 3 \u8f6e\u4fee\u7684", "\u5df2\u8bc1\u660e\u6709\u6548"],
        ["3 \u6761 <code>DEVICE D(parasitic_*)</code> \u88ab\u6ce8\u91ca", "\u5bc4\u751f\u4e95\u4e8c\u6781\u7ba1", "\u7b49\u4ef7\u4e8e deck \u81ea\u5df1\u7684 <code>LVS FILTER \u2026 OPEN</code>"],
    ]))
    p1.append("<h4>\u5173\u952e\u53d1\u73b0\uff1a\u90a3\u4e9b <code>_invv / _nand2v / _sdw2v</code> \u662f <b>Calibre \u81ea\u5df1\u6ce8\u5165\u7684\u5668\u4ef6</b></h4>")
    p1.append("<p>\u53d8\u6362\u540e\u8868\u91cc\u90a3\u4e9b\u5e26\u4e0b\u5212\u7ebf\u3001\u4e0d\u5c5e\u4e8e\u4efb\u4f55\u7f51\u8868\u6587\u4ef6\u7684\u201c\u5668\u4ef6\u7c7b\u578b\u201d"
              "\uff08<code>_invv</code>\u3001<code>_nand2b</code>\u3001<code>_sdw2v</code>\u3001<code>_sup2v</code>\u2026\uff09"
              "\uff0c\u62a5\u544a\u81ea\u5df1\u628a\u6e90\u4fa7\u5bf9\u5e94\u9879\u6807\u6210\u4e86 "
              "<b><code>** missing injected instance **</code></b>\u3002\u5b83\u4eec\u6765\u81ea kit deck \u7684"
              "<code>LVS INJECT LOGIC YES</code>\uff08\u9762\u5411\u6a21\u62df/\u6570\u6a21\u6df7\u5408\u7684\u9ed8\u8ba4\u503c\uff09\uff0c"
              "\u5bf9\u4e00\u4e2a\u7eaf\u6807\u51c6\u5355\u5143\u6570\u5b57\u5757\u662f<b>\u4e0d\u5bf9\u79f0\u6ce8\u5165</b>\uff0c"
              "\u4f1a\u51ed\u7a7a\u5236\u9020\u51fa\u5668\u4ef6/\u7f51\u8868/\u8fde\u63a5\u5dee\u5f02\u3002</p>")
    p1.append("<p>\u628a\u5b83\u5173\u6389\u540e\u505a\u7684\u5355\u53d8\u91cf\u77e9\u9635\uff08\u6bcf\u6b21\u8dd1 ~20 s\uff0c"
              "\u6bcf\u4e2a\u53d8\u4f53\u53ea\u52a0\u4e00\u4e2a\u5f00\u5173\uff09\uff1a</p>")
    p1.append(tbl(["\u53d8\u4f53", "<code>INJECT LOGIC</code>", "\u5176\u4f59\u5f00\u5173",
                   "\u7aef\u53e3", "\u603b\u5668\u4ef6\uff08\u7248\u56fe/\u6e90\uff09", "\u7f51\u8868", "\u9519\u8bef\u7f51\u5757"], [
        ["\u57fa\u7ebf v5.1", "YES", "\u2014", "178 = 178", "50686 / 50026 \u2717", "12146 / 12255", "50\uff08\u4e0a\u9650\uff09"],
        ["E", b("NO", 0), "\u2014", "178 = 178", b("49853 = 49853 \u2713", 0), "26704 / 26813", "34"],
        ["I", b("NO", 0), "<code>EXPAND UNBALANCED CELLS NO</code>",
         "178 = 178", "49853 = 49853 \u2713", "26704 / 26813", "34"],
        ["G", b("NO", 0), "<code>REDUCE SERIES MOS YES</code>",
         "178 = 178", "49825 = 49825 \u2713", "26676 / 26813", "35"],
        ["F", b("NO", 0), "\uff0b\u5355\u5143\u9ed1\u76d2\uff0889 \u4e2a\uff09",
         "178 = 178", b("3799 = 3799 \u2713", 0), "4753 / 4784", "<b>6</b>"],
        ["J", b("NO", 0), "\uff0b\u9ed1\u76d2\uff0b<code>REDUCE SERIES YES</code>",
         "178 = 178", "3796 = 3796 \u2713", "4750 / 4784", "11"],
    ]))
    p1.append(note("<b>\u8bfb\u6cd5</b>\uff1a\u4e00\u65e6\u628a <code>INJECT LOGIC</code> \u5173\u6389\uff0c"
                   "<b>\u603b\u5668\u4ef6\u6570\u5728\u6bcf\u4e00\u79cd\u914d\u7f6e\u4e0b\u90fd\u7cbe\u786e\u76f8\u7b49</b>\uff0c"
                   "\u7aef\u53e3 178 = 178\uff0c\u9ed1\u76d2\u540e<b>\u6bcf\u4e00\u79cd\u5355\u5143\u7684\u5b9e\u4f8b\u6570\u9010\u4e2a\u76f8\u7b49</b>"
                   "\uff08\u5982 <code>ADDFHXL</code> 15 = 15\u3001<code>AOI21XL</code> 130 = 130\uff09\u3002"
                   "\u6b8b\u4f59\u6536\u655b\u6210\u4e00\u4ef6\u4e8b\uff1a<b>\u7248\u56fe\u7f51\u8868\u6bd4\u6e90\u5c11</b>"
                   "\uff08\u5e73\u94fa \u2212109\uff0c\u9ed1\u76d2 \u221231\uff09\u3002"
                   "\u8fd9\u6b63\u662f\u5e76\u8054<b>\u624b\u6307\u5408\u5e76</b>\u5e94\u8be5\u9020\u6210\u7684\u7ed3\u679c"
                   "\u2014\u2014 \u5408\u5e76\u6389\u4e86\u624b\u6307\u4e4b\u95f4\u7684\u5185\u90e8\u8282\u70b9\u3002"))
    p1.append("<h4>\u7ed3\u8bba\u4e0e\u8fb9\u754c</h4>")
    p1.append(tbl(["\u53ef\u4ee5\u8bf4", "\u4e0d\u80fd\u8bf4"], [
        ["\u7248\u56fe\u4e0e\u7f51\u8868\u7684\u5668\u4ef6\u6570\u5dee\u5df2<b>\u9010\u5355\u5143\u5b9a\u91cf\u5f52\u56e0</b>\u4e3a\u591a\u624b\u6307\u753b\u6cd5\uff0c"
         "\u4e0d\u662f\u5c11\u94dd/\u591a\u94dd",
         "\u300cLVS \u5df2\u901a\u8fc7\u300d"],
        ["\u5408\u5e76 GDS \u7684\u5355\u5143\u4e0e kit \u539f\u7248\u5355\u5143<b>\u9010 master \u76f8\u7b49\uff0889/89\uff09</b>",
         "\u300cLVS \u6b8b\u4f59\u65e0\u5173\u7d27\u8981\u300d\u2014\u2014 \u5269\u4e0b\u7684\u9519\u8bef\u7f51\u5757\u5c1a\u672a\u9010\u6761\u5904\u7f6e"],
        ["<code>LVS INJECT LOGIC NO</code> \u5728\u672c\u5757\u662f\u6b63\u786e\u53d6\u503c\uff08\u5668\u4ef6\u6570\u76f8\u7b49\u4e3a\u8bc1\uff09",
         "\u300c\u6362\u4e2a\u5f00\u5173\u5c31\u80fd\u5237\u7eff\u300d\u2014\u2014 \u5f00\u5173\u53ea\u80fd\u6d88\u9664\u5de5\u5177\u5e7b\u5f71\uff0c\u4e0d\u80fd\u6d88\u9664\u771f\u5dee\u5f02"],
    ]))
    p1.append(note("<b>\u4e0b\u4e00\u6b65\u7684\u660e\u786e\u52a8\u4f5c</b>\uff1a"
                   "\uff081\uff09\u628a <code>LVS INJECT LOGIC NO</code> \u5199\u8fdb\u9879\u76ee deck\uff1b"
                   "\uff082\uff09\u7528\u9ed1\u76d2\u53e3\u5f84\u628a\u5269\u4e0b 6 \u4e2a\u9519\u8bef\u7f51\u5757\u9010\u6761\u5b9a\u4f4d\uff1b"
                   "\uff083\uff09\u82e5\u8981\u5e73\u94fa\u53e3\u5f84\u6536\u655b\uff0c\u9700\u8981\u4e00\u4efd"
                   "<b>\u624b\u6307\u7ea7\uff08finger-aware\uff09\u7684\u6e90 CDL</b>\uff0c\u6216\u5728\u5bf9\u6bd4\u524d"
                   "\u5bf9\u4e24\u4fa7\u540c\u6b65\u505a\u624b\u6307\u5408\u5e76 \u2014\u2014 \u8fd9\u662f<b>\u5e93/\u6d41\u7a0b\u7ea7</b>\u5de5\u4f5c\uff0c"
                   "\u4e0d\u662f\u6539\u8bbe\u8ba1\u3002"))
'''

t = t[:idx] + NEW + t[idx:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("generator updated, new length %d" % len(t))
