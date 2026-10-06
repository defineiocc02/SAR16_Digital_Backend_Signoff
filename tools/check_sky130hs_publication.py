#!/usr/bin/env python3
"""Check frozen publication integrity and recorded evidence; no EDA pass is synthesized."""
import argparse, ast, hashlib, json, re, subprocess, sys, tarfile
from pathlib import Path
import xml.etree.ElementTree as ET
REPO=Path(__file__).resolve().parents[1]
BASE=REPO/'repairs/sky130hs_20261006'
def digest(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def read(p): return json.loads(p.read_text())
def verify_manifest(root, manifest):
    for name, entry in manifest.items():
        p=root/name
        if Path(name).is_absolute() or '..' in Path(name).parts or p.is_symlink():
            raise ValueError('Unsafe publication path: '+name)
        if not p.is_file() or p.stat().st_size!=entry['bytes'] or digest(p)!=entry['sha256']:
            raise ValueError('Missing or changed frozen payload: '+name)
    return len(manifest)
def normalized_gds(p):
    data=bytearray(p.read_bytes()); off=0
    while off<len(data):
        n=int.from_bytes(data[off:off+2],'big')
        if n<4 or off+n>len(data):raise ValueError('Malformed GDS record')
        if data[off+2] in (1,5):data[off+4:off+n]=b'\0'*(n-4)
        off+=n
    return hashlib.sha256(data).hexdigest()
def check(base=BASE):
    manifest=read(base/'publication_manifest.json'); count=verify_manifest(base,manifest['files'])
    s=base/'signoff_20261006'; c=s/'candidate_v2_diodefree'; q=s/'verification/candidate_v2_diodefree'; eq=s/'equivalence_candidate_v2_diodefree'
    summary=read(s/'signoff_summary.json')
    assert summary['status']=='PASS_ALL_EXECUTED_OPEN_SOURCE_GATES'
    assert summary['selected_candidate']=='candidate_v2_diodefree' and summary['waivers']==[]
    for n,h in read(c/'reports/frozen_input_hashes.json').items():assert digest(c/'results'/n)==h, n
    assert read(c/'reports/invariance_audit.json')['status']=='PASS'
    ant=read(c/'reports/antenna_model_integrity.json');assert ant['status']=='PASS' and ant['candidate']['diode_instance_count']==0 and ant['all_master_gate_diffusion_antenna_models_identical']
    assert (q/'reports/magic_drc_full.rpt').read_text().strip()=='RAW_RECTANGLE_COUNT 0'
    assert len(ET.parse(q/'reports/klayout_beol.lyrdb').findall('.//item'))==0
    assert 'Final result: Circuits match uniquely.' in (q/'reports/netgen_lvs.out').read_text()
    lvs=read(q/'reports/netgen_lvs.json')
    for record in lvs:
        for key in ('badnets','badelements','properties'):
            assert not record.get(key), (key,record.get('name'))
    top=[r for r in lvs if r.get('name')==['sar_digi_paper_core']*2];assert len(top)==1 and top[0]['nets']==[4335,4335]
    binding=read(q/'reports/final_gds_binding.json')
    assert digest(q/'results/baseline.gds')==binding['independent_verification_gds_sha256']
    assert normalized_gds(q/'results/baseline.gds')==normalized_gds(c/'results/candidate.gds')
    ef=read(eq/'final_summary.json');assert ef['status']=='PASS' and ef['passed_jobs']==9 and ef['negative_controls_with_witnesses']==5
    for name,h in read(eq/'evidence_sha256.json').items():assert digest(eq/name)==h,name
    jobs=read(eq/'results/suite_results.json');assert len(jobs)==9
    for name,j in jobs.items():
        log=eq/j['log'];assert j['status']=='PASS' and digest(log)==j['log_sha256']
        token='SAT proof finished - model found: FAIL!' if j['expected_counterexample'] else 'SAT proof finished - no model found: SUCCESS!'
        assert token in log.read_text(),name
        if j['expected_counterexample']:
            for suffix in ('json','vcd'):assert (eq/'results'/f'{name}_cex.{suffix}').stat().st_size>0
    syntax={'python':0,'bash':0}
    for p in base.rglob('*'):
        if not p.is_file():continue
        if p.suffix=='.py':ast.parse(p.read_text(),filename=str(p));syntax['python']+=1
        if p.suffix=='.sh':subprocess.run(['bash','-n',str(p)],check=True);syntax['bash']+=1
    result={'status':'PASS','scope':'Frozen payload integrity, recorded DRC/LVS/formal evidence consistency and script syntax; not a new EDA run','payload_files':count,'formal_jobs':9,'syntax':syntax,'candidate':summary['selected_candidate'],'routed_verilog_sha256':ef['candidate_routed_v_sha256']}
    return result
if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--output',type=Path);args=parser.parse_args()
    try:
        result=check();text=json.dumps(result,indent=2)+'\n';print(text,end='')
        if args.output:args.output.parent.mkdir(parents=True,exist_ok=True);args.output.write_text(text)
    except (AssertionError,OSError,ValueError,subprocess.SubprocessError) as e:
        print('PUBLICATION_CHECK_FAIL:',e,file=sys.stderr);sys.exit(1)
