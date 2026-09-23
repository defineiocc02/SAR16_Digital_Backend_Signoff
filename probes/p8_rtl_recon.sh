#!/bin/bash
# Read-only reconnaissance for the interface narrowing (F2).
PC=/home/<user>/sar16_work/proj_paper_core
R=$PC/rtl

echo "########## A. rtl tree ##########"
ls -la $R
echo
echo "########## B. every declaration / driver / use of weight_rd_data ##########"
grep -rn 'weight_rd_data' $R
echo
echo "########## C. every declaration / driver / use of srm_residue_o ##########"
grep -rn 'srm_residue_o' $R
echo
echo "########## D. the top module port list ##########"
grep -n 'module sar_digi_paper_core' -A 80 $R/sar_digi_paper_core.sv | head -100
