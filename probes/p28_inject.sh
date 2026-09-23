#!/bin/bash
# Round 9d: the report calls the underscore components "injected instance" -> they come
# from LVS INJECT LOGIC YES (the kit deck default, aimed at analog/MS).
# For a pure standard-cell digital block that injection is asymmetric and manufactures
# spurious net/instance/connectivity differences.
#   E = full LVS, INJECT LOGIC NO
#   F = boxed LVS, INJECT LOGIC NO
# The INJECT statement goes at EOF (last statement wins) and the effect is PROVEN by
# re-reading the LVS PARAMETERS block of the produced report.
set -u
LVS=/home/<user>/sar16_work/proj_paper_core/calibre/lvs
W=/tmp/lvsbox
cd $W || exit 1
NAMES=$(tr '\n' ' ' < $W/boxlist.txt)

prep () {   # $1 = out deck, $2 = report, $3 = box|nobox
    if [ "$3" = "box" ]; then
        awk -v box="LVS BOX $NAMES" '{ print } /^LAYOUT PRIMARY/ && !d { print box; d=1 }' \
            $LVS/mylvs.lvs > "$1"
    else
        cp $LVS/mylvs.lvs "$1"
    fi
    echo 'LVS INJECT LOGIC NO' >> "$1"
    sed -i "s|^LVS REPORT \".*\"|LVS REPORT \"$2\"|" "$1"
    printf '  %s : BOX=%s REPORT=%s INJECT=%s\n' "$1" \
        "$(grep -c '^LVS BOX ' "$1")" "$2" "$(grep -c '^LVS INJECT LOGIC NO' "$1")"
}

run () {    # $1 = deck, $2 = tag
    echo "=== RUN $2 $(date +%T) ==="
    T0=$(date +%s)
    calibre -lvs -hier -turbo 6 "$1" > "$W/lvs$2.log" 2>&1
    echo "  RC=$? elapsed=$(( $(date +%s) - T0 ))s"
    echo "  verdict: $(grep -a -i -E 'LVS completed' "$W/lvs$2.log" | tail -1)"
    R="$W/lvs$2.rep"
    echo "  INJECT LOGIC in report  : $(grep -a -m1 'LVS INJECT LOGIC' "$R" | sed 's/^ *//')"
    echo "  --- errors ---"
    grep -a -A1 -E '^  (Error|Warning):' "$R" | grep -a -E '^  (Error|Warning):' | head -10 | sed 's/^/    /'
    N=$(grep -n 'NUMBERS OF OBJECTS AFTER TRANSFORMATION' "$R" | head -1 | cut -d: -f1)
    echo "  --- after transformation ---"
    sed -n "$((N+3)),$((N+12))p" "$R" | sed 's/^/    /'
    echo "  --- Total Inst ---"
    grep -a 'Total Inst' "$R" | sed 's/^/    /'
    echo "  --- incorrect net count ---"
    grep -a -c 'Incorrect Devices On This Net' "$R" | sed 's/^/    blocks=/'
}

prep $W/mylvsE.lvs $W/lvsE.rep nobox
prep $W/mylvsF.lvs $W/lvsF.rep box
run $W/mylvsE.lvs E
run $W/mylvsF.lvs F
echo "=== LVSINJECT_DONE ==="
