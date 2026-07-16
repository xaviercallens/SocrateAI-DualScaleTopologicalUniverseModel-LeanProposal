# Implementation Roadmap: PR Strategy & Timeline

**Status:** 30 tasks created with dependency tracking.  
**This file:** high-level PR sequence; consult task tracker for current progress.

---

## PR Sequence (Early Priorities)

Tasks are structured to land as versioned PRs with clear dependencies. The critical path
identifies what must land first; parallel streams allow lower-tier work.

### **Phase 1: Infrastructure & Claims (WS0) — Weeks 1–2**
*Target:* Clean CI foundation, scoped claims, eliminated numerical axioms → **Release v0.2**

| PR | Tasks | Tier | Owner | Timeline | Blocks |
|----|-------|------|-------|----------|--------|
| **PR-WS0-infrastructure** | WS0.1, WS0.2, WS0.3 | T-S / T-H | Sonnet + Haiku | 1 week | WS1+ |
| **PR-WS0-claims** | WS0.4 | T-F | Fable 5 | 3 days | Public messaging |
| **PR-WS0-blueprint** | WS0.5 | T-S | Sonnet | 1 week | WS2 drafting |

**Gate:** CI green, axiom allowlist (6 axioms), references verified, blueprint renders.

### **Phase 2: Verified Numerics (WS1) — Weeks 2–3**
*Target:* Eliminate 3 numerical axioms, axiom count 6→3 → **Release v0.2**

| PR | Tasks | Tier | Owner | Timeline | Blocks |
|----|-------|------|-------|----------|--------|
| **PR-WS1-numerics** | WS1.1, WS1.2, WS1.3 | T-S | Sonnet | 1 week | Theorem 3 content |

**Gate:** Axiom allowlist shrinks to 3 (empirical only); `#print axioms` on master theorem confirms.  
**Note:** WS1.2 depends on checkpoint H1 phenomenology review (parallel recruitment track).

---

## Critical Path (What Blocks Everything Else)

```
Checkpoints (parallel recruitment → human review):
├─ H1 (astro-particle phenomenology) ──→ WS1.2, WS4.1
└─ H2 (string theorist / LVS validation) ──→ WS3.1+

Cross-stream dependency:
├─ I-1 (Sequence Registry, data/registry/sequences.json)
│  └─ Must exist before: WS2.2, WS5.1, WS5.3
│  └─ Blocks longest path to v0.5 (all four sequences formal)

Infrastructure (must land before most WS2+):
├─ WS0.1 (Lake + CI)
├─ WS0.5 (blueprint ready)
└─ WS2.1 (P-recursive framework)
```

**Action:** Recruit H1 and H2 reviewers *immediately* (parallel to WS0/WS1).  
**Action:** Coordinate with Stream 2 repo on I-1 Sequence Registry (does not exist yet).

---

## Phase 3: Real Mathematics (WS2–4, parallel starting week 3)

### **WS2: Theorems 1 Content (P-recursive sequences, ~3 months)**

| PR | Tasks | Dependencies | Tier | Blocks |
|----|-------|--------------|------|--------|
| **PR-WS2-holonomic** | WS2.1 | WS0.5 blueprint ready | T-F + T-S | WS2.2+ |
| **PR-WS2-sequences** | WS2.2 | I-1 registry exists; WS2.1 | T-S | WS2.3+ |
| **PR-WS2-bounds** | WS2.3 | WS2.2 | T-S | WS2.4-A |
| **PR-WS2-minimality-A** | WS2.4-A | WS2.1/2.2; blueprint nodes | T-F + T-S | v0.3 gate; Paper 1 |
| **PR-WS2-minimality-B** | WS2.4-B | WS2.4-A + H5 math review | T-F + research | v1.0 gate |
| **PR-WS2-weierstrass** | WS2.5 | WS2.2 | T-S | Part of v0.3 |

**Gate for v0.3:** WS2.4-A solid (theorem 1 has real content, certified at degree-≤5).

### **WS3: Theorem 2 Content (LVS vacuum, ~2–3 months, needs H2)**

| PR | Tasks | Dependencies | Tier | Blocks |
|----|-------|--------------|------|--------|
| **PR-WS3-potential** | WS3.1 | H2 checkpoint | T-F + human | WS3.2+ |
| **PR-WS3-calculus** | WS3.2 | WS3.1 | T-S | WS3.3 |
| **PR-WS3-vacuum** | WS3.3 | WS3.2 + WS5.3 | T-F + T-S | v0.4 |
| **PR-WS3-swampland** | WS3.4 | WS3.3 | T-F + T-S | v0.4 |

**Gate for v0.4:** Real LVS potential with proven critical point and PosDef Hessian.

### **WS4: Theorem 3 Content (Phenomenology, ~1–2 months, needs H1)**

| PR | Tasks | Dependencies | Tier | Blocks |
|----|-------|--------------|------|--------|
| (WS4.1 is human review, not code) | – | H1 checkpoint | T-HU | WS4.2 |
| **PR-WS4-phenomenology** | WS4.2 + 4.3 | H1 complete + WS1.3 | T-F + T-S | v0.5 |

**Gate for v0.5:** Theorem 3 over validated M87* chain with units and error box.

---

## Phase 4: ML Integration & Certificates (WS5, parallel to WS2–4)

