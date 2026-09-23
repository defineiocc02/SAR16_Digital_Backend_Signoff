#!/usr/bin/env python3
"""Independent GDSII census for the SAR16 delivery package.

Written from the GDSII stream spec, deliberately NOT reusing the vendor's
in-tree parser, so that a shared bug cannot reproduce itself.
Read-only: opens the file 'rb', never writes next to it.
"""
import struct
import sys
from collections import Counter, defaultdict

# record type -> (name, data-type-kind)
REC = {
    0x00: "HEADER", 0x01: "BGNLIB", 0x02: "LIBNAME", 0x03: "UNITS",
    0x04: "ENDLIB", 0x05: "BGNSTR", 0x06: "STRNAME", 0x07: "ENDSTR",
    0x08: "BOUNDARY", 0x09: "PATH", 0x0A: "SREF", 0x0B: "AREF",
    0x0C: "TEXT", 0x0D: "LAYER", 0x0E: "DATATYPE", 0x0F: "WIDTH",
    0x10: "XY", 0x11: "ENDEL", 0x12: "SNAME", 0x13: "COLROW",
    0x14: "TEXTNODE", 0x15: "NODE", 0x16: "TEXTTYPE", 0x17: "PRESENTATION",
    0x18: "SPACING", 0x19: "STRING", 0x1A: "STRANS", 0x1B: "MAG",
    0x1C: "ANGLE", 0x1D: "UINTEGER", 0x1E: "USTRING", 0x21: "BOX",
    0x22: "BOXTYPE", 0x23: "PLEX", 0x24: "BGNEXTN", 0x25: "ENDEXTN",
    0x26: "TAPENUM", 0x27: "TAPECODE", 0x28: "STRCLASS", 0x2A: "REFLIBS",
    0x2B: "FONTS", 0x2C: "PATHTYPE", 0x2D: "GENERATIONS", 0x2E: "ATTRTABLE",
    0x2F: "STYPTABLE", 0x30: "STRTYPE", 0x31: "ELFLAGS", 0x32: "ELKEY",
    0x36: "FORMAT", 0x37: "MASK", 0x38: "ENDMASKS", 0x39: "LIBDIRSIZE",
    0x3A: "SRFNAME", 0x3B: "LIBSECUR",
}
ELEMENT_STARTS = {0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x14, 0x15, 0x21}


