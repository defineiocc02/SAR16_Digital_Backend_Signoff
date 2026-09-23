"""Scope-aware backward tracer for the delivered netlist.

Answers: what does the D pin of a given flop actually compute?  Tracks the driver
of a net inside ONE module scope (a bare name such as `n103` exists in many modules,
so a file-wide search is meaningless -- that mistake produced two bogus findings
earlier in this project).
"""
import io
import re
import sys

V = '../evidence/rpt_v51/sar_digi_paper_core_pnr.v'
MOD = sys.argv[1] if len(sys.argv) > 1 else 'srm_residue_estimator'
NETS = sys.argv[2].split(',') if len(sys.argv) > 2 else ['n103']
DEPTH = int(sys.argv[3]) if len(sys.argv) > 3 else 4

t = io.open(V, encoding='utf-8', errors='replace').read()
logical = []
for raw in t.splitlines():
    st = raw.strip()
    if st.startswith('+'):
        if logical:
            logical[-1] += ' ' + st[1:].strip()
        continue
    logical.append(st)

# collect the body of the target module
body, inm = [], False
for st in logical:
    m = re.match(r'module\s+(\S+)', st)
    if m:
        inm = m.group(1).startswith(MOD)
        if inm:
            print('module matched: %s' % m.group(1))
        continue
    if re.match(r'endmodule', st):
        if inm:
            break
        continue
    if inm:
        body.append(st)

OUT_PINS = {'Y', 'Q', 'QN', 'Z', 'ZN', 'CO', 'S', 'CON', 'ENCLK', 'GCK', 'SO'}
IN_PINS = {'A', 'B', 'C', 'D', 'CK', 'SI', 'SE', 'SN', 'RN', 'TE', 'EN', 'CLK', 'GN'}


def driver(net):
    """Return (instline, outpin, [ (pin, val) ... ]) for the instance driving net."""
    pat = re.compile(r'\.(\w+)\s*\(\s*%s\s*\)' % re.escape(net))
    for st in body:
        for m in pat.finditer(st):
            if m.group(1).upper() in OUT_PINS:
                hdr = st.split('(')[0].strip().split()
                master = hdr[0]
                inst = hdr[1] if len(hdr) > 1 else '?'
                pins = re.findall(r'\.(\w+)\s*\(\s*([^)]*?)\s*\)', st)
                return master, inst, m.group(1), pins
    return None


seen = set()
queue = [(n, 0) for n in NETS]
while queue:
    net, d = queue.pop(0)
    if net in seen or d > DEPTH:
        continue
    seen.add(net)
    r = driver(net)
    pad = '  ' * d
    if not r:
        print('%s%-9s <- NO DRIVER in this module (constant / primary input / undriven)' % (pad, net))
        continue
    master, inst, opin, pins = r
    others = ['%s=%s' % (p, v) for p, v in pins if p.upper() in IN_PINS and v != net]
    print('%s%-9s <- %s %s .%s()   inputs: %s' % (pad, net, master, inst, opin, ' '.join(others)))
    for p, v in pins:
        if p.upper() in IN_PINS and v != net and re.match(r'^[A-Za-z_]\w*$', v):
            queue.append((v, d + 1))
