/-
  Agora/Geometry/Occurrence.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE OCCURRENCE CRITERION — the arithmetic half, machine-proved.

  Requested by Stream 2, brief
  `briefs/STREAM2_TO_STREAMS1_3_LEANMASTER_RESULTS_AND_DIRECTIONS_2026_09_21.md`
  §2 direction 1 (their R3, `A2_MEMBERSHIP`), and their highest-priority ask.

  THE CLAIM BEING FORMALIZED. For `v = (x, y, z) ∈ T_N = U ⊕ ⟨2N⟩` with `v² < 0`
  and divisibility `d = div(v)`, the rank-2 lattice `v^⊥` has

      det(v^⊥) = (−v²) · 2N / d²          and hence discriminant
      D = −det(v^⊥) = 2N · v² / d²,   with   D ≡ (2Nz/d)²  (mod 4N).

  So a discriminant `D` can occur in the level-`N` family only if it is a square
  modulo `4N`.

  ────────────────────────────────────────────────────────────────────────────────
  WHAT IS PROVED, AND THE FINDING THAT CAME WITH IT

  §1  `occurrence_identity` — the congruence is an EXACT identity,
          D − m² = 4N · x′y′,     where  x = d·x′,  y = d·y′,  m·d = 2Nz.
      Stated with all divisions cleared, so there is no `ℤ`-division anywhere.
  §2  `occurrence_congruence` — hence `4N ∣ D − m²`.

  ⭐ **The finding.** Stream 2's brief says their leg (A) "rests on three sympy
  identities plus a three-line primitivity argument that is *not*
  machine-proved — that is the gap a Lean statement would close". For the
  congruence, **that primitivity argument is not needed at all.** The identity
  uses only `d ∣ x` and `d ∣ y`, which hold for ANY common divisor `d` of `x` and
  `y` — primitive `v` or not, `d = div(v)` or not. `occurrence_needs_divisibility`
  (§5) shows those two hypotheses cannot be dropped, so this is exactly the right
  generality: the gap closes by becoming unnecessary rather than by being filled.

  §3  The s₇ witness `(14, −14, 5) ∈ U ⊕ ⟨14⟩`: `v² = −42`, `d = 14`, `D = −3`,
      `m = 5`. `D = −3` is the discriminant of `A₂`.
  §4  `A2_not_in_s10_family` — `−3` is not a square modulo `40`, so `A₂` cannot
      occur in the `N = 10` family, for any vector.
  §5  Negative controls.

  ────────────────────────────────────────────────────────────────────────────────
  WHAT IS **NOT** PROVED HERE — read this before citing

  * **`det(v^⊥) = (−v²)·2N/d²` is NOT proved.** It is the standard formula for the
    orthogonal complement of a vector in a lattice of determinant `−2N`, and it IS
    where primitivity and `d = div(v)` genuinely enter. This file takes
    `D·d² = 2N·v²` as a HYPOTHESIS. So what is machine-checked is: *if* `D` is
    related to `v` by that formula, *then* `D` is a square mod `4N`. The geometry
    that produces the formula is literature, not Lean.
  * `v^⊥` is never constructed as a lattice. No rank-2 Gram matrix appears, and no
    isometry `v^⊥ ≅ A₂` is proved — §3 exhibits the *numbers* `(−42, 14, −3, 5)`
    and checks the identity on them; it does not show `(14,−14,5)^⊥` is `A₂`.
  * The CONVERSE ("every `D ≡ □ mod 4N` is realised by an explicit witness") is
    not attempted.
  * Nothing here concerns physics (VISION §1.3, F5b).

  ────────────────────────────────────────────────────────────────────────────────
  **Disclosure — the list above is SUPERSEDED for §6–§9 (added the next day).**
  §1–§5 were written first and their caveats were true of them. §6–§9 then took a
  different route, and three of the four "NOT proved" items no longer hold:

  §6  `binary_disc_identity` — for ANY two vectors `u₁, u₂` of `U ⊕ ⟨2N⟩`,
          −det Gram(u₁,u₂) = p₃² + 4N·p₁p₂,      p = u₁ × u₂,
      a polynomial identity with no hypotheses (it is `det(UᵀGU) = pᵀ·adj(G)·p`).
      Hence `binary_disc_square_mod`: the discriminant of EVERY rank-2 sublattice
      is a square mod `4N` — no `v`, no primitivity, no divisibility, and no
      determinant formula. `disc_realised` supplies the converse with the explicit
      witness `(−k,1,0), (−m,0,1)`, and `disc_occurs_iff` packages both.
      ⇒ the CONVERSE is now proved, and the criterion no longer rests on any
        hypothesis at all.
  §7  `complement_det_of_certificate` — `d²·det Gram = −2N·v²` whenever
      `d·(u₁ × u₂) = G·v`. ⇒ the DETERMINANT FORMULA is now proved, from a basis
      certificate.
  §8  `s7_complement_is_A2` — `(14,−14,5)^⊥` CONSTRUCTED: basis `(1,1,0)`,
      `(−3,2,−1)`, Gram exactly `A₂`, both orthogonal to the vector, and every
      orthogonal integer vector an explicit integer combination of the two.
  §9  `no_det_three_in_T10` — no pair in `U ⊕ ⟨20⟩` has Gram determinant 3, so
      `A₂` does not embed there in ANY way. UNCONDITIONAL; §4's caveat that the
      exclusion was "a conditional, not a theorem" no longer applies to it.

  STILL NOT PROVED: that for a general primitive `v` of divisibility `d`, every
  ℤ-basis of `v^⊥` satisfies the certificate `d·(u₁×u₂) = ±G·v` (the classical
  saturation fact). It is exhibited for the s₇ vector only. So the determinant
  formula is a theorem *about certified bases*, and that certified bases always
  exist is literature. Nothing here concerns physics.

  ────────────────────────────────────────────────────────────────────────────────
  **Disclosure — the "STILL NOT PROVED" paragraph above is SUPERSEDED by §10.**
  It said the existence of a certified basis for a general `v` was literature.
  §10 proves it:

  §10 `every_vector_is_cross` — every integer vector is a cross product (Bezout).
      `saturated_of_primitive_cross` — Cramer's rule in dimension 3: if `r·p = 1`
      and `u·p = 0` with `p = u₁ × u₂`, then
      `u = −[u,r,u₂]·u₁ + [u,r,u₁]·u₂`, integer coefficients. A primitive cross
      product FORCES the pair to be a ℤ-basis of the whole orthogonal lattice.
      `complement_general` — for EVERY `v` with `G·v = d·n′`, `d ≠ 0`, `n′`
      primitive: `v^⊥` has a ℤ-basis, orthogonal to `v`, saturated, with
      `d²·det = −2N·v²`. Primitivity of `v` itself is never used.
      `gram_det_basis_independent` — two bases of the same nondegenerate lattice
      have equal Gram determinant, so `det(v^⊥)` belongs to the lattice and not
      to the basis the Bezout construction happened to produce.

  WHAT REMAINS OUTSIDE THIS FILE, precisely: (i) that the hypothesis
  "`G·v = d·n′` with `n′` primitive" holds with `d = gcd(x, y, 2Nz)` — true by the
  definition of gcd, not stated here as a lemma; (ii) which point of the family a
  given vector corresponds to (Stream 2's R2); (iii) anything about physics.

  0 sorry. Axioms: Lean's standard ones only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Geometry.MnLattice

namespace Agora.Geometry.Occurrence

open Matrix DualScaleStream2.Lattice Agora.Geometry.MnLattice

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §0. THE NORM ON T_N, WRITTEN OUT                                   ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The norm of `v = x·e + y·f + z·w` in `T_N = U ⊕ ⟨2N⟩` is `2xy + 2Nz²`.
    Stated so that the `v²` appearing in §1 is visibly this repository's
    `latticeNorm` and not a formula typed from memory. -/
theorem TN_norm (N x y z : ℤ) :
    latticeNorm (TN N) ![x, y, z] = 2 * x * y + 2 * N * z ^ 2 := by
  simp [latticeNorm, TN, dotProduct, mulVec, Fin.sum_univ_succ]; ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1–§2. THE IDENTITY AND THE CONGRUENCE                             ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **THE OCCURRENCE IDENTITY.** With `x = d·x′`, `y = d·y′`, and with `D` and `m`
    defined by the division-free relations `D·d² = 2N·v²` and `m·d = 2Nz`,

        D − m² = 4N · x′y′        exactly.

    No primitivity hypothesis, and `d` need not be `div(v)` — any common divisor
    of `x` and `y` for which `m` and `D` are integral will do.

    -- Source: Stream 2 brief (above), R3 / direction 1. Their congruence
    `D ≡ (2Nz/d)² mod 4N` is `occurrence_congruence` below. -/
theorem occurrence_identity (N d x' y' z D m : ℤ) (hd : d ≠ 0)
    (hD : D * d ^ 2 = 2 * N * (2 * (d * x') * (d * y') + 2 * N * z ^ 2))
    (hm : m * d = 2 * N * z) :
    D - m ^ 2 = 4 * N * (x' * y') := by
  have h : (D - m ^ 2) * d ^ 2 = (4 * N * (x' * y')) * d ^ 2 := by
    linear_combination hD - (m * d + 2 * N * z) * hm
  exact mul_right_cancel₀ (pow_ne_zero 2 hd) h

/-- **The occurrence criterion, arithmetic half:** `D ≡ m² (mod 4N)`. A
    discriminant occurring in the level-`N` family is a square modulo `4N`. -/
theorem occurrence_congruence (N d x' y' z D m : ℤ) (hd : d ≠ 0)
    (hD : D * d ^ 2 = 2 * N * (2 * (d * x') * (d * y') + 2 * N * z ^ 2))
    (hm : m * d = 2 * N * z) :
    (4 * N) ∣ (D - m ^ 2) :=
  ⟨x' * y', occurrence_identity N d x' y' z D m hd hD hm⟩

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE s₇ WITNESS                                                 ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `(14, −14, 5) ∈ U ⊕ ⟨14⟩` has norm `−42`. (Also `ModularAction.g3_fixed_norm`,
    where this vector is the fixed vector of the order-3 stabilizer.) -/
theorem s7_witness_norm : latticeNorm T7 ![14, -14, 5] = -42 := by
  simp [latticeNorm, T7, TN, dotProduct, mulVec, Fin.sum_univ_succ]

/-- The witness satisfies the two defining relations with
    `d = 14`, `x′ = 1`, `y′ = −1`, `D = −3`, `m = 5`. `D = −3` is the
    discriminant of `A₂`.
    ⚠️ This checks the NUMBERS. It does not construct `(14,−14,5)^⊥` or show it
    is isometric to `A₂` (header). -/
theorem s7_witness_relations :
    (-3 : ℤ) * 14 ^ 2 = 2 * 7 * (2 * (14 * 1) * (14 * (-1)) + 2 * 7 * 5 ^ 2)
      ∧ (5 : ℤ) * 14 = 2 * 7 * 5 := by
  constructor <;> norm_num

/-- So the criterion holds on the witness: `−3 − 5² = −28 = 4·7·(1·(−1))`. -/
theorem s7_witness_occurs : (4 * 7 : ℤ) ∣ ((-3) - 5 ^ 2) :=
  occurrence_congruence 7 14 1 (-1) 5 (-3) 5 (by norm_num)
    s7_witness_relations.1 s7_witness_relations.2

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. A₂ DOES NOT OCCUR IN THE s₁₀ FAMILY                            ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **`−3` is not a square modulo `40`.** So by the criterion, the discriminant
    of `A₂` cannot occur in the level-`10` family `U ⊕ ⟨20⟩` — for any vector.

    -- Source: Stream 2 brief, direction 1: "`¬ ∃ v, v^⊥ ≅ A₂` in `U ⊕ ⟨20⟩`
    (−3 is not a square mod 40)".
    ⚠️ What is proved is the arithmetic obstruction. Turning it into
    "`¬ ∃ v, v^⊥ ≅ A₂`" needs the determinant formula of the header, which is
    NOT proved here; the combination is a conditional, not a theorem. -/
theorem A2_not_in_s10_family : ¬ ∃ k : ZMod 40, k ^ 2 = (-3 : ZMod 40) := by decide

/-- By contrast `−3` IS a square modulo `28`: `5² = 25 ≡ −3`. So the criterion
    *permits* `A₂` at level `7`, consistently with the witness of §3. -/
theorem A2_permitted_in_s7_family : ∃ k : ZMod 28, k ^ 2 = (-3 : ZMod 28) :=
  ⟨5, by decide⟩

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §5. NEGATIVE CONTROLS                                              ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **CONTROL 1: `d ∣ x` and `d ∣ y` cannot be dropped.** At
    `N = 2, d = 2, x = 1, y = 2, z = 1` the two defining relations hold
    (`D = 8`, `m = 2`) but `4N = 8` does **not** divide `D − m² = 4`. Here
    `d ∤ x`. So `occurrence_congruence` is not true of arbitrary `(D, m)` tied to
    `v` by those relations: the divisibility of `x` and `y` is load-bearing, and
    it is the *only* thing that is. -/
theorem occurrence_needs_divisibility :
    (8 : ℤ) * 2 ^ 2 = 2 * 2 * (2 * 1 * 2 + 2 * 2 * 1 ^ 2) ∧ (2 : ℤ) * 2 = 2 * 2 * 1
      ∧ ¬ ((4 * 2 : ℤ) ∣ (8 - 2 ^ 2)) := by
  refine ⟨by norm_num, by norm_num, by decide⟩

/-- **CONTROL 2: the criterion discriminates.** It permits `A₂` at level 7 and
    forbids it at level 10, so it is not vacuously true of every level. -/
theorem criterion_discriminates :
    (∃ k : ZMod 28, k ^ 2 = (-3 : ZMod 28)) ∧ ¬ ∃ k : ZMod 40, k ^ 2 = (-3 : ZMod 40) :=
  ⟨A2_permitted_in_s7_family, A2_not_in_s10_family⟩

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §6. THE LAGRANGE IDENTITY — the criterion made UNCONDITIONAL       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The bilinear form of `T_N = U ⊕ ⟨2N⟩`. -/
def pairing (N : ℤ) (u u' : Fin 3 → ℤ) : ℤ := u ⬝ᵥ (TN N *ᵥ u')

/-- Gram matrix of the pair `(u₁, u₂)` inside `T_N`. -/
def gram2 (N : ℤ) (u₁ u₂ : Fin 3 → ℤ) : Matrix (Fin 2) (Fin 2) ℤ :=
  !![pairing N u₁ u₁, pairing N u₁ u₂; pairing N u₂ u₁, pairing N u₂ u₂]

/-- The ordinary cross product in coordinates. `u₁ × u₂` is Euclidean-orthogonal
    to both, and `u ⟂ v` in `T_N` means `u` is Euclidean-orthogonal to `G·v`; so
    for a basis of `v^⊥` the cross product is proportional to `G·v`. -/
def cross (u₁ u₂ : Fin 3 → ℤ) : Fin 3 → ℤ :=
  ![u₁ 1 * u₂ 2 - u₁ 2 * u₂ 1, u₁ 2 * u₂ 0 - u₁ 0 * u₂ 2, u₁ 0 * u₂ 1 - u₁ 1 * u₂ 0]

/-- The pairing, written out. -/
theorem pairing_eq (N : ℤ) (u u' : Fin 3 → ℤ) :
    pairing N u u' = u 0 * u' 1 + u 1 * u' 0 + 2 * N * (u 2 * u' 2) := by
  simp [pairing, TN, dotProduct, mulVec, Fin.sum_univ_succ]; ring

/-- **THE GENERALIZED LAGRANGE IDENTITY FOR `T_N`.** For ANY two vectors,

        −det Gram(u₁, u₂) = p₃² + 4N · p₁p₂,        p = u₁ × u₂.

    It is `det(UᵀGU) = pᵀ·adj(G)·p` with `adj(TN N) = [[0,−2N,0],[−2N,0,0],[0,0,−1]]`.
    No `v`, no primitivity, no divisibility, no definiteness: a polynomial
    identity in six variables and `N`. -/
theorem binary_disc_identity (N : ℤ) (u₁ u₂ : Fin 3 → ℤ) :
    -(gram2 N u₁ u₂).det
      = (cross u₁ u₂ 2) ^ 2 + 4 * N * (cross u₁ u₂ 0 * cross u₁ u₂ 1) := by
  simp only [gram2, Matrix.det_fin_two_of, pairing_eq, cross, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons]
  ring

/-- **THE OCCURRENCE CRITERION, UNCONDITIONAL.** The discriminant `−det` of EVERY
    rank-2 sublattice of `U ⊕ ⟨2N⟩` — saturated or not, an orthogonal complement
    or not — is a square modulo `4N`. This supersedes `occurrence_congruence`,
    which needed the determinant formula as a hypothesis; this needs nothing. -/
theorem binary_disc_square_mod (N : ℤ) (u₁ u₂ : Fin 3 → ℤ) :
    (4 * N) ∣ (-(gram2 N u₁ u₂).det - (cross u₁ u₂ 2) ^ 2) :=
  ⟨cross u₁ u₂ 0 * cross u₁ u₂ 1, by rw [binary_disc_identity]; ring⟩

/-- **The converse, with an explicit witness.** Every `D = m² + 4N·k` — i.e. every
    `D` that is a square mod `4N` — is the discriminant of a rank-2 sublattice,
    namely the span of `(−k, 1, 0)` and `(−m, 0, 1)`; its cross product is
    `(1, k, m)`, which is primitive. -/
theorem disc_realised (N m k : ℤ) :
    -(gram2 N ![-k, 1, 0] ![-m, 0, 1]).det = m ^ 2 + 4 * N * k
      ∧ cross ![-k, 1, 0] ![-m, 0, 1] = ![1, k, m] := by
  constructor
  · rw [binary_disc_identity]; simp [cross]
  · ext i; fin_cases i <;> simp [cross]

/-- **The criterion as an IFF:** `D` is the discriminant of some pair in
    `U ⊕ ⟨2N⟩` iff `D ≡ □ (mod 4N)`. -/
theorem disc_occurs_iff (N D : ℤ) :
    (∃ u₁ u₂ : Fin 3 → ℤ, -(gram2 N u₁ u₂).det = D) ↔ ∃ m k : ℤ, D = m ^ 2 + 4 * N * k := by
  constructor
  · rintro ⟨u₁, u₂, h⟩
    exact ⟨cross u₁ u₂ 2, cross u₁ u₂ 0 * cross u₁ u₂ 1, by rw [← h, binary_disc_identity]⟩
  · rintro ⟨m, k, rfl⟩
    exact ⟨_, _, (disc_realised N m k).1⟩

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §7. THE DETERMINANT FORMULA, FROM A BASIS CERTIFICATE              ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- A pair whose cross product is proportional to `G·v` is orthogonal to `v`. -/
theorem orthogonal_of_certificate (N d : ℤ) (u₁ u₂ v : Fin 3 → ℤ) (hd : d ≠ 0)
    (hc : d • cross u₁ u₂ = TN N *ᵥ v) :
    pairing N u₁ v = 0 ∧ pairing N u₂ v = 0 := by
  have h0 : d * cross u₁ u₂ 0 = v 1 := by
    have := congrFun hc 0; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  have h1 : d * cross u₁ u₂ 1 = v 0 := by
    have := congrFun hc 1; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  have h2 : d * cross u₁ u₂ 2 = 2 * N * v 2 := by
    have := congrFun hc 2; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  have c0 : cross u₁ u₂ 0 = u₁ 1 * u₂ 2 - u₁ 2 * u₂ 1 := by simp [cross]
  have c1 : cross u₁ u₂ 1 = u₁ 2 * u₂ 0 - u₁ 0 * u₂ 2 := by simp [cross]
  have c2 : cross u₁ u₂ 2 = u₁ 0 * u₂ 1 - u₁ 1 * u₂ 0 := by simp [cross]
  constructor
  · apply mul_left_cancel₀ hd
    rw [pairing_eq, mul_zero]
    linear_combination (-(d * u₁ 0)) * h0 - d * u₁ 1 * h1 - d * u₁ 2 * h2
      + d ^ 2 * u₁ 0 * c0 + d ^ 2 * u₁ 1 * c1 + d ^ 2 * u₁ 2 * c2
  · apply mul_left_cancel₀ hd
    rw [pairing_eq, mul_zero]
    linear_combination (-(d * u₂ 0)) * h0 - d * u₂ 1 * h1 - d * u₂ 2 * h2
      + d ^ 2 * u₂ 0 * c0 + d ^ 2 * u₂ 1 * c1 + d ^ 2 * u₂ 2 * c2

/-- **THE DETERMINANT FORMULA**, division-free: if `d · (u₁ × u₂) = G·v` then

        d² · det Gram(u₁,u₂) = −2N · v².

    This is Stream 2's `det(v^⊥) = (−v²)·2N/d²`, and it discharges hypothesis
    `hD` of `occurrence_identity`.
    ⚠️ **Disclosure.** The hypothesis is a CERTIFICATE. That *every* ℤ-basis of
    `v^⊥`, for primitive `v` of divisibility `d`, satisfies `d·(u₁×u₂) = ±G·v` is
    the classical saturation fact; it is NOT proved here in general — only
    exhibited for the s₇ witness in §8. -/
theorem complement_det_of_certificate (N d : ℤ) (u₁ u₂ v : Fin 3 → ℤ)
    (hc : d • cross u₁ u₂ = TN N *ᵥ v) :
    d ^ 2 * (gram2 N u₁ u₂).det = -(2 * N) * pairing N v v := by
  have h0 : d * cross u₁ u₂ 0 = v 1 := by
    have := congrFun hc 0; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  have h1 : d * cross u₁ u₂ 1 = v 0 := by
    have := congrFun hc 1; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  have h2 : d * cross u₁ u₂ 2 = 2 * N * v 2 := by
    have := congrFun hc 2; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  have hid := binary_disc_identity N u₁ u₂
  rw [pairing_eq]
  linear_combination (-(d ^ 2)) * hid - 4 * N * d * (cross u₁ u₂ 0) * h1
    - 4 * N * (v 0) * h0 - (d * cross u₁ u₂ 2 + 2 * N * v 2) * h2

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §8. (14,−14,5)^⊥ IS A₂ — constructed, not asserted                 ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The root lattice `A₂`. -/
def A2 : Matrix (Fin 2) (Fin 2) ℤ := !![2, -1; -1, 2]

def w7 : Fin 3 → ℤ := ![14, -14, 5]
def a1 : Fin 3 → ℤ := ![1, 1, 0]
def a2 : Fin 3 → ℤ := ![-3, 2, -1]

/-- The Gram matrix of `(a₁, a₂)` in `U ⊕ ⟨14⟩` is exactly `A₂`. -/
theorem s7_complement_gram : gram2 7 a1 a2 = A2 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [gram2, A2, a1, a2, pairing_eq]

/-- The certificate: `14 · (a₁ × a₂) = G·(14,−14,5)`, and `a₁ × a₂ = (−1,1,5)` is
    primitive. -/
theorem s7_complement_certificate : (14 : ℤ) • cross a1 a2 = TN 7 *ᵥ w7 := by
  ext i
  fin_cases i <;> simp [cross, a1, a2, w7, TN, mulVec, dotProduct, Fin.sum_univ_succ]

/-- **Saturation, proved for this witness:** every integer vector orthogonal to
    `(14,−14,5)` in `U ⊕ ⟨14⟩` is an integer combination of `a₁, a₂`, with
    explicit coefficients. So `(a₁, a₂)` is a ℤ-basis of the full orthogonal
    complement, not merely of a finite-index sublattice of it. -/
theorem s7_complement_saturated (u : Fin 3 → ℤ) (h : pairing 7 u w7 = 0) :
    u = (u 0 - 3 * u 2) • a1 + (-(u 2)) • a2 := by
  rw [pairing_eq] at h
  have h' : u 1 = u 0 - 5 * u 2 := by
    simp [w7] at h; linarith
  ext i
  fin_cases i <;> simp [a1, a2, h'] <;> ring

/-- Conversely `a₁, a₂` are orthogonal to the witness. -/
theorem s7_complement_orthogonal : pairing 7 a1 w7 = 0 ∧ pairing 7 a2 w7 = 0 :=
  orthogonal_of_certificate 7 14 a1 a2 w7 (by norm_num) s7_complement_certificate

/-- **`(14,−14,5)^⊥ ≅ A₂` in `U ⊕ ⟨14⟩`**, assembled: a ℤ-basis of the whole
    orthogonal complement whose Gram matrix is `A₂`. This is Stream 2's R2/R3
    statement "`T_X = A₂` at `z = ∞`" at the level of lattices. It says nothing
    about which point of the family the vector corresponds to — that is theirs. -/
theorem s7_complement_is_A2 :
    gram2 7 a1 a2 = A2
      ∧ (pairing 7 a1 w7 = 0 ∧ pairing 7 a2 w7 = 0)
      ∧ ∀ u : Fin 3 → ℤ, pairing 7 u w7 = 0 → ∃ s t : ℤ, u = s • a1 + t • a2 :=
  ⟨s7_complement_gram, s7_complement_orthogonal,
    fun u h => ⟨_, _, s7_complement_saturated u h⟩⟩

/-- The determinant formula on the witness: `14² · 3 = −14 · (−42)`. -/
theorem s7_complement_det : (14 : ℤ) ^ 2 * (gram2 7 a1 a2).det = -(2 * 7) * pairing 7 w7 w7 :=
  complement_det_of_certificate 7 14 a1 a2 w7 s7_complement_certificate

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §9. NO A₂ AT LEVEL 10 — now UNCONDITIONAL                          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **No pair of vectors in `U ⊕ ⟨20⟩` has Gram determinant 3.** In particular
    neither `A₂` nor `A₂(−1)` embeds in `U ⊕ ⟨20⟩` — as an orthogonal complement
    or in any other way, primitively or not. This is Stream 2's requested
    "`¬ ∃ v, v^⊥ ≅ A₂`", strengthened, and with NO unproved hypothesis: §4's
    caveat about the determinant formula no longer applies to it. -/
theorem no_det_three_in_T10 : ¬ ∃ u₁ u₂ : Fin 3 → ℤ, (gram2 10 u₁ u₂).det = 3 := by
  rintro ⟨u₁, u₂, h⟩
  have hid := binary_disc_identity 10 u₁ u₂
  rw [h] at hid
  have h2 : (cross u₁ u₂ 2) ^ 2 = -3 - 40 * (cross u₁ u₂ 0 * cross u₁ u₂ 1) := by
    linear_combination -hid
  have hz := congrArg (Int.cast : ℤ → ZMod 40) h2
  push_cast at hz
  have h40 : (40 : ZMod 40) = 0 := by decide
  rw [h40, zero_mul, sub_zero] at hz
  exact A2_not_in_s10_family ⟨_, hz⟩

theorem no_A2_in_T10 : ¬ ∃ u₁ u₂ : Fin 3 → ℤ, gram2 10 u₁ u₂ = A2 := by
  rintro ⟨u₁, u₂, h⟩
  exact no_det_three_in_T10 ⟨u₁, u₂, by rw [h]; simp [A2, Matrix.det_fin_two_of]⟩

/-- **NEGATIVE CONTROL.** The obstruction is about level 10, not about `gram2`:
    at level 7 a pair with Gram determinant 3 exists (§8). -/
theorem det_three_exists_in_T7 : ∃ u₁ u₂ : Fin 3 → ℤ, (gram2 7 u₁ u₂).det = 3 :=
  ⟨a1, a2, by rw [s7_complement_gram]; simp [A2, Matrix.det_fin_two_of]⟩

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §10. THE GENERAL CASE — saturation, for every vector               ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Euclidean dot product on `ℤ³`, in coordinates. -/
def dot3 (u w : Fin 3 → ℤ) : ℤ := u 0 * w 0 + u 1 * w 1 + u 2 * w 2

/-- **Cramer's rule in dimension 3, as saturation.** If the cross product
    `p = u₁ × u₂` is PRIMITIVE — witnessed by some `r` with `r·p = 1` — then every
    integer vector orthogonal to `p` is an integer combination of `u₁, u₂`, with
    the explicit coefficients `s = −[u, r, u₂]`, `t = [u, r, u₁]`.

    It is the four-vector identity
    `[r,u₁,u₂]·u − [u,u₁,u₂]·r + [u,r,u₂]·u₁ − [u,r,u₁]·u₂ = 0`.
    So a primitive cross product FORCES the pair to be a ℤ-basis of the whole
    orthogonal lattice; no finite-index ambiguity is possible. -/
theorem saturated_of_primitive_cross (u₁ u₂ r u : Fin 3 → ℤ)
    (hr : dot3 r (cross u₁ u₂) = 1) (hu : dot3 u (cross u₁ u₂) = 0) :
    u = (-(dot3 u (cross r u₂))) • u₁ + (dot3 u (cross r u₁)) • u₂ := by
  simp only [dot3, cross, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons] at hr hu
  have e0 : u 0 = (-(dot3 u (cross r u₂))) * u₁ 0 + (dot3 u (cross r u₁)) * u₂ 0 := by
    simp only [dot3, cross, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (-(u 0)) * hr + (r 0) * hu
  have e1 : u 1 = (-(dot3 u (cross r u₂))) * u₁ 1 + (dot3 u (cross r u₁)) * u₂ 1 := by
    simp only [dot3, cross, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (-(u 1)) * hr + (r 1) * hu
  have e2 : u 2 = (-(dot3 u (cross r u₂))) * u₁ 2 + (dot3 u (cross r u₁)) * u₂ 2 := by
    simp only [dot3, cross, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (-(u 2)) * hr + (r 2) * hu
  ext i
  fin_cases i
  · simpa using e0
  · simpa using e1
  · simpa using e2

/-- **Every integer vector is a cross product** (Bezout). With `g = gcd(a,b)`,
    `a = g·a′`, `b = g·b′`, `s·a′ + t·b′ = 1`:
    `(−cs, −ct, g) × (b′, −a′, 0) = (a, b, c)`. -/
theorem every_vector_is_cross (a b c : ℤ) :
    ∃ u₁ u₂ : Fin 3 → ℤ, cross u₁ u₂ = ![a, b, c] := by
  by_cases hg : (Int.gcd a b : ℤ) = 0
  · have h0 : Int.gcd a b = 0 := by exact_mod_cast hg
    obtain ⟨ha, hb⟩ := Int.gcd_eq_zero_iff.mp h0
    subst ha; subst hb
    exact ⟨![1, 0, 0], ![0, c, 0], by ext i; fin_cases i <;> simp [cross]⟩
  · obtain ⟨a', ha⟩ := Int.gcd_dvd_left a b
    obtain ⟨b', hb⟩ := Int.gcd_dvd_right a b
    have hbez := Int.gcd_eq_gcd_ab a b
    set g : ℤ := (Int.gcd a b : ℤ) with hgdef
    set s := Int.gcdA a b
    set t := Int.gcdB a b
    have h1 : s * a' + t * b' = 1 := by
      have : g * (s * a' + t * b') = g * 1 := by
        rw [mul_one]; linear_combination -hbez - s * ha - t * hb
      exact mul_left_cancel₀ hg this
    refine ⟨![-(c * s), -(c * t), g], ![b', -a', 0], ?_⟩
    ext i
    fin_cases i
    · simp [cross]; linarith [ha]
    · simp [cross]; linarith [hb]
    · simp [cross]; linear_combination c * h1

/-- The pairing with `v` is `d` times the Euclidean dot product with the
    primitive normal `n′`, when `G·v = d·n′`. -/
theorem pairing_eq_dot (N d : ℤ) (u v n' : Fin 3 → ℤ) (hn : d • n' = TN N *ᵥ v) :
    pairing N u v = d * dot3 u n' := by
  have h0 : d * n' 0 = v 1 := by
    have := congrFun hn 0; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  have h1 : d * n' 1 = v 0 := by
    have := congrFun hn 1; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  have h2 : d * n' 2 = 2 * N * v 2 := by
    have := congrFun hn 2; simpa [TN, mulVec, dotProduct, Fin.sum_univ_succ] using this
  rw [pairing_eq]; unfold dot3
  linear_combination (-(u 0)) * h0 - u 1 * h1 - u 2 * h2

/-- **THE GENERAL THEOREM.** Let `v ∈ U ⊕ ⟨2N⟩` with `G·v = d·n′`, `d ≠ 0`, and
    `n′` primitive (witness `r·n′ = 1`) — i.e. `d` is the divisibility of `v`.
    Then `v^⊥` has a ℤ-BASIS `u₁, u₂`: both orthogonal to `v`, every integer
    vector orthogonal to `v` an integer combination of them, and

        d² · det Gram(u₁,u₂) = −2N · v².

    This is Stream 2's `det(v^⊥) = (−v²)·2N/d²` for EVERY such `v`, not only
    the s₇ vector. It closes the item §7 left open: a certified basis always
    exists. Primitivity of `v` itself is never used — only that of `n′`. -/
theorem complement_general (N d : ℤ) (hd : d ≠ 0) (v n' r : Fin 3 → ℤ)
    (hn : d • n' = TN N *ᵥ v) (hr : dot3 r n' = 1) :
    ∃ u₁ u₂ : Fin 3 → ℤ,
      (pairing N u₁ v = 0 ∧ pairing N u₂ v = 0)
      ∧ (∀ u : Fin 3 → ℤ, pairing N u v = 0 → ∃ s t : ℤ, u = s • u₁ + t • u₂)
      ∧ d ^ 2 * (gram2 N u₁ u₂).det = -(2 * N) * pairing N v v := by
  obtain ⟨u₁, u₂, hc⟩ := every_vector_is_cross (n' 0) (n' 1) (n' 2)
  have hc' : cross u₁ u₂ = n' := by
    rw [hc]; ext i; fin_cases i <;> simp
  have hcert : d • cross u₁ u₂ = TN N *ᵥ v := by rw [hc']; exact hn
  refine ⟨u₁, u₂, orthogonal_of_certificate N d u₁ u₂ v hd hcert, ?_,
    complement_det_of_certificate N d u₁ u₂ v hcert⟩
  intro u hu
  have hdot : dot3 u n' = 0 := by
    have := pairing_eq_dot N d u v n' hn
    rw [hu] at this
    exact (mul_eq_zero.mp this.symm).resolve_left hd
  exact ⟨_, _, saturated_of_primitive_cross u₁ u₂ r u (by rw [hc']; exact hr)
    (by rw [hc']; exact hdot)⟩

/-- **Change of basis scales the Gram determinant by `(det M)²`.** -/
theorem gram_det_basis_change (N a b c e : ℤ) (u₁ u₂ : Fin 3 → ℤ) :
    (gram2 N (a • u₁ + b • u₂) (c • u₁ + e • u₂)).det
      = (a * e - b * c) ^ 2 * (gram2 N u₁ u₂).det := by
  simp only [gram2, Matrix.det_fin_two_of, pairing_eq, Pi.add_apply, Pi.smul_apply,
    smul_eq_mul]
  ring

/-- **The determinant does not depend on the basis.** If two pairs span the same
    lattice (each an integer combination of the other) and the form is
    nondegenerate on it, their Gram determinants agree. So "`det(v^⊥)`" in
    `complement_general` is a property of the lattice `v^⊥`, not of the basis the
    Bezout construction happened to produce. -/
theorem gram_det_basis_independent (N : ℤ) (u₁ u₂ w₁ w₂ : Fin 3 → ℤ) (a b c e a' b' c' e' : ℤ)
    (hw₁ : w₁ = a • u₁ + b • u₂) (hw₂ : w₂ = c • u₁ + e • u₂)
    (hu₁ : u₁ = a' • w₁ + b' • w₂) (hu₂ : u₂ = c' • w₁ + e' • w₂)
    (hnd : (gram2 N u₁ u₂).det ≠ 0) :
    (gram2 N w₁ w₂).det = (gram2 N u₁ u₂).det := by
  have hW : (gram2 N w₁ w₂).det = (a * e - b * c) ^ 2 * (gram2 N u₁ u₂).det := by
    rw [hw₁, hw₂]; exact gram_det_basis_change N a b c e u₁ u₂
  have hU : (gram2 N u₁ u₂).det = (a' * e' - b' * c') ^ 2 * (gram2 N w₁ w₂).det := by
    conv_lhs => rw [hu₁, hu₂]
    exact gram_det_basis_change N a' b' c' e' w₁ w₂
  have hk : (a * e - b * c) ^ 2 * (a' * e' - b' * c') ^ 2 = 1 := by
    have h := hU
    rw [hW] at h
    have h2 : ((a * e - b * c) ^ 2 * (a' * e' - b' * c') ^ 2) * (gram2 N u₁ u₂).det
        = 1 * (gram2 N u₁ u₂).det := by linear_combination -h
    exact mul_right_cancel₀ hnd h2
  have hone : (a * e - b * c) ^ 2 = 1 :=
    Int.eq_one_of_dvd_one (sq_nonneg _) ⟨_, hk.symm⟩
  rw [hW, hone, one_mul]

end Agora.Geometry.Occurrence

/-
  Generated-by: Claude Opus 5 (Stream 1 session, 2026-09-21) | Verified-by: Lean 4
  kernel; identity cross-checked numerically on 20,000 random instances before
  formalization (0 failures) | Reviewed-by: T0 N
-/
