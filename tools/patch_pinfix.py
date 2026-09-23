#!/usr/bin/env python3
"""Patch fc_pnr_paper_core.tcl: forbid signal pins from stacking on the PG grid.

Discipline (this project has been burned by every one of these):
  * refuse to run unless the file md5 matches the expected pre-state
  * anchor on the exact existing text, assert EXACTLY ONE hit per anchor
  * assert that after the patch the only added lines are the ones we intended
  * write a timestamped backup beside the file
"""
import hashlib
import os
import shutil
import sys
import time

PC = "/home/<user>/sar16_work/proj_paper_core"
TCL = os.path.join(PC, "scripts", "fc_pnr_paper_core.tcl")
EXPECT_MD5 = "44890f4d10e108bd8135421a314a8d4c"   # v4.3/round-3 final script

ANCHOR = 'run "place_pins" {place_pins -self}'

BLOCK = '''# ---------------------------------------------------------------------------
# Pins must not stack on the power grid.
#
# Measured on the v4.3 delivery (own GDS parser, not the tool's word):
#   128 of 232 signal pins had pin metal overlapping an M1 power rail or an M2
#   power strap, and Calibre's shorts report named the consequence:
#       SHORT 1.  rst_n - VDD in sar_digi_paper_core
#   The rst_n pin sat on the bottom edge, where the bottom-most M1 rail runs the
#   full block width, and the extractor merged the two nets.
#
# `-stacking_allowed` is THIS release's own control for exactly that situation
# ("allowance of signal pins stacking above or below other pins and power or
# ground straps"), so it is used rather than a guessed option spelling -- this
# flow has already lost a round to `write_gds -output` (CMD-011) and to
# `fc_shell -no_gui` (CMD-010).
#
# Acceptance is measured outside the tool: every signal pin's metal must be
# disjoint from every rail and strap in the written GDS.
run "set_block_pin_constraints" {set_block_pin_constraints -self -stacking_allowed none}

'''


def md5(p):
    return hashlib.md5(open(p, "rb").read()).hexdigest()


def main():
    if not os.path.exists(TCL):
        print("PATCH status=NO_FILE %s" % TCL)
        return 1
    pre = md5(TCL)
    print("PATCH pre_md5=%s (expect %s)" % (pre, EXPECT_MD5))
    if pre != EXPECT_MD5:
        print("PATCH status=MD5_MISMATCH -- refusing to touch the file")
        return 1

    txt = open(TCL, encoding="utf-8", errors="surrogateescape").read()
    hits = txt.count(ANCHOR)
    print("PATCH anchor hits=%d (must be exactly 1)" % hits)
    if hits != 1:
        print("PATCH status=ANCHOR_COUNT_INVALID")
        return 1

    new = txt.replace(ANCHOR, BLOCK + ANCHOR)
    added = [l for l in new.splitlines() if l not in txt.splitlines()]
    print("PATCH added lines=%d" % len(added))
    unexpected = [l for l in added
                  if not (l.startswith("#") or l.strip() == ""
                          or l.startswith('run "set_block_pin_constraints"'))]
    print("PATCH unexpected added lines=%d" % len(unexpected))
    for l in unexpected:
        print("    UNEXPECTED: %s" % l)
    if unexpected:
        print("PATCH status=UNEXPECTED_LINES")
        return 1

    bakdir = os.path.join(PC, "scripts", ".bak_pinfix")
    os.makedirs(bakdir, exist_ok=True)
    stamp = time.strftime("%Y%m%d_%H%M%S")
    shutil.copy2(TCL, os.path.join(bakdir, "fc_pnr_paper_core.tcl.%s" % stamp))
    open(TCL, "w", encoding="utf-8", errors="surrogateescape").write(new)

    post = md5(TCL)
    print("PATCH backup=%s" % os.path.join(bakdir, "fc_pnr_paper_core.tcl.%s" % stamp))
    print("PATCH post_md5=%s" % post)
    print("PATCH status=OK" if post != pre else "PATCH status=NO_CHANGE")
    return 0


if __name__ == "__main__":
    sys.exit(main())
