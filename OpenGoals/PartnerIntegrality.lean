/-
  OpenGoals/PartnerIntegrality.lean
  ════════════════════════════════════════════════════════════════════════════════

  Named open goals for WP S1-11/S1-12 (Agora/Sequences/PartnerIntegrality.lean,
  Agora/Sequences/FormalSqrt.lean).

  This directory is the ONLY sorry-carrying location permitted on `main`
  (lean-proof-workflow skill, "sorry policy").

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.PartnerIntegrality

namespace Agora.Sequences.OpenGoals

open Agora.Sequences Agora.Sequences.Partner

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  open_goal_partner_integral_s7                                     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- OPEN. The order-2 partner of Cooper's s7 (= A279619) has integral
    coefficients at every index.

    STATUS: open. Kernel-checked to `n ≤ 7` (`s7_partner_integral_pass7`); checked
    to `n = 81` in exact rational arithmetic outside the kernel
    (`scripts/verify_sym2_partner_identities.py`, and the denominator scan in the
    S1-10 session). No counterexample is expected — A279619 is a catalogued
    integer sequence — but "catalogued as an integer sequence" is a claim about a
    database, not a proof, and this project has been burned by exactly that
    substitution before (E-007 finding 5, E-010).

    WHY IT IS NOT AUTOMATIC. The defining recurrence is

      (k+2)²·a_{k+2} = a_{k+1}·(26(k+1)² + 13(k+1) + 2) − a_k·(−27k² − 27k − 6)

    with leading coefficient `(k+2)²`. Integrality therefore requires
    `(k+2)² ∣ RHS` at every step — an Apéry-style arithmetic statement of the same
    family as the classical integrality of the Apéry numbers, not a consequence of
    the sequence's type. The contrast is visible in this very file's neighbours:
    the s10 and s18 partners satisfy the same shaped recurrence and are NOT
    integral (`s10_partner_not_integral`, `s18_partner_not_integral`, both
    complete). So no argument that ignores the specific parameters can work.

    ROUTE MOST LIKELY TO CLOSE IT. Not a direct induction — the divisibility is
    not step-local. O'Brien (2016), *"Modular forms and two new integer sequences
    at level 7"*, MSc thesis, Massey University, Theorem 6.1 (fetched and
    hash-pinned by Stream 2, `refs/literature_provenance.txt`) gives
    `A279619 = ` the expansion of the g.f. of `A002652` in powers of the level-7
    Hauptmodul `A279618`. Integrality of a `q`-expansion in powers of a Hauptmodul
    with integral `q`-expansion is the standard route to results of this shape.
    Formalising it needs modular-forms machinery that the pinned Mathlib does not
    have, so this is plausibly "blocked-on-mathlib" rather than merely hard —
    that judgement is T0's to make, and is deliberately not made here.

    Grind-loop record (three strategies, per the three-strikes rule):
    1. `induction` on the recurrence with `omega`/`decide` on the divisibility
       step — fails: `(k+2)² ∣ RHS` is not derivable from the integrality of the
       two predecessors alone; the statement needs strengthening to a
       simultaneous congruence, which is the actual research content.
    2. Strengthening to a `p`-adic valuation invariant (`v_p(a_n) ≥ 0` tracked
       per prime) — not attempted beyond design: the s10/s18 counterexamples show
       any such invariant must consume the parameters, and the 2-adic behaviour
       there (denominators exactly powers of 2) indicates the prime `2` is the
       only obstruction, which is a genuine lead but not a proof sketch.
    3. `exact?`/`apply?` against Mathlib — nothing applicable; Mathlib has no
       Apéry-integrality or Hauptmodul-expansion API at the pinned commit.

    UPDATE 2026-07-26 (WP S1-12, after Deep Think's Q6 answer). The goal has
    been REDUCED, conditionally: `FormalSqrt.sqrtSeq_dyadic` (Tier A, generic)
    proves the formal square root of ANY integer series is dyadic — only the
    prime 2 can appear in denominators. So modulo the bridge
    `open_goal_partner_eq_sqrt_s7` below, the odd-prime half of this goal is
    already done, and what remains is exactly the 2-adic cancellation — the
    arithmetic anomaly Deep Think attributes ([B], unformalised) to the level-7
    parametrisation. Strategy 2's suspicion that "2 is the only obstruction" is
    thereby confirmed on the sqrt side of the bridge. -/
theorem open_goal_partner_integral_s7 :
    ∀ n, IsIntegral (partnerSeq s7_params n) := by
  sorry

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  open_goal_partner_eq_sqrt_s7                                      ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- OPEN. The recurrence-defined partner IS the formal square root of the s7
    series: `partnerSeq s7_params = FormalSqrt.sqrtSeq (s7 ·)` at every index.

    STATUS: open. Kernel-checked at `n = 1, 2, 3` (`sqrt_matches_partner_s7`,
    with the s10 analogue at `n = 1, 2`); CAS-verified to `n = 59` for all three
    candidates in exact arithmetic (S1-12 session, scratchpad `q6_check.py`
    rederivable from `scripts/verify_sym2_partner_identities.py` data).

    WHY IT IS TRUE (informally — this is the part the kernel does not yet have).
    `L₃ = P₂·Sym²(L₂)` is kernel-proved AT OPERATOR LEVEL (PartnerOperators.lean).
    Sym² of an operator annihilates squares of its solutions, so the holomorphic
    solution `f` of `L₂` has `f² = Σ s(n)zⁿ`; both `partnerSeq` (coefficients
    of `f`) and `sqrtSeq` (formal square root, `sqrtSeq_sq`) then square to the
    same series with the same constant term `1`, and `ℚ⟦z⟧` is an integral
    domain, forcing equality. Every step is standard; none is currently
    formalisable here, because the pinned Mathlib has no machinery connecting a
    θ-form operator identity to statements about its solution sequences (no
    D-finite/holonomic API, no `PowerSeries` square root).

    CONSEQUENCE IF THE BRIDGE IS PROVED: `sqrtSeq_dyadic` transports to `partnerSeq`, making
    `open_goal_partner_integral_s7` purely 2-adic, and upgrading the s10/s18
    observation "denominators are exactly powers of 2" from PASS(59) to theorem.

    Grind-loop record (three strategies, per the three-strikes rule):
    1. Direct strong induction on `n` — fails: the step needs the convolution
       identity `Σ partnerSeq i · partnerSeq (n−i) = s7 n` as input, which is
       equivalent to the goal itself (simultaneous induction just relocates the
       same missing algebraic identity into the other branch).
    2. Simultaneous induction on (equality + convolution) — the convolution step
       then requires showing the `(k+2)²`-recurrence implies the convolution
       recurrence, i.e. the solution-level Sym² transport; that is a WZ-style
       certificate identity in its own right, not currently derivable without
       the missing operator-action-on-sequences framework.
    3. `exact?`/`apply?` / Mathlib search — no `PowerSeries.sqrt`, no holonomic
       sequence API at the pinned commit. Candidate "blocked-on-mathlib"; that
       classification is T0's call. -/
theorem open_goal_partner_eq_sqrt_s7 :
    ∀ n, partnerSeq s7_params n = FormalSqrt.sqrtSeq (fun k => (s7 k : ℤ)) n := by
  sorry

end Agora.Sequences.OpenGoals
