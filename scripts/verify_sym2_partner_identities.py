#!/usr/bin/env python3
"""
verify_sym2_partner_identities.py — exact verification of the three claims that
docs/STREAM1_LEAN_ENCODING_GUIDE_2026_07_25.md asks Stream 1 to encode in Lean.

Everything printed is computed here by sympy over exact rationals. The only
inputs are the L2 partner coefficients and the Cooper (a,b,c,d) parameters, and
both are then independently cross-checked (claim 3).

CLAIM 1  theta(P2) = 2*P1          "the magic collapse"
CLAIM 2  L3_Cooper = P2 * Sym^2(L2), i.e. the residuals D2 = D1 = D0 vanish
CLAIM 3  f(z)^2 = sum s(n) z^n     (series cross-check, ties L2 to the sequence)

-- Source (L2 coefficients): briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md, "s7"/"s10" rows.
-- Source (Cooper a,b,c,d): Gorodetsky arXiv:2102.11839 v2 p.3 table, fetched and
   SHA256-pinned (refs/literature_provenance.txt); re-checked by
   checkers/adversarial_A5_A6_provenance_hygiene.py.
-- Source (Cooper L3 template): Gorodetsky arXiv:2102.11839 v2, eq. (1.7):
   (theta^3 - z(2theta+1)(a theta^2 + a theta + b)
             + z^2 (c(theta+1)^3 + d(theta+1))) y = 0
"""

import sys
from sympy import symbols, expand, simplify, factor, Rational, together, cancel, Poly

z = symbols('z')

DATA = {
    's7':  dict(P2=1 - 26*z - 27*z**2, P1=-13*z - 27*z**2, P0=-2*z - 6*z**2,
                cooper=(13, 4, -27, 3)),
    's10': dict(P2=1 - 12*z - 64*z**2, P1=-6*z - 64*z**2,  P0=-z - 15*z**2,
                cooper=(6, 2, -64, 4)),
}


def theta(f):
    """theta = z d/dz."""
    return expand(z * f.diff(z))


def cooper_L3(params):
    """Coefficients (c3, c2, c1, c0) of Cooper's order-3 operator in theta-form,
    obtained by expanding eq. (1.7). z sits to the LEFT of every theta, and the
    inner factors have constant coefficients, so no commutator terms arise:

      -z(2th+1)(A th^2 + A th + B) = -z[2A th^3 + 3A th^2 + (A+2B) th + B]
      z^2(C(th+1)^3 + D(th+1))     = z^2[C th^3 + 3C th^2 + (3C+D) th + (C+D)]
    """
    A, B, C, D = params
    c3 = expand(1 - 2*A*z + C*z**2)
    c2 = expand(-3*A*z + 3*C*z**2)
    c1 = expand(-(A + 2*B)*z + (3*C + D)*z**2)
    c0 = expand(-B*z + (C + D)*z**2)
    return c3, c2, c1, c0


def sym2_monic(P2, P1, P0):
    """Monic theta-form coefficients of Sym^2(L2) for L2 = P2 th^2 + P1 th + P0.

    Derivation (recorded so the Lean encoding can follow it): put
    alpha = P1/P2, beta = P0/P2, so th^2 y = -alpha th y - beta y for any
    solution y. For u = y*w with y, w solutions, set
        s0 = y w,  s1 = (th y)w + y(th w),  s2 = (th y)(th w).
    Then
        th s0 = s1
        th s1 = -2 beta s0 - alpha s1 + 2 s2
        th s2 = -beta s1 - 2 alpha s2
    Eliminating s1, s2 gives
        th^3 u + 3a th^2 u + (2a^2 + th(a) + 4b) th u + (4ab + 2 th(b)) u = 0
    with a = alpha, b = beta.
    """
    a = cancel(P1 / P2)
    b = cancel(P0 / P2)
    e2 = cancel(3 * a)
    e1 = cancel(2 * a**2 + theta(a) + 4 * b)
    e0 = cancel(4 * a * b + 2 * theta(b))
    return e2, e1, e0


