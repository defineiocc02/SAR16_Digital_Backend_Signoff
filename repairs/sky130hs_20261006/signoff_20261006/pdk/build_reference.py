#!/usr/bin/env python3
"""Merge unchanged upstream HS views after verifying the recorded per-file SHA256."""
from pathlib import Path
import hashlib,json,re
root=Path(__file__).resolve().parent
manifest=json.loads((root/'geometry_matched_reference_manifest.json').read_text())
src=root/'src/sky130_fd_sc_hs-verified-968e0c3'
for row in manifest['verified_source_files']:
    f=src/row['path']
    assert hashlib.sha256(f.read_bytes()).hexdigest()==row['sha256'],f
for ext in ['spice','cdl']:
    out=root/'sky130A/libs.ref/sky130_fd_sc_hs'/ext/('sky130_fd_sc_hs.geometry_matched.'+ext)
    out.parent.mkdir(parents=True,exist_ok=True)
    text=''.join('* Source: '+str(f.relative_to(src))+'\n'+f.read_text()+'\n' for f in sorted(src.glob('cells/*/*.'+ext)))
    out.write_text(text)
    assert hashlib.sha256(out.read_bytes()).hexdigest()==manifest['outputs'][ext]['sha256'],out
    cells=set(re.findall(r'^\s*\.subckt\s+(\S+)',text,re.M|re.I))
    used=set(json.loads((root/'used_cells.json').read_text()))
    assert not used-cells,used-cells
    print(ext,len(cells),'subcircuits;',len(used),'used masters covered;',out)
