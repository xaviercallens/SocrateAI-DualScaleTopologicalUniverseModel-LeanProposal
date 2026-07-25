#!/usr/bin/env sage
"""
derive_wz_certificates_s7_s10.sage — D2 CAS re-derivation (ESCALATIONS.md E-006
companion, docs/WZ_CERTIFICATE_ANALYSIS.md ADDENDUM 4).

Derives Wilf-Zeilberger creative-telescoping certificates proving that Cooper's
closed-form binomial sums s7, s10 satisfy their sourced three-term recurrences
(refs/cooper_sequences.md, Gorodetsky arXiv:2102.11839 p.3 Cooper table).

Gorodetsky's paper does NOT supply an explicit certificate (constant-term /
Laurent-polynomial method, not creative telescoping — see ESCALATIONS.md D2 fetch
addenda 2026-07-20/24). This script re-derives it via Sage's ore_algebra package
(Zeilberger's algorithm, `ideal.ct()`), independently of the source paper.

Method: for summand F(n,k), build the two first-order annihilating operators
(shift ratios in n and k, each independently numerically verified against direct
binomial evaluation before use here), form the left ideal they generate in the
bivariate shift-operator (Ore) algebra, and call `.ct(Sk - 1)` to compute the
telescoper (the recurrence in n) and its certificate G(n,k) = R(n,k)*F(n,k).

REQUIRES: SageMath with the `ore_algebra` package (github.com/mkauers/ore_algebra).
NOTE (environment-specific): the ore_algebra HEAD as of 2026-07 fails against
Ubuntu 22.04's packaged Sage 9.5 (`gens()` on a bivariate OreAlgebra hits a
Singular tower-ring limitation). Commit 47e05a4 (2022, contemporaneous with
Sage 9.5) works. If running on a newer Sage, HEAD should be fine.
"""

from ore_algebra import OreAlgebra

R = QQ['n,k']
n, k = R.gens()
A = OreAlgebra(R, 'Sn', 'Sk')
Sn, Sk = A.gens()


def derive(name, F, ann_n, ann_k, verify_points, params):
    """ann_n, ann_k: annihilating operators for F in Sn, Sk resp.
    verify_points: list of (n,k) pairs for an independent numeric spot-check
    of the raw telescoping identity Top(F) = G(.,k+1) - G(.,k).
    params: (a,b,c,d) — the sourced Cooper recurrence this should reproduce."""
    print(f"=== {name} ===")
    I = A.ideal([ann_k, ann_n])
    T, C = I.ct(Sk - 1, infolevel=0)
    Top = T[0]
    Gfun = list(C[0].dict().values())[0]  # order-(0,0) part = the rational-function certificate
    print("Telescoper (recurrence in Sn, relates F(n,k),F(n+1,k),F(n+2,k)):")
    print(" ", Top)
    print("Certificate G(n,k)/F(n,k) =", Gfun)

    # Independent numeric verification of the raw identity (not just trusting ore_algebra).
    Tcoeffs = Top.list()
    ok = True
    for (nval, kval) in verify_points:
        lhs = sum(Tcoeffs[j](n=nval) * F(nval + j, kval) for j in range(len(Tcoeffs)))
        rhs = Gfun(n=nval, k=kval + 1) * F(nval, kval + 1) - Gfun(n=nval, k=kval) * F(nval, kval)
        if lhs - rhs != 0:
            print(f"  MISMATCH at n={nval},k={kval}: lhs={lhs} rhs={rhs}")
            ok = False
    print("  raw telescoping identity:", "VERIFIED" if ok else "FAILED", f"({len(verify_points)} points)")

    # Algebraic check against the sourced Cooper recurrence, shifted to align index
    # convention (Top relates n,n+1,n+2; Cooper's recurrence at index n+1 relates the same).
    a, b, c, d = params
    RnPoly = QQ['n']
    nn = RnPoly.gen()
    cooper_at_np1 = {
        2: (nn + 2) ** 3,
        1: -(2 * nn + 3) * (a * (nn + 1) ** 2 + a * (nn + 1) + b),
        0: (nn + 1) * (c * (nn + 1) ** 2 + d),
    }
    # Clear Top's denominator and compare up to overall scalar.
    from sage.all import lcm
    denoms = [c.denominator() for c in Tcoeffs]
    L = lcm(denoms)
    cleared = [(c * L).numerator() for c in Tcoeffs]
    # cleared[2] should be a scalar multiple of (n+2)^3
    scale = cleared[2] / cooper_at_np1[2] if cooper_at_np1[2] != 0 else None
    matches = all((cleared[j] - scale * cooper_at_np1[j].change_ring(QQ)) == 0 for j in [0, 1, 2])
    print("  matches sourced Cooper recurrence", params, ":", matches)
    print()


def F7(nn, kk):
    return binomial(nn, kk) ** 2 * binomial(nn + kk, kk) * binomial(2 * kk, nn)


def F10(nn, kk):
    return binomial(nn, kk) ** 4


import random
random.seed(0)
pts_s10 = [(random.randint(3, 10), random.randint(1, 9)) for _ in range(15)]
pts_s7 = [(random.randint(3, 12), random.randint(1, 11)) for _ in range(30)]
pts_s10 = [(nv, kv) for nv, kv in pts_s10 if kv < nv]
pts_s7 = [(nv, kv) for nv, kv in pts_s7 if kv < nv]

derive(
    "s10 = sum_k C(n,k)^4  (OEIS A005260)",
    F10,
    (n + 1 - k) ** 4 * Sn - (n + 1) ** 4,
    (k + 1) ** 4 * Sk - (n - k) ** 4,
    pts_s10,
    (6, 2, -64, 4),
)

derive(
    "s7 = sum_{k=ceil(n/2)}^n C(n,k)^2 C(n+k,k) C(2k,n)",
    F7,
    (n + 1 - k) ** 2 * Sn - (n + 1 + k) * (2 * k - n),
    (k + 1) ** 2 * (2 * k + 2 - n) * (2 * k + 1 - n) * Sk - 2 * (n - k) ** 2 * (n + k + 1) * (2 * k + 1),
    pts_s7,
    (13, 4, -27, 3),
)
