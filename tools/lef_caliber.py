import re
p = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar\02_仿真验证\sar16_digi_v4_paper_aligned\delivery_final\gds\sar_digi_paper_core.lef"
txt = open(p, encoding="utf-8", errors="replace").read()
lines = txt.splitlines()

calibers = {
    "lines containing 'MACRO'": sum(1 for l in lines if "MACRO" in l),
    "lines matching ^MACRO": sum(1 for l in lines if re.match(r"^MACRO", l)),
    "occurrences of MACRO": len(re.findall(r"MACRO", txt)),
    "lines containing 'PIN'": sum(1 for l in lines if "PIN" in l),
    "lines matching ^\\s*PIN": sum(1 for l in lines if re.match(r"^\s*PIN", l)),
    "lines matching \\bPIN\\b": sum(1 for l in lines if re.search(r"\bPIN\b", l)),
    "occurrences of PIN": len(re.findall(r"PIN", txt)),
    "lines matching \\bPIN\\b or \\bPORT\\b": sum(1 for l in lines if re.search(r"\bPIN\b|\bPORT\b", l)),
    "lines matching ^\\s*END\\s+\\S+": sum(1 for l in lines if re.match(r"^\s*END\s+\S+", l)),
    "occurrences of 'PORT'": len(re.findall(r"PORT", txt)),
}
for k, v in calibers.items():
    print("%-42s %d" % (k, v))
print()
print("his README claims: MACRO 115 / PIN 665")
