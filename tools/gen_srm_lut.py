#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""gen_srm_lut.py -- regenerate the SRM residue LUT (RECONSTRUCTED, see note).

The original generator referenced by rtl/srm_residue_lut.sv and
rtl/srm_residue_estimator.sv is NOT present in the delivered tree.  This file was
reconstructed by fitting the baked table in rtl/srm_residue_lut.sv, and it reproduces
all 12 half-table entries exactly under the estimator

        P(cnt)   = (cnt + 0.5) / (N + 1)          <- continuity-corrected
        v(cnt)   = round( sigma * Phi^-1(P) * 2^FRAC_OUT ), clamped at -258 for cnt=0

with N = 22, sigma = SIGMA_Q8/256, FRAC_OUT = 8.

Usage:  python3 gen_srm_lut.py --n 22 --sigma-q8 128 --frac-out 8
"""
import argparse
import math

def Phi_inv(p):
    # Acklam's approximation (same as used to fit the table)
    if p <= 0.0: return -math.inf
    if p >= 1.0: return math.inf
    a = [-3.969683028665376e+01, 2.209460984245205e+02, -2.759285104469687e+02,
         1.383577518672690e+02, -3.066479806614716e+01, 2.506628277459239e+00]
    b = [-5.447609879822406e+01, 1.615858368580409e+02, -1.556989798598866e+02,
         6.680131188771972e+01, -1.328068155288572e+01]
    c = [-7.784894002430293e-03, -3.223964580411365e-01, -2.400758277161838e+00,
         -2.549732539343734e+00, 4.374664141464968e+00, 2.938163982698783e+00]
    d = [7.784695709041462e-03, 3.224671290700398e-01, 2.445134137142996e+00,
         3.754408661907416e+00]
    pl = 0.02425
    if p < pl:
        q = math.sqrt(-2 * math.log(p))
        return (((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5]) / \
               ((((d[0]*q+d[1])*q+d[2])*q+d[3])*q+1)
    if p <= 1 - pl:
        q = p - 0.5; r = q*q
        return (((((a[0]*r+a[1])*r+a[2])*r+a[3])*r+a[4])*r+a[5])*q / \
               (((((b[0]*r+b[1])*r+b[2])*r+b[3])*r+b[4])*r+1)
    q = math.sqrt(-2 * math.log(1 - p))
    return -(((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5]) / \
            ((((d[0]*q+d[1])*q+d[2])*q+d[3])*q+1)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--n', type=int, default=22)
    ap.add_argument('--sigma-q8', type=int, default=128)
    ap.add_argument('--frac-out', type=int, default=8)
    ap.add_argument('--clamp', type=int, default=-258)
    a = ap.parse_args()
    sigma = a.sigma_q8 / 256.0
    print('// half table, P = (cnt + 0.5)/(N + 1), N=%d sigma_q8=%d frac_out=%d'
          % (a.n, a.sigma_q8, a.frac_out))
    for cnt in range(a.n // 2 + 1):
        p = (cnt + 0.5) / (a.n + 1)
        v = int(round(sigma * Phi_inv(p) * (2 ** a.frac_out)))
        if cnt == 0:
            v = max(v, a.clamp)
        print('            5\'d%-2d : tbl_q8 = -16\'sd%d;' % (cnt, -v) if v < 0
              else '            5\'d%-2d : tbl_q8 =  16\'sd%d;' % (cnt, v))
    print('            default: tbl_q8 = 16\'sd0;')

if __name__ == '__main__':
    main()
