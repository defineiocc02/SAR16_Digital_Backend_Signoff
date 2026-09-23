"""Locate the HFSNET_* tie nets in the delivered P&R Verilog and in the v2lvs CDL.

Question to answer: are HFSNET_* tied to VDD somewhere in the hierarchy, or do they
float?  The LVS run says the layout has no HFSNET net at all and the only incorrect
net is VDD, so the expectation is "float in the source, VDD in the layout".
"""
import io
import re
import sys

V = 'sar_digi_paper_core_pnr.v'
C = 'sar16.cdl'

v = io.open(V, encoding='utf-8', errors='replace').read().splitlines()
c = io.open(C, encoding='utf-8', errors='replace').read().splitlines()

print('=== 1) which module declares HFSNET as a port? ===')
cur = None
decl = {}
for i, ln in enumerate(v, 1):
    m = re.match(r'\s*module\s+(\S+)', ln)
    if m:
        cur = m.group(1)
        continue
    if re.match(r'\s*endmodule', ln):
        cur = None
        continue
    if 'HFSNET' in ln and re.match(r'\s*(input|output|inout)\b', ln):
        decl.setdefault(cur, []).append((i, ln.strip()))
for k, val in decl.items():
    print('  module %-45s %d HFSNET port declarations, e.g. %s' % (k, len(val), val[0][1]))

print('')
print('=== 2) instantiation of those modules: are HFSNET ports connected? ===')
for mod in decl:
    for i, ln in enumerate(v, 1):
        if re.search(r'^\s*%s\s+\S+\s*\(' % re.escape(mod), ln):
            blk = '\n'.join(v[i - 1:i + 40])
            tail = blk.split(';')[0]
            print('  line %d instantiates %s' % (i, mod))
            hf = [t for t in re.findall(r'\.(\w+)\s*\(\s*([^)]*)\)', tail) if 'HFSNET' in t[1]]
            print('    HFSNET connections in that instantiation: %s' % (hf if hf else 'NONE'))
            break

print('')
print('=== 3) every syntactic position where HFSNET appears in the Verilog ===')
pos = {}
for i, ln in enumerate(v, 1):
    if 'HFSNET' not in ln:
        continue
    if re.match(r'\s*(input|output|inout)\b', ln):
        k = 'port-declaration'
    elif re.search(r'\.\w+\s*\(\s*HFSNET', ln):
        k = 'instantiation-connection'
    elif re.search(r'^\s*(wire|reg)\b', ln):
        k = 'wire-declaration'
    elif re.search(r'\bmodule\b', ln):
        k = 'module-portlist'
    else:
        k = 'other'
    pos[k] = pos.get(k, 0) + 1
for k, n in sorted(pos.items(), key=lambda x: -x[1]):
    print('  %-26s %d' % (k, n))

print('')
print('=== 4) the CDL: does the parent tie the subckt port to VDD? ===')
for i, ln in enumerate(c, 1):
    if 'HFSNET' in ln and 'X' == ln.strip()[:1] and '=' in ln:
        print('  L%d: %s' % (i, ln.strip()[:200]))
        break
# find a subckt whose port list has HFSNET, then find its instantiation
sub = None
for i, ln in enumerate(c, 1):
    if ln.strip().upper().startswith('.SUBCKT') and 'HFSNET' in ln:
        sub = ln.split()[1]
        print('  subckt with HFSNET port: %s (L%d)' % (sub, i))
        break
    if 'HFSNET' in ln and ln.strip().startswith('+') and sub is None:
        pass
if sub:
    for i, ln in enumerate(c, 1):
        if re.search(r'\b%s\b' % re.escape(sub), ln) and not ln.strip().upper().startswith('.SUBCKT'):
            print('  instantiation L%d: %s' % (i, ln.strip()[:300]))
            for j in range(i, min(i + 6, len(c))):
                if c[j].strip().startswith('+'):
                    print('      + %s' % c[j].strip()[:300])
                else:
                    break
            break

print('')
print('=== 5) top subckt port list: does it contain HFSNET? ===')
for i, ln in enumerate(c, 1):
    if ln.strip().upper().startswith('.SUBCKT SAR_DIGI_PAPER_CORE'):
        print('  L%d: %s' % (i, ln.strip()[:200]))
        for j in range(i, min(i + 12, len(c))):
            print('      %s' % c[j].strip()[:200])
        break
