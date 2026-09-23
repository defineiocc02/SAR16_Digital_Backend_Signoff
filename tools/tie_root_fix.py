"""Tie only the UNDRIVEN root nets of the HFSNET_* tie network.

Rule: a HFSNET net is a driver output if it ever appears as the argument of `.Y ( ... )`.
Every other HFSNET net (the constant roots and the parent-level aliases that feed the
85 HFSINV instances) is tied to the given constant.  The 85 HFSINV instances keep their
real connections, so the inverted copies are produced by real inverters -- which is
exactly what the layout does.

usage: tie_root_fix.py <in.v> <out.v> <root_value> [<special_net> <special_value>]
"""
import io
import re
import sys

src, dst, rootv = sys.argv[1], sys.argv[2], sys.argv[3]
special = sys.argv[4] if len(sys.argv) > 4 else None
specialv = sys.argv[5] if len(sys.argv) > 5 else None

t = io.open(src, encoding='utf-8', errors='replace').read()

driven = set(re.findall(r'\.Y\s*\(\s*(HFSNET_\d+)\s*\)', t))
referenced = set(re.findall(r'HFSNET_\d+', t))
roots = sorted(referenced - driven)
print('  HFSNET nets referenced : %d' % len(referenced))
print('  driven by a .Y         : %d' % len(driven))
print('  ROOT (undriven) nets   : %d  -> %s' % (len(roots), ', '.join(roots[:12])))

n_root = 0
n_spec = 0


def repl(m):
    global n_root, n_spec
    net = m.group(2)
    if net in driven:
        return m.group(0)
    if special and net == special:
        n_spec += 1
        return '%s%s%s' % (m.group(1), specialv, m.group(3))
    n_root += 1
    return '%s%s%s' % (m.group(1), rootv, m.group(3))


# only rewrite HFSNET tokens that are the ARGUMENT of a connection, never a port name
t = re.sub(r'(\.\w+\s*\(\s*)(HFSNET_\d+)(\s*\))', repl, t)

left = re.findall(r'\.\w+\s*\(\s*HFSNET_\d+\s*\)', t)
io.open(dst, 'w', encoding='utf-8', newline='\n').write(t)
print('  roots tied to %-6s : %d' % (rootv, n_root))
print('  special %s -> %-5s : %d' % (special, specialv, n_spec))
print('  HFSNET still used as a connection argument : %d   (must be 0)' % len(left))
