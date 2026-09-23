#!/bin/bash
# V2 round 8: the X is NOT from the SN tie nets (HFSNET_4 measured = 1, inactive).
# Root cause candidate: releasing reset through the tie chain sets rst_n = 1 from t=0,
# so the blocks are NEVER reset and their (synchronously-reset) flops stay X.
# Corrected stimulus: drive the tie root as a RESET SEQUENCE -- 1 (rst asserted) first,
# then 0 (released) -- and only then apply start.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2h
rm -rf $W; mkdir -p $W
NDEC=22

python3 - "$NET" "$W/tb_rst.sv" "$NDEC" <<'PYEOF'
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
exp_ones = sum(1 for i in range(ndec) if i % 3 == 0)
ROOTS = ['dut.HFSNET_120', 'dut.HFSNET_121', 'dut.HFSNET_122', 'dut.HFSNET_123',
         'dut.HFSNET_124']
L = ['`timescale 1ns/1ps', 'module tb_rst;']
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
L.append('    $display("RST %0s t=%0t rstn_srm=%b state=%b go_tgl=%b busy=%b done=%b total=%0d ones=%0d residue=%0d",')
L.append('      tag, $time, dut.u_srm_residue.rst_n, dut.u_srm_residue.state,')
L.append('      dut.u_srm_residue.go_tgl, srm_busy, srm_done, srm_total_count, srm_ones_count, srm_residue_o);')
L.append('  end endtask')
L.append('  initial begin')
L.append('    // PHASE 1: hold the tie root at 1  => rst_n = 0 => blocks ARE reset')
for r in ROOTS:
    L.append("    force %s = 1'b1;" % r)
L.append('    #320; show("reset_asserted");')
L.append('    // PHASE 2: root -> 0 => rst_n = 1 => reset released (proper sequence)')
for r in ROOTS:
    L.append("    force %s = 1'b0;" % r)
L.append('    #100; show("reset_released");')
L.append('    srm_start = 1; #20; srm_start = 0;')
L.append('    #100; show("after_start");')
L.append('    for (i = 0; i < %d; i = i + 1) begin' % ndec)
L.append("      srm_decision_bit = ((i % 3) == 0) ? 1'b1 : 1'b0;")
L.append('      srm_decision_valid = 1; #80; srm_decision_valid = 0; #40;')
L.append('    end')
L.append('    show("after_decisions");')
L.append('    #8000; show("late");')
L.append('    $display("RST_EXPECT ones should be %d of %d if the estimator counts correctly");' % (exp_ones, ndec))
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('TB written: %d lines ; expectation ones=%d of %d' % (len(L), exp_ones, ndec))
PYEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_rst $CELLS $NET $W/tb_rst.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -m3 -E '^Error|Error-\[' $W/build.log | sed 's/^/  /'
if [ -x $W/simv_rst ]; then
    timeout 900 $W/simv_rst -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    grep -a -E 'RST |RST_EXPECT' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== V2H_DONE ==="
