import matplotlib
matplotlib.use('Agg')
from matplotlib import pyplot as plt
from matplotlib.patches import Polygon,Rectangle
from matplotlib.collections import PatchCollection
import json
from pathlib import Path
w=Path(__file__).resolve().parent.parent; data=json.loads((w/'reports/li_zoom_geometry.json').read_text())
colors={'LI':'#e45756','MCON':'#e7b237','M1':'#327bb3'}
for v in data['views']:
 fig,axes=plt.subplots(1,2,figsize=(12,6.7),dpi=180)
 for ax,state in zip(axes,['before','after']):
  for name in ['M1','LI','MCON']:
   patches=[Polygon(p,closed=True) for p in v['layers'][state][name]]
   ax.add_collection(PatchCollection(patches,facecolor=colors[name],edgecolor='#394451',linewidth=.55,alpha=.60 if name=='M1' else .88,zorder={'M1':1,'LI':2,'MCON':3}[name]))
  old,new=v['old_center_um'],v['new_center_um'];active=old if state=='before' else new
  ax.add_patch(Rectangle((active[0]-.105,active[1]-.105),.21,.21,fill=False,color='#071e3d',linewidth=1.8,zorder=10))
  ax.annotate('CLK access via',xy=active,xytext=(active[0]+.45,active[1]-.6),fontsize=10,color='#071e3d',arrowprops=dict(arrowstyle='->',color='#071e3d'),zorder=12)
  if state=='after':
   ax.add_patch(Rectangle((old[0]-.085,old[1]-.085),.17,.17,fill=False,color='#202020',linewidth=1,linestyle='--',zorder=11))
   ax.annotate('',xy=(old[0]-.27,new[1]),xytext=(old[0]-.27,old[1]),arrowprops=dict(arrowstyle='<->',lw=1.2,color='#172e3d'),zorder=12)
   ax.text(old[0]-.45,(old[1]+new[1])/2-.03,'0.185 µm',fontsize=9,rotation=90,ha='center',va='center',color='#172e3d',zorder=12)
  b=v['bbox_um'];ax.set_xlim(b[0],b[2]);ax.set_ylim(b[1],b[3]);ax.set_aspect('equal');ax.grid(alpha=.14);ax.set_xlabel('X (µm)');ax.set_ylabel('Y (µm)');ax.ticklabel_format(style='plain',useOffset=False)
  ax.set_title('Before: access crosses native pin notch' if state=='before' else 'After: access inside native CLK pin',fontsize=11,pad=12)
 handles=[Rectangle((0,0),1,1,color=colors[n],alpha=.88) for n in ['LI','MCON','M1']]
 fig.legend(handles,['Local interconnect (67/20)','MCON contact (67/44)','Metal1 (68/20)'],loc='lower center',ncol=3,bbox_to_anchor=(.5,.055),frameon=False)
 fig.suptitle(f'SKY130HS routing repair · {v["instance"]} / CLK',fontsize=17,fontweight='bold',y=.965)
 fig.text(.5,.915,v['net'],ha='center',fontsize=11,color='#526070')
 fig.text(.5,.03,'Rendered from complete before/after GDS geometry · All coordinates in µm · Standard-cell masters unchanged',ha='center',fontsize=9,color='#526070')
 fig.subplots_adjust(left=.07,right=.98,top=.845,bottom=.19,wspace=.20)
 name='li_access_'+v['instance'].strip('_')+'.png';fig.savefig(w/'images'/name,facecolor='white');plt.close(fig)
print('Generated three actual-GDS before/after routing zooms')
