# INTERNAL DRAFT — Physics-Tier Gaps in the Lean Repository

**Status:** ⚠️ INTERNAL MEMO — NOT a scientific report, NOT for external distribution or citation.
**Purpose:** Catalogue, for Xavier's review, every place in the Lean repository where prose
docstrings or theorem names claim more than the underlying Lean statement establishes, so
these can be fixed (rewritten, re-scoped, or explicitly quarantined) before any of this
material is presented externally.
**Trigger:** Produced while preparing `manuscript/main.tex` (the math-only formal report on
the Cooper-sequence formalization). That manuscript deliberately excludes everything below;
this memo exists so the exclusion is a documented decision, not a silent omission.
**Audience:** Xavier Callens (T0) only.

---

## Why this memo exists

CLAUDE.md rule 6 ("never silently weaken a statement to make it provable") has a mirror image
that this project's epistemic-guardrails skill also enforces: never silently *strengthen* a
docstring's prose beyond what the adjacent Lean statement proves. While surveying the full
`Agora/` tree to write the math manuscript, I found several places where this mirror rule is
violated — the Lean *statement* is a small, correct, often-trivial fact, but the *docstring or
theorem name* asserts something considerably stronger, in the register of an established
physical result. None of this is presented as fixed here; it is presented as **findings**, for
you to decide how to handle (rewrite, delete, re-scope as explicitly-conjectural, or leave as
internal scratch work never meant for publication).

None of the findings below affect the mathematics reported in `manuscript/main.tex`. That
manuscript's five results (sequence encoding, θ-operator order, symmetric-square API, the
generic $W\equiv0$ theorem, growth-bound correction) do not import, depend on, or reference any
file discussed below.

---

## Finding 1 — `pipeline_upper_bound`: axiom self-documented as vacuous, still cited in prose

**File:** `Agora/Axioms/PipelineBound.lean`

**The axiom:**
```lean
axiom pipeline_upper_bound : ∃ (S12_max : ℝ), S12_max ≤ 1.177 ∧ S12_max > 0
```

**The problem:** This existential is witnessed trivially by `S12_max = 1` and carries **no**
information about any actual pipeline computation — a fact the axiom's *own* docstring
discloses in capital letters: `[DISCLOSED-VACUOUS: Awaiting static cryptographic data artifact
from Stream 2/3]`. This is good — the vacuity is honestly flagged at the point of
declaration. The gap is downstream: `Agora/Swampland/DualScaleStability.lean`'s
`master_moduli_stabilization` theorem consumes this axiom via `pipeline_ensures_perturbative`
and folds its conclusion into clause (v) of a five-part conjunction titled "MASTER THEOREM
(Dual-Scale Moduli Stabilization)" — a name that reads, out of context, as an established
result. Anyone citing `master_moduli_stabilization` without reading all the way down to this
axiom's docstring would not learn that 1/5 of its clauses is content-free.

**Recommendation:** Either (a) rename `master_moduli_stabilization` to make the dependency on
an admittedly-vacuous axiom visible in the name/docstring itself (not just three files away),
or (b) split the theorem so the four genuinely-proved clauses (i–iv, which really are just
"product of positives is positive" restated four ways — see Finding 3) are stated separately
from clause (v), which should not be bundled into anything called a "master theorem" until the
axiom is discharged.

---

## Finding 2 — `theorem3_holds`: explicitly vacuous, but the Master Theorem's prose claims otherwise

**File:** `Agora/DualScaleMaster.lean`

**The statement:**
```lean
def theorem3_holds : Prop := ∃ (alpha_eff : ℝ), alpha_eff > 0.45
```

