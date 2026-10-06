# Native antenna-diode recovery search

## Result

A real public candidate with property-clean standalone LVS exists: `sky130_fd_sc_hd__diode_2` at official commit `9cb2d7cb8ed4619094263614039a61b6b2d22a88`. With the same unmodified SKY130A Magic and Netgen setup, its actual native GDS extracts `perim=2.64e6 area=4.347e11`, and its official native SPICE matches uniquely with no property errors.

Evidence and unchanged native files are in `native_hd/`, especially `isolated_diode.spice`, `isolated_diode_lvs.txt`, and `extract.log`. The source GDS SHA256 is `7198f35a0a4bde6ba7155242c567b21644b04696c39734b604490c09e6709c90`.

**It is not a safe drop-in for this HS placement.** HD is 0.92×2.72µm, site unithd; HS is 0.96×3.33µm, site unit. Its power rails and body/well geometry differ. Also, the currently published raw native HD LEF inspected here omits ANTENNADIFFAREA. Mixing it into HS needs appropriate native Liberty characterization, validated antenna metadata and site/power/well integration, followed by full DRC, extracted LVS, antenna and STA checks. This test neither replaced a cell nor approved a physical integration.

The main repair task has a more promising routing-only recovery: remove the problematic signal diodes and repair the remaining antenna exposure with actual upper-metal routing. Extra library acquisition was stopped as requested once the standalone HD test was documented.

## Same-row alternatives and revision search

Full pinned revisions and exact scope of each check are in `candidate_sources.json`.

| Candidate | What was checked | Result |
|---|---|---|
| HS diode_2, latest c3d7991 | SPICE history, GDS history, previously completed isolated extraction/LVS | GDS has not changed since May 2020; maintained SPICE still has perimeter 7.32 despite actual 3.24. No corrected official HS reference commit found |
| HS fill_diode_2/4/8 | Native SPICE and existing official LEF | Power-only physical fillers with no DIODE signal pin; cannot substitute for signal antenna protection |
| MS diode_2, 2965099 | Native SPICE and LEF | Same 7.32e6 perimeter reference and .96×3.33 size; no proven correction. Not standalone-tested |
| LS diode_2, 4283919 | Native SPICE and LEF | Same 7.32e6 perimeter reference and .96×3.33 size; no proven correction. Not standalone-tested |
| LP diode_0 and diode_1, 091cb45 | Native SPICE and LEF | Matching row height, but both reference SPICE subcircuits are empty. Actual-device LVS cannot be established from these gold files. Not standalone-tested |
| HDLL diode_2, 0ff13a5 | Native SPICE and LEF | Old 5.36e6 perimeter, plus incompatible 2.72µm height. Not standalone-tested |
| HD diode_2, 9cb2d7c | Official native GDS, SPICE and LEF; isolated Magic and Netgen | Property-clean unique match, but different row/site/power rails and raw LEF antenna-metadata gap |

No reference was hand-edited, no diode property was waived, and no native geometry was altered. MS/LS/LP/HDLL conclusions above are source-screening conclusions rather than executed-LVS results.

## Historical upstream correction establishes the cause

The original Magic perimeter bug is documented by its maintainer in OpenLane issue 578: contacts were wrongly excluded from the diode perimeter region, adding their boundaries to the perimeter while leaving area correct. The maintainer fixed Magic and added an open-pdks installation correction in 2022.

- Maintainer explanation: https://github.com/The-OpenROAD-Project/OpenLane/issues/578#issuecomment-1231630171
- Installation-fix note: https://github.com/The-OpenROAD-Project/OpenLane/issues/578#issuecomment-1231759119
- Official HD SPICE correction commit: https://github.com/fossi-foundation/skywater-pdk-libs-sky130_fd_sc_hd/commit/20e3f824c90bd5e938eb7fa9514073105f63ed62
- Public OpenLane adoption: https://github.com/The-OpenROAD-Project/OpenLane/pull/1322

The official historical open-pdks revision `fa87f8f4bbcc7255b6f0c0fb506960f531ae2392` was downloaded and inspected. Its `sky130/custom/scripts/fix_device_models.py` performs a literal replacement `pj=5.36` to `pj=2.64`; it does **not** replace HS’s 7.32 with 3.24. Therefore replaying that official script is not an HS fix, and broadening its replacement locally would be a new reference-model edit rather than merely installing a published correction. We did not do that.

The existing HS measurements independently reproduce this contact-boundary mechanism: actual perimeter 3.24 plus internal LICON perimeter 4.08 equals the stale 7.32 reference. This search strengthens the diagnosis of a stale native HS gold view; it does not turn the failing comparison into a pass.
