/-
  Agora/Sequences/SqrtBridge.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE BRIDGE: the recurrence-defined order-2 partner of Cooper's s7 IS the formal
  square root of the s7 generating series, coefficient by coefficient.

      partnerSeq s7_params n = FormalSqrt.sqrtSeq (s7 ·) n      for every n

  This closes `open_goal_partner_eq_sqrt_s7`, which was the repository's last
  remaining `sorry`. Proved 2026-09-20.

  ────────────────────────────────────────────────────────────────────────────────
  WHY THIS WAS OPEN, AND WHAT THE PREVIOUS ANALYSIS GOT WRONG

  The goal carried four recorded failed strategies and a T0 ruling of
  `blocked-on-mathlib`, on the stated grounds that the pinned Mathlib had "no
  `PowerSeries` square root" and "no D-finite/holonomic API".

  Both of those observations are TRUE and both are IRRELEVANT. This proof uses
  only `PowerSeries.mk`, `coeff_mul`, `Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk`,
  `isUnit_iff_constantCoeff`, `PowerSeries.instNoZeroDivisors` and
  `Finset.sum_range_reflect` — all present at the pinned commit, and all present
  at the PREVIOUS pin too. Nothing was missing from Mathlib.

  What was missing was the decomposition. The four recorded strategies were never
  refuted; they were routed around. The route:

    1. `conv_symm` — a convolution sum may be symmetrized in its two indices,
       via `Finset.sum_range_reflect`. This is what replaces the "Leibniz rule"
       the earlier analysis expected to need.
    2. `conv_cooper_of_rec` — THE CRUX. If `a` satisfies the order-2 partner
       recurrence (the one dividing by `(k+2)²`), then the convolution `a ⋆ a`
       satisfies Cooper's order-3 recurrence exactly. Proved by symmetrizing
       three explicit kernels and a single `linear_combination` against the
       order-2 hypothesis. This is the solution-level Sym² transport that
       strategy 2 identified as the missing ingredient and assumed was a
       WZ-style certificate problem; it is not, at the coefficient level.
    3. `cooper_unique` — two sequences satisfying Cooper's order-3 recurrence
       with equal first two values are equal. Ordinary strong induction; the
       leading coefficient `(n+2)³` never vanishes over ℚ.
    4. Square-root uniqueness in `ℚ⟦X⟧`: two series with constant coefficient 1
       and equal squares are equal (`PowerSeries` is a domain).

  METHODOLOGICAL NOTE, recorded because it generalizes: "blocked-on-mathlib" was
  a statement about a PROOF ROUTE, not about the goal. Four strategies failing is
  evidence about those four strategies. Before accepting such a label, ask which
  specific declaration is absent and whether the goal actually needs it — here the
  answer was that it did not.

  ────────────────────────────────────────────────────────────────────────────────
  WHAT THIS DOES AND DOES NOT GIVE

  DOES: `sqrtSeq_dyadic` now transports to `partnerSeq` (see `partner_s7_dyadic`
  below), so the s7 partner lies in ℤ[1/2] for EVERY n — upgrading the previous
  PASS(59) observation to a theorem, and excluding all odd primes.

  DOES NOT: discharge `Axioms.obrien2016_theorem6_2`. `IsDyadic` means "denominator
  a power of 2", which is NOT integrality. The axiom remains the sole support for
  `open_goal_partner_integral_s7`; this result reduces that goal to a purely
  2-adic statement but does not close it. Do not cite this file as discharging it.

  Provenance: proved by a 9-agent workflow (recon → lemma DAG → kernel-checked
  attempts → independent verification), then re-verified by the session main loop
  against the repository's own declaration with a statement lock plus a negative
  control. See briefs/BRIDGE_GOAL_CLOSED_2026_09_20.md.

  0 sorry. Axioms: propext, Classical.choice, Quot.sound (Lean's own only).
  ════════════════════════════════════════════════════════════════════════════════
-/
import Agora.Sequences.PartnerIntegrality
import Agora.Sequences.WZCertificates
import Mathlib.RingTheory.PowerSeries.Basic
import Mathlib.RingTheory.PowerSeries.Inverse
import Mathlib.RingTheory.PowerSeries.NoZeroDivisors
import Mathlib.Tactic

namespace Agora.Sequences.SqrtBridge
open Agora.Sequences Agora.Sequences.Partner Agora.Sequences.FormalSqrt PowerSeries Finset

theorem conv_symm (a : ℕ → ℚ) (F : ℕ → ℕ → ℚ) (m : ℕ) :
    ∑ i ∈ Finset.range (m + 1), F i (m - i) * (a i * a (m - i))
      = ∑ i ∈ Finset.range (m + 1), ((F i (m - i) + F (m - i) i) / 2) * (a i * a (m - i)) := by
  have key : ∑ i ∈ Finset.range (m + 1), F (m - i) i * (a i * a (m - i))
      = ∑ i ∈ Finset.range (m + 1), F i (m - i) * (a i * a (m - i)) := by
    rw [← Finset.sum_range_reflect (fun i => F (m - i) i * (a i * a (m - i))) (m + 1)]
    refine Finset.sum_congr rfl ?_
    intro j hj
    have hj' : j ≤ m := by simpa using Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
    have e1 : m + 1 - 1 - j = m - j := by omega
    have e2 : m - (m - j) = j := by omega
    rw [e1, e2]; ring
  have h2 : ∑ i ∈ Finset.range (m + 1), ((F i (m - i) + F (m - i) i) / 2) * (a i * a (m - i))
      = (∑ i ∈ Finset.range (m + 1), F i (m - i) * (a i * a (m - i))
         + ∑ i ∈ Finset.range (m + 1), F (m - i) i * (a i * a (m - i))) / 2 := by
    rw [← Finset.sum_add_distrib, Finset.sum_div]
    exact Finset.sum_congr rfl fun i _ => by ring
  rw [h2, key]; ring

theorem conv_cooper_of_rec (a : ℕ → ℚ) (h1 : a 1 = 2 * a 0)
    (hrec : ∀ k : ℕ, ((k : ℚ) + 2) ^ 2 * a (k + 2) =
      (26 * ((k : ℚ) + 1) ^ 2 + 13 * ((k : ℚ) + 1) + 2) * a (k + 1)
        + 3 * (3 * (k : ℚ) + 1) * (3 * (k : ℚ) + 2) * a k) (n : ℕ) :
    ((n : ℚ) + 2) ^ 3 * (∑ i ∈ Finset.range (n + 3), a i * a (n + 2 - i)) =
      (2 * (n : ℚ) + 3) * (13 * ((n : ℚ) + 1) ^ 2 + 13 * ((n : ℚ) + 1) + 4)
          * (∑ i ∈ Finset.range (n + 2), a i * a (n + 1 - i))
        - ((n : ℚ) + 1) * (-27 * ((n : ℚ) + 1) ^ 2 + 3)
          * (∑ i ∈ Finset.range (n + 1), a i * a (n - i)) := by
  show ((n : ℚ) + 2) ^ 3 * (∑ i ∈ Finset.range (n + 2 + 1), a i * a (n + 2 - i)) =
      (2 * (n : ℚ) + 3) * (13 * ((n : ℚ) + 1) ^ 2 + 13 * ((n : ℚ) + 1) + 4)
          * (∑ i ∈ Finset.range (n + 1 + 1), a i * a (n + 1 - i))
        - ((n : ℚ) + 1) * (-27 * ((n : ℚ) + 1) ^ 2 + 3)
          * (∑ i ∈ Finset.range (n + 1), a i * a (n - i))
  have key : ∀ (F : ℕ → ℕ → ℚ) (c : ℚ) (m : ℕ),
      (∀ i, i ≤ m → (F i (m - i) + F (m - i) i) / 2 = c) →
      ∑ i ∈ Finset.range (m + 1), F i (m - i) * (a i * a (m - i))
        = c * ∑ i ∈ Finset.range (m + 1), a i * a (m - i) := by
    intro F c m hc
    rw [conv_symm a F m, Finset.mul_sum]
    refine Finset.sum_congr rfl fun i hi => ?_
    rw [hc i (Nat.lt_succ_iff.mp (Finset.mem_range.mp hi))]
  have csub : ∀ (m i : ℕ), i ≤ m → ((m - i : ℕ) : ℚ) = (m : ℚ) - (i : ℚ) :=
    fun m i h => Nat.cast_sub h
  have E1 := key (fun j k => (6 * (j : ℚ) + 2 * (k : ℚ)) * (k : ℚ) ^ 2)
      (((n : ℚ) + 2) ^ 3) (n + 2) (by
        intro i hi; rw [csub (n + 2) i hi]; push_cast; ring)
  have E2 := key (fun j k => (6 * (j : ℚ) + 2 * (k : ℚ) + 2) * (26 * (k : ℚ) ^ 2 + 13 * (k : ℚ) + 2))
      ((2 * (n : ℚ) + 3) * (13 * ((n : ℚ) + 1) ^ 2 + 13 * ((n : ℚ) + 1) + 4)) (n + 1) (by
        intro i hi; rw [csub (n + 1) i hi]; push_cast; ring)
  have E3 := key (fun j k => (6 * (j : ℚ) + 2 * (k : ℚ) + 4) * (27 * (k : ℚ) ^ 2 + 27 * (k : ℚ) + 6))
      (((n : ℚ) + 1) * (27 * ((n : ℚ) + 1) ^ 2 - 3)) n (by
        intro i hi; rw [csub n i hi]; ring)
  have main :
      ∑ i ∈ Finset.range (n + 2 + 1),
          ((6 * (i : ℚ) + 2 * ((n + 2 - i : ℕ) : ℚ)) * ((n + 2 - i : ℕ) : ℚ) ^ 2)
            * (a i * a (n + 2 - i))
        = ∑ i ∈ Finset.range (n + 1 + 1),
            ((6 * (i : ℚ) + 2 * ((n + 1 - i : ℕ) : ℚ) + 2)
              * (26 * ((n + 1 - i : ℕ) : ℚ) ^ 2 + 13 * ((n + 1 - i : ℕ) : ℚ) + 2))
              * (a i * a (n + 1 - i))
          + ∑ i ∈ Finset.range (n + 1),
            ((6 * (i : ℚ) + 2 * ((n - i : ℕ) : ℚ) + 4)
              * (27 * ((n - i : ℕ) : ℚ) ^ 2 + 27 * ((n - i : ℕ) : ℚ) + 6))
              * (a i * a (n - i)) := by
    have peel2 : ∀ f : ℕ → ℚ, ∑ i ∈ Finset.range (n + 2 + 1), f i
        = (∑ i ∈ Finset.range (n + 1), f i) + f (n + 1) + f (n + 2) := by
      intro f; rw [Finset.sum_range_succ, Finset.sum_range_succ]
    have peel1 : ∀ f : ℕ → ℚ, ∑ i ∈ Finset.range (n + 1 + 1), f i
        = (∑ i ∈ Finset.range (n + 1), f i) + f (n + 1) := by
      intro f; rw [Finset.sum_range_succ]
    rw [peel2, peel1]
    have hbody : ∀ i ∈ Finset.range (n + 1),
        ((6 * (i : ℚ) + 2 * ((n + 2 - i : ℕ) : ℚ)) * ((n + 2 - i : ℕ) : ℚ) ^ 2)
            * (a i * a (n + 2 - i))
          = ((6 * (i : ℚ) + 2 * ((n + 1 - i : ℕ) : ℚ) + 2)
              * (26 * ((n + 1 - i : ℕ) : ℚ) ^ 2 + 13 * ((n + 1 - i : ℕ) : ℚ) + 2))
              * (a i * a (n + 1 - i))
            + ((6 * (i : ℚ) + 2 * ((n - i : ℕ) : ℚ) + 4)
              * (27 * ((n - i : ℕ) : ℚ) ^ 2 + 27 * ((n - i : ℕ) : ℚ) + 6))
              * (a i * a (n - i)) := by
      intro i hi
      have hin : i ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hi)
      obtain ⟨t, rfl⟩ : ∃ t, n = i + t := ⟨n - i, by omega⟩
      have r0 : i + t + 2 - i = t + 2 := by omega
      have r1 : i + t + 1 - i = t + 1 := by omega
      have r2 : i + t - i = t := by omega
      rw [r0, r1, r2]
      push_cast
      linear_combination ((6 * (i : ℚ) + 2 * (t : ℚ) + 4) * a i) * hrec t
    rw [Finset.sum_congr rfl hbody, Finset.sum_add_distrib]
    have b0 : n + 2 - (n + 2) = 0 := by omega
    have b1 : n + 2 - (n + 1) = 1 := by omega
    have b2 : n + 1 - (n + 1) = 0 := by omega
    rw [b0, b1, b2, h1]
    push_cast
    ring
  linear_combination (-1 : ℚ) * E1 + E2 + E3 + main


