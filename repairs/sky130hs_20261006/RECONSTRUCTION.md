# SKY130HS physical closure reconstruction — 2026-10-06

## Evidence preserved

The prior cloud runtime no longer contained the SAR16 job or EDA installation. The delivered SAR16_Rework_Core_20261005.zip was recovered from Library and its complete 438-file SHA256 manifest passed before any edits. Its SKY130HS subset contained only mapped.v, routed.v and final_summary.json. The native ODB, DEF, SPEF, SDC and implementation Tcl files were not delivered. The former final netlist was recovered exactly, SHA256 afaabd0b5a55b0981ac33148e2e52fcfa6c55fc01641e341931c782e62b95942.

This run is a fresh reconstruction on the same mapped logic and same die/core size, not an incremental edit of the lost geometry. No original physical layout identity is claimed. Original delivered files remain unchanged under recovered/; new artifacts are under run_v1/.

## Reconstructed choices

- Frozen native mapped.v SHA256 6a158f84c153d282d7210e074af238d80a63d6596c0790dab0f9dffeedc33ee3; no RTL function or calibration algorithm edits
- Native SKY130HS TT025C1v80 Liberty and matched LEF/OpenRCX platform at ORFS ad11cc9f8cc8bde9946200cafc21bae265067188
- Exact pinned OpenROAD 26Q2-1164-g08f67ee5ec; native Yosys0.52
- Fixed die 0,0–392.98,392.98µm and core12,13.32–380.64,379.62µm; 110rows×768sites, identical dimensions to prior summary
- Explicit strict digital contract: clk10ns, dec_clk3ns, max output load0.05pF=50fF, digital output min−0.5ns, no broad asynchronous-clock false paths; same13explicit CDC max-delay constraints and same targeted external async reset sink waiver only
- Delivered Nangate45 constraint template ported to native pF units. Native placement/CTS/routing commands adapted from delivered implementation helpers and the pinned SKY130HS platform because native flow was missing
- Reconstructed placement target density0.62, platform pin layers met3/met2, same edge pin grouping, platform tap distance14µm and PDN, platform routing met1–met5/signals and met3–met5/clocks,20%route-capacity adjustment
- CTS root clkbuf8, candidates clkbuf2/4/8/16; sink cluster20;0.9sink-cap derate
- Placement-estimated timing repair targets the same early0.9/late1.1scalar sensitivity; setup margin0.10ns and hold margin0.05ns,45%max buffer budget. These are repair objectives, not relaxed verification constraints
- Antenna repair uses supported jumper and native diode flow, up to5iterations,30%ratio margin. Final detailed geometry is checked again; global estimated pass alone is insufficient

## Prior antenna root cause

The prior report records met1 partial side-area ratio409.89>400 on net106→output107/A (raw_code_o[2]) and617.90>400 on net108→output109/A (raw_code_o[4]). These are internal branches at the small input gate of a sky130_fd_sc_hs__buf_1 output driver. A netlist audit confirms neither net106 nor net108 has a native antenna diode among the27inserted cells. The old geometry is unavailable, so its exact route length/via topology and the reason global-route prediction missed those detailed violations cannot be remeasured. There is no need to change the RTL algorithm to repair these physical charge-collection ratios.

## Limits preserved

This is a public1.8Vdigital process proxy, not SMIC18 or a full ADC implementation. OpenROAD explicitly skips unsupported LEF58_ENCLOSURE entries lacking CUTCLASS on mcon/via/via2/via3/via4. Passing supported router DRC is not full foundry DRC/LVS/PEX or tapeout signoff. Scalar0.9/1.1stress is not characterized multi-corner PVT/OCV. No analog interface signoff, MTBF, EM/IR/package/pads, calibrated ADC SNDR/power or paper-faithful calibration claim is made. Missing paper calibration choices remain pending.

## Actual closure iterations

