# Unified Vision: Dual-Scale Topological Universe Model

**Version:** 1.0 — 2026-07-16
**Companion document:** [`docs/THEORY_BUILDING_PLAN.md`](docs/THEORY_BUILDING_PLAN.md)
(the detailed, task-level execution plan for Stream 1; this document is the
program-level vision across all three streams).

---

## 1. The Unified Vision

The **Dual-Scale Topological Universe Model** proposes that dark matter and dark
energy phenomenology arise from a single F-theory compactification with a
**K3 × T² base and elliptic fiber**, and that this proposal can be held to a
higher evidentiary standard than is customary in string cosmology by pursuing
three mutually reinforcing lines of work:

1. **Theory** — machine-checked formal verification of the model's internal
   mathematical consistency (Lean 4).
2. **K3 Selection** — ML classification (AutoEvolve) of the candidate geometric
   objects: Cooper s₇/s₁₀ sequences (Order-3 Picard-Fuchs → K3 families) versus
   S₁₂/S₂₁ sequences (Order-2 Picard-Fuchs → elliptic-curve families).
3. **Experimentation** — GPU-based empirical validation (DarkMatter@Home)
   against survey data (SDSS, Euclid, PTA).

The unifying discipline: **every empirical claim becomes a certificate, every
certificate becomes a formal axiom with provenance, and every theorem's statement
mentions the real objects.** No stream is allowed to cite another stream's output
except through a versioned, machine-readable interface.

---

## 2. Three Parallel Streams

| Stream | Repository | Focus | Goal |
|--------|-----------|-------|------|
| **1. Theory** | `SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal` (this repo) | F-theory formalization in Lean 4 | Mathematically certify the Dual-Scale Model |
| **2. K3 Selection** | `SocrateAI-Scientific-Agora-K3-DarkMatter` | AutoEvolve for K3 sequence selection | Confirm Cooper s₇/s₁₀ as true K3 surfaces |
| **3. Experimentation** | `DarkMatterK3-Home.github.io` (local: `SocrateAI-Scientific-Agora-Home`) | GPU validation with SDSS/Euclid/PTA | Empirically validate the model |

All three progress in parallel and converge on three shared goals:
**(a)** formalize F-theory in Lean 4, **(b)** confirm Cooper s₇/s₁₀ as K3
surfaces, **(c)** validate empirically against survey data.

---

## 3. Key Hypotheses (stated falsifiably)

Each hypothesis carries a status, the stream that owns it, and — critically —
what evidence would *refute* it. A hypothesis without a refutation condition is
not admissible in this program.

**H-A. Cooper s₇/s₁₀ have Order-3 Picard-Fuchs ODEs and correspond to K3 families.**
- *Owner:* Stream 2 (numerical), Stream 1 (formal).
- *Support today:* the order-3 classification of Cooper's sporadic sequences is
  established in the mathematical literature (Cooper, Ramanujan J. 29 (2012));
  AutoEvolve reproduces it numerically.
- *Formal target:* Stream 1 WS2.4 — machine-checked minimal recurrence order = 3.
- *Refuted if:* an order-≤2 polynomial-coefficient recurrence for s₇ or s₁₀ is
  exhibited (finitely checkable per degree bound, see plan WS2.4).

**H-B. S₁₂/S₂₁ have Order-2 Picard-Fuchs ODEs and correspond to elliptic-curve families.**
- *Owner:* Stream 2 (numerical), Stream 1 (formal).
- *Formal target:* WS2.4 — minimal order = 2, plus the mathlib `WeierstrassCurve`
  model (WS2.5).
- *Action required:* pin the exact OEIS IDs / recurrences for S₁₂ and S₂₁ in a
  cross-stream registry (see §4, Interface I-1). Ambiguity here silently breaks
  both streams.
- *Refuted if:* an order-1 recurrence exists, or the minimal order exceeds 2.

**H-C. Δ_obs spikes in survey data (e.g., K3-DISC-0003) correspond to 7-brane
intersections on the discriminant locus.** ⚠️ *Boldest hypothesis — highest risk.*
- *Owner:* Stream 3 (detection), Stream 1 (formal statement of the locus).
- *Honest status:* this is an **interpretive bridge**, not yet a derivation. The
  chain (F-theory discriminant locus → 4D observable → statistic Δ_obs in
  SDSS/Euclid maps) has no written derivation with stated assumptions. Until it
  does, K3-DISC detections are *anomalies consistent with the model's narrative*,
  not evidence for it.
