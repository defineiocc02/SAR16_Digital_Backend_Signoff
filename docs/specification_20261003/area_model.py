#!/usr/bin/env python3
"""Reproducible planning estimates; no new synthesis, extraction, or signoff."""
import csv, json, math
from pathlib import Path
BASE=Path(__file__).resolve().parent
BASE_CELL=0.1023001056
BASE_MACRO=0.1848394568
# SMIC archive: nominal MIM c0=.969 fF/um2; optional MIM2 c0=1.99.
# SP018N selected functional IO body/corner depth=.235mm. Bond pitch is NOT 35um.
# Compact requires the optional MIM2 process option; not a PVT corner.
SCENARIOS={
 'compact_option':dict(cap_density=1.99,cs_overhead=1.20,cdac_overhead=2.5,cdac_floor=.012,boot_pf=4,decap_pf=40,decap_overhead=1.10,new_digital_cell=.075,digital_util=.60,digital_margin=1.05,analog_other=.065,core_whitespace=.15,pad_pitch=.070,corner_extent=.235,pad_depth=.235,inner_clearance=.035,seal_allowance=.025),
 'nominal_folded':dict(cap_density=.969,cs_overhead=1.30,cdac_overhead=3.0,cdac_floor=.020,boot_pf=6,decap_pf=80,decap_overhead=1.15,new_digital_cell=.095,digital_util=.55,digital_margin=1.07,analog_other=.090,core_whitespace=.20,pad_pitch=.090,corner_extent=.235,pad_depth=.235,inner_clearance=.045,seal_allowance=.030),
 'conservative_folded':dict(cap_density=.969,cs_overhead=1.45,cdac_overhead=4.0,cdac_floor=.030,boot_pf=10,decap_pf=120,decap_overhead=1.20,new_digital_cell=.120,digital_util=.50,digital_margin=1.10,analog_other=.125,core_whitespace=.25,pad_pitch=.110,corner_extent=.235,pad_depth=.235,inner_clearance=.055,seal_allowance=.040),
}
SCENARIOS['nominal_direct_reuse']={**SCENARIOS['nominal_folded'],'new_digital_cell':.135}
a=63.0
for direct,bridge in [(30,4),(32,4),(128,12)]:a=direct+bridge*a/(bridge+a)
cu_ff=1000/a
physical_cdac_pf=2*273*cu_ff/1000

def area_pf(pf,density): return pf/(1000*density)
def ceil_grid(side):return round(math.ceil((side-1e-12)/.05)*.05,10)
rows=[]
for name,p in SCENARIOS.items():
 digital=(BASE_CELL+p['new_digital_cell'])/p['digital_util']*p['digital_margin']
 parts={
  'digital_macro':digital,
  'cs_pair':area_pf(40,p['cap_density'])*p['cs_overhead'],
  # Reserve custom CDAC layout independently: a ~7.3fF unit is NOT verified by MIM density alone.
  'cdac_pair':max(p['cdac_floor'],area_pf(physical_cdac_pf,p['cap_density'])*p['cdac_overhead']),
  'caz_flash_boot':area_pf(2.6+.9+p['boot_pf'],p['cap_density'])*1.4,
  'supply_ref_decap':area_pf(p['decap_pf'],p['cap_density'])*p['decap_overhead'],
  'analog_active_and_local_layout':p['analog_other'],
 }
 subtotal=sum(parts.values());core=subtotal/(1-p['core_whitespace'])
 for npins in (32,48):
  # Evenly loaded sides are a geometric bound; actual pad types/ESD rails/grouping require assembly.
  perimeter_side=math.ceil(npins/4)*p['pad_pitch']+2*p['corner_extent']
  core_side=math.sqrt(core)+2*(p['pad_depth']+p['inner_clearance'])
  die_side=ceil_grid(max(perimeter_side,core_side)+2*p['seal_allowance'])
  rows.append(dict(scenario=name,pin_count=npins,parameters=p,module_areas_mm2=parts,module_sum_mm2=subtotal,
    core_window_mm2=core,core_equivalent_square_mm=math.sqrt(core),pad_side_constraint_mm=perimeter_side,
    core_plus_ring_side_mm=core_side,die_side_mm=die_side,die_area_mm2=die_side**2,
    limiting_constraint='core_plus_ring' if core_side>=perimeter_side else 'pad_perimeter'))
