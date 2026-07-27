#!/usr/bin/env python3
"""
test_U1_splitting_independent_controls.py — mandatory negative controls for
check_U1_splitting_independent.py. "A run without them is not evidence"
(the same standing rule Stream 2 states in docs/U1_ROUTE_DESIGN_2026_07_26.md
and applies here too).

Controls:
  1. SCRAMBLED G: perturb one entry of the certificate's Gram matrix. The
     independent splitting construction must either fail to find a valid
     GL_3(Z) witness, or find one whose target Gram no longer matches
     U + <14> — the checker must FAIL, not silently pass.
  2. SCRAMBLED P: take the correctly-derived witness P and corrupt one entry.
     The corrupted P must fail EITHER the det(P) = +-1 gate OR the
     P^T G P == target gate.
  3. NON-UNIMODULAR P: scale a column of the correct P by 2. det(P) becomes
     even, must be rejected by the GL_3(Z) gate.
  4. s10-ANALOG (mismatched-d) CROSS-CHECK: the certificate itself records,
     as its own "different_level_cooper_s10" control, that the identical
     Stream 2 pipeline run on cooper_s10 derives det = -20 (i.e. d = 20, not
     d = 14). Using ONLY that cert-recorded number (never a value typed from
     memory) to build the target U + <20>, checking the REAL s7 Gram against
     it must FAIL — the s7 geometry is not the s10 geometry. This is the s10
     analog required by the task brief; there is no standalone saved s10 U1
     certificate file in the Stream 2 repo to load directly (only this
     embedded control value), so this is exactly what "certificate ecosystem
     has an s10 analog" means here — documented, not fabricated.
  5. POSITIVE (sanity): the unmodified certificate must still PASS after all
     of the above scrambling helpers are exercised, proving the scrambling
     hooks are surgical and don't leak state.

Run:
  python3 checkers/test_U1_splitting_independent_controls.py
  pytest checkers/test_U1_splitting_independent_controls.py

Generated-by: Sonnet 5 (Stream 1) | Verified-by: this file IS the verifier for
check_U1_splitting_independent.py | Reviewed-by: pending T0 (Xavier)
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import check_U1_splitting_independent as U1I  # noqa: E402


def _load_real_cert():
    return U1I.load_cert(U1I.DEFAULT_CERT)


# ---------------------------------------------------------------------------
# 1. scrambled G
# ---------------------------------------------------------------------------

def test_scrambled_gram_fails():
    cert = _load_real_cert()

    def scramble(G):
        G = [list(row) for row in G]
        G[0][2] += 1  # -1 -> 0; breaks isotropy/unimodularity of the cusp vector
        G[2][0] += 1
        return G

    try:
        U1I.verify_certificate(cert, verbose=False, scramble_G=scramble)
    except U1I.VerificationFailure as e:
        return str(e)
    raise AssertionError("scrambled-G control FAILED: checker accepted a corrupted Gram")


# ---------------------------------------------------------------------------
# 2. scrambled P (post-hoc corruption of a correct witness)
# ---------------------------------------------------------------------------

def test_scrambled_witness_fails():
    cert = _load_real_cert()

    def scramble(P):
        P = [list(row) for row in P]
        P[0][1] += 1  # perturb one entry of the (previously correct) witness
        return P

    try:
        U1I.verify_certificate(cert, verbose=False, scramble_P=scramble)
    except U1I.VerificationFailure as e:
        return str(e)
    raise AssertionError("scrambled-P control FAILED: checker accepted a corrupted witness")


# ---------------------------------------------------------------------------
# 3. non-unimodular P (det != +-1)
# ---------------------------------------------------------------------------

def test_non_unimodular_witness_fails():
    cert = _load_real_cert()

    def scramble(P):
        P = [list(row) for row in P]
        for i in range(3):
            P[i][0] *= 2  # scale first column -> det doubles, leaves GL_3(Z)
        return P

    try:
        U1I.verify_certificate(cert, verbose=False, scramble_P=scramble)
    except U1I.VerificationFailure as e:
        assert "GL_3(Z)" in str(e), f"expected a GL_3(Z) rejection, got: {e}"
        return str(e)
    raise AssertionError("non-unimodular-P control FAILED: checker accepted det(P) != +-1")


# ---------------------------------------------------------------------------
# 4. s10-analog: mismatched target d must be rejected
# ---------------------------------------------------------------------------

def test_s10_analog_mismatched_d_fails():
    cert = _load_real_cert()
    d_s10 = cert["controls"]["different_level_cooper_s10"]["det"]
    assert d_s10 == -20, (
        "s10-analog control precondition changed: certificate no longer records "
        f"det=-20 for cooper_s10 (got {d_s10}); update this control's provenance note"
    )
    d_s10_target = -d_s10  # cert stores det = -d convention; d itself is |det|

    try:
        U1I.verify_certificate(cert, verbose=False, override_target_d=d_s10_target)
    except U1I.VerificationFailure as e:
        return str(e)
    raise AssertionError(
        "s10-analog control FAILED: the real s7 Gram matched the s10-level target "
        "U + <20> — the checker does not discriminate between families"
    )


# ---------------------------------------------------------------------------
# 5. positive sanity: unmodified run still passes after all the above
# ---------------------------------------------------------------------------

def test_unmodified_certificate_passes():
    cert = _load_real_cert()
    result = U1I.verify_certificate(cert, verbose=False)
    assert result["detP"] in (1, -1)
    assert result["PtGP"] == result["target"]
    assert result["d_computed"] == cert["derived"]["u_splitting"]["d"]
    return "unmodified certificate verified PASS as expected"


# ---------------------------------------------------------------------------
# runner (plain python3, no pytest dependency required)
# ---------------------------------------------------------------------------

CONTROLS = [
    ("scrambled-G (must FAIL)", test_scrambled_gram_fails),
    ("scrambled-P (must FAIL)", test_scrambled_witness_fails),
    ("non-unimodular-P (must FAIL)", test_non_unimodular_witness_fails),
    ("s10-analog mismatched-d (must FAIL)", test_s10_analog_mismatched_d_fails),
    ("unmodified certificate (must PASS)", test_unmodified_certificate_passes),
]


def main():
    print("=" * 78)
    print("test_U1_splitting_independent_controls.py")
    print("=" * 78)
    all_ok = True
    for name, fn in CONTROLS:
        try:
            detail = fn()
            ok = True
        except AssertionError as e:
            ok, detail = False, str(e)
        all_ok &= ok
        print(f"[{'PASS' if ok else 'FAIL'}] {name}")
        print(f"        {detail}")
    print("=" * 78)
    print(f"VERDICT: {'ALL CONTROLS PASS' if all_ok else 'CONTROL SUITE FAILED'}")
    print("=" * 78)
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
