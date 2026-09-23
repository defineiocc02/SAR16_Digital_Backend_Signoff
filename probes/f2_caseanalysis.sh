#!/bin/bash
# F2: why did FC replace rst_n with a tie constant?  The classic cause is a
# set_case_analysis / constant on rst_n in the P&R constraints: FC then optimises the
# reset logic away.
PC=/home/<user>/sar16_work/proj_paper_core
for f in $PC/constraints/sar_digi_paper_core_pnr.sdc $PC/constraints/sar_digi_paper_core.sdc \
         $PC/pnr/out/sar_digi_paper_core_pnr.sdc; do
    [ -s "$f" ] || continue
    echo "############ $f  ($(stat -c%s "$f") B) ############"
    echo "--- set_case_analysis / set_constant / disable ---"
    grep -n -E 'set_case_analysis|set_constant|set_disable|case_analysis' "$f" | head -20
    echo "--- every line mentioning rst_n ---"
    grep -n 'rst_n' "$f" | head -20
    echo ""
done

echo "############ the P&R tcl: anything forcing rst_n / constants? ############"
grep -n -E 'set_case_analysis|set_constant|rst_n|constant' $PC/scripts/fc_pnr_paper_core.tcl | head -20

echo ""
echo "############ FC log: did it report removing the reset? ############"
grep -a -n -i -E 'rst_n|constant|case_analysis' $PC/logs/fc_pnr.log 2>/dev/null | head -12
echo "=== F2_DONE ==="
