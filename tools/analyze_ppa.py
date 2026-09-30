#!/usr/bin/env python3
"""Recompute SAR16 area inventory and explicitly conditional comparison numbers."""
import collections
import hashlib
import json
import math
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parent
DESTINATION = REPO / 'build/ppa'


def register_inventory():
    lef = (REPO / 'evidence/rpt_v51/sar_digi_paper_core.lef').read_text()
    areas = {}
    for match in re.finditer(r'^MACRO\s+(\S+)\s*\n(.*?)^END\s+\1\s*$', lef, re.S | re.M):
        size = re.search(r'SIZE\s+([\d.]+)\s+BY\s+([\d.]+)\s*;', match[2])
        if size:
            areas[match[1]] = float(size[1]) * float(size[2])
    netlist = (REPO / 'evidence/rpt_v51/sar_digi_paper_core_pnr.v').read_text()
    modules = {}
    for match in re.finditer(r'^module\s+(\w+)\s*\((.*?)\bendmodule', netlist, re.S | re.M):
        modules[match[1]] = re.findall(r'^\s*(\w+)\s+(\\\S+|\w+)\s*\(', match[2], re.M)
    leaves = []

    def walk(module, path=''):
        for kind, name in modules[module]:
            instance_path = path + name.lstrip('\\')
            if kind in modules:
                walk(kind, instance_path + '/')
            else:
                if kind not in areas:
                    raise ValueError(f'Missing LEF geometry for {kind}')
                leaves.append({'type': kind, 'name': instance_path, 'area_um2': areas[kind]})

    walk('sar_digi_paper_core')
    total = sum(item['area_um2'] for item in leaves)
    if len(leaves) != 3626 or not math.isclose(total, 102300.1056, abs_tol=1e-6):
        raise ValueError(f'PNR report reconciliation failed: cells={len(leaves)} area={total}')
    dffs = [item for item in leaves if item['type'].startswith('DFF')]
    shadow = [item for item in dffs if 'shadow_weights_reg[' in item['name']]
    address = lambda item: int(re.search(r'shadow_weights_reg\[(\d+)\]', item['name'])[1])
    trusted = [item for item in shadow if address(item) <= 5]
    if (len(dffs), len(shadow), len(trusted)) != (1011, 600, 180):
        raise ValueError('Baseline register inventory changed; review the area opportunity claims')
    groups = {}
    for key in ('shadow_weights_reg', 'accumulator_reg', 'temp_acc_reg', 'meas_val_p_reg',
                'meas_val_n_reg', 'avg_rounded_r_reg', 'calc_result_r_reg', 'w_wr_data_reg',
                'raw_code_o_reg'):
        selected = [item for item in dffs if key in item['name']]
        groups[key] = {'dff_count': len(selected), 'leaf_area_um2': sum(x['area_um2'] for x in selected)}
    return {
        'scope': 'PNR logical netlist instances and delivered LEF dimensions; no implementation changed',
        'leaf_cells': len(leaves), 'sum_leaf_area_um2': total, 'dff_count': len(dffs),
        'shadow_by_address': dict(sorted(collections.Counter(address(x) for x in shadow).items())),
        'trusted_lsb_dffs': len(trusted),
        'trusted_lsb_dff_area_um2': sum(x['area_um2'] for x in trusted), 'register_groups': groups,
    }


def latency_results():
    text = (DESTINATION / 'latency_run.log').read_text(encoding='utf-8')
    pattern = (r'LATENCY_PASS case=(\d+) phase_ns=([\d.]+) samples=(\d+) '
               r'accepted_to_done_min_ns=([\d.]+) accepted_to_done_max_ns=([\d.]+) '
               r'last_to_done_min_ns=([\d.]+) last_to_done_max_ns=([\d.]+) first_to_last_ns=([\d.]+)')
    cases = [{
        'case': int(m[1]), 'phase_ns': float(m[2]), 'samples': int(m[3]),
        'accepted_to_done_min_ns': float(m[4]), 'accepted_to_done_max_ns': float(m[5]),
        'last_to_done_min_ns': float(m[6]), 'last_to_done_max_ns': float(m[7]),
        'first_to_last_ns': float(m[8]),
    } for m in re.finditer(pattern, text)]
    if (len(cases) != 12 or {x['case'] for x in cases} != set(range(12)) or
            any(x['samples'] != 100 or x['phase_ns'] != x['case']*.25 for x in cases)):
        raise ValueError('Incomplete phase/sustained throughput experiment')
    if any(x['accepted_to_done_min_ns'] != 120 or x['accepted_to_done_max_ns'] != 120 or
           x['first_to_last_ns'] != 63 for x in cases):
        raise ValueError('Baseline SRM latency changed; review the new result before updating the claims')
    if 'SRM_LATENCY_EXPERIMENT_PASS' not in text or 'LATENCY_FAIL' in text:
        raise ValueError('Failed latency experiment')
    early = re.search(r'EARLY_STREAM phase=([\d.]+) total=(\d+) ones=(\d+) shortfall=(\d+) stalled=(\d+) start_to_done_ns=([\d.]+)', text)
    if not early:
        raise ValueError('Missing early-stream probe')
    if tuple(int(early[i]) for i in (2, 4, 5)) != (20, 1, 1):
        raise ValueError('Early-stream counterexample changed')
    version = re.search(r'^SIMULATOR version=(.+)$', text, re.M)
    if not version:
        raise ValueError('Missing simulator version')
    return {'scope': 'two-state zero-delay standalone SRM; clk=10 ns dec_clk=3 ns',
            'simulator': version[1],
            'request_interval_ns': 200, 'stream_delay_after_accepted_start_ns': 12,
            'cases': sorted(cases, key=lambda x: x['case']),
            'early_stream_delay_ns': 0,
            'early_example': {'phase_ns': float(early[1]), 'total': int(early[2]),
                              'ones': int(early[3]), 'shortfall': int(early[4]),
                              'stalled': int(early[5]), 'done_latency_ns': float(early[6])},
            'excludes': ['full ADC throughput', 'metastability', 'SDF', 'analog settling/noise', 'physical timing closure']}


