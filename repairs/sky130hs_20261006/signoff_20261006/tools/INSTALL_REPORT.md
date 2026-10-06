# Local SKY130 verification tool installation

Completed and smoke-tested on 2026-10-06 UTC. No global packages, system settings, the existing ORFS environment, or frozen design runs were modified.

## Executables

From this directory, source `env.sh` or invoke `bin/<tool>` directly.

| Launcher | Verified version | Provenance |
|---|---|---|
| `bin/magic` | 8.3.684 | Official RTimothyEdwards/magic commit `4f53bb3091d1e4a9b2009a58f157a8a4331d4c84` |
| `bin/netgen` / `bin/netgen-lvs` | 1.5.324 | Official RTimothyEdwards/netgen commit `3cb047bd6b55ae09c8eefeb479b4fe746cfdb948` |
| `bin/klayout` | 0.30.0 | Official Debian 13 package `klayout_0.30.0-1+b1_amd64.deb` |

This is the VLSI Netgen LVS checker, not the unrelated mesh-generator program. Debian Netgen LVS 1.5.133 is retained only as a package dependency/download artifact; launchers use the current source-built 1.5.324.

## Validation

`test_tools.sh` passed all checks. Outputs are under `smoke/` and `logs/`.

- Magic starts with Tcl support and the distribution `scmos` technology
- Magic writes GDS, performs extraction, and generates SPICE using `ext2spice lvs`
- Magic reports zero DRC errors for clean test metal and two errors for deliberately narrow test metal
- Netgen reports a unique match for equivalent resistor circuits with renamed internal nodes
- Netgen reports a mismatch when a resistor is intentionally missing
- KLayout writes and reads a GDS and detects deliberate minimum-width errors through the geometry engine
- KLayout's native `.drc` macro engine runs successfully and emits one expected violation in `smoke/klayout_smoke.lyrdb`
- Magic/Netgen executables and Tcl extensions plus KLayout have no unresolved dynamic-library dependencies in the launcher environment

These checks validate the tools only. They do not constitute SKY130 DRC or design LVS signoff; those require the selected PDK/rule decks and actual design data.

## Runtime details

Debian packages are extracted under `debian/`; source-built tools are under `local/`. No root access is used. The wrapper load paths include local dependencies. KLayout uses the offscreen Qt platform by default and local Ruby 3.3 library/gem paths, fixing the built-in DRC `pathname` load error. No GUI session was tested.

Magic was built with Tcl/Tk, without OpenGL, Cairo, or readline. These optional GUI features are unnecessary for the tested headless DRC/extraction workflow. Optional LaTeX document regeneration produced warnings; upstream prebuilt PostScript documentation was installed instead. Magic's executable build and installation succeeded. Netgen emits routine Tcl namespace notices for `format` and `global`; LVS controls pass.

## Reproduction and provenance

- `debian-download-manifest.json`: each Debian package's exact URL, version, byte count, SHA-256
- `upstream-manifest.json`: official source repository URLs, pinned commits/versions, and source-archive SHA-256
- `package-index-provenance.json`: source and hash of the official Debian package index
- `SHA256SUMS`: hashes for all saved downloads and source archives
- `tool-status.json`: final tested versions, launcher locations, binary hashes, test results
- `fetch_debian.py`: dependency retrieval and hash verification, followed by user-local package extraction
- `build_tools.sh`: source builds/install into this local tool tree
- `configure_wrappers.py`: generates runtime wrappers
- `test_tools.sh`: positive and negative smoke controls

To rebuild at the same location, run `python3 fetch_debian.py`, `./build_tools.sh`, `python3 configure_wrappers.py`, and `./test_tools.sh`. Do not run extraction/build/install while any design verification process is using this tool tree. The compiled Magic/Netgen prefixes are absolute; moving the tree requires rebuilding. The host supplies the Debian 13 C/C++ base runtime and compiler. Saved downloads total roughly 182 MiB including indexes/source archives; the installed tree and source builds use about 985 MiB.
