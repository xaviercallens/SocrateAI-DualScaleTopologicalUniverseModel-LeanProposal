/-
  Agora/Geometry/ReadingS.lean
  ════════════════════════════════════════════════════════════════════════════

  THE LATTICE OF `E × E'` FOR A CYCLIC `n`-ISOGENY ("Reading S" lattice), kernel-checked.

  ⚠️ **Disclosure.** This file was written by the Stream 2 session (Claude, K3-DarkMatter)
  on T0's instruction of 2026-10-10. It is NOT independently attested: the producer and
  the verifier are the same session, and the five release gates recorded in the pull
  request were run by that producer. Treat the kernel check as certifying the statements
  below and nothing more until a second party has re-run the gates.

  WHAT IS STATED (all for an arbitrary integer `n`, no hypothesis on `n`):

  Coordinates on `∧²ℤ⁴ = ℤ⁶` are indexed `(12, 13, 14, 23, 24, 34)` ↦ `0 … 5`. The pairing
  is the coefficient of `e₁∧e₂∧e₃∧e₄` in `u ∧ w`:
      `⟨u,w⟩ = u₁₂w₃₄ + u₃₄w₁₂ − u₁₃w₂₄ − u₂₄w₁₃ + u₁₄w₂₃ + u₂₃w₁₄`.
  The three classes are `A = e₃₄`, `B = e₁₂` and `Γ = e₁₂ + n e₁₄ − e₂₃ + n e₃₄`, the graph
  of the isogeny with lattice matrix `diag(1, n)`.

    (1) `NS = ⟨A, B, Γ⟩` has Gram `[[0,1,1],[1,0,n],[1,n,0]]` (determinant `2n`) and is
        isometric, by an explicit unimodular change of basis, to `U ⊕ ⟨−2n⟩`.
    (2) `NS` is SATURATED: if `k • v ∈ NS` with `k ≠ 0` then `v ∈ NS`.
    (3) The orthogonal complement `NS^⊥` — as a SET, an if-and-only-if — equals the
        integral span of `b₁ = e₁₃`, `b₂ = e₂₄`, `b₃ = e₂₃ + n e₁₄`, and these three
        are linearly independent over `ℤ`.
    (4) The Gram of `(b₁, b₂, b₃)` is `[[0,−1,0],[−1,0,0],[0,0,2n]]`, and the basis
        `(b₁, −b₂, b₃)` has Gram exactly `MnLattice.TN n = U ⊕ ⟨2n⟩`, by a change of
        basis of determinant `−1`.

  WHAT IS NOT STATED (and must not be read into the names):
    * that `E` and `E'` have no complex multiplication (so that `NS(E×E')` has rank 3):
      that is a hypothesis of the geometric reading, not part of this lattice statement;
    * the Shioda–Inose isometry `T(X) ≅ T(E×E')` for an Inose surface `X` (Tier L,
      Kumar–Kuwata Remark 2.2), and any identification of `X` with a family member;
    * anything about a physical compactification (Tier C; VISION §1.3).

  Companion computation (exact arithmetic, Stream 2): `K3xT2_READING_S.json`,
  `K3xT2_READING_S_LEVEL_SWEEP.json`. This file is the kernel statement of the same
  lattice facts, uniformly in `n` (the Python checker is run at n = 7, 10 and 1…24).

  0 sorry. Axioms: Lean's three only.
  ════════════════════════════════════════════════════════════════════════════
-/

import Agora.Geometry.MnLattice
import Mathlib.Tactic

namespace Agora.Geometry.ReadingS

open Matrix

/-- The pairing on `∧²ℤ⁴ = ℤ⁶` in coordinates `(12,13,14,23,24,34)` ↦ `0…5`:
    `⟨u,w⟩ = u₁₂w₃₄ + u₃₄w₁₂ − u₁₃w₂₄ − u₂₄w₁₃ + u₁₄w₂₃ + u₂₃w₁₄`.
    -- Source: `e₁₂∧e₃₄ = +e₁₂₃₄`, `e₁₃∧e₂₄ = −e₁₂₃₄`, `e₁₄∧e₂₃ = +e₁₂₃₄`. -/
def pair (u w : Fin 6 → ℤ) : ℤ :=
  u 0 * w 5 + u 5 * w 0 - u 1 * w 4 - u 4 * w 1 + u 2 * w 3 + u 3 * w 2

/-- `A = e₃₄`. -/
def vecA : Fin 6 → ℤ := ![0, 0, 0, 0, 0, 1]
/-- `B = e₁₂`. -/
def vecB : Fin 6 → ℤ := ![1, 0, 0, 0, 0, 0]
/-- `Γ = e₁₂ + n e₁₄ − e₂₃ + n e₃₄`: the graph of the isogeny with lattice matrix `diag(1,n)`,
    i.e. `(e₁+e₃) ∧ (e₂ + n e₄)`. -/