def holomorphic_solution(P2, P1, P0, N):
    p2 = Poly(P2, z).all_coeffs()[::-1]
    p1 = Poly(P1, z).all_coeffs()[::-1]
    p0 = Poly(P0, z).all_coeffs()[::-1]
    g = lambda L, i: L[i] if i < len(L) else 0            # noqa: E731
    a = [Rational(1)]
    for M in range(1, N + 1):
        acc = sum(a[M - j] * (g(p2, j)*(M - j)**2 + g(p1, j)*(M - j) + g(p0, j))
                  for j in range(1, M + 1))
        a.append(simplify(-acc / (M * M)))
    return a


def cooper_sequence(params, N):
    A, B, C, D = params
    u = [Rational(1), Rational(B)]
    for n in range(1, N):
        u.append(simplify((((2*n + 1)*(A*n*n + A*n + B)*u[n]
                            - n*(C*n*n + D)*u[n - 1]) / Rational((n + 1)**3))))
    return u


def run(name):
    d = DATA[name]
    P2, P1, P0 = d['P2'], d['P1'], d['P0']
    ok = True
    print("=" * 76)
    print(f"  {name}")
    print("=" * 76)
    print(f"  P2 = {P2}      factored: {factor(P2)}")
    print(f"  P1 = {P1}")
    print(f"  P0 = {P0}")

    # ---- CLAIM 1 -----------------------------------------------------------
    lhs, rhs = theta(P2), expand(2 * P1)
    good = simplify(lhs - rhs) == 0
    ok &= good
    print(f"\n  [CLAIM 1] theta(P2) = 2 P1")
    print(f"    theta(P2) = {lhs}")
    print(f"    2 P1      = {rhs}")
    print(f"    difference = {simplify(lhs - rhs)}   -> {'HOLDS' if good else 'FAILS'}")

    # ---- CLAIM 2 -----------------------------------------------------------
    c3, c2, c1, c0 = cooper_L3(d['cooper'])
    print(f"\n  [CLAIM 2] L3_Cooper = P2 * Sym^2(L2)")
    print(f"    Cooper L3 theta-coefficients (from eq. 1.7):")
    print(f"      th^3: {c3}")
    print(f"      th^2: {c2}")
    print(f"      th^1: {c1}")
    print(f"      th^0: {c0}")
    lead = simplify(c3 - P2)
    print(f"    leading coefficient check: c3 - P2 = {lead}"
          f"   -> {'P2 IS the leading coeff' if lead == 0 else 'DIFFERS'}")
    ok &= (lead == 0)

    e2, e1, e0 = sym2_monic(P2, P1, P0)
    D2 = simplify(cancel(c2 / c3) - e2)
    D1 = simplify(cancel(c1 / c3) - e1)
    D0 = simplify(cancel(c0 / c3) - e0)
    print(f"    Sym^2(L2) monic coefficients:")
    print(f"      th^2: {simplify(e2)}")
    print(f"      th^1: {simplify(e1)}")
    print(f"      th^0: {simplify(e0)}")
    print(f"    residuals   D2 = {D2}    D1 = {D1}    D0 = {D0}")
    good = (D2 == 0 and D1 == 0 and D0 == 0)
    ok &= good
    print(f"    -> {'D2 = D1 = D0 = 0, IDENTITY HOLDS' if good else 'IDENTITY FAILS'}")

    # ---- CLAIM 2' : the COLLAPSED, division-free forms Lean should prove -----
    # Multiplying the monic residuals by P2^2 and using theta(P2) = 2 P1:
    #   P2^2 D2 = P2 * (c2 - 3 P1)
    #   P2^2 D1 = P2 * (c1 - theta(P1) - 4 P0)      [the -2P1^2 + P1 theta(P2) cancel]
    #   P2^2 D0 = P2 * (c0 - 2 theta(P0))           [the -4P1P0 + 2P0 theta(P2) cancel]
    # so with P2 not identically zero the whole Sym^2 identity reduces to three
    # POLYNOMIAL equations in Q[z] -- no division, no side conditions.
    print("\n    [CLAIM 2'] collapsed division-free forms (these are the Lean goals):")
    r3 = simplify(expand(c3 - P2))
    r2 = simplify(expand(c2 - 3*P1))
    r1 = simplify(expand(c1 - theta(P1) - 4*P0))
    r0 = simplify(expand(c0 - 2*theta(P0)))
    print(f"      c3 - P2                    = {r3}")
    print(f"      c2 - 3 P1                  = {r2}")
    print(f"      c1 - theta(P1) - 4 P0      = {r1}")
    print(f"      c0 - 2 theta(P0)           = {r0}")
    collapsed = (r3 == 0 and r2 == 0 and r1 == 0 and r0 == 0)
    ok &= collapsed
    print(f"      -> {'ALL FOUR VANISH' if collapsed else 'FAILURE'}")

    # Guard: show the collapse genuinely depends on theta(P2) = 2 P1 by
    # perturbing P1 and confirming the collapsed D1 form then breaks.
    P1p = P1 + z
    broken = simplify(expand(
        (c1 * P2**2
         - (2*P1p**2 + (theta(P1p)*P2 - P1p*theta(P2)) + 4*P0*P2) * c3) / P2))
    print(f"      control: perturbing P1 -> P1 + z makes P2*D1 = {broken}"
          f"  ({'non-zero, so the identity is not vacuous' if broken != 0 else 'STILL ZERO -- suspicious'})")

    # ---- CLAIM 4 : is L2 an instance of the repo's zagierThetaOperator? -----
    # zagierThetaOperator (A, lam, B) expands (ThetaOperators.lean,
    # zagierThetaOperator_eq) to
    #     (1 - A z + B z^2) th^2 + (-A z + 2B z^2) th + (-lam z + B z^2),
    # whose th^1 coefficient is EXACTLY theta of its th^2 coefficient.
    # Our partner satisfies theta(P2) = 2 P1, i.e. P1 = theta(P2)/2. The two
    # agree only if theta(P2) = 0, i.e. P2 constant -- which it is not here.
    print("\n  [CLAIM 4] is L2 an instance of the existing zagierThetaOperator?")
    A_z = -Poly(P2, z).all_coeffs()[::-1][1]          # P2 = 1 - A z + B z^2
    B_z = Poly(P2, z).all_coeffs()[::-1][2]
    zag_P1 = expand(-A_z*z + 2*B_z*z**2)
    print(f"    matching th^2 forces A = {A_z}, B = {B_z}")
    print(f"    zagier th^1 coeff would be : {zag_P1}   (= theta(P2))")
    print(f"    our P1 is                  : {expand(P1)}   (= theta(P2)/2)")
    print(f"    difference = {simplify(zag_P1 - P1)}")
    print(f"    -> {'NOT a zagierThetaOperator instance; needs a NEW Lean def'}")

    # ---- CLAIM 3 -----------------------------------------------------------
    N = 12
    a = holomorphic_solution(P2, P1, P0, N)
    u = cooper_sequence(d['cooper'], N)
    series_ok = all(sum(a[i]*a[M - i] for i in range(M + 1)) == u[M] for M in range(N + 1))
    ok &= series_ok
    print(f"\n  [CLAIM 3] f(z)^2 = sum {name}(n) z^n  (a_0 = 1), to z^{N}")
    print(f"    f : {[str(x) for x in a[:7]]} ...")
    print(f"    {name}: {[str(x) for x in u[:7]]} ...")
    integral = all(x.q == 1 for x in a)
    print(f"    -> {'VERIFIED' if series_ok else 'FAILED'};"
          f" f coefficients are {'INTEGRAL' if integral else 'NON-INTEGRAL (A4 caveat)'}")
    return ok


def main():
    results = {n: run(n) for n in ('s7', 's10')}
    print("\n" + "=" * 76)
    for n, v in results.items():
        print(f"  {n}: {'ALL CLAIMS VERIFIED' if v else 'SOME CLAIM FAILED'}")
    print("=" * 76)
    return 0 if all(results.values()) else 1


if __name__ == '__main__':
    sys.exit(main())
