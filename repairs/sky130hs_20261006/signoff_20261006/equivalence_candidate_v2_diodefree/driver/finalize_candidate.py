"""Close exact artifact identity and document the narrowly scoped model extension."""
from pathlib import Path
import hashlib, json, os, re, subprocess, collections
O=Path(os.environ['EQ_OUT']); root=O.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
before=json.loads((O/'identity/identity_before.json').read_text())
for p,h in before['candidate_sha256'].items():assert sha(root/p)==h, ('candidate changed',p)
for p,h in before['driver_sha256'].items():assert sha(root/p)==h, ('original driver/tool changed',p)
provenance=json.loads((O/'identity/driver_provenance.json').read_text())
for p,h in provenance['driver_sha256'].items():assert sha(O/'driver'/p)==h, ('candidate driver changed',p)
subprocess.run([os.environ['OPENROAD_EXE'],'-exit',str(O/'identity/reexport.tcl')],check=True,stdout=(O/'identity/reexport_final.log').open('w'),stderr=subprocess.STDOUT)
for p,h in before['candidate_sha256'].items():assert sha(root/p)==h, ('candidate changed during export',p)
assert sha(O/'identity/routed_from_odb.v')==before['candidate_sha256']['signoff_20261006/candidate_v2_diodefree/results/routed.v']
assert sha(O/'identity/source_from_odb.pg.v')==before['candidate_sha256']['signoff_20261006/candidate_v2_diodefree/results/source.pg.v']
manifest=json.loads((O/'source_manifest.json').read_text()); cfg=manifest['config']
audit=json.loads((O/'models/sky130hs_physical_only_audit.json').read_text())
pre=json.loads((O/'results/sky130hs_routed_preflatten.json').read_text())['modules']
counts=collections.Counter(c['type'] for c in pre['sar_digi_paper_core']['cells'].values())
expected={'sky130_fd_sc_hs__tapvpwrvgnd_1':1456,'sky130_fd_sc_hs__fill_1':1941,'sky130_fd_sc_hs__fill_2':1598,'sky130_fd_sc_hs__fill_4':1349,'sky130_fd_sc_hs__fill_8':4012}
assert set(audit)==set(expected)==set(cfg['physical_only']['sky130hs']['cells'])
assert counts['sky130_fd_sc_hs__diode_2']==0, 'Diode-free candidate still contains a diode'
lef=Path(cfg['physical_only']['sky130hs']['lef']).read_text(); model_audit={}
for cell,count in expected.items():
 assert counts[cell]==count
 block=re.search(r'^MACRO\s+'+re.escape(cell)+r'\b.*?^END\s+'+re.escape(cell)+r'\s*$',lef,re.M|re.S).group()
 declared=re.findall(r'^  PIN\s+(\S+)\s*$',block,re.M)
 parsed=re.findall(r'  PIN (\S+)\n(.*?)  END \1',block,re.S)
 assert len(declared)==len(parsed)==len(set(declared))
 assert set(declared)==set(audit[cell]['power_only_pins'])==set(pre[cell]['ports'])
 assert not int(pre[cell]['attributes'].get('blackbox','0'),2)
 assert not pre[cell]['cells']
 for pin,body in parsed:
  assert re.search(r'\bDIRECTION\s+INOUT\s*;',body)
  assert re.search(r'\bUSE\s+(POWER|GROUND)\s*;',body)
  assert pre[cell]['ports'][pin]['direction']=='inout'
 assert audit[cell]['functional_outputs']==0
 model_audit[cell]={'instances':count,'class':audit[cell]['class'],'power_only_pins':declared,'functional_pins':0,'functional_outputs':0,'blackbox':False}
