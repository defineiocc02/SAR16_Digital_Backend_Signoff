import csv,re,collections,json
from pathlib import Path
p=Path(__file__).resolve().parents[1]
rows=list(csv.DictReader((p/'results/routed_nets.csv').open()))
spef=(p/'results/routed.spef').read_text()
# OpenRCX escapes literal periods in flattened hierarchical identifiers.
maps={i:re.sub(r'\\(.)',r'\1',n) for i,n in re.findall(r'^\*(\d+) (.+)$',spef,re.M)}
annot={maps.get(i,'?') for i in re.findall(r'^\*D_NET \*(\d+) ',spef,re.M)}
sig=[r for r in rows if r['type'] not in ('POWER','GROUND')]
def norm(n): return re.sub(r'\\(.)',r'\1',n)
assert len({norm(r['name']) for r in sig}) == len(sig), 'Canonical name collision'
missing=[r for r in sig if norm(r['name']) not in annot]
res={'database_signal_nets':len(sig),'spef_d_net_entries':len(annot),'missing_signal_net_count':len(missing),'missing_by_pin_count':dict(collections.Counter(int(r['pins']) for r in missing)),'missing_connected_nets':[r for r in missing if int(r['pins'])>1]}
res['connected_nets_annotated']=not res['missing_connected_nets']
(p/'reports/spef_coverage.json').write_text(json.dumps(res,indent=2))
print(json.dumps(res,indent=2))
assert res['connected_nets_annotated'], 'Connected signal net lacks D_NET in extracted SPEF'
