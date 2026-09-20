/-
  Agora/Geometry/SelfDual.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE SELF-DUAL LOCUS — Tier A content of the "walk toward the self-dual point"
  evaluation (briefs/THOUGHT_EXPERIMENTS_SELF_DUAL_2026_09_20.md).

  Four kernel-checked facts, each the exact-algebra core of one thought
  experiment recorded there:

   §1 (GE-1) THE SWAP IS A WEYL REFLECTION. `r = e − f` has norm `−2` in
      `U ⊕ ⟨2N⟩` for every `N`, and `MnLattice.swap` IS LeanMaster's
      `reflection (TN N) r`. Same on the bare hyperbolic plane / Narain lattice.
   §2 (GE-2) THE SELF-DUAL LOCUS IS THE ROOT'S WALL. The root `r` is orthogonal
      to the period `ω(τ)` iff `Nτ² = −1`.
   §3 (GE-3) THE SINGULAR POINTS OF L₃ ARE THE FIXED POINTS OF THE FRICKE MAP ON
      THE HAUPTMODUL LINE. With `z(h) = h / (1 + 13h + 49h²)`:
        • `z(1/(49h)) = z(h)`                        (Fricke invariance)
        • `z(1/7) = 1/27`, `z(−1/7) = −1`            (the two fixed points)
        • `P₂(z(h))·(1+13h+49h²)² = (1 − 49h²)²`     (discriminant = perfect square)
      where `P₂ = 1 − 26z − 27z²` is the leading coefficient of the s7 partner
      operator (`PartnerOperators.s7_P2`), whose roots `{−1, 1/27}` are the finite
      singular locus of L₂ and L₃.
   §4 (GE-4) THE DUAL-SCALE HEIGHT. `Nt² + 1/(Nt²) ≥ 2` for `t > 0`, invariant under
      `t ↦ 1/(Nt)`, with equality iff `Nt² = 1` — obtained FROM LeanMaster's
      `circle_effective_scale_ge_two`, i.e. it is literally the circle's
      dual-scale bound evaluated at `R = Nt²`.

  ────────────────────────────────────────────────────────────────────────────────
  EPISTEMIC STATUS

  Tier A: every statement here is an identity of integer matrices, or of rational
  functions over a field, or a real inequality.

  NOT established here (status L/E, see the brief): that `z(h)` with
  `h = (η(7τ)/η(τ))⁴` is the modular parametrization of the s7 family, and that
  `h ↦ 1/(49h)` is induced by `τ ↦ −1/(7τ)`. The first was checked in-session as
  an exact q-series identity to finite order (PASS(N), see brief); the second is
  the η transformation law. §3 is therefore a theorem about the rational map
  `z(h)`; reading it as a statement about the s7 family imports those two inputs.

  NOT established and NOT claimed: any physics. That the wall of a (−2)-root is a
  locus of enhanced gauge symmetry is a literature statement about string
  compactifications (Tier C in this program, F5b): it is recorded in the brief as
  context and appears nowhere below.

  0 sorry. Axioms: Lean's three only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Geometry.MnLattice
import Agora.Sequences.PartnerOperators
import DualScaleStream2.DualScale.TraceBound

namespace Agora.Geometry.SelfDual

open Matrix DualScaleStream2.Lattice Agora.Geometry.MnLattice

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. GE-1 — the swap is the reflection in the (−2)-root e − f      ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The root `e − f` of the `U` summand, in coordinates `(e, f, w)`. -/
def root : Fin 3 → ℤ := ![1, -1, 0]

/-- `(e − f)² = −2` in `U ⊕ ⟨2N⟩`, for every `N`. -/
theorem root_norm (N : ℤ) : latticeNorm (TN N) root = -2 := by
  simp [latticeNorm, TN, root, dotProduct, mulVec, Fin.sum_univ_succ]

/-- **The swap is a Weyl reflection**: `swap = s_{e−f}`, LeanMaster's `reflection`. -/
theorem swap_eq_reflection (N : ℤ) : swap = reflection (TN N) root := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [swap, reflection, TN, root, vecMulVec, Matrix.mul_apply, Matrix.one_apply,
      Fin.sum_univ_succ]

/-- Hence isometry and involution also follow from LeanMaster's general theorems
    about `(−2)`-reflections — an independent second derivation of
    `MnLattice.swap_isometry` / `swap_involution`. -/
