#!/bin/bash
# Round 12b (F3): what library setup does the existing P&R script use, and what is the
# exact `create_abstract` syntax in this FC version?  Read the tool's own help.
PC=/home/<user>/sar16_work/proj_paper_core
echo "=== library / ndm setup in fc_pnr_paper_core.tcl ==="
grep -n -E 'open_mw_lib|create_mw_lib|set_mw_|\.ndm|reference|search_path|set_app_var|sh_scripts' \
     $PC/scripts/fc_pnr_paper_core.tcl | head -30
echo ""
echo "=== first 40 lines of the script ==="
sed -n '1,40p' $PC/scripts/fc_pnr_paper_core.tcl
echo ""
echo "=== library directory on disk ==="
ls -d $PC/*/ 2>/dev/null | head -20
find $PC -maxdepth 3 -name '*.ndm' -o -maxdepth 3 -name '*.nlib' 2>/dev/null | head -10
echo "=== DONE ==="
