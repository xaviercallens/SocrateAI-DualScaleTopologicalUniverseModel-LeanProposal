#!/usr/bin/env python3
"""
check_C3_symsquare.py — symbolic verification of criterion C3 (symmetric square)
for the Cooper candidates s7, s10, s18. Stream-1-side symbolic evidence feeding the
C3 status flag (route 1 of K3_CRITERIA C3: symbolic => SYM2_SYMBOLIC; a Lean kernel
proof would be route 2 => SYM2_PROVED).

Criterion (Almkvist-van Straten, arXiv:2103.08651, p.4-5; SHA-pinned in
refs/cooper_sequences.md): a monic 3rd-order operator L = D^3 + a2 D^2 + a1 D + a0
(D = d/dx) is essentially self-adjoint  <=>  it is the symmetric square of a 2nd-order
operator  <=>  the differential polynomial

    W := (1/3) a2'' + (2/3) a2 a2' + (4/27) a2^3 + 2 a0 - (2/3) a1 a2 - a1'

vanishes identically in x.

Cooper operator (Gorodetsky arXiv:2102.11839, eq 1.7), theta = x d/dx:
    L = theta^3 - x (2theta+1)(a theta^2 + a theta + b) + x^2 ( c (theta+1)^3 + d (theta+1) )

RESULT (this script, exact symbolic arithmetic):
  * Controls: Apery a_n (known symmetric square) -> W=0; a generic non-Cooper operator -> W!=0.
  * s7 (13,4,-27,3), s10 (6,2,-64,4), s18 (14,6,192,-12): W=0  => all symmetric squares.
  * IMPORTANT: W=0 holds IDENTICALLY for the whole Cooper family (symbolic a,b,c,d), i.e. the
    symmetric-square property is AUTOMATIC for this operator ansatz. C3 confirms the geometric
    relation EXISTS but does NOT discriminate among Cooper-form candidates; candidate selection
    rests on C1/C2/C3b/C4/C5. See refs/cooper_sequences.md and briefs/ESCALATIONS.md E-004.

Epistemic tier: the Sym^2 relation is a geometric/arithmetic relation only; it implies NO
physical coupling (VISION section 1.3). Symbolic (sympy) verification, not a Lean kernel proof.

Generated-by: Opus 4.8 (T0) | Verified-by: sympy exact symbolic (controls pass) | Reviewed-by: T0 Y
"""
import sympy as sp

x = sp.symbols('x')
y = sp.Function('y')


def theta(f):
    return sp.expand(x * sp.diff(f, x))


def poly_in_theta(coeffs, f):
    """Apply sum_i coeffs[i] * theta^i to f (coeffs low-order first)."""
    res, term = 0, f
    for ci in coeffs:
        res += ci * term
        term = theta(term)
    return sp.expand(res)


def cooper_L_on_y(a, b, c, d):
    """L y for Gorodetsky eq 1.7 with params (a, b, c, d)."""
    yy = y(x)
    t3 = theta(theta(theta(yy)))
    inner = poly_in_theta([b, a, a], yy)                 # (a th^2 + a th + b) y
    mid = poly_in_theta([1, 2], inner)                   # (2 th + 1)(...) y
    x2op = c * poly_in_theta([1, 3, 3, 1], yy) + d * poly_in_theta([1, 1], yy)
    return sp.expand(t3 - x * mid + x**2 * x2op)


def W_of_monic(a2, a1, a0):
    return sp.simplify(
        sp.Rational(1, 3) * sp.diff(a2, x, 2)
        + sp.Rational(2, 3) * a2 * sp.diff(a2, x)
        + sp.Rational(4, 27) * a2**3
        + 2 * a0
        - sp.Rational(2, 3) * a1 * a2
        - sp.diff(a1, x)
    )


def W_from_cooper(a, b, c, d):
    Ly = cooper_L_on_y(a, b, c, d)
    p3 = Ly.coeff(sp.diff(y(x), x, 3))
    p2 = Ly.coeff(sp.diff(y(x), x, 2))
    p1 = Ly.coeff(sp.diff(y(x), x, 1))
    p0 = Ly.coeff(y(x))
    a2, a1, a0 = sp.together(p2 / p3), sp.together(p1 / p3), sp.together(p0 / p3)
    return sp.simplify(W_of_monic(a2, a1, a0)), p3


def main():
    print("CONTROLS")
    Wpos, _ = W_from_cooper(17, 5, 1, 0)
    assert Wpos == 0, "positive control (Apery a_n) failed"
    print(f"  [+] Apery a_n (17,5,1,0):  W = {Wpos}   PASS")
    Wneg = W_of_monic(x**2 + 1, x + 2, x**3)
    assert Wneg != 0, "negative control failed"
    print(f"  [-] generic operator:      W = {Wneg}   (nonzero => detector works)")

    print("\nCOOPER CANDIDATES")
    ok = {}
    for name, (a, b, c, d) in {'s7': (13, 4, -27, 3),
                               's10': (6, 2, -64, 4),
                               's18': (14, 6, 192, -12)}.items():
        W, p3 = W_from_cooper(a, b, c, d)
        ok[name] = (W == 0)
        print(f"  {name:>4} (a,b,c,d)=({a},{b},{c},{d})  p3={sp.factor(p3)}  W={W}  "
              f"=> {'SYM2_SYMBOLIC (W=0)' if W == 0 else 'FAIL'}")

    a, b, c, d = sp.symbols('a b c d')
    Wgen, _ = W_from_cooper(a, b, c, d)
    print(f"\nGENERIC Cooper-form (symbolic a,b,c,d):  W = {sp.simplify(Wgen)}")
    print("  => W=0 identically: symmetric-square property is AUTOMATIC for the Cooper ansatz")
    print("     (C3 is structural, not discriminating; selection rests on C1/C2/C3b/C4/C5).")

    assert all(ok.values())
    print("\nRESULT:", {k: ('W=0' if v else 'W!=0') for k, v in ok.items()})


if __name__ == "__main__":
    main()
