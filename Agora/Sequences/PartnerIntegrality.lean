/-
  PartnerIntegrality.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-11 — arithmetic of the order-2 partner sequences.

  WHY THIS FILE EXISTS. `Agora/Sequences/PartnerOperators.lean` (S1-10) proves that
  every operator of the Cooper template is `P₂ · Sym²(L₂)` for an explicit order-2
  `L₂`, and that the resulting partner separates the three sporadic candidates:
  s7's partner series is integral, s10's and s18's are not. That separation is the
  one arithmetic fact currently doing selection work, and until now it rested on a
  Python script (`scripts/verify_sym2_partner_identities.py`). This file moves it
  to the kernel — with the asymmetry stated honestly:

    * NON-integrality of the s10 and s18 partners is COMPLETE (Tier A). It needs a
      single witness, and `17/2` resp. `45/2` at `n = 2` supply it.
    * Integrality of the s7 partner is NOT proved. It is a genuine Apéry-style
      integrality theorem (the recurrence has leading coefficient `(k+2)²`, so
      nothing forces the quotient to be integral). What is here is a kernel-checked
      finite range, reported as `PASS(N)`, plus the general statement as the named
      open goal `open_goal_partner_integral_s7`.

  Do not cite this file as "s7's partner is integral". It is
  "integral for n ≤ N, kernel-checked, general case open".

  0 sorry in this file (the open goal lives in `OpenGoals/`).

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.CooperRecurrences
import Agora.Sequences.FormalSqrt
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic

namespace Agora.Sequences.Partner

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE PARTNER COEFFICIENT SEQUENCE                              ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- One step of the partner recurrence, carried as the pair `(aₖ, aₖ₊₁)`.

    Reading `L₂ = P₂θ² + P₁θ + P₀` off `partnerP2`/`partnerP1`/`partnerP0`
    (`PartnerOperators.lean`) and extracting the `zᴹ` coefficient of `L₂f = 0` for
    the holomorphic solution `f = Σ aₙzⁿ` with `a₀ = 1` gives

      (k+2)²·a_{k+2} = a_{k+1}·(2a(k+1)² + a(k+1) + b/2)
                       − a_k·(c·k² + c·k + (c+d)/4)

    and, at `M = 1`, `a₁ = b/2`. Note the leading `(k+2)²`: the sequence is
    `ℚ`-valued by construction, and integrality is a theorem, not a typing fact.
    -- Source: derived from the operators of `PartnerOperators.lean` §2½, which are
    in turn solved out of Gorodetsky arXiv:2102.11839 v2 eq. (1.7). Cross-checked
    against all three known partner series in
    `scripts/verify_sym2_partner_identities.py`. -/
def partnerPair (p : CooperRecurrenceParams) : ℕ → ℚ × ℚ
  | 0 => (1, (p.b : ℚ) / 2)
  | k + 1 =>
      let prev := partnerPair p k
      (prev.2,
        (prev.2 * (2 * (p.a : ℚ) * ((k : ℚ) + 1) ^ 2 + (p.a : ℚ) * ((k : ℚ) + 1) + (p.b : ℚ) / 2)
            - prev.1 * ((p.c : ℚ) * (k : ℚ) ^ 2 + (p.c : ℚ) * (k : ℚ)
                          + ((p.c : ℚ) + (p.d : ℚ)) / 4))
          / ((k : ℚ) + 2) ^ 2)

/-- `aₙ`, the `n`-th coefficient of the holomorphic solution of the order-2
    partner operator, normalised to `a₀ = 1`. Source as `partnerPair`. -/
def partnerSeq (p : CooperRecurrenceParams) (n : ℕ) : ℚ := (partnerPair p n).1

/-- `q` is an integer. Phrased as "some integer maps onto it" rather than
    "`q.den = 1`" so that the refutations below are honest arithmetic (`17 = 2m`
    has no integer solution) rather than denominator bookkeeping. -/
def IsIntegral (q : ℚ) : Prop := ∃ m : ℤ, q = m

theorem isIntegral_den (q : ℚ) (h : IsIntegral q) : q.den = 1 := by
  obtain ⟨m, rfl⟩ := h; simp

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE PARTNER SERIES REPRODUCE THE LITERATURE VALUES            ║
-- ║  Golden checks: these are the numbers the S1-10 handoff and the     ║
-- ║  OEIS entry record, so a wrong recurrence would show up here.       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- s7's partner opens `1, 2, 22, 336, 6006` — the first terms of A279619.
    -- Source: A279619 (verified against the primary source O'Brien 2016,
    Theorem 6.1, per Stream 2 `refs/literature_provenance.txt`). -/
theorem s7_partner_values :
    partnerSeq s7_params 0 = 1 ∧ partnerSeq s7_params 1 = 2 ∧
    partnerSeq s7_params 2 = 22 ∧ partnerSeq s7_params 3 = 336 ∧
    partnerSeq s7_params 4 = 6006 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> norm_num [partnerSeq, partnerPair, s7_params]

