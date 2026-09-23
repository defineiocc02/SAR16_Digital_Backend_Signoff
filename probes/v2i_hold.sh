#!/bin/bash
# V2 round 9: why does the FSM not leave S_IDLE?  Hold start high for a long time and
# sample state / next_state / busy; also watch whether the state register is clocked.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2i
rm -rf $W; mkdir -p $W

python3 - "$NET" "$W/tb_hold.sv" <<'PYEOF'
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
ROOTS = ['dut.HFSNET_120', 'dut.HFSNET_121', 'dut.HFSNET_122', 'dut.HFSNET_123', 'dut.HFSNET_124']
L = ['`timescale 1ns/1ps', 'module tb_hold;']
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
L.append('    $display("HLD %0s t=%0t rstn=%b start_pin=%b state=%b go_tgl=%b busy=%b dec_run=%b",')
L.append('      tag, $time, dut.u_srm_residue.rst_n, dut.u_srm_residue.start,')
L.append('      dut.u_srm_residue.state,')
L.append('      dut.u_srm_residue.go_tgl, srm_busy, dut.u_srm_residue.dec_run);')
L.append('  end endtask')
L.append('  initial begin')
for r in ROOTS:
    L.append("    force %s = 1'b1;" % r)
L.append('    #320; show("reset_asserted");')
for r in ROOTS:
    L.append("    force %s = 1'b0;" % r)
L.append('    #100; show("reset_released");')
L.append('    srm_start = 1;')
L.append('    for (i = 0; i < 10; i = i + 1) begin #100; show("start_held"); end')
L.append('    srm_start = 0; #200; show("start_low");')
L.append('    residue_consume_i = 1; #200; show("consume_hi");')
L.append('    #2000; show("late");')
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('TB written: %d lines' % len(L))
PYEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_hold $CELLS $NET $W/tb_hold.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -m3 -E '^Error|Error-\[' $W/build.log | sed 's/^/  /'
if [ -x $W/simv_hold ]; then
    timeout 900 $W/simv_hold -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    grep -a 'HLD' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== V2I_DONE ==="
