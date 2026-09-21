/-
  Agora/Geometry/ModularAction.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE FOUNDATIONAL STRUCTURE: Γ₀(N)⁺ ACTS ON `U ⊕ ⟨2N⟩` BY INTEGER MATRICES.

  `MnLattice.lean` exhibited ONE isometry of `U ⊕ ⟨2N⟩` (the swap) and showed it
  acts on the period as the Fricke involution. That was a sample of a general
  structure, formalized here:

      there is an explicit 3×3 integer representation ρ such that
        • ρ(g) is an isometry of `U ⊕ ⟨2N⟩` for every `g = [[a,b],[Nc,d]]`
          with `ad − Nbc = ±1`                                     (§1)
        • ρ(g)·ω(τ) = (Ncτ + d)² · ω(g·τ)                          (§2)
        • the Atkin–Lehner elements `W = [[Na,b],[Nc,Nd]]/√N` with
          `Nad − bc = ±1` are ALSO isometries, acting by `τ ↦ (Naτ+b)/(N(cτ+d))` (§3)
        • ρ is multiplicative: ρ(gh) = ρ(g)ρ(h)                    (§4)

  So the arithmetic of the Picard–Fuchs operator is not an analogy with modular
  forms — the modular group IS the isometry group of the lattice, acting on the
  period line, and every statement below is an integer-matrix identity.

  WHAT THIS EXPLAINS (§5, for N = 7, the s7 family):
    • the Fricke involution is ρ(W) at `(a,b,c,d) = (0,-1,1,0)` — recovering
      `MnLattice.swap` as a special case of the general representation;
    • the SECOND singular point `z = −1` comes from the conjugate Atkin–Lehner
      element `W' = [[7,4],[−14,−7]]/√7`: `ρ(W')² = 1`, and `−ρ(W')` is the
      reflection in the root `(−2,4,1)`, of norm `−2` — so BOTH singular points
      of L₂/L₃ are walls of (−2)-roots, not just the Fricke one;
    • the order-3 element `[[2,−1],[7,−3]] ∈ Γ₀(7)` satisfies `ρ(g)³ = 1` and
      fixes the vector `(14,−14,5)` of norm `−42`. Its fixed point on the period
      line is the elliptic point of order 3 of `X₀(7)`.

  ────────────────────────────────────────────────────────────────────────────────
  EPISTEMIC STATUS

  Tier A throughout: identities of integer matrices, and of rational functions
  over a field. The hypotheses (`ad − Nbc = ±1` etc.) are stated, never assumed
  silently.

  The IDENTIFICATION of this period line with the s7 family's — i.e. that the
  Hauptmodul `h = (η(7τ)/η(τ))⁴` and `z = h/(1+13h+49h²)` pull L₃ back to this
  τ — is NOT kernel-proved: it is PASS(40) exact plus literature
  (`scripts/check_selfdual_points_s7.py`, `briefs/THOUGHT_EXPERIMENTS_SELF_DUAL_2026_09_20.md`).
  Everything below is a theorem about the lattice and its period domain.

  NO physics. That `Γ₀(N)⁺ ≅ O⁺(U⊕⟨2N⟩)/±1` is Dolgachev's theorem (literature,
  not proved here): we prove the inclusion `⊇` constructively, which is the
  direction the applications need.

  0 sorry. Axioms: Lean's three only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Geometry.SelfDual

namespace Agora.Geometry.ModularAction

open Matrix DualScaleStream2.Lattice Agora.Geometry.MnLattice Agora.Geometry.SelfDual

variable {K : Type*} [CommRing K]

/-- The Gram matrix of `U ⊕ ⟨2N⟩` over an arbitrary commutative ring — the
    coefficient-generic form of `MnLattice.TN`. -/
def TNR (N : K) : Matrix (Fin 3) (Fin 3) K := !![0, 1, 0; 1, 0, 0; 0, 0, 2 * N]