**The problem:** This is even more direct than Finding 1. The theorem discharging it
(`m87_alpha_eff_certificate`) has a docstring that says outright: *"the statement `∃ v, v >
0.45` is trivially true (witness 1) and carries NO M87\* content... `theorem3_holds` therefore
remains a content-free placeholder."* That is exemplary self-disclosure at the point of proof.
But `dual_scale_universe_model_consistent` (the file's top-level "MASTER THEOREM") has a
docstring claiming the combined result shows the model is:

> "(3) OBSERVATIONAL CONSISTENCY: The chameleon mechanism rescues the S₁,₂ axion from M87\*
> superradiance bounds... Observationally viable (consistent with EHT M87\* data)"

This directly contradicts the disclosure three declarations earlier in the same file. A reader
who only reads the master theorem's docstring (the natural entry point) will never learn that
the "observational consistency" clause is `∃ v, v > 0.45`, provable by `v := 1`, with no
reference to M87\*, EHT, or any physical quantity at all.

**Recommendation:** Rewrite `dual_scale_universe_model_consistent`'s docstring to state plainly
that clause 3 is a content-free placeholder pending a non-vacuous Theorem 3 restatement (the
docstring on `m87_alpha_eff_certificate` already says this correctly — it just needs to be
repeated where a reader will actually see it first), or remove the "observational consistency"
framing from the master theorem's prose entirely until that gap closes.

---

## Finding 3 — "Moduli stabilization" / "Hessian positive-definiteness" is a positivity-of-a-product argument, not a computed physical Hessian

**File:** `Agora/Swampland/DualScaleStability.lean`

**The mathematical content, honestly stated:** For a *postulated* (not derived) toy potential
$V_F(\tau_1,\tau_2) = A e^{-a\tau_1} + B e^{-b\tau_2}$ with $A,B,a,b$ stipulated positive reals,
the function is trivially positive, and its two independent second partials are each trivially
positive (product of positive reals), while the mixed partial is postulated to be exactly zero
by the choice of functional form (a `def` returning `0`, not a derived consequence of any
Kähler potential). "Sylvester's criterion" is then applied to a $2\times1$ diagonal Hessian
whose off-diagonal entry is zero by construction — this reduces Sylvester's criterion to
"product of two positive numbers is positive," proved by `mul_pos`.

**The problem:** This is real, correctly-proved elementary calculus/algebra. The issue is
entirely in the framing: docstrings describe it as "F-theory vacuum stability," cite Sylvester's
criterion, KKLT, and the Swampland Distance Conjecture literature
(`briefs`/file headers cite `[KKLT03]`, `[BBCQ05]`, `[Palti19]`, `[OVV18]`), and the section
header claims "LEVEL 2 — Hessian Positive-Definiteness (Sylvester's Criterion)" as though an
actual physical scalar potential's Hessian were computed from a Kähler potential and
superpotential. No such derivation exists in this file or anywhere in the repository; $V_F$'s
functional form is asserted, not derived, and the "no cross-coupling" claim
(`d2V_mixed := 0`) is a definitional stipulation, not a proven consequence of the K3×T² product
structure it's attributed to.

**Recommendation:** Either (a) retitle this file's claims honestly — e.g. "a toy factorized
potential is Hessian-positive-definite by construction" rather than "the F-theory vacuum is
stable" — or (b) if a genuine derivation of $V_F$ from an actual Kähler potential is intended
future work, mark every current theorem here as provisional/illustrative in its docstring, not
just in the file header (which most readers skip).

---

## Finding 4 — Chameleon/M87\* "rescue": real inequality arithmetic, stipulated physical inputs

**File:** `Agora/Phenomenology/ChameleonRescue.lean`

**The mathematical content, honestly stated:** Given the definition
$\alpha_{\text{eff}} = \alpha_{\text{bare}} \cdot (\rho_b/\rho_{\text{crit}})^{1/4}$ and the
**stipulated** canonical parameters `alpha_bare := 0.155`, `rho_ratio := 1000000`, the
inequality $\alpha_{\text{eff}} > 0.45$ is correctly and rigorously proved (this part is genuine
and good real-analysis work — `m87_numerical_certificate` and
`density_threshold_certificate` were correctly converted from axioms to proved theorems in an
earlier session, and the rpow arithmetic is sound). The `0.155`, `10^6`, and `0.42` threshold
values are not derived from, or fit to, any actual M87\* observational data in this repository;
they are asserted in `m87_canonical`'s definition and in `alpha_superradiance_threshold`'s
definition, with citations in the surrounding prose (EHT 2019, Brito–Cardoso–Pani 2015) that
are **not connected to the Lean statements by any derivation** — the citations justify that
*these kinds of numbers* appear in the literature, not that *these specific values* are the
correct ones for whatever physical axion this repository is modeling.

**The problem:** `master_chameleon_evasion`'s docstring states: *"This formally verifies that
the Dual-Scale model is CONSISTENT with the Event Horizon Telescope observations of M87\*."*
This is a substantially stronger claim than "given these stipulated numbers, this inequality
holds" — it implies the numbers themselves are established, which they are not.

**Recommendation:** Rewrite `master_chameleon_evasion`'s docstring to state precisely what is
proved: the inequality holds *for the stipulated canonical parameters*, and flag explicitly
that those parameters are illustrative/assumed, not measured or derived. Consider renaming
`m87_canonical` to something like `m87_illustrative_params` to make the epistemic status visible
at every call site.

---

## Finding 5 — `DiscriminantLocus.lean`: narrative physics dressing over a threshold lookup table

**File:** `Agora/Geometry/DiscriminantLocus.lean`

**The mathematical content, honestly stated:** `classify_observation` is an `if/else` chain on
numeric thresholds (1, 10, 30); `tate_algorithm` is a hardcoded pattern match from a handful of
`(ord_f, ord_g, ord_Δ)` triples to gauge-algebra labels (a correct restatement of the textbook
Tate's algorithm lookup table, not a derivation of it); `GaugeAlgebra.rank` is a hardcoded
arithmetic function. The two theorems proved (`extreme_threshold`, `standard_model_rank`) are
correct but essentially case-split bookkeeping.

**The problem:** The file's docstrings state as fact, with no conjecture marker, claims like:

> "High Δ_obs signifies dense Dark Matter subhalos undergoing tidal disruption — the
> macroscopic manifestation of 7-brane wrapping in the compact extra dimensions."

and lists specific fabricated-looking "observations" (`K3-DISC-0003: Δ_obs = 47.0 → massive
7-brane intersection`) with no data source, no fetch, no citation — this looks like placeholder/
illustrative data that was never flagged as such, and directly violates this project's own
anti-hallucination protocol ("no numbers from memory... every numeric constant... must trace to
a checker certificate... or a cited file"). No Lean theorem in this file proves any correlation
between an observed discriminant value and a dark matter interpretation; the `DiscriminantObservation`
structure is just a record type with a nonnegativity field.

**Recommendation:** This file should not be cited as evidence of anything about dark matter
without (a) a real, sourced dataset behind the `DiscriminantObservation` instances, and (b)
every physical-interpretation sentence in the docstrings rewritten with an explicit conjecture
marker, per the epistemic-guardrails skill's Tier C rule. As it stands, this file is the
clearest instance of "physics-washing" found in the survey.

---

## Finding 6 — `FTheoryFibration.lean` mixes a genuinely proved Tier A/B result (§1–3) with unmarked Tier C narrative (§4–11) in one file

**File:** `Agora/Geometry/FTheoryFibration.lean`

**What's actually solid (§1–3):** The order-classification result (encoded operators have
θ-degree exactly 2 or exactly 3, and these are mutually exclusive) is real, kernel-checked, and
correctly scoped in its own docstrings — e.g. `master_fibration_classification`'s docstring
explicitly says "NOT established here... that these operators are minimal for their sequences,
the elliptic/K3 period identifications, and any F-theory vacuum architecture." This is exactly
the right discipline. This is the part reused (independently, via direct citation of the
underlying `cooperThetaOperator_natDegree` fact) as Theorem 1 in `manuscript/main.tex`
Section 6 — though the manuscript states it purely as an operator-order fact, without the
"elliptic curve"/"K3 surface" labels, to avoid importing any geometric-identification
connotation those names carry.

**What's not solid (§4–11, same file):** The Weierstrass model, discriminant locus, "Dual-Scale
Dictionary" (`is_smooth_region`, `is_moderate_degeneration`, mapping `Δ_obs` thresholds to
"massive 7-brane intersection" and "tidal disruption"), and `CY4Topology` sections have the same
character as Finding 5: physically-loaded prose with no conjecture marker, attached to
definitionally-trivial Lean content (threshold `if` chains, a positivity lemma
`discriminant_pos_of_f_pos_g_ne_zero` that is standard real-number algebra). The final
`master_fibration_classification` combines the solid §1–3 result with an implicit invitation
(via file structure and section numbering) to read it alongside §4–11's narrative, even though
nothing in §1–3's *statement* depends on or licenses §4–11's claims.

**Recommendation:** Consider physically splitting this file: move §1–3 (order classification) to
a file with a name that doesn't carry "F-theory" framing (e.g. `OperatorOrderClassification.lean`),
and move §4–11 to a clearly-marked speculative/phenomenology file, so the two epistemic tiers
are not just documentation-separated but file-separated.

---

## Summary table

| File | Genuinely proved content | Overclaiming issue | Severity |
|---|---|---|---|
| `Axioms/PipelineBound.lean` | — (axiom, self-disclosed vacuous) | Downstream "master theorem" bundles it without repeating the disclosure | Medium |
| `DualScaleMaster.lean` | Theorem 1 (real, via import), Theorem 2 (trivial positivity) | `theorem3_holds` explicitly vacuous but master docstring claims "observationally viable... consistent with EHT data" | **High** — direct self-contradiction in the same file |
| `Swampland/DualScaleStability.lean` | Positivity of a postulated toy potential and its partials | "F-theory vacuum stability" / Sylvester's criterion framing over an undereived potential | Medium-High |
| `Phenomenology/ChameleonRescue.lean` | Correct rpow inequality arithmetic (genuinely good work) | Stipulated parameters presented as if measured/derived; "CONSISTENT with EHT observations" overclaim | Medium-High |
| `Geometry/DiscriminantLocus.lean` | Threshold lookup, Tate's-algorithm table restatement | Fabricated-looking unsourced "observations," unmarked dark-matter narrative | **High** — closest to a straightforward anti-hallucination-protocol violation |
| `Geometry/FTheoryFibration.lean` §4–11 | Standard discriminant algebra | Same pattern as DiscriminantLocus, co-located with the genuinely solid §1–3 | Medium |

---

## What I did NOT do

- I did not modify, delete, or "fix" any of the files above. This memo is diagnostic only.
- I did not include any of this material in `manuscript/main.tex`, which is scoped to only the
  sequence/operator formalization (Sections 4–9 of that document) and explicitly states the
  exclusion in its own Section 10 ("Scope boundary: what this report does not claim").
- I did not attempt to adjudicate whether the underlying physical ideas (chameleon screening,
  LVS moduli stabilization, F-theory discriminant/dark-matter correspondence) are worth pursuing
  — that is a T0/Xavier judgment call, not something this memo takes a position on. The finding
  is narrowly about the gap between what current docstrings *claim* and what the current Lean
  statements *prove*.

## Suggested next step

Your call on how to proceed — options in ascending order of effort:
1. Add a blanket disclosure banner to the top of each affected file (`DualScaleMaster.lean`,
   `DualScaleStability.lean`, `ChameleonRescue.lean`, `DiscriminantLocus.lean`,
   `FTheoryFibration.lean` §4–11) stating plainly that the physical interpretation is
   illustrative/speculative and the numerical inputs are stipulated, not derived or fit to data.
2. Rewrite the specific overclaiming sentences identified above (Findings 1–6) to match their
   Lean content exactly, keeping the files but removing the mismatch.
3. Physically separate genuinely-proved content (Finding 6's §1–3) from speculative narrative
   (everything else), as suggested in Finding 6.
4. Leave as-is if this material is understood internally to be scratch/exploratory work never
   intended for external presentation — in which case, consider adding a top-level repository
   note (e.g. in README) stating that `Agora/Swampland/DualScaleStability.lean`,
   `Agora/Phenomenology/ChameleonRescue.lean`, `Agora/DualScaleMaster.lean`, and
   `Agora/Geometry/DiscriminantLocus.lean` are exploratory and excluded from the project's
   formal-verification claims, mirroring the exclusion already made explicit in
   `manuscript/main.tex` §10.

---

*Generated-by: Sonnet 5 (repository epistemic survey, requested alongside `manuscript/main.tex`)
| Verified-by: none — this is a diagnostic memo, not a claim requiring a checker | Reviewed-by:
T0 N (this memo IS the review request) | Distribution: Xavier only, not for external sharing.*