theorem swap_isometry_via_reflection (N : ℤ) : swapᵀ * TN N * swap = TN N := by
  rw [swap_eq_reflection N]
  exact reflection_isometry (TN N) (TN_symm N) root (root_norm N)

theorem swap_involution_via_reflection (N : ℤ) : swap * swap = 1 := by
  rw [swap_eq_reflection N]
  exact reflection_involution (TN N) root (root_norm N)

/-- The same on the bare hyperbolic plane (= LeanMaster's Narain Gram matrix):
    the momentum–winding exchange is the reflection in the norm `−2` vector
    `(1, −1)`. -/
theorem narain_root_norm : latticeNorm hyperbolicU ![1, -1] = -2 := by
  simp [latticeNorm, hyperbolicU, dotProduct, mulVec, Fin.sum_univ_succ]

theorem narain_swap_eq_reflection : hyperbolicU = reflection hyperbolicU ![1, -1] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [reflection, hyperbolicU, vecMulVec, Matrix.mul_apply, Matrix.one_apply,
      Fin.sum_univ_succ]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. GE-2 — the self-dual locus is the wall of the root            ║
-- ╚════════════════════════════════════════════════════════════════════╝

variable {K : Type*} [Field K]

/-- The bilinear form of `U ⊕ ⟨2N⟩` over a field. -/
def bN (N : K) (v w : Fin 3 → K) : K := v 0 * w 1 + v 1 * w 0 + 2 * N * v 2 * w 2

/-- `bN` polarizes `qN`. -/
theorem bN_self (N : K) (v : Fin 3 → K) : bN N v v = qN N v := by
  simp [bN, qN]; ring

/-- The root over `K`. -/
def rootK : Fin 3 → K := ![1, -1, 0]

/-- `⟨e − f, ω(τ)⟩ = −(Nτ² + 1)`. -/
theorem root_pairing_period (N τ : K) : bN N rootK (period N τ) = -(N * τ ^ 2 + 1) := by
  simp [bN, rootK, period]; ring

/-- **The self-dual locus is exactly where the root becomes orthogonal to the
    period.** -/
theorem root_orthogonal_iff_selfdual (N τ : K) :
    bN N rootK (period N τ) = 0 ↔ N * τ ^ 2 = -1 := by
  rw [root_pairing_period]
  constructor
  · intro h; linear_combination -h
  · intro h; rw [h]; ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. GE-3 — singular points of L₃ = Fricke fixed points on the h-line ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The rational map `z(h) = h / (1 + 13h + 49h²)`.
    -- Source: Cooper, "Sporadic sequences, modular forms and new series for 1/π",
    Ramanujan J. 29 (2012), level 7 parametrization; checked in-session as a
    q-series identity to finite order (see the brief). The statements below are
    about this rational map only. -/
noncomputable def zOf (h : K) : K := h / (1 + 13 * h + 49 * h ^ 2)

/-- **Fricke invariance**: `z(1/(49h)) = z(h)`. -/
theorem zOf_fricke (h : K) (hh : h ≠ 0) (hD : 1 + 13 * h + 49 * h ^ 2 ≠ 0) [NeZero (49 : K)] :
    zOf (1 / (49 * h)) = zOf h := by
  have h49 : (49 : K) ≠ 0 := NeZero.ne 49
  have hD' : 1 + 13 * (1 / (49 * h)) + 49 * (1 / (49 * h)) ^ 2 ≠ 0 := by
    have : 1 + 13 * (1 / (49 * h)) + 49 * (1 / (49 * h)) ^ 2
        = (1 + 13 * h + 49 * h ^ 2) / (49 * h ^ 2) := by field_simp; ring
    rw [this]; exact div_ne_zero hD (mul_ne_zero h49 (pow_ne_zero 2 hh))
  unfold zOf
  rw [div_eq_div_iff hD' hD]
  field_simp
  ring

/-- The fixed point `h = 1/7` maps to `z = 1/27`. -/
theorem zOf_selfdual_pos : zOf (1 / 7 : ℚ) = 1 / 27 := by norm_num [zOf]

/-- The fixed point `h = −1/7` maps to `z = −1`. -/
theorem zOf_selfdual_neg : zOf (-1 / 7 : ℚ) = -1 := by norm_num [zOf]

/-- `h = ±1/7` are exactly the fixed points of `h ↦ 1/(49h)` over `ℚ`. -/
theorem fricke_fixed_iff (h : ℚ) (hh : h ≠ 0) : 1 / (49 * h) = h ↔ h = 1 / 7 ∨ h = -1 / 7 := by
  constructor
  · intro e
    have h2 : (7 * h - 1) * (7 * h + 1) = 0 := by
      field_simp at e; linear_combination -e
    rcases mul_eq_zero.mp h2 with h' | h'
    · left; linarith
    · right; linarith
  · rintro (rfl | rfl) <;> norm_num

/-- **The discriminant identity.** With `D = 1 + 13h + 49h²`,
    `(1 − 26z − 27z²)·D² = (1 − 49h²)²` at `z = z(h)`. The left factor is the
    leading coefficient `P₂` of the s7 partner operator; the right side is a
    perfect square vanishing exactly at the Fricke fixed points `h = ±1/7`. -/
theorem s7_P2_discriminant (h : K) (hD : 1 + 13 * h + 49 * h ^ 2 ≠ 0) :
    (1 - 26 * zOf h - 27 * zOf h ^ 2) * (1 + 13 * h + 49 * h ^ 2) ^ 2
      = (1 - 49 * h ^ 2) ^ 2 := by
  have e : zOf h * (1 + 13 * h + 49 * h ^ 2) = h := div_mul_cancel₀ _ hD
  linear_combination
    (-26 * (1 + 13 * h + 49 * h ^ 2) - 27 * (zOf h * (1 + 13 * h + 49 * h ^ 2) + h)) * e

/-- The polynomial in `s7_P2_discriminant` IS the repository's `s7_P2`. -/
theorem s7_P2_eval (x : ℚ) :
    Polynomial.eval x Agora.Sequences.Partner.s7_P2 = 1 - 26 * x - 27 * x ^ 2 := by
  simp [Agora.Sequences.Partner.s7_P2]

/-- So the finite singular locus `{−1, 1/27}` of the s7 operators is the image of
    the Fricke fixed points. -/
theorem s7_singular_points_are_selfdual :
    Polynomial.eval (zOf (1 / 7 : ℚ)) Agora.Sequences.Partner.s7_P2 = 0 ∧
    Polynomial.eval (zOf (-1 / 7 : ℚ)) Agora.Sequences.Partner.s7_P2 = 0 := by
  rw [s7_P2_eval, s7_P2_eval, zOf_selfdual_pos, zOf_selfdual_neg]; norm_num

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. GE-4 — the dual-scale height, from LeanMaster's circle bound   ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Height on the imaginary axis `τ = it`: `H_N(t) = Nt² + 1/(Nt²)`. -/
noncomputable def height (N t : ℝ) : ℝ := N * t ^ 2 + (N * t ^ 2)⁻¹

/-- `H_N ≥ 2` — this IS LeanMaster's circle dual-scale bound at `R = Nt²`. -/
theorem height_ge_two (N t : ℝ) (hN : 0 < N) (ht : 0 < t) : 2 ≤ height N t :=
  DualScaleStream2.DualScale.circle_effective_scale_ge_two (N * t ^ 2) (by positivity)

/-- The height is Fricke-invariant: `H_N(1/(Nt)) = H_N(t)`. -/
theorem height_fricke (N t : ℝ) (hN : 0 < N) (ht : 0 < t) :
    height N (1 / (N * t)) = height N t := by
  unfold height
  have hN' : N ≠ 0 := hN.ne'
  have ht' : t ≠ 0 := ht.ne'
  field_simp
  ring

/-- Equality holds exactly on the self-dual locus `Nt² = 1` (i.e. `Nτ² = −1`). -/
theorem height_eq_two_iff (N t : ℝ) (hN : 0 < N) (ht : 0 < t) :
    height N t = 2 ↔ N * t ^ 2 = 1 := by
  unfold height
  have hx : 0 < N * t ^ 2 := by positivity
  set x := N * t ^ 2 with hxdef
  constructor
  · intro h
    have hx' : x ≠ 0 := hx.ne'
    have : (x - 1) ^ 2 = 0 := by
      field_simp at h; linear_combination h
    have := pow_eq_zero_iff (two_ne_zero) |>.mp this
    linarith
  · intro h; rw [h]; norm_num

end Agora.Geometry.SelfDual