1. run_v1: reconstructed placement/CTS and mixed jumper+diode repair at30%margin. Global antenna0, detailed antenna2 (_0827_/met1 at426.07/400 and net111/met1 at1186.42/400). Supported routerDRC0; extracted timing/electrical/CDC/reset/PG/SPEFpassed.
2. run_v2: added native diodes near _2775_/A1 and output112/A, rerouted. Previous two violations resolved, but3new detailed-route branches failed: _0934_/_2859_/A2 met1 at451.55/400, net99/output100/A met3 at1154.19/400, and net113/output114/A met1 at543.59/400. Timing/electrical and other checks passed.
3. run_v3: explicitly protected _2859_/A2 and used diode-only repair with50%ratio margin. The optional raw-output target enumerator selected no extra targets; the executed target list and every actual insertion are preserved in its log. Automatic repair inserted149additional native diodes over3iterations. Detailed antenna0, routerDRC0, timing/CDC/reset/PG/SPEFpassed. Two fanout nets rose from24functional loads to25including the diode input, failing the unchanged limit24.
4. run_v4: split12functional loads from each of fanout282/X and fanout292/X onto a dedicated native buf_4, leaving the original diode on the original branch. The new split nets are also rerouted and antenna-repaired, followed by fresh extraction and the entire strict audit. Final result is recorded separately, never inferred from an earlier pass.

Every failed intermediate result is preserved. No violation was suppressed to manufacture a pass. The50%antenna ratio margin is a stricter repair target, not a relaxed rule.

The run_v4 full-reroute retry was rejected: timing passed but one new antenna branch and two different fanout nets failed. A run_v5 localized-net experiment stopped at its explicit connectivity guard because appended ECO net-name suffixes made two selectors unresolved; copied input reports in that directory are explicitly marked stale and are not pass evidence.

The selected strategy was then changed to the supported OpenROAD post-DRT antenna repair flow: start from the complete run_v1 detailed wires, call repair_antennas on their actual measured geometry, then detailed_route, without deleting all signal wires or regenerating a global route. See run_v6/scripts/post_drt_antenna.tcl and its per-iteration reports. This preserves the legal placement and avoids treating global-route estimates as final antenna closure. Official reference: https://github.com/The-OpenROAD-Project/OpenROAD/blob/master/test/flow.tcl (post-DRT repair section); behavior and actual tool warnings are retained in the pinned local runtime logs.

## Selected result

run_v6 closes the complete supported physical proxy checks. Its supported post-DRT repair added4native diodes to the initial4, with no standard-cell movement reported by that antenna legalization. Its resulting detailed route has antenna0/DRC0, nominal setup/hold+1.062000/+0.153111ns, and scalar stress+0.947258/+0.050458ns. All existing electrical,13CDC/Gray-span, local-reset, PG-connectivity and connected-net SPEF gates pass. Its area is66920.2128µm² in5765instances, slightly below the prior recovered summary's67235.0976µm². The inherited die/core sizes and all verification constraints are unchanged. Final digital proof status is tracked separately in equivalence/candidate_final and the final summary.

## Replaying delivered evidence

Unzip the numbered delivery archives into the same directory, preserving their common root. Run `python3 verify_delivery.py` before any regeneration. Run `bash environment/setup.sh install` to restore pinned official dependencies if needed, then `bash reproduce.sh audit` for the frozen exact routed geometry, `bash reproduce.sh formal` for a fresh full digital proof of the delivered netlist, and `bash reproduce.sh render` for actual database images. `replay_formal.py` verifies all four frozen RTL and the mapped/final-netlist hashes before generating a fresh proof case.

For a physical rerun, use a new copy. The final pre-ECO reconstructed run_v1 routed.odb and the selected run_v6 post_drt_antenna.tcl are supplied. Starting from that pre-ECO database reproduces the exact scoped final repair flow; creating placement/routing again from mapped.v is a separate reconstruction and may produce different bytes. Every new output needs fresh extraction, checks, and formal proof; inherited hashes must never be used to certify changed geometry.

The PDK-input archive uses ZIP-LZMA to remain below the delivery size limit; Python's standard `zipfile` module can extract it. For example, `python3 -m zipfile -e SAR16_04_Pinned_PDK_LZMA_20261006.zip .`. Extract all four archives before running the delivery manifest verifier. `environment/setup.sh` recognizes these prepacked inputs only after validating all17pinned hashes; it does not overwrite changed input files. Tool binaries remain official pinned downloads, requiring Linuxx86_64 and the documented shared-library Python3.12runtime.
