#!/bin/bash
# V2 round 6: why does the FSM never leave S_IDLE?  Print the block's own state and the
# start signal AT THE BLOCK BOUNDARY, with tight timing around the pulse.
set -u
PC=/home/<user>/sar16_work/proj_paper_core
NET=$PC/pnr/out/sar_digi_paper_core_pnr.v
CELLS=/home/<user>/Project/DESIGN/14BIT_ADC/smic18/digital/sc/verilog/smic18.v
W=/tmp/v2f
rm -rf $W; mkdir -p $W

python3 - "$NET" "$W/tb_st.sv" <<'PYEOF'
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
L = ['`timescale 1ns/1ps', 'module tb_st;']
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
L.append('  initial begin force dut.HFSNET_120 = 1\'b0; force dut.HFSNET_121 = 1\'b0;')
L.append('    force dut.HFSNET_122 = 1\'b0; force dut.HFSNET_123 = 1\'b0; force dut.HFSNET_124 = 1\'b0; end')
L.append('  task show; input [255:0] tag; begin')
L.append('    $display("ST %0s t=%0t rstn_srm=%b start_port=%b start_pin=%b state=%b go_tgl=%b busy=%b dec_run=%b dec_total=%0d",')
L.append('      tag, $time, dut.u_srm_residue.rst_n, srm_start, dut.u_srm_residue.start,')
L.append('      dut.u_srm_residue.state, dut.u_srm_residue.go_tgl, srm_busy, dut.u_srm_residue.dec_run, dut.u_srm_residue.dec_total);')
L.append('  end endtask')
L.append('  initial begin')
L.append('    #320; show("idle");')
L.append('    srm_start = 1; #12; show("pulse_hi");')
L.append('    srm_start = 0; #20; show("pulse_lo_1");')
L.append('    #200; show("later");')
L.append('    #2000; show("late");')
L.append('    $finish;')
L.append('  end')
L.append('endmodule')
io.open(out, 'w', newline='\n').write('\n'.join(L) + '\n')
print('TB written: %d lines' % len(L))
PYEOF

cd $W || exit 1
timeout 1800 vcs -full64 -sverilog +v2k -timescale=1ns/1ps +nospecify +notimingcheck \
      -o $W/simv_st $CELLS $NET $W/tb_st.sv -l $W/build.log > $W/build.out 2>&1
echo "vcs rc=$?"
grep -a -m3 -E '^Error|Error-\[|Warning-\[?' $W/build.log | head -4 | sed 's/^/  /'
if [ -x $W/simv_st ]; then
    timeout 900 $W/simv_st -l $W/run.log > $W/run.out 2>&1
    echo "sim rc=$?"
    grep -a 'ST ' $W/run.log
else
    echo "NO BINARY"
fi
echo "=== V2F_DONE ==="
