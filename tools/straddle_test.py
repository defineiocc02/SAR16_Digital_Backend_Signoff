#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Do the flagged devices straddle TWO cell instances?

If a transistor's diffusion comes from one placed cell and its gate poly from a
neighbour, the extraction sees a device that no single cell declares -- which is
exactly what "+660 devices the cell contents do not account for" would look like.

Method: for each flagged coordinate, gather every diffusion (layer 10/14) and poly
(layer 30/43) polygon from EVERY placed instance (geometry transformed to absolute
coordinates) that covers the point, and report which instance each belongs to.
"""
import io
import os
import re
import struct
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
R = os.path.join(HERE, "..", "evidence", "rpt_v51")
GDS = os.path.join(R, "sar_digi_paper_core_merged.gds")
LVS = os.path.join(R, "lvs.rep")
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


# index the placed instances and their device-layer polygons in absolute coords
inst_shapes = []      # (frame, absbbox, [(layer, absbbox)])
BIN = 40000
grid = defaultdict(list)
for idx, (nm, ox, oy, ang, flip) in enumerate(top["srefs"]):
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
        corners = [(bb[0], bb[1]), (bb[2], bb[1]), (bb[2], bb[3]), (bb[0], bb[3])]
        pts = [xform(cx - rc["bbox"][0], cy - rc["bbox"][1], ox, oy, ang, flip, w, h)
               for cx, cy in corners]
        xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
        polys.append((lay, (min(xs), min(ys), max(xs), max(ys))))
    if polys:
        bxs = [p[1][0] for p in polys]; bys = [p[1][1] for p in polys]
        bxe = [p[1][2] for p in polys]; bye = [p[1][3] for p in polys]
        ab = (min(bxs), min(bys), max(bxe), max(bye))
        i = len(inst_shapes)
        inst_shapes.append((nm, rm, ab, polys))
        for gx in range(ab[0] // BIN, ab[2] // BIN + 1):
            for gy in range(ab[1] // BIN, ab[3] // BIN + 1):
                grid[(gx, gy)].append(i)

print("placed logic instances with device geometry: %d" % len(inst_shapes))

t = io.open(LVS, encoding="utf-8", errors="replace").read()
blk = t.split("INCORRECT INSTANCES")[-1].split("INCORRECT NETS")[0]
flag = re.findall(r"^\s+\d+\s+(\S+?)/(M\d+)\(([-\d.]+),([-\d.]+)\)\s+(M[NP])\((\w+)\)"
                  r"\s+\*\* missing instance", blk, re.M)
print("flagged devices: %d\n" % len(flag))

cross = 0
resolved = 0
for inst, dev, xs, ys, kind, model in flag:
    x = int(round(float(xs) * S)); y = int(round(float(ys) * S))
    owners_aa, owners_gt = set(), set()
    for gx in (x // BIN, x // BIN + 1):
        for gy in (y // BIN, y // BIN + 1):
            for i in grid.get((gx, gy), []):
                nm, rm, ab, polys = inst_shapes[i]
                if not (ab[0] - 300 <= x <= ab[2] + 300 and ab[1] - 300 <= y <= ab[3] + 300):
                    continue
                for lay, bb in polys:
                    if bb[0] - 300 <= x <= bb[2] + 300 and bb[1] - 300 <= y <= bb[3] + 300:
                        (owners_aa if lay in AA else owners_gt).add((nm, i))
    if owners_aa or owners_gt:
        resolved += 1
    multi = len(owners_aa) > 1 or len(owners_gt) > 1
    crossflag = ""
    if owners_aa and owners_gt:
        a_set = {i for _, i in owners_aa}
        g_set = {i for _, i in owners_gt}
        if not (a_set & g_set):
            crossflag = "  <-- AA and GT from DIFFERENT instances"
            cross += 1
    if crossflag or resolved <= 12:
        print("   %-12s %-5s %-9s at (%8s,%8s)  AA=%s GT=%s%s"
              % (inst, dev, "%s(%s)" % (kind, model), xs, ys,
                 sorted(n for n, _ in owners_aa), sorted(n for n, _ in owners_gt), crossflag))

print("\n=== summary ===")
print("   flagged devices with at least one AA/GT found : %d of %d" % (resolved, len(flag)))
print("   devices whose AA and GT come from DIFFERENT instances: %d" % cross)
