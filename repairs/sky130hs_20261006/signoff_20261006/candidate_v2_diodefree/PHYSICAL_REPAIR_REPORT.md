# SKY130HS final diode-free physical repair

## Result and scope

The final candidate is `candidate_v2_diodefree`. The frozen `run_v6` and first repaired `candidate_v1` are preserved. This candidate fixes real geometry and interconnect; no RTL/architecture, functional cell, standard-cell master GDS, timing constraint, DRC rule, antenna limit, or gate/diffusion antenna model is changed.

All freshly rerun physical proxy gates pass. The accompanying signoff workflow additionally verifies full GDS Magic `drc(full)=0` and strict extracted Netgen LVS with matching topology and no device-property error. Read that workflow's final reports for the full signoff scope and formal proof results. Public-rule validation is not a foundry tapeout signoff or a full analog ADC verification.

## What changed

1. Added official fill_1/2/4/8 cells to complete the placement rows and well/tap connectivity. Final filler count: 8,900.
2. Fixed three dfrtp_1 CLK-access vias that overlapped a notch hidden by the rectangular LEF pin abstraction. Each via moved 0.185 µm inward in the native GDS pin, with one small metal1 connection. This preserves the original cell GDS.
3. Removed the eight physical antenna-diode cells. Their ordinary logic-driving and receiving cells are unchanged. Eight fill_2 cells occupy the freed sites.
4. Replaced the antenna protection with actual routing-layer jumps:
   - `clk`: a 1.44 µm M4 bridge between (180.000,197.950) and (181.440,197.950) µm, with two M3–M4 contacts and a real break in M3
   - `clknet_4_8_0_clk`: lift the 0.72 µm terminal branch from (89.760,226.070) to (90.480,226.070) µm from M3 to M4; reuse one existing contact, add one contact, and add a 0.48 µm M3 landing extension to satisfy the physical minimum-area rule
   - `_0827_`: replace the former diode's multi-access local conductor with a genuine M2 bridge and two M1–M2 contacts, connecting (336.240,228.475) to (336.720,228.105) µm
5. Two other removed multi-access diode sites receive short 0.17 µm LI routes inside the former pin footprint to preserve branch connectivity. Five obsolete sole-access LI/MCON vias are removed. Existing harmless connected higher-metal stubs are retained.

The three original LI access repairs are:

| Instance | Net | Old contact center (µm) | New center (µm) |
|---|---|---|---|
| _5953_ / CLK | clknet_leaf_48_clk | 192.000,244.755 | 192.000,244.940 |
| _5803_ / CLK | clknet_leaf_109_clk | 303.475,244.755 | 303.475,244.940 |
| _5610_ / CLK | clknet_leaf_67_clk | 258.355,361.305 | 258.355,361.120 |

`reports/diodefree_route_edits.json` and `reports/access_edits.json` provide exact machine-readable edits. The final original tap placement state remains LOCKED. DEF encodes both FIRM and LOCKED as FIXED; the import script restores the baseline LOCKED metadata before freezing.

## Why simple diode deletion was insufficient

The first removal-only probe reported one antenna violation. That probe did not preserve the connection between multiple access points formerly joined by three diode cells' LI geometry. Restoring the real conductor paths revealed two more antenna cases. These were repaired with the additional physical layer jumps above. The final extraction and strict LVS establish the resulting connectivity; the final antenna run is performed in a fresh OpenROAD process reading the frozen ODB.

This intermediate result is not used as final evidence. No diffusion credit is retained from a deleted diode.

## Fresh final antenna evidence

The final ODB contains zero diode instances and zero DIODE terminals. All 3,230 library master-pin gate/diffusion antenna records are exactly identical to the baseline. The exported geometry and antenna rules are identical. No threshold or area is relaxed.

| Receiver / layer | Final side-area ratio | Limit |
|---|---:|---:|
| clk → clkbuf_0_clk/A, M3 | 58.13 | 400 |
| clk → clkbuf_0_clk/A, M4 | 7.38 | 400 |
| clknet_4_8_0_clk → clkbuf_leaf_22_clk/A, M3 | 7.97 | 400 |
| _0827_ → _2775_/A1, M1 | 2.85 | 400 |

Total antenna violations: **0 nets / 0 pins**. Raw complete breakdown: `reports/antenna_fresh_full.rpt`; individual bridge-net reports are `antenna_clk_jumper.rpt`, `antenna_clock_branch_jumper.rpt`, and `antenna_signal_m2_jumper.rpt`. Integrity proof: `reports/antenna_model_integrity.json`.

A DEF roundtrip resets the routed ODB's RC metadata to the original LEF defaults. The extraction/STA flow reloads the same original `setRC.tcl` and `rcx_patterns.rules`; fresh SPEF extraction supplies the timing parasitics. The antenna/geometry identity comparison excludes only RC values, and preserves every antenna rule and pin area exactly.

