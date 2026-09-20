/-
  Agora/Sequences/SqrtBridgeGeneric.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE BRIDGE, FOR THE WHOLE COOPER TEMPLATE.

  `SqrtBridge.lean` proved, for s7, that the recurrence-defined order-2 partner is
  the formal square root of the bulk series. This file shows that nothing in that
  argument used the s7 parameters: for EVERY `(a,b,c,d)` and EVERY integer sequence
  `s` that satisfies the Cooper recurrence with `s 0 = 1`, `s 1 = b`,

      partnerSeq p n = FormalSqrt.sqrtSeq s n           for every n.

  This is the sequence-level counterpart of the operator-level template theorem
  `L₃ = P₂·Sym²(L₂)` (PartnerOperators.lean), uniform in the parameters in the
  same sense.

  CONSEQUENCES PROVED HERE
    * `partner_dyadic` — the partner of ANY Cooper-template sequence is dyadic
      (denominators are powers of 2) at every index.
    * `s10_partner_dyadic` — instantiation at s10 via the kernel-proved WZ
      recurrence `WZ.s10_satisfies`. This upgrades the recorded observation
      "s10's partner denominators are exactly powers of 2, PASS(59)" to a theorem
      for the "at most powers of 2" half. Together with `s10_partner_not_integral`
      the prime 2 genuinely occurs.
    * s7 is recovered as an instance (`partner_eq_sqrt_s7_via_generic`), as a consistency
      check of the generalization against the hand-specialized proof.

  NOT PROVED HERE, deliberately: an s18 instance. `CooperRecurrences.lean`
  provides no closed form `s18 : ℕ → ℕ` (its header explains why), so there is no
  sequence to instantiate at. The generic theorem applies to s18 the moment a
  sequence with the s18 recurrence is supplied; that hypothesis is NOT assumed
  anywhere.

  ⚠️ Dyadic is not integral. Nothing here discharges
  `Axioms.obrien2016_theorem6_2`.

  0 sorry. Axioms: Lean's three only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.SqrtBridge

namespace Agora.Sequences.SqrtBridge
open Agora.Sequences Agora.Sequences.Partner Agora.Sequences.FormalSqrt PowerSeries Finset

/-- THE CRUX, uniform in the template parameters. If `a` satisfies the order-2
    partner recurrence for `(A,B,C,D)`, its self-convolution satisfies the
    order-3 Cooper recurrence for the same parameters. -/
theorem conv_cooper_of_rec_generic (A B C D : ℚ) (a : ℕ → ℚ) (h1 : a 1 = B / 2 * a 0)
    (hrec : ∀ k : ℕ, ((k : ℚ) + 2) ^ 2 * a (k + 2) =
      (2 * A * ((k : ℚ) + 1) ^ 2 + A * ((k : ℚ) + 1) + B / 2) * a (k + 1)
        - (C * (k : ℚ) ^ 2 + C * (k : ℚ) + (C + D) / 4) * a k) (n : ℕ) :
    ((n : ℚ) + 2) ^ 3 * (∑ i ∈ Finset.range (n + 3), a i * a (n + 2 - i)) =
      (2 * (n : ℚ) + 3) * (A * ((n : ℚ) + 1) ^ 2 + A * ((n : ℚ) + 1) + B)
          * (∑ i ∈ Finset.range (n + 2), a i * a (n + 1 - i))
        - ((n : ℚ) + 1) * (C * ((n : ℚ) + 1) ^ 2 + D)
          * (∑ i ∈ Finset.range (n + 1), a i * a (n - i)) := by
  show ((n : ℚ) + 2) ^ 3 * (∑ i ∈ Finset.range (n + 2 + 1), a i * a (n + 2 - i)) =
      (2 * (n : ℚ) + 3) * (A * ((n : ℚ) + 1) ^ 2 + A * ((n : ℚ) + 1) + B)
          * (∑ i ∈ Finset.range (n + 1 + 1), a i * a (n + 1 - i))
        - ((n : ℚ) + 1) * (C * ((n : ℚ) + 1) ^ 2 + D)
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
  have E2 := key (fun j k => (6 * (j : ℚ) + 2 * (k : ℚ) + 2) * (2 * A * (k : ℚ) ^ 2 + A * (k : ℚ) + B / 2))
      ((2 * (n : ℚ) + 3) * (A * ((n : ℚ) + 1) ^ 2 + A * ((n : ℚ) + 1) + B)) (n + 1) (by
        intro i hi; rw [csub (n + 1) i hi]; push_cast; ring)
  have E3 := key (fun j k => (6 * (j : ℚ) + 2 * (k : ℚ) + 4) * (C * (k : ℚ) ^ 2 + C * (k : ℚ) + (C + D) / 4))
      (((n : ℚ) + 1) * (C * ((n : ℚ) + 1) ^ 2 + D)) n (by
        intro i hi; rw [csub n i hi]; ring)
  have main :
      ∑ i ∈ Finset.range (n + 2 + 1),
          ((6 * (i : ℚ) + 2 * ((n + 2 - i : ℕ) : ℚ)) * ((n + 2 - i : ℕ) : ℚ) ^ 2)
            * (a i * a (n + 2 - i))
        = ∑ i ∈ Finset.range (n + 1 + 1),
            ((6 * (i : ℚ) + 2 * ((n + 1 - i : ℕ) : ℚ) + 2)
              * (2 * A * ((n + 1 - i : ℕ) : ℚ) ^ 2 + A * ((n + 1 - i : ℕ) : ℚ) + B / 2))
              * (a i * a (n + 1 - i))
          - ∑ i ∈ Finset.range (n + 1),
            ((6 * (i : ℚ) + 2 * ((n - i : ℕ) : ℚ) + 4)
              * (C * ((n - i : ℕ) : ℚ) ^ 2 + C * ((n - i : ℕ) : ℚ) + (C + D) / 4))
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
              * (2 * A * ((n + 1 - i : ℕ) : ℚ) ^ 2 + A * ((n + 1 - i : ℕ) : ℚ) + B / 2))
              * (a i * a (n + 1 - i))
            - ((6 * (i : ℚ) + 2 * ((n - i : ℕ) : ℚ) + 4)
              * (C * ((n - i : ℕ) : ℚ) ^ 2 + C * ((n - i : ℕ) : ℚ) + (C + D) / 4))
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
    rw [Finset.sum_congr rfl hbody, Finset.sum_sub_distrib]
    have b0 : n + 2 - (n + 2) = 0 := by omega
    have b1 : n + 2 - (n + 1) = 1 := by omega
    have b2 : n + 1 - (n + 1) = 0 := by omega
    rw [b0, b1, b2, h1]
    push_cast
    ring
  linear_combination (-1 : ℚ) * E1 + E2 - E3 + main

