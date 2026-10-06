from pathlib import Path
import json,sys
R=Path(__file__).resolve().parents[3];O=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else R/'sar16_rework_20261005/optimization';F=O/'formal'
def load(n):return json.loads((F/(n+'.json')).read_text())['modules']['sar_calib_ctrl_serial']
def regs(m):return sorted([(c['connections']['Q'][0],n,c) for n,c in m['cells'].items() if c['type'].startswith('$_DFF_')])
M={n:load(n) for n in ['old','new']};cov=json.loads((F/'storage_equivalence_coverage.json').read_text());N=cov['old_state_bits'];G=cov['new_state_bits'];lines=['module reset_base(',','.join(f"input [{len(w['bits'])-1}:0] {p}" for p,w in M['old']['ports'].items() if w['direction']=='input')+',output proof_ok);',f'wire [{N-1}:0] oq;',f'wire [{G-1}:0] nq;'];props=[];conns={'old':[],'new':[]}
for p,w in M['old']['ports'].items():
 if w['direction']=='input':
  for n in conns:conns[n].append(f'.{p}({p})')
 else:
  for n in conns:lines.append(f"wire [{len(w['bits'])-1}:0] {n}_{p};");conns[n].append(f'.{p}({n}_{p})')
  props.append(f'(old_{p} == new_{p})')
for mapping in cov['mapping']:props.append(f"(oq[{mapping['old_index']}] == nq[{mapping['new_index']}])")
for i,v in cov['constant_state'].items():props.append(f"(oq[{i}] == 1'b{v})")
for n,p in [('old','o'),('new','n')]:
 m=M[n];bits=[b for b,_,_ in regs(m)];m['ports']['eq_q']={'direction':'output','bits':bits};m['netnames']['eq_q']={'hide_name':0,'bits':bits,'attributes':{}}
 (F/(n+'_seq.json')).write_text(json.dumps({'modules':{n+'_seq':m}}));lines.append(f'{n}_seq u_{n}('+','.join(conns[n]+[f'.eq_q({p}q)'])+');')
lines+=['assign proof_ok = &{'+','.join(props)+'};','endmodule'];(F/'reset_base.sv').write_text('\n'.join(lines)+'\n')
(F/'reset_base.ys').write_text(f'''read_json {F}/old_seq.json
read_json {F}/new_seq.json
read_verilog -sv {F}/reset_base.sv
hierarchy -top reset_base
proc
flatten
async2sync
opt
sat -seq 1 -set rst_n 0 -verify -prove proof_ok 1 -show-inputs -show-outputs
''')
