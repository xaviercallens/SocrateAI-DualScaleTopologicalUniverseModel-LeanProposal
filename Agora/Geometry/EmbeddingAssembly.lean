/-
  Agora/Geometry/EmbeddingAssembly.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE ASSEMBLY STEP, MOVED FROM PAPER INTO THE KERNEL.

  `Agora/Geometry/Embedding.lean` checks the arithmetic core of the paper's
  Proposition `prop:g0complement` in `U³` (6×6): `B` embeds `T₇ = U ⊕ ⟨14⟩`, `C`
  embeds `U ⊕ ⟨−14⟩`, and the two are orthogonal. Its header then says, of the
  step from that 6×6 statement to the full rank-22 one:

      "the assembly of the 22×22 statement from this 6×6 one is the standard
       orthogonal-direct-sum argument, done on paper, not in Lean."

  This file removes that sentence's content from paper and gives it to the kernel.
  Nothing here is new mathematics — it is the bookkeeping that the earlier header
  declined to do, done generically and then instantiated.

  ────────────────────────────────────────────────────────────────────────────────
  WHAT IS PROVED

  §1  `join_pullback` — GENERIC, over arbitrary index types and any commutative
      ring: if `Bᵀ G B = G₁`, `Cᵀ G C = G₂` and `Bᵀ G C = 0`, with `G` symmetric,
      then the joined map `[B | C]` pulls `G` back to the block-diagonal form
      `G₁ ⊕ G₂`. The fourth cross-term `Cᵀ G B = 0` is *derived* from symmetry,
      not assumed.
  §2  `Lambda` — the K3 lattice `Λ = U³ ⊕ E₈(−1)²` as an explicit block matrix
      over `Fin 6 ⊕ Fin 16`, and `Lambda_symm`.
  §3  The two ambient embeddings `Phi_T` (rank 3) and `Phi_M` (rank 19), and
      their pullbacks: `Phi_T_pullback : Phi_Tᵀ Λ Phi_T = T₇`, and
      `Phi_M_pullback : Phi_Mᵀ Λ Phi_M = (U ⊕ ⟨−14⟩) ⊕ E₈(−1)²`.
  §4  `assembly` — the rank-22 statement: the joined map `Φ = [Phi_T | Phi_M]`
      satisfies `Φᵀ Λ Φ = T₇ ⊕ ((U ⊕ ⟨−14⟩) ⊕ E₈(−1)²)`. This is
      `prop:g0complement` over the whole rank-22 lattice, orthogonality included.
      ⚠️ Note precisely what this is: a statement about the PULLBACK of `Λ` along
      `Φ`. It is *not* a rank, injectivity or index statement about `Φ` itself —
      none is proved here. (`assembly_det ≠ 0` does force `Φ` to have trivial
      kernel over `ℚ`, but that corollary is not formalized below, so do not
      cite this file for it.)
  §5  `assembly_det` — the discriminant bookkeeping: the pullback has determinant
      `−196 = −14²`, so `|det| = 14²` where `14 = |disc T₇|` is the index computed
      in `Embedding.index_eq_disc`. The `index² = disc · disc` relation for a
      finite-index sublattice of a unimodular lattice, kernel-checked.
  §6  NEGATIVE CONTROLS: the join lemma genuinely uses orthogonality (dropping it
      makes the conclusion false), and `Phi_M` genuinely uses `−7` (at `+7` the
      two sublattices are not orthogonal in `Λ`).

  NON-VACUITY OF `assembly`. A statement of the form `Φᵀ Λ Φ = X` is worth
  checking for degenerate solutions — `Φ = 0` satisfies it whenever `X = 0`.
  It does not here: `assembly_det` (§5) computes `X.det = −196 ≠ 0`, so
  `assembly` forces `det (Φᵀ Λ Φ) ≠ 0`, which no degenerate `Φ` can satisfy.
  The two theorems together are the non-vacuity control for this file.
  (This bounds `Φ` from below; it still proves no rank or index statement
  about `Φ` — see §4's caveat.)

  WHAT IS NOT PROVED HERE — the boundary is unchanged from `Embedding.lean`

  * That `E₈(−1)` is unimodular and even is QUOTED from LeanMaster
    (`e8Neg_unimodular`, `e8Neg_evenDiag`), which is `rfl`-level over an encoded
    Cartan matrix. That inherited caveat is not re-derived here.
  * "Index equals discriminant ⟹ the two sublattices are primitive orthogonal
    complements of each other" is the standard Nikulin-style criterion. It is
    LITERATURE, not Lean: §5 checks the numerical coincidence the criterion
    consumes, it does not formalize the criterion.
  * The IDENTIFICATION of the s₇ monodromy lattice with `U ⊕ ⟨14⟩` remains
    **Tier B** and rests on a numerical monodromy computation performed outside
    Lean. This file embeds the lattice; it does not show it is the right one.
  * Nothing here concerns physics. No observable, coupling, or brane statement
    is made or implied (VISION §1.3, F5b).

  BASIS-ORDERING CONVENTION. The assembly produces the summands in the order
  `T₇ ⊕ ((U ⊕ ⟨−14⟩) ⊕ E₈(−1)²)`, whereas the paper writes the complement as
  `M₇ = U ⊕ E₈(−1)² ⊕ ⟨−14⟩`. These differ by a permutation of basis vectors
  (a conjugation by a permutation matrix), which is a choice of ordering and not
  a mathematical difference. It is stated rather than proved; no theorem below
  claims the paper's literal ordering.

  0 sorry. Axioms: Lean's three standard ones only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Geometry.Embedding
import Mathlib.Data.Matrix.ColumnRowPartitioned

namespace Agora.Geometry.EmbeddingAssembly

open Matrix DualScaleStream2.Lattice
open Agora.Geometry.MnLattice Agora.Geometry.Embedding

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE GENERIC ORTHOGONAL-JOIN LEMMA                              ║
-- ╚════════════════════════════════════════════════════════════════════╝

variable {R : Type*} [CommRing R]
variable {m n₁ n₂ : Type*} [Fintype m] [DecidableEq m]

/-- **The cross-term in the other order vanishes too.** For a *symmetric* form `G`,
    `Bᵀ G C = 0` already forces `Cᵀ G B = 0`; it is the transpose of the first.
    Stated separately because it is the only place symmetry of `G` is used. -/
theorem orthogonal_symm {G : Matrix m m R} (hG : Gᵀ = G)
    {B : Matrix m n₁ R} {C : Matrix m n₂ R} (h : Bᵀ * G * C = 0) :
    Cᵀ * G * B = 0 := by
  have : (Bᵀ * G * C)ᵀ = (0 : Matrix n₂ n₁ R) := by rw [h]; simp
  simpa [Matrix.transpose_mul, hG, Matrix.mul_assoc] using this

/-- **THE ASSEMBLY LEMMA (generic).** Two maps into a symmetric form, pulling it
    back to `G₁` and `G₂` and mutually orthogonal, join to a single map pulling
    it back to the block-diagonal form `G₁ ⊕ G₂`.

    This is the "standard orthogonal-direct-sum argument" that `Embedding.lean`
    performed on paper. It holds over any commutative ring and any index types:
    no finiteness of the source, no rank condition, no nondegeneracy. -/
theorem join_pullback {G : Matrix m m R} (hG : Gᵀ = G)
    {B : Matrix m n₁ R} {C : Matrix m n₂ R} {G₁ : Matrix n₁ n₁ R} {G₂ : Matrix n₂ n₂ R}
    (hB : Bᵀ * G * B = G₁) (hC : Cᵀ * G * C = G₂) (hBC : Bᵀ * G * C = 0) :
    (fromCols B C)ᵀ * G * (fromCols B C) = fromBlocks G₁ 0 0 G₂ := by
  have hCB : Cᵀ * G * B = 0 := orthogonal_symm hG hBC
  rw [transpose_fromCols, fromRows_mul, fromRows_mul_fromCols, hB, hC, hBC, hCB]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE K3 LATTICE Λ = U³ ⊕ E₈(−1)²                                ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `E₈(−1)²`, as a block matrix over `Fin 8 ⊕ Fin 8`.
    -- Source: LeanMaster `DualScaleStream2.Lattice.E8.e8Neg` (negated Cartan
    matrix of E₈); the K3 lattice is `U³ ⊕ E₈(−1)²`, e.g. Barth–Hulek–Peters–Van
    de Ven, *Compact Complex Surfaces*, VIII.3. -/
def E8sq : Matrix (Fin 8 ⊕ Fin 8) (Fin 8 ⊕ Fin 8) ℤ :=
  fromBlocks e8Neg 0 0 e8Neg

theorem E8sq_symm : E8sqᵀ = E8sq := by
  rw [E8sq, fromBlocks_transpose, e8Neg_symm]; simp

/-- The K3 lattice `Λ = U³ ⊕ E₈(−1)²`, built over the index type
    `Fin 6 ⊕ (Fin 8 ⊕ Fin 8)` — six hyperbolic-plane coordinates and two copies
    of `E₈(−1)`, so rank 22 by construction. (The number 22 is the size of that
    index type, not a claim proved below.) -/
def Lambda : Matrix (Fin 6 ⊕ (Fin 8 ⊕ Fin 8)) (Fin 6 ⊕ (Fin 8 ⊕ Fin 8)) ℤ :=
  fromBlocks U3 0 0 E8sq

theorem Lambda_symm : Lambdaᵀ = Lambda := by
  rw [Lambda, fromBlocks_transpose, U3_symm, E8sq_symm]; simp

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE TWO AMBIENT EMBEDDINGS                                     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `Φ_T : T₇ → Λ`. The rank-3 lattice `T₇ = U ⊕ ⟨14⟩` goes in through `B`, and
    misses the `E₈(−1)²` summand entirely. -/
def Phi_T : Matrix (Fin 6 ⊕ (Fin 8 ⊕ Fin 8)) (Fin 3) ℤ :=
  fromRows B 0

/-- `Φ_M : (U ⊕ ⟨−14⟩) ⊕ E₈(−1)² → Λ`, rank 19. The non-unimodular part goes in
    through `C`; the `E₈(−1)²` summand is carried across by the identity, which
    is the content of "`E₈(−1)` is unimodular, so it splits off and sits entirely
    inside the complement". -/
def Phi_M : Matrix (Fin 6 ⊕ (Fin 8 ⊕ Fin 8)) (Fin 3 ⊕ (Fin 8 ⊕ Fin 8)) ℤ :=
  fromBlocks C 0 0 1

/-- **`Φ_T` embeds `T₇` in the full K3 lattice.** The 6×6 computation
    `Embedding.B_pullback` transported to rank 22. -/
theorem Phi_T_pullback : Phi_Tᵀ * Lambda * Phi_T = T7 := by
  rw [Phi_T, Lambda, transpose_fromRows, fromCols_mul_fromBlocks, fromCols_mul_fromRows]
  simp [B_pullback]

/-- **`Φ_M` embeds the complement `(U ⊕ ⟨−14⟩) ⊕ E₈(−1)²`.**

    The off-diagonal `0` blocks of the conclusion are not bookkeeping: they say
    the `⟨−14⟩` part and the `E₈(−1)²` part are mutually orthogonal inside `Λ`,
    which is why the complement splits as a direct SUM rather than merely
    containing both as sublattices. -/
theorem Phi_M_pullback :
    Phi_Mᵀ * Lambda * Phi_M = fromBlocks (TN (-7)) 0 0 E8sq := by
  rw [Phi_M, Lambda, fromBlocks_transpose, fromBlocks_multiply, fromBlocks_multiply]
  simp [C_pullback]

/-- **The two sublattices are orthogonal inside `Λ`.** `Embedding.B_orthogonal_C`
    plus the fact that `Φ_T` has no component along `E₈(−1)²`. -/
theorem Phi_T_orthogonal_Phi_M : Phi_Tᵀ * Lambda * Phi_M = 0 := by
  rw [Phi_T, Phi_M, Lambda, transpose_fromRows, fromCols_mul_fromBlocks,
    fromCols_mul_fromBlocks]
  simp [B_orthogonal_C]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. THE RANK-22 STATEMENT                                          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The full embedding `Φ = [Φ_T | Φ_M] : T₇ ⊕ M₇ → Λ`, of rank `3 + 19 = 22`. -/
def Phi : Matrix (Fin 6 ⊕ (Fin 8 ⊕ Fin 8)) (Fin 3 ⊕ (Fin 3 ⊕ (Fin 8 ⊕ Fin 8))) ℤ :=
  fromCols Phi_T Phi_M

/-- **`prop:g0complement`, OVER THE WHOLE RANK-22 LATTICE, IN THE KERNEL.**

    `(U ⊕ ⟨14⟩) ⊥ (U ⊕ E₈(−1)² ⊕ ⟨−14⟩) ⊂ U³ ⊕ E₈(−1)²`

    The joined map pulls the K3 form back to the orthogonal direct sum of `T₇`
    and the complement — the off-diagonal blocks are `0`, which *is* the
    orthogonality assertion. Summand order is the convention fixed in the header
    (the paper writes `⟨−14⟩` last); that is a basis ordering, not a claim. -/
theorem assembly :
    Phiᵀ * Lambda * Phi = fromBlocks T7 0 0 (fromBlocks (TN (-7)) 0 0 E8sq) :=
  join_pullback Lambda_symm Phi_T_pullback Phi_M_pullback Phi_T_orthogonal_Phi_M

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §5. THE DISCRIMINANT BOOKKEEPING                                   ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `det E₈(−1)² = 1`: unimodular, and the sign squares away.
    ⚠️ Rests on LeanMaster's `e8Neg_unimodular`, which is `rfl`-level over an
    encoded Cartan matrix — see the header's caveat. -/
theorem E8sq_det : E8sq.det = 1 := by
  rw [E8sq, det_fromBlocks_zero₁₂]
  rcases e8Neg_unimodular with h | h <;> rw [h] <;> norm_num

/-- **The determinant of the pullback is `−14²`.**

    `det = det T₇ · det(U ⊕ ⟨−14⟩) · det E₈(−1)² = (−14) · 14 · 1 = −196`.

    The absolute value is `14² = 196`, and `14` is exactly the index computed in
    `Embedding.index_eq_disc` and the discriminant of `Embedding.T7_disc`. This
    is the numerical input to the standard criterion that two mutually orthogonal
    sublattices of a unimodular lattice with `index² = disc · disc` are primitive
    complements of one another. ⚠️ The criterion itself is literature and is NOT
    formalized here (header). -/
theorem assembly_det :
    (fromBlocks T7 0 0 (fromBlocks (TN (-7)) 0 0 E8sq) :
      Matrix (Fin 3 ⊕ (Fin 3 ⊕ (Fin 8 ⊕ Fin 8))) _ ℤ).det = -196 := by
  rw [det_fromBlocks_zero₁₂, det_fromBlocks_zero₁₂, T7_det, TN_det, E8sq_det]
  norm_num

/-- The same number, said the way the criterion consumes it: `|det| = |disc T₇|²`. -/
theorem assembly_det_eq_disc_sq :
    |(fromBlocks T7 0 0 (fromBlocks (TN (-7)) 0 0 E8sq) :
      Matrix (Fin 3 ⊕ (Fin 3 ⊕ (Fin 8 ⊕ Fin 8))) _ ℤ).det| = |T7.det| ^ 2 := by
  rw [assembly_det, T7_det]; norm_num

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §6. NEGATIVE CONTROLS                                              ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **CONTROL 1: the join lemma really uses orthogonality.** Without the
    hypothesis `Bᵀ G C = 0` the conclusion is false — here is a witness, with
    `G = U` and both maps the identity, where the pullback is *not*
    block-diagonal. So `join_pullback` is not vacuously true of any two maps. -/
theorem join_needs_orthogonality :
    ∃ (G : Matrix (Fin 2) (Fin 2) ℤ) (B C : Matrix (Fin 2) (Fin 1) ℤ),
      Gᵀ = G ∧ (fromCols B C)ᵀ * G * (fromCols B C) ≠
        fromBlocks (Bᵀ * G * B) 0 0 (Cᵀ * G * C) := by
  refine ⟨!![0,1;1,0], !![1;0], !![0;1], by ext i j; fin_cases i <;> fin_cases j <;> rfl, ?_⟩
  intro hc
  have h := congrFun (congrFun hc (Sum.inl 0)) (Sum.inr 0)
  simp [Matrix.mul_apply, Fin.sum_univ_succ, fromCols] at h

/-- **CONTROL 2: the sign in `Φ_M` is load-bearing.** Replacing `C` (which uses
    `e₃ − 7f₃`) by `B` (which uses `e₃ + 7f₃`) destroys orthogonality: the two
    copies of `T₇` are not orthogonal in `Λ`. So §3's orthogonality says
    something about the `±` split of the third hyperbolic plane. -/
theorem plus_seven_not_orthogonal :
    Phi_Tᵀ * Lambda * (fromRows B (0 : Matrix (Fin 8 ⊕ Fin 8) (Fin 3) ℤ)) ≠ 0 := by
  intro hc
  rw [Phi_T, Lambda, transpose_fromRows, fromCols_mul_fromBlocks,
    fromCols_mul_fromRows] at hc
  simp only [Matrix.mul_zero, Matrix.zero_mul, add_zero, zero_add] at hc
  have h := congrFun (congrFun hc 2) 2
  rw [show Bᵀ * U3 * B = T7 from B_pullback] at h
  simp [T7, TN] at h

end Agora.Geometry.EmbeddingAssembly

/-
  Generated-by: Claude Opus 5 (Stream 1 session) | Verified-by: Lean 4 kernel
  (lake build Agora, 0 sorry, axioms propext/Classical.choice/Quot.sound only)
  | Reviewed-by: T0 N
-/
