import json,collections
from pathlib import Path
O=Path('/workspace/scratch/5988101d3fa5/sar16_rework_20261005/equivalence/results')
def load(n):return json.loads((O/(n+'.json')).read_text())['modules']['sar_digi_paper_core']
def qs(m):return {c['connections']['Q'][0]:(n,c) for n,c in m['cells'].items() if c['type'].startswith('$_DFF_')}
def aliases(m):
 a=collections.defaultdict(set)
 for n,w in m['netnames'].items():
  if not n.startswith('$'):
   for i,b in enumerate(w['bits']):a[b].add((n,i))
 return a
r=load('rtl');rq=qs(r);ra=aliases(r)
for k in ['ng_mapped','ng_routed','gf_mapped','gf_routed']:
 if not (O/(k+'.json')).exists():continue
 g=load(k);gq=qs(g);ga=aliases(g);rnames={a:b for b in rq for a in ra[b]}; missing=[];conflict=[]
 for b in gq:
  match={rnames[a] for a in ga[b] if a in rnames and a[0]!='u_srm_residue.state'}
  if not match:missing.append((b,sorted(ga[b])))
  if len(match)>1:conflict.append((b,match))
 print(k,'regbits',len(gq),'unmatched',len(missing),'conflict',len(conflict)); print('unmatched',missing[:20]);print('conflict',conflict[:10])