/-- Recursion uniqueness for the Cooper order-3 recurrence, any parameters. -/
theorem cooper_unique_generic (A B C D : ℚ) (x y : ℕ → ℚ) (h0 : x 0 = y 0) (h1 : x 1 = y 1)
    (hx : ∀ n : ℕ, ((n : ℚ) + 2) ^ 3 * x (n + 2) =
      (2 * (n : ℚ) + 3) * (A * ((n : ℚ) + 1) ^ 2 + A * ((n : ℚ) + 1) + B) * x (n + 1)
        - ((n : ℚ) + 1) * (C * ((n : ℚ) + 1) ^ 2 + D) * x n)
    (hy : ∀ n : ℕ, ((n : ℚ) + 2) ^ 3 * y (n + 2) =
      (2 * (n : ℚ) + 3) * (A * ((n : ℚ) + 1) ^ 2 + A * ((n : ℚ) + 1) + B) * y (n + 1)
        - ((n : ℚ) + 1) * (C * ((n : ℚ) + 1) ^ 2 + D) * y n) :
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

/-- The Cooper recurrence (stated over ℤ for `n ≥ 1`) in the shifted ℚ-form. -/
theorem cooper_shift (p : CooperRecurrenceParams) (s : ℕ → ℤ)
    (hs : SatisfiesCooperRecurrence s p) (n : ℕ) :
    ((n : ℚ) + 2) ^ 3 * (s (n + 2) : ℚ) =
      (2 * (n : ℚ) + 3) * ((p.a : ℚ) * ((n : ℚ) + 1) ^ 2 + (p.a : ℚ) * ((n : ℚ) + 1) + (p.b : ℚ))
          * (s (n + 1) : ℚ)
        - ((n : ℚ) + 1) * ((p.c : ℚ) * ((n : ℚ) + 1) ^ 2 + (p.d : ℚ)) * (s n : ℚ) := by
  have h := hs (n + 1) (by omega)
  rw [show n + 1 + 1 = n + 2 from rfl, Nat.add_sub_cancel] at h
  have h' : (((n + 1 : ℕ) : ℚ) + 1) ^ 3 * (s (n + 2) : ℚ) =
      (2 * ((n + 1 : ℕ) : ℚ) + 1) * ((p.a : ℚ) * ((n + 1 : ℕ) : ℚ) ^ 2
          + (p.a : ℚ) * ((n + 1 : ℕ) : ℚ) + (p.b : ℚ)) * (s (n + 1) : ℚ)
        - ((n + 1 : ℕ) : ℚ) * ((p.c : ℚ) * ((n + 1 : ℕ) : ℚ) ^ 2 + (p.d : ℚ)) * (s n : ℚ) := by
    exact_mod_cast h
  push_cast at h'
  linear_combination h'

