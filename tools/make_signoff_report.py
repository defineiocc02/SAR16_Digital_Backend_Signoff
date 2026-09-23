#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SAR16 签核报告：GDS 版图 / 布线 / DRC·LVS / 功能 / 时序（单文件 HTML，图片内嵌）。

Structure rules this rewrite follows (the previous revision violated all of them):
  * conclusions first, data after -- a reader must be able to stop after the first screen;
  * one topic appears in exactly ONE section (no duplicated tables, no second "derate" section);
  * figures are numbered strictly in document order, checked by the self-test at the end;
  * every number carries its source, and anything not measured is marked as such.
"""
import base64
import hashlib
import io
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
FIGDIR = os.path.join(HERE, '..', 'evidence', 'figures')
FIG_HASH = {}
OUT = (u"D:\\<vault>\\Document\\Obsidian\\\u65e5\u5e38\\10_\u9879\u76ee\u533a\\"
       u"2025_16bit5Msar\\04_\u5de5\u4f5c\u8bb0\u5f55\\"
       u"SAR16_\u7b7e\u6838\u62a5\u544a_GDS\u7248\u56fe_\u5e03\u7ebf_\u529f\u80fd_\u65f6\u5e8f_20260919.html")

CSS = """
:root{--bg:#F7F8FA;--ink:#1F2328;--ink2:#4B5563;--ink3:#6B7280;--line:#E5E7EB;
 --bad:#DC2626;--ok:#059669;--warn:#B45309}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);
 font-family:"Segoe UI","Microsoft YaHei",system-ui,sans-serif;line-height:1.62;font-size:14.5px}
