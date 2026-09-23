#!/bin/bash
# Read-only probe 5: is "+1499 VDD connections" the reset net's fanout?
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/calibre/lvs
SRC=$L/sar16.cdl
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v

echo "########## A. rst_n fanout, several calibers ##########"
echo "-- source CDL ($SRC)"
echo "   lines containing rst_n              : $(grep -c 'rst_n' $SRC)"
echo "   rst_n as a whole token              : $(grep -o '\brst_n\b' $SRC | wc -l)"
echo "   RST_N (upper) token                 : $(grep -o '\bRST_N\b' $SRC | wc -l)"
echo "-- post-route netlist ($NET)"
echo "   lines containing rst_n              : $(grep -c 'rst_n' $NET)"
echo "   rst_n as a whole token              : $(grep -o '\brst_n\b' $NET | wc -l)"
echo "   .rst_n( port connections           : $(grep -o '\.rst_n(' $NET | wc -l)"

echo
echo "########## B. top-level port list, source vs layout ##########"
echo "-- source top .SUBCKT port count:"
awk '/^[.]SUBCKT sar_digi_paper_core /{f=1} f{print} f&&!/\+$/{exit}' $SRC > /tmp/top_src.txt
python3 - <<'PYEOF'
import re
txt=open("/tmp/top_src.txt").read()
txt=txt.replace("+\n"," ").replace("+ "," ")
parts=txt.split()
# parts[0]='.SUBCKT', [1]=name, rest are ports
print("   source top ports parsed :", len(parts)-2)
print("   rst_n present in source :", "rst_n" in parts[2:])
PYEOF

echo
echo "########## C. layout extracted top .SUBCKT port count ##########"
python3 - <<'PYEOF'
p="/home/<user>/sar16_work/proj_paper_core/calibre/lvs/svdb/sar_digi_paper_core.sp"
lines=open(p,errors="replace").read().splitlines()
start=None
for i,l in enumerate(lines):
    if l.startswith(".SUBCKT sar_digi_paper_core "):
        start=i; break
buf=[]
for l in lines[start:]:
    buf.append(l)
    if not l.rstrip().endswith("+"):
        break
txt=" ".join(x.rstrip().rstrip("+") for x in buf)
parts=txt.split()
print("   layout top ports parsed :", len(parts)-2)
print("   rst_n present in layout :", "rst_n" in parts[2:])
print("   VDD/VSS present         :", "VDD" in parts[2:], "VSS" in parts[2:])
PYEOF

echo
echo "########## D. INCORRECT INSTANCES section: what is extra ##########"
awk '/INCORRECT INSTANCES/{f=1} f{print} f&&/INCORRECT NETS/{exit}' $L/lvs.rep | head -50