/-- Recursion uniqueness for Cooper's order-3 recurrence. -/
theorem cooper_unique (x y : ℕ → ℚ) (h0 : x 0 = y 0) (h1 : x 1 = y 1)
    (hx : ∀ n : ℕ, ((n : ℚ) + 2) ^ 3 * x (n + 2) =
      (2 * (n : ℚ) + 3) * (13 * ((n : ℚ) + 1) ^ 2 + 13 * ((n : ℚ) + 1) + 4) * x (n + 1)
        - ((n : ℚ) + 1) * (-27 * ((n : ℚ) + 1) ^ 2 + 3) * x n)
    (hy : ∀ n : ℕ, ((n : ℚ) + 2) ^ 3 * y (n + 2) =
      (2 * (n : ℚ) + 3) * (13 * ((n : ℚ) + 1) ^ 2 + 13 * ((n : ℚ) + 1) + 4) * y (n + 1)
        - ((n : ℚ) + 1) * (-27 * ((n : ℚ) + 1) ^ 2 + 3) * y n) :
    ∀ n, x n = y n := by
  intro n
  induction n using Nat.twoStepInduction with
  | zero => exact h0
  | one => exact h1
  | more k ihk ihk1 =>
    have hne : ((k : ℚ) + 2) ^ 3 ≠ 0 := by positivity
    have e := hx k
    rw [ihk, ihk1, ← hy k] at e
    exact mul_left_cancel₀ hne e

