#!/bin/bash
# V2 round 4: the blocks never counted anything.  My earlier probe only checked that
# the sub-block rst_n was "not X" -- it never printed the VALUE.  If the undriven tie
# chain resolves to 0, both big blocks are held in reset forever and that alone
# explains total=0 / busy=0.  This prints the values over time.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2d
rm -rf $W; mkdir -p $W

python3 - "$NET" "$W/tb_probe.sv" <<'PYEOF'
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
L = ['`timescale 1ns/1ps', 'module tb_probe;']
for p in ins:
    L.append('  reg %s;' % p)
for p in outs:
    L.append('  wire %s;' % p)
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
L.append('    $display("PROBE %0s HFSNET_124=%b rstn_calib=%b rstn_srm=%b calib_clk=%b HFSNET_119=%b busy=%b done=%b total=%0d start_seen=%b",')
L.append('      tag, dut.HFSNET_124, dut.u_calib_ctrl.rst_n, dut.u_srm_residue.rst_n,')
L.append('      dut.u_calib_ctrl.clk, dut.HFSNET_119, srm_busy, srm_done, srm_total_count, dut.u_srm_residue.dec_run);')
L.append('  end endtask')
L.append('  initial begin')
L.append('    #300; show("after_reset_release");')
L.append('    #200; show("before_start");')
L.append('    srm_start = 1; #20; srm_start = 0;')
L.append('    #100; show("after_start");')
L.append('    for (i = 0; i < 6; i = i + 1) begin')
L.append("      srm_decision_bit = ((i % 3) == 0) ? 1'b1 : 1'b0;")
L.append('      srm_decision_valid = 1; #80; srm_decision_valid = 0; #40;')
L.append('    end')
L.append('    show("after_6_decisions");')
L.append('    #4000; show("late");')
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('probe TB written: %d lines' % len(L))
PYEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_probe $CELLS $NET $W/tb_probe.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -m3 -E '^Error|Error-\[' $W/build.log | sed 's/^/  /'
if [ -x $W/simv_probe ]; then
    timeout 900 $W/simv_probe -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    echo "--- probe values ---"
    grep -a 'PROBE' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== V2D_DONE ==="
