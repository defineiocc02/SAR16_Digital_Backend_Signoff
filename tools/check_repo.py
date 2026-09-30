#!/usr/bin/env python3
"""Check the public evidence snapshot without running historical probes or EDA."""
import argparse
import ast
import hashlib
import json
from pathlib import Path
import re
from statistics import NormalDist
import subprocess
import sys
import tokenize

ROOT = Path(__file__).resolve().parents[1]
RPT = ROOT / 'evidence/rpt_v51'


def text(path):
    return path.read_text(encoding='utf-8-sig')


def required_matches(pattern, value, source):
    matches = re.findall(pattern, value, re.M)
    if not matches:
        raise ValueError(f'No report records matched in {source}')
    return matches


def table_entries(source, function):
    match = re.search(r'function\s+automatic.*?\b' + function +
                      r'\(.*?endfunction', source, re.S)
    if match is None:
        raise ValueError(f'Missing LUT function {function}')
    entries = required_matches(r"5'd(\d+)\s*:\s*" + function +
                               r"\s*=\s*(-?)16'sd(\d+)", match[0], function)
    result = {int(index): (-1 if sign else 1) * int(value)
              for index, sign, value in entries}
    if len(result) != len(entries):
        raise ValueError(f'Duplicate LUT addresses in {function}')
    return result


def check_lut():
    source = text(ROOT / 'evidence/rtl_baseline/srm_residue_lut.sv')
    half = table_entries(source, 'tbl_q8')
    full = table_entries(source, 'tbl_full_q8')
    # Independent normal inverse CDF, rather than the generator's approximation.
    expected = {k: max(-258, round(128 * NormalDist().inv_cdf((k + 0.5) / 23)))
                for k in range(12)}
    if half != expected:
        raise ValueError('Baked half LUT differs from the N=22, sigma=0.5 Q8 model')
    mirrored = {k: half[k] if k <= 11 else -half[22-k] for k in range(23)}
    if full != mirrored:
        raise ValueError('Full LUT differs from the folded half LUT')
    generated = subprocess.run([sys.executable, str(ROOT / 'tools/gen_srm_lut.py')],
                               capture_output=True, text=True, check=True, timeout=10)
    entries = required_matches(r"5'd(\d+)\s*:\s*tbl_q8\s*=\s*(-?)16'sd(\d+)",
                               generated.stdout, 'generator output')
    actual = {int(k): (-1 if sign else 1) * int(v) for k, sign, v in entries}
    if actual != half:
        raise ValueError('Reconstructed generator differs from the baked half LUT')
    return {'half_entries': len(half), 'full_entries': len(full),
            'model': 'P=(k+0.5)/23; sigma=0.5; Q8; endpoint clamp=-258',
            'range_q8': [min(full.values()), max(full.values())]}


