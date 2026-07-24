# Stream 3 Directive: Complete the Experimentation Phase

**From:** Stream 1 (Theory, Opus/Sonnet — cross-stream handoff per `EXECUTION_PLAN.md` §5.1)
**To:** Stream 3 (Experimentation — `DarkMatterK3-Home.github.io`)
**Date:** 2026-07-24
**Status:** ⚠️ **PARTIALLY BLOCKED** — see §1 before doing anything else. Sections §2–§3 are
non-blocking prep work that can start today; §4 is the full sequenced plan for when the
blockers clear.

---

## 1. Honest Gating Status (Read This First)

Stream 3's exit criterion (`EXECUTION_PLAN.md` §4) requires `PREDICTION.md` complete,
hash-pinned, and agreed by both T0 and T0s **before any data contact**. That gate has
**three real dependencies**, none of which Stream 3 can discharge itself:

| Dependency | Current state | Blocks |
|---|---|---|
| **Stream 2 candidate selection (C3b)** | Adversarial checks A1–A6 + C1 (Kodaira)/C2 (Picard lattice) infrastructure built (`checkers/`) but **not yet executed with real data** — Phase 1 provenance gate (literature PDF fetch) still open. No "top C3b-passing candidate pair" exists yet. | S3-00 step (2)/(3): m_φ, α_D, Λ_D derivation needs a **selected** candidate's period geometry and Kodaira fiber data. |
| **`ASSUMPTIONS.md` sign-off** | **DRAFT v0.1, explicitly unverified, "NOT YET T0-AUTHORED OR SIGNED OFF"** (file's own header). A-SEQ, A-VOL, A-ONT, A-REL are best-inference reconstructions, not Xavier-authored Tier C rulings. | Every S3-00 quantity must carry an assumption-ID tag (`ASSUMPTIONS.md` CI contract §"CI / Audit Contract"); tagging unsigned assumptions is honest bookkeeping, but the MVM result inherits an unresolved Tier C ceiling until Xavier reviews/replaces them. |
| **`PREDICTION.md` observable narrowing** | **DRAFT v1.0, not frozen.** Three candidate observables (P1 PTA, P2 lensing, Lyman-α null test) listed; §3 explicitly defers narrowing to "consult with astrophysicists" (human outreach — OCA Nice, SYRTE per the file). | S3-00 step (3) "pinned observable (choose first available)" needs the choice actually made and hash-pinned. |

**Do not shortcut these by picking a candidate/observable "for now" and treating the result
as real.** Per `VISION.md` §1.3 and the epistemic-guardrails skill: a prediction derived
before the candidate is selected, or before assumptions are signed, is not a pre-registered
test — it would be indistinguishable from a fit chosen to fit, and undermines the entire
falsifiability program. If you are tempted to shortcut, stop and escalate to Xavier instead
(`briefs/ESCALATIONS.md`), per CLAUDE.md's escalation rule.

**None of this blocks §2–§3 below.** Data acquisition and pipeline architecture do not
depend on which candidate wins or which observable is finally pinned — build them generic
and parameter-free now; point them at frozen `PREDICTION.md` values later.

---

## 2. Non-Blocking Prep: Start Today (WP S3-01)

**Task:** Scripted, checksummed acquisition of the public datasets each candidate observable
will eventually be tested against. This is pure data-engineering — no model content, no
candidate dependency.

### 2.1 Datasets to acquire

| Dataset | Observable it serves | Source |
|---|---|---|
| NANOGrav 15-yr free-spectrum posteriors | P1 (PTA) | Agazie et al. 2023, NANOGrav public data release |
| EPTA Data Release 2 | P1 (PTA) | Liu et al. 2023, EPTA public release |
| SDSS stacked weak-lensing profiles | P2 (halo profile) | Mandelbaum et al. 2013/2020 |
| DES Y3 lensing profiles | P2 (halo profile) | Leauthaud et al. 2024 |
| Euclid Early Release Observations (if available) | P2 (halo profile) | ESA/Euclid public archive |
| SDSS DR12 Lyman-α power spectrum | Lyman-α null test | Palanque-Delabrouille et al. 2015 |
| DESI Early Data Release | Lyman-α null test | DESI public archive |

### 2.2 Deliverables

- `data/MANIFEST.md` — every dataset with exact URL, version/release tag, fetch date,
  SHA256 of the downloaded artifact. Anti-hallucination rule applies here exactly as it
  does to literature parameters in Stream 1/2: **fetch and hash, never transcribe a number
  from memory.**
- `scripts/fetch_stream3_data.sh` (or `.py`) — idempotent fetch script; re-running it must
  either re-download-and-match the pinned hash or no-op if already present and matching.
- CI check: hash verification on every run (per `EXECUTION_PLAN.md` §4 WP S3-01 validation
  column — "Checksum CI").

### 2.3 Acceptance

- [ ] All datasets in the table above fetched, hash-pinned, versioned in `MANIFEST.md`
- [ ] Fetch script is idempotent (safe to re-run, e.g. in CI on every commit)
- [ ] No dataset is referenced anywhere in the repo without a `MANIFEST.md` entry

**This work is fully decoupled from §1's blockers — do it now.**

---

## 3. Non-Blocking Prep: Pipeline Architecture (WP S3-02, generic scaffold only)

**Task:** Build the V5 pipeline's *shape* — the part that does not depend on which
candidate or observable is finally selected — so that once `PREDICTION.md` freezes, only
parameter values need to be plugged in, not new code.

### 3.1 Design constraints (binding, from `EXECUTION_PLAN.md` §4 WP S3-02 + `VISION.md`)

- **No free knobs.** The pipeline reads frozen `PREDICTION.md` parameters and the Free-Parameter
  Ledger (`EXECUTION_PLAN.md` WP P0-B). It does not define parameters; it consumes them.
- **Every comparison labeled `TEST` or `FIT`** at the point of output — never left implicit.
  A shape-only prediction (e.g., P2's radial-slope shape) is `TEST`; a normalization fitted
  to the same data it is compared against is `FIT`. Mixing these without the label is the
  exact failure mode `TUNING_LOG.md` exists to catch.
- **Assumption-tag pass-through.** Every output the pipeline produces carries the
  assumption-ID list (`[A-SEQ, A-VOL, A-ONT, A-REL]` or whichever subset applies) inherited
  from the `PREDICTION.md` quantity it's testing. Do not strip these in transit.

### 3.2 Required golden tests (build before any real data touches the pipeline)

1. **Closure test:** inject a synthetic signal matching the model's predicted shape into
   synthetic "data"; pipeline must recover the injected parameters within stated tolerance.
2. **Null test:** run the identical pipeline on null synthetic data (no injected signal);
   pipeline must report null / no detection at the stated significance level (α) — i.e., no
   false positive rate above what's declared.

Both tests must be in CI and green **before** the pipeline is pointed at any real public
dataset. This is the honesty check that the pipeline isn't secretly tuned to always find
something.

### 3.3 What NOT to build yet

- Do not hard-code s7, s10, or any specific candidate's numbers into the pipeline. The
  pipeline is candidate-agnostic; `PREDICTION.md` (once frozen) supplies the numbers.
- Do not select P1 vs P2 vs Lyman-α as "the" observable in code — build the pipeline to
  accept whichever is pinned, or build thin adapters for each of the three so the eventual
  choice is a config change, not a rewrite.

### 3.4 Acceptance

- [ ] Pipeline architecture documented (input: frozen `PREDICTION.md` + ledger; output:
      pass/fail + likelihood/exclusion + TEST/FIT label + assumption tags)
- [ ] Closure golden test green in CI
- [ ] Null golden test green in CI
- [ ] Zero hard-coded candidate-specific numbers in pipeline code

---

## 4. Full Sequenced Plan (Execute Once §1's Blockers Clear)

This is `EXECUTION_PLAN.md` §4's work-package table, expanded into an executable sequence.
**Do not start step N+1 before step N's Definition of Done is met** — the two-model rule
and pre-registration discipline exist precisely to prevent look-ahead bias.

### Step 0 — Confirm unblocked

Before anything below: verify (a) Stream 2 has published a `K3_SELECTION_REPORT.md` (or
equivalent) naming the C3b-passing candidate pair, (b) Xavier has reviewed and either
signed or replaced each `ASSUMPTIONS.md` entry, (c) `PREDICTION.md`'s observable choice is
made and about to be hash-pinned. If any of (a)–(c) is missing, stop and return to §1/§2/§3.

### Step 1 — WP S3-00: `PREDICTION.md` MVM Matching (the hard gate)

**This is, per `EXECUTION_PLAN.md`, "the single hardest task in the program." Model:
T0 derives, T0s blind re-derives — not a T1/T2 task.**

1. Install the Free-Parameter Ledger (WP P0-B): 7-row table classifying every EFT degree
   of freedom as GEOMETRIC / CONTINUOUS-FREE / DISCRETE / ASSUMED under A-SEQ/A-VOL/A-ONT/A-REL.
2. For the Stream-2-selected top candidate pair, derive **in order**:
   - (a) `m_φ(𝒱, g_s)` from period geometry at the C3b-selected vacuum point
   - (b) `α_D, Λ_D(𝒱, g_s)` from Kodaira fiber data (C2 output) and gauge-kinetics RG running
   - (c) Eliminate `(𝒱, g_s)` between the observables → **a relation, not a number**
3. Pin the observable (first available, per current `PREDICTION.md` draft ordering):
   **P1 (PTA)** if `m_φ ∈ 10⁻²³–10⁻²² eV` → nHz pulsar-timing residuals, `f = m_φ/π`;
   else **P2 (lensing)** → `σ(v)/m` velocity-shape (`TEST`) + `r_c(M_halo)` normalization (`FIT`).
4. **Kill condition (pre-committed, evaluate honestly):** if no observable-relation
   survives the `(𝒱, g_s)` elimination, the model is generic vdSIDM → **F5 triggers**. This
   is a real, reportable outcome, not a failure to hide.
5. **Tag every prediction** with its assumption list `[A-SEQ, A-VOL, A-ONT, A-REL]`.

**Definition of Done:** T0 and T0s derivations agree within stated tolerance on `m_φ`,
`α_D`, `Λ_D`, and the final observable relation; numbers + uncertainties + assumption tags
committed **hash-pinned before any data contact**; kill condition evaluated and result
recorded either way.

**Validation:** two-model rule (§1.2.3); blind re-derivation diff report; assumptions
audit; commit-timestamp check (the hash-pin must predate any dataset fetch touching this
observable — `git log` timestamps are the audit trail).

### Step 2 — WP S3-03/S3-04: Run the pinned comparison

Point the §3 pipeline at the now-frozen `PREDICTION.md` values and the §2-acquired data:

- **If P1 selected:** compare predicted nHz spectrum (`f`, amplitude) against public
  NANOGrav/EPTA posteriors. Report as exclusion σ or Bayes factor. This is a comparison
  against published products — no claim of NANOGrav/EPTA collaboration involvement. `TEST`
  (kernel-blind by design — the comparison target wasn't seen before the prediction froze).
- **If P2 selected:** halo-profile prediction (`r_c` vs `M_halo` shape) vs published stacked
  profiles (dwarf regime). Split label: shape = `TEST`, normalization = `FIT`.

**Definition of Done:** result reproduces from a clean checkout in one command; assumption
tags preserved end-to-end into the output.

**Validation:** reproducibility CI; T0 reviews the interpretation (not the arithmetic).

### Step 3 — WP S3-05: `OBSERVATIONAL_REPORT.md`

- T1 assembles the results tables (machine-generated, no hand-entered numbers in evidence
  sections).
- **T0 writes the interpretation section only** — and per epistemic-guardrails, every Tier C
  sentence in that interpretation carries its conjecture marker in the same sentence; no
  forbidden verb (*predicts, establishes, shows, implies, locks, governs, determines,
  demonstrates, proves*) applied to an unconstructed physical mechanism.
- Every observable result carries its `TEST`/`FIT` label and assumption list.
- F3/F4/F5 branches triggered **mechanically from thresholds + the kill-condition check**,
  never from judgment calls made after seeing the result.
- **Publish even — especially — if every result is an exclusion.** A clean exclusion is
  the honest outcome the whole falsifiability design exists to produce; VISION.md is
  explicit that this is not a failure mode for the project.

**Definition of Done:** report published; kill-condition evaluation recorded; no
hand-entered numbers in evidence sections.

**Validation:** T0s adversarial pass (actively hunts for assumption-breaking
counter-evidence, per `EXECUTION_PLAN.md` §5.2); Xavier sign-off.

---

## 5. Epistemic Guardrails Specific to Stream 3 (Binding — Do Not Relax)

1. **`TEST` vs `FIT` is not cosmetic.** A number compared against data it was never fitted
   to is `TEST`; a number tuned using the same data it's then compared against is `FIT`.
   Mislabeling either direction is the single most common way a falsification program
   quietly becomes unfalsifiable. When in doubt, label conservatively (`FIT`) and ask.
2. **Tier C sentences need in-sentence markers.** Any claim connecting the geometry to an
   actual physical dark-sector mechanism ("the model predicts...", "this establishes...")
   must carry `[C]`/"we conjecture"/"if the matching holds" in the **same sentence** — not
   in a footnote three paragraphs later.
3. **The Sym²/Shioda–Inose relation implies no physics by itself.** If any Stream 3 prose
   drifts toward "the geometry links/locks/couples the bulk to the dark-matter EFT,"
   that's the exact overreach `VISION.md` §1.3 rules out. State the geometric fact and the
   physics conjecture as two separate, separately-tiered statements.
4. **No numbers from memory.** Every constant that ends up in `PREDICTION.md`,
   `OBSERVATIONAL_REPORT.md`, or pipeline code must trace to a `MANIFEST.md`-pinned
   dataset, a Stream 1/2 certificate, or a cited reference — never transcribed from a
   model's training data.
5. **Kill conditions are pre-committed, not negotiated after the fact.** The S3-00 kill
   condition and the F3/F4/F5 falsification branches are locked in *before* data contact.
   If a result is inconvenient, the response is to report it under the pre-committed
   branch, not to revisit the branch definition.
6. **Provenance footer on every generated artifact:**
   `Generated-by: <model/tier> | Verified-by: <verifier> | Reviewed-by: <T0 Y/N>`

---

## 6. What to Report Back to Stream 1

- Once S3-00 completes: the final observable relation and its assumption tags, so Stream 1
  can cross-check against the C3b geometric data (`briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md`
  feedback loop).
- Any point where an `ASSUMPTIONS.md` entry is found to be **wrong** (not just unsigned) —
  per F6 discipline, this needs a disclosure note in the repo README in the same PR that
  fixes it, not a silent correction.
- The kill-condition outcome either way (survives / triggers F5) — this is the single most
  important fact this entire multi-year program produces; it must be recorded regardless of
  which way it falls.

---

## 7. Summary Timeline

| Phase | Depends on | Can start |
|---|---|---|
| §2 Data acquisition (S3-01) | Nothing | **Now** |
| §3 Pipeline scaffold + goldens (S3-02, generic) | Nothing | **Now** |
| §4 Step 1: S3-00 MVM matching | Stream 2 candidate selection + `ASSUMPTIONS.md` sign-off + `PREDICTION.md` freeze | Blocked — see §1 |
| §4 Step 2: S3-03/S3-04 comparisons | Step 1 complete | After Step 1 |
| §4 Step 3: S3-05 report | Step 2 complete | After Step 2 |

---

*Generated-by: Sonnet 5 (Stream 1 → Stream 3 cross-stream handoff, per `EXECUTION_PLAN.md`
§5.1 Fable duty "cross-stream consistency review") | Verified-by: none — this is a routing/
directive document, not a claim requiring a checker | Reviewed-by: T0 N (pending Xavier)*
