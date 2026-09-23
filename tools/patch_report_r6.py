#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Add round-6 results to the HTML report generator (and record the withdrawal).

NOTE: no ASCII double quotes may appear inside the Chinese prose added here --
that is exactly the bug that broke the generator twice already.
"""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

ANCHOR = '    pb.append(note("<b>结论收窄</b>：库自洽、单元数目完全一致、端口已相等 —— "'
NEW = '''    pb.append("<h4>B.2.1 第 6 轮：又排除三条，并撤回我自己的一条错判</h4>")
    pb.append(tbl(["候选解释", "检验方法", "结果"], [
        ["几何来源可疑（merge 改写了单元）",
         "kit GDS 的内层几何 vs 合并 GDS 的内层几何，逐层直方图比对（7 种单元）",
         b("IDENTICAL", 0) + "；bbox 只差恰好 10×（precision 1000 vs 10000）"],
        ["帧单元的层 141 端口文本在作怪",
         "在隔离目录里把 4 处 <code>PORT LAYER TEXT 141</code> 注释掉重跑 LVS",
         b("数字逐项完全相同", 0) + "（178/179、26761/26876、50、0 全部不变）"],
        ["CDL 器件多重性 <code>M=</code> 口径",
         "在 kit CDL 里检索 <code>M=</code>",
         b("0 处", 0) + " —— 该解释不成立"],
        ["源网表缺器件",
         "按层次递归展开 CDL × 实际放置数，与 Calibre 的源侧计数比",
         b("50026 = 50026，差 0", 0)],
    ]))
    pb.append(note("<b>撤回一条我自己的错判</b>：本轮中途我曾判定『交付 GDS 有结构缺陷 —— "
                   "3626 个标准单元放置指向只有外框的帧单元，真几何被 merge 改名藏到下一层』。"
                   "查过 kit GDS 之后该结论<b>撤回</b>：<b>那是 kit 自己的两级结构</b>，"
                   "合并件忠实复制了它。<br>"
                   "教训：判定『这是 merge 造出来的』之前，先看源文件长什么样 —— 我跳过了这一步。"))
    pb.append(note("<b>结论收窄</b>：库自洽、单元数目完全一致、端口已相等 —— "'''

n = t.count(ANCHOR)
print("anchor hits: %d" % n)
assert n == 1, "anchor must appear exactly once"
t = t.replace(ANCHOR, NEW)

# extend the closing note with the round-6 statement
OLD2 = "这是下一步唯一的目标，不再是「到处都可能是原因」。\"))"
NEW2 = ("这是下一步唯一的目标，不再是「到处都可能是原因」。<br>"
        "<b>第 6 轮进一步把它钉成一个可执行实验</b>：源侧已证明完全正确"
        "（<code>Σ(CDL 展开) = 50026 = Calibre 源计数</code>），几何是 kit 的原件，"
        "CDL 无多重性参数 —— 因此 <b>+660 个物理器件只能是提取器在「单元内容之外」"
        "由放置上下文（相邻单元 abutment / M1 轨 / M2 条带 / 井连接）生成的</b>。"
        "下一步：在被标记单元周围<b>裁剪一小块版图，分别做孤立提取与上下文提取</b>，"
        "比较器件数。判据是器件数差，不再需要新假设。\"))")
print("anchor2 hits: %d" % t.count(OLD2))
assert t.count(OLD2) == 1
t = t.replace(OLD2, NEW2)

io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("generator updated")
