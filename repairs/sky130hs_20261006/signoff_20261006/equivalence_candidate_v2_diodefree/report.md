# SAR16 whole-design sequential equivalence

Tool: Yosys 0.52 (git sha1 fee39a3284c90249e1d9684cf6944ffbbcbb8f90)

This is hash-scoped implementation-preservation evidence. It does not establish conformance to the paper's functional algorithm, calibration equations or analog performance. Any changed RTL revision requires new proofs.

## Verified results

| Comparison | Status | RTL/gold state bits | Gate state bits | Output bits | Step obligations | Reset obligations |
|---|---|---:|---:|---:|---:|---:|
| rtl_to_sky130hs_mapped | PASS | 843 | 846 | 146 | 2689 | 849 |
| sky130hs_mapped_to_sky130hs_routed | PASS | 846 | 846 | 146 | 2684 | 848 |

These are unbounded proofs by explicit induction and composition, not a bounded simulation or a standalone weak equiv_induct result. No actual mismatch was found. Every one of 20 functional output ports / 146 bits is covered; coverage_matrix.csv names every port and results/*_coverage.json names every individual bit/pin obligation. A routed netlist not listed above has not been proved.

## Proof construction

1. Read the exact frozen production RTL with default parameters, or the actual mapped/routed Verilog plus functional models imported directly from its pinned Liberty. Run checked process lowering, flattening, memory lowering and bit-level normalization. No RTL file is edited.
2. Enumerate every sequential bit. Non-FSM state correspondence uses original semantic signal names, not approximate matching or equal-valued simulation samples. Match all state bits, with no omitted state. The SRM FSM is explicitly related: RTL 0,4,2,1,5,3 maps to one-hot bits 0,1,2,3,4,5. All six codewords and reset encodings are checked.
3. For the inductive step only, replace each state output with an arbitrary defined symbolic state and instantiate both complete combinational cones. This is the stated induction hypothesis. Prove every FF D, clock and asynchronous-reset pin, every functional output bit, legal-FSM next-state closure and homogeneous FSM clock/reset. Reset polarities and constants are exhaustively checked by the generator. No functional output is cut or assumed.
4. The only restriction in RTL→mapped step proofs is legal SRM binary state 0..5. Its reset base and next-state closure are proved, not assumed without justification. No calibration range or payload constraints are needed.
5. Separately instantiate both uncut sequential designs. clk2fflogic preserves both independent sampled clock domains and asynchronous reset behavior. Force only rst_n=0 in global steps1..2, then prove the full state relation and that all state bits on both sides are defined at steps2..4. No DUT register is forced. Reset may change arbitrarily afterward.
6. Reset establishes the relation. Every possible clock/reset event preserves it because all transition data, edge polarities, clock/reset functions and reset values correspond; the encoded FSM relation is closed. All outputs agree under that relation. Induction gives all future digital events, and transitivity composes RTL→mapped→routed.

## Nonvacuity and negative controls

Five deliberately mutated local proof copies invert one functional output, one FF data input, one clock input, one asynchronous-reset input, and one encoded-FSM next-state bit. Every mutation produces a SAT counterexample and the -falsify run returns success for the expected rejection. Their witness JSON/VCD files are under results/negative_*_cex.*. They are harness validation tests, not bugs in the supplied netlists.

## Functional-cell and supply abstraction

All instantiated functional cell types resolve to Liberty-derived models. Imported cells with missing clock-gater functions are unused and do not survive hierarchy checking. Normalized gate models contain only the explicitly allowed Boolean primitives and resettable positive-edge FFs; no unresolved blackboxes or X/Z gate connections remain. Cell sizing, signal/clock buffers and tie cells are included through their logic functions. Cells without functional outputs, such as fillers, taps, endcaps and antennas, have no Boolean effect. This is not a power connectivity proof. Where SKY130HS tapvpwrvgnd is absent from Liberty, a separate pinned LEF audit establishes CORE WELLTAP with only VGND/VPWR power pins and zero functional outputs; its generated no-logic model is explicitly recorded in models/*_physical_only*. No functional cell is blackboxed.

## Scope and limits

- Only the exact hashed default-parameter source and actual supplied netlists; alternative parameters are unproved
- Defined primary inputs and nominal-power, zero-delay Liberty functional semantics
- Common reset low at the first two sampled global steps; equality/definedness holds at steps 2 through 4; later resets are arbitrary
- Clock levels are independent and unconstrained, with no fixed ratio or fairness assumption
- Yosys clk2fflogic uses its documented negative-hold-time asynchronous-reset convention when reset release coincides with a clock edge
- Equivalence preserves the RTL behavior; it is not an independent proof that calibration numerics, analog performance or every intended functional requirement is correct
- No source-level arbitrary-X propagation guarantee: standard synthesis normalization uses opt without keepdc
- No analog metastability, synchronizer MTBF, SDF timing, recovery/removal, power-integrity/connectivity, extracted-GDS equivalence or LVS conclusion

## Source hashes

The machine-readable authoritative manifest is source_manifest.json. Inputs are hashed before normalization and rechecked after every proof suite. Model hashes are recorded there. All proof scripts/logs are individually hashed in results/suite_results.json.

- `/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs/lef/sky130_fd_sc_hs_merged.lef`: `bcf8e2f0c90417b4002d2b96b348e63c806d69f6d44b9a465e0c830215b67a5a`
- `/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/environment/tools/OpenROAD-flow-scripts/flow/platforms/sky130hs/lib/sky130_fd_sc_hs__tt_025C_1v80.lib`: `0d10dd4e30a628ef692020af757593121eb4b93e69ee2a6f4f16d8630cfe3aeb`
- `/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/recovered/SAR16_Rework_Core_20261005/sar16_rework_20261005/repo/rtl_optimized/sar_calib_ctrl_serial.sv`: `bff398bd6e1e99b9008b39a673c252caa389e6ea50d4f51d3d7e1d6de9e6ea1d`
- `/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/recovered/SAR16_Rework_Core_20261005/sar16_rework_20261005/repo/rtl_optimized/sar_digi_paper_core.sv`: `cfb3548a9aa6e6bfa3d9395f02c5695d12e075415931185db8da461804139022`
- `/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/recovered/SAR16_Rework_Core_20261005/sar16_rework_20261005/repo/rtl_optimized/srm_residue_estimator.sv`: `113265c69b6fa7550906c17290a66b7507f51221231751a99d72a8f580f110de`
- `/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/recovered/SAR16_Rework_Core_20261005/sar16_rework_20261005/repo/rtl_optimized/srm_residue_lut.sv`: `d3335201c8de1692e31cab9f28b8a9862ffbace3710529599ac8f241ed98bbdf`
- `/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/run_v1/results/mapped.v`: `6a158f84c153d282d7210e074af238d80a63d6596c0790dab0f9dffeedc33ee3`
- `/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/signoff_20261006/candidate_v2_diodefree/results/routed.v`: `b6b2f6ab56f5d565d26b2ccacfcb1af9e751b0bf1100595bb16942449e35cce5`

## Reproduction

Source the pinned environment, set EQ_OUT to this evidence directory, and run the candidate-local runner (the original suite plus the audited CORE SPACER model extension):

```bash
source /workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/environment/env.sh
export EQ_OUT="/workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/signoff_20261006/equivalence_candidate_v2_diodefree"
python /workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/signoff_20261006/equivalence_candidate_v2_diodefree/driver/run_suite.py
python /workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/signoff_20261006/equivalence_candidate_v2_diodefree/driver/collect_report.py
python /workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/signoff_20261006/equivalence_candidate_v2_diodefree/driver/verify_evidence.py
python /workspace/scratch/5988101d3fa5/sar16_antenna_repair_20261006/signoff_20261006/equivalence_candidate_v2_diodefree/driver/finalize_candidate.py
```

config.json identifies exact source and library paths. A changed pinned input aborts reproduction; use a new evidence directory for a new design. Results apply only to the hashes above.


## Repaired candidate identity and filler support

The final repaired ODB exports routed.v and source.pg.v byte-for-byte. Identity is independently closed in identity/identity_final.json. This digital proof uses routed.v and makes no claim about power connectivity or extracted-GDS equivalence.

The four filler types are absent from Liberty. This candidate reuses the previously verified, candidate-local normalization extension without changing its proof semantics. The normalization helper admits explicitly enumerated CORE SPACER macros under the same strict pinned-LEF, power/ground-only, no-functional-pin audit as the existing WELLTAP model. All 8,900 filler instances are accounted for. The model contains no logic and is not a blackbox; no functional cell is abstracted. The exact diff is identity/normalization_extension.patch.

The induction, reset-base, negative-control, suite runner, coverage checks and report generator are byte-identical to the prior proof drivers. All nine proof gates were rerun successfully. No old proof, RTL or netlist was modified. For the complete guarded rerun including fresh ODB identity closure, use reproduce.sh in this evidence directory.
