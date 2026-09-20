# Stream 1 — Theory: Lean 4 Formalization

**Dual-Scale Topological Universe Model: Arithmetic & Formal Verification**

This is **Stream 1** of the Dual-Scale Topological Universe Model project. Its role is to **machine-certify the mathematical claims** (Tier A) and formalize the conjectures (Tier B) in Lean 4.

**See [VISION.md](VISION.md) for the full project scope, roadmap, and epistemic framework.**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22853239.svg)](https://doi.org/10.5281/zenodo.22853239)

**Paper:** *A kernel-checked symmetric-square structure theorem for Cooper's sporadic Apéry-like
operators, and the monodromy lattice of the s₇ family* — archived at
[10.5281/zenodo.22853239](https://doi.org/10.5281/zenodo.22853239) (PDF + full LaTeX sources),
corresponding to release [`v0.8-lean-4.34.0-rc2`](https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal/releases/tag/v0.8-lean-4.34.0-rc2).

---

## What This Repository Does

- **Formalizes Cooper sequences** as holonomic Picard-Fuchs ODEs.
- **Proves arithmetic properties**: order-3 operator = symmetric square of order-2, congruence relations, integrality of mirror maps.
- **Bridges to K3 geometry** via clearly-marked axiomatized conjectures, so proof obligations are machine-readable.
- **Targets Mathlib contribution**: full algebraic-geometric machinery (K3 surfaces, Kodaira classification) is a 12–24 month horizon.

This repository is **not** responsible for:
- Ranking K3 candidates (→ Stream 2, `SocrateAI-Scientific-Agora-K3-DarkMatter`)
- Testing predictions against data (→ Stream 3, `SocrateAI-Scientific-Agora-Home`)

---

## Toolchain (pinned)

| | Value |
|---|---|
| Lean | `leanprover/lean4:v4.34.0-rc2` |
| Mathlib | tag `v4.34.0-rc2` = commit `85e3a25e006c35636f0e53b0e9296caca2685bc0` |

Migrated from Lean `v4.32.0` / Mathlib `3dffaf2f…` on **2026-09-20** (T0 decision). The pin matches
`SocrateAI-Scientific-Agora-LeanMaster` deliberately, so the two projects share one Mathlib olean
cache — that cache is toolchain-exact, and a mismatch costs a from-source Mathlib rebuild.
The pin is frozen again: changing it needs a new dated T0 decision (`CLAUDE.md` rule 1).

The migration required **no change to any Lean source file**; all 314 declaration signatures are
byte-identical across the two versions. Details, and a reusable migration playbook, in
**[`briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md`](briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md)**.

## Verified status

Last checked 2026-09-20 at the pin above. **Re-run the commands rather than trusting these numbers.**

| Check | Result |
|---|---|
| `lake build Agora OpenGoals Tests` | 3155 jobs, **0 errors** (linter warnings only) |
| Axiom audit of `Agora` | **165 theorems audited.** 162 depend only on `propext`, `Classical.choice`, `Quot.sound` |
| — the other 3 | depend on the two *registered, disclosed* axioms below; no `sorryAx`, no `Lean.ofReduceBool` |
| `sorry` | **exactly one**, `OpenGoals/PartnerIntegrality.lean:201` (`open_goal_partner_eq_sqrt_s7`) |
| Statement lock | OK — 299 declarations in 25 files, none changed |

The two axioms, both registered in [`AXIOMS.md`](AXIOMS.md):

- **`obrien2016_theorem6_2`** — a literature citation (O'Brien 2016, MSc thesis, Massey University,
  Thm 6.2 p.47), used once, to close `open_goal_partner_integral_s7`. Not re-derived here.
- **`pipeline_upper_bound`** — flagged **DISCLOSED-VACUOUS**: vacuously true, encodes no pipeline
  data, **not** discharged. The two theorems reaching it carry no content from it; do not cite it
  as evidence.

`native_decide` is confined to `Tests/` (four golden numeric tests, each tagged `TRUST:
native_decide`). Results proved that way are kernel-checked *modulo compiler trust*, not plain
Tier A. Nothing in `Agora/` or `OpenGoals/` uses it.

---

## ⚠️ Correction notice — 2026-07-25 (F6 disclosure)

Work published to `main` on 2026-07-25 under the heading "Stream 2 geometry locked" has been
**retracted the same day**. The C1/C2 "certificates", the C3b physics-interpretation brief, the
EFT-matching analyses, and the decision to unlock the EFT phase were all built on checker
scripts that performed **no computation** — every value they reported was a hardcoded
placeholder, and their self-tests returned `True` unconditionally and could not fail.

Specifically retracted: the claim that the s7/s10 fiber configuration is `[I₁, I₁]`; that the
Picard lattice is `[[2,1],[1,2]]` with ρ=2, τ=20; that discriminant −3 indicates an SU(5) GUT
(that lattice is A₂, i.e. SU(3)); that `s7` is the weight-3 modular form η(τ)⁶ (unsupported by
the cited source, which states only that the generating function *composed with* a modular
function is a modular form); and every downstream number, including the 10¹⁸ GeV string scale
and the 10⁴⁰⁻⁴¹ yr proton lifetime. A separate provenance failure: the PDF pinned as Zagier's
paper was in fact an unrelated article on lattice disk coverings, so the "15 sporadic sequences
verified" claim was also false.

**Not affected:** all Lean results, including the D2 closure
(`Agora/Sequences/WZCertificates.lean`, `open_goal_recurrence_s7`/`_s10`). Those are kernel
proofs, independently re-verified and two-model reviewed; `lake build` is green and both
theorems depend only on `propext`/`Classical.choice`/`Quot.sound`. The Cooper parameters
`(13,4,−27,3)` / `(6,2,−64,4)` / `(14,6,192,−12)` were genuinely checked against the fetched
Gorodetsky PDF and stand.

Full analysis, evidence, and remediation: **[`briefs/ESCALATIONS.md` § E-007](briefs/ESCALATIONS.md)**.
Retracted artifacts are retained in place with `⛔ RETRACTED` banners rather than deleted, so the
record stays auditable.

## ⚠️ Correction notice — 2026-07-26 (F6 disclosure): two vacuous "integrality" theorems

`Agora/Sequences/Integrality.lean` (WP S1-03) described itself as proving that Cooper's s7 and
s10 "are integral for all n". It does not. `s7` and `s10` are declared `ℕ → ℕ`, so the two
theorems in question — `s7_is_nat`, `s10_is_nat`, both of the form `∃ k : ℕ, s7 n = k` — are
**tautologies**, closed by `use s7 n`. They restate the type signature and carry no arithmetic
content. This is the same failure mode as E-002 and E-005 (a statement that cannot fail being
cited as though it had been verified); no external claim rested on them, and nothing else in the
repository depended on them.

Both are retained, relabelled `⚠️ VACUOUS`, so they are not silently re-added as evidence. The
file header now states honestly what it does and does not establish.

**The real arithmetic content has been supplied** in the same change, as WP S1-11
(`Agora/Sequences/PartnerIntegrality.lean`): the *order-2 partner* sequences are ℚ-valued —
their recurrence divides by `(k+2)²` — so their integrality is a genuine theorem, and it
separates the candidates. Proved unconditionally: **s10's and s18's partners are NOT integral**
(single witnesses, `17/2` and `45/2` at `n = 2`). **Not proved: s7's partner is integral** — that
is kernel-checked only to `n ≤ 7` (`PASS(7)`) and is registered as the named open goal
`open_goal_partner_integral_s7`, with the reason it is hard (an Apéry-style divisibility, not a
typing fact) recorded there. Please do not cite it as established.

---

## Key Documents

1. **[VISION.md](VISION.md)** — The master vision document. Read this first.
2. **[K3_CRITERIA.md](K3_CRITERIA.md)** — Frozen criteria for ranking K3 candidates (Tier A/B properties). Stream 2 uses this.
3. **[PREDICTION.md](PREDICTION.md)** — Draft falsifiable predictions. Stream 3 tests these against data.
4. **[PHASE_8_FTHEORY_PROPOSAL.md](docs/PHASE_8_FTHEORY_PROPOSAL.md)** — Previous F-theory proposal (for context).

---

## Repository Structure

```
.
├── Agora/                  # The mathematics. No `sorry` anywhere.
│   ├── Axioms/             # The ONLY place an `axiom` may be declared (see AXIOMS.md)
│   ├── Sequences/          # Cooper sequences, recurrences, θ-form operators, Sym² partners
│   ├── Geometry/           # Weierstrass / discriminant / F-theory fibration scaffolding
│   ├── Swampland/          # Swampland constraints, Sym² C3b checker
│   ├── Phenomenology/      # ChameleonRescue
│   └── ML/                 # Python/notebook experiments (not Lean)
├── OpenGoals/              # The ONLY place a `sorry` may appear; each is a named goal
├── Tests/                  # Golden numeric tests (these use `native_decide`)
├── briefs/                 # Session briefs, escalations, cross-stream memos
├── paper/                  # LaTeX manuscript
├── docs/                   # Documentation, references, statement_lock.json
├── data/                   # Test data and sequence values
├── external/               # Vendored third-party repos (reference only — not build deps)
└── scripts/                # Automation (export_open_goals.py, checkers, verification)
```

The `Agora/` – `Agora/Axioms/` – `OpenGoals/` split is the epistemic contract: the mathematics,
the declared assumptions, and the admitted gaps each have exactly one place to live.

---

## Building & Testing

```bash
git clone https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal.git
cd SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal

# Fetch the prebuilt Mathlib oleans for the pinned commit (minutes instead of hours).
lake exe cache get

# Build. Name the targets explicitly — the package declares no default target,
# so a bare `lake build` reports "Nothing to build" and exits 0.
lake build Agora OpenGoals Tests
```

`./scripts/setup_externals.sh` is **not** needed to build. It clones the `external/` submodules,
which are vendored for reference only; since 2026-09-20 no `external/` package is a build
dependency (the unused `QuantumInfo` require was removed during the toolchain migration).

Expect exactly one `sorry` warning, from `OpenGoals/PartnerIntegrality.lean` — that is the single
named open goal, and it is the only permitted location. Verify the claims above with:

```bash
grep -rn '\bsorry\b' Agora OpenGoals Tests --include=*.lean   # one hit, in OpenGoals/
python3 scripts/export_open_goals.py                          # regenerates open_goals.json
```

---

## Roadmap (from VISION.md)

| Phase | Dates | Deliverable |
|-------|-------|-------------|
| **Phase 0** | Weeks 1–2 | VISION.md, K3_CRITERIA.md, draft PREDICTION.md (all three repos) |
| **Phase 1** | Months 1–2 | Finalize falsifiable prediction (M1) |
| **Phase 2** | Months 2–8 | Lean arithmetic formalization + arXiv preprint (M2) |
| **Phase 3** | Months 8–14 | Stream 3 observational report (M3) |
| **Phase 4** | Months 14–18 | Final manuscript(s) |

**This repo's focus:** Phase 2 (months 2–8).

---

## Contact & Collaboration

- **Author:** Xavier Callens (callensxavier@gmail.com)
- **Feedback:** Open issues or PRs. Mathematical results should be reviewed by the modular-forms / mirror-symmetry community before claiming Tier A status.
- **External math libraries:** See `external/` for credits (Lean-QuantumInfo, Lean4PHYS, ml-string-landscape).
  These are vendored for reference and are **not** build dependencies — the repository's only Lean
  dependency is Mathlib at the pinned commit.
- **Sibling repository:** [`SocrateAI-Scientific-Agora-LeanMaster`](https://github.com/xaviercallens/SocrateAI-Scientific-Agora-LeanMaster)
  shares this toolchain pin and supplies the reusable proof-gate tooling (`statement_lock.py`,
  `axiom_audit.py`) used to verify the table above.

---

<sub>README verified against the repository 2026-09-20 (Lean v4.34.0-rc2). Build, axiom, `sorry` and
statement-lock figures are from that session's runs, recorded in
[`briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md`](briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md).
Tier discipline per [VISION.md](VISION.md) §2. Not yet T0-reviewed.</sub>
