#!/bin/bash
# Read-only probe: what exactly does the LVS mismatch consist of?
# Touches nothing; only reads $L and prints.
L=/home/<user>/sar16_work/proj_paper_core/calibre/lvs
PC=/home/<user>/sar16_work/proj_paper_core

echo "########## 1. lvs.rep.ext ##########"
cat "$L/lvs.rep.ext"

echo
echo "########## 2. svdb tree ##########"
find "$L/svdb" -maxdepth 2 | head -40

echo
echo "########## 3. extracted layout netlist: size + element histogram ##########"
find "$L/svdb" -name '*.sp' -o -name '*.cir' 2>/dev/null | while read f; do
    echo "--- $f  $(stat -c%s "$f") B  $(wc -l < "$f") lines"
done

echo
echo "########## 4. shorts file: head 40 ##########"
head -40 "$L/lvs.rep.shorts"

echo
echo "########## 5. shorts file: summary-ish lines ##########"
grep -aiE 'total|number of|short' "$L/lvs.rep.shorts" | head -20
