"""For the incorrect nets that touch none of the 15 boundary-port masters, print the
device/pin correspondence so the difference can be seen pin by pin instead of as a count.
"""
import collections
import io
import re

R = 'lvsF_boxed_injectno.rep'
TARGETS = {7, 12, 14, 17, 26, 29, 31, 37, 63}

lines = io.open(R, encoding='utf-8', errors='replace').read().splitlines()
start = next(i for i, l in enumerate(lines) if l.strip().startswith('INCORRECT NETS'))

blocks = {}
cur = None
buf = []
for ln in lines[start:start + 40000]:
    s = ln.strip()
    if s.startswith('INCORRECT INSTANCES') or s.startswith('INCORRECT PORTS'):
        break
    m = re.match(r'^\s*(\d+)\s+Net\s+(\S+)\s+(\S+)\s*$', ln)
    if m:
        if cur is not None:
            blocks[cur] = buf
        cur = int(m.group(1))
        buf = [ln.rstrip()]
        continue
    if cur is not None:
        buf.append(ln.rstrip())
if cur is not None:
    blocks[cur] = buf

print('blocks parsed: %d' % len(blocks))
print('')
pat = collections.Counter()
for d in sorted(TARGETS):
    b = blocks.get(d)
    if b is None:
        continue
    print('================ disc %d ================' % d)
    for ln in b[:14]:
        print(ln[:130])
    # classify: lines of the form  "  LAYOUTNAME: net    SOURCEANNOT   SOURCENAME: net"
    for ln in b:
        m = re.match(r'^\s*(\w+):\s*(\S+)\s+(\*\*.*?\*\*|\S+)\s+(\w+):\s*(\S+)\s*$', ln)
        if m:
            if m.group(2) != m.group(5):
                pat['pin %s: layout %s vs source %s' % (m.group(1), m.group(2), m.group(5))] += 1
            else:
                pat['pin %s: MATCHED' % m.group(1)] += 1
    print('')
print('=== mismatch pattern across the 9 nets (pin-level) ===')
for k, v in pat.most_common(14):
    print('  %-52s x%d' % (k, v))
