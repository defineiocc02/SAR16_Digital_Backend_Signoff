"""What drives ctosc_gls_0, the on-chip clock that gates the SRM estimator?"""
import io
import re

t = io.open('sar_digi_paper_core_pnr.v', encoding='utf-8', errors='replace').read()
lines = t.splitlines()
print('ctosc_gls_0 occurrences : %d' % t.count('ctosc_gls_0'))

OUT = ('Y', 'Q', 'QN', 'Z', 'ZN', 'CO', 'S', 'ENCLK', 'GCK')
print('')
print('=== places where ctosc_gls_0 is the OUTPUT pin of an instance ===')
n = 0
for i, l in enumerate(lines, 1):
    m = re.search(r'\.(\w+)\s*\(\s*ctosc_gls_0\s*\)', l)
    if m and m.group(1).upper() in OUT:
        print('  L%-6d %s' % (i, l.strip()[:150]))
        n += 1
print('  total: %d' % n)

print('')
print('=== the instance that produces it (previous non-blank line) ===')
for i, l in enumerate(lines, 1):
    if 'ctosc_gls_0' in l and re.search(r'\(\s*ctosc_gls_0\s*\)\s*[,)]', l):
        # look back for the instance header
        for j in range(i - 1, max(0, i - 6), -1):
            if re.match(r'^\s*[A-Za-z_]\w*\s+\S+\s*\(', lines[j - 1]):
                print('  L%-6d %s' % (j, lines[j - 1].strip()[:150]))
                break
        print('  L%-6d %s' % (i, l.strip()[:150]))
        break

print('')
print('=== oscillator-ish identifiers in the netlist ===')
names = sorted(set(re.findall(r'\b[A-Za-z_]*[Oo][Ss][Cc][A-Za-z_0-9]*\b', t)))
print('  %s' % names[:30])

print('')
print('=== is ctosc_gls_0 also a top-level port? ===')
m = re.search(r'module\s+sar_digi_paper_core\s*\((.*?)\)\s*;', t, re.S)
print('  in top port list: %s' % ('ctosc_gls_0' in m.group(1)))

print('')
print('=== clock-ish nets used as .CK / .clk on sequential instances (top 12) ===')
ck = {}
for l in lines:
    for m in re.finditer(r'\.(?:CK|clk|CLK)\s*\(\s*(\w+)\s*\)', l):
        ck[m.group(1)] = ck.get(m.group(1), 0) + 1
for k, v in sorted(ck.items(), key=lambda x: -x[1])[:12]:
    print('  %-20s %d' % (k, v))
