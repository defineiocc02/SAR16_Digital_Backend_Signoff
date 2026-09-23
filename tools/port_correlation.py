"""Correlation test for the "extra boundary ports" explanation.

Hypothesis: every net that Calibre reports as incorrect sits on at least one instance
of the 15 cell masters that extract with extra unlabeled boundary ports.  If the
hypothesis is right, the incorrect-net list should be a subset of the neighbourhood of
those cells; if many incorrect nets touch none of them, the explanation is incomplete.
"""
import collections
import io
import re
import sys

REPORT = sys.argv[1] if len(sys.argv) > 1 else 'lvsF_boxed_injectno.rep'
AFFECTED = {
    'ADDFX1', 'AND2X2', 'AND3XL', 'AOI21XL', 'AOI2BB1XL', 'AOI2BB2XL', 'CMPR32X1',
    'DFFSX1', 'DFFSX2', 'DFFSXL', 'MXI2XL', 'NAND2BXL', 'OR4X1', 'TLATNXL', 'XNOR2XL',
}

lines = io.open(REPORT, encoding='utf-8', errors='replace').read().splitlines()
start = None
for i, ln in enumerate(lines):
    if ln.strip().startswith('INCORRECT NETS'):
        start = i
        break
assert start is not None

nets = []
cur = None
dev_re = re.compile(r'^\s*(\S+?)\((\d+\.\d+),(-?\d+\.\d+)\)\s+(\S+)\s+(\S+)\s+(\S+)\s*$')
for ln in lines[start:start + 40000]:
    s = ln.strip()
    if s.startswith('INCORRECT INSTANCES') or s.startswith('INCORRECT PORTS'):
        break
    m = re.match(r'^\s*(\d+)\s+Net\s+(\S+)\s+(\S+)\s*$', ln)
    if m:
        cur = {'disc': int(m.group(1)), 'lay': m.group(2), 'src': m.group(3),
               'lay_cells': collections.Counter(), 'src_cells': collections.Counter(),
               'lay_dev': collections.Counter()}
        nets.append(cur)
        continue
    m = dev_re.match(ln)
    if m and cur is not None:
        inst_lay = m.group(1)
        cellname_lay = m.group(4)
        src_lay = m.group(5)
        cellname_src = m.group(6)
        cur['lay_dev'][cellname_lay] += 1
        # layout instance name looks like X7/X184 : the X7 part is the block
        blk = inst_lay.split('/')[0] if '/' in inst_lay else ''
        cur['lay_cells'][cellname_lay] += 1
        if cellname_src and not cellname_src.startswith('*'):
            cur['src_cells'][cellname_src] += 1

print('incorrect nets parsed : %d' % len(nets))
print('affected cell masters : %d' % len(AFFECTED))
print('')
touch = 0
clean = []
for n in nets:
    hit = sorted(set(n['lay_dev']) & AFFECTED) + sorted(set(n['src_cells']) & AFFECTED)
    if hit:
        touch += 1
    else:
        clean.append(n)
    n['hit'] = sorted(set(hit))
print('nets touching >=1 affected cell : %d / %d' % (touch, len(nets)))
print('nets touching NONE of them      : %d' % len(clean))
print('')
print('%-5s %-26s %-26s %s' % ('disc', 'layout', 'source', 'affected cells on the net'))
for n in nets:
    print('%-5d %-26s %-26s %s' % (n['disc'], n['lay'][:26], n['src'][:26],
                                  ','.join(n['hit']) if n['hit'] else '-- NONE --'))
print('')
print('=== device types on the clean (non-touching) nets ===')
c = collections.Counter()
for n in clean:
    c.update(n['lay_dev'])
print('  %s' % ', '.join('%s x%d' % (k, v) for k, v in c.most_common(20)))
