#!/bin/bash
# Round 10 housekeeping: keep the small evidence, remove the transient LVS/experiment
# products, and PROVE the project tree was not written to by this round.
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/lvs10
echo "=== project tree: anything newer than 21:30 today? ==="
find $PC -newermt "2026-09-18 21:30" -type f 2>/dev/null | head
echo "(empty above = round 10 did not touch the project tree)"
echo ""
echo "=== compact round-10 evidence ==="
{
  echo "### 1. the tie chain (P&R Verilog)"
  grep -n -m3 'HFSINV' $PC/pnr/out/sar_digi_paper_core_pnr.v
  echo
  echo "### 2. HFSNET_8 has no driver (expect: no hits)"
  grep -nE '(assign|wire|reg)[^;]*HFSNET_8' $PC/pnr/out/sar_digi_paper_core_pnr.v | head
  echo
  echo "### 3. rst_n of the two big blocks points at HFSNET_119"
  grep -n 'rst_n ( HFSNET_119 )' $PC/pnr/out/sar_digi_paper_core_pnr.v
  echo
  echo "### 4. HFSNET / HFSINV counts across the three netlists"
  for f in $PC/pnr/out/sar_digi_paper_core_pnr.v $PC/calibre/lvs/sar16.cdl \
           $PC/calibre/lvs/svdb/sar_digi_paper_core.sp; do
    printf '  %-58s HFSNET=%-6s HFSINV=%s\n' "$(basename $f)" \
      "$(grep -c HFSNET $f)" "$(grep -c HFSINV $f)"
  done
  echo
  echo "### 5. fix attempt 2 result (patch all HFSNET -> 1'b1): still INCORRECT"
  grep -a -m1 'LVS completed' $W/lvsK.log
  grep -a -m1 'Connections On This Net' $W/lvsK.rep
  echo
  echo "### 6. best config (boxed + INJECT NO, unpatched source): only VDD is wrong"
  grep -a -m1 'LVS completed' $W/lvsF.log
  sed -n '/DISC#/,/^ *1 /p' $W/lvsF.rep | head -8
} > /tmp/round10_evidence.txt
wc -l /tmp/round10_evidence.txt
echo ""
echo "=== removing transient products ==="
du -sh $W 2>/dev/null
rm -rf $W
ls -d $W 2>/dev/null || echo "  /tmp/lvs10 removed"
echo "=== /tmp now ==="
ls -1 /tmp | wc -l; du -sh /tmp 2>/dev/null
echo "=== DONE ==="
