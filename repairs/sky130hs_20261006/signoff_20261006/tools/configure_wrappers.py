#!/usr/bin/env python3
from pathlib import Path
r=Path(__file__).resolve().parent
base='#!/bin/bash\nset -e\nROOT="$(cd "$(dirname "$0")/.." && pwd)"\nexport LD_LIBRARY_PATH="$ROOT/debian/usr/lib/x86_64-linux-gnu:$ROOT/debian/usr/lib/klayout${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"\nexport TCL_LIBRARY="$ROOT/debian/usr/share/tcltk/tcl8.6"\nexport TK_LIBRARY="$ROOT/debian/usr/share/tcltk/tk8.6"\n'
for name in ['magic','netgen']:
 (r/'bin'/name).write_text(base+f'exec "$ROOT/local/bin/{name}" "$@"\n')
(r/'bin'/'netgen-lvs').write_text(base+'exec "$ROOT/local/bin/netgen" "$@"\n')
(r/'bin'/'klayout').write_text(base+'export RUBYLIB="$ROOT/debian/usr/lib/ruby/3.3.0:$ROOT/debian/usr/lib/x86_64-linux-gnu/ruby/3.3.0${RUBYLIB:+:$RUBYLIB}"\nexport GEM_PATH="$ROOT/debian/usr/lib/ruby/gems/3.3.0"\nexport QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-offscreen}"\nexport QT_PLUGIN_PATH="$ROOT/debian/usr/lib/x86_64-linux-gnu/qt5/plugins${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"\nexec "$ROOT/debian/usr/lib/klayout/klayout" "$@"\n')
for f in (r/'bin').iterdir(): f.chmod(0o755)
(r/'env.sh').write_text('export SAR16_SIGNOFF_TOOLS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"\nexport PATH="$SAR16_SIGNOFF_TOOLS/bin:$PATH"\n')
