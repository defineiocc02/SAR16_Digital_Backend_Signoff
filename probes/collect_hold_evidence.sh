#!/bin/bash
# Move the hold-experiment reports out of the project tree into the handover
# scratch, leaving the delivery tree clean.  The BASELINE reports are untouched.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
S=$PC/pnr/reports/sta
D=/tmp/hold_exp_evidence
rm -rf $D; mkdir -p $D

echo "=== before ==="
ls -1 $S | wc -l
ls -1 $S | grep -cE 'holdfix|_hf2|_hf3' || true

for tag in holdfix hf2 hf3; do
    for f in $S/*_${tag}_*.rpt; do
        [ -f "$f" ] && mv "$f" $D/
    done
done

echo "=== after ==="
ls -1 $S | wc -l
echo "   experiment files moved: $(ls -1 $D | wc -l)"
echo "   leftovers in the project: $(ls -1 $S | grep -cE 'holdfix|_hf2|_hf3' || echo 0)"
echo
echo "=== keep only the four reports that carry the result ==="
ls -la $D | head -5
for f in $D/*_holdfix_hold.rpt $D/*_hf2_hold.rpt $D/*_hf3_hold.rpt; do
    [ -f "$f" ] && echo "   keeping $(basename $f) ($(stat -c%s $f) B)"
done
# drop the bulky per-corner detail of the intermediate variant
rm -f $D/*_holdfix_violators.rpt $D/*_holdfix_drc.rpt $D/*_holdfix_setup.rpt
echo "   after pruning: $(ls -1 $D | wc -l) file(s), $(du -sh $D | cut -f1)"
echo
echo "=== baseline hold reports still intact ==="
ls -la $S/sta_pc_slow_pc_hold.rpt $S/sta_pc_typical_pc_hold.rpt $S/sta_pc_fast_pc_hold.rpt | awk '{print "   "$5" "$9}'