/-- s7 satisfies the shifted Cooper recurrence over ℚ (PROVED). -/
theorem s7_cooper_shift (n : ℕ) :
    ((n : ℚ) + 2) ^ 3 * (s7 (n + 2) : ℚ) =
      (2 * (n : ℚ) + 3) * (13 * ((n : ℚ) + 1) ^ 2 + 13 * ((n : ℚ) + 1) + 4) * (s7 (n + 1) : ℚ)
        - ((n : ℚ) + 1) * (-27 * ((n : ℚ) + 1) ^ 2 + 3) * (s7 n : ℚ) := by
  have h := Agora.Sequences.WZ.s7_satisfies (n + 1) (by omega)
  simp only [s7_params] at h
  rw [show n + 1 + 1 = n + 2 from rfl, Nat.add_sub_cancel] at h
  have h' : ((n : ℚ) + 1 + 1) ^ 3 * (s7 (n + 2) : ℚ) =
      (2 * ((n : ℚ) + 1) + 1) * (13 * ((n : ℚ) + 1) ^ 2 + 13 * ((n : ℚ) + 1) + 4) * (s7 (n + 1) : ℚ)
        - ((n : ℚ) + 1) * (-27 * ((n : ℚ) + 1) ^ 2 + 3) * (s7 n : ℚ) := by exact_mod_cast h
  linear_combination h'