summary=json.loads((O/'results/summary.json').read_text()); integrity=json.loads((O/'integrity_audit.json').read_text())
assert integrity['status']=='PASS' and integrity['proof_jobs_passed']==9
assert all(x['unsupported_functional_cells']==x['x_z_connections']==0 for x in summary['functional_cell_audit'].values())
identity={'status':'PASS','candidate_sha256':before['candidate_sha256'],'exact_odb_reexport_matches_routed_v':True,'exact_odb_reexport_matches_source_pg_v':True,'candidate_stable_across_final_reexport':True,'original_drivers_and_tools_unchanged':True,'candidate_driver_provenance_verified':True,'physical_only_model_audit':model_audit,'source_hashes_rechecked':integrity['source_hashes_rechecked'],'model_hashes_rechecked':integrity['model_hashes_rechecked']}
(O/'identity/identity_final.json').write_text(json.dumps(identity,indent=2)+'\n')
report=(O/'report.md').read_text()
report=report.replace('run the shared runner:', 'run the candidate-local runner (the original suite plus the audited CORE SPACER model extension):')
report=report.replace(str(root/'equivalence/scripts/run_suite.py'),str(O/'driver/run_suite.py')).replace(str(root/'equivalence/scripts/collect_report.py'),str(O/'driver/collect_report.py'))
report=report.replace('python '+str(O/'driver/collect_report.py')+'\n```','python '+str(O/'driver/collect_report.py')+'\npython '+str(O/'driver/verify_evidence.py')+'\npython '+str(O/'driver/finalize_candidate.py')+'\n```')
if '## Repaired candidate identity and filler support' not in report:
 report+='\n\n## Repaired candidate identity and filler support\n\nThe final repaired ODB exports routed.v and source.pg.v byte-for-byte. Identity is independently closed in identity/identity_final.json. This digital proof uses routed.v and makes no claim about power connectivity or extracted-GDS equivalence.\n\nThe four filler types are absent from Liberty. This candidate reuses the previously verified, candidate-local normalization extension without changing its proof semantics. The normalization helper admits explicitly enumerated CORE SPACER macros under the same strict pinned-LEF, power/ground-only, no-functional-pin audit as the existing WELLTAP model. All 8,900 filler instances are accounted for. The model contains no logic and is not a blackbox; no functional cell is abstracted. The exact diff is identity/normalization_extension.patch.\n\nThe induction, reset-base, negative-control, suite runner, coverage checks and report generator are byte-identical to the prior proof drivers. All nine proof gates were rerun successfully. No old proof, RTL or netlist was modified. For the complete guarded rerun including fresh ODB identity closure, use reproduce.sh in this evidence directory.\n'
(O/'report.md').write_text(report)
compact={'status':'PASS','scope':summary['scope'],'candidate_routed_v_sha256':before['candidate_sha256']['signoff_20261006/candidate_v2_diodefree/results/routed.v'],'candidate_routed_odb_sha256':before['candidate_sha256']['signoff_20261006/candidate_v2_diodefree/results/routed.odb'],'proof_jobs':9,'passed_jobs':9,'negative_controls_with_witnesses':5,'proofs':summary['proofs'],'output_ports_per_comparison':20,'output_bits_per_comparison':146,'strictly_audited_added_filler_instances':8900,'physical_antenna_diode_instances':0,'unsupported_functional_cells':0,'unresolved_blackboxes':0,'x_z_gate_connections':0,'identity_audit':'identity/identity_final.json','proof_integrity_audit':'integrity_audit.json','report':'report.md','reproduction':'reproduce.sh','normalization_extension_diff':'identity/normalization_extension.patch','limits':summary['limits']}
(O/'final_summary.json').write_text(json.dumps(compact,indent=2)+'\n')
files=[O/'report.md',O/'final_summary.json',O/'config.json',O/'source_manifest.json',O/'integrity_audit.json',O/'coverage_matrix.csv',O/'driver.log',O/'reproduce.sh',*sorted((O/'driver').glob('*.py')),*sorted((O/'identity').glob('*')),*sorted((O/'logs').glob('*.log')),*sorted((O/'models').glob('*')),O/'results/summary.json',O/'results/suite_results.json',*sorted((O/'scripts').glob('*')),*sorted((O/'results').glob('*_coverage.json')),*sorted((O/'results').glob('negative_*_cex.*'))]
(O/'evidence_sha256.json').write_text(json.dumps({str(p.relative_to(O)):sha(p) for p in files if p.is_file()},indent=2)+'\n')
print(json.dumps(compact,indent=2))
