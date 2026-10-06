"""Independent result-integrity and exhaustive coverage audit; changes no proof logic."""
from pathlib import Path
import os, json, hashlib, re
out = Path(os.environ['EQ_OUT'])
load = lambda p: json.loads(p.read_text())
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
manifest = load(out / 'source_manifest.json')
suite = load(out / 'results/suite_results.json')
summary = load(out / 'results/summary.json')
expected_pairs = ['rtl_to_sky130hs_mapped']
if 'sky130hs_routed' in manifest['config']['netlists']:
    expected_pairs.append('sky130hs_mapped_to_sky130hs_routed')
negative = {'negative_output_invert', 'negative_data_invert', 'negative_clock_invert', 'negative_reset_invert', 'negative_fsm_next_invert'}
expected_jobs = negative | {name for pair in expected_pairs for name in (pair, pair + '_reset')}
assert set(suite) == expected_jobs, (set(suite), expected_jobs)
assert {x['comparison'] for x in summary['proofs']} == set(expected_pairs)
assert all(x['result'] == 'PASS' for x in summary['proofs'])
assert {p.stem[:-len('_coverage')] for p in (out/'results').glob('*_coverage.json')} == set(expected_pairs)
for label, result in suite.items():
    assert result['status'] == 'PASS' and result['exit_code'] == 0, (label, result)
    assert result['expected_counterexample'] == (label in negative)
    script = out / 'scripts' / (label + '.ys')
    log = out / result['log']
    assert sha(script) == result['script_sha256'], label
    assert sha(log) == result['log_sha256'], label
    expected_token = 'SAT proof finished - model found: FAIL!' if label in negative else 'SAT proof finished - no model found: SUCCESS!'
    assert expected_token in log.read_text(), label
    if label in negative:
        for ext in ('json','vcd'):
            assert (out/'results'/f'{label}_cex.{ext}').stat().st_size > 0
for p, expected in manifest['source_sha256'].items():
    assert sha(Path(p)) == expected, p
for p, expected in manifest['model_sha256'].items():
    assert sha(out / p) == expected, p
coverage = {}
for pair in expected_pairs:
    cov = load(out/'results'/f'{pair}_coverage.json')
    gold = load(out/'results'/f'{cov["gold"]}.json')['modules']['sar_digi_paper_core']
    gate = load(out/'results'/f'{cov["gate"]}.json')['modules']['sar_digi_paper_core']
    outputs = {name: len(p['bits']) for name,p in gold['ports'].items() if p['direction']=='output'}
    expected_names = {f'output {name}[{i}]' for name,width in outputs.items() for i in range(width)}
    actual_names = [p['name'] for p in cov['proof_obligations'] if p['name'].startswith('output ')]
    assert set(actual_names) == expected_names and len(actual_names) == len(expected_names)
    assert len(outputs) == 20 and sum(outputs.values()) == cov['output_bits'] == 146
    assert len(cov['state_mapping']) == cov['gate_state_bits'] == 846
    gold_regs = [c for c in gold['cells'].values() if c['type'].startswith('$_DFF_')]
    gate_regs = [c for c in gate['cells'].values() if c['type'].startswith('$_DFF_')]
    assert len(gold_regs) == cov['gold_state_bits']
    assert len(gate_regs) == cov['gate_state_bits']
    assert {m['gate_index'] for m in cov['state_mapping']} == set(range(846))
    expected_obligations = 2689 if cov['gold'] == 'rtl' else 2684
    assert len(cov['proof_obligations']) == expected_obligations
    assert len({p['index'] for p in cov['proof_obligations']}) == expected_obligations
    assert all(summary['output_coverage'][pair][name] == {'bits':width,'status':'PASS'} for name,width in outputs.items())
    coverage[pair] = {'state_mapping_complete':True,'output_ports':20,'output_bits':146,'inductive_obligations':expected_obligations}
for label, audit in summary['functional_cell_audit'].items():
    assert audit['unsupported_functional_cells'] == 0 and audit['x_z_connections'] == 0
assert set(summary['functional_cell_audit']) == set(manifest['config']['netlists'])
report = {'status':'PASS','expected_proof_jobs':len(expected_jobs),'proof_jobs_passed':len(suite),'negative_controls_with_json_and_vcd_witnesses':len(negative),'coverage':coverage,'source_hashes_rechecked':len(manifest['source_sha256']),'model_hashes_rechecked':len(manifest['model_sha256']),'summary_sha256':sha(out/'results/summary.json'),'source_manifest_sha256':sha(out/'source_manifest.json'),'suite_results_sha256':sha(out/'results/suite_results.json')}
(out/'integrity_audit.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
