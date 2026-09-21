/-
  Agora/Geometry/AtkinLehner.lean
  ════════════════════════════════════════════════════════════════════════════════

  THE ATKIN–LEHNER MULTIPLIER RULE, FOR EVERY HALL DIVISOR `Q`.

  Requested by Stream 2, brief
  `briefs/STREAM2_TO_STREAMS1_3_LEANMASTER_RESULTS_AND_DIRECTIONS_2026_09_21.md`
  §2 direction 2 (their R6, `ATKIN_LEHNER_DISC_FORM`, PASS(30)):

      "for g = [[Qa,b],[Nc,Qd]] of determinant Q, the induced map on
       (U⊕⟨2N⟩)^∨/(U⊕⟨2N⟩) ≅ ℤ/2N is multiplication by m = 2Qad − 1, so
       m ≡ −1 mod 2Q and m ≡ +1 mod 2N/Q."

  `ModularAction.lean` §7 delivered this for `Q = N` only, and said so: its
  `rhoAL` parameterizes the Fricke coset. This file supplies the missing
  parameterization and proves the rule for all `Q`.

  THE PARAMETERIZATION. Write `N = Q·M`. Normalising
  `W_Q = (1/√Q)·[[Qa, b], [Nc, Qd]]` and taking the symmetric square in the
  lattice basis `(e, f, w)` gives the INTEGER matrix

      ρ_Q = [[ Q·d²,  −M·c²,   2QM·cd ],
             [ −M·b²,  Q·a²,  −2QM·ab ],
             [ b·d,   −a·c,   Q·ad + M·bc ]],

  the `√Q` cancelling in every entry. `Q = 1` recovers `rho`; `M = 1` recovers
  `rhoAL`. The determinant condition `Q²ad − Nbc = Q` becomes `Q·ad − M·bc = 1`.

  WHAT IS PROVED — all polynomial identities, over any commutative ring

  §1  `rhoQ_isometry_general` — `ρ_Qᵀ·T_N·ρ_Q = (Qad − Mbc)²·T_N`, NO hypotheses.
      Hence an isometry when `Qad − Mbc = ±1`. Also `det = (Qad − Mbc)³`.
  §2  `rhoQ_mulVec_period` — `ρ_Q·ω(τ) = (Q(Mcτ+d)², −M(Qaτ+b)², (Qaτ+b)(Mcτ+d))`,
      which is `Q(Mcτ+d)²·ω(τ′)` with `τ′ = (Qaτ+b)/(Ncτ+Qd)`: the `W_Q` action.
  §3  THE MULTIPLIER. `ρ_Q(w) = 2N(cd·e − ab·f) + m·w`, `m = Qad + Mbc`, and under
      `Qad − Mbc = 1`:
          m + 1 = 2Q·ad        (so  m ≡ −1  mod 2Q)
          m − 1 = 2M·bc        (so  m ≡ +1  mod 2M = 2N/Q)
          m² − 1 = 4N·abcd     (so  m preserves the discriminant FORM x²/4N)
      Stream 2's rule, for every `Q`, as exact identities rather than congruences.
  §4  The s10 instances: `{1, 11, 9, 19}` at `Q = 1, 2, 5, 10`, matching R6; and
      these are ALL the square roots of 1 modulo 20 that lift mod 40.
  §5  Negative control.

  WHAT IS NOT PROVED
  * That `Q` and `M` are coprime is never assumed and never needed for the
    identities. It is needed for `Qad − Mbc = 1` to be SOLVABLE, i.e. for `W_Q`
    to exist; existence of Atkin–Lehner elements is not proved here.
  * That `Q ↦ m` is a group ISOMORPHISM `W(N) → O(q_A)` (their R6). §4 exhibits
    it for `N = 10`; the general statement would need the group law on the
    `W_Q`, which is not formalized.
  * Nothing here concerns physics (VISION §1.3, F5b).

  0 sorry. Axioms: Lean's standard ones only.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Geometry.ModularAction

namespace Agora.Geometry.AtkinLehner

open Matrix Agora.Geometry.ModularAction

variable {K : Type*} [CommRing K]

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE REPRESENTATION, AND THAT IT IS AN ISOMETRY                 ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `ρ_Q` for the Atkin–Lehner element `W_Q = [[Qa, b], [QMc, Qd]]/√Q` of level
    `N = Q·M`, in the basis `(e, f, w)` of `U ⊕ ⟨2N⟩`.
    -- Source: symmetric square of the normalised matrix; Stream 2 brief,
    direction 2. Cf. Dolgachev, J. Math. Sci. 81 (1996) §7 for `O⁺(U⊕⟨2n⟩)/±1 ≅ Γ₀(n)⁺`. -/
