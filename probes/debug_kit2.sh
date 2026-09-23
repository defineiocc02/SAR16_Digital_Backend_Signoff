#!/bin/bash
WD=/home/<user>/sar16_work/proj_paper_core/kitcheck
echo "=== NOR2XL.rep.ext (full) ==="
cat $WD/NOR2XL.rep.ext
echo
echo "=== NOR2XL.log: error / warning / fatal lines ==="
grep -anE 'ERROR|Error|Error:|FATAL|Cannot|can not|not found|Nothing|abort|Abort' $WD/NOR2XL.log | tail -25
echo
echo "=== NOR2XL.log: last 25 lines ==="
tail -25 $WD/NOR2XL.log
