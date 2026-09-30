#!/usr/bin/env python3
"""Run the SRM timing experiment with two immutable baseline RTL sources."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
REPO = HERE.parent
DESTINATION = REPO / 'build/ppa'


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
               REPO/'evidence/rtl_baseline/srm_residue_lut.sv', REPO/'tests/tb_srm_latency.sv']
    DESTINATION.mkdir(parents=True, exist_ok=True)
    for name in ('latency_run.log', 'latency_result.json', 'netlist_register_inventory.json',
                 'ppa_comparison_numbers.json', 'source_hashes.json'):
        (DESTINATION/name).unlink(missing_ok=True)
    with tempfile.TemporaryDirectory(prefix='sar16-ppa-') as directory:
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
                   '--top-module', 'tb_srm_latency', '-j', '2', '--Mdir', 'obj',
                   *[source.name for source in sources]]
        with (DESTINATION/'latency_build.log').open('w', encoding='utf-8') as log:
            subprocess.run(command, cwd=stage, env=environment, stdout=log,
                           stderr=subprocess.STDOUT, check=True, timeout=180)
        result = subprocess.run([str(stage/'obj/Vtb_srm_latency')], cwd=stage,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                check=False, text=True, timeout=30)
    (DESTINATION/'latency_run.log').write_text(f'SIMULATOR version={version}\n'+result.stdout,
                                            encoding='utf-8')
    print(result.stdout, end='')
    result.check_returncode()
    if 'SRM_LATENCY_EXPERIMENT_PASS' not in result.stdout:
        raise ValueError('Missing experiment completion marker')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print(f'SRM_LATENCY_FAIL: {error}; inspect build/ppa/latency_build.log and latency_run.log',
              file=sys.stderr)
        sys.exit(1)
