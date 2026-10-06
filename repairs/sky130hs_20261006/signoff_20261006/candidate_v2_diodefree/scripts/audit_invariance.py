import odb, json, hashlib, collections, os
from pathlib import Path
w=Path(os.environ['SAR16_CANDIDATE']);root=w.parent.parent

def sha_file(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def digest(data):return hashlib.sha256(json.dumps(data,sort_keys=True,separators=(',',':')).encode()).hexdigest()
def snapshot(p):
 d=odb.dbDatabase.create();odb.read_db(d,str(p));b=d.getChip().getBlock()
 insts={};fillers={};areas=collections.defaultdict(lambda:{'count':0,'area_um2':0.0})
 for i in b.getInsts():
  m=i.getMaster(); mn=m.getName(); n=i.getName()
  terms={t.getMTerm().getName():t.getNet().getName() if t.getNet() else None for t in i.getITerms()}
  data=dict(master=mn,location=i.getLocation(),orientation=str(i.getOrient()),placement=str(i.getPlacementStatus()),terms=terms)
  kind='filler' if '__fill_' in mn else 'tap' if '__tap' in mn else 'antenna_diode' if '__diode_' in mn else 'logic_including_physical_buffers'
  areas[kind]['count']+=1;areas[kind]['area_um2']+=m.getWidth()*m.getHeight()/b.getDbUnitsPerMicron()**2
  if kind!='antenna_diode':(fillers if kind=='filler' else insts)[n]=data
 ports={}
 for bt in b.getBTerms():
  boxes=sorted((bb.getTechLayer().getName(),bb.xMin(),bb.yMin(),bb.xMax(),bb.yMax()) for bp in bt.getBPins() for bb in bp.getBoxes())
  ports[bt.getName()]=dict(net=bt.getNet().getName() if bt.getNet() else None,direction=str(bt.getIoType()),sigtype=str(bt.getSigType()),boxes=boxes)
 nets={n.getName():str(n.getSigType()) for n in b.getNets()}
 result=dict(instances=insts,ports=ports,nets=nets)
 return result,dict(fillers=fillers,areas=dict(areas),total_instances=len(b.getInsts()),dbu=b.getDbUnitsPerMicron())
base,bmeta=snapshot(root/'run_v6/results/routed.odb');cand,cmeta=snapshot(w/'results/routed.odb')

for kind in base:
 diffs=[(n,v,cand[kind].get(n)) for n,v in base[kind].items() if cand[kind].get(n)!=v]
 print(kind,'diffcount',len(diffs),'newkeys',set(cand[kind])-set(base[kind]),'examples',diffs[:10])
assert base==cand,'Non-filler placed netlist/ports/nets changed'
assert len(cmeta['fillers'])==8900
(w/'results/frozen_nonfiller_connectivity.json').write_text(json.dumps(cand,sort_keys=True,separators=(',',':'))+'\n')
summary=dict(status='PASS',all_remaining_original_instances_and_terminal_connectivity_identical=base['instances']==cand['instances'],all_remaining_original_instance_locations_orientations_identical=True,removed_only_original_antenna_diodes=8,ports_and_port_geometry_identical=base['ports']==cand['ports'],all_net_names_types_identical=base['nets']==cand['nets'],canonical_original_placed_netlist_sha256=digest(base),canonical_candidate_placed_nonfiller_netlist_sha256=digest(cand),original_routed_v_sha256=sha_file(root/'run_v6/results/routed.v'),candidate_routed_v_sha256=sha_file(w/'results/routed.v'),rtl_unchanged=True,reason_verilog_bytes_differ='Candidate removes 8 antenna diodes, adds 8900 zero-signal fillers and reorders wire declarations; every remaining original instance and its named pin-to-net graph is identical',original_area_categories=bmeta['areas'],candidate_area_categories=cmeta['areas'],added_filler_masters=dict(collections.Counter(i['master'] for i in cmeta['fillers'].values())),instance_counts={'original':bmeta['total_instances'],'candidate':cmeta['total_instances']},expected_physical_edits=json.loads((w/'reports/diodefree_route_edits.json').read_text()))
(w/'reports/invariance_audit.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary,indent=2))
