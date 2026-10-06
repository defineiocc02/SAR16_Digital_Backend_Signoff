from pathlib import Path
import json,re,hashlib,csv,collections
R=Path(__file__).resolve().parents[1];P=R/'reports';D=R/'results'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def nums(p,pattern):return [float(x) for x in re.findall(pattern,p.read_text())]
summary={'status':'CHECKING','run':R.name,'scope':'SKY130HS public1.8Vdigital physical proxy; no foundry/fullADC signoff','clock_ns':{'clk':10.0,'dec_clk':3.0},'load_pf':0.05,'digital_output_min_ns':-0.5,'timing_ns':{},'electrical_violation_counts':{},'cdc_and_reset':{},'hashes':{p.name:sha(p) for p in D.iterdir() if p.name in ['mapped.v','routed.v','routed.odb','extracted.odb','routed.def','routed.spef','routed.sdc','routed.sdf']}}
for tag in ['nominal','scalarstress']:
 summary['timing_ns'][tag]={kind+'_wns':nums(P/f'{tag}_{kind}_wns.rpt',r'worst slack \w+ ([-\d.]+)')[0] for kind in ['setup','hold']}
 summary['electrical_violation_counts'][tag]={k:(P/f'{tag}_{k}.rpt').read_text().count('(VIOLATED)') for k in ['max_slew','max_capacitance','min_capacitance','max_fanout','min_pulse_width','min_period','recovery','removal']}
 s=(P/f'{tag}_cdc_max_paths.rpt').read_text(); rows=[]
 for x in s.split('CDC_ENTRY ')[1:]:
  k,src,dst,_,bound=x.splitlines()[0].split()
  arrival=re.findall(r'([-\d.]+)\s+data arrival time',x)[0]
  slack=re.findall(r'([-\d.]+)\s+slack \((?:MET|VIOLATED)\)',x)[0]
  rows.append({'kind':k,'source':src,'destination':dst,'bound_ns':float(bound),'data_arrival_ns':float(arrival),'slack_ns':float(slack)})
 mins={}
 for x in (P/f'{tag}_cdc_measurement_min.rpt').read_text().split('CDC_ENTRY ')[1:]:
  _,src,dst,_=x.splitlines()[0].split();mins[src]=float(re.findall(r'([-\d.]+)\s+data arrival time',x)[0])
 gray={}
 for bus in ['ones_g','total_g']:
  rs=[x for x in rows if f'.{bus}[' in x['source']];a=min(mins[x['source']] for x in rs);b=max(x['data_arrival_ns'] for x in rs)
  gray[bus]={'bits':len(rs),'min_physical_delay_ns':a,'max_physical_delay_ns':b,'span_ns':b-a,'source_period_ns':3.0,'pass':b-a<3.0}
 reset={k:nums(P/f'{tag}_local_reset_{k}.rpt',r'([-\d.]+)\s+slack \((?:MET|VIOLATED)\)') for k in ['recovery','removal']}
 summary['cdc_and_reset'][tag]={'entries':rows,'13_bounds_pass':len(rows)==13 and all(x['slack_ns']>=0 for x in rows),'gray_buses':gray,'local_reset_slacks_ns':reset,'reset_pass':all(reset.values()) and all(x>=0 for v in reset.values() for x in v)}
ants=(P/'antenna.rpt').read_text()
summary['antenna_net_violations']=int(re.findall(r'Found (\d+) net violations',ants)[-1]);summary['antenna_pin_violations']=int(re.findall(r'Found (\d+) pin violations',ants)[-1])
summary['router_drc_report_bytes']=(P/'route_drc.rpt').stat().st_size
summary['power_grid']={n:'All shapes on net '+n+' are connected.' in (P/f'pg_{n.lower()}.rpt').read_text() for n in ['VDD','VSS']}
counts=dict(line.split() for line in (P/'physical_counts.rpt').read_text().splitlines());summary['physical_counts']={k:float(v) for k,v in counts.items()}
summary['die_bbox_um']=[0,0,392.98,392.98];summary['core_bbox_um']=[12,13.32,380.64,379.62];summary['die_area_um2']=392.98**2;summary['core_area_um2']=(380.64-12)*(379.62-13.32)
rows=list(csv.DictReader((D/'placed_cells.csv').open()));cats=collections.defaultdict(lambda:{'count':0,'area_um2':0.0})
for r in rows:
 n,m=r['instance'],r['master'];kind='retained_mapped'
 if '__tap' in m:kind='tap'
 elif '__diode_' in m:kind='antenna_diode'
 elif n.startswith('clkload'):kind='clock_dummy_load'
 elif n.startswith('clk'):kind='clock_tree'
 elif n.startswith('hold'):kind='hold_repair'
 elif n.startswith('input'):kind='input_buffer'
 elif n.startswith('output'):kind='output_buffer'
 elif not re.fullmatch(r'_\d+_',n):kind='other_physical_repair'
 cats[kind]['count']+=1;cats[kind]['area_um2']+=float(r['width_um'])*float(r['height_um'])
summary['area_categories']=dict(cats)
summary['spef_coverage']=json.loads((P/'spef_coverage.json').read_text())
summary['router_model_limitations']=['LEF58_ENCLOSURE without CUTCLASS skipped on '+x for x in ['mcon','via','via2','via3','via4']]
summary['expected_constraint_warning']='rst_n has no input delay under inherited external asynchronous-reset assumption;745direct async-clear sink exceptions only'
summary['checks']={'timing':all(x>=0 for d in summary['timing_ns'].values() for x in d.values()),'electrical':not any(x for d in summary['electrical_violation_counts'].values() for x in d.values()),'cdc':all(d['13_bounds_pass'] and d['reset_pass'] and all(b['pass'] for b in d['gray_buses'].values()) for d in summary['cdc_and_reset'].values()),'antenna':summary['antenna_net_violations']==0 and summary['antenna_pin_violations']==0,'router_drc':summary['router_drc_report_bytes']==0,'routed_connectivity':counts['routed_connectivity']=='1','power_grid':all(summary['power_grid'].values()) and counts['unconnected_pg_terminals']=='0','spef_connected_net_coverage':summary['spef_coverage']['connected_nets_annotated']}
summary['all_supported_physical_checks_pass']=all(summary['checks'].values());summary['status']='SUPPORTED_PHYSICAL_PROXY_PASS_FORMAL_PENDING' if summary['all_supported_physical_checks_pass'] else 'FAIL'
target=P/'final_summary.json'
if target.exists() and json.loads(target.read_text()).get('all_requested_supported_gates_pass'):
 target=P/'physical_recheck_summary.json'
target.write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps({k:summary[k] for k in ['status','timing_ns','checks','physical_counts','antenna_net_violations']},indent=2))
if not summary['all_supported_physical_checks_pass']:raise SystemExit(1)
# These reports must belong to the current extracted geometry rather than a
# copied intermediate checkpoint. The final-stage markers are checked too.
assert 'STAGE_COMPLETE audit' in (R/'logs/audit.log').read_text()
assert 'STAGE_COMPLETE extract' in (R/'logs/extract.log').read_text()
assert (D/'extracted.odb').stat().st_mtime >= (D/'routed.odb').stat().st_mtime
for tag in ['nominal','scalarstress']:
 for kind in ['setup_wns','hold_wns','max_slew','max_capacitance','max_fanout']:
  assert (P/f'{tag}_{kind}.rpt').stat().st_mtime >= (D/'extracted.odb').stat().st_mtime
print('Freshness guards passed for final extracted geometry and both STA audits.')
