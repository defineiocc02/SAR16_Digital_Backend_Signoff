#!/bin/bash
# Run standalone kit LVS for EVERY master the design places.
# If a cell does not match itself (kit GDS vs kit CDL), its transistors can never
# match in our design either, and the count of such cells x their placements
# bounds how much of the residual mismatch is a library-data problem.
set -u
K=/home/<user>/Project/DESIGN/14BIT_ADC/smic18
PC=/home/<user>/sar16_work/proj_paper_core
WD=$PC/kitcheck
DECK=$K/Calibre/SMIC_CalLVS_018MSE_1833_V1.11_1/SMIC_CalLVS_018MSE_1833_V1.11_1.lvs
KGDS=$K/digital/sc/gds2/smic18.gds2
KCDL=$PC/calibre/lvs/smic18_san.cdl
LIST=$WD/masters.txt

rm -rf $WD; mkdir -p $WD; cd $WD || exit 1
cp /tmp/masters.txt $LIST 2>/dev/null || { echo "MISS masters list"; exit 1; }

echo "cell,placements,verdict,layout_devs,source_devs,dev_delta" > kit_lvs_results.csv
FAIL=0; TOT=0
while read -r CELL N; do
    [ -z "$CELL" ] && continue
    TOT=$((TOT+1))
    sed -e "s|^LAYOUT PATH \"[^\"]*\"|LAYOUT PATH \"$KGDS\"|" \
        -e "s|^LAYOUT PRIMARY \"[^\"]*\"|LAYOUT PRIMARY \"$CELL\"|" \
        -e "s|^SOURCE PATH \"[^\"]*\"|SOURCE PATH \"$KCDL\"|" \
        -e "s|^SOURCE PRIMARY \"[^\"]*\"|SOURCE PRIMARY \"$CELL\"|" \
        -e "s|^LVS REPORT \"[^\"]*\"|LVS REPORT \"$WD/$CELL.rep\"|" \
        "$DECK" > "$CELL.lvs"
    sed -i -E 's|^LVS GLOBALS ARE PORTS.*|LVS GLOBALS ARE PORTS   YES|' "$CELL.lvs"
    if grep -qE '^PRECISION' "$CELL.lvs"; then
        sed -i -E 's|^PRECISION  *[0-9]+|PRECISION 1000|' "$CELL.lvs"
    else
        sed -i -E '/^LAYOUT PRIMARY/a PRECISION 1000' "$CELL.lvs"
    fi
    calibre -lvs -hier "$CELL.lvs" > "$CELL.log" 2>&1
    V=$(grep -aoE '^\s+(CORRECT|INCORRECT)\s+' "$CELL.rep" 2>/dev/null | head -1 | tr -d ' ')
    [ -z "$V" ] && V="NO_REPORT"
    # device counts from the extracted layout netlist and the source cdl
    LD=$(awk '/^M/{c++} END{print c+0}' "$CELL.sp" 2>/dev/null)
    SD=$(awk -v c="$CELL" 'BEGIN{IGNORECASE=1}
        $1==".subckt" && $2==c {f=1; next} f && $1==".ends" {f=0}
        f && substr($1,1,1)=="M" {n++} END{print n+0}' "$KCDL")
    echo "$CELL,$N,$V,${LD:-0},${SD:-0},$(( ${LD:-0} - ${SD:-0} ))" >> kit_lvs_results.csv
    [ "$V" != "CORRECT" ] && { FAIL=$((FAIL+1)); echo "   FAIL $CELL  verdict=$V  layout_devs=${LD:-0} cdl_devs=${SD:-0}"; }
done < "$LIST"

echo
echo "=== summary ==="
echo "   cells tested : $TOT"
echo "   INCORRECT    : $FAIL"
echo
echo "=== the failing cells (if any) ==="
awk -F, 'NR>1 && $3!="CORRECT"' kit_lvs_results.csv | head -40
echo
echo "=== all results ==="
cat kit_lvs_results.csv
echo
echo "KIT_ALL_DONE"
