#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
echo "=== run_sta_paper_core.sh (full, it is short) ==="
cat -n $PC/scripts/run_sta_paper_core.sh | sed -n '1,130p'
