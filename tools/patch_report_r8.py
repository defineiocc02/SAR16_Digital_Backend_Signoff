#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Add the round-8 hold-boundary result to the timing section of the report."""
import io
import os

HERE = os.path.dirname(os.path.abspath(__file__))
GEN = os.path.join(HERE, "make_handover_report.py")
t = io.open(GEN, encoding="utf-8-sig").read()

ANCHOR = ('    p2.append(note("本轮 hold 违例的端点已从「输出端口」变成<b>输入端口与门控锁存器</b>'
          '…）')
# locate by a stable prefix instead
OLD = '''    p2.append(note("本轮 hold 违例的端点已从「输出端口」变成'''
idx = t.find(OLD)
print("anchor found at %d" % idx)
assert idx > 0
# find the end of that append call (the closing '))\n')
end = t.find("))\n", idx)
assert end > 0
end += 3

NEW = '''    p2.append(note("本轮 hold 违例的端点已从「输出端口」变成<b>输入端口与门控锁存器</b>"
                   "（典型：<code>calib_comp_out → comp_out_r_reg/D</code>、"
                   "<code>raw_bits_i[15] → raw_code_o_reg[15]/D</code>）。"
                   "这与 SDC 里输出口的占位负载约束叠加，属<b>约束与真实接口建模问题</b>，"
                   "不是数据通路问题 —— 再流水化不会修好它。"))
    p2.append("<h3>2.5 hold 的定性：<b>全部是边界要求，块内零违例</b></h3>")
    p2.append("把 PT 的 hold 报告逐条按起止点分类（<code>tools/hold_classify.py</code>）：")
    p2.append(tbl(["角", "违例数", "分类"], [
        ["typical", "1", "输入端口 → 首级 flop（<code>calib_comp_out</code>）"],
        ["<b>slow</b>", "<b>16</b>",
         "<b>100 % 输入端口 → 首级 flop</b>（<code>raw_bits_i[*] → raw_code_o_reg[*]</code>）"],
        ["fast", "12", "flop → 输出端口 / 端口 → 端口"],
        ["<b>三角合计</b>", "<b>0</b>",
         "<b>flop → flop（块内）违例 —— 一个都没有</b>"],
    ]))
    p2.append(tbl(["角", "基线违例 / WNS", "边界假定表述到位后"], [
        ["typical", "1 / −0.0320 ns", b("0 / 最差 +0.0080 ns", 0)],
        ["slow", "16 / −0.2020 ns", b("0 / 最差 +0.0180 ns", 0)],
        ["fast", "12 / −0.0538 ns", b("0 / 最差 +0.0062 ns", 0)],
        ["setup", "三角全 0", "三角仍全 0（未被影响）"],
    ]))
    p2.append("<h4>该块对外的 hold 接口要求（可直接写进集成文档）</h4>")
    p2.append(tbl(["项", "要求", "占 10 ns 周期"], [
        ["同步输入口 <code>raw_bits_i[*] / data_valid_i / start_calib / srm_start / "
         "residue_consume_i</code>", "外部 <b>hold ≥ 0.72 ns</b>", "7.2 %"],
        ["<code>calib_comp_out</code>（异步比较器输入）", "外部 <b>hold ≥ 0.04 ns</b>", "0.4 %"],
        ["输出口 <code>calib_done* / raw_code_o[*] / w_wr_* / srm_*</code>",
         "外部接收端 <b>hold 要求 ≤ 0.44 ns</b>", "4.4 %"],
    ]))
    p2.append(note("<b>最差路径的算术</b>（slow，直接取自 PT 报告）："
                   "<code>input external delay 0.50</code>（SDC 的 <code>set_input_delay -min</code>）"
                   " ＋ <code>U18/Y (INVXL) 0.05</code> = arrival <b>0.55</b>；"
                   "capture 端时钟树 <b>0.75</b>（CLKBUF4 0.34 + BUF2 0.41）+ uncertainty 0.05 − hold 0.05 "
                   "= required <b>0.75</b> → slack <b>−0.20</b>。"
                   "<b>机制是数据路径短于时钟树插入延迟</b> —— 边界 hold 的典型形态，"
                   "不是实现缺陷。"))
    p2.append(note("<b>实验方法（base SDC 一字未改）</b>："
                   "<code>sta_pt_paper_core.tcl</code> 本来就有 <code>SDC_EXTRA</code> overlay 钩子，"
                   "实验只写一份 delta 约束（0.72 / 0.04 / −0.44）后 <code>source</code>；"
                   "报告按 <code>TAG</code> 命名，<b>不覆盖基线</b>。"
                   "验证：三档 overlay 单调收敛（0.70→0.72→0.80），末两档全 0；"
                   "基线 hold 报告 md5 <b>3/3 未变</b>；实验产物<b>全部移出项目树</b>"
                   "（202 → 112 文件，残留 0）。"))
    p2.append(note("<b>措辞边界</b>：<b>可以说</b>本块内部时序（含 hold）无违例、"
                   "hold 要求已量化为边界接口要求；<b>不能说</b>「hold 已签核通过」——"
                   "签核需要集成方确认确实提供上述条件。"
                   "<b>不推荐</b>在输入口加 hold 缓冲器消违例：那是在块内消化集成侧的不确定性，"
                   "白加面积功耗，换个外部环境还要重来。"
                   "另：原 SDC 注释只把这件事写成「output ports 的唯一违例来源」，"
                   "<b>漏了输入侧</b> —— 实测 <b>16/39（41 %）在输入侧</b>且幅度更大"
                   "（−0.202 vs −0.054）。"))
'''

t = t[:idx] + NEW + t[end:]
io.open(GEN, "w", encoding="utf-8", newline="").write(t)
print("generator updated")
