"""Inventory every layer actually present in the delivered GDS (all structs), so the
layout renders can carry an honest legend instead of guessing layer names."""
import collections
import io
import struct
import sys

sys.stdout.reconfigure(encoding='utf-8')
GDS = '../evidence/rpt_v51/sar_digi_paper_core_merged.gds'
REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR', 0x08: 'BOUNDARY', 0x09: 'PATH',
       0x0A: 'SREF', 0x0C: 'TEXT', 0x0D: 'LAYER', 0x0E: 'DATATYPE', 0x10: 'XY', 0x11: 'ENDEL',
       0x12: 'SNAME', 0x19: 'STRING'}
NAME = {10: 'AA active', 14: 'GT poly', 30: 'GT poly(2)', 40: 'SN', 43: 'SP', 50: 'NW',
        61: 'M1', 62: 'M2', 63: 'M3', 64: 'M4', 65: 'M5', 66: 'M6',
        67: 'V1?', 68: 'V2?', 69: 'V3?', 70: 'cut70', 71: 'cut71', 72: 'cut72',
        73: 'cut73', 74: 'cut74', 127: 'frame', 141: 'M1 text', 142: 'M2 text',
        143: 'M3 text', 144: 'M4 text', 145: 'M5 text', 146: 'M6 text'}


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

cnt = collections.Counter()
area = collections.Counter()
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
        cur = layer = elem = None
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
    elif n in ('BOUNDARY', 'PATH'):
        elem = n
    elif n == 'XY' and elem is not None:
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        if len(pts) >= 4:
            xs, ys = pts[0::2], pts[1::2]
            cnt[layer] += 1
            area[layer] += (max(xs) - min(xs)) * (max(ys) - min(ys)) / (prec * prec)
        elem = None
f.close()

print('%-6s %-12s %9s %14s' % ('layer', 'guess', 'shapes', 'area um2'))
for lay in sorted(cnt, key=lambda l: -area[l]):
    print('%-6s %-12s %9d %14.1f' % (lay, NAME.get(lay, '?'), cnt[lay], area[lay]))
print('')
print('total shapes %d   total area %.0f um2' % (sum(cnt.values()), sum(area.values())))
