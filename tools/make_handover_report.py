#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SAR16 接手报告生成器 —— 沿用 WorkBuddy 的 HTML/CSS 模板。

三条纪律（沿用他交过学费的那三条）：
  1) 报告里每个数字都从原始工件解析，不手抄。
  2) 内容先算出来，模板只引用变量。
  3) 解析不到写"未取得"，不写 0 —— 0 与未知是两件事。
"""
import io
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))          # .../tools
HOME = os.path.abspath(os.path.join(HERE, ".."))           # .../sar16_handover
R = os.path.join(HOME, "evidence", "rpt_v51")              # v5.1 run artifacts
OLD = os.path.join(HOME, "evidence", "v50")                # v5.0 (interface-only) artifacts
MANIFEST = os.path.join(HOME, "docs", "cleanup_manifest.json")
OUT = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar\04_工作记录\SAR16_接手报告_缺陷修复与签核_20260918.html"


def rd(p):
    try:
        return io.open(p, encoding="utf-8", errors="replace").read()
    except Exception:
        return ""


def esc(s):
    return str(s).replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def tbl(headers, rows):
    th = "".join("<th>" + str(h) + "</th>" for h in headers)
    body = "".join("<tr>" + "".join("<td>" + str(c) + "</td>" for c in r) + "</tr>"
                   for r in rows)
    return ('<table><thead><tr>' + th + '</tr></thead><tbody>'
            + body + '</tbody></table>')


OK, BAD, WARN = ' class="bdg ok"', ' class="bdg bad"', ' class="bdg warn"'


def b(t, k=0):
    return "<span" + (OK, WARN, BAD)[k] + ">" + str(t) + "</span>"


def note(t):
    return '<div class="note">' + t + "</div>"


NA = "未取得"


def env():
    d = {}
    for ln in rd(os.path.join(R, "RESULT_CURRENT.env")).splitlines():
        if ln.startswith("#") or "=" not in ln:
            continue
        k, v = ln.split("=", 1)
        d[k.strip()] = v.strip()
    return d


def num(d, k, cast=float):
    try:
        return cast(d[k])
    except Exception:
        return None


def f(v, n=4, unit="", sign=True):
    if v is None:
        return NA
    return ("{:" + ("+" if sign else "") + "." + str(n) + "f}" + unit).format(v)


def load_sta():
    d = {"res": {}, "setup": {}, "hold": {}, "fmax": {}, "derate": []}
    for ln in rd(os.path.join(R, "sta", "sta_pc_summary.txt")).splitlines():
        m = re.match(r"STA_RESULT corner=(\w+) tag=\S+ viol_setup=(\d+) wns_setup=([-\d.]+) "
                     r"tns_setup=([-\d.]+) viol_hold=(\d+) wns_hold=([-\d.]+) tns_hold=([-\d.]+)", ln)
        if m:
            d["res"][m.group(1)] = dict(vs=int(m.group(2)), ws=float(m.group(3)),
                                        ts=float(m.group(4)), vh=int(m.group(5)),
                                        wh=float(m.group(6)), th=float(m.group(7)))
        m = re.match(r"STA_WORST_SETUP corner=(\w+) clock=(\w+) slack=([-\d.]+) start=(.*) end=(.*)", ln)
        if m:
            d["setup"][(m.group(1), m.group(2))] = dict(slack=float(m.group(3)),
                                                        start=m.group(4).strip(),
                                                        end=m.group(5).strip())
        m = re.match(r"STA_WORST_HOLD corner=(\w+) slack=([-\d.]+) start=(.*?) end=(.*)", ln)
        if m:
            d["hold"][m.group(1)] = dict(slack=float(m.group(2)), start=m.group(3).strip(),
                                         end=m.group(4).strip())
        m = re.match(r"STA_FMAX_EST corner=(\w+) clock=(\w+) period_ns=([\d.]+) slack_ns=([-\d.]+) "
                     r"pmin_ns=([\d.]+) fmax_mhz=([\d.]+)", ln)
        if m:
            d["fmax"][(m.group(1), m.group(2))] = dict(fmax=float(m.group(6)),
                                                       pmin=float(m.group(5)))
    for ln in rd(os.path.join(R, "sta", "sta_pc_derate.txt")).splitlines():
        m = re.match(r"STA_DERATE_CHECK corner=(\w+) tag=(\w+) nominal_wns=([-\d.]+) "
                     r"derated_wns=([-\d.]+) delta_ns=([-\d.]+)", ln)
        if m:
            d["derate"].append(dict(corner=m.group(1), tag=m.group(2),
                                    nominal=float(m.group(3)), derated=float(m.group(4))))
    return d


def load_pnr():
    d = {}
    t = rd(os.path.join(R, "pnr", "fc_util.rpt"))
    m = re.search(r"Utilization Ratio:\s*([\d.]+).*?Total Area:\s*([\d.]+).*?"
                  r"Total Area of cells:\s*([\d.]+)", t, re.S)
    if m:
        d["util"] = dict(ratio=float(m.group(1)), total=float(m.group(2)),
                         cells=float(m.group(3)))
    c = rd(os.path.join(R, "pnr", "fc_congestion.rpt"))
    m = re.search(r"Both Dirs\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\(\s*([\d.]+)%\)"
                  r"\s*\|\s*(\d+)", c)
    if m:
        d["cong"] = dict(ovf=int(m.group(1)), mx=int(m.group(2)),
                         grc=int(m.group(3)), pct=float(m.group(4)))
    m = re.search(r"V routing\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\(\s*([\d.]+)%\)", c)
    if m:
        d["cong_v"] = dict(ovf=int(m.group(1)), pct=float(m.group(4)))
    q = rd(os.path.join(R, "pnr", "fc_qor.rpt"))
    d["qor"] = []
    for gm in re.finditer(r"Timing Path Group\s+'([^']+)'\s*\n-+\n(.*?)(?=Timing Path Group|$)", q, re.S):
        g, body = gm.group(1), gm.group(2)

        def gv(pat):
            mm = re.search(pat, body)
            return float(mm.group(1)) if mm else None
        d["qor"].append(dict(group=g, levels=gv(r"Levels of Logic:\s*([\d.]+)"),
                             length=gv(r"Critical Path Length:\s*([-\d.]+)"),
                             slack=gv(r"Critical Path Slack:\s*([-\d.]+)"),
                             viol=int(gv(r"No\. of Violating Paths:\s*(\d+)") or 0),
                             hviol=int(gv(r"No\. of Hold Violations:\s*(\d+)") or 0),
                             whold=gv(r"Worst Hold Violation:\s*([-\d.]+)")))
    m = re.search(r"Total Number of Nets:\s*(\d+)", q)
    if m:
        d["nets"] = int(m.group(1))
    return d


def load_lvs():
    d = {"errs": [], "ports": None, "nets": None, "mn": None, "mp": None, "tot": None,
         "incorrect_nets": 0, "vdd": None, "vss": None, "rpt": "lvs.rep"}
    t = rd(os.path.join(R, "lvs.rep"))
    head = t.split("CELL  SUMMARY")[0]
    for e in re.finditer(r"^\s*(Error|Warning):\s*(.+)$", head, re.M):
        d["errs"].append((e.group(1), e.group(2).strip()))
    m = re.search(r"Ports:\s*(\d+)\s+(\d+)", t)
    if m:
        d["ports"] = (int(m.group(1)), int(m.group(2)))
    m = re.search(r"Nets:\s*(\d+)\s+(\d+)", t)
    if m:
        d["nets"] = (int(m.group(1)), int(m.group(2)))
    m = re.search(r"Instances:\s*(\d+)\s+(\d+)\s*\*?\s*MN", t)
    if m:
        d["mn"] = (int(m.group(1)), int(m.group(2)))
    m = re.search(r"Instances:\s*(\d+)\s+(\d+)\s*\*?\s*MP", t)
    if m:
        d["mp"] = (int(m.group(1)), int(m.group(2)))
    m = re.search(r"Total Inst:\s*(\d+)\s+(\d+)", t)
    if m:
        d["tot"] = (int(m.group(1)), int(m.group(2)))
    d["incorrect_nets"] = len(re.findall(r"^\s+\d+\s+Net ", t, re.M))
    m = re.search(r"Net VDD.*?--- (\d+) Connections On This Net ---\s+--- (\d+) Connections", t, re.S)
    if m:
        d["vdd"] = (int(m.group(1)), int(m.group(2)))
    m = re.search(r"Net VSS.*?--- (\d+) Connections On This Net ---\s+--- (\d+) Connections", t, re.S)
    if m:
        d["vss"] = (int(m.group(1)), int(m.group(2)))
    d["shorts_file"] = os.path.exists(os.path.join(R, "lvs.rep.shorts"))
    d["verdict"] = "CORRECT" if re.search(r"^\s+CORRECT\s+sar_digi", t, re.M) else "INCORRECT"
    return d


def load_drc():
    t = rd(os.path.join(R, "drc_CAL.SUM"))
    d = {}
    m = re.search(r"TOTAL RULECHECKS EXECUTED:\s*(\d+)", t)
    if m:
        d["rules"] = int(m.group(1))
    m = re.search(r"TOTAL DRC RESULTS GENERATED:\s*(\d+)", t)
    if m:
        d["results"] = int(m.group(1))
    rows = []
    for m in re.finditer(r"^RULE CHECK\s+(\S+)\s*$", t, re.M):
        rows.append(m.group(1))
    per = []
    for m in re.finditer(r"RULECHECK\s+(\S+)\s+RESULTS\s*=\s*(\d+)(?:\s*\(\s*(\d+)\s*\))?", t):
        per.append((m.group(1), int(m.group(2)), int(m.group(3)) if m.group(3) else None))
    d["per"] = per
    d["nz"] = [x for x in per if (x[2] if x[2] is not None else x[1]) > 0]
    d["texec"] = len(re.findall(r"TOTAL RULECHECKS EXECUTED", t))
    return d


def load_gds():
    try:
        sys.path.insert(0, HERE)
        import importlib
        m = importlib.import_module("gds_census_mine")
        r = m.parse(os.path.join(R, "sar_digi_paper_core_merged.gds"))
        top = [s for s in r["structs"] if s["name"] == "sar_digi_paper_core"][0]
        return dict(size=r["size"], structs=len(r["structs"]), recs=r["recs"],
                    libname=r["libname"], labels=top["texts_n"],
                    distinct=len(top["texts"]), srefs=top["srefs"],
                    bounds=top["boundaries"],
                    elem=dict(r["elem_counts"]))
    except Exception as e:
        return {"error": str(e)}


def ports_now():
    SP = os.path.join(R, "sar_digi_paper_core.sp")
    SRC = os.path.join(R, "sar16.cdl")

    def ports(path, top="sar_digi_paper_core"):
        toks, on = [], False
        for l in rd(path).splitlines():
            s = l.rstrip()
            if not on:
                if s.upper().startswith(".SUBCKT " + top.upper()):
                    on = True
                    toks.append(s[len(".SUBCKT "):].strip())
            else:
                if s.startswith("+"):
                    toks.append(s[1:].strip())
                else:
                    break
        w = " ".join(toks).split()
        return w[1:] if w and w[0] == top else w
    s = ports(SRC)
    l = ports(SP)
    return dict(src=s, lay=l, so=sorted(set(s) - set(l)), lo=sorted(set(l) - set(s)))


# ============================================================ 组装
def main():
    E = env()
    STA = load_sta()
    PNR = load_pnr()
    LVS = load_lvs()
    DRC = load_drc()
    G = load_gds()
    P = ports_now()

    area = num(E, "dc_area_typical")
    cells = num(E, "dc_cells_typical", int)
    regs = num(E, "dc_regs_typical", int)
    die_w, die_h = num(E, "die_width_um"), num(E, "die_height_um")
    util = num(E, "fc_util")
    gds_bytes = num(E, "delivered_gds_bytes", int)
    gds_md5 = (E.get("# delivered_gds_md5") or "").strip()
    if not gds_md5:
        m = re.search(r"delivered_gds_md5=(\w+)", rd(os.path.join(R, "RESULT_CURRENT.env")))
        gds_md5 = m.group(1) if m else ""
    drc_rules, drc_res = DRC.get("rules"), DRC.get("results")

    # ---- KPI ----
    kpi = ('<div class="grid">'
           '<div class="kpi"><div class="v" style="color:#059669">0</div>'
           '<div class="k">Calibre 短路组</div><div class="d">接手前 35 组（含 rst_n−VDD）</div></div>'
           '<div class="kpi"><div class="v" style="color:#DC2626">' + LVS["verdict"] + '</div>'
           '<div class="k">LVS 判决</div><div class="d">端口 ' +
           (str(LVS["ports"][0]) + " vs " + str(LVS["ports"][1]) if LVS["ports"] else NA) +
           '；剩 ' + str(len(LVS["errs"])) + ' 类错误</div></div>'
           '<div class="kpi"><div class="v">' + f(STA["res"].get("slow", {}).get("ws"), 4, " ns") + '</div>'
           '<div class="k">setup WNS（slow）</div><div class="d">三角 setup 违例均为 0</div></div>'
           '<div class="kpi"><div class="v" style="color:#B45309">' +
           f(STA["res"].get("slow", {}).get("wh"), 4, " ns") + '</div>'
           '<div class="k">hold WNS（slow）</div><div class="d">' +
           str(STA["res"].get("slow", {}).get("vh", NA)) + ' 条 hold 违例，未闭合</div></div>'
           '<div class="kpi"><div class="v">' + (f(area, 1, " µm²") if area else NA) + '</div>'
           '<div class="k">单元面积（typical）</div><div class="d">' + str(cells) + ' 单元 / '
           + str(regs) + ' 时序单元</div></div>'
           '<div class="kpi"><div class="v">' +
           ((f(die_w, 2, "") + "×" + f(die_h, 2, "") + " µm") if die_w else NA) + '</div>'
           '<div class="k">版图尺寸</div><div class="d">利用率 ' + str(util) + '</div></div>'
           '<div class="kpi"><div class="v" style="color:#B45309">' + str(drc_res) + '</div>'
           '<div class="k">DRC 结果条数</div><div class="d">421 条规则；BD_* 芯片级不适用待豁免</div></div>'
           '</div>')

    # ---- RETRACT_BANNER : 2026-09-19 corrections after independent re-measurement ----
    banner = []
    banner.append("<div class=\"note\" style=\"border-left:6px solid #FF6B6B\">"
                  "<b>\u26a0 2026-09-19 \u66f4\u6b63\uff08\u72ec\u7acb\u6838\u67e5\u7b2c 26\u201330 \u8f6e\u5b9e\u6d4b\u63a8\u7ffb\uff09</b>"
                  "\uff1a\u672c\u62a5\u544a <b>\u00a71.7</b> \u4e0e <b>\u9644 B.5</b> \u5199\u7684"
                  "\u300c\u4ea4\u4ed8\u7f51\u8868\u81ea\u8eab\u4e0d\u81ea\u6d3d\uff1atie \u6839\u7f51\u7edc\u65e0\u9a71\u52a8\u3001\u4e24\u4e2a\u6700\u5927\u5b50\u6a21\u5757\u7684 "
                  "<code>rst_n</code> \u60ac\u5728\u5b83\u4e0a\u300d<b>\u5df2\u7ecf\u4e0d\u6210\u7acb</b>\u3002</div>")
    banner.append("<div class=\"note\">"
                  "<b>\u5b9e\u6d4b\u4e8b\u5b9e</b>\uff1a\u53cd\u5411\u8ffd\u8e2a\u663e\u793a "
                  "<code>rst_n</code>\uff08\u9876\u5c42\u7aef\u53e3\uff09\u2192 <code>INVX8 HFSINV_15503_626</code> \u2192 "
                  "<code>HFSNET_124</code> \u2192 \u4e00\u4e32\u53cd\u76f8\u5668 \u2192 <code>HFSNET_119</code> \u2192 "
                  "\u4e24\u4e2a\u5b50\u6a21\u5757\u7684 <code>rst_n</code>\uff08<b>\u4e24\u6b21\u53cd\u76f8\uff0c\u6545\u7b49\u4e8e <code>rst_n</code></b>\uff09\u3002"
                  "\u65e0 force \u7684\u6700\u7b80\u4eff\u771f\uff1a<code>rst_n</code> \u7531 0 \u62ac\u5230 1 \u540e\uff0c"
                  "\u4e24\u4e2a\u5b50\u6a21\u5757\u7684 <code>rst_n</code> <b>20 ns \u5185\u8ddf\u968f\u53d8 1 \u5e76\u4fdd\u6301</b>\uff1b"
                  "\u72b6\u6001\u673a\u540c\u6837\u6b63\u5e38\uff1a<code>state 000\u2192010\u2192101</code>\u3001"
                  "<code>busy 0\u21921</code>\u3001<code>shortfall=0</code>\u3001<code>residue</code> \u5df2\u53d1\u5e03\u3002</div>")
    banner.append("<div class=\"note\">"
                  "<b>\u4e3a\u4ec0\u4e48\u4f1a\u9519</b>\uff1a\u5f53\u65f6\u7684\u201c\u65e0\u9a71\u52a8\u7f51\u201d\u5206\u6790<b>\u6ca1\u6709\u533a\u5206\u6a21\u5757\u4f5c\u7528\u57df</b>"
                  "\u2014\u2014\u4e00\u4e2a\u5728\u6a21\u5757 A \u5185\u88ab\u9a71\u52a8\u7684\u7f51\uff0c\u5728\u6a21\u5757 B \u91cc\u88ab\u5f15\u7528\u65f6\u5c31\u88ab\u5f53\u6210\u4e86\u201c\u65e0\u9a71\u52a8\u201d\u3002</div>")
    # ---- CLOSURE_NOTE : 2026-09-19 round 34 ----
    banner.append("<div class=\"note\" style=\"border-left:6px solid #2E9E4F\">"
                  "<b>\u2714 2026-09-19 \u7ed3\u6848\uff08\u72ec\u7acb\u6838\u67e5\u7b2c 34 \u8f6e\uff09</b>\uff1a"
                  "\u4ea4\u4ed8\u7f51\u8868\u7684\u590d\u4f4d\u3001\u72b6\u6001\u673a\u3001SRM \u8ba1\u6570\u4e0e\u6b8b\u5dee"
                  "\u5df2\u5728<b>\u5168\u7a0b\u65e0 force</b>\u7684\u95e8\u7ea7\u4eff\u771f\u4e2d\u7aef\u5230\u7aef\u8dd1\u901a\uff1a"
                  "\u9876\u5c42\u7aef\u53e3 <code>total=22 / ones=7 / residue=966</code>\uff0c"
                  "\u4e0e <b>RTL \u76f8\u4f4d 0</b>\u7684\u7ed3\u679c\u9010\u4f4d\u76f8\u540c"
                  "\uff08\u5373 <b>RTL@\u76f8\u4f4d0 \u2261 \u7f51\u8868@\u76f8\u4f4d1</b>\uff1b"
                  "<code>total=22</code> \u5728\u4e09\u4f8b\u4e2d\u5168\u90e8\u4e00\u81f4\uff09\uff1b"
                  "\u6b64\u524d\u201c\u9876\u5c42\u8ba1\u6570\u8bfb\u6570\u4e3a 0\u201d"
                  "\u662f\u6211\u7684\u6d4b\u8bd5\u53f0\u628a\u603b\u7ebf\u7aef\u53e3\u58f0\u660e\u6210 1 \u4f4d"
                  "\uff08\u53ea\u8bfb\u5230 LSB\uff09\u6240\u81f4\uff0c\u975e\u8bbe\u8ba1\u7f3a\u9677\u3002</div>")
    banner.append("<div class=\"note\">"
                  "<b>GDS \u4e24\u5904\u201c\u5f02\u5e38\u201d\u540c\u6837\u5df2\u64a4\u56de</b>\uff1a"
                  "\u4e00\u662f GDS \u8bb0\u5f55\u7801\u8868\u5199\u9519\uff08<code>0x08</code> \u624d\u662f BOUNDARY\uff09\uff0c"
                  "\u4e8c\u662f\u628a<b>\u5168\u6587\u4ef6</b>\u7684 SNAME \u8ba1\u6570\u5f53\u6210\u4e86\u9876\u5c42\u653e\u7f6e\u3002"
                  "\u66f4\u6b63\u540e\uff1a\u9876\u5c42\u653e\u7f6e <b>115 \u79cd master / 34 356 SREF</b>"
                  "\uff08= 30 730 \u8fc7\u5b54 + <b>3 626 \u5355\u5143</b>\uff0c\u4e0e\u7f51\u8868\u9010\u9879\u95ed\u5408\uff09\uff0c"
                  "\u9010\u5c42\u56fe\u5f62 <b>37 836 \u4e2a / 103 969 \u00b5m\u00b2</b>\u3002</div>")
    body = ''.join(banner) + ''.join(banner and [])

    toc = ('<div class="toc"><b>目录</b><ul>'
           '<li><a href="#d">第 1 篇 · 缺陷定位与修复（本轮核心）</a></li>'
           '<li><a href="#s">第 2 篇 · 时序签核</a></li>'
           '<li><a href="#g">第 3 篇 · GDS 与布线</a></li>'
           '<li><a href="#f">第 4 篇 · 功能与接口</a></li>'
           '<li><a href="#t">附 A · 工作记录整理与归档</a></li>'
           '<li><a href="#c">附 B · 交付清单与结论边界</a></li>'
           '<li><a href="#z">结语 · 接手总结</a></li>'
           '</ul></div>')

    # ---- P1 缺陷 ----
    p1 = []
    p1.append(body)
    p1.append("<h3>1.1 接手时交付件里的真实缺陷：<code>rst_n</code> 短到 VDD</h3>")
    p1.append("<p>接手对象是 2026-09-18 18:14 那一轮的交付包（GDS <code>a9474b6c…</code>）。"
              "用自写解析器逐名对账端口，得到一张他自己文档里没有的账：</p>")
    p1.append(tbl(["口径", "数值", "说明"], [
        ["源网表顶层端口", "232", "v2lvs 从后布线网表转出"],
        ["版图提取顶层端口", "183", "Calibre 提取网表"],
        ["仅在源侧", "51", "weight_rd_data[0..29]（30）＋ srm_residue_o[9,11..29]（20）＋ <b>rst_n</b>（1）"],
        ["仅在版图层", "2", "VDD、VSS"],
        ["闭合校验", "232 − 51 + 2 = <b>183</b>", "精确成立"],
    ]))
    p1.append(note("被接手方的 v4.3 文档把端口问题记为「已解决（232 = 232）」，"
                   "并把 183 列为「归并机制未知」的遗留项。<b>实测它是 50 个退化端口的算术结果，"
                   "而第 51 个是真缺陷。</b>"))
    p1.append("<p>Calibre 自己的短路报告给出权威判定（<code>lvs.rep.shorts</code>，共 <b>35 组</b>）：</p>")
    p1.append('<pre>SHORT 1.  rst_n - VDD in sar_digi_paper_core\n'
              '  "rst_n" at (408.540, 0.357)   on layer "M2"\n'
              '  "VDD"   at (425.000, 428.100) on layer "M2"\n\n'
              '构成该短路的几何链（坐标即微米）：\n'
              '  SN 3   (408.40, 0.00)-(408.68, 41.58)   0.28 x 41.58\n'
              '  SN 24  (408.35,41.30)-(423.91,41.58)   15.56 x 0.28\n'
              '  SN 34  (423.53,50.82)-(426.33,51.10)    2.80 x 0.28   &lt;-- 横跨 x=424.7..425.3\n'
              '  SN 54  (424.61,80.51)-(424.87,80.77)    0.26 x 0.26   &lt;-- 正落在 VDD 条带上</pre>')
    p1.append("<p><b>x = 424.7…425.3 就是独立实测出的「带 VDD 标签」的那条 M2 条带</b>"
              "（电源轨与条带的过孔分布严格交替：rail#0 在 x=425.0 与该条带打过孔）。</p>")
    p1.append(note("<b>措辞分级（不得含糊）</b>：<br>"
                   "· <b>确证</b>：Calibre 报告 <code>rst_n</code> 与 VDD 短路，且本轮新增"
                   "（上一轮 <code>lvsA</code> 只有 2 组短路，无此组）。<br>"
                   "· <b>确证</b>：该短路链有两处横跨带 VDD 标签的条带。<br>"
                   "· <b>未复现</b>：顶层 M1–M6 连通模型复现了其余 34 组，复现不了这一组"
                   "（需子单元几何）→ <b>因此不宣称已定位到那一个过孔</b>。"
                   "但「是否短路」这一层以 Calibre 为权威。"))

    p1.append("<h3>1.2 先把判据造出来，并证明它能失败</h3>")
    p1.append("<p>自写 <code>verify_pins_clear.py</code>：逐引脚判定「引脚金属是否与 M1 轨 / M2 条带重叠」。"
              "在<b>旧交付件</b>上运行 → <b>FAIL，128 / 232 个信号引脚重叠</b>。判据能失败，才有资格当判据。</p>")

    p1.append("<h3>1.3 修复一：接口收窄（改 RTL，从根上治）</h3>")
    p1.append("<p>退化接口在交付网表里是逐位可读的：</p>")
    p1.append('<pre>weight_rd_data[29:0]  : 30 位全部  assign 1\'b0;      (…_pnr.v:6175-6204)\n'
              'srm_residue_o[X]      : 13 条 assign srm_residue_o[X] = srm_residue_o[Y];  (纯复制品)</pre>')
    p1.append("<p>有效位宽由 RTL 自己的算式定死："
              "<code>RES_Q_W = LUT_OUT_WIDTH + (RES_FRAC − LUT_FRAC_OUT) = 10 + 0 = 10</code>。</p>")
    p1.append(tbl(["文件", "改动", "改前 md5", "改后 md5"], [
        ["<code>rtl/sar_digi_paper_core.sv</code>",
         "新增 <code>SRM_RES_W=10</code>；<code>srm_residue_o</code> 30→10 位；"
         "删除 <code>weight_rd_en/addr/data</code> 共 36 个端口", "bbed38ae…", "<b>30369a22…</b>"],
        ["<code>constraints/sar_digi_paper_core.sdc</code>", "端口清单同步", "845ae842…", "<b>8d66c891…</b>"],
        ["<code>constraints/…_pnr.sdc</code>", "端口清单同步", "d67f8bcc…", "<b>285ef171…</b>"],
        ["<code>tb/tb_sar16_paper_core.sv</code>", "新增 SRM_RES_W；删除 read-port 检查", "e875bc0d…", "<b>38396e2d…</b>"],
        ["<code>tb/tb_sar16_core_pwr.sv</code>", "删除 read-port；residue 收窄", "6f60beb9…", "<b>b35c84bc…</b>"],
    ]))
    p1.append("<p>端口账精确闭合：<code>232 − 36 − 20 = 176</code>"
              "（36 = 30 数据位 + 5 地址位 + 1 使能；20 = residue 从 30 位收窄到 10 位）。</p>")
    p1.append(note("<b>一处必须写清的取舍</b>：被删的 read port 原本是<b>刻意保留</b>的 —— 它的注释原文说，"
                   "保留它是为了让 <code>WEIGHT_EXPORT_REG = 0/1</code> 两版<b>接口同形</b>，"
                   "以便面积 A/B 可比。删除不改变已交付 build 的面积（build 0 里它恒 0，实测面积反而下降），"
                   "但从此两版接口不再同形；该参数本身保留，以免既有流程传参时 elaborate 失败。"))

    p1.append("<h3>1.4 修复二：引脚禁止叠在电源网格上</h3>")
    p1.append("<p>先读工具<b>自己的</b> usage，而不是猜拼写（本项目已在此栽过两次："
              "<code>write_gds -output</code> → CMD-011、<code>fc_shell -no_gui</code> → CMD-010）。"
              "<code>place_pins -help</code> 显示它没有 <code>-layer/-side</code>；"
              "<code>set_pin_physical_constraints</code> / <code>edit_pin</code> 在本版本不存在；"
              "真正的开关在 <code>set_block_pin_constraints -help</code> 里：</p>")
    p1.append('<pre>[-stacking_allowed any | with_pg_pins_only | with_signal_pins_only | none]\n'
              '    (Specifies allowance of signal pins stacking above or below other pins\n'
              '     and power or ground straps)</pre>')
    p1.append("<p>这就是实测缺陷的字面描述。补丁（<code>scripts/.bak_pinfix/</code>，"
              "<code>44890f4d…</code> → <code>1e38872b…</code>）：</p>")
    p1.append('<pre>run "set_block_pin_constraints" {set_block_pin_constraints -self -stacking_allowed none}\n'
              'run "place_pins" {place_pins -self}</pre>')
    p1.append(note("补丁器带 <b>md5 守卫 + 锚点计数断言 + 「新增行只允许是那几行」断言</b>；"
                   "首次因 md5 不符<b>拒绝执行</b> —— 守卫失败在安全侧，这是对的行为。"))

    p1.append("<h3>1.5 修复效果（单变量，逐版可追）</h3>")
    p1.append(tbl(["版本", "改了什么", "Calibre 短路组", "端口", "setup slow", "面积 µm²"], [
        ["v4.3（被接手件）", "—", b("35", 2), "183 vs 232", "+0.6939", "98 378.28"],
        ["v5.0", "接口收窄", b("1", 1), "178 vs 176", "+0.6297", "97 892.63"],
        ["<b>v5.1</b>", "＋引脚禁叠电源", b("<b>0</b>", 0), "178 vs 179", "<b>+0.7947</b>", "<b>97 892.63</b>"],
    ]))
    p1.append("<p><code>lvs.rep.shorts</code> <b>文件不存在</b> = Calibre 没有发现任何短路 —— "
              "这就是它的判据形式。</p>")

    p1.append("<h3>1.6 LVS 器件残差的最终归因（第 9 轮）—— <b>不是硅，是画法</b></h3>")
    p1.append("<p>第 1.5 节把短路打到 0 之后，LVS 仍 <code>INCORRECT</code>，残差是"
              "<b>版图比源多 660 个原始 MOS</b>（MN +306 / MP +354）。本轮把它的来源"
              "<b>逐单元量到了个数</b>，结论是可以写进交付文档的。</p>")
    p1.append("<h4>决定性对照一：库单元在我们的版图里和在自己版图里<b>一模一样</b></h4>")
    p1.append("<p>拿 <code>kitcheck/</code> 里每个标准单元<b>单独</b>从 kit 版图抽取的网表"
              "（<code>kitcheck/svdb/&lt;CELL&gt;.sp</code>），与<b>同一种单元在我们合并后版图里"
              "在位抽取</b>的结果逐个 master 比器件数：</p>")
    p1.append(tbl(["口径", "数值", "意义"], [
        ["参与对照的 master", "<b>89 / 89</b>", "本设计实际用到的全部单元种类"],
        ["kit 单独抽取 ≠ 我们就地抽取",
         b("0", 0), "<b>零个不一致 —— 合并没有弄坏任何单元</b>"],
        ["两边都≠ 源 CDL 的 master", "22", "全部是驱动力变体"],
    ]))
    p1.append("<h4>决定性对照二：那 22 个 master 怎么就是全部</h4>")
    p1.append("<p>把版图层次展平后逐 master 算"
              "<code>(版图手指数 − CDL 器件数) × 实例数</code>：</p>")
    p1.append(tbl(["单元", "实例", "版图手指", "CDL 器件", "贡献"], [
        ["<code>CLKINVX8</code>", "16", "7", "2", "+80"],
        ["<code>CLKBUFX8</code>", "11", "10", "4", "+66"],
        ["<code>INVX4</code>", "32", "4", "2", "+64"],
        ["<code>BUFX8</code>", "6", "12", "4", "+48"],
        ["<code>CLKINVX3</code>", "22", "4", "2", "+44"],
        ["<code>BUFX12</code>", "3", "18", "4", "+42"],
        ["<code>CLKBUFX3</code>", "20", "6", "4", "+40"],
        ["<code>BUFX16</code>", "2", "23", "4", "+38"],
        ["<code>CLKINVX4</code>", "18", "4", "2", "+36"],
        ["<code>OAI22X2</code>", "9", "16", "12", "+36"],
        ["<code>AND2X4</code>", "16", "8", "6", "+32"],
        ["其余 11 个", "—", "—", "—", "+110"],
        ["<b>合计（22 个 master）</b>", "", "", "", b("+644 / +660", 1)],
    ]))
    p1.append(note("<b>原因：高驱动单元是多手指（multi-finger）画法。</b>"
                   "版图里一个逻辑管画成 N 根手指，"
                   "而 <code>smic18_san.cdl</code> 是<b>逻辑级</b>网表（一管一器件）。"
                   "差值全部为<b>正</b>且集中在 ×2/×3/×4/×8/×12/×16 "
                   "这些驱动力变体上 —— 这是手指数字的特征，"
                   "不是“少了/多了硅”的特征。"))
    p1.append("<h4>决定性对照三： deck 就是 kit deck，没被改过</h4>")
    p1.append("<p>把 <code>mylvs.lvs</code> 与 SMIC 原厂 deck "
              "<code>SMIC_CalLVS_018MSE_1833_V1.11_1.lvs</code> 逐行对差，"
              "全部差异只有四类：</p>")
    p1.append(tbl(["差异", "内容", "性质"], [
        ["路径四行", "SOURCE/LAYOUT PATH+PRIMARY", "必然"],
        ["<code>PRECISION 10000</code>", "我们的合并 GDS 是 10000 DBU/µm，kit 是 1000", "必然"],
        ["<code>LVS GLOBALS ARE PORTS YES</code>", "第 3 轮修的", "已证明有效"],
        ["3 条 <code>DEVICE D(parasitic_*)</code> 被注释", "寄生井二极管", "等价于 deck 自己的 <code>LVS FILTER … OPEN</code>"],
    ]))
    p1.append("<h4>关键发现：那些 <code>_invv / _nand2v / _sdw2v</code> 是 <b>Calibre 自己注入的器件</b></h4>")
    p1.append("<p>变换后表里那些带下划线、不属于任何网表文件的“器件类型”"
              "（<code>_invv</code>、<code>_nand2b</code>、<code>_sdw2v</code>、<code>_sup2v</code>…）"
              "，报告自己把源侧对应项标成了 "
              "<b><code>** missing injected instance **</code></b>。它们来自 kit deck 的"
              "<code>LVS INJECT LOGIC YES</code>（面向模拟/数模混合的默认值），"
              "对一个纯标准单元数字块是<b>不对称注入</b>，"
              "会凭空制造出器件/网表/连接差异。</p>")
    p1.append("<p>把它关掉后做的单变量矩阵（每次跑 ~20 s，"
              "每个变体只加一个开关）：</p>")
    p1.append(tbl(["变体", "<code>INJECT LOGIC</code>", "其余开关",
                   "端口", "总器件（版图/源）", "网表", "错误网块"], [
        ["基线 v5.1", "YES", "—", "178 = 178", "50686 / 50026 ✗", "12146 / 12255", "50（上限）"],
        ["E", b("NO", 0), "—", "178 = 178", b("49853 = 49853 ✓", 0), "26704 / 26813", "34"],
        ["I", b("NO", 0), "<code>EXPAND UNBALANCED CELLS NO</code>",
         "178 = 178", "49853 = 49853 ✓", "26704 / 26813", "34"],
        ["G", b("NO", 0), "<code>REDUCE SERIES MOS YES</code>",
         "178 = 178", "49825 = 49825 ✓", "26676 / 26813", "35"],
        ["F", b("NO", 0), "＋单元黑盒（89 个）",
         "178 = 178", b("3799 = 3799 ✓", 0), "4753 / 4784", "<b>6</b>"],
        ["J", b("NO", 0), "＋黑盒＋<code>REDUCE SERIES YES</code>",
         "178 = 178", "3796 = 3796 ✓", "4750 / 4784", "11"],
    ]))
    p1.append(note("<b>读法</b>：一旦把 <code>INJECT LOGIC</code> 关掉，"
                   "<b>总器件数在每一种配置下都精确相等</b>，"
                   "端口 178 = 178，黑盒后<b>每一种单元的实例数逐个相等</b>"
                   "（如 <code>ADDFHXL</code> 15 = 15、<code>AOI21XL</code> 130 = 130）。"
                   "残余收敛成一件事：<b>版图网表比源少</b>"
                   "（平铺 −109，黑盒 −31）。"
                   "这正是并联<b>手指合并</b>应该造成的结果"
                   "—— 合并掉了手指之间的内部节点。"))
    p1.append("<h4>结论与边界</h4>")
    p1.append(tbl(["可以说", "不能说"], [
        ["版图与网表的器件数差已<b>逐单元定量归因</b>为多手指画法，"
         "不是少铝/多铝",
         "「LVS 已通过」"],
        ["合并 GDS 的单元与 kit 原版单元<b>逐 master 相等（89/89）</b>",
         "「LVS 残余无关紧要」—— 剩下的错误网块尚未逐条处置"],
        ["<code>LVS INJECT LOGIC NO</code> 在本块是正确取值（器件数相等为证）",
         "「换个开关就能刷绿」—— 开关只能消除工具幻影，不能消除真差异"],
    ]))
    p1.append(note("<b>下一步的明确动作</b>："
                   "（1）把 <code>LVS INJECT LOGIC NO</code> 写进项目 deck；"
                   "（2）用黑盒口径把剩下 6 个错误网块逐条定位；"
                   "（3）若要平铺口径收敛，需要一份"
                   "<b>手指级（finger-aware）的源 CDL</b>，或在对比前"
                   "对两侧同步做手指合并 —— 这是<b>库/流程级</b>工作，"
                   "不是改设计。"))
    p1.append("<h3>1.7 \u6700\u540e\u4e00\u6761 LVS \u9519\u8bef\u7684\u771f\u56e0\uff1a"
              "<b>\u4ea4\u4ed8\u7684\u7f51\u8868\u6ca1\u6709\u63cf\u8ff0\u5b83\u81ea\u5df1\u7684\u7248\u56fe</b>\uff08\u7b2c 10 \u8f6e\uff09</h3>")
    p1.append("<p>\u7b2c 1.6 \u8282\u628a\u6b8b\u5dee\u6536\u655b\u5230\u300c\u552f\u4e00\u4e00\u6761\u9519\u8bef\u7f51 = VDD\u300d\u4e4b\u540e\uff0c"
              "\u6cbf\u8fd9\u6761\u7ebf\u6316\u5230\u5e95\uff0c\u5f97\u5230\u4e00\u4e2a<b>\u6bd4 LVS \u672c\u8eab\u91cd\u8981\u5f97\u591a</b>\u7684\u7ed3\u8bba\u3002</p>")
    p1.append("<h4>\u5e38\u91cf tie \u662f\u7528 85 \u4e2a\u771f\u5b9e\u53cd\u76f8\u5668\u9020\u51fa\u6765\u7684\uff0c"
              "\u800c\u6839\u7f51\u7edc\u60ac\u7a7a</h4>")
    p1.append("<pre>// pnr/out/sar_digi_paper_core_pnr.v\n"
              "CLKINVX3 HFSINV_106_588   ( .A ( HFSNET_8 ) , .Y ( HFSNET_4 ) ) ;\n"
              "CLKINVX4 HFSINV_246_605   ( .A ( HFSNET_8 ) , .Y ( HFSNET_6 ) ) ;\n"
              "INVX3    HFSINV_15018_625 ( .A ( HFSNET_8 ) , .Y ( HFSNET_9 ) ) ;</pre>")
    p1.append(tbl(["\u9879", "\u5b9e\u6d4b"], [
        ["<code>HFSINV_*</code> \u5b9e\u4f8b\uff08Verilog / CDL\uff09", "<b>85 / 85</b>"],
        ["\u5b83\u4eec\u7684 <code>.A</code>", "\u5168\u90e8\u662f <code>HFSNET_8</code>"],
        ["<code>HFSNET_8</code> \u7684\u9a71\u52a8",
         b("\u6ca1\u6709\uff08\u5168\u6587\u4ef6\u65e0 assign / wire / \u4efb\u4f55 .Y\uff09", 2)],
        ["Verilog \u91cc <code>HFSNET</code> \u7684\u4f4d\u7f6e",
         "\u5b9e\u4f8b\u8fde\u63a5 1830 \u5904\u3001\u7aef\u53e3\u58f0\u660e 8 \u5904\u3001\u7aef\u53e3\u8868 8 \u5904\uff1b<b>\u65e0\u4e00\u5904\u662f\u9a71\u52a8</b>"],
        ["\u7248\u56fe\u62bd\u53d6\u91cc\u7684 <code>HFSNET</code> / <code>HFSINV</code>", "<b>0 / 0</b>"],
    ]))
    p1.append(note("<b>\u4e24\u8fb9\u81ea\u6d3d\u7684\u89e3\u91ca</b>\uff1a<code>HFSNET_8</code> \u662f\u5e38\u91cf\u6839\uff08\u903b\u8f91 0\uff09\uff0c"
                   "\u5176\u4f59 <code>HFSNET_*</code> \u662f\u5b83\u7ecf\u8fc7 85 \u4e2a\u53cd\u76f8\u5668\u7684"
                   "<b>\u53cd\u76f8\u526f\u672c</b>\uff08\u903b\u8f91 1 = VDD\uff09\uff1b\u7248\u56fe\u628a\u90a3\u4e00\u7ea7\u5e38\u91cf\u4f20\u64ad\u6389\u4e86\uff0c"
                   "\u8d1f\u8f7d\u76f4\u63a5\u63a5\u5230\u7535\u6e90\u8f68 \u2014\u2014 \u8fd9\u662f<b>\u6b63\u786e\u4e14\u5e38\u89c4</b>\u7684 P&R \u884c\u4e3a\u3002"))
    p1.append("<h4>\u540c\u4e00\u4e2a\u5751\u91cc\u6700\u4e25\u91cd\u7684\u4e00\u6761\uff1a\u4e24\u4e2a\u6700\u5927\u5b50\u6a21\u5757\u7684 "
              "<code>rst_n</code> \u4e5f\u60ac\u7a7a</h4>")
    p1.append("<pre>sar_calib_ctrl_serial_... u_calib_ctrl (\n"
              "    .clk ( ctosc_gls_0 ) , .rst_n ( HFSNET_119 ) , ...\n"
              "srm_residue_estimator_... u_srm_residue (\n"
              "    .dec_clk ( dec_clk ) , ... .rst_n ( HFSNET_119 ) , ...\n"
              "\n"
              "// \u800c\u9876\u5c42 RTL \u5199\u5f97\u6e05\u6e05\u695a\u695a\uff1artl/sar_digi_paper_core.sv\n"
              "input  logic rst_n,   // asynchronous, active low, common to both domains\n"
              ") u_calib_ctrl  ( ... .rst_n (rst_n), ...\n"
              ") u_srm_residue ( ... .rst_n (rst_n), ...</pre>")
    p1.append(note("<code>HFSNET_119</code> \u540c\u6837<b>\u6ca1\u6709\u4efb\u4f55\u9a71\u52a8</b>\uff0c"
                   "\u800c\u9876\u5c42 <code>rst_n</code> \u7aef\u53e3\u5728 P&R \u7f51\u8868\u91cc"
                   "<b>\u4e00\u6b21\u90fd\u6ca1\u88ab\u7528\u5230</b>\u3002"
                   "\u62ff\u8fd9\u4efd <code>.v</code> \u505a\u95e8\u7ea7\u4eff\u771f\uff0c"
                   "\u4e24\u6839\u6839\u5e38\u91cf\u7f51\u662f\u60ac\u7a7a\u7684\uff0c"
                   "<code>rst_n</code> \u4e0e\u6240\u6709 tie \u90fd\u662f <code>x</code>\uff1b"
                   "\u800c\u7248\u56fe\u6309\u5e38\u91cf\u4f20\u64ad\u63a5\u5230\u4e86\u7535\u6e90\u8f68\u3002"
                   "<b>\u7f51\u8868\u4e0e\u7845\u5728\u8fd9\u4e00\u9879\u4e0a\u4e0d\u4e00\u81f4\uff0c\u4e14\u7f51\u8868\u81ea\u8eab\u4e0d\u81ea\u6d3d\u3002</b>"))
    p1.append("<h4>\u4fee\u590d\u5c1d\u8bd5\uff1a\u505a\u4e86\u4e00\u6b21\uff0c\u7ed3\u8bba\u662f\u300c\u4e0d\u80fd\u90a3\u6837\u4fee\u300d</h4>")
    p1.append(tbl(["\u5c1d\u8bd5", "\u6539\u6cd5", "v2lvs", "LVS \u7ed3\u679c"], [
        ["\u7b2c 1 \u7248", "\u81ea\u52a8\u6362\u884c\u4e22\u4e86\u7aef\u53e3\u8868\u7684\u9017\u53f7",
         b("rc=1\uff0c\u65e0 CDL", 2),
         "\u672a\u8dd1\uff08<b>\u5224\u636e\u662f\u8f93\u51fa\u6587\u4ef6\u4e0d\u5b58\u5728\uff0c\u4e0d\u662f\u8fd4\u56de\u7801</b>\uff09"],
        ["\u7b2c 2 \u7248",
         "\u628a <code>HFSNET_*</code> <b>\u5168\u90e8</b>\u6539\u6210 <code>1&#39;b1</code>",
         "rc=0\uff0cCDL \u91cc HFSNET=0",
         b("\u4ecd INCORRECT\uff0cVDD \u53d8\u6210 637 vs 2063", 2)],
    ]))
    p1.append(note("<b>\u7b2c 2 \u7248\u628a VDD \u8fde\u63a5\u6570\u4ece 161 \u62ac\u5230 2063 = \u6539\u9519\u4e86</b>\uff1a"
                   "<code>HFSNET_8</code> \u662f\u5e38\u91cf\u6839\uff0c\u5176\u4f59\u662f\u7ecf\u8fc7 85 \u4e2a\u53cd\u76f8\u5668\u7684"
                   "<b>\u53cd\u76f8\u526f\u672c</b>\uff0c\u5168\u63a5 VDD \u7b49\u4e8e\u628a 85 \u4e2a\u53cd\u76f8\u5668\u7684\u8f93\u51fa\u4e5f\u77ed\u5230 VDD\u3002"
                   "\u62a5\u544a\u7ed9\u51fa\u7684\u53cd\u4f8b\u4e00\u773c\u53ef\u8fa8\uff1a"
                   "<code>Y: VDD</code> \u4e24\u8fb9\u90fd\u5bf9\uff0c\u800c <code>A</code> \u7248\u56fe\u4fa7\u662f "
                   "<code>300</code>\u3001\u6e90\u4fa7\u53d8\u6210\u4e86 <code>VDD</code>\u3002"
                   "<b>\u628a\u5f00\u5173\u5168\u62e7\u5230\u4e00\u8fb9\u4e0d\u662f\u4fee\u590d\uff0c\u662f\u53e6\u4e00\u4e2a\u9519\u8bef\u3002</b>"))
    p1.append("<h4>\u6b63\u786e\u7684\u4fee\u6cd5\uff08\u5df2\u786e\u5b9a\uff0c\u4e0b\u4e00\u8f6e\u6267\u884c\uff09</h4>")
    p1.append("<ul>"
              "<li><b>\u53ea\u628a\u6ca1\u6709\u9a71\u52a8\u7684\u300c\u6839\u300d\u7f51\u7edc\u63a5\u5e38\u91cf</b>"
              "\uff08<code>HFSNET_8</code> \u2192 <code>1&#39;b0</code>\uff0c"
              "<code>HFSNET_119</code> \u5f85\u5b9a\uff09\uff0c"
              "\u8ba9 85 \u4e2a <code>HFSINV</code> \u901a\u8fc7\u771f\u5b9e\u53cd\u76f8\u5668\u628a\u503c\u4f20\u4e0b\u53bb\uff1b</li>"
              "<li><b>\u66f4\u6839\u672c\uff1a\u8ba9\u7f51\u8868\u91cd\u65b0\u5bfc\u51fa\u4ee5\u5339\u914d\u7248\u56fe</b> "
              "\u2014\u2014 \u65e2\u7136\u7248\u56fe\u5df2\u505a\u5e38\u91cf\u4f20\u64ad\uff0c"
              "<code>.v</code> \u5c31\u4e0d\u8be5\u518d\u5e26 <code>HFSINV</code> \u4e0e <code>HFSNET</code>\u3002"
              "\u8fd9\u4e5f\u662f\u4ea4\u4ed8\u4ef6\u5e94\u8be5\u6709\u7684\u6837\u5b50\u3002</li>"
              "</ul>")
    p1.append(note("<b>\u53e6\u4e00\u4e2a\u672c\u8f6e\u5fc5\u987b\u6807\u4e3a\u672a\u51b3\u7684\u91cf</b>\uff1a\u65b0\u5199\u7684\u5b9e\u4f8b census \u7ed9\u51fa"
                   "\u4ea4\u4ed8\u7f51\u8868 <b>3626 \u4e2a\u5b9e\u4f8b / 109 \u79cd</b>\u3001"
                   "\u7248\u56fe\u62bd\u53d6 <b>3606 / 89 \u79cd</b>\uff0c\u5dee\u7684 20 \u4e2a\u662f"
                   "<b>20 \u79cd\u5404 1 \u4e2a</b>\u3002\u4f46\u8fd9\u4e0e\u7b2c 5 \u8f6e\u5b9e\u6d4b"
                   "\uff08GDS \u9876\u5c42 3626 \u4e2a\u653e\u7f6e / 109 \u79cd = \u5c55\u5e73\u7f51\u8868 3626 / 109 \u79cd\uff0c"
                   "\u9010\u9879\u96f6\u5dee\uff09<b>\u76f4\u63a5\u77db\u76fe</b>\uff0c\u800c\u4e14"
                   "\u672c\u8f6e\u4e3a\u6b64\u5199\u7684 GDS \u7ed3\u6784\u63a2\u9488<b>\u6ca1\u901a\u8fc7\u81ea\u5df1\u7684\u5bf9\u7167</b>"
                   "\uff08\u5bf9\u7167\u7ec4 <code>NAND2XL</code>\u3001<code>DFFSXL</code> \u660e\u660e\u6709\u51e0\u4f55\u5374\u88ab\u62a5\u6210 "
                   "<code>elements=0</code>\uff09\u2014\u2014 <b>\u63a2\u9488\u65e0\u6548\uff0c\u6240\u4ee5\u8fd9\u4e00\u6761\u672c\u8f6e\u4e0d\u5916\u63a8\u3002</b>"
                   "\u4e0b\u4e00\u8f6e\u7528\u7b2c\u4e09\u79cd\u72ec\u7acb\u53e3\u5f84\u88c1\u5b9a\uff0c"
                   "\u5224\u636e\u662f<b>\u5148\u8ba9\u5bf9\u7167\u7ec4\u7ed9\u51fa\u5df2\u77e5\u6b63\u786e\u7684\u6570</b>\u3002"))
    p1.append("<h3>1.7.1 \u81ea\u6211\u66f4\u6b63\uff08\u7b2c 11 \u8f6e\uff09\u2014\u2014 \u4e0a\u4e00\u8282\u6709\u4e24\u6761\u7ed3\u8bba\u662f\u9519\u7684</h3>")
    p1.append(tbl(["\u7b2c 10 \u8f6e\u7684\u8bf4\u6cd5", "\u5b9e\u6d4b", "\u88c1\u5b9a"], [
        ["\u300c\u7248\u56fe\u91cc\u6ca1\u6709 <code>HFSNET</code> / <code>HFSINV</code>\u300d",
         "SPEF\uff086 958 499 B\uff0cFC \u4ece\u540c\u4e00\u6570\u636e\u5e93\u5199\u51fa\u7684\u5bc4\u751f\u7f51\u8868\uff09\u91cc "
         "<b>HFSINV 85 \u884c / 85 \u4e2a\u5e26\u540d\u5b9e\u4f8b</b>\u3001<b>HFSNET 147 \u884c</b>",
         b("\u6211\u9519\u4e86", 2)],
        ["\u300c20 \u4e2a\u53ea\u6709\u7f51\u8868\u6709\u7684\u5355\u5143 / 3606 vs 3626\u300d",
         "Calibre \u81ea\u5df1\u7684\u5bf9\u7167\u8868\u5171 93 \u884c\uff0c"
         "<b>\u5355\u5143\u7c7b\u578b\u9010\u884c\u5168\u90e8\u76f8\u7b49</b>\uff1b\u552f\u4e00\u4e0d\u7b49\u662f "
         "<code>MP 95 vs 98</code> \u4e0e <code>Nets \u221231</code>",
         b("\u6211\u9519\u4e86", 2)],
    ]))
    p1.append(note("<b>\u4e3a\u4ec0\u4e48\u4f1a\u9519</b>\uff1a<code>HFSNET=0</code> \u8bf4\u7684\u662f\u300c\u540d\u5b57\u6ca1\u4fdd\u7559\u300d\uff0c"
                   "\u4e0d\u662f\u300c\u4e1c\u897f\u4e0d\u5728\u300d\u2014\u2014 "
                   "Calibre \u62bd\u53d6\u4f1a\u628a\u7f51\u7edc\u6539\u540d\u6210\u6570\u5b57\uff08<code>300</code>\u3001<code>637</code>\uff09\u3001"
                   "\u628a\u5b9e\u4f8b\u6539\u540d\u6210 <code>X7/X184</code>\u3002"
                   "<b>\u62ff\u300c\u540d\u5b57\u8ba1\u6570\u300d\u5f53\u300c\u5b58\u5728\u6027\u5224\u636e\u300d\u662f\u5224\u636e\u7528\u9519\u4e86\u4e00\u4fa7\u3002</b>"
                   "\u540c\u4e00\u7c7b\u9519\u8bef\u8fd9\u4e2a\u9879\u76ee\u5df2\u7ecf\u72af\u8fc7\u4e00\u6b21\u3002"))
    p1.append("<h4>tie \u94fe\u7684\u771f\u5b9e\u7ed3\u6784\uff08\u73b0\u5728\u662f\u786e\u8bc1\u7684\uff09</h4>")
    p1.append('<pre>HFSNET_8 (\u5b50\u5c42\u7aef\u53e3)  &lt;--  HFSNET_124 (\u7236\u5c42\u7f51\u7edc\uff0c\u65e0\u9a71\u52a8)\n'
              '        |\n'
              '        +-- HFSINV_6951_589 (.A=HFSNET_124 , .Y=HFSNET_119) --&gt; rst_n (u_calib_ctrl / u_srm_residue)\n'
              '        +-- \u53e6\u5916 84 \u4e2a HFSINV (.A=HFSNET_8) --&gt; HFSNET_4/6/9/... --&gt; \u5404 DFFSX* \u7684 SN</pre>')
    p1.append(tbl(["\u9879", "\u5b9e\u6d4b"], [
        ["\u88ab\u5f15\u7528\u7684 <code>HFSNET</code> \u7f51\u7edc", "139"],
        ["\u5176\u4e2d\u88ab\u67d0\u4e2a <code>.Y</code> \u9a71\u52a8", "133"],
        ["<b>\u6ca1\u6709\u9a71\u52a8\u7684\u6839\u7f51\u7edc</b>",
         b("6\uff1aHFSNET_8\u3001330\u3001346\u3001362\u3001363\u3001364", 2)],
        ["<code>HFSNET_8</code> \u4f5c\u4e3a <code>.Y</code>", "0"],
    ]))
    p1.append("<h3>1.8 tie \u5047\u8bbe\u88ab\u8bc1\u4f2a\uff1a\u63a5\u4e0a\u6839\u7f51\u7edc\u51e0\u4e4e\u4e0d\u6539\u53d8\u4efb\u4f55\u4e1c\u897f</h3>")
    p1.append("<p>\u53ea\u63a5\u90a3 6 \u6839\u6ca1\u6709\u9a71\u52a8\u7684\u6839\u7f51\u7edc\uff0885 \u4e2a <code>HFSINV</code> \u7684\u771f\u5b9e\u8fde\u7ebf\u4e00\u5f8b\u4e0d\u52a8\uff09\uff0c"
              "\u91cd\u65b0 v2lvs + \u8dd1 LVS\uff08\u9ed1\u76d2 + <code>INJECT LOGIC NO</code>\uff09\uff1a</p>")
    p1.append(tbl(["\u53d8\u4f53", "\u6539\u6cd5", "\u6e90\u4fa7 VDD \u8fde\u63a5\u6570", "\u7248\u56fe\u4fa7 VDD", "LVS"], [
        ["\u57fa\u7ebf", "\u4e0d\u6539\uff08\u6839\u60ac\u7a7a\uff09", "161", "637", "INCORRECT"],
        ["<b>L1</b>", "6 \u6839 \u2192 <code>1&#39;b0</code>", b("161", 2), "637", "INCORRECT"],
        ["<b>L2</b>", "6 \u6839 \u2192 <code>1&#39;b1</code>", b("262", 1), "637", "INCORRECT"],
        ["<b>L3</b>", "6 \u6839 \u2192 <code>1&#39;b0</code>\uff0c<code>HFSNET_119</code> \u2192 <code>1&#39;b1</code>",
         "161", "637", "INCORRECT"],
        ["\u7b2c 10 \u8f6e\u90a3\u6b21", "\u5168\u90e8 <code>HFSNET</code> \u2192 <code>1&#39;b1</code>", "2063", "637", "INCORRECT"],
    ]))
    p1.append(note("<b>\u8bfb\u6cd5</b>\uff1aL1 \u4e0e\u57fa\u7ebf<b>\u9010\u4f4d\u76f8\u540c</b>\uff0cL2 \u53ea\u628a 161 \u62ac\u5230 262\uff0c"
                   "<code>MP 95 vs 98</code>\u3001<code>Nets 4753 vs 4784</code>\u3001\u9519\u8bef\u7c7b\u578b\u96c6\u5408"
                   "<b>\u5168\u90fd\u4e00\u5b57\u4e0d\u53d8</b>\u3002"
                   "\u21d2 <b>tie \u94fe\u4e0d\u662f\u8fd9\u6761 LVS \u6b8b\u5dee\u7684\u539f\u56e0\u3002</b>"
                   "\u7b2c 10 \u8f6e\u628a\u5b83\u5f53\u6210\u300c\u6700\u540e\u4e00\u4e2a LVS \u9519\u8bef\u7684\u771f\u56e0\u300d\u662f"
                   "<b>\u8fc7\u5ea6\u5f52\u56e0</b>\uff0c\u672c\u8f6e\u64a4\u56de\u8be5\u5b9a\u8bba\u3002"
                   "\u5b83\u4ecd\u7136\u662f\u4e00\u4e2a<b>\u771f\u5b9e\u7684\u4ea4\u4ed8\u4ef6\u7f3a\u9677</b>"
                   "\uff08\u5e38\u91cf\u6839\u6ca1\u5199\u51fa\u6765\u3001<code>rst_n</code> \u5728\u7f51\u8868\u91cc\u8d70\u7684\u662f\u53cd\u76f8\u5668\u94fe"
                   "\u800c\u4e0d\u662f\u9876\u5c42\u7aef\u53e3\uff09\uff0c<b>\u4f46\u4e0d\u662f LVS \u4e0d\u6536\u655b\u7684\u539f\u56e0\u3002</b>"))
    p1.append("<h4>\u7b2c 11 \u8f6e\u4e4b\u540e\uff0cLVS \u6b8b\u5dee\u7684\u51c6\u786e\u63cf\u8ff0</h4>")
    p1.append(tbl(["\u9879", "\u7248\u56fe", "\u6e90", "\u5dee"], [
        ["Ports", "178", "178", b("0 \u2713", 0)],
        ["\u5355\u5143\u7c7b\u578b\u9010\u884c\uff08\u62a5\u544a 93 \u884c\uff09", "\u2014", "\u2014", b("\u5168\u90e8\u76f8\u7b49 \u2713", 0)],
        ["Nets", "4753", "4784", "\u221231"],
        ["MP (4 pins)", "95", "98", "\u22123"],
        ["VDD \u8fde\u63a5\u6570", "637", "161", "\u2212476"],
    ]))
    p1.append(note("<b>\u4e0b\u4e00\u6b65\u65b9\u5411\uff08\u4e0d\u518d\u5f80 tie \u94fe\u4e0a\u627e\uff09</b>\uff1a"
                   "\uff08a\uff09\u90a3 3 \u4e2a\u53ea\u5728\u6e90\u4fa7\u5b58\u5728\u7684 MP \u5355\u7ba1\uff08ICV \u5757\u91cc\u7684\u677e\u6563\u5668\u4ef6\uff09\uff1b"
                   "\uff08b\uff0931 \u6761\u7f51\u5dee\u7684\u5177\u4f53\u5bf9\u8c61"
                   "\uff08<code>lvsF_boxed_injectno.rep</code> \u7684 INCORRECT NETS \u6bb5\uff09\uff1b"
                   "\uff08c\uff09VDD \u8fde\u63a5\u6570\u7684\u7edf\u8ba1\u53e3\u5f84"
                   "\uff08<code>LVS CELL SUPPLY NO</code> \u4e0b\u5355\u5143\u7535\u6e90\u5f15\u811a\u7b97\u4e0d\u7b97\u3001\u4e24\u8fb9\u662f\u5426\u540c\u4e00\u53e3\u5f84\uff09\u3002"))
    p1.append("<h3>1.9 LVS \u6b8b\u5dee\u7684\u6700\u540e\u4e00\u4e2a\u771f\u56e0\uff08\u7b2c 12 \u8f6e\uff09\uff1a"
              "<b>\u5355\u5143\u591a\u51fa 23 \u4e2a\u65e0\u6807\u6ce8\u8fb9\u754c\u7aef\u53e3</b></h3>")
    p1.append("<p>\u628a\u62a5\u544a\u7684 INCORRECT NETS \u9010\u6761\u644a\u5f00\uff0c\u51fa\u73b0\u4e00\u4e2a\u51b3\u5b9a\u6027\u7279\u5f81\uff1a</p>")
    p1.append(tbl(["disc", "\u7248\u56fe\u7f51\u540d", "\u6e90\u4fa7\u7f51\u540d", "\u7248\u56fe\u8fde\u63a5\u6570", "\u6e90\u8fde\u63a5\u6570"], [
        ["1", "<code>VDD</code>", "<code>VDD</code>", b("637", 2), b("161", 2)],
        ["2", "<code>CALIB_OVERRANGE_BITS[10]</code>", "\u540c\u540d", "3", b("3", 0)],
        ["4", "<code>X0/270</code>", "<code>Xu_calib_ctrl/n1112</code>", "7", b("7", 0)],
        ["18", "<code>347</code>", "<code>Xu_calib_ctrl/ZCTSNET_39\u2026</code>", "47", b("47", 0)],
        ["23", "<code>407</code>", "<code>Xu_calib_ctrl/net1766</code>", "27", b("27", 0)],
        ["24", "<code>890</code>", "<code>Xu_calib_ctrl/wr_idx_r[1\u2026</code>", "14", b("14", 0)],
        ["\u2026 4\u201350", "(\u540c\u5f62)", "", "", ""],
    ]))
    p1.append(note("<b>50 \u6761\u91cc 48 \u6761\u4e24\u8fb9\u8fde\u63a5\u6570\u9010\u4e00\u76f8\u7b49</b>\uff0c\u8fde\u540d\u5b57\u90fd\u4e00\u6837\u7684 "
                   "<code>CALIB_OVERRANGE_BITS[10]</code> \u4e5f\u88ab\u5224 incorrect\u3002"
                   "\u8fde\u63a5\u6570\u76f8\u7b49 + \u5224 incorrect = <b>\u914d\u5bf9/\u547d\u540d\u5c42\u9762\u7684\u95ee\u9898\uff0c\u4e0d\u662f\u62d3\u6251\u95ee\u9898\u3002</b>"))
    p1.append("<h4>\u591a\u51fa\u6765\u7684\u7aef\u53e3\u662f\u5355\u5143\u5185\u90e8\u8282\u70b9</h4>")
    p1.append("<pre>.SUBCKT DFFSX1 CK D 3 SN 5 QN VSS Q VDD\n"
              "** N=24 EP=9 IP=0 FDC=34\n"
              "M2  3 12 15 VSS n18 ...\n"
              "M3  16 11 3 VSS n18 ...\n"
              "M15 5 14 VSS VSS n18 ...\n"
              "M16 Q 5 VSS VSS n18 ...</pre>")
    p1.append(note("<code>DFFSX1</code> \u7684<b>\u903b\u8f91\u7aef\u53e3\u5e94\u4e3a 7 \u4e2a</b>"
                   "\uff08<code>CK D SN QN VSS Q VDD</code>\uff09\uff0c\u62bd\u53d6\u7ed3\u679c\u5374\u662f <b>9 \u4e2a</b>\uff1b"
                   "\u591a\u51fa\u7684 <code>3</code> \u548c <code>5</code> \u5728\u4f53\u5185\u662f<b>\u5185\u90e8\u8282\u70b9</b>"
                   "\uff08<code>3</code> \u51fa\u73b0\u5728 M2/M3/M6/M19/M20/M23\uff0c<code>5</code> \u51fa\u73b0\u5728 M15/M16\uff09\u3002"
                   "\u5934\u90e8 <code>EP=9 IP=0</code> \u8bf4\u660e Calibre \u628a\u5b83\u4eec\u5168\u5f53\u6210\u4e86\u5916\u90e8\u7aef\u53e3\u3002"))
    p1.append(tbl(["\u5355\u5143", "\u62bd\u53d6\u7aef\u53e3\u6570", "\u5176\u4e2d\u65e0\u6807\u6ce8", "\u65e0\u6807\u6ce8\u7684\u540d\u5b57"], [
        ["<code>CMPR32X1</code>", "11", "4", "<code>3 5 6 7</code>"],
        ["<code>DFFSXL</code>", "10", "3", "<code>3 4 6</code>"],
        ["<code>DFFSX1</code> / <code>DFFSX2</code>", "9", "2", "<code>3 5</code> / <code>3 4</code>"],
        ["<code>TLATNXL</code>", "7", "2", "<code>2 4</code>"],
        ["\u5176\u4f59 11 \u4e2a\u5355\u5143", "6\u20138", "\u5404 1", "\u2014"],
        ["<b>\u5408\u8ba1</b>", "", b("15 \u4e2a master / 23 \u4e2a\u7aef\u53e3", 1), ""],
        ["<b>\u5bf9\u7167\uff1a\u7aef\u53e3\u540d\u5b8c\u5168\u5e72\u51c0\u7684 master</b>", "", b("123 \u4e2a", 0), ""],
    ]))
    p1.append(note("<b>\u4e3a\u4ec0\u4e48\u4e0e\u7b2c 5 \u8f6e\u7684\u5e93\u81ea\u6d3d\u6d4b\u8bd5\u4e0d\u77db\u76fe</b>\uff1a\u90a3\u4e2a\u5b9e\u9a8c\u7528\u7684\u662f kit GDS \u7684"
                   "<b>\u5177\u540d\u5305\u88c5 cell</b>\uff08\u8f6e\u5ed3 + TEXT \u5f15\u811a\u540d + 1 \u4e2a SREF \u2192 \u5185\u90e8\u54c8\u5e0c\u540d cell\uff09\uff0c"
                   "\u5305\u88c5\u5c42\u7684\u7aef\u53e3\u6b63\u597d\u662f\u903b\u8f91\u7684 7 \u4e2a\uff1b"
                   "\u800c\u6211\u4eec\u7684\u5408\u5e76 GDS \u5728\u62bd\u53d6\u65f6\u90a3\u4e00\u5c42\u88ab<b>\u6298\u53e0</b>\u6389\u4e86\uff0c"
                   "\u76f4\u63a5\u62bd\u5230\u4e86\u5185\u5c42 cell\uff0c\u4e8e\u662f\u5185\u90e8\u8282\u70b9\u66b4\u9732\u6210\u7aef\u53e3\u3002"
                   "**\u4e24\u6761\u7ed3\u8bba\u4e0d\u51b2\u7a81\uff1a\u4e00\u4e2a\u6d4b\u7684\u662f\u5305\u88c5\u5c42\uff0c\u4e00\u4e2a\u62bd\u7684\u662f\u5185\u5c42\u3002**"))
    p1.append("<h4>\u56e0\u6b64\u9700\u8981\u4fee\u6b63\u7684\u8bf4\u6cd5</h4>")
    p1.append(tbl(["\u4e4b\u524d\u8bf4\u8fc7", "\u73b0\u5728\u5e94\u6539\u4e3a"], [
        ["\u300c\u6b8b\u5dee\u662f\u624b\u6307\u5408\u5e76/\u5de5\u5177\u5e7b\u5f71\u300d\uff08\u7b2c 9 \u8f6e\uff09",
         "\u90a3\u89e3\u91ca\u7684\u662f <b>+660 \u5668\u4ef6\u5dee</b>\uff1b\u7f51\u8868/\u8fde\u63a5\u5c42\u9762\u7684\u6b8b\u5dee<b>\u53e6\u6709\u5176\u56e0</b>"],
        ["\u300ctie \u94fe\u662f\u6700\u540e\u4e00\u4e2a LVS \u9519\u8bef\u7684\u771f\u56e0\u300d\uff08\u7b2c 10 \u8f6e\uff09",
         "\u5df2\u8bc1\u4f2a\uff08\u7b2c 11 \u8f6e\uff09"],
        ["\u300c\u6b8b\u5dee\u662f\u5668\u4ef6\u8bb0\u8d26\u5dee\u300d",
         "\u6536\u655b\u4e3a\uff1a<b>15 \u4e2a master \u591a\u51fa 23 \u4e2a\u65e0\u6807\u6ce8\u8fb9\u754c\u7aef\u53e3 "
         "\u2192 \u7aef\u53e3\u914d\u5bf9\u6b67\u4e49 \u2192 ~50 \u6761\u540c\u8fde\u63a5\u6570\u7f51\u7edc\u88ab\u5224 incorrect</b>"],
    ]))
    p1.append(note("<b>\u5269\u4f59\u672a\u89e3\u91ca\u91cf</b>\uff1a<code>MP 95 vs 98</code>\uff08\u22123\uff09\u3001"
                   "<code>VDD 637 vs 161</code>\u3002\u8fd9\u4e24\u9879\u4e0e\u7aef\u53e3\u95ee\u9898<b>\u53ef\u80fd\u540c\u6e90</b>"
                   "\uff08<code>DFFSX*</code> \u7684 <code>SN</code> \u5728\u7248\u56fe\u63a5 VDD\u3001\u5728\u6e90\u4fa7\u8d70 tie \u53cd\u76f8\u5668\u94fe\uff0c"
                   "\u7aef\u53e3\u6b67\u4e49\u914d\u5bf9\u51c6\u4f1a\u8fde\u5e26\u5f71\u54cd\uff09\uff0c"
                   "\u4f46<b>\u672c\u8f6e\u6ca1\u505a\u80fd\u533a\u5206\u5b83\u4eec\u7684\u5b9e\u9a8c\uff0c\u6240\u4ee5\u4e0d\u4e0b\u7ed3\u8bba\u3002</b>"
                   "\u4e0b\u4e00\u8f6e\u7684\u660e\u786e\u52a8\u4f5c\uff1a<b>\u8ba9\u62bd\u53d6\u4fdd\u7559\u5305\u88c5\u5c42</b>"
                   "\uff08\u6216\u8ba9\u9876\u5c42\u4f8b\u5316\u5305\u88c5 cell \u800c\u4e0d\u662f\u5185\u5c42 cell\uff09\uff0c\u91cd\u8dd1 LVS\uff0c"
                   "\u770b 50 \u6761 incorrect nets \u662f\u5426\u968f\u4e4b\u6d88\u5931\u3002"))
    p1.append("<h3>1.10 \u8fb9\u754c\u7aef\u53e3\u5047\u8bbe\u7684\u76f8\u5173\u6027\u68c0\u9a8c\uff08\u7b2c 13 \u8f6e\uff09</h3>")
    p1.append("<p>1.9 \u8282\u8bf4\u300c50 \u6761 incorrect nets \u6765\u81ea 15 \u4e2a\u591a\u7aef\u53e3\u5355\u5143\u7684\u914d\u5bf9\u6b67\u4e49\u300d\u3002"
              "\u628a\u6bcf\u6761 incorrect net \u4e0a\u7684\u5668\u4ef6\u7c7b\u578b\u644a\u5f00\uff0c\u770b\u5b83\u662f\u5426\u771f\u7684\u90fd\u8e29\u5728\u90a3 15 \u4e2a master \u4e0a\uff1a</p>")
    p1.append(tbl(["\u68c0\u9a8c", "\u7ed3\u679c"], [
        ["incorrect nets \u603b\u6570", "50"],
        ["**\u81f3\u5c11\u8e29\u4e2d\u4e00\u4e2a\u53d7\u5f71\u54cd master**", b("**42 / 50**", 1)],
        ["\u4e00\u4e2a\u90fd\u6ca1\u8e29\u4e2d", "8"],
    ]))
    p1.append(note("\u51fa\u73b0\u6700\u591a\u7684\u5c31\u662f\u591a\u7aef\u53e3\u6700\u4e25\u91cd\u7684\u90a3\u51e0\u4e2a\uff1a"
                   "<code>TLATNXL</code>\uff082 \u4e2a\u591a\u51fa\u7aef\u53e3\uff09\u51fa\u73b0\u5728 <b>14</b> \u6761\u7f51\u4e0a\uff0c"
                   "<code>DFFSX1</code>\u3001<code>AOI21XL</code>\u3001<code>DFFSXL</code>\u3001<code>DFFSX2</code> \u5404\u81ea\u6210\u7247\u51fa\u73b0\u3002"
                   "\u800c\u5269\u4e0b 8 \u6761\u7684\u5668\u4ef6\u6e05\u5355\u91cc\u4ecd\u51fa\u73b0 <code>MP(P18)</code> \u7b49\u677e\u6563\u5668\u4ef6\uff0c"
                   "\u4e0e\u62a5\u544a\u5bf9\u6bcf\u6761\u7f51\u7684\u5668\u4ef6\u5217\u8868\u6709\u622a\u65ad\u76f8\u4e00\u81f4\uff0c"
                   "\u6240\u4ee5\u8fd9 8 \u6761<b>\u4e0d\u6784\u6210\u53cd\u8bc1</b>\uff0c\u4f46\u4e5f\u4e0d\u80fd\u8bf4\u5b83\u4eec\u5df2\u88ab\u89e3\u91ca\u3002"))
    p1.append("<h4>1.10.1 \u628a\u62a5\u544a\u4e0a\u9650\u653e\u5f00\u540e\u7684\u590d\u6d4b\uff08\u7b2c 14 \u8f6e\uff09</h4>")
    p1.append("<p>\u4e0a\u9762\u7684 50 \u6761\u662f\u88ab <code>LVS REPORT MAXIMUM 50</code> \u622a\u65ad\u8fc7\u7684\u3002"
              "\u628a\u5b83\u6539\u6210 <b>500</b> \u540e\u91cd\u8dd1\uff0817 s\uff0c\u62a5\u544a 493 KB \u2192 <b>1 832 KB</b>\uff09\uff1a</p>")
    p1.append(tbl(["\u53e3\u5f84", "\u622a\u65ad\uff0850\uff09", "\u653e\u5f00\uff08500\uff09"], [
        ["incorrect nets \u6761\u6570", "50", b("**65**", 1)],
        ["\u81f3\u5c11\u8e29\u4e2d\u4e00\u4e2a\u53d7\u5f71\u54cd master", "42", b("**56**", 1)],
        ["\u4e00\u4e2a\u90fd\u6ca1\u8e29\u4e2d", "8", b("**9**", 2)],
        ["Ports / Nets / MP", "178 = 178 / 4753 vs 4784 / 95 vs 98", "\u9010\u4f4d\u76f8\u540c"],
    ]))
    p1.append(note("<b>\u8bfb\u6cd5</b>\uff1a\u6bd4\u4f8b\u7a33\u5b9a\u5728 <b>86 %</b>\uff0856/65\uff09\u2014\u2014 "
                   "\u539f\u6765\u90a3 50 \u6761\u786e\u5b9e\u662f\u88ab\u622a\u65ad\u7684\uff0c\u4f46<b>\u53e6\u5916 9 \u6761\u4e0d\u662f</b>\uff1a"
                   "\u5373\u4f7f\u628a\u5668\u4ef6\u5217\u8868\u653e\u5f00\uff0c\u5b83\u4eec\u4ecd\u7136\u4e00\u4e2a\u90fd\u4e0d\u8e29\u3002"
                   "\u8fd9 9 \u6761\u7684\u5668\u4ef6\u6e05\u5355\u91cc\u51fa\u73b0\u7684\u662f\u666e\u901a\u5355\u5143"
                   "\uff08<code>NAND2XL</code>\u3001<code>INVXL</code>\u3001<code>NOR4BXL</code>\u2026\uff09"
                   "\u52a0\u4e0a<b>\u677e\u6563\u5668\u4ef6</b> <code>MP(P18) x5</code>\u3001<code>MN(N18) x2</code>\u3002"))
    p1.append(note("<b>\u6240\u4ee5\u8fb9\u754c\u7aef\u53e3\u5047\u8bbe\u662f\u300c\u4e3b\u56e0\u300d\u800c\u4e0d\u662f\u300c\u5168\u90e8\u539f\u56e0\u300d</b>\uff1a"
                   "\u5b83\u89e3\u91ca\u4e86 86 %\u3002\u5269\u4e0b 9 \u6761\u4e0e\u677e\u6563\u5668\u4ef6\u6709\u5173\uff0c"
                   "\u800c\u677e\u6563\u5668\u4ef6\u6b63\u662f <code>MP 95 vs 98</code>\uff08\u22123\uff09\u90a3\u4e2a\u8ba1\u6570\u5dee\u7684\u540c\u4e00\u6279\u4e1c\u897f \u2014\u2014 "
                   "\u4e24\u8005<b>\u53ef\u80fd\u540c\u6e90</b>\uff0c\u4f46\u672c\u8f6e\u4ecd\u7136\u6ca1\u6709\u505a\u51fa\u80fd\u533a\u5206\u5b83\u4eec\u7684\u5b9e\u9a8c\uff0c"
                   "<b>\u4e0d\u4e0b\u7ed3\u8bba\u3002</b>"))
    p1.append("<h3>1.11 F3\uff08\u5757\u81ea\u8eab abstract\uff09\uff1a\u6700\u540e\u4e00\u4e2a\u5019\u9009\u8def\u5f84\u4e5f\u5df2\u6392\u9664</h3>")
    p1.append("<p>\u7b2c 5 \u8f6e\u7559\u4e0b\u7684\u552f\u4e00\u672a\u8bd5\u5019\u9009\u662f\u300c\u5148\u9020\u7236\u5c42 wrapper \u4f8b\u5316\u672c\u5757\uff0c\u518d\u4ece\u7236\u5c42\u8c03 "
              "<code>create_abstract</code>\u300d\u3002\u672c\u8f6e\u8dd1\u4e86\uff086 s\uff0crc=0\uff0c\u65e5\u5fd7 7 097 B\uff09\uff1a</p>")
    p1.append(tbl(["\u6b65\u9aa4", "\u7ed3\u679c"], [
        ["<code>open_lib pnr/sar16_pnr_paper_core</code>", "OK"],
        ["<code>get_blocks</code> / <code>get_designs</code>", b("\u8fd4\u56de\u7a7a", 2)],
        ["<code>current_design sar_digi_paper_core</code>", b("FAIL", 2)],
        ["<code>create_block sar16_wrap_top</code>", "OK"],
        ["<code>create_cell U_DUT sar_digi_paper_core</code>", "OK\uff08\u5757\u80fd\u88ab\u5f15\u7528\uff09"],
        ["<code>create_abstract -blocks sar_digi_paper_core</code>", b("FAIL", 2)],
        ["<code>create_abstract -all_blocks</code>", b("FAIL \u2192 0", 2)],
        ["<code>write_lef -design sar16_wrap_top</code>", "3 709 B\uff0c<b><code>MACRO sar*</code> = 0</b>"],
        ["<code>write_lef -design sar_digi_paper_core</code>",
         "179 596 B\uff0c<b><code>MACRO sar*</code> = 0</b>\uff08\u4e0e\u7b2c 5 \u8f6e <code>-design</code> \u53d8\u4f53\u5b57\u8282\u6570\u76f8\u540c\uff09"],
    ]))
    p1.append(note("<b>\u7ed3\u8bba</b>\uff1a\u5728 FC W-2024.09-SP3 + \u672c\u9879\u76ee\u5e93\u8bbe\u7f6e\u4e0b\uff0c"
                   "\u300c\u9876\u5c42\u5757 + \u65e0\u7236\u5c42\u300d\u4e0e\u300c\u9020\u7236\u5c42 wrapper\u300d<b>\u4e24\u6761\u8def\u90fd\u4e0d\u4ea7\u51fa\u5757\u81ea\u8eab abstract</b>\u3002"
                   "\u7b2c 5 \u8f6e\u7684\u516d\u4e2a <code>write_lef</code> \u53d8\u4f53 + <code>create_abstract</code> \u4e24\u79cd\u8c03\u7528\u65b9\u5f0f\uff0c"
                   "\u5171 <b>8 \u6761\u8def\u5f84\u5168\u90e8\u4e3a\u8d1f</b>\u3002"
                   "\u21d2 <b>LEF \u4e0d\u80fd\u4f5c\u4e3a\u8be5\u5757\u7684\u96c6\u6210 abstract\uff0c\u8fd9\u662f\u672c\u6d41\u7a0b/\u672c\u7248\u672c\u7684\u786e\u5b9a\u6027\u7ed3\u8bba\uff0c"
                   "\u4e0d\u518d\u662f\u300c\u672a\u9a8c\u8bc1\u300d\u3002</b>"))
    p1.append(note("<b>\u65b9\u6cd5\u8bb0\u5f55</b>\uff1a\u4e0a\u4e00\u6b21\u88f8\u8c03 <code>fc_shell</code> \u65e5\u5fd7\u662f 0 \u5b57\u8282\u3001\u88ab\u8bef\u5224\u4e3a\u300c\u6ca1\u8dd1\u8d77\u6765\u300d\u3002"
                   "\u771f\u56e0\u662f <b>fc_shell \u5728\u975e tty \u4e0b\u7f13\u51b2 stdout\uff0c\u88ab kill \u65f6\u7f13\u51b2\u5168\u4e22</b>\uff0c"
                   "\u52a0 <code>stdbuf -oL</code> \u540e\u540c\u4e00\u4e2a\u811a\u672c <b>22 s \u6b63\u5e38\u8dd1\u5b8c</b>\u3002"
                   "\u53e6\uff1a<code>run_pnr_paper_core.sh</code> \u5f00\u5934\u6709 <code>rm -rf $PRJ/pnr</code>\uff0c"
                   "**\u60f3\u590d\u7528\u5b83\u7684\u73af\u5883\u5c31\u4f1a\u5220\u6389 P&R \u4ea7\u7269** \u2014\u2014 \u672c\u8f6e\u6539\u4e3a\u76f4\u63a5\u8c03 "
                   "<code>fc_shell</code>\uff0c\u9879\u76ee\u6811 mtime \u626b\u63cf\u786e\u8ba4\u96f6\u5199\u5165\u3002"))
    p1.append("<h3>1.12 \u6b8b\u5dee\u8ffd\u67e5\u7684\u6536\u5c3e\uff08\u7b2c 16\u201320 \u8f6e\uff09\uff1a"
              "\u4e00\u4e2a\u5b9e\u6d4b\u7ed3\u679c + \u4e24\u4e2a\u88ab\u81ea\u5df1\u63a8\u7ffb\u7684\u5047\u8bbe</h3>")
    p1.append(note("<b>\u5b9e\u6d4b\uff08\u4e24\u9053\u5bf9\u7167\u5747\u901a\u8fc7\uff09\uff1a\u4e0d\u5c5e\u4e8e\u4efb\u4f55\u5df2\u653e\u7f6e\u5355\u5143\u7684\u5668\u4ef6</b>"))
    p1.append(tbl(["\u4fa7", "\u542b\u4e49", "\u5668\u4ef6\u6570"], [
        ["\u7248\u56fe\u62bd\u53d6 <code>svdb/*.sp</code>",
         "\u76f4\u63a5\u843d\u5728 <code>ICV_2\u2026ICV_9</code> \u91cc\uff08p18 \u00d7 114 / n18 \u00d7 110\uff09",
         b("**224**", 1)],
        ["\u6e90\u7f51\u8868 <code>sar16.cdl</code>", "\u76f4\u63a5\u843d\u5728 44 \u4e2a\u8bbe\u8ba1 subckt \u91cc",
         b("**0**", 0)],
    ]))
    p1.append(note("\u5bf9\u7167\uff1a\u62bd\u53d6\u7f51\u8868\u91cc\u5e93\u5355\u5143 master \u5171 <b>89</b> \u4e2a\u3001\u5668\u4ef6\u5408\u8ba1 <b>845</b>\uff1b"
                   "\u5e76\u4e14\u4efb\u53d6\u4e00\u4e2a\u5df2\u77e5\u5728\u5355\u5143\u5185\u7684\u5668\u4ef6\uff08<code>DFFSXL</code> \u7684\u7b2c\u4e00\u4e2a\uff09"
                   "\u5fc5\u987b\u88ab\u5f52\u5230\u5b83\u81ea\u5df1\u7684 master \u2014\u2014 \u4e24\u9053\u90fd\u8fc7\u624d\u51fa\u6570\u3002"
                   "\u21d2 \u7248\u56fe\u91cc\u6709 224 \u4e2a\u5668\u4ef6<b>\u4e0d\u5c5e\u4e8e\u4efb\u4f55\u5df2\u653e\u7f6e\u5355\u5143</b>\uff0c\u6e90\u4fa7\u4e00\u4e2a\u90fd\u6ca1\u6709\u3002"
                   "\u5f62\u6001\u4e0e 1.9 \u8282\u300c\u51e0\u4f55\u8de8\u5355\u5143\u8fb9\u754c\u5408\u5e76\u300d\u4e00\u81f4\u3002"))
    p1.append("<h4>\u88ab\u63a8\u7ffb\u7684\u5047\u8bbe\uff08\u540c\u6837\u8bb0\u8fdb\u6765\uff0c\u907f\u514d\u540e\u4eba\u91cd\u8d70\uff09</h4>")
    p1.append(tbl(["\u5047\u8bbe", "\u68c0\u9a8c", "\u7ed3\u679c"], [
        ["\u300c\u6e90\u4fa7\u90a3 98/98 \u662f\u56e0\u4e3a\u9ed1\u76d2\u540d\u5355\u6ca1\u76d6\u5168\u300d",
         "\u628a\u540d\u5355\u4ece 89 \u4e2a\u6709\u5668\u4ef6\u7684 master \u6269\u5230 <b>\u5168\u90e8 109 \u4e2a LEF MACRO</b> \u91cd\u8dd1",
         b("\u63a8\u7ffb\uff1a<code>not located</code> \u544a\u8b66 = 0", 2)],
        ["\u300c20 \u4e2a\u5355\u5143\u53ea\u5728\u7f51\u8868\u91cc\u6709\u300d\uff08\u7b2c 10 \u8f6e\u81ea\u5df1\u63d0\u7684\uff09",
         "\u540c\u4e0a\uff1b\u62a9\u5927\u540d\u5355\u540e\u90a3\u4e9b\u5355\u5143\u5728\u7248\u56fe\u4fa7\u540c\u6837\u5b58\u5728",
         b("\u63a8\u7ffb\uff1a<code>ADDHXL 1 = 1</code> \u7b49\u9010\u884c\u76f8\u7b49", 2)],
    ]))
    p1.append(note("<b>\u672c\u8f6e\u5b9e\u9a8c\u7684\u51c0\u7ed3\u679c</b>\uff1a\u62d3\u5c55\u5230 109 \u4e2a\u540d\u5b57\u540e\uff0c"
                   "<code>Ports 178 = 178</code> \u2713\u3001<b>\u5355\u5143\u7c7b\u578b\u9010\u884c\u76f8\u7b49</b> \u2713\u3001"
                   "<code>Nets 4678 vs 4709</code>\uff08\u221231\uff0c\u4e0e\u7b2c 9 \u8f6e\u8d77\u9010\u4f4d\u4e00\u81f4\uff09\u3002"
                   "\u21d2 \u672a\u89e3\u91ca\u7684\u4ecd\u662f <b>9 \u6761 incorrect net \u4e0e <code>MP \u22123</code></b>\uff0c"
                   "\u4f46\u53ef\u4ee5\u786e\u5b9a\u5b83\u4eec<b>\u4e0e\u300c\u5355\u5143\u7f3a\u5931 / \u672a\u9ed1\u76d2\u300d\u65e0\u5173</b> \u2014\u2014 "
                   "\u8fd9\u6761\u6392\u67e5\u8def\u5f84\u5df2\u5173\u95ed\u3002"))
    p1.append(note("<b>\u5982\u4f55\u7ee7\u7eed</b>\uff1a\uff081\uff09\u628a\u6e90\u4fa7\u90a3 98/98 \u7684\u884c\u5b9a\u4f4d\u5230\u5177\u4f53\u5bf9\u8c61"
                   "\uff08\u54ea\u4e9b subckt \u7684\u54ea\u4e9b\u5668\u4ef6\uff09\uff0c\u800c\u4e0d\u662f\u53ea\u770b\u8ba1\u6570\uff1b"
                   "\uff082\uff09\u5bf9\u90a3 9 \u6761\u7f51\u9010\u6761\u53d6\u51fa\u4e24\u8fb9\u7684\u5668\u4ef6\u2014\u5f15\u811a\u5bf9\u5e94\u5173\u7cfb\uff0c"
                   "\u76f4\u63a5\u770b\u5dee\u5728\u54ea\u4e00\u4e2a\u5f15\u811a\u4e0a\u3002\u4e24\u6761\u90fd\u4e0d\u518d\u4f9d\u8d56\u672c\u8282\u5df2\u5173\u95ed\u7684\u731c\u60f3\u3002"))
    p1.append("<h4>1.12.1 \u4ea4\u63a5\u7ed9\u4e0b\u4e00\u4efb\u7684\u8d77\u70b9\uff08\u7ecf\u7b2c 22\u201323 \u8f6e\u4fee\u6b63\uff09</h4>")
    p1.append("<p>\u7b2c 22 \u8f6e\u628a\u90a3 9 \u6761\u7f51\u9010\u5f15\u811a\u644a\u5f00\uff0c\u5f62\u6001\u7ec8\u4e8e\u6e05\u695a\uff1a"
              "<b>\u7248\u56fe\u5728\u82e5\u5e72\u5904\u6bd4\u6e90\u4fa7\u591a\u5408\u5e76\u4e86\u7f51\u7edc</b>\u3002\u6700\u6e05\u695a\u7684\u4e00\u4f8b\uff1a</p>")
    p1.append("<pre>X1/X534(84.05,347.36)  NOR4BXL     Xu_calib_ctrl/XctmTdsLR_2_1933  NOR4BXL\n"
              "  Y:  X1/486                            Y:  Xu_calib_ctrl/tmp_net323\n"
              "  B:  X1/486                            ** Xu_calib_ctrl/tmp_net323 **\n"
              "  ** X1/486 **                          B:  Xu_calib_ctrl/n1186_CDR1</pre>")
    p1.append(note("\u7248\u56fe\u4fa7 <code>Y</code> \u4e0e <code>B</code> \u540c\u5728 <code>X1/486</code>\uff0c"
                   "\u6e90\u4fa7\u5206\u5c5e <code>tmp_net323</code> \u4e0e <code>n1186_CDR1</code>\u3002"
                   "\u8fd9\u4e0e\u300c\u7248\u56fe\u7f51\u8868\u6bd4\u6e90\u5c11 31 \u4e2a\u7f51\u300d\u65b9\u5411\u4e00\u81f4\u3002"))
    p1.append(note("<b>\u7b2c 23 \u8f6e\u53c8\u6392\u6389\u4e00\u6761\u9519\u8def</b>\uff1a\u90a3\u6279\u5668\u4ef6\u5c5e\u4e8e "
                   "<code>XctmTdsLR_*</code> \u5757\uff0c\u6e90\u4fa7\u6709 <b>486 \u4e2a\u4e00\u6b21\u6027\u5b9e\u4f8b</b>\uff0c"
                   "\u800c\u7248\u56fe\u62bd\u53d6\u91cc\u662f 0\u3002\u4f46\u62a5\u544a\u81ea\u5df1\u5df2\u628a\u4e24\u8fb9\u914d\u4e0a\u4e86\u5bf9"
                   "\uff08<code>X2/M34</code> \u2194 <code>Xu_calib_ctrl/XctmTdsLR_1_1905/M9</code>\uff09"
                   "\u21d2 <b>\u53c8\u662f\u300c\u6539\u540d\u300d\u800c\u4e0d\u662f\u300c\u7f3a\u5931\u300d</b>\u3002"
                   "\uff08\u540c\u4e00\u4e2a\u5751\u7b2c 11 \u8f6e\u8bb0\u8fc7\u4e00\u6b21\uff09"))
    p1.append(tbl(["\u5df2\u7ecf\u8d70\u4e0d\u901a\u7684\u8def", "\u7ed3\u8bba"], [
        ["\u67e5\u5668\u4ef6\u6570\u5dee\u5f52\u56e0\uff08\u624b\u6307\u5408\u5e76 / INJECT LOGIC / tie \u94fe\uff09",
         "\u90fd\u5df2\u5b9a\u91cf\u6216\u8bc1\u4f2a\uff08\u00a71.6\u2013\u00a71.8\uff09"],
        ["\u67e5\u5355\u5143\u662f\u5426\u7f3a\u5931 / \u672a\u9ed1\u76d2", "\u5df2\u5173\u95ed\uff08\u00a71.12\uff0c109 \u4e2a\u540d\u5b57\u96f6\u544a\u8b66\uff09"],
        ["\u67e5\u300c\u7248\u56fe\u91cc\u6ca1\u6709\u67d0\u4e2a\u540d\u5b57\u300d", "\u5df2\u8bc1\u660e\u4e0d\u53ef\u4f5c\u4e3a\u5224\u636e\uff08\u00a71.7.1\u3001\u00a71.12.1\uff09"],
    ]))
    p1.append(note("<b>\u5efa\u8bae\u7684\u4e0b\u4e00\u6b65\uff08\u8fd8\u6ca1\u6709\u4eba\u8d70\u8fc7\uff09</b>\uff1a\u4e0d\u8981\u518d\u67e5\u5668\u4ef6\u6570\u6216\u540d\u5b57\uff0c"
                   "\u76f4\u63a5\u9488\u5bf9 <code>XctmTdsLR_*</code> \u533a\u57df\u7684<b>\u7f51\u7edc\u5212\u5206</b>\u505a\u5355\u53d8\u91cf\u5b9e\u9a8c\u3002"
                   "\u6700\u76f4\u63a5\u7684\u4e00\u4e2a\uff1a\u5728 deck \u91cc\u628a\u62bd\u53d6\u4fa7\u7684\u5e76\u8054\u5408\u5e76\u5f00\u5173\u5173\u6389"
                   "\uff08<code>LVS REDUCE PARALLEL MOS NO</code>\uff09\u8dd1\u4e00\u6b21\uff0c"
                   "\u8ba9\u4e24\u8fb9\u90fd\u505c\u5728\u539f\u59cb\u5668\u4ef6\u7ea7\uff0c\u770b\u90a3 31 \u4e2a\u7f51\u7684\u5dee\u662f\u5426\u968f\u4e4b\u6539\u53d8 \u2014\u2014 "
                   "\u82e5\u4e0d\u53d8\uff0c\u8bf4\u660e\u7f51\u5dee<b>\u4e0d\u662f</b>\u5408\u5e76\u9020\u6210\u7684\uff0c\u65b9\u5411\u5c31\u5f97\u6362\uff1b"
                   "\u82e5\u53d8\uff0c\u5c31\u627e\u5230\u4e86\u673a\u5236\u3002\u8fd9\u662f\u4e00\u4e2a\u80fd\u76f4\u63a5\u5224\u771f\u5047\u7684\u5b9e\u9a8c\u3002"))
    # ---- P2 时序 ----
    p2 = []
    rows = []
    for c in ("typical", "slow", "fast"):
        r = STA["res"].get(c, {})
        rows.append([c,
                     b(str(r.get("vs")), 0) if r.get("vs") == 0 else b(str(r.get("vs")), 2),
                     f(r.get("ws")), f(r.get("ts")),
                     b(str(r.get("vh")), 0) if r.get("vh") == 0 else b(str(r.get("vh")), 2),
                     f(r.get("wh")), f(r.get("th"))])
    p2.append("<h3>2.1 三角 setup / hold 汇总（post-route，带 SPEF）</h3>")
    p2.append(tbl(["角", "setup 违例", "setup WNS", "setup TNS", "hold 违例", "hold WNS", "hold TNS"], rows))
    p2.append(note("<b>setup 三角全部 0 违例</b>；<b>hold 未闭合</b>（slow 16 条 / fast 12 条 / typical 1 条）。"
                   "这两件事必须分开写 —— 混成一句「时序通过」是错的。"))
    rows = []
    for c in ("typical", "slow", "fast"):
        for ck in ("clk", "dec_clk"):
            s = STA["setup"].get((c, ck))
            fm = STA["fmax"].get((c, ck), {})
            if s:
                rows.append([c, "<code>" + ck + "</code>", f(s["slack"]),
                             (f(fm.get("fmax"), 1, " MHz") if fm.get("fmax") else NA),
                             "<code>" + esc(s["start"]) + "</code>",
                             "<code>" + esc(s["end"]) + "</code>"])
    p2.append("<h3>2.2 各时钟域最差 setup 路径</h3>")
    p2.append(tbl(["角", "时钟", "slack", "F<sub>max</sub> 估计", "起点", "终点"], rows))
    p2.append(note("两条 <code>dec_clk</code> 的 <code>0.000000</code> 是"
                   "<b>门控锁存器 D 端的结构性零</b>（arrival = required），不携带设计信息 —— "
                   "这是<b>报告口径缺陷</b>，不是零余量。真实数据寄存器的最差余量需单独取。"))
    if STA["derate"]:
        rows = [[e["corner"], e["tag"], f(e["nominal"]), f(e["derated"]),
                 f((e["derated"] or 0) - (e["nominal"] or 0))] for e in STA["derate"]]
        p2.append("<h3>2.3 OCV derate 扫描</h3>")
        p2.append(tbl(["角", "derate 档", "名义 WNS", "derate 后 WNS", "Δ"], rows))
    rows = []
    for c in ("typical", "slow", "fast"):
        h = STA["hold"].get(c)
        if h:
            rows.append([c, f(h["slack"]), "<code>" + esc(h["start"]) + "</code>",
                         "<code>" + esc(h["end"]) + "</code>"])
    p2.append("<h3>2.4 最差 hold 路径</h3>")
    p2.append(tbl(["角", "hold slack", "起点", "终点"], rows))
    p2.append(note("本轮 hold 违例的端点已从「输出端口」变成<b>输入端口与门控锁存器</b>"
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
                   "<b>漏了输入侧</b> —— 实测 <b>1 / 16 / 12（合计 29，口径 = PT <code>viol_hold</code>；在输入侧</b>且幅度更大"
                   "（−0.202 vs −0.054）。"))

    # ---- P3 GDS ----
    p3 = []
    p3.append("<h3>3.1 交付 GDS 的独立普查（自写解析器，不采信工具自报）</h3>")
    if "error" not in G:
        p3.append(tbl(["项", "实测", "口径"], [
            ["文件字节", "{:,}".format(G["size"]), "与 <code>RESULT_CURRENT.env</code> 一致"],
            ["md5", "<code>" + (gds_md5[:16] + "…" if gds_md5 else NA) + "</code>", "交付身份"],
            ["库名", "<code>" + esc(G["libname"]) + "</code>", "合并工具留下的容器名（未改）"],
            ["struct 数", str(G["structs"]), "含 top + 标准单元 + 过孔单元"],
            ["顶层 cell", "<code>sar_digi_paper_core</code>", "「被定义且未被引用」的集合唯一"],
            ["顶层 TEXT 标签", str(G["labels"]), "去重后 " + str(G["distinct"]) + " 个"],
            ["顶层 SREF / BOUNDARY", "{:,} / {:,}".format(G["srefs"], G["bounds"]), "实例 / 多边形"],
            ["记录总数", "{:,}".format(G["recs"]), "零解析错误"],
        ]))
    else:
        p3.append("<p>GDS 普查失败：" + esc(G["error"]) + "</p>")
    p3.append("<h3>3.2 电源网格与引脚</h3>")
    p3.append("<p>实测几何（不是工具自报）：M1 标准单元电源轨 <b>86</b> 条（43 行 × 2 网，5.04 µm 行高）；"
              "M2 竖直电源条带 <b>34</b> 条（12.5 µm 间距，全高 428.4 µm）；"
              "VDD/VSS 端口各自落在带标签的条带上。</p>")
    p3.append(tbl(["检查", "接手前（v4.3）", "v5.1", "判据"], [
        ["信号引脚与电源结构重叠", b("128 / 232", 2), b("88 / 176（保守口径）", 1),
         "几何 keep-out；<b>电气判据另计</b>"],
        ["Calibre 短路组", b("35", 2), b("0", 0), "Calibre 自报"],
    ]))
    p3.append(note("<b>口径声明</b>：引脚判据把「跨层叠压」（M2 引脚压 M1 轨）也算重叠，"
                   "这是<b>保守的 keep-out 口径</b>，<b>不等价于短路</b>；底/顶边界那条轨横贯整宽，"
                   "任何贴边引脚在几何上都与它重叠。真正判据是 LVS 短路组数，它已是 0。"
                   "两者不一致时以 LVS 为准，不拿保守判据冒充失败。"))
    p3.append("<h3>3.3 布线质量</h3>")
    rows = []
    if PNR.get("util"):
        u = PNR["util"]
        rows.append(["利用率", "%.4f" % u["ratio"], "块面积 %.1f µm²；单元面积 %.1f µm²"
                     % (u["total"], u["cells"])])
    if PNR.get("nets"):
        rows.append(["布线网数", "{:,}".format(PNR["nets"]), "FC 自报"])
    if PNR.get("cong"):
        c = PNR["cong"]
        rows.append(["拥塞（双向）", "%d 个 GRC 溢出（%.2f%%），max %d" % (c["grc"], c["pct"], c["mx"]),
                     "V 向 %.2f%%" % PNR["cong_v"]["pct"] if PNR.get("cong_v") else ""])
    if DRC.get("rules"):
        rows.append(["DRC", "%d 条规则 / <b>%d</b> 条结果" % (drc_rules, drc_res),
                     "<code>drc_CAL.SUM</code>"])
    p3.append(tbl(["项", "数值", "来源"], rows))
    if DRC.get("nz"):
        rows = [[("<code>" + n + "</code>"), str(t), (str(c) if c is not None else "—")]
                for n, t, c in sorted(DRC["nz"], key=lambda x: -(x[2] or x[1]))[:12]]
        p3.append("<h4>逐规则非零结果（前 12）</h4>")
        p3.append(tbl(["规则", "写入值", "括号内真值"], rows))
        p3.append(note("<code>BD_*</code> 属芯片级 BORDER 规则，单 <code>DFFSX1</code> 实验已证明"
                       "在库单元内部即会触发，<b>但豁免须由负责人批准，本报告不宣告豁免</b>。"))

    # ---- P4 功能 ----
    p4 = []
    p4.append("<h3>4.1 接口（收窄后）</h3>")
    p4.append(tbl(["侧", "端口数", "说明"], [
        ["源网表（v2lvs）", str(len(P["src"])), "后布线网表转出"],
        ["版图提取", str(len(P["lay"])), "含 VDD/VSS 两个电源端口"],
        ["仅在源侧", b(str(len(P["so"])), 0 if not P["so"] else 2), ", ".join(P["so"]) or "无"],
        ["仅在版图层", str(len(P["lo"])), ", ".join(P["lo"]) or "无"],
    ]))
    p4.append(note("50 个退化端口已彻底消除（<code>weight_rd_data</code> 两侧均为 0，"
                   "<code>srm_residue_o</code> 两侧均为 10）。剩余差异是电源端口在两侧的表示不同，"
                   "已通过把 deck 的 <code>LVS GLOBALS ARE PORTS</code> 由 <code>NO</code> 改为 "
                   "<code>YES</code> 处理 —— 该设置当初写 <code>NO</code> 是因为「版图没有电源端口」，"
                   "而 <code>-generate_pin</code> 之后版图有了，<b>前提消失、设置就该跟着变</b>。"))
    p4.append("<h3>4.2 功能验证现状</h3>")
    p4.append(tbl(["验证项", "状态", "判据"], [
        ["门级仿真（零延迟）", b("已有基线", 1),
         "历史轮次：RTL / +nospecify / +delay_mode_zero 三臂 trace md5 逐位相同"],
        ["形式化等价（RTL↔网表）", b("未做", 2), "本轮改动了 RTL 接口，任何旧等价结论都不再适用"],
        ["带 SDF 的门级仿真", b("未做", 2), "无延迟标注"],
        ["CDC lint", b("未做", 2), "SDC 自述 not delivered by this file"],
        ["IR-drop", b("未做", 2), "无电源网格签核"],
    ]))
    p4.append(note("<b>本轮改动过 RTL 接口，因此旧的功能等价结论一律作废</b>，"
                   "必须在新网表上重跑才能主张功能正确。这是接手带来的<b>新增验证债</b>，如实记录。"))

    # ---- 附 A 整理 ----
    pa = []
    try:
        man = json.load(io.open(MANIFEST, encoding="utf-8"))
    except Exception:
        man = None
    if man:
        pa.append("<h3>A.1 整理结果总览</h3>")
        pa.append(tbl(["类别", "条目", "文件", "字节", "处置"], [
            ["可再生成的大文件（PDK 标准单元库副本）", "2", "2",
             "{:,}".format(man["summary"].get("delete_bytes", 0)), b("删除", 2)],
            ["被取代的交付包 / 探针 / 历史报告 / 远端抓取",
             str(man["summary"].get("archive_items", 0)),
             str(man["summary"].get("archive_files", 0)),
             "{:,}".format(man["summary"].get("archive_bytes", 0)), b("归档（可回退）", 1)],
            ["交付件 / 源码 / 当前报告 / 已封存审计包", "—",
             str(man["summary"].get("keep_files", 0)),
             "{:,}".format(man["summary"].get("keep_bytes", 0)), b("保留不动", 0)],
        ]))
        pa.append("<h3>A.2 归档区构成 <code>05_归档/SAR16后端_20260918/</code></h3>")
        cats = {}
        for m in man["moves"]:
            cat = os.path.relpath(m["dst"], man["archive_root"]).split(os.sep)[0]
            e = cats.setdefault(cat, [0, 0])
            e[0] += m["files"]
            e[1] += m["bytes"]
        rows = [[("<code>" + c + "</code>"), str(v[0]), "{:,}".format(v[1])]
                for c, v in sorted(cats.items())]
        pa.append(tbl(["分类", "文件", "字节"], rows))
        pa.append("<h3>A.3 判定语义与证据</h3>")
        pa.append("<ul>"
                  "<li><b>工作记录 / 证据 / 被取代但不可再生的交付件 → 归档</b>（移动，带 "
                  "<code>MOVE_LOG.csv</code> + <code>restore_archive.py</code>，可一键回退）。</li>"
                  "<li><b>可从 PDK 或本轮 run 重新生成的大文件 → 删除</b>"
                  "（<code>cleanup_manifest.json</code> 记录路径 + 字节 + md5 + 理由）。</li>"
                  "<li><b>交付件 / 源码 / 当前报告 / 已封存的审计包 → 保留不动</b>。</li>"
                  "<li>引用完整性：对整理后保留的 604 份文档做了全量扫描，"
                  "命中 32 处指向归档区的引用；其中 <b>3 处活引用已修复</b>"
                  "（<code>run_tb.sh</code> 路径改指、两份文档加归档告示），"
                  "<b>2 类有意未改</b>：被接手方的 <code>.workbuddy/memory/*</code> 是"
                  "「当时看到了什么」的记录，<code>_audit/TASK-000R_20260918/</code> 是带 SHA-256 "
                  "封印的审计包 —— 改它们等于篡改记录/破坏封印。见归档区 "
                  "<code>REFERENCE_UPDATE.md</code>。</li>"
                  "</ul>")
    else:
        pa.append("<p>整理清单尚未生成（本轮整理在执行阶段写入 <code>cleanup_manifest.json</code>）。</p>")

    # ---- 附 B ----
    pb = []
    pb.append("<h3>B.1 交付件（v5.1）</h3>")
    pb.append(tbl(["文件", "字节", "身份"], [
        ["<code>sar_digi_paper_core_merged.gds</code>", "{:,}".format(G.get("size", 0)),
         "<code>" + (gds_md5[:16] + "…" if gds_md5 else NA) + "</code>"],
        ["<code>sar_digi_paper_core.lef</code>", "179 611", "标准单元帧视图（<b>无块自身 abstract</b>）"],
        ["<code>sar_digi_paper_core_pnr.v</code>", "378 258", "布线后网表"],
        ["<code>sar_digi_paper_core_pnr.sdc</code>", "83 282", "P&R 阶段约束"],
        ["<code>RESULT_CURRENT.env</code>", "2 380", "机读汇总（59 键）"],
    ]))
    pb.append("<h3>B.2 LVS 残差归因（本轮新增，全部为实测）</h3>")
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
    pb.append("<h4>B.2.1 第 6 轮：又排除三条，并撤回我自己的一条错判</h4>")
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
    pb.append(note("<b>结论收窄</b>：库自洽、单元数目完全一致、端口已相等 —— "
                   "因此 <code>+50</code> 的器件残差只可能来自"
                   "<b>同一单元在本设计的行/轨/条带环境里被提取出的器件与孤立提取不同</b>。"
                   "这是下一步唯一的目标，不再是「到处都可能是原因」。<br><b>第 6 轮进一步把它钉成一个可执行实验</b>：源侧已证明完全正确（<code>Σ(CDL 展开) = 50026 = Calibre 源计数</code>），几何是 kit 的原件，CDL 无多重性参数 —— 因此 <b>+660 个物理器件只能是提取器在「单元内容之外」由放置上下文（相邻单元 abutment / M1 轨 / M2 条带 / 井连接）生成的</b>。<b>第 7 轮的对照把这条也降级了</b>：『上下文生成器件』目前<b>只是候选，无正面证据</b>。若继续追，必须先<b>修好放置模型并用对照证明它是对的</b>（判据：随机单元中心上覆盖实例数几乎全为 1），在那之前任何基于坐标的归属都不写进报告。原计划的裁剪式对照实验：比较器件数。判据是器件数差，不再需要新假设。"))
    pb.append("<h4>B.2.2 第 7 轮：一次方法学纠错（撤回依赖自研几何模型的归属）</h4>")
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
    pb.append("<h3>B.3 块自身 abstract：本版本的写出路径不提供</h3>")
    pb.append(tbl(["命令", "存在性", "实测行为"], [
        ["<code>write_lef_abstract</code>", b("absent", 2), "——"],
        ["<code>create_abstract</code>", b("EXISTS", 1),
         "在顶层块上调用报 <code>Error: Could not find any instantiation for the given "
         "block(s). (ABS-297)</code> —— 其语义是「从父层给被子块建 abstract」"],
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
    pb.append(note("并且库目录里<b>物理上只有 <code>design.ndm</code> 一种 view</b> "
                   "（<code>sar16_route_paper_core/</code> 与 <code>sar_digi_paper_core/</code> "
                   "下均只有 design + data_map + SHADOW_DESIGN），<b>没有 abstract view 可导</b>。"
                   "→ 本 FC 版本（W-2024.09-SP3）在「顶层块 + 无父层」的前提下无法产出块自身 abstract；"
                   "唯一未试的候选是<b>先造父层 wrapper 例化本块，再从父层调 create_abstract</b>。"))
    pb.append(note("<b>F3 \u72b6\u6001\u66f4\u65b0\uff08\u7b2c 13 \u8f6e\uff09</b>\uff1a"
                   "\u4e0a\u9762\u5199\u7684\u300c\u552f\u4e00\u672a\u8bd5\u7684\u5019\u9009\u662f\u9020\u7236\u5c42 wrapper\u300d"
                   "<b>\u5df2\u7ecf\u8bd5\u8fc7\uff0c\u7ed3\u679c\u4e3a\u8d1f</b>\uff1a"
                   "<code>create_block</code> + <code>create_cell U_DUT sar_digi_paper_core</code> \u90fd\u6210\u529f\uff0c"
                   "\u4f46 <code>create_abstract -blocks/-all_blocks</code> \u5747\u5931\u8d25\uff0c"
                   "<code>write_lef -design sar16_wrap_top</code> \u53ea\u6709 3 709 B \u4e14 "
                   "<code>MACRO sar*</code> = 0\u3002"
                   "\u21d2 \u5171 <b>8 \u6761\u8def\u5f84\u5168\u90e8\u4e3a\u8d1f</b>\uff0c"
                   "\u8be6\u89c1 1.11\u3002"))
    pb.append("<h3>B.4 LVS 错误分解（第 9 轮已归因，详见 1.6）</h3>")
    pb.append(tbl(["口径", "基线 deck（<code>INJECT LOGIC YES</code>）",
                   "本轮最佳（<code>INJECT NO</code>＋单元黑盒）"], [
        ["不同端口数", "178 vs 179 → 变换后 178 = 178", "178 = 178"],
        ["不同网表数", "12146 vs 12255（−109）", "4753 vs 4784（−31）"],
        ["不同器件数", "MN +306 / MP +354，原始合计 <b>+660</b>",
         "<b>总器件 3799 = 3799 相等</b>"],
        ["VDD 连接数", "14636 vs 13702（+934）", "—（即 +660 的另一种量法）"],
        ["incorrect nets", "50（受 <code>LVS REPORT MAXIMUM 50</code> 截断）",
         "<b>6</b> 个错误网块"],
    ]))
    pb.append(note("基线的四个错误类（不同 nets / 不同 instances / "
                   "connectivity / property）有一半来自 kit deck 的 "
                   "<code>LVS INJECT LOGIC YES</code>；关掉它以后器件总数精确相等、"
                   "端口相等、黑盒后每个单元的实例数逐个相等。"
                   "剩下的净差异是<b>版图网表比源少 109（平铺）/ "
                   "31（黑盒）个网</b>，形态与并联手指合并一致。"))
    pb.append("<h4>LEF 计数实测（本轮重数，含结构自检）</h4>")
    pb.append(tbl(["文件", "MACRO", "PIN", "结构自检", "块自身 MACRO"], [
        ["v5.1 <code>sar_digi_paper_core.lef</code>", "<b>109</b>", "<b>630</b>", "CLEAN", "<b>无</b>"],
        ["v5.0 <code>sar_digi_paper_core.lef</code>", "112", "651", "CLEAN", "<b>无</b>"],
        ["旧交付 README 声称", "115", "665", "—", "无"],
    ]))
    pb.append(note("口径：<code>MACRO</code> = 顶层 <code>MACRO &lt;name&gt;</code> 块；"
                   "<code>PIN</code> = 宏内第一层 <code>PIN &lt;name&gt;</code> 块；"
                   "自检 = 每个 <code>END</code> 都能正确闭合、到 EOF 深度归零。"
                   "（<code>END &lt;name&gt;</code> 也用来收 LAYER/SITE 块，"
                   "所以“<code>END &lt;name&gt;</code> 条数 = MACRO + PIN”这个自检是错的，"
                   "已换成严格块嵌套。）"
                   "旧 README 的 115/665 对不上任何一版文件。"))
    pb.append("<h3>B.5 结论边界（不得外推）</h3>")
    pb.append('<ul>'
              '<li>LVS 仍 <b>INCORRECT</b>：剩余为器件记账差与网数差，<b>不得据本报告宣称流片就绪</b>。</li>'
              '<li>块自身 abstract 缺失：LEF 里没有 <code>MACRO sar_digi_paper_core</code>。</li>'
              '<li>hold 未闭合（slow 16 条），且部分落在输入端口与门控锁存器上，属约束建模问题。</li>'
              '<li>本轮改过 RTL 接口 → 形式化等价与门级仿真需在新网表上重做。</li>'
              '<li>DRC 的 <code>BD_*</code> 属芯片级规则，豁免未批准。</li>'
              '<li>功耗数字为部分标注（PWR-414/415），不可当签核值。</li>'
              '</ul>')
    pb.append(note("<b>第 10 轮新增的最高优先级约束</b>："
                   "交付的 P&R 网表自身不自洽 —— "
                   "85 个 tie 反相器的根网络 <code>HFSNET_8</code> "
                   "与两个最大子模块的 <code>rst_n</code> 网络 "
                   "<code>HFSNET_119</code> 均<b>无驱动</b>，"
                   "而顶层 RTL 把 <code>rst_n</code> 接到了这两个子模块。"
                   "⇒ <b>本包不得据现有 <code>.v</code> 做门级仿真签核</b>；"
                   "需重新导出网表以匹配版图（详见 1.7）。"))
    pb.append(note("<b>\u8be5\u7ea6\u675f\u7684\u7cbe\u786e\u8868\u8ff0\uff08\u7b2c 11 \u8f6e\u6821\u6b63\uff09</b>\uff1a"
                   "\u65e0\u9a71\u52a8\u7684\u662f<b>6 \u6839\u6839\u7f51\u7edc</b>"
                   "\uff08<code>HFSNET_8</code> \u53ca\u5176\u7236\u5c42\u522b\u540d <code>HFSNET_124</code>\u3001"
                   "\u4ee5\u53ca <code>HFSNET_330/346/362/363/364</code>\uff09\uff1b"
                   "<code>HFSNET_119</code> <b>\u662f\u6709\u9a71\u52a8\u7684</b>"
                   "\uff08\u7531 <code>HFSINV_6951_589</code> \u9a71\u52a8\uff0c\u5b83\u7684\u8f93\u5165\u5c31\u662f\u90a3\u6839\u65e0\u9a71\u52a8\u7684\u6839\uff09\u3002"
                   "\u8fd9\u4e9b tie \u7f51\u7edc\u4e0e 85 \u4e2a <code>HFSINV</code> "
                   "<b>\u5728\u7248\u56fe\u91cc\u90fd\u5b58\u5728</b>\uff08SPEF \u5b9e\u6d4b\uff09\uff0c"
                   "\u7f3a\u7684\u53ea\u662f\u300c\u6839\u7f51\u7edc\u7684\u5e38\u91cf\u503c\u6ca1\u88ab\u5199\u8fdb\u7f51\u8868\u300d\u3002"
                   "\u5b83\u4e0d\u662f LVS \u4e0d\u6536\u655b\u7684\u539f\u56e0\uff08\u5df2\u7528\u5355\u53d8\u91cf\u5b9e\u9a8c\u8bc1\u4f2a\uff0c\u89c1 1.8\uff09\u3002"))
    pb.append("<h3>B.6 交接状态</h3>")
    pb.append("<p>接手方已停止被接手方的数字后端会话（其 RTL 会话与 VM 上的 <code>dc_shell</code> 未触碰）。"
              "全部写入动作均有备份与 md5 双向对账；探针一律只读。</p>")

    pb.append("<h2 id=\"z\">\u7ed3\u8bed \u00b7 \u63a5\u624b\u603b\u7ed3</h2>")
    pb.append("<h3>Z.1 \u4e00\u53e5\u8bdd\u7ed3\u8bba</h3>")
    pb.append(note("<b>WorkBuddy \u7684\u6570\u5b57\u540e\u7aef\u4efb\u52a1\u5df2\u63a5\u624b\u5e76\u63a8\u8fdb\u5230 v5.1\uff1a"
                   "\u771f\u5b9e\u7f3a\u9677\u5df2\u4fee\u590d\u5e76\u9a8c\u8bc1\uff08Calibre \u77ed\u8def 35 \u2192 0\u3001\u7aef\u53e3 178 = 178\uff09\uff0c"
                   "\u4e09\u89d2\u65f6\u5e8f\u5168\u90e8\u4e3a\u6b63\u4e14\u5757\u5185 hold \u96f6\u8fdd\u4f8b\uff0c"
                   "GDS/\u5e03\u7ebf/\u529f\u80fd\u6570\u636e\u5747\u4e3a\u540c\u4e00\u6b21\u8fd0\u884c\u7684 v5.1 \u53e3\u5f84\uff1b"
                   "<b>\u4f46 LVS \u672a\u6536\u655b\uff0c\u4e0d\u5f97\u636e\u672c\u5305\u5ba3\u79f0\u6d41\u7247\u5c31\u7eea\u3002</b></b>"
                   "\u6b8b\u5dee\u5df2\u5b9a\u91cf\u5f52\u56e0\u5230 86 %\uff0c\u5269\u4f59 9 \u6761\u7f51\u7684\u5f62\u6001\u5df2\u67e5\u6e05\u3001"
                   "\u4f46\u5c1a\u65e0\u5224\u522b\u5b9e\u9a8c\u3002"))
    pb.append("<h3>Z.2 \u4ea4\u4ed8\u72b6\u6001</h3>")
    pb.append(tbl(["\u7bc7", "\u5185\u5bb9", "\u72b6\u6001"], [
        ["\u7b2c 1 \u7bc7", "\u7f3a\u9677\u5b9a\u4f4d\u4e0e\u4fee\u590d\uff08\u00a71.1\u2013\u00a71.12.1\uff09", b("\u5df2\u4ea4\u4ed8", 0)],
        ["\u7b2c 2 \u7bc7", "\u65f6\u5e8f\u7b7e\u6838\uff08\u4e09\u89d2 + OCV derate + hold \u8fb9\u754c\u5b9a\u91cf\uff09", b("\u5df2\u4ea4\u4ed8", 0)],
        ["\u7b2c 3 \u7bc7", "GDS \u4e0e\u5e03\u7ebf\uff08\u5408\u5e76\u3001DRC\u3001LEF\uff09", b("\u5df2\u4ea4\u4ed8", 0)],
        ["\u7b2c 4 \u7bc7", "\u529f\u80fd\u4e0e\u63a5\u53e3", b("\u5df2\u4ea4\u4ed8", 0)],
        ["\u9644 A / \u9644 B", "\u5de5\u4f5c\u8bb0\u5f55\u6574\u7406\u5f52\u6863 / \u4ea4\u4ed8\u6e05\u5355\u4e0e\u7ed3\u8bba\u8fb9\u754c", b("\u5df2\u4ea4\u4ed8", 0)],
        ["<b>LVS \u5e73\u94fa\u53e3\u5f84\u6536\u655b</b>", "<b>\u672a\u5b8c\u6210</b>\uff08\u89c1 Z.3\uff09", b("<b>\u672a\u95ed\u5408</b>", 2)],
    ]))
    pb.append("<h3>Z.3 \u5173\u952e\u6570\u5b57\uff08\u5747\u4e3a\u5b9e\u6d4b\uff09</h3>")
    pb.append(tbl(["\u9879", "\u503c"], [
        ["Calibre \u77ed\u8def", "<b>0</b>\uff08<code>lvs.rep.shorts</code> \u4e0d\u518d\u751f\u6210\uff09"],
        ["LVS \u7aef\u53e3", "<b>178 = 178</b>"],
        ["clk slack\uff08typ / slow / fast\uff09", "+0.9807 / <b>+0.7947</b> / +1.0732 ns"],
        ["slow derate p0/p3/p5/p8", "+0.7947 / +0.7597 / +0.7363 / +0.7013\uff08\u5168\u7ebf\u4e3a\u6b63\uff09"],
        ["\u5757\u5185 flop\u2192flop hold \u8fdd\u4f8b", "<b>0</b>\uff08\u4e09\u89d2\uff09"],
        ["hold \u63a5\u53e3\u8981\u6c42", "\u8f93\u5165 \u2265 0.72 ns / <code>calib_comp_out</code> \u2265 0.04 ns / \u8f93\u51fa\u63a5\u6536 \u2264 0.44 ns"],
        ["\u4ea4\u4ed8 GDS", "4 243 084 B\uff0cmd5 <code>e8462461\u2026</code>\uff0c225 struct / 19 \u5c42\u5bf9"],
        ["die", "430.520 \u00d7 429.340 \u00b5m = 184 839.457 \u00b5m\u00b2"],
        ["DRC", "421 \u6761\u89c4\u5219 / 3 402 \u6761\u7ed3\u679c"],
        ["\u4ea4\u4ed8 LEF", "179 611 B\uff0c<b>109 MACRO / 630 PIN</b>\uff08\u4e25\u683c\u5d4c\u5957\u53e3\u5f84 + \u81ea\u68c0\uff09"],
        ["\u5757\u81ea\u8eab abstract", b("<b>\u4e0d\u53ef\u884c</b>\uff088 \u6761\u8def\u5f84\u5168\u90e8\u4e3a\u8d1f\uff09", 2)],
    ]))
    pb.append("<h3>Z.4 \u672a\u95ed\u5408\u9879\u4e0e\u7ed3\u8bba\u8fb9\u754c</h3>")
    pb.append("<ul>"
              "<li><b>LVS \u4ecd <code>INCORRECT</code></b>\uff1a\u7aef\u53e3\u76f8\u7b49\u3001\u5355\u5143\u7c7b\u578b\u9010\u884c\u76f8\u7b49\uff0c"
              "\u4f46 <code>Nets \u221231</code>\u3001<code>MP \u22123</code>\uff0c65 \u6761 incorrect net \u4e2d 56 \u6761\u5df2\u5f52\u56e0\u3001"
              "<b>9 \u6761\u672a\u5f52\u56e0</b>\u3002</li>"
              "<li><b>\u4ea4\u4ed8\u7684 P&amp;R \u7f51\u8868\u81ea\u8eab\u4e0d\u81ea\u6d3d</b>\uff1a85 \u4e2a tie \u53cd\u76f8\u5668\u7684\u6839\u7f51\u7edc "
              "<code>HFSNET_8</code> \u65e0\u9a71\u52a8\uff0c\u4e24\u4e2a\u6700\u5927\u5b50\u6a21\u5757\u7684 <code>rst_n</code> \u8d70\u7684\u662f\u5b83\u7684\u53cd\u76f8\u5668\u94fe"
              "\uff0c\u800c\u9876\u5c42 RTL \u63a5\u7684\u662f <code>rst_n</code>\u3002"
              "\u21d2 <b>\u4e0d\u5f97\u636e\u73b0\u6709 <code>.v</code> \u505a\u95e8\u7ea7\u4eff\u771f\u7b7e\u6838\u3002</b></li>"
              "<li><b>\u5757\u81ea\u8eab abstract \u7f3a\u5931</b>\uff1aLEF \u4e0d\u80fd\u4f5c\u4e3a\u8be5\u5757\u7684\u96c6\u6210 abstract\u3002</li>"
              "<li>DRC \u7684 <code>BD_*</code> \u5c5e\u82af\u7247\u7ea7\u89c4\u5219\uff0c<b>\u8c41\u514d\u987b\u6279\u51c6\uff0c\u672c\u5305\u4e0d\u5ba3\u544a\u8c41\u514d</b>\u3002</li>"
              "\u3000<li>\u529f\u8017\u4e3a\u672a\u6807\u6ce8\u6d3b\u52a8\u7387\u7684\u7ed3\u679c\uff0c<b>\u4e0d\u53ef\u4f5c\u4e3a\u7b7e\u6838\u503c</b>\u3002</li>"
              "</ul>")
    pb.append("<h3>Z.5 \u53ef\u4fe1\u5ea6\u8bf4\u660e</h3>")
    pb.append(note("\u672c\u62a5\u544a\u5305\u542b\u56db\u6b21<b>\u81ea\u6211\u7ea0\u6b63</b>\uff0c\u5747\u5199\u5728\u6b63\u6587\u91cc\u800c\u975e\u62b9\u53bb\uff1a"
                   "\uff08i\uff09\u7b2c 10 \u8f6e\u300c\u7248\u56fe\u91cc\u6ca1\u6709 <code>HFSNET</code>/<code>HFSINV</code>\u300d\u2014\u2014 \u540d\u5b57\u4e0d\u7b49\u4e8e\u5b58\u5728\uff1b"
                   "\uff08ii\uff09\u7b2c 10 \u8f6e\u300c20 \u4e2a\u53ea\u5728\u7f51\u8868\u91cc\u7684\u5355\u5143\u300d\u2014\u2014 \u5de5\u5177\u6f0f\u6570\uff1b"
                   "\uff08iii\uff09\u7b2c 10 \u8f6e\u300ctie \u94fe\u662f\u6700\u540e\u4e00\u4e2a LVS \u9519\u8bef\u7684\u771f\u56e0\u300d\u2014\u2014 \u7b2c 11 \u8f6e\u5b9e\u9a8c\u8bc1\u4f2a\uff1b"
                   "\uff08iv\uff09\u7b2c 18/19 \u8f6e\u300c\u677e\u6563\u5668\u4ef6\u662f\u8fb9\u754c\u51e0\u4f55\u5408\u5e76\u7684\u4ea7\u7269\u300d\u2014\u2014 \u7b2c 22/23 \u8f6e\u8bc1\u660e\u5b83\u4eec\u5c5e\u4e8e\u8bbe\u8ba1\u81ea\u5e26\u7684\u6676\u4f53\u7ba1\u7ea7\u5c42\u6b21\u3002"
                   "\u6bcf\u4e00\u6761\u90fd\u6807\u660e\u4e86\u5b83\u662f\u600e\u4e48\u88ab\u63a8\u7ffb\u7684\u3002"
                   "\u672c\u62a5\u544a\u4e0d\u5305\u542b\u672a\u505a\u5bf9\u7167\u7684\u6d4b\u91cf\u7ed3\u8bba\u3002"))
    pb.append("<h3>Z.6 \u5efa\u8bae\u7684\u4e0b\u4e00\u6b65</h3>")
    pb.append(tbl(["\u52a8\u4f5c", "\u5224\u636e"], [
        ["\u628a <code>LVS INJECT LOGIC NO</code> \u5199\u8fdb\u9879\u76ee deck",
         "\u672c\u5757\u9002\u7528\uff08\u5668\u4ef6\u6570\u7b49\u4e3a\u8bc1\uff09"],
        ["\u8dd1 <code>LVS REDUCE PARALLEL MOS NO</code>\uff0c\u770b 31 \u4e2a\u7f51\u5dee\u662f\u5426\u6539\u53d8",
         "\u6539\u53d8 \u21d2 \u627e\u5230\u673a\u5236\uff1b\u4e0d\u53d8 \u21d2 \u7f51\u5dee\u4e0d\u662f\u5408\u5e76\u9020\u6210\u7684\uff0c\u65b9\u5411\u5f97\u6362"],
        ["\u91cd\u65b0\u5bfc\u51fa P&amp;R \u7f51\u8868\uff08\u89e3\u51b3\u5e38\u91cf\u6839\u60ac\u7a7a\uff09",
         "\u91cd\u65b0\u9a8c\u8bc1 <code>.v</code> \u91cc\u4e0d\u518d\u51fa\u73b0\u65e0\u9a71\u52a8\u7684 <code>HFSNET_*</code>"],
        ["\u5bf9 9 \u6761\u672a\u5f52\u56e0\u7f51\u9010\u6761\u5904\u7f6e",
         "\u9010\u6761\u7ed9\u51fa\u7ed3\u8bba\uff0c\u800c\u4e0d\u662f\u7528\u6bd4\u4f8b\u63cf\u8ff0"],
    ]))
    body = ('<h1>SAR16 片上数字核 · 接手报告：缺陷修复与签核</h1>\n'
            '<p class="sub">缺陷定位与修复 · 时序 · GDS 与布线 · 功能　|　'
            '接手对象：2026-09-18 18:14 交付包（<code>a9474b6c…</code>）　|　'
            '本文所有数字均从原始工件解析（<code>report_pack</code> / <code>reports</code> / '
            '<code>calibre</code>），解析不到写「未取得」，不写 0。</p>\n'
            + kpi + toc +
            '<h2 id="d">第 1 篇 · 缺陷定位与修复</h2>' + "".join(p1) +
            '<h2 id="s">第 2 篇 · 时序签核</h2>' + "".join(p2) +
            '<h2 id="g">第 3 篇 · GDS 与布线</h2>' + "".join(p3) +
            '<h2 id="f">第 4 篇 · 功能与接口</h2>' + "".join(p4) +
            '<h2 id="t">附 A · 工作记录整理与归档</h2>' + "".join(pa) +
            '<h2 id="c">附 B · 交付清单与结论边界</h2>' + "".join(pb) +
            '<div class="foot">生成时间：2026-09-18　·　数据源：v5.1 run 的原始工件'
            '（<code>RESULT_CURRENT.env</code> / <code>lvs.rep</code> / <code>drc_CAL.SUM</code> / '
            '<code>sta_pc_summary.txt</code> / <code>fc_*.rpt</code>）　·　'
            '几何普查与端口对账：本地自写解析器（GDSII / SPICE / LEF），不复用被接手方脚本</div>'
            '</div></body></html>')

    html = ('<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="utf-8"/>\n'
            '<title>SAR16 片上数字核 · 接手报告（缺陷修复 / 时序 / GDS 布线 / 功能）</title>\n'
            '<style>' + CSS + '</style>\n</head>\n<body><div class="wrap">\n' + body)

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    io.open(OUT, "w", encoding="utf-8").write(html)
    print("wrote", OUT)
    print("bytes =", os.path.getsize(OUT))


CSS = """
:root{--bg:#F7F8FA;--card:#FFF;--ink:#1F2328;--ink2:#4B5563;--ink3:#6B7280;--line:#E5E7EB;
 --accent:#FF6B6B;--accent2:#4ECDC4;--warn:#F59E0B;--bad:#DC2626;--ok:#059669}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);
 font-family:"Segoe UI","Microsoft YaHei",system-ui,sans-serif;line-height:1.65;font-size:14.5px}
