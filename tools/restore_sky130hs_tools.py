#!/usr/bin/env python3
"""Restore pinned signoff dependencies and build official tools only on explicit request."""
import argparse,concurrent.futures,hashlib,json,subprocess
from pathlib import Path
B=Path(__file__).resolve().parents[1]/'repairs/sky130hs_20261006'
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--bundle-root',type=Path,required=True);p.add_argument('--install',action='store_true');a=p.parse_args()
 if not a.install:p.error('--install is required; this downloads packages and compiles official source')
 r=a.bundle_root.resolve()/'signoff_20261006/tools'
 for d in ('downloads','debian','logs','bin'):(r/d).mkdir(exist_ok=True)
 manifest=json.loads((r/'debian-download-manifest.json').read_text())
 def fetch(row):
  dest=r/'downloads'/row['file']
  if not dest.exists():subprocess.run(['curl','--fail','--location','--retry','2','--max-time','300',row['url'],'-o',str(dest)],check=True)
  if dest.stat().st_size!=row['bytes'] or hashlib.sha256(dest.read_bytes()).hexdigest()!=row['sha256']:raise RuntimeError('Pinned package mismatch: '+row['file'])
  return dest
 with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:files=list(pool.map(fetch,manifest))
 for f in files:subprocess.run(['dpkg-deb','-x',str(f),str(r/'debian')],check=True)
 for row in json.loads((r/'upstream-manifest.json').read_text()):
  src=r/(row['tool']+'-src');head=subprocess.check_output(['git','-C',str(src),'rev-parse','HEAD'],text=True).strip()
  if head!=row['commit']:raise RuntimeError('Unexpected upstream commit: '+str(src))
 for cmd in (['bash',str(r/'build_tools.sh')],['python3',str(r/'configure_wrappers.py')],['bash',str(r/'test_tools.sh')]):subprocess.run(cmd,check=True)
 print('Pinned signoff tools built; positive and negative installation smoke checks passed.')
if __name__=='__main__':main()
