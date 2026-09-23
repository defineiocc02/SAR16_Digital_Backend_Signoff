#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Organise the handover working directory into tools / docs / probes / evidence,
and drop binaries that merely duplicate what already lives in the VM project or
the delivery package.
"""
import hashlib
import os
import shutil
import sys

H = r"E:\ReedLab\tmp\sar16_handover"

TOOLS = ["gds_census_mine.py", "gds_query.py", "label_census.py", "rail_net.py",
         "stub_via.py", "m2_component.py", "full_connect.py", "all_layer_connect.py",
         "short_to_layer.py", "short1_layers.py", "lef_census_mine.py", "lef_exact.py",
         "lef_caliber.py", "port_accounting.py", "ports_v50.py", "verify_pins_clear.py",
         "chk_html.py", "make_handover_report.py", "tidy_sar16.py", "refcheck.py",
         "fix_refs.py", "recalc_manifest.py", "patch_pinfix.py", "patch_globals.py",
         "inventory_host.py", "inspect_cleanup.py", "pull_rpt.sh", "pull_rpt2.sh",
         "run_lvs_only.sh", "wait_v51.sh"]
DOCS = ["00_接手验收_只读复核.md", "01_LVS根因定位_第1轮.md",
        "02_接口收窄与短路确证_第2轮.md", "03_短路清零_第3轮.md",
        "cleanup_manifest.json"]
# pulled binaries that duplicate the VM / delivery package -> drop locally
DROP = ["rpt_v51/sar_digi_paper_core_merged.gds", "rpt_v51/sar_digi_paper_core.gds",
        "v50/sar_digi_paper_core_merged.gds", "v51/sar_digi_paper_core_merged.gds"]


def main():
    run = "--run" in sys.argv
    for sub in ("tools", "docs", "probes", "evidence"):
        p = os.path.join(H, sub)
        if run:
            os.makedirs(p, exist_ok=True)
        print("dir  %s" % sub)

    moved = 0
    for name in TOOLS:
        s = os.path.join(H, name)
        if os.path.exists(s):
            print("  %-40s -> tools/" % name)
            if run:
                shutil.move(s, os.path.join(H, "tools", name))
            moved += 1
    for name in DOCS:
        s = os.path.join(H, name)
        if os.path.exists(s):
            print("  %-40s -> docs/" % name)
            if run:
                shutil.move(s, os.path.join(H, "docs", name))
            moved += 1

    # probe scripts + their captured output
    for f in sorted(os.listdir(H)):
        p = os.path.join(H, f)
        if os.path.isfile(p) and (f.startswith("p") and (f.endswith(".sh") or f.endswith(".out"))
                                  or f.startswith("_") or f in (
                                      "census.txt", "lef.txt", "lef_exact.txt", "lef_caliber.txt",
                                      "chk.out", "recalc.out", "tidy_dry.out", "tidy_run.out",
                                      "inv_host.out", "inspect.out", "refcheck.out",
                                      "fixrefs.out", "mkreport.out", "mkreport2.out",
                                      "run2.out", "run_result.out", "run_result2.out",
                                      "run_check.out", "lock_check.out", "ports.out",
                                      "upload_verify.out", "backup.out", "patch_pinfix.out",
                                      "patch_pinfix2.out", "patch_globals.out", "p14b.out",
                                      "p15b.out", "p15c.out", "repro_launch.out",
                                      "repro51_launch.out", "v51_result.out", "lvs_globals.out",
                                      "gds_query.out", "label_census.out", "rail_net.out",
                                      "stub_via.out", "m2_component.out", "full_connect.out",
                                      "all_layer.out", "short_to_layer.out", "short1_layers.out",
                                      "v50_pins.out", "v51_pins.out", "verify_old.out",
                                      "ports_v50.out", "cleanup.out", "md5check.out",
                                      "scripts_scan.out", "pull_rpt.out", "pull_rpt2.out",
                                      "p4.out", "p5.out", "p6.out", "p7.out", "p8.out",
                                      "p9.out", "p10.out", "p11.out", "p12.out", "p13.out",
                                      "p14.out", "p15.out", "p16.out", "p17.out", "p18.out",
                                      "p19.out", "p20.out", "p1_lvs_probe.out",
                                      "p2_device_acct.out", "p3_shorts_diff.out",
                                      "gds_census_mine.out")):
            print("  %-40s -> probes/" % f)
            if run:
                shutil.move(p, os.path.join(H, "probes", f))
            moved += 1

    # evidence trees stay, but pulled binaries go
    for rel in DROP:
        p = os.path.join(H, rel)
        if os.path.exists(p):
            print("  DROP %-36s (%s B, duplicates VM/delivery)" % (rel, os.path.getsize(p)))
            if run:
                os.remove(p)

    # remaining sub-trees -> evidence/
    for d in ("rpt_v51", "v50", "v51", "rtl_baseline", "sdc_baseline", "tb_baseline"):
        p = os.path.join(H, d)
        if os.path.isdir(p):
            print("  %-40s -> evidence/" % d)
            if run and not os.path.exists(os.path.join(H, "evidence", d)):
                shutil.move(p, os.path.join(H, "evidence", d))

    # catch-all: nothing but the four directories (and this organiser) may sit at the
    # root.  Round 34 added several one-off scripts and captured outputs after the first
    # tidy pass, so sweep whatever is left into probes/ (kept, not deleted: they are the
    # evidence trail for the conclusions in docs/).
    for f in sorted(os.listdir(H)):
        p = os.path.join(H, f)
        if not os.path.isfile(p) or f == os.path.basename(__file__):
            continue
        print("  %-40s -> probes/ (catch-all)" % f)
        if run:
            shutil.move(p, os.path.join(H, "probes", f))
        moved += 1

    if not run:
        print("\nDRY RUN")
        return 0

    tot = n = 0
    for dp, dn, fn in os.walk(H):
        for f in fn:
            tot += os.path.getsize(os.path.join(dp, f))
            n += 1
    print("\nafter: %d files / %.1f MB" % (n, tot / 1048576.0))
    return 0


if __name__ == "__main__":
    sys.exit(main())
