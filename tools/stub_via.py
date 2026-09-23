#!/usr/bin/env python3
"""Localise the rst_n-to-VDD connection to a single via, by comparing the pin
stub of rst_n against its neighbours along the bottom edge.

If only rst_n's stub contains a via down to the bottom rail, the defect is a
single misplaced/stitched pin, not a global placement problem.

Read-only.
"""
import struct
import sys

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x19: "STRING"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}
S = 10000.0


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
            cur = {"name": None, "labels": [], "shapes": [], "srefs": []}
        elif n == "STRNAME":
            cur["name"] = d.split(b"\x00")[0].decode("latin-1")
        elif n == "ENDSTR":
            structs.append(cur); cur = None
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
                    xs = el["xy"][0::2]; ys = el["xy"][1::2]
                    cur["srefs"].append((el["sname"], sum(xs) / len(xs),
                                         sum(ys) / len(ys)))
                elif el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    xs = el["xy"][0::2]; ys = el["xy"][1::2]
                    cur["shapes"].append((el["layer"],
                                          (min(xs), min(ys), max(xs), max(ys))))
            el = None
    f.close()
    return next(s for s in structs if s["name"] == cell)


def main():
    top = load(sys.argv[1], "sar_digi_paper_core")
    # bottom-edge pin stubs: M2 shapes fully inside y<1 and small
    stubs = []
    for l, bb in top["shapes"]:
        if l != 62:
            continue
        x0, y0, x1, y1 = [v / S for v in bb]
        if y0 >= -0.05 and y1 < 1.0 and (x1 - x0) < 1.0 and (y1 - y0) < 1.5:
            stubs.append((x0, y0, x1, y1))
    stubs.sort()
    print("bottom-edge M2 pin stubs: %d" % len(stubs))

    labels = {}
    for text, lay, x, y in top["labels"]:
        if y / S < 1.0:
            labels[text] = (x / S, y / S)

    # vias = SREFs whose name starts with $$
    vias = [(x / S, y / S) for nm, x, y in top["srefs"]
            if nm and nm.startswith("$$")]

    print("\n%-26s %-22s %s" % ("pin", "stub bbox (x0,y0,x1,y1)", "vias inside"))
    n_with = 0
    for x0, y0, x1, y1 in stubs:
        inside = [(vx, vy) for vx, vy in vias
                  if x0 - 0.1 <= vx <= x1 + 0.1 and y0 - 0.1 <= vy <= y1 + 0.1]
        # find the label whose anchor falls in this stub
        nm = "?"
        for text, (lx, ly) in labels.items():
            if x0 <= lx <= x1 and y0 <= ly <= y1:
                nm = text
                break
        if inside:
            n_with += 1
        if inside or nm == "rst_n":
            print("%-26s (%.3f,%.3f,%.3f,%.3f)  %s"
                  % (nm, x0, y0, x1, y1,
                     ["(%.2f,%.2f)" % v for v in inside] if inside else "none"))
    print("\nbottom stubs containing at least one via: %d of %d" % (n_with, len(stubs)))

    # control: the same for the top edge
    tstubs = []
    for l, bb in top["shapes"]:
        if l != 62:
            continue
        x0, y0, x1, y1 = [v / S for v in bb]
        if y0 > 427.5 and (x1 - x0) < 1.0 and (y1 - y0) < 1.5:
            tstubs.append((x0, y0, x1, y1))
    tw = 0
    for x0, y0, x1, y1 in tstubs:
        if any(x0 - 0.1 <= vx <= x1 + 0.1 and y0 - 0.1 <= vy <= y1 + 0.1
               for vx, vy in vias):
            tw += 1
    print("top-edge stubs containing a via: %d of %d" % (tw, len(tstubs)))

    print("\n=== all vias in the bottom 1.5 um strip, x sorted ===")
    band = sorted((vx, vy) for vx, vy in vias if vy < 1.5)
    print("count = %d" % len(band))
    for vx, vy in band[:40]:
        print("   (%.3f, %.3f)" % (vx, vy))


if __name__ == "__main__":
    main()
