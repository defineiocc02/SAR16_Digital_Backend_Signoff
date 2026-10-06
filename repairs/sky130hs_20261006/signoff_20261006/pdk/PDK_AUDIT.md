# SKY130A signoff setup and HS reference validation

## Selected inputs

- Magic/Netgen rules: official FOSSi open-pdks 1.0.611, commit `801834fcbf9119e6fd4462f97da9e637f284539a` (2026-10-02), https://github.com/fossi-foundation/open-pdks/tree/801834fcbf9119e6fd4462f97da9e637f284539a
- Original HS layout source: Google commit `1d051f49bfe4e2fe9108d702a8bc2e9c081005a4`, https://github.com/google/skywater-pdk-libs-sky130_fd_sc_hs/tree/1d051f49bfe4e2fe9108d702a8bc2e9c081005a4
- Geometry-matched, current-model-naming HS SPICE/CDL: official maintained commit `968e0c3b60c103c2df1da4981b11ff603d55a88a` (2024-05-27), https://github.com/fossi-foundation/skywater-pdk-libs-sky130_fd_sc_hs/tree/968e0c3b60c103c2df1da4981b11ff603d55a88a
- Newer maintained HS commit `c3d7991a9bcb4fc33cbd43262b44bb5560d6fdd0` was inspected but must NOT be used as the frozen-layout reference without qualification: its conb_1 layout and resistor length changed in 2025.

Archive hashes and generated-file hashes are in `source_manifest.json`. Every one of the 780 selected SPICE/CDL files was verified against the official Git blob SHA1 at the selected commit; SHA256 hashes are also retained in `geometry_matched_reference_manifest.json`.

This is a deliberately minimal signoff PDK subset, not a complete analog-simulation PDK installation. No HD standard-cell substitution was made. The technology supports SKY130A's five-metal stack; no library geometry was changed in frozen run_v6 or the existing environment.

## Paths and reproduction

Set PDK_ROOT to the absolute path of this directory.

- Magic rcfile: `sky130A/libs.tech/magic/sky130A.magicrc`
- Magic technology: `sky130A/libs.tech/magic/sky130A.tech`
- Netgen setup: `sky130A/libs.tech/netgen/sky130A_setup.tcl`
- USE FOR LVS: `sky130A/libs.ref/sky130_fd_sc_hs/spice/sky130_fd_sc_hs.geometry_matched.spice`
- Matching pin-order CDL: `sky130A/libs.ref/sky130_fd_sc_hs/cdl/sky130_fd_sc_hs.geometry_matched.cdl`
- `sky130_fd_sc_hs.spice` without the geometry_matched suffix is the newer comparison snapshot, NOT the selected baseline reference.

Run `build_tech.sh` to reproduce the official open-pdks preprocessing targets, and `build_reference.py` to verify and merge the unchanged selected upstream netlists. Technology definitions are TECHNAME=sky130A, METAL5, MIM, REDISTRIBUTION, STAGING_PATH=this directory, MAGIC_CURRENT=libs.tech/magic. No design-rule edits or error waivers were introduced. The upstream tech requires Magic 8.3.411 or later; load and full-style smoke passed with Magic 8.3.684 (`smoke/load_tech.log`).

## Master coverage and geometry matching

The frozen routed DEF has 5,765 instances and **95 distinct HS masters**, not 117. Its mapped and routed Verilog master-name union is also 95.

- Both selected libraries contain 390 subcircuits and cover all 95 used masters.
- All used CDL and SPICE subcircuit pin orders match.
- KLayout per-layer polygon XOR found **95/95 ORFS master geometries identical** to original upstream GDS. Labels were not part of the polygon XOR.
- All **95/95 original GDS blobs are byte-identical** to the chosen 2024 maintained revision, including labels.
- Evidence: `cell_coverage.json`, `orfs_vs_upstream_geometry.json`, `hs_gds_matched_revision_comparison.json`.
- HS CDL's diode_2 is intentionally an empty subcircuit and says the tap diode is not represented. Therefore use native SPICE as the transistor/device gold, not CDL alone. The native tap cell is empty because it contains no MOS transistor or explicit modeled diode.

## Why the newest HS reference was rejected

Only two used SPICE cells differ between original Google and the newest maintained snapshot: conb_1 and diode_2. Exact changes are retained in `hs_upstream_netlist_changes.diff`.

- conb_1 originally used an obsolete three-terminal `short` name with W=.51 and L=.045 microns. The 2024 source represents it as the supported two-terminal `sky130_fd_pr__res_generic_po` with those SAME dimensions. In July 2025, upstream changed its mask layer 66/15 and reference length to .5 microns. ORFS still has the old .045-micron geometry; current Magic independently extracted .045. Using the latest .5-micron reference would manufacture an unrelated LVS mismatch.
- The 2025 physical change is documented by upstream: https://github.com/fossi-foundation/skywater-pdk-libs-sky130_fd_sc_hs/commit/b9b2be651c4ca109240709b7e3a7a91613b2eb56
- The XOR of latest conb_1 against ORFS finds 0.4641 square microns changed on layer 66/15 (`orfs_vs_maintained_conb_geometry.json`).
- diode_2 received the current primitive name and parameter names in 2024, without a geometry change. Its upstream perimeter remains inconsistent with the physical rectangle, as documented below.

