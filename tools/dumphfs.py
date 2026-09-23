"""Dump the exact Verilog text around the HFSNET tie connections, so the claim
"submodule rst_n is tied to a constant" is read off the file, not inferred."""
import io
import re

V = 'sar_digi_paper_core_pnr.v'
lines = io.open(V, encoding='utf-8', errors='replace').read().splitlines()

def show(a, b, tag):
    print('---- %s : lines %d-%d ----' % (tag, a, b))
    for i in range(a - 1, min(b, len(lines))):
        print('%6d| %s' % (i + 1, lines[i].rstrip()[:180]))

# module declarations of the two HFSNET-bearing modules
for i, ln in enumerate(lines, 1):
    m = re.match(r'\s*module\s+(srm_residue_estimator\S*|sar_calib_ctrl_serial\S*)', ln)
    if m:
        show(i, i + 12, 'module ' + m.group(1))

show(6155, 6175, 'instantiation of sar_calib_ctrl_serial_...')
show(6206, 6226, 'instantiation of srm_residue_estimator_...')

print('')
print('---- the 3 "other" HFSNET positions ----')
for i, ln in enumerate(lines, 1):
    if 'HFSNET' not in ln:
        continue
    if re.match(r'\s*(input|output|inout)\b', ln) or re.search(r'\.\w+\s*\(\s*HFSNET', ln):
        continue
    print('%6d| %s' % (i, ln.rstrip()[:180]))

print('')
print('---- is there ANY driver for HFSNET_119 / HFSNET_120 (assign / cell) ? ----')
for i, ln in enumerate(lines, 1):
    for n in ('HFSNET_119', 'HFSNET_120', 'HFSNET_4', 'HFSNET_330'):
        if n in ln and (re.search(r'\bassign\b', ln) or re.match(r'\s*(wire|reg)\b', ln)):
            print('%6d| %s' % (i, ln.rstrip()[:180]))

print('')
print('---- top-level rst_n usage in the P&R netlist ----')
for i, ln in enumerate(lines, 1):
    if re.search(r'\.rst_n\s*\(', ln):
        print('%6d| %s' % (i, ln.strip()[:140]))
