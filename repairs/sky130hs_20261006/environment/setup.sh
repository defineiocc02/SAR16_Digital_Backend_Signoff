#!/usr/bin/env bash
# Rebuild the tested, user-local cloud EDA environment. No sudo or system edits.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-install}"
export ROOT
mkdir -p "$ROOT"/{downloads,tools,logs,bin,cache}
if [[ "$(uname -m)" != x86_64 ]]; then echo 'This lock targets Linux x86_64.' >&2; exit 1; fi
if [[ "$MODE" != install && "$MODE" != --verify-downloads ]]; then
  echo 'Usage: setup.sh [install|--verify-downloads]' >&2; exit 1
fi
export MODE
python3 - <<'PY'
import os,json,hashlib,subprocess
from pathlib import Path
r=Path(os.environ['ROOT'])
for a in json.loads((r/'download-manifest.json').read_text()):
    if not a['active']: continue
    p=r/'downloads'/a['file']
    if not p.exists():
        if os.environ['MODE']=='--verify-downloads': raise SystemExit(f'Missing: {p}')
        subprocess.run(['curl','--fail','--location','--retry','2','--max-time','300',a['url'],'--output',str(p)],check=True)
    if hashlib.sha256(p.read_bytes()).hexdigest()!=a['sha256']:
        raise SystemExit(f'SHA256 mismatch: {p}')
    print('VERIFIED',a['file'])
    if os.environ['MODE']=='install':
        dest=r/'tools'/('openroad24' if a['package']=='openroad' else 'debian')
        dest.mkdir(parents=True,exist_ok=True)
        subprocess.run(['dpkg-deb','-x',str(p),str(dest)],check=True)
PY
[[ "$MODE" == --verify-downloads ]] && exit 0

# OpenROAD's selected official Ubuntu24 binary links to CPython3.12.
PYTHON_BIN="${PYTHON_BIN:-$(command -v python3.12 || command -v python3)}"
"$PYTHON_BIN" - <<'PY'
import sys,os
assert sys.version_info[:2]==(3,12),'Use a shared-library CPython3.12 build (PYTHON_BIN=...)'
p=os.path.join(sys.base_prefix, 'lib', 'libpython3.12.so.1.0')
assert os.path.exists(p),f'Required shared Python library is absent: {p}'
PY
"$PYTHON_BIN" -m venv "$ROOT/tools/python"
if [[ -d "$ROOT/downloads/wheels" ]]; then
  "$ROOT/tools/python/bin/pip" install --no-index --find-links "$ROOT/downloads/wheels" --require-hashes -r "$ROOT/python-requirements-hashed.lock"
else
  "$ROOT/tools/python/bin/pip" install --no-cache-dir --require-hashes -r "$ROOT/python-requirements-hashed.lock"
fi
PYTHON_LIB="$($PYTHON_BIN -c 'import sys,os;print(os.path.join(sys.base_prefix,"lib"))')"
printf '%s\n' "$PYTHON_LIB" > "$ROOT/host-python-libdir.txt"
ORFS="$ROOT/tools/OpenROAD-flow-scripts"
PIN=ad11cc9f8cc8bde9946200cafc21bae265067188
# Delivered minimal public PDK inputs can be replayed without a Git checkout.
# Never silently overwrite changed prepacked inputs.
if [[ ! -d "$ORFS/.git" && -f "$ORFS/flow/platforms/sky130hs/lib/sky130_fd_sc_hs__tt_025C_1v80.lib" && -f "$ROOT/supplied-platform-sha256.json" ]]; then
  python3 "$ROOT/verify_supplied_platform.py"
else
NEW_ORFS=0
if [[ ! -d "$ORFS/.git" ]]; then
  git init "$ORFS"
  git -C "$ORFS" remote add origin https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
  git -C "$ORFS" sparse-checkout init --cone
  git -C "$ORFS" sparse-checkout set flow/platforms/sky130hs flow/platforms/sky130hd flow/scripts
  NEW_ORFS=1
fi
if ! git -C "$ORFS" cat-file -e "$PIN^{commit}" 2>/dev/null; then git -C "$ORFS" fetch --filter=blob:none --depth=1 origin "$PIN"; fi
if [[ "$NEW_ORFS" == 0 && -n "$(git -C "$ORFS" status --porcelain)" ]]; then echo 'Refusing to overwrite a modified ORFS checkout.' >&2; exit 1; fi
git -C "$ORFS" checkout --detach "$PIN"
fi
python3 "$ROOT/configure_wrappers.py"
echo "Ready: source $ROOT/env.sh"
echo "Run the validation smoke separately: $ROOT/smoke_sky130hs.sh"