/-- Over `ℤ` it is `MnLattice.TN`. -/
theorem TNR_int (N : ℤ) : TNR N = TN N := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE REPRESENTATION ρ ON Γ₀(N)                                  ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `ρ(g)` for `g = [[a, b], [Nc, d]] ∈ Γ₀(N)`, in the basis `(e, f, w)` of
    `U ⊕ ⟨2N⟩`: the symmetric square of `g` in coordinates adapted to the
    lattice. Integer entries whenever `a, b, c, d, N` are integers.
    -- Source: Dolgachev, J. Math. Sci. 81 (1996), §7 — the isomorphism
    `O⁺(U ⊕ ⟨2n⟩)/±1 ≅ Γ₀(n)⁺`. Only the constructive direction is proved here. -/
def rho (N a b c d : K) : Matrix (Fin 3) (Fin 3) K :=
  !![d ^ 2, -(N * c ^ 2), 2 * N * c * d;
     -(N * b ^ 2), a ^ 2, -(2 * N * a * b);
     b * d, -(a * c), a * d + N * b * c]

/-- **ρ(g) is an isometry of `U ⊕ ⟨2N⟩`** as soon as `(ad − Nbc)² = 1`, i.e. for
    both determinants `±1`. Uniform in `N` and in the entries. -/
theorem rho_isometry (N a b c d : K) (h : (a * d - N * b * c) ^ 2 = 1) :
    (rho N a b c d)ᵀ * TNR N * rho N a b c d = TNR N := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rho, TNR, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    (first
      | ring1
      | linear_combination h
      | linear_combination -h
      | linear_combination (2 * N) * h
      | linear_combination (-2 * N) * h)

/-- ρ is the identity at `g = 1`. -/
theorem rho_one (N : K) : rho N 1 0 0 1 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [rho, Matrix.one_apply]

/-- **ρ is a homomorphism**: `ρ(g)·ρ(h) = ρ(gh)`, with `gh` written out on the
    entries of `Γ₀(N)`. So the isometries of §1 form a group and the period
    action of §2 is a group action. -/
theorem rho_mul (N a b c d a' b' c' d' : K) :
    rho N a b c d * rho N a' b' c' d'
      = rho N (a * a' + N * b * c') (a * b' + b * d') (c * a' + d * c')
          (N * c * b' + d * d') := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rho, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-- **ρ IS THE SYMMETRIC SQUARE**: its character is that of `Sym²` of the
    standard 2-dimensional representation, `tr ρ(g) = (tr g)² − det g`.

    This is the precise sense in which the rank-3 lattice picture is the
    *same* symmetric-square construction as the operator identity
    `L₃ = P₂·Sym²(L₂)`: the monodromy of `L₂` is a rank-2 representation, that
    of `Sym²(L₂)` is its symmetric square, and `ρ` is that symmetric square
    written in integer coordinates on `U ⊕ ⟨2N⟩`. -/
theorem rho_trace (N a b c d : K) :
    (rho N a b c d).trace = (a + d) ^ 2 - (a * d - N * b * c) := by
  simp [rho, Matrix.trace_fin_three]; ring

/-- **The image lies in `SO`, not merely `O`**: `det ρ(g) = (det g)³`, so an
    element of determinant 1 maps to an isometry of determinant 1.

    Together with `rho_isometry` and `rho_mul` this is the integral form of the
    exceptional isomorphism `SL(2) → SO(2,1)`: the lattice `U ⊕ ⟨2N⟩` has
    signature `(2,1)` (`MnLattice.sigTN_eq`), and `Γ₀(N)` acts on it through
    determinant-preserving isometries. -/
theorem rho_det (N a b c d : K) :
    (rho N a b c d).det = (a * d - N * b * c) ^ 3 := by
  simp [rho, Matrix.det_fin_three]; ring

/-- Specialization: a determinant-1 element of `Γ₀(N)` gives an element of
    `SO(U ⊕ ⟨2N⟩)` — an isometry (`rho_isometry`) of determinant 1. -/
theorem rho_mem_SO (N a b c d : K) (h : a * d - N * b * c = 1) :
    (rho N a b c d).det = 1 ∧
      (rho N a b c d)ᵀ * TNR N * rho N a b c d = TNR N :=
  ⟨by rw [rho_det, h]; ring, rho_isometry N a b c d (by rw [h]; ring)⟩

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. ρ ACTS ON THE PERIOD BY MÖBIUS TRANSFORMATIONS                 ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `ω(τ) = e − Nτ²f + τw`, over an arbitrary commutative ring. -/
def periodR (N τ : K) : Fin 3 → K := ![1, -(N * τ ^ 2), τ]

