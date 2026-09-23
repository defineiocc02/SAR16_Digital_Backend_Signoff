"""V1-a: itemise the port counts. Formality compared 146 "Port" points; LVS reports 178
layout ports.  This expands the delivered netlist's own top-level port list to bits.
"""
import io
import re

V = 'sar_digi_paper_core_pnr.v'
t = io.open(V, encoding='utf-8', errors='replace').read()
m = re.search(r'module\s+sar_digi_paper_core\s*\((.*?)\)\s*;', t, re.S)
ports = [p.strip() for p in m.group(1).split(',') if p.strip()]
body = t[m.end():]
ins, outs = [], []
for ln in body.splitlines():
    st = ln.strip()
    if not st:
        continue
    mm = re.match(r'^(input|output|inout)\s+(.*?);\s*$', st)
    if mm:
        (ins if mm.group(1) == 'input' else outs).append(mm.group(2).strip())
        continue
    if re.match(r'^[A-Za-z_]', st):
        break


def width(decl):
    w = re.search(r'\[(\d+):(\d+)\]', decl)
    if w:
        return abs(int(w.group(1)) - int(w.group(2))) + 1
    return 1


def name(decl):
    return decl.split(']')[-1].strip() if ']' in decl else decl


print('top-level port NAMES : %d  (input %d / output %d)' % (len(ports), len(ins), len(outs)))
ti = to = 0
print('')
print('--- inputs ---')
for d in ins:
    w = width(d)
    ti += w
    print('  %-22s width %2d' % (name(d), w))
print('--- outputs ---')
for d in outs:
    w = width(d)
    to += w
    print('  %-22s width %2d' % (name(d), w))
print('')
print('bit-expanded inputs  : %d' % ti)
print('bit-expanded outputs : %d' % to)
print('bit-expanded TOTAL   : %d' % (ti + to))
print('')
print('Formality "Port" compare points : 146')
print('LVS report Ports (layout)       : 178')
print('LVS Ports - bit-expanded total  : %d' % (178 - (ti + to)))
