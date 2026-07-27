#!/usr/bin/env python3
"""
check_U1_splitting_independent.py — Stream 1 INDEPENDENT verification of the
Stream 2 U1 U-splitting claim (E-011 pattern, requested in
briefs/STREAM2_TO_STREAMS1_3_U1_CLOSED_2026_07_27.md, optional item 1).

CLAIM UNDER TEST (finite, exact — mechanically checkable)
-----------------------------------------------------------
Stream 2's cooper_s7 U1 pipeline (checkers/check_U1_lattice.py in the Stream 2
repo) derives a primitive even Gram matrix G for the joint monodromy-invariant
lattice of the cooper_s7 family, and claims G is isometric over Z to U + <d>
(d = 14) via an explicit unimodular integral base change. This is recorded in
data/certificates/C2_cooper_s7_v4.json (LIVE, T0-accepted 2026-07-27).

WHAT THIS SCRIPT DOES
----------------------
Loads the certificate at runtime (path is a CLI arg; default points at the
Stream 2 repo checked out alongside this one). Reads ONLY:
  - derived.gram_primitive_even   (G — the claimed Gram, taken as given input)
  - derived.u_splitting.d         (d — used ONLY to build the runtime EXPECTED
                                    target matrix U + <d>; never hardcoded)
  - derived.det, derived.signature, derived.u_splitting.gram_after
                                   (cross-checked against, not trusted)

It does NOT import or call Stream 2's check_U1_lattice.py, and does NOT reuse
Stream 2's base-change matrix — the certificate does not even store one (only
det(P) and P^T G P are serialized; see stage3_lattice() in that file). This
script re-derives its OWN witness matrix P from G alone, via a standard,
independently implemented construction (find a primitive isotropic vector
with unimodular G-pairing, complete it to a hyperbolic pair, take the
orthogonal-complement generator) — exact integer / Fraction arithmetic
throughout, no floats, no dependency on the Stream 2 codebase.

CHECKS (all must hold for PASS)
  1. G loaded from the certificate is symmetric, has integer entries, and is
     even (diagonal entries even) — a precondition for "isometric to U + <d>"
     to even make sense.
  2. det(G) and Sylvester signature, computed independently from G, match the
     certificate's own claimed det/signature fields (consistency cross-check).
  3. An independently constructed P is integral with det(P) = +-1, i.e.
     P in GL_3(Z).
  4. P^T G P equals the EXPECTED target matrix U + <d> = [[0,1,0],[1,0,0],[0,0,d]],
     where d is read from the certificate at runtime (never hardcoded to 14
     outside a labeled control — see test_U1_splitting_independent_controls.py).
  5. (Informational, not required for PASS) whether our P^T G P matches the
     certificate's own reported gram_after exactly, or only up to the
     GL_3(Z)-orbit — any valid witness P is a valid proof of isometry, and our
     construction is not guaranteed to reproduce Stream 2's unrecorded matrix.

WHAT THIS UPGRADES AND WHAT IT DOES NOT
  Upgrades: the lattice-arithmetic portion of the U-splitting claim (Link 1,
  "this specific Gram is isometric to U + <14>") from "trust the checker" to
  "two independently written, exact-arithmetic implementations agree."
  Does NOT touch: the numerics-to-exact monodromy-entry recognition step
  (Stream 2 stage 2, 60-digit numerics -> rational recognition), or the
  identification of this lattice with the transcendental lattice T of the K3
  (Link 2, Dolgachev/Doran framework reading). Both remain Tier B regardless.
  See briefs/STREAM1_U1_INDEPENDENT_VERIFICATION_2026_07_27.md.

Usage:
  python3 checkers/check_U1_splitting_independent.py
  python3 checkers/check_U1_splitting_independent.py --cert /path/to/cert.json

Generated-by: Sonnet 5 (Stream 1) | Verified-by: this file +
test_U1_splitting_independent_controls.py | Reviewed-by: pending T0 (Xavier)
"""

