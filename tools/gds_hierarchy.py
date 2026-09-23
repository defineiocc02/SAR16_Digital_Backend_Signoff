"""Inspect the GDS hierarchy: how deep is it, and where do the device layers live?

The flattened renders were missing AA/GT/SN/SP/NW, which means expanding only the top cell's
direct SREFs is not enough.  This prints, for a few cell masters, the layers they draw
themselves and the children they reference.
"""
import collections
import io
import struct
import sys

sys.stdout.reconfigure(encoding='utf-8')
GDS = '../evidence/rpt_v51/sar_digi_paper_core_merged.gds'
TOP = 'sar_digi_paper_core'
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

lay = collections.defaultdict(collections.Counter)   # struct -> layer -> n
kids = collections.defaultdict(collections.Counter)  # struct -> child -> n
order = []
cur = layer = sname = None
elem = None
while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur = layer = sname = elem = None
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
        if cur not in order:
            order.append(cur)
    elif n == 'LAYER':
        layer = struct.unpack('>h', d)[0]
    elif n in ('BOUNDARY', 'PATH'):
        elem = n
    elif n == 'SNAME':
        sname = d.split(b'\x00')[0].decode('latin-1')
    elif n == 'XY':
        pts = struct.unpack('>%di' % (len(d) // 4), d)
        if elem and cur:
            lay[cur][layer] += 1
            elem = None
        elif len(pts) == 2 and sname and cur:
            kids[cur][sname] += 1
            sname = None
f.close()

depth = {}


def d_of(name, seen=None):
    seen = seen or set()
    if name in depth:
        return depth[name]
    if name in seen:
        return 0
    seen = seen | {name}
    k = kids.get(name)
    depth[name] = 1 + (max((d_of(c, seen) for c in k), default=-1) if k else -1)
    return depth[name]


print('structs: %d   top depth: %d' % (len(order), d_of(TOP)))
print('')
print('=== structs that draw DEVICE layers (AA=10, GT=14/30, SN=40, SP=43, NW=50) ===')
DEV = {10, 14, 30, 40, 43, 50}
found = 0
for name in order:
    hits = {l: c for l, c in lay[name].items() if l in DEV}
    if hits:
        found += 1
        if found <= 8:
            print('  %-28s device layers=%s   all layers=%s   children=%d'
                  % (name[:28], sorted(hits), sorted(lay[name]), len(kids.get(name, {}))))
print('  ... total %d structs draw device layers' % found)
print('')
print('=== a few standard cells as instantiated by the top cell ===')
insts = list(kids[TOP])
print('  top cell references %d distinct masters' % len(insts))
for m in insts[:6]:
    print('  %-22s layers=%-34s children=%s'
          % (m[:22], str(sorted(lay.get(m, {})))[:34],
             list(kids.get(m, {}))[:2]))
print('')
print('=== structs whose children draw the device layers ===')
for name in order[:6]:
    ch = list(kids.get(name, {}))
    if ch:
        print('  %-22s -> %s' % (name[:22], ch[:3]))
print('')
print('=== where does layer 10 (AA) appear? ===')
owners = [n for n in order if lay[n].get(10)]
print('  %d structs draw AA; first few: %s' % (len(owners), [o[:26] for o in owners[:6]]))
print('  are any of them referenced by the top cell? %s'
      % any(o in insts for o in owners))
print('  are any referenced by those masters?      %s'
      % any(o in kids.get(m, {}) for m in insts for o in owners))