- *Required before any claim:* a derivation note (analogous to plan WS4.1) giving
  the predicted signal shape, amplitude, and — indispensably — the **look-elsewhere
  effect / trials factor** for spike detection, reviewed by a human cosmologist
  (**Checkpoint H1-b**, added to the plan's checkpoint table).
- *Refuted if:* the derived signal amplitude is below survey sensitivity, or
  detected spikes are consistent with the null (systematics/LSS) at the stated
  significance after trials correction.

---

## 4. Cross-Stream Interfaces (data contracts)

Streams may only consume each other's outputs through these versioned artifacts.
This is what makes parallel progress safe — and what makes lower-tier LLM agents
safe to deploy in any stream.

**I-1. Sequence Registry** (Stream 2 → Streams 1, 3)
- `data/registry/sequences.json`: for each of {S₁₂, S₂₁, s₇, s₁₀} — canonical
  name, OEIS ID, defining recurrence (exact rational coefficients), seed values,
  first 50 terms, literature citation.
- Single source of truth. Stream 1's Lean definitions (plan WS2.2) and Stream 2's
  AutoEvolve configs are both *generated* from it.
- Status: **does not exist yet — highest-priority cross-stream task** (tier T-S,
  owner: Stream 2, consumed by plan WS2.2).

**I-2. Classification Certificates** (Stream 2 → Stream 1)
- `data/certificates/*.json`: AutoEvolve output per sequence — claimed minimal
  order, coefficient degree bound searched, number of terms verified, pipeline
  version, input-data hash, timestamp.
- Rendered into Lean by `scripts/gen_certificates.py` (plan WS5.1): as decidable
  lemmas where possible, as provenance-documented axioms otherwise.

**I-3. Observation Certificates** (Stream 3 → Streams 1, 2)
- Per detection (e.g., K3-DISC-0003): survey, sky coordinates, statistic value,
  null distribution, significance *after trials correction*, pipeline version,
  data-release hash.
- Consumed by Stream 1 only after the H-C derivation note exists; consumed by
  Stream 2 as training/validation data.

**I-4. Formal Constraint Feedback** (Stream 1 → Streams 2, 3)
- The parameter boxes under which Stream 1's theorems hold (LVS box from plan
  WS3.3, axion-mass window from WS4) published as
  `data/constraints/formal_bounds.json` per release.
- Stream 2's fitness functions and Stream 3's search priors must respect these —
  the loop "ML proposes, Lean disposes, experiment decides."

---

## 5. Stream 1 Goals — Reconciled with the Theory-Building Plan

The originally proposed Stream 1 task list is preserved below, **re-mapped onto
the audited reality** documented in `docs/THEORY_BUILDING_PLAN.md` §2. The key
correction: the three theorem files already compile 0-sorry — "completing" them
does not mean making them build; it means **giving their statements real
mathematical content**. That is what the timelines below price in.

| Proposed task | Reality check (plan ref) | Re-scoped deliverable | Owner / Tier | Realistic timeline |
|---|---|---|---|---|
| Complete `FTheoryFibration.lean` (Theorem 1) | Statement currently reduces to 2 ≠ 3 (G1) | Minimal recurrence order 2 vs 3 for the registry sequences (WS2.1–2.4, now covering all four: S₁₂, S₂₁, s₇, s₁₀) | Fable 5 design + Sonnet proofs; human math review (H5) | Milestone A: ~3 mo |
| Complete `DualScaleStability.lean` (Theorem 2) | Current potential is a runaway with no critical point (G2) | Genuine LVS potential, proven critical point + PosDef Hessian, non-vacuous SDC (WS3) | Human validates potential (H2, blocking) → Fable skeleton → Sonnet | ~2 mo after H2 |
| Complete `ChameleonRescue.lean` (Theorem 3) | Currently circular; physics inputs suspect (G3) | Human-validated derivation note, then formalized exclusion window with units and EHT error box (WS4) | Phenomenologist (H1, blocking) → Fable → Sonnet | ~1–2 mo after H1 |
| Formalize `Weierstrass.lean` | Hand-rolled structure duplicates mathlib | Migration to mathlib `WeierstrassCurve`, explicit discriminant locus (WS2.5) | Sonnet | ~1 mo, parallel |
| Formalize `DiscriminantLocus.lean` (Δ_F as 7-brane locus) | Formal statement OK to build; *observational* link is H-C and needs derivation | Discriminant locus over the Weierstrass family; H-C bridge stated as an explicit conjecture, not a theorem | Fable + human (H1-b) | With WS2.5; H-C note before any claim |
| Publish preprint (arXiv, 4–6 wks) | Not honest at 4–6 wks for "certification"; see two-paper strategy below | **Paper 1** (methodology) at ~8–10 wks | Xavier + Fable drafting; H6 sign-off | ~10 wks |
| Submit PRD/JHEP (6–12 wks) | Requires real Theorems 1–3 content | **Paper 2** (results) after v0.5 | Xavier + coauthors from checkpoints | ~6–9 mo |

**Two-paper publication strategy** (replaces the single 4–6 week preprint):

