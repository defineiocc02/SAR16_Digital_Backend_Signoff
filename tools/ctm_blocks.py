"""Do the `XctmTdsLR_*` transistor-level blocks correspond between the two netlists?

Round 22 showed the unattributed devices belong to `XctmTdsLR_*` blocks, i.e. design-owned
transistor-level hierarchy rather than library cells.  This checks, for both netlists,
how many such blocks exist and whether the name sets agree.  Controls: the CDL must have
44 subckts and the extracted netlist must contain the top cell; if either fails the
numbers are VOID.
"""
import collections
import io
import re
import sys

CDL = sys.argv[1] if len(sys.argv) > 1 else 'sar16.cdl'
SP = sys.argv[2] if len(sys.argv) > 2 else 'sar_digi_paper_core.sp'
PAT = re.compile(r'ctmTdsLR_\d+_\d+')

def load(p):
    out = []
    for raw in io.open(p, encoding='utf-8', errors='replace'):
        st = raw.strip()
        if st.startswith('+'):
            if out:
                out[-1] = out[-1] + ' ' + st[1:].strip()
            continue
        out.append(st)
    return out

cdl = load(CDL)
sp = load(SP)
subs_cdl = [l.split()[1] for l in cdl if l.upper().startswith('.SUBCKT')]
subs_sp = [l.split()[1] for l in sp if l.upper().startswith('.SUBCKT')]
print('CONTROL cdl .SUBCKT = %d (expect 44)   sp .SUBCKT = %d' % (len(subs_cdl), len(subs_sp)))
if len(subs_cdl) != 44 or 'sar_digi_paper_core' not in subs_sp:
    print('CONTROLS FAILED -> VOID'); raise SystemExit(1)

a = collections.Counter(PAT.findall('\n'.join(cdl)))
b = collections.Counter(PAT.findall('\n'.join(sp)))
print('')
print('ctmTdsLR names in source CDL  : %d distinct, %d occurrences' % (len(a), sum(a.values())))
print('ctmTdsLR names in layout .sp   : %d distinct, %d occurrences' % (len(b), sum(b.values())))
print('only in source : %d' % len(set(a) - set(b)))
print('only in layout : %d' % len(set(b) - set(a)))
print('')
print('=== sample, source ===')
for k in list(a)[:6]:
    print('  %-26s x%d' % (k, a[k]))
print('=== sample, layout ===')
for k in list(b)[:6]:
    print('  %-26s x%d' % (k, b[k]))
print('')
print('=== are they subckts (definitions) or instances? ===')
defs_sp = [s for s in subs_sp if 'ctmTdsLR' in s]
print('  layout .SUBCKT names containing ctmTdsLR : %d  %s' % (len(defs_sp), defs_sp[:4]))
defs_cdl = [s for s in subs_cdl if 'ctmTdsLR' in s]
print('  source .SUBCKT names containing ctmTdsLR : %d  %s' % (len(defs_cdl), defs_cdl[:4]))
