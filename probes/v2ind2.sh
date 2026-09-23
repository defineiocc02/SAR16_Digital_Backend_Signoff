#!/bin/bash
# V2 (fixed): the first attempt parsed direction declarations from the module HEADER
# only, so 27 real inputs were left floating and trivially showed X.  This version
# reads the declarations from the module BODY and drives every input.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2ind2
rm -rf $W; mkdir -p $W

python3 - "$NET" "$W/tb_indep.sv" <<'PYEOF'
import io, re, sys
net, out = sys.argv[1], sys.argv[2]
t = io.open(net, encoding='utf-8', errors='replace').read()
m = re.search(r'module\s+sar_digi_paper_core\s*\((.*?)\)\s*;', t, re.S)
assert m, 'top port list not found'
ports = [p.strip() for p in m.group(1).split(',') if p.strip()]
body = t[m.end():]

# directions live in the module BODY, one per line, before the first instance
ins, outs = [], []
for ln in body.splitlines():
    st = ln.strip()
    if not st:
        continue
    mm = re.match(r'^(input|output|inout)\s+(.*?);\s*$', st)
    if mm:
        (ins if mm.group(1) == 'input' else outs).append(mm.group(2).strip())
        continue
    if re.match(r'^[A-Za-z_]', st):      # first instance -> stop
        break
print('top ports=%d  inputs=%d  outputs=%d' % (len(ports), len(ins), len(outs)))
print('inputs : %s' % ', '.join(ins[:20]))
print('outputs: %s' % ', '.join(outs[:20]))
missing = [p for p in ports if p not in ins and p not in outs]
print('ports with no direction found: %s' % (missing if missing else 'none'))

L = ['`timescale 1ns/1ps', 'module tb_indep;']
for p in ins:
    L.append('  reg %s;' % p)
for p in outs:
    L.append('  wire %s;' % p)
L.append('  integer errors = 0;')
def nm(p):
    """connection name: strip a leading width, e.g. '[19:0] raw_bits_i' -> 'raw_bits_i'"""
    return p.split(']')[-1].strip() if ']' in p else p
conns = ',\n    '.join('.%s(%s)' % (nm(p), nm(p)) for p in ports)
L.append('  sar_digi_paper_core dut (\n    %s\n  );' % conns)
L.append('  initial begin')
for p in ins:
    L.append('    %s = 0;' % nm(p))
L.append('  end')
L.append('  initial clk = 0;')
L.append('  always #5 clk = ~clk;')
L.append('  initial dec_clk = 0;')
L.append('  always #10 dec_clk = ~dec_clk;')
L.append('  task chk; input [255:0] nm; input v; begin')
L.append("    if (v === 1'bx || v === 1'bz) begin")
L.append('      errors = errors + 1; $display("INDEP_X   %0s = X/Z", nm); end')
L.append('  end endtask')
L.append('  initial begin')
L.append('    #20; rst_n = 0; #200; rst_n = 1; #2000;')
L.append('    $display("INDEP_TB  checked at %0t", $time);')
for p in outs:
    L.append('    chk("%s", %s);' % (nm(p), nm(p)))
L.append('    chk("dut.u_srm_residue.rst_n", dut.u_srm_residue.rst_n);')
L.append('    chk("dut.u_calib_ctrl.rst_n", dut.u_calib_ctrl.rst_n);')
L.append('    chk("dut.u_srm_residue.HFSNET_5", dut.u_srm_residue.HFSNET_5);')
L.append('    chk("dut.u_calib_ctrl.HFSNET_330", dut.u_calib_ctrl.HFSNET_330);')
L.append('    $display("INDEP_ERRORS %0d", errors);')
L.append('    if (errors == 0) $display("INDEP_VERDICT NO_X_ON_PROBED_POINTS");')
L.append('    else             $display("INDEP_VERDICT X_FOUND count=%0d", errors);')
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('testbench written: %d lines' % len(L))
PYEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_indep $CELLS $NET $W/tb_indep.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -iE '^Error|Error-' $W/build.log | head -6
if [ -x $W/simv_indep ]; then
    timeout 900 $W/simv_indep -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    echo "--- independent verdict ---"
    grep -a -E 'INDEP_' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== V2IND2_DONE ==="
