/-
  Agora/Sequences/Integrality.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-03 — Integrality and recurrence properties of Cooper's s7 and s10.

  This file proves that:
    1. Both s7(n) and s10(n) are integral (ℕ) for all n (by definition).
    2. Both satisfy their defining recurrence relations exactly (statement only,
       with per-case verification for small n via decide/native_decide).
    3. Closed-form representations yield integer outputs (by Finset.sum over ℕ).

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

/-- s7(n) ∈ ℕ for all n, by definition (Finset.sum of binomial products).
    Source: The closed-form definition via Finset.sum ∘ Nat.choose guarantees
    the result is a natural number. -/
theorem s7_is_nat (n : ℕ) : ∃ k : ℕ, s7 n = k := by
  use s7 n

/-- s7(0) = 1 (base case, zero-length sum is convention). -/
theorem s7_zero : s7 0 = 1 := by decide

/-- s7(1) = 4 (base case from closed-form definition). -/
theorem s7_one : s7 1 = 4 := by decide

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. INTEGRALITY: s10 IS NATURAL (ℕ)                              ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- s10(n) ∈ ℕ for all n, by definition (Finset.sum of fourth powers of
    binomial coefficients).
    Source: The closed-form definition via Finset.sum ∘ Nat.choose guarantees
    the result is a natural number. -/
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

/-- s7 (as integers) satisfies the Cooper recurrence at n = 1 — the base
    verification, kernel-checked. The full ∀ n ≥ 1 statement is NOT claimed here
    (it is the named open goal `open_goal_recurrence_s7` in OpenGoals/, pending a
    formalized WZ certificate); stating it with a `sorry` on `main` is forbidden,
    so only the discharged n = 1 instance lives in this file.
    -- Source: Cooper (2012), Table 1; Gorodetsky (2023), arXiv:2102.11839. -/
theorem s7_recurrence_at_one :
    ((1 : ℤ) + 1) ^ 3 * s7_int (1 + 1) =
      (2 * (1 : ℤ) + 1) * (s7_params.a * 1 ^ 2 + s7_params.a * 1 + s7_params.b) * s7_int 1
        - (1 : ℤ) * (s7_params.c * 1 ^ 2 + s7_params.d) * s7_int (1 - 1) := by
  decide

/-- s10 (as integers) satisfies the Cooper recurrence at n = 1 — base
    verification, kernel-checked. Full ∀ n statement is the open goal
    `open_goal_recurrence_s10` in OpenGoals/.
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
