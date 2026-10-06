# Calibration trusted-reference storage optimization

## Result and scope

Accepted as a local RTL area optimization. The default design retains **all fourteen measured weights at their original 30-bit width**, the complete read view, the write-back interface, and the repaired controller's cycle-by-cycle behavior. Only `sar_calib_ctrl_serial.sv` changed. No frozen repair files, source repository state, remote branch, feedback algorithm, or external interface was changed by this work.

The six trusted weights are 256, 512, 1024, 2048, 4096, and 8192 in the original signed 30-bit representation. They previously consumed 180 resettable flip-flops because dynamically indexed writes hid the controller's write-index invariant from synthesis. They are now explicit constant generate assignments. Fourteen separate full-width measured-weight registers use decoded write enables. The existing indexed read expression remains a combinational multiplexer over the complete twenty-entry view.

The constant branch is enabled only for `CAP_NUM=20` and `MAX_CALIB_BIT=5`. Every other CAP/MAX combination uses a separate copy of the original reset loop and dynamically indexed write behavior. Other parameter guards are unchanged. The optimization's correctness depends only on the index range and on retaining exactly the original width-truncated `REF_WEIGHT_INIT <<< i` constants, not on calibration measurement accuracy.

## Matched synthesis comparison

Identical Yosys 0.52 recipe and Nangate45 typical Liberty, using `synth -flatten -noabc`, `dfflibmap`, `abc -liberty`, `hilomap`, and cleanup:

| Metric | Frozen repaired RTL | Optimized RTL | Reduction |
|---|---:|---:|---:|
| Physical mapped standard cells | 4,515 | 4,047 | 468 (10.3654%) |
| Flip-flops | 1,026 | 846 | 180 (17.5439%) |
| Mapped standard-cell area, µm² | 9,840.936 | 8,400.546 | 1,440.390 (14.6367%) |
| Flip-flop master area, µm² | 5,458.320 | 4,500.720 | 957.600 |
| Combinational/tie-cell area, µm² | 4,382.616 | 3,899.826 | 482.790 |
| Dynamic shadow-weight bits | 600 | 420 | 180 |
| Measured-weight bits | 420 | 420 | 0 |

The three `$scopeinfo` metadata cells in each Yosys JSON count are excluded from physical-cell counts. DFFR_X1 and DFFS_X1 are each 5.32 µm² in the actual Liberty. These figures are **mapped cell area**, not placement utilization, routed area, core area, or die area. ABC receives only Liberty, exactly as in the baseline; the original 10 ns / 3 ns clocks, 50 fF maximum output load, and min/max I/O SDC belong to the downstream physical comparison and were not relaxed by this optimization.

## Formal correctness argument

1. **Original invariant, before implementation:** on the untouched repaired calibration RTL, formal assertions prove that `target_bit` and `wr_idx_r` remain 6..19 after reset, every write address is above MAX_CALIB_BIT, and each trusted weight retains its exact reset constant. SAT temporal induction passed at induction depth one. No constraint was imposed on start or comparator inputs.
2. **Explicit state relation:** the normalized original calibration block has 904 state bits. The candidate has 724. Every retained bit is matched through its semantic signal aliases. The 180 removed original bits are related to their proven constants. All 724 retained reset values and all 180 removed reset constants are checked against the actual normalized FF types.
3. **Inductive transition and outputs:** combinational SAT passed 2,364 named obligations: equal retained next-state data, clock and asynchronous-reset inputs, preservation of removed constant state, preservation of the index range, and equality of all 100 public output bits. Apart from the independently proved index/constants invariant, all retained state and external inputs are arbitrary. No measurement-value, comparator-polarity, start-pulse, or numerical-range restriction is used.
4. **Actual uncut reset base:** a separate SAT proof on the full uncut original and candidate models verifies all state correspondences, removed constants, and outputs with the common active-low reset asserted. This establishes the base of the sequential-equivalence argument independently of reset-value bookkeeping.
5. **Negative control:** an isolated candidate mutation XORs bit 0 of every measured-weight write. The same proof fails and emits a counterexample. Production RTL is never mutated.

Together, reset base plus invariant/transition preservation proves cycle-by-cycle sequential equivalence after a common reset. Inputs may vary arbitrarily at every sampled clock; restart and later resets are included. This is two-state RTL reasoning with a reset observed at least once. It does not claim pre-reset equivalence of unknown power-up state, metastability modeling, fault tolerance, X-injection, analog fidelity, or SDF gate-level equivalence.

