#!/usr/bin/env python3
"""Full M1+M2+via connectivity of the delivered GDS top cell.

Goal: decide whether the net carrying the `rst_n` label is electrically the same
net as the one carrying the `VDD` label.  Calibre's extraction report says they
are (it assigned VDD to the net).  M2-only analysis says they are NOT.  So the
merge, if real, must run through metal1 and/or vias.

Model:
  * nodes = M1 shapes (layer 61) + M2 shapes (layer 62)
  * same-layer edges = bbox overlap
  * cross-layer edges = a via instance whose centre lies inside both shapes
    (`$$via1*` is the metal1-metal2 via; `$$via2*` is metal2-metal3 and is
     irrelevant to an M1/M2 question but is reported for completeness)
Then report the component that carries each labelled pin.

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
BIN = 20000


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
    m1 = [(61, bb) for l, bb in top["shapes"] if l == 61]
    m2 = [(62, bb) for l, bb in top["shapes"] if l == 62]
    nodes = m1 + m2
    n = len(nodes)
    print("nodes: M1=%d  M2=%d  total=%d" % (len(m1), len(m2), n))

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
    edges = 0
    for cell in grid.values():
        ln = len(cell)
        for ii in range(ln):
            for jj in range(ii + 1, ln):
                a, b = cell[ii], cell[jj]
                if a == b or (a, b) in seen:
                    continue
                seen.add((a, b))
                if nodes[a][0] != nodes[b][0]:
                    continue                      # cross-layer needs a via
                A, B = nodes[a][1], nodes[b][1]
                if A[0] <= B[2] and B[0] <= A[2] and A[1] <= B[3] and B[1] <= A[3]:
                    union(a, b)
                    edges += 1
    print("same-layer unions: %d" % edges)

    # cross-layer through via instances
    vias = [(nm, x, y) for nm, x, y in top["srefs"] if nm and nm.startswith("$$")]
    byname = defaultdict(int)
    for nm, _, _ in vias:
        byname[nm] += 1
    print("via instances: %s" % dict(byname))

    def find_shape(layer, x, y):
        hits = [i for i, (l, bb) in enumerate(nodes)
                if l == layer and bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]]
        return hits

    cross = 0
    for nm, x, y in vias:
        if not nm.startswith("$$via1"):
            continue
        h1 = find_shape(61, x, y)
        h2 = find_shape(62, x, y)
        if h1 and h2:
            union(h1[0], h2[0])
            cross += 1
    print("$$via1 cross-layer unions applied: %d" % cross)

    # component of each labelled pin
    labels = [(t, x, y) for t, l, x, y in top["labels"] if l in (61, 62)]
    print("\n=== component membership per pin label ===")
    comp_of = {}
    for t, x, y in labels:
        hits = find_shape(62, x, y)
        if not hits:
            hits = find_shape(61, x, y)
        if not hits:
            print("   %-24s : no M1/M2 shape at the label" % t)
            continue
        comp_of.setdefault(find(hits[0]), []).append(t)

    sizes = defaultdict(int)
    for i in range(n):
        sizes[find(i)] += 1
    multi = {k: v for k, v in comp_of.items() if len(v) > 1}
    print("labels sharing a component with another label: %d component(s)" % len(multi))
    for k, v in sorted(multi.items(), key=lambda kv: -len(kv[1])):
        print("   component %-6d shapes=%-6d carries %d labels: %s"
              % (k, sizes[k], len(v), v[:8]))

    print("\n=== explicit question ===")
    for want in ("rst_n", "VDD", "VSS", "clk"):
        for k, v in comp_of.items():
            if want in v:
                print("   %-8s -> component %-6d shapes=%-5d co-labels=%s"
                      % (want, k, sizes[k], [z for z in v if z != want][:6]))
                break


if __name__ == "__main__":
    main()
