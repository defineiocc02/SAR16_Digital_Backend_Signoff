import pya,json,os,hashlib
from pathlib import Path
w=Path(os.environ['SAR16_CANDIDATE']);sources={'before':w.parent/'candidate_v1/results/candidate.gds','after':w/'results/candidate.gds'};ls={};data={'sources':{},'views':[]}
for n,p in sources.items():
 l=pya.Layout();l.read(str(p));ls[n]=l;data['sources'][n]={'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'dbu_um':l.dbu}
views=[dict(id='clk',title='Clock input: 1.44 µm Metal4 bridge',net='clk',bbox=[179.1,197.2,182.4,198.8],layers=[('M3',70,20),('M4',71,20),('VIA3',70,44)],anchor=[180.72,197.95],text=[180.72,198.5],annotation='1.44 µm M4 bridge\nTwo M3–M4 contacts'),dict(id='clock_branch',title='Clock branch: lift terminal route to Metal4',net='clknet_4_8_0_clk',bbox=[88.9,225.2,91.5,227.0],layers=[('M3',70,20),('M4',71,20),('VIA3',70,44)],anchor=[90.12,226.07],text=[90.25,226.65],annotation='0.72 µm M4 link\nM3 landing extension'),dict(id='signal_m2',title='Signal branch: replace diode conductor with Metal2',net='_0827_',bbox=[335.7,227.6,337.4,229.0],layers=[('LI',67,20),('M1',68,20),('M2',69,20),('MCON',67,44),('VIA1',68,44)],anchor=[336.72,228.3],text=[336.15,228.85],annotation='M2 bridge with\ntwo M1–M2 contacts')]
for v in views:
 v['states']={};b=pya.Box(*[round(x*1000) for x in v['bbox']])
 for state,l in ls.items():
  c=l.cell('sar_digi_paper_core');shapes={}
  for name,layer,dt in v['layers']:
   r=pya.Region(c.begin_shapes_rec(l.layer(layer,dt)))&pya.Region(b)
   shapes[name]=[[[q.x*l.dbu,q.y*l.dbu] for q in p.each_point_hull()] for p in r.each_merged()]
  v['states'][state]=shapes
 data['views'].append(v)
(w/'reports/jumper_zoom_geometry.json').write_text(json.dumps(data,indent=2)+'\n')
