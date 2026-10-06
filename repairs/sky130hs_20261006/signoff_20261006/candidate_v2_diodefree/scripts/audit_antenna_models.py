import odb,json,hashlib,os
from pathlib import Path
w=Path(os.environ['SAR16_CANDIDATE']); root=w.parent.parent;result={};pinmodels={}
for tag,path in [('baseline',root/'run_v6/results/routed.odb'),('candidate',w/'results/routed.odb')]:
 d=odb.dbDatabase.create();odb.read_db(d,str(path));b=d.getChip().getBlock();tech=w/'reports'/f'{tag}_technology.export.lef';odb.write_tech_lef(d.getTech(),str(tech));pms={}
 for lib in d.getLibs():
  for m in lib.getMasters():
   for t in m.getMTerms():
    data={}
    for method in ['getDiffArea','getPartialCutArea','getPartialMetalArea','getPartialMetalSideArea']:
     data[method]=[(a,l.getName() if l else None) for a,l in getattr(t,method)()]
    for kind in ['Default','Oxide2']:
     model=getattr(t,'get'+kind+'AntennaModel')()
     if model:
      data[kind]={method:[(a,l.getName() if l else None) for a,l in getattr(model,method)()] for method in ['getGateArea','getMaxAreaCAR','getMaxCutCAR','getMaxSideAreaCAR']}
    pms[m.getName()+'/'+t.getName()]=data
 physical_text='\n'.join(line for line in tech.read_text().splitlines() if not line.strip().startswith(('RESISTANCE ','CAPACITANCE ','EDGECAPACITANCE ')))
 result[tag]={'physical_rule_export_sha256':hashlib.sha256(physical_text.encode()).hexdigest(),'technology_export_sha256':hashlib.sha256(tech.read_bytes()).hexdigest(),'all_master_pin_antenna_data_sha256':hashlib.sha256(json.dumps(pms,sort_keys=True).encode()).hexdigest(),'pins':len(pms),'clk_root_gate_area':pms['sky130_fd_sc_hs__clkbuf_8/A']['Default']['getGateArea'],'diode_instance_count':sum('diode' in i.getMaster().getName() for i in b.getInsts()),'diode_terminal_count':sum('DIODE' in t.getMTerm().getName() for i in b.getInsts() for t in i.getITerms())}
 pinmodels[tag]=pms
assert result['baseline']['physical_rule_export_sha256']==result['candidate']['physical_rule_export_sha256'],'Physical/antenna rules modified'
assert pinmodels['baseline']==pinmodels['candidate'],'Master gate/diffusion antenna properties modified'
assert result['candidate']['diode_instance_count']==0 and result['candidate']['diode_terminal_count']==0
result['status']='PASS';result['all_geometry_and_antenna_rules_identical']=True;result['rc_metadata_note']='Routed DEF reimport has original LEF RC defaults; extraction and STA reload the same original setRC.tcl and use the same rcx_patterns.rules. RC metadata is excluded only from this antenna/geometry-rule identity hash; antenna rules are preserved exactly.';result['all_master_gate_diffusion_antenna_models_identical']=True
(w/'reports/antenna_model_integrity.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
