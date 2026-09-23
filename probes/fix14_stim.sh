#!/bin/bash
# FIX 14: with the reset now proven good, re-run the SRM stimulus (start + 22 decisions)
# on the DELIVERED netlist -- no forces anywhere.  Tests whether "the FSM never leaves
# S_IDLE" was also a measurement artefact of the earlier (wrong) reset assumption.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/fix14
rm -rf $W; mkdir -p $W
NDEC=22

python3 - "$NET" "$W/tb_s.sv" "$NDEC" <<'PYEOF'
import io, re, sys
net, out, ndec = sys.argv[1], sys.argv[2], int(sys.argv[3])
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
L = ['`timescale 1ns/1ps', 'module tb_s;']
for p in ins:
    L.append('  reg %s;' % nm(p))
for p in outs:
    L.append('  wire %s;' % nm(p))
L.append('  integer i; integer errors = 0;')
L.append('  sar_digi_paper_core dut (\n    %s\n  );'
         % ',\n    '.join('.%s(%s)' % (nm(p), nm(p)) for p in ports))
L.append('  initial begin')
for p in ins:
    L.append('    %s = 0;' % nm(p))
L.append('  end')
L.append('  initial clk = 0; always #5 clk = ~clk;')
L.append('  initial dec_clk = 0; always #10 dec_clk = ~dec_clk;')
L.append('  task show; input [255:0] tag; begin')
L.append('    $display("S %-14s t=%0t rstn_srm=%b state=%b dec_run=%b busy=%b done=%b total=%0d ones=%0d shortfall=%b stalled=%b residue=%0d",')
L.append('      tag, $time, dut.u_srm_residue.rst_n, dut.u_srm_residue.state,')
L.append('      dut.u_srm_residue.dec_run, srm_busy, srm_done,')
L.append('      srm_total_count, srm_ones_count, srm_count_shortfall, srm_stalled, $signed(srm_residue_o));')
L.append('  end endtask')
L.append('  initial begin')
L.append('    rst_n = 0; #200; rst_n = 1; #100; show("after_reset");')
L.append('    srm_start = 1; #20; srm_start = 0; #60; show("after_start");')
L.append('    srm_decision_valid = 1;')
L.append('    for (i = 0; i < 40; i = i + 1) begin')
L.append("      srm_decision_bit = ((i % 3) == 0) ? 1'b1 : 1'b0;")
L.append('      @(posedge dec_clk);')
L.append('    end')
L.append('    srm_decision_valid = 0;')
L.append('    #200; show("after_decisions");')
L.append('    #4000; show("late");')
L.append('    $display("S_EXPECT total=22 ones=7 or 8 (window f(0..21) -> 8, f(1..22) -> 7)");')
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('TB written: %d lines' % len(L))
PYEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_s $CELLS $NET $W/tb_s.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -m3 -E '^Error|Error-\[' $W/build.log | sed 's/^/  /'
if [ -x $W/simv_s ]; then
    timeout 900 $W/simv_s -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    grep -a '^S ' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== FIX14_DONE ==="
