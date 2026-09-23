#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""V4 scoping: quantify the compaction opportunity from the EXISTING reports, and state
exactly what the (not yet run) experiment must measure.

Nothing here is a measurement of a new layout -- it is arithmetic on the delivered
utilization / area / congestion numbers, and is labelled as such.
"""
import io
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.join(HERE, '..', 'docs', 'V4_布线密度与紧凑化_界定与测算.md')

# values read from the delivered reports (see V5 for how they were re-parsed)
CELL_AREA = 102300.1056      # fc_area.rpt  "Total cell area"
CORE_AREA = 184066.3440      # fc_util.rpt  "Total Area"
UTIL_MEAS = 0.5558           # fc_util.rpt  "Utilization Ratio"
CELLS = 3626
GRC_OVERFLOW_PCT = 2.52      # fc_congestion.rpt "GRCs has overflow (%)" Both Dirs

rows = []
for target in (0.60, 0.65, 0.70, 0.75):
    area = CELL_AREA / target
    shrink = 1.0 - area / CORE_AREA
    scale = math.sqrt(area / CORE_AREA)
    rows.append((target, area, shrink, scale))

body = []
body.append('# 独立核查 V4：布线密度与紧凑化 —— **界定与测算（实验未执行）**\n')
body.append('**性质**：本节是**对已有报告做算术**，**不是**新布局的测量结果。'
            '真正的紧凑化实验（改 `UTIL` 重跑 P&R + STA + DRC + LVS）**本轮没有执行**，'
            '原因见 §4。\n')
body.append('---\n')
body.append('## 1. 为什么布线看起来"散"：一个参数\n')
body.append('`scripts/fc_pnr_paper_core.tcl`：\n')
body.append('```tcl\nset UTIL 0.55\ninitialize_floorplan -core_utilization $UTIL\n```\n')
body.append('交付报告实测：\n')
body.append('| 量 | 值 | 来源 |\n|---|---|---|')
body.append('| 单元总面积 | %.2f µm² | `fc_area.rpt` Total cell area |' % CELL_AREA)
body.append('| 核心/块面积 | %.2f µm² | `fc_util.rpt` Total Area |' % CORE_AREA)
body.append('| **利用率** | **%.4f** | `fc_util.rpt` Utilization Ratio |' % UTIL_MEAS)
body.append('| 单元数 | %d | `fc_area.rpt` Number of cells |' % CELLS)
body.append('| 布线溢出 | **%.2f %%** 的 GRC | `fc_congestion.rpt` Both Dirs |' % GRC_OVERFLOW_PCT)
body.append('')
body.append('**⇒ 单元只占核心面积的 %.1f %%，约 %.0f %% 是空行。这不是布线失败，是 `UTIL` 这个数。**\n'
            % (UTIL_MEAS * 100, (1 - UTIL_MEAS) * 100))
body.append('**同一份报告也说明它不能白压**：55 %% 利用率下已经有 **%.2f %%** 的全局布线单元溢出，'
            '垂直方向更差。**所以"能压到多少"必须实验定，不能拍。**\n' % GRC_OVERFLOW_PCT)
body.append('---\n')
body.append('## 2. 紧凑化的算术空间（只是算术）\n')
body.append('把 `UTIL` 当作目标利用率，所需核心面积 = 单元面积 / 目标：\n')
body.append('| 目标 `UTIL` | 所需核心面积 µm² | 相对当前缩小 | 边长缩放 |\n|---|---|---|---|')
for t, a, s, sc in rows:
    body.append('| %.2f | %.0f | **%.1f %%** | ×%.3f |' % (t, a, s * 100, sc))
body.append('')
body.append('⇒ 从 0.55 提到 0.70，面积上约可省 **%.1f %%**，边长约 ×%.3f。'
            '**这是面积算术，不是"能收敛"的结论。**\n' % (rows[2][2] * 100, rows[2][3]))
body.append('---\n')
body.append('## 3. 实验该怎么跑（下一轮照此执行）\n')
body.append('**单变量**：只改 `set UTIL`，其余一字不动（RTL/SDC/NDM/deck 都不动）。\n')
body.append('| 步骤 | 命令 | 判据 |\n|---|---|---|')
body.append('| 1 | 以 `UTIL=0.65`（或 0.70）重跑 `bash scripts/run_pnr_paper_core.sh` | 三个阶段产物齐全，不看返回码 |')
body.append('| 2 | `report_utilization` / `report_area` / `report_congestion` | 实测利用率、单元面积、**GRC 溢出** |')
body.append('| 3 | 重跑 STA | **slow clk slack 仍为正**（当前 +0.7947 ns） |')
body.append('| 4 | 重跑 DRC + LVS | DRC 结果数与 **LVS 短路仍为 0** |')
body.append('| 5 | 与 v5.1 基线逐项列表对比 | 得到"密度—拥塞—时序"三方权衡 |')
body.append('')
body.append('**必须一起报的量**：利用率、GRC 溢出、slow slack、DRC 结果数、LVS 短路口径。'
            '**只报面积变小是不合格的。**\n')
body.append('---\n')
body.append('## 4. 为什么本轮没执行\n')
body.append('该实验需要**整轮 P&R + STA + DRC + LVS 重跑**（交付基线一次约 644–720 s，'
            '且 P&R 阶段会 `rm -rf $PRJ/pnr` 重建输出目录）。'
            '在本次核查会话剩余的预算内无法完成，**而半途而废的数字不应写进核查报告**，'
            '所以本项**如实标注为未执行**，并在此把它界定到"照着表格就能跑"的程度。\n')
body.append('---\n')
body.append('## 5. V4 状态\n')
body.append('| 子项 | 状态 |\n|---|---|')
body.append('| **为什么偏散** | **已答**：`set UTIL 0.55`，实测利用率 0.5558，约 44 % 是空行 ✅ |')
body.append('| 拥挤代价的现状 | **已答**：55 % 下已有 2.52 % GRC 溢出 ✅ |')
body.append('| 紧凑化的算术空间 | **已算**（§2，明确标注为算术）✅ |')
body.append('| **紧凑化实验** | **未执行** ❌ —— 步骤与判据已在 §3 写明 |')

io.open(DOC, 'w', encoding='utf-8', newline='').write('\n'.join(body) + '\n')
print('doc written: %s' % os.path.basename(DOC))
print('')
print('arithmetic summary:')
for t, a, s, sc in rows:
    print('  UTIL %.2f -> core %.0f um2 (shrink %.1f %%, linear x%.3f)' % (t, a, s * 100, sc))
