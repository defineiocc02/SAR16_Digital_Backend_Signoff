"""Port-name quality of the standard-cell subckts: extracted layout vs source CDL.

If a cell pin's label TEXT is missing on the layer the LVS deck reads, Calibre emits a
bare NUMBER as the port name (e.g. `.SUBCKT MXI2XL S0 B 3 Y A VSS VDD`).  A numeric
port name cannot be paired with the CDL's named port, which makes the whole cell
ambiguous and cascades into "incorrect nets" whose connection counts are equal.
"""
import collections
import io
import re

SP = 'sar_digi_paper_core.sp'
CDL = 'sar16.cdl'
KIT = 'smic18_san.cdl'

NUM = re.compile(r'^\d+$')

import os

def read_ports(path):
    if not os.path.exists(path):
        return {}
    logical = []
    for raw in io.open(path, encoding='utf-8', errors='replace'):
        st = raw.strip()
        if st.startswith('+'):
            if logical:
                logical[-1] = logical[-1] + ' ' + st[1:].strip()
            continue
        logical.append(st)
    ports = {}
    for st in logical:
        if st.upper().startswith('.SUBCKT'):
            t = st.split()
            ports[t[1]] = t[2:]
    return ports

lay = read_ports(SP)
kit = read_ports(KIT)
cdl = read_ports(CDL)

print('=== numeric port names ===')
print('%-14s %6s %6s %6s' % ('cell', 'ports', 'NUMBERIC', 'unnamed'))
bad_total = 0
cells_bad = []
for c in sorted(lay):
    if c.startswith('ICV_') or c == 'sar_digi_paper_core':
        continue
    p = lay[c]
    if not p:
        continue
    nums = [x for x in p if NUM.match(x)]
    if nums:
        cells_bad.append(c)
        bad_total += len(nums)
        print('%-14s %6d %6d   %s' % (c, len(p), len(nums), ' '.join(nums[:10])))
print('')
print('cell masters with numeric ports : %d' % len(cells_bad))
print('numeric port occurrences        : %d' % bad_total)

print('')
print('=== the same cells in the source CDL / kit CDL ===')
for c in cells_bad[:8]:
    print('  %-14s layout=%-42s kit=%s' % (c, ' '.join(lay[c])[:42], ' '.join(kit.get(c, []))[:42]))

print('')
print('=== control: cells whose layout ports are all named ===')
named = [c for c in sorted(lay) if not c.startswith('ICV_') and c != 'sar_digi_paper_core'
         and lay[c] and not any(NUM.match(x) for x in lay[c])]
print('  count = %d, e.g. %s' % (len(named), ', '.join(named[:6])))
print('')
print('=== how many of the design\'s nets are affected ? (ports are per master) ===')
print('  total cell masters with ports : %d' % len([c for c in lay if lay[c] and not c.startswith('ICV_') and c != 'sar_digi_paper_core']))
