#!/usr/bin/env python3
"""Build observation-only formal adapters; never modifies or overrides DUT drivers."""
from pathlib import Path
import subprocess, sys, hashlib, json, os
root=Path(__file__).resolve().parent
rtl=Path(os.environ.get('RTL_DIR',str(root/'../rtl_frozen'))).resolve()
names=['sar_calib_ctrl_serial','sar_digi_paper_core','srm_residue_estimator','srm_residue_lut']
manifest={n+'.sv':hashlib.sha256((rtl/(n+'.sv')).read_bytes()).hexdigest() for n in names}
expected=json.loads((root/'pinned_rtl_sha256.json').read_text())
if manifest!=expected: raise SystemExit('Frozen RTL checksum mismatch; refuse stale proof inputs')
(root/'rtl_sha256.json').write_text(json.dumps(manifest,indent=2)+'\n')
for case in sys.argv[1:] or ['lut','calib','raw']:
 top=case+'_formal'
 fs=names if case=='raw' else (['sar_calib_ctrl_serial'] if case.startswith('calib') else ['srm_residue_lut'] if case=='lut' else ['srm_residue_estimator','srm_residue_lut'])
 script='read_verilog -formal -sv -D SYNTHESIS '+ ' '.join(str(rtl/(n+'.sv')) for n in fs)+' '+str(root/'harness'/(top+'.sv'))+'\n'
 script+='hierarchy -check -top '+top+'\nproc\nflatten\n'
 adapters={}
 if case.startswith('calib'): adapters=dict(state='state',target='target_bit',wridx='wr_idx_r',sarptr='sar_ptr',wait='wait_cnt',calc='calc_cnt',avg='avg_cnt')
 mapping=root/'harness'/(case+'_observations.json')
 if mapping.exists(): adapters.update(json.loads(mapping.read_text()))
 for a,b in adapters.items(): script+=f'connect -nounset -set f_{a} dut.{b}\n'
 script+='opt\nmemory_map\nopt\n'
 if case=='lut':
  script+='chformal -lower\nchformal -cover -remove\nsat -verify -prove-asserts -set-assumes -show-inputs\n'
  for k in [0,11,22]: script+=f'sat -set-assumes -set cnt {k} -show cnt -show half\n'
 else:
  script+=('clk2fflogic\n' if case.startswith('srm') else 'async2sync\ndffunmap\n')
  script+='chformal -lower\nopt\ndffunmap\ncheck -assert\nwrite_smt2 -wires '+str(root/(top+'.smt2'))+'\n'
 (root/(case+'_adapter.ys')).write_text(script)
 with (root/'logs'/(case+'_build.log')).open('w') as log:
  cp=subprocess.run(['yosys','-Q','-T','-s',str(root/(case+'_adapter.ys'))],stdout=log,stderr=subprocess.STDOUT)
 print(case,cp.returncode,flush=True)
 if cp.returncode: print((root/'logs'/(case+'_build.log')).read_text()[-5000:]);sys.exit(cp.returncode)
