# SAR16 cloud EDA environment, 2026-10-05

## Verified toolchain

All tools are installed in this cloud workspace. No local Mac changes, system package installation, repository pushes, commercial libraries, or paid services were used.

| Command | Pinned version / source |
|---|---|
| `openroad` | `26Q2-1164-g08f67ee5ec`, official-project-endorsed Precision Innovations VaultLink Ubuntu24.04 binary; includes OpenSTA, OpenRCX, global/detailed placement and routing |
| `yosys-native` | Debian `0.52-2`, Yosys commit `fee39a3284c90249e1d9684cf6944ffbbcbb8f90` |
| `yosys`, `yosys-smtbmc`, `sby` | YoWASP package `0.69.0.0.post1233`, Yosys `0.69`, commit `9f75ca1f9`; SBY is bundled and prints `unknown SBY version`, so the exact containing wheel and SHA256 are locked |
| `z3` | `5.1.0`, Python distribution `z3-solver==5.1.0.0` |
| `iverilog`, `vvp` | Debian Icarus Verilog `12.0-2+b1` |
| `verilator` | Debian `5.032-1+b2` |
| `sta` | Debian OpenSTA `0~20191111gitc018cb2+dfsg-1.1`, executable reports `2.0.17`; physical runs use OpenROAD's newer embedded STA |

The host is Linux x86_64, Debian13, glibc2.41, shared CPython3.12.14. Standard host utilities (`bash`, `curl`, `git`, `dpkg-deb`, `make`, `g++`, `tclsh`) are prerequisites. The installer requires a shared-library CPython3.12 installation and discovers its actual runtime prefix; it does not use the compiled-in `/install/lib` path.

## Use and reproduce

```bash
source environment/env.sh
environment/setup.sh --verify-downloads
environment/smoke.sh
```

For a fresh equivalent Linux cloud workspace, retain this folder's scripts, lock files, download manifest and smoke sources, then run `environment/setup.sh`. It downloads only exact hash-locked active Debian/OpenROAD artifacts, extracts them without `sudo`, installs hash-locked Python packages, and checks out the exact public platform commit. If the cached downloads are included, they are verified and reused. The setup code has syntax and artifact-integrity checks; a second fully clean host was not provisioned. The actual installed environment and aggregate smoke script were exercised here.

`YOSYS_EXE` selects native0.52 for fast synthesis; plain `yosys` selects0.69 for compatibility with bundled SBY. Latest ORFS's complete Makefile flow asks for Yosys>=0.58. This task uses explicit Yosys/OpenROAD scripts rather than claiming compatibility with every latest ORFS target.

## Public platform pins and limits

OpenROAD-flow-scripts: `ad11cc9f8cc8bde9946200cafc21bae265067188` from https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts

- Nangate45: matched typical1.1V Liberty, technology/cell LEF, track/RC scripts and OpenRCX rules. Apache2 platform license. A public predictive45nm flow-validation proxy, not the user's180nm process
- GF180MCU: matched LEF, RCX models and 7T/9T Liberty at multiple PVT points, including TT25°C/1.8V. The supplied cell files carry Apache2 headers. The `mcu7t5v0`/`mcu9t5v0` families use5V-class devices; choosing a1.8V characterization file does not make them equivalent to SMIC180nm1.8V cells. The ORFS platform's default is5V; every reported experiment must state its actual library and voltage
- No proprietary SMIC18 Liberty/LEF/RC or analog ADC/CDAC models were imported
- Neither a public proxy's routed layout nor its PPA proves SMIC18 signoff or reproduces the complete ADC paper's area, power, SNDR, ENOB or measured sample rate

## Environment smoke evidence

The checks are deliberately small tool-installation tests, separate from production SAR16 verification:

1. Icarus counter simulation: `SIMULATION_SMOKE_PASS`
2. Verilator counter lint and native Yosys standard-cell synthesis: passed;15 mapped Nangate45 logic/sequential cells
3. SBY+Z3 positive invariant: unbounded k-induction `PASS`
4. Deliberately false counter invariant: expected bounded `FAIL`, with VCD counterexample, confirming the assertion/trace path operates
5. OpenROAD: actual floorplan, pin placement, global/detailed placement, CTS, global routing, detailed routing, OpenRCX extraction, SPEF and postroute STA completed. Routed ODB/DEF/SPEF exist; detailed-router DRC output is empty. Example10ns clock setup slack is9.74ns. This is not foundry DRC/LVS, IR/EM or production signoff

Key logs are under `logs/`; `smoke.sh` requires explicit success markers and output files. OpenROAD can return process status0 after a Tcl error, so exit code alone is intentionally insufficient. This OpenROAD version no longer supports random pin placement through `place_pins -random`; the tested scripts omit that obsolete option.

## Provenance and integrity

- Native artifact URLs, exact versions, sizes and SHA256: `download-manifest.json`
- Python versions and wheel SHA256: `python-requirements-hashed.lock`
- Public Liberty/LEF/RC/script hashes: `platform-file-sha256.json`
- OpenROAD official installation guidance: https://openroad.readthedocs.io/en/latest/user/Build.html
- Endorsed binary route: https://github.com/Precision-Innovations/OpenROAD/releases → https://vaultlink.precisioninno.com/
- Selected binary SHA256: `f3f1eeaa18f327503f72cc45dcef5b1514ec2e89726ec53b4553bf4f951168a3`; vendor length and MD5 also matched before extraction
- Unused Ubuntu22 binary and optional Boost packages are marked inactive in the manifest, and are not needed by the reproduction script

The uncertain `openroad` PyPI package was not installed or executed. An official endorsed binary route was used instead.
