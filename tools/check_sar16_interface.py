#!/usr/bin/env python3
"""Validate the default SAR16 interface against immutable RTL/CDL/SP/LEF evidence.

The generated SPICE adapter only changes positional order for the extracted SP.
It does not resolve electrical compatibility, analog sequencing, or LVS.
"""
import argparse
import ast
import csv
import json
from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parent.parent
CSV_FIELDS = [
    'canonical_position_1based', 'kind', 'group', 'verilog_name', 'oa_alias',
    'group_width', 'group_signed', 'bit_index', 'direction', 'domain',
    'source_cdl_position_1based', 'extracted_sp_position_1based',
    'source_cdl_supply_mode',
]


def require(condition, message):
    if not condition:
        raise ValueError(message)


def read_text(path):
    return path.read_text(encoding='utf-8-sig')


def unique(values, context):
    require(len(values) == len(set(values)), f'{context}: duplicate names')


def integer_expression(expression, parameters):
    """Evaluate only the integer names/arithmetic used by this port header."""
    def value(node):
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return node.value
        if isinstance(node, ast.Name) and node.id in parameters:
            return parameters[node.id]
        if isinstance(node, ast.BinOp) and isinstance(node.op, (ast.Add, ast.Sub)):
            left, right = value(node.left), value(node.right)
            return left + right if isinstance(node.op, ast.Add) else left - right
        raise ValueError(f'Unsupported port-width expression: {expression}')
    return value(ast.parse(expression.strip(), mode='eval').body)


def rtl_ports(source, top):
    source = re.sub(r'/\*.*?\*/|//[^\n]*', '', source, flags=re.S)
    match = re.search(r'\bmodule\s+' + re.escape(top) +
                      r'\s*#\s*\((.*?)\)\s*\((.*?)\);', source, re.S)
    require(match is not None, f'RTL: missing parameterized top {top}')
    parameter_header, port_header = match.groups()
    parameters = {name: int(number) for name, number in re.findall(
        r'parameter\s+int\s+(\w+)\s*=\s*(\d+)\s*(?:,|$)', parameter_header)}
    parameters.update({name: int(number) for name, number in re.findall(
        r"parameter\s+bit\s+(\w+)\s*=\s*1'b([01])\s*(?:,|$)", parameter_header)})
    ports = []
    for declaration in port_header.split(','):
        found = re.fullmatch(
            r'\s*(input|output)\s+logic\s+(signed\s+)?'
            r'(?:\[([^:]+):([^\]]+)\]\s*)?(\w+)\s*', declaration)
        require(found is not None, f'RTL: unparsed declaration {declaration!r}')
        direction, signed, msb, lsb, name = found.groups()
        port = {'name': name, 'direction': direction, 'signed': bool(signed), 'width': 1}
        if msb is not None:
            high = integer_expression(msb, parameters)
            low = integer_expression(lsb, parameters)
            require(high >= low >= 0, f'RTL: unsupported range for {name}')
            port.update(msb=high, lsb=low, width=high-low+1)
        ports.append(port)
    unique([port['name'] for port in ports], 'RTL groups')
    return parameters, ports


def pnr_ports(source, top):
    match = re.search(r'^module\s+' + re.escape(top) +
                      r'\s*\((.*?)\)\s*;(.*?)^endmodule', source, re.M | re.S)
    require(match is not None, f'PNR Verilog: missing top {top}')
    order = [name.strip() for name in match[1].split(',')]
    declarations = {}
    for direction, msb, lsb, name in re.findall(
            r'^\s*(input|output)\s+(?:\[(\d+):(\d+)\]\s*)?(\w+)\s*;',
            match[2], re.M):
        require(name not in declarations, f'PNR: repeated declaration {name}')
        port = {'name': name, 'direction': direction, 'width': 1}
        if msb:
            port.update(msb=int(msb), lsb=int(lsb), width=int(msb)-int(lsb)+1)
        declarations[name] = port
    unique(order, 'PNR groups')
    require(set(order) == set(declarations), 'PNR header/declaration mismatch')
    return [declarations[name] for name in order]


def spice_cards(source):
    cards = []
    for line in source.splitlines():
        line = line.strip()
        if not line or line.startswith('*'):
            continue
        if line.startswith('+'):
            require(bool(cards), 'SPICE: continuation without a card')
            cards[-1].extend(line[1:].split())
        else:
            cards.append(line.split())
    return cards


