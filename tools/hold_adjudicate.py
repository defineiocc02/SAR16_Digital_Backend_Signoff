"""Adjudicate the hold-violation total: is it 29 or 39?

Counts violations in EVERY hold report under sta/, including the derate points
(p0/p3/p5/p8), so the two candidate calibers can be compared on the raw files.
"""
import glob
import io
import os
import re

files = sorted(glob.glob(os.path.join('sta', '*hold*.rpt')))
print('hold report files found: %d' % len(files))
print('')
print('%-42s %8s %8s' % ('file', 'VIOLATED', 'lines'))
tot_viol = 0
per = {}
for f in files:
    txt = io.open(f, encoding='utf-8', errors='replace').read()
    n = len(re.findall(r'VIOLATED', txt))
    lines = txt.count('\n')
    print('%-42s %8d %8d' % (os.path.basename(f), n, lines))
    per[os.path.basename(f)] = n
print('')
print('sum of VIOLATED over ALL hold reports : %d' % sum(per.values()))

print('')
print('=== grouped two ways ===')
grp = {}
for k, v in per.items():
    m = re.match(r'sta_pc_(\w+?)_(p\d+|pc)_hold', k)
    if m:
        grp.setdefault(m.group(1), {})[m.group(2)] = v
for corner in sorted(grp):
    d = grp[corner]
    print('  %-8s %s   sum=%d' % (corner, d, sum(d.values())))

print('')
print('=== the three-corner caliber (typical/slow/fast at pc only) ===')
tri = {c: grp.get(c, {}).get('pc', 0) for c in ('typical', 'slow', 'fast')}
print('  %s   sum=%d' % (tri, sum(tri.values())))

print('')
print('=== the all-corners-and-derate caliber ===')
print('  sum over every file = %d' % sum(per.values()))

print('')
print('=== can 16/39 be reproduced? ===')
slow = grp.get('slow', {})
fast = grp.get('fast', {})
typ = grp.get('typical', {})
print('  slow pc=%s ; fast pc=%s ; typical pc=%s' % (slow.get('pc'), fast.get('pc'), typ.get('pc')))
print('  slow all=%d  fast all=%d  typical all=%d  total=%d'
      % (sum(slow.values()), sum(fast.values()), sum(typ.values()),
         sum(slow.values()) + sum(fast.values()) + sum(typ.values())))
