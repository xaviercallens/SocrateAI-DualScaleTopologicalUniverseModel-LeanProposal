# Index: Stream 2 & Stream 3 Next Actions (2026-07-24)

**Release:** v0.4-S1-complete  
**Status:** Stream 1 Lean formalization 100% done. Stream 2/3 unblocked and ready to execute.  
**Authority:** Xavier Callens (T0)

---

## For Stream 2 (Physics Selection & Geometry Computation)

**Current state:** Review approved (Xavier, 2026-07-24). L₃ = Sym²(L₂) algebraic link verified [A]. L₂ operators exact and ready.

### Immediate Actions (In Order)

#### Action 1: Read the Handoff Brief

**File:** `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md`

**What it contains:**
- L₃ = Sym²(L₂) verification summary (three-stage proof: Fable → Deep Think → Opus)
- L₂ operator specifications for s7 and s10 (exact, no approximation)
- D-brane gauge-group selection framework
- Adversarial validation gates (A1–A6)
- Expected outputs and edge cases

**Why read it first:** This is the formal transfer of authority from Stream 1. Everything Stream 2 builds depends on these L₂ operators and the three-tier epistemic structure.

#### Action 2: Review the Approval Decision

**File:** `briefs/REVIEW_2026-07-24_STREAM1_HANDOFF_APPROVED.md`

**What it contains:**
- Xavier's formal review verdict (Tier A/B/C assessment)
- Directives binding on Stream 2
- Singular points (exact, no solve needed)
- Expected C1/C2 outputs (no surprises)

**Key directive:** "Compute C1 Kodaira fiber types at exact singular points (2-4h), then C2 Picard lattice (2-3h), then physics interpretation (4-6h)."

#### Action 3: Execute Phase 1 (Provenance Gate) — 1–2 hours

**Blocking:** All C1/C2 work until this passes.

**Tasks:**
1. Fetch 4 PDFs (exact references in `STATUS_2026-07-24_PHASE_SETUP_COMPLETE.md` §"Next Immediate Action"):
   - Almkvist–van Straten (arXiv:2103.08651)
   - Gorodetsky (arXiv:2102.11839)
   - Zagier 2009 (arXiv or ResearchGate)
   - Cooper 2012 (Ramanujan J. 29)
2. Save to `docs/literature/`
3. Compute SHA256 hashes
4. Manually verify (a,b,c,d) parameters against PDFs (cross-check OEIS)
5. Pin hashes in `refs/literature_provenance.txt`
6. Run: `python3 checkers/adversarial_A5_A6_provenance_hygiene.py`
   - Expected: ✅ PASS (all 15 sporadic sequences verified)

**If PASS:** Proceed to Action 4. **If FAIL:** Stop and escalate to Xavier.

#### Action 4: Compute C1 (Kodaira Fibers) — 2–4 hours

**Input:** Exact singular points (given below; no approximation error).

**Exact singular points:**
- **s7:** `z = 1/27` (I₁), `z = −1` (I₁)
- **s10:** `z = 1/16` (I₁), `z = −1/4` (I₁)

**Computation:**
- Run monodromy verification at each singular point
- Classify Kodaira fiber types (I₀, I₁, I₂, …, II, III, IV, …)
- Output: `data/certificates/C1_cooper_s7.json`, `data/certificates/C1_cooper_s10.json`
- Each file contains: singular z-coordinates, monodromy order, Kodaira type, fiber configuration Σ

**Tooling:**
- `scripts/k3_monodromy_verification.py` (Fuchs classification)
- `scripts/k3_t2_singular_loci.py` (exact discriminant)
- Checker template: `checkers/check_C1_kodaira_fibers.py`

**Expected output (no surprises):**
- s7: Σ(s7) = [I₁, I₁], Picard lower bound ≥ 4
- s10: Σ(s10) = [I₁, I₁], Picard lower bound ≥ 4 (caveat: [B] provisional on orbifold scaling)

#### Action 5: Compute C2 (Picard Lattice) — 2–3 hours

**Dependency:** C1 complete

**Input:** C1 fiber configuration Σ

**Computation:**
```
Picard number ρ = 2 + Σ(m_v − 1) + rank(Mordell-Weil)
Transcendental rank τ = 22 − ρ
Intersection form & discriminant (definite K3 signature)
```

