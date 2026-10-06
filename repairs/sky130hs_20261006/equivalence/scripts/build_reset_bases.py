from pathlib import Path
import os
import json
ROOT=Path('/workspace/scratch/5988101d3fa5');OUT=Path(os.environ.get('EQ_OUT', str(Path(__file__).resolve().parents[1])))
def load(n):return json.loads((OUT/'results'/(n+'.json')).read_text())['modules']['sar_digi_paper_core']
def regs(m):return sorted([(c['connections']['Q'][0],n,c) for n,c in m['cells'].items() if c['type'].startswith('$_DFF_')])
for n in ['rtl',*json.loads((OUT/'config.json').read_text())['netlists']]:
 if not (OUT/'results'/f'{n}.json').exists():continue
 m=load(n);rs=regs(m);m['attributes']={};m['cells']={k:c for k,c in m['cells'].items() if c['type']!='$scopeinfo'}
 bits=[bit for bit,_,_ in rs]; m['ports']['eq_q']={'direction':'output','bits':bits};m['netnames']['eq_q']={'hide_name':0,'bits':bits,'attributes':{}}
 (OUT/'results'/f'{n}_full.json').write_text(json.dumps({'modules':{n+'_full':m}}))
for label in [p.stem[:-len('_coverage')] for p in sorted((OUT/'results').glob('*_coverage.json'))]:
 if not (OUT/'results'/f'{label}_coverage.json').exists():continue
 cov=json.loads((OUT/'results'/f'{label}_coverage.json').read_text()); a=cov['gold'];b=cov['gate'];rm=load(a);gm=load(b);rr=regs(rm);gr=regs(gm);ri={bit:i for i,(bit,_,_) in enumerate(rr)}
 lines=[f'module {label}_reset(']; decl=[]; conns={'r':[],'g':[]};checks=["(^rq !== 1'bx)","(^gq !== 1'bx)"]
 for p,w in rm['ports'].items():
  if w['direction']=='input':
   decl.append(f'input [{len(w["bits"])-1}:0] {p}')
   for side in conns:conns[side].append(f'.{p}({p})')
 lines.append(','.join(decl)+',output proof_ok);')
 for p in cov['power_ports']:
  lines.append(f"wire supply_{p}=1'b{1 if p=='VDD' else 0};");conns['g'].append(f'.{p}(supply_{p})')
 lines.extend([f'wire [{len(rr)-1}:0] rq;',f'wire [{len(gr)-1}:0] gq;'])
 if a=='rtl':
  fs=rm['netnames']['u_srm_residue.state']['bits'];lines.append('wire [2:0] fsm_q={'+','.join(f'rq[{ri[x]}]' for x in fs[::-1])+'};');checks.append("fsm_q <= 3'd5")
 for mp in cov['state_mapping']:
  j=mp['gate_index']
  if mp['kind']=='identity':checks.append(f'(rq[{mp["rtl_index"]}] === gq[{j}])')
  else:checks.append(f"((fsm_q == 3'd{mp['rtl_state_value']}) === gq[{j}])")
 for side,n in [('r',a),('g',b)]:lines.append(f'{n}_full {side}('+','.join(conns[side]+[f'.eq_q({side}q)'])+');')
 lines.append('assign proof_ok=&{'+','.join('('+x+')' for x in checks)+'};');lines.append('endmodule')
 (OUT/'results'/f'{label}_reset.sv').write_text('\n'.join(lines))
 ys=f'''read_json {OUT/'results'/f'{a}_full.json'}
read_json {OUT/'results'/f'{b}_full.json'}
read_verilog -formal -sv {OUT/'results'/f'{label}_reset.sv'}
hierarchy -check -top {label}_reset
flatten
clk2fflogic
opt
check -assert
sat -enable_undef -set-def-inputs -seq 4 -set-at 1 rst_n 0 -set-at 2 rst_n 0 -prove-skip 1 -prove proof_ok 1 -show-ports -dump_json {OUT/'results'/f'{label}_reset_cex.json'} -dump_vcd {OUT/'results'/f'{label}_reset_cex.vcd'} -verify
'''
 (OUT/'scripts'/f'{label}_reset.ys').write_text(ys)
 print(label,'initial relation checks',len(checks),flush=True)