## Parameter checks

Three extra configurations passed state-relation SAT, original invariant induction, and actual uncut reset-base SAT:

- Fallback lower legal boundary: MAX_CALIB_BIT=0; all 904 state bits retained
- Fallback upper legal boundary: MAX_CALIB_BIT=15; all 904 state bits retained
- Alternate constant-branch configuration: WEIGHT_WIDTH=31, COMP_WAIT_CYC=4, AVG_LOOPS=1, REF_WEIGHT_LSB=512, ROUND_HALF_LSB=0, DETECT_OVERRANGE=0; 919→733 state bits, removing exactly six times 31 bits

These are targeted formal elaborations, not a claim that every integer parameter combination has been exhaustively enumerated. The fallback explicitly preserves the original behavior rather than silently treating an unsupported configuration as the default.

## Regression results

- Original default calibration control/rank: 12-frame BMC PASS; temporal induction PASS
- Original calibration publication/rearm: 12-frame BMC PASS; temporal induction PASS
- Calibration start/search covers: PASS
- Original full-core smoke: PASS, 166 checks; two complete sweeps each publish addresses 6..19 exactly once and satisfy sticky-done/pulse/restart checks
- Exact rank remains 207,352 active control edges. The smoke bench's later observation window reports 207,350 wait cycles for each sweep; these are different start points, not a latency change
- Original SRM adversarial: PASS, 39 checks, both Verilator and Icarus
- Original SRM latency: PASS, 1,200 samples across 12 phase offsets; accepted-to-done 120 ns and accepted-to-ready 140 ns
- Lint: PASS with exactly the same 25 baseline warning messages
- Optional extra Icarus full-core attempt: blocked by the same eight pre-existing enum-ternary elaboration errors in both frozen baseline and candidate. No full-core four-state simulation pass is claimed; the required full-core regression is the passing Verilator bench
- Evidence verifier: 34 checks PASS, including frozen source identities and unchanged original files

The original protocol testbench explicitly excludes numerical calibration-accuracy acceptance. The paper feedback/estimator algorithm is unchanged and is **not claimed complete or repaired** by this area change.

## Frozen identity

Optimized calibration SHA-256:
`bff398bd6e1e99b9008b39a673c252caa389e6ea50d4f51d3d7e1d6de9e6ea1d`

Original repaired calibration SHA-256:
`8e7fe237eb2f3fe66b2d1017d00dbfb1bdd22a42ce640222bd2dbfbbdae3fa4c`

Exact mapped Verilog SHA-256:
`607fe520c82edab4b9cb955821c6fcd3c4b3baac78bd2c2cbf73b1e750877540`

The other three RTL hashes are unchanged and recorded in `reports/rtl_optimized.sha256` and `reports/summary.json`.

## Reproduce and inspect

From the existing SAR16 workspace, run `bash sar16_rework_20261005/optimization/run_all.sh`. The script uses the pinned local tools, frozen repaired baseline, and frozen optimized candidate. It regenerates proofs, parameter checks, the deliberately failing negative control, original calibration proofs/regressions, and matched synthesis. It does not push, alter RTL, or run placement/routing. `scripts/create_candidate.py` documents the exact source transformation separately; `reports/rtl_optimization.patch` is the direct patch.

Key evidence:

- `reports/summary.json`, `synthesis_comparison.json`, `parameter_results.json`, `negative_control.json`, `evidence_validation.json`
- `formal/baseline_invariant.sv/.ys`; `logs/baseline_invariant.log`
- `formal/storage_equivalence.sv/.ys`, actual normalized JSON models, and exhaustive `storage_equivalence_coverage.json`; `logs/storage_equivalence.log`
- `formal/reset_base.sv/.ys` and uncut sequential models; `logs/reset_base.log`
- `negative_control/formal/counterexample.vcd` and failing proof log
- `formal_regression/harness`, `formal_regression/logs`, and cover traces
- `regression/tests` and `regression/logs`
- `synthesis/scripts/synth.ys`, mapped/unmapped models, `synthesis/logs/synthesis.log`, and `synthesis/reports/synth_stats.json`

Candidate RTL→mapped→routed technology-mapped equivalence and final floorplan/routing metrics are separate evidence owned by the equivalence and compact-backend workstreams. This report does not substitute synthesis results for those checks.
