#!/usr/bin/env python3
"""Flip the LVS deck's GLOBALS-ARE-PORTS setting to match the current layout.

History (from the script's own comments):
  * round 3 set it to NO, because at that time the LAYOUT had no VDD/VSS ports
    while the source did (v2lvs emits `.GLOBAL VDD VSS`), so the comparison died
    on "Different numbers of ports".
  * v5.0/v5.1 added `-extend_low/-extend_high ..._and_generate_pin`, so the
    LAYOUT now carries VDD and VSS as ports (measured: layout-only = {VDD, VSS}).
    The premise of NO is therefore gone, and YES is the setting that makes the
    two sides agree.
Controlled patch: md5 guard, anchor-count assert, backup.
"""
import hashlib
import os
import shutil
import sys
import time

PC = "/home/<user>/sar16_work/proj_paper_core"
SH = os.path.join(PC, "scripts", "run_lvs_paper_core.sh")
EXPECT_MD5 = "d21c81c9e344cc0fe331ccaaf9b64419"   # as recorded in the delivery README

OLD1 = "    sed -i -E 's|^LVS GLOBALS ARE PORTS.*|LVS GLOBALS ARE PORTS                 NO|' mylvs.lvs"
NEW1 = "    sed -i -E 's|^LVS GLOBALS ARE PORTS.*|LVS GLOBALS ARE PORTS                 YES|' mylvs.lvs"
OLD2 = "    sed -i -E '/^LAYOUT PRIMARY/a LVS GLOBALS ARE PORTS                 NO' mylvs.lvs"
NEW2 = "    sed -i -E '/^LAYOUT PRIMARY/a LVS GLOBALS ARE PORTS                 YES' mylvs.lvs"
OLD3 = "NGP=$(grep -cE '^LVS GLOBALS ARE PORTS +NO' mylvs.lvs); NGP=${NGP:-0}"
NEW3 = "NGP=$(grep -cE '^LVS GLOBALS ARE PORTS +YES' mylvs.lvs); NGP=${NGP:-0}"
OLD4 = 'echo "  LVS GLOBALS ARE PORTS NO statements : $NGP  (must be exactly 1)"'
NEW4 = 'echo "  LVS GLOBALS ARE PORTS YES statements : $NGP  (must be exactly 1)"'
OLD5 = 'echo "FATAL: could not force \'LVS GLOBALS ARE PORTS NO\'."'
NEW5 = 'echo "FATAL: could not force \'LVS GLOBALS ARE PORTS YES\'."'


def md5(p):
    return hashlib.md5(open(p, "rb").read()).hexdigest()


def main():
    pre = md5(SH)
    print("PATCH pre_md5=%s (expect %s)" % (pre, EXPECT_MD5))
    if pre != EXPECT_MD5:
        print("PATCH status=MD5_MISMATCH -- refusing")
        return 1
    t = open(SH, encoding="utf-8", errors="surrogateescape").read()
    for old, new in ((OLD1, NEW1), (OLD2, NEW2), (OLD3, NEW3), (OLD4, NEW4), (OLD5, NEW5)):
        n = t.count(old)
        print("PATCH anchor hits=%d : %s" % (n, old.strip()[:60]))
        if n != 1:
            print("PATCH status=ANCHOR_COUNT_INVALID")
            return 1
        t = t.replace(old, new)
    bakdir = os.path.join(PC, "scripts", ".bak_globals")
    os.makedirs(bakdir, exist_ok=True)
    stamp = time.strftime("%Y%m%d_%H%M%S")
    shutil.copy2(SH, os.path.join(bakdir, "run_lvs_paper_core.sh.%s" % stamp))
    open(SH, "w", encoding="utf-8", errors="surrogateescape").write(t)
    print("PATCH backup=%s/run_lvs_paper_core.sh.%s" % (bakdir, stamp))
    print("PATCH post_md5=%s" % md5(SH))
    print("PATCH status=OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
