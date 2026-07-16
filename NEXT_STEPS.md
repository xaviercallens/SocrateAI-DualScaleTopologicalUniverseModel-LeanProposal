# Next Steps: Starting Implementation

**Status:** Planning phase complete. First PR submitted (PR-WS0-planning).  
**Date:** 2026-07-16  
**Model in use:** Haiku 4.5 (you can delegate T-H work to Haiku; T-F work still needs Fable 5)

---

## What Just Happened

✅ **Created and pushed:**
- `VISION.md` — unified three-stream vision with data contracts
- `docs/THEORY_BUILDING_PLAN.md` — detailed execution plan (~10k words, 7 workstreams, frank audit)
- `docs/IMPLEMENTATION_ROADMAP.md` — PR sequence and release gates
- Task tracker with 30 tasks and dependency graph

✅ **PR #1 submitted:**
- https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal/pull/1
- Contains planning + roadmap; no code changes
- Ready for your review / merge

---

## Critical Path: Blocking Tasks You Must Do This Week

**These are human-level decisions that gates everything:**

### H1: Recruit astro-particle phenomenologist (Task #10)
- **What:** Find someone to review M87* superradiance/chameleon chain
- **Why:** Blocks WS1.2, WS4.1, WS4.2 — without this review, the Constants in Theorem 3 (0.155, 0.42) could be wrong
- **Timeline:** Need review to start *this week* if WS1 is to land on schedule
- **Offer:** Coauthorship on the PRD/JHEP paper (see plan §6, credit policy)
- **Input:** Use the WS4.1 spec in plan §4 as the brief

**Candidates to contact:**
- Someone from your astro-particle community who knows axion/superradiance constraints
- Check arXiv recent work on "axion superradiance" or "chameleon screening" + black holes
- Lean Zulip / PhysLean community may have recommendations

### H2: Recruit string theorist / LVS validator (Task #11)
- **What:** Someone to validate the genuine LVS potential (plan WS3.1)
- **Why:** Blocks WS3.1–WS3.4 — the current potential is wrong (runaway)
- **Timeline:** Ideally review starts this week; gives 4–6 weeks for them to check BBCQ, confirm truncation
- **Offer:** Coauthorship on Paper 2
- **Input:** Use the WS3.1 spec in plan §4 as brief

**Candidates:**
- A string theorist familiar with KKLT/LVS landscape
- Someone who has worked on moduli stabilization phenomenology

---

## Immediate Work (This Week)

### 1. **Review PR #1 and merge** (you)
- Read the planning docs
- Confirm the audit findings match your sense of the code
- Merge if happy (or request changes, then re-review)

### 2. **Recruit H1 + H2** (you)
- Send them the plan excerpts (§4.1 for H1, §3.1 for H2)
- Offer coauthorship per plan credit policy
- Get preliminary "yes, I'll review" by end of week

### 3. **Build Sequence Registry (I-1)** — parallel, coordinate with Stream 2
- What: `data/registry/sequences.json` with S₁₂, S₂₁, s₇, s₁₀
- Why: Blocks WS2.2 (defining sequences in Lean) and Stream 2 ML work
- Action: Sync with whoever owns Stream 2 repo; ask for OEIS IDs and recurrence coefficients for all four sequences
- Deadline: ASAP; WS2 can't start without it

### 4. **Start WS0.1 (Lake + CI)** — Task #1 (Sonnet/Haiku)
- Set up lakefile.lean with pinned mathlib
- Add GitHub Actions using leanprover/lean-action
- Target: CI builds in <20 min with cache
- DoD: Fresh clone, `lake build` works, readme badge ✅

### 5. **Start WS0.3 (Reference audit)** — Task #3 (Haiku)
- Verify every arXiv link in `docs/REFERENCES.md`
- Fix broken IDs (e.g., Vafa paper is hep-th/9602022, not 9602062)
- Use the corrected list in plan §6
- Write `scripts/check_references.py` to validate links in CI

---

