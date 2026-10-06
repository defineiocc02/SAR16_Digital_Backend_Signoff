#!/usr/bin/env python3
"""Generate relocatable launchers for the pinned local tool installation."""
from pathlib import Path
r=Path(__file__).resolve().parent
(r/'bin').mkdir(exist_ok=True)
base='#!/bin/bash\nROOT="$(cd "$(dirname "$0")/.." && pwd)"\n'
native='export LD_LIBRARY_PATH="$ROOT/tools/debian/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"\nexport TCL_LIBRARY="$ROOT/tools/debian/usr/share/tcltk/tcl8.6"\n'
for name,target in {'yosys':'yowasp-yosys','sby':'yowasp-sby','yosys-smtbmc':'yowasp-yosys-smtbmc','yosys-witness':'yowasp-yosys-witness'}.items():
    (r/'bin'/name).write_text(base+f'exec "$ROOT/tools/python/bin/{target}" "$@"\n')
for name,target in {'yosys-native':'yosys','abc':'yosys-abc','sta':'sta','vvp':'vvp','verilator':'verilator'}.items():
    extra='export VERILATOR_ROOT="$ROOT/tools/debian/usr/share/verilator"\n' if name=='verilator' else ''
    (r/'bin'/name).write_text(base+native+extra+f'exec "$ROOT/tools/debian/usr/bin/{target}" "$@"\n')
(r/'bin'/'iverilog').write_text(base+native+'exec "$ROOT/tools/debian/usr/bin/iverilog" -B "$ROOT/tools/debian/usr/lib/x86_64-linux-gnu/ivl" "$@"\n')
(r/'bin'/'openroad').write_text(base+native+'PYLIB="$(cat "$ROOT/host-python-libdir.txt")"\nexport LD_LIBRARY_PATH="$ROOT/tools/openroad24/opt/or-tools/lib:$PYLIB:$LD_LIBRARY_PATH"\nexec "$ROOT/tools/openroad24/usr/bin/openroad" "$@"\n')
for p in (r/'bin').iterdir(): p.chmod(0o755)
(r/'env.sh').write_text('''# Source this Bash file for the pinned, user-local cloud tools.
export SAR16_EDA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SAR16_NATIVE_ROOT="$SAR16_EDA_ROOT/tools/debian"
export PATH="$SAR16_EDA_ROOT/bin:$SAR16_EDA_ROOT/tools/python/bin:$SAR16_NATIVE_ROOT/usr/bin:$PATH"
export XDG_CACHE_HOME="$SAR16_EDA_ROOT/cache"
export LD_LIBRARY_PATH="$SAR16_NATIVE_ROOT/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export TCL_LIBRARY="$SAR16_NATIVE_ROOT/usr/share/tcltk/tcl8.6"
export VERILATOR_ROOT="$SAR16_NATIVE_ROOT/usr/share/verilator"
export ORFS_ROOT="$SAR16_EDA_ROOT/tools/OpenROAD-flow-scripts"
export NANGATE45_ROOT="$ORFS_ROOT/flow/platforms/nangate45"
export GF180_ROOT="$ORFS_ROOT/flow/platforms/gf180"
export SKY130HS_ROOT="$ORFS_ROOT/flow/platforms/sky130hs"
export OPENROAD_EXE="$SAR16_EDA_ROOT/bin/openroad"
export YOSYS_EXE="$SAR16_EDA_ROOT/bin/yosys-native"
''')
