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

/-- **`e + N f` is primitive in `U`**, for every `N`: in the basis `(e, f)` it is
    the coordinate vector `![1, N]`, and any factorization `![1, N] = d • w`
    through an integer vector `w` forces `d` to be a unit.

    ⚠️ **Disclosure — corrected 2026-09-21.** This theorem was previously stated as
    `IsCoprime (1 : ℤ) N` and closed by `isCoprime_one_left`. That statement is
    true for every `N` in every commutative ring and mentions neither the
    vector, the basis, nor `U`: it is `isCoprime_one_left` under another name,
    and the identification with "`e + N f` is primitive" lived entirely in this
    docstring. The mathematics was never wrong — the coordinates really are
    `(1, N)` and really are coprime — but the kernel was certifying none of it.
    The statement now names the vector. -/
theorem glue_primitive (N : ℤ) {d : ℤ} {w : Fin 2 → ℤ}
    (h : ![1, N] = d • w) : IsUnit d := by
  have h0 : d * w 0 = 1 := by
    have := congrFun h 0
    simpa using this.symm
  exact isUnit_iff_exists.mpr ⟨w 0, h0, by rw [mul_comm]; exact h0⟩

/-- s7: `e + 7f ∈ U` has norm 14 — the witness of the paper's `prop:g0complement`. -/
theorem s7_glue_norm : latticeNorm hyperbolicU ![1, 7] = 14 := by
  simp [latticeNorm, hyperbolicU, dotProduct, mulVec, Fin.sum_univ_succ]

theorem s7_glue_conorm : latticeNorm hyperbolicU ![1, -7] = -14 := by
  simp [latticeNorm, hyperbolicU, dotProduct, mulVec, Fin.sum_univ_succ]

/-- The discriminants of the two glued pieces agree in absolute value. (Under the
    standard Nikulin-style criterion this is what mutually orthogonal primitive
    sublattices of a unimodular lattice must satisfy — but that criterion is
    literature and is not formalized in this repository; only the equality below
    is checked.)  Explicitly:
    `|det(U ⊕ ⟨14⟩)| = 14 = |det U · det E₈(−1)² · (−14)|`, the E₈(−1) factors
    being unimodular (LeanMaster `e8Neg_unimodular`). -/
theorem s7_discriminants_match : |T7.det| = |hyperbolicU.det * (-14)| := by
  rw [T7_det]
  have : hyperbolicU.det = -1 := by simp [hyperbolicU, det_fin_two]
  rw [this]; norm_num

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. SIGNATURES, against LeanMaster's K3 lattice                    ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **The signature is now kernel-backed, not asserted.** The integer basis
    change `P = (e+f, w, e−f)`, of determinant 2, diagonalizes `U ⊕ ⟨2N⟩`:

        Pᵀ · T_N · P = diag(2, 2N, −2)

    For `N > 0` that is two positive entries and one negative, so the signature
    is `(2,1)` by Sylvester's law of inertia (quoted, Tier L — the diagonal form
    itself is Tier A).

    Supplied by the LeanMaster session (`DualScaleDyons.FrickeCriterion.
    uPlus2N_diagonalises`, tag v3.43.0) and restated and re-verified here; it
    retires the "asserted pairs" caveat this file inherited for `sigTN`. -/
def diagBasis : Gram 3 := !![1, 0, 1; 1, 0, -1; 0, 1, 0]

theorem diagBasis_det : diagBasis.det = 2 := by
  simp [diagBasis, Matrix.det_fin_three]

