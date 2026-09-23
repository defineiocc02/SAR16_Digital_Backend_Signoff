#!/bin/bash
PC=/home/<user>/sar16_work/proj_paper_core
F=$PC/scripts/fc_pnr_paper_core.tcl
echo "=== actual md5 / size / mtime ==="
md5sum $F
stat -c '%s B  mtime %y' $F
echo
echo "=== anchor present? (want exactly 1) ==="
grep -c 'place_pins -self' $F
echo
echo "=== already patched? ==="
grep -n 'stacking_allowed' $F || echo "   not yet patched"
echo
echo "=== the pin-placement section as it stands ==="
grep -n 'pin placement' -A 6 $F | head -14
echo
echo "=== the older copies that exist (which md5 belongs to which round) ==="
for d in $PC/scripts/.bak_round3 $PC/scripts/.bak_20260918_092621 $PC/scripts/.bak_final; do
    [ -d "$d" ] && for f in $d/fc_pnr_paper_core.tcl*; do
        [ -f "$f" ] && md5sum "$f"
    done
done
