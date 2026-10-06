# Pinned SKY130HS environment restore

Restore completed on 2026-10-06. Source `env.sh` in Bash.

## Verified tool versions

- OpenROAD `26Q2-1164-g08f67ee5ec`, original Ubuntu 24.04 package
- Native Yosys `0.52`, Git `fee39a3284c90249e1d9684cf6944ffbbcbb8f90`
- ABC 1.01, compiled May 4 2025
- Icarus Verilog 12.0
- Verilator 5.032
- OpenSTA 2.0.17
- All six pinned Python dependencies restored with `--require-hashes`

All 12 active packages in `download-manifest.json` match their original SHA-256 values. No package version/hash substitutions were made. Inactive Ubuntu 22.04 OpenROAD and Boost downloads were not installed.

## Platform

- ORFS exact commit: `ad11cc9f8cc8bde9946200cafc21bae265067188`
- Clean sparse Git checkout: `tools/OpenROAD-flow-scripts`
- Platform: `$SKY130HS_ROOT`, which is `tools/OpenROAD-flow-scripts/flow/platforms/sky130hs`
- Main files: `lef/sky130_fd_sc_hs.tlef`, `lef/sky130_fd_sc_hs_merged.lef`, `lib/sky130_fd_sc_hs__tt_025C_1v80.lib`
- Original platform manifest contains no SKY130HS file hashes. No comparison to absent hashes is claimed. Exact Git commit verification and a fresh SHA-256 inventory are retained in `sky130hs-restored-file-sha256.json`.

## Fresh validation

`./smoke_sky130hs.sh` passed. It loads 11 technology layers, 25 vias, 390 LEF masters and 377 Liberty cells; maps a small counter to 14 SKY130HS cells with native Yosys/ABC; simulates it with Icarus; and runs Verilator lint. OpenROAD's obsolete LEF NAMESCASESENSITIVE warning is present; no error occurred.

SBY positive induction smoke passed with exit 0. Deliberately incorrect assertion failed with expected exit 2 and a counterexample trace. Fresh logs are `logs/sky130hs-openroad-smoke.log`, `logs/sky130hs-yosys-smoke.log`, `logs/iverilog-smoke.log`, `logs/restored-verilator-smoke.log`, `logs/restored-formal-positive.log` and `logs/restored-formal-negative.log`.

This task did not run SAR16 placement/routing or modify the SAR16 flow. Prior copied smoke logs are not fresh validation evidence. The legacy full `smoke.sh` assumes additional Nangate45 files that are not in this intentionally sparse restore; use `smoke_sky130hs.sh` for the current scope.

## Reproduction

`setup.sh` now performs the same sparse restore and retains original strict package and Python hashes. A shared-library CPython 3.12 runtime is needed; current runtime is 3.12.14 and its shared library path is recorded in `host-python-libdir.txt`. All tools and libraries are user-local, with no sudo or system-directory modification.

Use `yosys-native` for the pinned native 0.52 engine. `yosys`, `sby`, and `yosys-smtbmc` use the separately pinned WASM distribution from the original environment lock.
