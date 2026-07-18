/-
  Agora/Sequences/ThetaOperators.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-07 — θ-form Picard-Fuchs operators for the sporadic-sequence templates.

  PURPOSE (E-002 discharge): replace the vacuous degree axioms of
  `Agora/Geometry/FTheoryFibration.lean` (`∃ P, P.natDegree = 3`, true of any
  cubic) with the ACTUAL operators, encoded verbatim in the literature's θ-form,
  so that "order 2" / "order 3" become kernel-computed facts about pinned
  coefficient data instead of assumed existentials.

  REPRESENTATION. A θ-form operator (θ = z·d/dz) with polynomial coefficients
  is an element of ℚ[z][θ], encoded as `Polynomial (Polynomial ℚ)`:
    · the OUTER variable `X` is θ,
    · the INNER variable (written `C X` from the outside) is z,
    · the ODE order is the θ-degree, i.e. `natDegree`.
  This avoids the monic D-form normalization entirely (which needs RatFunc
  coefficients — escalation trigger E-04b in briefs/S1-04.md) because the
  ORDER of the operator is representation-independent and readable in θ-form.

  EPISTEMIC BOUNDARY (VISION §2 — read before citing this file):
  · Tier A (kernel-checked here): the encoded operators have θ-degree 2 / 3,
    for EVERY parameter choice of their template.
  · Tier B (NOT established here): that each encoded operator is the MINIMAL
    annihilating operator of its sequence, and any geometric identification
    (elliptic-curve vs K3 periods). Those are bridge statements — S1-05 scope.

  0 sorry.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.CooperRecurrences
import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Tactic

namespace Agora.Sequences

open Polynomial

noncomputable section

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE ORDER-2 (ZAGIER) TEMPLATE                                 ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Parameters (A, λ, B) fixing one instance of the order-2 (Apéry-like /
    Zagier) sporadic template. The associated recurrence is
      (n+1)² u(n+1) = (A·n² + A·n + λ)·u(n) − B·n²·u(n−1).
    -- Source: D. Zagier, "Integral solutions of Apéry-like recurrence
    equations"; operator form per O. Gorodetsky, arXiv:2102.11839, eq. (1.6),
    as fetched and recorded in `briefs/ESCALATIONS.md` E-004 and
    `refs/cooper_sequences.md`. -/
structure ZagierRecurrenceParams where
  A : ℤ
  lam : ℤ
  B : ℤ
  deriving Repr, DecidableEq

/-- The order-2 θ-form Picard-Fuchs operator of the Zagier template,
      θ² − z·(A·θ² + A·θ + λ) + B·z²·(θ + 1)²,
    encoded verbatim (outer `X` = θ, `C X` = z).
    -- Source: Gorodetsky, arXiv:2102.11839, eq. (1.6) (fetched; see
    `refs/cooper_sequences.md`, SHA-pinned). -/
def zagierThetaOperator (p : ZagierRecurrenceParams) : Polynomial (Polynomial ℚ) :=
  X ^ 2
    - C X * (C (C (p.A : ℚ)) * X ^ 2 + C (C (p.A : ℚ)) * X + C (C (p.lam : ℚ)))
    + C (C (p.B : ℚ)) * C X ^ 2 * (X + 1) ^ 2

/-- The Zagier-template operator, rewritten with its θ-coefficients collected
    (a `ring`-level identity; the kernel checks the expansion):
      (1 − A·z + B·z²)·θ² + (−A·z + 2B·z²)·θ + (−λ·z + B·z²). -/
theorem zagierThetaOperator_eq (p : ZagierRecurrenceParams) :
    zagierThetaOperator p =
        C (1 - C (p.A : ℚ) * X + C (p.B : ℚ) * X ^ 2) * X ^ 2
      + C (- C (p.A : ℚ) * X + C (2 * (p.B : ℚ)) * X ^ 2) * X
      + C (- C (p.lam : ℚ) * X + C (p.B : ℚ) * X ^ 2) := by
  unfold zagierThetaOperator
  simp only [map_add, map_sub, map_mul, map_neg, map_one, map_ofNat, map_pow]
  ring

/-- The θ-leading coefficient 1 − A·z + B·z² of the Zagier template is nonzero
    (its constant term is 1) — for EVERY parameter choice. -/
theorem zagier_leadCoeff_ne_zero (p : ZagierRecurrenceParams) :
    (1 - C (p.A : ℚ) * X + C (p.B : ℚ) * X ^ 2 : Polynomial ℚ) ≠ 0 := by
  intro h
  have h0 := congrArg (fun q : Polynomial ℚ => q.coeff 0) h
  simp [coeff_one, mul_coeff_zero, coeff_X_zero] at h0

/-- KERNEL FACT (Tier A): the Zagier-template θ-operator has θ-degree exactly 2,
    for every parameter choice. This is the honest, data-carrying replacement
    for the former `empirical_S12_degree` existence axiom. -/
