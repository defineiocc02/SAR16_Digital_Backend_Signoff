"""Per-layer metal routing detail for the delivered GDS.

For the TOP cell only -- the geometry P&R itself drew -- per layer:
  * BOUNDARY / PATH counts (counted on the element record, the SAME convention as
    gds_routing.py, so the totals reconcile exactly with the census)
  * drawn wire length along each shape's major axis, split horizontal / vertical
    (a router draws a horizontal segment as a rectangle with dx >> dy, so the major axis
    is the direction of travel and the minor axis is the drawn width)
  * drawn-width statistics and a histogram
  * the layer's direction preference

It also reports, for each `$$via*` master, the RAW layer numbers it contains: the via-cut
numbering in this file is not the one assumed from the LVS deck, so the numbers are printed
rather than translated into names.
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
METAL = {61: 'M1', 62: 'M2', 63: 'M3', 64: 'M4', 65: 'M5', 66: 'M6', 30: 'GT poly'}


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

geo = collections.defaultdict(lambda: {'n': 0, 'bnd': 0, 'path': 0, 'area': 0.0,
                                       'h': 0.0, 'v': 0.0, 'w': []})
struct_layers = collections.defaultdict(set)
struct_shapes = collections.Counter()

cur = layer = None
elem = None
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur, layer, elem = None, None, None
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
        if cur:
            struct_layers[cur].add(layer)
    elif n in ('BOUNDARY', 'PATH'):
        elem = n
    elif n == 'XY' and elem and layer is not None:
        # count on the element's OWN layer (the LAYER record precedes XY).  Counting on the
        # BOUNDARY record instead uses the previous element's layer and shifts one element
        # at every layer change -- see the note in gds_routing.py.
        if cur:
            s = geo[(cur, layer)]
            s['n'] += 1
            struct_shapes[cur] += 1
            if elem == 'PATH':
                s['path'] += 1
            else:
                s['bnd'] += 1
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        if len(pts) >= 4:
            xs, ys = pts[0::2], pts[1::2]
            dx = (max(xs) - min(xs)) / prec
            dy = (max(ys) - min(ys)) / prec
            s = geo[(cur, layer)]
            s['area'] += dx * dy
            if dx >= dy:
                s['h'] += dx
                s['w'].append(dy)
            else:
                s['v'] += dy
                s['w'].append(dx)
        elem = None
f.close()

print('GDS UNITS -> %.0f DBU/um   top cell = %s' % (prec, TOP))
print()
print('=== per-layer routing drawn by the TOP cell ===')
print('%-9s %8s %7s %7s %11s %11s %11s %5s %7s %7s' %
      ('layer', 'shapes', 'BNDRY', 'PATH', 'area um2', 'lenH um', 'lenV um', 'dir', 'minW', 'medW'))
tot_shapes = 0
tot_len = 0.0
LISTED = (61, 62, 63, 64, 65, 66, 30)
for lay in LISTED:
    s = geo.get((TOP, lay))
    if not s or not s['n']:
        continue
    h_, v_ = s['h'], s['v']
    d = 'H' if h_ > 2 * v_ else ('V' if v_ > 2 * h_ else 'mix')
    print('%-9s %8d %7d %7d %11.0f %11.1f %11.1f %5s %7.3f %7.3f' %
          (METAL.get(lay, str(lay)), s['n'], s['bnd'], s['path'], s['area'], h_, v_, d,
           min(s['w']) if s['w'] else 0, sorted(s['w'])[len(s['w']) // 2] if s['w'] else 0))
    tot_shapes += s['n']
    tot_len += h_ + v_
# catch-all: every OTHER layer the top cell drew, so nothing can be silently dropped
extra = sorted((l for (c, l) in geo if c == TOP and l not in LISTED and geo[(c, l)]['n']),
               key=lambda x: (-1 if x is None else x))
for lay in extra:
    s = geo[(TOP, lay)]
    print('%-9s %8d %7d %7d %11.1f %11.1f %11.1f %5s %7s %7s' %
          (('layer %s' % lay) if lay is not None else 'NO-LAYER', s['n'], s['bnd'],
           s['path'], s['area'], s['h'], s['v'], '?', '-', '-'))
    tot_shapes += s['n']
    tot_len += s['h'] + s['v']
print('%-9s %8d %7s %7s %11s %11.1f' % ('TOTAL', tot_shapes, '', '', '', tot_len))
print('  layers drawn by the top cell: %s'
      % ', '.join(str(l) for l in sorted((x for x in set(l for (c, l) in geo if c == TOP)),
                                         key=lambda x: (-1 if x is None else x))))
print('  census cross-check: 37 836 expected -> %s'
      % ('MATCH' if tot_shapes == 37836 else 'MISMATCH (%d)' % tot_shapes))
print()

print('=== drawn-width histogram (um), routing shapes only ===')
for lay in (61, 62, 63, 64, 65, 66):
    s = geo.get((TOP, lay))
    if not s or not s['w']:
        continue
    hist = collections.Counter()
    for x in s['w']:
        hist['<0.30' if x < 0.3 else '0.30-0.49' if x < 0.5 else
             '0.50-0.99' if x < 1.0 else '1.0-2.9' if x < 3.0 else '>=3.0'] += 1
    parts = ' '.join('%s:%d' % (k, hist[k]) for k in
                     ('<0.30', '0.30-0.49', '0.50-0.99', '1.0-2.9', '>=3.0') if hist[k])
    print('  %-4s max=%-8.3f %s' % (METAL[lay], max(s['w']), parts))
print()

print('=== each $$via master: RAW layers it contains, and how many times it is placed ===')
sref = collections.Counter()
f2 = open(GDS, 'rb')
f2.seek(0)
cur = None
while True:
    h = f2.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f2.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur = None
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'SNAME' and cur == TOP:
        sref[d.split(b'\x00')[0].decode('latin-1')] += 1
f2.close()
via_tot = 0
for name in sorted(struct_layers):
    if not name.startswith('$$'):
        continue
    print('  %-24s layers=%-18s shapes=%-4d placements=%d'
          % (name, ','.join(str(l) for l in sorted(struct_layers[name])),
             struct_shapes[name], sref.get(name, 0)))
    via_tot += sref.get(name, 0)
print('  %-24s %35s %d' % ('ALL vias', 'total placements =', via_tot))