def subckt_pins(cards, top):
    headers = [card for card in cards if len(card) >= 2 and
               card[0].upper() == '.SUBCKT' and card[1] == top]
    require(len(headers) == 1, f'SPICE: expected one .SUBCKT {top}')
    pins = headers[0][2:]
    unique(pins, f'{top} formal pins')
    return pins


def expand_ports(ports):
    result = []
    for port in ports:
        indices = range(port['msb'], port['lsb']-1, -1) if 'msb' in port else [None]
        for bit in indices:
            name = port['name'] if bit is None else f"{port['name']}[{bit}]"
            result.append((port, bit, name))
    unique([name for _, _, name in result], 'Expanded RTL pins')
    return result


def oa_bit_names(cell):
    result = set()
    for name, info in cell['pins'].items():
        match = re.fullmatch(r'(\w+)<(\d+):(\d+)>', name)
        if match:
            group, first, last = match.groups()
            first, last = int(first), int(last)
            require(info['numBits'] == abs(first-last)+1, f'OA width mismatch: {name}')
            result.update(f'{group}<{bit}>' for bit in range(min(first,last), max(first,last)+1))
        else:
            require(info['numBits'] == 1, f'Unrecognized OA bus: {name}')
            result.add(name)
    return result


def read_csv(path, fields=None):
    with path.open(encoding='utf-8-sig', newline='') as stream:
        reader = csv.DictReader(stream)
        if fields is not None:
            require(reader.fieldnames == fields, f'{path.name}: unexpected CSV columns')
        rows = list(reader)
    require(all(None not in row and all(v is not None for v in row.values()) for row in rows),
            f'{path.name}: malformed CSV row')
    return rows


def check_analog_maps(repo, spec):
    inventory = json.loads(read_text(repo / spec['evidence']['oa_inventory']))
    cells = {(c['library'], c['cell']): c for c in inventory['cells']}
    require(len(cells) == len(inventory['cells']), 'OA: duplicate cell records')
    cdac = cells[('SAR_16B_5M_CORE', 'CDAC_MAIN_20b')]
    driver = cells[('SAR_16B_5M_CORE', 'CDAC_SWITCH_DRIVER_NEW')]
    require(cdac['read_ok'] and driver['read_ok'], 'OA: required cell read failed')
    cdac_pins, driver_pins = oa_bit_names(cdac), oa_bit_names(driver)
    connections = driver['selected_connections']
    require(len(connections) == 20, 'OA: expected 20 driver connections')
    unique([c['terms']['BIT'] for c in connections], 'OA driver physical BIT')
    by_bit = {c['terms']['BIT']: c for c in connections}
    weights = read_csv(repo / 'integration/analog_weight_map.csv')
    require(len(weights) == spec['expected']['analog_weight_rows'] == 20,
            'Analog weight map: expected 20 rows')
    unique([row['weight_index'] for row in weights], 'Analog weight index')
    unique([row['legacy_logic_index'] for row in weights], 'Analog physical index')
    unique([row['legacy_set_index'] for row in weights], 'Analog SET index')
    require({int(row['weight_index']) for row in weights} == set(range(20)),
            'Analog weight map: indices must be 0..19')
    for row in weights:
        i = int(row['weight_index'])
        j, setting = i+1, 19-i
        require(row['paper_cap'] == f'C{i}' and int(row['legacy_logic_index']) == j and
                int(row['legacy_set_index']) == setting,
                f'Analog weight {i}: physical index/SET mismatch')
        require(row['p_top_node'] == 'P' and row['n_top_node'] == 'N' and
                row['p_bottom_node_oa'] == f'BITD<{j}>' and
                row['n_bottom_node_oa'] == f'BITU<{j}>',
                f'Analog weight {i}: P/N CDAC pin mismatch')
        require(all(row[field] in cdac_pins for field in
                    ('p_top_node', 'n_top_node', 'p_bottom_node_oa', 'n_bottom_node_oa')),
                f'Analog weight {i}: missing OA CDAC pin')
        connection = by_bit.get(f'BITU<{j}>')
        require(connection is not None, f'Analog weight {i}: missing OA driver connection')
        require(connection['cell'] == 'CDAC_SWITCH_DRIVER_NEW_GATES',
                f'Analog weight {i}: unexpected driver cell')
        for term, net in {'BITP': f'BITP<{j}>', 'BITN': f'BITN<{j}>',
                          'SET': f'SET<{setting}>'}.items():
            require(net in driver_pins and connection['terms'].get(term) == net,
                    f'Analog weight {i}: OA driver {term} mismatch')
        require('raw_bit_sign_pending' in row['raw_polarity_status'],
                f'Analog weight {i}: raw sign requires separately validated evidence')
    boundary = read_csv(repo / 'integration/analog_boundary.csv')
    require(bool(boundary), 'Analog boundary map is empty')
    unique([row['canonical_role'] for row in boundary], 'Analog boundary role')
    require(all(row['mapping_status'] and row['requirement'] for row in boundary),
            'Analog boundary map: missing status/requirement')
    return {'analog_weight_rows': len(weights), 'analog_boundary_rows': len(boundary),
            'oa_driver_connections': len(connections), 'raw_polarity': 'pending'}


