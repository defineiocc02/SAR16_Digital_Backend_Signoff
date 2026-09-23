"""Extract and summarise the INCORRECT OBJECTS section of a Calibre LVS report.

Prints, for every incorrect net: its two names, the two connection counts, and a
tally of the device types / pin names that are on it.  Also lists incorrect
instances and unmatched objects.
"""
import collections
import io
import re
import sys

path = sys.argv[1]
lines = io.open(path, encoding='utf-8', errors='replace').read().splitlines()

# ---- section boundaries ----
marks = {}
for i, ln in enumerate(lines):
    s = ln.strip()
    if s.startswith('INCORRECT NETS') or s.startswith('INCORRECT INSTANCES') \
       or s.startswith('INCORRECT PORTS') or s.startswith('INCORRECT DEVICES') \
       or s.startswith('UNMATCHED') or s.startswith('FLOATING'):
        marks.setdefault(s, i)
print('=== sections present ===')
for k, v in marks.items():
    print('  %-24s at line %d' % (k, v + 1))
print('')

start = marks.get('INCORRECT NETS')
if start is None:
    print('no INCORRECT NETS section')
    sys.exit(0)

cur = None
nets = []
for ln in lines[start:start + 20000]:
    s = ln.strip()
    if s.startswith('INCORRECT INSTANCES') or s.startswith('INCORRECT PORTS'):
        break
    m = re.match(r'^\s*(\d+)\s+Net\s+(\S+)\s+(\S+)\s*$', ln)
    if m:
        cur = {'disc': m.group(1), 'lay': m.group(2), 'src': m.group(3),
               'layc': None, 'srcc': None, 'devs': collections.Counter(), 'pins': collections.Counter()}
        nets.append(cur)
        continue
    m = re.match(r'.*---\s*(\d+)\s+Connections On This Net\s*---.*---\s*(\d+)\s+Connections On This Net\s*---', ln)
    if m and cur is not None:
        cur['layc'], cur['srcc'] = int(m.group(1)), int(m.group(2))
        continue
    m = re.match(r'^\s*(\S+?)\((\d+\.\d+),(-?\d+\.\d+)\)\s+(\S+)\s+(\S+)\s+(\S+)\s*$', ln)
    if m and cur is not None:
        cur['devs'][m.group(6)] += 1
        continue
    m = re.match(r'^\s*(\w+):\s*(\S+)\s+\S+\s+(\w+):\s*(\S+)\s*$', ln)
    if m and cur is not None:
        cur['pins'][m.group(1)] += 1
        continue

print('=== incorrect nets ===')
print('%-5s %-24s %-24s %8s %8s' % ('disc', 'layout', 'source', 'lay#', 'src#'))
for n in nets:
    print('%-5s %-24s %-24s %8s %8s' % (n['disc'], n['lay'][:24], n['src'][:24],
                                        n['layc'], n['srcc']))
print('')
for n in nets:
    print('--- disc %s : layout %s (%s conns) vs source %s (%s conns)'
          % (n['disc'], n['lay'], n['layc'], n['src'], n['srcc']))
    print('    layout-side device types on this net : %s'
          % ', '.join('%s x%d' % (k, v) for k, v in n['devs'].most_common(8)))
    print('    matched pin names                    : %s'
          % ', '.join('%s x%d' % (k, v) for k, v in n['pins'].most_common(8)))

# ---- incorrect instances ----
ii = marks.get('INCORRECT INSTANCES')
if ii is not None:
    print('')
    print('=== incorrect instances (first 40 lines) ===')
    for ln in lines[ii:ii + 40]:
        print('  %s' % ln.rstrip()[:150])
ui = marks.get('UNMATCHED')
if ui is not None:
    print('')
    print('=== unmatched (first 30 lines) ===')
    for ln in lines[ui:ui + 30]:
        print('  %s' % ln.rstrip()[:150])
