from pathlib import Path
import subprocess, os, json, hashlib, re
ROOT=Path(__file__).resolve().parents[3]
OUT=Path(os.environ.get('EQ_OUT',str(Path(__file__).resolve().parents[1])))
REP=ROOT/'sar16_repair_20261005'
NGLIB=ROOT/'sar16_signoff_20261005/environment/tools/OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib'
GFLIB=REP/'backend_gf180/inputs/gf180mcu_fd_sc_mcu9t5v0__tt_025C_1v80.lib'
for d in ['results','models','scripts','logs']:(OUT/d).mkdir(parents=True,exist_ok=True)
cfg_path=OUT/'config.json'
if cfg_path.exists():cfg=json.loads(cfg_path.read_text())
else:
 cfg={'rtl_dir':str(REP/'rtl_frozen'),'netlists':{'ng_mapped':str(REP/'backend/results/mapped.v'),'ng_routed':str(REP/'backend/results/routed.v'),'gf_mapped':str(REP/'backend_gf180/results/mapped.v'),'gf_routed':str(REP/'backend_gf180/results/routed.v')},'libraries':{'ng':str(NGLIB),'gf':str(GFLIB)}}
 cfg_path.write_text(json.dumps(cfg,indent=2)+'\n')
YS=os.environ['YOSYS_EXE']
def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
inputs=sorted({*map(str,Path(cfg['rtl_dir']).glob('*.sv')),*cfg['netlists'].values(),*cfg['libraries'].values(),*(c['lef'] for c in cfg.get('physical_only',{}).values())})
before={p:digest(p) for p in inputs}
roles={**{'rtl/'+Path(p).name:p for p in inputs if p.endswith('.sv')},**{'netlist/'+k:v for k,v in cfg['netlists'].items()},**{'liberty/'+k:v for k,v in cfg['libraries'].items()},**{'physical_lef/'+k:v['lef'] for k,v in cfg.get('physical_only',{}).items()}}
manifest={'source_roles':{k:{'path':v,'sha256':before[v]} for k,v in roles.items()},'source_sha256':before,'yosys_version':subprocess.check_output([YS,'-V'],text=True).strip(),'config':cfg}
prior=OUT/'source_manifest.json'
if prior.exists():
 old=json.loads(prior.read_text())
 oldcfg=old['config']
 oldroles={**{'rtl/'+Path(p).name:p for p in old['source_sha256'] if p.endswith('.sv')},**{'netlist/'+k:v for k,v in oldcfg['netlists'].items()},**{'liberty/'+k:v for k,v in oldcfg['libraries'].items()},**{'physical_lef/'+k:v['lef'] for k,v in oldcfg.get('physical_only',{}).items()}}
 for role,p in oldroles.items():
  if role in roles:assert before[roles[role]]==old['source_sha256'][p],f'Previously pinned role changed: {role}'
 for p,h in old['source_sha256'].items():
  if p in before:assert before[p]==h,f'Previously pinned source changed: {p}'
for tech,lib in cfg['libraries'].items():
 script=f'read_liberty -ignore_miss_func {lib}\nwrite_json {OUT/"models"/f"{tech}_from_liberty.json"}\nwrite_verilog -noattr {OUT/"models"/f"{tech}_from_liberty.v"}\n'
 p=OUT/'scripts'/f'models_{tech}.ys';p.write_text(script)
 with (OUT/'logs'/f'models_{tech}.log').open('w') as f:subprocess.run([YS,'-Q','-T','-s',str(p)],stdout=f,stderr=subprocess.STDOUT,check=True)
physical_models={}
for tech,info in cfg.get('physical_only',{}).items():
 lef=Path(info['lef']).read_text(); text=['// Proven no-functional-pin WELLTAP model; nominal-power digital abstraction.','// LEF SHA256: '+before[info['lef']]];audit={}
 for cell in info['cells']:
  match=re.search(r'^MACRO\s+'+re.escape(cell)+r'\b.*?^END\s+'+re.escape(cell)+r'\s*$',lef,re.M|re.S)
  assert match,'Physical macro absent from pinned LEF: '+cell
  block=match.group();assert re.search(r'CLASS\s+CORE\s+WELLTAP\s*;',block), 'Only verified WELLTAP cells may use this abstraction'
  pins=[]
  for pin,body in re.findall(r'  PIN (\S+)\n(.*?)  END \1',block,re.S):
   direction=re.search(r'DIRECTION\s+(\w+)',body).group(1);use=re.search(r'USE\s+(\w+)',body).group(1)
   assert direction=='INOUT' and use in ['POWER','GROUND'], 'Functional pin cannot be abstracted'
   pins.append(pin)
  assert pins,'Missing power-pin evidence'
  text.append('module '+cell+'('+','.join(pins)+');')
  text.extend('inout '+pin+';' for pin in pins);text.append('endmodule');audit[cell]={'class':'CORE WELLTAP','power_only_pins':pins,'functional_outputs':0}
 path=OUT/'models'/f'{tech}_physical_only.v';path.write_text('\n'.join(text)+'\n');physical_models[tech]=path
 (OUT/'models'/f'{tech}_physical_only_audit.json').write_text(json.dumps(audit,indent=2)+'\n')
for label in ['rtl',*cfg['netlists']]:
 if label=='rtl':reads='read_verilog -sv -D SYNTHESIS '+' '.join(str(p) for p in sorted(Path(cfg['rtl_dir']).glob('*.sv')))
 else:
  lib=cfg['libraries'][label.split('_')[0]]
  reads=f'read_liberty -ignore_miss_func {lib}\n'
  tech=label.split('_')[0]
  if tech in physical_models:reads+=f'read_verilog -noblackbox {physical_models[tech]}\n'
  reads+=f'read_verilog {cfg["netlists"][label]}'
 script=f'''{reads}
hierarchy -check -top sar_digi_paper_core
proc
write_json {OUT/'results'/f'{label}_preflatten.json'}
flatten
opt
memory
opt
techmap
opt
dffunmap
opt_clean
check -assert
write_json {OUT/'results'/f'{label}.json'}
write_verilog -noattr {OUT/'results'/f'{label}.v'}
stat
'''
 p=OUT/'scripts'/f'normalize_{label}.ys';p.write_text(script)
 with (OUT/'logs'/f'normalize_{label}.log').open('w') as f:subprocess.run([YS,'-Q','-T','-s',str(p)],stdout=f,stderr=subprocess.STDOUT,check=True)
 print(label,'normalized',flush=True)
assert {p:digest(p) for p in inputs}==before,'Sources changed during normalization'
manifest['model_sha256']={str(p.relative_to(OUT)):digest(p) for p in (OUT/'models').glob('*') if p.is_file()}
prior.write_text(json.dumps(manifest,indent=2)+'\n')
