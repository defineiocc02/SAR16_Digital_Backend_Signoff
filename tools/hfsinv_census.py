"""Instance census per standard-cell type: delivered netlist vs extracted layout.

Cell names come from the LEF MACRO list, so only CELL instances are counted (the
design's own hierarchical subckts and the device-model stubs are recursed through,
not counted).  Both inputs use '+' continuation lines; both are flattened from their
own root.  Two passes: collect every subckt name first, then resolve each X line to
the first token that is either a library cell or a known subckt.
"""
import collections
import io
import re

LEF = 'sar_digi_paper_core.lef'
CDL = 'sar16.cdl'
SP = 'sar_digi_paper_core.sp'

cells = set()
for ln in io.open(LEF, encoding='utf-8', errors='replace'):
    m = re.match(r'^MACRO\s+(\S+)\s*$', ln.rstrip())
    if m:
        cells.add(m.group(1))
print('library cells (LEF MACRO) : %d' % len(cells))


def logical_lines(path):
    out = []
    for raw in io.open(path, encoding='utf-8', errors='replace'):
        st = raw.strip()
        if st.startswith('+'):
            if out:
                out[-1] = out[-1] + ' ' + st[1:].strip()
            continue
        out.append(st)
    return out


def parse(path):
    lines = logical_lines(path)
    known = set()
    for st in lines:
        if st.upper().startswith('.SUBCKT'):
            known.add(st.split()[1])
    subs = collections.OrderedDict()
    cur = None
    for st in lines:
        up = st.upper()
        if up.startswith('.SUBCKT'):
            cur = st.split()[1]
            subs.setdefault(cur, [])
            continue
        if up.startswith('.ENDS'):
            cur = None
            continue
        if cur is None or not st or st[0].upper() != 'X':
            continue
        toks = [t for t in st.split()[1:] if '=' not in t]
        name = None
        for t in toks:
            if t in cells or t in known:
                name = t
                break
        subs[cur].append(name)
    return subs


def flatten(subs, top):
    memo = {}

    def rec(name, stack=()):
        if name in memo:
            return memo[name]
        if name in stack or name not in subs:
            return collections.Counter()
        c = collections.Counter()
        for ch in subs[name]:
            if ch in cells:
                c[ch] += 1
            elif ch in subs:
                c.update(rec(ch, stack + (name,)))
        memo[name] = c
        return c

    return rec(top)


top = 'sar_digi_paper_core'
a = flatten(parse(CDL), top)
b = flatten(parse(SP), top)
print('netlist cell instances    : %d' % sum(a.values()))
print('layout  cell instances    : %d' % sum(b.values()))
keys = sorted(set(a) | set(b))
diff = [(k, a.get(k, 0), b.get(k, 0)) for k in keys if a.get(k, 0) != b.get(k, 0)]
print('cell types used           : %d' % len(keys))
print('cell types that differ    : %d' % len(diff))
print('')
print('%-14s %9s %9s %7s' % ('cell', 'netlist', 'layout', 'delta'))
tot = 0
for k, x, y in sorted(diff, key=lambda r: -(r[1] - r[2])):
    print('%-14s %9d %9d %+7d' % (k, x, y, x - y))
    tot += x - y
print('%-14s %9s %9s %+7d' % ('TOTAL', '', '', tot))
