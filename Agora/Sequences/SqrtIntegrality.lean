/-
  Agora/Sequences/SqrtIntegrality.lean
  ════════════════════════════════════════════════════════════════════════════════

  A SUFFICIENT CRITERION FOR INTEGRALITY OF A FORMAL SQUARE ROOT, and the
  resulting AXIOM-FREE, CONDITIONAL route to s7 partner integrality.

  `sqrtSeq_even_of_four_dvd`: if `4 ∣ s n` for every `n ≥ 1`, then every
  coefficient `sqrtSeq s (n+1)` of the formal square root is an EVEN INTEGER.
  (Classically: `(1 + 4u)^{1/2}` has integer coefficients when `u` does.)

  Combined with the bridge (`SqrtBridge.partner_eq_sqrt_s7`) this gives

      (∀ n ≥ 1, 4 ∣ s7 n)  →  the s7 partner is integral,

  WITHOUT `Axioms.obrien2016_theorem6_2`. So that axiom can be retired by proving
  one elementary congruence on a binomial sum.

  ⚠️ STATUS OF THE HYPOTHESIS — it is NOT proved here and NOT assumed anywhere.
  `∀ n ≥ 1, 4 ∣ s7 n` is checked in exact integer arithmetic for `1 ≤ n ≤ 200`
  (PASS(200), 2026-09-20 session; min 2-adic valuation over that range is exactly
  2) and kernel-checked below for `n ≤ 6` (`s7_four_dvd_pass6`). It is evidence,
  not proof. `s7_partner_integral` therefore STILL rests on the O'Brien axiom;
  this file adds a second, conditional route and changes no existing status.

  The criterion is SUFFICIENT, NOT NECESSARY: `s = (1+z)²` has `s 1 = 2` and an
  integral square root. It does separate the sporadic candidates the right way —
  `s10 1 = 2` and `s18`'s `b = 6` both fail it at `n = 1` — but that is an
  observation, not a characterization.

  0 sorry. Axioms: Lean's three only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.SqrtBridge

namespace Agora.Sequences.SqrtIntegrality
open Agora.Sequences Agora.Sequences.Partner Agora.Sequences.FormalSqrt

/-- If `4 ∣ s n` for all `n ≥ 1`, the formal square root of `Σ s(n) zⁿ` has even
    integer coefficients in every positive degree. -/
theorem sqrtSeq_even_of_four_dvd (s : ℕ → ℤ) (h : ∀ n, 1 ≤ n → (4 : ℤ) ∣ s n) :
    ∀ n, ∃ m : ℤ, sqrtSeq s (n + 1) = 2 * (m : ℚ) := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    obtain ⟨t, ht⟩ := h (n + 1) (by omega)
    have hterm : ∀ i ∈ Finset.range n,
        ∃ c : ℤ, sqrtSeq s (i + 1) * sqrtSeq s (n - i) = 4 * (c : ℚ) := by
      intro i hi
      have hi' := Finset.mem_range.mp hi
      obtain ⟨m1, h1⟩ := ih i hi'
      obtain ⟨m2, h2⟩ := ih (n - i - 1) (by omega)
      have e : n - i - 1 + 1 = n - i := by omega
      rw [e] at h2
      exact ⟨m1 * m2, by rw [h1, h2]; push_cast; ring⟩
    choose! c hc using hterm
    refine ⟨t - ∑ i ∈ Finset.range n, c i, ?_⟩
    rw [sqrtSeq_succ, Finset.sum_congr rfl hc, ht]
    push_cast
    rw [← Finset.mul_sum]
    ring

/-- Integrality of the formal square root under the mod-4 criterion. -/
theorem sqrtSeq_integral_of_four_dvd (s : ℕ → ℤ) (h : ∀ n, 1 ≤ n → (4 : ℤ) ∣ s n) :
    ∀ n, IsIntegral (sqrtSeq s n) := by
  intro n
  cases n with
  | zero => exact ⟨1, by simp⟩
  | succ k =>
    obtain ⟨m, hm⟩ := sqrtSeq_even_of_four_dvd s h k
    exact ⟨2 * m, by rw [hm]; push_cast; ring⟩

/-- **Conditional, axiom-free route to s7 partner integrality.** The hypothesis is
    an elementary congruence; see the header for its (unproved) status. -/
theorem s7_partner_integral_of_congruence
    (h : ∀ n, 1 ≤ n → (4 : ℤ) ∣ (s7 n : ℤ)) :
    ∀ n, IsIntegral (partnerSeq s7_params n) := by
  intro n
  rw [SqrtBridge.partner_eq_sqrt_s7 n]
  exact sqrtSeq_integral_of_four_dvd _ h n

/-- PASS(6), kernel-checked: `4 ∣ s7 n` for `1 ≤ n ≤ 6`. Evidence, not proof. -/
theorem s7_four_dvd_pass6 : ∀ n, 1 ≤ n → n ≤ 6 → (4 : ℤ) ∣ (s7 n : ℤ) := by
  intro n h1 h6
  interval_cases n <;> decide

/-- CONTROL: the criterion is not vacuous and does discriminate — s10 fails it
    already at `n = 1`, consistent with `s10_partner_not_integral`. -/
theorem s10_fails_criterion : ¬ (4 : ℤ) ∣ (s10 1 : ℤ) := by decide

/-- **NON-VACUITY CONTROL for `sqrtSeq_even_of_four_dvd`.** Its conclusion,
    `∃ m : ℤ, sqrtSeq s (n+1) = 2·m`, is an existential over a `ℚ`-valued
    sequence, so it could in principle be satisfiable for trivial reasons. It is
    not: drop the hypothesis and the conclusion FAILS. For the sequence with
    `s 1 = 1` — which violates `4 ∣ s 1` — we get `sqrtSeq s 1 = 1/2`, which is
    not twice an integer.

    This control exists because a vacuous statement compiles, passes the `sorry`
    grep, reports only the three standard axioms and locks cleanly; only an
    explicit refutation of the hypothesis-free version distinguishes it from a
    real theorem. Cf. the `⚠️ VACUOUS` relabelling in
    `Agora/Sequences/Integrality.lean` (E-002 / E-005). -/
theorem sqrtSeq_even_needs_hypothesis :
    ¬ (∃ m : ℤ, sqrtSeq (fun k => if k = 1 then 1 else 0) 1 = 2 * (m : ℚ)) := by
  rintro ⟨m, hm⟩
  rw [sqrtSeq_succ] at hm
  norm_num at hm
  have : (1 : ℚ) = 4 * (m : ℚ) := by linarith
  have h4 : (4 : ℤ) ∣ 1 := ⟨m, by exact_mod_cast this⟩
  norm_num at h4

end Agora.Sequences.SqrtIntegrality
