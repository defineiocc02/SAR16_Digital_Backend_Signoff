#!/usr/bin/env python3
"""Inventory the delivered PNR netlist against LEF; never launches synthesis.

Classification reports library primitive families, not inferred RTL operators.
No liberty timing model or Boolean equivalence is inferred from LEF dimensions.
"""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
import math
from pathlib import Path
import re


def family(kind, ports):
    """Use narrow standard-cell families, cross-checked with named pin sets."""
    if kind.startswith('DFF') and {'D', 'CK'} <= ports:
        return 'dff'
    if kind.startswith('TLAT') and {'D', 'GN', 'Q'} <= ports:
        return 'latch'
    if kind.startswith(('CLKBUF', 'BUF')) and {'A', 'Y'} <= ports:
        return 'buffer'
    if kind.startswith(('CLKINV', 'INV')) and {'A', 'Y'} <= ports:
        return 'inverter'
    if kind.startswith(('ADDF', 'ADDH')) and {'A', 'B', 'CO', 'S'} <= ports:
        return 'adder_primitive'
    if kind.startswith(('MX2', 'MX4', 'MXI2', 'MXI4')) and 'S0' in ports:
        return 'mux_primitive'
    return 'other_combinational'


def summarize(items):
    return {'count': len(items), 'area_um2': round(sum(x['area_um2'] for x in items), 9)}


