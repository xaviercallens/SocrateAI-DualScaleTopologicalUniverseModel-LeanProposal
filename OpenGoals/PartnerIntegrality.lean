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

/-- CLOSED (2026-07-26, WP S1-13). The order-2 partner of Cooper's s7
    (= A279619) has integral coefficients at every index.

    STATUS: kernel-proved for all `n`, via a single external citation. Proof:
    `Agora.Sequences.Partner.s7_partner_integral`
    (`Agora/Sequences/PartnerIntegrality.lean`), combining
    `partnerSeq_s7_recurrence` (mechanical: `partnerSeq s7_params` satisfies
    O'Brien 2016's recurrence for his sequence `c₇` exactly — CAS-confirmed,
    then kernel-checked) with `Axioms.obrien2016_theorem6_2` (external: that
    recurrence forces integer values, O'Brien 2016 Theorem 6.2, p.47 —
    registered in `AXIOMS.md`).

    ⚠️ This closure used a citation, not machinery built from scratch — record
    kept below of how the ORIGINAL open-goal reasoning held up, since it was
    right about everything except assuming a proof route did not exist:

    WHY IT IS NOT AUTOMATIC. The defining recurrence is

      (k+2)²·a_{k+2} = a_{k+1}·(26(k+1)² + 13(k+1) + 2) − a_k·(−27k² − 27k − 6)

    with leading coefficient `(k+2)²`. Integrality therefore requires
    `(k+2)² ∣ RHS` at every step — an Apéry-style arithmetic statement of the same
    family as the classical integrality of the Apéry numbers, not a consequence of
    the sequence's type. The contrast is visible in this very file's neighbours:
    the s10 and s18 partners satisfy the same shaped recurrence and are NOT
    integral (`s10_partner_not_integral`, `s18_partner_not_integral`, both
    complete). So no argument that ignores the specific parameters can work.

    ROUTE MOST LIKELY TO CLOSE IT (2026-07-26, as originally written). Not a
    direct induction — the divisibility is not step-local. O'Brien (2016),
    Theorem 6.1 [CORRECTED BELOW: should read Theorem 6.2] gives the route via
    the level-7 Hauptmodul expansion. Formalising it needs modular-forms
    machinery that the pinned Mathlib does not have, so this is plausibly
    "blocked-on-mathlib" — that judgement is T0's to make, deliberately not
    made here. ★ T0 subsequently ruled `blocked-on-mathlib` on Deep Think's
    concurrence (2026-07-26) — see the CLOSED update below for why that
    ruling, though reasonable on the information available, undersold the
    route: the modular-forms machinery is needed to ESTABLISH O'Brien's
    q-expansions, not to USE his already-proved conclusion. Citing his
    Theorem 6.2 directly, on the same footing as any other literature-sourced
    declaration in the `Axioms/` directory, sidesteps rebuilding that
    machinery entirely. ★

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

    UPDATE 2026-07-26 (WP S1-12, after Deep Think's Q6 answer). The goal was
    first REDUCED, conditionally: `FormalSqrt.sqrtSeq_dyadic` (Tier A, generic)
    proves the formal square root of ANY integer series is dyadic — only the
    prime 2 can appear in denominators. So modulo the (still-open) bridge
    `open_goal_partner_eq_sqrt_s7`, the odd-prime half was already done, and
    what remained was exactly the 2-adic cancellation — the arithmetic anomaly
    Deep Think attributed ([B], unformalised) to the level-7 parametrisation.

    CLOSED 2026-07-26 (WP S1-13, same day). The reduction above turned out to
    be unnecessary: `partnerSeq_s7_recurrence`
    (`Agora/Sequences/PartnerIntegrality.lean`) shows `partnerSeq s7_params`
    satisfies O'Brien (2016)'s recurrence for his sequence `c₇` EXACTLY —
    same coefficients, same initial data, CAS-confirmed then kernel-checked.
    His **Theorem 6.2** (not 6.1 — the citation above named the wrong theorem;
    6.1 only proves the generating-function correspondence, 6.2 proves
    integrality, by an explicit coefficient-matching induction, NOT the generic
    "η-quotient corollary" first reported to us) proves that recurrence forces
    integer values. Cited as `Axioms.obrien2016_theorem6_2`
    (`Agora/Axioms/OBrien2016.lean`, registered `AXIOMS.md`). No modular-forms
    machinery needed to be built: it is needed to ESTABLISH O'Brien's
    q-expansions, not to USE his already-published conclusion. -/
theorem open_goal_partner_integral_s7 :
    ∀ n, IsIntegral (partnerSeq s7_params n) := by
  exact Agora.Sequences.Partner.s7_partner_integral

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
       classification is T0's call.

    UPDATE 2026-07-26 (WP S1-14). T0 ruled this goal `blocked-on-mathlib` on Deep
    Think's concurrence. Before accepting that for a SECOND time this session
    (having just found it wrong for `open_goal_partner_integral_s7`, S1-13),
    tried a fourth, different strategy — with a real result, though not closure.

    4. Verify `Σ partnerSeq(i)·partnerSeq(n−i) = s7(n)` holds as a genuine
       IDENTITY, not just plausible, then try `ore_algebra`'s `symmetric_power`
       (the same Sage tool that derived the WZ certificates for
       `open_goal_recurrence_s7`/`_s10`) to find a certificate for it directly.
       — The identity itself is STRONGLY confirmed: the convolution of
         `partnerSeq s7_params` with itself satisfies COOPER'S OWN 3-term
         recurrence exactly, verified in exact rational arithmetic to `n = 38`
         (two independent encodings: the `f_seq`/`cooper_s7` script from S1-10's
         session and a fresh one this session — same result, and matches the
         `n ≤ 3` kernel-checked instances of `sqrt_matches_partner_s7` above).
         This is strong evidence the goal is TRUE, not merely "plausible because
         everyone says so" — recomputed per the standing rule, not inherited.
       — `symmetric_power(2)` applied to the (independently sanity-checked —
         confirmed to annihilate the known partner values `1,2,22,336,…`
         directly) order-2 recursion operator for `partnerSeq` returned an
         order-3 operator, but with DEGREE-8 polynomial coefficients (vs.
         Cooper's own degree-2/3), and — checked directly against the
         convolution sequence, not just assumed — it does **not** annihilate
         it (nonzero residuals from `n = 0`, exact rational arithmetic, not a
         precision artifact). `GCRD(sym2, cooper_op) = 1` (no common right
         factor) confirms this isn't just a normalization mismatch. Two
         genuine index-convention bugs were found and fixed in the operator
         setup along the way (both operators individually verified against
         known sequence values before this test — a real, if unglamorous,
         improvement to how this class of check should be done in future
         sessions) — the mismatch persisted after both fixes. Read as a tool
         limitation of this pinned `ore_algebra` build (already flagged
         elsewhere as incompatible with this Sage version at HEAD) rather than
         a refutation of the identity, given the independent triple
         verification above — but NOT confirmed as a tool bug; recorded
         honestly as unresolved.

    NET ASSESSMENT: the "blocked-on-mathlib" framing (needing `PowerSeries`
    reversion/holonomic-sequence APIs) describes why a GENERIC, abstract Sym²
    transport theorem is out of reach, but may overstate the difficulty of THIS
    SPECIFIC instance — an elementary hand derivation exists in principle (the
    `s0, s1, s2` elimination already sketched in
    `scripts/verify_sym2_partner_identities.py`'s `sym2_monic` docstring,
    redone at the coefficient/`Finset.sum` level rather than the `Polynomial ℚ`
    level, avoiding `RatFunc` entirely since `θg(n) := n·g(n)` is DEFINITIONAL
    for coefficient sequences — no Leibniz rule to prove, no `PowerSeries` type
    needed). Not attempted in Lean this session: real, multi-lemma effort
    (Leibniz-for-convolution via `Finset.sum` reindexing, the coupled `s0,s1,s2`
    recursion in cleared/polynomial form, then a recursion-uniqueness argument)
    — plausibly substantial but not "blocked" in the same sense as
    `open_goal_partner_integral_s7` was before S1-13. Recommend: worth a
    dedicated session, not a re-litigation of "blocked-on-mathlib" without new
    information. -/
theorem open_goal_partner_eq_sqrt_s7 :
    ∀ n, partnerSeq s7_params n = FormalSqrt.sqrtSeq (fun k => (s7 k : ℤ)) n := by
  sorry

end Agora.Sequences.OpenGoals