def vecG (n : ℤ) : Fin 6 → ℤ := ![1, 0, n, -1, 0, n]

/-- The three classes `(A, B, Γ)` spanning `NS`. -/
def ns (n : ℤ) : Fin 3 → (Fin 6 → ℤ) := ![vecA, vecB, vecG n]

/-- The candidate basis `b₁ = e₁₃`, `b₂ = e₂₄`, `b₃ = e₂₃ + n e₁₄` of `NS^⊥`. -/
def comp (n : ℤ) : Fin 3 → (Fin 6 → ℤ) :=
  ![![0, 1, 0, 0, 0, 0], ![0, 0, 0, 0, 1, 0], ![0, 0, n, 1, 0, 0]]

theorem pair_symm (u w : Fin 6 → ℤ) : pair u w = pair w u := by
  simp [pair]; ring

/-- Gram matrix of a triple of vectors under `pair`. -/
def gram3 (v : Fin 3 → (Fin 6 → ℤ)) : Matrix (Fin 3) (Fin 3) ℤ :=
  Matrix.of fun i j => pair (v i) (v j)

-- ╔══════════════════════════════════════════════════════════════╗
-- ║  (1) NS: Gram, and the isometry to U ⊕ ⟨−2n⟩                   ║
-- ╚══════════════════════════════════════════════════════════════╝

/-- Gram of `(A, B, Γ)` under the pairing of `∧²ℤ⁴`: `[[0,1,1],[1,0,n],[1,n,0]]`. -/
theorem readingS_NS_gram (n : ℤ) :
    gram3 (ns n) = !![0, 1, 1; 1, 0, n; 1, n, 0] := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [gram3, ns, pair, vecA, vecB, vecG]

/-- Determinant of the `NS` Gram is `2n`. -/
theorem readingS_NS_det (n : ℤ) : (gram3 (ns n)).det = 2 * n := by
  rw [readingS_NS_gram]; simp [det_fin_three]; ring

/-- The unimodular change of basis `(A, B, Γ) ↦ (A, B, Γ − nA − B)`. -/
def csNS (n : ℤ) : Matrix (Fin 3) (Fin 3) ℤ := !![1, 0, -n; 0, 1, -1; 0, 0, 1]

theorem csNS_det (n : ℤ) : (csNS n).det = 1 := by
  simp [csNS, det_fin_three]

/-- **`NS ≅ U ⊕ ⟨−2n⟩`**, by an explicit integral basis change of determinant `1`:
    `Cᵀ · Gram(A,B,Γ) · C = [[0,1,0],[1,0,0],[0,0,−2n]]`. For `n > 0` this is
    signature `(1,2)`. -/
theorem readingS_NS_isometry_U_plus_neg2n (n : ℤ) :
    (csNS n)ᵀ * !![0, 1, 1; 1, 0, n; 1, n, 0] * csNS n = !![0, 1, 0; 1, 0, 0; 0, 0, -(2 * n)] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [csNS, Matrix.mul_apply, Fin.sum_univ_succ, transpose_apply]; ring

-- ╔══════════════════════════════════════════════════════════════╗
-- ║  (2) NS is saturated in ℤ⁶                                      ║
-- ╚══════════════════════════════════════════════════════════════╝

/-- **`NS` is saturated.** If a nonzero integer multiple of `v` lies in the `ℤ`-span of
    `(A, B, Γ)` then `v` itself does: the quotient `ℤ⁶ / NS` is torsion-free. -/
theorem readingS_NS_saturated (n : ℤ) (k : ℤ) (hk : k ≠ 0) (v : Fin 6 → ℤ)
    (h : ∃ a b c : ℤ, k • v = a • vecA + b • vecB + c • vecG n) :
    ∃ a b c : ℤ, v = a • vecA + b • vecB + c • vecG n := by
  obtain ⟨a, b, c, h⟩ := h
  have h0 := congrFun h 0
  have h1 := congrFun h 1
  have h2 := congrFun h 2
  have h3 := congrFun h 3
  have h4 := congrFun h 4
  have h5 := congrFun h 5
  simp [vecA, vecB, vecG] at h0 h1 h2 h3 h4 h5
  have e1 : v 1 = 0 := by
    have : k * v 1 = 0 := by simpa using h1
    exact (mul_eq_zero.mp this).resolve_left hk
  have e4 : v 4 = 0 := by
    have : k * v 4 = 0 := by simpa using h4
    exact (mul_eq_zero.mp this).resolve_left hk
  have hc : c = -(k * v 3) := by linarith
  have e2 : v 2 = -(v 3) * n := by
    have : k * v 2 = k * (-(v 3) * n) := by rw [h2, hc]; ring
    exact mul_left_cancel₀ hk this
  refine ⟨v 5 + v 3 * n, v 0 + v 3, -(v 3), ?_⟩
  funext i
  fin_cases i <;> simp [vecA, vecB, vecG] <;> linarith

