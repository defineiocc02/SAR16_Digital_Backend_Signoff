PYTHON ?= python3
.PHONY: sky130hs-check sky130hs-rtl
sky130hs-check:
	$(PYTHON) tools/check_sky130hs_publication.py
	$(PYTHON) -m unittest discover -s tests -p test_sky130hs_publication.py
sky130hs-rtl:
	$(PYTHON) tools/run_sky130hs_rtl_regression.py
