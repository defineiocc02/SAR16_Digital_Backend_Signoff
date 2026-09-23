import re
p = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar\02_仿真验证\sar16_digi_v4_paper_aligned\delivery_final\gds\sar_digi_paper_core.lef"
txt = open(p, encoding="utf-8", errors="replace").read()
lines = txt.splitlines()
mac = [l for l in lines if re.match(r'^MACRO\s+', l)]
pins = [l for l in lines if re.match(r'^\s*PIN\s+', l)]
ports = [l for l in lines if re.match(r'^\s*PORT\s*$', l)]
obs = [l for l in lines if re.match(r'^\s*OBS\s*$', l)]
endm = [l for l in lines if re.match(r'^END\s+\S+', l)]
print("bytes            :", len(txt.encode('utf-8', errors='replace')))
print("lines            :", len(lines))
print("MACRO (col0)     :", len(mac))
print("MACRO anywhere   :", len(re.findall(r'\bMACRO\b', txt)))
print("PIN              :", len(pins))
print("PORT             :", len(ports))
print("OBS              :", len(obs))
print("END <name>       :", len(endm))
print("first 5 names    :", [l.split()[1] for l in mac][:5])
print("last 3 names     :", [l.split()[1] for l in mac][-3:])
print("block abstract?  :", any(l.split()[1] == 'sar_digi_paper_core' for l in mac))
print("expanded_util?   :", any(l.split()[1] == 'expanded_util' for l in mac))
print("VERSION          :", [l for l in lines if l.startswith('VERSION')])
print("UNITS            :", [l for l in lines if 'DATABASE MICRONS' in l])
