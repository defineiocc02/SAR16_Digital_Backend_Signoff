import collections
import os
import glob

def parse(path):
    """SPICE parser that joins '+' continuation lines (the trap)."""
    subs = collections.OrderedDict()
    order = []
    with open(path, 'r', errors='replace') as f:
        logical = []
        for raw in f:
            line = raw.rstrip('\n').rstrip('\r')
            st = line.strip()
            if st.startswith('+'):
                if logical:
                    logical[-1] = logical[-1] + ' ' + st[1:].strip()
                continue
            logical.append(line)
    _consume.cur = None
    for line in logical:
        _consume(line, subs, order)
    return subs, order

def _consume(line, subs, order):
    st = line.strip()
    if not st:
        return
    up = st.upper()
    if up.startswith('.SUBCKT'):
        t = st.split()
        cur = t[1]
        subs[cur] = {'mos': 0, 'child': [], 'pins': t[2:]}
        order.append(cur)
        _consume.cur = cur
        return
    if up.startswith('.ENDS'):
        _consume.cur = None
        return
    c = _consume.cur
    if c is None:
        return
    if st[0].upper() == 'M':
        subs[c]['mos'] += 1
    elif st[0].upper() == 'X':
        subs[c]['child'].append(st.split())

_consume.cur = None

lay, layorder = parse('svdb/sar_digi_paper_core.sp')
kit_cdl, _ = parse('smic18_san.cdl')
src, _ = parse('sar16.cdl')
src_all = dict(kit_cdl)
for k, v in src.items():
    src_all[k] = v

cellnames = [k for k in lay if not k.startswith('ICV_') and lay[k]['mos'] > 0]

print('=== 1) per-master finger count, three sources ===')
print('   A = kit GDS standalone (kitcheck/svdb/<CELL>.sp)')
print('   B = our merged GDS in-context (design svdb/<top>.sp)')
print('   C = source CDL (smic18_san.cdl)')
print('')
hdr = '%-14s %5s %5s %5s   %s' % ('cell', 'A', 'B', 'C', 'A-vs-B')
print(hdr)
rows = []
kitdir = '/home/<user>/sar16_work/proj_paper_core/kitcheck/svdb'
for c in sorted(cellnames):
    p = os.path.join(kitdir, c + '.sp')
    a = None
    if os.path.exists(p):
        ks, _ = parse(p)
        a = ks.get(c, {}).get('mos', None)
    b = lay[c]['mos']
    cc = src_all.get(c, {}).get('mos', None)
    rows.append((c, a, b, cc))
    flag = '' if (a is None or a == b) else '  <== MISMATCH'
    print('%-14s %5s %5s %5s   %s%s' % (c, a, b, cc, 'same' if a == b else 'DIFF', flag))

nomiss = sum(1 for r in rows if r[1] is not None)
mism = [r for r in rows if r[1] is not None and r[1] != r[2]]
print('')
print('masters with kit extraction available : %d' % nomiss)
print('masters where kit-standalone != in-context : %d' % len(mism))

print('')
print('=== 2) flattened attribution on the extracted layout netlist ===')
def resolve(tokens):
    for tok in tokens[1:]:
        if '=' in tok:
            continue
        if tok in lay:
            return tok
    return None

instantiated = set()
for k in lay:
    for t in lay[k]['child']:
        r = resolve(t)
        if r:
            instantiated.add(r)
tops = [k for k in layorder if k not in instantiated and (lay[k]['mos'] or lay[k]['child'])]
print('root subckts: %s' % ', '.join(tops))

memo = {}
def flat(name, stack=()):
    if name in memo:
        return memo[name]
    if name in stack or name not in lay:
        return {'mos': 0, 'cells': collections.Counter()}
    v = lay[name]
    cells = collections.Counter()
    mos = v['mos']
    for t in v['child']:
        ch = resolve(t)
        if ch in lay:
            sub = flat(ch, stack + (name,))
            mos += sub['mos']
            cells.update(sub['cells'])
            if ch in lay and not ch.startswith('ICV_'):
                cells[ch] += 1
        elif ch:
            cells[ch] += 1
    r = {'mos': mos, 'cells': cells}
    memo[name] = r
    return r

for top in tops:
    r = flat(top)
    n_cells = sum(r['cells'].values())
    src_tot = 0
    for k, n in r['cells'].items():
        src_tot += src_all.get(k, {}).get('mos', 0) * n
    print('')
    print('--- root %s ---' % top)
    print('cell instances in flattened layout  = %d' % n_cells)
    print('total layout fingers                = %d' % r['mos'])
    print('same instances, source CDL devices  = %d' % src_tot)
    print('FINGER EXCESS                       = %d' % (r['mos'] - src_tot))
    rows2 = []
    for k, n in r['cells'].items():
        lm = lay[k]['mos'] if k in lay else 0
        sm = src_all.get(k, {}).get('mos', 0)
        if lm != sm:
            rows2.append((k, n, lm, sm, n * (lm - sm)))
    rows2.sort(key=lambda x: -abs(x[4]))
    print('%-14s %6s %7s %7s %9s' % ('cell', 'insts', 'layFin', 'srcDev', 'excess'))
    tot = 0
    for row in rows2[:30]:
        tot += row[4]
        print('%-14s %6d %7d %7d %9d' % row)
    print('... masters with excess = %d ; sum of shown = %d' % (len(rows2), tot))
    print('unresolved child names (top 10): %s' % list(r['cells'].items())[:10])
