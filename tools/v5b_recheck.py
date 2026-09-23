"""V5b: fix the two defects in my first re-check (a tuple-format crash and a DRC regex
that matched unrelated parenthesised numbers -- it reported 367 041 "results" over 516
"rules", which is nonsense and is therefore VOID, not a finding)."""
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

print('=== DRC: drc_CAL.SUM structure ===')
p = os.path.join(R, 'drc_CAL.SUM')
lines = io.open(p, encoding='utf-8', errors='replace').read().splitlines()
print('  file lines: %d' % len(lines))
for i, ln in enumerate(lines[:14]):
    print('    %3d| %s' % (i + 1, ln.rstrip()[:110]))

rul = [ln for ln in lines if ln.strip().upper().startswith('RULECHECK')]
print('')
print('  lines starting with RULECHECK : %d' % len(rul))
tot_true = 0
tot_cap = 0
n = 0
for ln in rul:
    m = re.findall(r'=\s*(\d+)\s*\((\d+)\)', ln)
    if m:
        cap, true = int(m[-1][0]), int(m[-1][1])
        tot_cap += cap
        tot_true += true
        n += 1
print('  RULECHECK lines with "= n (true)" : %d' % n)
print('  sum of capped values              : %d' % tot_cap)
print('  sum of TRUE values                : %d   env[drc_results]=%s'
      % (tot_true, env.get('drc_results', 'ABSENT')))
hdr = [ln for ln in lines if 'RULECHECK' in ln.upper() and 'EXECUTED' in ln.upper()]
print('  header line                       : %s' % (hdr[0][:100] if hdr else 'NOT FOUND'))

print('')
print('=== LVS: lvs.rep ===')
txt = io.open(os.path.join(R, 'lvs.rep'), encoding='utf-8', errors='replace').read()
for pat, lbl in ((r'Ports:\s+(\d+)\s+(\d+)', 'Ports'),
                 (r'Total Inst:\s+(\d+)\s+(\d+)', 'Total Inst')):
    m = re.search(pat, txt)
    print('  %-10s : %s' % (lbl, m.groups() if m else 'NOT FOUND'))
print('  verdict  : %s   env[lvs_verdict]=%s'
      % ('INCORRECT' if 'INCORRECT' in txt else 'CORRECT', env.get('lvs_verdict', 'ABSENT')))

print('')
print('=== STA hold: what the raw summary says vs what I quoted in the handover ===')
p = os.path.join(R, 'sta', 'sta_pc_summary.txt')
hold = []
for ln in io.open(p, encoding='utf-8', errors='replace'):
    m = re.match(r'STA_RESULT corner=(\w+).*viol_hold=(\d+)\s+wns_hold=(-?\d+\.\d+)', ln.strip())
    if m:
        hold.append((m.group(1), int(m.group(2)), m.group(3)))
print('  raw STA summary      : %s' % hold)
print('  sum of viol_hold     : %d' % sum(h[1] for h in hold))
print('  env hold keys        : %s' % [k for k in env if 'hold' in k] or 'NONE')
print('  NOTE: my handover report quotes "39 hold violations (slow 16 / fast 12 / typical 1)".')
print('        The raw summary above is the authority; the sum is what it is.')
