from pathlib import Path
import os, json, subprocess, time, hashlib, concurrent.futures
S=Path(__file__).resolve().parent; O=Path(os.environ.get('EQ_OUT',str(S.parent))); O.mkdir(exist_ok=True)
YS=os.environ['YOSYS_EXE']; status={}
for builder in ['normalize.py','build_state_miters.py','build_reset_bases.py','build_negative_controls.py']:
 subprocess.run(['python',str(S/builder)],check=True)
pairs=[p.stem[:-len('_coverage')] for p in sorted((O/'results').glob('*_coverage.json'))]
jobs=[(p,False) for pair in pairs for p in [pair,pair+'_reset']]+[(p.stem,True) for p in sorted((O/'scripts').glob('negative_*.ys'))]
def run(job):
 label,negative=job;t=time.monotonic();p=O/'scripts'/f'{label}.ys';log=O/'logs'/f'{label}.log'
 with log.open('w') as f:r=subprocess.run([YS,'-Q','-T','-s',str(p)],stdout=f,stderr=subprocess.STDOUT)
 txt=log.read_text();token='SAT proof finished - model found: FAIL!' if negative else 'SAT proof finished - no model found: SUCCESS!'
 passed=r.returncode==0 and token in txt
 d={'status':'PASS' if passed else 'UNKNOWN','expected_counterexample':negative,'exit_code':r.returncode,'wall_seconds':round(time.monotonic()-t,3),'script_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'log_sha256':hashlib.sha256(log.read_bytes()).hexdigest(),'log':str(log.relative_to(O))}
 print(label,d['status'],d['wall_seconds'],flush=True);return label,d
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
 for label,d in pool.map(run,jobs):status[label]=d
source=json.loads((O/'source_manifest.json').read_text())
for p,h in source['source_sha256'].items():assert hashlib.sha256(Path(p).read_bytes()).hexdigest()==h,f'Input source changed: {p}'
(O/'results/suite_results.json').write_text(json.dumps(status,indent=2)+'\n')
assert all(d['status']=='PASS' for d in status.values()),'Unclosed proof; inspect suite_results.json'
print('All requested proof jobs passed with stable source hashes.',flush=True)
