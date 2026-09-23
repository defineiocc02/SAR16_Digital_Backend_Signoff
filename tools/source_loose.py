"""Source-side loose devices: `M` lines that sit directly inside a DESIGN subckt.

The layout's extracted netlist carries 224 devices outside any cell master
(round 18, controlled).  If the source CDL has ~0 such devices, the two sides differ
structurally; if it has ~193, the layout's loose devices have a source counterpart and
the difference lies elsewhere.

Controls (must pass or the numbers are VOID):
  C1  the top subckt must contain 0 direct M lines (it is all instances)
  C2  the file must contain 44 .SUBCKT blocks (the known design hierarchy size)
"""
import collections
import io
import sys

CDL = sys.argv[1] if len(sys.argv) > 1 else 'sar16.cdl'

logical = []
for raw in io.open(CDL, encoding='utf-8', errors='replace'):
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
        subs[cur] = []
        continue
    if up.startswith('.ENDS'):
        cur = None
        continue
    if cur is None or not st:
        continue
    if st[0].upper() == 'M':
        subs[cur].append(st)

top = 'sar_digi_paper_core'
c1 = len(subs.get(top, []))
c2 = len(subs)
print('CONTROL 1  top subckt direct M lines : %d  (must be 0)' % c1)
print('CONTROL 2  .SUBCKT blocks in the file : %d' % c2)
if c1 != 0 or c2 != 44:
    print('CONTROLS FAILED -> tool VOID, no numbers reported')
    raise SystemExit(1)

tot = sum(len(v) for v in subs.values())
print('')
print('=== design subckts that hold devices directly ===')
print('%-60s %6s' % ('subckt', 'devs'))
for k, v in subs.items():
    if v:
        print('%-60s %6d' % (k[:60], len(v)))
print('%-60s %6d' % ('TOTAL', tot))
print('')
print('=== models ===')
mod = collections.Counter()
for v in subs.values():
    for t in v:
        toks = t.split()
        mod[toks[5] if len(toks) > 5 else '?'] += 1
print('  %s' % ', '.join('%s x%d' % (a, b) for a, b in mod.most_common(10)))
print('')
print('VERDICT: source loose devices = %d ; layout raw loose devices = 224' % tot)
