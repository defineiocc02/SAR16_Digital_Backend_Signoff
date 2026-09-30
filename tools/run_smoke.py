#!/usr/bin/env python3
"""Build and run the standalone zero-delay RTL protocol smoke with Verilator."""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--verilator', default=os.environ.get('VERILATOR', 'verilator'))
    args = parser.parse_args()
    destination = ROOT / 'build/smoke'
    destination.mkdir(parents=True, exist_ok=True)
    for generated in ('run.log', 'result.json'):
        (destination / generated).unlink(missing_ok=True)
    version = subprocess.run([args.verilator, '--version'], check=True, capture_output=True,
                             text=True, timeout=10).stdout.strip()
    sources = sorted((ROOT / 'evidence/rtl_baseline').glob('*.sv'))
    # Verilator's generated makefiles can escape non-ASCII paths as octal text.
    # Stage only these five public sources in an ASCII temporary build directory.
    with tempfile.TemporaryDirectory(prefix='sar16-smoke-') as temporary:
        stage = Path(temporary)
        if not str(stage).isascii():
            raise ValueError('Verilator build requires an ASCII TMPDIR')
        for source in [*sources, ROOT / 'tests/tb_sar16_smoke.sv']:
            shutil.copyfile(source, stage / source.name)
        executable = shutil.which(args.verilator)
        if executable is None:
            raise ValueError(f'Verilator executable not found: {args.verilator}')
        environment = os.environ.copy()
        runtime = environment.get('VERILATOR_ROOT')
        if runtime is None:
            candidate = Path(executable).resolve().parents[1]
            if (candidate / 'include/verilated.mk').is_file():
                runtime = str(candidate)
        if runtime is not None and not runtime.isascii():
            alias = stage / 'runtime'
            alias.symlink_to(runtime, target_is_directory=True)
            environment['VERILATOR_ROOT'] = str(alias)
        command = [executable, '--binary', '--timing', '--assert', '-Wall', '-Wno-fatal',
                   '-CFLAGS', '-std=c++20', '-MAKEFLAGS', f'PYTHON3={sys.executable}',
                   '-DSIMULATION', '--top-module', 'tb_sar16_smoke', '-j', '2',
                   '--Mdir', 'obj', *[source.name for source in sources], 'tb_sar16_smoke.sv']
        with (destination / 'build.log').open('w', encoding='utf-8') as log:
            subprocess.run(command, cwd=stage, env=environment, stdout=log, stderr=subprocess.STDOUT,
                           check=True, timeout=180)
        result = subprocess.run([str(stage / 'obj/Vtb_sar16_smoke')], cwd=stage,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                check=False, text=True, timeout=60)
    (destination / 'run.log').write_text(result.stdout, encoding='utf-8')
    result.check_returncode()
    if 'SAR16_SMOKE_PASS' not in result.stdout:
        raise ValueError('Simulator exited without SAR16_SMOKE_PASS')
    (destination / 'result.json').write_text(json.dumps({
        'status': 'PASS', 'simulator': version, 'defines': ['SIMULATION'],
        'scope': 'zero-delay two-state RTL: LUT, raw export, SRM, calibration publish protocol',
        'excluded': ['metastability/CDC/RDC proof', 'four-state X propagation', 'SDF timing',
                     'calibration analog accuracy', 'full ADC ENOB/SNDR', 'physical signoff']
    }, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(result.stdout, end='')
    print('Logs: build/smoke/build.log, build/smoke/run.log, build/smoke/result.json')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f'SMOKE_FAIL: {error}; inspect build/smoke/build.log and run.log', file=sys.stderr)
        sys.exit(1)
