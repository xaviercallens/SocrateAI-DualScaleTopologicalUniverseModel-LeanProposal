/-
  PartnerOperators.lean
  ════════════════════════════════════════════════════════════════════════════════

  The order-2 "partner" operators L₂ of Cooper's s7 and s10, and the θ-form
  identities witnessing `L₃_Cooper = P₂ · Sym²(L₂)`.

  Companion document: `docs/STREAM1_LEAN_ENCODING_GUIDE_2026_07_25.md`, which
  records the derivation, the CAS cross-check, and why the encoding is shaped
  this way. Re-runnable verification: `scripts/verify_sym2_partner_identities.py`.

  WHY θ-FORM AND NOT `DiffOp3`/`symSquare`. Monic D-form normalisation of an
  order-3 operator introduces genuine rational-function coefficients and needs
  `RatFunc (Polynomial ℚ)`, which has no derivative API at the pinned Mathlib
  commit — this is the trap recorded as E-04b / E-006 in `briefs/ESCALATIONS.md`
  that blocked WP S1-08. Everything below stays in `Polynomial ℚ`: no division,
  no nonvanishing side conditions, every proof a `ring` goal. Bridging these
  statements to the `Agora/SymSquare.lean` `IsSymSquareOf` API is a T0 design
  question, deliberately not attempted here.

  0 sorry in this file.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.CooperRecurrences
import Mathlib.Algebra.Polynomial.Derivative

namespace Agora.Sequences.Partner

open Polynomial

/-- θ acting on a coefficient polynomial: `θ(f) = z · f′`, with `X` the variable `z`. -/
noncomputable def thetaC (f : Polynomial ℚ) : Polynomial ℚ := X * derivative f

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE ORDER-2 PARTNER OPERATORS                                 ║
-- ║  L₂ = P₂·θ² + P₁·θ + P₀                                            ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `P₂` of the s7 partner: `1 − 26z − 27z² = −(z+1)(27z−1)`.
    -- Source: `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md`, row `s7`
    (Stream 1 → Stream 2 handoff). Independently re-validated at series level:
    the holomorphic solution `f` of this operator satisfies `f² = Σ s7(n)zⁿ`
    (checked to `z¹²`, `scripts/verify_sym2_partner_identities.py` CLAIM 3). -/
noncomputable def s7_P2 : Polynomial ℚ := 1 - 26 * X - 27 * X ^ 2

/-- `P₁` of the s7 partner. Source as `s7_P2`. -/
noncomputable def s7_P1 : Polynomial ℚ := -13 * X - 27 * X ^ 2

/-- `P₀` of the s7 partner. Source as `s7_P2`. -/
noncomputable def s7_P0 : Polynomial ℚ := -2 * X - 6 * X ^ 2

/-- `P₂` of the s10 partner: `1 − 12z − 64z² = −(4z+1)(16z−1)`.
    -- Source: `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md`, row `s10`.
    CAVEAT (Tier B, "A4 rational 2-power partner"): the holomorphic solution of
    the s10 partner is NOT integral — its coefficients are
    `1, 1, 17/2, 147/2, 6363/8, …`, denominators powers of 2 — unlike s7's, which
    is `1, 2, 22, 336, 6006, …`. The identities in this file are unaffected (they
    live in `ℚ[z]`), but no integrality statement about the s10 partner is true
    as stated. -/
noncomputable def s10_P2 : Polynomial ℚ := 1 - 12 * X - 64 * X ^ 2

/-- `P₁` of the s10 partner. Source as `s10_P2`. -/
noncomputable def s10_P1 : Polynomial ℚ := -6 * X - 64 * X ^ 2

/-- `P₀` of the s10 partner. Source as `s10_P2`. -/
noncomputable def s10_P0 : Polynomial ℚ := -1 * X - 15 * X ^ 2

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. COOPER'S ORDER-3 OPERATOR, θ-COEFFICIENTS                     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- θ³-coefficient of Cooper's operator: `1 − 2a·z + c·z²`.
    -- Source: O. Gorodetsky, arXiv:2102.11839 v2, eq. (1.7),
    `θ³ − z(2θ+1)(aθ² + aθ + b) + z²(c(θ+1)³ + d(θ+1))`, expanded with every `z`
    moved to the left (the inner factors have constant coefficients, so no
    commutator terms arise). PDF fetched and SHA256-pinned,
    `refs/literature_provenance.txt`. -/
