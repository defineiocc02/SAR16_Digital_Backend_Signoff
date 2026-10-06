#!/usr/bin/env python3
"""Rerun nine frozen formal jobs in a fresh directory without editing archived evidence."""
import argparse,hashlib,json,os,shutil,subprocess,sys,tempfile
from pathlib import Path
R=Path(__file__).resolve().parents[1];B=R/'repairs/sky130hs_20261006';S=B/'signoff_20261006';E=S/'equivalence_candidate_v2_diodefree'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--platform',type=Path,default=B/'environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs');p.add_argument('--yosys',default=os.environ.get('YOSYS_EXE','yosys'));p.add_argument('--openroad',default=os.environ.get('OPENROAD_EXE','openroad'));p.add_argument('--output',type=Path);a=p.parse_args()
 out=a.output.resolve() if a.output else Path(tempfile.mkdtemp(prefix='sar16-formal-'))
 if out.exists() and any(out.iterdir()):p.error('Output must be new or empty')
 out.mkdir(parents=True,exist_ok=True);platform=a.platform.resolve();cfg=json.loads((E/'config.json').read_text())
 old='/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006';oldplatform=old+'/environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs'
 cfg=json.loads(json.dumps(cfg).replace(old,str(B)).replace(str(B)+'/environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs',str(platform)))
 (out/'config.json').write_text(json.dumps(cfg,indent=2)+'\n')
 # Preserve source-role hash pins; normalize.py accepts relocation, never different bytes.
 shutil.copy2(E/'source_manifest.json',out/'source_manifest.json')
 env=os.environ.copy();env['EQ_OUT']=str(out);env['YOSYS_EXE']=str(Path(shutil.which(a.yosys) or a.yosys).resolve())
 pins=json.loads((E/'evidence_sha256.json').read_text())
 for name,h in pins.items():
  if name.startswith('driver/'):assert sha(E/name)==h, name
 frozen=json.loads((S/'candidate_v2_diodefree/reports/frozen_input_hashes.json').read_text())
 for name,h in frozen.items():assert sha(S/'candidate_v2_diodefree/results'/name)==h,name
 with (out/'replay.log').open('w') as log:
  for script in ('run_suite.py','collect_report.py','verify_evidence.py'):
   print('Running',script,flush=True);subprocess.run([sys.executable,str(E/'driver'/script)],env=env,stdout=log,stderr=subprocess.STDOUT,check=True)
 # Check actual ODB export identity in the relocated workflow as well.
 lib=platform/'lib/sky130_fd_sc_hs__tt_025C_1v80.lib';odb=S/'candidate_v2_diodefree/results/routed.odb'
 # Reject Tcl metacharacters rather than interpolating ambiguous paths.
 for path in (lib,odb,out):
  if any(c in str(path) for c in '{}\n\r'):raise ValueError('Unsupported Tcl path characters')
 script=out/'reexport.tcl';script.write_text(f'read_liberty {{{lib}}}\nread_db {{{odb}}}\nwrite_verilog {{{out}/routed_from_odb.v}}\nwrite_verilog -include_pwr_gnd {{{out}/source_from_odb.pg.v}}\nexit\n')
 with (out/'reexport.log').open('w') as log:subprocess.run([a.openroad,'-exit',str(script)],env=env,stdout=log,stderr=subprocess.STDOUT,check=True)
 assert sha(out/'routed_from_odb.v')==frozen['routed.v'];assert sha(out/'source_from_odb.pg.v')==frozen['source.pg.v']
 for name,h in frozen.items():assert sha(S/'candidate_v2_diodefree/results'/name)==h,name
 audit=json.loads((out/'integrity_audit.json').read_text());assert audit['status']=='PASS' and audit['proof_jobs_passed']==9
 result={'status':'PASS','proof_jobs':9,'negative_controls':5,'candidate_input_hashes_unchanged':True,'fresh_odb_exports_match':True,'scope':'Same frozen default-parameter digital equivalence and ODB/export identity; not new extracted LVS'}
 (out/'replay_summary.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2));print('Evidence:',out)
if __name__=='__main__':main()
