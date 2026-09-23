#!/bin/bash
# Read-only: every consumer of the two interfaces we are about to narrow.
PC=/home/<user>/sar16_work/proj_paper_core

echo "########## A. SDC files ##########"
ls -la $PC/constraints/
for f in $PC/constraints/*.sdc; do
    echo "--- $f"
    grep -n 'weight_rd_data\|weight_rd_en\|weight_rd_addr\|srm_residue_o' "$f" || echo "    (no reference)"
done

echo
echo "########## B. testbenches / sim sources ##########"
find $PC -maxdepth 3 \( -name 'tb_*.sv' -o -name 'tb_*.v' \) 2>/dev/null
for f in $(find $PC -maxdepth 3 \( -name 'tb_*.sv' -o -name 'tb_*.v' \) 2>/dev/null); do
    echo "--- $f"
    grep -n 'weight_rd_data\|weight_rd_en\|weight_rd_addr\|srm_residue_o' "$f" || echo "    (no reference)"
done

echo
echo "########## C. other RTL consumers ##########"
grep -rn 'weight_rd_data\|weight_rd_en\|weight_rd_addr\|srm_residue_o' $PC/rtl/*.sv

echo
echo "########## D. the top's declaration of srm_residue_q and WEIGHT_WIDTH use ##########"
grep -n 'srm_residue_q\|WEIGHT_WIDTH' $PC/rtl/sar_digi_paper_core.sv

echo
echo "########## E. reproduce_all.sh stage list (what a re-run would execute) ##########"
grep -n 'STAGE\|run_dc\|run_pnr\|run_sta\|run_calibre\|run_lvs\|collect_result' $PC/scripts/reproduce_all.sh | head -40
