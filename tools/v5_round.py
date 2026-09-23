#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""V5 round: write the independent re-verification record AND correct the one number it
caught in my own delivered report.

Caught: the handover report says "39 hold violations (slow 16 / fast 12 / typical 1)".
The raw STA summary says viol_hold = 1 / 16 / 12, whose sum is 29, not 39.
"""
import io
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.join(HERE, '..', 'docs', 'V5_独立复核_时序与DRC与LVS.md')
GEN = os.path.join(HERE, 'make_handover_report.py')

DOC_TEXT = u"""# 独立核查 V5：独立复核时序 / DRC / LVS 结论

**方法**：**不看**任何二手数字，直接从原始报告重新解析，再与项目自己的机读汇总
`RESULT_CURRENT.env` 对差。一条一条列出来，不一致的必须解释。

---

## 1. DRC —— 复现成功 ✅

从 `drc_CAL.SUM` 独立解析：

```
TOTAL DRC RuleChecks Executed:   421
以 RULECHECK 开头的行           : 421
其中带 "= n (true)" 的行        : 421
capped 值合计                   : 2956
TRUE 值合计                     : 3402
```

| 量 | 我的独立解析 | `RESULT_CURRENT.env` | 一致 |
|---|---|---|---|
| 规则条数 | **421** | 421 | ✅ |
| 真实结果数 | **3402** | 3402 | ✅ |

**顺带证实"上限会低估"**：capped 合计 2956 vs 真值 3402，**低估 446 条**——
与交付说明里"结果被 1000 上限截断"一致。

### 1.1 我自己的第一次解析是错的（记录）

第一版正则 `= *(\\d+) *\\((\\d+)\\)` 在全文件范围内乱匹配，报出 **516 条规则 / 367 041 条结果**。
**那是垃圾数字，已作废。** 正确做法：**只取以 `RULECHECK` 开头的行**。

## 2. LVS —— 与已知一致 ✅

| 量 | `lvs.rep` 原文 | 判定 |
|---|---|---|
| verdict | `INCORRECT` | 与 `env[lvs_verdict]` 一致 |
| Ports（初始） | 178 vs 179 | 与既有记录一致 |
| Total Inst（初始） | 50686 vs 50026 | 与既有的 +660 一致 |

## 3. 时序 —— setup 复现成功，**并抓到我自己的一个错数** ❗

`sta/sta_pc_summary.txt` 原始行：

```
STA_RESULT corner=typical viol_setup=0 wns_setup=0.0000 viol_hold=1  wns_hold=-0.0320
STA_RESULT corner=slow    viol_setup=0 wns_setup=0.0000 viol_hold=16 wns_hold=-0.2020
STA_RESULT corner=fast    viol_setup=0 wns_setup=0.0000 viol_hold=12 wns_hold=-0.0538
STA_WORST_SETUP slow  clock=clk slack=0.794725
STA_WORST_SETUP typical clock=clk slack=0.980740
STA_WORST_SETUP fast  clock=clk slack=1.073170
```

| 量 | 原始报告 | 交付报告引用 | 一致 |
|---|---|---|---|
| setup slack（typ/slow/fast） | 0.980740 / 0.794725 / 1.073170 | 0.9807 / 0.7947 / 1.0732 | ✅ |
| setup 违例 | 三角全 0 | 三角全 0 | ✅ |
| hold WNS | −0.0320 / −0.2020 / −0.0538 | 同 | ✅ |
| **hold 违例数** | **1 / 16 / 12（合计 29）** | **「39」** | ❌ **不一致** |

**⇒ 我的接手报告里那句「39 条 hold 违例（slow 16 / fast 12 / typical 1）」是错的。**
三个分角数字都对，**合计应为 29，不是 39**。（16 + 12 + 1 = 29。）
**本轮已把报告里的这个数字改正。** 这正是独立复核要抓的东西——抓的是我自己的错。

### 3.1 顺带发现：机读汇总里**没有 hold 量**

`RESULT_CURRENT.env` 里与 hold 有关的键只有 `dc_hold_viols`（= 105，**综合阶段**的数），
**签核 STA 的 hold 结果一个键都没有**。
⇒ 交付的机读汇总**只覆盖 setup**，hold 结论只存在于 STA 文本报告里。
这是一个**交付完整性问题**，已记录。

## 4. V5 结论

| 项 | 结论 |
|---|---|
| DRC 规则数 / 结果数 | **独立复现，一致** ✅ |
| LVS verdict 与端口/器件数 | **独立复现，一致** ✅ |
| STA setup（三角 slack、0 违例） | **独立复现，一致** ✅ |
| STA hold 分角数字 | 一致 |
| **STA hold 合计** | **我的报告写错，已改正（39 → 29）** ❗ |
| 机读汇总覆盖度 | **缺 hold**（只有综合阶段的 `dc_hold_viols`） |
"""

io.open(DOC, 'w', encoding='utf-8', newline='').write(DOC_TEXT)
print('doc written: %s (%d chars)' % (os.path.basename(DOC), len(DOC_TEXT)))

# ---- correct the number in the report generator ----
t = io.open(GEN, encoding='utf-8-sig').read()
before = t.count('39')
t2, n = re.subn(r'39 \u6761 hold', '29 \u6761 hold', t)
t2, n2 = re.subn(r'\u5171 <b>39</b>', '\u5171 <b>29</b>', t2)
t2 = t2.replace('slow 16 \u00b7 fast 12 \u00b7 typical 1', 'slow 16 \u00b7 fast 12 \u00b7 typical 1')
t2 = t2.replace('slow 16 / fast 12 / typical 1\uff09', 'slow 16 / fast 12 / typical 1\uff0c\u5408\u8ba1 29\uff09')
print('replacements: "39 条 hold" -> %d ; "共 <b>39</b>" -> %d' % (n, n2))
if n or n2:
    io.open(GEN, 'w', encoding='utf-8', newline='').write(t2)
    print('generator updated')
else:
    print('NOTE: no "39" pattern matched -- inspect manually (occurrences of 39: %d)' % before)
