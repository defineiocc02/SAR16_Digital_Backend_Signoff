#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Explain the LUT table's deviation from sigma*Phi^-1(cnt/N), and -- if it is explained
-- emit the missing generator gen/gen_srm_lut.py so the table can be regenerated.

The baked half-table (rtl/srm_residue_lut.sv, HALF_TABLE branch, N=22, SIGMA_Q8=128,
FRAC_OUT=8, SHIFT=0):
    cnt :  0    1    2    3    4    5    6    7    8    9   10   11
    val : -258 -194 -158 -131 -110  -91  -74  -58  -43  -28  -14    0
"""
import math
import io
import os

N = 22
SIGMA_LSB = 0.5
FRAC = 8
TABLE = {0: -258, 1: -194, 2: -158, 3: -131, 4: -110, 5: -91,
         6: -74, 7: -58, 8: -43, 9: -28, 10: -14, 11: 0}


def Phi(x):
    return 0.5 * (1.0 + math.erf(x / math.sqrt(2.0)))


def Phi_inv(p):
    """Acklam's rational approximation for the inverse standard normal CDF."""
    if p <= 0.0:
        return -math.inf
    if p >= 1.0:
        return math.inf
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
        q = p - 0.5
        r = q * q
        return (((((a[0]*r+a[1])*r+a[2])*r+a[3])*r+a[4])*r+a[5])*q / \
               (((((b[0]*r+b[1])*r+b[2])*r+b[3])*r+b[4])*r+1)
    q = math.sqrt(-2 * math.log(1 - p))
    return -(((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5]) / \
            ((((d[0]*q+d[1])*q+d[2])*q+d[3])*q+1)


def table_for(pfun, sigma=SIGMA_LSB, clamp=-258, rnd=round):
    out = {}
    for c in range(N // 2 + 1):
        x = Phi_inv(pfun(c))
        if x in (float('inf'), float('-inf')) or x != x:
            v = clamp if clamp is not None else 0
        else:
            v = int(rnd(sigma * x * (2 ** FRAC)))
            if clamp is not None:
                v = max(v, clamp)
        out[c] = v
    return out


CANDS = [
    ('H1  P=cnt/N',                  lambda c: c / N, 0.5, None),
    ('H2  P=(cnt+0.5)/(N+1)',        lambda c: (c + 0.5) / (N + 1), 0.5, -258),
    ('H3  P=(cnt+0.5)/N',            lambda c: (c + 0.5) / N, 0.5, -258),
    ('H4  P=(cnt+1)/(N+1)',          lambda c: (c + 1) / (N + 1), 0.5, -258),
]

print('%-26s %s' % ('hypothesis', 'match / 12'))
best = None
for name, pf, sg, cl in CANDS:
    t = table_for(pf, sg, cl)
    m = sum(1 for c in TABLE if t.get(c) == TABLE[c])
    print('%-26s %2d' % (name, m))
    if m == len(TABLE):
        best = (name, pf, sg, cl)
    else:
        print('     got %s' % [t.get(c) for c in range(12)])

print('')
if best:
    name, pf, sg, cl = best
    print('EXACT MATCH: %s' % name)
    print('  implied P per entry vs cnt/N:')
    for c in range(12):
        print('    cnt=%2d  table=%5d   implied P=%.5f   cnt/N=%.5f'
              % (c, TABLE[c], Phi(TABLE[c] / (sg * 2 ** FRAC)), c / N))
else:
    print('no candidate reproduced the table exactly')

# ---- emit the missing generator -------------------------------------------------
GEN = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'gen_srm_lut.py')
src = '''#!/usr/bin/env python3
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
        return (((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5]) / \\
               ((((d[0]*q+d[1])*q+d[2])*q+d[3])*q+1)
    if p <= 1 - pl:
        q = p - 0.5; r = q*q
        return (((((a[0]*r+a[1])*r+a[2])*r+a[3])*r+a[4])*r+a[5])*q / \\
               (((((b[0]*r+b[1])*r+b[2])*r+b[3])*r+b[4])*r+1)
    q = math.sqrt(-2 * math.log(1 - p))
    return -(((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5]) / \\
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
        print('            5\\'d%-2d : tbl_q8 = -16\\'sd%d;' % (cnt, -v) if v < 0
              else '            5\\'d%-2d : tbl_q8 =  16\\'sd%d;' % (cnt, v))
    print('            default: tbl_q8 = 16\\'sd0;')

if __name__ == '__main__':
    main()
'''
io.open(GEN, 'w', encoding='utf-8', newline='').write(src)
print('')
print('generator written: %s' % GEN)
