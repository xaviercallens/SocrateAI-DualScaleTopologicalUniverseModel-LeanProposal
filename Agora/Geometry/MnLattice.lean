/-
  Agora/Geometry/MnLattice.lean
  ════════════════════════════════════════════════════════════════════════════════

  The lattice `U ⊕ ⟨2N⟩`, its gluing into a hyperbolic plane, and the swap
  isometry — kernel-checked, built on LeanMaster's lattice API
  (`DualScaleStream2.Lattice`: `Gram`, `hyperbolicU`, `latticeNorm`, `Signature`).

  WHY THIS FILE EXISTS. The paper (§6, §8) derives — by an exact integer pipeline
  outside Lean, status (E) — that the monodromy-invariant lattice of the s7 family
  is isometric to `U ⊕ ⟨14⟩`, and cross-checks that its orthogonal complement in
  the K3 lattice is `U ⊕ E₈(−1)² ⊕ ⟨−14⟩ = M₇`. This file does NOT re-derive that
  identification. It certifies the LATTICE ARITHMETIC that the identification is
  then fed into, uniformly in `N`, and instantiates at `N = 7`:

    §1  `TN N = U ⊕ ⟨2N⟩`: symmetric, even, `det = −2N` (so not unimodular).
    §2  THE GLUE: inside one hyperbolic plane `U`, the vector `(1, N)` has norm
        `2N`, the vector `(1, −N)` has norm `−2N`, they are orthogonal, and they
        span a sublattice of index `2N`. This is the explicit witness
        `w ↦ e + N f` of the paper's Prop. `prop:g0complement`, and it is the whole
        non-trivial content of the primitive embedding
        `(U ⊕ ⟨2N⟩) ⊕ (U ⊕ E₈(−1)² ⊕ ⟨−2N⟩) ⊂ U³ ⊕ E₈(−1)²`.
    §3  Signature bookkeeping against LeanMaster's `sigK3`: `(2,1) + (1,18) = (3,19)`.
    §4  THE SWAP. Exchanging the two isotropic generators of `U` is an isometry of
        `U ⊕ ⟨2N⟩`, an involution, of determinant `−1`. On the period vector
        `ω(τ) = (1, −Nτ², τ)` it acts as `τ ↦ −1/(Nτ)` — the Fricke involution —
        and its fixed locus is `Nτ² = −1`.
    §5  The same swap, on LeanMaster's Narain lattice, is the T-duality generator
        `eta 1` (`hyperbolicU = NarainLattice.gram` is LeanMaster's theorem).

  ────────────────────────────────────────────────────────────────────────────────
  EPISTEMIC STATUS — read before citing

  Everything here is Tier A: statements about explicitly exhibited integer matrices
  and an explicit algebraic period vector. What is NOT here, and stays Tier B:
  that `U ⊕ ⟨14⟩` IS the transcendental lattice of the s7 K3 family
  (paper Conjecture `conj:T`), and ρ = 19 / T = 3 (Stream 2 E-011).

  §4–§5 establish that ONE matrix — the swap on `U` — is simultaneously (a) the
  Fricke involution on the `Mₙ`-polarized period parameter and (b) the T-duality
  generator on a circle's Narain lattice. That is a fact about a lattice isometry.
  It is NOT a physical identification of the two, supplies no coupling, and no
  such reading is asserted (VISION §1.3; Tier C remains blocked, F5b). The
  research note `briefs/RESEARCH_DIRECTIONS_2026_09_20.md` states the conjecture
  this suggests, marked as a conjecture.

  Signatures in §3 are, as in LeanMaster, asserted pairs (its Tier L caveat is
  inherited verbatim): `⟨1,0⟩` for `⟨2N⟩` with `N > 0` is not extracted from a
  definiteness proof.

  0 sorry. Axioms: Lean's three only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import DualScaleStream2.Lattice.Hyperbolic
import DualScaleStream2.Lattice.Reflection
import DualScaleStream2.Lattice.K3T2Signature
import DualScaleStream2.TDuality.ODD
import Mathlib.Tactic

namespace Agora.Geometry.MnLattice

open Matrix DualScaleStream2.Lattice

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. U ⊕ ⟨2N⟩                                                       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Gram matrix of `U ⊕ ⟨2N⟩` in the basis `(e, f, w)`: `e² = f² = 0`, `e·f = 1`,
    `w² = 2N`.
    -- Source: Dolgachev, "Mirror symmetry for lattice polarized K3 surfaces",
    J. Math. Sci. 81 (1996), §7: the transcendental lattice of an `Mₙ`-polarized
    K3 surface is `U ⊕ ⟨2n⟩`. -/
def TN (N : ℤ) : Gram 3 := !![0, 1, 0; 1, 0, 0; 0, 0, 2 * N]

/-- The s7 instance, `U ⊕ ⟨14⟩`. -/
def T7 : Gram 3 := TN 7

theorem TN_symm (N : ℤ) : (TN N)ᵀ = TN N := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl

theorem TN_evenDiag (N : ℤ) : IsEvenDiag (TN N) := by
  intro i; fin_cases i
  · exact ⟨0, by simp [TN]⟩
  · exact ⟨0, by simp [TN]⟩
  · exact ⟨N, by simp [TN]; ring⟩

/-- The norm form of `U ⊕ ⟨2N⟩` is `2xy + 2Nz²`. -/
theorem TN_norm (N x y z : ℤ) : latticeNorm (TN N) ![x, y, z] = 2 * x * y + 2 * N * z ^ 2 := by
  simp [latticeNorm, TN, dotProduct, mulVec, Fin.sum_univ_succ]; ring

theorem TN_det (N : ℤ) : (TN N).det = -(2 * N) := by
  simp [TN, det_fin_three]

theorem T7_det : T7.det = -14 := by rw [T7, TN_det]; norm_num

/-- `U ⊕ ⟨14⟩` is not unimodular: its discriminant group has order 14. -/
theorem T7_not_unimodular : ¬ IsUnimodular T7 := by
  rintro (h | h) <;> rw [T7_det] at h <;> norm_num at h

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE GLUE: ⟨2N⟩ ⊕ ⟨−2N⟩ ⊂ U, index 2N                          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Columns `e + N f` and `e − N f` of a hyperbolic plane. -/
def glue (N : ℤ) : Gram 2 := !![1, 1; N, -N]

/-- **The gluing witness.** In one hyperbolic plane `U`, `e + N f` has norm `2N`,
    `e − N f` has norm `−2N`, and they are orthogonal. -/
theorem glue_congruence (N : ℤ) :
    (glue N)ᵀ * hyperbolicU * glue N = !![2 * N, 0; 0, -(2 * N)] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [glue, hyperbolicU, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-- The sublattice `⟨2N⟩ ⊕ ⟨−2N⟩ ⊂ U` has index `|det| = 2N`. -/
theorem glue_det (N : ℤ) : (glue N).det = -(2 * N) := by
  simp [glue, det_fin_two]; ring

/-- `e + N f` is primitive in `U` for every `N`. -/
theorem glue_primitive (N : ℤ) : IsCoprime (1 : ℤ) N := isCoprime_one_left

/-- s7: `e + 7f ∈ U` has norm 14 — the witness of the paper's `prop:g0complement`. -/
theorem s7_glue_norm : latticeNorm hyperbolicU ![1, 7] = 14 := by
  simp [latticeNorm, hyperbolicU, dotProduct, mulVec, Fin.sum_univ_succ]

theorem s7_glue_conorm : latticeNorm hyperbolicU ![1, -7] = -14 := by
  simp [latticeNorm, hyperbolicU, dotProduct, mulVec, Fin.sum_univ_succ]

/-- The discriminants of the two glued pieces agree in absolute value, as they must
    for mutually orthogonal primitive sublattices of a unimodular lattice:
    `|det(U ⊕ ⟨14⟩)| = 14 = |det U · det E₈(−1)² · (−14)|`, the E₈(−1) factors
    being unimodular (LeanMaster `e8Neg_unimodular`). -/
theorem s7_discriminants_match : |T7.det| = |hyperbolicU.det * (-14)| := by
  rw [T7_det]
  have : hyperbolicU.det = -1 := by simp [hyperbolicU, det_fin_two]
  rw [this]; norm_num

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. SIGNATURES, against LeanMaster's K3 lattice                    ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Signature of `U ⊕ ⟨2N⟩`, `N > 0` (asserted pair; see header). -/
def sigTN : Signature := sigU + ⟨1, 0⟩

/-- Signature of `Mₙ = U ⊕ E₈(−1)² ⊕ ⟨−2N⟩`, `N > 0`. -/
def sigMN : Signature := sigU + sigE8Neg + sigE8Neg + ⟨0, 1⟩

theorem sigTN_eq : sigTN = ⟨2, 1⟩ := rfl
theorem sigMN_eq : sigMN = ⟨1, 18⟩ := rfl

/-- `(2,1) + (1,18) = (3,19)`: the two pieces fill out LeanMaster's K3 signature. -/
theorem sig_fills_K3 : sigTN + sigMN = sigK3 := rfl

/-- Ranks `3 + 19 = 22`. The `19` is forced by `22 − 3`; it is arithmetic, not
    independent evidence for a Picard number. -/
theorem rank_fills_K3 : sigTN.rank + sigMN.rank = sigK3.rank := rfl

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. THE SWAP = FRICKE ON THE PERIOD                               ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Exchange the isotropic generators `e ↔ f` of the `U` summand. -/
def swap : Gram 3 := !![0, 1, 0; 1, 0, 0; 0, 0, 1]

/-- The swap is an isometry of `U ⊕ ⟨2N⟩`, for every `N`. -/
theorem swap_isometry (N : ℤ) : swapᵀ * TN N * swap = TN N := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [swap, TN, Matrix.mul_apply, Fin.sum_univ_succ]

theorem swap_involution : swap * swap = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [swap, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The swap reverses orientation: it is not in `SO`. -/
theorem swap_det : swap.det = -1 := by simp [swap, det_fin_three]

variable {K : Type*} [Field K]

/-- The period vector `ω(τ) = e − Nτ² f + τ w`, in coordinates `(e, f, w)`.
    -- Source: Dolgachev (1996) §7, the tube-domain realization of the period
    domain of `U ⊕ ⟨2n⟩` as the upper half-plane. -/
def period (N τ : K) : Fin 3 → K := ![1, -N * τ ^ 2, τ]

/-- The quadratic form `2xy + 2Nz²` of `U ⊕ ⟨2N⟩` over a field (cf. `TN_norm`). -/
def qN (N : K) (v : Fin 3 → K) : K := 2 * v 0 * v 1 + 2 * N * v 2 ^ 2

/-- The period vector is isotropic: `ω(τ)² = 0`, for every `τ`. -/
theorem period_isotropic (N τ : K) : qN N (period N τ) = 0 := by
  simp [qN, period]; ring

/-- The swap, acting on coordinate vectors over `K`. -/
def swapVec (v : Fin 3 → K) : Fin 3 → K := ![v 1, v 0, v 2]

theorem swapVec_preserves_qN (N : K) (v : Fin 3 → K) : qN N (swapVec v) = qN N v := by
  simp [qN, swapVec]; ring

/-- **The swap is the Fricke involution.** On the period line,
    `swap · ω(τ) = (−Nτ²) · ω(−1/(Nτ))`: exchanging `e ↔ f` sends the period
    parameter `τ` to `−1/(Nτ)`. -/
theorem swap_is_fricke (N τ : K) (hN : N ≠ 0) (hτ : τ ≠ 0) :
    swapVec (period N τ) = (-N * τ ^ 2) • period N (-1 / (N * τ)) := by
  ext i
  fin_cases i <;> simp [swapVec, period] <;> field_simp

/-- **Self-dual locus.** If `Nτ² = −1` the period vector is fixed by the swap on
    the nose: `ω = (1, 1, τ)`. (Over `ℂ`: `τ = i/√N`, the Fricke fixed point.) -/
theorem swap_fixes_selfdual (N τ : K) (h : N * τ ^ 2 = -1) :
    swapVec (period N τ) = period N τ := by
  have h' : -N * τ ^ 2 = 1 := by linear_combination -h
  ext i
  fin_cases i <;> simp [swapVec, period, h']

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §5. THE SAME SWAP IS T-DUALITY ON THE NARAIN LATTICE               ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The `U`-block of `swap` is `hyperbolicU` itself … -/
theorem swap_U_block : (swap.submatrix (Fin.castLE (by norm_num : 2 ≤ 3))
    (Fin.castLE (by norm_num : 2 ≤ 3))) = hyperbolicU := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl

/-- … and `hyperbolicU` is, by LeanMaster's theorem, the Narain Gram matrix of a
    circle, on which the exchange of momentum and winding is T-duality. So the
    matrix that acts as Fricke on the `Mₙ` period (§4) is the matrix LeanMaster
    verifies as the Narain form. Statement about matrices only; see header. -/
theorem swap_U_block_is_narain :
    (swap.submatrix (Fin.castLE (by norm_num : 2 ≤ 3)) (Fin.castLE (by norm_num : 2 ≤ 3)))
      = StringTheory.UseCases.NarainLattice.gram :=
  swap_U_block.trans hyperbolicU_eq_narain_gram

/-- LeanMaster's T-duality generator `eta d` is an `O(d,d;ℤ)` element squaring to
    one — re-exported here so the parallel with `swap_isometry`/`swap_involution`
    is checked in one place rather than asserted in prose. -/
theorem tduality_parallel (d : ℕ) :
    DualScaleStream2.TDuality.IsODD (DualScaleStream2.TDuality.eta d) ∧
      DualScaleStream2.TDuality.eta d * DualScaleStream2.TDuality.eta d = 1 :=
  ⟨DualScaleStream2.TDuality.eta_isODD, DualScaleStream2.TDuality.eta_mul_self⟩

end Agora.Geometry.MnLattice