theorem TN_diagonalises (N : ℤ) :
    diagBasisᵀ * TN N * diagBasis = !![2, 0, 0; 0, 2 * N, 0; 0, 0, -2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [diagBasis, TN, Matrix.mul_apply, Fin.sum_univ_succ] <;> ring

/-- NEGATIVE CONTROL: the sign is load-bearing. The last diagonal entry is `−2`,
    not `+2`. -/
theorem TN_diagonalises_sign (N : ℤ) :
    diagBasisᵀ * TN N * diagBasis ≠ !![2, 0, 0; 0, 2 * N, 0; 0, 0, 2] := by
  intro hc
  rw [TN_diagonalises] at hc
  have h := congrFun (congrFun hc 2) 2
  simp at h

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3b. RANK-JUMP CLASSES: (−2)-vectors and their exact complements     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-! **Stream 2 direction 2** (`briefs/STREAM2_TO_STREAM1_FABLE_REVIEW_DIRECTIONS_2026_09_27.md`,
    from the audited external review of 2026-09-21): the *lattice half* of the ρ = 20
    "rank-jump" rows of Stream 2's `data/certificates/CM_POINTS_RHO20.json`
    (sha256 `1ef6d622af22a6488316fad01503ed4381c1d742861f178b3d3ea9d76c220755`, read at
    K3-DarkMatter `79b1c68`). The certificate's coordinates `(x, y, z)` carry the norm
    `2xy + 2Nz²` (its `stage0_selftest.norm_is_2xy_plus_2n_z2`), i.e. **this file's basis**
    `(e, f, w)` for `TN`; the brief's "our basis" remark concerns a different presentation
    and is not needed here.

    What the kernel certifies below, for a (−2)-class `v`:
    * `v² = −2` (`latticeNorm`);
    * the **exact** orthogonal complement `v^⊥ = {x | ⟨x, v⟩ = 0}` as a set, as an `↔` with
      an explicit two-parameter family — not merely two vectors that happen to be orthogonal;
    * the Gram matrix of that complement, and the index of `v ⊕ v^⊥` in `U ⊕ ⟨2N⟩`
      (determinant of the frame `(v, basis of v^⊥)`).

    What it does **not** certify (Tier B, Stream 2's): that `v` is algebraic at the recognised
    period point `τ` (Lefschetz (1,1)), hence that the Picard number jumps to 20 there and
    `T_X = v^⊥`; and that the `z`-values `1/27`, `−1` are the s₇ singular loci (numeric
    recognition, LLL at 120 digits re-checked at 200). The framework identification
    `T = U ⊕ ⟨2N⟩` is Dolgachev 1996 §7 / Doran 1998 Thm 5.13 (Tier L, `docs/literature/MANIFEST.md`). -/

/-- The bilinear pairing `xᵀ G y` of two coordinate vectors under a Gram matrix `G`; the
    polarization of `latticeNorm` (`pairing G v v = latticeNorm G v` by `rfl`). -/
def pairing (G : Gram 3) (x y : Fin 3 → ℤ) : ℤ := x ⬝ᵥ (G *ᵥ y)

theorem pairing_self (G : Gram 3) (v : Fin 3 → ℤ) : pairing G v v = latticeNorm G v := rfl

/-- **Class 1 — the Fricke fixed-point class** `e − f`, coordinates `![1, -1, 0]`, for every `N`.
    -- Source: `CM_POINTS_RHO20.json`, `families.cooper_s7.rows`, row `v = [1,-1,0]`
    (`minus_v2 = 2`, `div_v = 1`, `T_X_kernel_basis = [[1,1,0],[0,0,1]]`, `D = -28`,
    `z_value_if_rational = 1/27`); the same row exists for `cooper_s10` (`z = 1/16`, ADVISORY).
    Its wall `⟨x, e−f⟩ = 0 ⟺ Nτ² = −1` is `SelfDual.lean`'s subject. -/
def rootEF : Fin 3 → ℤ := ![1, -1, 0]

theorem rootEF_norm (N : ℤ) : latticeNorm (TN N) rootEF = -2 := by
  simp [latticeNorm, rootEF, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- **The exact complement of `e − f`:** `x ⊥ (e − f)` in `U ⊕ ⟨2N⟩` iff `x = a(e + f) + b·w`.
    This is the set-level statement; `rootEF_perp_gram` gives that complement's form. -/
theorem rootEF_perp_iff (N : ℤ) (x : Fin 3 → ℤ) :
    pairing (TN N) x rootEF = 0 ↔ ∃ a b : ℤ, x = ![a, a, b] := by
  constructor
  · intro h
    refine ⟨x 0, x 2, ?_⟩
    simp [pairing, rootEF, TN, dotProduct, mulVec, Fin.sum_univ_succ] at h
    ext i; fin_cases i <;> simp <;> omega
  · rintro ⟨a, b, rfl⟩
    simp [pairing, rootEF, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- Columns `e + f` and `w`: the basis of `(e − f)^⊥` named by `rootEF_perp_iff`. -/
def rootEFPerpBasis : Matrix (Fin 3) (Fin 2) ℤ := !![1, 0; 1, 0; 0, 1]

/-- `(e − f)^⊥ ≅ ⟨2⟩ ⊕ ⟨2N⟩` — the certificate's `T_X = <2>+<2n>` at the Fricke point. -/
theorem rootEF_perp_gram (N : ℤ) :
    rootEFPerpBasisᵀ * TN N * rootEFPerpBasis = !![2, 0; 0, 2 * N] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rootEFPerpBasis, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The frame `(e − f, e + f, w)`. -/
def rootEFFrame : Gram 3 := !![1, 1, 0; -1, 1, 0; 0, 0, 1]

/-- `⟨e − f⟩ ⊕ (e − f)^⊥` has **index 2** in `U ⊕ ⟨2N⟩`: the frame has determinant 2.
    (This is `TN_diagonalises` with its columns reordered — the same diagonal form.) -/
theorem rootEFFrame_det : rootEFFrame.det = 2 := by
  simp [rootEFFrame, det_fin_three]

theorem TN_splits_at_rootEF (N : ℤ) :
    rootEFFrameᵀ * TN N * rootEFFrame = !![-2, 0, 0; 0, 2, 0; 0, 0, 2 * N] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rootEFFrame, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- **Class 2 — the other order-2 point of `X₀(7)⁺`**, coordinates `![2, -4, 1]` in `U ⊕ ⟨14⟩`.
    -- Source: `CM_POINTS_RHO20.json`, `families.cooper_s7.rows`, row `v = [2,-4,1]`
    (`minus_v2 = 2`, `div_v = 2`, `T_X_reduced_form_abc = [1,1,2]`, `det_T_X = 7`, `D = -7`,
    `T_X_kernel_basis = [[1,2,0],[0,-7,1]]`, `z_value_if_rational = -1`). The brief writes this
    class as `±(−2, 4, 1)`; the certificate row carries `(2, −4, 1)`, used here. The
    `τ = 1/2 + i/√28` and `z = −1` in that row are Tier B and are **not** used below. -/
def root7 : Fin 3 → ℤ := ![2, -4, 1]

theorem root7_norm : latticeNorm T7 root7 = -2 := by
  simp [latticeNorm, root7, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- **The exact complement of `root7`:** `x ⊥ root7` in `U ⊕ ⟨14⟩` iff
    `x = a·(1, 2, 0) + b·(0, −7, 1)` — the certificate's `T_X_kernel_basis`, verbatim. -/
theorem root7_perp_iff (x : Fin 3 → ℤ) :
    pairing T7 x root7 = 0 ↔ ∃ a b : ℤ, x = ![a, 2 * a - 7 * b, b] := by
  constructor
  · intro h
    refine ⟨x 0, x 2, ?_⟩
    simp [pairing, root7, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ] at h
    ext i; fin_cases i <;> simp <;> omega
  · rintro ⟨a, b, rfl⟩
    simp [pairing, root7, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]; ring

/-- The certificate's kernel basis of `root7^⊥`, as columns `(1, 2, 0)`, `(0, −7, 1)`. -/
def root7PerpBasis : Matrix (Fin 3) (Fin 2) ℤ := !![1, 0; 2, -7; 0, 1]

theorem root7_perp_gram : root7PerpBasisᵀ * T7 * root7PerpBasis = !![4, -7; -7, 14] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root7PerpBasis, T7, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The Gauss-reduced basis `(2, −3, 1)`, `(1, 2, 0)` of the same complement. -/
def root7PerpReduced : Matrix (Fin 3) (Fin 2) ℤ := !![2, 1; -3, 2; 1, 0]

/-- The integer change of basis `!![2, 1; 1, 0]` between the two bases of `root7^⊥`. -/
def root7PerpChange : Gram 2 := !![2, 1; 1, 0]

/-- The two bases of `root7^⊥` differ by `root7PerpChange`, which is unimodular
    (`root7_perp_change_det`), so they span the same sublattice. -/
theorem root7_perp_bases_related : root7PerpBasis * root7PerpChange = root7PerpReduced := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root7PerpBasis, root7PerpReduced, root7PerpChange, Matrix.mul_apply, Fin.sum_univ_succ]

theorem root7_perp_change_det : root7PerpChange.det = -1 := by
  simp [root7PerpChange, det_fin_two]

/-- **`root7^⊥ ≅ [[2, 1], [1, 4]]`** — the binary form `x² + xy + 2y²` of discriminant `−7`, the
    certificate's `T_X_reduced_form_abc = [1,1,2]`. -/
theorem root7_perp_reduced_gram :
    root7PerpReducedᵀ * T7 * root7PerpReduced = !![2, 1; 1, 4] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root7PerpReduced, T7, TN, Matrix.mul_apply, Fin.sum_univ_succ]

theorem root7_perp_reduced_det : (!![2, 1; 1, 4] : Gram 2).det = 7 := by
  simp [det_fin_two]

/-- The frame `(root7, (2, −3, 1), (1, 2, 0))`. -/
def root7Frame : Gram 3 := !![2, 2, 1; -4, -3, 2; 1, 1, 0]

/-- **Index 1, unlike the Fricke class:** the frame is unimodular, so
    `U ⊕ ⟨14⟩ = ⟨root7⟩ ⊕ root7^⊥` exactly — an integral isometry
    `U ⊕ ⟨14⟩ ≅ ⟨−2⟩ ⊕ [[2, 1], [1, 4]]`. Consistent with the certificate's
    `det(v^⊥) = −v²·2n / div(v)² = 2·14/4 = 7`. -/
theorem root7Frame_det : root7Frame.det = -1 := by
  simp [root7Frame, det_fin_three]

theorem T7_splits_at_root7 :
    root7Frameᵀ * T7 * root7Frame = !![-2, 0, 0; 0, 2, 1; 0, 1, 4] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root7Frame, T7, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- NEGATIVE CONTROL (non-vacuity of `root7_perp_iff`): `e = ![1, 0, 0]` is *not* orthogonal to
    `root7` (pairing `−4`), and indeed `![1, 0, 0]` is not of the form `![a, 2a − 7b, b]`. -/
theorem root7_e_not_perp : pairing T7 ![1, 0, 0] root7 = -4 := by
  simp [pairing, root7, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- NEGATIVE CONTROL: the two (−2)-classes are not orthogonal to each other
    (`⟨e − f, root7⟩ = −6`), so `root7` does not lie in the Fricke complement. -/
theorem rootEF_root7_pairing : pairing T7 rootEF root7 = -6 := by
  simp [pairing, rootEF, root7, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3c. THE AM-8 SELECTED ROWS: the z = ∞ classes, s₇ → A₂, s₁₀ → ⟨2⟩⊕⟨2⟩ ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-! **AM-8 (T0, 2026-09-28)** adopted the C6 selector "minimal `|disc T|` within each register
    family" (`K3_CRITERIA.md`, mirror pinned at sha256 `7af500a7…`; record K3-DarkMatter
    `briefs/T0_DECISIONS_2026_09_28_STREAM2.md`, comparison
    `briefs/STREAM2_AM8_SELECTOR_COMPARISON_2026_09_28.md`). Per family it picks the `z = ∞` row of
    `CM_POINTS_RHO20.json` (sha256 `1ef6d622…`): cooper_s7 → `T = A₂` (`D = −3`), cooper_s10
    (ADVISORY, lattice certificate DRAFT) → `T = ⟨2⟩ ⊕ ⟨2⟩` (`D = −4`).

    This section is the **lattice half of those two rows**, same pattern as §3b: norm, exact
    complement as an `↔`, Gram matrix, the certificate's `div(v)`, and the index of `v ⊕ v^⊥`.
    LeanMaster states the same rows independently (`DualScaleDyons/RankJump.lean` at their commit
    `73f6fb1`: `s7_z_infinity`, `s7_z_infinity_index`, `s10_z_infinity`, proved by `decide +kernel`).
    Their statements were **read here** (not built here) on 2026-09-28: same vectors, same complement
    bases `(1,1,0),(−2,3,1)` and `(1,1,0),(−3,3,1)`, same Grams `[[2,1],[1,2]]` and `[[2,0],[0,2]]`,
    same frame determinant 3 for s₇. Each file is kernel-checked in its own repository; the
    comparison between them is at the level of statements.

    Not certified here, and not claimed: the selection itself (a T0 text, not a theorem); that the
    class is algebraic at the recognised `τ` and that `z = ∞` is the point at infinity of the family
    (Tier B); that `v^⊥` is the transcendental lattice (Tier L, Dolgachev/Doran); any ranking of s₇
    against s₁₀ (AM-8 forbids it); any physical reading (ledger item 4). The s₁₀ lattice `U ⊕ ⟨20⟩`
    is taken from a DRAFT certificate: the arithmetic below is exact for that lattice, but whether
    that lattice is s₁₀'s is ADVISORY (D6′). -/

-- ── s₇, the selected row ──────────────────────────────────────────────────────

/-- **The AM-8 class for cooper_s7**, coordinates `![14, -14, -5]` in `U ⊕ ⟨14⟩`.
    -- Source: `CM_POINTS_RHO20.json`, `families.cooper_s7.rows`, row `v = [14,-14,-5]`
    (`minus_v2 = 42`, `div_v = 14`, `D = -3`, `det_T_X = 3`, `T_X_reduced_form_abc = [1,1,1]`,
    `T_X_kernel_basis = [[1,1,0],[0,5,1]]`, `z_value_if_rational = infinity`,
    `singular_locus_match = infinity`). The `τ = −5/14 + i√3/14` and `z = ∞` are Tier B. -/
def root7Inf : Fin 3 → ℤ := ![14, -14, -5]

theorem root7Inf_norm : latticeNorm T7 root7Inf = -42 := by
  simp [latticeNorm, root7Inf, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- The pairing with the class is `14·(−x₀ + x₁ − 5x₂)`: every pairing is divisible by 14. -/
theorem root7Inf_pairing_formula (x : Fin 3 → ℤ) :
    pairing T7 x root7Inf = 14 * (-x 0 + x 1 - 5 * x 2) := by
  simp [pairing, root7Inf, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]; ring

/-- `div(v) = 14` — the certificate's `div_v`, as the two halves of a gcd: 14 divides every
    pairing (`root7Inf_pairing_formula`) and the pairing with `e` is exactly `−14`. -/
theorem root7Inf_div (x : Fin 3 → ℤ) : (14 : ℤ) ∣ pairing T7 x root7Inf :=
  ⟨_, root7Inf_pairing_formula x⟩

theorem root7Inf_pairing_e : pairing T7 ![1, 0, 0] root7Inf = -14 := by
  simp [pairing, root7Inf, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- **The exact complement:** `x ⊥ root7Inf ↔ x = a·(1,1,0) + b·(0,5,1)` — the certificate's
    `T_X_kernel_basis`, verbatim. -/
theorem root7Inf_perp_iff (x : Fin 3 → ℤ) :
    pairing T7 x root7Inf = 0 ↔ ∃ a b : ℤ, x = ![a, a + 5 * b, b] := by
  rw [root7Inf_pairing_formula]
  constructor
  · intro h
    refine ⟨x 0, x 2, ?_⟩
    ext i; fin_cases i <;> simp <;> omega
  · rintro ⟨a, b, rfl⟩
    simp

/-- The certificate's kernel basis, as columns `(1,1,0)`, `(0,5,1)`. -/
def root7InfPerpBasis : Matrix (Fin 3) (Fin 2) ℤ := !![1, 0; 1, 5; 0, 1]

theorem root7Inf_perp_gram : root7InfPerpBasisᵀ * T7 * root7InfPerpBasis = !![2, 5; 5, 14] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root7InfPerpBasis, T7, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Gauss-reduced basis `(1,1,0)`, `(−2,3,1)` of the same complement. -/
def root7InfPerpReduced : Matrix (Fin 3) (Fin 2) ℤ := !![1, -2; 1, 3; 0, 1]

/-- The unimodular change of basis (determinant 1) from the certificate's basis to the reduced one. -/
def root7InfPerpChange : Gram 2 := !![1, -2; 0, 1]

theorem root7Inf_perp_bases_related :
    root7InfPerpBasis * root7InfPerpChange = root7InfPerpReduced := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root7InfPerpBasis, root7InfPerpReduced, root7InfPerpChange, Matrix.mul_apply,
      Fin.sum_univ_succ]

theorem root7Inf_perp_change_det : root7InfPerpChange.det = 1 := by
  simp [root7InfPerpChange, det_fin_two]

/-- **`root7Inf^⊥ ≅ A₂ = [[2, 1], [1, 2]]`**, the form `x² + xy + y²` of discriminant `−3`
    (`T_X_reduced_form_abc = [1,1,1]`). -/
theorem root7Inf_perp_reduced_gram :
    root7InfPerpReducedᵀ * T7 * root7InfPerpReduced = !![2, 1; 1, 2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root7InfPerpReduced, T7, TN, Matrix.mul_apply, Fin.sum_univ_succ]

theorem root7Inf_perp_reduced_det : (!![2, 1; 1, 2] : Gram 2).det = 3 := by
  simp [det_fin_two]

/-- The frame `(root7Inf, (1,1,0), (−2,3,1))`. -/
def root7InfFrame : Gram 3 := !![14, 1, -2; -14, 1, 3; -5, 0, 1]

/-- **Index 3:** `⟨root7Inf⟩ ⊕ root7Inf^⊥` has index 3 in `U ⊕ ⟨14⟩`, consistent with the
    certificate's `det(v^⊥)·v² = −2N·det(frame)²`: `3·(−42) = −14·9`. -/
theorem root7InfFrame_det : root7InfFrame.det = 3 := by
  simp [root7InfFrame, det_fin_three]

theorem T7_splits_at_root7Inf :
    root7InfFrameᵀ * T7 * root7InfFrame = !![-42, 0, 0; 0, 2, 1; 0, 1, 2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root7InfFrame, T7, TN, Matrix.mul_apply, Fin.sum_univ_succ]

-- ── s₁₀, the selected row (ADVISORY family; lattice certificate DRAFT) ────────

/-- `U ⊕ ⟨20⟩`, the lattice of cooper_s10's **DRAFT** certificate `C2_cooper_s10_v4_DRAFT.json`
    (D6′: ADVISORY). Everything below is exact arithmetic in this lattice; that this lattice is
    s₁₀'s is not certified anywhere yet. -/
def T10 : Gram 3 := TN 10

theorem T10_det : T10.det = -20 := by rw [T10, TN_det]; norm_num

/-- **The AM-8 class for cooper_s10**, coordinates `![10, -10, -3]` in `U ⊕ ⟨20⟩`.
    -- Source: `CM_POINTS_RHO20.json`, `families.cooper_s10.rows`, row `v = [10,-10,-3]`
    (`minus_v2 = 20`, `div_v = 10`, `D = -4`, `det_T_X = 4`, `T_X_reduced_form_abc = [1,0,1]`,
    `T_X_kernel_basis = [[1,1,0],[0,6,1]]`, `z = infinity`, flag `LATTICE_CERT_DRAFT`). -/
def root10Inf : Fin 3 → ℤ := ![10, -10, -3]

theorem root10Inf_norm : latticeNorm T10 root10Inf = -20 := by
  simp [latticeNorm, root10Inf, T10, TN, dotProduct, mulVec, Fin.sum_univ_succ]

theorem root10Inf_pairing_formula (x : Fin 3 → ℤ) :
    pairing T10 x root10Inf = 10 * (-x 0 + x 1 - 6 * x 2) := by
  simp [pairing, root10Inf, T10, TN, dotProduct, mulVec, Fin.sum_univ_succ]; ring

/-- `div(v) = 10`, as for s₇: 10 divides every pairing and the pairing with `e` is `−10`. -/
theorem root10Inf_div (x : Fin 3 → ℤ) : (10 : ℤ) ∣ pairing T10 x root10Inf :=
  ⟨_, root10Inf_pairing_formula x⟩

theorem root10Inf_pairing_e : pairing T10 ![1, 0, 0] root10Inf = -10 := by
  simp [pairing, root10Inf, T10, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- **The exact complement:** `x ⊥ root10Inf ↔ x = a·(1,1,0) + b·(0,6,1)`. -/
theorem root10Inf_perp_iff (x : Fin 3 → ℤ) :
    pairing T10 x root10Inf = 0 ↔ ∃ a b : ℤ, x = ![a, a + 6 * b, b] := by
  rw [root10Inf_pairing_formula]
  constructor
  · intro h
    refine ⟨x 0, x 2, ?_⟩
    ext i; fin_cases i <;> simp <;> omega
  · rintro ⟨a, b, rfl⟩
    simp

def root10InfPerpBasis : Matrix (Fin 3) (Fin 2) ℤ := !![1, 0; 1, 6; 0, 1]

theorem root10Inf_perp_gram :
    root10InfPerpBasisᵀ * T10 * root10InfPerpBasis = !![2, 6; 6, 20] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root10InfPerpBasis, T10, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Reduced basis `(1,1,0)`, `(−3,3,1)`. -/
def root10InfPerpReduced : Matrix (Fin 3) (Fin 2) ℤ := !![1, -3; 1, 3; 0, 1]

def root10InfPerpChange : Gram 2 := !![1, -3; 0, 1]

theorem root10Inf_perp_bases_related :
    root10InfPerpBasis * root10InfPerpChange = root10InfPerpReduced := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root10InfPerpBasis, root10InfPerpReduced, root10InfPerpChange, Matrix.mul_apply,
      Fin.sum_univ_succ]

theorem root10Inf_perp_change_det : root10InfPerpChange.det = 1 := by
  simp [root10InfPerpChange, det_fin_two]

/-- **`root10Inf^⊥ ≅ ⟨2⟩ ⊕ ⟨2⟩`**, the form `x² + y²` of discriminant `−4`
    (`T_X_reduced_form_abc = [1,0,1]`). -/
theorem root10Inf_perp_reduced_gram :
    root10InfPerpReducedᵀ * T10 * root10InfPerpReduced = !![2, 0; 0, 2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root10InfPerpReduced, T10, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The frame `(root10Inf, (1,1,0), (−3,3,1))`. -/
def root10InfFrame : Gram 3 := !![10, 1, -3; -10, 1, 3; -3, 0, 1]

/-- **Index 2:** `4·(−20) = −20·2²`. -/
theorem root10InfFrame_det : root10InfFrame.det = 2 := by
  simp [root10InfFrame, det_fin_three]

theorem T10_splits_at_root10Inf :
    root10InfFrameᵀ * T10 * root10InfFrame = !![-20, 0, 0; 0, 2, 0; 0, 0, 2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [root10InfFrame, T10, TN, Matrix.mul_apply, Fin.sum_univ_succ]

/-- NEGATIVE CONTROL: the AM-8 class of s₇ is not orthogonal to either §3b wall class
    (`⟨e−f, root7Inf⟩ = −28`, `⟨root7, root7Inf⟩ = −154 = 14·(−11)`), so the three complements are
    three different sublattices, as their discriminants `28, 7, 3` already force.
    (Disclosure: the first draft of this docstring said `−42`; the kernel rejected it. The hand
    value was wrong, the statement below is the one that compiles.) -/
theorem rootEF_root7Inf_pairing : pairing T7 rootEF root7Inf = -28 := by
  simp [pairing, rootEF, root7Inf, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

theorem root7_root7Inf_pairing : pairing T7 root7 root7Inf = -154 := by
  simp [pairing, root7, root7Inf, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- Signature of `U ⊕ ⟨2N⟩` for `N > 0`. Backed by `TN_diagonalises` above
    (modulo Sylvester's law, Tier L) rather than merely asserted. -/
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
