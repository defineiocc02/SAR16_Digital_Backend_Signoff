"""Port / pin census of the delivered GDS, and its reconciliation with the netlist and LVS.

Reads the TOP cell's TEXT labels (that is what a port/pin actually is in the layout) and
reports:
  * how many labels, how many DISTINCT names, and which names repeat (a repeated label is
    not a second port -- counting them as ports is a known trap)
  * the layer each label sits on, and which side of the die it is nearest to
  * the bounding box of all labels, for comparison with the die size

Everything is measured from the file; nothing is taken from a delivered document.
"""
import collections
import io
import struct
import sys

GDS = sys.argv[1] if len(sys.argv) > 1 else '../evidence/rpt_v51/sar_digi_paper_core_merged.gds'
TOP = 'sar_digi_paper_core'
REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR', 0x08: 'BOUNDARY', 0x09: 'PATH',
       0x0A: 'SREF', 0x0B: 'AREF', 0x0C: 'TEXT', 0x0D: 'LAYER', 0x0E: 'DATATYPE',
       0x0F: 'WIDTH', 0x10: 'XY', 0x11: 'ENDEL', 0x12: 'SNAME', 0x13: 'COLROW',
       0x16: 'TEXTTYPE', 0x19: 'STRING'}
ROLE = {61: 'M1', 62: 'M2', 63: 'M3', 64: 'M4', 65: 'M5', 66: 'M6',
        141: 'M1 text', 142: 'M2 text', 143: 'M3 text', 144: 'M4 text',
        145: 'M5 text', 146: 'M6 text'}
DIE_W, DIE_H = 430.520, 429.340     # from RESULT_CURRENT.env, for the side classification


def gds_real(b):
    sign = -1.0 if b[0] & 0x80 else 1.0
    exp = (b[0] & 0x7F) - 64
    mant = int.from_bytes(b[1:8], 'big') / float(1 << 56)
    return sign * mant * (16.0 ** exp)


f = open(GDS, 'rb')
prec = 10000.0
while True:
    hdr = f.read(4)
    if len(hdr) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', hdr)
    d = f.read(rl - 4) if rl >= 4 else b''
    if rt == 0x03 and len(d) >= 16:
        prec = 1e-6 / gds_real(d[8:16])
        break
    if rt == 0x05:
        break
f.seek(0)

cur = layer = None
pending_text = False
labels = []          # (name, layer, x_um, y_um)
text_per_struct = collections.Counter()
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur, layer, pending_text = None, None, False
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
    elif n == 'TEXT':
        if cur:
            text_per_struct[cur] += 1
        pending_text = (cur == TOP)
    elif n == 'XY' and pending_text:
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        if len(pts) >= 2:
            labels.append(['', layer, pts[0] / prec, pts[1] / prec])
    elif n == 'STRING' and pending_text and labels:
        labels[-1][0] = d.split(b'\x00')[0].decode('latin-1')
        pending_text = False
f.close()

print('GDS UNITS -> %.0f DBU/um   top cell = %s' % (prec, TOP))
print('TEXT labels in TOP            : %d' % len(labels))
print('TEXT records in the WHOLE file: %d  (across %d structs)'
      % (sum(text_per_struct.values()), len(text_per_struct)))
if text_per_struct:
    top5 = sorted(text_per_struct.items(), key=lambda x: -x[1])[:5]
    print('  structs carrying TEXT       : %s'
          % ', '.join('%s=%d' % (k[:26], v) for k, v in top5))
print('  --> a FILE-WIDE count is NOT a port count; only the top cell holds ports.')
names = [l[0] for l in labels]
uniq = sorted(set(names))
print('distinct label names          : %d' % len(uniq))
dup = [(k, v) for k, v in collections.Counter(names).items() if v > 1]
print('names appearing more than once: %d  (total extra labels: %d)'
      % (len(dup), sum(v - 1 for _, v in dup)))
for k, v in sorted(dup, key=lambda x: -x[1])[:12]:
    print('    %-24s x%d' % (k, v))
print('')

print('=== labels per layer ===')
for lay, c in sorted(collections.Counter(l[1] for l in labels).items()):
    print('  layer %-4d %-10s %4d' % (lay, ROLE.get(lay, '?'), c))
print('')

if labels:
    xs = [l[2] for l in labels]
    ys = [l[3] for l in labels]
    print('=== label extent (um) ===')
    print('  x: %.3f .. %.3f      y: %.3f .. %.3f' % (min(xs), max(xs), min(ys), max(ys)))
    print('  die: 0 .. %.3f   x   0 .. %.3f' % (DIE_W, DIE_H))
    print('')

    # nearest die edge
    side = collections.Counter()
    for _, _, x, y in labels:
        d = {'left': x, 'right': DIE_W - x, 'bottom': y, 'top': DIE_H - y}
        side[min(d, key=d.get)] += 1
    print('=== nearest die edge ===')
    for k in ('left', 'right', 'bottom', 'top'):
        print('  %-7s %4d' % (k, side[k]))
    print('')

    # a signal pin is normally ON a metal layer; a text layer means a label only
    metal_lbl = [l for l in labels if l[1] in (61, 62, 63, 64, 65, 66)]
    print('=== labels sitting on a metal layer (i.e. real pins) vs label-only layers ===')
    print('  on metal : %d' % len(metal_lbl))
    print('  otherwise: %d' % (len(labels) - len(metal_lbl)))
    print('')
    print('=== sample of distinct names (first 40) ===')
    for i in range(0, min(40, len(uniq)), 4):
        print('  ' + '  '.join('%-22s' % u for u in uniq[i:i + 4]))
