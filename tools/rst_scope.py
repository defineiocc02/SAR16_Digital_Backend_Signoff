"""Is HFSINV_15503_626 in the TOP module, and does its rst_n reach the top-level port?

Builds the module tree and reports, for the reset chain, the enclosing module of each
instance plus what the enclosing module's rst_n port connects to at its parent.
"""
import io
import re

V = 'sar_digi_paper_core_pnr.v'
t = io.open(V, encoding='utf-8', errors='replace').read()

logical = []
for raw in t.splitlines():
    st = raw.strip()
    if st.startswith('+'):
        if logical:
            logical[-1] = logical[-1] + ' ' + st[1:].strip()
        continue
    logical.append(st)

# module -> list of (master, instname, conns)
mods = {}
order = []
cur = None
for st in logical:
    m = re.match(r'module\s+(\S+)', st)
    if m:
        cur = m.group(1)
        mods[cur] = []
        order.append(cur)
        continue
    if re.match(r'endmodule', st):
        cur = None
        continue
    if cur is None:
        continue
    mi = re.match(r'^([A-Za-z_]\w*)\s+(\S+)\s*\((.*)\)\s*;\s*$', st)
    if mi:
        mods[cur].append((mi.group(1), mi.group(2), mi.group(3)))

TOP = 'sar_digi_paper_core'
print('modules in the netlist : %d' % len(mods))
print('top module             : %s' % TOP)
print('')

TARGET = 'HFSINV_15503_626'
owner = None
for mod, insts in mods.items():
    for master, name, conns in insts:
        if name == TARGET:
            owner = (mod, master, conns)
print('=== the inverter that drives HFSNET_124 ===')
if owner:
    mod, master, conns = owner
    print('  instance %s : master %s' % (TARGET, master))
    print('  ENCLOSING MODULE : %s' % mod)
    print('  connections      : %s' % ' '.join(conns.split())[:160])
else:
    print('  not found by instance name')

print('')
print('=== who instantiates that module, and what does its rst_n get? ===')
if owner:
    m_owner = owner[0]
    for mod, insts in mods.items():
        for master, name, conns in insts:
            if master == m_owner:
                pairs = re.findall(r'\.(\w+)\s*\(\s*([^)]*?)\s*\)', conns)
                rn = [p for p in pairs if p[0] == 'rst_n']
                print('  %s instantiates %s as %s' % (mod, master, name))
                print('    .rst_n connects to : %s' % (rn[0][1] if rn else '(not present)'))

print('')
print('=== does the TOP module instantiate anything whose rst_n is rst_n? ===')
for master, name, conns in mods.get(TOP, []):
    pairs = re.findall(r'\.(\w+)\s*\(\s*([^)]*?)\s*\)', conns)
    rn = [p for p in pairs if p[0] in ('rst_n',)]
    if rn:
        print('  %-22s %-14s .rst_n(%s)' % (master[:22], name[:14], rn[0][1]))
print('')
print('=== top-level port list contains rst_n? ===')
m = re.search(r'module\s+%s\s*\((.*?)\)\s*;' % TOP, t, re.S)
print('  %s' % ('YES' if m and 'rst_n' in m.group(1) else 'no'))
