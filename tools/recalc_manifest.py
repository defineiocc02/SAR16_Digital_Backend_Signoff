#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Recompute the manifest's per-item sizes from what is actually in the archive.

The first manifest recorded sizes BEFORE the two PDK .lib files were deleted, so
the 'remote' category claimed 27 MB while the archive holds 4.2 MB.  Numbers in a
report must describe the tree as it is, not as it was planned.
"""
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))
B = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar"
man = json.load(open(os.path.join(HERE, "cleanup_manifest.json"), encoding="utf-8"))


def measure(p):
    if os.path.isfile(p):
        return 1, os.path.getsize(p)
    n = b = 0
    for dp, dn, fn in os.walk(p):
        for f in fn:
            try:
                b += os.path.getsize(os.path.join(dp, f))
            except OSError:
                continue
            n += 1
    return n, b


for m in man["moves"]:
    if os.path.exists(m["dst"]):
        m["files"], m["bytes"] = measure(m["dst"])
    else:
        m["files"] = m["bytes"] = 0

man["summary"]["archive_files"] = sum(m["files"] for m in man["moves"])
man["summary"]["archive_bytes"] = sum(m["bytes"] for m in man["moves"])
keep_n = keep_b = 0
for dp, dn, fn in os.walk(B):
    dn[:] = [d for d in dn if d != "__pycache__"]
    for f in fn:
        try:
            keep_b += os.path.getsize(os.path.join(dp, f))
        except OSError:
            continue
        keep_n += 1
man["summary"]["keep_files"] = keep_n
man["summary"]["keep_bytes"] = keep_b
man["recomputed_from_archive"] = True

json.dump(man, open(os.path.join(HERE, "cleanup_manifest.json"), "w", encoding="utf-8"),
          ensure_ascii=False, indent=2)
print("archive: %d items / %d files / %s"
      % (man["summary"]["archive_items"], man["summary"]["archive_files"],
         "{:,}".format(man["summary"]["archive_bytes"])))
print("delete : %d files / %s" % (man["summary"]["delete_files"],
                                  "{:,}".format(man["summary"]["delete_bytes"])))
print("keep   : %d files / %s" % (keep_n, "{:,}".format(keep_b)))
for m in man["moves"]:
    print("   %-58s %4d files  %10s" % (os.path.relpath(m["dst"], man["archive_root"]),
                                        m["files"], "{:,}".format(m["bytes"])))
