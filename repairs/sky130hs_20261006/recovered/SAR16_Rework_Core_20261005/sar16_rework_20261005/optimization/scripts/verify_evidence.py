from pathlib import Path
import hashlib,json,re
R=Path(__file__).resolve().parents[3];O=R/'sar16_rework_20261005/optimization';summary=json.loads((O/'reports/summary.json').read_text());checks=[]
def check(name,ok):
 checks.append({'name':name,'pass':bool(ok)})
 if not ok:raise SystemExit('Evidence check failed: '+name)
for n,h in summary['rtl_sha256'].items():check('frozen candidate '+n,hashlib.sha256((R/'sar16_rework_20261005/repo/rtl_optimized'/n).read_bytes()).hexdigest()==h)
baseline=json.loads((R/'sar16_repair_20261005/backend/reports/rtl_sha256.json').read_text())
for n,h in baseline.items():check('unchanged baseline '+n,hashlib.sha256((R/'sar16_repair_20261005/rtl_frozen'/n).read_bytes()).hexdigest()==h)
for n in ['baseline_invariant','storage_equivalence','reset_base']:check(n,'SUCCESS!' in (O/'logs'/f'{n}.log').read_text())
for n in ['calib_bmc','calib_induction','calib_publish_bmc','calib_publish_induction','calib_cover']:check(n,'Status: PASSED' in (O/'formal_regression/logs'/f'{n}.log').read_text())
for n,marker in [('tb_sar16_smoke','SAR16_SMOKE_PASS checks=166'),('tb_srm_repair','SRM_REPAIR_PASS checks=39'),('tb_srm_latency','SRM_LATENCY_EXPERIMENT_PASS phases=12 normal_samples=1200'),('iverilog_repair','SRM_REPAIR_PASS checks=39')]:check(n,marker in (O/'regression/logs'/f'{n}.log').read_text())
check('two full calibration sweeps',(O/'regression/logs/tb_sar16_smoke.log').read_text().count('CALIB_PROTOCOL_PASS writes=14')==2)
check('negative mutation detected',json.loads((O/'reports/negative_control.json').read_text())['detected'])
for n,v in json.loads((O/'reports/parameter_results.json').read_text()).items():
 for k in ['status','invariant_status','reset_base_status']:check(n+' '+k,v[k]=='PASS')
d=json.loads((O/'synthesis/reports/synth_stats.json').read_text())['design'];check('exact mapped area',d['area']==8400.546);check('846 flops',sum(v for k,v in d['num_cells_by_type'].items() if k.startswith('DFF'))==846)
check('only calibration source changed',[n for n,h in baseline.items() if summary['rtl_sha256'][n]!=h]==['sar_calib_ctrl_serial.sv'])
(O/'reports/evidence_validation.json').write_text(json.dumps({'status':'PASS','checks':checks},indent=2)+'\n');print('PASS:',len(checks),'evidence checks')
