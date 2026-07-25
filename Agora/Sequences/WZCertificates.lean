/-
  WZCertificates.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-09 — Wilf–Zeilberger creative-telescoping certificates discharging the
  three-term Cooper recurrences for the closed forms `s7` and `s10`
  (`Agora/Sequences/CooperRecurrences.lean`).

  PROVENANCE OF THE CERTIFICATE DATA (honest statement, per epistemic-guardrails):
  the rational-function certificates encoded below as `cert7` / `cert10` were NOT
  taken from a paper. Gorodetsky (arXiv:2102.11839) proves the s7/s10 recurrences
  by the constant-term / Laurent-polynomial method and supplies no explicit WZ
  certificate. The certificates here were derived by computer algebra (SageMath +
  `ore_algebra`, Zeilberger's algorithm) in this repo's
  `scripts/derive_wz_certificates_s7_s10.sage`; see
  `docs/WZ_CERTIFICATE_ANALYSIS.md` ADDENDUM 4 for the derivation trail.
  -- Source (certificate data): docs/WZ_CERTIFICATE_ANALYSIS.md ADDENDUM 4
     (SageMath 9.5 + ore_algebra commit 47e05a4, `ideal.ct()`), 2026-07-25.
  -- Source (recurrence being proved): S. Cooper, Ramanujan J. 29 (2012),
     163–183, Table 1; cross-checked O. Gorodetsky, Exp. Math. 32 (2023),
     arXiv:2102.11839, §2.

  The CAS origin of the certificate carries no trust weight in what follows: the
  certificate is a bare *witness*. Every statement below is proved from Mathlib's
  `Nat.choose` API by the Lean kernel, so the results are Tier A outright — a
  wrong certificate would simply fail to compile.

  DEPARTURE FROM THE RAW CAS OUTPUT (important, and the crux of the encoding).
  `ore_algebra` returns the certificate as `G(n,k) = R(n,k)·F(n,k)` with
  `R = N/D`, and for s7 `D(n,k) = 7(n−k+1)²(n−k+2)²`. That denominator VANISHES
  at `k = n+1` and `k = n+2`, which are inside the summation range, and the
  vanishing is a genuine `0/0`: `F` vanishes there too, with a nonzero limit.
  Relying on Lean's `x/0 = 0` junk convention to kill those terms gives a FALSE
  pointwise identity (checked numerically: it fails at `k = n, n+1, n+2`).

  The fix used here is to cancel the offending denominator symbolically before
  entering Lean. Since `C(n,k)·(n+1)(n+2) = C(n+2,k)·(n−k+1)(n−k+2)`, we have
      F(n,k) / (n−k+1)²(n−k+2)²  =  H(n,k) / (n+1)²(n+2)²
  where `H` is `F` with `C(n,k)` replaced by `C(n+2,k)`. The certificate then
  reads `G = cert·H / (n+1)²(n+2)²` with a denominator that never vanishes, and
  clearing it leaves a division-free identity over `ℤ`. So no `field_simp`, no
  nonvanishing side conditions, and no junk-value reasoning appears below.

  0 sorry in this file.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.CooperRecurrences

namespace Agora.Sequences.WZ

open Finset

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. ℤ-CAST PASCAL RATIO LEMMAS                                    ║
-- ║  Mathlib's ratio identities live in ℕ, where `n - k` truncates.    ║
-- ║  These cast them to ℤ, valid unconditionally: whenever the ℤ       ║
-- ║  subtraction would go negative the binomial coefficient is 0.      ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Upper-index ratio `C(n,k)(n+1) = C(n+1,k)(n+1−k)`, over `ℤ`, for all `n k`.
    ℤ-valued restatement of Mathlib's `Nat.choose_mul_succ_eq`. -/
theorem choose_mul_succ_int (n k : ℕ) :
    (n.choose k : ℤ) * ((n : ℤ) + 1) = ((n + 1).choose k : ℤ) * ((n : ℤ) + 1 - (k : ℤ)) := by
  by_cases h : k ≤ n + 1
  · have h0 := Nat.choose_mul_succ_eq n k
    have hc : ((n + 1 - k : ℕ) : ℤ) = (n : ℤ) + 1 - (k : ℤ) := by
      have := Nat.cast_sub (R := ℤ) h
      push_cast at this
      linarith [this]
    calc (n.choose k : ℤ) * ((n : ℤ) + 1)
        = ((n.choose k * (n + 1) : ℕ) : ℤ) := by push_cast; ring
      _ = (((n + 1).choose k * (n + 1 - k) : ℕ) : ℤ) := by rw [h0]
      _ = ((n + 1).choose k : ℤ) * ((n : ℤ) + 1 - (k : ℤ)) := by rw [Nat.cast_mul, hc]
  · rw [Nat.choose_eq_zero_of_lt (by omega), Nat.choose_eq_zero_of_lt (by omega)]
    simp

/-- Lower-index ratio `C(n,k+1)(k+1) = C(n,k)(n−k)`, over `ℤ`, for all `n k`.
    ℤ-valued restatement of Mathlib's `Nat.choose_succ_right_eq`. -/
theorem choose_succ_right_int (n k : ℕ) :
    (n.choose (k + 1) : ℤ) * ((k : ℤ) + 1) = (n.choose k : ℤ) * ((n : ℤ) - (k : ℤ)) := by
  by_cases h : k ≤ n
  · have h0 := Nat.choose_succ_right_eq n k
    have hc : ((n - k : ℕ) : ℤ) = (n : ℤ) - (k : ℤ) := Nat.cast_sub h
    calc (n.choose (k + 1) : ℤ) * ((k : ℤ) + 1)
        = ((n.choose (k + 1) * (k + 1) : ℕ) : ℤ) := by push_cast; ring
      _ = ((n.choose k * (n - k) : ℕ) : ℤ) := by rw [h0]
      _ = (n.choose k : ℤ) * ((n : ℤ) - (k : ℤ)) := by rw [Nat.cast_mul, hc]
  · rw [Nat.choose_eq_zero_of_lt (by omega), Nat.choose_eq_zero_of_lt (by omega)]
    simp

-- ── The three "atom" families. Every binomial factor occurring in the s7
-- ── telescoping identity is expressed against one of the three atoms
-- ──   A = C(n+2,k),  B = C(n+k,k),  Q = C(2k+2,n)
-- ── times a polynomial, divided by a factor that is NEVER zero for `n k : ℕ`
-- ── (a product of `n+1`, `n+2`, `k+1`, `2k+1`, `2k+2`). This is what makes the
-- ── whole proof division-free; see the header note.

/-- `C(n+1,k)(n+2) = A(n+2−k)` where `A = C(n+2,k)`. -/
theorem atom_A1 (n k : ℕ) :
    ((n + 1).choose k : ℤ) * ((n : ℤ) + 2) = ((n + 2).choose k : ℤ) * ((n : ℤ) + 2 - (k : ℤ)) := by
  have h := choose_mul_succ_int (n + 1) k
  push_cast at h
  linear_combination h

/-- `C(n,k)(n+1)(n+2) = A(n+1−k)(n+2−k)` where `A = C(n+2,k)`. -/
theorem atom_A0 (n k : ℕ) :
    (n.choose k : ℤ) * (((n : ℤ) + 1) * ((n : ℤ) + 2))
      = ((n + 2).choose k : ℤ) * (((n : ℤ) + 1 - (k : ℤ)) * ((n : ℤ) + 2 - (k : ℤ))) := by
  have h1 := choose_mul_succ_int n k
  have h2 := atom_A1 n k
  linear_combination ((n : ℤ) + 2) * h1 + ((n : ℤ) + 1 - (k : ℤ)) * h2

/-- `C(n+2,k+1)(k+1) = A(n+2−k)` where `A = C(n+2,k)`. -/
theorem atom_A2 (n k : ℕ) :
    ((n + 2).choose (k + 1) : ℤ) * ((k : ℤ) + 1)
      = ((n + 2).choose k : ℤ) * ((n : ℤ) + 2 - (k : ℤ)) := by
  have h := choose_succ_right_int (n + 2) k
  push_cast at h
  linear_combination h

/-- `C(n+k+1,k)(n+1) = B(n+k+1)` where `B = C(n+k,k)`. -/
theorem atom_B1 (n k : ℕ) :
    ((n + k + 1).choose k : ℤ) * ((n : ℤ) + 1)
      = ((n + k).choose k : ℤ) * ((n : ℤ) + (k : ℤ) + 1) := by
  have h := choose_mul_succ_int (n + k) k
  push_cast at h
  linear_combination -h

/-- `C(n+k+2,k)(n+1)(n+2) = B(n+k+1)(n+k+2)` where `B = C(n+k,k)`. -/
theorem atom_B2 (n k : ℕ) :
    ((n + k + 2).choose k : ℤ) * (((n : ℤ) + 1) * ((n : ℤ) + 2))
      = ((n + k).choose k : ℤ)
          * (((n : ℤ) + (k : ℤ) + 1) * ((n : ℤ) + (k : ℤ) + 2)) := by
  have h1 := choose_mul_succ_int (n + k + 1) k
  have h2 := atom_B1 n k
  push_cast at h1
  linear_combination (-((n : ℤ) + 1)) * h1 + ((n : ℤ) + (k : ℤ) + 2) * h2

/-- `C(n+k+1,k+1)(k+1) = B(n+k+1)` where `B = C(n+k,k)`. -/
theorem atom_B3 (n k : ℕ) :
    ((n + k + 1).choose (k + 1) : ℤ) * ((k : ℤ) + 1)
      = ((n + k).choose k : ℤ) * ((n : ℤ) + (k : ℤ) + 1) := by
  have h1 := choose_succ_right_int (n + k + 1) k
  have h2 := atom_B1 n k
  push_cast at h1
  linear_combination h1 + h2

/-- `C(2k,n)(2k+2)(2k+1) = Q(2k+2−n)(2k+1−n)` where `Q = C(2k+2,n)`. -/
theorem atom_Q0 (n k : ℕ) :
    ((2 * k).choose n : ℤ) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1))
      = ((2 * k + 2).choose n : ℤ)
          * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ))) := by
  have h1 := choose_mul_succ_int (2 * k) n
  have h2 := choose_mul_succ_int (2 * k + 1) n
  push_cast at h1 h2
  linear_combination (2 * (k : ℤ) + 2) * h1 + (2 * (k : ℤ) + 1 - (n : ℤ)) * h2

