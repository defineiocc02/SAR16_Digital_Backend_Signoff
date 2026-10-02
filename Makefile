PYTHON ?= python3
VERILATOR ?= verilator

.PHONY: check smoke ppa review interface
check:
	$(PYTHON) tools/check_repo.py --output build/repository_check.json
	tclsh tests/check_sdc.tcl

smoke:
	$(PYTHON) tools/run_smoke.py --verilator "$(VERILATOR)"

ppa:
	$(PYTHON) tools/run_srm_latency.py --verilator "$(VERILATOR)"
	$(PYTHON) tools/analyze_ppa.py

review:
	$(PYTHON) tools/run_rtl_review.py --verilator "$(VERILATOR)"
	$(PYTHON) tools/analyze_rtl_principles.py
	$(PYTHON) tools/inventory_synthesis.py

interface:
	$(PYTHON) tools/check_sar16_interface.py --output build/sar16_interface_check.json
	$(PYTHON) -m unittest discover -s tests -p test_sar16_interface.py
