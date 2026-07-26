/-
  FormalSqrt.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-12 — the formal square root of an integer sequence, and the dyadic
  baseline theorem (Deep Think Q6, algebraic half, made kernel-checked).

  CONTEXT. Deep Think's 2026-07-26 literature answer to Q6 of
  `briefs/DEEPTHINK_LITERATURE_REVIEW_L2_PARTNERS_2026-07-25.md` claims the
  2-power denominators observed in the s10/s18 partner series are not a
  level-specific anomaly but the DEFAULT for any square root of an integer
  series: expanding `√(1 + c₁z + …)` can only ever produce powers of 2 in
  denominators. That is an exact algebraic claim, so per the standing rule
  (recompute, don't inherit — E-007/E-010) it is proved here rather than cited:

    `sqrtSeq_dyadic` — for EVERY `s : ℕ → ℤ`, every coefficient of the formal
    square root of `Σ s(n)zⁿ` (normalised `b₀ = 1`) lies in `ℤ[1/2]`.

  Consequences for the Cooper program, stated precisely:
  * s10/s18: their partners' non-integrality (`s10_partner_not_integral`,
    `s18_partner_not_integral`, PartnerIntegrality.lean) is the BASELINE
    behaviour, not a pathology. The right reading of the candidate separation is
    not "s10/s18 are broken" but "s7 is the anomaly".
  * s7: IF the partner equals this formal square root (the bridge — CAS-verified
    to n = 59, named open goal `open_goal_partner_eq_sqrt_s7`), then its
    integrality question REDUCES to a purely 2-adic statement: no odd prime can
    occur in any denominator. The odd primes introduced by the `(k+2)²` division
    in the partner recurrence must always cancel — and via the bridge, that
    cancellation is this file's theorem, not a conjecture.

  What is NOT claimed: nothing here identifies WHY 2 cancels for s7
  specifically. Deep Think attributes it to the level-7 modular parametrisation
  (integral weight-1 form + integral Hauptmodul); that is a [B] claim tracked in
  `briefs/DEEPTHINK_L2_PARTNERS_RESPONSE_2026_07_26.md`, not formalised here.

  0 sorry in this file.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Mathlib.Data.Rat.Defs
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic

namespace Agora.Sequences.FormalSqrt

open Finset

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE FORMAL SQUARE ROOT                                        ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The formal square root of the power series `Σ s(n)zⁿ`, coefficient-wise:
    the unique `ℚ`-sequence with `b₀ = 1` whose Cauchy self-convolution
    reproduces `s` (uniqueness because the leading coefficient of the
    convolution is `2b₀ = 2 ≠ 0`; the reproduction itself is `sqrtSeq_sq`).

      b₀ = 1,   b_{n+1} = (s(n+1) − Σ_{j=1}^{n} b_j·b_{n+1−j}) / 2.

    -- Source: Newton's generalized binomial expansion of `√(1+u)`, in
    recurrence form; this is the object Deep Think's Q6 answer (2026-07-26)
    reasons about. The Cooper-partner instances are cross-checked against
    `scripts/verify_sym2_partner_identities.py` and the recurrence-defined
    `partnerSeq` (golden matches in PartnerIntegrality.lean). -/
def sqrtSeq (s : ℕ → ℤ) : ℕ → ℚ
  | 0 => 1
  | n + 1 =>
      ((s (n + 1) : ℚ) -
        ∑ i ∈ (Finset.range n).attach, sqrtSeq s (i.1 + 1) * sqrtSeq s (n - i.1)) / 2
  decreasing_by
  · exact Nat.succ_lt_succ (Finset.mem_range.mp i.2)
  · exact Nat.lt_succ_of_le (Nat.sub_le n i.1)

@[simp] theorem sqrtSeq_zero (s : ℕ → ℤ) : sqrtSeq s 0 = 1 := by rw [sqrtSeq]

/-- Unfolding lemma with the `attach` artifact of the termination proof removed. -/
theorem sqrtSeq_succ (s : ℕ → ℤ) (n : ℕ) :
    sqrtSeq s (n + 1) =
      ((s (n + 1) : ℚ) - ∑ i ∈ Finset.range n, sqrtSeq s (i + 1) * sqrtSeq s (n - i)) / 2 := by
  rw [sqrtSeq, ← Finset.sum_attach (Finset.range n)
    (fun i => sqrtSeq s (i + 1) * sqrtSeq s (n - i))]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. IT IS the SQUARE ROOT: the Cauchy self-convolution IS `s`     ║
-- ║  This is what makes §3 a statement about √(integer series) and not  ║
-- ║  about an arbitrary recursion someone wrote down.                   ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The defining property, `(Σ bₙzⁿ)² = Σ s(n)zⁿ` at every coefficient `n ≥ 1`:
    the full convolution splits as `b₀b_{n+1} + (middle) + b_{n+1}b₀`, and the
    definition of `b_{n+1}` is exactly the statement that this equals `s(n+1)`. -/
