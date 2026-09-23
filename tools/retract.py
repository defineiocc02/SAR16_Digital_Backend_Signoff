#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Retract the disproven claims from the two delivered documents.

Facts as now measured (rounds 26-30):
  * the netlist DOES define the reset: top-level `rst_n` -> INVX8 -> HFSNET_124 ->
    inverters -> HFSNET_119 -> both blocks' rst_n  (two inversions => rst_n)
  * simulation with no forces: rst_n 0->1 makes both blocks' rst_n follow to 1 in 20 ns
  * the FSM works: state 000 -> 010 -> 101, busy 0->1, residue published, shortfall=0
  * only unreproduced item: the top-level total_count/ones_count read 0
"""
import io
import os

D = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'docs')
D = os.path.abspath(D)

CORRECTION = u"""> **⚠ 2026-09-19 更正（第 28–30 轮实测推翻本节）**：交付网表**确实定义了复位，而且工作正常**。
> 反向追踪显示 `rst_n`（顶层端口）→ `INVX8 HFSINV_15503_626` → `HFSNET_124` →
> 一串反相器 → `HFSNET_119` → 两个子模块的 `rst_n`（**两次反相，故等于 `rst_n`**）。
> 无 force 的最简仿真实测：`rst_n` 由 0 抬到 1 后，两个子模块的 `rst_n` **20 ns 内跟随变 1 并保持**。
> 状态机同样正常：`state 000 → 010(S_WAIT) → 101(S_HOLD)`、`busy 0→1`、
> `shortfall=0`、`residue` 已发布。
> **⇒ 本节原来说的「复位无定义 / 必须把 tie 根当复位序列驱动 / 顶层 rst_n 不起作用」
> 全部作废，是本核查方的测量错误。以下原文保留仅为留痕。**
"""

# ---------- 1. interface contract: retract the star section ----------
p1 = os.path.join(D, u'接口契约补充_上电与驱动前提.md')
t1 = io.open(p1, encoding='utf-8').read()
marker = u'## 3. ★ 上电前提（**交付件缺陷，按原样必须遵守**）'
i = t1.find(marker)
print('interface contract: star section at %d' % i)
if i > 0:
    j = t1.find(u'## 4.', i)
    assert j > i
    t1 = t1[:i] + CORRECTION + u'\n' + t1[i:j].replace(u'## 3. ★ 上电前提（**交付件缺陷，按原样必须遵守**）',
                                                       u'## 3. [已作废] 原「上电前提」原文（留痕）') + t1[j:]
    io.open(p1, 'w', encoding='utf-8', newline='').write(t1)
    print('  corrected')
else:
    print('  marker not found -- left unchanged')

# ---------- 2. verification report: retract the headline claims ----------
p2 = os.path.join(D, u'独立核查报告.md')
t2 = io.open(p2, encoding='utf-8').read()
subs = [
    (u'| 交付网表可否被外部驱动 | **不能**：复位无定义 + 主状态机不前进 | V2 第 5–8 轮 |',
     u'| 交付网表可否被外部驱动 | **能**（**原判「复位无定义 + 状态机不前进」已作废**，系本方测量错误）| 第 28–30 轮重测 |'),
    (u'**2. 即使复位正确，主状态机不前进。**',
     u'**2. [已作废] 即使复位正确，主状态机不前进。**  *（第 29 轮在正常复位下重测：`state` 000→010→101、`busy` 0→1、`residue` 已发布 —— 本条系本方测量假象。）*'),
    (u'**1. 交付网表没有定义复位。**',
     u'**1. [已作废] 交付网表没有定义复位。**  *（第 26–28 轮反向追踪与无 force 重测证明：`rst_n` → INVX8 → HFSNET_124 → 反相器 → HFSNET_119 → 两个子模块 rst_n，复位工作正常。本条系本方测量错误。）*'),
]
n = 0
for old, new in subs:
    if old in t2:
        t2 = t2.replace(old, new)
        n += 1
    else:
        print('  NOT FOUND: %s' % old[:40].encode('ascii', 'replace').decode('ascii'))
if n:
    io.open(p2, 'w', encoding='utf-8', newline='').write(t2)
print('verification report: %d of %d claims marked retracted' % (n, len(subs)))

print('')
print('remaining docs/ top level:')
for f in sorted(os.listdir(D)):
    fp = os.path.join(D, f)
    print('  %-40s %s' % (f, 'DIR' if os.path.isdir(fp) else '%d B' % os.path.getsize(fp)))
