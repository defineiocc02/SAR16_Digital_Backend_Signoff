"""V5: independently re-parse the delivered timing / DRC / LVS reports and compare with
the project's own machine-readable summary (RESULT_CURRENT.env).

Nothing here reuses a number quoted by the report generator -- every value is read from
the raw report file and then diffed against the summary, so a mismatch shows up.
"""
import io
import os
import re

R = '.'

env = {}
for ln in io.open(os.path.join(R, 'RESULT_CURRENT.env'), encoding='utf-8', errors='replace'):
    ln = ln.strip()
    if ln and not ln.startswith('#') and '=' in ln:
        k, v = ln.split('=', 1)
        env[k.strip()] = v.strip()

print('=== 1. STA: my parse of sta/sta_pc_summary.txt vs RESULT_CURRENT.env ===')
p = os.path.join(R, 'sta', 'sta_pc_summary.txt')
mine = {}
if os.path.exists(p):
    for ln in io.open(p, encoding='utf-8', errors='replace'):
        s = ln.strip()
        m = re.match(r'^(\w+)\s+(setup|hold)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)\s+(-?\d+\.\d+)', s)
        if m:
            mine[(m.group(1), m.group(2))] = (m.group(3), m.group(4), m.group(5))
    if not mine:
        print('  (pattern did not match; raw first 18 lines follow)')
        for i, ln in enumerate(io.open(p, encoding='utf-8', errors='replace')):
            if i > 17:
                break
            print('    %s' % ln.rstrip()[:120])
for c in ('typical', 'slow', 'fast'):
    for kind, key in (('setup', 'sta_%s_clk_slack' % c), ('hold', 'sta_%s_hold_wns' % c)):
        if (c, kind) in mine:
            print('  %-8s %-6s parsed=%s   env[%s]=%s' % (c, kind, mine[(c, kind)], key, env.get(key, 'ABSENT')))
print('  env setup keys present: %s' % [k for k in env if 'slack' in k])

print('')
print('=== 2. DRC: my totals from drc_CAL.SUM vs env ===')
p = os.path.join(R, 'drc_CAL.SUM')
if os.path.exists(p):
    txt = io.open(p, encoding='utf-8', errors='replace').read()
    rc = re.search(r'TOTAL\s+RULECHECKS?\s+EXECUTED\s*=?\s*(\d+)', txt)
    res = re.findall(r'= *(\d+) *\((\d+)\)', txt)
    tot_brackets = sum(int(b) for _, b in res)
    print('  RULECHECKS parsed     : %s   env[drc_rulechecks]=%s'
          % (rc.group(1) if rc else 'NOT FOUND', env.get('drc_rulechecks', 'ABSENT')))
    print('  sum of "= n (true)"   : %d over %d rules   env[drc_results]=%s'
          % (tot_brackets, len(res), env.get('drc_results', 'ABSENT')))
else:
    print('  drc_CAL.SUM missing')

print('')
print('=== 3. LVS: my read of lvs.rep vs env ===')
p = os.path.join(R, 'lvs.rep')
if os.path.exists(p):
    txt = io.open(p, encoding='utf-8', errors='replace').read()
    verdict = 'INCORRECT' if 'INCORRECT' in txt else ('CORRECT' if 'CORRECT' in txt else '?')
    m = re.search(r'Ports:\s+(\d+)\s+(\d+)', txt)
    m2 = re.search(r'Total Inst:\s+(\d+)\s+(\d+)', txt)
    print('  verdict in report     : %s   env[lvs_verdict]=%s' % (verdict, env.get('lvs_verdict', 'ABSENT')))
    print('  Ports (initial)       : %s' % (m.groups() if m else 'NOT FOUND'))
    print('  Total Inst (initial)  : %s' % (m2.groups() if m2 else 'NOT FOUND'))
else:
    print('  lvs.rep missing')

print('')
print('=== 4. what the env does NOT contain (gaps in the machine summary) ===')
for want in ('sta_slow_hold_wns', 'sta_typical_hold_wns', 'sta_fast_hold_wns',
             'hold_violations_slow', 'drc_bd_1_true', 'lef_macro_count'):
    print('  %-24s %s' % (want, 'present' if want in env else 'ABSENT'))
