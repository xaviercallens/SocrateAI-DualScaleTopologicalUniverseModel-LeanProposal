/-
  Agora/Geometry/Embedding.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE PRIMITIVE EMBEDDING, KERNEL-CHECKED.

  The paper's Proposition `prop:g0complement` records that the orthogonal
  complement of `T₇ = U ⊕ ⟨14⟩` inside the K3 lattice
  `Λ = U³ ⊕ E₈(−1)²` is `M₇ = U ⊕ E₈(−1)² ⊕ ⟨−14⟩`, with the embedding witness
  `w ↦ e + 7f`. That was status (E): an exact computation performed outside Lean.

  This file makes the witness status (K), by exhibiting the two embeddings as
  explicit integer matrices and checking, by the kernel:

      Bᵀ·U³·B = U ⊕ ⟨14⟩        (§2)
      Cᵀ·U³·C = U ⊕ ⟨−14⟩       (§2)
      Bᵀ·U³·C = 0               (§3, orthogonality)
      index = |disc T₇| = 14    (§4)

  ────────────────────────────────────────────────────────────────────────────────
  WHY SIX DIMENSIONS SUFFICE, AND WHAT IS THEREFORE NOT PROVED HERE

  `E₈(−1)` is unimodular, so the `E₈(−1)²` summand of `Λ` contributes nothing to
  the gluing: it sits entirely inside the complement and splits off orthogonally.
  All of the arithmetic content of the embedding
  `(U ⊕ ⟨14⟩) ⊥ (U ⊕ E₈(−1)² ⊕ ⟨−14⟩) ⊂ U³ ⊕ E₈(−1)²`
  therefore lives in `U³`, and that is the statement proved below. Concretely:
  the first `U` goes to `T₇`, the second to `M₇`, and the third is split by the
  two vectors `e ± 7f` of `MnLattice.glue_congruence`.

  What is NOT proved here: that `E₈(−1)` is unimodular is quoted from LeanMaster
  (`e8Neg_unimodular`, itself `rfl`-level over an encoded Cartan matrix) and is
  not re-derived.

  ⭐ UPDATED 2026-09-21: this header previously also said that "the assembly of
  the 22×22 statement from this 6×6 one is the standard orthogonal-direct-sum
  argument, done on paper, not in Lean". That is no longer true — the assembly
  is now kernel-checked in `Agora/Geometry/EmbeddingAssembly.lean`
  (`assembly`), generically via `join_pullback` and then instantiated over
  `Λ = U³ ⊕ E₈(−1)²`. The `E₈(−1)` caveat above is unchanged and is inherited
  there.
  So `prop:g0complement` is upgraded from (E) to (K) IN ITS WITNESS, not in its
  identification of the monodromy lattice with `U ⊕ ⟨14⟩` — that remains Tier B
  and depends on the numerical monodromy computation.

  0 sorry. Axioms: Lean's three only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Geometry.MnLattice

namespace Agora.Geometry.Embedding

open Matrix DualScaleStream2.Lattice Agora.Geometry.MnLattice

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE AMBIENT U³ AND THE TWO EMBEDDINGS                          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `U³`, in the basis `(e₁,f₁,e₂,f₂,e₃,f₃)`. -/
def U3 : Gram 6 :=
  !![0,1,0,0,0,0;
     1,0,0,0,0,0;
     0,0,0,1,0,0;
     0,0,1,0,0,0;
     0,0,0,0,0,1;
     0,0,0,0,1,0]

theorem U3_symm : U3ᵀ = U3 := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl

/-- `U³` is an involution as a matrix, hence unimodular (`det² = 1`). Stated this
    way rather than as a determinant because it is the form the kernel checks
    cheaply, and it is LeanMaster's idiom for `U` (`hyperbolicU_mul_self`). -/