/-- The convolution identity, for the whole template. -/
theorem hconv_generic (p : CooperRecurrenceParams) (s : ℕ → ℤ)
    (hs : SatisfiesCooperRecurrence s p) (hs0 : s 0 = 1) (hs1 : s 1 = p.b) :
    ∀ n, ∑ i ∈ Finset.range (n + 1), partnerSeq p i * partnerSeq p (n - i) = (s n : ℚ) := by
  have ha0 : partnerSeq p 0 = 1 := partnerSeq_zero p
  have ha1 : partnerSeq p 1 = (p.b : ℚ) / 2 * partnerSeq p 0 := by
    rw [partnerSeq_one, ha0]; ring
  refine cooper_unique_generic (p.a : ℚ) (p.b : ℚ) (p.c : ℚ) (p.d : ℚ)
    (fun n => ∑ i ∈ Finset.range (n + 1), partnerSeq p i * partnerSeq p (n - i))
    (fun n => (s n : ℚ)) ?_ ?_ ?_ (fun n => cooper_shift p s hs n)
  · simp [ha0, hs0]
  · simp only [Finset.sum_range_succ, Finset.sum_range_zero]
    simp [ha0, partnerSeq_one, hs1]
  · intro n
    exact conv_cooper_of_rec_generic (p.a : ℚ) (p.b : ℚ) (p.c : ℚ) (p.d : ℚ)
      (partnerSeq p) ha1 (partnerSeq_recurrence p) n

private theorem sq_root_unique' (f g : PowerSeries ℚ)
    (hf : constantCoeff f = 1) (hg : constantCoeff g = 1) (h : f * f = g * g) : f = g := by
  have hsum : IsUnit (f + g) := by rw [isUnit_iff_constantCoeff]; simp [hf, hg]
  have hz : (f - g) * (f + g) = 0 := by ring_nf; linear_combination h
  rcases mul_eq_zero.mp hz with hc | hc
  · exact sub_eq_zero.mp hc
  · exact absurd hc hsum.ne_zero

private theorem coeff_mk_sq' (u : ℕ → ℚ) (n : ℕ) :
    coeff n (PowerSeries.mk u * PowerSeries.mk u)
      = ∑ i ∈ Finset.range (n + 1), u i * u (n - i) := by
  rw [coeff_mul, Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk]; simp [coeff_mk]

/-- **THE GENERIC BRIDGE.** For every Cooper parameter choice and every integer
    sequence satisfying the Cooper recurrence with the template's initial data,
    the recurrence-defined partner IS the formal square root. -/
theorem partner_eq_sqrt (p : CooperRecurrenceParams) (s : ℕ → ℤ)
    (hs : SatisfiesCooperRecurrence s p) (hs0 : s 0 = 1) (hs1 : s 1 = p.b) :
    ∀ n, partnerSeq p n = sqrtSeq s n := by
  have hsq : ∀ n, ∑ i ∈ Finset.range (n + 1), sqrtSeq s i * sqrtSeq s (n - i) = (s n : ℚ) := by
    intro n
    match n with
    | 0 => simp [hs0]
    | m + 1 => simpa using sqrtSeq_sq s m
  have hP : (PowerSeries.mk (partnerSeq p)) * (PowerSeries.mk (partnerSeq p))
      = (PowerSeries.mk (sqrtSeq s)) * (PowerSeries.mk (sqrtSeq s)) := by
    ext n; rw [coeff_mk_sq', coeff_mk_sq', hconv_generic p s hs hs0 hs1 n, hsq n]
  have h0P : constantCoeff (PowerSeries.mk (partnerSeq p)) = 1 := by
    rw [← coeff_zero_eq_constantCoeff_apply, coeff_mk]; exact partnerSeq_zero p
  have h0Q : constantCoeff (PowerSeries.mk (sqrtSeq s)) = 1 := by
    rw [← coeff_zero_eq_constantCoeff_apply, coeff_mk]; simp
  have hEq := sq_root_unique' _ _ h0P h0Q hP
  intro n
  have := congrArg (coeff n) hEq
  simpa [coeff_mk] using this

/-- The partner of ANY Cooper-template sequence is dyadic at every index. -/
theorem partner_dyadic (p : CooperRecurrenceParams) (s : ℕ → ℤ)
    (hs : SatisfiesCooperRecurrence s p) (hs0 : s 0 = 1) (hs1 : s 1 = p.b) (n : ℕ) :
    IsDyadic (partnerSeq p n) := by
  rw [partner_eq_sqrt p s hs hs0 hs1 n]; exact sqrtSeq_dyadic s n

/-- Consistency check: the generic theorem reproduces the s7 closure. -/
theorem partner_eq_sqrt_s7_via_generic :
    ∀ n, partnerSeq s7_params n = sqrtSeq (fun k => (s7 k : ℤ)) n :=
  partner_eq_sqrt s7_params _ Agora.Sequences.WZ.s7_satisfies (by decide) (by decide)

/-- **s10: the partner is the formal square root.** New. -/
theorem partner_eq_sqrt_s10 :
    ∀ n, partnerSeq s10_params n = sqrtSeq (fun k => (s10 k : ℤ)) n :=
  partner_eq_sqrt s10_params _ Agora.Sequences.WZ.s10_satisfies (by decide) (by decide)

/-- **s10's partner is dyadic at every index** — upgrades the "denominators are
    powers of 2" observation from PASS(59) to a theorem. It is NOT integral
    (`s10_partner_not_integral`), so the prime 2 genuinely occurs. -/
theorem s10_partner_dyadic (n : ℕ) : IsDyadic (partnerSeq s10_params n) :=
  partner_dyadic s10_params _ Agora.Sequences.WZ.s10_satisfies (by decide) (by decide) n

end Agora.Sequences.SqrtBridge