def comparison_numbers(inventory):
    # Paper values manually transcribed from the inspected original pages 819/821.
    # They are published values, not generated by this script or new EDA.
    power_total = 5.31
    paper_logic = power_total * .288
    paper_counter = power_total * .074
    area = inventory['sum_leaf_area_um2']
    pipeline = sum(inventory['register_groups'][key]['leaf_area_um2']
                   for key in ('avg_rounded_r_reg', 'calc_result_r_reg'))
    trusted = inventory['trusted_lsb_dff_area_um2']
    data = {
        'paper': {'doi': '10.1109/JSSC.2025.3526595', 'sample_rate_msps': 5.0,
                  'total_power_mw': power_total, 'active_area_mm2': .57, 'sndr_db': 93.7,
                  'low_frequency_enob_from_sndr': (93.7-1.76)/6.02,
                  'logic_power_from_figure15_mw': paper_logic,
                  'srm_counter_power_from_figure15_mw': paper_counter,
                  'logic_plus_srm_power_mw': paper_logic+paper_counter,
                  'lut_synthesis_area_um2': 484., 'lut_synthesis_power_uw': 4.7,
                  'srm_analog_window_ns': 70., 'sar_conversion_model_ns': 60.,
                  'schreier_from_sndr_db': 93.7+10*math.log10(2.5e6/(power_total*1e-3))},
        'baseline': {'dc_area_um2': 97892.625106, 'calibration_dc_area_um2': 88106.3564,
                     'srm_dc_area_um2': 8306.0208, 'lut_dc_area_um2': 831.6,
                     'pnr_area_um2': area, 'gds_die_area_um2': 430.52*429.34,
                     'dc_default_activity_power_mw': 2.546,
                     'calibration_default_activity_power_mw': 1.760,
                     'srm_default_activity_power_mw': .556},
        'conditional_estimates_not_new_ppa': {
            'lut_area_ratio_to_paper': 831.6/484,
            'digital_default_power_ratio_to_paper_logic_plus_srm': 2.546/(paper_logic+paper_counter),
            'die_fraction_of_paper_active_area': (430.52*429.34/1e6)/.57,
            'trusted_storage_gross_saving_fraction': trusted/area,
            'two_pipeline_registers_gross_saving_um2': pipeline,
            'combined_gross_saving_fraction': (trusted+pipeline)/area,
            'after_combined_gross_cell_area_um2': area-trusted-pipeline,
            'after_trusted_gross_cell_area_um2': area-trusted,
            'row_capacity_reduction_55_to_65_percent': 1-.5558/.65,
            'row_capacity_reduction_55_to_70_percent': 1-.5558/.70,
            'paper_like_average_measurement_lower_bound_us_14x64_at_5Msps': 14*64/5.,
        },
        'whole_chip_power_scenarios': []}
    for reduction in (.25,.50):
        remaining = power_total - (paper_logic+paper_counter)*reduction
        data['whole_chip_power_scenarios'].append({
            'assumption': 'same analog power, SNDR and bandwidth as paper; all Logic+SRM class power scaled',
            'digital_class_reduction_fraction': reduction, 'resulting_total_mw': remaining,
            'whole_chip_reduction_fraction': 1-remaining/power_total,
            'schreier_gain_db': 10*math.log10(power_total/remaining)})
    return data


def main():
    sources = ('evidence/rpt_v51/sar_digi_paper_core_pnr.v', 'evidence/rpt_v51/sar_digi_paper_core.lef',
               'evidence/rpt_v51/dc/area.rpt', 'evidence/rpt_v51/dc/power.rpt',
               'evidence/rtl_baseline/srm_residue_estimator.sv',
               'evidence/rtl_baseline/srm_residue_lut.sv',
               'evidence/rtl_baseline/sar_calib_ctrl_serial.sv',
               'evidence/rtl_baseline/sar_digi_paper_core.sv',
               'tests/tb_srm_latency.sv', 'tools/run_srm_latency.py', 'tools/analyze_ppa.py')
    manifest = {path: hashlib.sha256((REPO/path).read_bytes()).hexdigest() for path in sources}
    locked = json.loads((REPO/'docs/baseline_manifest.json').read_text(encoding='utf-8'))['sha256']
    for path, digest in manifest.items():
        if path.startswith('evidence/') and digest != locked[path]:
            raise ValueError(f'Historical input changed: {path}; published comparison constants no longer apply')
    inventory = register_inventory()
    latency = latency_results()
    numbers = comparison_numbers(inventory)
    for name, value in (('netlist_register_inventory.json', inventory),
                        ('latency_result.json', latency), ('ppa_comparison_numbers.json', numbers),
                        ('source_hashes.json', manifest)):
        (DESTINATION / name).write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print('PPA_ANALYSIS_PASS cells=3626 area_um2=102300.1056 shadow_dffs=600 trusted_dffs=180 phases=12 samples=1200')
    print(json.dumps(numbers['conditional_estimates_not_new_ppa'], indent=2))


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError) as error:
        print(f'PPA_ANALYSIS_FAIL: {error}', file=sys.stderr)
        sys.exit(1)
