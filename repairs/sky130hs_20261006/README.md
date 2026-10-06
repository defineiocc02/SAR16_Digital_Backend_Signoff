# SAR16 repaired RTL and SKY130HS physical closure, 2026-10-06

This is a new, frozen **public SKY130HS 1.8 V digital-core** repair and verification result. It does not replace the historical SMIC180 artifacts elsewhere in this repository or imply that their signoff gaps are closed. The final candidate is [`signoff_20261006/candidate_v2_diodefree`](signoff_20261006/candidate_v2_diodefree). Original reports and proof inputs are retained byte-for-byte.

## Start here

- [Four-page Chinese final PDF](signoff_20261006/delivery/SAR16_SKY130HS_DRC_LVS_Final_20261006.pdf), [editable DOCX](signoff_20261006/delivery/SAR16_SKY130HS_DRC_LVS_Final_20261006.docx)
- [Full DRC/LVS results and limits](signoff_20261006/README_DRC_LVS.md), [machine-readable final summary](signoff_20261006/signoff_summary.json)
- [Exact physical edits](signoff_20261006/candidate_v2_diodefree/PHYSICAL_REPAIR_REPORT.md), [final routed overview](signoff_20261006/candidate_v2_diodefree/images/01_routed_full.png)
- [Native GDS](signoff_20261006/candidate_v2_diodefree/results/candidate.gds), [OpenDB](signoff_20261006/candidate_v2_diodefree/results/routed.odb), [DEF](signoff_20261006/candidate_v2_diodefree/results/routed.def), [routed Verilog](signoff_20261006/candidate_v2_diodefree/results/routed.v), [power-aware Verilog](signoff_20261006/candidate_v2_diodefree/results/source.pg.v), [SPEF](signoff_20261006/candidate_v2_diodefree/results/routed.spef), [SDC](signoff_20261006/candidate_v2_diodefree/results/routed.sdc), [SDF](signoff_20261006/candidate_v2_diodefree/results/routed.sdf)
- [Digital proof report](signoff_20261006/equivalence_candidate_v2_diodefree/report.md), [raw extracted LVS](signoff_20261006/verification/candidate_v2_diodefree/reports/netgen_lvs.out), [all frozen file hashes](publication_manifest.json)

## Repairs and observed results

- SRM generation handshakes prevent stale completion/restart mispairing: [source patch](srm_generation_handshake.patch)
- Default calibration trusted weights 0..5 become constants, removing 180 flip-flops while retaining the nondefault parameter fallback: [optimization patch](recovered/SAR16_Rework_Core_20261005/sar16_rework_20261005/optimization/reports/rtl_optimization.patch), [proof and parameter scope](recovered/SAR16_Rework_Core_20261005/sar16_rework_20261005/optimization/REPORT.md)
- Physical repair inserts 8,900 official fillers, repairs three CLK local-interconnect accesses, removes eight diodes and replaces their protection with actual layer-jump routing
- Final merged GDS: Magic `drc(full)` 0; KLayout BEOL/off-grid 0; strict extracted Netgen LVS uniquely matches with **zero property errors**, 4,335 nets and 4,301 functional cell instances on both sides
- Final original timing/electrical/CDC/PG/SPEF/router gates pass; fresh antenna is 0 nets / 0 pins with original rules and gate/diffusion areas unchanged
- All 9 default-parameter full-design formal jobs pass, including five expected-counterexample controls; no functional blackboxes

Nominal setup/hold WNS: **+1.062018 / +0.153111 ns**. Scalar-stress setup/hold: **+0.947274 / +0.050880 ns**. Scalar stress is the original 0.9/1.1 derating, not foundry PVT/OCV signoff. Die remains 392.98 × 392.98 µm.

Final routed Verilog SHA256: `b6b2f6ab56f5d565d26b2ccacfcb1af9e751b0bf1100595bb16942449e35cce5`  
Final GDS SHA256: `bc8f2590c514a8f8bfb819057fcf0f848fc8107b0726860d7581b8bcdadd8c4b`

## Checks from a normal clone

From the repository root, Python 3.9+, Bash and standard Linux tools suffice for the frozen-integrity checks:

```sh
make sky130hs-check
```

