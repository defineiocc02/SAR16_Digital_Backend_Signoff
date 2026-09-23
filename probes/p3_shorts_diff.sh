#!/bin/bash
# Read-only probe 3: are the extraction shorts NEW (introduced by the PG strap
# extension) or pre-existing?  Compare this round against the earlier round.
L=/home/<user>/sar16_work/proj_paper_core/calibre/lvs
SP=$L/svdb/sar_digi_paper_core.sp

echo "########## A. short-circuit warnings: this round vs earlier round ##########"
for f in lvs.rep.ext lvsA.rep.ext; do
    if [ -s "$L/$f" ]; then
        n=$(grep -ac 'Short circuit' "$L/$f")
        echo "$f : $n short-circuit warning(s), $(stat -c%s "$L/$f") B, mtime $(stat -c%y "$L/$f" | cut -c1-19)"
    else
        echo "$f : MISSING"
    fi
done

echo
echo "########## B. earlier round (lvsA.rep.ext) — the short groups ##########"
grep -a -A6 'Short circuit' "$L/lvsA.rep.ext" | head -60

echo
echo "########## C. this round (lvs.rep.ext) — group headers only ##########"
grep -a -A3 'Short circuit' "$L/lvs.rep.ext" | grep -aE 'Net Id|name ' | head -20

echo
echo "########## D. how many nets carry >1 label, this round ##########"
grep -ac 'The name .* was assigned to the net' "$L/lvs.rep.ext"

echo
echo "########## E. does the extracted top cell contain rst_n on the VDD net? ##########"
echo "--- .SUBCKT sar_digi_paper_core in the extracted netlist? ---"
grep -n '^[.]SUBCKT sar_digi_paper_core' "$SP" | head -3
echo "--- all .SUBCKT in extracted netlist (count) ---"
grep -c '^[.]SUBCKT' "$SP"
echo "--- any line mentioning rst_n in the extracted netlist ---"
grep -n 'rst_n' "$SP" | head -10

echo
echo "########## F. the extracted top subckt: first 12 lines after the header ##########"
awk '/^[.]SUBCKT sar_digi_paper_core/{f=1} f{print; n++} n>12{exit}' "$SP"
