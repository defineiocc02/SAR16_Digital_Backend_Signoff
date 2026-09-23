"""How are the 178 ports actually arranged in the delivered GDS?

For every port label (TEXT in the top cell) this measures:
  * which die edge it belongs to, and its coordinate ALONG that edge
  * the spacing to the next port on the same edge (pitch)
  * the metal rectangle the label sits on -- i.e. the actual PIN shape: layer, size
  * the port name, so buses and single signals can be told apart

Everything comes from the file; nothing is inferred from a spec or a pin list.
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
       0x0A: 'SREF', 0x0C: 'TEXT', 0x0D: 'LAYER', 0x10: 'XY', 0x11: 'ENDEL', 0x12: 'SNAME',
       0x19: 'STRING'}
LAY = {61: 'M1', 62: 'M2', 63: 'M3', 64: 'M4', 65: 'M5', 66: 'M6'}


def gds_real(b):
    s = -1.0 if b[0] & 0x80 else 1.0
    return s * (int.from_bytes(b[1:8], 'big') / float(1 << 56)) * (16.0 ** ((b[0] & 0x7F) - 64))


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

labels = []
metal = collections.defaultdict(list)     # layer -> rects in the top cell
cur = layer = elem = None
pending = False
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur = layer = elem = None
        pending = False
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
    elif n in ('BOUNDARY', 'PATH'):
        elem = n
    elif n == 'TEXT':
        pending = (cur == TOP)
    elif n == 'STRING':
        if pending and labels and labels[-1][0] == '':
            labels[-1][0] = d.split(b'\x00')[0].decode('latin-1')
            pending = False
    elif n == 'XY':
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        if pending and cur == TOP and len(pts) == 2:
            labels.append(['', layer, pts[0] / prec, pts[1] / prec])
        elif elem and cur == TOP and len(pts) >= 4:
            xs, ys = pts[0::2], pts[1::2]
            metal[layer].append((min(xs) / prec, min(ys) / prec,
                                 max(xs) / prec, max(ys) / prec))
        elem = None
f.close()

print('port labels: %d   layers: %s' % (len(labels),
      dict(collections.Counter(LAY.get(l[1], l[1]) for l in labels))))
print('')

EDGES = {'bottom': lambda x, y: y, 'top': lambda x, y: DIE_H - y,
         'left': lambda x, y: x, 'right': lambda x, y: DIE_W - x}


def edge_of(x, y):
    d = {k: fn(x, y) for k, fn in EDGES.items()}
    return min(d, key=d.get)


groups = collections.defaultdict(list)
for (nm, lay, x, y) in labels:
    groups[(LAY.get(lay, lay), edge_of(x, y))].append((nm, x, y))

for (lay, edge) in sorted(groups, key=lambda k: (k[0], k[1])):
    pts = groups[(lay, edge)]
    along = sorted(p[1] if edge in ('bottom', 'top') else p[2] for p in pts)
    gaps = [round(along[i + 1] - along[i], 3) for i in range(len(along) - 1)]
    med = sorted(gaps)[len(gaps) // 2] if gaps else 0
    print('=== %s / %s edge : %d ports ===' % (lay, edge, len(pts)))
    print('    along-edge range %.3f .. %.3f µm' % (along[0], along[-1]))
    print('    spacing: min %.3f  median %.3f  max %.3f µm'
          % (min(gaps), med, max(gaps)))
    # how many distinct spacings (a uniform row of pins shows one value)
    c = collections.Counter(gaps)
    print('    distinct spacings: %s' % dict(list(c.most_common(5))))
    print('    names: %s' % ', '.join(sorted(p[0] for p in pts)[:10]) + ' ...')
    print('')

print('=== the pin shape each label sits on (top-cell metal under the label) ===')
sizes = collections.Counter()
nomatch = 0
for (nm, lay, x, y) in labels:
    hit = None
    for cand in (lay,) + tuple(LAY):          # try its own layer first, then any metal
        for (a, b, c, e) in metal.get(cand, []):
            if a - 0.01 <= x <= c + 0.01 and b - 0.01 <= y <= e + 0.01:
                hit = (cand, round(c - a, 3), round(e - b, 3))
                break
        if hit:
            break
    if not hit:
        nomatch += 1
        continue
    sizes[(LAY.get(hit[0], hit[0]), hit[1], hit[2])] += 1
print('  labels with a metal shape at the label point: %d / %d   (no shape: %d)'
      % (sum(sizes.values()), len(labels), nomatch))
for (l, w, h), c in sizes.most_common(12):
    print('    %-3s  %-6.3f x %-6.3f µm   x%d' % (l, w, h, c))