def inventory(repo):
    netfile = repo / 'evidence/rpt_v51/sar_digi_paper_core_pnr.v'
    leffile = repo / 'evidence/rpt_v51/sar_digi_paper_core.lef'
    netlist = netfile.read_text(encoding='utf-8')
    lef = leffile.read_text(encoding='utf-8')
    areas = {}
    for m in re.finditer(r'^MACRO\s+(\S+)\s*\n(.*?)^END\s+\1\s*$', lef, re.M | re.S):
        size = re.search(r'SIZE\s+([\d.]+)\s+BY\s+([\d.]+)\s*;', m[2])
        if size:
            areas[m[1]] = float(size[1]) * float(size[2])
    modules = {}
    module_lines = {}
    for m in re.finditer(r'^module\s+(\w+)\s*\((.*?)\bendmodule', netlist, re.M | re.S):
        instances = []
        for inst in re.finditer(r'^\s*(\w+)\s+(\\\S+|\w+)\s*\((.*?)\)\s*;', m[2], re.M | re.S):
            pins = {p[1]: ' '.join(p[2].split()).replace('\\', '')
                    for p in re.finditer(r'\.(\w+)\s*\(([^()]*)\)', inst[3])}
            line = netlist[:m.start(2) + inst.start()].count('\n') + 1
            instances.append({'type': inst[1], 'name': inst[2].lstrip('\\'),
                              'pins': pins, 'source_line': line})
        modules[m[1]] = instances
        module_lines[m[1]] = netlist[:m.start()].count('\n') + 1
    leaves = []
    gates = []

    def resolve(net, path, bindings):
        if net in bindings:
            return bindings[net]
        if re.fullmatch(r"\d+'[bdh][0-9xza-f]+", net):
            return net
        # The clock/reset connections below are scalar. Bus pins not used for
        # fanout tracing retain an expression label when concatenated at a port.
        indexed = re.fullmatch(r'(\w+)\[(\d+)\]', net)
        if indexed and indexed[1] in bindings:
            value = bindings[indexed[1]]
            if value.startswith('{'):
                return f'{value}[{indexed[2]}]'
            return value + '[' + indexed[2] + ']'
        return path + net

    def walk(module, path='', bindings=None):
        bindings = bindings or {}
        for inst in modules[module]:
            item = dict(inst)
            item['name'] = path + inst['name']
            item['pins'] = {p: resolve(n, path, bindings) for p, n in inst['pins'].items()}
            kind = inst['type']
            if kind in modules:
                if kind.startswith('SNPS_CLOCK_GATE_HIGH_'):
                    gates.append({'name': item['name'], 'module': kind, 'pins': item['pins'],
                                  'source_line': item['source_line']})
                walk(kind, item['name'] + '/', item['pins'])
            else:
                if kind not in areas:
                    raise ValueError('Missing LEF macro for ' + kind)
                item['area_um2'] = areas[kind]
                item['family'] = family(kind, set(item['pins']))
                leaves.append(item)

    walk('sar_digi_paper_core')
    if len(leaves) != 3626 or not math.isclose(sum(x['area_um2'] for x in leaves), 102300.1056, abs_tol=1e-6):
        raise ValueError('Historical PNR area/cell count reconciliation failed')
    hierarchy = defaultdict(list)
    classes = defaultdict(list)
    cell_types = defaultdict(list)
    for x in leaves:
        hierarchy[x['name'].split('/')[0] if '/' in x['name'] else '(top direct)'].append(x)
        classes[x['family']].append(x)
        cell_types[x['type']].append(x)
    dffs = classes['dff']
    reggroups = defaultdict(list)
    for x in dffs:
        prefix = x['name'].rsplit('/', 1)[0] if '/' in x['name'] else '(top direct)'
        basename = x['name'].rsplit('/', 1)[-1]
        group = re.sub(r'\[.*', '', basename)
        reggroups[prefix + '/' + group].append(x)
    perhier = {}
    for h, items in sorted(hierarchy.items()):
        perhier[h] = {'total': summarize(items), 'families': {
            f: summarize([x for x in items if x['family'] == f]) for f in sorted(classes)}}
    shadow = [x for x in dffs if '/shadow_weights_reg[' in x['name']]
    shadow_addresses = defaultdict(list)
    for x in shadow:
        address = int(re.search(r'shadow_weights_reg\[(\d+)\]', x['name'])[1])
        shadow_addresses[address].append(x)
    reference = [x for address in range(6) for x in shadow_addresses[address]]
    if len(reference) != 180 or len(shadow) != 600:
        raise ValueError('Shadow inventory no longer matches immutable baseline')
    gate_items = [x for x in leaves if '/clk_gate_' in x['name']]
    trusted_gates = [x for x in gate_items if re.search(r'/clk_gate_shadow_weights_reg\[[0-5]\]/', x['name'])]
    refclock = Counter(x['pins']['CK'] for x in reference)
    refreset = Counter(x['pins'].get('RN', x['pins'].get('SN', '(none)')) for x in reference)
    allclock = Counter(x['pins']['CK'] for x in dffs)
    allreset = Counter(x['pins'].get('RN', x['pins'].get('SN', '(none)')) for x in dffs)
    leafbyname = {x['name']: x for x in leaves}
    traced_gates = []
    for g in gates:
        contents = [x for name, x in leafbyname.items() if name.startswith(g['name'] + '/')]
        loads = [x for x in dffs if x['pins']['CK'] == g['pins']['ENCLK']]
        traced_gates.append({**g, 'contents': summarize(contents), 'direct_dff_clock_loads': len(loads)})
    # Clock trees can sit between a gate's output and DFF CK. Trace only BUF/INV
    # primitives, which have one input A and one output Y; retain inversion info.
    forwarding = defaultdict(list)
    for x in leaves:
        if x['family'] in ('buffer', 'inverter'):
            forwarding[x['pins']['A']].append(x)

    def downstream(start, sink_pin, through_clock_gates=False):
        nets = {start}
        queue = [start]
        buffers = []
        while queue:
            n = queue.pop()
            for x in forwarding[n]:
                target = x['pins']['Y']
                if target not in nets:
                    nets.add(target)
                    queue.append(target)
                    buffers.append(x)
            if through_clock_gates:
                for gate in gates:
                    if gate['pins']['CLK'] == n and gate['pins']['ENCLK'] not in nets:
                        nets.add(gate['pins']['ENCLK'])
                        queue.append(gate['pins']['ENCLK'])
        sinks = [x for x in dffs if x['pins'].get(sink_pin) in nets]
        return {'dff_sinks': len(sinks), 'buffer_inverter_tree': summarize(buffers),
                'leaf_sink_nets': len(set(x['pins'].get(sink_pin) for x in sinks))}

    for g in traced_gates:
        g['clock_tree_loads'] = downstream(g['pins']['ENCLK'], 'CK')
    reset_sn = downstream('rst_n', 'SN')
    reset_rn = downstream('rst_n', 'RN')
    clocks = {name: downstream(name, 'CK', True) for name in ('clk', 'dec_clk')}
    if clocks['clk']['dff_sinks'] != 996 or clocks['dec_clk']['dff_sinks'] != 15:
        raise ValueError('Clock-domain register load reconciliation failed')
    lut_items = [x for x in leaves if x['name'].startswith('u_srm_residue/u_lut/')]
    rtl_declared = {'shadow_weights': 20*30, 'accumulator': 37, 'temp_acc': 36,
                    'meas_val_p': 30, 'meas_val_n': 30, 'avg_rounded_r': 37,
                    'calc_result_r': 32, 'w_wr_data': 30, 'raw_code_o': 20}
    opportunity = {'scope': 'gross removed register/ICG leaf area, not net new synthesis/PNR PPA',
                   'trusted_registers': summarize(reference),
                   'trusted_six_clock_gate_contents': summarize(trusted_gates),
                   'snapshot_registers': summarize([x for x in dffs if re.search(r'/(avg_rounded_r_reg|calc_result_r_reg)\[', x['name'])]),
                   'trusted_180_dff_fraction_of_pnr': sum(x['area_um2'] for x in reference)/102300.1056}
    maximum_weights = [256 << k for k in range(6)]
    range_rows = []
    for k in range(6, 20):
        maximum = sum(maximum_weights) + 128
        if maximum != 254 * 2**k:
            raise ValueError('Default-parameter recursive range calculation changed')
        maximum_weights.append(maximum)
        unsigned_width = maximum.bit_length()
        signed_width = unsigned_width + 1
        removable_signed = [x for x in shadow_addresses[k]
                             if int(re.search(r'\[(\d+)\]$', x['name'])[1]) >= signed_width]
        range_rows.append({'address': k, 'max_reachable_weight_q8_candidate': maximum,
                           'min_unsigned_bits_if_nonnegative_proven': unsigned_width,
                           'min_signed_bits_for_bound': signed_width,
                           'mapped_dffs_above_signed_bound': summarize(removable_signed)})
    range_estimate = {'scope': 'mathematical candidate under valid reset/defaults/qualified FSM addresses; not a sequential formal proof or synthesis result',
                      'defaults': {'AVG_LOOPS': 32, 'REF_WEIGHT_LSB': 256, 'HALF_LSB': 128,
                                   'MAX_CALIB_BIT': 5, 'CAP_NUM': 20},
                      'recurrence': 'Wmax(k)=sum(Wmax(0..k-1))+128=254*2**k for k=6..19',
                      'writable_entries': range_rows,
                      'writable_signed_bit_budget': sum(x['min_signed_bits_for_bound'] for x in range_rows),
                      'writable_unsigned_bit_budget': sum(x['min_unsigned_bits_if_nonnegative_proven'] for x in range_rows),
                      'gross_dffs_above_signed_bound': sum(x['mapped_dffs_above_signed_bound']['count'] for x in range_rows),
                      'gross_area_above_signed_bound_um2': round(sum(x['mapped_dffs_above_signed_bound']['area_um2'] for x in range_rows), 9),
                      'required_proof': ['reset assumption', 'FSM/write-address reachability', 'P/N compensated sum bounds including protected bits',
                                         'average rounding and truncation/overflow', 'parameter freeze', 'no force/SEU/illegal-state behavior extension']}
    input_sources = [netfile, leffile] + [repo/path for path in (
        'evidence/rtl_baseline/sar_calib_ctrl_serial.sv',
        'evidence/rtl_baseline/sar_digi_paper_core.sv',
        'evidence/rtl_baseline/srm_residue_estimator.sv',
        'evidence/rtl_baseline/srm_residue_lut.sv',
        'evidence/rpt_v51/dc/timing_setup.rpt',
        'evidence/rpt_v51/dc/area_flat.rpt',
        'evidence/rpt_v51/dc/area.rpt',
        'evidence/rpt_v51/pnr/fc_area.rpt')]
    timing_text = (repo/'evidence/rpt_v51/dc/timing_setup.rpt').read_text(encoding='utf-8')
    timing_rows = []
    for match in re.finditer(r'^  Startpoint:(.*?)(?=^  Startpoint:|\Z)', timing_text, re.M | re.S):
        segment = match[0]
        start = re.search(r'Startpoint:\s*(\S+)', segment)
        end = re.search(r'Endpoint:\s*(\S+)', segment)
        arrival = re.search(r'data arrival time\s+([\d.-]+)', segment)
        slack = re.search(r'slack \([^)]*\)\s+([\d.-]+)', segment)
        if start and end and arrival and slack:
            timing_rows.append({'startpoint': start[1], 'endpoint': end[1],
                                'arrival_ns_report_precision': float(arrival[1]),
                                'slack_ns_report_precision': float(slack[1]),
                                'full_adder_CO_points_on_path': len(re.findall(r'/CO\s+\(ADDF\w+\)', segment)),
                                'source_line': timing_text[:match.start()].count('\n')+1})
    return {'scope': 'immutable delivered logical PNR netlist instances and delivered LEF SIZE dimensions',
            'sources_sha256': {str(p.relative_to(repo)): hashlib.sha256(p.read_bytes()).hexdigest()
                               for p in input_sources},
            'classification_rule': 'DFF/TLAT/BUF/INV/ADDF/ADDH/MX families plus named pin checks; other_combinational includes decomposed comparisons/arithmetic/mux/control',
            'totals': summarize(leaves), 'families': {k: summarize(v) for k, v in sorted(classes.items())},
            'hierarchy': perhier, 'cell_types': {k: summarize(v) for k, v in sorted(cell_types.items())},
            'register_groups': {k: {**summarize(v), 'actual_bit_indices': sorted(set(int(re.search(r'\[(\d+)\]$', x['name'])[1]) for x in v if re.search(r'\[(\d+)\]$', x['name'])))}
                                for k, v in sorted(reggroups.items())},
            'shadow_by_address': {str(k): summarize(v) for k, v in sorted(shadow_addresses.items())},
            'shadow_reference_cell_types': dict(Counter(x['type'] for x in reference)),
            'reference_only_nonzero_reset_bits': [8+i for i in range(6)],
            'reference_semantically_variable_bits_after_valid_reset': 0,
            'rtl_declared_register_widths_default': rtl_declared,
            'clock_gate_instances': traced_gates, 'clock_gate_count': len(gates),
            'clock_gate_contents': summarize(gate_items),
            'clock_domain_register_loads_through_buffers_and_clock_gates': clocks,
            'register_clock_pin_loads_by_net': dict(sorted(allclock.items())),
            'register_async_reset_pin_loads_by_net': dict(sorted(allreset.items())),
            'reference_clock_pin_loads_by_net': dict(sorted(refclock.items())),
            'reference_reset_pin_loads_by_net': dict(sorted(refreset.items())),
            'rst_n_buffer_inverter_tree_to_SN': reset_sn,
            'rst_n_buffer_inverter_tree_to_RN': reset_rn,
            'lut': {'total': summarize(lut_items), 'families': {f: summarize([x for x in lut_items if x['family'] == f]) for f in sorted(classes)}},
            'opportunity_estimates': opportunity,
            'recursive_range_estimates_not_new_synthesis': range_estimate,
            'dc_typical_wireload_timing_paths': timing_rows,
            'module_definition_lines': module_lines,
            'limits': ['LEF area is geometry, not timing/power/capacitance',
                       'BUF/INV clock/reset tracing gives logical pin counts and geometry, not capacitance/skew or recovery/removal signoff',
                       'primitive mux/add counts are not exact RTL operator counts; comparator/decode logic is decomposed',
                       'unobserved weight_export table removal is RTL synthesis expectation; WEIGHT_EXPORT_REG=1 not re-synthesized here']}, leaves


def main():
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repo', type=Path, default=here.parent)
    parser.add_argument('--output-dir', type=Path, default=here.parent/'build/rtl_review')
    args = parser.parse_args()
    locked = json.loads((args.repo/'docs/baseline_manifest.json').read_text(encoding='utf-8'))['sha256']
    data, leaves = inventory(args.repo)
    for path, digest in data['sources_sha256'].items():
        if locked[path] != digest:
            raise ValueError(f'Historical input changed: {path}')
    args.output_dir.mkdir(parents=True, exist_ok=True)
    for name, obj in [('synthesis_inventory.json', data), ('synthesis_leaf_inventory.json', leaves)]:
        (args.output_dir/name).write_text(json.dumps(obj, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print('SYNTHESIS_INVENTORY_PASS cells=3626 area_um2=102300.1056')
    print(json.dumps({'families': data['families'], 'hierarchy': data['hierarchy'],
                      'clock_gate_count': data['clock_gate_count'], 'lut': data['lut']}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
