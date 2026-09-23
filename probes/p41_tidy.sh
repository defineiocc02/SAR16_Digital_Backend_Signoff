#!/bin/bash
# Round 11 housekeeping: extract the small evidence, drop the transient LVS products,
# and prove the project tree was not written to by this round.
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/lvs11
echo "=== project tree: anything newer than 21:50 today? ==="
find $PC -newermt "2026-09-18 21:50" -type f 2>/dev/null | head
echo "(empty above = round 11 did not touch the project tree)"
echo ""
{
  echo "### 1. SPEF proves the tie chain is physically present"
  SPEF=$(find $PC -name '*.spef' -size +1M 2>/dev/null | head -1)
  echo "SPEF = $SPEF  ($(stat -c%s "$SPEF") B)"
  printf '  HFSINV lines = %s   distinct HFSINV names = %s\n' \
    "$(grep -c HFSINV "$SPEF")" "$(grep -o 'HFSINV_[0-9]*_[0-9]*' "$SPEF" | sort -u | wc -l)"
  printf '  HFSNET lines = %s\n' "$(grep -c HFSNET "$SPEF")"
  printf '  distinct instances in SPEF = %s\n' "$(grep -a '^\*I ' "$SPEF" | sed 's/^\*I  *//' | awk -F: '{print $1}' | sort -u | wc -l)"
  echo
  echo "### 2. the written netlist: who has a driver"
  V=$PC/pnr/out/sar_digi_paper_core_pnr.v
  python3 - "$V" <<'PY'
import re, sys, collections
t = open(sys.argv[1], errors='replace').read()
driven = set(re.findall(r'\.Y\s*\(\s*(HFSNET_\d+)\s*\)', t))
ref = set(re.findall(r'HFSNET_\d+', t))
roots = sorted(ref - driven)
print('  HFSNET referenced = %d   driven by a .Y = %d   ROOTS = %d' % (len(ref), len(driven), len(roots)))
print('  roots: %s' % ', '.join(roots))
print('  HFSNET_8 as .Y = %d ; as .A = %d ; as port name = %d'
      % (len(re.findall(r'\.Y\s*\(\s*HFSNET_8\s*\)', t)),
         len(re.findall(r'\.A\s*\(\s*HFSNET_8\s*\)', t)),
         len(re.findall(r'\.HFSNET_8\s*\(', t))))
PY
  echo
  echo "### 3. root-tie repair variants (all still INCORRECT)"
  for v in L1 L2 L3; do
    printf '  %s : %s | %s\n' "$v" "$(grep -a -m1 'LVS completed' $W/lvs$v.log)" \
      "$(grep -a -m1 'Connections On This Net' $W/lvs$v.rep | sed 's/  */ /g')"
  done
} > /tmp/round11_evidence.txt
wc -l /tmp/round11_evidence.txt
echo ""
echo "=== removing transient products ==="
du -sh $W 2>/dev/null
rm -rf $W
ls -d $W 2>/dev/null || echo "  /tmp/lvs11 removed"
rm -f /tmp/p37.sh /tmp/p39.sh /tmp/p40.sh /tmp/p37.out /tmp/tie_root_fix.py 2>/dev/null
echo "=== /tmp now ==="
ls -1 /tmp | wc -l; du -sh /tmp 2>/dev/null
echo "=== DONE ==="
