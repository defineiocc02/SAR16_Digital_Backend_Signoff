#!/bin/bash
# Clean the VM's /tmp of agent scratch.  Rules:
#   * only entries OWNED BY <user>          (system dirs are root-owned or sockets)
#   * never touch X11 / ICE / systemd / snap / .font-unix style entries
#   * /tmp/run_*.sh is SAFE: reproduce_all.sh re-syncs it from scripts/ before
#     every stage (verified at lines 43-63 of that script)
#   * write a manifest so the deletion is auditable
PC=/home/<user>/sar16_work/proj_paper_core
MAN=/tmp/tmp_cleanup_manifest.txt

echo "before: $(du -sh /tmp 2>/dev/null | cut -f1)   entries: $(ls -1 /tmp | wc -l)"
echo
{
  echo "# /tmp cleanup $(date '+%F %T')  user=<user>"
  echo "# name<TAB>bytes<TAB>mtime"
} > "$MAN"

cd /tmp || exit 1
n=0; freed=0
for e in *; do
    [ -e "$e" ] || continue
    # skip X11 / system
    case "$e" in
        .X11-unix|.ICE-unix|.XIM-unix|.font-unix|.Test-unix|systemd-private-*|snap-private-*|.X*-lock|tmp*|.*)
            continue ;;
    esac
    owner=$(stat -c '%U' "$e" 2>/dev/null)
    [ "$owner" = "<user>" ] || continue
    sz=$(du -sb "$e" 2>/dev/null | cut -f1)
    mt=$(stat -c '%y' "$e" 2>/dev/null | cut -c1-19)
    printf '%s\t%s\t%s\n' "$e" "$sz" "$mt" >> "$MAN"
    rm -rf -- "$e"
    n=$((n+1)); freed=$((freed + ${sz:-0}))
done

echo "removed entries : $n"
echo "freed bytes     : $freed  ($((freed/1024/1024)) MB)"
echo "manifest        : $MAN"
echo
echo "after: $(du -sh /tmp 2>/dev/null | cut -f1)   entries: $(ls -1 /tmp | wc -l)"
echo
echo "=== what survived (should be system/sockets only) ==="
ls -la /tmp | head -20
echo
echo "=== safety: the project and its backups are untouched ==="
du -sh $PC
ls -1 $PC/scripts/.bak_pinfix $PC/scripts/.bak_globals $PC/rtl/.bak_v50 2>/dev/null
