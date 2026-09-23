#!/bin/bash
# FIX 15: settle the ONE remaining unexplained item -- why the delivered netlist
# reads srm_total_count = 0 / srm_ones_count = 0 while it publishes shortfall = 0
# and reaches S_HOLD, whereas the same stimulus on the RTL gives total = 22 / ones = 7.
#
# Method: identical stimulus to FIX 14 (so the result is comparable), but instrument
# EVERY clk cycle and also record the running MAXIMUM of the two count buses and the
# two internal counter buses.  A published-then-held value cannot hide from a max.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/fix15
# PH shifts the offered decision pattern by PH dec_clk slots.  The estimator accepts a
# 22-decision window; the RTL (zero-delay) run gives ones=7 and the netlist gives ones=8
# on the same stimulus, so the question is whether that is a LOST decision or merely the
# accepting window opening one slot later.  #{i in [0,21] : i%3==0} = 8 while
# #{i in [1,22] : i%3==0} = 7, so PH=1 must reproduce 7 if the window is merely shifted.
PH=${1:-0}
echo "PHASE=$PH"
rm -rf $W; mkdir -p $W

python3 - "$NET" "$W/tb_s.sv" "$PH" <<'PYEOF'
import io, re, sys
net, out, ph = sys.argv[1], sys.argv[2], int(sys.argv[3])
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
# Declare with the FULL declaration text (range included).  Earlier revisions used nm(p)
# and so declared every bus port as a 1-bit wire: a 5-bit output port connected to a 1-bit
# net silently truncates to its LSB, which is exactly why srm_total_count/srm_ones_count
# read 0 (LSB of 22 / of 8) and srm_residue_o read -1 (LSB of 981, signed).  The DUT was
# always right; the readout was wrong.
for p in ins:
    L.append('  reg %s;' % p)
for p in outs:
    L.append('  wire %s;' % p)
L.append('  integer i; integer nline = 0;')
L.append('  integer max_tot = 0; integer max_one = 0; integer max_dtot = 0; integer max_done_ = 0;')
L.append('  integer max_ctot = 0; integer max_cone = 0; integer max_itot = 0; integer max_ione = 0;')
L.append('  integer cycles_seen = 0; integer window = 0;')
# NOTE: the previous revision initialised the maxima to -1.  `integer` is SIGNED, so
# `srm_total_count (unsigned 5-bit) > max_tot (-1)` is evaluated as an UNSIGNED compare
# against 4294967295 and is therefore never true -- the maxima were dead code and printed
# -1.  Initialise to 0 instead.
L.append('  reg armed = 1\'b0;')
L.append('  reg [2:0] prev_state = 3\'bxxx;')
L.append('  sar_digi_paper_core dut (\n    %s\n  );'
         % ',\n    '.join('.%s(%s)' % (nm(p), nm(p)) for p in ports))
L.append('  initial begin')
for p in ins:
    L.append('    %s = 0;' % nm(p))
L.append('  end')
L.append('  initial clk = 0; always #5 clk = ~clk;')
L.append('  initial dec_clk = 0; always #10 dec_clk = ~dec_clk;')
L.append('  task row; begin')
L.append('    $display("C t=%0t st=%b n7=%b en=%b | SUB one=%0d tot=%0d q=%0d | TOP tot=%0d one=%0d res=%0d | NET 109=%b 110=%b 113=%b | NET 114=%b 115=%b 118=%b | NET 121=%b 130=%b",')
L.append('      $time, dut.u_srm_residue.state, dut.u_srm_residue.n7, dut.u_srm_residue.n123,')
L.append('      dut.u_srm_residue.ones_count, dut.u_srm_residue.total_count, dut.u_srm_residue.residue_q,')
L.append('      srm_total_count, srm_ones_count, $signed(srm_residue_o),')
L.append('      dut.aps_rename_109_, dut.aps_rename_110_, dut.aps_rename_113_,')
L.append('      dut.aps_rename_114_, dut.aps_rename_115_, dut.aps_rename_118_,')
L.append('      dut.aps_rename_121_, dut.aps_rename_130_);')
L.append('  end endtask')
# per-cycle trace: sample 1 ns after each rising clk edge (settled values).
L.append('  always @(posedge clk) begin : trace')
L.append('    #1;')
L.append('    if (armed) begin')
L.append('      cycles_seen = cycles_seen + 1;')
L.append('      if (srm_total_count > max_tot) max_tot = srm_total_count;')
L.append('      if (srm_ones_count > max_one) max_one = srm_ones_count;')
L.append('      if (dut.u_srm_residue.dec_total > max_dtot) max_dtot = dut.u_srm_residue.dec_total;')
L.append('      if (dut.u_srm_residue.dec_ones > max_done_) max_done_ = dut.u_srm_residue.dec_ones;')
L.append('      if (dut.u_srm_residue.cap_total > max_ctot) max_ctot = dut.u_srm_residue.cap_total;')
L.append('      if (dut.u_srm_residue.cap_ones > max_cone) max_cone = dut.u_srm_residue.cap_ones;')
L.append('      if (dut.u_srm_residue.ones_count > max_ione) max_ione = dut.u_srm_residue.ones_count;')
L.append('      if (dut.u_srm_residue.total_count > max_itot) max_itot = dut.u_srm_residue.total_count;')
# Sample EVERY cycle through the S_SETTLE -> S_LUT -> S_HOLD window: a value that is
# published for a single cycle cannot be missed this way.
L.append('      if (dut.u_srm_residue.state == 3\'b011 && window == 0) window = 14;')
L.append('      if (window > 0) begin row; window = window - 1; nline = nline + 1; end')
L.append('      else if (nline < 8) begin row; nline = nline + 1; end')
L.append('      if (dut.u_srm_residue.state !== prev_state) prev_state = dut.u_srm_residue.state;')
L.append('    end')
L.append('  end')
L.append('  initial begin')
L.append('    rst_n = 0; #200; rst_n = 1; #100;')
L.append('    armed = 1\'b1;')
L.append('    srm_start = 1; #20; srm_start = 0; #60;')
L.append('    srm_decision_valid = 1;')
L.append('    for (i = 0; i < 40; i = i + 1) begin')
L.append("      srm_decision_bit = (((i + %d) %% 3) == 0) ? 1'b1 : 1'b0;" % ph)
L.append('      @(posedge dec_clk);')
L.append('    end')
L.append('    srm_decision_valid = 0;')
L.append('    #4000;')
L.append('    $display("RUN  monitor executed on %0d clk cycles (proof the trace ran)", cycles_seen);')
L.append('    $display("MAX  top_total=%0d top_ones=%0d | SUB_total=%0d SUB_ones=%0d | dec_total=%0d dec_ones=%0d | cap_total=%0d cap_ones=%0d",')
L.append('      max_tot, max_one, max_itot, max_ione, max_dtot, max_done_, max_ctot, max_cone);')
L.append('    $display("EXPECT phase=%d : RTL 7 (window f(1..22)) / netlist 8 (window f(0..21)) if the difference is a one-slot window offset");' % ph)
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
    echo "----- per-change trace -----"
    grep -a '^C ' $W/run.log
    echo "----- maxima -----"
    grep -a '^RUN\|^MAX\|^EXPECT' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== FIX15_DONE ==="