def load_evidence(repo, canonical_path):
    spec = json.loads(read_text(canonical_path))
    require(spec['schema_version'] == 1, 'Unsupported interface schema')
    top, paths = spec['top_module'], spec['evidence']
    parameters, actual = rtl_ports(read_text(repo / paths['rtl']), top)
    require(spec['parameters'] == parameters, 'Canonical default parameters differ from RTL')
    canonical = spec['ports']
    keys = ('name', 'direction', 'width', 'signed', 'msb', 'lsb')
    require([{k: p[k] for k in keys if k in p} for p in canonical] == actual,
            'Canonical groups/direction/width/signed/order differ from RTL')
    require(all(p.get('domain') for p in canonical), 'Canonical port domain is missing')
    pnr = pnr_ports(read_text(repo / paths['pnr_verilog']), top)
    require([{k: v for k, v in p.items() if k != 'signed'} for p in actual] == pnr,
            'PNR groups/direction/width/order differ from RTL')
    expanded = expand_ports(canonical)
    signals = [name for _, _, name in expanded]
    require(len(canonical) == spec['expected']['groups'] == 31 and
            len(signals) == spec['expected']['signal_bits'] == 176,
            'Expected default 31 groups/176 signal bits')
    source_cards = spice_cards(read_text(repo / paths['source_cdl']))
    source = subckt_pins(source_cards, top)
    require(source == signals, 'Source CDL formal order differs from canonical RTL expansion')
    power = spec['adapter_power_pins']
    require(power == ['VDD', 'VSS'], 'Expected canonical adapter power order VDD,VSS')
    globals_ = {name for card in source_cards if card[0].upper() == '.GLOBAL' for name in card[1:]}
    require(set(power) <= globals_ and not set(power).intersection(source),
            'Source CDL must retain global power outside top formal pins')
    extracted = subckt_pins(spice_cards(read_text(repo / paths['extracted_sp'])), top)
    require(len(extracted) == spec['expected']['extracted_formals'] == 178 and
            set(extracted) == set(signals + power), 'Extracted SP formal pin bijection failed')
    macros = re.findall(r'^\s*MACRO\s+(\S+)\s*$', read_text(repo / paths['leaf_lef']), re.M)
    unique(macros, 'LEF macros')
    require(len(macros) == spec['expected']['leaf_lef_macros'] == 109 and top not in macros,
            'LEF must contain 109 leaf macros and no core top macro')
    analog = check_analog_maps(repo, spec)
    return spec, expanded, source, extracted, macros, analog


def expected_rows(spec, expanded, source, extracted):
    source_position = {name: str(i+1) for i, name in enumerate(source)}
    extracted_position = {name: str(i+1) for i, name in enumerate(extracted)}
    rows = []
    for port, bit, name in expanded:
        rows.append({
            'kind': 'signal', 'group': port['name'], 'verilog_name': name,
            'oa_alias': name if bit is None else f"{port['name']}<{bit}>",
            'group_width': str(port['width']), 'group_signed': str(int(port['signed'])),
            'bit_index': '' if bit is None else str(bit), 'direction': port['direction'],
            'domain': port['domain'], 'source_cdl_position_1based': source_position[name],
            'extracted_sp_position_1based': extracted_position[name], 'source_cdl_supply_mode': '',
        })
    for name in spec['adapter_power_pins']:
        rows.append({'kind': 'power', 'group': name, 'verilog_name': name, 'oa_alias': name,
                     'group_width': '1', 'group_signed': '0', 'bit_index': '', 'direction': 'power',
                     'domain': 'power', 'source_cdl_position_1based': '',
                     'extracted_sp_position_1based': extracted_position[name],
                     'source_cdl_supply_mode': 'global'})
    for i, row in enumerate(rows):
        row['canonical_position_1based'] = str(i+1)
    return rows


