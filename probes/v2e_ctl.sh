#!/bin/bash
# V2 round 5: the CORRECTED control.  Round 4's control forced the wrong nets -- the
# value that matters is the PARENT net HFSNET_124 (it feeds the inverter that drives
# rst_n).  This run forces the five parent roots AND the child ports, prints the reset
# values, and fixes the broken differ (it used to compare lines containing TIEVAL itself).
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2e
rm -rf $W; mkdir -p $W
NDEC=22

python3 - "$NET" "$W/tb_ctl.sv" "$NDEC" <<'PYEOF'
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

FORCE = ['dut.HFSNET_120', 'dut.HFSNET_121', 'dut.HFSNET_122', 'dut.HFSNET_123',
         'dut.HFSNET_124',
         'dut.u_srm_residue.HFSNET_5', 'dut.u_srm_residue.HFSNET_7',
         'dut.u_srm_residue.HFSNET_8',
         'dut.u_calib_ctrl.HFSNET_330', 'dut.u_calib_ctrl.HFSNET_346',
         'dut.u_calib_ctrl.HFSNET_362', 'dut.u_calib_ctrl.HFSNET_363',
         'dut.u_calib_ctrl.HFSNET_364']

L = ['`timescale 1ns/1ps', 'module tb_ctl;']
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
L.append('  initial begin')
for f in FORCE:
    L.append("    force %s = `TIEVAL;" % f)
L.append('  end')
L.append('  task show; input [255:0] tag; begin')
L.append('    $display("CTL %0s rstn_calib=%b rstn_srm=%b busy=%b done=%b total=%0d ones=%0d residue=%0d",')
L.append('      tag, dut.u_calib_ctrl.rst_n, dut.u_srm_residue.rst_n, srm_busy, srm_done,')
L.append('      srm_total_count, srm_ones_count, srm_residue_o);')
L.append('  end endtask')
L.append('  initial begin')
L.append('    #300; show("reset_released");')
L.append('    srm_start = 1; #20; srm_start = 0;')
L.append('    #100; show("after_start");')
L.append('    for (i = 0; i < %d; i = i + 1) begin' % ndec)
L.append("      srm_decision_bit = ((i % 3) == 0) ? 1'b1 : 1'b0;")
L.append('      srm_decision_valid = 1; #80; srm_decision_valid = 0; #40;')
L.append('    end')
L.append('    show("after_decisions");')
L.append('    #6000; show("late");')
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('TB written: %d lines ; expected ones = %d of %d' % (len(L), exp_ones, ndec))
PYEOF

cd $W || exit 1
for V in 0 1; do
    echo ""
    echo "################ HFSNET roots forced to $V ################"
    timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
          +define+TIEVAL=$V -o $W/simv_$V $CELLS $NET $W/tb_ctl.sv -l $W/build_$V.log > $W/build_$V.out 2>&1
    echo "  vcs rc=$?  $(grep -a -m1 -E '^Error|Error-\[' $W/build_$V.log)"
    if [ -x $W/simv_$V ]; then
        timeout 900 $W/simv_$V -l $W/run_$V.log > $W/run_$V.out 2>&1
        echo "  sim rc=$?"
        grep -a 'CTL ' $W/run_$V.log | sed 's/^/    /'
    else
        echo "  NO BINARY"
    fi
done
echo ""
echo "############ comparison (parameter stripped from both sides) ############"
if [ -s $W/run_0.log ] && [ -s $W/run_1.log ]; then
    diff <(grep -a 'CTL ' $W/run_0.log) <(grep -a 'CTL ' $W/run_1.log) > $W/diff.txt && \
        echo "  IDENTICAL behaviour for roots=0 and roots=1" || { echo "  DIFFERENT:"; cat $W/diff.txt | sed 's/^/    /'; }
fi
echo "=== V2E_DONE ==="
