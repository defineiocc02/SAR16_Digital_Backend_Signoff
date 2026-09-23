#!/usr/bin/env python3
"""All-layer connectivity of the delivered GDS top cell (M1..M6 + via1..via5).

Calibre's shorts report says  SHORT 1.  rst_n - VDD.  A metal1+metal2+via1 model
does NOT reproduce that, so the merge must use higher metals.  This model adds
them.

Nodes  = every drawn shape in the top cell (layers 61..66).
Edges  = bbox overlap on the same layer,
       + a via instance whose centre lies inside both of two shapes on the two
         layers that via connects (`$$viaN` = metalN -> metal(N+1)).
Report the component carrying each labelled pin, and the shortest label-to-label
sharing.

Read-only.
"""
import struct
import sys
from collections import defaultdict, deque

REC = {0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR", 0x08: "BOUNDARY",
       0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF", 0x0C: "TEXT", 0x0D: "LAYER",
       0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x19: "STRING"}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}
S = 10000.0
BIN = 20000
METAL = {61: 1, 62: 2, 63: 3, 64: 4, 65: 5, 66: 6}


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
    nodes = [(l, bb) for l, bb in top["shapes"] if l in METAL]
    n = len(nodes)
    print("nodes (M1..M6 shapes in top cell): %d" % n)
    parent = list(range(n))

    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[rb] = ra

    grid = defaultdict(list)
    for i, (_, bb) in enumerate(nodes):
        for gx in range(bb[0] // BIN, bb[2] // BIN + 1):
            for gy in range(bb[1] // BIN, bb[3] // BIN + 1):
                grid[(gx, gy)].append(i)
    seen = set()
    same = 0
    for cell in grid.values():
        ln = len(cell)
        for ii in range(ln):
            for jj in range(ii + 1, ln):
                a, b = cell[ii], cell[jj]
                if a == b or (a, b) in seen:
                    continue
                seen.add((a, b))
                if nodes[a][0] != nodes[b][0]:
                    continue
                A, B = nodes[a][1], nodes[b][1]
                if A[0] <= B[2] and B[0] <= A[2] and A[1] <= B[3] and B[1] <= A[3]:
                    union(a, b)
                    same += 1
    print("same-layer unions: %d" % same)

    # shape lookup grid per layer for via association
    perl = defaultdict(list)
    for i, (l, bb) in enumerate(nodes):
        perl[l].append(i)

    def containing(layer, x, y):
        return [i for i in perl.get(layer, [])
                if nodes[i][1][0] <= x <= nodes[i][1][2]
                and nodes[i][1][1] <= y <= nodes[i][1][3]]

    VIA = {"$$via1": (61, 62), "$$via1_5200_5200_1_2": (61, 62),
           "$$via2": (62, 63), "$$via3": (63, 64), "$$via4": (64, 65),
           "$$via5": (65, 66)}
    cross = defaultdict(int)
    for nm, x, y in top["srefs"]:
        pair = VIA.get(nm)
        if not pair:
            continue
        h1 = containing(pair[0], x, y)
        h2 = containing(pair[1], x, y)
        if h1 and h2:
            union(h1[0], h2[0])
            cross[nm] += 1
    print("cross-layer unions by via: %s" % dict(cross))

    labels = [(t, x, y) for t, l, x, y in top["labels"] if l in METAL]
    comp = defaultdict(list)
    for t, x, y in labels:
        hit = None
        for lay in (62, 63, 61, 64, 65, 66):
            h = containing(lay, x, y)
            if h:
                hit = h[0]
                break
        if hit is None:
            print("   %-24s : no metal shape at label" % t)
            continue
        comp[find(hit)].append(t)

    sizes = defaultdict(int)
    for i in range(n):
        sizes[find(i)] += 1
    multi = {k: v for k, v in comp.items() if len(v) > 1}
    print("\n=== components carrying more than one label: %d ===" % len(multi))
    for k, v in sorted(multi.items(), key=lambda kv: -len(kv[1])):
        print("   component %-7d shapes=%-6d labels(%d): %s"
              % (k, sizes[k], len(v), sorted(v)[:12]))

    print("\n=== explicit question: rst_n vs VDD ===")
    rn = vd = None
    for k, v in comp.items():
        if "rst_n" in v:
            rn = k
        if "VDD" in v:
            vd = k
    print("   rst_n component = %s (shapes=%s, co-labels=%s)"
          % (rn, sizes.get(rn), sorted(comp.get(rn, []))))
    print("   VDD   component = %s (shapes=%s, co-labels=%s)"
          % (vd, sizes.get(vd), sorted(comp.get(vd, []))[:8]))
    print("   SAME COMPONENT  = %s" % (rn is not None and rn == vd))


if __name__ == "__main__":
    main()
