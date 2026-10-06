from pathlib import Path
import os
import json
OUT=Path(os.environ.get('EQ_OUT', str(Path(__file__).resolve().parents[1])))
tech=next(iter(json.loads((OUT/'config.json').read_text())['libraries']))
gate=tech+'_mapped'
base=json.loads((OUT/'results'/f'{gate}_comb.json').read_text())
cover=json.loads((OUT/'results'/f'rtl_to_{gate}_coverage.json').read_text())
fsmidx=next(m['gate_index'] for m in cover['state_mapping'] if m['kind']=='fsm_encoded')
for label,port,index in [('output_invert','raw_code_o',0),('data_invert','eq_d',0),('clock_invert','eq_c',0),('reset_invert','eq_r',0),('fsm_next_invert','eq_d',fsmidx)]:
 d=json.loads(json.dumps(base));m=d['modules'][gate+'_comb'];old=m['ports'][port]['bits'][index]
 fresh=max(b for w in m['netnames'].values() for b in w['bits'] if isinstance(b,int))+1
 m['ports'][port]['bits'][index]=fresh;m['netnames'][port]['bits'][index]=fresh
 m['cells']['negative_control_inverter']={'hide_name':0,'type':'$_NOT_','parameters':{},'attributes':{},'port_directions':{'A':'input','Y':'output'},'connections':{'A':[old],'Y':[fresh]}}
 (OUT/'results'/f'negative_{label}.json').write_text(json.dumps(d))
 script=f'''read_json {OUT/'results/rtl_comb.json'}
read_json {OUT/'results'/f'negative_{label}.json'}
read_verilog -formal -sv {OUT/'results'/f'rtl_to_{gate}.sv'}
hierarchy -check -top rtl_to_{gate}
flatten
opt
check -assert
sat -enable_undef -set-def-inputs -prove proof_ok 1 -show-ports -dump_json {OUT/'results'/f'negative_{label}_cex.json'} -dump_vcd {OUT/'results'/f'negative_{label}_cex.vcd'} -falsify
'''
 (OUT/'scripts'/f'negative_{label}.ys').write_text(script)