## Active geometric DRC coverage

The startup default is `drc(fast)`. For this task, explicitly set `drc style drc(full)` and `drc euclidean on`. The official standard-DRC helper also selects `drc(full)`.

The generated technology's lines 4592–4743 include the following actual contact and enclosure rules. These are Magic internal-contact rules, not a reimplementation of LEF58 or an assertion about OpenROAD's parser:

| Raw contact | Active internal rule(s) | Upstream rule labels |
|---|---|---|
| mcon | width 170, spacing 190, exact_overlap mcon/li; metal1 surround 30 all sides and 60 directional | mcon.1, mcon.2, met1.4, met1.5 |
| via1 | width 260, spacing 60, directional surround 30 on metal1 and metal2, exact_overlap v1/m1 | via.1a+2×via.4a, via.2−2×via.4a, via.5a−via.4a, met2.5−met2.4 |
| via2 | width 280, spacing 120, metal2 surround 45 directional, metal3 surround 25, exact_overlap v2/m2 | via2.1a+2×via2.4, via2.2−2×via2.4, via2.4a−via2.4, met3.4 |
| via3 | width 320, spacing 80, metal3 surround 30 directional, metal4 surround 5, exact_overlap v3/m3 | via3.1+2×via3.4, via3.2−2×via3.4, via3.5−via3.4, met4.3−via3.4 |
| via4 | width 1180, spacing 420, metal5 surround 120, exact_overlap v4/m4 | via4.1+2×via4.4, via4.2−2×via4.4, met5.3−via4.4 |

The internal contact representation incorporates the nominal overlap during CIF import: via1 grows by 55 nominal units outside COREID (50 within), via2 by40, via3 by60, via4 by190. Consequently the literal additional surround numbers are NOT the raw GDS cut enclosure by themselves. Review these together with the import rules at lines 3563–3663. Full DRC adds minimum metal-hole rules, wide-metal neighborhood rules, and well/tap coverage checks. This establishes real enclosure-rule presence independent of OpenROAD's ignored LEF58 statements; it does not certify that every foundry rule is covered or that an unchecked input path is valid.

## Density and antenna limits

- The official `run_standard_drc.py` says standard DRC excludes antenna and density; separate helpers are required.
- `check_density.py` refuses layouts smaller than 700×700 microns. The standalone 392.98×392.98-micron block is below this window. Block metal-area summaries would not be a replacement for foundry local-window density checks at chip integration.
- The extraction technology contains partial antenna parameters and explicitly notes diode-diffusion checks are not modeled. A standard DRC pass therefore must not be described as antenna signoff.
- The public open-source deck is not a proprietary foundry certification, and no tapeout-clean claim follows from tool execution alone.

## Isolated diode discrepancy: reference-library issue

The unmodified official `sky130_fd_sc_hs__diode_2.gds` was extracted independently of the chip. It reproduces the chip's exact result:

- extracted area=6.417e11, perim=3.24e6 in the PDK's unusual diode parameter units
- gold area=6.417e11, perim=7.32e6
- one “Could not determine device boundary” feedback warning

KLayout independently measures its raw DIFF(65/20) and DIODE(81/23) rectangle from (0.135,0.320) to (0.825,1.250) microns: width .69, height .93, area .6417 square microns, perimeter 3.24 microns. This matches Magic. The six internal LICON cuts have a combined perimeter4.08 microns, exactly the excess in gold7.32=3.24+4.08. Contact-edge double counting in an older extraction is a plausible explanation; that historical cause has not been proven.

Both supported CIF import styles, sky130() and sky130(vendor), with maskhints on and off, return the same result. No supported import-setting fix was found. The warning itself is a known, still-open upstream issue for the exact primitive: https://github.com/RTimothyEdwards/magic/issues/319#issuecomment-2273780471

An isolated Netgen check matches connectivity uniquely but reports the expected perimeter property error (delta77.3%, cutoff2%). This is an upstream standard-cell gold-reference discrepancy, not evidence that design routing damaged the diode. It remains a genuine blocker to an unqualified property-clean LVS pass against that official reference.

Evidence is under `smoke/diode/`: extraction scripts/logs, raw geometry measurements, the import-option comparison, and `isolated_diode_lvs.txt`. No diode property waiver, primitive substitution, gold-netlist rewrite, extracted-netlist rewrite, or geometry modification was applied to force a pass.

## Candidate v1 filler-cell extension

Candidate v1 adds fill_1/2/4/8, for 99 distinct masters and 14,657 instances. Filler counts are 1,941 / 1,590 / 1,349 / 4,012 respectively (8,892 fillers). All 99 ORFS native master geometries match original upstream GDS by per-layer KLayout XOR, and all 99 original GDS blobs are byte-identical to selected revision 968e0c3. All 99 have verified native SPICE and CDL definitions with matching pin order. These filler definitions are empty physical-only subcircuits as supplied upstream. No reference library or GDS edits were needed. Evidence: `candidate_v1_cell_coverage.json` and `candidate_v1_orfs_vs_upstream_geometry.json`. The existing isolated diode property mismatch is unchanged by this coverage audit.
