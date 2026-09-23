"""LEF macro/pin census, strict block tracking.

Caliber (stated so the number is reproducible):
  MACRO = `MACRO <name>` blocks at column 0
  PIN   = `PIN <name>` blocks opened at macro top level (depth 0 inside the macro)
Structures tracked: MACRO / PIN / OBS / PORT raise depth, every END lowers it.
`END <name>` also closes LAYER and SITE blocks, so `END <name>` counts can NOT be
used as a self-check on their own -- the check used here is that depth returns to
exactly 0 at every macro-closing END and at EOF.
"""
import re
import sys

MACRO = re.compile(r'^MACRO\s+(\S+)\s*$')
ENDNM = re.compile(r'^\s*END\s+(\S+)\s*$')
BLOCK = re.compile(r'^\s*(PIN|OBS|PORT|BLOCKAGE)\b')

def census(path):
    macros = []
    pins = 0
    cur = None
    depth = 0
    bad = []
    with open(path, 'r', errors='replace') as f:
        for i, raw in enumerate(f, 1):
            st = raw.rstrip('\n').rstrip('\r')
            m = MACRO.match(st)
            if m:
                if cur is not None:
                    bad.append('line %d: MACRO inside MACRO' % i)
                cur = m.group(1)
                depth = 0
                continue
            if cur is None:
                continue
            b = BLOCK.match(st)
            if b:
                if b.group(1) == 'PIN' and depth == 0:
                    pins += 1
                depth += 1
                continue
            e = ENDNM.match(st)
            if e:
                if depth == 0:
                    if e.group(1) != cur:
                        bad.append('line %d: END %s closes MACRO %s' % (i, e.group(1), cur))
                    macros.append(cur)
                    cur = None
                else:
                    depth -= 1
                continue
            if st.strip() == 'END':
                if depth > 0:
                    depth -= 1
        if cur is not None:
            bad.append('EOF: MACRO %s never closed (depth %d)' % (cur, depth))
    return macros, pins, bad

for path in sys.argv[1:]:
    macros, pins, bad = census(path)
    names = macros
    print(path.split('\\')[-1])
    print('  MACRO = %d     PIN = %d' % (len(macros), pins))
    print('  structure check : %s' % ('CLEAN' if not bad else 'PROBLEMS: ' + '; '.join(bad[:4])))
    print('  duplicate MACRO names : %d' % (len(names) - len(set(names))))
    print('  top cell MACRO present: %s' % ('sar_digi_paper_core' in names))
