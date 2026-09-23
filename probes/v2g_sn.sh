#!/bin/bash
# V2 round 7: verify or kill the "SN tie net is X" hypothesis.
# Roots forced to 0; print the actual values of the tie nets that feed the flops'
# asynchronous SET pins, and of one flop's SN pin.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2g
rm -rf $W; mkdir -p $W

python3 - "$NET" "$W/tb_sn.sv" <<'PYEOF'
import io, re, sys
net, out = sys.argv[1], sys.argv[2]
t = io.open(net, encoding='utf-8', errors='replace').read()
m = re.search(r'module\s+sar_digi_paper_core\s*\((.*?)\)\s*;', t, re.S)
ports = [p.strip() for p in m.group(1).split(',') if p.strip()]
body = t[m.end():]
ins, outs = [], []
for ln in body.splitlines():
    st = ln.strip()
    if not st:
        continue
    mm = re.match(r'^(input|output|inout)\s+(.*?);\s*$', st)
    if mm:
        (ins if mm.group(1) == 'input' else outs).append(mm.group(2).strip())
        continue
    if re.match(r'^[A-Za-z_]', st):
        break
nm = lambda p: p.split(']')[-1].strip() if ']' in p else p
PROBES = [('top HFSNET_124', 'dut.HFSNET_124'),
          ('srm HFSNET_8', 'dut.u_srm_residue.HFSNET_8'),
          ('srm HFSNET_4', 'dut.u_srm_residue.HFSNET_4'),
          ('srm HFSNET_6', 'dut.u_srm_residue.HFSNET_6'),
          ('srm HFSNET_9', 'dut.u_srm_residue.HFSNET_9'),
          ('srm rst_n', 'dut.u_srm_residue.rst_n'),
          ('srm go_tgl', 'dut.u_srm_residue.go_tgl'),
          ('srm state', 'dut.u_srm_residue.state')]
L = ['`timescale 1ns/1ps', 'module tb_sn;']
for p in ins:
    L.append('  reg %s;' % p)
for p in outs:
    L.append('  wire %s;' % p)
L.append('  sar_digi_paper_core dut (\n    %s\n  );'
         % ',\n    '.join('.%s(%s)' % (nm(p), nm(p)) for p in ports))
L.append('  initial begin')
for p in ins:
    L.append('    %s = 0;' % nm(p))
L.append('  end')
L.append('  initial clk = 0; always #5 clk = ~clk;')
L.append('  initial dec_clk = 0; always #10 dec_clk = ~dec_clk;')
L.append("  initial begin force dut.HFSNET_120 = 1'b0; force dut.HFSNET_121 = 1'b0;")
L.append("    force dut.HFSNET_122 = 1'b0; force dut.HFSNET_123 = 1'b0; force dut.HFSNET_124 = 1'b0; end")
L.append('  initial begin')
L.append('    #400;')
for name, path in PROBES:
    L.append('    $display("SNV %-14s = %%b", %s);' % (name, path))
L.append('    $display("SNV ---- driving clk/dec_clk for a while ----");')
L.append('    #200;')
for name, path in PROBES:
    L.append('    $display("SNV2 %-14s = %%b", %s);' % (name, path))
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('TB written: %d lines, %d probes' % (len(L), len(PROBES)))
PYEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_sn $CELLS $NET $W/tb_sn.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -m3 -E '^Error|Error-\[' $W/build.log | sed 's/^/  /'
if [ -x $W/simv_sn ]; then
    timeout 900 $W/simv_sn -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    grep -a 'SNV' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== V2G_DONE ==="
