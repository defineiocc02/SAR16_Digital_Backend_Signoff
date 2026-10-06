from pathlib import Path
import re,json,csv
w=Path(__file__).resolve().parent.parent
s=(w/'results/no_diodes.def').read_text();manifest=[]
# Work only inside routed NETS, not the same-named top-level PINS.
start=s.index('\nNETS ');head=s[:start];s=s[start:]
rows=list(csv.DictReader((w/'reports/removed_diodes.tsv').open(),delimiter='\t'))
for d in rows:
 net=d['net'];x,y=int(d['x_dbu']),int(d['y_dbu']);match=re.search(r'    - '+re.escape(net)+r' .*?;',s,re.S);assert match,net
 old=match.group();new=old
 pts=[(int(a),int(b),t) for a,b,t in re.findall(r'NEW li1(?: TAPER)? \( (\d+) (\d+) \) (L1M1_\w+)',old) if x+95<=int(a)<=x+865 and y+265<=int(b)<=y+3065]
 assert pts,(d,old)
 if len(pts)==1:
  a,b,t=pts[0];new=re.sub(r'\n      NEW li1(?: TAPER)? \( '+str(a)+' '+str(b)+r' \) '+t,r'',new)
  action='Remove sole obsolete diode access via; retain harmless connected metal stub'
 elif net=='_0827_':
  # A real M2 bridge avoids exposing the _2775_ input to the long M1-only antenna.
  for a,b,t in pts:
   new=re.sub(r'NEW li1(?: TAPER)? \( '+str(a)+' '+str(b)+r' \) '+t,f'NEW met1 ( {a} {b} ) M1M2_PR',new)
  a,b,_=pts[0];c,e,_=pts[1]
  new=new[:-1]+f'\n      NEW met2 ( {a} {b} ) ( {c} * )\n      NEW met2 ( {c} {b} ) ( * {e} ) ;'
  action='Replace multi-access diode conductor with real M2 bridge plus two M1M2 vias'
 else:
  # The original diode LI pin electrically bridges multiple route branches.
  # Preserve this connection with genuine 0.17um LI routing inside its old pin footprint.
  a,b,_=pts[0]
  added=[]
  for c,e,_ in pts[1:]:
   if c!=a:added.append(f'      NEW li1 ( {a} {b} ) ( {c} * )')
   if e!=b:added.append(f'      NEW li1 ( {c} {b} ) ( * {e} )')
  new=new[:-1]+'\n'+'\n'.join(added)+' ;'
  action='Replace removed multi-access diode LI conductor with real LI route preserving branch connectivity'
 manifest.append(dict(instance=d['instance'],net=net,via_centers_dbu=[p[:2] for p in pts],action=action))
 s=s[:match.start()]+new+s[match.end():]
match=re.search(r'    - clk .*?;',s,re.S);old=match.group();needle='NEW met3 ( 36960 197950 ) ( 197520 * )';assert old.count(needle)==1
new=old.replace(needle,'NEW met3 ( 36960 197950 ) ( 180000 * )\n      NEW met4 ( 180000 197950 ) ( 181440 * )\n      NEW met3 ( 181440 197950 ) ( 197520 * )\n      NEW met3 ( 180000 197950 ) M3M4_PR\n      NEW met3 ( 181440 197950 ) M3M4_PR')
s=s[:match.start()]+new+s[match.end():]
manifest.append(dict(net='clk',action='Cut 1.44um of M3; insert 1.44um M4 bridge plus two M3M4_PR vias',centers_dbu=[[180000,197950],[181440,197950]],geometry_keepout='0.9um M4 clearance screening plus router and full GDS DRC verification'))
match=re.search(r'    - clknet_4_8_0_clk .*?;',s,re.S);old=match.group();needle='NEW met3 ( 89760 226070 ) ( 90480 * )';assert old.count(needle)==1
new=old.replace(needle,'NEW met4 ( 89760 226070 ) ( 90480 * )\n      NEW met3 ( 90480 226070 ) M3M4_PR\n      NEW met3 ( 90480 226070 ) ( 90960 * )')
s=s[:match.start()]+new+s[match.end():]
manifest.append(dict(net='clknet_4_8_0_clk',action='Lift 0.72um terminal M3 branch to M4; add one M3M4_PR via at90480,226070; reuse existing via at89760,226070; add0.48um M3 landing extension to meet min-area'))
(w/'results/access_repair.def').write_text(head+s);(w/'reports/diodefree_route_edits.json').write_text(json.dumps(manifest,indent=2)+'\n');print(json.dumps(manifest,indent=2))