theorem zagierThetaOperator_natDegree (p : ZagierRecurrenceParams) :
    (zagierThetaOperator p).natDegree = 2 := by
  rw [zagierThetaOperator_eq]
  compute_degree!
  · exact zagier_leadCoeff_ne_zero p

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE ORDER-3 (COOPER) TEMPLATE                                 ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The order-3 θ-form Picard-Fuchs operator of the Cooper template,
      θ³ − z·(2θ+1)·(a·θ² + a·θ + b) + z²·(c·(θ+1)³ + d·(θ+1)),
    encoded verbatim (outer `X` = θ, `C X` = z), with parameters from
    `CooperRecurrenceParams` (already sourced per candidate in
    `Agora/Sequences/CooperRecurrences.lean`).
    -- Source: Gorodetsky, arXiv:2102.11839, eq. (1.7) (Cooper's operator
    template; fetched — see `refs/cooper_sequences.md`, SHA-pinned; original:
    S. Cooper, Ramanujan J. 29 (2012), Table 1). -/
def cooperThetaOperator (p : CooperRecurrenceParams) : Polynomial (Polynomial ℚ) :=
  X ^ 3
    - C X * (2 * X + 1) * (C (C (p.a : ℚ)) * X ^ 2 + C (C (p.a : ℚ)) * X + C (C (p.b : ℚ)))
    + C X ^ 2 * (C (C (p.c : ℚ)) * (X + 1) ^ 3 + C (C (p.d : ℚ)) * (X + 1))

/-- The Cooper-template operator with θ-coefficients collected:
      (1 − 2a·z + c·z²)·θ³ + (−3a·z + 3c·z²)·θ² + (−(a+2b)·z + (3c+d)·z²)·θ
        + (−b·z + (c+d)·z²). -/
theorem cooperThetaOperator_eq (p : CooperRecurrenceParams) :
    cooperThetaOperator p =
        C (1 - C (2 * (p.a : ℚ)) * X + C (p.c : ℚ) * X ^ 2) * X ^ 3
      + C (- C (3 * (p.a : ℚ)) * X + C (3 * (p.c : ℚ)) * X ^ 2) * X ^ 2
      + C (- C ((p.a : ℚ) + 2 * (p.b : ℚ)) * X + C (3 * (p.c : ℚ) + (p.d : ℚ)) * X ^ 2) * X
      + C (- C (p.b : ℚ) * X + C ((p.c : ℚ) + (p.d : ℚ)) * X ^ 2) := by
  unfold cooperThetaOperator
  simp only [map_add, map_sub, map_mul, map_neg, map_one, map_ofNat, map_pow]
  ring

/-- The θ-leading coefficient 1 − 2a·z + c·z² of the Cooper template is nonzero
    (its constant term is 1) — for EVERY parameter choice. -/
theorem cooper_leadCoeff_ne_zero (p : CooperRecurrenceParams) :
    (1 - C (2 * (p.a : ℚ)) * X + C (p.c : ℚ) * X ^ 2 : Polynomial ℚ) ≠ 0 := by
  intro h
  have h0 := congrArg (fun q : Polynomial ℚ => q.coeff 0) h
  simp [coeff_one, mul_coeff_zero, coeff_X_zero] at h0

/-- KERNEL FACT (Tier A): the Cooper-template θ-operator has θ-degree exactly 3,
    for every parameter choice — in particular for s7, s10, and s18. This is
    the honest, data-carrying replacement for the former `empirical_s7_degree`
    existence axiom.

    NOT established here (Tier B, S1-05 bridge scope): minimality of this
    operator for the sequence, and the K3-period geometric identification. -/
theorem cooperThetaOperator_natDegree (p : CooperRecurrenceParams) :
    (cooperThetaOperator p).natDegree = 3 := by
  rw [cooperThetaOperator_eq]
  compute_degree!
  -- side goal: the θ³-coefficient 1 − 2a·z + c·z² is nonzero (constant term 1);
  -- `compute_degree!` presents it in cast-normalized shape, so close it by
  -- evaluating the constant coefficient rather than via the standalone lemma
  intro h
  have h0 := congrArg (fun q : Polynomial ℚ => q.coeff 0) h
  simp [coeff_one, mul_coeff_zero, coeff_X_zero] at h0

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. THE S_{1,2} INSTANCE (pipeline-extracted parameters)          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Recurrence parameters for the S_{1,2} sequence: (A, λ, B) = (11, 3, −1),
    i.e. the recurrence (n+1)²·u(n+1) = (11n² + 11n + 3)·u(n) + n²·u(n−1).
    -- Source: AutoEvolve pipeline exact-rational nullspace extraction
    (Stream 2 artifact; carried over from the recurrence recorded in the
    retired `empirical_S12_degree` axiom docstring, FTheoryFibration.lean,
    pre-S1-07).
    EPISTEMIC NOTE (Tier B): that the ACTUAL pipeline sequence satisfies this
    recurrence is an empirical claim about Stream 2/3 data, NOT certified by
    this file. What the kernel certifies is the θ-degree of the operator these
    parameters define. -/
def S12_zagier_params : ZagierRecurrenceParams := ⟨11, 3, -1⟩

end

end Agora.Sequences