def rhoQ (Q M a b c d : K) : Matrix (Fin 3) (Fin 3) K :=
  !![Q * d ^ 2, -(M * c ^ 2), 2 * Q * M * c * d;
     -(M * b ^ 2), Q * a ^ 2, -(2 * Q * M * a * b);
     b * d, -(a * c), Q * a * d + M * b * c]

/-- `Q = 1` is `rho`: the group `Γ₀(N)` itself. -/
theorem rhoQ_one_left (M a b c d : K) : rhoQ 1 M a b c d = rho M a b c d := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [rhoQ, rho]

/-- `M = 1` is `rhoAL`: the Fricke coset. -/
theorem rhoQ_one_right (Q a b c d : K) : rhoQ Q 1 a b c d = rhoAL Q a b c d := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [rhoQ, rhoAL]

/-- **`ρ_Qᵀ·T_N·ρ_Q = (Qad − Mbc)²·T_N`**, with `N = Q·M` — a polynomial identity,
    no hypotheses. -/
theorem rhoQ_isometry_general (Q M a b c d : K) :
    (rhoQ Q M a b c d)ᵀ * TNR (Q * M) * rhoQ Q M a b c d
      = ((Q * a * d - M * b * c) ^ 2) • TNR (Q * M) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [rhoQ, TNR, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.smul_apply] <;> ring

/-- **Atkin–Lehner elements are isometries of `U ⊕ ⟨2N⟩`**, for every `Q`. -/
theorem rhoQ_isometry (Q M a b c d : K) (h : (Q * a * d - M * b * c) ^ 2 = 1) :
    (rhoQ Q M a b c d)ᵀ * TNR (Q * M) * rhoQ Q M a b c d = TNR (Q * M) := by
  rw [rhoQ_isometry_general, h, one_smul]

/-- `det ρ_Q = (Qad − Mbc)³`, so `W_Q` lands in `SO`, not merely `O`. -/
theorem rhoQ_det (Q M a b c d : K) :
    (rhoQ Q M a b c d).det = (Q * a * d - M * b * c) ^ 3 := by
  simp [rhoQ, Matrix.det_fin_three]; ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE ACTION ON THE PERIOD                                       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `ρ_Q·ω(τ) = (Q(Mcτ+d)², −M(Qaτ+b)², (Qaτ+b)(Mcτ+d))` — in cleared form, over
    any commutative ring. It is `Q(Mcτ+d)²·ω(τ′)` with `τ′ = (Qaτ+b)/(QMcτ+Qd)`,
    the Möbius action of `W_Q`. -/
