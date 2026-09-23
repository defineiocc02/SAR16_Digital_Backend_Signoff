import os
import time

B = r"D:\<vault>\Document\Obsidian\日常\10_项目区\2025_16bit5Msar"
W = os.path.join(B, "02_仿真验证", "sar16_digi_v4_paper_aligned")


def human(n):
    for u in ("B", "K", "M", "G"):
        if n < 1024:
            return "%.0f%s" % (n, u)
        n /= 1024.0
    return "%.1fT" % n


def show(title, path, limit=40):
    print("\n########## %s ##########" % title)
    print("path: %s" % path)
    if not os.path.exists(path):
        print("  (absent)")
        return
    tot = n = 0
    for dp, dn, fn in os.walk(path):
        for f in fn:
            p = os.path.join(dp, f)
            try:
                st = os.stat(p)
            except OSError:
                continue
            tot += st.st_size
            n += 1
    print("  files=%d  bytes=%s" % (n, human(tot)))
    items = []
    for dp, dn, fn in os.walk(path):
        for f in fn:
            p = os.path.join(dp, f)
            try:
                st = os.stat(p)
            except OSError:
                continue
            items.append((st.st_size, time.strftime("%m-%d %H:%M", time.localtime(st.st_mtime)),
                          os.path.relpath(p, path)))
    items.sort(key=lambda x: -x[0])
    for sz, mt, rel in items[:limit]:
        print("    %9s  %s  %s" % (human(sz), mt, rel))
    if len(items) > limit:
        print("    … %d more" % (len(items) - limit))


show("backend/analysis (whole)", os.path.join(W, "backend", "analysis"))
show("backend/scripts/probes", os.path.join(W, "backend", "scripts", "probes"), 15)
show("backend/scripts/remote_v42", os.path.join(W, "backend", "scripts", "remote_v42"), 15)
show("_audit", os.path.join(B, "_audit"), 25)
show("00_项目总览", os.path.join(B, "00_项目总览"), 15)
show("03_IP规格说明书", os.path.join(B, "03_IP规格说明书"), 15)
show("05_归档", os.path.join(B, "05_归档"), 15)

print("\n\n########## backend/scripts top level ##########")
sd = os.path.join(W, "backend", "scripts")
if os.path.isdir(sd):
    for f in sorted(os.listdir(sd)):
        p = os.path.join(sd, f)
        if os.path.isfile(p):
            print("    %9s  %s" % (human(os.path.getsize(p)), f))
        else:
            n = sum(len(fn) for _, _, fn in os.walk(p))
            print("    %9s  %s/  (%d files)" % (human(sum(os.path.getsize(os.path.join(dp, x))
                                                          for dp, _, fs in os.walk(p) for x in fs)), f, n))
