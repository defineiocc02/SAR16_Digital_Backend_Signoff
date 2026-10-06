from pathlib import Path
R=Path(__file__).resolve().parents[3];O=R/'sar16_rework_20261005/optimization'
for n,p in [('old',R/'sar16_repair_20261005/rtl_frozen'),('new',R/'sar16_rework_20261005/repo/rtl_optimized')]:
 (O/f'formal/{n}.ys').write_text(f'''read_verilog -sv -D SYNTHESIS {p}/sar_calib_ctrl_serial.sv
hierarchy -top sar_calib_ctrl_serial
proc
flatten
opt
memory_map
opt
techmap
opt
dffunmap
opt_clean
write_json {O}/formal/{n}.json
''')