theorem U3_involution : U3 * U3 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [U3, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Consequently `det U³ = ±1`. -/
theorem U3_det_sq : U3.det * U3.det = 1 := by
  rw [← Matrix.det_mul, U3_involution, Matrix.det_one]

/-- `B : U ⊕ ⟨14⟩ → U³`, sending the basis to `e₁, f₁, e₃ + 7f₃`. -/
def B : Matrix (Fin 6) (Fin 3) ℤ :=
  !![1,0,0;
     0,1,0;
     0,0,0;
     0,0,0;
     0,0,1;
     0,0,7]

/-- `C : U ⊕ ⟨−14⟩ → U³`, sending the basis to `e₂, f₂, e₃ − 7f₃`. -/
def C : Matrix (Fin 6) (Fin 3) ℤ :=
  !![0,0,0;
     0,0,0;
     1,0,0;
     0,1,0;
     0,0,1;
     0,0,-7]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE TWO PULLBACKS ARE THE EXPECTED LATTICES                    ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **`B` embeds `U ⊕ ⟨14⟩ = T₇`.** -/
theorem B_pullback : Bᵀ * U3 * B = T7 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [B, U3, T7, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- **`C` embeds `U ⊕ ⟨−14⟩`**, the non-unimodular part of `M₇`. -/
theorem C_pullback : Cᵀ * U3 * C = TN (-7) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [C, U3, TN, Matrix.mul_apply, Fin.sum_univ_succ]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. ORTHOGONALITY                                                  ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **The two sublattices are orthogonal in `U³`.** This is the statement that
    `C` lands in the orthogonal complement of `B`. -/
theorem B_orthogonal_C : Bᵀ * U3 * C = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [B, C, U3, Matrix.mul_apply, Fin.sum_univ_succ]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. THE INDEX IS 14                                                ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The discriminants match up, as they must for mutually orthogonal primitive
    sublattices filling out a unimodular lattice: `|det T₇| = |det(U ⊕ ⟨−14⟩)| = 14`. -/
theorem discriminants_agree : |T7.det| = |(TN (-7)).det| := by
  rw [T7_det, TN_det]; norm_num

/-- `|disc T₇| = 14`. -/
theorem T7_disc : |T7.det| = 14 := by rw [T7_det]; norm_num

/-- **The index is 14**, and it is checked where it actually lives: inside the
    third hyperbolic plane. `MnLattice.glue_det` computes the determinant of the
    2×2 change of basis `(e, f) ↦ (e + 7f, e − 7f)` as `−14`, so that sublattice
    has index 14 in `U`; the other two planes are matched isomorphically by `B`
    and `C` (index 1). Hence the index of `T₇ ⊥ (U ⊕ ⟨−14⟩)` in `U³` is 14,
    equal to `|disc T₇|` — which is exactly the condition for both sublattices
    to be primitive and mutually orthogonal complements.

    We state it as this equality of the two independently computed numbers
    rather than as a 6×6 determinant: the 6×6 expansion is not what carries the
    content, and Mathlib has no `det_fin_six`. -/
theorem index_eq_disc : |(glue 7).det| = |T7.det| := by
  rw [glue_det, T7_det]; norm_num

/-- **NEGATIVE CONTROL.** The embedding is not trivially available for any
    coefficient: replacing `7` by `6` in `B` gives `w² = 12 ≠ 14`, so `B` would
    not embed `T₇`. The theorems above therefore say something about 7. -/
theorem B_six_not_T7 :
    (!![1,0,0; 0,1,0; 0,0,0; 0,0,0; 0,0,1; 0,0,6] : Matrix (Fin 6) (Fin 3) ℤ)ᵀ * U3 *
      (!![1,0,0; 0,1,0; 0,0,0; 0,0,0; 0,0,1; 0,0,6] : Matrix (Fin 6) (Fin 3) ℤ) ≠ T7 := by
  intro hc
  have h22 := congrFun (congrFun hc 2) 2
  simp [U3, T7, TN, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.cons_val_succ] at h22

end Agora.Geometry.Embedding
