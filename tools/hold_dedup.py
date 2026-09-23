"""Adjudicate the hold-violation count by DEDUPLICATING the violating paths.

Third caliber (see V5): count unique (startpoint, endpoint) pairs per report file, then
compare with the three numbers that were floating around (29 / 42 / 39).

Calibers being compared:
  A  sta_pc_summary.txt  viol_hold               -> 1 / 16 / 12   = 29
  B  occurrences of the string "VIOLATED"        -> 1 / 25 / 16   = 42  (upper bound)
  C  unique violating (startpoint,endpoint)      -> ?              (this script)
"""
import glob
import io
import os
import re

FILES = sorted(glob.glob(os.path.join('sta', '*hold*.rpt')))
print('hold report files: %d' % len(FILES))
print('')
print('%-34s %7s %7s %7s' % ('file', 'paths', 'unique', 'VIOLATED'))
per = {}
for f in FILES:
    txt = io.open(f, encoding='utf-8', errors='replace').read()
    sp = re.findall(r'^\s*Startpoint:\s*(\S+)', txt, re.M)
    ep = re.findall(r'^\s*Endpoint:\s*(\S+)', txt, re.M)
    pairs = set(zip(sp, ep))
    v = len(re.findall(r'VIOLATED', txt))
    n = os.path.basename(f)
    per[n] = {'paths': min(len(sp), len(ep)), 'unique': len(pairs), 'violated': v,
              'pairs': pairs}
    print('%-34s %7d %7d %7d' % (n[:34], min(len(sp), len(ep)), len(pairs), v))

print('')


def pick(suffix):
    return {k: v for k, v in per.items() if k.endswith(suffix)}


pc = {k: v for k, v in per.items() if k.endswith('_pc_hold.rpt')}
print('=== caliber C, three pc corners ===')
tot = 0
allpc = set()
for c in ('typical', 'slow', 'fast'):
    k = 'sta_pc_%s_pc_hold.rpt' % c
    if k in per:
        print('  %-8s unique=%-4d' % (c, per[k]['unique']))
        tot += per[k]['unique']
        allpc |= per[k]['pairs']
print('  sum of per-corner unique : %d' % tot)
print('  union over the three     : %d' % len(allpc))

print('')
print('=== union over ALL report files (pc + derate points) ===')
allf = set()
for v in per.values():
    allf |= v['pairs']
print('  union over all files     : %d' % len(allf))

print('')
print('=== the three calibers, side by side ===')
print('  A  summary viol_hold (typ/slow/fast) = 1/16/12  -> %d' % (1 + 16 + 12))
print('  B  "VIOLATED" occurrences, pc only   = %d'
      % sum(per[k]['violated'] for k in pc))
print('  C  unique endpoints, pc only, summed = %d' % tot)
print('  C\' unique endpoints, pc only, union  = %d' % len(allpc))
print('  D  unique endpoints, all files union = %d' % len(allf))
print('')
print('=== can 39 be reproduced? ===')
for label, val in (('A', 29), ('B', sum(per[k]['violated'] for k in pc)),
                   ('C', tot), ("C'", len(allpc)), ('D', len(allf))):
    print('  %-3s = %-4d %s' % (label, val, '<== 39!' if val == 39 else ''))
