#!/usr/bin/env python3
"""F1 acceptance check: does any signal pin overlap a power structure?

PASS means: for every one of the block's signal-pin labels, the metal shape that
carries the label does not overlap any M1 power rail or M2 power strap on the
same layer, and the label is not sitting on top of a supply structure.

This is the positive, recomputable criterion for the pin-placement fix -- it does
not rely on any tool's "OK" string.

Usage:
    verify_pins_clear.py <merged.gds> [cell]

Exit code 0 = PASS, 1 = FAIL.
Read-only.
"""
import struct
import sys

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x19: "STRING"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}
S = 10000.0
LN = {61: "M1", 62: "M2", 63: "M3", 64: "M4", 65: "M5", 66: "M6"}
SUPPLY = {"VDD", "VSS"}


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
            cur = {"name": None, "labels": [], "shapes": []}
        elif n == "STRNAME":
            cur["name"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            structs.append(cur); cur = None
        elif rt in ELEM:
            el = {"kind": n, "layer": None, "xy": None, "text": None}
        elif n == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", d[:2])[0]
        elif n == "XY" and el is not None:
            k = len(d) // 4
            el["xy"] = struct.unpack(">%di" % k, d[:k * 4])
        elif n == "STRING" and el is not None:
            el["text"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDEL":
            if el is not None and cur is not None and el["xy"]:
                if el["kind"] == "TEXT":
                    cur["labels"].append((el["text"], el["layer"],
                                          el["xy"][0], el["xy"][1]))
                elif el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    xs = el["xy"][0::2]; ys = el["xy"][1::2]
                    cur["shapes"].append((el["layer"],
                                          (min(xs), min(ys), max(xs), max(ys))))
            el = None
    f.close()
    return next(s for s in structs if s["name"] == cell)


def overlap(a, b, tol=0):
    return (a[0] <= b[2] + tol and b[0] <= a[2] + tol
            and a[1] <= b[3] + tol and b[1] <= a[3] + tol)


def main():
    path = sys.argv[1]
    cell = sys.argv[2] if len(sys.argv) > 2 else "sar_digi_paper_core"
    top = load(path, cell)
    shapes = [(l, bb) for l, bb in top["shapes"] if l is not None]

    # power structures = long M1 bars (rails) and long M2 bars (straps)
    rails, straps = [], []
    for l, bb in shapes:
        w = (bb[2] - bb[0]) / S
        h = (bb[3] - bb[1]) / S
        if l == 61 and w > 400 and h < 2:
            rails.append(bb)
        if l == 62 and h > 400 and w < 2:
            straps.append(bb)

    labels = [(t, l, x, y) for t, l, x, y in top["labels"]]
    signals = [(t, l, x, y) for t, l, x, y in labels if t.upper() not in SUPPLY]
    supplies = [(t, l, x, y) for t, l, x, y in labels if t.upper() in SUPPLY]

    print("cell                 : %s" % cell)
    print("labels               : %d  (signal %d, supply %d)"
          % (len(labels), len(signals), len(supplies)))
    print("M1 rails detected    : %d" % len(rails))
    print("M2 straps detected   : %d" % len(straps))

    print("\n=== signal pins whose own shape overlaps a rail or a strap ===")
    bad = 0
    for t, l, x, y in signals:
        own = [(sl, bb) for sl, bb in shapes
               if sl == l and bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]]
        if not own:
            print("   %-28s NO SHAPE at label anchor (%s layer %s)"
                  % (t, LN.get(l, l), l))
            bad += 1
            continue
        hits = []
        for sl, sb in own:
            for rb in rails:
                if overlap(sb, rb):
                    hits.append("M1-rail")
            for st in straps:
                if overlap(sb, st):
                    hits.append("M2-strap")
        if hits:
            sb = own[0][1]
            print("   %-28s %s (%.3f,%.3f)-(%.3f,%.3f)  -> %s"
                  % (t, LN.get(l, l), sb[0] / S, sb[1] / S, sb[2] / S, sb[3] / S,
                     ",".join(sorted(set(hits)))))
            bad += 1

    print("\n=== supply pins (informational: they are supposed to touch the grid) ===")
    for t, l, x, y in supplies:
        own = [(sl, bb) for sl, bb in shapes
               if sl == l and bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]]
        on = []
        for sl, sb in own:
            for rb in rails:
                if overlap(sb, rb):
                    on.append("M1-rail")
            for st in straps:
                if overlap(sb, st):
                    on.append("M2-strap")
        print("   %-6s %s at (%.3f,%.3f) touches %s"
              % (t, LN.get(l, l), x / S, y / S, sorted(set(on)) or "nothing"))

    print("\nVERDICT: %s  (%d of %d signal pins overlap a power structure)"
          % ("PASS" if bad == 0 else "FAIL", bad, len(signals)))
    return 0 if bad == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