/-- `C(2k,n+1)(n+1)(2k+2)(2k+1) = Q(2k+2−n)(2k+1−n)(2k−n)`. -/
theorem atom_Q1 (n k : ℕ) :
    ((2 * k).choose (n + 1) : ℤ)
        * (((n : ℤ) + 1) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))
      = ((2 * k + 2).choose n : ℤ)
          * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ))
             * (2 * (k : ℤ) - (n : ℤ))) := by
  have h1 := choose_succ_right_int (2 * k) n
  have h2 := atom_Q0 n k
  push_cast at h1
  linear_combination ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)) * h1
    + (2 * (k : ℤ) - (n : ℤ)) * h2

/-- `C(2k,n+2)(n+1)(n+2)(2k+2)(2k+1) = Q(2k+2−n)(2k+1−n)(2k−n)(2k−n−1)`. -/
theorem atom_Q2 (n k : ℕ) :
    ((2 * k).choose (n + 2) : ℤ)
        * ((((n : ℤ) + 1) * ((n : ℤ) + 2)) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))
      = ((2 * k + 2).choose n : ℤ)
          * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ))
             * (2 * (k : ℤ) - (n : ℤ)) * (2 * (k : ℤ) - (n : ℤ) - 1)) := by
  have h1 := choose_succ_right_int (2 * k) (n + 1)
  have h2 := atom_Q1 n k
  push_cast at h1
  linear_combination (((n : ℤ) + 1) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1))) * h1
    + (2 * (k : ℤ) - (n : ℤ) - 1) * h2

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE s7 SUMMAND, ITS RESCALED PARTNER, AND THE CERTIFICATE     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The s7 summand `F(n,k) = C(n,k)²·C(n+k,k)·C(2k,n)`; `s7 n = Σ_k F n k`.
    -- Source: the summand of `Agora.Sequences.s7` (Gorodetsky arXiv:2102.11839,
    closed form for s₇). -/