This checks every delivered hash, original 72-file proof manifest, raw DRC/LVS records, all nine proof-result markers/negative witnesses, independent GDS geometry binding, and Python/Bash syntax. Its own negative tests detect changed/missing files, symlinks and path escape. It **does not rerun EDA tools**.

For the repaired RTL regression, install Verilator 5, Icarus Verilog, make and a C++ compiler, then:

```sh
make sky130hs-rtl
# Or retain new logs in a chosen empty directory:
python3 tools/run_sky130hs_rtl_regression.py --output /tmp/sar16-rtl-check
```

Fresh publication replay passed lint, 39 adversarial SRM checks, 1,200 samples at 12 phases, 166 full-core checks/two calibration sweeps, and an independent 39-check Icarus run. GitHub Actions runs these checks on each push; the heavyweight physical/formal tools are not installed by CI.

## Formal replay without overwriting evidence

The archived proof drivers and config are unchanged. Use the portable wrapper with the exact pinned SKY130HS platform and Yosys/OpenROAD environment:

```sh
source /path/to/pinned/environment/env.sh
python3 tools/replay_sky130hs_formal.py \
  --platform "$SKY130HS_ROOT" --output /tmp/sar16-formal-check
```

The wrapper remaps **paths only**, checks original source-role hashes, reruns all nine original jobs and coverage audits, then verifies a fresh ODB export against both frozen Verilog files. This exact wrapper was successfully exercised against this repository's relocated source tree before publication. Archived evidence remains unchanged; newly generated reports go only to the new output directory.

The older optimization `run_all.sh` and generated `.ys` files are historical recipe/evidence with original paths and some omitted intermediate models. They are not advertised as a portable standalone command. The current full-design formal wrapper proves optimized RTL to the actual final netlist; it does not independently prove analog calibration accuracy.

## Full physical replay and public dependencies

Compiled tools, download caches, whole vendor source trees and bulk PDK files are intentionally excluded. Native design outputs contain publicly licensed HS cell geometry/technology; notices are in [licenses](licenses/README.md). Exact public URLs, commits, download SHA256s and used input hashes remain in `environment/`, `signoff_20261006/tools/` and `signoff_20261006/pdk/`.

Use a **new runtime copy**, leaving the repository's frozen evidence intact. On a compatible Linux x86_64 system with shared CPython 3.12, Debian 13 C/C++ runtime/build dependencies, Git, curl and dpkg-deb:

```sh
python3 tools/prepare_sky130hs_runtime.py --output /tmp/sar16-runtime
python3 tools/fetch_sky130hs_sources.py --bundle-root /tmp/sar16-runtime --fetch
bash /tmp/sar16-runtime/environment/setup.sh
python3 tools/restore_sky130hs_tools.py --bundle-root /tmp/sar16-runtime --install
export PDK_ROOT=/tmp/sar16-runtime/signoff_20261006/pdk
bash /tmp/sar16-runtime/signoff_20261006/candidate_v2_diodefree/reproduce_physical_candidate.sh \
  /tmp/sar16-runtime/signoff_20261006/candidate_github_replay
bash /tmp/sar16-runtime/signoff_20261006/scripts/verify_variant.sh github_replay \
  /tmp/sar16-runtime/signoff_20261006/candidate_github_replay/results/routed.def \
  /tmp/sar16-runtime/signoff_20261006/candidate_github_replay/results/routed.odb
```

The public-source fetcher checks pinned official sources and rebuilds unchanged PDK views; installation remains explicit. Runtime relocation changes only three path-bearing configuration/import files, retaining `.archive_original` copies and a relocation audit. Source builds are host-specific. The original full physical replay and separate empty-directory restore/strict LVS were executed; these new public-download helpers have syntax/static validation, but a second clean OS tool installation was **not** provisioned.

`run_v6` and the two before/after reference GDS streams under `signoff_20261006/results` and `candidate_v1` are **nonfinal reference inputs** required by replay and images. They are explicitly labeled. Failed/intermediate candidate outputs, earlier platform experiments, paper PDFs, private notes, commercial PDKs and tool binaries are not published.

## Scope limits

This is public-rule, digital-core validation, not proprietary foundry tapeout signoff, SMIC180 certification, full ADC/SNDR/ENOB verification, or synchronizer MTBF proof. The official density tool requires ≥700 × 700 µm; this standalone block needs density verification after top-level integration. Existing engineering assumptions and all detailed limits remain in the source reports.
