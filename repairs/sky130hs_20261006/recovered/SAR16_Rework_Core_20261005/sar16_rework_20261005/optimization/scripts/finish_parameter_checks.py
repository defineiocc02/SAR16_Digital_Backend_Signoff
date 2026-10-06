from pathlib import Path
import json,subprocess
R=Path(__file__).resolve().parents[3];O=R/'sar16_rework_20261005/optimization';report=O/'reports/parameter_results.json';results=json.loads(report.read_text())
for name,data in results.items():
 D=O/'parameter_checks'/name;F=D/'formal';L=D/'logs';params=data['parameters'];(F/'baseline_invariant.sv').write_text((O/'formal/baseline_invariant.sv').read_text());s=(O/'formal/baseline_invariant.ys').read_text().replace(str(O),str(D)).replace('prep -top','chparam '+' '.join(f'-set {k} {v}' for k,v in params.items())+' sar_calib_ctrl_serial\nprep -top');(F/'baseline_invariant.ys').write_text(s)
 with (L/'baseline_invariant.log').open('w') as log:cp=subprocess.run(['yosys-native','-s',str(F/'baseline_invariant.ys')],stdout=log,stderr=subprocess.STDOUT)
 data['invariant_status']='PASS' if cp.returncode==0 else 'FAIL'
 subprocess.run(['python3',str(O/'scripts/prove_reset_base.py'),str(D)],check=True)
 with (L/'reset_base.log').open('w') as log:cp=subprocess.run(['yosys-native','-s',str(F/'reset_base.ys')],stdout=log,stderr=subprocess.STDOUT)
 data['reset_base_status']='PASS' if cp.returncode==0 else 'FAIL';print(name,data,flush=True)
report.write_text(json.dumps(results,indent=2)+'\n')
