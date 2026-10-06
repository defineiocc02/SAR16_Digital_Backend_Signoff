#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
D="$ROOT/debian/usr"
export PATH="$D/bin:$PATH"
export LD_LIBRARY_PATH="$D/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export TCL_LIBRARY="$D/share/tcltk/tcl8.6"
export TK_LIBRARY="$D/share/tcltk/tk8.6"
export CFLAGS="-O2 -I$D/include -I$D/include/tcl8.6"
export CPPFLAGS="-I$D/include -I$D/include/tcl8.6"
export LDFLAGS="-L$D/lib/x86_64-linux-gnu -Wl,-rpath,$D/lib/x86_64-linux-gnu"
COMMON=(--prefix="$ROOT/local" --with-tcl="$D/lib/x86_64-linux-gnu/tcl8.6" --with-tk="$D/lib/x86_64-linux-gnu/tk8.6" --with-tclincls="$D/include/tcl8.6" --with-tkincls="$D/include/tcl8.6" --with-tcllibs="$D/lib/x86_64-linux-gnu" --with-tklibs="$D/lib/x86_64-linux-gnu" --x-includes="$D/include" --x-libraries="$D/lib/x86_64-linux-gnu")
cd "$ROOT/magic-src"
./configure "${COMMON[@]}" --with-opengl=no --with-cairo=no --disable-readline --disable-magic-builddate > "$ROOT/logs/magic-configure.log" 2>&1
make -j4 > "$ROOT/logs/magic-build.log" 2>&1
make install > "$ROOT/logs/magic-install.log" 2>&1
cd "$ROOT/netgen-src"
./configure "${COMMON[@]}" > "$ROOT/logs/netgen-configure.log" 2>&1
make -j4 > "$ROOT/logs/netgen-build.log" 2>&1
make install > "$ROOT/logs/netgen-install.log" 2>&1