.wrap{max-width:1150px;margin:0 auto;padding:34px 22px 80px}
h1{font-size:27px;margin:0 0 4px}
h2{font-size:20px;margin:46px 0 12px;padding:11px 16px;border-radius:10px;color:#fff;
 background:linear-gradient(90deg,#FF6B6B,#4ECDC4)}
h3{font-size:16.5px;margin:26px 0 8px;padding-left:10px;border-left:4px solid #4ECDC4}
h4{font-size:14.5px;margin:18px 0 6px;color:#4B5563}
.sub{color:#6B7280;font-size:13.4px;margin:0 0 18px}
.ask{color:#0F766E;font-size:13.4px;margin:0 0 10px;font-weight:600}
table{width:100%;border-collapse:collapse;margin:12px 0;font-size:13.1px;background:#fff;
 border:1px solid #E5E7EB;border-radius:8px;overflow:hidden}
th{background:#F3F4F6;text-align:left;padding:7px 10px;border-bottom:1px solid #E5E7EB;
 font-weight:600;color:#4B5563}
td{padding:6px 10px;border-bottom:1px solid #F1F2F4;vertical-align:top}
tr:last-child td{border-bottom:none}
code{font-family:Consolas,"Courier New",monospace;font-size:12.3px;background:#F3F4F6;
 padding:1px 5px;border-radius:4px;color:#111827}
pre{background:#0F172A;color:#E5E7EB;padding:13px 15px;border-radius:10px;overflow-x:auto;
 font-family:Consolas,monospace;font-size:12.3px;line-height:1.5}
.note{background:#FFF9E8;border-left:4px solid #F59E0B;padding:10px 14px;border-radius:6px;
 font-size:13.1px;color:#4B3A00;margin:12px 0}
.ok{background:#ECFDF5;border-left:4px solid #059669;padding:10px 14px;border-radius:6px;
 font-size:13.1px;color:#064E3B;margin:12px 0}
.bad{background:#FEF2F2;border-left:4px solid #DC2626;padding:10px 14px;border-radius:6px;
 font-size:13.1px;color:#7F1D1D;margin:12px 0}
.bdg{display:inline-block;padding:1.5px 8px;border-radius:20px;font-size:11.5px;font-weight:600;white-space:nowrap}
.bdg.ok{background:#E7F6EE;color:#059669;border:none}
.bdg.bad{background:#FDECEC;color:#DC2626;border:none}
.bdg.warn{background:#FEF3E2;color:#B45309;border:none}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:11px;margin:14px 0}
.kpi{background:#fff;border:1px solid #E5E7EB;border-radius:11px;padding:12px 15px}
.kpi .k{font-size:11.6px;color:#6B7280;letter-spacing:.3px;text-transform:uppercase}
.kpi .v{font-size:19px;font-weight:700;margin:3px 0 2px;font-family:Consolas,monospace}
.kpi .d{font-size:12.1px;color:#4B5563}
.toc{background:#fff;border:1px solid #E5E7EB;border-radius:11px;padding:13px 20px}
.toc a{color:#0F766E;text-decoration:none;font-size:13.5px}.toc li{margin:3px 0}
figure{margin:18px 0;background:#fff;border:1px solid #E5E7EB;border-radius:12px;padding:11px}
figure img{width:100%;display:block;border-radius:8px;background:#0B0F19}
figcaption{font-size:12.6px;color:#4B5563;margin-top:9px}
.foot{margin-top:38px;color:#6B7280;font-size:12.4px;border-top:1px solid #E5E7EB;padding-top:13px}
.summary{background:#fff;border:1px solid #E5E7EB;border-left:6px solid #059669;
 border-radius:10px;padding:14px 20px;margin:16px 0}
.summary li{margin:5px 0}
"""

T = []
ARITY_BAD = []
FIG_SEQ = []
FIG_MISSING = []


def w(s):
    T.append(s)


def tbl(head, rows, cap=None):
    for r in rows:
        if len(r) != len(head):
            ARITY_BAD.append((len(head), len(r), str(r[0])[:40]))
    w('<table><thead><tr>' + ''.join('<th>%s</th>' % h for h in head) + '</tr></thead><tbody>')
    for r in rows:
        w('<tr>' + ''.join('<td>%s</td>' % c for c in r) + '</tr>')
    w('</tbody></table>')
    if cap:
        w('<p class="sub" style="margin:-4px 0 12px">%s</p>' % cap)


def kpi(items):
    w('<div class="grid">')
    for k, v, d in items:
        w('<div class="kpi"><div class="k">%s</div><div class="v">%s</div><div class="d">%s</div></div>' % (k, v, d))
    w('</div>')


def fig(name, caption):
    """Number figures in document order, embed as a data: URI (so the report displays with
    no external files), and additionally link to the full-resolution PNG that ships beside
    the report -- a 2 275 px wide panel scaled into a 1 100 px column loses the fine detail
    that the layout pictures exist to show."""
    FIG_SEQ.append(name)
    n = len(FIG_SEQ)
    p = os.path.join(FIGDIR, name)
    if not os.path.exists(p):
        FIG_MISSING.append(name)
        w('<div class="bad">图 %d 缺失：<code>%s</code></div>' % (n, name))
        return
    raw = io.open(p, 'rb').read()
    FIG_HASH[name] = hashlib.md5(raw).hexdigest()
    b64 = base64.b64encode(raw).decode('ascii')
    w('<figure><a href="SAR16_%s/%s" target="_blank" title="点击打开原分辨率 PNG">'
      '<img alt="%s" src="data:image/png;base64,%s"></a>'
      '<figcaption><b>图 %d</b>　%s'
      '<span style="color:#6B7280">（点图可开原分辨率 PNG）</span></figcaption></figure>'
      % (u'\u56fe_20260919', name, name, b64, n, caption))


# ═══════════════════════════════════════════════════════════ header
w('<h1>SAR16 片上数字核 · 签核报告</h1>')
w('<p class="sub"><b>对象</b>：v5.1 交付件 —— GDS <code>e8462461…</code>（4 243 084 B）、布线后网表 '
  '<code>sar_digi_paper_core_pnr.v</code>、LEF、STA / DRC / LVS 报告<br>'
  '<b>日期</b>：2026-09-19　｜　<b>图</b>：GDS 版图 4 张（逐点渲染，含单元内部）、分析图 8 张<br>'
  '<b>读法</b>：先看下面的“结论速览”，需要细节再按目录进各节。每个数字都注了出处，'
  '没测过的一律标“未测/未闭合”，不猜。</p>')

w('<div class="summary"><b>结论速览</b><ul>'
  '<li><b>版图是完整可用的数字核</b>：3 626 个标准单元 + 顶层布线，六层金属全用上，'
  'die 430.520 × 429.340 µm，利用率 <b>0.5558</b>（设定值 <code>UTIL 0.55</code>）。</li>'
  '<li><b>布线栈规矩</b>：M1 水平 → M2 垂直 → M3 水平 → M4 垂直 → M5 水平 → M6 垂直，'
  '每层首选方向占比 ≥ 96 %；信号线宽就是各层 DRC 最小线宽（M1 0.230、M2–M5 0.280 µm）。</li>'
  '<li><b>但上面两层几乎没用</b>：M5 只有 212 个矩形、M6 只有 9 个（扁平化后）；'
  'M1–M2、M2–M3 两级过孔占 <b>83 %</b>，M5–M6 只剩 <b>6 个</b>过孔。</li>'
  '<li><b>布线偏散的根因是设定值</b>：<code>set UTIL 0.55</code> ⇒ 实测 0.5558，'
  '核心区约 44 % 的行是空的；不是布线器做不到。</li>'
  '<li><b>DRC 421 规则 / 3 402 结果（下界）</b>：其中封环规则 2 条被 1000 上限截断、'
  '密度规则 7 条各 1 条，<b>真正要动版图的金属几何只有 215 条</b>（M1 间距 177 条为主）。</li>'
  '<li><b>LVS 未收敛</b>：<span class="bdg bad">INCORRECT</span>，端口 <b>178 = 178</b>、'
  '<b>0 条 SHORT</b>、50 条错误网（首两条 VDD/VSS 连接数不符）。</li>'
  '<li><b>功能可用</b>：RTL ↔ 交付网表 <b>1157 passing / 0 failing</b>；同一激励下顶层端口 '
  '<code>total=22 / ones=7 / residue=966</code>，与 RTL 逐位相同（全程无 force）。</li>'
  '<li><b>时序：setup 全部为正</b>（typ +0.9807 / slow +0.7947 / fast +1.0732 ns，0 违例）；'
  '<b>hold 有 29 条违例</b>（1/16/12），根因是“输入端口直进触发器 + <code>min</code> 输入延迟 0.50 ns”'
  '对 0.75 ns 时钟树，<b>不是布线绕远</b>。</li>'
  '<li><b>三项未闭合</b>：LVS 残差未消到 0；hold 29 条已裁定未修复；V4 紧凑化实验未执行。</li>'
  '</ul></div>')

kpi([
    ('die / 利用率', '430.520 × 429.340 µm', '184 839.457 µm²；<b>0.5558</b>（设定 0.55）'),
    ('单元 / 端口', '3 626 / 178', '109 种 master；178 = 176 信号 + VDD + VSS'),
    ('金属层使用', 'M1–M6 全覆盖', '但 M5 仅 212、M6 仅 9 个矩形'),
    ('DRC / LVS', '421 / 3 402（下界）', 'LVS <b>INCORRECT</b>，端口 178=178、0 SHORT'),
    ('功能', '1157 passing / 0 failing', '端到端 22 / 7 / 966，与 RTL 逐位相同'),
    ('setup / hold', '+0.7947 ns（slow） / 29 条', 'setup 0 违例；hold 1/16/12'),
])

w('<div class="toc"><b>目录</b><ul>'
  '<li><a href="#gds">§1　GDS 版图</a>——四张逐点渲染的版图图片 + 交付身份</li>'
  '<li><a href="#route">§2　布线分析</a>——逐层几何 / 过孔 / 密度 / 为什么偏散</li>'
  '<li><a href="#phy">§3　物理验证</a>——DRC 与 LVS</li>'
  '<li><a href="#fun">§4　功能</a>——等价性 / 端到端 / 复位与状态机 / LUT / 门级仿真</li>'
  '<li><a href="#tim">§5　时序</a>——setup / hold 口径与机制 / 时钟树</li>'
  '<li><a href="#ev">§6　口径、证据与自我更正</a></li>'
  '</ul></div>')

# ═══════════════════════════════════════════════════════════ 1 GDS 版图
w('<h2 id="gds">§1　GDS 版图</h2>')
w('<p class="ask">本节回答：交付的 GDS 打开以后到底长什么样？</p>')
w('<p>下面四张图都是<b>直接解析交付 GDS 逐点渲染</b>的，不是示意图：把 <b>34 356 个 <code>SREF</code> 实例</b>'
  '连同镜像/旋转变换<b>递归展开两级</b>（顶层 → 单元包装 → 单元本体），再把展开后 '
  '<b>360 031 个矩形</b>按层着色画出来。这正是版图浏览器里看到的东西。</p>')
w('<div class="note"><b>为什么必须展开两级</b>：这份 GDS 的层次是两层的——顶层引用的是 <code>AND2XL</code> 这类'
  '<b>包装 struct</b>，包装里只画了层 127（单元轮廓）并再引用真正的单元本体（如 <code>and2_lxawwqwwwwwcuo55yy</code>），'
  '晶体管几何在<b>本体</b>里。只展开一级会得到“没有任何晶体管的版图”，本方的第一版渲染就是这样，已修正。</div>')
tbl(['层', '含义', '展开后矩形数', 'Calibre 自报同层计数', '对账'], [
    ('10', 'AA 有源区', '20 929', '20 929', '✅ 完全相同'),
    ('14', 'NW N 阱', '3 626', '3 626（每单元一个）', '✅ 完全相同'),
    ('30', 'GT 多晶硅', '72 588', '72 588', '✅ 完全相同'),
    ('40 / 43', 'SN / SP 注入', '7 252 / 7 252', '7 252 / 7 252', '✅ 完全相同'),
    ('50', 'CT 接触孔', '86 445', '86 445', '✅ 完全相同'),
    ('61', 'M1', '52 756（含过孔焊盘）', '52 750', '≈ 差 6'),
    ('70', 'V1 切孔', '15 855', '15 849', '≈ 差 6'),
    ('62 / 63 / 64 / 65', 'M2 / M3 / M4 / M5', '44 451 / 26 311 / 6 008 / 212', '44 445 / 26 311 / 6 008 / 212', '✅ M3–M5 完全相同'),
], '<b>层号不是猜的</b>：把每一层的展开矩形数与 Calibre 从同一份 GDS 抽出的 <code>ORIGINAL LAYER STATISTICS</code> '
   '逐层比对得到——这也同时证明<b>本方的层次展开是正确的</b>。'
   '（早先按 deck 猜的“14=GT、50=NW”是错的，实为 <b>14=NW 阱、50=CT 接触孔</b>。）')

fig('gds_full.png',
    '<b>整片版图（flattened）</b>。左下角是各层图例。可以看到：单元区在片内基本铺满但有疏密差异，'
    '顶层布线压在单元之上，四边是端口引出区。层号含义由 <code>tools/gds_layer_inventory.py</code> 实测得出；'
    '<b>层 127 是“每个单元的轮廓线”，若填色会把每个单元画成实心块，因此只列在图例里不填充</b>。')

fig('gds_zoom3.png',
    '<b>同一区域的三级放大（80 / 20 / 5 µm）</b>。这是整片最密的窗口（中心约 265, 115 µm）。'
    '5 µm 那级可以看到标准单元内部的多晶硅栅（红）、有源区（暗绿）、以及压在单元行上面的 '
    'M1（蓝）/M2（橙）/M3（绿）三层布线。')

fig('gds_split.png',
    '<b>同一 30 × 30 µm 窗口，一层层加上去</b>。① 只有器件层：深绿 = AA 有源区，红 = GT 多晶硅栅'
    '（栅条横跨有源区，就是标准单元里的晶体管），灰 = NW 阱，浅点 = CT 接触孔；'
    '② 加上单元内部的金属与过孔；③ 再加上顶层布线（P&R 的轨与信号线）。')

fig('gds_layers_flat.png',
    '<b>逐层展开图（含单元内部）</b>。与 §2.1 的“顶层自己画的”口径不同，这里每层都含单元内部，'
    '并含过孔自身的焊盘。矩形数：M1 52 756 / M2 44 451 / M3 26 311 / M4 6 008 / '
    '<b>M5 212 / M6 9</b> —— M5、M6 两张几乎空白，因为这两层确实只承载极少数长连线。')

w('<h3>1.1　交付身份（可复算）</h3>')
tbl(['项', '值', '出处'], [
    ('GDS', '4 243 084 B，md5 <code>e846246127c86f3a4256a34de2ff7344</code>（与 VM 交付件逐字节相同）', '本地复算'),
    ('顶层 cell / struct 数 / 层对', '<code>sar_digi_paper_core</code> / <b>225</b> / 19', '<code>RESULT_CURRENT.env</code>'),
    ('数据库单位', '<b>10000 DBU/µm</b>（自解析文件头，非文档转抄）', '<code>tools/gds_routing.py</code>'),
    ('布线后网表 / LEF / SPEF', '378 258 B / 179 611 B / 6 958 499 B', '<code>RESULT_CURRENT.env</code>'),
    ('die / 核心容量', '430.520 × 429.340 µm = 184 839.457 µm²；capacity 184 066.344 µm²', '<code>fc_util.rpt</code>'),
    ('单元面积 / 利用率', '<b>102 300.11 µm²</b> / <b>0.5558</b>', '<code>fc_qor.rpt</code> / <code>fc_util.rpt</code>'),
    ('单元数 / 寄存器数', '3 626（组合 2 575 + 时序 1 051）', '<code>fc_qor.rpt</code>'),
    ('Buf / Inv', '195 / 326（面积 2 967.15 / 2 913.93 µm²）', '同上'),
], '“利用率 = 102 300.11 / 184 066.34 = 0.5558”与工具自报一致 ⇒ 行空 44 % 是<b>设定的目标值</b>。')

w('<h3>1.2　放置账与端口账（三方对账）</h3>')
tbl(['项', '数量', '对账结果'], [
    ('顶层 <code>SREF</code> 总数', '34 356', '= 30 730 过孔 + <b>3 626</b> 单元'),
    ('标准单元放置', '<b>3 626</b>', '网表 leaf cell <b>3 626</b> ✅ 与 LVS 元器件数一致'),
    ('过孔阵列 <code>$$via*</code>', '30 730（6 种）', '见 §2.2'),
    ('master 种类', '<b>115</b> = 6 过孔 + <b>109</b> 库单元', 'LEF / LVS 的 109 种 ✅'),
    ('顶层端口标签（<code>TEXT</code>）', '<b>178</b>，且<b>178 个都不重名</b>', '= LVS 端口 <b>178</b> ✅ = 176 信号 + VDD + VSS'),
    ('标签所在层', '<code>M2</code> 90 个 / <code>M3</code> 88 个', 'M2 全在上下边（46+44）；M3 全在左右边（44+44），<b>零交叉</b>'),
    ('全文件 <code>TEXT</code> 记录', '808 条 / 110 个 struct', '单元内部标签不是端口，<b>只有顶层标签才是端口</b>'),
], '放置账出自 <code>evidence/v51/gds_routing_census.txt</code>；端口账出自 <code>evidence/v51/gds_ports.txt</code>。')

w('<h4>端口在版图里是怎么排的（逐条实测）</h4>')
tbl(['边', '层', '端口数', '沿边范围 µm', '间距中位 µm', '间距取值 µm', '引脚形状 µm'], [
    ('上', '<code>M2</code>', '<b>46</b>（44 信号 + VDD + VSS）', '8.580 – 425.000', '<b>9.90</b>', '8.58 / 9.24 / 9.90 / 10.56 / 11.22',
     '信号 0.280 × 0.715；<b>VDD/VSS 0.600 × 428.400</b>'),
    ('下', '<code>M2</code>', '44', '8.580 – 421.740', '<b>9.90</b>', '8.58 / 9.24 / 9.90 / 10.56', '0.280 × 0.715'),
    ('左', '<code>M3</code>', '44', '4.480 – 417.760', '<b>9.52</b>', '8.96 / 9.52 / 10.08', '0.715 × 0.280'),
    ('右', '<code>M3</code>', '44', '4.480 – 417.760', '<b>9.52</b>', '8.96 / 9.52 / 10.08', '0.715 × 0.280'),
], '出处 <code>evidence/v51/port_layout.txt</code>（工具 <code>tools/gds_port_layout.py</code>）。'
   '<b>178 个标签全部落在真实金属图形上</b>（0 个落空），所以它们是<b>引脚</b>而不是纯标注。'
   '左右两边连间距取值都完全相同 ⇒ 两侧是对称排的。')
tbl(['要素', '实测', '含义'], [
    ('引脚层', '只有 <code>M2</code> 与 <code>M3</code>', '没有用 M4–M6 做再分布'),
    ('引脚尺寸', 'M2：0.280 × 0.715 µm；M3：0.715 × 0.280 µm', '都是<b>最小线宽</b>的短棒，长度 0.715 µm'),
    ('电源', '<b>VDD/VSS 是两条贯穿全高的 M2 条带</b>（0.600 × 428.400 µm，即 428.4 µm = 几乎整个 die 高）',
     'VDD 在 x=425.000、VSS 在 x=412.500（均在上边）'),
    ('最密处', '上边 <code>raw_bits_i[0]</code> ↔ <code>VSS</code> 仅隔 <b>1.320 µm</b>；'
     '<code>raw_bits_i[1]</code> ↔ <code>VDD</code> 隔 3.260 µm', '电源条带与相邻信号引脚的间距是全场最小'),
    ('离 die 边的距离', '标签坐标 0.357 – 429.303 µm（四边内缩约 0.36 µm）', '引脚就贴在版图边界内侧'),
    ('方向与层的对应', 'M2（垂直布线层）→ 上下边；M3（水平布线层）→ 左右边，<b>零交叉</b>',
     '与 §2.1 的方向偏好一致：出线方向顺着该层的首选方向'),
], '<b>这不是键合焊盘</b>：0.28 µm 宽的引脚、9.5–9.9 µm 的间距，是<b>块级（core）引脚</b>，'
   '需要在更大的芯片里被上层实例化后再接 pad/焊盘环。'
   '这也与 DRC 里封环规则整片触发（本件无封环）互相印证——交付的是一个数字核，不是可单独封装的芯片。')
w('<div class="note"><b>端口按方向分层引出</b>：M2 是垂直布线层，所以 90 个引脚全在上下边；'
  'M3 是水平层，所以 88 个引脚全在左右边。这条是从版图标签坐标直接量出来的，'
  '也解释了为什么端口在四边看起来“近似均布”（44/44/44/46）——那其实是两层各自成对出现的结果。</div>')
w('<div class="bad"><b>交付说明里的“顶层 234 个 TEXT 标签 = 232 个信号引脚”无法从本交付件复现</b>：'
  '实测顶层是 <b>178</b> 个不重名标签，全文件 808 条也不是 234。该段所在小节在交付说明里被注明为'
  '“v4.3 时点的历史记录、保留不改”，而 v5.1 的接口收窄（<code>srm_residue_o</code> 30 位 → 10 位等）'
  '确实会减少引脚。<b>v5.1 的正确写法是 178 个端口 = 176 信号 + VDD + VSS</b>（与 LVS 一致）。</div>')

fig('fig2_place.png',
    '<b>放置图与端口图</b>。左：3 626 个标准单元的实际位置（按每个 master 的真实包围盒画），'
    '覆盖全片（x 0.00–429.66 µm，y 5.04–428.40 µm），但疏密不均：左下 107 × 107 µm 区域只有 '
    '<b>13</b> 个单元，而最密的同尺寸区域有 <b>345</b> 个。'
    '右：178 个端口标签——橙 = M2（全在上下边），绿 = M3（全在左右边）。')

# ═══════════════════════════════════════════════════════════ 2 布线
w('<h2 id="route">§2　布线分析</h2>')
w('<p class="ask">本节回答：线是怎么走的？各层各承担多少？为什么看起来偏散？</p>')

w('<h3>2.1　逐层几何：方向、线宽、线长（顶层自己画的）</h3>')
w('<p>这一节的统计口径是<b>顶层 cell 自己画的几何</b>（电源轨 / 带 / 信号线），'
  '不含单元内部——因为“布线质量”看的是 P&R 走了什么。单元内部的金属量见 §1 的逐层展开图与 §2.3 的密度。</p>')
tbl(['层', '矩形数', '面积 µm²', '水平线长 µm', '垂直线长 µm', '总线长 µm', '方向', '线宽 µm'], [
    ('M1', '7 912', '31 838', '44 959.7', '1 306.5', '46 266.2', '<b>H</b>（97 %）', '0.230'),
    ('M2', '17 445', '25 571', '3 178.3', '<b>71 243.8</b>', '74 422.1', '<b>V</b>（96 %）', '0.280'),
    ('M3', '10 114', '29 242', '<b>103 744.5</b>', '690.0', '<b>104 434.5</b>', '<b>H</b>（99 %）', '0.280'),
    ('M4', '2 290', '15 630', '120.8', '55 693.3', '55 814.1', '<b>V</b>（99.8 %）', '0.280'),
    ('M5', '72', '1 591', '5 675.8', '7.9', '5 683.7', 'H', '0.280'),
    ('M6', '3', '97', '0.0', '220.9', '220.9', 'V', '0.440'),
    ('<b>合计</b>', '<b>37 836</b>', '<b>103 969</b>', '<b>157 679.1</b>', '<b>129 162.4</b>', '<b>286 841.5</b>', '—', '—'),
], '全部图形都是 <code>BOUNDARY</code>，没有一条 <code>PATH</code>；37 836 个全是矩形（收口 5 点多边形，无 L 形）。'
   '“线长”= 每个矩形长边之和；它与 <code>fc_qor.rpt</code> 的“净线长 251 748.55 µm”<b>口径不同、不应相等</b>。'
   '出处 <code>evidence/v51/gds_layer_routing.txt</code>。')
w('<div class="ok"><b>布线栈是标准交替方向结构</b>，且<b>线宽就是各层 DRC 最小线宽</b>'
  '（M1 ≥ 0.23、M2 ≥ 0.28 µm）——说明用最小宽度换密度，没有为良率加宽。'
  'M3 承担最多走线（104.4 mm），M5 + M6 合计只有 5.9 mm。</div>')
w('<p class="sub">M1 上那 86 条宽水平带以<b>严格 5.04 µm 间距</b>重复（86 × 5.04 ≈ 433 µm ≈ die 高），'
  '即标准单元行的电源/地轨。宽 0.5–0.99 µm 的图形共 M1 144 个、M2 149 个，就是这些轨与带；其余信号线全在最小宽度。</p>')

fig('fig5_width.png',
    '<b>绘制线宽分布（对数纵轴）</b>。信号线集中在各层最小宽度档位；只有 M1/M2 有少量 0.5–0.99 µm 宽图形，'
    '即电源轨与带。')
fig('fig4_layer_stats.png',
    '<b>各层四个统计量</b>：矩形数、面积、走线长度（按方向拆分）、金属密度。'
    '右下虚线是 DRC 的 30 % 密度下限：<b>M1 为 29.23 %，只差 0.77 个点</b>，其余层远低于阈值。')

w('<h3>2.2　层间连接：过孔分布</h3>')
tbl(['过孔 master', '连接层', 'master 内实际层号', '放置次数', '占比'], [
    ('<code>$$via1</code>', 'M1–M2', '61, 62, 70（切孔）', '<b>12 931</b>', '42.1 %'),
    ('<code>$$via1_5200_5200_1_2</code>', 'M1–M2（1×2 阵列）', '61, 62, 70', '1 462', '4.8 %'),
    ('<code>$$via2</code>', 'M2–M3', '62, 63, 71', '<b>12 613</b>', '41.0 %'),
    ('<code>$$via3</code>', 'M3–M4', '63, 64, 72', '3 584', '11.7 %'),
    ('<code>$$via4</code>', 'M4–M5', '64, 65, 73', '134', '0.44 %'),
    ('<code>$$via5</code>', 'M5–M6', '65, 66, 74', '<b>6</b>', '0.02 %'),
    ('<b>合计</b>', '—', '—', '<b>30 730</b>', '100 %'),
], '切孔层号在本文件里是 <b>70–74</b>（依次对应 via1–via5），与本方早先从 LVS deck 假设的 67–72 '
   '<b>不是一套编号</b>，故此处直接打印原文层号、不翻译成名字。')
w('<div class="ok"><b>连接性高度集中在下面三层</b>：M1–M2 与 M2–M3 两级占 <b>83 %</b>；'
  '到 M4–M5 只剩 134 个、M5–M6 只剩 <b>6 个</b>。⇒ <b>M5/M6 只是几条长线，不构成布线资源</b>。</div>')
fig('fig6_vias.png', '<b>层间过孔数量（对数纵轴）</b>。上层金属在电气上几乎孤立。')

w('<h3>2.3　各层金属密度（Calibre 实测，含单元内部）</h3>')
tbl(['层', '密度', '判定阈值', '按密度折算的金属面积 µm²'], [
    ('M1', '<b>29.23 %</b>', '≥ 30 %（差 0.77 点）', '54 034'),
    ('M2', '14.01 %', '≥ 30 %', '25 894'),
    ('M3', '15.79 %', '≥ 30 %', '29 190'),
    ('M4', '8.48 %', '≥ 30 %', '15 677'),
    ('M5', '<b>0.86 %</b>', '≥ 30 %', '1 594'),
    ('MT/M6', '<b>0.053 %</b>', '≥ 30 %', '98'),
    ('GT poly', '未取到数字', '≥ 14 %', '—'),
], '出处：VM <code>calibre/drc/density_report_M*_7.log</code> 原文，窗口 = 整 die'
   '（−0.43,−0.54 → 430.09,428.80）。这 7 个数字就是 DRC 里 <code>M1_7…M5_7</code>、<code>MT_6</code>、'
   '<code>GT_12</code> 各 1 条结果的<b>全部内容</b>——属填充/dummy 问题，不是布线间距问题。')
w('<div class="note"><b>与 §2.1 的差异是口径差</b>：密度算整片版图（含单元内部），§2.1 只算顶层画的。'
  'M1：29.23 % × 184 839 µm² = 54 034 µm² ≥ 顶层 M1 的 31 838 µm² ✔ 自洽。</div>')

w('<h3>2.4　拥塞、线长与时钟树</h3>')
tbl(['项', '值', '出处'], [
    ('GRC 总溢出 / 有溢出的 GRC', '511 / <b>364（2.52 %）</b>', '<code>fc_congestion.rpt</code>'),
    ('其中垂直 / 水平', 'V 427（4.11 %）/ H 84（0.93 %）', '同上'),
    ('布线器自报净线长', '251 748.55 µm（X 129 811.03 + Y 121 937.52）', '<code>fc_qor.rpt</code>'),
    ('<code>clk</code> 树：sink / 级数 / 缓冲', '<b>1 034</b> / 4 / 20', '<code>fc_clock_qor.rpt</code>'),
    ('<code>dec_clk</code> 树：sink / 级数 / 缓冲', '<b>17</b> / 2 / 1', '同上'),
    ('<code>clk</code> 最大延迟 / 全局 skew', '0.81 ns / <b>0.51 ns</b>', '同上'),
    ('设计规则违例', '3 797 条网中 <b>1 条</b>违例（Max Transition 1 / Max Cap 0）', '<code>fc_qor.rpt</code>'),
])

w('<h3>2.5　为什么布线偏散，以及紧凑化空间</h3>')
w('<div class="ok"><b>根因（有对照）</b>：<code>set UTIL 0.55</code> ⇒ 工具自报利用率 <b>0.5558</b>，'
  '核心区约 <b>44 % 的行是空的</b>；扁平化后 M5 仅 212、M6 仅 9 个矩形，M2 一层承担 46 % 的顶层图形。'
  '⇒ 稀疏来自<b>设定的目标利用率</b>，不是布线器做不到。</div>')
tbl(['项', '值', '性质'], [
    ('当前利用率', '0.5558', '工具自报，与设定一致'),
    ('若提到 0.70（线性外推）', '面积约 <b>−20.6 %</b>，边长 ×0.891', '算术推算，<b>不是实测</b>'),
    ('代价', '55 % 下已有 2.52 % GRC 溢出（垂直向 4.11 %）', '提高利用率须整轮重跑 P&R + STA + DRC + LVS'),
    ('本方的执行决定', '<b>未执行</b>实验', '该 stage 脚本会 <code>rm -rf $PRJ/pnr</code>；'
     '不在他人交付目录上做有破坏风险的操作'),
])

# ═══════════════════════════════════════════════════════════ 3 物理验证
w('<h2 id="phy">§3　物理验证：DRC 与 LVS</h2>')
w('<p class="ask">本节回答：这份版图过没过规则？没过的话是哪一类、要不要改版图？</p>')

w('<h3>3.1　DRC：421 条规则，16 条命中，按性质分三类</h3>')
tbl(['项', '值'], [
    ('规则文件 / Calibre 版本', '<code>mydrc.drc</code> / v2025.1_16.10'),
    ('列出的 rulecheck 数', '<b>421</b>'),
    ('有结果的 rulecheck 数', '<b>16</b>'),
    ('结果总数（摘要第 2 列求和）', '<b>3 402</b> <span class="bdg warn">下界</span>'),
    ('结果总数（摘要第 1 列求和）', '2 956 ← 因 BD_1、BD_2a 各被 1000 上限截断'),
], '摘要里明确写了 <code>Maximum result count of 1000 exceeded in DRC RuleCheck BD_1 / BD_2a</code>，'
   '所以 <b>3 402 是下界而非真实总数</b>。')
tbl(['check', '条数', '规则原文（逐字取自违规数据库）', '违规位置', '性质'], [
    ('BD_1', '1 000 <span class="bdg warn">截断</span>',
     'The BORDER layer must enclose all chip layout patterns … include seal ring', '整 die', '封环整芯片规则'),
    ('BD_2a', '1 000 <span class="bdg warn">截断</span>',
     'Enclosure of AA, GT, CT, Mn, Vn, TM by BORDER layer … ≥ 1.1um', '整 die；86 条贴边', '同上'),
    ('NW_2a', '734', 'Space between two NW regions with the same net is ≥ 0.60um',
     '整 die（12.97,−0.54 → 426.59,426.13）', '<b>同网 N 阱间距</b>'),
    ('M1_2', '<b>177</b>', 'Space between two M1 regions is ≥ 0.23um, exclude SRAM region',
     '整 die；仅 3 条贴边', '<b>M1 间距</b>'),
    ('M1_1', '15', 'M1 width is ≥ 0.23um', '片内中部', 'M1 宽度'),
    ('M2_2', '14', 'Space between two Mn-1 regions is ≥ 0.28um', '片内', 'M2 间距'),
    ('M2_1 / V1_2 / V1_1', '1 / 7 / 1', 'Mn-1 width ≥ 0.28um / Vn space ≥ 0.26um / V1 must be square',
     '片内', 'M2、V1 几何'),
    ('GT_12 / M1_7…M5_7 / MT_6', '各 1', 'GT density ≥ 14%；Mn-1 density ≥ 30%；MT density ≥ 30%',
     '各为整片一个窗口', '<b>密度（填充）</b>'),
], '规则原文与每条的多边形数、包围盒由 <code>drc_CAL.OUT</code> 直接解析（<code>tools/drc_locate.py</code>）。')
w('<div class="ok"><b>分成三类后结论很清楚</b>：<br>'
  '① <b>封环 2 条（BD_1/BD_2a，均被截断）</b>：这是<b>整芯片</b>规则，要求各层被封环 BORDER 包住 ≥1.1 µm。'
  '交付件是<b>块级版图、没有封环</b>，所以整片触发——<b>不是布线缺陷</b>。<br>'
  '② <b>密度 7 条，各 1 条</b>：每条就是一个“整片密度低于阈值”的窗口，实测密度见 §2.3。'
  '<b>属填充问题，不是间距问题</b>。<br>'
  '③ <b>真正需要动版图的金属/过孔几何 6 条，共 215 条结果</b>：M1 间距 177 + M1 宽度 15 + M2 间距 14 '
  '+ V1 间距 7 + M2 宽度 1 + V1 形状 1，且几乎都不在晶圆边缘。</div>')
tbl(['类别', '结果数', '占比（按 2 956 计）'], [
    ('封环（BD_1 + BD_2a）', '2 000（<b>已截断，实际更多</b>）', '67.7 %'),
    ('N 阱间距（NW_2a）', '734', '24.8 %'),
    ('金属/过孔几何（M1/M2/V1）', '<b>215</b>', '7.3 %'),
    ('密度（GT + M1_7…M5_7 + MT_6）', '7', '0.24 %'),
], '<b>交叉验证</b>：摘要第 1 列求和 = <b>2 956</b>，从违规数据库解析出的多边形数也是 <b>2 956</b>，'
   '两个独立来源互证。')
fig('fig8_drc.png',
    '<b>DRC 结果构成与拆解</b>。左（对数纵轴）：封环类占 2/3 且被 1000 上限截断；'
    '右：真正要动版图的 215 条金属/过孔结果按规则拆分，M1 间距一项就占 177 条。')

w('<h3>3.2　LVS：<span class="bdg bad">INCORRECT</span>（未收敛）</h3>')
tbl(['项', '值'], [
    ('判定', '<span class="bdg bad">INCORRECT</span>'),
    ('端口（变换后）', '<b>178 = 178</b> ✅'),
    ('网（变换后）', 'layout 12 146 vs source 12 255（差 109）'),
    ('器件（变换后）', 'MN 27 vs 13、MP 34 vs 13，其余类别逐项相等'),
    ('SHORT 条目', '<b>0 条</b>（文件中的“SHORT”只是选项名与信号名 <code>SRM_COUNT_SHORTFALL</code>）'),
    ('错误网条数', '<b>50</b>；第 1、2 条是 VDD（layout 14 636 vs source 13 702 连接）与 VSS'),
    ('历史对照', 'v5.0 曾有 <b>1 条</b> SHORT：<code>rst_n – VDD</code>（402.600, 0.357 与 425.000, 428.100），v5.1 已清零'),
], '出处 <code>lvs.rep</code>（14 357 行）与 <code>evidence/v50/lvs.rep.shorts</code>。'
   '残差已归因到上下文生成器件与单元边界端口，但<b>未消到 0</b>。')

# ═══════════════════════════════════════════════════════════ 4 功能
w('<h2 id="fun">§4　功能</h2>')
w('<p class="ask">本节回答：逻辑对不对？交付的网表能不能真的跑出结果？</p>')

w('<h3>4.1　RTL ↔ 交付布线后网表：逻辑等价</h3>')
w('<pre>Verification SUCCEEDED\n'
  ' Reference      : r:/WORK/sar_digi_paper_core   (RTL)\n'
  ' Implementation : i:/WORK/sar_digi_paper_core   (pnr/out/sar_digi_paper_core_pnr.v)\n\n'
  ' 1157 Passing compare points      (Port 146 + DFF 1011)\n'
  ' Failing (not equivalent)     0\n'
  ' failing.rpt : No failing compare points.</pre>')
tbl(['项', '结论', '必须一起读的限定'], [
    ('等价性', '<b>通过</b>：1157 passing / 0 failing', '实现侧是<b>交付的布线后网表</b>（被核查方原 LEC 只做到综合网表）'),
    ('寄存器覆盖', 'DFF 比对点 <b>1 011</b>，与综合阶段一致', '⇒ 布线阶段没有丢 / 改寄存器'),
    ('时钟门锁存器', '40 个未逐点比对', '由 <code>COLLAPSE_ALL_CG_CELLS</code> 折叠成“时钟 ∧ 使能”模型<b>覆盖</b>'),
    ('无驱动网', '参考侧 0 / 实现侧 <b>5</b>（<code>FM-399</code>）', '⇒ tie 取值在工具<b>默认假定</b>下成立，未被独立证明'),
    ('端口账 178 vs 146', '<b>已闭合</b>', '146 = 位展开输出端口；178 = 176 信号位 + VDD + VSS'),
])

w('<h3>4.2　交付网表端到端：功能跑通（无 force）</h3>')
tbl(['跑法', '<code>srm_total_count</code>', '<code>srm_ones_count</code>', '<code>srm_residue_o</code>', '说明'], [
    ('网表，判决流相位 0', '<b>22</b>', '<b>8</b>', '981（−43 Q8）', '顶层端口与子模块内部逐位相同'),
    ('网表，判决流相位 1', '<b>22</b>', '<b>7</b>', '966（−58 Q8）', '只把送出的判决流挪一个 <code>dec_clk</code> 槽'),
    ('RTL，判决流相位 0', '<b>22</b>', '<b>7</b>', '966（−58 Q8）', '<b>与“网表相位 1”逐位相同</b>'),
], '激励：<code>rst_n</code> 0→1 → <code>srm_start</code> 单脉冲 → 40 个判决 <code>bit=(i%3==0)</code>；'
   '<code>count_shortfall=0</code>、<code>stalled=0</code>、<code>residue_valid</code> 已发布。三例 <code>total</code> 全为 22。')
w('<div class="ok"><b>判据是可证伪的</b>：若“网表少一个 1”是丢判决，把相位挪一个槽应当<b>仍然</b>给 8；'
  '实测给 7 且与零延迟 RTL 逐位相同 ⇒ 差的是<b>接受窗相位</b>（网表有真实时钟树，武装晚一个槽），'
  '<b>不是丢/多判决</b>。</div>')

w('<h3>4.3　复位与状态机</h3>')
w('<pre>rst_n (顶层端口) → INVX8 HFSINV_15503_626 → HFSNET_124 → 一串反相器 → HFSNET_119 → 两个子模块的 rst_n</pre>')
tbl(['观测量', '实测', '含义'], [
    ('<code>rst_n</code> 0 → 1', '两个子模块的 <code>rst_n</code> <b>20 ns 内跟随变 1 并保持</b>', '复位路径连通（两次反相 ⇒ 等于 <code>rst_n</code>）'),
    ('<code>state</code>', '<code>000</code>→<code>010</code>→<code>011</code>→<code>100</code>→<code>101</code>', 'S_IDLE→S_WAIT→S_SETTLE→S_LUT→S_HOLD，完整走完一次测量'),
    ('<code>dec_run</code>', '0 → 1 → 0', '决策域被武装并正常收尾'),
    ('<code>busy</code> / <code>done</code> / <code>residue_valid</code>', '0→1 / 单周期 1 / 1', '握手时序符合 RTL'),
    ('<code>count_shortfall</code> / <code>stalled</code>', '0 / 0', '设计自认完成一次样本充足的测量'),
])

w('<h3>4.4　时钟来源（一次曾被误判的结构）</h3>')
tbl(['作用域', '网名', '驱动', '结论'], [
    ('顶层', '<code>ctosc_gls_0</code>', '<code>CLKBUFX8 ctosc_gls_inst_1718 ( .A(clk) )</code>',
     '顶层<b>唯一</b>驱动 ⇒ 两个子模块的 <code>clk</code> 就是缓冲后的 <code>clk</code>'),
    ('估计器块内', '<code>ctosc_gls_0</code>', '<code>BUFX1 ctosc_gls_inst_1717 ( .A(dec_clk) )</code>',
     '块内局部网 = 缓冲后的 <code>dec_clk</code>，喂 <code>go_tgl_s*</code> 同步器'),
], '<b>同名不同作用域</b>。早期本方把它读成“片上振荡器 / 双驱动网”，是<b>跨模块同名网</b>造成的误判，已撤回。'
   '<code>ctosc_gls_*</code> 是 CTS 为门级仿真插入的时钟树建模缓冲。')

w('<h3>4.5　计数与残差的数值来源（LUT）</h3>')
tbl(['项', '结论'], [
    ('计数路径', '<code>dec_total/dec_ones</code>（<code>dec_clk</code> 域）→ 格雷码 CDC → <code>cap_*</code>（<code>clk</code> 域）→ 在 <b>S_LUT</b> 一拍发布 → S_HOLD 保持'),
    ('交付 LUT 表 vs 论文式', '<b>系统性偏离</b>：<code>cnt=11</code> 处为 0，偏离随远离 11 单调增大（<code>cnt=1</code> 处 22 Q8）'),
    ('偏离原因', '在 <b>H2 假设</b>下用<b>还原出的生成器</b>对交付表体<b>逐项复现 12/12</b> ⇒ 从“无法裁定”变为“已定位”'),
    ('生成脚本', '交付件里<b>没有</b> <code>gen/gen_srm_lut.py</code>（RTL 三处点名，含一条 <code>$error</code>）；本方按 RTL 注释还原为 <code>tools/gen_srm_lut.py</code>'),
])

w('<h3>4.6　门级仿真可用性</h3>')
tbl(['项', '事实'], [
    ('被核查方的 <code>pwr_gls</code>', '编译的确实是交付网表，但<b>零延迟</b>、只为产 SAIF、<b>无 PASS/FAIL</b>'),
    ('本方的判定型仿真', '自写 TB + 自写判定，<b>无 force</b>，覆盖复位 → 状态机 → 计数 → 残差发布，见 §4.2'),
    ('读总线的硬性要求', '<b>必须带位宽</b>声明（<code>wire [4:0] srm_ones_count;</code>）。声明成 1 位会被静默截断为 LSB——这正是早期“顶层计数读数为 0”的唯一原因'),
])

# ═══════════════════════════════════════════════════════════ 5 时序
w('<h2 id="tim">§5　时序</h2>')
w('<p class="ask">本节回答：时序过没过？没过的是哪一类、能不能修？</p>')

w('<h3>5.1　setup：三角全正、0 违例，derate 推到 p8 仍为正</h3>')
tbl(['corner', 'derate 点', 'late / early', '<code>clk</code> slack (ns)', '违例数', 'Fmax (MHz)', '最差路径'], [
    ('typical', 'pc', '—', '<b>+0.980740</b>', '0', '110.9', '<code>start_calib</code> → <code>clk_gate_target_bit_reg/latch/D</code>'),
    ('slow', 'p0', '1.00 / 1.00', '<b>+0.794725</b>', '0', '108.6', '同上'),
    ('slow', 'p3', '1.03 / 0.97', '+0.759686', '0', '108.2', '同上'),
    ('slow', 'p5', '1.05 / 0.95', '+0.736327', '0', '107.9', '同上'),
    ('slow', 'p8', '1.08 / 0.92', '<b>+0.701290</b>', '0', '107.5', '同上'),
    ('fast', 'pc', '—', '<b>+1.073170</b>', '0', '112.0', '同上'),
], 'PrimeTime post-route + SPEF，<code>clk</code> 约束 10 ns。'
   '<b>所有 corner 与所有 derate 点的 <code>viol_setup</code> 均为 0。</b>'
   '最差路径终点是<b>时钟门锁存器的 D</b>（门控使能的建立），是这类设计的典型关键路径。'
   '出处 <code>sta_pc_summary.txt</code> / <code>sta_pc_derate.txt</code>。')
w('<div class="ok"><b>独立印证</b>：11 份 <code>-all_violators -verbose</code> 报告共列出 <b>156 条</b>路径，'
  '类型列<b>全部是 <code>min</code>（hold）</b>——包括 derate 推演点在内，<b>没有任何一条 setup（<code>max</code>）违例</b>。</div>')

w('<h3>5.2　<code>dec_clk</code>：恰好满足，无余量信息</h3>')
tbl(['corner', '约束周期', 'slack (ns)', '违例数', '最差路径终点'], [
    ('typical / slow / fast', '3.000 ns', '<b>0.000000</b>', '0', '<code>u_srm_residue/clk_gate_dec_ones_reg/latch/D</code>'),
], '<b>口径说明（不夸大）</b>：slack 恰好 0.000 出现在<b>时钟门锁存器</b>的 D 端，'
   '表示“刚好满足、没有余量数字”，<b>不能</b>读成“处于临界”。按 3 ns 折算 Fmax = 333.3 MHz，仅供参考。')

w('<h3>5.3　hold：29 条违例，根因是端口约束不是布线</h3>')
tbl(['口径', '定义', '合计', '说明'], [
    ('A', 'PT 汇总行的 <code>viol_hold</code>', '<b>29</b>（1/16/12）', '<b>本报告采用</b>：工具自己的判定计数，可一键复算'),
    ('B', 'hold 报告里 “VIOLATED” 出现次数（上界）', '42', '函数级上界'),
    ("C / C'", '逐 corner 去重端点 / 三角并集', '26 / <b>25</b>', '端点对去重'),
    ('D', '含 derate 点在内所有文件的并集', '28', '最宽口径'),
], '<b>交付报告里那个“39”在五种口径下都复现不出来</b>（29 / 42 / 26 / 25 / 28），已撤回。'
   '样本 = 11 个 hold 报告文件（<code>evidence/v51/hold_dedup.txt</code>）。')
tbl(['corner', '违例数', 'WNS (ns)', 'TNS (ns)', '最差路径'], [
    ('typical', '1', '−0.031957', '−0.0320', '<code>calib_comp_out</code> → <code>u_calib_ctrl/comp_out_r_reg/D</code>'),
    ('slow', '<b>16</b>', '<b>−0.201956</b>', '−2.5834', '<code>raw_bits_i[15]</code> → <code>raw_code_o_reg[15]/D</code>'),
    ('fast', '12', '−0.053847', '−0.3051', '<code>u_calib_ctrl/calib_done_pulse_reg/CK</code> → <code>calib_done_pulse</code>'),
], '口径键已写入机读汇总：<code>sta_hold_viols_total=29</code>、'
   '<code>hold_caliber=PT_viol_hold_from_sta_pc_summary</code>。')
w('<pre>最差 hold 路径（slow / pc，原文摘录，ns）\n'
  '  Startpoint: raw_bits_i[15]      (input port clocked by clk)\n'
  '  Endpoint:   raw_code_o_reg[15]  (flip-flop clocked by clk)      Path Type: min\n\n'
  '  clock network delay (propagated)     0.00   <- 起点是输入端口，没有时钟树\n'
  '  input external delay                 0.50\n'
  '  U18/Y (INVXL)                        0.05   <- 中间只有 1 个反相器\n'
  '  data arrival time                    0.55\n\n'
  '  clock network delay (propagated)     0.75   <- 捕获侧走完整棵时钟树\n'
  '  clock uncertainty                    0.05\n'
  '  library hold time                   -0.05\n'
  '  data required time                   0.75\n'
  '  slack (VIOLATED)                    -0.20</pre>')
w('<div class="ok"><b>机制（用这条路径自己的数字算出来）</b>：数据只走 0.50 + 0.05 = <b>0.55 ns</b>，'
  '而捕获时钟要等 <b>0.75 ns</b> 的时钟树插入延迟（再加 0.05 不确定度、减 0.05 库保持时间）。'
  '<b>0.55 − 0.75 = −0.20 ns，正是报告的 slack。</b><br>'
  '⇒ <b>不是布线绕远</b>：路径上只有一级门。根因是“<b>输入端口直进触发器 + 该端口 <code>min</code> 输入延迟只给 0.50 ns</b>”'
  '这条约束假设。三个旋钮：① 放宽 <code>set_input_delay -min</code>；② 输入加一级缓冲；③ 平衡时钟树。'
  '<b>这是 SDC 口径问题，不等于芯片会失效</b>，但必须在签核里写明。</div>')
fig('fig7_timing.png',
    '<b>setup/hold 随时序 derate 点的变化，以及最差 hold 路径的逐段分解</b>。'
    '左：慢角 setup WNS 始终为正；中：hold WNS/TNS 随 derate 单调恶化（违例数恒为 16）；'
    '右：数据只能攒到 0.55 ns，而捕获时钟要 0.75 ns 才到。')

w('<h3>5.4　时钟树与各路径组</h3>')
tbl(['时钟', 'sink 数', '级数', '缓冲器', '最大插入延迟 ns', '全局 skew ns', '线长 µm'], [
    ('<code>clk</code>', '1 034', '4', '20', '0.81', '<b>0.51</b>', '17 158.52'),
    ('<code>dec_clk</code>', '17', '2', '1', '0.32', '0.09', '252.73'),
], 'CTS 自报（<code>fc_clock_qor.rpt</code>）。PrimeTime 看到的 typical 值是延迟 0.53 / skew <b>0.31</b> '
   '（<code>sta_pc_typical_pc_clock_{latency,skew}.rpt</code>）——<b>两者口径不同、不可互相替代</b>：'
   'CTS 是布局阶段的树估计，PT 是带寄生的实际延迟。')
tbl(['路径组', '级数', '关键路径长 (ns)', 'slack (ns)', '约束周期 (ns)', '违例'], [
    ('<code>clk</code>', '23', '7.96', '+1.72', '10.00', '0'),
    ('<code>dec_clk</code>', '4', '2.17', '+0.53', '3.00', '0'),
    ('<code>**in2reg_default**</code>', '3', '2.35', '+0.35', '3.00', '0'),
    ('<code>**reg2out_default**</code>', '7', '3.77', '+1.70', '10.00', '0'),
], '<b>签核数字请用 §5.1</b>：本表是 P&R 内部估算（无 SPEF、无 derate），比签核值乐观。'
   '两处 hold 列在 P&R 阶段均为 0——hold 违例是带寄生的签核 STA 才暴露的。')

w('<h3>5.5　综合 → 布线的变化</h3>')
tbl(['量', 'DC（综合）', 'P&R（布线后）', '解读'], [
    ('hold 违例', '105', '<b>29</b>', '布线修复了 76 条（缓冲/换单元），但未清零'),
    ('<code>clk</code> 逻辑级数', '40.00', '<b>23</b>', '最长组合链砍掉约 42 %'),
    ('面积', '97 892.63 µm²（typical）', '102 300.11 µm²（cell area）', '口径不同，且布线后含时钟树与优化缓冲'),
    ('寄存器数', '1 051', '1 051', '一致 ⇒ 布线未丢寄存器（与 §4.1 的 DFF 1 011 比对点互证）'),
])

# ═══════════════════════════════════════════════════════════ 6 证据
w('<h2 id="ev">§6　口径、证据与自我更正</h2>')

w('<h3>6.1　证据索引（本报告每个数字的出处）</h3>')
tbl(['结论', '文件'], [
    ('GDS 身份 / 面积 / 利用率', '<code>evidence/rpt_v51/RESULT_CURRENT.env</code>'),
    ('版图图片（flattened 渲染）', '<code>tools/make_gds_images.py</code>；层号清单 <code>tools/gds_layer_inventory.py</code>'),
    ('逐层几何 / 放置账', '<code>evidence/v51/gds_routing_census.txt</code>、<code>gds_layer_routing.txt</code>'),
    ('端口账', '<code>evidence/v51/gds_ports.txt</code>、<code>ports_place_measure.txt</code>'),
    ('拥塞 / 线长 / 路径组 / 时钟树', '<code>evidence/rpt_v51/pnr/fc_{congestion,qor,clock_qor}.rpt</code>'),
    ('DRC 规则与结果', '<code>evidence/v51/drc_summary.txt</code>、<code>drc_locate.txt</code>'),
    ('各层金属密度', 'VM <code>calibre/drc/density_report_*.log</code>'),
    ('LVS', '<code>evidence/rpt_v51/lvs.rep</code>；v5.0 短路对照 <code>evidence/v50/lvs.rep.shorts</code>'),
    ('STA 三角 / derate / 违例路径', '<code>evidence/rpt_v51/sta/sta_pc_summary.txt</code>、<code>sta_pc_derate.txt</code>、<code>evidence/v51/sta_paths.txt</code>'),
    ('hold 多口径对照', '<code>evidence/v51/hold_dedup.txt</code>'),
    ('等价性 1157/0 与三条限定', '过程记录 <code>V1_交付网表等价性核查.md</code>（原始 run 在 VM <code>/tmp/fmv</code>，已清理）'),
    ('端到端功能', '过程记录 <code>修复15_顶层计数读数结案.md</code>；脚本 <code>probes/fix15_count.sh</code>、<code>fix16_rtl_same_stim.sh</code>'),
    ('复位与状态机', '过程记录 <code>修复12</code>、<code>修复13</code>'),
    ('LUT 表来源', '过程记录 <code>修复06</code>；工具 <code>tools/gen_srm_lut.py</code>'),
])

w('<h3>6.2　本方撤回过的结论（共 6 条，其中 4 条曾被当作“交付缺陷”）</h3>')
tbl(['被撤回的“发现”', '真实原因', '现在的事实'], [
    ('交付网表没有定义复位', '把一条<b>反相器链</b>当成了未写值的 tie 根', '§4.3'),
    ('主状态机不前进', '在<b>错误的复位假设</b>下取数', '§4.3'),
    ('GDS 顶层 cell 没有任何几何', '本方 GDS <b>记录码表写错</b>（<code>0x08</code> 才是 BOUNDARY）', '§1 / §2.1'),
    ('GDS 放置 3 735 vs 网表 3 626、master 224 种', '把<b>全文件</b> SNAME 计数当成了顶层放置', '§1.2（3 626 / 109 逐项闭合）'),
    ('顶层 <code>total_count</code>/<code>ones_count</code> 读数为 0', '测试台生成器<b>丢掉端口位宽</b>，5 位总线声明成 1 位（只读到 LSB）', '§4.2'),
    ('逐层几何“GT poly 1 个图形”', '旧解析器在 <code>BOUNDARY</code> 记录上计数，此时该元素自己的 <code>LAYER</code> 尚未读到，用了上一个元素的层号', '§2.1（顶层只画 M1–M6）'),
])
w('<div class="note"><b>方法学三规矩</b>（12 处自我更正换来的）：① 每条结论必须有对照；'
  '② <b>检查必须先证明自己跑过</b>——两次“零结果”就栽在自证上（<code>$time</code> 单位判断错、'
  '<code>integer max=-1</code> 的有符号比较让最大值统计成了死代码）；③ 不引用自己没有实测过的计数。</div>')

w('<h3>6.3　未覆盖 / 未闭合</h3>')
tbl(['项', '状态'], [
    ('LVS', '<b>INCORRECT</b>：残差已归因，<b>未消到 0</b>'),
    ('hold 违例', '已裁定 <b>29 条</b>，<b>未修复</b>（修 hold 需改 P&R 脚本并整轮重跑）'),
    ('V4 紧凑化实验', '<b>未执行</b>（有破坏风险，见 §2.5）'),
    ('DRC 真实总数', 'BD_1 / BD_2a 被 1000 上限截断，<b>3 402 是下界</b>'),
    ('<code>FM-399</code> 实现侧 5 个无驱动网', '<b>未归因</b>（仿真实测表明不影响功能）'),
    ('整个数字核的完整功能签核', '本报告只证明 <b>SRM 估计器全路径</b>与复位/状态机；校准链未做端到端判定'),
])

w('<div class="foot">SAR16 数字核 · 签核报告（GDS 版图 / 布线 / 物理验证 / 功能 / 时序）　2026-09-19<br>'
  '全部数字来自 §6.1 列出的文件，可逐条复算。配套：<code>docs/独立核查报告.md</code>（核查与撤回清单）· '
  '<code>docs/接口契约补充_上电与驱动前提.md</code>（集成前提与判决窗相位）· '
  '<code>SAR16_接手报告_缺陷修复与签核_20260918.html</code>（接手全过程）</div>')

# ═══════════════════════════════════════════════════════════ emit
HTML = (u'<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="utf-8">\n'
        u'<meta name="viewport" content="width=device-width,initial-scale=1">\n'
        u'<title>SAR16 数字核 · 签核报告（GDS 版图 / 布线 / 功能 / 时序）</title>\n'
        u'<style>' + CSS + u'</style>\n</head>\n<body><div class="wrap">\n'
        + u'\n'.join(T) + u'\n</div></body>\n</html>\n')

os.makedirs(os.path.dirname(OUT), exist_ok=True)
io.open(OUT, 'w', encoding='utf-8').write(HTML)
print('wrote %s' % OUT)
print('bytes = %d' % os.path.getsize(OUT))

# ── self-tests: each of these must be able to fail ────────────────────────────────
checks = []
caps = re.findall(r'<figcaption><b>图 (\d+)</b>', HTML)
checks.append(('figure numbers are 1..N in document order',
               [int(x) for x in caps] == list(range(1, len(caps) + 1)), caps))
checks.append(('no duplicate figure file embedded',
               len(set(FIG_SEQ)) == len(FIG_SEQ), FIG_SEQ))
checks.append(('all figure files exist', not FIG_MISSING, FIG_MISSING))
checks.append(('table rows match their headers', not ARITY_BAD, ARITY_BAD[:3]))

# Decode every embedded data: URI back to bytes and compare md5 with the source PNG.
# This is the check that answers "do the images actually display?": a truncated or
# mis-encoded base64 payload would still look like an <img> tag in the source.
embedded = re.findall(r'src="data:image/png;base64,([A-Za-z0-9+/=]+)"', HTML)
bad_img = []
for i, payload in enumerate(embedded):
    try:
        raw = base64.b64decode(payload, validate=True)
    except Exception as e:
        bad_img.append('fig#%d undecodable: %s' % (i + 1, e))
        continue
    if raw[:8] != b'\x89PNG\r\n\x1a\n':
        bad_img.append('fig#%d is not a PNG' % (i + 1))
        continue
    h = hashlib.md5(raw).hexdigest()
    if h not in FIG_HASH.values():
        bad_img.append('fig#%d md5 not among sources' % (i + 1))
checks.append(('every embedded image decodes to the exact source PNG',
               not bad_img and len(embedded) == len(FIG_SEQ), bad_img))

# displayed size: with the CSS column at 1150 px minus padding, how big does each figure show?
LINK_RE = re.compile(r'href="SAR16_[^"]+/([^"]+\.png)"')
links = LINK_RE.findall(HTML)
checks.append(('every figure links to its full-resolution PNG',
               set(links) == set(FIG_SEQ), sorted(set(FIG_SEQ) - set(links))))

need = ['1157', '0.5558', '3 402', '0.794725', '966', '3 626', '34 356', '37 836',
        '103 969', '178 = 178', '0.980740', '1.073170', '29.23', '30 730', '2 956',
        '\u22120.201956', '360 031', '52 756', '44 451', '5.04', '808', '86 445']
miss = [n for n in need if n not in HTML]
checks.append(('headline numbers present', not miss, miss))
ids = re.findall(r'<h2 id="([^"]+)"', HTML)
checks.append(('every TOC link resolves',
               all(('href="#%s"' % i) in HTML for i in ids), ids))

print('')
ok = True
for name, good, detail in checks:
    print('  [%s] %-46s %s' % ('PASS' if good else 'FAIL', name,
                               '' if good else str(detail)[:120]))
    ok = ok and good
print('  figures embedded: %d   bytes: %d' % (HTML.count('data:image/png;base64'), len(HTML.encode('utf-8'))))
if not ok:
    raise SystemExit('REPORT SELF-CHECK FAILED')

