# Stream 1 (Lean Theory) — T0 Decision Brief

**Date:** 2026-07-20  
**Prepared by:** Opus 4.8 (middle-tier executor / T1–T0 hybrid)  
**Audience:** Xavier (T0 owner, physics intuition, phase-gate) · Fable 5 (T0 math design) · Deep Think / Gemini DeepMind (T0s adversarial re-derivation)  
**Purpose:** A single routing document. Carry each decision below to the right party, collect their answer/feedback, hand it back to Opus to execute. Nothing here is acted on without a recorded T0 decision.

---

## 0. How to read this — the four-party model

| Party | Role in this program | What only they can decide |
|---|---|---|
| **Xavier (you)** | T0 owner. Physics/domain intuition. Phase-gate override (EXECUTION_PLAN §6.5). | Candidate register freezes; falsification-branch triggers; cross-stream priorities; "which of s7/s10/s18 is physically load-bearing". |
| **Fable 5** | T0 higher-reasoning orchestrator (in-house). | Mathematical **design** choices (API type, proof route, formalization scope). |
| **Deep Think (Gemini)** | T0s independent adversarial re-derivation. | **Concurrence** — the second model in the two-model rule; independent re-derivation of any identity before it's trusted. |
| **Opus 4.8 (me)** | Middle-tier executor. Bounded grind, honest escalation, kernel-gated work. | Nothing load-bearing unilaterally — I execute decisions and file escalations. |

**The two-model rule** (project-binding): no substantive identity is "trusted" until Fable/Opus produces it *and* Deep Think independently re-derives it and concurs. Already exercised on E-004 (C3 W=0) and the S1-04 C3 review.

---

## 1. Status snapshot (kernel-verified reality)

- **Build:** `Tests` and `OpenGoals` rebuilt green this session; full `Agora` last verified green at **3104 jobs** (commit `d7aee9e`, 2026-07-20).
- **Axioms:** **0** in `Axioms/`. Two previously-vacuous axiom clusters were **discharged** (E-002 Theorem-1 axioms; ChameleonRescue numerical certificates). One vacuous axiom remains **disclosed-but-not-discharged**: `pipeline_upper_bound` (E-005).
- **`sorry`:** only in `OpenGoals/CooperRecurrences.lean` (policy-compliant). **2 open goals**: `open_goal_recurrence_s7`, `open_goal_recurrence_s10`.
- **Candidate register:** {s7, s10, s18}. s7/s10 fully encoded (closed form + params); s18 encoded by params + golden values only (no verified closed form).

### What is Tier A (may be stated as fact)
- s7, s10 closed-form definitions match independently-computed golden values, n=0..19 (`native_decide` — *modulo compiler trust*).
- **New this session:** the closed-form `s7`/`s10` definitions satisfy their Cooper recurrences at every index **n = 1..18** (`s7/s10_closed_form_satisfies_recurrence_upto`, `native_decide`). This is **bounded evidence, not the ∀ n statement** — it validates the encodings before any WZ investment.
- s7/s10 are **not** polynomially bounded (kernel-proved exponential-growth disproof; corrected a prior false "polynomial" claim).
- θ-form Picard-Fuchs operators have kernel-computed order 2 / order 3 for every parameter choice (Theorem 1 is now non-vacuous *about the encoded operators*).

### What is Tier B (checkable, hedged, not proved)
- **C3 / Sym²:** W=0 confirmed symbolically for s7/s10/s18 (two-model, Deep Think concurs). **Caveat:** W=0 holds *identically* for the whole Cooper ansatz → C3 is **structural, not discriminating**. No explicit order-2 partner L₂ has been *exhibited* for any candidate.
- s18 minimality / geometric (K3) identification: Tier B, S1-05 scope.

### What is open (named goals / escalations)
- The two recurrence open goals (need WZ certificate — **Decision D2**).
- SYM2_PROVED upgrade (blocked on RatFunc derivative — **Decision D1**).
- pipeline_upper_bound discharge (**Decision D3**).
- Explicit L₂ / C3b discriminator (**Decision D4**).
- K3_CRITERIA v1.0 freeze + s18 closed form (**Decision D5**).

---

## 2. Key findings since v0.3

