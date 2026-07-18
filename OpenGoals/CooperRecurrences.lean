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
-- ║  open_goal_s7_growth                                                ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Cooper's s7 satisfies polynomial growth: ∃ c k, ∀ n, s7(n) ≤ c · n^k.

    STATUS: expected from literature asymptotic analysis (Cooper 2012, §4)
    but not kernel-verified. The sporadic sequences are known to grow
    polynomially, not exponentially, but the exact degree and leading
    coefficient require detailed asymptotic expansion.

    Grind-loop attempts:
    1. `omega` on polynomial inequalities — fails at the general level
       (requires concrete bounds, not arbitrary ∃).
    2. Analytic approach via generating functions — Mathlib lacks the
       infrastructure (asymptotic-series tactics).
    3. Direct literature citation + trusted_constant — would require
       an axiom of the form `axiom s7_growth : ∃ c k, ...` (T0 decision).

    Conclusion: either find a source with explicit bounds (Cooper paper
    full version) or escalate as an open research question. -/
lemma open_goal_s7_growth :
    ∃ c k : ℕ, ∀ n : ℕ, s7 n ≤ c * (n + 1) ^ k := by
  sorry

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  open_goal_s10_growth                                               ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Cooper's s10 (Yang–Zudilin numbers) satisfies polynomial growth.

    STATUS: s10(n) = Σ C(n,k)^4 is a classical sequence with known
    asymptotic behavior (related to Domb numbers), but explicit bounds
    require literature reference.

    Grind-loop attempts:
    1. Direct sum bound: Σ C(n,k)^4 ≤ (n+1) · max C(n,k)^4 — gives
       exponential bound, not polynomial. Tighter analysis needed.
    2. Classical reference (Domb literature) — check existence of explicit
       polynomial-growth result before kernel work.

    Conclusion: search Yang–Zudilin/Domb literature for tight bounds. -/
lemma open_goal_s10_growth :
    ∃ c k : ℕ, ∀ n : ℕ, s10 n ≤ c * (n + 1) ^ k := by
  sorry

end Agora.Sequences.OpenGoals
