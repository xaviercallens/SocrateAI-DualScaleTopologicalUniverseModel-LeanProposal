#!/usr/bin/env python3
"""
c1_singular_analysis.py — REAL local analysis of the Stream 2 L2 operators.

Replaces the placeholder logic that E-007 retracted (briefs/ESCALATIONS.md).
Every number this prints is computed here by sympy. Nothing is hardcoded except
the operator coefficients themselves, whose provenance is stated below and whose
correctness is INDEPENDENTLY TESTED by check_sym2_against_s7() rather than assumed.

-- Source (L2 coefficients): briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md, table row
   "s7"/"s10" (Stream 1 -> Stream 2 handoff, two-model reviewed 2026-07-24).
-- Source (s7/s10 recurrence params): Gorodetsky arXiv:2102.11839 v2 p.3 Table 1,
   fetched to docs/literature/ and SHA256-pinned in refs/literature_provenance.txt.

SCOPE — what this script does and does NOT establish:

  DOES compute, rigorously:
    * the singular points of L2 on P^1 (roots of the leading coefficient, plus
      z=0 and z=infinity), exactly, as rationals;
    * the local indicial exponents at every singular point;
    * whether the holomorphic solution f of L2 satisfies f^2 = sum s7(n) z^n,
      i.e. a direct series-level test of the Sym^2 relation AND of the L2
      coefficients themselves.

  Does NOT establish (deliberately left open, see E-007 findings 3 and 6):
    * Kodaira fiber types. Getting those honestly requires building the
      Weierstrass model of the associated elliptic surface and running Tate's
      algorithm on its discriminant. Local exponents alone do not determine the
      Kodaira type.
    * Anything about a K3 surface. L2 is the Picard-Fuchs operator of a family of
      elliptic curves; the K3 lives on the L3 = Sym^2(L2) side (Gorodetsky p.2).
    * Any Picard lattice, Picard number, or gauge group.
"""

import sys
from sympy import Rational, symbols, Poly, factor, roots, simplify, series, O

z, rho = symbols('z rho')

# --- operator data (provenance in the docstring; correctness tested below) ------
# L2 = P2(z) theta^2 + P1(z) theta + P0(z),  theta = z d/dz
OPERATORS = {
    's7': dict(
        P2=1 - 26 * z - 27 * z**2,
        P1=-13 * z - 27 * z**2,
        P0=-2 * z - 6 * z**2,
        cooper=(13, 4, -27, 3),   # (a,b,c,d) for the order-3 Cooper recurrence
    ),
    's10': dict(
        P2=1 - 12 * z - 64 * z**2,
        P1=-6 * z - 64 * z**2,
        P0=-z - 15 * z**2,
        cooper=(6, 2, -64, 4),
    ),
}


def singular_points(P2):
    """Exact singular points of L2 on P^1.

    In d/dz form the operator is  z^2 P2 y'' + z (P2 + P1) y' + P0 y,
    so the finite singular points are z = 0 together with the roots of P2.
    z = infinity is always a singular point of these operators.
    """
    return sorted(roots(Poly(P2, z)).keys(), key=lambda r: (r.is_real is False, r))


def indicial_at_zero(P2, P1, P0):
    """Indicial equation at z=0. For theta-form the exponents solve
    P2(0) rho^2 + P1(0) rho + P0(0) = 0."""
    eq = P2.subs(z, 0) * rho**2 + P1.subs(z, 0) * rho + P0.subs(z, 0)
    return eq, sorted(roots(Poly(eq, rho)).items())


def indicial_at_finite(P2, P1, P0, z0):
    """Indicial exponents at a simple root z0 != 0 of P2.

    d/dz form: Q2 y'' + Q1 y' + Q0 y with Q2 = z^2 P2, Q1 = z(P2+P1), Q0 = P0.
    At a simple zero z0 of P2 the point is regular singular; with
    p_{-1} = lim_{z->z0} (z-z0) Q1/Q2 = Q1(z0) / (z0^2 P2'(z0)),
    the indicial equation is rho(rho - 1) + p_{-1} rho = 0.
    """
    Q1 = z * (P2 + P1)
    dP2 = P2.diff(z)
    p_m1 = simplify(Q1.subs(z, z0) / (z0**2 * dP2.subs(z, z0)))
    eq = rho * (rho - 1) + p_m1 * rho
    return p_m1, sorted(roots(Poly(eq, rho)).items())


