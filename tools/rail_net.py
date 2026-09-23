#!/usr/bin/env python3
"""Decide which supply the bottom-most M1 rail belongs to, from geometry alone.

Method: power-grid connectivity needs a via at every M1-rail / M2-strap
crossing.  The VDD and VSS straps are identifiable because their own labels sit
on them (VDD at x~425.4, VSS at x~412.6, both full height).  So:
  * collect every M1 full-width rail (y band)      -> rails
  * collect every M2 full-height strap (x band)    -> straps
  * collect every via instance (SREF of $$via*)    -> via centres
  * for the bottom rail, report which straps have a via on it
That yields "the bottom rail is the one the VDD strap is stitched to".

Read-only.
"""
import struct
import sys
from collections import defaultdict

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x19: "STRING"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}
S = 10000.0


def load(path, cell):
    f = open(path, "rb")
    structs = []
    cur = None
    el = None
    while True:
        h = f.read(4)
        if len(h) < 4:
            break
        rl, rt, rd = struct.unpack(">HBB", h)
        d = f.read(rl - 4) if rl >= 4 else b""
        n = REC.get(rt)
        if n == "BGNSTR":
            cur = {"name": None, "labels": [], "shapes": [], "srefs": []}
        elif n == "STRNAME":
            cur["name"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            structs.append(cur)
            cur = None
        elif rt in ELEM:
            el = {"kind": n, "layer": None, "xy": None, "text": None, "sname": None}
        elif n == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", d[:2])[0]
        elif n == "XY" and el is not None:
            k = len(d) // 4
            el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
        elif n == "STRING" and el is not None:
            el["text"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "SNAME" and el is not None:
            el["sname"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDEL":
            if el is not None and cur is not None and el["xy"]:
                if el["kind"] == "TEXT":
                    cur["labels"].append((el["text"], el["layer"],
                                          el["xy"][0], el["xy"][1]))
                elif el["kind"] in ("SREF", "AREF"):
                    xs = el["xy"][0::2]
                    ys = el["xy"][1::2]
                    cur["srefs"].append((el["sname"], sum(xs) / len(xs),
                                         sum(ys) / len(ys)))
                elif el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    xs = el["xy"][0::2]
                    ys = el["xy"][1::2]
                    cur["shapes"].append((el["layer"],
                                          (min(xs), min(ys), max(xs), max(ys))))
            el = None
    f.close()
    return next(s for s in structs if s["name"] == cell)


def main():
    top = load(sys.argv[1], argv_cell)
    rails = []      # (y0,y1)
    straps = []     # (x0,x1)
    for l, bb in top["shapes"]:
        w = (bb[2] - bb[0]) / S
        h = (bb[3] - bb[1]) / S
        if l == 61 and w > 400 and h < 2:
            rails.append((bb[0] / S, bb[1] / S, bb[2] / S, bb[3] / S))
        if l == 62 and h > 400 and w < 2:
            straps.append((bb[0] / S, bb[1] / S, bb[2] / S, bb[3] / S))
    rails.sort(key=lambda r: r[1])
    straps.sort(key=lambda s: s[0])
    print("M1 full-width rails : %d" % len(rails))
    print("M2 full-height straps: %d" % len(straps))

    # which strap carries which label?
    labelled = {}
    for text, lay, x, y in top["labels"]:
        if text in ("VDD", "VSS"):
            ux, uy = x / S, y / S
            for st in straps:
                if st[0] <= ux <= st[2]:
                    labelled[round((st[0] + st[2]) / 2, 3)] = text
    print("straps identified by label: %s" % labelled)
    vdd_x = [k for k, v in labelled.items() if v == "VDD"]
    vss_x = [k for k, v in labelled.items() if v == "VSS"]

    # via instances
    vias = [(nm, x / S, y / S) for nm, x, y in top["srefs"]
            if nm and nm.startswith("$$via")]
    print("via-ish SREFs in top cell: %d" % len(vias))
    names = defaultdict(int)
    for nm, _, _ in vias:
        names[nm] += 1
    print("  by name: %s" % dict(names))

    # For each rail, count how many VDD-strap and VSS-strap crossings have a via
    print("\nrail#   y-band(um)        VDD-strap vias   VSS-strap vias   verdict")
    for i, (x0, y0, x1, y1) in enumerate(rails):
        yc = (y0 + y1) / 2
        nv = nvs = 0
        for st in straps:
            xc = (st[0] + st[2]) / 2
            hit = any(abs(vx - xc) < 1.5 and abs(vy - yc) < 1.5 for _, vx, vy in vias)
            if not hit:
                continue
            if xc in vdd_x:
                nv += 1
            elif xc in vss_x:
                nvs += 1
        if i < 6 or i > len(rails) - 4:
            print("%4d   %.2f..%-8.2f   %-16d %-16d" % (i, y0, y1, nv, nvs))

    # Full crossing matrix: for EVERY strap, how many rails have a via on it
    print("\nper-strap via counts (first/last few), with label if known:")
    tally = []
    for st in straps:
        xc = (st[0] + st[2]) / 2
        cnt = sum(1 for (x0, y0, x1, y1) in rails
                  if any(abs(vx - xc) < 1.5 and y0 - 1.5 <= vy <= y1 + 1.5
                         for _, vx, vy in vias))
        tally.append((round(xc, 2), cnt, labelled.get(round(xc, 3), "")))
    for t in tally[:6] + tally[-6:]:
        print("   x=%8.2f  vias-on-rails=%3d  %s" % t)

    print("\n=== decisive: the bottom-most rail ===")
    x0, y0, x1, y1 = rails[0]
    yc = (y0 + y1) / 2
    print("bottom rail y band %.3f..%.3f" % (y0, y1))
    for st in straps:
        xc = (st[0] + st[2]) / 2
        if any(abs(vx - xc) < 1.5 and abs(vy - yc) < 1.5 for _, vx, vy in vias):
            print("   via present at strap x=%.3f  -> %s"
                  % (xc, labelled.get(round(xc, 3), "(unlabelled strap)")))


argv_cell = "sar_digi_paper_core"
if __name__ == "__main__":
    main()