def F7 (n k : ℕ) : ℕ := (n.choose k) ^ 2 * ((n + k).choose k) * ((2 * k).choose n)

/-- `F7` with `C(n,k)` replaced by `C(n+2,k)`. This is the rescaling that
    cancels the certificate's `(n−k+1)²(n−k+2)²` denominator; see header. -/
def H7 (n k : ℕ) : ℕ := ((n + 2).choose k) ^ 2 * ((n + k).choose k) * ((2 * k).choose n)

/-- Numerator of the s7 WZ certificate, as a polynomial in `ℤ`.
    -- Source: docs/WZ_CERTIFICATE_ANALYSIS.md ADDENDUM 4; regenerate with
    `sage scripts/derive_wz_certificates_s7_s10.sage`. Total degree 7,
    19 terms. -/
def cert7 (x y : ℤ) : ℤ :=
  7 * x ^ 5 * y ^ 2 - 54 * x ^ 4 * y ^ 3 + 147 * x ^ 3 * y ^ 4 - 164 * x ^ 2 * y ^ 5
    + 60 * x * y ^ 6
  + 46 * x ^ 4 * y ^ 2 - 287 * x ^ 3 * y ^ 3 + 609 * x ^ 2 * y ^ 4 - 482 * x * y ^ 5
    + 88 * y ^ 6
  + 111 * x ^ 3 * y ^ 2 - 535 * x ^ 2 * y ^ 3 + 804 * x * y ^ 4 - 356 * y ^ 5
  + 116 * x ^ 2 * y ^ 2 - 398 * x * y ^ 3 + 332 * y ^ 4 + 44 * x * y ^ 2 - 88 * y ^ 3

/-- The WZ certificate function `G(n,k)`, in the division-free rescaled form. -/
def G7 (n k : ℕ) : ℤ := cert7 (n : ℤ) (k : ℤ) * (H7 n k : ℤ)

-- ── The five "cleared" lemmas: each quantity entering the telescoping identity,
-- ── multiplied by a never-zero polynomial, equals `A²·B·Q` times a polynomial.

private theorem clr_F0 (n k : ℕ) :
    (F7 n k : ℤ) * ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2
        * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))
      = ((n + 2).choose k : ℤ) ^ 2 * ((n + k).choose k : ℤ) * ((2 * k + 2).choose n : ℤ)
        * ((((n : ℤ) + 1 - (k : ℤ)) * ((n : ℤ) + 2 - (k : ℤ))) ^ 2
           * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ)))) := by
  calc (F7 n k : ℤ) * ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2
          * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))
      = ((n.choose k : ℤ) * (((n : ℤ) + 1) * ((n : ℤ) + 2))) ^ 2
        * ((n + k).choose k : ℤ)
        * (((2 * k).choose n : ℤ) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1))) := by
        simp only [F7]; push_cast; ring
    _ = (((n + 2).choose k : ℤ) * (((n : ℤ) + 1 - (k : ℤ)) * ((n : ℤ) + 2 - (k : ℤ)))) ^ 2
        * ((n + k).choose k : ℤ)
        * (((2 * k + 2).choose n : ℤ)
           * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ)))) := by
        rw [atom_A0, atom_Q0]
    _ = _ := by ring

