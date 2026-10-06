import pya, json, os, hashlib
from pathlib import Path
w=Path(os.environ['SAR16_CANDIDATE']); sources={'before':w.parent/'results/baseline.gds','after':w/'results/candidate.gds'}
edits=json.loads((w/'reports/access_edits.json').read_text()); data={'sources':{},'views':[]}
layouts={}
for name,path in sources.items():
 l=pya.Layout();l.read(str(path));layouts[name]=l
 data['sources'][name]={'path':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'dbu_um':l.dbu}
for e in edits:
 x,y=e['old_center_dbu'];bbox=[x-1150,y-1050,x+1150,y+1050]
 view={'instance':e['instance'],'net':e['net'],'old_center_um':[x/1000,y/1000],'new_center_um':[v/1000 for v in e['new_center_dbu']],'bbox_um':[v/1000 for v in bbox],'layers':{}}
 for state,l in layouts.items():
  c=l.cell('sar_digi_paper_core');box=pya.Box(*bbox);shapes={}
  for name,layer,datatype in [('LI',67,20),('MCON',67,44),('M1',68,20)]:
   region=pya.Region(c.begin_shapes_rec(l.layer(layer,datatype))) & pya.Region(box)
   shapes[name]=[[[p.x*l.dbu,p.y*l.dbu] for p in poly.each_point_hull()] for poly in region.each_merged()]
  view['layers'][state]=shapes
 data['views'].append(view)
(w/'reports/li_zoom_geometry.json').write_text(json.dumps(data,indent=2)+'\n')
