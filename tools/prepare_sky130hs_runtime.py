#!/usr/bin/env python3
"""Copy verified frozen inputs to a new runtime location and change path references only."""
import argparse,hashlib,json,shutil,subprocess,sys
from pathlib import Path
R=Path(__file__).resolve().parents[1];B=R/'repairs/sky130hs_20261006'
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',type=Path,required=True);a=p.parse_args();out=a.output.resolve()
 if out.exists():p.error('Output must not exist; frozen inputs are never overwritten')
 subprocess.run([sys.executable,str(R/'tools/check_sky130hs_publication.py')],check=True)
 shutil.copytree(B,out)
 old='/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006';s=out/'signoff_20261006';records=[]
 for f in (s/'inputs/sky130hs.absolute.lyt',s/'equivalence_candidate_v2_diodefree/config.json',s/'equivalence_candidate_v2_diodefree/identity/reexport.tcl'):
  before=f.read_text();after=before.replace(old,str(out));shutil.copy2(f,f.with_suffix(f.suffix+'.archive_original'));f.write_text(after)
  records.append({'path':str(f.relative_to(out)),'before_sha256':hashlib.sha256(before.encode()).hexdigest(),'after_sha256':hashlib.sha256(after.encode()).hexdigest(),'only_path_prefix_replaced':True})
 (out/'runtime_relocation.json').write_text(json.dumps(records,indent=2)+'\n')
 print('Prepared runtime copy:',out)
 print('The archived manifest applies to original files; .archive_original retains each relocated config byte-for-byte.')
if __name__=='__main__':main()