private theorem clr_F1 (n k : ℕ) :
    (F7 (n + 1) k : ℤ) * ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2
        * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))
      = ((n + 2).choose k : ℤ) ^ 2 * ((n + k).choose k : ℤ) * ((2 * k + 2).choose n : ℤ)
        * (((n : ℤ) + 2 - (k : ℤ)) ^ 2 * ((n : ℤ) + (k : ℤ) + 1)
           * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ))
              * (2 * (k : ℤ) - (n : ℤ)))) := by
  calc (F7 (n + 1) k : ℤ) * ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2
          * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))
      = (((n + 1).choose k : ℤ) * ((n : ℤ) + 2)) ^ 2
        * (((n + k + 1).choose k : ℤ) * ((n : ℤ) + 1))
        * (((2 * k).choose (n + 1) : ℤ)
           * (((n : ℤ) + 1) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))) := by
        simp only [F7]
        rw [show n + 1 + k = n + k + 1 by ring]
        push_cast; ring
    _ = (((n + 2).choose k : ℤ) * ((n : ℤ) + 2 - (k : ℤ))) ^ 2
        * (((n + k).choose k : ℤ) * ((n : ℤ) + (k : ℤ) + 1))
        * (((2 * k + 2).choose n : ℤ)
           * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ))
              * (2 * (k : ℤ) - (n : ℤ)))) := by
        rw [atom_A1, atom_B1, atom_Q1]
    _ = _ := by ring

private theorem clr_F2 (n k : ℕ) :
    (F7 (n + 2) k : ℤ) * ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2
        * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))
      = ((n + 2).choose k : ℤ) ^ 2 * ((n + k).choose k : ℤ) * ((2 * k + 2).choose n : ℤ)
        * ((((n : ℤ) + (k : ℤ) + 1) * ((n : ℤ) + (k : ℤ) + 2))
           * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ))
              * (2 * (k : ℤ) - (n : ℤ)) * (2 * (k : ℤ) - (n : ℤ) - 1))) := by
  calc (F7 (n + 2) k : ℤ) * ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2
          * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))
      = ((n + 2).choose k : ℤ) ^ 2
        * (((n + k + 2).choose k : ℤ) * (((n : ℤ) + 1) * ((n : ℤ) + 2)))
        * (((2 * k).choose (n + 2) : ℤ)
           * ((((n : ℤ) + 1) * ((n : ℤ) + 2)) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1)))) := by
        simp only [F7]
        rw [show n + 2 + k = n + k + 2 by ring]
        push_cast; ring
    _ = ((n + 2).choose k : ℤ) ^ 2
        * (((n + k).choose k : ℤ) * (((n : ℤ) + (k : ℤ) + 1) * ((n : ℤ) + (k : ℤ) + 2)))
        * (((2 * k + 2).choose n : ℤ)
           * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ))
              * (2 * (k : ℤ) - (n : ℤ)) * (2 * (k : ℤ) - (n : ℤ) - 1))) := by
        rw [atom_B2, atom_Q2]
    _ = _ := by ring

private theorem clr_H0 (n k : ℕ) :
    (H7 n k : ℤ) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1))
      = ((n + 2).choose k : ℤ) ^ 2 * ((n + k).choose k : ℤ) * ((2 * k + 2).choose n : ℤ)
        * ((2 * (k : ℤ) + 2 - (n : ℤ)) * (2 * (k : ℤ) + 1 - (n : ℤ))) := by
  calc (H7 n k : ℤ) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1))
      = ((n + 2).choose k : ℤ) ^ 2 * ((n + k).choose k : ℤ)
        * (((2 * k).choose n : ℤ) * ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1))) := by
        simp only [H7]; push_cast; ring
    _ = _ := by rw [atom_Q0]; ring

