/-
  Agora/Swampland/SymSquareC3b.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-08 — the generic Almkvist–van Straten self-adjointness criterion `W ≡ 0`
  for the Cooper operator family, in cleared-denominator (Option B) form.

  GATE HISTORY (see briefs/ESCALATIONS.md E-006):
    · E-006 filed: monic normalization of the Cooper θ-operator needs `RatFunc`
      coefficients (no derivative API at the pinned Mathlib commit) — E-04b.
    · T0s decision (2026-07-20): Option B — clear denominators, state a pure
      `Polynomial ℚ` identity, discharge by `ring`. Two-model concurrence gate:
      Fable derives `P_cleared`; Deep Think independently re-derives it; only on
      exact match may this be encoded in Lean.
    · Gate step 1 (2026-07-24): Fable's derivation posted, briefs/D1_P_CLEARED_FABLE_2026-07-24.md.
    · Gate step 2 (2026-07-24): Deep Think's independent CAS re-derivation CONCURS
      (SymPy/SageMath, no copying). Recorded in briefs/ESCALATIONS.md E-006.
    · THIS FILE discharges gate step 3: the Lean kernel proof.

  WHAT THIS PROVES (Tier A once built):
    For the generic Cooper θ-operator (Gorodetsky arXiv:2102.11839 eq 1.7,
    `Agora/Sequences/ThetaOperators.lean`'s `cooperThetaOperator`), converted to
    D-form (p3·D³+p2·D²+p1·D+p0), the Almkvist–van Straten criterion
      W = (1/3)a₂″ + (2/3)a₂·a₂′ + (4/27)a₂³ + 2a₀ − (2/3)a₁·a₂ − a₁′  (aᵢ = pᵢ/p3)
    is equivalent (since p3 ≠ 0 generically, `p3` a nonzero polynomial) to the pure
    polynomial identity `P_cleared ≡ 0` (numerator of `27·p3³·W`), proved here for
    ALL a,b,c,d : ℚ by `ring` — ONE kernel proof covering s7, s10, s18 (and any
    future Cooper-template candidate) simultaneously, by specialization.

    Per E-004's resolution (Deep Think, 2026-07-20): `W≡0` is STRUCTURAL for the
    whole Cooper ansatz — it establishes symmetric-square (K3) geometry as an
    entry ticket but does NOT discriminate among candidates. Discrimination lives
    in C3b (Shioda–Inose moduli map) — Stream 2 territory, not this file.

  D-FORM DERIVATION (consistency-checked against the ALREADY-PROVEN θ-form
  `cooperThetaOperator_eq` in `Agora/Sequences/ThetaOperators.lean`, via the
  standard substitution θ=zD, θ²=z²D²+zD, θ³=z³D³+3z²D²+zD — hand-verified to
  match Fable's independently-posted D-form term for term):
    p3 = z³(1 − 2az + cz²),        p2 = 3z²(1 − 3az + 2cz²)
    p1 = z(1 − (6a+2b)z + (7c+d)z²), p0 = z(−b + (c+d)z)

  EPISTEMIC NOTE: derivatives below are genuine `Polynomial.derivative` (formal,
  kernel-computed term-by-term differentiation) — NOT hand-transcribed closed
  forms. This is deliberate: encoding a hand-computed "derivative" as an opaque
  definition would let a transcription error slip past `ring` undetected. Using
  `Polynomial.derivative` means the kernel itself verifies every differentiation
  step, matching the project's "kernel is the judge" discipline.

  0 sorry (both s7 and s10 discharged by specialization of the single generic
  theorem `P_cleared_eq_zero`).

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.CooperRecurrences
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Tactic

namespace Agora.Swampland.SymSquareC3b

open Polynomial Agora.Sequences

noncomputable section

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. D-FORM COEFFICIENTS OF THE GENERIC COOPER OPERATOR            ║
-- ║  (Fable 5's derivation, gate-step-1/2 verified — see header)       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- D-form leading (D³) coefficient of the generic Cooper operator,
    p3 = z³(1 − 2az + cz²). -- Source: briefs/D1_P_CLEARED_FABLE_2026-07-24.md §2,
    cross-checked against `cooperThetaOperator_eq` (θ=zD substitution). -/
def p3 (a c : ℚ) : Polynomial ℚ := X ^ 3 * (1 - C (2 * a) * X + C c * X ^ 2)

/-- D-form D² coefficient, p2 = 3z²(1 − 3az + 2cz²). -/
def p2 (a c : ℚ) : Polynomial ℚ := 3 * X ^ 2 * (1 - C (3 * a) * X + C (2 * c) * X ^ 2)

/-- D-form D¹ coefficient, p1 = z(1 − (6a+2b)z + (7c+d)z²). -/
def p1 (a b c d : ℚ) : Polynomial ℚ := X * (1 - C (6 * a + 2 * b) * X + C (7 * c + d) * X ^ 2)

/-- D-form D⁰ coefficient, p0 = z(−b + (c+d)z). -/
def p0 (b c d : ℚ) : Polynomial ℚ := X * (C (-b) + C (c + d) * X)

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE CLEARED ALMKVIST–VAN STRATEN IDENTITY                     ║
-- ║  P_cleared = 27·p3³·W, every term a genuine polynomial product.    ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The numerator of `27·p3³·W` after substituting `aᵢ = pᵢ/p3` into the
    Almkvist–van Straten self-adjointness criterion and clearing denominators
    (Option B, `briefs/ESCALATIONS.md` E-006 resolution, 2026-07-20). Six terms,
    matching Fable's posted derivation exactly (gate step 1) and Deep Think's
    independent re-derivation (gate step 2, CONCUR). -/
def P_cleared (a b c d : ℚ) : Polynomial ℚ :=
  9 * (derivative (derivative (p2 a c)) * (p3 a c) ^ 2
        - (p2 a c) * (p3 a c) * derivative (derivative (p3 a c))
        - 2 * derivative (p2 a c) * (p3 a c) * derivative (p3 a c)
        + 2 * (p2 a c) * derivative (p3 a c) ^ 2)
    + 18 * (p2 a c) * (derivative (p2 a c) * (p3 a c) - (p2 a c) * derivative (p3 a c))
    + 4 * (p2 a c) ^ 3
    + 54 * (p0 b c d) * (p3 a c) ^ 2
    - 18 * (p1 a b c d) * (p2 a c) * (p3 a c)
    - 27 * (p3 a c) * (derivative (p1 a b c d) * (p3 a c) - (p1 a b c d) * derivative (p3 a c))

/-- **KERNEL FACT (Tier A) — discharges WP S1-08 / E-006 for the ENTIRE Cooper
    family at once.** `P_cleared ≡ 0` for every parameter choice `a b c d : ℚ`.

    Since `P_cleared = 27·p3³·W` and `p3` is a nonzero polynomial for every
    parameter choice (constant term 1, cf. `cooper_leadCoeff_ne_zero` after the
    θ→D conversion), this is equivalent to `W ≡ 0`: the Cooper ansatz is
    STRUCTURALLY a symmetric square for every (a,b,c,d), confirming E-004's
    finding that C3 does not discriminate among candidates (discrimination is
    C3b's job, Stream 2 territory).

    Proof: pure ring identity in `Polynomial ℚ` after pushing every
    `Polynomial.derivative` and `Polynomial.C` through the algebraic structure;
    `ring` closes the resulting polynomial equation directly (no case split,
    no induction — same shape as `cooperThetaOperator_eq`'s proof). -/
theorem P_cleared_eq_zero (a b c d : ℚ) : P_cleared a b c d = 0 := by
  unfold P_cleared p3 p2 p1 p0
  simp only [derivative_mul, derivative_pow, derivative_C, derivative_X, derivative_one,
    derivative_zero, derivative_ofNat, map_add, map_sub, map_mul, map_neg, map_ofNat,
    map_natCast, mul_zero, zero_mul, add_zero, zero_add, sub_zero, one_mul, mul_one,
    Nat.cast_ofNat]
  ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. SPECIALIZATION — s7 AND s10 (SYM2_PROVED)                     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Cooper s7's cleared self-adjointness identity vanishes — an immediate
    specialization of the generic kernel fact, using the already-sourced
    `s7_params` (Cooper 2012, Ramanujan J. 29, Table 1; cf.
    `Agora/Sequences/CooperRecurrences.lean`). Discharges `C3b_L3_sym2_L2_s7`:
    C3 upgrades from `SYM2_SYMBOLIC` to `SYM2_PROVED`. -/
theorem P_cleared_s7 :
    P_cleared (s7_params.a : ℚ) (s7_params.b : ℚ) (s7_params.c : ℚ) (s7_params.d : ℚ) = 0 :=
  P_cleared_eq_zero _ _ _ _

/-- Cooper s10's cleared self-adjointness identity vanishes — specialization
    using `s10_params` (Cooper 2012, Table 1). Discharges `C3b_L3_sym2_L2_s10`:
    C3 upgrades from `SYM2_SYMBOLIC` to `SYM2_PROVED`. -/
theorem P_cleared_s10 :
    P_cleared (s10_params.a : ℚ) (s10_params.b : ℚ) (s10_params.c : ℚ) (s10_params.d : ℚ) = 0 :=
  P_cleared_eq_zero _ _ _ _

/-- Cooper s18's cleared self-adjointness identity vanishes — specialization
    using `s18_params`. NOTE (scope guard, per
    `briefs/STREAM2_C3B_OPERATOR_IDENTITY_HANDOFF.md` §4): this discharges ONLY
    the generic C3 (symmetric-square structure) obligation for s18; it does
    NOT certify `s18_params`'s recurrence transcription itself (flagged corrupt
    pending re-transcription from arXiv:2102.11839 v2 p.3 — see
    `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md` §4). C3 is structural (E-004)
    and holds regardless of which citable Cooper-template parameters are used;
    it is silent on whether `s18_params`'s current values are themselves
    correctly transcribed. -/
theorem P_cleared_s18 :
    P_cleared (s18_params.a : ℚ) (s18_params.b : ℚ) (s18_params.c : ℚ) (s18_params.d : ℚ) = 0 :=
  P_cleared_eq_zero _ _ _ _

end

end Agora.Swampland.SymSquareC3b
