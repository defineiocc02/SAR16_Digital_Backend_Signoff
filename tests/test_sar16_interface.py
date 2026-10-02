"""Exercise rejection at the external pin-map and positional-netlist boundary."""
import csv
import importlib.util
from pathlib import Path
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
SPEC = importlib.util.spec_from_file_location('sar16_interface', ROOT / 'tools/check_sar16_interface.py')
CHECK = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CHECK)


class Sar16InterfaceTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.temp = Path(self.directory.name)

    def write_pinmap(self, rows):
        path = self.temp / 'mutated_pinmap.csv'
        with path.open('w', encoding='utf-8', newline='') as stream:
            writer = csv.DictWriter(stream, fieldnames=CHECK.CSV_FIELDS)
            writer.writeheader()
            writer.writerows(rows)
        return path

    def test_actual_evidence_and_maps_pass(self):
        result = CHECK.validate(ROOT)
        self.assertEqual(result['status'], 'PASS')
        self.assertEqual((result['groups'], result['signal_bits'], result['extracted_formals']),
                         (31, 176, 178))
        self.assertFalse(result['top_macro_lef_present'])

    def test_swapped_raw_bits_are_rejected(self):
        rows = CHECK.read_csv(ROOT / 'integration/sar16_core_pinmap.csv')
        by_name = {row['verilog_name']: row for row in rows}
        first, second = by_name['raw_bits_i[0]'], by_name['raw_bits_i[1]']
        first['verilog_name'], second['verilog_name'] = second['verilog_name'], first['verilog_name']
        with self.assertRaisesRegex(ValueError, 'Digital pinmap'):
            CHECK.validate(ROOT, pinmap_path=self.write_pinmap(rows))

    def test_missing_pin_is_rejected(self):
        rows = CHECK.read_csv(ROOT / 'integration/sar16_core_pinmap.csv')
        rows = [row for row in rows if row['verilog_name'] != 'srm_residue_o[9]']
        with self.assertRaisesRegex(ValueError, 'Digital pinmap'):
            CHECK.validate(ROOT, pinmap_path=self.write_pinmap(rows))

    def test_extracted_child_order_swap_is_rejected(self):
        cards = CHECK.spice_cards(CHECK.read_text(ROOT / 'integration/sar16_core_pin_adapter.sp'))
        child = next(card for card in cards if card[0] == 'Xcore')
        child[1], child[2] = child[2], child[1]
        path = self.temp / 'mutated_adapter.sp'
        path.write_text('\n'.join(' '.join(card) for card in cards) + '\n', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, 'Xcore extracted-SP positional order'):
            CHECK.validate(ROOT, wrapper_path=path)

    def test_supply_omission_is_rejected(self):
        cards = CHECK.spice_cards(CHECK.read_text(ROOT / 'integration/sar16_core_pin_adapter.sp'))
        child = next(card for card in cards if card[0] == 'Xcore')
        child.remove('VSS')
        path = self.temp / 'missing_supply_adapter.sp'
        path.write_text('\n'.join(' '.join(card) for card in cards) + '\n', encoding='utf-8')
        with self.assertRaisesRegex(ValueError, 'Xcore extracted-SP positional order'):
            CHECK.validate(ROOT, wrapper_path=path)


if __name__ == '__main__':
    unittest.main()