**Output:** `data/certificates/C2_cooper_s7.json`, `data/certificates/C2_cooper_s10.json`

**Checker template:** `checkers/check_C2_picard_lattice.py`

**Expected output:**
- Both s7 and s10: ρ = 4, τ = 18, discriminant = −3 (definite K3 ✓)

#### Action 6: Physics Interpretation (Tier C, Marked) — 4–6 hours

**Dependency:** C2 complete

**Task:** Map Picard lattice structure → D-brane gauge groups

**Key questions to resolve:**
- Does s7's fiber configuration [I₁, I₁] support SU(5) or SO(10) GUT?
- Does s10's rational structure (A4 caveat: 2-adic scaling) affect gauge-group rank?
- Which is the "load-bearing vacuum" for Standard Model embedding?

**Constraint:** Every physics claim must carry an explicit **[C] CONJECTURE** marker in the same sentence. See `epistemic-guardrails` skill for forbidden verbs.

**Deliverable:** Physics brief (brief_stream2_physics_interpretation_2026-07-24.md) with all [C]-marked claims.

### Success Criteria (Geometry Lock)

- ✅ Phase 1 A5/A6 PASS
- ✅ C1 Kodaira types determined
- ✅ C2 Picard lattice computed
- ✅ Physics brief drafted (all [C]-marked)
- ✅ No contradictions with L₃ = Sym²(L₂) (cross-check with `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md`)
- ✅ Feedback to Stream 1 (Σ fiber configs for S1-05 minimality analysis)

**Authority declaration:** Xavier: "C3b geometry locked. Stream 2 physics proceeds."

---

## For Stream 3 (Experimentation & Data Confrontation)

**Current state:** Partially blocked (see §1 of the directive). Sections §2–§3 unblocked and ready to start today.

### Read the Directive First

**File:** `briefs/STREAM3_EXPERIMENTATION_DIRECTIVE_2026-07-24.md`

**What it contains:**
- Honest gating status (§1): three genuine blockers + why shortcutting them would break falsifiability
- Non-blocking prep you can start today (§2–§3):
  - WP S3-01: Data acquisition (NANOGrav, EPTA, SDSS/DES/Euclid, Lyman-α)
  - WP S3-02: Generic pipeline scaffold + golden tests
- Full sequenced plan (§4) for once blockers clear (S3-00 MVM matching, S3-03/04 comparisons, S3-05 report)
- Epistemic guardrails specific to Stream 3 (TEST vs FIT labeling, Tier C markers, kill conditions)

### Immediate Actions (In Order)

#### Action 1: Start WP S3-01 (Data Acquisition) — NOW, 2–4 hours

**Does NOT depend on any blocker. Start today.**

**Datasets to acquire:**

| Dataset | Observable | Source |
|---|---|---|
| NANOGrav 15-yr free-spectrum posteriors | P1 (PTA) | Agazie et al. 2023 |
| EPTA Data Release 2 | P1 (PTA) | Liu et al. 2023 |
| SDSS stacked weak-lensing profiles | P2 (halo) | Mandelbaum et al. 2013/2020 |
| DES Y3 lensing profiles | P2 (halo) | Leauthaud et al. 2024 |
| Euclid Early Release Observations | P2 (halo) | ESA/Euclid archive |
| SDSS DR12 Lyman-α power | Lyman-α null test | Palanque-Delabrouille et al. 2015 |
| DESI Early Data Release | Lyman-α null test | DESI public archive |

**Deliverables:**
- `data/MANIFEST.md` — every dataset with exact URL, version, fetch date, SHA256
- `scripts/fetch_stream3_data.sh` (or `.py`) — idempotent fetch script
- CI check: hash verification on every run

**Anti-hallucination rule:** Fetch and hash the files themselves; never transcribe a URL or version number from memory.

#### Action 2: Start WP S3-02 (Pipeline Architecture) — NOW, 4–8 hours

**Does NOT depend on any blocker or candidate selection. Start today.**

**Design constraints (binding):**
- No free knobs — pipeline reads frozen `PREDICTION.md` + Free-Parameter Ledger
- Every comparison labeled `TEST` or `FIT` at output
- Assumption-tag pass-through (carry [A-SEQ, A-VOL, A-ONT, A-REL] end-to-end)

