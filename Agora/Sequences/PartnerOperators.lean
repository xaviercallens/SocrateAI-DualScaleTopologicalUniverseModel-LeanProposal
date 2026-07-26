/-
  PartnerOperators.lean
  ════════════════════════════════════════════════════════════════════════════════

  The order-2 "partner" operators L₂ of Cooper's sporadic sequences, and the
  θ-form identities witnessing `L₃_Cooper = P₂ · Sym²(L₂)`.

  MAIN RESULT (§2½–§3½, added 2026-07-26). The identities are not three separate
  facts about three candidates: read in order they DETERMINE the partner from the
  Cooper parameters `(a,b,c,d)`, and the resulting constraint holds identically.
  So EVERY operator of the Cooper template is `P₂ · Sym²` of an explicit order-2
  operator. s7, s10 and s18 are corollaries. In particular the s18 partner is
  obtained without any new algebra, and without a literature transcription —
  which matters, because no order-2 companion for s18 has been identified in the
  literature (`briefs/STREAM2_TO_STREAM1_E009_STATUS_2026_07_26.md`).

  What this does NOT establish: that the s18 partner is *modular*, or elliptic, or
  geometrically meaningful. It is an operator identity over `ℚ[z]`. The s7 partner
  is separately known to be A279619 (weight-1, disc −7); nothing of the kind is
  claimed here for s18, and its holomorphic solution is not even integral (see
  `s18_P2`). Distinguishing "has a formal Sym² partner" from "has a modular
  companion" is the whole point of stating it this way.

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

