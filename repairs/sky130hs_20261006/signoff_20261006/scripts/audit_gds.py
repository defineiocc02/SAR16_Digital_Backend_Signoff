import pya, json, os, collections, hashlib
from pathlib import Path
w=Path(os.environ['SAR16_SIGNOFF']); layout=pya.Layout(); layout.read(str(w/'results/baseline.gds'));top=layout.cell('sar_digi_paper_core')
usage=collections.Counter()
for inst in top.each_inst():
 cell=inst.cell
 if cell.name.startswith('sky130_fd_sc_hs__'): usage[cell.name]+=inst.na*inst.nb if inst.is_regular_array() else 1
expected=json.loads((w/'reports/design_cell_usage.json').read_text())
assert usage==expected,(usage-expected,collections.Counter(expected)-usage)
layers=[]
for idx in layout.layer_indices():
 info=layout.get_info(idx); region=pya.Region(top.begin_shapes_rec(idx)); area=region.area()*layout.dbu**2
 shapes=sum(1 for s in top.begin_shapes_rec(idx).each())
 layers.append({'layer':info.layer,'datatype':info.datatype,'recursive_objects':shapes,'polygon_area_sum_um2':area})
assert not any(x['layer']<64 and x['polygon_area_sum_um2']>0 for x in layers), 'Unexpected streamout numeric layer'
report={'source':'Frozen run_v6 routed.def + native ORFS HS stdcell GDS, no filler/metal fill/reroute modifications','gds_sha256':hashlib.sha256((w/'results/baseline.gds').read_bytes()).hexdigest(),'dbu_um':layout.dbu,'top_cells':[c.name for c in layout.top_cells()],'top_bbox_um':str(top.dbbox()),'cell_count':layout.cells(),'empty_cells':[c.name for c in layout.each_cell() if c.is_empty()],'stdcell_instances':sum(usage.values()),'unique_stdcell_masters':len(usage),'instance_counts_match_frozen_def':usage==expected,'native_device_layers_present':all(any(r['layer']==n and r['datatype']==d and r['polygon_area_sum_um2']>0 for r in layers) for n,d in [(64,20),(65,20),(66,20),(66,44),(67,20),(67,44)]),'layers':layers}
(w/'reports/gds_integrity.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
