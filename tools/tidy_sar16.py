#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SAR16 后端工作区整理器 —— 归档 vs 删除，先干跑。

判定语义（沿用本项目第九轮定下的规矩，不另发明）：
  * 工作记录 / 证据 / 被取代但不可再生的交付件  -> 归档（移动，可回退）
  * 可从 PDK 或从本轮 run 重新生成的大文件        -> 删除（记 path+bytes+md5 便于审计）
  * 交付件 / 源码 / 当前报告 / 已封存的审计包     -> 保留不动

用法：
  python tidy_sar16.py --dry      # 只打印计划
  python tidy_sar16.py --run      # 执行，并写 manifest / MOVE_LOG / README / RESTORE
"""
import hashlib
import json
import os
import shutil
import sys
import time

B = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar"
W = os.path.join(B, "02_仿真验证", "sar16_digi_v4_paper_aligned")
REC = os.path.join(B, "04_工作记录")
ARCH = os.path.join(B, "05_归档", "SAR16后端_20260918")

# ---- 归档：被取代的交付包 ------------------------------------------------
ARCHIVE_DIRS = [
    (os.path.join(W, "delivery"),          "01_被取代的交付包/delivery"),
    (os.path.join(W, "delivery_v41"),      "01_被取代的交付包/delivery_v41"),
    (os.path.join(W, "delivery_v42"),      "01_被取代的交付包/delivery_v42"),
    (os.path.join(W, "delivery_round3"),   "01_被取代的交付包/delivery_round3"),
    (os.path.join(W, "backend", "gds_images"),     "03_被取代的源码与图像/gds_images"),
    (os.path.join(W, "backend", "gds_images_v43"), "03_被取代的源码与图像/gds_images_v43"),
    (os.path.join(W, "backend", "scripts", "probes"),     "02_探针与一次性脚本/probes"),
    (os.path.join(W, "backend", "scripts", "remote_v42"), "02_探针与一次性脚本/remote_v42"),
    (os.path.join(W, "backend", "analysis", "raw", "remote"),
     "05_远端原始抓取/remote"),
]

# ---- 归档：一次性探针脚本（backend/scripts 顶层）------------------------
ARCHIVE_GLOBS = [
    ("probe_", "02_探针与一次性脚本"), ("diag_lvs", "02_探针与一次性脚本"),
    ("pg_probe", "02_探针与一次性脚本"), ("pg_build_probe", "02_探针与一次性脚本"),
    ("pg_syntax_probe", "02_探针与一次性脚本"), ("port_census", "02_探针与一次性脚本"),
    ("patch_pnr_and_lvs", "02_探针与一次性脚本"), ("patch_round3", "02_探针与一次性脚本"),
    ("gaps_v43", "02_探针与一次性脚本"), ("fix_precision_and_run", "02_探针与一次性脚本"),
    ("fix_repro_authority", "02_探针与一次性脚本"), ("_fix_report", "02_探针与一次性脚本"),
    ("_rechist", "02_探针与一次性脚本"), ("calibre_chain", "02_探针与一次性脚本"),
    ("final_calibre", "02_探针与一次性脚本"), ("rerun_all_fixed", "02_探针与一次性脚本"),
    ("summarize_open_issues", "02_探针与一次性脚本"),
    ("run_sta_only", "02_探针与一次性脚本"), ("run_pwr_pt", "02_探针与一次性脚本"),
    ("run_flow_paper", "02_探针与一次性脚本"), ("run_backend_paper_core", "02_探针与一次性脚本"),
    ("probe_fix_pins_pg", "02_探针与一次性脚本"),
    ("tb/tb_sar16_v4.sv", "03_被取代的源码与图像"),
]

# ---- 归档：被取代的历史工作报告 -----------------------------------------
ARCHIVE_RECORDS = [
    "SAR16_v4.1_遗留问题逐项解决_20260918.md",
    "SAR16_v4.2_第二轮改进_时序闭合与复现权威性_20260918.md",
    "SAR16_v4.2_时序签核报告_20260918.md",
    "SAR16_v4.2_完整工作记录报告.html",
    "SAR16_v4paper_功能报告_20260917.md",
    "SAR16_v4paper_时序报告_20260917.md",
    "SAR16_v4paper_布线报告_20260917.md",
    "SAR16_v4paper_最终交付_GDS与复现_20260918.md",
    "SAR16_v4完整数字后端流程_20260917.md",
    "SAR16_v4论文对齐实现与验证记录_20260917.md",
    "SAR16_v4独立复审_论文功能一致性_20260917.md",
    "SAR16_片内片外边界与面积对齐_20260917.md",
    "SAR16_SRM_LUT面积归因与优化_20260917.md",
    "SAR16_最终结果汇总_20260917.md",
    "SAR16数字流程对照评估_20260917.md",
    "SAR16_GDS图像分析报告.html",
]

# ---- 删除：可再生成 / 属 PDK 的大文件 -----------------------------------
DELETE = [
    (os.path.join(W, "backend", "analysis", "raw", "remote", "lib_slow.lib"),
     "PDK 标准单元库副本（11 MB，属厂商数据，不应留在工作区，可从 $K 重新取）"),
    (os.path.join(W, "backend", "analysis", "raw", "remote", "lib_typical.lib"),
     "PDK 标准单元库副本（11 MB，同上）"),
]


def human(n):
    for u in ("B", "K", "M", "G"):
        if n < 1024:
            return "%.0f%s" % (n, u)
        n /= 1024.0
    return "%.1fT" % n


def walk(p):
    for dp, dn, fn in os.walk(p):
        for f in fn:
            yield os.path.join(dp, f)


def size_of(p):
    if os.path.isfile(p):
        return os.path.getsize(p)
    return sum(os.path.getsize(x) for x in walk(p))


def count_of(p):
    if os.path.isfile(p):
        return 1
    return sum(1 for _ in walk(p))


def md5(p):
    h = hashlib.md5()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def build_plan():
    moves, deletes, keeps = [], [], []
    for src, dstrel in ARCHIVE_DIRS:
        if os.path.exists(src):
            moves.append((src, os.path.join(ARCH, dstrel)))
    sdir = os.path.join(W, "backend", "scripts")
    for pre, dstrel in ARCHIVE_GLOBS:
        p = os.path.join(sdir, pre) if "/" not in pre else os.path.join(W, pre)
        if os.path.exists(p):
            moves.append((p, os.path.join(ARCH, dstrel, os.path.basename(p))))
    for name in ARCHIVE_RECORDS:
        p = os.path.join(REC, name)
        if os.path.exists(p):
            moves.append((p, os.path.join(ARCH, "04_历史工作报告", name)))
    for p, why in DELETE:
        if os.path.exists(p):
            deletes.append((p, why))
    return moves, deletes


def main():
    run = "--run" in sys.argv
    moves, deletes = build_plan()

    mv_files = sum(count_of(s) for s, _ in moves)
    mv_bytes = sum(size_of(s) for s, _ in moves)
    dl_files = len(deletes)
    dl_bytes = sum(os.path.getsize(p) for p, _ in deletes)

    print("=== 归档 (%d 项 -> %d 文件, %s) ===" % (len(moves), mv_files, human(mv_bytes)))
    for s, d in moves:
        print("   %-58s -> %s   [%s, %d files]"
              % (os.path.relpath(s, B), os.path.relpath(d, ARCH),
                 human(size_of(s)), count_of(s)))
    print("\n=== 删除 (%d 文件, %s) ===" % (dl_files, human(dl_bytes)))
    for p, why in deletes:
        print("   %-58s %s   %s" % (os.path.relpath(p, B), human(os.path.getsize(p)), why))

    keep_files = 0
    keep_bytes = 0
    for dp, dn, fn in os.walk(B):
        dn[:] = [d for d in dn if d != "__pycache__"]
        for f in fn:
            p = os.path.join(dp, f)
            try:
                keep_bytes += os.path.getsize(p)
            except OSError:
                continue
            keep_files += 1
    print("\n=== 现状 ===")
    print("   归档前：%d 文件 / %s" % (keep_files, human(keep_bytes)))
    print("   整理后预计：%d 文件 / %s" % (keep_files - dl_files, human(keep_bytes - dl_bytes)))

    man = dict(when=time.strftime("%F %T"), archive_root=ARCH,
               summary=dict(archive_items=len(moves), archive_files=mv_files,
                            archive_bytes=mv_bytes, delete_files=dl_files,
                            delete_bytes=dl_bytes,
                            keep_files=keep_files - dl_files,
                            keep_bytes=keep_bytes - dl_bytes),
               moves=[dict(src=s, dst=d, files=count_of(s), bytes=size_of(s)) for s, d in moves],
               deletes=[dict(path=p, bytes=os.path.getsize(p), md5=md5(p), reason=w)
                        for p, w in deletes])
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           "cleanup_manifest.json"), "w", encoding="utf-8") as f:
        json.dump(man, f, ensure_ascii=False, indent=2)

    if not run:
        print("\nDRY RUN —— 未做任何改动。加 --run 执行。")
        return 0

    print("\n=== 执行 ===")
    log = []
    os.makedirs(ARCH, exist_ok=True)
    # deletes FIRST: two of them live inside a directory that is about to move
    for p, why in deletes:
        os.remove(p)
        log.append((os.path.relpath(p, B), "", "deleted"))
        print("   deleted %s" % os.path.relpath(p, B))
    for s, d in moves:
        os.makedirs(os.path.dirname(d), exist_ok=True)
        if os.path.exists(d):
            print("   SKIP(exists) %s" % d)
            continue
        shutil.move(s, d)
        log.append((os.path.relpath(s, B), os.path.relpath(d, B), "moved"))
        print("   moved  %s" % os.path.relpath(s, B))

    with open(os.path.join(ARCH, "MOVE_LOG.csv"), "w", encoding="utf-8") as f:
        f.write("src,dst,action\n")
        for a, c, act in log:
            f.write('"%s","%s",%s\n' % (a, c, act))
    print("\nMOVE_LOG.csv written (%d rows)" % len(log))

    # ---- 归档索引 + 一键回退 -------------------------------------------
    idx = ["# SAR16 后端工作区整理索引（2026-09-18）", "",
           "整理人：接手方（DSH）。判定语义：**工作记录/证据/不可再生的被取代交付件 -> 归档；"
           "可从 PDK 或本轮 run 重新生成的大文件 -> 删除；交付件/源码/当前报告/已封存审计包 -> 保留**。", "",
           "## 归档内容", "",
           "| 分类 | 条目 | 文件 | 字节 |", "|---|---|---|---|"]
    by_cat = {}
    for s, d in moves:
        cat = os.path.relpath(d, ARCH).split(os.sep)[0]
        e = by_cat.setdefault(cat, [0, 0, 0])
        e[0] += 1
        e[1] += count_of(d)
        e[2] += size_of(d)
    for cat in sorted(by_cat):
        n, f, by = by_cat[cat]
        idx.append("| `%s` | %d | %d | %s |" % (cat, n, f, human(by)))
    idx += ["", "## 已删除（不可回退，清单见 `cleanup_manifest.json`）", ""]
    for p, why in deletes:
        idx.append("- `%s` —— %s" % (os.path.relpath(p, B), why))
    idx += ["", "## 回退", "",
            "```bash", "python restore_archive.py --dry    # 先看会动什么",
            "python restore_archive.py --run    # 执行回退", "```", ""]
    with open(os.path.join(ARCH, "README_ARCHIVE_INDEX.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(idx))

    pairs = [(os.path.relpath(s, B), os.path.relpath(d, B)) for s, d in moves]
    with open(os.path.join(ARCH, "restore_archive.py"), "w", encoding="utf-8") as f:
        f.write("#!/usr/bin/env python3\n# -*- coding: utf-8 -*-\n"
                '"""Move the archived items back to where they came from."""\n'
                "import os, shutil, sys\n"
                "B = r'%s'\nPAIRS = %r\n"
                "run = '--run' in sys.argv\n"
                "n = 0\n"
                "for src, dst in PAIRS:\n"
                "    s = os.path.join(B, dst); d = os.path.join(B, src)\n"
                "    if not os.path.exists(s):\n"
                "        print('MISSING', s); continue\n"
                "    print(('restore ' if run else 'would restore ') + src)\n"
                "    if run:\n"
                "        os.makedirs(os.path.dirname(d), exist_ok=True)\n"
                "        if os.path.exists(d): print('  EXISTS, skipped'); continue\n"
                "        shutil.move(s, d); n += 1\n"
                "print('restored = %%d' %% n if run else 'dry run only')\n"
                % (B, pairs))

    # ---- 引用完整性：保留文档里还有没有指向归档区的路径？ ----------------
    print("\n=== 引用完整性核对（保留文档 -> 归档区）===")
    moved_names = []
    for s, d in moves:
        moved_names.append(os.path.relpath(s, B).replace("\\", "/"))
        moved_names.append(os.path.basename(s))
    hits = []
    for dp, dn, fn in os.walk(B):
        if os.path.abspath(dp).startswith(os.path.abspath(ARCH)):
            continue
        dn[:] = [x for x in dn if x not in ("__pycache__",)]
        for f in fn:
            if not f.lower().endswith((".md", ".html", ".py", ".sh", ".tcl", ".json", ".csv")):
                continue
            p = os.path.join(dp, f)
            try:
                t = open(p, encoding="utf-8", errors="replace").read()
            except OSError:
                continue
            for nm in moved_names:
                if len(nm) > 6 and nm in t.replace("\\", "/"):
                    hits.append((os.path.relpath(p, B), nm))
                    break
    if hits:
        for a, nm in hits[:20]:
            print("   REF  %s  ->  %s" % (a, nm))
        print("   total %d referencing document(s)" % len(hits))
    else:
        print("   0 referencing documents")
    with open(os.path.join(ARCH, "reference_check.json"), "w", encoding="utf-8") as f:
        json.dump([dict(doc=a, ref=nm) for a, nm in hits], f, ensure_ascii=False, indent=2)
    return 0


if __name__ == "__main__":
    sys.exit(main())