def historical_status():
    env = dict(required_matches(r'^([\w.]+)=([^\n]+)$',
                                text(RPT / 'RESULT_CURRENT.env'), 'RESULT_CURRENT.env'))
    summary = text(RPT / 'sta/sta_pc_summary.txt')
    sta = {}
    for corner in ('typical', 'slow', 'fast'):
        rows = required_matches(r'^STA_RESULT corner=' + corner +
                                r' tag=pc (.*)$', summary, 'STA summary')
        if len(rows) != 1:
            raise ValueError(f'Expected one pc STA_RESULT for {corner}')
        fields = dict(re.findall(r'(\w+)=([\w.\-]+)', rows[0]))
        if int(fields['viol_hold']) != int(env[f'sta_{corner}_hold_viols']):
            raise ValueError(f'Hold count differs from locked summary for {corner}')
        if abs(float(fields['wns_hold']) - float(env[f'sta_{corner}_hold_wns'])) > 0.0001:
            raise ValueError(f'Hold slack differs from locked summary for {corner}')
        setup = required_matches(r'^STA_WORST_SETUP corner=' + corner +
                                 r' clock=clk slack=([\d.\-]+)', summary, 'STA setup summary')
        if len(setup) != 1 or abs(float(setup[0])-float(env[f'sta_{corner}_clk_slack'])) > 0.0001:
            raise ValueError(f'Setup slack differs from locked summary for {corner}')
        coverage_text = text(RPT / f'sta/sta_pc_{corner}_pc_coverage.rpt')
        coverage = {}
        for kind in ('setup', 'hold', 'recovery', 'removal', 'min_pulse_width'):
            values = required_matches(r'^' + kind + r'\s+(\d+)\s+\d+\s+\([^)]*\)'
                                      r'\s+\d+\s+\([^)]*\)\s+(\d+)\s+\(',
                                      coverage_text, f'{corner} coverage {kind}')
            coverage[kind] = {'total': int(values[0][0]), 'untested': int(values[0][1])}
        drc = text(RPT / f'sta/sta_pc_{corner}_pc_drc.rpt')
        sections = re.split(r'^\s*(max_\w+)\s*$', drc, flags=re.M)
        electrical = {sections[i]: sections[i+1].count('(VIOLATED)')
                      for i in range(1, len(sections), 2)}
        sta[corner] = {**fields, 'clk_setup_slack_ns': float(setup[0]),
                       'coverage': coverage, 'electrical_violations': electrical}
    hold_total = sum(int(row['viol_hold']) for row in sta.values())
    if hold_total != int(env['sta_hold_viols_total']):
        raise ValueError('Hold total differs from RESULT_CURRENT.env')
    drc_text = text(RPT / 'drc_CAL.SUM')
    drc_rows = required_matches(r'^RULECHECK\s+(\S+)\s+\.*\s*TOTAL Result Count\s*='
                               r'\s*(\d+)\s*\(\s*(\d+)\s*\)', drc_text, 'DRC summary')
    first = sum(int(a) for _, a, _ in drc_rows)
    second = sum(int(b) for _, _, b in drc_rows)
    if len(drc_rows) != int(env['drc_rulechecks']) or second != int(env['drc_results']):
        raise ValueError('DRC rule count/parenthesized count differs from locked summary')
    lvs = text(RPT / 'lvs.rep')
    verdict = required_matches(r'^\s*(INCORRECT|CORRECT)\s+sar_digi_paper_core\s+', lvs, 'LVS verdict')
    if len(set(verdict)) != 1 or verdict[0] != env['lvs_verdict']:
        raise ValueError('LVS verdict differs from RESULT_CURRENT.env')
    pg = text(RPT / 'pnr/fc_pg.rpt')
    floating = required_matches(r'Number of floating std cells:\s*(\d+)', pg, 'PG report')
    if len(floating) != 2:
        raise ValueError('Expected two PG net sections')
    routes = text(RPT / 'pnr/fc_check_routes.rpt')
    route_drc = required_matches(r'Total number of DRCs = (\d+)', routes, 'route report')
    return {'signoff_status': 'NOT_CLOSED', 'sta': sta, 'hold_corner_sum': hold_total,
            'drc': {'rulechecks': len(drc_rows), 'column_1': first, 'parenthesized_column': second,
                    'truncated_rules': re.findall(r'Maximum result count of \d+ exceeded in DRC RuleCheck (\S+)\.', drc_text)},
            'lvs': verdict[0], 'pre_optimization_pg_floating_std_cells': dict(zip(('VDD', 'VSS'), map(int, floating))),
            'fc_route_drc': int(route_drc[0]),
            'note': 'Historical report parsing, not a new EDA run or final PG proof.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    manifest = json.loads(text(ROOT / 'docs/baseline_manifest.json'))
    for relative, expected in manifest['sha256'].items():
        digest = hashlib.sha256((ROOT / relative).read_bytes()).hexdigest()
        if digest != expected:
            raise ValueError(f'Historical evidence changed: {relative}')
    py_files = (sorted((ROOT / 'tools').glob('*.py')) +
                sorted((ROOT / 'probes').glob('*.py')) + [ROOT / 'organize_scratch.py'])
    for path in py_files:
        with tokenize.open(path) as stream:
            ast.parse(stream.read(), filename=str(path.relative_to(ROOT)))
    sh_files = sorted((ROOT / 'tools').glob('*.sh')) + sorted((ROOT / 'probes').glob('*.sh'))
    for path in sh_files:
        subprocess.run(['bash', '-n', str(path)], check=True, capture_output=True, text=True, timeout=10)
    status = historical_status()
    result = {'repository_checks': 'PASS', 'baseline_commit': manifest['baseline_commit'],
              'immutable_evidence_files': len(manifest['sha256']),
              'python_syntax_files': len(py_files), 'shell_syntax_files': len(sh_files),
              'lut': check_lut(), 'historical_signoff': status}
    if args.output:
        destination = args.output if args.output.is_absolute() else ROOT / args.output
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f"REPOSITORY_CHECK_PASS evidence={len(manifest['sha256'])} python={len(py_files)} shell={len(sh_files)} lut=12/23")
    print('HISTORICAL_SIGNOFF_NOT_CLOSED: LVS=INCORRECT, hold=29, DRC=2956/3402 (truncated), route_DRC=440')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, SyntaxError, subprocess.SubprocessError) as error:
        print(f'REPOSITORY_CHECK_FAIL: {error}', file=sys.stderr)
        sys.exit(1)