1. **E-002 discharged (Fable, S1-07):** the vacuous `empirical_*_degree` axioms ("∃ P, natDegree = 3" — true of *any* cubic) were deleted; Theorem 1 rebuilt on concrete θ-form operators. Real content now.
2. **ChameleonRescue discharged (Opus/T1):** two numerical-certificate axioms became proved theorems (fixed-exponent rpow bounds). First-attempt proofs.
3. **Growth-bound correction (F6 event):** repo had claimed *polynomial* growth for s7/s10 — **false**. Replaced with kernel-proved *exponential* disproof. Disclosure applied.
4. **C3 is structural, not selective:** the load-bearing candidate discriminator is **not** C3 — it is C3b (Shioda–Inose moduli map), C1 (mirror integrality), C2 (Kodaira fibers). Important reframing for how selection actually happens.
5. **E-04b confirmed concretely (Opus/T1):** the θ→D monic normalization genuinely forces `RatFunc (Polynomial ℚ)` (pole at z=0), which has **no derivative API** at the pinned Mathlib commit. Not hypothetical anymore.
6. **This session:** bounded closed-form-vs-recurrence consistency check for s7/s10 added; encodings validated over n=1..18.

---

## 3. OPEN DECISIONS — the actual asks

> Each card states: what's blocked, the options, my (non-binding) recommendation, who decides, and **what feedback I need back**.

### D1 — E-006: RatFunc derivative for the generic `W ≡ 0` kernel proof
**Blocks:** SYM2_SYMBOLIC → SYM2_PROVED (the route-2 upgrade for the whole Cooper family).  
**Situation:** the literature W-criterion (Almkvist–van Straten, arXiv:2103.08651) differentiates monic-normalized coefficients `a2 = 3(1−3az+2cz²)/[z(1−2az+cz²)]`, which is a genuine rational function with a pole at z=0. Mathlib (pinned) gives `RatFunc` field structure but **no `deriv` API**.

| Option | What | Cost | Risk |
|---|---|---|---|
| **A** (my rec) | Build `RatFunc (Polynomial ℚ)` derivative infra (quotient rule + representative-independence) | 100–300 lines | Low math risk; faithful to paper; reusable |
| **B** | Reformulate as cleared-denominator polynomial identity (multiply through by p3ⁿ) | Cheaper, stays in Polynomial ℚ | **Re-derivation risk (E-04c):** a wrong cleared power silently kernel-checks a *different, weaker* statement |

**Decides:** Fable (design). **If B:** Deep Think must sign off that the specific cleared form is mathematically equivalent to the literature W=0 (two-model).  
**Feedback I need:** "A or B." If A, go. If B, I'll draft the cleared identity for Deep Think to verify before I touch Lean.

---

### D2 — WZ certificate for the s7 / s10 recurrences
**Blocks:** `open_goal_recurrence_s7`, `open_goal_recurrence_s10` (the two remaining open goals).  
**Situation:** the ∀ n recurrence is established in the literature (Gorodetsky 2023) via a Wilf–Zeilberger creative-telescoping certificate G(n,k). To make the Lean proof mechanical we need G transcribed. Three decision points (from `docs/WZ_CERTIFICATE_ANALYSIS.md`):

1. **Fetch vs. re-derive G(n,k).** Does Gorodetsky's paper/supplement give an explicit G, or must Deep Think re-derive it (Zeilberger algorithm / CAS)?
2. **Priority: s7 or s10 first.** s10 (Σ C(n,k)⁴) is the more classical/symmetric sum; s7 has fewer terms in range.
3. **Infrastructure-first vs. per-sequence.** Build reusable telescoping lemmas, or prove each independently? (200–500 lines either way; infra reusable.)

