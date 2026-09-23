"""Read the object-count table straight out of Calibre's own report.

Row shapes in the report:
    Instances:         98        98         MN (4 pins)
                       95        98    *    MP (4 pins)
                       15        15         ADDFHXL (5 pins)
so a row is "two integers, optional *, then a component type in the trailing text".
"""
import io
import re
import sys

path = sys.argv[1]
lines = io.open(path, encoding='utf-8', errors='replace').read().splitlines()

for marker in ('INITIAL NUMBERS OF OBJECTS', 'NUMBERS OF OBJECTS AFTER TRANSFORMATION'):
    start = None
    for i, ln in enumerate(lines):
        if marker in ln:
            start = i
            break
    if start is None:
        continue
    print('=== %s ===' % marker)
    rows = []
    for ln in lines[start:start + 400]:
        if ln.strip().startswith('Total Inst'):
            m = re.match(r'\s*Total Inst:\s+(\d+)\s+(\d+)', ln)
            if m:
                print('  %-22s %8s %8s' % ('Total Inst', m.group(1), m.group(2)))
            break
        m = re.match(r'^\s*(?:\w+:\s+)?(\d+)\s+(\d+)\s*(\*?)\s*(.+?)\s*$', ln)
        if m:
            rows.append((m.group(4), int(m.group(1)), int(m.group(2)), m.group(3) == '*'))
            continue
        m2 = re.match(r'^\s*(Ports|Nets):\s+(\d+)\s+(\d+)\s*(\*?)\s*$', ln)
        if m2:
            print('  %-22s %8s %8s %s' % (m2.group(1), m2.group(2), m2.group(3), m2.group(4)))
    mism = [r for r in rows if r[3] or r[1] != r[2]]
    print('  rows total=%d   mismatching=%d' % (len(rows), len(mism)))
    if mism:
        print('  --- mismatching rows ---')
        for name, a, b, star in sorted(mism, key=lambda r: -(abs(r[1] - r[2]))):
            print('    %-30s layout=%-8d source=%-8d delta=%+d' % (name, a, b, a - b))
    print('')
