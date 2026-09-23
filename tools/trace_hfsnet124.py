"""Trace WHO drives HFSNET_124 -- my round-11 analysis said it is NOT in the undriven
root set, so something drives it.  If that something is the top-level rst_n, then the
reset IS connected (through buffers) and my whole 'reset undefined' conclusion is wrong.

Walks backwards from a net to its driver, up to a few levels.
"""
import io
import re
import sys

V = 'sar_digi_paper_core_pnr.v'
START = sys.argv[1] if len(sys.argv) > 1 else 'HFSNET_124'
DEPTH = 6

t = io.open(V, encoding='utf-8', errors='replace').read()

# join continuation lines so multi-line instances are handled
logical = []
for raw in t.splitlines():
    st = raw.strip()
    if st.startswith('+'):
        if logical:
            logical[-1] = logical[-1] + ' ' + st[1:].strip()
        continue
    logical.append(st)

# module boundaries
owner = {}
mod = None
for st in logical:
    m = re.match(r'module\s+(\S+)', st)
    if m:
        mod = m.group(1)
        continue
    if re.match(r'endmodule', st):
        mod = None
        continue
    owner[len(owner)] = mod

# instance lines: MASTER inst ( .PIN(net) ... ) ;
insts = []
for idx, st in enumerate(logical):
    if 'module' in st[:8] or st.startswith('input') or st.startswith('output'):
        continue
    m = re.match(r'^([A-Za-z_]\w*)\s+(\S+)\s*\((.*)\)\s*;\s*$', st)
    if m:
        insts.append((m.group(1), m.group(2), m.group(3)))

print('parsed instances: %d' % len(insts))
print('')


def drivers_of(net, level, seen):
    if level > DEPTH or net in seen:
        return
    seen.add(net)
    found = False
    for master, name, conns in insts:
        for pin, val in re.findall(r'\.(\w+)\s*\(\s*([^)]*?)\s*\)', conns):
            if val.strip() == net:
                out_pin = pin.upper() in ('Y', 'Q', 'QN', 'Z', 'ZN', 'CO', 'S', 'ENCLK')
                tag = 'OUTPUT' if out_pin else 'input '
                print('%s%-14s -> %s(%s) pin %s = %s'
                      % ('  ' * level, net, master, name, pin, net))
                if out_pin:
                    found = True
                    ins = [(p, v.strip()) for p, v in
                           re.findall(r'\.(\w+)\s*\(\s*([^)]*?)\s*\)', conns)
                           if p.upper() != pin.upper()]
                    for p, v in ins:
                        if v in ('1\'b1', '1\'b0'):
                            print('%s    ^ driven by a CONSTANT %s on pin %s'
                                  % ('  ' * level, v, p))
                        else:
                            drivers_of(v, level + 1, seen)
    if not found:
        print('%s%-14s -> NO INSTANCE drives this net (undriven / top-level port)'
              % ('  ' * level, net))


print('=== backward trace from %s ===' % START)
drivers_of(START, 0, set())

print('')
print('=== is %s a top-level port? ===' % START)
m = re.search(r'module\s+sar_digi_paper_core\s*\((.*?)\)\s*;', t, re.S)
ports = [p.strip() for p in m.group(1).split(',')] if m else []
print('  %s' % ('YES' if START in ports else 'no'))
print('')
print('=== all nets that appear as an OUTPUT pin (.Y/.Q/.QN) anywhere in the file,')
print('    which are ALSO named HFSNET_* ===')
outs = set()
for master, name, conns in insts:
    for pin, val in re.findall(r'\.(\w+)\s*\(\s*([^)]*?)\s*\)', conns):
        if pin.upper() in ('Y', 'Q', 'QN', 'Z', 'ZN', 'CO', 'S', 'ENCLK'):
            outs.add(val.strip())
hfs = sorted(n for n in outs if n.startswith('HFSNET_'))
print('  driven HFSNET nets: %d  %s' % (len(hfs), hfs[:12]))
refs = set(re.findall(r'HFSNET_\d+', t))
roots = sorted(refs - outs)
print('  UNDRIVEN HFSNET nets: %d  %s' % (len(roots), roots))
