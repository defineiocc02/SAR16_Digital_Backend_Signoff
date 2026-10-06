from pathlib import Path
import os
import json, collections, re
ROOT=Path('/workspace/scratch/5988101d3fa5'); OUT=Path(os.environ.get('EQ_OUT', str(Path(__file__).resolve().parents[1])))
def load(n):return json.loads((OUT/'results'/(n+'.json')).read_text())['modules']['sar_digi_paper_core']
def regs(m):return sorted([(c['connections']['Q'][0],n,c) for n,c in m['cells'].items() if c['type'].startswith('$_DFF_')])
def aliases(m):
 a=collections.defaultdict(set)
 for n,w in m['netnames'].items():
  if n in m['ports'] or n.startswith('u_'):
   for i,b in enumerate(w['bits']):a[b].add((n,i))
 return a
def emit_comb(n):
 m=load(n); rs=regs(m)
 assert all(c['type'] in ['$_DFF_PN0_','$_DFF_PN1_'] for _,_,c in rs)
 for _,name,_ in rs:del m['cells'][name]
 m['cells']={k:c for k,c in m['cells'].items() if c['type']!='$scopeinfo'}
 assert all(c['type'] in ['$_AND_','$_OR_','$_XOR_','$_XNOR_','$_NOT_','$_MUX_'] for c in m['cells'].values())
 m['attributes']={}
 for port,pin,direction in [('eq_q','Q','input'),('eq_d','D','output'),('eq_c','C','output'),('eq_r','R','output')]:
  bits=[c['connections'][pin][0] for _,_,c in rs];m['ports'][port]={'direction':direction,'bits':bits};m['netnames'][port]={'hide_name':0,'bits':bits,'attributes':{}}
 (OUT/'results'/f'{n}_comb.json').write_text(json.dumps({'creator':'build_state_miters.py; state outputs abstracted for explicit induction relation','modules':{n+'_comb':m}}))
for n in ['rtl',*json.loads((OUT/'config.json').read_text())['netlists']]:
 if (OUT/'results'/f'{n}.json').exists():emit_comb(n)

