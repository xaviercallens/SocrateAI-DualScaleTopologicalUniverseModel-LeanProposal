/-
  Agora/Geometry/SymSquareForms.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE SYMMETRIC SQUARE ON BINARY QUADRATIC FORMS — `SL(2) → SO(2,1)`, in the
  Gauss presentation.

  `ModularAction.lean` realizes `Γ₀(N)⁺` inside `O(U ⊕ ⟨2N⟩)` by an explicit
  integer representation `ρ`. This file gives the same construction in its
  classical coordinates: a `2×2` matrix acts on a binary quadratic form
  `Q(x,y) = a x² + b xy + c y²` by substitution, hence on the coefficient triple
  `(a,b,c)`, preserving the discriminant `b² − 4ac` — a form of signature
  `(2,1)`. That is the exceptional isomorphism, and it is why a `3×3` INTEGER
  representation exists at all.

  WHAT IS PROVED (all uniform in the entries, over any commutative ring):

    sym2_isometry_general : sym2(M)ᵀ · G₀ · sym2(M) = (det M)² · G₀
    sym2_det              : det (sym2 M) = (det M)³
    sym2_trace            : tr (sym2 M) = (tr M)² − det M
    sym2_contravariant    : sym2 (M · M') = sym2 M' · sym2 M

  ────────────────────────────────────────────────────────────────────────────────
  TWO CORRECTIONS TO THE NAIVE EXPECTATION, both found by computing first

  1. The isometry statement needs NO determinant hypothesis. `det M = 1` gives
     `sym2_isometry` as a one-line corollary, but the identity
     `sym2(M)ᵀG₀sym2(M) = (det M)²G₀` holds for EVERY `M`. Stating it with the
     hypothesis would have been strictly weaker, and would have hidden that the
     discriminant is a relative invariant of weight 2.

  2. `sym2` is CONTRAVARIANT, not covariant: `sym2(M·M') = sym2(M')·sym2(M)`.
     This is forced by the convention — the action is by SUBSTITUTION into `Q`,
     which reverses composition. Asserting `sym2(M·M') = sym2(M)·sym2(M')` would
     have been false; it is checked here in the order that is true. (To get a
     genuine homomorphism, act by `M⁻¹`, or transpose; we keep substitution and
     record the variance.)

  ────────────────────────────────────────────────────────────────────────────────
  RELATION TO `ModularAction.rho`

  `ρ` and `sym2` are the same representation, but they act on **two genuinely
  different lattices**, and §3 below proves they are not isometric:

    `U ⊕ ⟨2N⟩`   form `2xy + 2Nz²`,  Gram determinant `−2N`   (ρ; Dolgachev's
                 transcendental lattice of an `Mₙ`-polarized K3)
    `⟨1⟩ ⊕ U(2N)` form `b² − 4Nac`,  Gram determinant `−4N²`  (sym2; the
                 discriminant lattice of `Γ₀(N)`-forms, Gauss)

  Both have signature `(2,1)`; both carry an integer symmetric-square action of
  `Γ₀(N)⁺`. They are NOT isomorphic: a change of basis multiplies the Gram
  determinant by a square, and `−4N² = −2N` forces `N = 0` or `N = 1/2`, so for
  every integer `N ≥ 1` the two determinants differ by a non-square ratio.

  **Conflating them under one name is a real error**, and it is the error this
  §3 exists to block. It was caught in cross-session review with the LeanMaster
  repository (tag v3.43.0), where a directive had merged the two lattices into a
  single claim. Neither repository's Lean files ever asserted the conflation;
  the directive did.

  ────────────────────────────────────────────────────────────────────────────────
  EPISTEMIC STATUS

  Tier A: identities of matrices over a commutative ring. The correspondence
  between `SL(2)` acting on binary quadratic forms and `SO(2,1)` is classical
  (Gauss; and it underlies Dolgachev's `O⁺(U⊕⟨2n⟩)/±1 ≅ Γ₀(n)⁺`). Nothing here
  is claimed as new mathematics; the contribution is that it is machine-checked
  and available to the rest of the development.

  NO physical claim. In particular this file does NOT assert that the
  arithmetic "freezes", "selects" or "crystallizes" a K3 surface, nor anything
  about moduli being discrete: `Γ₀(N)⁺` acts discretely on a CONTINUOUS period
  domain, and a discrete group acting on a continuous space does not make the
  space discrete. Tier C remains blocked (F5b), and VISION §1.3 applies — a
  symmetric-square relation supplies no physical coupling.

  0 sorry. Axioms: Lean's three only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Geometry.MnLattice
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic

namespace Agora.Geometry.SymSquareForms

open Matrix

variable {K : Type*} [CommRing K]

/-- The Gram matrix of the discriminant form `b² − 4ac` on coefficient triples
    `(a, b, c)`. Signature `(2,1)`. -/
def G0 : Matrix (Fin 3) (Fin 3) K := !![0, 0, -2; 0, 1, 0; -2, 0, 0]

/-- The discriminant form really is `b² − 4ac` — a non-vacuity check on `G0`. -/
theorem G0_quadratic (a b c : K) :
    (![a, b, c] ⬝ᵥ (G0.mulVec ![a, b, c])) = b ^ 2 - 4 * (a * c) := by
  simp [G0, dotProduct, mulVec, Fin.sum_univ_succ]; ring

/-- `sym2 M` : the action of `M = !![α, β; γ, δ]` on the coefficient triple
    `(a, b, c)` of `Q(x,y) = a x² + b xy + c y²`, induced by the substitution
    `(x, y) ↦ (αx + βy, γx + δy)`. -/
def sym2 (M : Matrix (Fin 2) (Fin 2) K) : Matrix (Fin 3) (Fin 3) K :=
  !![M 0 0 ^ 2,            M 0 0 * M 1 0,              M 1 0 ^ 2;
     2 * (M 0 0 * M 0 1),  M 0 0 * M 1 1 + M 0 1 * M 1 0,  2 * (M 1 0 * M 1 1);
     M 0 1 ^ 2,            M 0 1 * M 1 1,              M 1 1 ^ 2]

/-- **The discriminant is a relative invariant of weight 2.** No hypothesis on
    `M`. -/
theorem sym2_isometry_general (M : Matrix (Fin 2) (Fin 2) K) :
    (sym2 M)ᵀ * G0 * sym2 M = (M.det ^ 2) • G0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [sym2, G0, Matrix.det_fin_two, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-- **`SL(2) → SO(2,1)`, the isometry half.** -/
theorem sym2_isometry (M : Matrix (Fin 2) (Fin 2) K) (h : M.det = 1) :
    (sym2 M)ᵀ * G0 * sym2 M = G0 := by
  rw [sym2_isometry_general, h]; simp

/-- `det (sym2 M) = (det M)³` — so `det M = 1` lands in `SO`, not merely `O`. -/
theorem sym2_det (M : Matrix (Fin 2) (Fin 2) K) : (sym2 M).det = M.det ^ 3 := by
  simp [sym2, Matrix.det_fin_three, Matrix.det_fin_two]; ring

/-- **`SL(2) → SO(2,1)`, in full**: determinant one and an isometry. -/
theorem sym2_mem_SO (M : Matrix (Fin 2) (Fin 2) K) (h : M.det = 1) :
    (sym2 M).det = 1 ∧ (sym2 M)ᵀ * G0 * sym2 M = G0 :=
  ⟨by rw [sym2_det, h]; ring, sym2_isometry M h⟩

/-- `tr (sym2 M) = (tr M)² − det M`: the character of the symmetric square. -/
theorem sym2_trace (M : Matrix (Fin 2) (Fin 2) K) :
    (sym2 M).trace = M.trace ^ 2 - M.det := by
  simp [sym2, Matrix.trace_fin_three, Matrix.trace_fin_two, Matrix.det_fin_two]; ring

/-- **`sym2` is CONTRAVARIANT.** Substitution reverses composition. -/
theorem sym2_contravariant (M M' : Matrix (Fin 2) (Fin 2) K) :
    sym2 (M * M') = sym2 M' * sym2 M := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [sym2, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-- `sym2 1 = 1`. -/
theorem sym2_one : sym2 (1 : Matrix (Fin 2) (Fin 2) K) = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [sym2, Matrix.one_apply]

/-- **NEGATIVE CONTROL.** `sym2` is genuinely contravariant: for the explicit
    non-commuting pair below, `sym2 (M * M') ≠ sym2 M * sym2 M'`. So the order
    in `sym2_contravariant` is not a matter of taste. -/
theorem sym2_not_covariant :
    sym2 (!![1, 1; 0, 1] * !![1, 0; 1, 1] : Matrix (Fin 2) (Fin 2) ℤ)
      ≠ sym2 (!![1, 1; 0, 1] : Matrix (Fin 2) (Fin 2) ℤ) *
        sym2 (!![1, 0; 1, 1] : Matrix (Fin 2) (Fin 2) ℤ) := by
  intro hc
  have h := congrFun (congrFun hc 0) 1
  norm_num [sym2, Matrix.mul_apply, Fin.sum_univ_succ] at h

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE TWO LATTICES ARE NOT ISOMETRIC                             ║
-- ╚════════════════════════════════════════════════════════════════════╝

open Agora.Geometry.MnLattice

/-- The discriminant lattice of `Γ₀(N)`-forms: the Gram matrix of `b² − 4Nac`. -/
def G0N (N : ℤ) : Matrix (Fin 3) (Fin 3) ℤ := !![0, 0, -(2 * N); 0, 1, 0; -(2 * N), 0, 0]

theorem G0N_det (N : ℤ) : (G0N N).det = -(4 * N ^ 2) := by
  simp [G0N, Matrix.det_fin_three]; ring

/-- **The two lattices are distinguished by their Gram determinants**:
    `det(b² − 4Nac) = −4N²` while `det(U ⊕ ⟨2N⟩) = −2N`. -/
theorem G0N_det_ne_TN_det (N : ℤ) (hN : 1 ≤ N) : (G0N N).det ≠ (TN N).det := by
  rw [G0N_det, TN_det]
  intro h
  nlinarith [h, hN]

/-- **Hence no isometry relates them.** A change of basis `P` sends a Gram matrix
    `G` to `PᵀGP`, whose determinant is `(det P)²·det G`; an isometry has
    `det P = ±1`, so it preserves the Gram determinant exactly. Since those
    determinants differ for every `N ≥ 1`, the discriminant lattice of
    `Γ₀(N)`-forms is NOT the transcendental lattice `U ⊕ ⟨2N⟩`.

    Both carry `Γ₀(N)⁺` actions; they are different objects with different
    roles, and must not be named interchangeably. -/
theorem no_isometry_G0N_TN (N : ℤ) (hN : 1 ≤ N) (P : Matrix (Fin 3) (Fin 3) ℤ)
    (hP : P.det = 1 ∨ P.det = -1) : Pᵀ * G0N N * P ≠ TN N := by
  intro hc
  have hdet : (P.det) ^ 2 * (G0N N).det = (TN N).det := by
    rw [← hc, Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose]; ring
  have hsq : (P.det) ^ 2 = 1 := by rcases hP with h | h <;> rw [h] <;> ring
  rw [hsq, one_mul] at hdet
  exact G0N_det_ne_TN_det N hN hdet

end Agora.Geometry.SymSquareForms