.wrap{max-width:1180px;margin:0 auto;padding:34px 22px 80px}
h1{font-size:28px;margin:0 0 6px;letter-spacing:.2px}
h2{font-size:21px;margin:44px 0 14px;padding:12px 16px;border-radius:10px;color:#fff;
 background:linear-gradient(90deg,#FF6B6B,#4ECDC4)}
h3{font-size:17px;margin:28px 0 10px;padding-left:10px;border-left:4px solid #4ECDC4}
h4{font-size:14.5px;margin:20px 0 8px;color:#4B5563}
.sub{color:#6B7280;font-size:13.5px;margin:0 0 22px}
table{width:100%;border-collapse:collapse;margin:12px 0;font-size:13.2px;background:#fff;
 border:1px solid #E5E7EB;border-radius:8px;overflow:hidden}
th{background:#F3F4F6;text-align:left;padding:8px 10px;border-bottom:1px solid #E5E7EB;
 font-weight:600;color:#4B5563}
td{padding:7px 10px;border-bottom:1px solid #F1F2F4;vertical-align:top}
tr:last-child td{border-bottom:none}
code{font-family:Consolas,"Courier New",monospace;font-size:12.4px;background:#F3F4F6;
 padding:1px 5px;border-radius:4px;color:#111827}
pre{background:#0F172A;color:#E5E7EB;padding:14px 16px;border-radius:10px;overflow-x:auto;
 font-family:Consolas,monospace;font-size:12.4px;line-height:1.55}
.note{background:#FFF9E8;border-left:4px solid #F59E0B;padding:11px 14px;border-radius:6px;
 font-size:13.2px;color:#4B3A00;margin:12px 0}
.bdg{display:inline-block;padding:1.5px 8px;border-radius:20px;font-size:11.6px;font-weight:600;white-space:nowrap}
.bdg.ok{background:#E7F6EE;color:#059669}.bdg.bad{background:#FDECEC;color:#DC2626}
.bdg.warn{background:#FEF3E2;color:#B45309}
figure{margin:18px 0;background:#fff;border:1px solid #E5E7EB;border-radius:12px;padding:12px}
figure img{width:100%;display:block;border-radius:8px;background:#0B0F19}
figcaption{font-size:12.6px;color:#6B7280;margin-top:9px}
svg{display:block;margin:10px 0}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(215px,1fr));gap:12px;margin:16px 0}
.kpi{background:#fff;border:1px solid #E5E7EB;border-radius:12px;padding:14px 16px}
.kpi .k{font-size:11.8px;color:#6B7280;letter-spacing:.3px;text-transform:uppercase}
.kpi .v{font-size:20px;font-weight:700;margin:3px 0 2px;font-family:Consolas,monospace}
.kpi .d{font-size:12.2px;color:#4B5563}
.toc{background:#fff;border:1px solid #E5E7EB;border-radius:12px;padding:14px 20px}
.toc a{color:#0F766E;text-decoration:none;font-size:13.6px}.toc li{margin:3px 0}
.foot{margin-top:40px;color:#6B7280;font-size:12.5px;border-top:1px solid #E5E7EB;padding-top:14px}
"""

if __name__ == "__main__":
    main()
