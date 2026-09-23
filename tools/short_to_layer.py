#!/usr/bin/env python3
"""Map Calibre's SHORT 1 polygons back to GDS layers.

lvs.rep.shorts prints, for each short, the exact rectangles of the geometry that
makes up the shorted net.  Matching those rectangles against the delivered GDS
tells us which LAYER carries the rst_n-to-VDD connection -- which a top-level
model that only unions by bbox overlap failed to reproduce.

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
LAYERNAME = {61: "M1", 62: "M2", 63: "M3", 64: "M4", 65: "M5", 66: "M6",
             51: "CONT", 52: "VIA1", 53: "VIA2", 54: "VIA3", 55: "VIA4",
             56: "VIA5", 10: "AA", 30: "GT"}


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
    gds, shorts = sys.argv[1], sys.argv[2]
    top = load(gds, "sar_digi_paper_core")
    index = defaultdict(list)
    for lay, bb in top["shapes"]:
        index[bb].append(lay)

    txt = open(shorts, errors="replace").read()
    blocks = re.split(r"^SHORT\s+(\d+)\..*$", txt, flags=re.M)
    # blocks: [preamble, id, body, id, body, ...]
    for i in range(1, len(blocks), 2):
        sid, body = blocks[i], blocks[i + 1]
        title = txt.split("SHORT %s." % sid)[1].split("\n")[0].strip()
        rects = re.findall(r"^p \d+ 4\nSN (\d+)\n(-?\d+) (-?\d+)\n(-?\d+) (-?\d+)\n"
                           r"(-?\d+) (-?\d+)\n(-?\d+) (-?\d+)$", body, re.M)
        print("\n=== SHORT %s : %s ===  rectangles: %d" % (sid, title, len(rects)))
        counts = defaultdict(int)
        for sn, x0, y0, x1, y1, x2, y2, x3, y3 in rects:
            xs = [int(x0), int(x1), int(x2), int(x3)]
            ys = [int(y0), int(y1), int(y2), int(y3)]
            bb = (min(xs), min(ys), max(xs), max(ys))
            lays = index.get(bb)
            w = (bb[2] - bb[0]) / S
            h = (bb[3] - bb[1]) / S
            if lays:
                for l in set(lays):
                    counts[l] += 1
                laytxt = ",".join(LAYERNAME.get(l, str(l)) for l in sorted(set(lays)))
            else:
                counts[None] += 1
                laytxt = "NOT-IN-TOP-CELL"
            print("   SN %-6s %-22s (%.3f,%.3f)-(%.3f,%.3f)  %.3fx%.3f um"
                  % (sn, laytxt, bb[0] / S, bb[1] / S, bb[2] / S, bb[3] / S, w, h))
        print("   layer histogram: %s"
              % {LAYERNAME.get(k, k): v for k, v in counts.items()})


if __name__ == "__main__":
    main()