theorem sqrtSeq_sq (s : ℕ → ℤ) (n : ℕ) :
    ∑ i ∈ Finset.range (n + 2), sqrtSeq s i * sqrtSeq s (n + 1 - i) = (s (n + 1) : ℚ) := by
  rw [Finset.sum_range_succ, Finset.sum_range_succ']
  have hmid : ∀ i ∈ Finset.range n,
      sqrtSeq s (i + 1) * sqrtSeq s (n + 1 - (i + 1)) =
        sqrtSeq s (i + 1) * sqrtSeq s (n - i) := by
    intro i _
    have h : n + 1 - (i + 1) = n - i := by omega
    rw [h]
  rw [Finset.sum_congr rfl hmid]
  simp only [Nat.sub_self, sqrtSeq_zero, Nat.sub_zero, mul_one, one_mul]
  have h := sqrtSeq_succ s n
  field_simp at h
  linarith [h]

/-- And `n = 0`: the constant coefficient of the square is `1`, so `sqrtSeq` is
    a square root of `s` (as a power series) exactly when `s 0 = 1`. Recorded so
    the normalisation hypothesis is visible rather than implicit. -/
theorem sqrtSeq_sq_zero (s : ℕ → ℤ) :
    ∑ i ∈ Finset.range 1, sqrtSeq s i * sqrtSeq s (0 - i) = 1 := by simp

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE DYADIC BASELINE (Deep Think Q6, algebraic half)           ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `q ∈ ℤ[1/2]`: an integer divided by a power of two. -/
def IsDyadic (q : ℚ) : Prop := ∃ (m : ℤ) (k : ℕ), q = (m : ℚ) / 2 ^ k

theorem IsDyadic.intCast (m : ℤ) : IsDyadic (m : ℚ) := ⟨m, 0, by norm_num⟩

theorem IsDyadic.one : IsDyadic 1 := ⟨1, 0, by norm_num⟩

theorem IsDyadic.zero : IsDyadic 0 := ⟨0, 0, by norm_num⟩

theorem IsDyadic.add {p q : ℚ} (hp : IsDyadic p) (hq : IsDyadic q) : IsDyadic (p + q) := by
  obtain ⟨m, k, rfl⟩ := hp
  obtain ⟨m', k', rfl⟩ := hq
  refine ⟨m * 2 ^ k' + m' * 2 ^ k, k + k', ?_⟩
  push_cast
  field_simp
  ring

theorem IsDyadic.mul {p q : ℚ} (hp : IsDyadic p) (hq : IsDyadic q) : IsDyadic (p * q) := by
  obtain ⟨m, k, rfl⟩ := hp
  obtain ⟨m', k', rfl⟩ := hq
  refine ⟨m * m', k + k', ?_⟩
  push_cast
  field_simp
  ring

theorem IsDyadic.sub {p q : ℚ} (hp : IsDyadic p) (hq : IsDyadic q) : IsDyadic (p - q) := by
  obtain ⟨m', k', rfl⟩ := hq
  have : IsDyadic (-(m' : ℚ) / 2 ^ k') := ⟨-m', k', by push_cast; ring⟩
  simpa [sub_eq_add_neg, neg_div] using hp.add this

theorem IsDyadic.div2 {p : ℚ} (hp : IsDyadic p) : IsDyadic (p / 2) := by
  obtain ⟨m, k, rfl⟩ := hp
  exact ⟨m, k + 1, by field_simp; ring⟩

theorem IsDyadic.sum {α : Type*} {t : Finset α} {f : α → ℚ}
    (h : ∀ a ∈ t, IsDyadic (f a)) : IsDyadic (∑ a ∈ t, f a) :=
  Finset.sum_induction f IsDyadic (fun _ _ => IsDyadic.add) IsDyadic.zero h

/-- **The dyadic baseline** (Deep Think Q6, algebraic half — Tier A).

    For EVERY integer sequence `s`, every coefficient of the formal square root
    of `Σ s(n)zⁿ` lies in `ℤ[1/2]`: only the prime 2 can ever appear in a
    denominator. Nothing about modularity, levels, or the specific Cooper
    parameters enters — the `/2` in the definition is the only division there is.

    Read against PartnerIntegrality.lean (modulo the bridge open goal):
    * the s10/s18 partners' powers-of-2 denominators are FORCED to be powers
      of 2 — the observed behaviour is the generic one, fully explained;
    * s7's open integrality question loses its odd-prime half: `(k+2)² ∣ RHS`
      cancellation at odd primes is automatic, and only 2-adic cancellation —
      the actual arithmetic anomaly — remains to be proved. -/
theorem sqrtSeq_dyadic (s : ℕ → ℤ) : ∀ n, IsDyadic (sqrtSeq s n) := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    match n with
    | 0 => rw [sqrtSeq_zero]; exact IsDyadic.one
    | n + 1 =>
      rw [sqrtSeq_succ]
      refine IsDyadic.div2 (IsDyadic.sub (IsDyadic.intCast _) (IsDyadic.sum ?_))
      intro i hi
      have hi' := Finset.mem_range.mp hi
      exact IsDyadic.mul (ih (i + 1) (by omega)) (ih (n - i) (by omega))

/-- Negative control for the baseline: the analogous claim with the division
    changed from 2 to 3 is FALSE — dividing `s 1 = 1` by 3 already leaves
    `ℤ[1/2]`. Recorded so `sqrtSeq_dyadic` cannot be dismissed as an artifact of
    a definition too weak to fail (the E-002/E-005 pattern). -/
theorem dyadic_baseline_control : ¬ IsDyadic ((1 : ℚ) / 3) := by
  rintro ⟨m, k, hm⟩
  have h3 : (3 : ℚ) ≠ 0 := by norm_num
  have h2 : (2 : ℚ) ^ k ≠ 0 := by positivity
  have : (2 : ℚ) ^ k = 3 * m := by field_simp at hm; linarith
  have hz : (2 ^ k : ℤ) = 3 * m := by exact_mod_cast this
  have hdvd : (3 : ℤ) ∣ 2 ^ k := ⟨m, hz⟩
  have h32 : (3 : ℤ) ∣ 2 := Int.prime_three.dvd_of_dvd_pow hdvd
  norm_num at h32

end Agora.Sequences.FormalSqrt
