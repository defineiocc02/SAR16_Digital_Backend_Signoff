from pathlib import Path
R=Path(__file__).resolve().parents[3]; O=R/'sar16_rework_20261005/optimization'
s=(R/'sar16_repair_20261005/rtl_frozen/sar_calib_ctrl_serial.sv').read_text()
assert s.count('endmodule')==1
s=s.replace('endmodule','''
    // Proof-only instrumentation: strengthened inductive invariant.
    // No constraints on start_calib or comp_out; reset is applied at frame 1.
    always_comb begin
        if (rst_n) begin
            assert(target_bit >= FIRST_TARGET_BIT && target_bit <= LAST_TARGET_BIT);
            assert(wr_idx_r >= FIRST_TARGET_BIT && wr_idx_r <= LAST_TARGET_BIT);
            assert(state != S_UPDATE_WEIGHT || wr_idx_r > MAX_CALIB_BIT);
            for (int k=0; k<=MAX_CALIB_BIT; k=k+1)
                assert(shadow_weights[k] == (REF_WEIGHT_INIT <<< k));
        end
    end
endmodule''')
(O/'formal/baseline_invariant.sv').write_text(s)
(O/'formal/baseline_invariant.ys').write_text(f'''read_verilog -formal -sv -D SYNTHESIS {O}/formal/baseline_invariant.sv
prep -top sar_calib_ctrl_serial -flatten
memory_map
opt
async2sync
dffunmap
opt
sat -seq 3 -tempinduct -maxsteps 8 -set-at 1 rst_n 0 -prove-asserts -verify -show-inputs -show-outputs
''')
