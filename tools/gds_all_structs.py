"""Where does the routing geometry actually live?

Round-22's census found the TOP cell `sar_digi_paper_core` carries 0 BOUNDARY / 0 PATH.
This lists EVERY struct with its element counts so the location of the routing is
evident from the file itself, instead of being inferred.
"""
import struct
import collections

GDS = 'sar_digi_paper_core_merged.gds'
REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR', 0x08: 'ENDEL', 0x0A: 'SREF',
       0x0B: 'AREF', 0x03: 'BOUNDARY', 0x09: 'PATH', 0x04: 'TEXT', 0x02: 'BOX',
       0x12: 'SNAME', 0x0D: 'LAYER'}

f = open(GDS, 'rb')
cur = None
stat = collections.OrderedDict()


def slot(name):
    if name not in stat:
        stat[name] = {'BOUNDARY': 0, 'PATH': 0, 'TEXT': 0, 'SREF': 0, 'AREF': 0,
                      'layers': set(), 'bytes': 0}
    return stat[name]


while True:
    h = f.read(4)
    if len(h) < 4:
        break
    rl, rt, rd = struct.unpack('>HBB', h)
    d = f.read(rl - 4) if rl >= 4 else b''
    n = REC.get(rt)
    if n == 'BGNSTR':
        cur = None
    elif n == 'STRNAME':
        cur = d.split(b'\x00')[0].decode('latin-1')
        slot(cur)
    elif cur is not None and n in ('BOUNDARY', 'PATH', 'TEXT', 'SREF', 'AREF'):
        slot(cur)[n] += 1
        slot(cur)['bytes'] += rl
    elif cur is not None and n == 'LAYER':
        slot(cur)['layers'].add(struct.unpack('>h', d)[0])
f.close()

print('structs in file: %d' % len(stat))
print('')
rows = []
for k, v in stat.items():
    rows.append((k, v['BOUNDARY'], v['PATH'], v['TEXT'], v['SREF'], v['AREF'], len(v['layers'])))
rows.sort(key=lambda r: -(r[1] + r[2]))

print('%-30s %9s %7s %6s %8s %5s %6s' % ('struct', 'BOUNDARY', 'PATH', 'TEXT', 'SREF', 'AREF', 'layers'))
for r in rows[:18]:
    print('%-30s %9d %7d %6d %8d %5d %6d' % r)
print('')
tot = [sum(r[i] for r in rows) for i in (1, 2, 3, 4, 5)]
print('%-30s %9d %7d %6d %8d %5d' % ('TOTAL (whole file)', tot[0], tot[1], tot[2], tot[3], tot[4]))
print('')
top = stat.get('sar_digi_paper_core')
if top:
    print('TOP cell sar_digi_paper_core : BOUNDARY=%d PATH=%d TEXT=%d SREF=%d layers=%s'
          % (top['BOUNDARY'], top['PATH'], top['TEXT'], top['SREF'], sorted(top['layers'])))
print('')
print('=== structs that DO carry polygons/paths (the routing suspects) ===')
for r in rows[:12]:
    if r[1] or r[2]:
        print('  %-30s BOUNDARY=%-7d PATH=%-6d SREF=%d' % (r[0], r[1], r[2], r[4]))
