#!/usr/bin/env python3
"""Decisive test: is the rst_n pin stub physically part of the VDD network?

Build the M2 (layer 62) shape set of the delivered GDS top cell, union-find on
bbox overlap, and look at the connected component that contains the rst_n pin
stub.  Compare with a control pin (clk) and with the VDD strap.

Because the deck attaches TEXT on layer 62 to metal2, the label lands on
whatever M2 component contains it -- so this component IS the net Calibre named.

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


def main():
    top = load(sys.argv[1], "sar_digi_paper_core")
    m2 = [bb for l, bb in top["shapes"] if l == 62]
    print("M2 shapes in top cell: %d" % len(m2))

    parent = list(range(len(m2)))

    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[rb] = ra

    # spatial binning so this is not O(n^2) on 17 657 shapes
    BIN = 20000  # 2 um in DBU
    grid = {}
    for i, bb in enumerate(m2):
        for gx in range(bb[0] // BIN, bb[2] // BIN + 1):
            for gy in range(bb[1] // BIN, bb[3] // BIN + 1):
                grid.setdefault((gx, gy), []).append(i)
    checked = set()
    for cell in grid.values():
        for a in cell:
            for b in cell:
                if a >= b:
                    continue
                if (a, b) in checked:
                    continue
                checked.add((a, b))
                A, B = m2[a], m2[b]
                if A[0] <= B[2] and B[0] <= A[2] and A[1] <= B[3] and B[1] <= A[3]:
                    union(a, b)
    print("union-find pairs examined: %d" % len(checked))

    labels = [(t, x, y) for t, l, x, y in top["labels"] if l == 62]
    comp_label = {}
    for t, x, y in labels:
        for i, bb in enumerate(m2):
            if bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]:
                comp_label.setdefault(find(i), []).append(t)
                break

    sizes = {}
    for i in range(len(m2)):
        sizes[find(i)] = sizes.get(find(i), 0) + 1
    big = sorted(sizes.items(), key=lambda kv: -kv[1])[:6]
    print("\nlargest M2 components (root, #shapes):")
    for root, n in big:
        lbl = comp_label.get(root, [])
        print("   root=%-6d shapes=%-6d labels=%d %s"
              % (root, n, len(lbl), lbl[:6]))

    print("\n=== the component that carries each named pin ===")
    for want in ("rst_n", "clk", "dec_clk", "VDD", "VSS", "calib_done"):
        for t, x, y in labels:
            if t != want:
                continue
            hit = None
            for i, bb in enumerate(m2):
                if bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]:
                    hit = i
                    break
            if hit is None:
                print("   %-10s : label not inside any M2 shape" % want)
                continue
            root = find(hit)
            bb = m2[hit]
            print("   %-10s : stub=(%.3f,%.3f)-(%.3f,%.3f)  component shapes=%d  "
                  "co-labels=%s"
                  % (want, bb[0] / S, bb[1] / S, bb[2] / S, bb[3] / S,
                     sizes.get(root, 0), comp_label.get(root, [])))
            break

    # extent of the rst_n component
    for t, x, y in labels:
        if t != "rst_n":
            continue
        for i, bb in enumerate(m2):
            if bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]:
                root = find(i)
                members = [m2[k] for k in range(len(m2)) if find(k) == root]
                x0 = min(m[0] for m in members); x1 = max(m[2] for m in members)
                y0 = min(m[1] for m in members); y1 = max(m[3] for m in members)
                print("\nrst_n M2 component extent: (%.2f,%.2f)-(%.2f,%.2f) um  "
                      "= %.1f x %.1f um"
                      % (x0 / S, y0 / S, x1 / S, y1 / S,
                         (x1 - x0) / S, (y1 - y0) / S))
                break
        break


if __name__ == "__main__":
    main()
