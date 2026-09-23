import os, struct
GDS = r"evidence\rpt_v51\sar_digi_paper_core_merged.gds"
REC = {0x05:"BGNSTR",0x06:"STRNAME",0x07:"ENDSTR",0x0A:"SREF",0x0B:"AREF",
       0x0D:"LAYER",0x10:"XY",0x11:"ENDEL",0x12:"SNAME",0x08:"BOUNDARY",0x09:"PATH"}
ELEM={0x08,0x09,0x0A,0x0B}
f=open(GDS,"rb"); cur=None; name=None; el=None
info={}
while True:
    h=f.read(4)
    if len(h)<4: break
    rl,rt,rd=struct.unpack(">HBB",h); d=f.read(rl-4) if rl>=4 else b""
    n=REC.get(rt)
    if n=="BGNSTR": cur={"srefs":[],"bbox":None}
    elif n=="STRNAME": name=d.split(b"\x00")[0].decode("latin-1")
    elif n=="ENDSTR":
        info[name]=cur; cur=None
    elif rt in ELEM: el={"kind":n,"layer":None,"xy":None,"sname":None}
    elif n=="LAYER" and el is not None: el["layer"]=struct.unpack(">h",d[:2])[0]
    elif n=="XY" and el is not None:
        k=len(d)//4; el["xy"]=struct.unpack(">%di"%k,d[:k*4])
    elif n=="SNAME" and el is not None: el["sname"]=d.split(b"\x00")[0].decode("latin-1")
    elif n=="ENDEL":
        if el is not None and cur is not None and el["xy"]:
            xs=el["xy"][0::2]; ys=el["xy"][1::2]
            if el["kind"] in ("SREF","AREF"):
                cur["srefs"].append((el["sname"], xs[0], ys[0]))
            else:
                bb=(min(xs),min(ys),max(xs),max(ys))
                b=cur["bbox"]
                cur["bbox"]=bb if b is None else (min(b[0],bb[0]),min(b[1],bb[1]),max(b[2],bb[2]),max(b[3],bb[3]))
        el=None
f.close()
print("=== frame -> real cell SREF ORIGIN (the offset I ignored) ===")
for fn in ("INVXL","NOR2XL","DFFSX1","NAND2BXL","AOI21XL","XNOR2XL","OAI21XL","AND4XL","OAI211X1","NAND2XL"):
    fr=info.get(fn,{})
    rs=fr.get("srefs") or []
    real=rs[0][0] if rs else None
    off=(rs[0][1],rs[0][2]) if rs else None
    print("   %-10s frame bbox=%-30s SREF %-30s origin=%s   real bbox=%s"
          % (fn, fr.get("bbox"), real, off, info.get(real,{}).get("bbox")))
