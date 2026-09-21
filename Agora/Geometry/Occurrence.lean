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

end Agora.Geometry.Occurrence

/-
  Generated-by: Claude Opus 5 (Stream 1 session, 2026-09-21) | Verified-by: Lean 4
  kernel; identity cross-checked numerically on 20,000 random instances before
  formalization (0 failures) | Reviewed-by: T0 N
-/