/-- **The period transforms with the weight-2 automorphy factor.** In cleared
    (projective) form, so that it is a polynomial identity valid over ANY
    commutative ring and needs no determinant hypothesis and no invertibility:

      `ρ(g)·ω(τ) = ((Ncτ+d)², −N(aτ+b)², (aτ+b)(Ncτ+d))`,

    which is `(Ncτ+d)²·ω((aτ+b)/(Ncτ+d))` wherever the denominator is a unit
    (see `rho_mulVec_period_field`). So ρ covers the Möbius action on the period
    line with automorphy factor `(Ncτ+d)²`. -/
theorem rho_mulVec_period (N a b c d τ : K) :
    (rho N a b c d) *ᵥ periodR N τ
      = ![(N * c * τ + d) ^ 2, -(N * (a * τ + b) ^ 2), (a * τ + b) * (N * c * τ + d)] := by
  ext i
  fin_cases i <;>
    simp [rho, periodR, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> ring

section Field
variable {F : Type*} [Field F]

/-- The same over a field, in the familiar form `ρ(g)·ω(τ) = (Ncτ+d)²·ω(g·τ)`. -/
theorem rho_mulVec_period_field (N a b c d τ : F) (hden : N * c * τ + d ≠ 0) :
    (rho N a b c d) *ᵥ periodR N τ
      = (N * c * τ + d) ^ 2 • periodR N ((a * τ + b) / (N * c * τ + d)) := by
  have h2 : N * τ * c + d ≠ 0 := fun hc => hden (by linear_combination hc)
  rw [rho_mulVec_period]
  ext i
  fin_cases i <;> simp [periodR] <;> field_simp <;> ring

end Field

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE ATKIN–LEHNER ELEMENTS                                      ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `ρ(W)` for the Atkin–Lehner element `W = [[Na, b], [Nc, Nd]]/√N`. The `√N`
    cancels in the symmetric square, so this is again an INTEGER matrix — which
    is why Atkin–Lehner involutions are lattice isometries at all. -/
def rhoAL (N a b c d : K) : Matrix (Fin 3) (Fin 3) K :=
  !![N * d ^ 2, -(c ^ 2), 2 * N * c * d;
     -(b ^ 2), N * a ^ 2, -(2 * N * a * b);
     b * d, -(a * c), N * a * d + b * c]

/-- **Atkin–Lehner elements are isometries of `U ⊕ ⟨2N⟩`** when `(Nad − bc)² = 1`. -/
theorem rhoAL_isometry (N a b c d : K) (h : (N * a * d - b * c) ^ 2 = 1) :
    (rhoAL N a b c d)ᵀ * TNR N * rhoAL N a b c d = TNR N := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rhoAL, TNR, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    (first
      | ring1
      | linear_combination h
      | linear_combination -h
      | linear_combination (2 * N) * h
      | linear_combination (-2 * N) * h)

/-- The Fricke involution is the Atkin–Lehner element at `(a,b,c,d) = (0,−1,1,0)`,
    and it is exactly `−swap`. So `MnLattice.swap` is a special case of this
    representation, and `SelfDual`'s Fricke computation is the `N`-generic
    statement below specialized. -/
theorem rhoAL_fricke (N : K) : rhoAL N 0 (-1) 1 0 = !![0, -1, 0; -1, 0, 0; 0, 0, -1] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [rhoAL]

/-- Over `ℤ`, that is exactly `−MnLattice.swap`: the Fricke involution studied in
    `MnLattice`/`SelfDual` is the specialization of `rhoAL` at `(0,−1,1,0)`. The
    sign is invisible on the period line (it rescales the isotropic vector). -/
theorem rhoAL_fricke_eq_neg_swap (N : ℤ) : rhoAL N 0 (-1) 1 0 = -swap := by
  rw [rhoAL_fricke]
  ext i j; fin_cases i <;> fin_cases j <;> simp [swap]

/-- The Atkin–Lehner action on the period, in cleared form — again an identity
    over any commutative ring:
    `ρ(W)·ω(τ) = (N(cτ+d)², −(Naτ+b)², (Naτ+b)(cτ+d))`. -/
theorem rhoAL_mulVec_period (N a b c d τ : K) :
    (rhoAL N a b c d) *ᵥ periodR N τ
      = ![N * (c * τ + d) ^ 2, -((N * a * τ + b) ^ 2), (N * a * τ + b) * (c * τ + d)] := by
  ext i
  fin_cases i <;>
    simp [rhoAL, periodR, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> ring

/-- The Atkin–Lehner elements are also determinant-cubes, hence also land in
    `SO(2,1)` when `Nad − bc = 1`. So the WHOLE of `Γ₀(N)⁺`, Fricke included,
    acts by orientation-preserving isometries of `U ⊕ ⟨2N⟩`. -/
theorem rhoAL_det (N a b c d : K) :
    (rhoAL N a b c d).det = (N * a * d - b * c) ^ 3 := by
  simp [rhoAL, Matrix.det_fin_three]; ring

section Field2
variable {F : Type*} [Field F]

/-- Over a field: `τ ↦ (Naτ + b)/(N(cτ + d))`. At `(a,b,c,d) = (0,−1,1,0)` this
    is `τ ↦ −1/(Nτ)`, the Fricke involution — recovering `MnLattice.swap_is_fricke`
    as the specialization of a representation defined for all of Γ₀(N)⁺. -/
theorem rhoAL_mulVec_period_field (N a b c d τ : F) (hN : N ≠ 0) (hden : c * τ + d ≠ 0) :
    (rhoAL N a b c d) *ᵥ periodR N τ
      = (N * (c * τ + d) ^ 2) • periodR N ((N * a * τ + b) / (N * (c * τ + d))) := by
  have h2 : τ * c + d ≠ 0 := fun hc => hden (by linear_combination hc)
  have h3 : c * τ + d ≠ 0 := hden
  rw [rhoAL_mulVec_period]
  ext i
  fin_cases i <;> simp [periodR] <;> field_simp <;> ring

end Field2

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §5. N = 7: BOTH SINGULAR POINTS ARE WALLS OF (−2)-ROOTS            ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `ρ(W')` for the conjugate Atkin–Lehner element `W' = [[7,4],[−14,−7]]/√7`,
    i.e. `(a,b,c,d) = (1,4,−2,−1)` at `N = 7`. -/
def W7conj : Gram 3 := rhoAL (7:ℤ) 1 4 (-2) (-1)

theorem W7conj_entries : W7conj = !![7, -4, 28; -16, 7, -56; -4, 2, -15] := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [W7conj, rhoAL]

/-- It is an involution. -/
theorem W7conj_involution : W7conj * W7conj = 1 := by
  rw [W7conj_entries]
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply, Matrix.one_apply, Fin.sum_univ_succ]

/-- The root of the second singular point. -/
def root2 : Fin 3 → ℤ := ![-2, 4, 1]

/-- It is a `(−2)`-root of `U ⊕ ⟨14⟩`. -/
theorem root2_norm : latticeNorm T7 root2 = -2 := by
  simp [latticeNorm, T7, TN, root2, dotProduct, mulVec, Fin.sum_univ_succ]

/-- **`−ρ(W')` is the Weyl reflection in that root.** So the second singular
    point `z = −1` of the s7 operators is the wall of a `(−2)`-root, exactly as
    `z = 1/27` is the wall of `e − f` (`SelfDual.swap_eq_reflection`). -/
theorem W7conj_eq_neg_reflection : -W7conj = reflection T7 root2 := by
  rw [W7conj_entries]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [reflection, T7, TN, root2, vecMulVec, Matrix.mul_apply, Matrix.one_apply,
      Fin.sum_univ_succ]

/-- The order-3 element `g = [[2,−1],[7,−3]] ∈ Γ₀(7)`, `det g = 1`. -/
def g3 : Gram 3 := rho (7:ℤ) 2 (-1) 1 (-3)

theorem g3_det_one : (2 : ℤ) * (-3) - 7 * (-1) * 1 = 1 := by norm_num

/-- `ρ(g)³ = 1`: an order-3 isometry of `U ⊕ ⟨14⟩`. -/
theorem g3_order_three : g3 * g3 * g3 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g3, rho, Matrix.mul_apply, Matrix.one_apply, Fin.sum_univ_succ]

