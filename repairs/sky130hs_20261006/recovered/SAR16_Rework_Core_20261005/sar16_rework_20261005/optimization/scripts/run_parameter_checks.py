from pathlib import Path
import subprocess,json
R=Path(__file__).resolve().parents[3];O=R/'sar16_rework_20261005/optimization';cases={'fallback_low':{'MAX_CALIB_BIT':0},'fallback_high':{'MAX_CALIB_BIT':15},'alternate_legal':{'WEIGHT_WIDTH':31,'COMP_WAIT_CYC':4,'AVG_LOOPS':1,'REF_WEIGHT_LSB':512,'ROUND_HALF_LSB':0,'DETECT_OVERRANGE':0}}
results={}
for name,params in cases.items():
 D=O/'parameter_checks'/name;F=D/'formal';L=D/'logs';F.mkdir(parents=True,exist_ok=True);L.mkdir(exist_ok=True)
 for n,p in [('old',R/'sar16_repair_20261005/rtl_frozen'),('new',R/'sar16_rework_20261005/repo/rtl_optimized')]:
  s=(O/f'formal/{n}.ys').read_text().replace(str(O),str(D)).replace('hierarchy -top sar_calib_ctrl_serial','chparam '+ ' '.join(f'-set {k} {v}' for k,v in params.items())+' sar_calib_ctrl_serial\nhierarchy -top sar_calib_ctrl_serial')
  (F/(n+'.ys')).write_text(s)
  with (L/(n+'_normalize.log')).open('w') as log:subprocess.run(['yosys-native','-s',str(F/(n+'.ys'))],stdout=log,stderr=subprocess.STDOUT,check=True)
 subprocess.run(['python3',str(O/'scripts/prove_state_relation.py'),str(D)],check=True)
 with (L/'storage_equivalence.log').open('w') as log:cp=subprocess.run(['yosys-native','-s',str(F/'storage_equivalence.ys')],stdout=log,stderr=subprocess.STDOUT)
 results[name]={'parameters':params,'status':'PASS' if cp.returncode==0 else 'FAIL','returncode':cp.returncode};print(name,results[name],flush=True)
(O/'reports/parameter_results.json').write_text(json.dumps(results,indent=2)+'\n')