def generate(a,b,encoded=False):
 rm=load(a); gm=load(b); rr=regs(rm);gr=regs(gm);ra=aliases(rm);ga=aliases(gm)
 rbidx={bit:i for i,(bit,_,_) in enumerate(rr)}; gbidx={bit:i for i,(bit,_,_) in enumerate(gr)}
 rnames={alias:bit for bit in rbidx for alias in ra[bit]}; gs=gm['netnames']['u_srm_residue.state']['bits'];rs=rm['netnames']['u_srm_residue.state']['bits']
 fsm_enc=[0,4,2,1,5,3]
 label=a+'_to_'+b; lines=[f'module {label}(input [{len(rr)-1}:0] eq_q,']; ports=rm['ports']; pdecl=[]
 extra_ports=set(gm['ports'])-set(ports)
 assert extra_ports <= {'VDD','VSS'} and set(ports)<=set(gm['ports'])
 for p in extra_ports:
  assert gm['ports'][p]['direction']=='inout'
  pbits=set(gm['ports'][p]['bits'])
  assert not any(pbits & set(bits) for c in gm['cells'].values() if c['type']!='$scopeinfo' for bits in c.get('connections',{}).values()), 'Power port unexpectedly enters functional logic'
 for p,w in ports.items():
  assert w['direction']==gm['ports'][p]['direction'] and len(w['bits'])==len(gm['ports'][p]['bits'])
  if w['direction']=='input':pdecl.append(f'input [{len(w["bits"])-1}:0] {p}')
 lines+= [',\n'.join(pdecl)+', output proof_ok);']
 lines+=[f'wire [{len(rr)-1}:0] rd,rc,rr;',f'wire [{len(gr)-1}:0] gq,gd,gc,gr;']
 props=[];mapping=[]
 def prop(name,expr):
  i=len(props);lines.append(f'wire cmp_{i} = ({expr});');props.append({'index':i,'name':name,'expression':expr})
 if encoded:
  lines.append('wire [2:0] fsm_q = {'+','.join(f'eq_q[{rbidx[z]}]' for z in rs[::-1])+'};')
  lines.append('wire [2:0] fsm_d = {'+','.join(f'rd[{rbidx[z]}]' for z in rs[::-1])+'};')
  lines.append('wire valid_state = fsm_q <= 3\'d5;')
  prop('SRM FSM next-state legal','fsm_d <= 3\'d5')
 else:lines.append('wire valid_state = 1\'b1;')
 rmatched=set()
 for j,(bit,name,c) in enumerate(gr):
  if encoded and bit in gs:
   val=fsm_enc[gs.index(bit)];i=rbidx[rs[0]]
   lines.append(f'assign gq[{j}] = fsm_q == 3\'d{val};')
   prop(f'{name} encoded next-state',f'gd[{j}] === (fsm_d == 3\'d{val})')
   for rbit in rs: rmatched.add(rbit)
   assert int(c['type'][-2]) == int(val==0)
   for rbit in rs: assert rr[rbidx[rbit]][2]['type']=='$_DFF_PN0_'
   mapping.append({'gate_index':j,'gate_cell':name,'kind':'fsm_encoded','rtl_state_value':val,'gate_reset_value':int(c['type'][-2])})
  else:
   matches={rnames[x] for x in ga[bit] if x in rnames and not(encoded and x[0]=='u_srm_residue.state')}
   assert len(matches)==1,(a,b,name,matches)
   rbit=matches.pop();i=rbidx[rbit]; rmatched.add(rbit)
   assert rr[i][2]['type']==c['type'],(a,b,name,'reset value differs')
   lines.append(f'assign gq[{j}] = eq_q[{i}];')
   prop(f'{name} data',f'rd[{i}] === gd[{j}]')
   shared=sorted(ra[rbit]&ga[bit]);mapping.append({'gate_index':j,'gate_cell':name,'rtl_index':i,'rtl_cell':rr[i][1],'shared_aliases':shared,'kind':'identity','reset_value':int(c['type'][-2])})
  prop(f'{name} clock',f'rc[{i}] === gc[{j}]')
  prop(f'{name} async reset',f'rr[{i}] === gr[{j}]')
 assert rmatched==set(rbidx),(len(rmatched),len(rbidx))
 # Encoded state register is one vector with one clock and reset on the RTL side.
 if encoded:
  for rbit in rs[1:]:
   prop('SRM FSM homogeneous clock',f'rc[{rbidx[rs[0]]}] === rc[{rbidx[rbit]}]')
   prop('SRM FSM homogeneous reset',f'rr[{rbidx[rs[0]]}] === rr[{rbidx[rbit]}]')
 conns={'r':[],'g':[]}
 for p in extra_ports:
  val=1 if p=='VDD' else 0
  lines.append(f'wire supply_{p} = 1\'b{val};')
  conns['g'].append(f'.{p}(supply_{p})')
 output_bits=0
 for p,w in ports.items():
  width=len(w['bits'])
  if w['direction']=='input':
   for side in conns:conns[side].append(f'.{p}({p})')
  else:
   output_bits+=width
   for side in conns:
    lines.append(f'wire [{width-1}:0] {side}_{p};');conns[side].append(f'.{p}({side}_{p})')
   for idx in range(width):prop(f'output {p}[{idx}]',f'r_{p}[{idx}] === g_{p}[{idx}]')
 for side,n in [('r',a),('g',b)]:
  q='eq_q' if side=='r' else 'gq'
  lines.append(f'{n}_comb {side}('+','.join(conns[side]+[f'.eq_q({q})',f'.eq_d({side}d)',f'.eq_c({side}c)',f'.eq_r({side}r)'])+');')
 lines.append('assign proof_ok = !valid_state || (&{'+','.join('cmp_'+str(p['index']) for p in props)+'});')
 lines.append('endmodule')
 (OUT/'results'/f'{label}.sv').write_text('\n'.join(lines)+'\n')
 manifest={'label':label,'gold':a,'gate':b,'gold_state_bits':len(rr),'gate_state_bits':len(gr),'output_bits':output_bits,'proof_obligations':props,'state_mapping':mapping,'condition':'SRM state in 0..5' if encoded else 'none','power_ports':sorted(extra_ports)}
 (OUT/'results'/f'{label}_coverage.json').write_text(json.dumps(manifest,indent=2))
 script=f'''read_json {OUT/'results'/f'{a}_comb.json'}
read_json {OUT/'results'/f'{b}_comb.json'}
read_verilog -formal -sv {OUT/'results'/f'{label}.sv'}
hierarchy -check -top {label}
flatten
opt
check -assert
sat -enable_undef -set-def-inputs -prove proof_ok 1 -show-ports -dump_json {OUT/'results'/f'{label}_cex.json'} -dump_vcd {OUT/'results'/f'{label}_cex.vcd'} -verify
'''
 (OUT/'scripts'/f'{label}.ys').write_text(script)
 print(label,len(props),'obligations',output_bits,'output bits')
for a,b,e in [pair for tech in json.loads((OUT/'config.json').read_text())['libraries'] for pair in [('rtl',tech+'_mapped',True),(tech+'_mapped',tech+'_routed',False)]]:
 if (OUT/'results'/f'{a}.json').exists() and (OUT/'results'/f'{b}.json').exists():generate(a,b,e)
