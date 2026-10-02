#!/usr/bin/env python3
"""Characterize RTL arithmetic and known protocol limitations without editing the baseline."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import re
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
REPO = HERE.parent
DESTINATION = REPO / 'build/rtl_review'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--verilator', default=os.environ.get('VERILATOR', 'verilator'))
    args = parser.parse_args()
    executable = shutil.which(args.verilator)
    if executable is None:
        raise ValueError(f'Verilator executable not found: {args.verilator}')
    version = subprocess.run([executable, '--version'], check=True, capture_output=True,
                             text=True, timeout=10).stdout.strip()
    sources = [REPO/'evidence/rtl_baseline/srm_residue_estimator.sv',
               REPO/'evidence/rtl_baseline/srm_residue_lut.sv', REPO/'evidence/rtl_baseline/sar_calib_ctrl_serial.sv', REPO/'tests/tb_rtl_review.sv']
    locked = json.loads((REPO/'docs/baseline_manifest.json').read_text(encoding='utf-8'))['sha256']
    for source in sources[:3]:
        if hashlib.sha256(source.read_bytes()).hexdigest() != locked[str(source.relative_to(REPO))]:
            raise ValueError(f'Historical input changed: {source.name}')
    DESTINATION.mkdir(parents=True, exist_ok=True)
    for name in ('review_run.log', 'review_result.json'):
        (DESTINATION/name).unlink(missing_ok=True)
    with tempfile.TemporaryDirectory(prefix='sar16-review-') as directory:
        stage = Path(directory)
        if not directory.isascii():
            raise ValueError('An ASCII TMPDIR is required for the build')
        for source in sources:
            shutil.copyfile(source, stage/source.name)
        environment = os.environ.copy()
        runtime = environment.get('VERILATOR_ROOT')
        if runtime is None:
            candidate = Path(executable).resolve().parents[1]
            if (candidate/'include/verilated.mk').is_file():
                runtime = str(candidate)
        if runtime is not None and not runtime.isascii():
            (stage/'runtime').symlink_to(runtime, target_is_directory=True)
            environment['VERILATOR_ROOT'] = str(stage/'runtime')
        command = [executable, '--binary', '--timing', '--assert', '-Wall', '-Wno-fatal',
                   '-CFLAGS', '-std=c++20', '-MAKEFLAGS', f'PYTHON3={sys.executable}',
                   '--top-module', 'tb_rtl_review', '-j', '2', '--Mdir', 'obj',
                   *[source.name for source in sources]]
        if sys.platform == 'darwin':
            # The local bundled runtime has empty configure-time compiler fields.
            # Clang must read the generated .gch explicitly when this larger
            # bench is split into several translation units.
            command[1:1] = ['--compiler', 'clang', '-MAKEFLAGS',
                             'CFG_CXXFLAGS_PCH_I=-include-pch CFG_GCH_IF_CLANG=.gch']
        with (DESTINATION/'review_build.log').open('w', encoding='utf-8') as log:
            subprocess.run(command, cwd=stage, env=environment, stdout=log,
                           stderr=subprocess.STDOUT, check=True, timeout=180)
        result = subprocess.run([str(stage/'obj/Vtb_rtl_review')], cwd=stage,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                check=False, text=True, timeout=30)
    (DESTINATION/'review_run.log').write_text(f'SIMULATOR version={version}\n'+result.stdout,
                                            encoding='utf-8')
    print(result.stdout, end='')
    result.check_returncode()
    if 'RTL_REVIEW_CHARACTERIZATION_PASS' not in result.stdout:
        raise ValueError('Missing experiment completion marker')
    calibration = [dict(case=int(m[1]), target_lsb=float(m[2]), offset_lsb=float(m[3]),
                        loops=int(m[4]), round_half=bool(int(m[5])), measured_q8=int(m[6]))
                   for m in re.finditer(r'CAL_QUANT_REPRO case=(\d+) target_lsb=([\d.]+) '
                                        r'offset_lsb=([\d.]+) loops=(\d+) round_half=(\d+) '
                                        r'measured_q8=(\d+)', result.stdout)]
    if len(calibration) != 7 or {x['case'] for x in calibration} != set(range(7)):
        raise ValueError('Incomplete calibration characterization')
    boundaries = re.findall(r'^SRM_BOUNDARY_REPRO (.+)$', result.stdout, re.M)
    formats = re.findall(r'^LUT_FORMAT_REPRO (.+)$', result.stdout, re.M)
    if len(boundaries) != 3 or len(formats) != 2:
        raise ValueError('Incomplete protocol or format characterization')
    data = {'status': 'CHARACTERIZATION_PASS_KNOWN_LIMITATIONS_REPRODUCED',
            'scope': 'two-state zero-delay immutable leaf RTL, clk=10 ns dec_clk=3 ns; '
                     'calibration first writable target only, ideal reference weights 1..32 LSB',
            'simulator': version, 'calibration_cases': sorted(calibration, key=lambda x: x['case']),
            'srm_boundary_records': boundaries, 'lut_format_records': formats,
            'excludes': ['full calibrated CDAC', 'analog noise/settling', 'metastability',
                         'four-state X', 'gate-level SDF', 'physical signoff', 'RTL repair'],
            'sources_sha256': {str(p.relative_to(REPO)): hashlib.sha256(p.read_bytes()).hexdigest()
                               for p in sources + [Path(__file__).resolve()]}}
    (DESTINATION/'review_result.json').write_text(json.dumps(data, ensure_ascii=False, indent=2)+'\n',
                                               encoding='utf-8')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f'RTL_REVIEW_FAIL: {error}; inspect build/rtl_review/review_build.log and review_run.log',
              file=sys.stderr)
        sys.exit(1)