**Required golden tests (before real data):**
1. **Closure test:** inject synthetic signal matching model's shape; pipeline recovers it within tolerance
2. **Null test:** run on null synthetic data; pipeline reports null at stated α (no false positive)

Both must be green in CI before pipeline touches real public data.

**What NOT to build yet:**
- No hard-coded s7, s10, or candidate numbers
- No selected P1 vs P2 vs Lyman-α in code — build thin adapters for each

#### Action 3: Wait for Stream 2 Geometry Lock

**Status:** S3-00 (MVM matching, "the single hardest task in the program") is BLOCKED on:
1. Stream 2's C3b candidate selection (Phase 1 provenance gate still open)
2. Xavier's sign-off on `ASSUMPTIONS.md` (currently DRAFT v0.1, unverified)
3. `PREDICTION.md` observable choice (P1 PTA / P2 lensing / Lyman-α) — awaiting astrophysics consultation

**Do NOT shortcut these.** A prediction derived before the candidate is selected or before assumptions are signed is not pre-registered — it would be indistinguishable from a fit chosen to fit.

**If tempted:** Stop and escalate to Xavier (`briefs/ESCALATIONS.md`), per CLAUDE.md escalation rule.

#### Action 4: Once Blockers Clear — WP S3-00 (MVM Matching)

**This is T0 work (Xavier derives, Deep Think blind re-derives), not T1/T2.**

1. Install Free-Parameter Ledger (7-row table: GEOMETRIC/CONTINUOUS-FREE/DISCRETE/ASSUMED)
2. Derive `m_φ(𝒱, g_s)`, `α_D`, `Λ_D(𝒱, g_s)` from Stream-2-selected candidate
3. Eliminate `(𝒱, g_s)` → **a relation, not a number**
4. Pin observable (first available: P1 PTA if m_φ ∈ 10⁻²³–10⁻²² eV; else P2 lensing)
5. **Kill condition (pre-committed, evaluate honestly):** if no relation survives elimination → **F5 triggers** (model is generic vdSIDM). This is a real, reportable outcome.
6. Tag every prediction with assumption list

**Definition of Done:** T0 and T0s derivations agree within tolerance; hash-pinned before any data contact; kill condition evaluated either way.

#### Action 5: Once S3-00 Complete — WP S3-03/S3-04 (Run Pinned Comparison)

Point the §2 pipeline at the now-frozen `PREDICTION.md` values and the §1-acquired data.

**If P1 (PTA) selected:** Compare predicted nHz spectrum against NANOGrav/EPTA posteriors. Mark as `TEST` (kernel-blind).

**If P2 (lensing) selected:** Halo-profile shape vs published profiles. Mark shape as `TEST`, normalization as `FIT`.

**Definition of Done:** Result reproduces from clean checkout in one command; assumption tags preserved end-to-end.

#### Action 6: Final Step — WP S3-05 (`OBSERVATIONAL_REPORT.md`)

- T1 assembles results tables (machine-generated, no hand-entered numbers in evidence)
- Xavier writes interpretation section only (every [C] claim carries marker)
- F3/F4/F5 branches triggered mechanically from thresholds + kill-condition check
- **Publish even — especially — if every result is an exclusion.** This is the honest outcome falsifiability design exists to produce.

**Definition of Done:** Report published; kill-condition evaluation recorded; no hand-entered numbers in evidence.

### Success Criteria (Phase 3 Closure)

- ✅ WP S3-01 data acquired, hashed, versioned
- ✅ WP S3-02 pipeline tested (closure + null golden tests green)
- ✅ WP S3-00 MVM matching complete (hash-pinned, two-model rule, kill condition evaluated)
- ✅ WP S3-03/04 comparisons run (TEST/FIT labeled, assumption tags preserved)
- ✅ WP S3-05 report published (even/especially on exclusion)
- ✅ F3/F4/F5 branching mechanical (not judgment-based)
- ✅ All Tier C claims marked in-sentence

---

## Critical Rules (Both Streams)

