from pathlib import Path
import json,hashlib,sys
E=Path(__file__).resolve().parent;R=E/'tools/OpenROAD-flow-scripts';M=json.loads((E/'supplied-platform-sha256.json').read_text())
assert M['orfs_commit']=='ad11cc9f8cc8bde9946200cafc21bae265067188'
for n,h in M['files'].items():
 p=R/n
 assert p.is_file(),f'Missing supplied platform input: {p}'
 assert hashlib.sha256(p.read_bytes()).hexdigest()==h,f'Modified supplied platform input: {p}'
print('PASS',len(M['files']),'supplied platform file hashes at pinned ORFS commit',M['orfs_commit'])
