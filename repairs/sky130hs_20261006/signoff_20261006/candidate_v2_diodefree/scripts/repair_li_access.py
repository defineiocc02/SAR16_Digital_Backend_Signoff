"""Relocate only three defective CLK access mcon vias into native GDS pin geometry."""
from pathlib import Path
import json, re
w=Path(__file__).resolve().parent.parent
src=(w/'results/fillers.def').read_text()
edits=[('_5953_','clknet_leaf_48_clk',192000,244755,244940),('_5803_','clknet_leaf_109_clk',303475,244755,244940),('_5610_','clknet_leaf_67_clk',258355,361305,361120)]
manifest=[]
for inst,net,x,oldy,newy in edits:
    pat=r'    - '+re.escape(net)+r' .*?;'
    match=re.search(pat,src,re.S); assert match,net
    old=match.group(); oldvia=f'NEW li1 ( {x} {oldy} ) L1M1_PR_MR'; assert old.count(oldvia)==1
    new=old.replace(oldvia,f'NEW li1 ( {x} {newy} ) L1M1_PR_MR\n      NEW met1 ( {x} {oldy} ) ( * {newy} )')
    src=src[:match.start()]+new+src[match.end():]
    manifest.append(dict(instance=inst,pin='CLK',net=net,via='L1M1_PR_MR',old_center_dbu=[x,oldy],new_center_dbu=[x,newy],met1_dogleg_um=abs(newy-oldy)/1000))
(w/'results/access_repair.def').write_text(src)
(w/'reports/access_edits.json').write_text(json.dumps(manifest,indent=2)+'\n')
