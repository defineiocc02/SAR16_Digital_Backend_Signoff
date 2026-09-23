"""Do the 20 netlist-only cells exist as real geometry in the delivered GDS?

The GDS top level places 3626 cells over 109 masters, but the extracted layout
netlist only contains 3606 instances over 89 masters.  The 20 missing types are each
instantiated exactly once in the netlist.  This checks whether their GDS structs
carry geometry, which separates "GDS content gap" from "netlist extra instances".
"""
import struct
import sys

GDS = sys.argv[1] if len(sys.argv) > 1 else 'sar_digi_paper_core_merged.gds'
WATCH = ['ADDHXL', 'AND3X2', 'AOI211X2', 'AOI211X4', 'AOI221XL', 'CLKINVXL', 'DFFSX4',
         'INVX8', 'MX2XL', 'MXI2X1', 'NAND4BX1', 'NOR2BX2', 'NOR3BX1', 'NOR3X1',
         'NOR4BX1', 'NOR4X1', 'OAI211X1', 'OR3X2', 'OR3XL', 'OR4XL']
# controls: cells that ARE used and DO extract
CTRL = ['NAND2XL', 'DFFSXL', 'INVXL', 'CLKINVX3']

REC = {0x05: 'BGNSTR', 0x06: 'STRNAME', 0x07: 'ENDSTR', 0x08: 'ENDEL', 0x0A: 'SREF',
       0x0B: 'AREF', 0x0D: 'LAYER', 0x0E: 'DATATYPE', 0x12: 'SNAME', 0x21: 'XY',
       0x03: 'BOUNDARY', 0x09: 'PATH', 0x04: 'TEXT', 0x02: 'BOX'}
ELEM = {'BOUNDARY', 'PATH', 'TEXT', 'BOX', 'SREF', 'AREF', 'NODE'}

f = open(GDS, 'rb')
cur = None
stat = {}
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
        stat.setdefault(cur, {'bytes': 0, 'elems': 0, 'sref': 0})
    elif cur is not None:
        stat[cur]['bytes'] += rl
        if n in ELEM:
            stat[cur]['elems'] += 1
            if n == 'SREF':
                stat[cur]['sref'] += 1
f.close()

print('structs in file: %d' % len(stat))
print('')
print('%-14s %10s %8s %8s   %-22s %s' % ('struct', 'bytes', 'elements', 'SREFs', 'inner struct', 'inner verdict'))


def inner_of(name):
    """Follow the single SREF of a kit-style wrapper cell to its real geometry."""
    f2 = open(GDS, 'rb')
    cur = None
    res = []
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
        elif n == 'SNAME' and cur == name:
            res.append(d.split(b'\x00')[0].decode('latin-1'))
    f2.close()
    return res


for group, tag in ((WATCH, 'netlist-only'), (CTRL, 'control (used)')):
    print('--- %s ---' % tag)
    for c in group:
        s = stat.get(c)
        if s is None:
            print('%-14s %10s %8s %8s   %-22s %s' % (c, '-', '-', '-', '-', 'STRUCT ABSENT'))
            continue
        kids = inner_of(c)
        kid = kids[0] if kids else None
        ks = stat.get(kid) if kid else None
        v = 'EMPTY (no geometry)' if s['elems'] == 0 else 'has geometry'
        print('%-14s %10d %8d %8d   %-22s %s'
              % (c, s['bytes'], s['elems'], s['sref'],
                 (kid[:22] if kid else 'NONE'),
                 ('elements=%d' % ks['elems']) if ks else 'inner struct ABSENT'))
