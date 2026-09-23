#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Insert a correction banner into the handover HTML report.

§1.7 and B.5 claim the delivered netlist is self-inconsistent because the tie roots are
undriven and both sub-blocks' rst_n hangs off them.  Rounds 26-30 disproved that:
  * `rst_n` (top port) -> INVX8 -> HFSNET_124 -> inverters -> HFSNET_119 -> blocks' rst_n
  * no-force simulation: rst_n 0->1 makes both blocks' rst_n follow to 1 within 20 ns
  * the FSM works: state 000->010->101, busy 0->1, residue published, shortfall=0
The root analysis that produced the claim compared net names across MODULE scopes,
which makes a net driven in module A look undriven when referenced in module B.
"""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, 'make_handover_report.py')
t = io.open(GEN, encoding='utf-8-sig').read()

if 'RETRACT_BANNER' in t:
    print('banner already present')
    raise SystemExit(0)

ANCHOR = "    toc = ('<div class=\"toc\">"
i = t.find(ANCHOR)
print('toc anchor at %d' % i)
assert i > 0

BANNER = r'''    # ---- RETRACT_BANNER : 2026-09-19 corrections after independent re-measurement ----
    banner = []
    banner.append("<div class=\"note\" style=\"border-left:6px solid #FF6B6B\">"
                  "<b>\u26a0 2026-09-19 \u66f4\u6b63\uff08\u72ec\u7acb\u6838\u67e5\u7b2c 26\u201330 \u8f6e\u5b9e\u6d4b\u63a8\u7ffb\uff09</b>"
                  "\uff1a\u672c\u62a5\u544a <b>\u00a71.7</b> \u4e0e <b>\u9644 B.5</b> \u5199\u7684"
                  "\u300c\u4ea4\u4ed8\u7f51\u8868\u81ea\u8eab\u4e0d\u81ea\u6d3d\uff1atie \u6839\u7f51\u7edc\u65e0\u9a71\u52a8\u3001\u4e24\u4e2a\u6700\u5927\u5b50\u6a21\u5757\u7684 "
                  "<code>rst_n</code> \u60ac\u5728\u5b83\u4e0a\u300d<b>\u5df2\u7ecf\u4e0d\u6210\u7acb</b>\u3002</div>")
    banner.append("<div class=\"note\">"
                  "<b>\u5b9e\u6d4b\u4e8b\u5b9e</b>\uff1a\u53cd\u5411\u8ffd\u8e2a\u663e\u793a "
                  "<code>rst_n</code>\uff08\u9876\u5c42\u7aef\u53e3\uff09\u2192 <code>INVX8 HFSINV_15503_626</code> \u2192 "
                  "<code>HFSNET_124</code> \u2192 \u4e00\u4e32\u53cd\u76f8\u5668 \u2192 <code>HFSNET_119</code> \u2192 "
                  "\u4e24\u4e2a\u5b50\u6a21\u5757\u7684 <code>rst_n</code>\uff08<b>\u4e24\u6b21\u53cd\u76f8\uff0c\u6545\u7b49\u4e8e <code>rst_n</code></b>\uff09\u3002"
                  "\u65e0 force \u7684\u6700\u7b80\u4eff\u771f\uff1a<code>rst_n</code> \u7531 0 \u62ac\u5230 1 \u540e\uff0c"
                  "\u4e24\u4e2a\u5b50\u6a21\u5757\u7684 <code>rst_n</code> <b>20 ns \u5185\u8ddf\u968f\u53d8 1 \u5e76\u4fdd\u6301</b>\uff1b"
                  "\u72b6\u6001\u673a\u540c\u6837\u6b63\u5e38\uff1a<code>state 000\u2192010\u2192101</code>\u3001"
                  "<code>busy 0\u21921</code>\u3001<code>shortfall=0</code>\u3001<code>residue</code> \u5df2\u53d1\u5e03\u3002</div>")
    banner.append("<div class=\"note\">"
                  "<b>\u4e3a\u4ec0\u4e48\u4f1a\u9519</b>\uff1a\u5f53\u65f6\u7684\u201c\u65e0\u9a71\u52a8\u7f51\u201d\u5206\u6790<b>\u6ca1\u6709\u533a\u5206\u6a21\u5757\u4f5c\u7528\u57df</b>"
                  "\u2014\u2014\u4e00\u4e2a\u5728\u6a21\u5757 A \u5185\u88ab\u9a71\u52a8\u7684\u7f51\uff0c\u5728\u6a21\u5757 B \u91cc\u88ab\u5f15\u7528\u65f6\u5c31\u88ab\u5f53\u6210\u4e86\u201c\u65e0\u9a71\u52a8\u201d\u3002</div>")
    body = ''.join(banner) + ''.join(banner and [])

'''

t = t[:i] + BANNER + t[i:]

# make the banner actually appear: prepend it to the part-1 stream
NEW_P1 = '    p1 = []\n    p1.append(body)\n'
if '    p1 = []\n' in t:
    t = t.replace('    p1 = []\n', NEW_P1, 1)
    print('banner wired into p1')
else:
    print('WARNING: p1 anchor not found; banner not wired')

io.open(GEN, 'w', encoding='utf-8', newline='').write(t)
print('generator patched, length %d' % len(t))
