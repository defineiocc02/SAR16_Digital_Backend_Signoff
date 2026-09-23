#!/bin/bash
# Round 9 probe 2: attribute the layout device excess.
#  A) per-cell-master device count: layout(extracted) vs source(kit CDL)
#  B) recursive instantiation census of the extracted layout netlist
#     -> how many MOS live OUTSIDE any std cell (loose transistors)?
cd /home/<user>/sar16_work/proj_paper_core/calibre/lvs || exit 1

python3 - <<'PYEOF'
import collections

def parse(path):
    subs = collections.OrderedDict()
    cur = None
    with open(path, 'r', errors='replace') as f:
        for raw in f:
            line = raw.strip()
            if not line:
                continue
            up = line.upper()
            if up.startswith('.SUBCKT'):
                t = line.split()
                cur = t[1]
                subs[cur] = {'mos': 0, 'child': [], 'pins': t[2:]}
                continue
            if up.startswith('.ENDS'):
                cur = None
                continue
            if cur is None or line[0] in '*$':
                continue
            c = line[0].upper()
            if c == 'M':
                subs[cur]['mos'] += 1
            elif c == 'X':
                t = line.split()
                # subckt name is the last token that is not a param assignment
                name = None
                for tok in t[1:]:
                    if '=' in tok:
                        continue
                    name = tok
                subs[cur]['child'].append(name)
    return subs

lay = parse('svdb/sar_digi_paper_core.sp')
kit = parse('smic18_san.cdl')
src = parse('sar16.cdl')
src_all = dict(kit)
for k, v in src.items():
    src_all[k] = v

print('=== A) per-cell-master MOS count: layout vs source ===')
keys = [k for k in lay if lay[k]['mos'] > 0 and not k.startswith('ICV_')]
diff = []
for k in sorted(keys):
    lm = lay[k]['mos']
    sm = src_all.get(k, {}).get('mos', None)
    if sm is None:
        diff.append((k, lm, 'MISSING-IN-SOURCE'))
    elif lm != sm:
        diff.append((k, lm, sm))
print('cell masters compared      : %d' % len(keys))
print('masters with MOS mismatch  : %d' % len(diff))
for d in diff:
    print('   %-30s layout=%s source=%s' % d)

print()
print('=== B) recursive flatten of the extracted layout netlist ===')
icv = sorted([k for k in lay if k.startswith('ICV_')])
print('ICV blocks: %d -> %s' % (len(icv), ', '.join(icv)))
top = 'sar_digi_paper_core'
print('top %s direct children: %s' % (top, lay[top]['child']))

memo = {}
def flat(name, stack=()):
    if name in memo:
        return memo[name]
    if name in stack:
        return {'mos': 0, 'cells': collections.Counter(), 'loose': 0, 'x': 0}
    v = lay.get(name)
    if v is None:
        r = {'mos': 0, 'cells': collections.Counter(), 'loose': 0, 'x': 0}
        memo[name] = r
        return r
    cells = collections.Counter()
    mos = v['mos']
    x = 0
    for ch in v['child']:
        x += 1
        if ch in lay:
            sub = flat(ch, stack + (name,))
            mos += sub['mos']
            cells.update(sub['cells'])
            cells[ch] += 1
        else:
            cells[ch] += 1
    r = {'mos': mos, 'cells': cells, 'loose': v['mos'], 'x': x}
    memo[name] = r
    return r

# loose MOS that ends up in the flattened layout = per-instantiation sum
inst = collections.Counter()
def walk(name, mult, stack=()):
    if name in stack or name not in lay:
        return
    inst[name] += mult
    for ch in lay[name]['child']:
        walk(ch, mult, stack + (name,))

walk(top, 1)
print()
print('%-12s %6s %8s %8s' % ('block', 'insts', 'ownMOS', 'looseMOS'))
totloose = 0
for k in icv:
    own = lay[k]['mos']
    loose = own * inst.get(k, 0)
    totloose += loose
    print('%-12s %6d %8d %8d' % (k, inst.get(k, 0), own, loose))
print('total LOOSE MOS in flattened layout (from ICV blocks): %d' % totloose)

print()
print('=== C) totals ===')
r = flat(top)
tot_cells = sum(r['cells'].values())
print('flattened layout: cell instances = %d , MOS = %d' % (tot_cells, r['mos']))
print('flattened layout: cell-instance MOS = %d' % (tot_cells and 0 or 0))
src_tot = 0
for k, n in r['cells'].items():
    sm = src_all.get(k, {}).get('mos', 0)
    src_tot += sm * n
print('same instances sized from SOURCE CDL = %d' % src_tot)
print('net difference = %d' % (r['mos'] - src_tot))
print()
print('=== D) top-30 cell instance counts in flattened layout ===')
for k, n in r['cells'].most_common(30):
    print('  %-12s %5d  srcMOSeach=%s' % (k, n, src_all.get(k, {}).get('mos', 'NA')))
PYEOF
