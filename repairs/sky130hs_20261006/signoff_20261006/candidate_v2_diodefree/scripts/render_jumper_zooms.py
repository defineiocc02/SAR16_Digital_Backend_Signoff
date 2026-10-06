import matplotlib
matplotlib.use('Agg')
from matplotlib import pyplot as plt
from matplotlib.patches import Polygon,Rectangle
from matplotlib.collections import PatchCollection
import json
from pathlib import Path
w=Path(__file__).resolve().parent.parent;data=json.loads((w/'reports/jumper_zoom_geometry.json').read_text());colors={'LI':'#d96859','M1':'#418cc2','M2':'#c9579c','M3':'#398b75','M4':'#7970b2','VIA3':'#e6b549','MCON':'#e6b549','VIA1':'#d8b84f'}
for v in data['views']:
 fig,axes=plt.subplots(1,2,figsize=(12.4,6.0),dpi=180)
 for ax,state in zip(axes,['before','after']):
  for name,layer,dt in v['layers']:
   ax.add_collection(PatchCollection([Polygon(p,closed=True) for p in v['states'][state][name]],facecolor=colors[name],edgecolor='#294356',linewidth=.65,alpha=.75 if name.startswith('M') and name!='MCON' else .90))
  if state=='after':ax.annotate(v['annotation'],xy=v['anchor'],xytext=v['text'],ha='center',va='center',color='#132e45',fontsize=10,arrowprops=dict(arrowstyle='->',color='#132e45',lw=1.1))
  b=v['bbox'];ax.set_xlim(b[0],b[2]);ax.set_ylim(b[1],b[3]);ax.set_aspect('equal');ax.grid(alpha=.15);ax.set_xlabel('X (µm)');ax.set_ylabel('Y (µm)');ax.ticklabel_format(style='plain',useOffset=False);ax.set_title('Before: candidate v1 routing' if state=='before' else 'After: final diode-free candidate v2',fontsize=11,pad=10)
 fig.suptitle(v['title'],fontsize=16,fontweight='bold',y=.97);fig.text(.5,.915,v['net'],ha='center',fontsize=11,color='#526070')
 handles=[Rectangle((0,0),1,1,color=colors[n],alpha=.8) for n,_,_ in v['layers']]
 fig.legend(handles,[f'{n} ({l}/{dt})' for n,l,dt in v['layers']],loc='lower center',ncol=len(handles),bbox_to_anchor=(.5,.068),frameon=False)
 fig.text(.5,.035,'Actual full GDS polygons · Final candidate antenna: 0 net / 0 pin violations · Original rule and gate/diffusion models',ha='center',fontsize=9,color='#526070')
 fig.subplots_adjust(left=.065,right=.98,top=.845,bottom=.2,wspace=.20)
 fig.savefig(w/'images'/f'jumper_{v["id"]}.png',facecolor='white');plt.close(fig)
print('Rendered three final-v2 GDS jumper views')
