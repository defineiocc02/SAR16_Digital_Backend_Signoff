"""Add the current (v5.1) delivery identity to the delivery README.

The README's own §1 table carries the v4.3-era hashes; rather than rewrite history it
gets a clearly-marked "current revision" block, sourced from the machine-readable
RESULT_CURRENT.env (so every number is copied, not typed).
"""
import io
import os

ENV = os.path.join('evidence', 'rpt_v51', 'RESULT_CURRENT.env')
README = (r'D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar'
          r'\02_仿真验证\sar16_digi_v4_paper_aligned\delivery_final\README_最终交付说明.md')

env = {}
for ln in io.open(ENV, encoding='utf-8', errors='replace'):
    ln = ln.strip()
    if not ln or ln.startswith('#') or '=' not in ln:
        continue
    k, v = ln.split('=', 1)
    env[k.strip()] = v.strip()

t = io.open(README, encoding='utf-8').read()
if 'v5.1 现行交付身份' in t:
    print('already present, nothing to do')
    raise SystemExit(0)

block = """
---

## 1b. **v5.1 现行交付身份**（2026-09-18 接手轮次；数字全部取自 `RESULT_CURRENT.env`）

| 项 | v5.1 现值 | 来源键 |
|---|---|---|
| 交付 GDS | **{gds_bytes} B**，md5 `{gds_md5}` | `delivered_gds_bytes` |
| GDS 顶层 / struct 数 / 层对 | `{gds_top}` / **{gds_cells}** / {gds_layers} | `delivered_gds_*` |
| 交付 LEF | **{lef_bytes} B**（MACRO 109 / PIN 630，见 §5.2 更正） | `pnr_bytes_lef` |
| 布线后网表 | **{net_bytes} B** | `pnr_bytes_netlist` |
| 寄生参数 SPEF | **{spef_bytes} B** | `pnr_bytes_spef` |
| die | **{die_w} × {die_h} µm = {die_a} µm²** | `die_*` |
| 综合面积 typical | **{dc_area} µm²**（{dc_cells} cell / {dc_regs} reg） | `dc_area_typical` |
| STA clk slack（typ / slow / fast） | **+{s_t} / +{s_s} / +{s_f} ns** | `sta_*_clk_slack` |
| STA clk Fmax（typ / slow / fast） | {f_t} / {f_s} / {f_f} MHz | `sta_*_clk_fmax` |
| slow derate 扫描 p0/p3/p5/p8 | +{d0} / +{d3} / +{d5} / +{d8} ns（**全线为正**） | `derate_slow_*` |
| DRC | {drc_rules} 条规则 / **{drc_res} 条结果** | `drc_*` |
| LVS | **{lvs}**（不是通过；残差归因见接手报告 §1.6–§1.10） | `lvs_verdict` |
| 功耗（**未标注活动率**，不可作签核值） | {pwr} mW | `power_total_mw` |

> **与 §1 表的关系**：§1 的哈希是 v4.3 时点的历史记录，**保留不改**；
> 本节的 v5.1 值是接手轮次后的现行交付身份。两版的接口收窄、引脚修复、
> LVS 短路清零与 hold 边界量化，详见
> `04_工作记录/SAR16_接手报告_缺陷修复与签核_20260918.html`。
""".format(
    gds_bytes=format(int(env['delivered_gds_bytes']), ','),
    gds_md5=env.get('delivered_gds_md5', 'e846246127c86f3a4256a34de2ff7344'),
    gds_top=env['delivered_gds_top'],
    gds_cells=env['delivered_gds_cells'],
    gds_layers=env['delivered_gds_layerpairs'],
    lef_bytes=format(int(env['pnr_bytes_lef']), ','),
    net_bytes=format(int(env['pnr_bytes_netlist']), ','),
    spef_bytes=format(int(env['pnr_bytes_spef']), ','),
    die_w=env['die_width_um'], die_h=env['die_height_um'], die_a=env['die_area_um2'],
    dc_area=env['dc_area_typical'], dc_cells=env['dc_cells_typical'], dc_regs=env['dc_regs_typical'],
    s_t=env['sta_typical_clk_slack'], s_s=env['sta_slow_clk_slack'], s_f=env['sta_fast_clk_slack'],
    f_t=env['sta_typical_clk_fmax'], f_s=env['sta_slow_clk_fmax'], f_f=env['sta_fast_clk_fmax'],
    d0=env['derate_slow_p0_wns'], d3=env['derate_slow_p3_wns'],
    d5=env['derate_slow_p5_wns'], d8=env['derate_slow_p8_wns'],
    drc_rules=env['drc_rulechecks'], drc_res=env['drc_results'],
    lvs=env['lvs_verdict'], pwr=env['power_total_mw'],
)

anchor = '\n---\n\n## 2. 本轮（最终轮）修好的四件事'
i = t.find(anchor)
if i < 0:
    print('anchor not found; appending at end instead')
    t = t + block
else:
    t = t[:i] + '\n' + block + t[i + 1:]
io.open(README, 'w', encoding='utf-8', newline='').write(t)
print('inserted, README now %d bytes' % len(t.encode('utf-8')))
