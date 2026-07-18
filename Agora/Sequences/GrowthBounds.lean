/-
  Agora/Sequences/GrowthBounds.lean
  ════════════════════════════════════════════════════════════════════════════════

  CORRECTION to `OpenGoals/CooperRecurrences.lean`'s `open_goal_s7_growth` /
  `open_goal_s10_growth` (T1 session, 2026-07-18).

  Those open goals asserted POLYNOMIAL growth (`∃ c k, ∀ n, s7 n ≤ c·(n+1)^k`),
  with a docstring claiming this is "expected from literature asymptotic
  analysis." Numerical check (25 terms, exact `math.comb` arithmetic) shows the
  growth ratio s7(n+1)/s7(n) climbs past 25 and s10(n+1)/s10(n) climbs past 15,
  monotonically, with no sign of leveling off — the signature of EXPONENTIAL
  growth, not polynomial. This matches standard asymptotic theory for D-finite
  (holonomic) sequences: a sequence satisfying a Picard-Fuchs-type recurrence
  with polynomial coefficients grows like ρ^n · n^α for ρ set by the nearest
  finite singularity of the recurrence, not polynomially — the original
  docstring's premise was wrong, not just hard to prove.

  This file proves the CORRECTED statement: s7 and s10 are provably NOT
  polynomially bounded. Method: both admit a clean single-term exponential
  lower bound via the central binomial coefficient (`Nat.centralBinom`,
  `Nat.four_pow_lt_mul_centralBinom` — a base-256 / base-16 bound respectively,
  weaker than the true asymptotic rate but sufficient to refute any polynomial
  bound), combined with Mathlib's `isLittleO_pow_const_const_pow_of_one_lt`
  (any fixed-degree polynomial is little-o of any exponential with base > 1).

  CLAUDE.md rule 6 ("never silently weaken a statement to make it provable"):
  this is not a weakening — it is a correction of a statement that was false as
  originally posed. The false open goals are removed from OpenGoals/ in the
  same commit; this file's theorems are the honest replacement, PROVED (0
  sorry), not open.

  0 sorry.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.CooperRecurrences
import Mathlib.Data.Nat.Choose.Central
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Tactic

namespace Agora.Sequences

open Finset Asymptotics Filter

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. SHARED ASYMPTOTIC LEMMA                                       ║
-- ║  If f(n) ≥ (centralBinom n)^p along a linear reindexing arg(n),    ║
-- ║  f cannot be polynomially bounded (centralBinom itself grows       ║
-- ║  exponentially: 4^n < n · centralBinom n for n ≥ 4).               ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- No fixed exponential (base `r > 1`) is eventually dominated by a fixed
    polynomial: for any `C r k` with `r > 1`, `C * n^k < r^n` for all large
    enough `n`. Packaged from Mathlib's little-o comparison so the two
    disproofs below don't repeat the filter bookkeeping. -/
private theorem exp_eventually_beats_poly (C : ℝ) (r : ℝ) (hr : 1 < r) (k : ℕ) :
    ∃ N : ℕ, ∀ n ≥ N, C * (n : ℝ) ^ k < r ^ n := by
  by_cases hC : C ≤ 0
  · refine ⟨0, fun n _ => ?_⟩
    have h1 : C * (n : ℝ) ^ k ≤ 0 := mul_nonpos_of_nonpos_of_nonneg hC (by positivity)
    have h2 : (0:ℝ) < r ^ n := by positivity
    linarith
  · simp only [not_le] at hC
    have hlittleo := isLittleO_pow_const_const_pow_of_one_lt (R := ℝ) k hr
    have heps := hlittleo.def (show (0:ℝ) < 1 / (2 * C) by positivity)
    rw [eventually_atTop] at heps
    obtain ⟨N, hN⟩ := heps
    refine ⟨N, fun n hn => ?_⟩
    have h := hN n hn
    simp only [Real.norm_eq_abs, abs_pow, abs_of_pos (show (0:ℝ) < r ^ n by positivity)] at h
    rw [abs_of_nonneg (show (0:ℝ) ≤ (n : ℝ) by positivity), div_mul_eq_mul_div,
      le_div_iff₀ (show (0:ℝ) < 2 * C by positivity)] at h
    have hpos : (0:ℝ) < r ^ n := by positivity
    nlinarith [h, hpos]

