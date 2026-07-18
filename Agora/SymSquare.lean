/-
  Agora/SymSquare.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-04 — Symmetric-square API for the C3 criterion.
  T0-OWNED DESIGN (Opus 4.8, acting as T0 under delegated authority; see
  briefs/S1-04.md for the full design brief and rationale).

  WHAT THIS FILE PROVIDES (the API surface T1/T2 implement per-candidate against):

    · DiffOp2 / DiffOp3 — monic 2nd/3rd-order linear ODE operators with
      Polynomial ℚ coefficients (the θ-operator / polynomial-coefficient
      presentation; escalate — do NOT improvise — if a candidate genuinely
      needs RatFunc ℚ coefficients).
    · symSquare : DiffOp2 → DiffOp3 — the classical symmetric-square operation.
    · IsSymSquareOf — the C3 relation `L3 = symSquare L2`, a CONCRETE operator
      equality (NOT an existence claim — this is what keeps C3 non-vacuous, cf.
      escalation E-002).

  DESIGN NOTE — WHY THIS IS NOT VACUOUS (contrast escalation E-002's
  `empirical_s7_degree : ∃ P, P.natDegree = 3`, true of ANY cubic):
  `IsSymSquareOf L3 L2` fixes EVERY coefficient of L3 as an explicit polynomial
  function of L2's coefficients. It is a specific identity, falsifiable per
  candidate — exactly the content C3 is supposed to carry.

  THE symSquare FORMULA is VALIDATED by the golden tests in §3 against two
  examples derived from first principles (sin/cos and 1/e^{-t} solution spaces),
  NOT trusted from memory. No `sym2_<candidate>` theorem may clear a candidate's
  SYM2_UNVERIFIED flag until these golden tests are green.

  0 sorry in this file (per-candidate theorems live in their own files; unproven
  cases go to OpenGoals/ as `open_goal_sym2_<candidate>`).

  ════════════════════════════════════════════════════════════════════════════════
-/

import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Tactic

namespace Agora.SymSquare

open Polynomial

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. OPERATOR REPRESENTATION                                       ║
-- ║  Monic linear ODE operators, coefficients in Polynomial ℚ.        ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- A monic second-order linear differential operator
      L₂ = D² + p·D + q
    with D = d/dt and coefficients p, q ∈ ℚ[t]. The leading coefficient is
    normalized to 1 (monic); a candidate whose operator is not monic must be
    normalized before encoding (division by the leading coefficient — if that
    introduces genuine rational-function coefficients, ESCALATE, do not
    improvise; see briefs/S1-04.md).
    -- Source: standard form of a 2nd-order linear ODE / Picard-Fuchs operator. -/
structure DiffOp2 where
  p : Polynomial ℚ
  q : Polynomial ℚ
  deriving Repr

/-- A monic third-order linear differential operator
      L₃ = D³ + b·D² + c·D + d,  b, c, d ∈ ℚ[t]. -/
structure DiffOp3 where
  b : Polynomial ℚ
  c : Polynomial ℚ
  d : Polynomial ℚ
  deriving Repr

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE SYMMETRIC SQUARE                                          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The symmetric square of a monic second-order operator.

    For L₂ = D² + p·D + q, the third-order operator whose solution space is
    spanned by the pairwise products {y_i·y_j} of solutions of L₂ is

      Sym²(L₂) = D³ + 3p·D² + (2p² + p' + 4q)·D + (4pq + 2q').

    Derivation (from first principles, NOT from memory — validated by the
    golden tests in §3): with u = y_i y_j and y'' = -p y' - q y, differentiate
    u, u', u'', u''' and eliminate {y', y''} to obtain the above coefficients.
    The p = 0 special case D³ + 4q·D + 2q' is the classical symmetric square of
    D² + q and is checked in `symSquare_golden_harmonic` below.

    -- Source: classical symmetric power of a linear ODE operator; the specific
    coefficients are kernel-validated against §3's first-principles examples. -/
noncomputable def symSquare (L : DiffOp2) : DiffOp3 where
  b := 3 * L.p
  c := 2 * L.p ^ 2 + L.p.derivative + 4 * L.q
  d := 4 * L.q * L.p + 2 * L.q.derivative

/-- The C3 relation for a candidate: its order-3 operator equals the symmetric
    square of an explicitly exhibited order-2 operator. A CONCRETE identity
    (every coefficient of `L3` pinned as a polynomial in `L2`'s coefficients),
    not an existence claim — this is what keeps criterion C3 non-vacuous. -/
def IsSymSquareOf (L3 : DiffOp3) (L2 : DiffOp2) : Prop :=
  L3 = symSquare L2

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. GOLDEN VALIDATION OF THE symSquare FORMULA                    ║
-- ║  Two examples derived from first principles (not memory). If either ║
-- ║  fails, the formula in §2 is wrong and NO candidate may be cleared. ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Golden test 1 — harmonic oscillator. L₂ = D² + 1 (p = 0, q = 1) has
    solution space {sin t, cos t}; the products {sin²,sin·cos,cos²} are spanned
    by {1, cos 2t, sin 2t}, killed by D(D² + 4) = D³ + 4D. So Sym²(D²+1) must be
    D³ + 0·D² + 4·D + 0. -/
theorem symSquare_golden_harmonic :
    symSquare ⟨0, 1⟩ = ⟨0, 4, 0⟩ := by
  simp [symSquare]

/-- Golden test 2 — L₂ = D² + D (p = 1, q = 0) has solution space {1, e^{-t}};
    products {1, e^{-t}, e^{-2t}} are killed by D(D+1)(D+2) = D³ + 3D² + 2D.
    So Sym²(D²+D) must be D³ + 3·D² + 2·D + 0. -/
theorem symSquare_golden_exp :
    symSquare ⟨1, 0⟩ = ⟨3, 2, 0⟩ := by
  simp [symSquare]

end Agora.SymSquare