def holomorphic_solution(P2, P1, P0, N):
    """Power-series solution f = sum a_n z^n of L2 with a_0 = 1, computed from the
    recurrence obtained by reading off the coefficient of z^N in L2[f]."""
    p2 = Poly(P2, z).all_coeffs()[::-1]
    p1 = Poly(P1, z).all_coeffs()[::-1]
    p0 = Poly(P0, z).all_coeffs()[::-1]

    def c(lst, i):
        return lst[i] if i < len(lst) else 0

    a = [Rational(1)]
    for M in range(1, N + 1):
        # coeff of z^M in sum_n a_n [P2 n^2 + P1 n + P0] z^n  ==  0
        acc = Rational(0)
        for j in range(1, M + 1):          # shift j >= 1 contributions
            n = M - j
            acc += a[n] * (c(p2, j) * n * n + c(p1, j) * n + c(p0, j))
        lead = c(p2, 0) * M * M + c(p1, 0) * M + c(p0, 0)   # = M^2 here
        if lead == 0:
            raise ArithmeticError(f"degenerate leading coefficient at n={M}")
        a.append(simplify(-acc / lead))
    return a


def cooper_sequence(params, N):
    """u(n) from the order-3 Cooper recurrence
    (n+1)^3 u(n+1) = (2n+1)(a n^2 + a n + b) u(n) - n(c n^2 + d) u(n-1),
    with u(0)=1 and u(1)=b (forced by the n=0 case: 1*u(1) = 1*b*u(0))."""
    a, b, c, d = params
    u = [Rational(1), Rational(b)]
    for n in range(1, N):
        nxt = ((2 * n + 1) * (a * n * n + a * n + b) * u[n]
               - n * (c * n * n + d) * u[n - 1]) / Rational((n + 1)**3)
        u.append(simplify(nxt))
    return u


def check_sym2(a, u, N):
    """Test f(z)^2 == sum u(n) z^n coefficientwise up to z^N.

    This simultaneously tests (i) that the L2 coefficients are the right ones and
    (ii) the Sym^2 relation at series level. A wrong L2 fails here immediately.
    """
    out = []
    for M in range(N + 1):
        sq = sum(a[i] * a[M - i] for i in range(M + 1))
        out.append((M, sq, u[M], sq == u[M]))
    return out


def analyse(name, N=12):
    d = OPERATORS[name]
    P2, P1, P0 = d['P2'], d['P1'], d['P0']
    print("=" * 78)
    print(f"  {name}:  L2 = ({P2}) th^2 + ({P1}) th + ({P0})")
    print("=" * 78)

    print(f"\n  leading coefficient P2 factors as: {factor(P2)}")
    sp = singular_points(P2)
    print(f"  finite singular points (roots of P2): {sp}")
    print("  plus z = 0 and z = oo (always singular for these operators)")

    eq0, ex0 = indicial_at_zero(P2, P1, P0)
    print(f"\n  z = 0:  indicial equation {eq0} = 0")
    print(f"          exponents {[(str(r), 'multiplicity %d' % m) for r, m in ex0]}")
    if ex0 == [(0, 2)]:
        print("          -> exponent 0 with multiplicity 2: MUM point"
              " (maximal unipotent monodromy)")

    for z0 in sp:
        p_m1, ex = indicial_at_finite(P2, P1, P0, z0)
        print(f"\n  z = {z0}:  p_(-1) = {p_m1}")
        print(f"          exponents {[str(r) for r, _ in ex]}")

    print(f"\n  --- Sym^2 series test (a_0 = 1, {N + 1} coefficients) ---")
    a = holomorphic_solution(P2, P1, P0, N)
    u = cooper_sequence(d['cooper'], N)
    res = check_sym2(a, u, N)
    print(f"  f coefficients : {[str(x) for x in a[:8]]} ...")
    print(f"  {name} from rec.: {[str(x) for x in u[:8]]} ...")
    ok = all(r[3] for r in res)
    for M, sq, un, good in res:
        if not good:
            print(f"    MISMATCH at z^{M}: (f^2)_{M} = {sq}  vs  {name}({M}) = {un}")
    print(f"  f(z)^2 == sum {name}(n) z^n  up to z^{N}: "
          f"{'VERIFIED' if ok else 'FAILED'}")
    return ok


def main():
    print(__doc__.split('SCOPE')[0].strip())
    print()
    results = {n: analyse(n) for n in ('s7', 's10')}
    print("\n" + "=" * 78)
    print("  SUMMARY")
    print("=" * 78)
    for n, ok in results.items():
        print(f"  {n}: Sym^2 series identity {'VERIFIED' if ok else 'FAILED'}")
    print("\n  NOT COMPUTED HERE (see docstring / E-007): Kodaira fiber types,")
    print("  any K3 surface, Picard number, Picard lattice, gauge group.")
    print("  Local exponents do NOT determine Kodaira type; that needs the")
    print("  Weierstrass model and Tate's algorithm.")
    return 0 if all(results.values()) else 1


if __name__ == '__main__':
    sys.exit(main())
