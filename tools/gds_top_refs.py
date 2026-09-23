"""Print exactly what the TOP cell references, with counts. Minimal and self-contained."""
import struct
import collections

GDS = 'sar_digi_paper_core_merged.gds'
TOP = 'sar_digi_paper_core'
REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR', 0x08: 'BOUNDARY', 0x09: 'PATH',
       0x0A: 'SREF', 0x0B: 'AREF', 0x0C: 'TEXT', 0x0D: 'LAYER', 0x0E: 'DATATYPE',
       0x10: 'XY', 0x11: 'ENDEL', 0x12: 'SNAME', 0x13: 'COLROW'}

f = open(GDS, 'rb')
cur = None
refs = collections.Counter()
structs = set()
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
        structs.add(cur)
    elif n == 'SNAME' and cur == TOP:
        refs[d.split(b'\x00')[0].decode('latin-1')] += 1
f.close()

print('structs defined in the file : %d' % len(structs))
print('TOP cell                    : %s' % TOP)
print('distinct masters referenced : %d' % len(refs))
print('total SREFs in TOP          : %d' % sum(refs.values()))
print('')
print('%-34s %8s' % ('master referenced BY THE TOP', 'count'))
for k, v in refs.most_common():
    print('%-34s %8d' % (k, v))
print('')
missing = [k for k in refs if k not in structs]
print('referenced but NOT defined in this file : %s' % (missing if missing else 'none'))