-- ╔══════════════════════════════════════════════════════════════╗
-- ║  (3) The orthogonal complement, as a set                        ║
-- ╚══════════════════════════════════════════════════════════════╝

/-- **The orthogonal complement of `NS`, as a SET.** An integer vector is orthogonal to
    all of `A`, `B`, `Γ` if and only if it lies in the integral span of `b₁ = e₁₃`,
    `b₂ = e₂₄`, `b₃ = e₂₃ + n e₁₄`. (An iff on the full set, not two orthogonal vectors.)

    ⚠️ **Disclosure.** Written by the Stream 2 session on T0's instruction; not
    independently attested. The statement is about the lattice `∧²ℤ⁴` with its
    pairing; it assumes nothing about elliptic curves (no-CM is not part of it). -/
theorem readingS_complement_eq_span (n : ℤ) :
    {v : Fin 6 → ℤ | pair v vecA = 0 ∧ pair v vecB = 0 ∧ pair v (vecG n) = 0} =
      {v : Fin 6 → ℤ | ∃ a b c : ℤ,
        v = a • comp n 0 + b • comp n 1 + c • comp n 2} := by
  ext v
  constructor
  · rintro ⟨hA, hB, hG⟩
    simp [pair, vecA, vecB, vecG] at hA hB hG
    rw [hA, hB] at hG
    have e2 : v 2 = v 3 * n := by linarith
    refine ⟨v 1, v 4, v 3, ?_⟩
    funext i
    fin_cases i <;> simp [comp, e2, hA, hB]
  · rintro ⟨a, b, c, rfl⟩
    simp [pair, comp, vecA, vecB, vecG]

/-- The three vectors `(b₁, b₂, b₃)` are linearly independent over `ℤ`, so together with
    `readingS_complement_eq_span` they form a `ℤ`-basis of `NS^⊥`. -/
theorem readingS_complement_basis_independent (n : ℤ) (a b c : ℤ)
    (h : a • comp n 0 + b • comp n 1 + c • comp n 2 = 0) : a = 0 ∧ b = 0 ∧ c = 0 := by
  have h1 := congrFun h 1
  have h3 := congrFun h 3
  have h4 := congrFun h 4
  simp [comp] at h1 h3 h4
  exact ⟨h1, h4, h3⟩

-- ╔══════════════════════════════════════════════════════════════╗
-- ║  (4) The complement's Gram and its isometry to U ⊕ ⟨2n⟩        ║
-- ╚══════════════════════════════════════════════════════════════╝

/-- Gram of `(b₁, b₂, b₃)`: `[[0,−1,0],[−1,0,0],[0,0,2n]]`. -/
theorem readingS_complement_gram (n : ℤ) :
    gram3 (comp n) = !![0, -1, 0; -1, 0, 0; 0, 0, 2 * n] := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [gram3, comp, pair]; ring

/-- The change of basis `(b₁, b₂, b₃) ↦ (b₁, −b₂, b₃)`. -/
def csComp : Matrix (Fin 3) (Fin 3) ℤ := !![1, 0, 0; 0, -1, 0; 0, 0, 1]

theorem csComp_det : csComp.det = -1 := by
  simp [csComp, det_fin_three]

/-- **`NS^⊥ ≅ U ⊕ ⟨2n⟩`**: in the basis `(b₁, −b₂, b₃)` the Gram of the orthogonal complement
    is exactly `Agora.Geometry.MnLattice.TN n`, the Gram `[[0,1,0],[1,0,0],[0,0,2n]]` used
    throughout the theory stream; the basis change has determinant `−1`.

    ⚠️ **Disclosure.** Same provenance and scope as `readingS_complement_eq_span`:
    no-CM and the Shioda–Inose isometry are not part of this statement. -/
theorem readingS_complement_isometry_TN (n : ℤ) :
    csComp ᵀ * gram3 (comp n) * csComp = Agora.Geometry.MnLattice.TN n := by
  rw [readingS_complement_gram]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [csComp, Agora.Geometry.MnLattice.TN, Matrix.mul_apply, Fin.sum_univ_succ, transpose_apply]

end Agora.Geometry.ReadingS