/-- s10's partner opens `1, 1, 17/2, 147/2, 6363/8` — already non-integral. -/
theorem s10_partner_values :
    partnerSeq s10_params 0 = 1 ∧ partnerSeq s10_params 1 = 1 ∧
    partnerSeq s10_params 2 = 17 / 2 ∧ partnerSeq s10_params 3 = 147 / 2 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> norm_num [partnerSeq, partnerPair, s10_params]

/-- s18's partner opens `1, 3, 45/2, 429/2` — likewise non-integral. -/
theorem s18_partner_values :
    partnerSeq s18_params 0 = 1 ∧ partnerSeq s18_params 1 = 3 ∧
    partnerSeq s18_params 2 = 45 / 2 ∧ partnerSeq s18_params 3 = 429 / 2 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> norm_num [partnerSeq, partnerPair, s18_params]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. NON-INTEGRALITY OF THE s10 AND s18 PARTNERS — COMPLETE        ║
-- ║                                                                    ║
-- ║  These are the easy direction and they are FULLY proved: a single   ║
-- ║  non-integral term refutes integrality outright. No finite-order    ║
-- ║  caveat applies to anything in this section.                        ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The s10 partner's `n = 2` term is `17/2`, which is not an integer: it would
    force `17 = 2m`. -/
theorem s10_partner_two_not_integral : ¬ IsIntegral (partnerSeq s10_params 2) := by
  rintro ⟨m, hm⟩
  rw [s10_partner_values.2.2.1] at hm
  have h : (17 : ℤ) = 2 * m := by
    have hq : (17 : ℚ) = 2 * (m : ℚ) := by linarith [hm]
    exact_mod_cast hq
  omega

/-- **The s10 partner series is not integral.** Tier A, complete — witnessed at
    `n = 2`. This is the "A4 rational 2-power partner" caveat, now a theorem
    rather than a note. -/
theorem s10_partner_not_integral : ¬ ∀ n, IsIntegral (partnerSeq s10_params n) :=
  fun h => s10_partner_two_not_integral (h 2)

/-- The s18 partner's `n = 2` term is `45/2`, which is not an integer: it would
    force `45 = 2m`. -/
theorem s18_partner_two_not_integral : ¬ IsIntegral (partnerSeq s18_params 2) := by
  rintro ⟨m, hm⟩
  rw [s18_partner_values.2.2.1] at hm
  have h : (45 : ℤ) = 2 * m := by
    have hq : (45 : ℚ) = 2 * (m : ℚ) := by linarith [hm]
    exact_mod_cast hq
  omega

/-- **The s18 partner series is not integral.** Tier A, complete — witnessed at
    `n = 2`. Together with `s10_partner_not_integral` this is the negative half of
    the candidate separation: of Cooper's three sporadic sequences, only s7 has a
    partner that is even a candidate for integrality. -/
theorem s18_partner_not_integral : ¬ ∀ n, IsIntegral (partnerSeq s18_params n) :=
  fun h => s18_partner_two_not_integral (h 2)

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. INTEGRALITY OF THE s7 PARTNER — PASS(7), NOT A THEOREM        ║
-- ║                                                                    ║
-- ║  This is the hard direction and it is NOT proved in general. The     ║
-- ║  recurrence divides by `(k+2)²`, so integrality at each step is a    ║
-- ║  genuine Apéry-style arithmetic statement, not a typing consequence. ║
-- ║  What follows is a kernel-checked finite range. Cite it as PASS(7).  ║
-- ║  The general statement is `open_goal_partner_integral_s7`.           ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **PASS(7).** The s7 partner's coefficients are integers for `n ≤ 7`, with the
    witnesses `1, 2, 22, 336, 6006, 117348, 2428272, 52303680` — kernel-checked,
    each by evaluating the recurrence, not by table lookup.

    This is EVIDENCE, NOT PROOF, of integrality. The general statement is open
    (`OpenGoals/PartnerIntegrality.lean`). Contrast `s10_partner_not_integral` and
    `s18_partner_not_integral`, which ARE complete: refuting integrality needs one
    witness, establishing it needs all of them.
    -- Source (values): A279619, confirmed against the primary source O'Brien 2016
    Theorem 6.1 (Stream 2 `refs/literature_provenance.txt`). -/
theorem s7_partner_integral_pass7 (n : ℕ) (hn : n ≤ 7) :
    IsIntegral (partnerSeq s7_params n) := by
  interval_cases n
  exacts [⟨1, by norm_num [partnerSeq, partnerPair, s7_params]⟩,
          ⟨2, by norm_num [partnerSeq, partnerPair, s7_params]⟩,
          ⟨22, by norm_num [partnerSeq, partnerPair, s7_params]⟩,
          ⟨336, by norm_num [partnerSeq, partnerPair, s7_params]⟩,
          ⟨6006, by norm_num [partnerSeq, partnerPair, s7_params]⟩,
          ⟨117348, by norm_num [partnerSeq, partnerPair, s7_params]⟩,
          ⟨2428272, by norm_num [partnerSeq, partnerPair, s7_params]⟩,
          ⟨52303680, by norm_num [partnerSeq, partnerPair, s7_params]⟩]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4½. GOLDEN MATCHES: partnerSeq vs the FORMAL SQUARE ROOT         ║
