#!/usr/bin/env python3
"""Reproduce fixed v5.1 LUT statistics and calibration state-action counts.

Standard library only. This is an analytical characterization of the actual ROM,
not an ADC simulation, a noise model validation, or a physical CDC check.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path
import re
from statistics import NormalDist

ROOT = Path(__file__).resolve().parent.parent
LUT_PATH = Path("evidence/rtl_baseline/srm_residue_lut.sv")
CAL_PATH = Path("evidence/rtl_baseline/sar_calib_ctrl_serial.sv")
Q8_SCALE = 256


def integer_default(source: str, name: str) -> int:
    match = re.search(r"parameter\s+int\s+" + re.escape(name) + r"\s*=\s*(\d+)\s*[,)]", source)
    if match is None:
        raise ValueError(f"Missing integer parameter default: {name}")
    return int(match.group(1))


def rom_entries(source: str, function: str) -> dict[int, int]:
    match = re.search(r"function\b[^;]*\b" + re.escape(function) + r"\s*\([^;]*;(?P<body>.*?)endfunction", source, re.S)
    if match is None:
        raise ValueError(f"Missing ROM function: {function}")
    pattern = r"5'd(\d+)\s*:\s*" + re.escape(function) + r"\s*=\s*(-?)16'sd(\d+)\s*;"
    pairs = re.findall(pattern, match.group("body"))
    result: dict[int, int] = {}
    for index, negative, magnitude in pairs:
        address = int(index)
        if address in result:
            raise ValueError(f"Duplicate ROM address {address} in {function}")
        result[address] = (-1 if negative else 1) * int(magnitude)
    return result


def binomial_characterization(entries: list[int], probability: float, truth_lsb: float) -> dict:
    count = len(entries) - 1
    pmf = [math.comb(count, k) * probability**k * (1 - probability)**(count - k)
           for k in range(count + 1)]
    if not math.isclose(math.fsum(pmf), 1.0, rel_tol=0, abs_tol=1e-12):
        raise ValueError("Binomial probabilities do not sum to one")
    mean = math.fsum(weight * value / Q8_SCALE for weight, value in zip(pmf, entries))
    variance = math.fsum(weight * (value / Q8_SCALE - mean)**2
                         for weight, value in zip(pmf, entries))
    return {"truth_lsb": truth_lsb, "probability_of_one": probability,
            "mean_lsb": mean, "bias_lsb": mean - truth_lsb,
            "std_lsb": math.sqrt(variance), "rmse_lsb": math.sqrt(variance + (mean - truth_lsb)**2),
            "endpoint_probability": pmf[0] + pmf[-1]}


def characterize_lut(source: str) -> dict:
    count = integer_default(source, "DECISION_COUNT")
    sigma_q8 = integer_default(source, "SIGMA_Q8")
    residue_fraction = integer_default(source, "RES_FRAC")
    output_fraction = integer_default(source, "FRAC_OUT")
    if (count, sigma_q8, residue_fraction, output_fraction) != (22, 128, 8, 8):
        raise ValueError("This analytical baseline requires the fixed N=22, sigma=128, Q8 ROM")
    full = rom_entries(source, "tbl_full_q8")
    half = rom_entries(source, "tbl_q8")
    if set(full) != set(range(count + 1)) or set(half) != set(range(count // 2 + 1)):
        raise ValueError("Missing or additional baked ROM addresses")
    if any(full[k] != (half[k] if k <= count // 2 else -half[count - k]) for k in full):
        raise ValueError("Full and folded half ROM differ")
    values = [full[k] for k in range(count + 1)]
    if any(values[k] != -values[count - k] for k in range(count + 1)):
        raise ValueError("Default Q8 ROM is not odd-symmetric")
    sigma_actual = 0.5
    gaussian = NormalDist()
    cases = [binomial_characterization(values, gaussian.cdf(truth / sigma_actual), truth)
             for truth in (-1.0, -0.5, 0.0, 0.5, 1.0)]
    pseudocount_probability = 0.5 / (count + 1)
    raw_endpoint_lsb = (sigma_q8 / Q8_SCALE) * gaussian.inv_cdf(pseudocount_probability)
    rounded_endpoint = round(raw_endpoint_lsb * Q8_SCALE)
    # The reconstructed generator's default lower endpoint bound is -258 Q8.
    generator_bound = -258
    after_bound = max(rounded_endpoint, generator_bound)
    if after_bound != values[0]:
        raise ValueError("Default endpoint model no longer matches the actual ROM")
    shift = residue_fraction - 4
    coarse_q4 = [value >> shift for value in values]
    # Reproduce the estimator's concatenation/left shift into its Q8 interface.
    coarse_published_q8 = [value << shift for value in coarse_q4]
    coarse_center = binomial_characterization(coarse_published_q8, 0.5, 0.0)
    pairs = [{"count_negative": k, "count_positive": count-k,
              "negative_q4": coarse_q4[k], "positive_q4": coarse_q4[count-k],
              "pair_sum_q4": coarse_q4[k] + coarse_q4[count-k],
              "negative_published_q8": coarse_published_q8[k],
              "positive_published_q8": coarse_published_q8[count-k]}
             for k in range(count // 2)]
    analytic_center_bias = -(1 - math.comb(count, count // 2) / 2**count) / 32
    if not math.isclose(coarse_center["bias_lsb"], analytic_center_bias, abs_tol=1e-15):
        raise ValueError("Q4 center-bias enumeration disagrees with paired formula")
    correlations = []
    for rho in (0.0, 0.05, 0.2, 0.5, 1.0):
        inflation = 1 + (count - 1) * rho
        correlations.append({"decision_equicorrelation_rho": rho,
                             "mean_variance_inflation": inflation,
                             "effective_independent_decisions": count / inflation})
    return {"scope": "exact finite sum for iid Gaussian-threshold decisions; no Monte Carlo",
            "actual_rom_values_q8": values,
            "decision_count": count, "sigma_actual_lsb": sigma_actual,
            "sigma_lut_lsb": sigma_q8 / Q8_SCALE,
            "iid_binomial_cases": cases,
            "endpoint": {"probability_with_pseudocount": pseudocount_probability,
                         "unrounded_endpoint_lsb": raw_endpoint_lsb,
                         "rounded_endpoint_q8": rounded_endpoint,
                         "reconstructed_generator_bound_q8": generator_bound,
                         "after_bound_q8": after_bound,
                         "bound_changes_default_value": after_bound != rounded_endpoint,
                         "actual_rom_endpoint_q8": values[0]},
            "frac_out_4": {"method": "signed arithmetic right shift by 4, then restore Q8 by left shift",
                           "all_nonzero_pairs": pairs,
                           "iid_zero_residue": coarse_center,
                           "zero_bias_paired_formula_lsb": analytic_center_bias},
            "decision_correlation_examples": {
                "formula": "N_eff=N/(1+(N-1)*rho)", "examples": correlations,
                "restriction": "rho describes Bernoulli decision correlation, not analog Gaussian voltage correlation"},
            "assumptions": ["held residue throughout each decision group", "decision 1 iff residue + noise > 0",
                            "zero comparator offset", "iid Gaussian noise for binomial cases",
                            "correlation examples characterize probability-mean variance only"],
            "excludes": ["real ADC SNDR/ENOB", "analog-noise validation", "metastability and physical timing"]}


def calibration_cycles(source: str) -> dict:
    params = {name: integer_default(source, name)
              for name in ("CAP_NUM", "COMP_WAIT_CYC", "AVG_LOOPS", "MAX_CALIB_BIT")}
    if params != {"CAP_NUM": 20, "COMP_WAIT_CYC": 16, "AVG_LOOPS": 32, "MAX_CALIB_BIT": 5}:
        raise ValueError("Default calibration baseline has changed; re-review the state-count formula")
    capacitor_count = params["CAP_NUM"]
    settling = params["COMP_WAIT_CYC"]
    loops = params["AVG_LOOPS"]
    targets = []
    for target in range(params["MAX_CALIB_BIT"] + 1, capacitor_count):
        search_bits = capacitor_count - 3 if target >= capacitor_count - 2 else target
        sar_cycles_each_phase = (settling + 1) * search_bits
        calc_cycles_each_phase = capacitor_count + 1
        cycles_each_pn_loop = 2 * (1 + sar_cycles_each_phase + calc_cycles_each_phase) + 1
        cycles = 1 + loops * cycles_each_pn_loop + 3
        targets.append({"target_bit": target, "search_bits": search_bits,
                        "sar_cycles_each_phase": sar_cycles_each_phase,
                        "calc_cycles_each_phase": calc_cycles_each_phase,
                        "cycles_each_pn_loop": cycles_each_pn_loop,
                        "state_action_cycles": cycles})
    total_cycles = sum(target["state_action_cycles"] for target in targets)
    search_sum = sum(target["search_bits"] for target in targets)
    if total_cycles != 207352 or search_sum != 172:
        raise ValueError("Calibration state-action count does not match the reviewed baseline")
    return {"defaults": params, "formula": "T_k=1+L*(2*(1+(C+1)*n_k+(N+1))+1)+3",
            "targets": targets, "sum_search_bits": search_sum,
            "total_state_action_cycles": total_cycles,
            "time_ms_at_100mhz": total_cycles / 100_000,
            "first_target_cycles_if_avg_loops_1": 1 + targets[0]["cycles_each_pn_loop"] + 3,
            "counting_boundary": "INIT_TARGET through the final UPDATE_WEIGHT state actions; excludes start/observer convention",
            "excludes": ["analog settling adequacy", "SRM-assisted calibration", "calibration accuracy"]}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=ROOT, help="Repository root (default: script parent parent)")
    parser.add_argument("--output-dir", type=Path, default=Path("build/rtl_review"))
    args = parser.parse_args()
    repo = args.repo.resolve()
    destination = args.output_dir if args.output_dir.is_absolute() else repo / args.output_dir
    contents = {name: (repo / name).read_bytes() for name in (LUT_PATH, CAL_PATH)}
    locked = json.loads((repo/"docs/baseline_manifest.json").read_text(encoding="utf-8"))["sha256"]
    for name, data in contents.items():
        if hashlib.sha256(data).hexdigest() != locked[str(name)]:
            raise ValueError(f"Historical input changed: {name}")
    result = {"scope": "analytical characterization of fixed v5.1 RTL; no commercial EDA",
              "input_sha256": {str(name): hashlib.sha256(data).hexdigest() for name, data in contents.items()},
              "lut": characterize_lut(contents[LUT_PATH].decode("utf-8")),
              "calibration": calibration_cycles(contents[CAL_PATH].decode("utf-8"))}
    destination.mkdir(parents=True, exist_ok=True)
    output = destination / "principle_numbers.json"
    output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("RTL_PRINCIPLES_ANALYSIS_PASS entries=23 cases=5 calibration_state_action_cycles=207352")
    print(f"zero_std_lsb={result['lut']['iid_binomial_cases'][2]['std_lsb']:.9f} "
          f"coarse_zero_bias_lsb={result['lut']['frac_out_4']['iid_zero_residue']['bias_lsb']:.9f}")
    print(output)


if __name__ == "__main__":
    main()