/-- `P₂` of the s18 partner: `1 − 28z + 192z² = (1−12z)(1−16z)`.

    Unlike s7's and s10's, this operator was NOT transcribed from a handoff — it is
    what `partnerP2` returns on `s18_params` (`s18_P2_eq` below), i.e. it is forced
    by the θ-form identities. Its finite singular points are `z = 1/12, 1/16`
    (s7: `1/27, −1`; s10: `1/16, −1/4`).
    -- Source: derived here from `s18_params`; see `partnerP2`. The parameters
    themselves are Gorodetsky arXiv:2102.11839 v2 p.3, independently corroborated
    by Almkvist–van Straten arXiv:2103.08651 §"three sporadic third order operators"
    (see `Agora/Sequences/CooperRecurrences.lean`, `s18_params`).

    CAVEAT (same shape as s10's, Tier A by finite witness): the holomorphic solution
    of the s18 partner is NOT integral. Its coefficients begin
    `1, 3, 45/2, 429/2, 18387/8, …` — the value `45/2` at `n = 2` already settles it.
    So s7 is the ONLY one of Cooper's three sporadic sequences whose order-2 partner
    has an integral holomorphic solution. Series checks:
    `scripts/verify_sym2_partner_identities.py`. -/
noncomputable def s18_P2 : Polynomial ℚ := 1 - 28 * X + 192 * X ^ 2

/-- `P₁` of the s18 partner. Source as `s18_P2`. -/
noncomputable def s18_P1 : Polynomial ℚ := -14 * X + 192 * X ^ 2

/-- `P₀` of the s18 partner. Source as `s18_P2`. -/
noncomputable def s18_P0 : Polynomial ℚ := -3 * X + 45 * X ^ 2

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

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2½. THE PARTNER, GENERICALLY                                     ║
-- ║                                                                    ║
-- ║  The four θ-form identities do not merely *hold* for s7 and s10 —   ║
-- ║  read in order, they DETERMINE the partner from the Cooper          ║
-- ║  parameters, leaving nothing free:                                  ║
-- ║    c₃ = P₂                    fixes P₂                              ║
-- ║    c₂ = 3P₁                   fixes P₁                              ║
-- ║    c₁ = θ(P₁) + 4P₀           fixes P₀                              ║
-- ║    c₀ = 2θ(P₀)                is then a CONSTRAINT, not a choice.   ║
-- ║  §3–§4 below prove that the constraint — and the magic collapse      ║
-- ║  θ(P₂) = 2P₁ — hold identically in `(a,b,c,d)`. So every operator    ║
-- ║  of the Cooper template is `P₂ · Sym²` of an explicit order-2        ║
-- ║  operator, and s7/s10/s18 are corollaries, not separate results.     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `P₂` of the order-2 partner, generically: `1 − 2a·z + c·z²`, i.e. exactly
    Cooper's own leading coefficient `c₃` (see `partner_res3`).
    -- Source: derived, not transcribed — solved out of the θ-form identities of
    `cooperC3`/`cooperC2`/`cooperC1` (Gorodetsky arXiv:2102.11839 v2 eq. (1.7)).
    Reproduces the independently-recorded s7 and s10 partners of
    `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md` exactly — see `s7_P2_eq`,
    `s10_P2_eq`, and the cross-validation in
    `scripts/verify_sym2_partner_identities.py`. -/
noncomputable def partnerP2 (p : CooperRecurrenceParams) : Polynomial ℚ :=
  1 - C (2 * (p.a : ℚ)) * X + C (p.c : ℚ) * X ^ 2

/-- `P₁` of the order-2 partner: `−a·z + c·z²` (= `c₂/3`). Source as `partnerP2`. -/
noncomputable def partnerP1 (p : CooperRecurrenceParams) : Polynomial ℚ :=
  -C (p.a : ℚ) * X + C (p.c : ℚ) * X ^ 2

/-- `P₀` of the order-2 partner: `−(b/2)·z + ((c+d)/4)·z²`.

    The halves and quarters are genuine: the partner lives in `ℚ[z]`, not `ℤ[z]`,
    even when the Cooper parameters are integers. (For s7, s10 and s18 they happen
    to clear — `−2z−6z²`, `−z−15z²`, `−3z+45z²` — but that is arithmetic luck per
    candidate, not a property of the template.) Source as `partnerP2`. -/
noncomputable def partnerP0 (p : CooperRecurrenceParams) : Polynomial ℚ :=
  -C ((p.b : ℚ) / 2) * X + C (((p.c : ℚ) + (p.d : ℚ)) / 4) * X ^ 2

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

/-- The magic collapse, for EVERY Cooper parameter choice: `θ(P₂) = 2·P₁`.

    `s7_magic` and `s10_magic` below are instances. This is what makes the
    `Sym²` identity division-free (see the §4 header for the cancellation). -/
theorem partner_magic (p : CooperRecurrenceParams) :
    thetaC (partnerP2 p) = 2 * partnerP1 p := by
  unfold thetaC partnerP2 partnerP1
  simp [map_ofNat, map_mul]
  ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3½. THE FOUR RESIDUAL IDENTITIES, GENERICALLY                    ║
-- ║  One proof each, covering s7, s10, s18 and every other operator of  ║
-- ║  the Cooper template simultaneously.                                ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- θ³: Cooper's leading coefficient IS the partner's `P₂`, so `L₃ = P₂·Sym²(L₂)`
    carries no spurious cofactor. True by construction — `partnerP2` was solved
    out of this identity — and recorded so the construction is auditable. -/
theorem partner_res3 (p : CooperRecurrenceParams) : cooperC3 p = partnerP2 p := rfl

/-- θ²: `c₂ = 3·P₁`, for every parameter choice. -/
theorem partner_res2 (p : CooperRecurrenceParams) :
    cooperC2 p = 3 * partnerP1 p := by
  unfold cooperC2 partnerP1
  simp [map_ofNat, map_mul]
  ring

/-- `C` is an opaque atom to `ring`, so the two halved/quartered coefficients of
    `partnerP0` have to be related to their cleared forms by hand. -/
private theorem C_half_b (p : CooperRecurrenceParams) :
    C ((p.b : ℚ) / 2) * 2 = ((p.b : ℤ) : Polynomial ℚ) := by
  rw [← map_ofNat C 2, ← map_mul,
    show ((p.b : ℚ) / 2 * 2) = ((p.b : ℤ) : ℚ) by push_cast; ring, map_intCast]

private theorem C_quarter_cd (p : CooperRecurrenceParams) :
    C (((p.c : ℚ) + (p.d : ℚ)) / 4) * 4
      = ((p.c : ℤ) : Polynomial ℚ) + ((p.d : ℤ) : Polynomial ℚ) := by
  rw [← map_ofNat C 4, ← map_mul,
    show (((p.c : ℚ) + (p.d : ℚ)) / 4 * 4) = ((p.c + p.d : ℤ) : ℚ) by push_cast; ring,
    map_intCast]
  push_cast
  ring

/-- θ¹: `c₁ = θ(P₁) + 4·P₀`, for every parameter choice. -/
theorem partner_res1 (p : CooperRecurrenceParams) :
    cooperC1 p = thetaC (partnerP1 p) + 4 * partnerP0 p := by
  unfold cooperC1 thetaC partnerP1 partnerP0
  simp [map_ofNat, map_mul, map_add]
  linear_combination 2 * X * C_half_b p - X ^ 2 * C_quarter_cd p

/-- θ⁰: `c₀ = 2·θ(P₀)`.

    This is the identity with actual content. `partnerP2`, `partnerP1`, `partnerP0`
    are already pinned by `partner_res3`/`partner_res2`/`partner_res1`, so nothing
    is left to tune here — the equation either holds or the Cooper template is not
    a symmetric square. It holds, identically in `(a,b,c,d)`. -/
theorem partner_res0 (p : CooperRecurrenceParams) :
    cooperC0 p = 2 * thetaC (partnerP0 p) := by
  unfold cooperC0 thetaC partnerP0
  simp [map_ofNat, map_mul, map_add]
  linear_combination X * C_half_b p - X ^ 2 * C_quarter_cd p

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

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3¾. THE GENERIC CONSTRUCTION REPRODUCES THE RECORDED PARTNERS    ║
-- ║                                                                    ║
-- ║  s7's and s10's partners reached this repo by a different route —   ║
-- ║  transcribed from `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md`, which  ║
-- ║  got them from an independent CAS extraction. Proving that          ║
-- ║  `partnerP*` reproduces them exactly is therefore a genuine          ║
-- ║  cross-check of the derivation in §2½, not a restatement: two        ║
-- ║  independent routes, same operators. It is also what licenses        ║
-- ║  trusting `partnerP*` on s18, where there is no handoff to compare   ║
-- ║  against.                                                           ║
-- ╚════════════════════════════════════════════════════════════════════╝

theorem s7_P2_eq : s7_P2 = partnerP2 s7_params := by
  unfold s7_P2 partnerP2 s7_params; norm_num [map_ofNat, map_neg]; ring

theorem s7_P1_eq : s7_P1 = partnerP1 s7_params := by
  unfold s7_P1 partnerP1 s7_params; norm_num [map_ofNat, map_neg]; ring

theorem s7_P0_eq : s7_P0 = partnerP0 s7_params := by
  unfold s7_P0 partnerP0 s7_params; norm_num [map_ofNat, map_neg]; ring

theorem s10_P2_eq : s10_P2 = partnerP2 s10_params := by
  unfold s10_P2 partnerP2 s10_params; norm_num [map_ofNat, map_neg]; ring

theorem s10_P1_eq : s10_P1 = partnerP1 s10_params := by
  unfold s10_P1 partnerP1 s10_params; norm_num [map_ofNat, map_neg]; ring

theorem s10_P0_eq : s10_P0 = partnerP0 s10_params := by
  unfold s10_P0 partnerP0 s10_params; norm_num [map_ofNat, map_neg]; ring

theorem s18_P2_eq : s18_P2 = partnerP2 s18_params := by
  unfold s18_P2 partnerP2 s18_params; norm_num [map_ofNat, map_neg]

theorem s18_P1_eq : s18_P1 = partnerP1 s18_params := by
  unfold s18_P1 partnerP1 s18_params; norm_num [map_ofNat, map_neg]

theorem s18_P0_eq : s18_P0 = partnerP0 s18_params := by
  unfold s18_P0 partnerP0 s18_params; norm_num [map_ofNat, map_neg]

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

-- ── s18: the same four facts, now FREE from §3½ ────────────────────────
-- No new algebra: each is the generic theorem transported along the `_eq`
-- lemmas. This is the payoff of proving the identities over the template
-- rather than per candidate — the same payoff S1-08 got from
-- `P_cleared_eq_zero`.

/-- The magic collapse for s18. -/
theorem s18_magic : thetaC s18_P2 = 2 * s18_P1 := by
  rw [s18_P2_eq, s18_P1_eq]; exact partner_magic _

/-- Cooper's leading coefficient IS the s18 partner's `P₂`. -/
theorem s18_res3 : cooperC3 s18_params = s18_P2 := by
  rw [s18_P2_eq]; exact partner_res3 _

/-- θ²-residual vanishes for s18: `c₂ = 3·P₁`. -/
theorem s18_res2 : cooperC2 s18_params = 3 * s18_P1 := by
  rw [s18_P1_eq]; exact partner_res2 _

/-- θ¹-residual vanishes for s18: `c₁ = θ(P₁) + 4·P₀`. -/
theorem s18_res1 : cooperC1 s18_params = thetaC s18_P1 + 4 * s18_P0 := by
  rw [s18_P1_eq, s18_P0_eq]; exact partner_res1 _

/-- θ⁰-residual vanishes for s18: `c₀ = 2·θ(P₀)`. -/
theorem s18_res0 : cooperC0 s18_params = 2 * thetaC s18_P0 := by
  rw [s18_P0_eq]; exact partner_res0 _

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
