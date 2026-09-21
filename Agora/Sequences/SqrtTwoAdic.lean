/-
  Agora/Sequences/SqrtTwoAdic.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE 2-ADIC BOUND ON A FORMAL SQUARE ROOT.

  Requested by Stream 2, brief
  `briefs/STREAM2_TO_STREAMS1_3_LEANMASTER_RESULTS_AND_DIRECTIONS_2026_09_21.md`
  §2 direction 4 (their R7, `PARTNER_GLOBAL_BOUNDEDNESS`, PASS(160)):

      "e(n) ≤ n−1 for the s10 partner — you already have `sqrtSeq_dyadic`; the
       sharper statement is that 2ⁿ⁻¹·a(n) ∈ ℤ, i.e. the partner in the
       coordinate 2z is integral."

  WHAT IS PROVED

  §1  `sqrtSeq_two_adic` — for ANY integer series with `s 1` even, the formal
      square root satisfies `2ⁿ · b(n+1) ∈ ℤ` for every `n`. `sqrtSeq_dyadic`
      says the denominators are powers of 2; this bounds WHICH power.
  §2  `s10_partner_two_adic` — hence `2ⁿ · partnerSeq s10_params (n+1) ∈ ℤ`,
      which is Stream 2's `2ⁿ⁻¹·a(n) ∈ ℤ` for `n ≥ 1`. Upgrades PASS(160) to all n.
  §3  Controls: the hypothesis is necessary, and the exponent is sharp.

  ⭐ THE FINDING. Stream 2 asked for this about the s10 partner and described it
  as holding "modulo two Stream 1 theorems". It is not specific to s10, to the
  Cooper template, or to any recurrence: it holds for every integer series whose
  linear coefficient is even. The ONLY place parity enters is `n = 0`, where
  `b(1) = s(1)/2`; for `n ≥ 1` the recurrence
      2ⁿ·b(n+1) = 2ⁿ⁻¹·s(n+1) − Σᵢ (2ⁱ·b(i+1)) · (2ⁿ⁻¹⁻ⁱ·b(n−i))
  has an integer right-hand side by induction, whatever the higher `s(k)` are.
  So the s10 statement needs exactly one fact about s10: `s10 1 = 2`.

  WHAT IS NOT PROVED
  * Nothing about s18 (no closed form for s18 is instantiated in this repo).
  * That `n−1` is the exact 2-adic valuation for s10 at any particular `n`. §3
    shows the exponent cannot be improved IN GENERAL (witness `1 + 2z`); it says
    nothing about whether s10 itself attains it.
  * Nothing here concerns physics (VISION §1.3, F5b).

  0 sorry. Axioms: Lean's standard ones only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.SqrtBridgeGeneric

namespace Agora.Sequences.SqrtTwoAdic

open Agora.Sequences Agora.Sequences.Partner Agora.Sequences.FormalSqrt Finset

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE GENERAL BOUND                                              ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **`2ⁿ · b(n+1) ∈ ℤ`** for the formal square root `b` of any integer series
    `s` with `s 1` even.

    -- Source: Stream 2 brief, direction 4 (their R7). Stated there for the s10
    partner; proved here for every integer series with even linear coefficient,
    since nothing else about `s` is used. -/
theorem sqrtSeq_two_adic (s : ℕ → ℤ) (h1 : (2 : ℤ) ∣ s 1) :
    ∀ n : ℕ, ∃ k : ℤ, sqrtSeq s (n + 1) * 2 ^ n = (k : ℚ) := by
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rw [sqrtSeq_succ]
    rcases n with _ | n
    · obtain ⟨c, hc⟩ := h1
      refine ⟨c, ?_⟩
      simp only [Finset.range_zero, Finset.sum_empty, sub_zero, pow_zero, mul_one]
      rw [hc]; push_cast; ring
    · -- each summand, scaled by `2ⁿ`, is an integer
      have hterm : ∀ i ∈ Finset.range (n + 1),
          ∃ k : ℤ, sqrtSeq s (i + 1) * sqrtSeq s (n + 1 - i) * 2 ^ n = (k : ℚ) := by
        intro i hi
        have hi' : i < n + 1 := Finset.mem_range.mp hi
        obtain ⟨p, hp⟩ := ih i hi'
        obtain ⟨q, hq⟩ := ih (n - i) (by omega)
        have hidx : n + 1 - i = n - i + 1 := by omega
        have hpow : (2 : ℚ) ^ n = 2 ^ i * 2 ^ (n - i) := by
          rw [← pow_add]; congr 1; omega
        refine ⟨p * q, ?_⟩
        rw [hidx, hpow]; push_cast
        rw [← hp, ← hq]; ring
      choose! f hf using hterm
      refine ⟨s (n + 1 + 1) * 2 ^ n - ∑ i ∈ Finset.range (n + 1), f i, ?_⟩
      have e : ((s (n + 1 + 1) : ℚ) -
            ∑ i ∈ Finset.range (n + 1), sqrtSeq s (i + 1) * sqrtSeq s (n + 1 - i)) / 2
              * 2 ^ (n + 1)
          = (s (n + 1 + 1) : ℚ) * 2 ^ n
            - ∑ i ∈ Finset.range (n + 1),
                sqrtSeq s (i + 1) * sqrtSeq s (n + 1 - i) * 2 ^ n := by
        rw [← Finset.sum_mul, pow_succ]; ring
      rw [e, Finset.sum_congr rfl hf]
      push_cast; ring