| PR | Tasks | Dependencies | Tier | Blocks |
|----|-------|--------------|------|--------|
| **PR-WS5-certificates** | WS5.1 | I-1 registry | T-S | WS5.2/5.3 |
| **PR-WS5-verification** | WS5.2 | WS5.1 | T-H | Reproducibility gate |
| **PR-WS5-ml-feedback** | WS5.3 | WS5.1 + WS3.3 | T-S | WS4.2 |

**Gate:** AutoEvolve certificates regenerated from I-1 registry, reproducible in CI.

---

## Phase 5: Community & Publication (WS6, throughout)

| PR | Tasks | Dependencies | Timeline | Blocks |
|----|-------|--------------|----------|--------|
| (WS6.1 engagement) | – | WS0.5 + WS2.4-A | Week 3 onwards | – |
| **PR-contributions-call** | WS6.4 | WS6.1 | Week 4–5 | Recruitment |
| (WS6.3 Paper 1 draft) | – | WS1.3 + WS2.4-A | ~Week 10 | – |

**Gate for Paper 1 (arXiv):** WS1.3 + WS2.4-A mature; H6 sign-off.  
**Gate for Paper 2 (PRD/JHEP):** WS2.4-B + WS3.4 + WS4.2 mature; H6 sign-off.

---

## Release Gates

| Release | Condition | Timeline | PR count |
|---------|-----------|----------|----------|
| **v0.2** | WS0 + WS1 complete; axioms 6→3 | ~2 weeks | 3 PRs |
| **v0.3** | WS2.4-A (deg-bounded minimality) | ~8 weeks | +3 PRs (WS2.1/2.2/2.4-A) |
| **v0.4** | WS3 complete (real LVS + vacuum) | ~12 weeks | +4 PRs (WS3.1–3.4) |
| **v0.5** | WS4.2 (Theorem 3 content); Paper 1 draft | ~14 weeks | +1 PR (WS4) |
| **v1.0** | All theorems + blueprint complete | ~6–9 months | +remaining |

---

## Immediate Action Items (This Week)

**Must happen in parallel:**

1. **Fable 5:** Start WS0.4 drafting (scope-down language for README/MEMORY). Need Xavier sign-off.
2. **Sonnet:** WS0.1 (Lake build CI) + WS0.3 (reference audit) skeleton.
3. **Haiku:** CI boilerplate (GitHub Actions file), requirements.txt → lockfile.
4. **Xavier:** Recruit H1 (astro-particle phenomenologist) and H2 (string theorist).
   - Send them the derived specifications from plan §4.1 (WS4) and §3.1 (WS3).
   - Offer coauthorship per plan §6.
5. **Stream 2 coordination:** Request I-1 Sequence Registry (data/registry/sequences.json with S₁₂, S₂₁, s₇, s₁₀ OEIS IDs + recurrences).

**By end of Week 1:**
- PR-WS0-infrastructure opened (ready for review).
- Checkpoints H1/H2 recruitment in flight.
- I-1 registry source-identified in Stream 2.

**By end of Week 2:**
- v0.2 released.
- Blueprint structure in place (WS0.5).
- H1/H2 reviews started.

---

## Model/Tier Assignments

**Haiku 4.5** (now your default):
- T-H tasks (mechanical CI, reference checking, boilerplate, proof assembly).
- Can close stated goals in T-S tasks *under guardrails* (never add axiom/change statement).
- **⚠️ Note:** You've switched to Haiku. High-tier work (WS2.1 design, WS3.1 potential choice, H-C bridge) still needs Fable 5's reasoning. See "Delegation Protocol" in plan §5.

**Sonnet 5** (next tier):
- T-S tasks: Lean proof work, mathlib lemma hunting, `HasDerivAt` bookkeeping.
- Proof review and statement verification (no drift).
- Parallel WS2/3/4 work once blueprints freeze.

**Fable 5** (scientific partner):
- T-F tasks: formal statement design, proof architecture, physics-to-math translation.
- Every theorem statement that changes.
- Blueprint node authoring (statements + strategy sketches).
- Checkpoint review prep.

**Xavier** (human lead):
- Checkpoints H1–H6 (deciding to accept/reject key results).
- Cross-stream coordination (I-1 registry, VISION.md updates).
- Final public claims (H3, H4, H6).
- Authorship decisions and publication.

---

## Notes for Low-Tier Agent Delegation

If delegating to Haiku/Sonnet:

1. **Use the task tracker** — each task has a clear DoD and validation step.
2. **Use leanblueprint blueprint nodes** (once WS0.5 lands) as specifications — a T-S agent's job is to close the `sorry` that Fable 5 authored.
3. **CI is the arbiter** — no task is done until WS0.1 build + WS0.2 axiom gate + task validation all pass.
4. **Escalation path:** On failure, report exact Lean goal state (not a paraphrase) and stop. Never guess.
5. **Lemma discovery:** Use Loogle/LeanSearch or `exact?`/`apply?` rather than hallucinating mathlib names.

---

*This roadmap is maintained in sync with task tracker and THEORY_BUILDING_PLAN.md. Updates reflect merged PRs and evolving dependencies.*

**Last updated:** 2026-07-16 (initial roadmap with 30 tasks and critical-path identification)
