#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Round-7 correction into the HTML report: qualify model-derived attributions.

No ASCII double quotes inside the added Chinese prose.
"""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

ANCHOR = '    pb.append("<h4>B.2.1 第 6 轮：又排除三条，并撤回我自己的一条错判</h4>")'
NEW = '''    pb.append("<h4>B.2.1 第 6 轮：又排除三条，并撤回我自己的一条错判</h4>")'''

# insert a new subsection right before the closing boundary section
ANCHOR2 = '    pb.append("<h3>B.3 块自身 abstract：本版本的写出路径不提供</h3>")'
NEW2 = '''    pb.append("<h4>B.2.2 第 7 轮：一次方法学纠错（撤回依赖自研几何模型的归属）</h4>")
    pb.append("为确证『被标记点上有多个相邻实例的扩散重叠』，本轮<b>先做对照</b>："
              "随机取 300 个已放置单元的中心，用同一套代码数覆盖该点的实例数。")
    pb.append(tbl(["样本", "AA 覆盖该点的实例数分布", "GT 覆盖该点的实例数分布"], [
        ["对照：300 个随机单元中心",
         "<b>1→79, 2→154, 3→56, 4→10, 5→1</b>", "1→96, 2→153, 3→45, 4→6"],
        ["被标记的 35 个点", "0→20, 1→11, 2→3, 3→1", "0→17, 1→13, 2→5"],
    ]))
    pb.append(note("<b>普通单元中心在几何上竟有 2–5 个实例的扩散覆盖同一点 —— 这不可能。</b>"
                   "⇒ 该观察是<b>伪影</b>，不是机制。两次修正尝试后对照直方图<b>逐位不变</b>"
                   "（整体平移不改变重叠关系），真正的错误在<b>自研顶层放置模型</b>里，"
                   "我<b>没有查出</b>它错在哪。"))
    pb.append(tbl(["结论", "处置"], [
        ["35 个被标记管『坐在真实 AA+GT 上、归属 INVXL/NOR2XL/DFFSX1…』",
         b("降级为未确证", 1) + " —— 不再引用具体单元名"],
        ["被标记点『跨实例 AA/GT』", b("撤回", 2)],
        ["『交付 GDS 有帧包装结构缺陷』", b("第 6 轮已撤回", 2)],
    ]))
    pb.append(note("<b>教训</b>：<b>没有任何对照的量测结论不得写进报告。</b>"
                   "这次的对照只花 30 秒，却否掉了一条本已准备写进结论的『机制』。"))
    pb.append("<p>以上撤回<b>不影响</b>下面这些事实 —— 它们全部来自 Calibre 自身或名字/计数层面，"
              "不依赖自研几何模型：短路 35→0、端口 178=178、库自洽 109/109、"
              "放置 3626/3626、源侧 50026=50026、版图 +660、CDL 无 <code>M=</code>、"
              "帧的 141 声明与残差无关（隔离实验）、kit 内层几何与合并件 IDENTICAL。</p>")
    pb.append("<h3>B.3 块自身 abstract：本版本的写出路径不提供</h3>")'''

n2 = t.count(ANCHOR2)
print("anchor2 hits: %d" % n2)
assert n2 == 1
t = t.replace(ANCHOR2, NEW2)

# 结论收窄 -> 改成更保守的版本
OLD3 = "下一步：在被标记单元周围<b>裁剪一小块版图，分别做孤立提取与上下文提取</b>，"
NEW3 = ("<b>第 7 轮的对照把这条也降级了</b>：『上下文生成器件』目前<b>只是候选，无正面证据</b>。"
        "若继续追，必须先<b>修好放置模型并用对照证明它是对的</b>"
        "（判据：随机单元中心上覆盖实例数几乎全为 1），在那之前任何基于坐标的归属都不写进报告。"
        "原计划的裁剪式对照实验：")
print("anchor3 hits: %d" % t.count(OLD3))
assert t.count(OLD3) == 1
t = t.replace(OLD3, NEW3)

io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("generator updated")
