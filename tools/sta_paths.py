"""Extract violated timing paths from the PrimeTime -all_violators -verbose reports.

For each report this pulls, per violated path: startpoint, endpoint, path group, path type
(max = setup / min = hold), the slack, and the key numbers that explain the slack
(data arrival, data required, propagated clock network delay, library setup/hold time).

Reports are parsed as text blocks starting at each `Startpoint:` line; nothing is inferred
from column positions, because these reports are fixed-width and wrap.
"""
import collections
import glob
import io
import os
import re
import sys

PATS = sys.argv[1:] or ['../evidence/rpt_v51/sta/sta_pc_*_violators.rpt']


def num(pat, block, grp=1):
    m = re.search(pat, block)
    return float(m.group(grp)) if m else None


def parse(path):
    t = io.open(path, encoding='utf-8', errors='replace').read().replace('\x00', '')
    out = []
    for blk in t.split('Startpoint:')[1:]:
        sp = blk.split('\n', 1)[0].strip()
        ep = re.search(r'Endpoint:\s*([^\n]+)', blk)
        pg = re.search(r'Path Group:\s*([^\n]+)', blk)
        pt = re.search(r'Path Type:\s*([^\n]+)', blk)
        sl = re.search(r'slack\s+\((\w+)\)\s+(-?[\d.]+)', blk)
        delays = re.findall(r'clock network delay \(propagated\)\s+(-?[\d.]+)', blk)
        out.append({
            'start': sp,
            'end': ep.group(1).strip() if ep else '?',
            'group': pg.group(1).strip() if pg else '?',
            'type': pt.group(1).strip() if pt else '?',
            'flag': sl.group(1) if sl else '?',
            'slack': float(sl.group(2)) if sl else None,
            'arrival': num(r'data arrival time\s+(-?[\d.]+)', blk),
            'required': num(r'data required time\s+(-?[\d.]+)', blk),
            'clkdelay': delays,
            'libsetup': num(r'library setup time\s+(-?[\d.]+)', blk),
            'libhold': num(r'library hold time\s+(-?[\d.]+)', blk),
            'uncert': num(r'clock uncertainty\s+(-?[\d.]+)', blk),
        })
    return out


print('%-28s %6s %6s %-6s %-9s %8s %8s %8s' %
      ('report', 'paths', 'viol', 'type', 'group', 'worst', 'arrival', 'required'))
allrows = []
for pat in PATS:
    for p in sorted(glob.glob(pat)):
        rows = parse(p)
        if not rows:
            continue
        bad = [r for r in rows if r['slack'] is not None and r['slack'] < 0]
        allrows += [(p, r) for r in bad]
        w = min(bad, key=lambda r: r['slack']) if bad else None
        print('%-28s %6d %6d %-6s %-9s %8s %8s %8s' %
              (os.path.basename(p), len(rows), len(bad),
               (w['type'] if w else '-'), (w['group'] if w else '-'),
               ('%.4f' % w['slack']) if w else '-',
               ('%.2f' % w['arrival']) if w and w['arrival'] is not None else '-',
               ('%.2f' % w['required']) if w and w['required'] is not None else '-'))

print('')
print('=== every violated endpoint, worst per (corner, endpoint) ===')
seen = {}
for p, r in allrows:
    key = (os.path.basename(p), r['end'])
    if key not in seen or r['slack'] < seen[key]['slack']:
        seen[key] = r
for (f, e), r in sorted(seen.items(), key=lambda x: x[1]['slack'])[:40]:
    print('  %-26s %-4s %-9s slack=%7.4f  %s -> %s' %
          (f.replace('sta_pc_', '').replace('_violators.rpt', ''),
           r['type'], r['group'], r['slack'], r['start'][:34], e[:40]))

print('')
print('=== worst path in full (slow, pc) ===')
for p, r in allrows:
    if 'slow_pc' in p and r['type'] == 'min':
        print('  %s' % p)
        print('  start      : %s' % r['start'])
        print('  end        : %s' % r['end'])
        print('  group/type : %s / %s' % (r['group'], r['type']))
        print('  arrival    : %s   required: %s   slack: %.4f (%s)'
              % (r['arrival'], r['required'], r['slack'], r['flag']))
        print('  clk net delay (launch, capture): %s' % r['clkdelay'])
        print('  library hold/setup: %s / %s   uncertainty: %s'
              % (r['libhold'], r['libsetup'], r['uncert']))
        break
