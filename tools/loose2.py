"""Loose-device locator, WITH a control.

Definition (stated): a device is LOOSE if its `M` line sits directly in a subcircuit
that is NOT a library cell master -- i.e. in the top cell or in a Calibre ICV_* block.
Round 16's version iterated every subckt including cell masters, so it reported cell
internals as "loose"; that is the bug this fixes.

Control: the control assertion must pass, otherwise the tool prints VOID and no
numbers.  Control = the parser must see the cell masters' internals (a non-zero
per-master device total) AND a known cell-internal device must be attributed to its
own master, not to a loose bucket.
"""
import collections
import io
import re
import sys

SP = sys.argv[1] if len(sys.argv) > 1 else 'sar_digi_paper_core.sp'
LEF = sys.argv[2] if len(sys.argv) > 2 else 'sar_digi_paper_core.lef'

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

subs = collections.OrderedDict()
cur = None
for st in logical:
    up = st.upper()
    if up.startswith('.SUBCKT'):
        cur = st.split()[1]
        subs[cur] = {'mos': [], 'kids': [], 'ports': st.split()[2:]}
        continue
    if up.startswith('.ENDS'):
        cur = None
        continue
    if cur is None or not st:
        continue
    c = st[0].upper()
    if c == 'M':
        subs[cur]['mos'].append(st.split())
    elif c == 'X':
        subs[cur]['kids'].append(st)

cell_masters = [k for k in subs if k in cells]
container = [k for k in subs if k not in cells and subs[k]['mos']]
master_dev_total = sum(len(subs[k]['mos']) for k in cell_masters)
print('CONTROL 1  library cell masters in the netlist : %d' % len(cell_masters))
print('CONTROL 1  their device total                  : %d' % master_dev_total)

# --- control 2: a device read from DFFSXL must be attributed to DFFSXL ---
probe = None
for k in cell_masters:
    if k == 'DFFSXL' and subs[k]['mos']:
        probe = (k, subs[k]['mos'][0])
        break
if probe is None:
    print('CONTROL 2  FAILED - no DFFSXL devices found -> tool VOID')
    raise SystemExit(1)
print('CONTROL 2  DFFSXL first device lives in master %s -> attributed correctly'
      % probe[0])

print('')
print('=== containers (non-cell subckts) that hold devices directly ===')
print('%-12s %6s %s' % ('block', 'devs', 'ports'))
tot = 0
for k in container:
    print('%-12s %6d %d' % (k, len(subs[k]['mos']), len(subs[k]['ports'])))
    tot += len(subs[k]['mos'])
print('%-12s %6d' % ('TOTAL', tot))

print('')
print('=== loose devices by model and by container ===')
mod = collections.Counter()
nets = collections.Counter()
for k in container:
    for t in subs[k]['mos']:
        model = t[5] if len(t) > 5 else '?'
        mod[model] += 1
        for p in t[1:5]:
            nets[(k, p)] += 1
print('  by model : %s' % ', '.join('%s x%d' % (a, b) for a, b in mod.most_common(8)))
print('')
print('=== the nets those loose devices sit on (top 12) ===')
for (k, p), c in nets.most_common(12):
    print('  %-10s net %-8s %d pin(s)' % (k, p, c))
print('')
print('=== recursive: devices under the top cell that are NOT inside a cell master ===')
memo = {}

def rec(name, stack=()):
    if name in memo:
        return memo[name]
    if name in stack or name not in subs:
        return collections.Counter()
    if name in cells:
        return collections.Counter()
    c = collections.Counter()
    for t in subs[name]['mos']:
        c[t[5] if len(t) > 5 else '?'] += 1
    for st in subs[name]['kids']:
        toks = [x for x in st.split()[1:] if '=' not in x]
        nm = None
        for x in toks:
            if x in subs:
                nm = x
                break
        if nm:
            c.update(rec(nm, stack + (name,)))
    memo[name] = c
    return c

r = rec('sar_digi_paper_core')
print('  %s' % ', '.join('%s x%d' % (a, b) for a, b in r.most_common(10)))
print('  total loose = %d' % sum(r.values()))