1. **Tier A = Proven (Lean/CAS).** State as fact. Example: "L₃ = Sym²(L₂) [A]."
2. **Tier B = Checkable.** Hedge + verification route. Example: "Picard ρ = 4, verified via Shioda-Tate [B]."
3. **Tier C = Conjecture.** Explicit marker in same sentence. Example: "We conjecture [C] the D-brane gauge group is SU(5)."
4. **Forbidden verbs for Tier C** (unless hedged): predicts, establishes, shows, implies, locks, governs, determines, demonstrates, proves.
5. **TEST vs FIT is not cosmetic.** Mislabeling is how falsification programs quietly become unfalsifiable.
6. **Kill conditions are pre-committed, not negotiated after results.** If a result is inconvenient, report it under the pre-committed branch, never revisit the condition.
7. **No numbers from memory.** Every constant traces to a fetched source, certificate, or cited reference.
8. **Provenance footer on every artifact:** `Generated-by: <model/tier> | Verified-by: <verifier> | Reviewed-by: <T0 Y/N>`

---

## Timeline Summary

| Phase | Owner | Duration | Depends on | Status |
|---|---|---|---|---|
| **Stream 1 S1-08** | Opus | ✅ DONE | — | Closed 2026-07-24 |
| **Stream 2 Phase 1 (Provenance)** | Xavier | 1–2h | Nothing | Ready NOW |
| **Stream 2 C1 (Kodaira)** | Xavier | 2–4h | Phase 1 | Ready after Phase 1 |
| **Stream 2 C2 (Picard)** | Xavier | 2–3h | C1 | Ready after C1 |
| **Stream 2 Physics** | Xavier | 4–6h | C2 | Ready after C2 |
| **Stream 3 WP S3-01** | T1/T2 | 2–4h | Nothing | Ready NOW |
| **Stream 3 WP S3-02** | T1/T2 | 4–8h | Nothing | Ready NOW |
| **Stream 3 WP S3-00** | Xavier (T0) | N/A | Stream 2 + ASSUMPTIONS + PREDICTION | Blocked 2026-07-24 |
| **Stream 3 WP S3-03/04** | T1/T2 | N/A | S3-00 | Blocked 2026-07-24 |
| **Stream 3 WP S3-05** | Xavier + T1 | N/A | S3-03/04 | Blocked 2026-07-24 |

**Total to geometry lock (Stream 2):** 9–15 hours (Phase 1 blocks; C1/C2/physics sequential after)

---

## Reference: All Relevant Briefs

| Brief | Audience | Purpose |
|---|---|---|
| `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md` | Stream 2 | Formal transfer of L₂ operators, validation spec, epistemic tiers |
| `briefs/REVIEW_2026-07-24_STREAM1_HANDOFF_APPROVED.md` | Stream 2 | Xavier's review verdict, directives, expected outputs |
| `briefs/STREAM3_EXPERIMENTATION_DIRECTIVE_2026-07-24.md` | Stream 3 | Gating status, non-blocking prep, full sequenced plan, guardrails |
| `briefs/D1_DEEPTHINK_GATE_STEP2_REQUEST.md` | Deep Think (reference) | CAS verification request (already completed) |
| `briefs/INDEX_STREAM2_STREAM3_NEXT_ACTIONS.md` | Stream 2 & Stream 3 | This file — consolidated action list |

---

## Release Notes

**v0.4-S1-complete (2026-07-24)**

**Completed:**
- ✅ S1-08: Generic Cooper W≡0 proved in Lean via `ring` tactic (commit 206db17)
- ✅ E-006 all three gate steps: Fable derivation → Deep Think CAS verification → Opus kernel proof
- ✅ Stream 1 Lean formalization 100% done (S1-02 through S1-08 all closed)

**Build:** `lake build Agora` green (3106 jobs), `lake build Tests` green (3000 jobs)

**Ready for execution:** Stream 2 Phase 1 (provenance), Stream 3 WP S3-01 + WP S3-02

**Blockers:** Stream 2 Phase 1 gate (PDF fetch + A5/A6 validation), then Stream 3 S3-00 (awaits geometry lock + ASSUMPTIONS sign-off + PREDICTION freeze)

---

*Generated-by: Sonnet 5 (Stream 1→2/3 orchestration) | Verified-by: none — routing document | Reviewed-by: T0 N (pending Xavier)*
