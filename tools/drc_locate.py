"""Locate the DRC violations from Calibre's ASCII results database (drc_CAL.OUT).

The .SUM only carries counts; the .OUT carries the polygons.  For every rule that fired
this reports the count, the rule text (verbatim, i.e. from the deck), the bounding box of
all its violations, and how many sit on the die edge -- which is what decides whether a
finding is a real layout defect or an artefact of checking a block-level layout with a
full-chip deck that expects a seal ring.

Block layout:
    <rule name>
    <count> <count> <n> <Mon DD HH:MM:SS YYYY>
    Rule File Pathname: mydrc.drc
    <description, possibly several lines>
    p <idx> <npts>
    <x> <y>   (DBU)
    ...

Segmentation is done by HEADER POSITIONS, not by scanning for the next `p` line: a rule
with zero results has no `p` line at all, and the first version of this script therefore
walked straight into the following block and silently dropped ~90 % of the file.
"""
import io
import re
import sys

P = sys.argv[1] if len(sys.argv) > 1 else '../evidence/v51/drc_CAL.OUT'
DIE_W, DIE_H = 430.520, 429.340
EDGE_BAND = 5.0

lines = [l.replace('\x00', '')
         for l in io.open(P, encoding='utf-8', errors='replace').read().splitlines()]

hdr_re = re.compile(r'^(\d+)\s+(\d+)\s+\d+\s+[A-Z][a-z]{2}\s+\d+\s+[\d:]+\s+\d{4}\s*$')
hdr_idx = [i for i, l in enumerate(lines) if hdr_re.match(l) and i > 0]
print('results database : %s' % P)
print('header lines     : %d' % len(hdr_idx))

blocks = []
for k, i in enumerate(hdr_idx):
    name = lines[i - 1].strip()
    if not re.match(r'^[A-Za-z]\w*$', name):
        continue
    cnt = int(hdr_re.match(lines[i]).group(1))
    end = hdr_idx[k + 1] - 1 if k + 1 < len(hdr_idx) else len(lines)
    body = lines[i + 1:end]
    desc = []
    for b in body:
        if b.startswith('p '):
            break
        if b.strip() and not b.startswith('Rule File Pathname'):
            desc.append(b.strip())
    pts = []
    j = 0
    while j < len(body):
        m = re.match(r'^p \d+ (\d+)$', body[j])
        if not m:
            j += 1
            continue
        n = int(m.group(1))
        xs, ys = [], []
        for t in range(j + 1, min(j + 1 + n, len(body))):
            xy = body[t].split()
            if len(xy) >= 2 and re.match(r'^-?\d+$', xy[0]):
                xs.append(int(xy[0]) / 10000.0)
                ys.append(int(xy[1]) / 10000.0)
        if xs:
            pts.append((min(xs), min(ys), max(xs), max(ys)))
        j += 1 + n
    blocks.append((name, cnt, ' '.join(desc)[:210], pts))

fired = [b for b in blocks if b[1] > 0 or b[3]]
print('blocks segmented : %d   (fired: %d)' % (len(blocks), len([b for b in blocks if b[1] > 0])))
print('')
print('=== rules that fired ===')
for name, cnt, desc, pts in sorted(fired, key=lambda x: -x[1]):
    if pts:
        x0 = min(p[0] for p in pts); y0 = min(p[1] for p in pts)
        x1 = max(p[2] for p in pts); y1 = max(p[3] for p in pts)
        edge = sum(1 for p in pts
                   if p[0] < EDGE_BAND or p[1] < EDGE_BAND
                   or p[2] > DIE_W - EDGE_BAND or p[3] > DIE_H - EDGE_BAND)
        head = ('%-8s reported=%-6d polygons=%-6d bbox=(%.2f,%.2f)-(%.2f,%.2f)  on_die_edge=%d (%.0f%%)'
                % (name, cnt, len(pts), x0, y0, x1, y1, edge, 100.0 * edge / len(pts)))
    else:
        head = '%-8s reported=%-6d polygons=%-6d' % (name, cnt, len(pts))
    print(head)
    print('         rule: %s' % desc)
print('')
print('=== reconciliation ===')
print('  sum of reported counts : %d' % sum(b[1] for b in blocks))
print('  sum of parsed polygons : %d' % sum(len(b[3]) for b in blocks))
