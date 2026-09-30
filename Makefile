PYTHON ?= python3
VERILATOR ?= verilator

.PHONY: check smoke ppa
check:
	$(PYTHON) tools/check_repo.py --output build/repository_check.json
	tclsh tests/check_sdc.tcl

smoke:
	$(PYTHON) tools/run_smoke.py --verilator "$(VERILATOR)"

ppa:
	$(PYTHON) tools/run_srm_latency.py --verilator "$(VERILATOR)"
	$(PYTHON) tools/analyze_ppa.py
