"""Is ctosc_gls_0 double-driven, or are these module-local nets that share a name?

Prints the enclosing module of every ctosc_gls_0 occurrence plus the u_srm_residue
clock connection.  Without this check a same-named net in two modules looks exactly
like a double-driven net.
"""
import io
import re

t = io.open('sar_digi_paper_core_pnr.v', encoding='utf-8', errors='replace').read()
lines = t.splitlines()

mod = None
owner = []
for i, l in enumerate(lines, 1):
    m = re.match(r'\s*module\s+(\S+)', l)
    if m:
        mod = m.group(1)
    if re.match(r'\s*endmodule', l):
        mod = '(after endmodule)'
    if 'ctosc_gls_0' in l:
        owner.append((i, mod, l.strip()[:120]))

from collections import Counter
c = Counter(o[1] for o in owner)
print('=== enclosing module of each ctosc_gls_0 line ===')
for k, v in c.items():
    print('  %-60s %d line(s)' % (k[:60], v))
print('')
for i, m, l in owner:
    print('  L%-6d [%s]  %s' % (i, (m or '?')[:40], l))

print('')
print('=== every .clk / .CK connection that uses ctosc_gls_0 ===')
for i, l in enumerate(lines, 1):
    if 'ctosc_gls_0' in l and re.search(r'\.(CK|clk|CLK)\s*\(\s*ctosc_gls_0\s*\)', l):
        print('  L%-6d %s' % (i, l.strip()[:140]))

print('')
print('=== which module holds u_srm_residue / u_calib_ctrl instantiations? ===')
mod = None
for i, l in enumerate(lines, 1):
    m = re.match(r'\s*module\s+(\S+)', l)
    if m:
        mod = m.group(1)
    if re.match(r'\s*endmodule', l):
        mod = None
    for inst in ('u_srm_residue', 'u_calib_ctrl'):
        if re.search(r'\b%s\s*\(' % inst, l) and '(' in l and not l.strip().startswith('.'):
            print('  %-16s instantiated in module %s at L%d' % (inst, (mod or '?')[:50], i))
