"""Pin a supplied final routed artifact while retaining the exact frozen sources."""
from pathlib import Path
import json, hashlib, argparse
ap = argparse.ArgumentParser()
ap.add_argument('--routed',type=Path,required=True)
ap.add_argument('--sha256',required=True)
ap.add_argument('--case',default='candidate_final')
args=ap.parse_args()
root = Path(__file__).resolve().parent.parent
assert args.case and Path(args.case).name == args.case
out = root / args.case
src = root / 'candidate_mapped'
config = json.loads((src/'config.json').read_text())
prior = json.loads((src/'source_manifest.json').read_text())
assert args.routed.is_file()
routed = args.routed.resolve()
actual = hashlib.sha256(routed.read_bytes()).hexdigest()
assert actual == args.sha256, (str(routed), actual, args.sha256)
for path, h in prior['source_sha256'].items():
    assert hashlib.sha256(Path(path).read_bytes()).hexdigest() == h, path
config['netlists']['sky130hs_routed'] = str(routed)
prior['config'] = config
prior['source_roles']['netlist/sky130hs_routed'] = {'path':str(routed),'sha256':actual}
prior['source_sha256'][str(routed)] = actual
prior.pop('model_sha256',None)
if (out/'source_manifest.json').exists():
    existing = json.loads((out/'source_manifest.json').read_text())
    assert existing['source_sha256'] == prior['source_sha256'], 'A changed artifact requires a fresh evidence directory'
else:
    out.mkdir(parents=True,exist_ok=True)
    (out/'source_manifest.json').write_text(json.dumps(prior,indent=2)+'\n')
(out/'config.json').write_text(json.dumps(config,indent=2)+'\n')
print(out)