noncomputable def cooperC3 (p : CooperRecurrenceParams) : Polynomial ℚ :=
  1 - C (2 * (p.a : ℚ)) * X + C (p.c : ℚ) * X ^ 2

/-- θ²-coefficient of Cooper's operator: `−3a·z + 3c·z²`. Source as `cooperC3`. -/
noncomputable def cooperC2 (p : CooperRecurrenceParams) : Polynomial ℚ :=
  -C (3 * (p.a : ℚ)) * X + C (3 * (p.c : ℚ)) * X ^ 2

/-- θ¹-coefficient of Cooper's operator: `−(a+2b)·z + (3c+d)·z²`. Source as `cooperC3`. -/
noncomputable def cooperC1 (p : CooperRecurrenceParams) : Polynomial ℚ :=
  -C ((p.a : ℚ) + 2 * (p.b : ℚ)) * X + C (3 * (p.c : ℚ) + (p.d : ℚ)) * X ^ 2

/-- θ⁰-coefficient of Cooper's operator: `−b·z + (c+d)·z²`. Source as `cooperC3`. -/
noncomputable def cooperC0 (p : CooperRecurrenceParams) : Polynomial ℚ :=
  -C (p.b : ℚ) * X + C ((p.c : ℚ) + (p.d : ℚ)) * X ^ 2

attribute [local simp] derivative_sub derivative_add derivative_mul derivative_one

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE STRUCTURAL COLLAPSE                                       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- STRUCTURAL, all parameters: Cooper's θ²-coefficient is `3/2` of `θ` applied
    to its θ³-coefficient. Consequently, once the partner's `P₂` is matched to
    `cooperC3`, requiring the θ²-residual to vanish FORCES `θ(P₂) = 2·P₁`. The
    "magic collapse" is therefore a property of the Cooper template, not a
    coincidence of the two candidates. -/
theorem cooperC2_eq_thetaC_cooperC3 (p : CooperRecurrenceParams) :
    2 * cooperC2 p = 3 * thetaC (cooperC3 p) := by
  unfold cooperC2 thetaC cooperC3
  simp [map_ofNat, map_mul]
  ring

/-- The magic collapse for s7: `θ(P₂) = 2·P₁`.

    This is what makes the whole `Sym²` identity division-free. Clearing
    denominators in the θ¹- and θ⁰-residuals produces the terms `P₁·θ(P₂)` and
    `2P₀·θ(P₂)`; substituting `θ(P₂) = 2P₁` turns them into `2P₁²` and `4P₀P₁`,
    which cancel the `−2P₁²` and `−4P₁P₀` already present. Every surviving term
    then carries a single factor of `P₂`, so the identity drops from a
    rational-function statement needing `P₂²` to a polynomial one. -/
theorem s7_magic : thetaC s7_P2 = 2 * s7_P1 := by
  unfold thetaC s7_P2 s7_P1; simp; ring

/-- The magic collapse for s10. See `s7_magic` for the mechanism. -/
theorem s10_magic : thetaC s10_P2 = 2 * s10_P1 := by
  unfold thetaC s10_P2 s10_P1; simp; ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. VANISHING RESIDUALS: L₃ = P₂ · Sym²(L₂)                       ║
-- ║                                                                    ║
-- ║  With `α = P₁/P₂`, `β = P₀/P₂`, the monic symmetric square is      ║
-- ║    θ³ + 3α·θ² + (2α² + θα + 4β)·θ + (4αβ + 2θβ),                   ║
-- ║  and the residuals `D_k = c_k/c₃ − (Sym² coefficient)` satisfy      ║
-- ║    P₂²·D₂ = P₂·(c₂ − 3P₁)                                          ║
-- ║    P₂²·D₁ = P₂·(c₁ − θ(P₁) − 4P₀)                                  ║
-- ║    P₂²·D₀ = P₂·(c₀ − 2θ(P₀))                                       ║
-- ║  using the magic collapse. So `D₂ = D₁ = D₀ = 0` reduces to the     ║
-- ║  four polynomial identities proved below, per candidate.            ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Cooper's leading coefficient IS the s7 partner's `P₂` — so the symmetric
    square needs no spurious cofactor: `L₃ = P₂ · Sym²(L₂)` exactly. -/