- **Paper 1 — Methodology (target: ~10 weeks, arXiv hep-th + cs.LO):**
  *"A certificate pipeline for machine-checked consistency arguments in string
  cosmology."* Content: the three-stream architecture, the axiom-as-certificate
  discipline (WS5), verified-numerics elimination of numerical axioms (WS1), and
  the P-recursive framework with the bounded-degree minimality result (WS2
  milestone A) if it lands in time. Every claim scoped to what
  `#print axioms` supports. This paper is publishable *and honest* on the
  short timeline.
- **Paper 2 — Results (target: ~6–9 months, PRD/JHEP + ITP/CICM companion):**
  the certified Dual-Scale Model: real Theorems 1–3, the H-C bridge (if it
  survives review), and joint constraints with Streams 2–3. Coauthorship offered
  to H1/H2/H5 reviewers per the plan's credit policy.

**Ownership correction:** the proposed table listed "Xavier" as owner of every
task. Under the tiered-delegation protocol (plan §5), Xavier owns *decisions and
sign-offs* (checkpoints H1–H6); Fable 5 owns statement design; Sonnet/Haiku own
goal-closing under CI guardrails. This is what makes the parallel-stream workload
sustainable for a single human lead.

---

## 6. Convergence Criteria — what "done" means

The program converges when all three hold simultaneously, each machine-auditable:

1. **Theory certified:** `#print axioms dual_scale_universe_model_consistent`
   lists *only* observational axioms generated from I-2/I-3 certificates, each
   with provenance; theorem statements mention the registry objects (Stream 1,
   plan v1.0 gate).
2. **K3 selection confirmed:** H-A and H-B hold formally (minimal orders 3 and 2,
   machine-checked at least at bounded coefficient degree), with AutoEvolve
   certificates and Lean proofs generated from the *same* registry entry (I-1).
3. **Empirical validation:** at least one Stream 3 detection survives the H-C
   derivation note's predicted signal shape and trials-corrected significance
   threshold — or, if H-C is refuted, the program publishes the refutation and
   the model's surviving, weaker observational status honestly.

Note the asymmetry by design: streams 1–2 can *succeed* while stream 3 refutes
H-C. A refutation is a scientific result of this program, not a failure of it.

---

## 7. Program-Level Risks & Review Additions

(Extends the risk register in `docs/THEORY_BUILDING_PLAN.md` §9.)

| Risk | Mitigation |
|------|-----------|
| **H-C is an unproven bridge** carrying the program's headline narrative | Add **Checkpoint H1-b**: a cosmologist reviews the Δ_obs derivation note before any public claim ties K3-DISC detections to 7-branes. Until then, all three repos must label H-C "conjecture." |
| **Sequence naming drift** (S₁₂/S₂₁/s₇/s₁₀ meaning different things in different repos) | Interface I-1 registry is the single source of truth; all streams generate from it. Build it first. |
| **Claim inflation across repos** (Stream 2/3 docs include "Certification"/"Discovery Report" language) | Extend plan WS0.4 claim discipline program-wide: each repo's README states exactly which hypotheses are proven, certified-conditional, or conjectural, synchronized at each Stream 1 release. |
| **Timeline pressure → dishonest preprint** | Two-paper strategy (§5); Paper 1 is achievable fast *because* its claims are modest. H6 blocks any submission. |
| **Single-human bottleneck** | Tiered delegation (plan §5) + call for contributions (plan WS6.4) with coauthorship credit for checkpoint reviewers. |

---

## 8. Immediate Cross-Stream Priorities (next 4 weeks)

1. **Build the Sequence Registry (I-1)** — unblocks Stream 1 WS2.2 and pins
   H-A/H-B. *(T-S, Stream 2 repo)*
2. **Stream 1 WS0 + WS1** — CI, axiom gate, reference repair, claim scope-down,
   numerical axioms eliminated → release v0.2. *(T-H/T-S, this repo)*
3. **Commission checkpoint H1 and H1-b reviews** — the two blocking human
   reviews (M87* chain; Δ_obs bridge). Start recruiting reviewers now; they gate
   the longest paths. *(T-HU, Xavier)*
4. **Draft Paper 1 skeleton** from the blueprint (WS0.5) so writing proceeds in
   parallel with WS1/WS2. *(T-F)*

---

*Maintained alongside `docs/THEORY_BUILDING_PLAN.md`. Changes to hypotheses H-A/
H-B/H-C or to interfaces I-1–I-4 are program-level decisions requiring Xavier's
sign-off (H4).*

**Update log**
- 2026-07-16 — v1.0: three-stream vision integrated with the Stream 1 audit and
  theory-building plan; H-C reframed as an explicit conjecture with a new
  checkpoint H1-b; two-paper publication strategy adopted.
