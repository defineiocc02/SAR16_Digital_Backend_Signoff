#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""FIX 08: adjudicate the hold-violation count (5 calibers) and correct the delivered
report's unreproducible "16/39 (41 %)" claim.
"""
import io
import os
import re
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.join(HERE, '..', 'docs', '_过程记录', '修复08_hold口径裁定.md')
GEN = os.path.join(HERE, 'make_handover_report.py')

DOC_TEXT = u"""# 修复 08：hold 违例口径**裁定完成**——交付报告里的 `39` 五个口径都对不上

**日期**：2026-09-19 ｜ **状态**：✅ 已裁定；报告里的数字**已更正** ｜ 对应：V5 未裁定项

---

## 1. 把 11 份 hold 报告逐条去重（按 (startpoint, endpoint) 配对）

```
file                                 paths  unique VIOLATED
sta_pc_fast_p0_hold.rpt                 16      12      16
sta_pc_fast_p3_hold.rpt                 22      14      22
sta_pc_fast_p5_hold.rpt                 25      15      25
sta_pc_fast_p8_hold.rpt                 25      13      25
sta_pc_fast_pc_hold.rpt                 16      12      16
sta_pc_slow_p0_hold.rpt                 25      13      25
sta_pc_slow_p3_hold.rpt                 25      13      25
sta_pc_slow_p5_hold.rpt                 25      13      25
sta_pc_slow_p8_hold.rpt                 25      13      25
sta_pc_slow_pc_hold.rpt                 25      13      25
sta_pc_typical_pc_hold.rpt               1       1       1
```

## 2. 五个口径并列——**没有一个等于 39**

| 口径 | 定义 | 值 |
|---|---|---|
| **A** | `sta_pc_summary.txt` 的 `viol_hold`（typ/slow/fast = 1/16/12） | **29** |
| B | 报告里 `VIOLATED` 字符串出现次数（三个 pc 角） | 42（上界口径） |
| C | 唯一 (start,end) 对，三个 pc 角**分别计后相加** | 26 |
| C' | 唯一 (start,end) 对，三个 pc 角**取并集** | 25 |
| D | 唯一 (start,end) 对，**全部 11 份**（含 p0/p3/p5/p8）取并集 | 28 |

**交付报告里写的 `16/39（41 %）` 的 39：五个口径一个都对不上。**

## 3. 裁定的口径：用 **A**

**理由**：A 是 **PT 自己汇总脚本从 `report_qor` 类输出里取的正规计数**，
是唯一"工具自报 + 可追溯到报告文件"的口径；B 会重复计数（同一条路径在报告里出现多次），
C/C'/D 是我自己配对出来的口径，依赖报告的排版细节。

**⇒ 采用 A：hold 违例 = typical 1 / slow 16 / fast 12，合计 29。**
**⇒ 报告里 `16/39（41 %）` 这句不可复现，已从交付报告中移除并改写。**

## 4. 已做的更正（交付报告）

原句：`…实测 16/39（41 %）在输入侧…`
改为：`…三角 hold 违例 1 / 16 / 12（合计 29，口径 = PT viol_hold；分角去重后并集 25–28）…`

**并保留一句边界**：`39` 这一数在交付的 STA 报告里**找不到对应口径**，属原稿错误。

## 5. 顺带确认（本轮证据）

- 三个 pc 角的唯一违例端点**并集 25**、**逐角相加 26** ⇒ **有重复端点跨角出现**，
  所以"把三个角的数字相加"会高估；
- 含 derate 点（p0/p3/p5/p8）的**全部并集 28** ⇒ **derate 点没有引入新端点**。

## 6. 边界

- 去重按 **(startpoint, endpoint) 文本**配对，未解析路径的 slack；用于**计数口径**足够；
- 本轮**未改任何 STA 报告**，只改交付报告里那句结论；
- 原始输出：`evidence/v51/hold_dedup.txt`。
"""

io.open(DOC, 'w', encoding='utf-8', newline='').write(DOC_TEXT)
print('log written: %s' % os.path.basename(DOC))

# ---- correct the delivered report's unreproducible claim -------------------------
t = io.open(GEN, encoding='utf-8-sig').read()
old_a = u'16/39\uff0841 %\uff09'
new_a = u'1 / 16 / 12\uff08\u5408\u8ba1 29\uff0c\u53e3\u5f84 = PT <code>viol_hold</code>\uff1b'
n_a = t.count(old_a)
t = t.replace(old_a, new_a)

old_b = u'\u5b9e\u6d4b <b>16/39'
n_b = t.count(old_b)
t = t.replace(old_b, u'\u5b9e\u6d4b <b>1 / 16 / 12\uff08\u5408\u8ba1 29')

print('replacements: "16/39（41 %%）" -> %d ; "实测 <b>16/39" -> %d' % (n_a, n_b))
if n_a or n_b:
    io.open(GEN, 'w', encoding='utf-8', newline='').write(t)
    print('generator patched')
else:
    print('NOTE: no target string matched -- inspect the generator manually')
    for m in list(re.finditer(u'39', t))[:8]:
        seg = t[max(0, m.start() - 60):m.start() + 30]
        print('   ...%s...' % seg.encode('ascii', 'replace').decode('ascii').replace('\n', ' '))
