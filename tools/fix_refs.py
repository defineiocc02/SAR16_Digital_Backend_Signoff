#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Repair the three LIVE references that the archive move would otherwise break.

Kept out of scope on purpose (recorded, not modified):
  * .workbuddy/memory/*  -- the agent's own memory of what it did; it is a record
    of a point in time, not a live pointer.
  * _audit/TASK-000R_20260918/*  -- a sealed, hashed evidence freeze. Editing it
    would invalidate its seal.
"""
import hashlib
import io
import os
import shutil
import time

B = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar"
W = os.path.join(B, "02_仿真验证", "sar16_digi_v4_paper_aligned")
ARCHREL = "05_归档/SAR16后端_20260918"

EDITS = [
    (os.path.join(W, "tb", "run_tb.sh"),
     [("tb_sar16_v4.sv",
       "$P/tb_sar16_v4.sv")]),
    (os.path.join(W, "README.md"), None),
    (os.path.join(W, "backend", "scripts", "make_gds_report.py"), None),
]

NOTE = ("\n<!-- 2026-09-18 接手方整理：以下路径已归档到 %s/03_被取代的源码与图像/ 与 "
        "%s/04_历史工作报告/，此处仅做路径更新，内容未改。 -->\n" % (ARCHREL, ARCHREL))


def md5(p):
    return hashlib.md5(open(p, "rb").read()).hexdigest()


def main():
    bak = os.path.join(B, "_audit", "handover_tidy_backup_%s" % time.strftime("%Y%m%d_%H%M%S"))
    os.makedirs(bak, exist_ok=True)
    print("backup dir: %s" % bak)
    for p, _ in EDITS:
        if os.path.exists(p):
            shutil.copy2(p, os.path.join(bak, os.path.basename(p)))
            print("  backed up %s (%s)" % (os.path.relpath(p, B), md5(p)[:12]))

    # 1) run_tb.sh: point the superseded testbench at the archive
    p = os.path.join(W, "tb", "run_tb.sh")
    if os.path.exists(p):
        t = io.open(p, encoding="utf-8", errors="replace").read()
        n = t.count("tb_sar16_v4.sv")
        t2 = t.replace("tb_sar16_v4.sv",
                       "../../../" + ARCHREL + "/03_被取代的源码与图像/tb_sar16_v4.sv")
        io.open(p, "w", encoding="utf-8").write(t2 + NOTE)
        print("  run_tb.sh : %d reference(s) repointed" % n)

    # 2) README.md and 3) make_gds_report.py: append a mapping note
    for p in (os.path.join(W, "README.md"),
              os.path.join(W, "backend", "scripts", "make_gds_report.py")):
        if os.path.exists(p):
            t = io.open(p, encoding="utf-8", errors="replace").read()
            io.open(p, "w", encoding="utf-8").write(t + NOTE)
            print("  %s : archive notice appended" % os.path.relpath(p, B))

    # reference-update record, inside the archive
    ARCH = os.path.join(B, "05_归档", "SAR16后端_20260918")
    io.open(os.path.join(ARCH, "REFERENCE_UPDATE.md"), "w", encoding="utf-8").write(
        "# 归档后的引用处理（2026-09-18）\n\n"
        "## 已修复的活引用（3 处）\n\n"
        "| 文件 | 引用的归档物 | 处理 |\n|---|---|---|\n"
        "| `02_仿真验证/sar16_digi_v4_paper_aligned/tb/run_tb.sh` | `tb/tb_sar16_v4.sv` | "
        "路径改指 `05_归档/SAR16后端_20260918/03_被取代的源码与图像/tb_sar16_v4.sv` |\n"
        "| `…/sar16_digi_v4_paper_aligned/README.md` | `tb_sar16_v4.sv` + 历史报告 | 文末加归档告示 |\n"
        "| `…/backend/scripts/make_gds_report.py` | `SAR16_GDS图像分析报告.html` | 文末加归档告示 |\n\n"
        "改动前原件备份在 `_audit/handover_tidy_backup_*/`。\n\n"
        "## 有意未修改的引用（2 类）\n\n"
        "1. **`.workbuddy/memory/*.md`** —— 被接手方自己的记忆。它记录的是"
        "「当时看到了什么」，不是活指针；改它等于篡改记录。\n"
        "2. **`_audit/TASK-000R_20260918/*`** —— 已封印（sealed）的审计包，"
        "带 SHA-256 封印。它描述的是**整理之前**的树；一旦修改，封印即失效。\n\n"
        "> 因此：这两类里的路径在整理后指向不存在的位置，**这是预期而非漏改**。\n"
        "> 需要复原时用本目录的 `restore_archive.py`。\n")
    print("\nREFERENCE_UPDATE.md written")


if __name__ == "__main__":
    main()
