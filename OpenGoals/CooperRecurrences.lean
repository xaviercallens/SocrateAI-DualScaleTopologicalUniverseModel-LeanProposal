/-
  OpenGoals/CooperRecurrences.lean
  ════════════════════════════════════════════════════════════════════════════════

  Named open goals for WP S1-02/S1-03 (Agora/Sequences/CooperRecurrences.lean).

  This file is the ONLY sorry-carrying location permitted on `main`
  (lean-proof-workflow skill, "sorry policy"). CI must exclude this
  directory from the no-sorry check and nothing else.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.CooperRecurrences

namespace Agora.Sequences.OpenGoals

open Agora.Sequences

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  open_goal_recurrence_s7                                           ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Cooper's s7 closed-form binomial sum satisfies the s7_params
    three-term recurrence.

    STATUS: mathematically established in the literature (Gorodetsky 2023,
    arXiv:2102.11839, via a WZ-pair / creative-telescoping certificate) but
    NOT kernel-verified here.

    Grind-loop attempts (lean-proof-workflow, three-strikes rule):
    1. `induction n` on the recurrence index, `simp [s7]` on the step —
       fails: the step case requires re-indexing a Finset.sum over a
       shifting range (Icc ((n+1)/2) n vs Icc ((n+2)/2) (n+1)), which does
       not reduce by `simp`/`ring`/`omega` alone; the identity is a genuine
       hypergeometric-sum identity, not a syntactic rewrite.
    2. `decide` at the general (∀ n) level — inapplicable; the statement
       quantifies over all `n : ℕ`, not decidable by kernel computation.
    3. `exact?`/`apply?` — no matching Mathlib lemma; Mathlib does not
       currently contain a creative-telescoping / Zeilberger tactic.

    Conclusion: this needs a formalized WZ certificate (the explicit
    rational-function multiplier from Gorodetsky's proof) as an auxiliary
    lemma before an inductive proof becomes mechanical. That certificate
    is not yet transcribed into this repo — T1/T0 follow-up work, not a
    Mathlib gap (hence NOT filed as blocked-on-mathlib). -/
theorem open_goal_recurrence_s7 :
    SatisfiesCooperRecurrence (fun n => (s7 n : ℤ)) s7_params := by
  sorry

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  open_goal_recurrence_s10                                          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Cooper's s10 closed-form binomial sum satisfies the s10_params
    three-term recurrence.

    STATUS: mathematically established in the literature (Gorodetsky 2023,
    arXiv:2102.11839, via a WZ-pair certificate) but NOT kernel-verified
    here. Same grind-loop analysis as `open_goal_recurrence_s7` applies —
    the s10 sum Σ C(n,k)⁴ is a classical but nontrivial hypergeometric
    identity (related to Domb-type numbers); no direct Mathlib lemma. -/
theorem open_goal_recurrence_s10 :
    SatisfiesCooperRecurrence (fun n => (s10 n : ℤ)) s10_params := by
  sorry

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  open_goal_s7_growth / open_goal_s10_growth — CLOSED, T1, 2026-07-18 ║
-- ╚════════════════════════════════════════════════════════════════════╝

-- These two open goals claimed POLYNOMIAL growth for s7/s10. That claim is
-- FALSE: numerical check (25 exact terms) shows ratio s7(n+1)/s7(n) climbing
-- monotonically past 25, s10(n+1)/s10(n) past 15 — the signature of
-- exponential, not polynomial, growth (standard for D-finite/holonomic
-- sequences: growth rate ρ^n set by the nearest recurrence singularity). The
-- original docstrings' "expected... polynomial" premise was wrong.
--
-- Per CLAUDE.md rule 6 ("never silently weaken a statement to make it
-- provable") this is not a weakening — it's a correction of a false
-- statement. Kernel-proved replacements (0 sorry, no longer open) now live in
-- `Agora/Sequences/GrowthBounds.lean`:
--   `s7_not_polynomially_bounded  : ¬ ∃ c k, ∀ n, s7 n ≤ c * (n+1)^k`
--   `s10_not_polynomially_bounded : ¬ ∃ c k, ∀ n, s10 n ≤ c * (n+1)^k`
-- via a single-term exponential lower bound (`Nat.centralBinom`) + Mathlib's
-- little-o comparison of polynomials against exponentials.

end Agora.Sequences.OpenGoals