import argparse
import hashlib
import json
import sys
from pathlib import Path

DEFAULT_CERT = (
    "/home/callensxavier_gmail_com/SocrateAI-Scientific-Agora-K3-DarkMatter/"
    "data/certificates/C2_cooper_s7_v4.json"
)


class VerificationFailure(Exception):
    pass


def chk(cond, msg):
    if not cond:
        raise VerificationFailure(msg)


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load_cert(path):
    with open(path) as f:
        return json.load(f)


# ---------------------------------------------------------------------------
# exact integer linear algebra (no floats anywhere)
# ---------------------------------------------------------------------------

def transpose(A):
    return [list(row) for row in zip(*A)]


def mat_mul(A, B):
    n, m, p = len(A), len(B), len(B[0])
    return [[sum(A[i][k] * B[k][j] for k in range(m)) for j in range(p)] for i in range(n)]


def mat_det3(A):
    return (A[0][0] * (A[1][1] * A[2][2] - A[1][2] * A[2][1])
            - A[0][1] * (A[1][0] * A[2][2] - A[1][2] * A[2][0])
            + A[0][2] * (A[1][0] * A[2][1] - A[1][1] * A[2][0]))


def gv(G, v):
    """G . v, exact integer vector."""
    return [sum(G[i][j] * v[j] for j in range(3)) for i in range(3)]


def bil(G, u, v):
    return sum(u[i] * G[i][j] * v[j] for i in range(3) for j in range(3))


def quad(G, v):
    return bil(G, v, v)


def igcd(a, b):
    a, b = abs(a), abs(b)
    while b:
        a, b = b, a % b
    return a


def content(vec):
    g = 0
    for x in vec:
        g = igcd(g, x)
    return g


def egcd(a, b):
    """Extended Euclid: returns (g, x, y) with a*x + b*y = g."""
    old_r, r = a, b
    old_s, s = 1, 0
    old_t, t = 0, 1
    while r != 0:
        q = old_r // r
        old_r, r = r, old_r - q * r
        old_s, s = s, old_s - q * s
        old_t, t = t, old_t - q * t
    return old_r, old_s, old_t


def bezout_combo(row):
    """Given an integer vector `row` with gcd(row) == 1, return integer
    coefficients c such that dot(c, row) == 1. Pure exact-integer, iterative
    extended-gcd combination — an independent, from-scratch implementation
    (not ported from any checker in either repo)."""
    n = len(row)
    coeffs = [0] * n
    cur_g, cur_coeffs = 0, [0] * n
    for i, r in enumerate(row):
        if r == 0:
            continue
        if cur_g == 0:
            cur_g, cur_coeffs = r, [0] * n
            cur_coeffs[i] = 1
        else:
            g2, x, y = egcd(cur_g, r)
            cur_coeffs = [x * c for c in cur_coeffs]
            cur_coeffs[i] += y
            cur_g = g2
    chk(cur_g in (1, -1), f"bezout_combo: row {row} does not have gcd 1 (got {cur_g})")
    if cur_g == -1:
        cur_coeffs = [-c for c in cur_coeffs]
    # sanity (exact)
    chk(sum(c * r for c, r in zip(cur_coeffs, row)) == 1, "bezout_combo: internal error")
    return cur_coeffs


def cross(u, v):
    return [u[1] * v[2] - u[2] * v[1],
            u[2] * v[0] - u[0] * v[2],
            u[0] * v[1] - u[1] * v[0]]


def find_isotropic_unimodular_vector(G):
    """Search for a primitive vector f with Q(f) = f^T G f = 0 and
    content(G . f) = 1 (i.e. f pairs unimodularly with the lattice). Tries the
    three standard basis vectors first (this is where a hyperbolic-plane
    generator will sit if the certificate's basis was already built around
    the cusp-invariant vector, as Stream 2's stage3_lattice() basis is), then
    falls back to a bounded search over small integer combinations — the same
    generic technique standard for indefinite ternary forms, independently
    coded here (bound chosen well above what this 3x3, small-entry Gram
    needs)."""
    candidates = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    B = 6
    for a in range(-B, B + 1):
        for b in range(-B, B + 1):
            for c in range(-B, B + 1):
                if (a, b, c) == (0, 0, 0):
                    continue
                candidates.append([a, b, c])
    for f in candidates:
        if content(f) != 1:
            continue
        if quad(G, f) != 0:
            continue
        row = gv(G, f)
        if content(row) == 1:
            return f
    return None


