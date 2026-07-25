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
import Agora.Sequences.WZCertificates

namespace Agora.Sequences.OpenGoals

open Agora.Sequences

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  open_goal_recurrence_s7                                           ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- CLOSED (2026-07-25, WP S1-09). Cooper's s7 closed-form binomial sum
    satisfies the s7_params three-term recurrence.

    STATUS: kernel-proved for all `n ≥ 1`. Tier A, unqualified — the proof
    uses no axiom beyond Lean's own `propext`/`Classical.choice`/`Quot.sound`,
    no `native_decide`, and no `sorry`. Proof: `Agora.Sequences.WZ.s7_satisfies`
    in `Agora/Sequences/WZCertificates.lean`.

    How it was closed. The three strategies recorded below were all sound in
    their diagnosis: the missing piece was an explicit Wilf–Zeilberger
    creative-telescoping certificate, which Gorodetsky (arXiv:2102.11839) does
    not supply (that paper argues by the constant-term / Laurent-polynomial
    method instead). The certificate was therefore derived independently by
    computer algebra — SageMath + `ore_algebra`, see
    `scripts/derive_wz_certificates_s7_s10.sage` and
    `docs/WZ_CERTIFICATE_ANALYSIS.md` ADDENDUM 4 — and then re-proved from
    Mathlib's `Nat.choose` API inside Lean. The CAS output serves only as a
    witness: it is not trusted by the final proof, and a wrong certificate
    would simply have failed to compile.

    Superseded grind-loop record (kept for the audit trail):
    1. `induction n` + `simp [s7]` on the step — fails; genuine
       hypergeometric-sum identity, not a syntactic rewrite.
    2. `decide` at the ∀ n level — inapplicable.
    3. `exact?`/`apply?` — no matching Mathlib lemma; Mathlib has no
       creative-telescoping / Zeilberger tactic. (Still true; the proof
       supplies the certificate by hand rather than deriving it in Lean.) -/
theorem open_goal_recurrence_s7 :
    SatisfiesCooperRecurrence (fun n => (s7 n : ℤ)) s7_params := by
  exact Agora.Sequences.WZ.s7_satisfies

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  open_goal_recurrence_s10                                          ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- CLOSED (2026-07-25, WP S1-09). Cooper's s10 closed-form binomial sum
    satisfies the s10_params three-term recurrence.

    STATUS: kernel-proved for all `n ≥ 1`. Tier A, unqualified — no axioms
    beyond Lean's own, no `native_decide`, no `sorry`. Proof:
    `Agora.Sequences.WZ.s10_satisfies` in `Agora/Sequences/WZCertificates.lean`.

    Closed by the same route as `open_goal_recurrence_s7` (see that docstring
    for the provenance of the certificate). The s10 summand `C(n,k)⁴` has a
    single binomial factor, so the Lean encoding needs only one Pascal-ratio
    "atom" family and is markedly shorter than s7's, even though s10's
    certificate is the larger of the two (degree 11 / 33 terms vs degree 7 /
    19 terms). -/
theorem open_goal_recurrence_s10 :
    SatisfiesCooperRecurrence (fun n => (s10 n : ℤ)) s10_params := by
  exact Agora.Sequences.WZ.s10_satisfies

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