def parse(path):
    size = len(open(path, "rb").read())
    f = open(path, "rb")
    recs = 0
    structs = []                 # list of dicts
    cur = None
    cur_el = None
    libname = None
    units = None
    tail_ok = None
    last4 = None
    elem_counts = Counter()
    texts = defaultdict(Counter)  # cell -> label counter
    layer_pairs = defaultdict(Counter)  # cell-kind -> (layer,datatype)
    refs = Counter()
    parse_error = None

    def read_exact(n):
        b = f.read(n)
        if len(b) != n:
            raise EOFError("short read: wanted %d got %d" % (n, len(b)))
        return b

    pos = 0
    while True:
        hdr = f.read(4)
        if len(hdr) == 0:
            break
        if len(hdr) < 4:
            parse_error = "trailing %d bytes (not a full record header)" % len(hdr)
            break
        rlen, rtype, rdt = struct.unpack(">HBB", hdr)
        if rlen < 4:
            parse_error = "record length %d < 4 at offset %d" % (rlen, pos)
            break
        data = read_exact(rlen - 4)
        pos += rlen
        recs += 1
        name = REC.get(rtype, "UNKNOWN_0x%02X" % rtype)
        if name == "LIBNAME":
            libname = data.split(b"\x00")[0].decode("latin-1")
        elif name == "UNITS":
            if len(data) >= 16:
                dbu_user, dbu_meter = struct.unpack(">dd", data[:16])
                units = (dbu_user, dbu_meter)
        elif name == "BGNSTR":
            cur = {"name": None, "elements": Counter(), "texts": Counter(),
                   "layers": Counter(), "refs": Counter(), "paths": 0,
                   "boundaries": 0, "srefs": 0, "arefs": 0, "texts_n": 0}
        elif name == "STRNAME":
            cur["name"] = data.split(b"\x00")[0].decode("latin-1")
        elif name == "ENDSTR":
            if cur is not None:
                structs.append(cur)
            cur = None
        elif rtype in ELEMENT_STARTS:
            cur_el = {"kind": name, "layer": None, "datatype": None, "sname": None}
            elem_counts[name] += 1
            if cur is not None:
                cur["elements"][name] += 1
        elif name == "LAYER":
            if cur_el is not None:
                cur_el["layer"] = struct.unpack(">h", data[:2])[0]
        elif name == "DATATYPE" or name == "BOXTYPE" or name == "TEXTTYPE":
            if cur_el is not None:
                cur_el["datatype"] = struct.unpack(">h", data[:2])[0]
        elif name == "SNAME":
            if cur_el is not None:
                cur_el["sname"] = data.split(b"\x00")[0].decode("latin-1")
        elif name == "STRING":
            if cur_el is not None and cur is not None:
                s = data.split(b"\x00")[0].decode("latin-1")
                cur["texts"][s] += 1
                cur["texts_n"] += 1
        elif name == "ENDEL":
            if cur is not None and cur_el is not None:
                k = cur_el["kind"]
                if k == "PATH":
                    cur["paths"] += 1
                elif k == "BOUNDARY" or k == "BOX":
                    cur["boundaries"] += 1
                elif k == "SREF":
                    cur["srefs"] += 1
                    cur["refs"][cur_el["sname"]] += 1
                    refs[cur_el["sname"]] += 1
                elif k == "AREF":
                    cur["arefs"] += 1
                    cur["refs"][cur_el["sname"]] += 1
                    refs[cur_el["sname"]] += 1
                if cur_el["layer"] is not None:
                    cur["layers"][(cur_el["layer"], cur_el["datatype"])] += 1
                    layer_pairs[k][(cur_el["layer"], cur_el["datatype"])] += 1
            cur_el = None
        elif name == "ENDLIB":
            tail_ok = True

    f.close()
    with open(path, "rb") as g:
        g.seek(max(0, size - 4))
        last4 = g.read(4)
    return dict(size=size, recs=recs, structs=structs, libname=libname,
                units=units, last4=last4, elem_counts=elem_counts,
                layer_pairs=layer_pairs, refs=refs, parse_error=parse_error,
                endlib_seen=bool(tail_ok))


def main():
    path = sys.argv[1]
    r = parse(path)
    print("file            : %s" % path)
    print("bytes           : %d" % r["size"])
    print("records         : %d" % r["recs"])
    print("library name    : %s" % r["libname"])
    print("units           : %s" % (r["units"],))
    print("ENDLIB seen     : %s" % r["endlib_seen"])
    print("last 4 bytes    : %s" % r["last4"].hex())
    print("parse error     : %s" % r["parse_error"])
    print("structs defined : %d" % len(r["structs"]))

    defined = {s["name"] for s in r["structs"]}
    referenced = set(r["refs"])
    top = sorted(defined - referenced)
    print("top candidates  : %s" % top)
    dangling = sorted(referenced - defined)
    print("referenced-but-undefined: %d %s" % (len(dangling), dangling[:10]))

    lp = set()
    for s in r["structs"]:
        lp |= set(s["layers"])
    print("layer/datatype pairs used anywhere : %d" % len(lp))

    print("element totals  : %s" % dict(r["elem_counts"]))

    for t in top:
        s = next(x for x in r["structs"] if x["name"] == t)
        print("")
        print("=== TOP CELL '%s' ===" % t)
        print("  elements      : %s" % dict(s["elements"]))
        print("  boundaries    : %d   paths: %d   srefs: %d   arefs: %d   TEXT: %d"
              % (s["boundaries"], s["paths"], s["srefs"], s["arefs"], s["texts_n"]))
        print("  distinct TEXT : %d" % len(s["texts"]))
        print("  layer pairs   : %d" % len(s["layers"]))
        print("  top layer pairs: %s" % sorted(s["layers"].items(), key=lambda kv: -kv[1])[:25])
        print("  child cells   : %d distinct" % len(s["refs"]))
        vdd = [k for k in s["texts"] if k.upper() == "VDD"]
        vss = [k for k in s["texts"] if k.upper() == "VSS"]
        print("  label VDD     : %s" % vdd)
        print("  label VSS     : %s" % vss)
        others = sorted(k for k in s["texts"] if k.upper() not in ("VDD", "VSS"))
        print("  non-supply labels: %d" % len(others))
        print("  first 12      : %s" % others[:12])
        print("  last 12       : %s" % others[-12:])


if __name__ == "__main__":
    main()
