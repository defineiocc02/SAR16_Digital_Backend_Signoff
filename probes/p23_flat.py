import collections
import subprocess

# ---------- 0) where do the underscore component types come from? ----------
probe_names = ['_invv', '_nand2b', '_sdw2v', '_bitcoreb', '_sup2v', '_tgmb', '_pmp2b']
files = ['svdb/sar_digi_paper_core.sp', 'sar16.cdl', 'smic18_san.cdl', 'mylvs.lvs']
print('=== 0) grep for underscore component types ===')
for nm in probe_names:
    hits = []
    for f in files:
        try:
            n = subprocess.run(['grep', '-c', '-F', nm, f], capture_output=True, text=True).stdout.strip()
        except Exception:
            n = 'ERR'
        hits.append('%s=%s' % (f.split('/')[-1], n))
    print('  %-12s %s' % (nm, '  '.join(hits)))
print('')

# ---------- 1) hierarchy-aware parser ----------
def parse(path):
    subs = collections.OrderedDict()
    order = []
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
                order.append(cur)
                continue
            if up.startswith('.ENDS'):
                cur = None
                continue
            if cur is None:
                continue
            c = line[0].upper()
            if c == 'M':
                subs[cur]['mos'] += 1
            elif c == 'X':
                t = line.split()
                subs[cur]['child'].append(t)
    return subs, order

lay, layorder = parse('svdb/sar_digi_paper_core.sp')
kit, _ = parse('smic18_san.cdl')
src, _ = parse('sar16.cdl')
src_all = dict(kit)
for k, v in src.items():
    src_all[k] = v

cellnames = set(k for k in lay if not k.startswith('ICV_') and lay[k]['mos'] > 0)

def resolve(tokens):
    """tokens = the token list of an X line (first token starts with X)."""
    body = tokens[1:]
    for tok in body:
        if '=' in tok:
            continue
        if tok in lay:
            return tok
    # fall back: second token is often the subckt in Calibre output
    for tok in body:
        if '=' not in tok:
            return tok
    return None

print('=== 1) sample X lines from the extracted layout netlist ===')
for ln in lay[layorder[-1]]['child'][:3] if False else []:
    pass
shown = 0
for k in layorder:
    for t in lay[k]['child']:
        if shown < 6:
            print('   [in %s] %s' % (k, ' '.join(t)[:150]))
            shown += 1

memo = {}
def flat(name, stack=()):
    if name in memo:
        return memo[name]
    if name in stack or name not in lay:
        return {'mos': 0, 'cells': collections.Counter(), 'unknown': collections.Counter()}
    v = lay[name]
    cells = collections.Counter()
    unknown = collections.Counter()
    mos = v['mos']
    for t in v['child']:
        ch = resolve(t)
        if ch in lay:
            sub = flat(ch, stack + (name,))
            mos += sub['mos']
            cells.update(sub['cells'])
            unknown.update(sub['unknown'])
            if ch in cellnames:
                cells[ch] += 1
        else:
            unknown[ch] += 1
    r = {'mos': mos, 'cells': cells, 'unknown': unknown}
    memo[name] = r
    return r

# find the real top: the subckt that is never instantiated
instantiated = set()
for k in lay:
    for t in lay[k]['child']:
        instantiated.add(resolve(t))
tops = [k for k in layorder if k not in instantiated and not k.startswith('ICV_') and (lay[k]['mos'] or lay[k]['child'])]
print('')
print('=== 2) root subckts (never instantiated) ===')
print('   %s' % ', '.join(tops))

for top in tops:
    r = flat(top)
    print('')
    print('--- root: %s ---' % top)
    print('   std-cell instances  = %d' % sum(r['cells'].values()))
    print('   total MOS (fingers) = %d' % r['mos'])
    print('   unknown instances   = %d  -> %s' % (sum(r['unknown'].values()), list(r['unknown'].items())[:8]))
    src_tot = 0
    for k, n in r['cells'].items():
        src_tot += src_all.get(k, {}).get('mos', 0) * n
    print('   same instances sized from SOURCE CDL devices = %d' % src_tot)
    print('   FINGER EXCESS (layout - source)              = %d' % (r['mos'] - src_tot))
    print('')
    print('   === per-master excess contribution (top 25) ===')
    rows = []
    for k, n in r['cells'].items():
        lm = lay[k]['mos'] if k in lay else 0
        sm = src_all.get(k, {}).get('mos', 0)
        if lm != sm:
            rows.append((k, n, lm, sm, n * (lm - sm)))
    rows.sort(key=lambda x: -abs(x[4]))
    print('   %-12s %6s %8s %8s %10s' % ('cell', 'insts', 'layMOS', 'srcMOS', 'excess'))
    for row in rows[:25]:
        print('   %-12s %6d %8d %8d %10d' % row)
    print('   ---- masters with excess: %d / %d ----' % (len(rows), len(r['cells'])))
