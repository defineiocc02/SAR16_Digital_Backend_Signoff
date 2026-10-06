from pathlib import Path
import json,collections,sys
R=Path(__file__).resolve().parents[3];O=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else R/'sar16_rework_20261005/optimization';F=O/'formal';MOD='sar_calib_ctrl_serial'
def load(n):return json.loads((F/(n+'.json')).read_text())['modules'][MOD]
def regs(m):return sorted([(c['connections']['Q'][0],n,c) for n,c in m['cells'].items() if c['type'].startswith('$_DFF_')])
def aliases(m):
 a=collections.defaultdict(set)
 for n,w in m['netnames'].items():
  if not n.startswith('$'):
   for i,b in enumerate(w['bits']):a[b].add((n,i))
 return a
M={n:load(n) for n in ['old','new']}; RS={n:regs(m) for n,m in M.items()}; A={n:aliases(m) for n,m in M.items()}; IDX={n:{b:i for i,(b,_,_) in enumerate(rs)} for n,rs in RS.items()}
for n,m in M.items():
 c=json.loads(json.dumps(m));rs=RS[n]
 assert all(cell['type'] in ['$_DFF_PN0_','$_DFF_PN1_'] for _,_,cell in rs)
 for _,k,_ in rs:del c['cells'][k]
 assert all(cell['type'] in ['$_AND_','$_OR_','$_XOR_','$_XNOR_','$_NOT_','$_MUX_'] for cell in c['cells'].values())
 for port,pin,direction in [('eq_q','Q','input'),('eq_d','D','output'),('eq_c','C','output'),('eq_r','R','output')]:
  bits=[cell['connections'][pin][0] for _,_,cell in rs];c['ports'][port]={'direction':direction,'bits':bits};c['netnames'][port]={'hide_name':0,'bits':bits,'attributes':{}}
 (F/(n+'_comb.json')).write_text(json.dumps({'modules':{n+'_comb':c}}))
N=len(RS['old']);G=len(RS['new']);ports=M['old']['ports'];lines=['module storage_equivalence(',f'input [{N-1}:0] arbitrary_q,']
lines+=[',\n'.join(f"input [{len(w['bits'])-1}:0] {p}" for p,w in ports.items() if w['direction']=='input')+', output proof_ok);']
lines += [f'wire [{N-1}:0] oq,od,oc,orr;',f'wire [{G-1}:0] nq,nd,nc,nrr;']
const={}
for i in range(20):
 obits=M['old']['netnames'][f'shadow_weights[{i}]']['bits']; nbits=M['new']['netnames'][f'shadow_weights[{i}]']['bits']
 if all(b in ['0','1'] for b in nbits):
  for k,b in enumerate(obits):
   assert isinstance(b,int); const[IDX['old'][b]]=int(nbits[k])
for i in range(N):lines.append(f"assign oq[{i}] = 1'b{const[i]};" if i in const else f'assign oq[{i}] = arbitrary_q[{i}];')
oldaliases={a:b for b in IDX['old'] for a in A['old'][b]};mapping=[];props=[];covered=set(const)
def prop(name,expr):
 k=len(props);lines.append(f'wire cmp_{k} = ({expr});');props.append({'name':name,'expr':expr})
for j,(b,k,c) in enumerate(RS['new']):
 matches={oldaliases[a] for a in A['new'][b] if a in oldaliases};assert len(matches)==1,(j,k,matches)
 ob=matches.pop();i=IDX['old'][ob];assert i not in const
 assert RS['old'][i][2]['type']==c['type'];covered.add(i)
 lines.append(f'assign nq[{j}] = oq[{i}];')
 for label,x,y in [('data','od','nd'),('clock','oc','nc'),('async_reset','orr','nrr')]:prop(k+' '+label,f'{x}[{i}] == {y}[{j}]')
 mapping.append({'old_index':i,'new_index':j,'reset_value':int(c['type'][-2]),'common_aliases':sorted(A['old'][ob]&A['new'][b])})
assert covered==set(range(N))
for i,v in const.items():
 assert int(RS['old'][i][2]['type'][-2])==v
 prop(f'trusted constant next-state bit {i}',f"od[{i}] == 1'b{v}")
def vector(n,var):return '{'+','.join(var+'['+str(IDX['old'][b])+']' for b in M['old']['netnames'][n]['bits'][::-1])+'}'
first=sum(int(RS['old'][IDX['old'][b]][2]['type'][-2])<<k for k,b in enumerate(M['old']['netnames']['target_bit']['bits']))
for n in ['target_bit','wr_idx_r']:
 lines.append(f'wire [4:0] {n}_q = {vector(n,"oq")};')
 lines.append(f'wire [4:0] {n}_d = {vector(n,"od")};')
 prop(n+' remains legal',f"{n}_d >= 5'd{first} && {n}_d <= 5'd19")
lines.append(f"wire invariant = target_bit_q >= 5'd{first} && target_bit_q <= 5'd19 && wr_idx_r_q >= 5'd{first} && wr_idx_r_q <= 5'd19;")
conns={'old':[],'new':[]};outbits=0
for p,w in ports.items():
 assert w['direction']==M['new']['ports'][p]['direction'] and len(w['bits'])==len(M['new']['ports'][p]['bits'])
 if w['direction']=='input':
  for n in conns:conns[n].append(f'.{p}({p})')
 else:
  W=len(w['bits']);outbits+=W
  for n in conns:lines.append(f'wire [{W-1}:0] {n}_{p};');conns[n].append(f'.{p}({n}_{p})')
  prop('all bits of output '+p,f'old_{p} == new_{p}')
for n,p in [('old','o'),('new','n')]:lines.append(f'{n}_comb u_{n}('+','.join(conns[n]+[f'.eq_q({p}q)',f'.eq_d({p}d)',f'.eq_c({p}c)',f'.eq_r({p}rr)'])+');')
lines += ['assign proof_ok = !invariant || (&{'+','.join(f'cmp_{i}' for i in range(len(props)))+'});','endmodule']
(F/'storage_equivalence.sv').write_text('\n'.join(lines)+'\n')
(F/'storage_equivalence.ys').write_text(f'''read_json {F}/old_comb.json
read_json {F}/new_comb.json
read_verilog -sv {F}/storage_equivalence.sv
hierarchy -top storage_equivalence
proc
flatten
opt
sat -verify -prove proof_ok 1 -show-inputs -show-outputs -dump_vcd {F}/counterexample.vcd
''')
(F/'storage_equivalence_coverage.json').write_text(json.dumps({'old_state_bits':N,'new_state_bits':G,'removed_constant_state_bits':len(const),'output_bits':outbits,'obligations':props,'mapping':mapping,'constant_state':const,'reset_value_equality':'checked exhaustively for every mapped/constant bit from actual $_DFF_PN[01]_ cell types','assumptions':f'target_bit and wr_idx_r in {first}..19 and old trusted constants, independently reset-inductively proven; start_calib and comp_out arbitrary; all nonremoved state bits otherwise arbitrary'},indent=2))
print(N,G,len(const),outbits,len(props))
