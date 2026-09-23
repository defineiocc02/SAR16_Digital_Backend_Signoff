#!/bin/bash
# poll the F3 wrapper run
W=/tmp/f3wrap
echo "=== p44.out complete ==="
cat /tmp/p44.out
echo ""
echo "=== fc_shell log: filtered ==="
grep -a -E '^(OK|FAIL|---|blocks:|designs:|cells:|WRAP_MACRO|F3_DONE)' $W/f3.log 2>/dev/null | head -40
echo ""
echo "=== fc_shell log tail ==="
tail -20 $W/f3.log 2>/dev/null
echo ""
echo "=== outputs in $W ==="
ls -la $W 2>/dev/null
echo "=== DONE ==="