/-- The same, indexed as Stream 2 states it: `2ⁿ⁻¹ · b(n) ∈ ℤ` for `n ≥ 1`.
    (Named without a trailing prime on purpose: `axiom_audit.py` cannot resolve a
    primed name and reports it MISSING, i.e. UNAUDITED — which the release gate
    rightly counts as a failure. Found when this theorem was first called
    `sqrtSeq_two_adic'` and the gate went red on it.) -/
theorem sqrtSeq_two_adic_of_pos (s : ℕ → ℤ) (h1 : (2 : ℤ) ∣ s 1) (n : ℕ) (hn : 1 ≤ n) :
    ∃ k : ℤ, sqrtSeq s n * 2 ^ (n - 1) = (k : ℚ) := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
  simpa using sqrtSeq_two_adic s h1 m

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE s10 PARTNER                                                ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **The s10 partner is integral in the coordinate `2z`:**
    `2ⁿ⁻¹ · partnerSeq s10_params n ∈ ℤ` for every `n ≥ 1`. Upgrades Stream 2's
    `PASS(160)` to all `n`. The only fact about s10 used, beyond the bridge
    `partner_eq_sqrt_s10`, is that `s10 1 = 2` is even. -/
theorem s10_partner_two_adic (n : ℕ) (hn : 1 ≤ n) :
    ∃ k : ℤ, partnerSeq s10_params n * 2 ^ (n - 1) = (k : ℚ) := by
  rw [Agora.Sequences.SqrtBridge.partner_eq_sqrt_s10]
  exact sqrtSeq_two_adic_of_pos _ (by decide) n hn

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. CONTROLS                                                       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **CONTROL 1: the hypothesis is necessary.** With `s 1 = 3` odd, `b(1) = 3/2`,
    so `2⁰ · b(1)` is not an integer. `sqrtSeq_two_adic` is therefore not true of
    every integer series. -/
theorem two_adic_needs_even :
    ¬ ∃ k : ℤ, sqrtSeq (fun n => if n = 1 then 3 else if n = 0 then 1 else 0) 1 * 2 ^ 0
        = (k : ℚ) := by
  rintro ⟨k, hk⟩
  rw [sqrtSeq_succ] at hk
  simp only [Finset.range_zero, Finset.sum_empty, sub_zero, pow_zero, mul_one] at hk
  norm_num at hk
  have h2 : (3 : ℚ) = 2 * (k : ℚ) := by linarith
  have h3 : (3 : ℤ) = 2 * k := by exact_mod_cast h2
  omega

/-- **CONTROL 2: the exponent is sharp in general.** For `s = 1 + 2z`,
    `b(2) = −1/2`, so `2⁰ · b(2)` is NOT an integer although `2¹ · b(2) = −1` is.
    The bound `n − 1` cannot be lowered to `n − 2`. (The scaled coefficients are
    the signed Catalan numbers `1, −1, 2, −5, 14, …`.) -/
theorem two_adic_exponent_sharp :
    sqrtSeq (fun n => if n = 0 then 1 else if n = 1 then 2 else 0) 2 = -1 / 2 := by
  rw [sqrtSeq_succ, Finset.sum_range_one, sqrtSeq_succ]
  simp

end Agora.Sequences.SqrtTwoAdic

/-
  Generated-by: Claude Fable 5.1 (Stream 1 session) | Verified-by: Lean 4 kernel;
  bound pre-checked on 3,000 random integer series to n = 14 (0 failures), with
  the necessity and sharpness controls computed independently | Reviewed-by: T0 N
-/
