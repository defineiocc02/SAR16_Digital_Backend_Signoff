#!/bin/bash
# FIX 13: the decisive re-measurement.  Netlist says rst_n(port) -> INVX8 -> HFSNET_124
# -> inverters -> HFSNET_119 -> blocks' rst_n.  My earlier simulation said otherwise.
# This run prints the four values over time, with NO force anywhere.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/fix13
rm -rf $W; mkdir -p $W

python3 - "$NET" "$W/tb_r.sv" <<'PYEOF'
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
L = ['`timescale 1ns/1ps', 'module tb_r;']
for p in ins:
    L.append('  reg %s;' % nm(p))
for p in outs:
    L.append('  wire %s;' % nm(p))
L.append('  integer i;')
L.append('  sar_digi_paper_core dut (\n    %s\n  );'
         % ',\n    '.join('.%s(%s)' % (nm(p), nm(p)) for p in ports))
L.append('  initial begin')
for p in ins:
    L.append('    %s = 0;' % nm(p))
L.append('  end')
L.append('  initial clk = 0; always #5 clk = ~clk;')
L.append('  initial dec_clk = 0; always #10 dec_clk = ~dec_clk;')
L.append('  task show; input [255:0] tag; begin')
L.append('    $display("R %-10s t=%0t  rst_n_port=%b  HFSNET_124=%b  HFSNET_119=%b  rstn_calib=%b  rstn_srm=%b",')
L.append('      tag, $time, rst_n, dut.HFSNET_124, dut.HFSNET_119,')
L.append('      dut.u_calib_ctrl.rst_n, dut.u_srm_residue.rst_n);')
L.append('  end endtask')
L.append('  initial begin')
L.append('    show("t0");')
L.append('    #100; show("hold_low");')
L.append('    rst_n = 1;')
L.append('    #20;  show("+20ns");')
L.append('    #100; show("+120ns");')
L.append('    #1000; show("+1120ns");')
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('TB written: %d lines' % len(L))
PYEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_r $CELLS $NET $W/tb_r.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -m3 -E '^Error|Error-\[' $W/build.log | sed 's/^/  /'
if [ -x $W/simv_r ]; then
    timeout 900 $W/simv_r -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    grep -a '^R ' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== FIX13_DONE ==="