**Decides:** Fable (scope) + Deep Think (re-derivation if G isn't fetchable).  
**Feedback I need:** answers to the three points above. **Cheap first step I can take now with your OK:** attempt to fetch the explicit G from arXiv:2102.11839 + supplement and report whether it exists — this de-risks point 1 before any scope commitment.  
**Note:** the encodings are now validated over n=1..18 (this session), so a WZ investment targets a sound object.

---

### D3 — E-005 / WP S1-09: discharge vacuous `pipeline_upper_bound`
**Blocks:** any prose citing `pipeline_upper_bound` / `perturbative_regime` as data-carrying.  
**Situation:** `axiom pipeline_upper_bound : ∃ S12_max, S12_max ≤ 1.177 ∧ S12_max > 0` is vacuous (witness 1) — same failure mode as E-002. Discharging it means encoding the **actual** Stream 2/3 pipeline statistic (per-sector values, or the certified max as checksummed exact rational data) and restating the bound about that data.  
**Why deferred:** it's a **cross-stream data-interface** question (how does Stream 1 consume Stream 2/3 artifacts), which is T0-owned, not an opportunistic fix.  
**Decides:** Fable + Xavier (cross-stream interface). Depends on Stream 2/3 producing a checksummable artifact.  
**Feedback I need:** is the pipeline artifact available/frozen yet? If not, this stays disclosed-and-parked.

---

### D4 — E-004 residual: explicit L₂ / C3b (the real candidate discriminator)
**Blocks:** actual candidate *selection* (the whole point of the K3 criteria).  
**Situation:** C3 (W=0) is confirmed but structural — it does not distinguish s7 from s10 from s18. The discriminating criterion is **C3b: the Shioda–Inose moduli map** (real K3 geometry), plus C1/C2. No explicit order-2 partner L₂ has been exhibited for any candidate; only existence via W=0. This is a **cross-stream** item (Stream 2 K3 ranking, S2-01b).  
**Decides:** Xavier (which criterion is physically load-bearing) + Stream 2 owner.  
**Feedback I need:** confirm C3b is the intended discriminator and that Stream 1's job here is to *supply* the W=0 existence result (done) while Stream 2 runs the Shioda–Inose ranking — i.e., is there Stream 1 work left, or is the ball in Stream 2's court?

---

### D5 — E-001 residual: K3_CRITERIA v1.0 freeze + s18 closed form
**Blocks:** K3_CRITERIA freeze (its own pre-freeze checklist can't clear with a PENDING row).  
**Situation:** register is {s7, s10, s18}; S22/t103 were dropped (uncitable — correct per the pre-committed rule). s18 is encoded by **params + golden values only**; a direct closed-form transcription disagreed with the recurrence at n=3 (ℕ-truncation/signed-binomial edge case). A verified s18 closed form is deferred follow-on.  
**Decides:** Xavier (phase-gate — freeze with s18-by-params, or hold for closed form?).  
**Feedback I need:** freeze the register at {s7, s10, s18} now (s18 represented by sourced params + recurrence-validated goldens), or block the freeze until a verified s18 closed form lands?

---

## 4. Critical-path view

```
                       ┌─────────────────────────────────────────────┐
   D2 (WZ certificate) │ open_goal_recurrence_s7/s10  →  Tier A recurrences
                       └─────────────────────────────────────────────┘
   D1 (RatFunc deriv)  → SYM2_PROVED (whole family)   ── independent of D2
   D4 (C3b / L₂)       → candidate SELECTION          ── Stream 2 load-bearing
   D5 (register freeze)→ K3_CRITERIA v1.0             ── gates Stream 2 ranking start
   D3 (pipeline data)  → non-vacuous S12 bound        ── waits on Stream 2/3 artifact
```

**Shortest honest path to more Tier A:** D2 → the two recurrence open goals close. **Shortest to unblock Stream 2:** D5 (register freeze) + D4 (confirm C3b ownership).

---

## 5. Prompts for Xavier's intuition (physics/judgment, not math)

1. **Load-bearing candidate:** of {s7, s10, s18}, which do you *expect* to survive C3b/C1/C2 as the dual-scale operator? (Sets priority for D2 and where Stream 2 spends effort.)
2. **s18 freeze tolerance (D5):** is "s18 by sourced params + validated goldens, no closed form" acceptable for a v1.0 freeze, or is a closed form a hard requirement?
3. **RatFunc investment (D1):** do you want the faithful-but-heavier infra (Option A) as reusable Stream-1 capability, or the cheaper cleared-form (Option B) gated by Deep Think? (Cost vs. reuse vs. re-derivation risk.)
4. **Cross-stream sequencing (D3/D4):** is the Stream 2/3 pipeline artifact frozen enough to build D3's data interface, or should Stream 1 stay parked on disclosed-vacuity there?

---

## 6. Feedback loop (how to use this doc)

1. **Route:** D1/D2 core → Fable. Re-derivations (D2 G-fetch fallback, D1 Option B) → Deep Think. D4/D5 + all of §5 → your call.
2. **Record:** answers land as decisions in `briefs/ESCALATIONS.md` (E-006, E-005) or `K3_CRITERIA.md` (D5) — the durable record, not this brief.
3. **Execute:** hand the recorded decision to Opus; I do the bounded, kernel-gated work and file the next escalation if I hit a wall.
4. **Two-model discipline holds:** nothing identity-level ships without Deep Think concurrence.

**One-line cheapest next action, if you want momentum today:** approve the D2 *fetch-only* step — I check whether Gorodetsky's explicit G(n,k) exists before anyone commits to WZ scope. Zero risk, high information.

---

*Generated-by: Opus 4.8 (middle-tier) | Verified-by: Lean kernel (build 3104 jobs green, d7aee9e) + this session's Tests/OpenGoals rebuild | Reviewed-by: T0 N (this brief is the review request)*
