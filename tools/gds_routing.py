"""GDS routing analysis: what is actually in the delivered layout, per layer.

Counts, for the TOP cell only (= the geometry P&R itself drew: rails, straps, signal
routing, vias), the number of BOUNDARY/PATH elements and their total area per layer.
Cell internals are referenced via SREF and therefore NOT counted here.
Precision is 10000 DBU/um, read from the file header.
"""
import struct
import collections
import sys

GDS = 'sar_digi_paper_core_merged.gds'
TOP = 'sar_digi_paper_core'
REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR',
       0x08: 'BOUNDARY', 0x09: 'PATH', 0x0A: 'SREF', 0x0B: 'AREF', 0x0C: 'TEXT',
       0x0D: 'LAYER', 0x0E: 'DATATYPE', 0x0F: 'WIDTH', 0x10: 'XY', 0x11: 'ENDEL',
       0x12: 'SNAME', 0x13: 'COLROW', 0x15: 'NODE', 0x16: 'TEXTTYPE', 0x19: 'STRING',
       0x1A: 'STRANS', 0x1B: 'MAG', 0x1C: 'ANGLE'}
# NOTE: the first version of this file used 0x03 for BOUNDARY and 0x21 for XY.  Both are
# wrong (0x03 is UNITS, 0x21 is unused) and that is why it reported ZERO polygons in the
# whole file -- a parser defect, not a layout defect.

def gds_real(b):
    """GDSII 8-byte real: sign bit, excess-64 exponent, 56-bit mantissa."""
    sign = -1.0 if b[0] & 0x80 else 1.0
    exp = (b[0] & 0x7F) - 64
    mant = int.from_bytes(b[1:8], 'big') / float(1 << 56)
    return sign * mant * (16.0 ** exp)


f = open(GDS, 'rb')
prec = None
# UNITS is not necessarily the first record: scan the header records until it is found.
while True:
    hdr = f.read(4)
    if len(hdr) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', hdr)
    d = f.read(rl - 4) if rl >= 4 else b''
    if rt == 0x03 and len(d) >= 16:
        dbu_m = gds_real(d[8:16])      # metres per database unit
        prec = 1e-6 / dbu_m            # database units per micrometre
        break
    if rt == 0x05:                     # BGNSTR: header section over
        break
if prec is None:
    print('UNITS not found; assuming 10000 DBU/um (the documented value for this file)')
    prec = 10000.0
print('GDS UNITS -> %.0f DBU/um' % prec)
f.seek(0)

cur = None
layer = dt = None
per = collections.defaultdict(lambda: [0, 0, 0.0])   # cell -> layer: [bnd, path, area]
sref = collections.Counter()
buf_xy = None
elem = None
# NOTE on attribution: an element must be counted on the layer of its OWN `LAYER` record.
# Counting it on the BOUNDARY record instead reads the PREVIOUS element's layer (the LAYER
# record of this element has not been read yet at that point) and shifts one element at
# every layer change -- that is why an earlier revision reported M1 7911 / M3 10115 / M6 2
# instead of 7912 / 10114 / 3.  Attributes here at XY time.
f.seek(0)
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur = None
        elem = None
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'SNAME':
        # KEY FIX: count references made BY THE TOP CELL only.  The previous version
        # counted SNAME over the whole file, which includes the 109 inner-cell references
        # that live INSIDE the library wrapper structs -- that is exactly where the bogus
        # "3735 vs 3626" and "224 distinct masters" came from.
        if cur == TOP:
            sref[d.split(b'\x00')[0].decode('latin-1')] += 1
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
    elif n == 'DATATYPE':
        dt = struct.unpack('>h', d)[0]
    elif n in ('BOUNDARY', 'PATH'):
        elem = n
    elif n == 'XY':
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        if elem and cur == TOP:
            k = (cur, layer)
            per[k][0 if elem == 'BOUNDARY' else 1] += 1
            if len(pts) >= 4:
                xs = pts[0::2]
                ys = pts[1::2]
                per[k][2] += (max(xs) - min(xs)) * (max(ys) - min(ys)) / (prec * prec)
        elem = None
f.close()

# layer roles (from the LVS deck mapping recorded earlier)
ROLE = {10: 'AA active', 14: 'GT poly', 30: 'GT poly', 40: 'SN', 43: 'SP', 50: 'NWELL',
        61: 'M1', 62: 'M2', 63: 'M3', 64: 'M4', 65: 'M5', 66: 'M6',
        67: 'V1', 68: 'V2', 69: 'V3', 70: 'V4', 71: 'V5', 72: 'V6',
        127: 'frame outline', 141: 'M1 text'}
rows = [(l, v[0], v[1], v[2]) for (c, l), v in per.items() if c == TOP]
rows.sort(key=lambda r: -r[3])
print('')
print('=== TOP cell %s : geometry P&R itself drew ===' % TOP)
print('%-6s %-14s %8s %8s %12s' % ('layer', 'role', 'BOUNDARY', 'PATH', 'area um2'))
tot = 0.0
for l, b, p, a in rows:
    print('%-6d %-14s %8d %8d %12.0f' % (l, ROLE.get(l, '?'), b, p, a))
    tot += a
print('%-6s %-14s %8s %8s %12.0f' % ('', 'TOTAL', '', '', tot))

print('')
print('=== SREFs in the TOP cell (placed cells / vias) ===')
tot_ref = sum(sref.values())
print('  distinct masters referenced : %d' % len(sref))
print('  total SREF count            : %d' % tot_ref)
via = {k: v for k, v in sref.items() if k.startswith('$$')}
if via:
    print('  via arrays ($$*)            : %d placements, %d kinds'
          % (sum(via.values()), len(via)))
    for k, v in sorted(via.items(), key=lambda x: -x[1])[:8]:
        print('    %-16s %6d' % (k, v))
    print('  real cell placements        : %d' % (tot_ref - sum(via.values())))
