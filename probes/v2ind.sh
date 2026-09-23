#!/bin/bash
# V2: an INDEPENDENT gate-level functional probe of the delivered post-route netlist.
# The generator reads the netlist's own top-module port list, then emits a self-checking
# testbench that (a) drives clock/reset, (b) checks every output for X after reset, and
# (c) probes the tie nets and the sub-block reset pins -- the exact places where the
# undriven constant root can inject X.  No designer-supplied checker is used.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2ind
rm -rf $W; mkdir -p $W

python3 - "$NET" "$W/tb_indep.sv" <<'PYEOF'
import io, re, sys
net, out = sys.argv[1], sys.argv[2]
t = io.open(net, encoding='utf-8', errors='replace').read()
m = re.search(r'module\s+sar_digi_paper_core\s*\((.*?)\)\s*;', t, re.S)
assert m, 'top port list not found'
ports = [p.strip() for p in m.group(1).split(',') if p.strip()]
head = t[:m.end()]
ins, outs = [], []
for p in ports:
    base = p.split('[')[0].strip()
    decl = re.search(r'\b(input|output|inout)\b[^;]*\b%s\b' % re.escape(base), head)
    kind = decl.group(1) if decl else None
    (ins if kind == 'input' else outs).append(p)
print('top ports=%d  inputs=%d  outputs=%d' % (len(ports), len(ins), len(outs)))
print('inputs : %s' % ', '.join(ins[:18]))
print('outputs: %s' % ', '.join(outs[:18]))

L = []
L.append('`timescale 1ns/1ps')
L.append('module tb_indep;')
for p in ins:
    L.append('  reg %s;' % p)
for p in outs:
    L.append('  wire %s;' % p)
L.append('  integer errors = 0;')
L.append('  integer i;')
conns = ',\n    '.join('.%s(%s)' % (p.split('[')[0].strip() if '[' in p else p, p) for p in ports)
L.append('  sar_digi_paper_core dut (\n    %s\n  );' % conns)
L.append('  initial begin')
for p in ins:
    L.append('    %s = 0;' % p)
L.append('  end')
L.append('  initial clk = 0;')
L.append('  always #5 clk = ~clk;')
L.append('  initial dec_clk = 0;')
L.append('  always #10 dec_clk = ~dec_clk;')
L.append('  task chk; input [255:0] nm; input v; begin')
L.append('    if (v === 1\'bx || v === 1\'bz) begin')
L.append('      errors = errors + 1; $display("INDEP_X   %0s = X/Z", nm); end')
L.append('  end endtask')
L.append('  initial begin')
L.append('    #20;')
L.append('    rst_n = 0;')
L.append('    #200;')
L.append('    rst_n = 1;')
L.append('    #2000;')
L.append('    $display("INDEP_TB  after reset+2000ns");')
for p in outs:
    L.append('    chk("%s", %s);' % (p, p))
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
print('testbench written: %s (%d lines)' % (out, len(L)))
PYEOF

echo ""
echo "############ compile ############"
cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_indep $CELLS $NET $W/tb_indep.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
echo "--- errors in build ---"
grep -a -iE '^Error|Error-' $W/build.log | head -8

echo ""
echo "############ run ############"
if [ -x $W/simv_indep ]; then
    timeout 900 $W/simv_indep -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    echo "--- independent verdict ---"
    grep -a -E 'INDEP_' $W/run.log
    echo "--- non-INDEP highlights ---"
    grep -a -iE 'Error|Warning' $W/run.log | sort -u | head -8
else
    echo "NO BINARY PRODUCED"
fi
echo "=== V2IND_DONE ==="
