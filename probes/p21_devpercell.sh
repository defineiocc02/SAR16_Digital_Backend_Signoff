#!/bin/bash
# Round 9 probe: per-subckt MOS device census, layout(extracted) vs source(CDL).
# Decisive question: WHERE are the +660 raw layout devices?
cd /home/<user>/sar16_work/proj_paper_core/calibre/lvs || exit 1

python3 - <<'PYEOF'
import re, json, collections

def census(path, label):
    subs = collections.OrderedDict()
    cur = None
    with open(path, 'r', errors='replace') as f:
        for raw in f:
            line = raw.rstrip('\n')
            if not line:
                continue
            first = line[0]
            if first in ' \t':
                first = line.lstrip()[0] if line.strip() else ''
                line = line.lstrip()
            if line[:8].upper().startswith('.SUBCKT'):
                toks = line.split()
                cur = toks[1] if len(toks) > 1 else '<noname>'
                subs.setdefault(cur, {'mos': 0, 'x': 0, 'd': 0, 'r': 0, 'c': 0, 'pins': len(toks) - 2})
                continue
            if line[:5].upper().startswith('.ENDS'):
                cur = None
                continue
            if cur is None:
                continue
            c = line[0]
            cu = c.upper()
            if cu == 'M':
                subs[cur]['mos'] += 1
            elif cu == 'X':
                subs[cur]['x'] += 1
            elif cu == 'D':
                subs[cur]['d'] += 1
            elif cu == 'R':
                subs[cur]['r'] += 1
            elif cu == 'C':
                subs[cur]['c'] += 1
    return subs

lay = census('svdb/sar_digi_paper_core.sp', 'layout')
src = census('sar16.cdl', 'cdl-main')
kit = census('smic18_san.cdl', 'cdl-kit')

# merge source side: kit holds the std-cell subckts
src_all = collections.OrderedDict()
for d in (kit, src):
    for k, v in d.items():
        if k in src_all:
            src_all[k]['mos'] += v['mos']
            src_all[k]['x'] += v['x']
        else:
            src_all[k] = dict(v)

print('=== SECTION 1: census sizes ===')
print('layout(extracted) subckts : %d   total MOS %d' % (len(lay), sum(v['mos'] for v in lay.values())))
print('kit cdl subckts           : %d   total MOS %d' % (len(kit), sum(v['mos'] for v in kit.values())))
print('main cdl subckts          : %d   total MOS %d' % (len(src), sum(v['mos'] for v in src.values())))
print()

print('=== SECTION 2: layout subckts that are DEVICE MODEL stubs (mos==0,x==0) ===')
stub = [k for k, v in lay.items() if v['mos'] == 0 and v['x'] == 0]
print('count=%d' % len(stub))
print(', '.join(stub[:40]))
print()

print('=== SECTION 3: layout subckts WITH content (mos>0 or x>0) ===')
print('%-58s %7s %7s' % ('layout subckt', 'MOS', 'Xinst'))
for k, v in sorted(lay.items(), key=lambda kv: -kv[1]['mos']):
    if v['mos'] or v['x']:
        print('%-58s %7d %7d' % (k, v['mos'], v['x']))
print()

print('=== SECTION 4: top-level-ish layout subckt (largest X count) ===')
top = max(lay.items(), key=lambda kv: kv[1]['x'])
print('%s  MOS=%d Xinst=%d' % (top[0], top[1]['mos'], top[1]['x']))
PYEOF
