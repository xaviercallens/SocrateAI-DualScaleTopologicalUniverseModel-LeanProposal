#!/usr/bin/env python3
"""
derive_D1_P_cleared.py — Fable 5 output for decision D1 (E-006, Option B).

Derives the CLEARED-DENOMINATOR polynomial identity equivalent to the
Almkvist-van Straten self-adjointness criterion W == 0 for the GENERIC Cooper
operator (Gorodetsky arXiv:2102.11839 eq 1.7, symbolic params a, b, c, d):

    L = theta^3 - z(2theta+1)(a theta^2 + a theta + b) + z^2 (c(theta+1)^3 + d(theta+1))

Method (the exact algebra Deep Think must independently reproduce):
  1. Convert L to D-form: L = p3 D^3 + p2 D^2 + p1 D + p0, p_i in Q[a,b,c,d][z].
  2. Monic coefficients a_i = p_i/p3 are rational functions (pole at z=0 - the
     E-006 blocker). Substitute into
        W = (1/3)a2'' + (2/3)a2 a2' + (4/27)a2^3 + 2a0 - (2/3)a1 a2 - a1'
     and multiply by 27*p3^3 (exact common denominator: a2'' and a2^3 both
     carry p3^3; every other term carries p3^2 or less). Result:

        P_cleared = 9(p2''p3^2 - p2 p3 p3'' - 2 p2' p3 p3' + 2 p2 p3'^2)
                  + 18 p2 (p2' p3 - p2 p3')
                  + 4 p2^3
                  + 54 p0 p3^2
                  - 18 p1 p2 p3
                  - 27 p3 (p1' p3 - p1 p3')

  3. EQUIVALENCE (for Deep Think sign-off): in Frac(Q[a,b,c,d][z]),
     W = P_cleared / (27 p3^3) with p3 != 0, hence W == 0  <=>  P_cleared == 0
     identically. No pole condition, no lost/gained factors: the clearing
     multiplier 27 p3^3 is explicit and nonzero as a polynomial.

  4. This script verifies: (i) P_cleared expands to the ZERO polynomial for the
     generic Cooper family (the D1 claim); (ii) the negative control (a generic
     non-Cooper operator) gives P_cleared != 0, so the cleared criterion still
     detects non-self-adjointness; (iii) P_cleared/(27 p3^3) - W == 0 for the
     negative control, confirming the clearing identity itself.

Lean encoding target (Opus, AFTER Deep Think concurrence): define p0..p3 as
explicit Polynomial expressions, state P_cleared = 0, discharge by `ring`.

Generated-by: Fable 5 (T0 math design) | Verified-by: sympy 1.14 exact symbolic
(this script; controls pass) | Reviewed-by: T0 N (AWAITING Deep Think concurrence
per the two-model rule - do not encode in Lean until recorded in ESCALATIONS.md)
"""
import sympy as sp

z = sp.symbols('z')
y = sp.Function('y')


def theta(f):
    return sp.expand(z * sp.diff(f, z))


def poly_in_theta(coeffs, f):
    """Apply sum_i coeffs[i] * theta^i to f (coeffs low-order first)."""
    res, term = 0, f
    for ci in coeffs:
        res += ci * term
        term = theta(term)
    return sp.expand(res)


def cooper_D_form(a, b, c, d):
    """p3, p2, p1, p0 of the Cooper operator in D-form (coeffs of y''', y'', y', y)."""
    yy = y(z)
    t3 = theta(theta(theta(yy)))
    inner = poly_in_theta([b, a, a], yy)
    mid = poly_in_theta([1, 2], inner)
    x2op = c * poly_in_theta([1, 3, 3, 1], yy) + d * poly_in_theta([1, 1], yy)
    Ly = sp.expand(t3 - z * mid + z**2 * x2op)
    return tuple(sp.expand(Ly.coeff(sp.diff(y(z), z, k))) for k in (3, 2, 1, 0))


def P_cleared(p3, p2, p1, p0):
    """27*p3^3*W as a pure polynomial expression (no division anywhere)."""
    d = lambda f: sp.diff(f, z)
    return sp.expand(
        9 * (d(d(p2)) * p3**2 - p2 * p3 * d(d(p3)) - 2 * d(p2) * p3 * d(p3) + 2 * p2 * d(p3)**2)
        + 18 * p2 * (d(p2) * p3 - p2 * d(p3))
        + 4 * p2**3
        + 54 * p0 * p3**2
        - 18 * p1 * p2 * p3
        - 27 * p3 * (d(p1) * p3 - p1 * d(p3))
    )


def W_of_monic(a2, a1, a0):
    return sp.simplify(
        sp.Rational(1, 3) * sp.diff(a2, z, 2)
        + sp.Rational(2, 3) * a2 * sp.diff(a2, z)
        + sp.Rational(4, 27) * a2**3
        + 2 * a0
        - sp.Rational(2, 3) * a1 * a2
        - sp.diff(a1, z)
    )


def main():
    a, b, c, d = sp.symbols('a b c d')

    # ---- Generic Cooper family --------------------------------------------
    p3, p2, p1, p0 = cooper_D_form(a, b, c, d)
    print("Cooper D-form coefficients (generic a,b,c,d):")
    for name, p in (("p3", p3), ("p2", p2), ("p1", p1), ("p0", p0)):
        print(f"  {name} = {sp.factor(p)}")

    P = P_cleared(p3, p2, p1, p0)
    print(f"\nP_cleared (generic Cooper) expanded = {P}")
    assert P == 0, "D1 claim FAILED: P_cleared != 0 for generic Cooper family"
    print("  => IDENTICALLY ZERO: cleared W-criterion holds for the whole Cooper ansatz.  PASS")

    # ---- Per-candidate sanity (same result, concrete params) ---------------
    for name, params in (('s7', (13, 4, -27, 3)), ('s10', (6, 2, -64, 4)),
                         ('s18', (14, 6, 192, -12))):
        Pc = P_cleared(*cooper_D_form(*params))
        assert Pc == 0, f"{name}: P_cleared != 0"
        print(f"  {name} {params}: P_cleared = 0  PASS")

    # ---- Negative control: detector must still fire ------------------------
    q3, q2, q1, q0 = sp.Integer(1), z**2 + 1, z + 2, z**3
    Pneg = P_cleared(q3, q2, q1, q0)
    assert Pneg != 0, "negative control failed: P_cleared vanished on non-self-adjoint operator"
    print(f"\nNegative control (non-Cooper): P_cleared = {sp.factor(Pneg)} != 0  PASS")

    # ---- Clearing-identity check: P_cleared/(27 p3^3) == W exactly ----------
    Wneg = W_of_monic(q2 / q3, q1 / q3, q0 / q3)
    diff = sp.simplify(Pneg / (27 * q3**3) - Wneg)
    assert diff == 0, "clearing identity failed"
    print("Clearing identity P_cleared/(27 p3^3) == W verified on control.  PASS")

    print("\nALL CHECKS PASS - output frozen for Deep Think re-derivation (two-model rule).")


if __name__ == "__main__":
    main()