theorem s7_res3 : cooperC3 s7_params = s7_P2 := by
  unfold cooperC3 s7_P2 s7_params; norm_num [map_ofNat, map_neg]; ring

/-- θ²-residual vanishes for s7: `c₂ = 3·P₁`. -/
theorem s7_res2 : cooperC2 s7_params = 3 * s7_P1 := by
  unfold cooperC2 s7_P1 s7_params; norm_num [map_ofNat, map_neg]; ring

/-- θ¹-residual vanishes for s7: `c₁ = θ(P₁) + 4·P₀`. -/
theorem s7_res1 : cooperC1 s7_params = thetaC s7_P1 + 4 * s7_P0 := by
  unfold cooperC1 thetaC s7_P1 s7_P0 s7_params; norm_num [map_ofNat, map_neg]; ring

/-- θ⁰-residual vanishes for s7: `c₀ = 2·θ(P₀)`. -/
theorem s7_res0 : cooperC0 s7_params = 2 * thetaC s7_P0 := by
  unfold cooperC0 thetaC s7_P0 s7_params; norm_num [map_ofNat, map_neg]; ring

/-- Cooper's leading coefficient IS the s10 partner's `P₂`. -/
theorem s10_res3 : cooperC3 s10_params = s10_P2 := by
  unfold cooperC3 s10_P2 s10_params; norm_num [map_ofNat, map_neg]; ring

/-- θ²-residual vanishes for s10: `c₂ = 3·P₁`. -/
theorem s10_res2 : cooperC2 s10_params = 3 * s10_P1 := by
  unfold cooperC2 s10_P1 s10_params; norm_num [map_ofNat, map_neg]; ring

/-- θ¹-residual vanishes for s10: `c₁ = θ(P₁) + 4·P₀`. -/
theorem s10_res1 : cooperC1 s10_params = thetaC s10_P1 + 4 * s10_P0 := by
  unfold cooperC1 thetaC s10_P1 s10_P0 s10_params; norm_num [map_ofNat, map_neg]; ring

/-- θ⁰-residual vanishes for s10: `c₀ = 2·θ(P₀)`. -/
theorem s10_res0 : cooperC0 s10_params = 2 * thetaC s10_P0 := by
  unfold cooperC0 thetaC s10_P0 s10_params; norm_num [map_ofNat, map_neg]; ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §5. NOT AN INSTANCE OF THE ZAGIER TEMPLATE                        ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The partner operators are NOT instances of `zagierThetaOperator`.

    That template's θ¹-coefficient is `θ` of its θ²-coefficient (`−Az + 2Bz²`),
    whereas the partners satisfy `θ(P₂) = 2·P₁`, i.e. `P₁ = θ(P₂)/2`. Matching
    θ² for s7 forces `A = 26, B = −27`, which would give θ¹-coefficient
    `−26z − 54z²`; the actual `P₁` is `−13z − 27z²`. The two templates agree only
    when `θ(P₂) = 0`. Recorded as a theorem so nobody re-derives the partner by
    instantiating the wrong template. -/
theorem s7_P1_ne_thetaC_P2 : thetaC s7_P2 ≠ s7_P1 := by
  unfold thetaC s7_P2 s7_P1
  intro h
  have := congrArg (fun q : Polynomial ℚ => q.coeff 1) h
  simp at this

/-- s10 analogue of `s7_P1_ne_thetaC_P2`. -/
theorem s10_P1_ne_thetaC_P2 : thetaC s10_P2 ≠ s10_P1 := by
  unfold thetaC s10_P2 s10_P1
  intro h
  have := congrArg (fun q : Polynomial ℚ => q.coeff 1) h
  simp at this

end Agora.Sequences.Partner
