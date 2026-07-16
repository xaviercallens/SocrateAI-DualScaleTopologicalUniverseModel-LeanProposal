/-
  Weierstrass.lean
  ════════════════════════════════════════════════════════════════════════════════

  WEIERSTRASS ELLIPTIC CURVE MODEL
  Standalone formalization of the Weierstrass normal form y² = x³ + ax + b
  and its j-invariant, used across all F-theory constructions.

  0 sorry. 0 axioms.

  References:
    [Silverman09]  J. Silverman, "The Arithmetic of Elliptic Curves", GTM 106
    [Husemöller04] D. Husemöller, "Elliptic Curves", GTM 111

  ════════════════════════════════════════════════════════════════════════════════
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic

noncomputable section

namespace Agora.Geometry

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. WEIERSTRASS CURVE OVER ℝ                                    ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- A Weierstrass elliptic curve y² = x³ + a·x + b over ℝ.
    The curve is non-singular iff Δ = -16(4a³ + 27b²) ≠ 0. -/
structure WeierstrassCurve where
  a : ℝ
  b : ℝ

/-- The discriminant of a Weierstrass curve.
    Δ = -16(4a³ + 27b²)
    For F-theory purposes, we track the algebraic discriminant 4a³ + 27b² directly. -/
def WeierstrassCurve.discriminant (E : WeierstrassCurve) : ℝ :=
  -16 * (4 * E.a ^ 3 + 27 * E.b ^ 2)

/-- The algebraic discriminant (without the -16 factor).
    This is the quantity that appears directly in the Kodaira classification. -/
def WeierstrassCurve.algebraic_discriminant (E : WeierstrassCurve) : ℝ :=
  4 * E.a ^ 3 + 27 * E.b ^ 2

/-- A curve is non-singular iff its discriminant is nonzero. -/
def WeierstrassCurve.nonsingular (E : WeierstrassCurve) : Prop :=
  E.discriminant ≠ 0

/-- Non-singularity is equivalent to the algebraic discriminant being nonzero. -/
theorem nonsingular_iff_alg_disc (E : WeierstrassCurve) :
    E.nonsingular ↔ E.algebraic_discriminant ≠ 0 := by
  unfold WeierstrassCurve.nonsingular WeierstrassCurve.discriminant
    WeierstrassCurve.algebraic_discriminant
  constructor
  · intro h habs
    apply h
    rw [habs]
    ring
  · intro h habs
    apply h
    nlinarith

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE j-INVARIANT                                             ║
-- ║  j(E) = -1728 · (4a³) / Δ classifies elliptic curves            ║
-- ║  up to isomorphism over an algebraically closed field.            ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The j-invariant of a Weierstrass curve.
    j = -1728 · (4a)³ / Δ = 1728 · 4a³ / (4a³ + 27b²)

    In F-theory, the j-invariant encodes the axio-dilaton:
    j(τ(u)) = SL(2,ℤ) invariant encoding of the Type IIB coupling. -/
def WeierstrassCurve.j_invariant (E : WeierstrassCurve)
    (h : E.algebraic_discriminant ≠ 0) : ℝ :=
  1728 * (4 * E.a ^ 3) / E.algebraic_discriminant

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. SPECIAL CURVES                                               ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The curve y² = x³ + x (a = 1, b = 0) has j = 1728.
    This is the "square" lattice curve with CM by ℤ[i]. -/
def square_lattice_curve : WeierstrassCurve := ⟨1, 0⟩

theorem square_lattice_disc : square_lattice_curve.algebraic_discriminant = 4 := by
  unfold square_lattice_curve WeierstrassCurve.algebraic_discriminant
  norm_num

theorem square_lattice_nonsingular : square_lattice_curve.nonsingular := by
  rw [nonsingular_iff_alg_disc]
  rw [square_lattice_disc]
  norm_num

/-- The curve y² = x³ + 1 (a = 0, b = 1) has j = 0.
    This is the "hexagonal" lattice curve with CM by ℤ[ω]. -/
def hexagonal_lattice_curve : WeierstrassCurve := ⟨0, 1⟩

theorem hexagonal_lattice_disc : hexagonal_lattice_curve.algebraic_discriminant = 27 := by
  unfold hexagonal_lattice_curve WeierstrassCurve.algebraic_discriminant
  norm_num

theorem hexagonal_lattice_nonsingular : hexagonal_lattice_curve.nonsingular := by
  rw [nonsingular_iff_alg_disc]
  rw [hexagonal_lattice_disc]
  norm_num

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. SINGULAR FIBERS (DISCRIMINANT ZERO)                         ║
-- ║  When Δ = 0, the cubic has a singular point — either a node       ║
-- ║  (multiplicative reduction) or a cusp (additive reduction).       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- A nodal cubic: y² = x³ + x² (shifted Weierstrass, but illustration).
    In standard form, a cusp occurs when a = 0, b = 0: y² = x³. -/
def cuspidal_cubic : WeierstrassCurve := ⟨0, 0⟩

theorem cuspidal_is_singular : ¬ cuspidal_cubic.nonsingular := by
  rw [nonsingular_iff_alg_disc]
  push_neg
  unfold cuspidal_cubic WeierstrassCurve.algebraic_discriminant
  norm_num

/-- For a ≥ 0 and b ≠ 0, the algebraic discriminant is positive,
    so the curve is non-singular. -/
theorem nonsingular_of_nonneg_a_nonzero_b (E : WeierstrassCurve)
    (ha : E.a ≥ 0) (hb : E.b ≠ 0) : E.nonsingular := by
  rw [nonsingular_iff_alg_disc]
  unfold WeierstrassCurve.algebraic_discriminant
  have h1 : 4 * E.a ^ 3 ≥ 0 := by positivity
  have h2 : 27 * E.b ^ 2 > 0 := by positivity
  linarith

end Agora.Geometry
