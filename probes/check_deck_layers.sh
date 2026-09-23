#!/bin/bash
L=/home/<user>/sar16_work/proj_paper_core/calibre/lvs/mylvs.lvs
D=/home/<user>/sar16_work/proj_paper_core/calibre/drc/mydrc.drc
echo "=== does the LVS deck map layer 127 or 141? ==="
grep -nE 'LAYER MAP +(127|141)( |$)' $L || echo "   (no direct 127/141 map)"
echo
echo "=== layer map lines mentioning 127/141 anywhere ==="
grep -nE '(^|[^0-9])127([^0-9]|$)|(^|[^0-9])141([^0-9]|$)' $L | head -20
echo
echo "=== what the deck's TEXT/device layers are ==="
grep -nE 'LAYER MAP' $L | wc -l
grep -nE 'TEXT LAYER|PORT LAYER|DEVICE ' $L | head -30
echo
echo "=== DRC deck: 127/141 ==="
grep -nE '(^|[^0-9])127([^0-9]|$)|(^|[^0-9])141([^0-9]|$)' $D 2>/dev/null | head -10
echo
echo "=== the two frame layers present in EVERY named cell ==="
echo "   layer 127 : 1 shape per cell"
echo "   layer 141 : 4-10 shapes per cell"
echo
echo "=== deck: any rule referencing 127/141 as a layer name? ==="
grep -nE 'LAYER +127|LAYER +141' $L | head