## Parallel Tracks (Assign to Sonnet/Haiku)

Once PR #1 merges, open these PRs in parallel:

| PR | Tasks | Owner | Est. Time | Blocks |
|----|-------|-------|-----------|--------|
| **PR-WS0-infrastructure** | WS0.1 (Lake), WS0.2 (axiom gate), WS0.3 (refs) | Sonnet + Haiku | 1 week | WS1+ |
| **PR-WS0-claims** | WS0.4 (scope language) | **You** (H3 sign-off) | 3 days | Public messaging |
| **PR-WS0-blueprint** | WS0.5 (leanblueprint) | Sonnet | 1 week | WS2 design |

**Target:** All three PRs reviewed and merged by end of Week 1 → **release v0.2 (axioms 6→3) by Week 2**.

---

## What's Next After v0.2

Once v0.2 ships with numerical axioms eliminated:

1. **WS2.1 (P-recursive framework)** — T-F task (needs Fable 5 to design the definitions and basic API)
2. **WS1.2 clarification** — once H1 review is in, may need to re-evaluate if 0.155/0.42 constants are correct
3. **I-1 Sequence Registry** — should exist by now; WS2.2 (defining sequences) can start
4. **Blueprint nodes** — once WS0.5 lands, Fable 5 can author nodes for WS2.1+

---

## Key Coordination Point: Stream 2

The Sequence Registry (I-1) is the **single most important cross-stream task**. Until it exists:
- Stream 1 can't formalize the sequences (WS2.2)
- Stream 2 can't finalize AutoEvolve config
- Stream 3 can't trust which sequences are being validated

**Action this week:** Contact Stream 2 repo owners, get agreement on I-1 ownership and timeline.

---

## You'll Need Fable 5 For:

These tasks still need Fable 5's reasoning (not Haiku/Sonnet work):
- **WS0.4** — drafting the exact language to scope down the "first machine-checkable proof" claim (careful word choice needed)
- **WS2.1** — designing the P-recursive sequence API (what should the definition include? what lemmas are essential?)
- **WS3.1** — once H2 review is in, synthesizing the correct LVS potential and stating it formally
- **WS4.1 note review** — helping formalize the phenomenology derivation after H1 inputs

---

## Task Tracker Status

30 tasks created with dependencies. Use `!gh task list` (or whatever your task CLI is) to see:
- ✅ Completed: 0
- 🔄 In progress: 3 (WS0.1, H1 recruitment, H2 recruitment)
- ⏳ Blocked: Many (waiting on I-1, H1/H2 review)
- 📋 Ready to start: WS0.3, WS0.5, others in parallel

---

## Merge Strategy For Reviewing PR #1

The PR contains no code changes — purely planning docs. Questions you might ask:

1. **Audit findings:** Do the v0.1 gaps match your experience with the Lean code?
   - Theorem 2 potential being a runaway?
   - Theorem 3 being circular?
   - Theorem 1 lacking mathematical content?

2. **Timeline estimates:** Do the weeks/months for WS0–WS6 feel right given your bandwidth?

3. **Checkpoints H1/H2:** Do you agree on what needs human validation before we formalize?

4. **Release gates:** Does the v0.2→v1.0 sequence make sense?

If yes to these, approve and merge. The real work starts after.

---

## Resources & Documentation

- **VISION.md** — read if you want the 3-page summary of the program
- **THEORY_BUILDING_PLAN.md** — read §1–3 for overview, §7 for checkpoints, §6 for literature
- **IMPLEMENTATION_ROADMAP.md** — read for PR sequence and immediate action items
- **Task tracker** — see which tasks are unblocked and ready to start

---

## Questions Before Starting?

The plan is intentionally detailed so that Haiku and Sonnet can execute tasks without guessing. But if something is unclear (e.g., what exactly goes into the Sequence Registry, or how to structure WS0.1 CI), now is the time to ask.

Next sync: after you've reviewed PR #1 and recruited H1/H2.

---

*Generated by Claude Code, 2026-07-16.*