private theorem clr_H1 (n k : ℕ) :
    (H7 n (k + 1) : ℤ) * ((k : ℤ) + 1) ^ 3
      = ((n + 2).choose k : ℤ) ^ 2 * ((n + k).choose k : ℤ) * ((2 * k + 2).choose n : ℤ)
        * (((n : ℤ) + 2 - (k : ℤ)) ^ 2 * ((n : ℤ) + (k : ℤ) + 1)) := by
  calc (H7 n (k + 1) : ℤ) * ((k : ℤ) + 1) ^ 3
      = (((n + 2).choose (k + 1) : ℤ) * ((k : ℤ) + 1)) ^ 2
        * (((n + k + 1).choose (k + 1) : ℤ) * ((k : ℤ) + 1))
        * ((2 * k + 2).choose n : ℤ) := by
        simp only [H7]
        rw [show n + (k + 1) = n + k + 1 by ring, show 2 * (k + 1) = 2 * k + 2 by ring]
        push_cast; ring
    _ = (((n + 2).choose k : ℤ) * ((n : ℤ) + 2 - (k : ℤ))) ^ 2
        * (((n + k).choose k : ℤ) * ((n : ℤ) + (k : ℤ) + 1))
        * ((2 * k + 2).choose n : ℤ) := by
        rw [atom_A2, atom_B3]
    _ = _ := by ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE POINTWISE TELESCOPING IDENTITY FOR s7                     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The WZ pointwise identity for s7, over `ℤ`, valid for ALL `n k : ℕ` with no
    side conditions. Summing this over `k` and telescoping the right-hand side
    yields Cooper's three-term recurrence.

    The `n`-coefficients are Cooper's `s7_params = (13,4,−27,3)` recurrence
    written at index `n+1` (so that it relates indices `n, n+1, n+2`):
    `(2n+3)(13(n+1)²+13(n+1)+4) = 26n³+117n²+177n+90` and
    `(n+1)(27(n+1)²−3) = 27n³+81n²+78n+24`. -/
theorem tele7 (n k : ℕ) :
    (((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2 *
      (((n : ℤ) + 2) ^ 3 * (F7 (n + 2) k : ℤ)
        - (26 * (n : ℤ) ^ 3 + 117 * (n : ℤ) ^ 2 + 177 * (n : ℤ) + 90) * (F7 (n + 1) k : ℤ)
        - (27 * (n : ℤ) ^ 3 + 81 * (n : ℤ) ^ 2 + 78 * (n : ℤ) + 24) * (F7 n k : ℤ))
      = G7 n (k + 1) - G7 n k := by
  have hM : ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1) * ((k : ℤ) + 1) ^ 3) ≠ 0 := by positivity
  apply mul_left_cancel₀ hM
  simp only [G7]
  push_cast
  linear_combination (norm := (simp only [cert7]; ring1))
      (((k : ℤ) + 1) ^ 3 * ((n : ℤ) + 2) ^ 3) * clr_F2 n k
    - (((k : ℤ) + 1) ^ 3 * (26 * (n : ℤ) ^ 3 + 117 * (n : ℤ) ^ 2 + 177 * (n : ℤ) + 90))
        * clr_F1 n k
    - (((k : ℤ) + 1) ^ 3 * (27 * (n : ℤ) ^ 3 + 81 * (n : ℤ) ^ 2 + 78 * (n : ℤ) + 24))
        * clr_F0 n k
    - ((2 * (k : ℤ) + 2) * (2 * (k : ℤ) + 1) * cert7 (n : ℤ) ((k : ℤ) + 1)) * clr_H1 n k
    + (((k : ℤ) + 1) ^ 3 * cert7 (n : ℤ) (k : ℤ)) * clr_H0 n k

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. RANGE EXTENSION AND BOUNDARY COLLAPSE                         ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `F7 m k` vanishes outside the true summation range `⌈m/2⌉ ≤ k ≤ m`:
    above by `C(m,k) = 0`, below by `C(2k,m) = 0`. -/
theorem F7_eq_zero_of_not_mem (m k : ℕ) (h : k ∉ Finset.Icc ((m + 1) / 2) m) :
    F7 m k = 0 := by
  simp only [Finset.mem_Icc, not_and_or, not_le] at h
  rcases h with h | h
  · have : 2 * k < m := by omega
    simp [F7, Nat.choose_eq_zero_of_lt this]
  · simp [F7, Nat.choose_eq_zero_of_lt h]

/-- `s7 m`, as a sum over any range `[0, N)` containing `[0, m]`. -/
theorem s7_eq_sum_range (m N : ℕ) (h : m < N) :
    (s7 m : ℤ) = ∑ k ∈ Finset.range N, (F7 m k : ℤ) := by
  have hsub : Finset.Icc ((m + 1) / 2) m ⊆ Finset.range N := by
    intro x hx
    simp only [Finset.mem_Icc] at hx
    simp only [Finset.mem_range]
    omega
  have hext := Finset.sum_subset (f := fun k => (F7 m k : ℤ)) hsub
    (fun x _ hx => by rw [F7_eq_zero_of_not_mem m x hx]; simp)
  rw [← hext, s7]
  push_cast [F7]
  rfl

/-- `H7 n k = 0` once `k` passes `n+2`, because `C(n+2,k) = 0`. -/
theorem H7_eq_zero_of_gt (n k : ℕ) (h : n + 2 < k) : H7 n k = 0 := by
  simp [H7, Nat.choose_eq_zero_of_lt h]

/-- Top boundary of the telescoping sum. -/
theorem G7_top (n : ℕ) : G7 n (n + 3) = 0 := by
  simp [G7, H7_eq_zero_of_gt n (n + 3) (by omega)]

/-- Bottom boundary of the telescoping sum: `cert7` has no `k`-free monomial. -/
theorem G7_bot (n : ℕ) : G7 n 0 = 0 := by
  simp [G7, cert7]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §5. THE s7 RECURRENCE                                             ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Cooper's three-term recurrence for `s7`, stated at indices `n, n+1, n+2`.
    Proved by summing `tele7` over `k ∈ [0, n+2]`; the right-hand side
    telescopes to `G7 n (n+3) − G7 n 0 = 0`. -/
theorem s7_recurrence_shifted (n : ℕ) :
    ((n : ℤ) + 2) ^ 3 * (s7 (n + 2) : ℤ)
      = (26 * (n : ℤ) ^ 3 + 117 * (n : ℤ) ^ 2 + 177 * (n : ℤ) + 90) * (s7 (n + 1) : ℤ)
        + (27 * (n : ℤ) ^ 3 + 81 * (n : ℤ) ^ 2 + 78 * (n : ℤ) + 24) * (s7 n : ℤ) := by
  have key : ∑ k ∈ Finset.range (n + 3), (G7 n (k + 1) - G7 n k) = 0 := by
    rw [Finset.sum_range_sub (fun k => G7 n k) (n + 3), G7_top, G7_bot]
    ring
  have hsum : ∑ k ∈ Finset.range (n + 3),
      ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2 *
        (((n : ℤ) + 2) ^ 3 * (F7 (n + 2) k : ℤ)
          - (26 * (n : ℤ) ^ 3 + 117 * (n : ℤ) ^ 2 + 177 * (n : ℤ) + 90) * (F7 (n + 1) k : ℤ)
          - (27 * (n : ℤ) ^ 3 + 81 * (n : ℤ) ^ 2 + 78 * (n : ℤ) + 24) * (F7 n k : ℤ))) = 0 := by
    rw [← key]
    exact Finset.sum_congr rfl (fun k _ => tele7 n k)
  rw [← Finset.mul_sum, Finset.sum_sub_distrib, Finset.sum_sub_distrib,
      ← Finset.mul_sum, ← Finset.mul_sum, ← Finset.mul_sum,
      ← s7_eq_sum_range (n + 2) (n + 3) (by omega),
      ← s7_eq_sum_range (n + 1) (n + 3) (by omega),
      ← s7_eq_sum_range n (n + 3) (by omega)] at hsum
  have hC : ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 2) ≠ 0 := by positivity
  have hbr := (mul_eq_zero.mp hsum).resolve_left hC
  linear_combination hbr

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §6. MATCHING COOPER'S TEMPLATE                                    ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **`s7` satisfies Cooper's three-term recurrence with parameters
    `s7_params = (13, 4, −27, 3)`.** Kernel-proved; no axioms, no
    `native_decide`, no `sorry`. -/
