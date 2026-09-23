#!/bin/bash
# Read-only probe 4: authoritative pin table if one exists (DEF / FC reports),
# plus the shape of the INCORRECT NETS list.
PC=/home/<user>/sar16_work/proj_paper_core
L=$PC/calibre/lvs

echo "########## A. is there a DEF with a PINS section? ##########"
find $PC -maxdepth 4 -name '*.def*' -o -maxdepth 4 -name '*.DEF' 2>/dev/null | head -20
echo "--- also look for pin/io reports ---"
find $PC -maxdepth 4 -iname '*pin*' -o -maxdepth 4 -iname '*io*.rpt' 2>/dev/null | head -20

echo
echo "########## B. FC P&R log: pin-placement lines ##########"
grep -anE 'place_pins|create_pin|pin placement|Number of pins|ports:|pins created' $PC/logs/fc_pnr.log 2>/dev/null | head -30

echo
echo "########## C. INCORRECT NETS: header of every entry ##########"
awk '/INCORRECT NETS/{f=1} /INCORRECT INSTANCES/{f=0} f' $L/lvs.rep \
  | grep -aE '^\s+[0-9]+\s+Net |Connections On This Net' | head -40

echo
echo "########## D. count of incorrect nets / instances / ports ##########"
grep -acE '^\s+[0-9]+\s+Net ' $L/lvs.rep
grep -anE 'Incorrect (Nets|Instances|Ports)' $L/lvs.rep | head -10

echo
echo "########## E. child cells referenced by the delivered GDS top cell ##########"
python3 - <<'PYEOF'
import struct
p="/home/<user>/sar16_work/proj_paper_core/calibre/sar_digi_paper_core_merged.gds"
REC={0x05:"BGNSTR",0x06:"STRNAME",0x07:"ENDSTR",0x0A:"SREF",0x0B:"AREF",0x12:"SNAME",0x11:"ENDEL"}
f=open(p,"rb")
cur=None; refs={}; cells=[]; kind=None; sname=None
while True:
    h=f.read(4)
    if len(h)<4: break
    rl,rt,rd=struct.unpack(">HBB",h)
    d=f.read(rl-4) if rl>=4 else b""
    n=REC.get(rt)
    if n=="BGNSTR": cur=None
    elif n=="STRNAME": cur=d.split(b"\x00")[0].decode("latin-1"); cells.append(cur)
    elif n in ("SREF","AREF"): kind=n; sname=None
    elif n=="SNAME": sname=d.split(b"\x00")[0].decode("latin-1")
    elif n=="ENDEL" and kind:
        if cur and sname: refs.setdefault(cur,{}).setdefault(sname,0); refs[cur][sname]+=1
        kind=None
f.close()
top="sar_digi_paper_core"
r=refs.get(top,{})
print("top cell '%s' references %d distinct child cells, %d SREFs" % (top,len(r),sum(r.values())))
print("child cells whose name looks like a via / fill / decap:")
for k,v in sorted(r.items()):
    if any(t in k.lower() for t in ("via","fill","decap","tap","tie","boundary","$$")):
        print("   %-40s %d" % (k,v))
print("total structs defined: %d" % len(cells))
print("first 10 child names:", sorted(r)[:10])
PYEOF
