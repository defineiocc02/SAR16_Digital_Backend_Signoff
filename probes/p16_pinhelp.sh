#!/bin/bash
# Get place_pins usage.  Two lessons applied:
#   * this release rejects -no_gui; the correct form is  fc_shell -f <script>
#   * fc_shell keeps reading stdin after a script error, so feed it /dev/null
#   * CMD errors abort the script, so the usage call goes LAST.
PC=/home/<user>/sar16_work/proj_paper_core
cat > /tmp/pinhelp.tcl <<'TCL'
puts "PINHELP-BEGIN"
puts "=== place_pins -help ==="
place_pins -help
puts "PINHELP-END"
exit 0
TCL
rm -f $PC/fc_pinhelp.log
fc_shell -f /tmp/pinhelp.tcl < /dev/null > $PC/fc_pinhelp.log 2>&1
echo "log bytes: $(stat -c%s $PC/fc_pinhelp.log)"
echo
sed -n '/PINHELP-BEGIN/,$p' $PC/fc_pinhelp.log | head -80
rm -f /tmp/pinhelp.tcl
