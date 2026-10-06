#!/usr/bin/env python3
"""Replay the frozen SAR16 RTL regressions without overwriting evidence.

Requires Python 3.9+, Verilator (tested with 5.032), a C++ compiler/make,
Icarus Verilog and vvp (tested with 12.0). Uses tools already on PATH.
No PDK, network access, or Python packages are needed.

From the repository root:
    python3 tools/run_sky130hs_rtl_regression.py --output /tmp/sar16-regression

An omitted --output creates a unique temporary directory. A specified output
directory must be empty. --rtl-dir and --tests-dir allow an unstaged local replay.
This is digital protocol/latency testing, not analog or physical signoff.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time


RTL_SHA256 = {
    "sar_digi_paper_core.sv": "cfb3548a9aa6e6bfa3d9395f02c5695d12e075415931185db8da461804139022",
    "sar_calib_ctrl_serial.sv": "bff398bd6e1e99b9008b39a673c252caa389e6ea50d4f51d3d7e1d6de9e6ea1d",
    "srm_residue_estimator.sv": "113265c69b6fa7550906c17290a66b7507f51221231751a99d72a8f580f110de",
    "srm_residue_lut.sv": "d3335201c8de1692e31cab9f28b8a9862ffbace3710529599ac8f241ed98bbdf",
}
BENCHES = {
    "tb_srm_repair": "SRM_REPAIR_PASS checks=39",
    "tb_srm_latency": "SRM_LATENCY_EXPERIMENT_PASS phases=12 normal_samples=1200",
    "tb_sar16_smoke": "SAR16_SMOKE_PASS checks=166",
}


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    repo = Path(__file__).resolve().parents[1]
    bundle = repo / "repairs/sky130hs_20261006"
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--rtl-dir", type=Path, default=bundle / "recovered/SAR16_Rework_Core_20261005/sar16_rework_20261005/repo/rtl_optimized")
    parser.add_argument("--tests-dir", type=Path, default=bundle / "rtl_regression/tests")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--jobs", type=int, default=min(4, os.cpu_count() or 1))
    parser.add_argument("--timeout", type=int, default=300, help="Maximum seconds per compile or simulation")
    args = parser.parse_args()
    if args.jobs < 1 or args.timeout < 1:
        parser.error("--jobs and --timeout must be positive")
    rtl, tests = args.rtl_dir.resolve(), args.tests_dir.resolve()
    for name, expected in RTL_SHA256.items():
        source = rtl / name
        if not source.is_file() or digest(source) != expected:
            parser.error("Frozen RTL missing or checksum mismatch: " + str(source))
    for name in BENCHES:
        if not (tests / (name + ".sv")).is_file():
            parser.error("Missing testbench: " + str(tests / (name + ".sv")))
    executables = {}
    for name in ("verilator", "iverilog", "vvp"):
        executable = shutil.which(name)
        if not executable:
            parser.error("Required executable is not on PATH: " + name)
        executables[name] = executable
    if args.output is None:
        output = Path(tempfile.mkdtemp(prefix="sar16-rtl-regression-"))
    else:
        output = args.output.resolve()
        if output.exists() and (not output.is_dir() or any(output.iterdir())):
            parser.error("--output must name a new or empty directory")
        output.mkdir(parents=True, exist_ok=True)
    logs = output / "logs"
    logs.mkdir()
    result = {
        "status": "RUNNING",
        "rtl_sha256": RTL_SHA256,
        "testbench_sha256": {name + ".sv": digest(tests / (name + ".sv")) for name in BENCHES},
        "tool_versions": {},
        "checks": [],
        "scope": "Frozen optimized RTL digital protocol and latency regression; no analog accuracy, physical CDC/RDC, SDF, or silicon signoff claim",
    }

    def run(label, command, marker=None):
        started = time.monotonic()
        log = logs / (label + ".log")
        print("Running " + label, flush=True)
        timed_out = False
        with log.open("w") as handle:
            try:
                process = subprocess.run(command, cwd=output, stdout=handle, stderr=subprocess.STDOUT, timeout=args.timeout)
                code = process.returncode
            except subprocess.TimeoutExpired:
                code, timed_out = None, True
        text = log.read_text(errors="replace")
        passed = code == 0 and (marker is None or marker in text)
        if label == "tb_sar16_smoke":
            passed = passed and text.count("CALIB_PROTOCOL_PASS writes=14") == 2
        result["checks"].append({
            "name": label, "status": "PASS" if passed else "FAIL",
            "returncode": code, "timed_out": timed_out,
            "elapsed_seconds": round(time.monotonic() - started, 3),
            "log": "logs/" + log.name,
            "expected_marker": marker,
        })
        if not passed:
            raise RuntimeError(label + " failed; see " + str(log))
        for line in text.splitlines():
            if "PASS" in line or "EARLY_STREAM" in line:
                print(line, flush=True)

    print("Results: " + str(output), flush=True)
    try:
        for name, flag in (("verilator", "--version"), ("iverilog", "-V"), ("vvp", "-V")):
            version = subprocess.run([executables[name], flag], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=30)
            result["tool_versions"][name] = version.stdout.splitlines()[0] if version.stdout else "unreported"
        sources = [str(rtl / name) for name in RTL_SHA256]
        run("lint", [executables["verilator"], "--lint-only", "--timing", "-Wno-fatal", "--top-module", "sar_digi_paper_core"] + sources)
        for name, marker in BENCHES.items():
            build = output / ("build_" + name)
            run(name + "_build", [executables["verilator"], "--binary", "--timing", "-Wno-fatal", "-j", str(args.jobs), "--top-module", name, "--Mdir", str(build)] + sources + [str(tests / (name + ".sv"))])
            run(name, [str(build / ("V" + name))], marker)
        simulation = output / "tb_srm_repair.vvp"
        run("icarus_repair_build", [executables["iverilog"], "-g2012", "-s", "tb_srm_repair", "-o", str(simulation), str(rtl / "srm_residue_estimator.sv"), str(rtl / "srm_residue_lut.sv"), str(tests / "tb_srm_repair.sv")])
        run("icarus_repair", [executables["vvp"], str(simulation)], BENCHES["tb_srm_repair"])
        result["status"] = "PASS"
    except (OSError, RuntimeError, subprocess.TimeoutExpired) as error:
        result["status"] = "FAIL"
        result["error"] = str(error)
        print(str(error), file=sys.stderr)
    finally:
        (output / "summary.json").write_text(json.dumps(result, indent=2) + "\n")
    print("SAR16_RTL_REGRESSION_" + result["status"], flush=True)
    return 0 if result["status"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
