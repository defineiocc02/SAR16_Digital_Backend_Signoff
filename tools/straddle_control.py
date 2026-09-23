#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""CONTROL for the straddle test: is "2-3 instances' diffusion at one point" special?

Take random points inside placed cells and count how many instances' diffusion
polygons cover each.  If ordinary points show the same multiplicity, the flagged
points are NOT outliers and the earlier observation is a measurement artifact of
my placement transform -- not a mechanism.
"""
import os
import random
import struct
import sys
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import importlib.util

spec = importlib.util.spec_from_file_location("st", os.path.join(HERE, "straddle_test.py"))
# do not execute its __main__ body; re-implement the loader here instead

GDS = os.path.join(HERE, "..", "evidence", "rpt_v51", "sar_digi_paper_core_merged.gds")
S = 10000.0
AA = {10, 14}
GT = {30, 43}
REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x1A: "STRANS", 0x1C: "ANGLE"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}


def load(path):
    f = open(path, "rb")
    structs, cur, el = {}, None, None
    while True:
        h = f.read(4)
        if len(h) < 4:
            break
        rl, rt, rd = struct.unpack(">HBB", h)
        d = f.read(rl - 4) if rl >= 4 else b""
        n = REC.get(rt)
        if n == "BGNSTR":
            cur = {"name": None, "bbox": None, "shapes": [], "srefs": []}
        elif n == "STRNAME":
            cur["name"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            structs[cur["name"]] = cur
            cur = None
        elif rt in ELEM:
            el = {"kind": n, "layer": None, "xy": None, "sname": None,
                  "flip": False, "angle": 0.0}
        elif n == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", d[:2])[0]
        elif n == "XY" and el is not None:
            k = len(d) // 4
            el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
        elif n == "SNAME" and el is not None:
            el["sname"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "STRANS" and el is not None:
            el["flip"] = bool(struct.unpack(">H", d[:2])[0] & 0x8000)
        elif n == "ANGLE" and el is not None:
            try:
                el["angle"] = struct.unpack(">d", d[:8])[0]
            except Exception:
                el["angle"] = 0.0
        elif n == "ENDEL":
            if el is not None and cur is not None and el["xy"]:
                xs = el["xy"][0::2]; ys = el["xy"][1::2]
                bb = (min(xs), min(ys), max(xs), max(ys))
                if el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    b = cur["bbox"]
                    cur["bbox"] = bb if b is None else (min(b[0], bb[0]), min(b[1], bb[1]),
                                                        max(b[2], bb[2]), max(b[3], bb[3]))
                    cur["shapes"].append((el["layer"], bb))
                elif el["kind"] in ("SREF", "AREF"):
                    cur["srefs"].append((el["sname"], el["xy"][0], el["xy"][1],
                                         el["angle"], el["flip"]))
            el = None
    f.close()
    return structs


cells = load(GDS)
top = cells["sar_digi_paper_core"]


def real_master(frame):
    c = cells.get(frame)
    if not c:
        return None
    for nm, ox, oy, ang, flip in c["srefs"]:
        if nm in cells and (AA & set(l for l, _ in cells[nm]["shapes"])):
            return nm
    return None


def xform(px, py, ox, oy, ang, flip, w, h):
    a = round(ang / 90.0) * 90
    if a == 90:
        lx, ly = py, w - px
    elif a == 180:
        lx, ly = w - px, h - py
    elif a == 270:
        lx, ly = h - py, px
    else:
        lx, ly = px, py
    if flip:
        ly = h - ly
    return ox + lx, oy + ly


insts = []
for nm, ox, oy, ang, flip in top["srefs"]:
    if nm.startswith("$$"):
        continue
    rm = real_master(nm)
    if not rm:
        continue
    rc = cells[rm]
    w = rc["bbox"][2] - rc["bbox"][0]
    h = rc["bbox"][3] - rc["bbox"][1]
    polys = []
    for lay, bb in rc["shapes"]:
        if lay not in AA and lay not in GT:
            continue
        pts = [xform(c[0] - rc["bbox"][0], c[1] - rc["bbox"][1], ox, oy, ang, flip, w, h)
               for c in [(bb[0], bb[1]), (bb[2], bb[1]), (bb[2], bb[3]), (bb[0], bb[3])]]
        xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
        polys.append((lay, (min(xs), min(ys), max(xs), max(ys))))
    if polys:
        bxs = [p[1][0] for p in polys]; bys = [p[1][1] for p in polys]
        bxe = [p[1][2] for p in polys]; bye = [p[1][3] for p in polys]
        insts.append((nm, (min(bxs), min(bys), max(bxe), max(bye)), polys))

BIN = 40000
grid = defaultdict(list)
for i, (nm, ab, polys) in enumerate(insts):
    for gx in range(ab[0] // BIN, ab[2] // BIN + 1):
        for gy in range(ab[1] // BIN, ab[3] // BIN + 1):
            grid[(gx, gy)].append(i)

print("instances with device geometry: %d" % len(insts))


def multiplicity(x, y, pad=300):
    aa, gt = set(), set()
    for gx in (x // BIN, x // BIN + 1):
        for gy in (y // BIN, y // BIN + 1):
            for i in grid.get((gx, gy), []):
                nm, ab, polys = insts[i]
                if not (ab[0] - pad <= x <= ab[2] + pad and ab[1] - pad <= y <= ab[3] + pad):
                    continue
                for lay, bb in polys:
                    if bb[0] - pad <= x <= bb[2] + pad and bb[1] - pad <= y <= bb[3] + pad:
                        (aa if lay in AA else gt).add(i)
    return len(aa), len(gt)


random.seed(20260918)
hist_aa = Counter()
hist_gt = Counter()
n = 0
for nm, ab, polys in random.sample(insts, min(300, len(insts))):
    cx = (ab[0] + ab[2]) // 2
    cy = (ab[1] + ab[3]) // 2
    a, g = multiplicity(cx, cy)
    hist_aa[a] += 1
    hist_gt[g] += 1
    n += 1

print("\n=== CONTROL: %d random cell CENTRES ===" % n)
print("   #instances whose AA covers the point : %s" % dict(sorted(hist_aa.items())))
print("   #instances whose GT covers the point : %s" % dict(sorted(hist_gt.items())))

print("\n=== the 35 flagged points, same measurement ===")
import io, re
t = io.open(os.path.join(HERE, "..", "evidence", "rpt_v51", "lvs.rep"),
            encoding="utf-8", errors="replace").read()
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
flag = re.findall(r"^\s+\d+\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)", blk, re.M)
fh_aa = Counter()
fh_gt = Counter()
for inst, dev, xs, ys in flag:
    x = int(round(float(xs) * S)); y = int(round(float(ys) * S))
    a, g = multiplicity(x, y)
    fh_aa[a] += 1
    fh_gt[g] += 1
print("   #instances whose AA covers the point : %s" % dict(sorted(fh_aa.items())))
print("   #instances whose GT covers the point : %s" % dict(sorted(fh_gt.items())))
