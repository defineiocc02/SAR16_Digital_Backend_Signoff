#!/bin/bash
# V2 round 2: (a) control experiment -- does the undriven tie value change behaviour?
#              (b) first independent functional expectation -- the SRM decision counters.
# Same testbench, compiled twice with +define+TIEVAL=0 and =1; the tie root nets are
# FORCED so the value is controlled rather than left to the model's z-resolution.
# The decision pattern is generated here, so the expected ones/total counts are known
# independently of the RTL.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2b
rm -rf $W; mkdir -p $W
NDEC=22

python3 - "$NET" "$W/tb_tie.sv" "$NDEC" <<'PYEOF'
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

# independent expectation for the decision pattern bit = (i % 3 == 0)
exp_ones = sum(1 for i in range(ndec) if i % 3 == 0)
L = ['`timescale 1ns/1ps', 'module tb_tie;']
for p in ins:
    L.append('  reg %s;' % p)
for p in outs:
    L.append('  wire %s;' % p)
L.append('  integer i; integer errors = 0;')
L.append('  reg [9:0] seen_residue; integer seen_total, seen_ones, seen_done;')
L.append('  sar_digi_paper_core dut (\n    %s\n  );'
         % ',\n    '.join('.%s(%s)' % (nm(p), nm(p)) for p in ports))
L.append('  initial begin')
for p in ins:
    L.append('    %s = 0;' % nm(p))
L.append('  end')
L.append('  initial clk = 0; always #5 clk = ~clk;')
L.append('  initial dec_clk = 0; always #10 dec_clk = ~dec_clk;')
L.append('  // CONTROL: force the undriven tie root nets to a chosen value')
L.append('  initial begin')
for path in ('dut.u_srm_residue.HFSNET_5', 'dut.u_srm_residue.HFSNET_7',
             'dut.u_srm_residue.HFSNET_8', 'dut.u_calib_ctrl.HFSNET_330',
             'dut.u_calib_ctrl.HFSNET_346', 'dut.u_calib_ctrl.HFSNET_362',
             'dut.u_calib_ctrl.HFSNET_363', 'dut.u_calib_ctrl.HFSNET_364'):
    L.append("    force %s = `TIEVAL;" % path)
L.append('  end')
L.append('  initial begin')
L.append('    #20; rst_n = 0; #200; rst_n = 1; #100;')
L.append('    // start the SRM estimator')
L.append('    srm_start = 1; #20; srm_start = 0;')
L.append('    #200;')
L.append('    // present %d decisions, one every 8 clk, bit = (i %% 3 == 0)' % ndec)
L.append('    for (i = 0; i < %d; i = i + 1) begin' % ndec)
L.append("      srm_decision_bit = ((i % 3) == 0) ? 1'b1 : 1'b0;")
L.append('      srm_decision_valid = 1; #80; srm_decision_valid = 0; #40;')
L.append('    end')
L.append('    // wait for completion')
L.append('    for (i = 0; i < 4000; i = i + 1) begin')
L.append('      #20; if (srm_done === 1\'b1) i = 4000;')
L.append('    end')
L.append('    seen_total = srm_total_count; seen_ones = srm_ones_count;')
L.append('    seen_done  = srm_done;        seen_residue = srm_residue_o;')
L.append('    $display("TIE_RESULT TIEVAL=%0d done=%0d total=%0d ones=%0d residue=%0d busy=%0d shortfall=%0d stalled=%0d",')
L.append('             `TIEVAL, seen_done, seen_total, seen_ones, seen_residue, srm_busy, srm_count_shortfall, srm_stalled);')
L.append('    $display("TIE_EXPECT  decisions_presented=%d expected_ones=%d (bit = i mod 3 == 0)");'
         % (ndec, exp_ones))
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('TB written: %d lines ; independent expectation: ones=%d of %d' % (len(L), exp_ones, ndec))
PYEOF

cd $W || exit 1
for V in 0 1; do
    echo ""
    echo "################ TIEVAL=$V ################"
    timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
          +define+TIEVAL=$V -o $W/simv_$V $CELLS $NET $W/tb_tie.sv -l $W/build_$V.log > $W/build_$V.out 2>&1
    echo "  vcs rc=$?"
    grep -a -m2 -E '^Error|Error-\[' $W/build_$V.log | sed 's/^/    /'
    if [ -x $W/simv_$V ]; then
        timeout 900 $W/simv_$V -l $W/run_$V.log > $W/run_$V.out 2>&1
        echo "  sim rc=$?"
        grep -a -E 'TIE_RESULT|TIE_EXPECT' $W/run_$V.log | sed 's/^/    /'
    else
        echo "  NO BINARY"
    fi
done
echo ""
echo "############ do the two runs differ? ############"
if [ -s $W/run_0.log ] && [ -s $W/run_1.log ]; then
    if diff <(grep -a 'TIE_RESULT' $W/run_0.log) <(grep -a 'TIE_RESULT' $W/run_1.log) > /dev/null; then
        echo "  IDENTICAL behaviour for TIEVAL=0 and TIEVAL=1"
    else
        echo "  DIFFERENT behaviour:"; diff <(grep -a 'TIE_RESULT' $W/run_0.log) <(grep -a 'TIE_RESULT' $W/run_1.log) | sed 's/^/    /'
    fi
fi
echo "=== V2B_DONE ==="
