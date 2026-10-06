#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/../../environment/env.sh"
export EQ_OUT="$HERE"
python - <<'PY'
from pathlib import Path
import os,json,hashlib
out=Path(os.environ['EQ_OUT']); root=out.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for p,h in json.loads((out/'identity/identity_before.json').read_text())['candidate_sha256'].items():assert sha(root/p)==h, p
for p,h in json.loads((out/'identity/driver_provenance.json').read_text())['driver_sha256'].items():assert sha(out/'driver'/p)==h,p
PY
{ python "$HERE/driver/run_suite.py"
  python "$HERE/driver/collect_report.py"
  python "$HERE/driver/verify_evidence.py"
} 2>&1 | tee "$HERE/driver.log"
python "$HERE/driver/finalize_candidate.py"