io=[]
for load in (2,5,10):
 for v in (1.8,3.3):
  for mode,data_r01,clock_r01 in [('serial_2lane_24bit',30e6,60e6),('parallel_16bit',20e6,5e6)]:
   # Random independent payload and one clock rise per transmitted bit pair / parallel sample.
   data=load*1e-12*v*v*data_r01*1000;clock=load*1e-12*v*v*clock_r01*1000
   io.append(dict(mode=mode,load_pf_per_pin=load,io_voltage_v=v,data_dynamic_mw=data,dco_dynamic_mw=clock,total_dynamic_mw=data+clock))
result={'date':'2026-10-03','scope':'Corrected target SMIC18 architecture: shared Cs, external reference/bias generators, on-chip final-code reconstruction.',
 'evidence':{'baseline_cell_mm2':BASE_CELL,'baseline_routed_block_mm2':BASE_MACRO,'nominal_mim_density_ff_um2':.969,'optional_mim2_density_ff_um2':1.99,'sp018n_io_body_depth_um':235,'sp018n_corner_extent_um':235,'sp018n_io_cell_pitch_um':35},
 'reconstruction_policy':'32-pin two-lane serial plus separate SPI is primary. Folded two-weight/cycle reconstruction is proposed, unimplemented. Direct wide reconstruction is a mutually exclusive comparison. New storage and 132-bit pairing/frame buffers are included; no shadow-memory sharing credit.',
 'assumptions':'Bond pitch70/90/110um, seal, clearance, new cell area, CDAC footprint and analog allowances remain estimates. Scenarios are design choices, not PVT corners. MIM nominal c0 is model data, not an all-size valid extracted capacitance. No validated pad-to-package assembly.',
 'capacitor_network':{'paper_effective_cdac_pf_per_side_assumed':1,'ideal_top_cu':a,'ideal_unit_ff':cu_ff,'physical_sum_cu_per_side_including_bridges':273,'physical_sum_pf_both_sides':physical_cdac_pf,'cdac_density_scaling_status':'Independent .020mm2 nominal footprint retained until unit geometry/model range, matching and PEX are validated.'},
 'recommendation':{'pin_count':32,'architecture':'nominal_folded','planning_die_side_mm':1.6,'planning_die_area_mm2':2.56,'conceptual_core_window_mm':[.95,.95],'digital_reservation_um':[410,940],'status':'Floorplan reservation, not placed-and-routed result or package dimensions'},
 'exclusions':['on-chip bandgap or precision reference driver','input buffer','PLL/DLL','SRAM compiler substitution','package outline area','scribe lane and MPW frame beyond placeholder seal allowance','physical implementation signoff'],
 'io_power_assumptions':'P=Cload*VIO^2*r01. Random data; 24-bit 5MS/s serial frames, 100MHz 12-cycle DCO bursts. Excludes control-pin switching, pad internal/short-circuit/static and internal serializer power. 1.8V is a conditional IO choice, not yet approved by selected pad.',
 'io_power_scenarios':io,'scenarios':rows}
(BASE/'area_estimate.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
with (BASE/'area_scenarios.csv').open('w',newline='') as f:
 fields=['scenario','pin_count','module_sum_mm2','core_window_mm2','core_equivalent_square_mm','die_side_mm','die_area_mm2','limiting_constraint']
 w=csv.DictWriter(f,fieldnames=fields,lineterminator='\n');w.writeheader();w.writerows({k:r[k] for k in fields} for r in rows)
with (BASE/'io_power_scenarios.csv').open('w',newline='') as f:
 w=csv.DictWriter(f,fieldnames=list(io[0]),lineterminator='\n');w.writeheader();w.writerows(io)
for r in rows:print(r['scenario'],r['pin_count'],'core',round(r['core_window_mm2'],6),'die',r['die_side_mm'],'area',round(r['die_area_mm2'],4))
print('nominal blocks',rows[2]['module_areas_mm2'])
print('unit',cu_ff,'physical CDAC both sides',physical_cdac_pf)
