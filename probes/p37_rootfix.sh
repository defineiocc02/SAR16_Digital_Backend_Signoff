#!/bin/bash
# Round 11: single-variable root-tie repair of the delivered netlist.
#   L1  every undriven HFSNET root -> 1'b0   (the SN=VDD consistency argument)
#   L2  every undriven HFSNET root -> 1'b1   (contrast)
#   L3  roots -> 1'b0, but HFSNET_119 (drives rst_n of both big blocks) -> 1'b1
# Each variant is ONE change; the 85 HFSINV instances always keep their real wiring.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
LVS=$PC/calibre/lvs
SRC=$PC/pnr/out/sar_digi_paper_core_pnr.v
W=/tmp/lvs11
rm -rf $W; mkdir -p $W; cd $W || exit 1
cp $LVS/smic18_san.cdl $W/smic18_san.cdl

# box list = real standard-cell masters in the extracted layout netlist
python3 - "$LVS/svdb/sar_digi_paper_core.sp" > $W/boxlist.txt <<'PYEOF'
import sys, collections
logical = []
for raw in open(sys.argv[1], errors='replace'):
    st = raw.strip()
    if st.startswith('+'):
        if logical: logical[-1] = logical[-1] + ' ' + st[1:].strip()
        continue
    logical.append(st)
known = set()
for st in logical:
    if st.upper().startswith('.SUBCKT'):
        known.add(st.split()[1])
cur = None; subs = collections.OrderedDict(); order = []
for st in logical:
    up = st.upper()
    if up.startswith('.SUBCKT'):
        t = st.split(); cur = t[1]; subs[cur] = {'m': 0}; order.append(cur); continue
    if up.startswith('.ENDS'):
        cur = None; continue
    if cur and st and st[0].upper() == 'M':
        subs[cur]['m'] += 1
for k in order:
    if not k.startswith('ICV_') and k != 'sar_digi_paper_core' and subs[k]['m'] > 0:
        print(k)
PYEOF
echo "BOX_CELLS=$(wc -l < $W/boxlist.txt)"
NAMES=$(tr '\n' ' ' < $W/boxlist.txt)

run_variant () {   # $1 tag  $2 rootv  $3 special-net-or-NONE  $4 specialv
    echo ""
    echo "================ variant $1 : root -> $2 , ${3:-none} -> ${4:-none} ================"
    if [ "$3" = "NONE" ]; then
        python3 /tmp/tie_root_fix.py $SRC $W/net_$1.v "$2"
    else
        python3 /tmp/tie_root_fix.py $SRC $W/net_$1.v "$2" "$3" "$4"
    fi
    v2lvs -v $W/net_$1.v -o $W/src_$1.cdl -s $W/smic18_san.cdl -s0 VSS -s1 VDD \
          -log $W/v2lvs_$1.log > $W/v2lvs_$1.out 2>&1
    if [ ! -s $W/src_$1.cdl ]; then
        echo "  FATAL: v2lvs produced no CDL"; tail -6 $W/v2lvs_$1.log; return
    fi
    echo "  CDL ok : subckts=$(grep -c '^\.SUBCKT' $W/src_$1.cdl)  HFSNET=$(grep -c HFSNET $W/src_$1.cdl)  VDD=$(grep -o VDD $W/src_$1.cdl | wc -l)"

    awk -v box="LVS BOX $NAMES" '{ print } /^LAYOUT PRIMARY/ && !d { print box; d=1 }' \
        $LVS/mylvs.lvs > $W/lvs$1.lvs
    printf 'LVS INJECT LOGIC NO\n' >> $W/lvs$1.lvs
    sed -i -e "s|^LVS REPORT \".*\"|LVS REPORT \"$W/lvs$1.rep\"|" \
           -e "s|^SOURCE PATH \".*\"|SOURCE PATH \"$W/src_$1.cdl\"|" $W/lvs$1.lvs
    T0=$(date +%s)
    calibre -lvs -hier -turbo 6 lvs$1.lvs > $W/lvs$1.log 2>&1
    echo "  RC=$? elapsed=$(( $(date +%s) - T0 ))s   $(grep -a -m1 'LVS completed' $W/lvs$1.log)"
    N=$(grep -n 'NUMBERS OF OBJECTS AFTER TRANSFORMATION' $W/lvs$1.rep | head -1 | cut -d: -f1)
    sed -n "$((N+3)),$((N+12))p" $W/lvs$1.rep | sed 's/^/    /'
    echo "  errors: $(grep -a -E '^  (Error|Warning):' $W/lvs$1.rep | sed 's/^ *//' | sort -u | tr '\n' '|')"
    A=$(grep -n 'INCORRECT NETS' $W/lvs$1.rep | head -1 | cut -d: -f1)
    if [ -n "$A" ]; then
        echo "  incorrect nets:"
        sed -n "${A},$((A+400))p" $W/lvs$1.rep | grep -a -E '^ +[0-9]+ +Net |Connections On This Net' | head -12 | sed 's/^/    /'
    fi
}

run_variant L1 "1'b0" NONE ""
run_variant L2 "1'b1" NONE ""
run_variant L3 "1'b0" HFSNET_119 "1'b1"
echo ""
echo "=== LVS11_DONE ==="