theorem s7_satisfies : SatisfiesCooperRecurrence (fun n => (s7 n : ℤ)) s7_params := by
  intro n hn
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
  have h := s7_recurrence_shifted m
  simp only [s7_params, Nat.add_sub_cancel]
  push_cast
  linear_combination h

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §7. COOPER'S s10 = Σ_k C(n,k)⁴                                     ║
-- ║  Same architecture, and simpler: the summand has a single binomial  ║
-- ║  factor, so only the `A = C(n+2,k)` atom family is needed.          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The s10 summand `F(n,k) = C(n,k)⁴`; `s10 n = Σ_k F n k`.
    -- Source: the summand of `Agora.Sequences.s10` (Gorodetsky
    arXiv:2102.11839, closed form for s₁₀; "Yang–Zudilin numbers"). -/
def F10 (n k : ℕ) : ℕ := (n.choose k) ^ 4

/-- `F10` with `C(n,k)` replaced by `C(n+2,k)`; cancels the certificate's
    `(n−k+1)⁴(n−k+2)⁴` denominator exactly as `H7` does for s7. -/
def H10 (n k : ℕ) : ℕ := ((n + 2).choose k) ^ 4

/-- Numerator of the s10 WZ certificate (sign-flipped so that the telescoping
    identity reads `… = G(n,k+1) − G(n,k)` with no extra scalar).
    -- Source: docs/WZ_CERTIFICATE_ANALYSIS.md ADDENDUM 4; regenerate with
    `sage scripts/derive_wz_certificates_s7_s10.sage`. Total degree 11,
    33 terms. -/