def derive_u_plus_d_witness(G):
    """Independently construct P = [f | e | w] (columns) with f, e a
    hyperbolic pair (Q(f)=Q(e)=0, bil(f,e)=1) and w spanning the orthogonal
    complement, so that P^T G P = [[0,1,0],[1,0,0],[0,0,d]] with
    d = Q(w). Returns (P, d). Raises VerificationFailure if no such
    construction is found (i.e. the independent algorithm cannot confirm the
    splitting from G alone)."""
    f = find_isotropic_unimodular_vector(G)
    chk(f is not None, "no primitive isotropic vector with unimodular G-pairing found "
        "(independent splitting search exhausted its bound) — cannot confirm U-summand")

    row_f = gv(G, f)  # G . f
    c = bezout_combo(row_f)  # dot(c, row_f) == 1  =>  bil(G, f, c) == 1
    v = c
    Qv = quad(G, v)
    chk(Qv % 2 == 0, f"Q(v) = {Qv} is odd on a claimed-even lattice — contradiction")
    e = [v[i] - (Qv // 2) * f[i] for i in range(3)]
    chk(bil(G, f, e) == 1, f"hyperbolic pairing failed: bil(f,e) = {bil(G, f, e)} != 1")
    chk(quad(G, e) == 0, f"e is not isotropic: Q(e) = {quad(G, e)}")

    row_e = gv(G, e)
    w = cross(row_f, row_e)
    chk(w != [0, 0, 0], "orthogonal complement direction is degenerate (row_f, row_e parallel)")
    g = content(w)
    chk(g != 0, "internal error: zero content for nonzero vector")
    w = [x // g for x in w]
    chk(bil(G, f, w) == 0 and bil(G, e, w) == 0,
        "orthogonal-complement vector fails to pair to zero with f, e")

    d = quad(G, w)
    if d < 0:
        # orientation freedom of w (w and -w both span the same line); the
        # target U + <d> is only meaningful up to this sign, which itself is
        # exact and reported, not hidden.
        w = [-x for x in w]
        d = quad(G, w)

    P = transpose([f, e, w])  # columns f, e, w
    return P, d


# ---------------------------------------------------------------------------
# main verification
# ---------------------------------------------------------------------------

def verify_certificate(cert, verbose=True, scramble_G=None, scramble_P=None,
                        override_target_d=None):
    """Run the full independent verification against a loaded certificate
    dict. Returns a result dict; raises VerificationFailure on any failed
    check. `scramble_G` / `scramble_P` / `override_target_d` are hooks used
    ONLY by the negative-control tests, never by the plain PASS run."""
    derived = cert["derived"]
    G = [list(row) for row in derived["gram_primitive_even"]]
    if scramble_G is not None:
        G = scramble_G(G)

    # --- check 1: symmetric, integer, even ---
    chk(len(G) == 3 and all(len(row) == 3 for row in G), "G is not 3x3")
    chk(all(isinstance(x, int) for row in G for x in row), "G has non-integer entries")
    chk(all(G[i][j] == G[j][i] for i in range(3) for j in range(3)), "G is not symmetric")
    chk(all(G[i][i] % 2 == 0 for i in range(3)), f"G is not even: diag = {[G[i][i] for i in range(3)]}")

    # --- check 2: det / signature cross-check against the certificate's own claim ---
    det_computed = mat_det3(G)
    cert_det = derived["det"]
    chk(det_computed == cert_det,
        f"independently computed det(G) = {det_computed} != certificate's claimed det = {cert_det}")

    d_cert = derived["u_splitting"]["d"]
    if override_target_d is not None:
        d_target = override_target_d
    else:
        d_target = d_cert

    # --- checks 3-4: independent GL_3(Z) witness and target match ---
    P, d_computed = derive_u_plus_d_witness(G)
    if scramble_P is not None:
        P = scramble_P(P)

    detP = mat_det3(P)
    chk(detP in (1, -1), f"P is not in GL_3(Z): det(P) = {detP}")

    PtGP = mat_mul(mat_mul(transpose(P), G), P)
    target = [[0, 1, 0], [1, 0, 0], [0, 0, d_target]]  # built at runtime from d_target only
    chk(PtGP == target,
        f"P^T G P = {PtGP} does not equal the expected target U + <{d_target}> = {target}")

    # signature derived from the confirmed split: U contributes (1,1); <d>
    # contributes (1,0) if d>0 else (0,1). Sylvester's law of inertia makes
    # this the signature of G itself, since P is a real (indeed integral)
    # congruence.
    sig_from_split = (1 + (1 if d_computed > 0 else 0), 1 + (1 if d_computed < 0 else 0))
    cert_sig = tuple(derived["signature"])
    chk(sig_from_split == cert_sig,
        f"signature derived from the independent split {sig_from_split} != "
        f"certificate's claimed signature {cert_sig}")

    # informational cross-check against the certificate's own reported gram_after
    gram_after_matches = (PtGP == derived["u_splitting"]["gram_after"])

    if verbose:
        print(f"  G (from certificate)            = {G}")
        print(f"  det(G) independent               = {det_computed}  (cert: {cert_det})")
        print(f"  witness P (independently derived) = {P}")
        print(f"  det(P)                            = {detP}  (in GL_3(Z): {detP in (1, -1)})")
        print(f"  P^T G P                           = {PtGP}")
        print(f"  target U + <{d_target}>                 = {target}")
        print(f"  d independently computed          = {d_computed}  (cert claims d = {d_cert})")
        print(f"  signature independent             = {sig_from_split}  (cert: {cert_sig})")
        print(f"  matches cert's own gram_after      = {gram_after_matches}  (informational)")

    return {
        "det_computed": det_computed,
        "P": P,
        "detP": detP,
        "PtGP": PtGP,
        "target": target,
        "d_computed": d_computed,
        "signature_computed": sig_from_split,
        "gram_after_matches_cert": gram_after_matches,
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                  formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--cert", default=DEFAULT_CERT,
                     help="path to the C2_cooper_s7_v4(.json | _DRAFT.json) certificate "
                          "(default: Stream 2 repo's LIVE v4)")
    args = ap.parse_args()

    print("=" * 78)
    print("check_U1_splitting_independent.py — Stream 1 independent U1 verification")
    print("=" * 78)

    cert_path = Path(args.cert)
    if not cert_path.exists():
        print(f"FAIL: certificate not found at {cert_path}", file=sys.stderr)
        return 2

    digest = sha256(cert_path)
    cert = load_cert(cert_path)
    print(f"certificate : {cert_path}")
    print(f"sha256      : {digest}")
    print(f"status field: {cert.get('status')}")
    print()

    try:
        verify_certificate(cert, verbose=True)
    except VerificationFailure as e:
        print(f"\nFAIL: {e}", file=sys.stderr)
        print("=" * 78)
        print("VERDICT: FAIL")
        print("=" * 78)
        return 1

    print()
    print("=" * 78)
    print("VERDICT: PASS — the U-splitting claim (Gram isometric to U + <d>, d "
          "read from the certificate) is independently confirmed by a "
          "separately implemented, exact-integer construction.")
    print("Does NOT upgrade: the numerics->exact monodromy recognition step, or")
    print("the identification of this lattice with T (both remain Tier B).")
    print("=" * 78)
    return 0


if __name__ == "__main__":
    sys.exit(main())
