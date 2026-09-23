"""Loose-transistor census of the extracted layout netlist (round 16).

Question: the LVS device table says the LAYOUT has 98 MN / 95 MP outside the boxed
standard cells, the SOURCE has 98 / 98.  Where are the layout's loose devices, and do
they sit on the same nets as the 9 incorrect nets that touch none of the 15
boundary-port masters?
"""
import collections
import io
import re

SP = 'sar_digi_paper_core.sp'
LEF = 'sar_digi_paper_core.lef'

cells = set()
for ln in io.open(LEF, encoding='utf-8', errors='replace'):
    m = re.match(r'^MACRO\s+(\S+)\s*$', ln.rstrip())
    if m:
        cells.add(m.group(1))

logical = []
for raw in io.open(SP, encoding='utf-8', errors='replace'):
    st = raw.strip()
    if st.startswith('+'):
        if logical:
            logical[-1] = logical[-1] + ' ' + st[1:].strip()
        continue
    logical.append(st)

known = set()
for st in logical:
    if st.upper().startswith('.SUBCKT'):
        known.add(st.split()[1])

subs = collections.OrderedDict()
cur = None
for st in logical:
    up = st.upper()
    if up.startswith('.SUBCKT'):
        cur = st.split()[1]
        subs[cur] = {'mos': [], 'kids': []}
        continue
    if up.startswith('.ENDS'):
        cur = None
        continue
    if cur is None or not st:
        continue
    c = st[0].upper()
    if c == 'M':
        t = st.split()
        subs[cur]['mos'].append(t)
    elif c == 'X':
        toks = [x for x in st.split()[1:] if '=' not in x]
        nm = None
        for x in toks:
            if x in cells or x in known:
                nm = x
                break
        subs[cur]['kids'].append((st, nm))

# recursive loose-device attribution
memo = {}

def rec(name, stack=()):
    if name in memo:
        return memo[name]
    if name in stack or name not in subs:
        return {'mn': 0, 'mp': 0, 'nets': collections.Counter()}
    mn = mp = 0
    nets = collections.Counter()
    for t in subs[name]['mos']:
        model = t[5] if len(t) > 5 else ''
        if model.lower().startswith('n'):
            mn += 1
        else:
            mp += 1
        for pn in t[1:5]:
            nets[pn] += 1
    for _, nm in subs[name]['kids']:
        if nm in subs and nm not in cells:
            sub = rec(nm, stack + (name,))
            mn += sub['mn']
            mp += sub['mp']
            nets.update(sub['nets'])
    r = {'mn': mn, 'mp': mp, 'nets': nets}
    memo[name] = r
    return r

MODELS = ('n18', 'p18', 'n33', 'p33', 'nnt18', 'pmvt18', 'nmvt18')
top = 'sar_digi_paper_core'
print('=== loose devices per hierarchical block ===')
print('%-12s %6s %6s' % ('block', 'MN', 'MP'))
tot_mn = tot_mp = 0
for k in subs:
    mn = mp = 0
    for t in subs[k]['mos']:
        model = t[5] if len(t) > 5 else ''
        if model.lower().startswith('n'):
            mn += 1
        else:
            mp += 1
    if mn or mp:
        print('%-12s %6d %6d' % (k, mn, mp))
        tot_mn += mn
        tot_mp += mp
print('%-12s %6d %6d' % ('TOTAL(own)', tot_mn, tot_mp))

r = rec(top)
print('')
print('flattened loose devices: MN=%d MP=%d' % (r['mn'], r['mp']))
print('')
print('=== nets most often touched by loose devices (top 15) ===')
for n, c in r['nets'].most_common(15):
    print('  net %-10s %d pin(s)' % (n, c))
print('')
print('=== is the top-level net 300 / 637 among them? ===')
for probe in ('300', '637', '461'):
    print('  net %-6s touches %d loose pins' % (probe, r['nets'].get(probe, 0)))
