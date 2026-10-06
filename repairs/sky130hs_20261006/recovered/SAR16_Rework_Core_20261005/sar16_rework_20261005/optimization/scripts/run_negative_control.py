from pathlib import Path
import subprocess,shutil,json
R=Path(__file__).resolve().parents[3];O=R/'sar16_rework_20261005/optimization';D=O/'negative_control';F=D/'formal';L=D/'logs';F.mkdir(parents=True,exist_ok=True);L.mkdir(exist_ok=True)
s=(R/'sar16_rework_20261005/repo/rtl_optimized/sar_calib_ctrl_serial.sv').read_text();needle='weight_r <= calc_result_r[WEIGHT_WIDTH-1:0];';assert s.count(needle)==1;s=s.replace(needle,"weight_r <= calc_result_r[WEIGHT_WIDTH-1:0] ^ WEIGHT_WIDTH'(1);")
(F/'mutated_calib.sv').write_text(s)
shutil.copy(O/'formal/old.json',F/'old.json')
s=(O/'formal/new.ys').read_text().replace(str(O),str(D)).replace(str(R/'sar16_rework_20261005/repo/rtl_optimized/sar_calib_ctrl_serial.sv'),str(F/'mutated_calib.sv'))
(F/'new.ys').write_text(s)
with (L/'new_normalize.log').open('w') as log:subprocess.run(['yosys-native','-s',str(F/'new.ys')],stdout=log,stderr=subprocess.STDOUT,check=True)
subprocess.run(['python3',str(O/'scripts/prove_state_relation.py'),str(D)],check=True)
with (L/'storage_equivalence.log').open('w') as log:cp=subprocess.run(['yosys-native','-s',str(F/'storage_equivalence.ys')],stdout=log,stderr=subprocess.STDOUT)
t=(L/'storage_equivalence.log').read_text();detected=cp.returncode!=0 and 'proof did fail' in t
result={'mutation':'XOR bit 0 of every measured weight on writeback; production RTL untouched','expected':'proof failure','detected':detected,'returncode':cp.returncode,'counterexample':'negative_control/formal/counterexample.vcd'};(O/'reports/negative_control.json').write_text(json.dumps(result,indent=2)+'\n');print(result)
assert detected
