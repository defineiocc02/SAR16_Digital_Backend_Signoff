"""Two quick measurements read off the figures, so the captions quote numbers not impressions:

 1. where the port labels sit: which die edge, per label layer
 2. whether the cell placement really leaves the lower-left empty (quadrant occupancy)
"""
import collections
import io
import struct
import sys

sys.stdout.reconfigure(encoding='utf-8')
GDS = '../evidence/rpt_v51/sar_digi_paper_core_merged.gds'
TOP = 'sar_digi_paper_core'
DIE_W, DIE_H = 430.520, 429.340
REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR', 0x08: 'BOUNDARY', 0x09: 'PATH',
       0x0A: 'SREF', 0x0C: 'TEXT', 0x0D: 'LAYER', 0x10: 'XY', 0x12: 'SNAME', 0x19: 'STRING'}


def gds_real(b):
    sign = -1.0 if b[0] & 0x80 else 1.0
    return sign * (int.from_bytes(b[1:8], 'big') / float(1 << 56)) * (16.0 ** ((b[0] & 0x7F) - 64))


f = open(GDS, 'rb')
prec = 10000.0
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    if rt == 0x03 and len(d) >= 16:
        prec = 1e-6 / gds_real(d[8:16]); break
    if rt == 0x05:
        break
f.seek(0)

cur = layer = sname = None
labels, srefs = [], []
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur = layer = sname = None
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
    elif n == 'SNAME':
        sname = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'STRING':
        if cur == TOP and labels and labels[-1][0] == '':
            labels[-1][0] = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'XY':
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        if len(pts) == 2:
            x, y = pts[0] / prec, pts[1] / prec
            if sname and cur == TOP:
                srefs.append((sname, x, y)); sname = None
            elif cur == TOP:
                labels.append(['', layer, x, y])
f.close()

print('=== port labels: which die edge, by layer ===')
side_of = {}
for name, lay, x, y in labels:
    d = {'left': x, 'right': DIE_W - x, 'bottom': y, 'top': DIE_H - y}
    s = min(d, key=d.get)
    side_of.setdefault(lay, collections.Counter())[s] += 1
for lay in sorted(side_of):
    c = side_of[lay]
    print('  layer %-3d (%-2s) total %3d   left %3d  right %3d  bottom %3d  top %3d'
          % (lay, 'M2' if lay == 62 else 'M3' if lay == 63 else '?', sum(c.values()),
             c['left'], c['right'], c['bottom'], c['top']))

print('')
print('=== cell placement occupancy (non-via SREF), 4 x 4 grid over the die ===')
cells = [(x, y) for n, x, y in srefs if not n.startswith('$$')]
print('  cell placements: %d' % len(cells))
print('        %8s %8s %8s %8s' % ('x<107', '107-215', '215-322', '>322'))
for j in range(3, -1, -1):
    row = []
    for i in range(4):
        x0, x1 = i * DIE_W / 4, (i + 1) * DIE_W / 4
        y0, y1 = j * DIE_H / 4, (j + 1) * DIE_H / 4
        row.append(sum(1 for x, y in cells if x0 <= x < x1 and y0 <= y < y1))
    print('  y>=%3.0f %8d %8d %8d %8d' % (j * DIE_H / 4, row[0], row[1], row[2], row[3]))

low = sum(1 for x, y in cells if x < 150 and y < 100)
print('  placements with x<150 and y<100 : %d' % low)
xs = [x for x, y in cells]; ys = [y for x, y in cells]
print('  placement extent: x %.2f..%.2f   y %.2f..%.2f' % (min(xs), max(xs), min(ys), max(ys)))
