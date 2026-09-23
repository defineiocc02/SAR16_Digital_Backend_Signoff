#!/usr/bin/env python3
"""Full label-vs-geometry census of the delivered GDS top cell.

For every TEXT label in the top cell, report which drawn shapes contain the
label anchor, and classify the containing shape as
  BAR   - a long full-width strip (>=100 um in one axis)
  STRAP - a long vertical strap (>=100 um tall)
  STUB  - a small pin/wire shape
This makes "which pin sits on which power structure" a measurement, not a guess.

Read-only.
"""
import struct
import sys
from collections import defaultdict

REC_NAMES = {
    0x00: "HEADER", 0x01: "BGNLIB", 0x02: "LIBNAME", 0x03: "UNITS",
    0x04: "ENDLIB", 0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR",
    0x08: "BOUNDARY", 0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF",
    0x0C: "TEXT", 0x0D: "LAYER", 0x0E: "DATATYPE", 0x10: "XY",
    0x11: "ENDEL", 0x12: "SNAME", 0x19: "STRING",
}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}
LAYERNAME = {61: "M1", 62: "M2", 63: "M3", 64: "M4", 65: "M5", 66: "M6"}


def load(path, cell):
    f = open(path, "rb")
    structs = []
    cur = None
    el = None
    while True:
        hdr = f.read(4)
        if len(hdr) < 4:
            break
        rlen, rtype, rdt = struct.unpack(">HBB", hdr)
        data = f.read(rlen - 4) if rlen >= 4 else b""
        name = REC_NAMES.get(rtype)
        if name == "BGNSTR":
            cur = {"name": None, "labels": [], "shapes": []}
        elif name == "STRNAME":
            cur["name"] = data.split(b"\x00")[0].decode("latin-1")
        elif name == "ENDSTR":
            structs.append(cur)
            cur = None
        elif rtype in ELEM:
            el = {"kind": name, "layer": None, "xy": None, "text": None}
        elif name == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", data[:2])[0]
        elif name == "XY" and el is not None:
            n = len(data) // 4
            el["xy"] = struct.unpack(">%di" % n, data[:n * 4])
        elif name == "STRING" and el is not None:
            el["text"] = data.split(b"\x00")[0].decode("latin-1")
        elif name == "ENDEL":
            if el is not None and cur is not None:
                if el["kind"] == "TEXT" and el["xy"]:
                    cur["labels"].append((el["text"], el["layer"],
                                          el["xy"][0], el["xy"][1]))
                elif el["xy"] and el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    xs = el["xy"][0::2]
                    ys = el["xy"][1::2]
                    cur["shapes"].append((el["layer"],
                                          (min(xs), min(ys), max(xs), max(ys))))
            el = None
    f.close()
    return next(s for s in structs if s["name"] == cell)


def main():
    path, cell = sys.argv[1], sys.argv[2]
    top = load(path, cell)
    S = 10000.0
    shapes = [(l, b) for l, b in top["shapes"] if l is not None]

    def kind(bb):
        w = (bb[2] - bb[0]) / S
        h = (bb[3] - bb[1]) / S
        if w >= 100 and h < 2:
            return "BAR-H"
        if h >= 100 and w < 2:
            return "STRAP-V"
        if w >= 100 or h >= 100:
            return "LONG"
        return "stub"

    # --- inventory of long structures ----------------------------------------
    longs = defaultdict(list)
    for l, bb in shapes:
        k = kind(bb)
        if k != "stub":
            longs[k].append((l, bb))
    print("=== long structures in the top cell ===")
    for k in sorted(longs):
        print("\n-- %s : %d" % (k, len(longs[k])))
        agg = defaultdict(list)
        for l, bb in longs[k]:
            agg[l].append(bb)
        for l in sorted(agg):
            print("   layer %d (%s): %d" % (l, LAYERNAME.get(l, "?"), len(agg[l])))
            for bb in sorted(agg[l])[:12]:
                print("      (%.3f,%.3f)-(%.3f,%.3f)  %.3f x %.3f"
                      % (bb[0] / S, bb[1] / S, bb[2] / S, bb[3] / S,
                         (bb[2] - bb[0]) / S, (bb[3] - bb[1]) / S))

    # --- per-label census -----------------------------------------------------
    print("\n\n=== label census: %d labels ===" % len(top["labels"]))
    rows = []
    for text, lay, x, y in top["labels"]:
        hits = [(l, bb, kind(bb)) for l, bb in shapes
                if bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]]
        rows.append((text, lay, x / S, y / S, hits))

    # which labels touch a BAR or STRAP?
    risky = [r for r in rows if any(h[2] in ("BAR-H", "STRAP-V", "LONG") for h in r[4])]
    print("\n--- labels whose anchor is inside a BAR/STRAP/LONG structure: %d ---"
          % len(risky))
    for text, lay, ux, uy, hits in risky:
        desc = " | ".join("%s@%s %.2fx%.2f" % (LAYERNAME.get(h[0], h[0]), h[2],
                                              (h[1][2] - h[1][0]) / S, (h[1][3] - h[1][1]) / S)
                          for h in hits if h[2] != "stub")
        print("   %-28s lbl-layer %-3s at (%8.3f,%8.3f)  --> %s"
              % (text, LAYERNAME.get(lay, lay), ux, uy, desc))

    print("\n--- how many labels have NO geometry under them at all ---")
    none_hits = [r for r in rows if not r[4]]
    print("   %d : %s" % (len(none_hits), [r[0] for r in none_hits][:20]))

    print("\n--- label anchor distribution (edge vs interior) ---")
    edges = defaultdict(int)
    for text, lay, ux, uy, hits in rows:
        if ux < 1:
            edges["left   (x<1)"] += 1
        elif ux > 429:
            edges["right  (x>429)"] += 1
        elif uy < 1:
            edges["bottom (y<1)"] += 1
        elif uy > 428:
            edges["top    (y>428)"] += 1
        else:
            edges["interior"] += 1
    for k in sorted(edges):
        print("   %-16s %d" % (k, edges[k]))

    print("\n--- bottom-edge labels in detail (y<1) ---")
    for text, lay, ux, uy, hits in rows:
        if uy < 1:
            print("   %-28s at (%8.3f,%6.3f) layer %s  hits=%s"
                  % (text, ux, uy, LAYERNAME.get(lay, lay),
                     [(LAYERNAME.get(h[0], h[0]), h[2]) for h in hits]))


if __name__ == "__main__":
    main()