## Rechecked physical gates

| Check | Final result |
|---|---|
| Nominal setup / hold WNS | +1.062018 / +0.153111 ns |
| Scalarstress setup / hold WNS | +0.947274 / +0.050880 ns |
| Electrical violations in both views | 0 |
| 13 CDC delay bounds, Gray physical spans, local reset checks | Pass |
| Router-model DRC | 0 |
| Fresh-process antenna | 0 nets / 0 pins |
| Placement | Pass |
| Routed connectivity | Complete |
| VDD / VSS connectivity | Pass |
| Unconnected power terminals | 0 |
| SPEF connected-net coverage | Complete, 4,187 annotated nonempty signal nets |

All results use the final repaired geometry and freshly extracted SPEF. The 11 absent SPEF entries are empty/unconnected database nets. The inherited clock periods (10 / 3 ns), output load (0.05 pF) and output-minimum-delay assumption (−0.5 ns) are unchanged. Scalarstress means the original 0.9/1.1 scalar delay derating, not foundry PVT/OCV signoff.

## Area and logical invariance

Die: **154,433.2804 µm²**. Core: **135,032.8320 µm²**. Both dimensions are unchanged.

| Category | Count | Area (µm²) |
|---|---:|---:|
| Original functional logic plus inserted clock/hold/I/O/repair buffers | 4,301 | 64,567.3680 |
| Original well taps | 1,456 | 2,327.2704 |
| Antenna diodes | 0 | 0 |
| Official fillers | 8,900 | 68,138.1936 |
| Total physical instances | 14,657 | 135,032.8320 |

The mapped-only subset remains 3,542 cells / 57,512.0304 µm². Functional-plus-buffer area remains 47.8161% of the core. Filler insertion makes placement-row occupancy 100%; it does not increase logic area or imply routing utilization is 100%.

Every one of the 5,757 remaining original instances, its master, placement/orientation and all terminal connections are unchanged. All 178 ports (including physical pin geometry) and all 4,200 net names/types are unchanged. Only the eight antenna diodes are removed. Canonical baseline-minus-diodes and final-minus-fillers placed connectivity hashes both equal:

`5289aef54dd34f9f90fed8e1c5acb0d62cce445e7f2667d6ba2b6b9e34afe5f9`

See `reports/invariance_audit.json` for exhaustive comparison and separate area categories. The final Verilog byte hash differs because of diode removal, filler additions, and declaration ordering. Formal verification is reported separately by the main signoff workflow.

## Frozen source identity

- ODB: `e7fcd87e358a1848c7e1d2fdde08280773994c176907caecc541867e81e09792`
- DEF: `22c5de831ee7dbdcf8eef1637735f7da03b2a7059b9ac9e8e7b45e4a7ae2edf1`
- GDS: `bc8f2590c514a8f8bfb819057fcf0f848fc8107b0726860d7581b8bcdadd8c4b`
- Routed Verilog: `b6b2f6ab56f5d565d26b2ccacfcb1af9e751b0bf1100595bb16942449e35cce5`
- Power-aware source Verilog: `c2c78daa1ed441bf7a611547ee02d43aa3b8a05b7fcab12598226623257834a8`

No geometry/netlist mutation occurs after these files are frozen. `reports/frozen_input_hashes.json` records these identities.

## Images and replay

All images under this candidate directory use its own final frozen ODB/GDS, not copied earlier-candidate images.

- `images/01_routed_full.png`: actual full final routed view
- `images/02_routed_signals.png`: final signal-only overview
- `images/layer_met1.png` through `layer_met5.png`: final per-layer routes
- `images/jumper_clk.png`, `jumper_clock_branch.png`, `jumper_signal_m2.png`: actual GDS before/after geometry for the three antenna-routing remedies, with coordinates and layer legends
- `images/li_access_5953.png`, `li_access_5803.png`, `li_access_5610.png`: original-to-final complete GDS access repairs
- `reports/jumper_zoom_geometry.json` and `li_zoom_geometry.json`: exact source hashes and polygons for the technical renders

`reproduce_physical_candidate.sh` starts from frozen `run_v6`, reproduces filler/access fixes, removes the eight diodes, constructs the routing jumps, checks invariance/models, reruns extraction and all physical proxy gates, streams complete GDS, and renders the final images. It requires a fresh sibling destination and refuses to overwrite existing results. Full GDS DRC, extracted strict LVS and formal proofs remain in the accompanying main signoff workflow.

The full replay was executed successfully in a separate fresh directory. Final ODB, DEF and both Verilog exports reproduce byte-for-byte; SPEF, SDC and SDF differ only in creation timestamps. Timing and all physical gate results are identical. See `reports/replay_verification.json`.
