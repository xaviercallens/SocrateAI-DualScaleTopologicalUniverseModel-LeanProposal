/-
  OpenGoals/PartnerIntegrality.lean
  ════════════════════════════════════════════════════════════════════════════════

  Named open goal for WP S1-11 (Agora/Sequences/PartnerIntegrality.lean).

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
       Apéry-integrality or Hauptmodul-expansion API at the pinned commit. -/
theorem open_goal_partner_integral_s7 :
    ∀ n, IsIntegral (partnerSeq s7_params n) := by
  sorry

end Agora.Sequences.OpenGoals