-- ║  (WP S1-12, after Deep Think's Q6 answer)                          ║
-- ║                                                                    ║
-- ║  `FormalSqrt.sqrtSeq` of the Cooper sequence and the recurrence-    ║
-- ║  defined `partnerSeq` agree — CAS-verified to n = 59 for all three  ║
-- ║  candidates, kernel-checked below for the first values on both the  ║
-- ║  integral (s7) and non-integral (s10) sides. Their equality for ALL ║
-- ║  n is the named open goal `open_goal_partner_eq_sqrt_s7`: it is the  ║
-- ║  solution-level transport of the operator identity L₃ = P₂·Sym²(L₂),║
-- ║  which the kernel has only at operator level. If it closes, the      ║
-- ║  dyadic baseline `sqrtSeq_dyadic` transports to `partnerSeq` and     ║
-- ║  s7's integrality question becomes purely 2-adic. s18 has no ℤ-      ║
-- ║  sequence definition in this repo (recurrence params only), so no    ║
-- ║  golden match is statable for it here.                              ║
-- ╚════════════════════════════════════════════════════════════════════╝

open FormalSqrt in
/-- The formal square root of `Σ s7(n)zⁿ` opens `2, 22, 336` — exactly
    `partnerSeq s7_params` (`s7_partner_values`). Kernel-checked instance of the
    bridge, on the integral side. -/
theorem sqrt_matches_partner_s7 :
    sqrtSeq (fun k => (s7 k : ℤ)) 1 = partnerSeq s7_params 1 ∧
    sqrtSeq (fun k => (s7 k : ℤ)) 2 = partnerSeq s7_params 2 ∧
    sqrtSeq (fun k => (s7 k : ℤ)) 3 = partnerSeq s7_params 3 := by
  have h1 : s7 1 = 4 := by decide
  have h2 : s7 2 = 48 := by decide
  have h3 : s7 3 = 760 := by decide
  have b1 : sqrtSeq (fun k => (s7 k : ℤ)) 1 = 2 := by
    rw [show (1 : ℕ) = 0 + 1 from rfl, sqrtSeq_succ]
    norm_num [h1]
  have b2 : sqrtSeq (fun k => (s7 k : ℤ)) 2 = 22 := by
    rw [show (2 : ℕ) = 1 + 1 from rfl, sqrtSeq_succ]
    norm_num [Finset.sum_range_one, b1, h2]
  have b3 : sqrtSeq (fun k => (s7 k : ℤ)) 3 = 336 := by
    rw [show (3 : ℕ) = 2 + 1 from rfl, sqrtSeq_succ]
    norm_num [Finset.sum_range_succ, Finset.sum_range_one, b1, b2, h3]
  exact ⟨by rw [b1, s7_partner_values.2.1],
         by rw [b2, s7_partner_values.2.2.1],
         by rw [b3, s7_partner_values.2.2.2.1]⟩

open FormalSqrt in
/-- The same match on the NON-integral side: the formal square root of
    `Σ s10(n)zⁿ` opens `1, 17/2` — exactly `partnerSeq s10_params`. So the `17/2`
    witnessing `s10_partner_not_integral` is not an artifact of the recurrence
    encoding; the square root itself produces it, as the dyadic baseline
    (`sqrtSeq_dyadic`) says it may. -/
theorem sqrt_matches_partner_s10 :
    sqrtSeq (fun k => (s10 k : ℤ)) 1 = partnerSeq s10_params 1 ∧
    sqrtSeq (fun k => (s10 k : ℤ)) 2 = partnerSeq s10_params 2 := by
  have h1 : s10 1 = 2 := by decide
  have h2 : s10 2 = 18 := by decide
  have b1 : sqrtSeq (fun k => (s10 k : ℤ)) 1 = 1 := by
    rw [show (1 : ℕ) = 0 + 1 from rfl, sqrtSeq_succ]
    norm_num [h1]
  have b2 : sqrtSeq (fun k => (s10 k : ℤ)) 2 = 17 / 2 := by
    rw [show (2 : ℕ) = 1 + 1 from rfl, sqrtSeq_succ]
    norm_num [Finset.sum_range_one, b1, h2]
  exact ⟨by rw [b1, s10_partner_values.2.1],
         by rw [b2, s10_partner_values.2.2.1]⟩

/-- The candidate separation, as far as it is currently proved.

    The two negative halves are unconditional; the s7 half is `PASS(7)` and is
    deliberately NOT part of this statement. Stated so that no downstream file can
    cite "only s7 is integral" as a single established fact — the asymmetry is the
    point, and it is visible in the type. -/
theorem cooper_partner_separation :
    (¬ ∀ n, IsIntegral (partnerSeq s10_params n)) ∧
    (¬ ∀ n, IsIntegral (partnerSeq s18_params n)) :=
  ⟨s10_partner_not_integral, s18_partner_not_integral⟩

end Agora.Sequences.Partner
