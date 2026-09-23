#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Precise reference check: does any KEPT document still point at an archived path?

The previous pass matched bare basenames ("delivery"), which is noise: many
unrelated files contain that word.  This pass only counts a hit when the
FULL relative path (or the SAR16-work-dir-qualified path) appears.
"""
import json
import os

B = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar"
ARCH = os.path.join(B, "05_归档", "SAR16后端_20260918")
man = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                  "cleanup_manifest.json"), encoding="utf-8"))

targets = []
for m in man["moves"]:
    rel = os.path.relpath(m["src"], B).replace("\\", "/")
    targets.append((rel, os.path.basename(rel), m))

EXT = (".md", ".html", ".py", ".sh", ".tcl", ".json", ".csv", ".env", ".txt")
hits = []
scanned = 0
for dp, dn, fn in os.walk(B):
    if os.path.abspath(dp).startswith(os.path.abspath(ARCH)):
        continue
    dn[:] = [d for d in dn if d != "__pycache__"]
    for f in fn:
        if not f.lower().endswith(EXT):
            continue
        p = os.path.join(dp, f)
        try:
            t = open(p, encoding="utf-8", errors="replace").read().replace("\\", "/")
        except OSError:
            continue
        scanned += 1
        for rel, base, m in targets:
            if rel in t:
                hits.append((os.path.relpath(p, B), rel, "full-path"))
            elif base.endswith((".md", ".html", ".sv", ".tcl", ".py", ".sh")) and base in t:
                hits.append((os.path.relpath(p, B), rel, "filename:" + base))

print("scanned kept documents: %d" % scanned)
print("archived items        : %d" % len(targets))
print()
if hits:
    seen = set()
    for doc, rel, kind in hits:
        k = (doc, rel)
        if k in seen:
            continue
        seen.add(k)
        print("  %-70s -> %s   [%s]" % (doc[:70], rel, kind))
    print("\ntotal precise hits: %d" % len(seen))
else:
    print("no kept document references an archived path  -> CLEAN")

json.dump([dict(doc=d, ref=r, kind=k) for d, r, k in hits],
          open(os.path.join(ARCH, "reference_check_precise.json"), "w", encoding="utf-8"),
          ensure_ascii=False, indent=2)
