/-
  Agora/Sequences/Integrality.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-03 — Integrality and recurrence properties of Cooper's s7 and s10.

  ⚠️ CORRECTED 2026-07-26 (WP S1-11). This file previously advertised itself as
  proving integrality of s7 and s10. It does not, and cannot: `s7` and `s10` are
  declared `ℕ → ℕ`, so "is a natural number" is a typing fact discharged by the
  elaborator, and `s7_is_nat`/`s10_is_nat` below are TAUTOLOGIES (`use s7 n`).
  They are retained, relabelled, purely so nobody re-adds them believing there is
  content there. The honest summary of this file is:

    1. s7/s10 are ℕ-valued BY CONSTRUCTION — nothing is proved (§1, §2).
    2. Base values s7(0)=1, s7(1)=4, s10(0)=1, s10(1)=2 — kernel-checked (§1, §2).
    3. n = 1 instances of the Cooper recurrence — kernel-checked (§3). The full
       ∀ n ≥ 1 statement is now PROVED elsewhere; see §3.

  WHERE THE REAL INTEGRALITY CONTENT LIVES: `Agora/Sequences/PartnerIntegrality.lean`.
  The order-2 PARTNER sequences are ℚ-valued (their recurrence divides by (k+2)²),
  so their integrality is a genuine theorem — and it separates the candidates:
  s10's and s18's partners are provably NOT integral, s7's is open. That is the
  arithmetic that actually distinguishes Cooper's three sporadic sequences.

  SCOPE NOTE:
    These are foundational lemmas for S1-04 (Sym² structure verification).
    No sorry in this file — all lemmas are proved or explicitly listed as
    open goals in OpenGoals/.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Tactic
import Agora.Sequences.CooperRecurrences

namespace Agora.Sequences

open Finset

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. INTEGRALITY: s7 IS NATURAL (ℕ)                               ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- ⚠️ VACUOUS — retained as a marker, not as a result.

    `s7 : ℕ → ℕ`, so `∃ k : ℕ, s7 n = k` is closed by `use s7 n` and says nothing.
    It is not evidence of integrality; it is the elaborator restating the type.
    The non-trivial integrality question for the s7 side is about the order-2
    PARTNER, which is ℚ-valued — see `Agora/Sequences/PartnerIntegrality.lean`
    and `open_goal_partner_integral_s7`. -/
theorem s7_is_nat (n : ℕ) : ∃ k : ℕ, s7 n = k := by
  use s7 n

/-- s7(0) = 1 (base case, zero-length sum is convention). -/
theorem s7_zero : s7 0 = 1 := by decide

/-- s7(1) = 4 (base case from closed-form definition). -/
theorem s7_one : s7 1 = 4 := by decide

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. INTEGRALITY: s10 IS NATURAL (ℕ)                              ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- ⚠️ VACUOUS — retained as a marker, not as a result. See `s7_is_nat`.

    For s10 the contrast is sharpest: this tautology sits a few lines from
    `s10_partner_not_integral`, which is a real theorem establishing that s10's
    order-2 partner is NOT integral. Type-level "integrality" and arithmetic
    integrality are not the same claim. -/
theorem s10_is_nat (n : ℕ) : ∃ k : ℕ, s10 n = k := by
  use s10 n

/-- s10(0) = 1 (base case). -/
theorem s10_zero : s10 0 = 1 := by decide

/-- s10(1) = 2 (base case from closed-form definition). -/
theorem s10_one : s10 1 = 2 := by decide

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. RECURRENCE SATISFACTION (VERIFICATION FOR SMALL CASES)        ║
-- ║  Both s7 and s10 satisfy their defining Cooper-template recurrences.║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Coercion of s7 from ℕ → ℕ to ℕ → ℤ for recurrence verification. -/
def s7_int : ℕ → ℤ := fun n => (s7 n : ℤ)

/-- Coercion of s10 from ℕ → ℕ to ℕ → ℤ for recurrence verification. -/
def s10_int : ℕ → ℤ := fun n => (s10 n : ℤ)

/-- s7 (as integers) satisfies the Cooper recurrence at n = 1 — kernel-checked.

    ⚠️ DOCSTRING CORRECTED 2026-07-26. This previously said the full `∀ n ≥ 1`
    statement was "NOT claimed here … pending a formalized WZ certificate". That
    is out of date: the certificate was derived and the goal was CLOSED on
    2026-07-25, so the general statement now holds unconditionally as
    `Agora.Sequences.WZ.s7_satisfies` (Tier A, no `native_decide`, no axioms
    beyond Lean's own). This n = 1 instance is consequently redundant and is kept
    only as a cheap regression check on the parameter encoding.
    -- Source: Cooper (2012), Table 1; Gorodetsky (2023), arXiv:2102.11839. -/
theorem s7_recurrence_at_one :
    ((1 : ℤ) + 1) ^ 3 * s7_int (1 + 1) =
      (2 * (1 : ℤ) + 1) * (s7_params.a * 1 ^ 2 + s7_params.a * 1 + s7_params.b) * s7_int 1
        - (1 : ℤ) * (s7_params.c * 1 ^ 2 + s7_params.d) * s7_int (1 - 1) := by
  decide

/-- s10 (as integers) satisfies the Cooper recurrence at n = 1 — kernel-checked.

    ⚠️ DOCSTRING CORRECTED 2026-07-26, as for `s7_recurrence_at_one`: the full
    `∀ n ≥ 1` statement is no longer an open goal. It is
    `Agora.Sequences.WZ.s10_satisfies`, closed 2026-07-25.
    -- Source: Cooper (2012), Table 1; Gorodetsky (2023), arXiv:2102.11839. -/
theorem s10_recurrence_at_one :
    ((1 : ℤ) + 1) ^ 3 * s10_int (1 + 1) =
      (2 * (1 : ℤ) + 1) * (s10_params.a * 1 ^ 2 + s10_params.a * 1 + s10_params.b) * s10_int 1
        - (1 : ℤ) * (s10_params.c * 1 ^ 2 + s10_params.d) * s10_int (1 - 1) := by
  decide

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. GROWTH BOUNDS                                                 ║
-- ║  The polynomial-growth statements are open goals, not partial      ║
-- ║  results — see `open_goal_s7_growth`/`open_goal_s10_growth` in      ║
-- ║  OpenGoals/. Nothing provable in closed form is asserted here.     ║
-- ╚════════════════════════════════════════════════════════════════════╝

end Agora.Sequences