theorem rhoQ_mulVec_period (Q M a b c d τ : K) :
    (rhoQ Q M a b c d) *ᵥ periodR (Q * M) τ
      = ![Q * (M * c * τ + d) ^ 2, -(M * (Q * a * τ + b) ^ 2),
          (Q * a * τ + b) * (M * c * τ + d)] := by
  ext i
  fin_cases i <;>
    simp [rhoQ, periodR, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> ring

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE MULTIPLIER ON THE DISCRIMINANT GROUP                       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **The image of `w`.** The `e`, `f` components carry the explicit factor
    `2QM = 2N`, which is why the action descends to `T_N^∨/T_N ≅ ℤ/2N` generated by
    `w/2N`; the `w` component is the multiplier. -/
theorem rhoQ_w_image (Q M a b c d : K) :
    (rhoQ Q M a b c d) *ᵥ ![0, 0, 1]
      = ![2 * (Q * M) * (c * d), -(2 * (Q * M) * (a * b)), Q * a * d + M * b * c] := by
  ext i
  fin_cases i <;> simp [rhoQ, Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> ring

/-- **`m + 1 = 2Q·ad`** — hence `m ≡ −1 (mod 2Q)`. -/
theorem multiplier_add_one (Q M a b c d : K) (h : Q * a * d - M * b * c = 1) :
    (Q * a * d + M * b * c) + 1 = 2 * Q * (a * d) := by linear_combination (-1 : K) * h

/-- **`m − 1 = 2M·bc`** — hence `m ≡ +1 (mod 2M)`, `2M = 2N/Q`. -/
theorem multiplier_sub_one (Q M a b c d : K) (h : Q * a * d - M * b * c = 1) :
    (Q * a * d + M * b * c) - 1 = 2 * M * (b * c) := by linear_combination h

/-- **`m² − 1 = 4N·abcd`.** So `m` preserves not only the discriminant GROUP
    `ℤ/2N` but the discriminant FORM `q(x) = x²/4N mod 2`: it is an element of
    `O(q_A)`, which is what Stream 2's R6 says the image is. -/
theorem multiplier_sq (Q M a b c d : K) (h : Q * a * d - M * b * c = 1) :
    (Q * a * d + M * b * c) ^ 2 - 1 = 4 * (Q * M) * (a * b * c * d) := by
  linear_combination (Q * a * d - M * b * c + 1) * h

/-- Stream 2's rule over `ℤ`, in the form they state it. -/
theorem multiplier_congruences (Q M a b c d : ℤ) (h : Q * a * d - M * b * c = 1) :
    (2 * Q) ∣ ((Q * a * d + M * b * c) + 1)
      ∧ (2 * M) ∣ ((Q * a * d + M * b * c) - 1)
      ∧ (4 * (Q * M)) ∣ ((Q * a * d + M * b * c) ^ 2 - 1) :=
  ⟨⟨a * d, by rw [multiplier_add_one Q M a b c d h]⟩,
   ⟨b * c, by rw [multiplier_sub_one Q M a b c d h]⟩,
   ⟨a * b * c * d, by rw [multiplier_sq Q M a b c d h]⟩⟩

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. THE s10 INSTANCES:  {1, 11, 9, 19}                             ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The four Atkin–Lehner multipliers at level `N = 10`, one for each Hall
    divisor `Q ∈ {1, 2, 5, 10}`, with explicit `(a,b,c,d)` satisfying
    `Qad − Mbc = 1`. Reproduces Stream 2's R6 list `{1, 11, 9, 19}` (the last as
    `−1 ≡ 19 mod 20`). -/
theorem s10_multipliers :
    ((1 : ℤ) * 1 * 1 - 10 * 0 * 0 = 1 ∧ (1 : ℤ) * 1 * 1 + 10 * 0 * 0 = 1)
    ∧ ((2 : ℤ) * 3 * 1 - 5 * 1 * 1 = 1 ∧ (2 : ℤ) * 3 * 1 + 5 * 1 * 1 = 11)
    ∧ ((5 : ℤ) * 1 * 1 - 2 * 2 * 1 = 1 ∧ (5 : ℤ) * 1 * 1 + 2 * 2 * 1 = 9)
    ∧ ((10 : ℤ) * 0 * 0 - 1 * (-1) * 1 = 1 ∧ (10 : ℤ) * 0 * 0 + 1 * (-1) * 1 = -1) := by
  norm_num

/-- `{1, 9, 11, 19}` is exactly the set of `m mod 20` with `m² ≡ 1 mod 40` — the
    whole of `O(q_A)` for `A = ℤ/20`, `q(x) = x²/40`. So at level 10 the four
    Atkin–Lehner multipliers exhaust it. -/
theorem s10_orthogonal_group :
    ∀ m : Fin 20, ((m.val : ZMod 40) ^ 2 = 1) ↔ (m = 1 ∨ m = 9 ∨ m = 11 ∨ m = 19) := by
  decide

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §5. NEGATIVE CONTROL                                               ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **CONTROL.** Without the normalization the rule fails: at
    `(Q,M,a,b,c,d) = (2,5,1,1,1,1)`, `Qad − Mbc = −3` and `m = 7`, and `2Q = 4`
    does not divide `m + 1 = 8`… it does; but `2M = 10` does not divide
    `m − 1 = 6`. So `multiplier_sub_one` says something about the hypothesis. -/
theorem multiplier_needs_normalization :
    (2 : ℤ) * 1 * 1 - 5 * 1 * 1 = -3 ∧ ¬ ((2 * 5 : ℤ) ∣ ((2 * 1 * 1 + 5 * 1 * 1) - 1)) := by
  refine ⟨by norm_num, by decide⟩

end Agora.Geometry.AtkinLehner

/-
  Generated-by: Claude Fable 5.1 (Stream 1 session) | Verified-by: Lean 4 kernel;
  every identity and every `linear_combination` coefficient checked symbolically
  (sympy) BEFORE the build, per LL.md §3.13 | Reviewed-by: T0 N
-/
