#!/bin/bash
# V1: independent LEC of the DELIVERED post-route netlist against the RTL.
# The existing fm run compared RTL against the SYNTHESISED netlist only.  This one
# reads pnr/out/sar_digi_paper_core_pnr.v as the implementation and keeps the same
# reference RTL, library and SVF guidance.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
W=/tmp/fmv
rm -rf $W; mkdir -p $W

echo "############ existing fm.tcl (to copy the exact setup) ############"
cat $PC/fm/fm.tcl
echo ""
echo "############ build the new deck ############"
python3 - "$PC/fm/fm.tcl" "$W/fm_pnr.tcl" "$PC/pnr/out/sar_digi_paper_core_pnr.v" <<'PYEOF'
import io, sys
src, dst, pnr = sys.argv[1], sys.argv[2], sys.argv[3]
t = io.open(src, encoding='utf-8', errors='replace').read()
old = '/home/<user>/sar16_work/proj_paper_core/mapped_ss/sar_digi_paper_core_netlist.v'
n = t.count(old)
t = t.replace(old, pnr)
# point the reports at the experiment directory
t = t.replace('/home/<user>/sar16_work/proj_paper_core/fm/', '/tmp/fmv/')
io.open(dst, 'w', newline='\n').write(t)
print('  replaced implementation netlist: %d occurrence(s)' % n)
print('  new implementation path: %s' % pnr)
PYEOF
echo "  --- key lines of the new deck ---"
grep -n -E 'read_db|set_svf|read_sverilog|read_verilog|set_top|verify|report_' $W/fm_pnr.tcl

echo ""
echo "############ run formality ############"
cd $W || exit 1
timeout 1800 fm_shell -f $W/fm_pnr.tcl > $W/fm_pnr.log 2>&1
echo "fm_shell rc=$?"
echo ""
echo "############ verdict ############"
grep -a -n -A12 'Verification Results' $W/fm_pnr.log | head -20
echo ""
echo "############ unmatched / failing summaries ############"
for f in $W/unmatched.rpt $W/failing.rpt; do
    if [ -s "$f" ]; then
        echo "--- $f (head 12) ---"; head -12 "$f"
        echo "--- $f (tail 6) ---"; tail -6 "$f"
    else
        echo "--- $f : NOT PRODUCED ---"
    fi
done
echo ""
echo "############ error lines ############"
grep -a -E 'Error|FM_FAIL|FM_NOTE|FM_SVF' $W/fm_pnr.log | head -12
echo "=== FMV1_DONE ==="