/-- If `f (arg n) ≥ centralBinom n ^ p` for all large `n`, with `arg` linearly
    bounded (`arg n ≤ A * n`), then `f` is not polynomially bounded. Both `s7`
    and `s10` instantiate this with `p = 2, arg = id` and `p = 4, arg = (2·)`
    respectively. -/
private theorem not_poly_bounded_of_centralBinom_le
    (f : ℕ → ℕ) (arg : ℕ → ℕ) (A p : ℕ) (hp : 0 < p)
    (harg : ∀ n, arg n ≤ A * n)
    (hlb : ∀ n, 4 ≤ n → Nat.centralBinom n ^ p ≤ f (arg n)) :
    ¬ ∃ c k : ℕ, ∀ n : ℕ, f n ≤ c * (n + 1) ^ k := by
  rintro ⟨c, k, hbound⟩
  -- Base exponential lower bound on centralBinom (Mathlib): 4^n < n · centralBinom n.
  have hcb : ∀ n : ℕ, 4 ≤ n → (4 ^ p) ^ n < n ^ p * Nat.centralBinom n ^ p := by
    intro n hn
    have h1 := Nat.four_pow_lt_mul_centralBinom n hn
    have h2 : (4 ^ n) ^ p < (n * Nat.centralBinom n) ^ p :=
      Nat.pow_lt_pow_left h1 hp.ne'
    calc (4 ^ p) ^ n = (4 ^ n) ^ p := by rw [← pow_mul, ← pow_mul, Nat.mul_comm]
      _ < (n * Nat.centralBinom n) ^ p := h2
      _ = n ^ p * Nat.centralBinom n ^ p := by rw [Nat.mul_pow]
  -- Chain (in ℕ): (4^p)^n < n^p · f(arg n) ≤ n^p · c · (arg n + 1)^k ≤ n^p · c · ((A+1)·n)^k.
  have hchainNat : ∀ n : ℕ, 4 ≤ n → 1 ≤ n →
      (4 ^ p) ^ n < n ^ p * (c * ((A + 1) * n) ^ k) := by
    intro n hn hn1
    have step1 : (4 ^ p) ^ n < n ^ p * f (arg n) :=
      (hcb n hn).trans_le (Nat.mul_le_mul_left _ (hlb n hn))
    have step2 : f (arg n) ≤ c * (arg n + 1) ^ k := hbound (arg n)
    have step3 : arg n + 1 ≤ (A + 1) * n := by
      have h0 := harg n
      have heq : (A + 1) * n = A * n + n := by ring
      omega
    calc (4 ^ p) ^ n < n ^ p * f (arg n) := step1
      _ ≤ n ^ p * (c * (arg n + 1) ^ k) := Nat.mul_le_mul_left _ step2
      _ ≤ n ^ p * (c * ((A + 1) * n) ^ k) := by gcongr
  -- cast to ℝ
  have hchain : ∀ n : ℕ, 4 ≤ n → 1 ≤ n →
      ((4 ^ p : ℕ) : ℝ) ^ n < (c : ℝ) * (A + 1 : ℝ) ^ k * (n : ℝ) ^ (p + k) := by
    intro n hn hn1
    calc ((4 ^ p : ℕ) : ℝ) ^ n = (((4 ^ p) ^ n : ℕ) : ℝ) := by push_cast; ring
      _ < ((n ^ p * (c * ((A + 1) * n) ^ k) : ℕ) : ℝ) := by exact_mod_cast hchainNat n hn hn1
      _ = (c : ℝ) * (A + 1 : ℝ) ^ k * (n : ℝ) ^ (p + k) := by
          push_cast
          rw [mul_pow]
          ring
  -- exponential (4^p, an integer ≥ 4 > 1) beats the polynomial n^(p+k) eventually
  obtain ⟨N, hN⟩ := exp_eventually_beats_poly ((c : ℝ) * (A + 1 : ℝ) ^ k)
    ((4 ^ p : ℕ) : ℝ) (by
      have h4p : (1 : ℕ) < 4 ^ p := Nat.one_lt_pow hp.ne' (by norm_num)
      exact_mod_cast h4p) (p + k)
  set n := max N 4 with hndef
  have hn4 : 4 ≤ n := le_max_right _ _
  have hn1 : 1 ≤ n := by omega
  have hnN : N ≤ n := le_max_left _ _
  linarith [hchain n hn4 hn1, hN n hnN]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. s10 IS NOT POLYNOMIALLY BOUNDED                                ║