/-- Its fixed vector `(14, −14, 5)` has norm `−42 = −6·7`. The corresponding
    point of the period line is the order-3 elliptic point of `X₀(7)`. -/
theorem g3_fixes : g3 *ᵥ ![14, -14, 5] = ![14, -14, 5] := by
  ext i
  fin_cases i <;> simp [g3, rho, Matrix.mulVec, dotProduct, Fin.sum_univ_succ]

theorem g3_fixed_norm : latticeNorm T7 ![14, -14, 5] = -42 := by
  simp [latticeNorm, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §7. WHAT ρ_AL DOES ON THE DISCRIMINANT GROUP                       ║
-- ║  Requested by Stream 2 (brief 2026-09-21, direction 2): the         ║
-- ║  "missing half of ρ's story".                                       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **The image of `w` under `ρ_AL`** — the third column, written out.

    `T_N = U ⊕ ⟨2N⟩` has `T_N^∨ = ℤe ⊕ ℤf ⊕ (1/2N)ℤw`, so the discriminant group
    `T_N^∨/T_N` is cyclic of order `2N`, generated by `w/2N`. The two `e`, `f`
    components below are visibly divisible by `2N`; that is **why** the action
    descends to the discriminant group at all, and it is the part that is easy
    to assume rather than check. -/
theorem rhoAL_w_image (N a b c d : K) :
    (rhoAL N a b c d) *ᵥ ![0, 0, 1]
      = ![2 * N * (c * d), -(2 * N * (a * b)), N * a * d + b * c] := by
  ext i
  fin_cases i <;> simp [rhoAL, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> ring

/-- **The Atkin–Lehner multiplier.** On `T_N^∨/T_N ≅ ℤ/2N`, generated by `w/2N`,
    `ρ_AL` acts as multiplication by `m = N·a·d + b·c`; under the normalization
    `N·a·d − b·c = 1` this is `m = 2·N·a·d − 1`.

    -- Source: requested by Stream 2, brief
    `briefs/STREAM2_TO_STREAMS1_3_LEANMASTER_RESULTS_AND_DIRECTIONS_2026_09_21.md`
    §2 direction 2, where it was derived symbolically and swept to `PASS(30)`.
    ⚠️ **Scope.** Stream 2 states the rule for a general Hall divisor `Q`, with
    `m ≡ −1 mod 2Q` and `m ≡ +1 mod 2N/Q`. What is proved here is the case their
    `Q = N` — the family this file's `rhoAL` parameterizes, which is the Fricke
    coset. The general-`Q` statement needs a parameterization this file does not
    have, and is NOT proved here. -/
theorem rhoAL_disc_multiplier (N a b c d : K) (h : N * a * d - b * c = 1) :
    N * a * d + b * c = 2 * (N * a * d) - 1 := by linear_combination -h

/-- Over `ℤ`: the multiplier is `≡ −1 mod 2N`, which is the `Q = N` case of
    Stream 2's congruence. Upgrades their `PASS(30)` sweep to every `N`. -/
theorem rhoAL_disc_multiplier_congr (N a b c d : ℤ) (h : N * a * d - b * c = 1) :
    (2 * N) ∣ (N * a * d + b * c + 1) := by
  refine ⟨a * d, ?_⟩; linear_combination -h

/-- The Fricke involution acts as `−1` on the discriminant group: `m = −1`. -/
theorem rhoAL_fricke_multiplier (N : K) :
    N * 0 * 0 + (-1) * 1 = -1 := by ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §8. ELLIPTIC ⇒ CM, AND THE THREE s7 STABILIZERS                    ║
-- ║  Stream 2 brief 2026-09-21, direction 3.                            ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **A Möbius fixed point satisfies an integer quadratic.** If `τ` is fixed by
    `![![α, β], ![γ, δ]]` acting as `τ ↦ (ατ+β)/(γτ+δ)`, then
    `γτ² + (δ−α)τ − β = 0`. With integer `α, β, γ, δ` and `γ ≠ 0` this is an
    integral quadratic equation for `τ`, which is what "the fixed point is a CM
    point" means. Stated over any commutative ring, with the fixed-point
    condition in cleared form so no division or nonvanishing hypothesis is
    needed.

    -- Source: Stream 2 brief
    `briefs/STREAM2_TO_STREAMS1_3_LEANMASTER_RESULTS_AND_DIRECTIONS_2026_09_21.md`
    §2 direction 3 ("elliptic ⇒ CM, as the one-line lemma it is"). Their R4
    establishes that the elliptic points of `X₀(n)⁺` are CM points; this is the
    algebraic half of that, and only that half.
    ⚠️ It does **not** prove the fixed point lies in the upper half-plane, that
    the quadratic is irreducible, or that its discriminant is negative — each of
    which the phrase "CM point" also carries. -/
theorem fixed_point_integer_quadratic (α β γ δ τ : K)
    (hfix : α * τ + β = τ * (γ * τ + δ)) :
    γ * τ ^ 2 + (δ - α) * τ - β = 0 := by linear_combination -hfix

/-- The three s7 stabilizers named by Stream 2, with their orders. In `PSL₂` a
    scalar matrix is the identity, so `M² = −7·I` means order 2. -/
theorem s7_stab_a_sq : (!![0, 1; -7, 0] : Matrix (Fin 2) (Fin 2) ℤ) * !![0, 1; -7, 0]
    = !![-7, 0; 0, -7] := by decide

theorem s7_stab_b_sq : (!![7, -4; 14, -7] : Matrix (Fin 2) (Fin 2) ℤ) * !![7, -4; 14, -7]
    = !![-7, 0; 0, -7] := by decide

/-- The order-3 stabilizer. `det = 1` and `trace = −1`, so Cayley–Hamilton gives
    `M² + M + I = 0` and hence `M³ = I` on the nose — not merely projectively. -/
theorem s7_stab_c_cube : (!![2, 1; -7, -3] : Matrix (Fin 2) (Fin 2) ℤ) * !![2, 1; -7, -3]
    * !![2, 1; -7, -3] = 1 := by decide

theorem s7_stab_c_charpoly : (!![2, 1; -7, -3] : Matrix (Fin 2) (Fin 2) ℤ).det = 1
    ∧ (!![2, 1; -7, -3] : Matrix (Fin 2) (Fin 2) ℤ).trace = -1 := by
  constructor <;> simp [Matrix.det_fin_two, Matrix.trace_fin_two]

/-- **NEGATIVE CONTROL.** The order-3 stabilizer is not order 2: its square is
    not a scalar, so the orders above distinguish the three points rather than
    being an artefact of the encoding. -/
theorem s7_stab_c_sq_not_scalar :
    (!![2, 1; -7, -3] : Matrix (Fin 2) (Fin 2) ℤ) * !![2, 1; -7, -3] ≠ !![-7, 0; 0, -7] := by
  decide

/-- **NEGATIVE CONTROL.** The multiplier is not identically `−1`: at
    `N = 7, a = d = 1, b = c = 2` (where `N·a·d − b·c = 3 ≠ 1`, so the
    normalization fails) it is `11`. So `rhoAL_disc_multiplier` says something
    about the hypothesis, not about `rhoAL` alone. -/
theorem rhoAL_disc_multiplier_not_constant :
    (7 : ℤ) * 1 * 1 + 2 * 2 = 11 := by norm_num

/-- **NEGATIVE CONTROL.** The determinant hypothesis in `rho_isometry` is
    load-bearing: at `(a,b,c,d) = (1,0,0,2)`, `N = 7`, where `ad − Nbc = 2`, the
    matrix `ρ(g)` is NOT an isometry. So the theorem is not vacuously true of
    every parameter choice. -/
theorem rho_not_isometry_of_det_two :
    (rho (7:ℤ) 1 0 0 2)ᵀ * TNR (7:ℤ) * rho (7:ℤ) 1 0 0 2 ≠ TNR (7:ℤ) := by
  intro hc
  have := congrFun (congrFun hc 0) 1
  simp [rho, TNR, Matrix.mul_apply, Fin.sum_univ_succ] at this

end Agora.Geometry.ModularAction
