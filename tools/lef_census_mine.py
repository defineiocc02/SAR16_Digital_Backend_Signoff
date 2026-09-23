#!/usr/bin/env python3
"""Independent LEF census: is the delivered LEF usable as a block abstract?

Read-only. Counts MACRO definitions, PINs inside each MACRO, and whether the
design block itself has an abstract.  Deliberately keyword-driven, no vendor code.
"""
import re
import sys
from collections import Counter

path = sys.argv[1]
if len(sys.argv) > 2:
    want = sys.argv[2]
else:
    want = "sar_digi_paper_core"

macros = []          # (name, pin_count, has_obs, has_size)
cur = None
pin_n = 0
obs = False
size = None

with open(path, "r", errors="replace") as f:
    for ln in f:
        s = ln.strip()
        m = re.match(r"^MACRO\s+(\S+)", s)
        if m:
            if cur is not None:
                macros.append((cur, pin_n, obs, size))
            cur, pin_n, obs, size = m.group(1), 0, False, None
            continue
        if s == "END":
            # bare END closes the innermost OBS / PORT / PIN block, NOT the macro
            if in_pin or in_obs:
                in_pin, in_obs = False, False
            continue
        if cur is None:
            continue
        if re.match(r"^PIN\s+\S+", s):
            pin_n += 1
            in_pin = True
        elif s.startswith("OBS"):
            obs = True
            in_obs = True
        elif s.startswith("SIZE "):
            size = s
        elif re.match(r"^END\s+MACRO$", s) or re.match(
                r"^END\s+" + re.escape(cur) + r"$", s):
            macros.append((cur, pin_n, obs, size))
            cur, pin_n, obs, size = None, 0, False, None

print("file            : %s" % path)
print("MACRO total     : %d" % len(macros))
print("total PINs      : %d" % sum(m[1] for m in macros))
print("MACROs w/ OBS   : %d" % sum(1 for m in macros if m[2]))
print("MACROs w/ SIZE  : %d" % sum(1 for m in macros if m[3]))
print("block '%s' present as MACRO: %s" % (want, any(m[0] == want for m in macros)))

sizes = Counter(m[3] for m in macros if m[3])
print("distinct SIZE lines: %d" % len(sizes))
for k, v in sizes.most_common(5):
    print("   %5d x %s" % (v, k))

nopins = [m[0] for m in macros if m[1] == 0]
print("MACROs with 0 PIN: %d %s" % (len(nopins), nopins[:10]))

big = sorted(macros, key=lambda m: -m[1])[:10]
print("top-10 by PIN count: %s" % [(b[0], b[1]) for b in big])

# layer section summary
layers = 0
with open(path, "r", errors="replace") as f:
    for ln in f:
        if re.match(r"^\s*LAYER\s+\S+", ln):
            layers += 1
print("LAYER statements: %d" % layers)