-- ║  s10(2n) ≥ centralBinom(n)^4 (single term of the defining sum).    ║
-- ╚════════════════════════════════════════════════════════════════════╝

theorem s10_centralBinom_le (n : ℕ) : Nat.centralBinom n ^ 4 ≤ s10 (2 * n) := by
  have heq : Nat.centralBinom n = (2 * n).choose n := Nat.centralBinom_eq_two_mul_choose n
  unfold s10
  rw [heq]
  apply Finset.single_le_sum (f := fun j => ((2 * n).choose j) ^ 4)
  · intro i _; exact Nat.zero_le _
  · simp only [Finset.mem_range]; omega

/-- CORRECTED replacement for `OpenGoals.open_goal_s10_growth` (which claimed
    the false statement `∃ c k, ∀ n, s10 n ≤ c·(n+1)^k`): s10 grows faster
    than any polynomial. Kernel-proved, 0 sorry. -/
theorem s10_not_polynomially_bounded :
    ¬ ∃ c k : ℕ, ∀ n : ℕ, s10 n ≤ c * (n + 1) ^ k :=
  not_poly_bounded_of_centralBinom_le s10 (2 * ·) 2 4 (by norm_num)
    (fun n => le_refl _) (fun n _ => s10_centralBinom_le n)

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. s7 IS NOT POLYNOMIALLY BOUNDED                                 ║
-- ║  s7(n) ≥ centralBinom(n)^2 (the k = n term of the defining sum).   ║
-- ╚════════════════════════════════════════════════════════════════════╝

theorem s7_centralBinom_le (n : ℕ) : Nat.centralBinom n ^ 2 ≤ s7 n := by
  have hmem : n ∈ Finset.Icc ((n + 1) / 2) n := by
    simp only [Finset.mem_Icc]; omega
  have hterm : (n.choose n) ^ 2 * (n + n).choose n * (2 * n).choose n
      = Nat.centralBinom n ^ 2 := by
    rw [Nat.choose_self, show n + n = 2 * n from (two_mul n).symm,
      Nat.centralBinom_eq_two_mul_choose]
    ring
  unfold s7
  calc Nat.centralBinom n ^ 2
      = (n.choose n) ^ 2 * (n + n).choose n * (2 * n).choose n := hterm.symm
    _ ≤ ∑ k ∈ Finset.Icc ((n + 1) / 2) n,
          (n.choose k) ^ 2 * (n + k).choose k * (2 * k).choose n :=
        Finset.single_le_sum
          (f := fun k => (n.choose k) ^ 2 * (n + k).choose k * (2 * k).choose n)
          (fun i _ => Nat.zero_le _) hmem

/-- CORRECTED replacement for `OpenGoals.open_goal_s7_growth`. Kernel-proved,
    0 sorry. -/
theorem s7_not_polynomially_bounded :
    ¬ ∃ c k : ℕ, ∀ n : ℕ, s7 n ≤ c * (n + 1) ^ k :=
  not_poly_bounded_of_centralBinom_le s7 id 1 2 (by norm_num)
    (fun n => by simp) (fun n _ => s7_centralBinom_le n)

end Agora.Sequences
