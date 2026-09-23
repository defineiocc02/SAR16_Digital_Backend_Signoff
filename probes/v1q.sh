#!/bin/bash
# V1 follow-up: qualify the "SUCCEEDED".
#   (a) 146 port compare points vs 178 top-level ports -- which ports are not compared?
#   (b) how did Formality treat the UNDRIVEN tie nets (HFSNET_8 etc.)?
W=/tmp/fmv
echo "############ (a) port compare points ############"
grep -a -n -iE 'port.*(compare|unmatch)|unmatched.*port|primary input|primary output' $W/fm_pnr.log | head -12
echo "--- how many ports does each side have? ---"
grep -a -n -iE '^ *(Reference|Implementation).*(port|design)|Number of (primary )?(input|output)s?' $W/fm_pnr.log | head -12
echo ""
echo "############ (b) undriven / constant handling ############"
grep -a -n -iE 'undriven|unresolved|tie|constant|set_constant|hdlin_|verification_set' $W/fm_pnr.log | head -20
echo ""
echo "############ (c) the implementation's own undriven nets (from the netlist) ############"
V=/home/<user>/sar16_work/proj_paper_core/pnr/out/sar_digi_paper_core_pnr.v
python3 - "$V" <<'PYEOF'
import re, sys, collections
t = open(sys.argv[1], errors='replace').read()
# every net that is used as a connection but never driven
driven = set()
for m in re.finditer(r'\.\w+\s*\(\s*([A-Za-z_][\w\[\]]*)\s*\)', t):
    pass
outs = set(re.findall(r'\.(?:Y|Q|QN|ZN|Z|CO|S|ENCLK)\s*\(\s*([A-Za-z_][\w\[\]]*)\s*\)', t))
uses = collections.Counter(re.findall(r'\.\w+\s*\(\s*([A-Za-z_][\w\[\]]*)\s*\)', t))
un = sorted(n for n in uses if n not in outs and not n.startswith('1\'b') and n not in ('VDD','VSS'))
print('  nets used but never driven by an output pin: %d' % len(un))
for n in un[:15]:
    print('    %-24s used %d time(s)' % (n, uses[n]))
PYEOF
echo "=== V1Q_DONE ==="
