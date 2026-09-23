#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Append a short "closure" block to the handover report's correction banner.

Round 34 settled the last open item in the report:
  * the delivered netlist DOES work end to end on the SRM path -- top-level ports give
    total=22 / ones=7 / residue=966 under no force, bit-identical to the RTL under the
    same stimulus;
  * the earlier "top-level counts read 0" was my own testbench declaring the bus ports
    as 1-bit wires, so only the LSB was read;
  * the two GDS "anomalies" were my parser (record-code table + file-wide SNAME count).
"""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, 'make_handover_report.py')
t = io.open(GEN, encoding='utf-8-sig').read()

if 'CLOSURE_NOTE' in t:
    print('closure already present')
    raise SystemExit(0)

ANCHOR = "    body = ''.join(banner) + ''.join(banner and [])\n"
assert ANCHOR in t, 'banner anchor not found'

CLOSURE = '''    # ---- CLOSURE_NOTE : 2026-09-19 round 34 ----
    banner.append("<div class=\\"note\\" style=\\"border-left:6px solid #2E9E4F\\">"
                  "<b>\\u2714 2026-09-19 \\u7ed3\\u6848\\uff08\\u72ec\\u7acb\\u6838\\u67e5\\u7b2c 34 \\u8f6e\\uff09</b>\\uff1a"
                  "\\u4ea4\\u4ed8\\u7f51\\u8868\\u7684\\u590d\\u4f4d\\u3001\\u72b6\\u6001\\u673a\\u3001SRM \\u8ba1\\u6570\\u4e0e\\u6b8b\\u5dee"
                  "\\u5df2\\u5728<b>\\u5168\\u7a0b\\u65e0 force</b>\\u7684\\u95e8\\u7ea7\\u4eff\\u771f\\u4e2d\\u7aef\\u5230\\u7aef\\u8dd1\\u901a\\uff1a"
                  "\\u9876\\u5c42\\u7aef\\u53e3 <code>total=22 / ones=7 / residue=966</code>\\uff0c"
                  "\\u4e0e RTL \\u540c\\u6fc0\\u52b1\\u7ed3\\u679c<b>\\u9010\\u4f4d\\u76f8\\u540c</b>\\u3002"
                  "\\u6b64\\u524d\\u201c\\u9876\\u5c42\\u8ba1\\u6570\\u8bfb\\u6570\\u4e3a 0\\u201d"
                  "\\u662f\\u6211\\u7684\\u6d4b\\u8bd5\\u53f0\\u628a\\u603b\\u7ebf\\u7aef\\u53e3\\u58f0\\u660e\\u6210 1 \\u4f4d"
                  "\\uff08\\u53ea\\u8bfb\\u5230 LSB\\uff09\\u6240\\u81f4\\uff0c\\u975e\\u8bbe\\u8ba1\\u7f3a\\u9677\\u3002</div>")
    banner.append("<div class=\\"note\\">"
                  "<b>GDS \\u4e24\\u5904\\u201c\\u5f02\\u5e38\\u201d\\u540c\\u6837\\u5df2\\u64a4\\u56de</b>\\uff1a"
                  "\\u4e00\\u662f GDS \\u8bb0\\u5f55\\u7801\\u8868\\u5199\\u9519\\uff08<code>0x08</code> \\u624d\\u662f BOUNDARY\\uff09\\uff0c"
                  "\\u4e8c\\u662f\\u628a<b>\\u5168\\u6587\\u4ef6</b>\\u7684 SNAME \\u8ba1\\u6570\\u5f53\\u6210\\u4e86\\u9876\\u5c42\\u653e\\u7f6e\\u3002"
                  "\\u66f4\\u6b63\\u540e\\uff1a\\u9876\\u5c42\\u653e\\u7f6e <b>115 \\u79cd master / 34 356 SREF</b>"
                  "\\uff08= 30 730 \\u8fc7\\u5b54 + <b>3 626 \\u5355\\u5143</b>\\uff0c\\u4e0e\\u7f51\\u8868\\u9010\\u9879\\u95ed\\u5408\\uff09\\uff0c"
                  "\\u9010\\u5c42\\u56fe\\u5f62 <b>37 836 \\u4e2a / 103 969 \\u00b5m\\u00b2</b>\\u3002</div>")
'''

t = t.replace(ANCHOR, CLOSURE + ANCHOR, 1)
io.open(GEN, 'w', encoding='utf-8', newline='').write(t)
print('closure patched into generator, length %d' % len(t))
