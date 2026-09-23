"""Why do the top-level srm_total_count / srm_ones_count read 0?

Checks, in the delivered netlist: what drives those top ports, and what the
u_srm_residue instantiation connects to .total_count / .ones_count.
"""
import io
import re

V = '../evidence/rpt_v51/sar_digi_paper_core_pnr.v'
t = io.open(V, encoding='utf-8', errors='replace').read()
logical = []
for raw in t.splitlines():
    st = raw.strip()
    if st.startswith('+'):
        if logical:
            logical[-1] = logical[-1] + ' ' + st[1:].strip()
        continue
    logical.append(st)

mod = None
cur = None
for st in logical:
    m = re.match(r'module\s+(\S+)', st)
    if m:
        mod = m.group(1)
        continue
    if re.match(r'endmodule', st):
        mod = None
        continue
    if mod != 'sar_digi_paper_core':
        continue
    mi = re.match(r'^([A-Za-z_]\w*)\s+(\S+)\s*\((.*)\)\s*;\s*$', st)
    if not mi:
        continue
    master, name, conns = mi.group(1), mi.group(2), mi.group(3)
    if 'srm_residue_estimator' in master or name == 'u_srm_residue':
        print('=== instantiation %s (master %s) ===' % (name, master[:50]))
        for pin, val in re.findall(r'\.(\w+)\s*\(\s*([^)]*?)\s*\)', conns):
            if pin.lower() in ('total_count', 'ones_count', 'residue_o', 'count_shortfall',
                               'residue_valid', 'done', 'busy', 'stalled'):
                print('   .%-16s -> %s' % (pin, val))
        print('')

print('=== what drives the TOP ports srm_total_count / srm_ones_count / srm_residue_o ===')
for target in ('srm_total_count', 'srm_ones_count', 'srm_residue_o'):
    hits = []
    mod = None
    for st in logical:
        m = re.match(r'module\s+(\S+)', st)
        if m:
            mod = m.group(1)
            continue
        if re.match(r'endmodule', st):
            mod = None
            continue
        if mod != 'sar_digi_paper_core':
            continue
        if re.search(r'\.\w+\s*\(\s*%s\s*\)' % target, st):
            hits.append(st[:120])
    print('  %-18s : %d reference(s)' % (target, len(hits)))
    for h in hits[:4]:
        print('      %s' % h)

print('')
print('=== is the TOP port declared as output? ===')
for target in ('srm_total_count', 'srm_ones_count'):
    m = re.search(r'^\s*(input|output|inout)\s+[^;]*%s\s*;' % target, t, re.M)
    print('  %-18s : %s' % (target, m.group(0).strip() if m else 'NOT FOUND'))
