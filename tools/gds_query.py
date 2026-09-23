#!/usr/bin/env python3
"""Geometry query on the delivered GDS top cell.

Question: the extraction report says the label "rst_n" sits on the same net as
the label "VDD".  Labels are attached by position, so the decisive fact is what
geometry is actually under each label.  This tool answers that from the GDS
itself, without asking any EDA tool.

Read-only.
"""
import struct
import sys
from collections import defaultdict

REC_NAMES = {
    0x00: "HEADER", 0x01: "BGNLIB", 0x02: "LIBNAME", 0x03: "UNITS",
    0x04: "ENDLIB", 0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR",
    0x08: "BOUNDARY", 0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF",
    0x0C: "TEXT", 0x0D: "LAYER", 0x0E: "DATATYPE", 0x0F: "WIDTH",
    0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x16: "TEXTTYPE",
    0x17: "PRESENTATION", 0x19: "STRING",
}
ELEM = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x21}


def load_top(path):
    """Return (topname, labels, shapes) where labels=[(text,layer,x,y)] and
    shapes=[(layer,bbox)] for the top cell."""
    f = open(path, "rb")
    size = 0
    structs = []          # (name, labels, shapes)
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
            if name == "TEXT":
                el["kind"] = "TEXT"
        elif name == "LAYER" and el is not None:
            el["layer"] = struct.unpack(">h", data[:2])[0]
        elif name == "XY" and el is not None:
            # XY holds 4-byte signed integers: two per point.
            n = len(data) // 4
            el["xy"] = struct.unpack(">%di" % n, data[:n * 4])
        elif name == "STRING" and el is not None:
            el["text"] = data.split(b"\x00")[0].decode("latin-1")
        elif name == "ENDEL":
            if el is not None and cur is not None:
                if el["kind"] == "TEXT" and el["xy"]:
                    x, y = el["xy"][0], el["xy"][1]
                    cur["labels"].append((el["text"], el["layer"], x, y))
                elif el["xy"] and el["kind"] in ("BOUNDARY", "PATH", "BOX"):
                    xs = el["xy"][0::2]
                    ys = el["xy"][1::2]
                    cur["shapes"].append((el["layer"],
                                          (min(xs), min(ys), max(xs), max(ys))))
            el = None
    f.close()
    defined = {s["name"] for s in structs}
    return structs, defined


def main():
    path = sys.argv[1]
    structs, defined = load_top(path)
    top = next(s for s in structs if s["name"] == "sar_digi_paper_core")

    # --- derive the DBU scale from the known die size -------------------------
    xs0 = min(s[1][0] for s in top["shapes"])
    ys0 = min(s[1][1] for s in top["shapes"])
    xs1 = max(s[1][2] for s in top["shapes"])
    ys1 = max(s[1][3] for s in top["shapes"])
    w_dbu, h_dbu = xs1 - xs0, ys1 - ys0
    print("top-cell shape bbox (DBU) : x %d..%d  y %d..%d" % (xs0, xs1, ys0, ys1))
    print("declared die (um)         : 430.090 x 429.340")
    print("=> DBU per um             : %.3f  (x)   %.3f  (y)"
          % (w_dbu / 430.090, h_dbu / 429.340))
    S = round(w_dbu / 430.090)

    # --- layer inventory of the top cell --------------------------------------
    bylayer = defaultdict(list)
    for lay, bb in top["shapes"]:
        bylayer[lay].append(bb)
    print("\nlayer  shapes   x-range(um)            y-range(um)            total area(um2)")
    for lay in sorted(bylayer):
        bbs = bylayer[lay]
        x0 = min(b[0] for b in bbs) / S
        x1 = max(b[2] for b in bbs) / S
        y0 = min(b[1] for b in bbs) / S
        y1 = max(b[3] for b in bbs) / S
        area = sum((b[2] - b[0]) * (b[3] - b[1]) for b in bbs) / (S * S)
        print("%5d  %6d   %8.2f..%-8.2f      %8.2f..%-8.2f      %10.1f"
              % (lay, len(bbs), x0, x1, y0, y1, area))

    # --- label query ----------------------------------------------------------
    print("\n=== labels named rst_n / VDD / VSS : what geometry is under them? ===")
    want = {"rst_n", "VDD", "VSS"}
    for text, lay, x, y in top["labels"]:
        if text not in want:
            continue
        ux, uy = x / S, y / S
        hits = []
        for shape_lay, bb in top["shapes"]:
            if bb[0] <= x <= bb[2] and bb[1] <= y <= bb[3]:
                hits.append((shape_lay, bb))
        print("\nlabel %-6s layer %d at (%.3f, %.3f) um   -> %d shape(s) contain it"
              % (text, lay, ux, uy, len(hits)))
        for shape_lay, bb in hits[:8]:
            print("     layer %3d  bbox (%.3f,%.3f)-(%.3f,%.3f) um  size %.3f x %.3f"
                  % (shape_lay, bb[0] / S, bb[1] / S, bb[2] / S, bb[3] / S,
                     (bb[2] - bb[0]) / S, (bb[3] - bb[1]) / S))

    # --- where are the M2 vertical straps? ------------------------------------
    print("\n=== M2 (layer 62) shapes taller than 100 um : the PG straps ===")
    tall = [bb for bb in bylayer.get(62, []) if (bb[3] - bb[1]) / S > 100]
    tall.sort(key=lambda b: b[0])
    print("count = %d" % len(tall))
    for bb in tall[:30]:
        print("     x %.3f..%.3f  y %.3f..%.3f   (w %.3f)"
              % (bb[0] / S, bb[2] / S, bb[1] / S, bb[3] / S, (bb[2] - bb[0]) / S))


if __name__ == "__main__":
    main()