def cert10 (x y : ℤ) : ℤ :=
  -75 * x ^ 7 * y ^ 4 + 260 * x ^ 6 * y ^ 5 - 374 * x ^ 5 * y ^ 6 + 276 * x ^ 4 * y ^ 7
    - 104 * x ^ 3 * y ^ 8 + 16 * x ^ 2 * y ^ 9
  - 800 * x ^ 6 * y ^ 4 + 2316 * x ^ 5 * y ^ 5 - 2688 * x ^ 4 * y ^ 6 + 1520 * x ^ 3 * y ^ 7
    - 402 * x ^ 2 * y ^ 8 + 36 * x * y ^ 9
  - 3610 * x ^ 5 * y ^ 4 + 8476 * x ^ 4 * y ^ 5 - 7612 * x ^ 3 * y ^ 6 + 3088 * x ^ 2 * y ^ 7
    - 508 * x * y ^ 8 + 20 * y ^ 9
  - 8930 * x ^ 4 * y ^ 4 + 16312 * x ^ 3 * y ^ 5 - 10620 * x ^ 2 * y ^ 6 + 2744 * x * y ^ 7
    - 210 * y ^ 8
  - 13075 * x ^ 3 * y ^ 4 + 17412 * x ^ 2 * y ^ 5 - 7302 * x * y ^ 6 + 900 * y ^ 7
  - 11330 * x ^ 2 * y ^ 4 + 9776 * x * y ^ 5 - 1980 * y ^ 6
  - 5380 * x * y ^ 4 + 2256 * y ^ 5 - 1080 * y ^ 4

/-- The s10 WZ certificate function, in the division-free rescaled form. -/
def G10 (n k : ℕ) : ℤ := cert10 (n : ℤ) (k : ℤ) * (H10 n k : ℤ)

