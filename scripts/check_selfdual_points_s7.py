#!/usr/bin/env python3
"""Exact + numerical checks behind briefs/THOUGHT_EXPERIMENTS_SELF_DUAL_2026_09_20.md.

(1) EXACT, PASS(N): with h = q prod (1-q^{7n})^4/(1-q^n)^4 and z = h/(1+13h+49h^2),
    sum_n s7(n) z^n == (sum_{a,b} q^{a^2+ab+2b^2})^2 as power series to O(q^N).
(2) NUMERICAL (mpmath, 40 digits): h(i/sqrt7), h((-1+i/sqrt7)/2), and the Fricke law
    49 h(t) h(-1/(7t)) = 1 at a generic point.
NEGATIVE CONTROL: the same check with 13 replaced by 12 must FAIL.
"""
from fractions import Fraction as Fr
from math import comb
import sys
N = 40
one = [Fr(1)] + [Fr(0)] * (N - 1)
def mul(a, b):
    c = [Fr(0)] * N
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if i + j < N: c[i + j] += x * y
    return c
def inv(a):
    b = [Fr(0)] * N; b[0] = 1 / a[0]
    for n in range(1, N): b[n] = -sum(a[k] * b[n - k] for k in range(1, n + 1)) / a[0]
    return b
def euler(m):
    p = one[:]
    for n in range(1, N):
        if m * n < N:
            f = one[:]; f[m * n] -= 1; p = mul(p, f)
    return p
def pw(a, k):
    r = one[:]
    for _ in range(k): r = mul(r, a)
    return r
s7 = lambda n: sum(comb(n, k) ** 2 * comb(n + k, k) * comb(2 * k, n) for k in range(n + 1))
hq = mul([Fr(0), Fr(1)] + [Fr(0)] * (N - 2), mul(pw(euler(7), 4), inv(pw(euler(1), 4))))
th = [Fr(0)] * N
for a in range(-10, 11):
    for b in range(-10, 11):
        e = a * a + a * b + 2 * b * b
        if e < N: th[e] += 1
th2 = mul(th, th)
def F_of(mid):
    D = [x + mid * y + 49 * w for x, y, w in zip(one, hq, mul(hq, hq))]
    zq = mul(hq, inv(D)); F = [Fr(0)] * N; zp = one[:]
    for n in range(N):
        F = [f + s7(n) * c for f, c in zip(F, zp)]; zp = mul(zp, zq)
    return F
ok = F_of(13) == th2
ctl = F_of(12) == th2
print(f"PASS({N}) F(z(q)) == theta^2 : {ok}")
print(f"negative control (13 -> 12) equal? {ctl}   (must be False)")
try:
    from mpmath import mp, mpf, mpc, exp, pi, sqrt, nstr
    mp.dps = 40
    def eta(t):
        q = exp(2j * pi * t); p = mpf(1)
        for n in range(1, 300): p *= (1 - q ** n)
        return exp(2j * pi * t / 24) * p
    h = lambda t: (eta(7 * t) / eta(t)) ** 4
    z = lambda x: x / (1 + 13 * x + 49 * x ** 2)
    t1 = 1j / sqrt(7); t2 = (-1 + 1j / sqrt(7)) / 2; t = mpc(0.13, 0.9)
    print("h(i/sqrt7)          =", nstr(h(t1), 25), " z =", nstr(z(h(t1)), 25))
    print("h((-1+i/sqrt7)/2)   =", nstr(h(t2), 25), " z =", nstr(z(h(t2)), 25))
    print("49 h(t) h(-1/(7t))  =", nstr(49 * h(t) * h(-1 / (7 * t)), 25))
except ImportError:
    print("mpmath not available; numerical part skipped")
sys.exit(0 if (ok and not ctl) else 1)
