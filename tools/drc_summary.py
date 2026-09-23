"""Independent DRC summary parser for the delivered Calibre run.

Reads `drc_CAL.SUM` and reports, from the CALIBRE::DRC-H SUMMARY REPORT only:
  * how many rules were actually checked (RULECHECK lines)
  * how many produced results, and the total number of results
  * the checks carrying the most results (the routing-relevant ones)
  * Calibre's own ORIGINAL LAYER STATISTICS, verbatim

Two traps this file has already sprung:
  * counting arbitrary integers out of unrelated sections -> nonsense totals;
  * assuming a RULECHECK line format instead of reading it.  The real format is
    `RULECHECK <name> ..... TOTAL Result Count = <n>    (<m>)`, and the two columns
    are NOT interchangeable -- the tool prints both sums below so the caller can see
    which one reproduces the reported 3402.
"""
import io
import os
import re
import sys

P = sys.argv[1] if len(sys.argv) > 1 else '../evidence/rpt_v51/drc_CAL.SUM'
t = io.open(P, encoding='utf-8', errors='replace').read()

rows = re.findall(
    r'^\s*RULECHECK\s+(\S+)\s+\.*\s*TOTAL Result Count\s*=\s*(\d+)\s*\(\s*(\d+)\s*\)\s*$',
    t, re.M)
if not rows:
    print('NO RULECHECK LINES MATCHED -- the format assumption is wrong, do not quote 0.')
    raise SystemExit(1)

col1 = [(n, int(a)) for n, a, b in rows]
col2 = [(n, int(b)) for n, a, b in rows]

print('DRC summary file : %s' % os.path.basename(P))
print('rulechecks listed        : %d' % len(rows))
print('sum of column 1          : %d' % sum(c for _, c in col1))
print('sum of column 2 (parens) : %d' % sum(c for _, c in col2))
print('rulechecks with results  : %d' % sum(1 for _, c in col1 if c > 0))
print('')

fired = [x for x in col1 if x[1] > 0]
tot = sum(c for _, c in col1)
print('%-40s %8s %6s' % ('check (column 1)', 'results', 'share'))
for n, c in sorted(fired, key=lambda x: -x[1]):
    print('%-40s %8d %5.1f%%' % (n, c, 100.0 * c / tot))

cat = {}
for n, c in fired:
    key = re.split(r'[_.]', n)[0]
    cat[key] = cat.get(key, 0) + c
print('')
print('--- roll-up by leading token ---')
for k, v in sorted(cat.items(), key=lambda x: -x[1]):
    print('%-20s %8d %5.1f%%' % (k, v, 100.0 * v / tot))

lay = re.findall(
    r'^\s*LAYER\s+(\S+)\s+\.*\s*TOTAL Original Geometry Count\s*=\s*(\d+)\s*\(\s*(\d+)\s*\)\s*$',
    t, re.M)
if lay:
    print('')
    print('--- ORIGINAL LAYER STATISTICS (verbatim; the two columns are not explained in the file) ---')
    print('%-12s %12s %12s' % ('layer', 'col1', 'col2'))
    for name, a, b in lay:
        if int(a) or int(b):
            print('%-12s %12d %12d' % (name, int(a), int(b)))
