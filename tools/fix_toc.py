#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Repair the TOC entry: the previous patch moved the closing quote of the 附B list
item, leaving an unterminated string literal."""
import io
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

# show the damaged region
i = t.find('href="#z"')
print('found at %d' % i)
assert i > 0
print(repr(t[max(0, i - 160):i + 80]))

# the broken shape is:  ...</a></li>\n<spaces>'<li><a href="#z">
pat = re.compile(r'(</a></li>)\s*\n(\s*)(\'<li><a href="#z">)')
t2, n = pat.subn(r"\1'\n\2\3", t)
print('repairs applied: %d' % n)
assert n == 1

io.open(GEN, "w", encoding="utf-8", newline="").write(t2)
print('written, length %d' % len(t2))
