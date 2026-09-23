#!/bin/bash
# Round 9e: small one-knob-at-a-time matrix on top of LVS INJECT LOGIC NO.
# Each run is ~16 s, so a matrix is cheaper than another round of guessing.
# Every variant states exactly which single knob it adds, and the verdict is read
# from the report, never inferred from the exit code.
set -u
LVS=/home/<user>/sar16_work/proj_paper_core/calibre/lvs
W=/tmp/lvsbox
cd $W || exit 1
NAMES=$(tr '\n' ' ' < $W/boxlist.txt)

variant () {   # $1 tag  $2 extra-svrF-line  $3 box|nobox
    D=$W/mylvs$1.lvs; R=$W/lvs$1.rep; L=$W/lvs$1.log
    if [ "$3" = "box" ]; then
        awk -v box="LVS BOX $NAMES" '{ print } /^LAYOUT PRIMARY/ && !d { print box; d=1 }' \
            $LVS/mylvs.lvs > $D
    else
        cp $LVS/mylvs.lvs $D
    fi
    printf 'LVS INJECT LOGIC NO\n%s\n' "$2" >> $D
    sed -i "s|^LVS REPORT \".*\"|LVS REPORT \"$R\"|" $D
    T0=$(date +%s)
    calibre -lvs -hier -turbo 6 $D > $L 2>&1
    RC=$?
    EL=$(( $(date +%s) - T0 ))
    V=$(grep -a -m1 -E 'LVS completed' $L)
    echo "---- variant $1 : box=$3  +[$2]  RC=$RC  ${EL}s"
    echo "     $V"
    echo "     inject in report : $(grep -a -m1 'LVS INJECT LOGIC' $R | sed 's/^ *//')"
    echo "     $(grep -a -m1 'LVS EXPAND UNBALANCED' $R | sed 's/^ *//')"
    echo "     $(grep -a -m1 'LVS SHORT EQUIVALENT' $R | sed 's/^ *//')"
    echo "     $(grep -a -m1 'LVS REDUCE SERIES MOS' $R | sed 's/^ *//')"
    N=$(grep -n 'NUMBERS OF OBJECTS AFTER TRANSFORMATION' $R | head -1 | cut -d: -f1)
    if [ -n "$N" ]; then sed -n "$((N+3)),$((N+11))p" $R | sed 's/^/     /'; fi
    echo "     $(grep -a 'Total Inst' $R | tail -1 | sed 's/^ *//')"
    echo "     incorrect-net blocks : $(grep -a -c 'Incorrect Devices On This Net' $R)"
    echo "     errors: $(grep -a -E '^  (Error|Warning):' $R | sed 's/^ *//' | sort -u | tr '\n' '|')"
}

variant G "LVS REDUCE SERIES MOS YES"        nobox
variant H "LVS SHORT EQUIVALENT NODES YES"   nobox
variant I "LVS EXPAND UNBALANCED CELLS NO"   nobox
variant J "LVS REDUCE SERIES MOS YES"        box
echo "=== LVSMTX_DONE ==="
