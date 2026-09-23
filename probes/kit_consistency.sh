#!/bin/bash
# DECISIVE TEST: is the kit internally consistent?
#
# For each standard cell, run Calibre LVS with the TOP cell = that standard cell,
# layout from the kit GDS and source from the kit CDL.  These two files ship
# together in the same PDK.  If a cell does not match ITSELF, then no design built
# from that cell can ever pass LVS -- and the remaining mismatch in our run is a
# library-data problem, not a design problem.
#
# Nothing in the project is modified: everything happens in $PC/kitcheck/.
set -u
K=/home/<user>/Project/DESIGN/14BIT_ADC/smic18
PC=/home/<user>/sar16_work/proj_paper_core
WD=$PC/kitcheck
DECK=$K/Calibre/SMIC_CalLVS_018MSE_1833_V1.11_1/SMIC_CalLVS_018MSE_1833_V1.11_1.lvs
KGDS=$K/digital/sc/gds2/smic18.gds2
KCDL=$PC/calibre/lvs/smic18_san.cdl      # the sanitised kit CDL already built

rm -rf $WD; mkdir -p $WD; cd $WD || exit 1

echo "################ kit self-consistency test ################"
for f in "$DECK" "$KGDS" "$KCDL"; do
    if [ -s "$f" ]; then echo "OK   $f  ($(stat -c%s "$f") B)"
    else echo "MISS $f"; echo "status=INPUT_MISSING"; exit 1; fi
done
echo

for CELL in NOR2XL NAND2BXL INVXL DFFSX1 XNOR2XL AOI21XL AND4XL OAI211X1 NAND2XL DFFSXL NOR2X1 MXI2XL; do
    sed -e "s|^LAYOUT PATH \"[^\"]*\"|LAYOUT PATH \"$KGDS\"|" \
        -e "s|^LAYOUT PRIMARY \"[^\"]*\"|LAYOUT PRIMARY \"$CELL\"|" \
        -e "s|^SOURCE PATH \"[^\"]*\"|SOURCE PATH \"$KCDL\"|" \
        -e "s|^SOURCE PRIMARY \"[^\"]*\"|SOURCE PRIMARY \"$CELL\"|" \
        -e "s|^LVS REPORT \"[^\"]*\"|LVS REPORT \"$WD/$CELL.rep\"|" \
        "$DECK" > "$CELL.lvs"
    # force the same globals/precision settings the project uses
    sed -i -E 's|^LVS GLOBALS ARE PORTS.*|LVS GLOBALS ARE PORTS   YES|' "$CELL.lvs"
    if grep -qE '^PRECISION' "$CELL.lvs"; then
        sed -i -E 's|^PRECISION  *[0-9]+|PRECISION 10000|' "$CELL.lvs"
    else
        sed -i -E '/^LAYOUT PRIMARY/a PRECISION 10000' "$CELL.lvs"
    fi
    calibre -lvs -hier "$CELL.lvs" > "$CELL.log" 2>&1
    rc=$?
    v=$(grep -aE '^\s+(CORRECT|INCORRECT)\s+' "$CELL.rep" 2>/dev/null | head -1 | awk '{print $1}')
    [ -z "$v" ] && v=$(grep -aoE 'CORRECT|INCORRECT|NOT COMPARED' "$CELL.rep" 2>/dev/null | head -1)
    nerr=$(grep -ac '^\s*Error:' "$CELL.rep" 2>/dev/null)
    printf "   %-12s rc=%-3s verdict=%-12s errors=%s\n" "$CELL" "$rc" "${v:-?}" "${nerr:-0}"
done

echo
echo "################ per-cell error detail (any that failed) ################"
for r in *.rep; do
    c=${r%.rep}
    if grep -qa 'INCORRECT\|NOT COMPARED' "$r"; then
        echo "--- $c ---"
        sed -n '/OVERALL COMPARISON RESULTS/,/CELL  SUMMARY/p' "$r" | grep -aE 'Error|Warning' | head -6
        sed -n '/INITIAL NUMBERS OF OBJECTS/,/Total Inst/p' "$r" | head -12
    fi
done
echo
echo "KITCHECK_DONE"
