import os
import time

ROOT = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar"
TMPDIRS = {"__pycache__", ".pytest_cache", ".ipynb_checkpoints"}


def human(n):
    for u in ("B", "K", "M", "G"):
        if n < 1024:
            return "%.0f%s" % (n, u)
        n /= 1024.0
    return "%.1fT" % n


rows = []
for dirpath, dirnames, filenames in os.walk(ROOT):
    dirnames[:] = [d for d in dirnames if d not in TMPDIRS]
    rel = os.path.relpath(dirpath, ROOT)
    depth = 0 if rel == "." else rel.count(os.sep) + 1
    for f in filenames:
        p = os.path.join(dirpath, f)
        try:
            st = os.stat(p)
        except OSError:
            continue
        rows.append((rel, f, st.st_size, st.st_mtime))

rows.sort(key=lambda r: (r[0], r[1]))
print("total files: %d   total bytes: %s" % (len(rows), human(sum(r[2] for r in rows))))
print()
by_dir = {}
for rel, f, sz, mt in rows:
    d = by_dir.setdefault(rel, [0, 0])
    d[0] += 1
    d[1] += sz
print("%-58s %6s %10s" % ("directory (relative)", "files", "bytes"))
for rel in sorted(by_dir):
    print("%-58s %6d %10s" % (rel, by_dir[rel][0], human(by_dir[rel][1])))

print()
print("=== top 30 largest files ===")
for rel, f, sz, mt in sorted(rows, key=lambda r: -r[2])[:30]:
    print("  %10s  %s  %s\\%s" % (human(sz), time.strftime("%m-%d %H:%M", time.localtime(mt)), rel, f))

print()
print("=== the backend work tree, file by file ===")
for rel, f, sz, mt in rows:
    if rel.startswith("02_仿真验证"):
        print("  %10s  %s  %s\\%s" % (human(sz), time.strftime("%m-%d %H:%M", time.localtime(mt)), rel, f))
