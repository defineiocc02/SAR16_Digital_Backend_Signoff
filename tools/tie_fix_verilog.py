"""Tie every undriven HFSNET_* net in a COPY of the P&R Verilog.

The HFSNET_* names appear in four syntactic roles and each needs its own edit:
  1. formal port name on an instantiation   `.HFSNET_5 ( HFSNET_120 )`  -> delete the
     whole connection (the port itself is removed from the module)
  2. bare net on a normal connection        `.rst_n ( HFSNET_119 )`     -> `.rst_n ( 1'b1 )`
  3. `input HFSNET_n ;` declaration                                      -> delete
  4. name inside a module port list                                      -> delete + fix commas

v2lvs maps `1'b1` to VDD because run_lvs_paper_core.sh calls it with `-s1 VDD`.
"""
import io
import re
import sys

path = sys.argv[1]
t = io.open(path, encoding='utf-8', errors='replace').read()
n0 = len(re.findall(r'HFSNET', t))

# 1. drop the whole named connection whose formal port name is HFSNET_n
t, n_port = re.subn(r'\.\s*HFSNET_\d+\s*\([^)]*\)\s*,?', '', t)

# 2. remaining bare HFSNET_n are nets -> tie high
t, n_net = re.subn(r'\bHFSNET_\d+\b', "1'b1", t)

# 3. drop port declarations
lines = []
n_decl = 0
for ln in t.splitlines():
    if re.match(r"\s*(input|output|inout)\s+1'b1\s*;\s*$", ln):
        n_decl += 1
        continue
    lines.append(ln)
t = '\n'.join(lines)

# 4. rewrite module port lists, splitting on commas so no dangling comma survives
n_list = 0


def fix_header(m):
    global n_list
    head, body, tail = m.group(1), m.group(2), m.group(3)
    keep = []
    for p in body.split(','):
        p = p.strip()
        if not p:
            continue
        if p == "1'b1":
            n_list += 1
            continue
        keep.append(p)
    out = []
    # single long line: the wrap version dropped the comma at each line break, which
    # v2lvs reported as `syntax error ... token:residue_valid`.  Verilog has no line
    # length limit, so do not wrap.
    out.append('   ' + ', '.join(keep))
    return head + '\n' + '\n'.join(out) + tail


t = re.sub(r'(?s)(\bmodule\s+\S+\s*\()(.*?)(\)\s*;)', fix_header, t)

# 5. tidy any comma damage left by the deletions
for _ in range(4):
    t = re.sub(r'\(\s*,', '(', t)
    t = re.sub(r',\s*,', ',', t)
    t = re.sub(r',\s*\)', ')', t)
t = re.sub(r'[ \t]+\n', '\n', t)

io.open(path, 'w', encoding='utf-8', newline='\n').write(t)
print('  HFSNET tokens at start   : %d' % n0)
print('  named connections dropped: %d' % n_port)
print('  bare nets tied to 1\'b1   : %d' % n_net)
print('  declarations removed     : %d' % n_decl)
print('  port-list names removed  : %d' % n_list)
print('  HFSNET left              : %d   (must be 0)' % len(re.findall(r'HFSNET', t)))
print('  ", ," left               : %d   (must be 0)' % len(re.findall(r',\s*,', t)))
print("  1'b1 connections         : %d" % len(re.findall(r"1'b1", t)))