/-- The convolution identity for the s7 partner. -/
theorem hconv_s7 : ∀ n, ∑ i ∈ Finset.range (n + 1),
    partnerSeq s7_params i * partnerSeq s7_params (n - i) = (s7 n : ℚ) := by
  set a : ℕ → ℚ := partnerSeq s7_params with ha
  have ha0 : a 0 = 1 := s7_partner_values.1
  have ha1 : a 1 = 2 * a 0 := by rw [ha, s7_partner_values.1, s7_partner_values.2.1]; norm_num
  have harec := partnerSeq_s7_recurrence
  refine cooper_unique (fun n => ∑ i ∈ Finset.range (n + 1), a i * a (n - i))
    (fun n => (s7 n : ℚ)) ?_ ?_ ?_ (fun n => s7_cooper_shift n)
  · simp [ha0, show s7 0 = 1 from by decide]
  · rw [Finset.sum_range_succ, Finset.sum_range_one]
    rw [show s7 1 = 4 from by decide]
    simp [ha0, ha1]
    norm_num [ha0, ha1]
  · intro n; exact conv_cooper_of_rec a ha1 harec n

-- ───────── recon B's compiled reduction, re-run here ─────────
private theorem sq_root_unique (f g : PowerSeries ℚ)
    (hf : constantCoeff f = 1) (hg : constantCoeff g = 1) (h : f * f = g * g) : f = g := by
  have hsum : IsUnit (f + g) := by rw [isUnit_iff_constantCoeff]; simp [hf, hg]
  have hz : (f - g) * (f + g) = 0 := by ring_nf; linear_combination h
  rcases mul_eq_zero.mp hz with hc | hc
  · exact sub_eq_zero.mp hc
  · exact absurd hc hsum.ne_zero

