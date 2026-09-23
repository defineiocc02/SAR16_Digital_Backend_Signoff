#!/bin/bash
# Read-only probe 2: device-level accounting, layout-extracted vs source CDL.
L=/home/<user>/sar16_work/proj_paper_core/calibre/lvs
SP=$L/svdb/sar_digi_paper_core.sp
SRC=$L/sar16.cdl

echo "########## A. python availability ##########"
command -v python3 && python3 -V
command -v python  && python  -V

echo
echo "########## B. extracted layout netlist ##########"
ls -la "$SP"
echo "--- line count: $(wc -l < "$SP")"
echo "--- head 40 ---"
head -40 "$SP"

echo
echo "########## C. element histogram in extracted .sp ##########"
echo "top-level (column-0) element letters:"
awk '/^[A-Za-z]/ {c[substr($0,1,1)]++} END {for (k in c) printf "  %s : %d\n", k, c[k]}' "$SP" | sort
echo "--- device subckt names used (2nd field of X lines), top 25 ---"
awk '/^[Xx]/ {print $2}' "$SP" | sort | uniq -c | sort -rn | head -25

echo
echo "########## D. source CDL ##########"
ls -la "$SRC"
echo "--- .SUBCKT count : $(grep -c '^[.]SUBCKT' "$SRC")"
echo "--- top .SUBCKT lines ---"
grep -n '^[.]SUBCKT' "$SRC" | head -5
echo "--- X instances in top subckt region ---"
awk '/^[.]SUBCKT sar_digi_paper_core/,/^[.]ENDS/' "$SRC" > /tmp/top_src.cdl
echo "    top subckt lines: $(wc -l < /tmp/top_src.cdl)"
echo "--- X instance subckt types in source top, top 25 ---"
awk '/^[Xx]/ {print $NF}' /tmp/top_src.cdl | sort | uniq -c | sort -rn | head -25

echo
echo "########## E. port comparison ##########"
echo "--- layout .sp top .SUBCKT header (first 3 lines) ---"
head -3 "$SP"
echo "--- source top .SUBCKT header ---"
grep -m1 -A2 '^[.]SUBCKT sar_digi_paper_core' "$SRC"
