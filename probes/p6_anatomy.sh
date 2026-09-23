#!/bin/bash
# Read-only probe 6: anatomy of the two big incorrect nets, plus a correct
# SPICE port parser (continuation lines START with '+', they do not end with it).
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/calibre/lvs
SRC=$L/sar16.cdl
SP=$L/svdb/sar_digi_paper_core.sp

echo "########## A. correct port counts ##########"
python3 - <<'PYEOF'
def ports(path, top):
    lines = open(path, errors="replace").read().splitlines()
    out, on = [], False
    for l in lines:
        s = l.rstrip()
        if not on:
            if s.upper().startswith(".SUBCKT " + top):
                on = True
                out.append(s[8 + len(top):])
        else:
            if s.startswith("+"):
                out.append(s[1:])
            else:
                break
    return [t for t in " ".join(out).split() if t]

src = ports("/home/<user>/sar16_work/proj_paper_core/calibre/lvs/sar16.cdl",
            "sar_digi_paper_core")
lay = ports("/home/<user>/sar16_work/proj_paper_core/calibre/lvs/svdb/sar_digi_paper_core.sp",
            "sar_digi_paper_core")
print("source top ports : %d" % len(src))
print("layout top ports : %d" % len(lay))
print("source-only      : %d %s" % (len(set(src) - set(lay)), sorted(set(src) - set(lay))[:12]))
print("layout-only      : %d %s" % (len(set(lay) - set(src)), sorted(set(lay) - set(src))[:12]))
print("rst_n in source  : %s" % ("rst_n" in src or "RST_N" in [s.upper() for s in src]))
print("rst_n in layout  : %s" % ("rst_n" in lay or "RST_N" in [s.upper() for s in lay]))
PYEOF

echo
echo "########## B. anatomy of the 'Net VDD' entry ##########"
awk '/^  1    Net VDD/{f=1} /^  2    Net VSS/{f=0} f' $L/lvs.rep > /tmp/vdd_entry.txt
echo "   lines in entry        : $(wc -l < /tmp/vdd_entry.txt)"
echo "   '(cell ports)' marks  : $(grep -c '(cell ports)' /tmp/vdd_entry.txt)"
echo "   '--- ' sub-headers    :"
grep -n -- '---' /tmp/vdd_entry.txt | head -20
echo "   first 12 lines:"
head -12 /tmp/vdd_entry.txt
echo "   last 15 lines:"
tail -15 /tmp/vdd_entry.txt

echo
echo "########## C. counts of incorrect objects ##########"
echo "   incorrect nets         : $(grep -cE '^ +[0-9]+ +Net ' $L/lvs.rep)"
echo "   'missing instance'     : $(grep -ac 'missing instance' $L/lvs.rep)"
echo "   'no similar net'       : $(grep -ac 'no similar net' $L/lvs.rep)"
echo "   incorrect-instance IDs : $(awk '/INCORRECT INSTANCES/{f=1} /INCORRECT NETS/{f=0} f' $L/lvs.rep | grep -cE '^ +[0-9]+ +X')"

echo
echo "########## D. what the layout-only devices have in common ##########"
awk '/INCORRECT INSTANCES/{f=1} /INCORRECT NETS/{f=0} f' $L/lvs.rep \
  | grep -aE 'missing instance' | sed -E 's/.*(MN|MP)\(([A-Z0-9]+)\).*/\1 \2/' | sort | uniq -c
echo "   parent cell of those devices (top 10):"
awk '/INCORRECT INSTANCES/{f=1} /INCORRECT NETS/{f=0} f' $L/lvs.rep \
  | grep -aE 'missing instance' | awk '{print $2}' | sed -E 's#/[^/]+$##' | sort | uniq -c | sort -rn | head -10