private theorem clr10_F0 (n k : ℕ) :
    (F10 n k : ℤ) * (((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 4
      = ((n + 2).choose k : ℤ) ^ 4
        * (((n : ℤ) + 1 - (k : ℤ)) * ((n : ℤ) + 2 - (k : ℤ))) ^ 4 := by
  calc (F10 n k : ℤ) * (((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 4
      = ((n.choose k : ℤ) * (((n : ℤ) + 1) * ((n : ℤ) + 2))) ^ 4 := by
        simp only [F10]; push_cast; ring
    _ = (((n + 2).choose k : ℤ) * (((n : ℤ) + 1 - (k : ℤ)) * ((n : ℤ) + 2 - (k : ℤ)))) ^ 4 := by
        rw [atom_A0]
    _ = _ := by ring

private theorem clr10_F1 (n k : ℕ) :
    (F10 (n + 1) k : ℤ) * ((n : ℤ) + 2) ^ 4
      = ((n + 2).choose k : ℤ) ^ 4 * ((n : ℤ) + 2 - (k : ℤ)) ^ 4 := by
  calc (F10 (n + 1) k : ℤ) * ((n : ℤ) + 2) ^ 4
      = (((n + 1).choose k : ℤ) * ((n : ℤ) + 2)) ^ 4 := by
        simp only [F10]; push_cast; ring
    _ = (((n + 2).choose k : ℤ) * ((n : ℤ) + 2 - (k : ℤ))) ^ 4 := by rw [atom_A1]
    _ = _ := by ring

private theorem clr10_F2 (n k : ℕ) :
    (F10 (n + 2) k : ℤ) = ((n + 2).choose k : ℤ) ^ 4 := by
  simp only [F10]; push_cast; ring

private theorem clr10_H0 (n k : ℕ) :
    (H10 n k : ℤ) = ((n + 2).choose k : ℤ) ^ 4 := by
  simp only [H10]; push_cast; ring

private theorem clr10_H1 (n k : ℕ) :
    (H10 n (k + 1) : ℤ) * ((k : ℤ) + 1) ^ 4
      = ((n + 2).choose k : ℤ) ^ 4 * ((n : ℤ) + 2 - (k : ℤ)) ^ 4 := by
  calc (H10 n (k + 1) : ℤ) * ((k : ℤ) + 1) ^ 4
      = (((n + 2).choose (k + 1) : ℤ) * ((k : ℤ) + 1)) ^ 4 := by
        simp only [H10]; push_cast; ring
    _ = (((n + 2).choose k : ℤ) * ((n : ℤ) + 2 - (k : ℤ))) ^ 4 := by rw [atom_A2]
    _ = _ := by ring

/-- The WZ pointwise identity for s10, over `ℤ`, valid for ALL `n k : ℕ`.

    The `n`-coefficients are Cooper's `s10_params = (6, 2, −64, 4)` recurrence
    written at index `n+1`: `(2n+3)(6(n+1)²+6(n+1)+2) = 12n³+54n²+82n+42` and
    `(n+1)(64(n+1)²−4) = 64n³+192n²+188n+60`. -/
theorem tele10 (n k : ℕ) :
    (((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 4 *
      (((n : ℤ) + 2) ^ 3 * (F10 (n + 2) k : ℤ)
        - (12 * (n : ℤ) ^ 3 + 54 * (n : ℤ) ^ 2 + 82 * (n : ℤ) + 42) * (F10 (n + 1) k : ℤ)
        - (64 * (n : ℤ) ^ 3 + 192 * (n : ℤ) ^ 2 + 188 * (n : ℤ) + 60) * (F10 n k : ℤ))
      = G10 n (k + 1) - G10 n k := by
  have hM : (((k : ℤ) + 1) ^ 4) ≠ 0 := by positivity
  apply mul_left_cancel₀ hM
  simp only [G10]
  push_cast
  linear_combination (norm := (simp only [cert10]; ring1))
      (((k : ℤ) + 1) ^ 4 * (((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 4 * ((n : ℤ) + 2) ^ 3)
        * clr10_F2 n k
    - (((k : ℤ) + 1) ^ 4 * ((n : ℤ) + 1) ^ 4
        * (12 * (n : ℤ) ^ 3 + 54 * (n : ℤ) ^ 2 + 82 * (n : ℤ) + 42)) * clr10_F1 n k
    - (((k : ℤ) + 1) ^ 4
        * (64 * (n : ℤ) ^ 3 + 192 * (n : ℤ) ^ 2 + 188 * (n : ℤ) + 60)) * clr10_F0 n k
    - cert10 (n : ℤ) ((k : ℤ) + 1) * clr10_H1 n k
    + (((k : ℤ) + 1) ^ 4 * cert10 (n : ℤ) (k : ℤ)) * clr10_H0 n k

/-- `s10 m`, as a sum over any range `[0, N)` containing `[0, m]`. -/
theorem s10_eq_sum_range (m N : ℕ) (h : m < N) :
    (s10 m : ℤ) = ∑ k ∈ Finset.range N, (F10 m k : ℤ) := by
  have hsub : Finset.range (m + 1) ⊆ Finset.range N := by
    intro x hx
    simp only [Finset.mem_range] at hx ⊢
    omega
  have hext := Finset.sum_subset (f := fun k => (F10 m k : ℤ)) hsub
    (fun x _ hx => by
      simp only [Finset.mem_range, not_lt] at hx
      simp [F10, Nat.choose_eq_zero_of_lt (by omega : m < x)])
  rw [← hext, s10]
  push_cast [F10]
  rfl

/-- `H10 n k = 0` once `k` passes `n+2`, because `C(n+2,k) = 0`. -/
theorem H10_eq_zero_of_gt (n k : ℕ) (h : n + 2 < k) : H10 n k = 0 := by
  simp [H10, Nat.choose_eq_zero_of_lt h]

/-- Top boundary of the telescoping sum. -/
theorem G10_top (n : ℕ) : G10 n (n + 3) = 0 := by
  simp [G10, H10_eq_zero_of_gt n (n + 3) (by omega)]

/-- Bottom boundary of the telescoping sum: `cert10` has no `k`-free monomial. -/
theorem G10_bot (n : ℕ) : G10 n 0 = 0 := by
  simp [G10, cert10]

/-- Cooper's three-term recurrence for `s10`, stated at indices `n, n+1, n+2`. -/
theorem s10_recurrence_shifted (n : ℕ) :
    ((n : ℤ) + 2) ^ 3 * (s10 (n + 2) : ℤ)
      = (12 * (n : ℤ) ^ 3 + 54 * (n : ℤ) ^ 2 + 82 * (n : ℤ) + 42) * (s10 (n + 1) : ℤ)
        + (64 * (n : ℤ) ^ 3 + 192 * (n : ℤ) ^ 2 + 188 * (n : ℤ) + 60) * (s10 n : ℤ) := by
  have key : ∑ k ∈ Finset.range (n + 3), (G10 n (k + 1) - G10 n k) = 0 := by
    rw [Finset.sum_range_sub (fun k => G10 n k) (n + 3), G10_top, G10_bot]
    ring
  have hsum : ∑ k ∈ Finset.range (n + 3),
      ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 4 *
        (((n : ℤ) + 2) ^ 3 * (F10 (n + 2) k : ℤ)
          - (12 * (n : ℤ) ^ 3 + 54 * (n : ℤ) ^ 2 + 82 * (n : ℤ) + 42) * (F10 (n + 1) k : ℤ)
          - (64 * (n : ℤ) ^ 3 + 192 * (n : ℤ) ^ 2 + 188 * (n : ℤ) + 60) * (F10 n k : ℤ))) = 0 := by
    rw [← key]
    exact Finset.sum_congr rfl (fun k _ => tele10 n k)
  rw [← Finset.mul_sum, Finset.sum_sub_distrib, Finset.sum_sub_distrib,
      ← Finset.mul_sum, ← Finset.mul_sum, ← Finset.mul_sum,
      ← s10_eq_sum_range (n + 2) (n + 3) (by omega),
      ← s10_eq_sum_range (n + 1) (n + 3) (by omega),
      ← s10_eq_sum_range n (n + 3) (by omega)] at hsum
  have hC : ((((n : ℤ) + 1) * ((n : ℤ) + 2)) ^ 4) ≠ 0 := by positivity
  have hbr := (mul_eq_zero.mp hsum).resolve_left hC
  linear_combination hbr

/-- **`s10` satisfies Cooper's three-term recurrence with parameters
    `s10_params = (6, 2, −64, 4)`.** Kernel-proved; no axioms, no
    `native_decide`, no `sorry`. -/
theorem s10_satisfies : SatisfiesCooperRecurrence (fun n => (s10 n : ℤ)) s10_params := by
  intro n hn
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
  have h := s10_recurrence_shifted m
  simp only [s10_params, Nat.add_sub_cancel]
  push_cast
  linear_combination h

end Agora.Sequences.WZ
