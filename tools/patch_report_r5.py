#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Add the round-5 findings to the HTML report generator, then it is regenerated.

Round 5 established, with measurements:
  * the PDK is self-consistent: 109/109 placed standard cells pass standalone LVS
  * layout placements == flattened netlist instances (3626/3626, 109 masters, 0 diff)
  * the block abstract is NOT producible by this FC release's writer path
"""
import io
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8").read()

ANCHOR = '    pb.append("<h3>B.2 LVS 错误分解（仍未收敛）</h3>")'
NEW = '''    pb.append("<h3>B.2 LVS 残差归因（本轮新增，全部为实测）</h3>")
    pb.append(tbl(["检验", "方法", "结果"], [
        ["<b>PDK 是否自洽</b>",
         "拿 kit 自己的版图 + kit 自己的 CDL，对该设计<b>实际用到的 109 个 master</b>"
         "逐个单独跑 Calibre LVS（precision 按 kit 的 1000）",
         b("109 / 109 CORRECT", 0) + " —— <b>库数据无问题，残差不能甩给库</b>"],
        ["<b>网表 ↔ 版图单元数</b>",
         "把 P&R 网表按层次展平，与版图顶层放置逐 master 对差",
         b("3626 / 3626 一致", 0) + "，109 种 master，仅版图有 0 / 仅网表有 0 / 计数差 0"],
        ["<b>纯物理单元是否多出</b>",
         "版图顶层 master 集合 vs 网表 master 集合",
         b("没有多余逻辑单元", 0) + "（独有的只有 <code>$$via1..via5</code> 过孔单元）"],
        ["<b>块自身 abstract 可行性</b>",
         "读 <code>write_lef -help</code> / <code>create_abstract -help</code>，并实测 6 种写出变体",
         b("本版本不提供", 2) + "（见 B.3）"],
    ]))
    pb.append(note("<b>结论收窄</b>：库自洽、单元数目完全一致、端口已相等 —— "
                   "因此 <code>+50</code> 的器件残差只可能来自"
                   "<b>同一单元在本设计的行/轨/条带环境里被提取出的器件与孤立提取不同</b>。"
                   "这是下一步唯一的目标，不再是"到处都可能是原因"。"))
    pb.append("<h3>B.3 块自身 abstract：本版本的写出路径不提供</h3>")
    pb.append(tbl(["命令", "存在性", "实测行为"], [
        ["<code>write_lef_abstract</code>", b("absent", 2), "——"],
        ["<code>create_abstract</code>", b("EXISTS", 1),
         "在顶层块上调用报 <code>Error: Could not find any instantiation for the given "
         "block(s). (ABS-297)</code> —— 其语义是"从父层给被子块建 abstract""],
        ["<code>create_abstract_model</code> / <code>create_boundary</code> / <code>set_boundary</code>",
         b("absent", 2), "——"],
    ]))
    pb.append("<p><code>write_lef</code> 的全部选项（读 <code>-help</code> 得到）："
              "<code>[-library] [-design] [-include {cell,tech}] [-properties] "
              "[-exclude_layers] [-slice_polygon] [-version] [-write_additional_viarule]</code>。"
              "六个变体全部实测，判据是文件里 <code>^MACRO sar_digi_paper_core</code> 的条数：</p>")
    pb.append(tbl(["变体", "字节", "MACRO 总数", "块自身 MACRO", "PIN"], [
        ["<code>-design &lt;block&gt;</code>（现用）", "179 596", "109", b("0", 2), "630"],
        ["<code>-include cell</code>", "176 050", "109", b("0", 2), "630"],
        ["<code>-include {cell tech}</code>", "179 596", "109", b("0", 2), "630"],
        ["<code>-include tech</code>", "3 709", "0", "0", "0"],
        ["<code>-design sar16_route_paper_core -include cell</code>", "176 050", "109", b("0", 2), "630"],
        ["<code>-library &lt;lib&gt; -include cell</code>", "163", "0", "0", "0"],
    ]))
    pb.append(note("并且库目录里<b>物理上只有 <code>design.ndm</code> 一种 view</b>"
                   "（<code>sar16_route_paper_core/</code> 与 <code>sar_digi_paper_core/</code> "
                   "下均只有 design + data_map + SHADOW_DESIGN），<b>没有 abstract view 可导</b>。"
                   "→ 本 FC 版本（W-2024.09-SP3）在"顶层块 + 无父层"的前提下无法产出块自身 abstract；"
                   "唯一未试的候选是<b>先造父层 wrapper 例化本块，再从父层调 create_abstract</b>。"))
    pb.append("<h3>B.4 LVS 错误分解（仍未收敛）</h3>")'''

n = t.count(ANCHOR)
print("anchor hits: %d" % n)
assert n == 1, "anchor must appear exactly once"
t = t.replace(ANCHOR, NEW)
# the old B.1 heading numbering for the delivery list stays; B.2 renamed above
t = t.replace('<h3>B.3 结论边界（不得外推）</h3>', '<h3>B.5 结论边界（不得外推）</h3>')
t = t.replace('<h3>B.4 交接状态</h3>', '<h3>B.6 交接状态</h3>')
io.open(GEN, "w", encoding="utf-8").write(t)
print("generator updated")
