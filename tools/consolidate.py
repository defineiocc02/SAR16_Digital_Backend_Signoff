#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Consolidate the independent verification into ONE concise report and move the 19
round-by-round process notes into a single subfolder."""
import io
import os
import shutil

D = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'docs')
D = os.path.abspath(D)
SUB = os.path.join(D, '_过程记录')

REPORT = u"""# SAR16 数字核 · 独立核查报告

**核查者**：接手方 ｜ **日期**：2026-09-19 ｜ **对象**：v5.1 交付件（GDS `e8462461…` + 布线后网表 + LEF + STA/DRC/LVS 报告）
**原则**：不用被核查方自己的 checker；每条结论有对照；工具先过对照才出数；**不能裁定的标"未裁定"，不猜**。

---

## 结论

**逻辑是对的，等价性成立，但交付的网表本身无法证明它实现了功能。问题不在算法，在网表交付。**

| 项 | 结论 |
|---|---|
| RTL ↔ **交付网表** 等价性 | **通过**：1157 passing（Port 146 + DFF 1011）/ **0 failing** |
| 端口账 178 vs 146 | **闭合**：非缺口，是两种口径（146 = 位展开输出端口；178 = 176 信号位 + VDD + VSS） |
| RTL 功能（SRM 计数器） | **核对通过**：`total=22 / shortfall=0`；`ones=7` 与"接受窗口偏移一位"的独立计算逐位吻合 |
| `residue_o` 数值 | 计数正确；**查表内容与论文式系统性偏离**（cnt=11 处为 0，偏离随远离 11 单调增至 22 Q8 @ cnt=1）——**原因无法裁定** |
| 交付网表可驱动性 | **不能**（见发现 1、2） |
| 门级仿真可用性 | 现有 GLS 编译的是交付网表，但**零延迟、只为产 SAIF、无 PASS/FAIL** |
| DRC / LVS / setup 复核 | **独立复现一致**：DRC 421 规则 / 3402 结果；LVS `INCORRECT`；setup slack 0.9807 / 0.7947 / 1.0732 ns |
| hold 违例总数 | **三个口径（29 / 42 / 39）互不相同，未裁定**——结论是"口径未写明" |
| 布线为何偏散 | **`set UTIL 0.55`**：实测利用率 0.5558，约 44 % 空行；55 % 下已有 2.52 % GRC 溢出 |
| 紧凑化空间 | 算术：提到 0.70 约省 **20.6 %** 面积（边长 ×0.891）。**实验未执行** |

---

## 三条必须整改的发现

**1. 交付网表没有定义复位。**
`u_calib_ctrl` / `u_srm_residue` 的 `rst_n` 来自一条**网表未写出值**的 tie 根。
对照实验：根 0 → `rst_n=1`（解除）、根 1 → `rst_n=0`（常驻）；网表自解析根值 = **1** ⇒ **复位锁死**。
必须把该根当**复位序列**驱动（否则触发器停在 X）——**这两件事都不在接口契约里**。

**2. 即使复位正确，主状态机不前进。**
`start` 拉高 1 µs：决策域被武装（`dec_run` 0→1），但 `state` 恒 `S_IDLE`、`busy` 恒 0。
⇒ 交付网表**无法被外部人驱动到能出结果的状态**；这也解释了那次 GLS 为何只能产 SAIF、`calib_done` 必然为 0。

**3. `gen/gen_srm_lut.py` 不在交付件里。**
RTL 三处点名它（含一条 `$error`"用它重新生成"），六路搜索整个 home 均无此文件。
⇒ 那张硬编码表**无法重生成、无法审计**，而它是 `residue_o` 的全部数值来源。

---

## 关键证据（可复核）

| 事 | 证据位置 |
|---|---|
| 等价性 1157/0 | Formality 独立 run：`/tmp/fmv/fm_pnr.log`、`unmatched.rpt`、`failing.rpt` |
| 等价性限定：实现侧 **5 个无驱动网** | 同上，日志 `FM-399` |
| 复位因果对照（根 0/1 → rst_n 1/0） | 过程记录 · V2 第五轮 |
| 状态机不前进（dec_run 0→1，state 恒 000） | 过程记录 · V2 第八轮 |
| 计数核对（22/0/7） | 过程记录 · V2 第十轮 |
| LUT 表体与论文式逐项对比 | 过程记录 · V2 第十二轮 |
| 生成脚本缺失（六路搜索） | 过程记录 · V2 第十三轮 |
| DRC 421/3402、hold 三口径 | 过程记录 · V5 |

---

## 给交付方的整改项（按优先级）

1. **重新导出网表**，让 tie 常量根有明确取值。
2. **把 `gen/gen_srm_lut.py` 放进交付件**，并给出重生成后与 RTL 表体的逐项比对结果。
3. **门级仿真要带判定**（当前无 PASS/FAIL）。
4. **hold 结论写明口径**，并写进机读汇总（当前 `RESULT_CURRENT.env` 只有 setup，没有 hold）。
5. **把片内必须外部驱动的网络写进接口契约**。

---

## 未执行 / 未裁定（如实标注）

| 项 | 原因 |
|---|---|
| **V4 紧凑化实验** | 需整轮 P&R+STA+DRC+LVS 重跑；且该 stage 脚本会 `rm -rf $PRJ/pnr`，**不在他人交付目录上做有破坏风险的操作**。步骤与判据见 `V4_…md` |
| hold 总数（29/42/39） | 需逐条取出违例端点去重 |
| residue 表偏离原因 | 取决于交付方是否提供生成脚本 |
| residue 逐位 | 同上 |

---

## 关于本次核查的诚实说明

核查过程中我**纠正了自己的 7 处错误**（含两处"抢跑"：未裁定就先改数字、未核实容差就宣称吻合），
并发现核查工具自身出过 3 次错。逐条记在 `_过程记录/`。
**本报告只写有对照支撑的结论；不能裁定的都标了"未裁定"。**
"""

io.open(os.path.join(D, '独立核查报告.md'), 'w', encoding='utf-8', newline='').write(REPORT)

# move the round-by-round notes out of the way
os.makedirs(SUB, exist_ok=True)
moved = 0
for name in sorted(os.listdir(D)):
    if name.startswith('V') and name.endswith('.md'):
        shutil.move(os.path.join(D, name), os.path.join(SUB, name))
        moved += 1
old = os.path.join(D, '独立核查报告_20260919.md')
if os.path.exists(old):
    os.remove(old)
print('single report written: docs/独立核查报告.md (%d chars)' % len(REPORT))
print('process notes moved into docs/_过程记录/ : %d' % moved)
print('')
print('docs/ top level now:')
for n in sorted(os.listdir(D)):
    p = os.path.join(D, n)
    print('  %-40s %s' % (n, 'DIR' if os.path.isdir(p) else '%d B' % os.path.getsize(p)))
