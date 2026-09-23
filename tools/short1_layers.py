#!/usr/bin/env python3
"""Layer lookup for Calibre's SHORT 1 rectangles, with tolerance.

The exact bbox key lookup missed because Calibre's reported rectangle and the
GDS polygon can differ by a database unit.  This version searches a window.

Read-only.
"""
import re
import struct
import sys
from collections import defaultdict

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x19: "STRING"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}
S = 10000.0
LN = {61: "M1", 62: "M2", 63: "M3", 64: "M4", 65: "M5", 66: "M6"}


def load(path, cell):
    f = open(path, "rb")
    structs, cur, el = [], None, None
    while True:
        h = f.read(4)
        if len(h) < 4:
            break
        rl, rt, rd = struct.unpack(">HBB", h)
        d = f.read(rl - 4) if rl >= 4 else b""
        n = REC.get(rt)
        if n == "BGNSTR":
            cur = {"name": None, "shapes": []}
        elif n == "STRNAME":
            cur["name"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            structs.append(cur); cur = None
        elif rt in ELEM:
            el = {"kind": n, "layer": None, "xy": None}
        elif n == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", d[:2])[0]
        elif n == "XY" and el is not None:
            k = len(d) // 4
            el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
        elif n == "ENDEL":
            if el is not None and cur is not None and el["xy"] and \
                    el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                xs = el["xy"][0::2]; ys = el["xy"][1::2]
                cur["shapes"].append((el["layer"],
                                      (min(xs), min(ys), max(xs), max(ys))))
            el = None
    f.close()
    return next(s for s in structs if s["name"] == cell)


def main():
    top = load(sys.argv[1], "sar_digi_paper_core")
    print("top-cell shapes: %d" % len(top["shapes"]))
    TOL = 3

    # straps and their nets, from the geometry we already measured
    straps = []
    for l, bb in top["shapes"]:
        if l == 62 and (bb[3] - bb[1]) / S > 400 and (bb[2] - bb[0]) / S < 2:
            straps.append(bb)
    print("M2 full-height straps: %d" % len(straps))

    txt = open(sys.argv[2], errors="replace").read()
    body = txt.split("SHORT 1.")[1].split("SHORT 2.")[0]
    rects = re.findall(r"^p \d+ 4\nSN (\d+)\n(-?\d+) (-?\d+)\n(-?\d+) (-?\d+)\n"
                       r"(-?\d+) (-?\d+)\n(-?\d+) (-?\d+)$", body, re.M)
    print("SHORT 1 rectangles: %d\n" % len(rects))

    for sn, x0, y0, x1, y1, x2, y2, x3, y3 in rects:
        xs = [int(x0), int(x1), int(x2), int(x3)]
        ys = [int(y0), int(y1), int(y2), int(y3)]
        bb = (min(xs), min(ys), max(xs), max(ys))
        if bb[2] - bb[0] <= TOL and bb[3] - bb[1] <= TOL:
            print("   SN %-5s label/via anchor at (%.3f, %.3f)  [skip]"
                  % (sn, bb[0] / S, bb[1] / S))
            continue
        cands = [(l, s) for l, s in top["shapes"]
                 if abs(s[0] - bb[0]) <= TOL and abs(s[1] - bb[1]) <= TOL
                 and abs(s[2] - bb[2]) <= TOL and abs(s[3] - bb[3]) <= TOL]
        lay = sorted({LN.get(l, l) for l, _ in cands})
        # does this rectangle cross a strap?
        crossing = [i for i, st in enumerate(straps)
                    if st[0] <= bb[2] and bb[0] <= st[2]
                    and st[1] <= bb[3] and bb[1] <= st[3]]
        print("   SN %-5s (%.3f,%.3f)-(%.3f,%.3f) %6.2fx%-6.2f layer=%s  "
              "crosses %d M2 strap(s) at x=%s"
              % (sn, bb[0] / S, bb[1] / S, bb[2] / S, bb[3] / S,
                 (bb[2] - bb[0]) / S, (bb[3] - bb[1]) / S,
                 lay if lay else "CHILD-CELL/UNKNOWN", len(crossing),
                 [round((straps[i][0] + straps[i][2]) / 2 / S, 2) for i in crossing]))

    # which straps are labelled VDD / VSS?
    labelled = {}
    for t, l, x, y in top["labels"]:
        if t in ("VDD", "VSS"):
            for st in straps:
                if st[0] <= x <= st[2]:
                    labelled[round((st[0] + st[2]) / 2 / S, 2)] = t
    print("\nlabelled straps: %s" % labelled)


if __name__ == "__main__":
    main()
