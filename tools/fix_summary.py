#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Balance the 结语 block's tags without guessing prose.

The tag checker reports one unclosed <b>.  Instead of matching a sentence I look for a
known inner tag pair (`...流片就绪。</b>`) and close the outer <b> right after it, which
is visually equivalent.  If the anchor is absent the script prints the region and
writes nothing, so a failed guess cannot damage the generator.
"""
import io
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

i = t.find('id=\\"z\\"')
if i < 0:
    i = t.find('id="z"')
assert i > 0
head, tail = t[:i], t[i:]

# balance tags inside the closing block only: report the running delta first
depth = 0
for m in re.finditer(r'</?b>', tail):
    depth += 1 if m.group(0) == '<b>' else -1
print('net <b> imbalance inside the closing block: %+d' % depth)

ANCHOR = r'\u6d41\u7247\u5c31\u7eea\u3002</b>'
if ANCHOR in tail:
    idx = tail.find(ANCHOR) + len(ANCHOR)
    tail = tail[:idx] + '</b>' + tail[idx:]
    print('outer <b> closed after the inner pair')
else:
    print('ANCHOR NOT FOUND - printing the region, writing nothing')
    j = tail.find('WorkBuddy')
    print(repr(tail[j:j + 700]))
    raise SystemExit(1)

depth2 = 0
for m in re.finditer(r'</?b>', tail):
    depth2 += 1 if m.group(0) == '<b>' else -1
print('imbalance after fix: %+d' % depth2)
assert depth2 == 0

# the two cosmetic fixes from the previous attempt
n_bold = len(re.findall(r'\*\*(.+?)\*\*', tail))
tail = re.sub(r'\*\*(.+?)\*\*', r'<b>\1</b>', tail)
n_typo = tail.count('L EF')
tail = tail.replace('L EF', 'LEF')
print('markdown-bold cells converted: %d ; L EF typo fixes: %d' % (n_bold, n_typo))

io.open(GEN, "w", encoding="utf-8", newline="").write(head + tail)
print('written, length %d' % len(head + tail))
