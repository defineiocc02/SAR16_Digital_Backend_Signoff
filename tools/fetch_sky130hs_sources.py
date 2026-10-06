#!/usr/bin/env python3
"""Fetch pinned public source inputs omitted from Git; no tools are built or installed."""
import argparse,gzip,hashlib,json,subprocess,tarfile,tempfile,shutil
from pathlib import Path
B=Path(__file__).resolve().parents[1]/'repairs/sky130hs_20261006';S=B/'signoff_20261006'
def run(*cmd):subprocess.run(list(map(str,cmd)),check=True)
def checkout(url,commit,dest):
 if dest.exists():
  actual=subprocess.check_output(['git','-C',str(dest),'rev-parse','HEAD'],text=True).strip()
  if actual!=commit or subprocess.check_output(['git','-C',str(dest),'status','--porcelain'],text=True).strip():raise RuntimeError('Existing source tree differs: '+str(dest))
  return
 dest.parent.mkdir(parents=True,exist_ok=True);run('git','init',dest);run('git','-C',dest,'remote','add','origin',url);run('git','-C',dest,'fetch','--depth=1','origin',commit);run('git','-C',dest,'checkout','--detach',commit)
def main():
 global B,S
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--bundle-root',type=Path,default=B);p.add_argument('--fetch',action='store_true',help='Explicitly fetch the pinned official sources');a=p.parse_args()
 B=a.bundle_root.resolve();S=B/'signoff_20261006'
 if not a.fetch:p.error('Use --fetch to download official source inputs; see README before building')
 pd=S/'pdk';src=pd/'src';src.mkdir(exist_ok=True)
 sources=json.loads((pd/'source_manifest.json').read_text())['official_sources'];op=sources[0]
 dest=src/('open-pdks-'+op['commit'])
 if not dest.exists():
  with tempfile.TemporaryDirectory() as td:
   archive=Path(td)/'source.tar.gz';run('curl','--fail','--location','--retry','2',op['url'],'-o',archive)
   if hashlib.sha256(archive.read_bytes()).hexdigest()!=op['archive_sha256']:raise RuntimeError('Open-PDKs source archive hash mismatch')
   with tarfile.open(archive) as t:
    members=t.getmembers()
    if any(m.issym() or m.islnk() for m in members):
     # Python data filter permits safe source-tree links and rejects path escapes.
     pass
    t.extractall(Path(td)/'unpacked',filter='data')
   roots=list((Path(td)/'unpacked').iterdir());assert len(roots)==1;shutil.move(str(roots[0]),dest)
 selected=json.loads((pd/'geometry_matched_reference_manifest.json').read_text())
 checkout('https://github.com/fossi-foundation/skywater-pdk-libs-sky130_fd_sc_hs.git',selected['commit'],src/'sky130_fd_sc_hs-verified-968e0c3')
 for entry in selected['verified_source_files']:
  f=src/'sky130_fd_sc_hs-verified-968e0c3'/entry['path'];assert hashlib.sha256(f.read_bytes()).hexdigest()==entry['sha256'],f
 for entry in json.loads((S/'tools/upstream-manifest.json').read_text()):
  dest=S/'tools'/(entry['tool']+'-src');checkout(entry['upstream'],entry['commit'],dest)
  data=subprocess.check_output(['git','-C',str(dest),'archive','HEAD'])
  # Match the recorded `git archive HEAD | gzip -n` bytes using the system gzip.
  packed=subprocess.run(['gzip','-n'],input=data,stdout=subprocess.PIPE,check=True).stdout
  assert hashlib.sha256(packed).hexdigest()==entry['sha256'],entry['tool']
  target=S/'tools'/entry['archive'];target.parent.mkdir(exist_ok=True);target.write_bytes(packed)
 run('bash',pd/'build_tech.sh');run('python3',pd/'build_reference.py')
 print('Pinned PDK and tool source inputs verified. No binaries were installed; see tools/INSTALL_REPORT.md for builds.')
if __name__=='__main__':main()