private theorem coeff_mk_sq (u : ℕ → ℚ) (n : ℕ) :
    coeff n (PowerSeries.mk u * PowerSeries.mk u)
      = ∑ i ∈ Finset.range (n + 1), u i * u (n - i) := by
  rw [coeff_mul, Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk]; simp [coeff_mk]

/-- **THE TARGET** — `open_goal_partner_eq_sqrt_s7`. -/
theorem partner_eq_sqrt_s7 :
    ∀ n, partnerSeq s7_params n = sqrtSeq (fun k => (s7 k : ℤ)) n := by
  set b : ℕ → ℚ := sqrtSeq (fun k => (s7 k : ℤ)) with hb
  have hsq : ∀ n, ∑ i ∈ Finset.range (n + 1), b i * b (n - i) = (s7 n : ℚ) := by
    intro n
    match n with
    | 0 => simp [hb, sqrtSeq_zero, show s7 0 = 1 from by decide]
    | m + 1 => simpa [hb] using sqrtSeq_sq (fun k => (s7 k : ℤ)) m
  have hP : (PowerSeries.mk (partnerSeq s7_params)) * (PowerSeries.mk (partnerSeq s7_params))
      = (PowerSeries.mk b) * (PowerSeries.mk b) := by
    ext n; rw [coeff_mk_sq, coeff_mk_sq, hconv_s7 n, hsq n]
  have h0P : constantCoeff (PowerSeries.mk (partnerSeq s7_params)) = 1 := by
    rw [← coeff_zero_eq_constantCoeff_apply, coeff_mk]; exact s7_partner_values.1
  have h0Q : constantCoeff (PowerSeries.mk b) = 1 := by
    rw [← coeff_zero_eq_constantCoeff_apply, coeff_mk]; simp [hb]
  have hEq := sq_root_unique _ _ h0P h0Q hP
  intro n
  have := congrArg (coeff n) hEq
  simpa [coeff_mk] using this

/-- The repository's open goal, in the exact form stated in
    `OpenGoals/PartnerIntegrality.lean`. -/
theorem open_goal_partner_eq_sqrt_s7 :
    ∀ n, partnerSeq s7_params n = FormalSqrt.sqrtSeq (fun k => (s7 k : ℤ)) n :=
  partner_eq_sqrt_s7

/-- CONSEQUENCE. The s7 partner is dyadic (denominator a power of 2) at every
    index — the `sqrtSeq_dyadic` transport the open goal's docstring predicted.

    ⚠️ Dyadic is NOT integral. This excludes odd primes for all `n`; it reduces
    `open_goal_partner_integral_s7` to a 2-adic statement and does not close it. -/
theorem partner_s7_dyadic (n : ℕ) :
    FormalSqrt.IsDyadic (partnerSeq s7_params n) := by
  rw [partner_eq_sqrt_s7 n]
  exact FormalSqrt.sqrtSeq_dyadic _ n

end Agora.Sequences.SqrtBridge
