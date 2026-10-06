from pathlib import Path
R=Path(__file__).resolve().parents[3];B=R/'sar16_repair_20261005/backend';O=R/'sar16_rework_20261005/optimization/synthesis'
for n in ['results','reports','logs','scripts']:(O/n).mkdir(parents=True,exist_ok=True)
s=(B/'scripts/synth.ys').read_text().replace(str(R/'sar16_repair_20261005/rtl_frozen'),str(R/'sar16_rework_20261005/repo/rtl_optimized')).replace(str(B),str(O));(O/'scripts/synth.ys').write_text(s)