def continued_card(prefix, nodes, suffix=''):
    tokens = nodes + ([suffix] if suffix else [])
    lines = []
    for i in range(0, len(tokens), 8):
        lines.append((prefix if i == 0 else '+') + ' ' + ' '.join(tokens[i:i+8]))
    return '\n'.join(lines)


def generate_files(spec, expanded, source, extracted, pinmap_path, wrapper_path):
    pinmap_path.parent.mkdir(parents=True, exist_ok=True)
    with pinmap_path.open('w', encoding='utf-8', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=CSV_FIELDS, lineterminator='\n')
        writer.writeheader()
        writer.writerows(expected_rows(spec, expanded, source, extracted))
    signals = [name for _, _, name in expanded]
    wrapper = '\n'.join([
        '* Generated by tools/check_sar16_interface.py --generate.',
        '* Positional naming adapter for the extracted SP only; not an analog hookup.',
        '* Source CDL VDD/VSS globals are unchanged. Include the extracted core separately.',
        '* LVS is not closed; differing foundry/PDK designs cannot be physically spliced.',
        '* Voltage, switch truth table, timing and sample pairing require validation.',
        continued_card('.SUBCKT ' + spec['adapter_subckt'], signals + spec['adapter_power_pins']),
        continued_card('Xcore', extracted, spec['top_module']),
        '.ENDS ' + spec['adapter_subckt'], '',
    ])
    wrapper_path.parent.mkdir(parents=True, exist_ok=True)
    wrapper_path.write_text(wrapper, encoding='utf-8')


def validate(repo=ROOT, canonical_path=None, pinmap_path=None, wrapper_path=None, generate=False):
    repo = Path(repo).resolve()
    canonical_path = Path(canonical_path) if canonical_path else repo / 'integration/sar16_core_interface.json'
    pinmap_path = Path(pinmap_path) if pinmap_path else repo / 'integration/sar16_core_pinmap.csv'
    wrapper_path = Path(wrapper_path) if wrapper_path else repo / 'integration/sar16_core_pin_adapter.sp'
    spec, expanded, source, extracted, macros, analog = load_evidence(repo, canonical_path)
    if generate:
        generate_files(spec, expanded, source, extracted, pinmap_path, wrapper_path)
    rows = read_csv(pinmap_path, CSV_FIELDS)
    require(rows == expected_rows(spec, expanded, source, extracted),
            'Digital pinmap: row/name/alias/position/signed-group mismatch')
    cards = spice_cards(read_text(wrapper_path))
    pins = subckt_pins(cards, spec['adapter_subckt'])
    require(pins == [name for _, _, name in expanded] + spec['adapter_power_pins'],
            'Adapter canonical formal order mismatch')
    children = [card for card in cards if card[0].lower() == 'xcore']
    require(len(children) == 1 and children[0][1:-1] == extracted and
            children[0][-1] == spec['top_module'], 'Adapter Xcore extracted-SP positional order mismatch')
    require(len(cards) == 3 and cards[-1] == ['.ENDS', spec['adapter_subckt']],
            'Adapter must contain only its header, Xcore instance and .ENDS')
    return {'status': 'PASS', 'groups': len(spec['ports']), 'signal_bits': len(source),
            'extracted_formals': len(extracted), 'leaf_lef_macros': len(macros),
            'top_macro_lef_present': False, 'source_cdl_power': 'global VDD/VSS unchanged',
            'scope': 'Names, widths, signed groups, bit bijection and positional adapter only',
            'electrical_physical_and_protocol_signoff': 'not established', **analog}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repo', type=Path, default=ROOT)
    parser.add_argument('--canonical', type=Path)
    parser.add_argument('--pinmap', type=Path)
    parser.add_argument('--wrapper', type=Path)
    parser.add_argument('--generate', action='store_true', help='Regenerate only derived digital CSV/adapter')
    parser.add_argument('--output', type=Path, help='Optional JSON validation summary')
    args = parser.parse_args(argv)
    try:
        result = validate(args.repo, args.canonical, args.pinmap, args.wrapper, args.generate)
    except (OSError, ValueError, KeyError, TypeError) as error:
        print(f'SAR16_INTERFACE_CHECK_FAIL: {error}', file=sys.stderr)
        return 1
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
    print('SAR16_INTERFACE_CHECK_PASS groups={groups} signals={signal_bits} '
          'extracted_formals={extracted_formals} leaf_macros={leaf_lef_macros} '
          'analog_weights={analog_weight_rows} boundary_roles={analog_boundary_rows}'.format(**result))
    print('Scope: naming/order only; electrical, physical and sample-protocol signoff remain open.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
