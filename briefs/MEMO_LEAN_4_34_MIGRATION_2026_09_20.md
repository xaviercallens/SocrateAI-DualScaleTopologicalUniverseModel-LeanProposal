# Memo — Lean 4.34.0-rc2 migration, and what another session can reuse from this repo

**Date:** 2026-09-20 · **Branch:** `migrate/lean-4.34.0-rc2` · **Status:** built, gated, merged and released.

**Audience:** a Claude Code session (or a person) starting Lean 4 formalization in a *different*
field, on this machine or from these repos. Read §1–§2 if you only want the toolchain. Read §5
before you trust any "verified" claim you find lying around in this program's repos — it is the
part that cost the most to learn.

---

## 1. The pin, and why it is this one

| | Value |
|---|---|
| Toolchain | `leanprover/lean4:v4.34.0-rc2` |
| Mathlib | tag `v4.34.0-rc2` = commit `85e3a25e006c35636f0e53b0e9296caca2685bc0` |
| Lakefile line | `require "leanprover-community" / "mathlib" @ git "v4.34.0-rc2"` |

This is **the same pin as `SocrateAI-Scientific-Agora-LeanMaster`**, deliberately. Pick the same
one for a new project unless you have a reason not to, because Mathlib's olean cache is
*toolchain-exact*: one version's cache is worthless to another, and a mismatch costs a
from-source Mathlib build (hours) instead of a decompress (~96 s, measured).

`rc2` rather than `v4.34.0` final is not an oversight — LeanMaster chose rc2 on 2026-09-19 for
cross-project alignment, and matching it is the whole point.

### The payoff, measured

On this machine `~/.cache/mathlib` → `/mnt/disks/disk-socrateai-local-1/leanmaster/mathlib-cache`
is already populated for this exact commit by LeanMaster. Running `lake update` in this repo
printed:

```
Decompressing 8557 already-cached file(s) (190 already decompressed)
No files to download
Completed successfully in 96659 ms!
```

**Nothing was downloaded.** That is the concrete, reproducible reason to align pins rather than
pick the newest release.

### Two ways to depend on LeanMaster's mathematics

Both are documented in `LeanMaster/docs/USING_LEANMASTER.md`; the working example is
`LeanMaster/examples/consumer_demo/`.

* **(A) Same machine, fastest** — set `packagesDir` to LeanMaster's package directory and
  `require` it by local path. Downloads nothing, reuses its built Mathlib.
  ⚠️ **The path in `consumer_demo/lakefile.lean` is stale** (see §5.5): it still points at
  `…/leanmaster/lake/packages`, which is the **v4.33.1** tree. The v4.34.0-rc2 tree is
  `…/leanmaster/lake-v434/packages`. Using the stale path silently gives you the wrong Mathlib.
* **(B) Any machine** — `require … from git … @ "<tag>"`, then `lake exe cache get`.

**This repo deliberately uses neither.** It keeps its own `.lake` and relies only on the shared
`~/.cache/mathlib`. Reason: it is a published repo with an external audience, and a `packagesDir`
pointing into a sibling checkout on one VM would make its build unreproducible for anyone else.
Use (A) for scratch//downstream work, not for a repo of record.

### Keep build trees off the root filesystem

Root is 146 GB; `/mnt/disks/disk-socrateai-local-1` is 492 GB. A Mathlib `.lake` is ~8 GB.
On this VM the repos, `~/.elan` and `~/.cache/mathlib` are **already** symlinked onto the data
disk, so nothing special is needed — but if you create a new project or worktree, symlink its
`.lake` onto the data disk before the first build, as this migration did:

```bash
mkdir -p /mnt/disks/disk-socrateai-local-1/<project>-lake
ln -sfn /mnt/disks/disk-socrateai-local-1/<project>-lake <project>/.lake
```

---

## 2. What the migration actually cost (v4.32.0 → v4.34.0-rc2)

**Two minor versions, ~4500 lines, 25 files, 314 declarations — and not one line of Lean source
had to change.** That is a genuinely better outcome than expected and should not be generalized:
this development imports only very stable Mathlib (`Polynomial`, `Rat`, `Finset`, `Nat.choose`,
`Real.Basic`, `Mathlib.Tactic`). A project touching analysis, category theory or measure theory
should budget for real drift — LeanMaster's own 4.33.1 migration hit 5 import renames, 3 API
removals, a reserved-attribute collision and **one false proof that had never been checked**
(`docs/INFRA_SETUP.md`).

Build: **3155 jobs, 0 errors.** What did appear, all non-breaking:

| Warning | Where | Note |
|---|---|---|
| `push_neg` deprecated, prefer `push Not` | `Agora/Geometry/Weierstrass.lean:121` | still works at rc2 |
| `Variable name … is not explicitly referenced` | Weierstrass:76, DualScaleStability:229 (×2) | new `unusedVariables` linter reach |
| `This simp argument is unused` | `PartnerOperators.lean:253` (`map_ofNat`, `map_mul`) | new `unusedSimpArgs` linter |
| `push_cast does nothing` | `PartnerOperators.lean:226` | new `unusedTactic` linter |

These were left alone on purpose: silencing a linter is a source change, and the point of this
branch was to prove the port needs none. Clean them in a separate commit if desired.

### One dependency was dropped

`require QuantumInfo` (Timeroot/Lean-QuantumInfo @ `56e83a9288…`) is **removed**. It was pinned to
a Lean-4.32-era commit and would have blocked the bump. It was safe to drop because
`grep -rn QuantumInfo --include=*.lean Agora OpenGoals Tests` returns **nothing** — no file ever
imported it. The vendored submodule stays in `external/` for reference. *Check this kind of
require before assuming a migration is blocked; an unused pin is a fake blocker.*

Stronger than the grep, and accidental: `git worktree add` does **not** initialise submodules, so
`external/` in this worktree contains only empty directories — and the build still completed
3155 jobs with zero errors. That is an *empirical* demonstration that nothing under `external/`
is a build dependency, not an inference from a search.

After the update, this repo's `lake-manifest.json` matches LeanMaster's revisions exactly
(mathlib, aesop, batteries, Qq, proofwidgets, importGraph, plausible, LeanSearchClient, Cli).

---

## 3. The migration playbook, in the order that matters

The Lean kernel checks that a proof proves its statement. It does **not** check that the
statement is still the one that was reviewed. A toolchain migration is exactly where a statement
gets quietly weakened to make something compile. So:

1. **Lock the statements BEFORE editing anything.**
   ```bash
   export LEAN_PROJECT_ROOT=$PWD
   python3 ~/SocrateAI-Scientific-Agora-LeanMaster/tools/statement_lock.py --update $(find <libs> -name '*.lean')
   ```
   It hashes each `theorem`/`lemma` statement up to the top-level `:=` (so swapping `sorry` for a
   real proof is *not* a change) and whole `def`/`structure` bodies. Writes `docs/statement_lock.json`.
2. **Record the `sorry` count and the axiom dependencies at the old version.** You cannot tell
   afterwards whether a new axiom crept in if you never wrote down the old set.
3. Work **on a branch, in a worktree, with its own `.lake`**, so the known-green old build
   survives as a fallback and you can A/B.
4. Bump `lean-toolchain`, rewrite the `require`, `rm lake-manifest.json`, `lake update`.
5. Build. Fix drift. **Re-run `statement_lock.py --check`** — exit 1 means a statement moved,
   which is a weakening, not a port.
6. Re-run the axiom audit and diff it against step 2.

Results of 5–6 here: statement lock **OK** (299 declarations in 25 files, none changed);
declaration signatures byte-identical to the 4.32.0 baseline (314 heads); exactly **one** `sorry`,
the same one as before (`OpenGoals/PartnerIntegrality.lean:201`,
`open_goal_partner_eq_sqrt_s7`).

*(The two counts differ legitimately and are not in tension: 314 is a line-oriented grep for
declaration heads across `Agora/ OpenGoals/ Tests/` including the root `.lean` files, while 299 is
what `statement_lock.py`'s parser admits — it skips declaration forms the grep catches. Use each
as a check against its own baseline, and do not expect them to agree.)*

`LeanMaster/tools/` is reusable from any Lake project via `LEAN_PROJECT_ROOT` — `statement_lock.py`,
`axiom_audit.py`, `prover_loop.py`. `lean_depgraph.lean` and `theorem_atlas.py` are
LeanMaster-specific; copy and edit their library lists.

---

## 4. What is actually verified in *this* repo

Do not restate these from memory — the commands are the source of truth.

* Sole non-standard axiom reached by any theorem: **`Agora.Axioms.obrien2016_theorem6_2`**
  (a literature citation: O'Brien 2016, MSc thesis, Massey University, Thm 6.2 p.47), used once,
  to close `open_goal_partner_integral_s7`. Registered in `AXIOMS.md`.
  `Agora.Axioms.pipeline_upper_bound` exists but is flagged **DISCLOSED-VACUOUS** — vacuously
  true, encodes no data, **not** discharged. Nothing should cite it as content.
* Full audit of the `Agora` library at 4.34.0-rc2: **165 theorems audited, 3 "failing"** — and all
  three are the known, registered axioms, not defects:
  `s7_partner_integral` → `obrien2016_theorem6_2`; `pipeline_ensures_perturbative` and
  `master_moduli_stabilization` → `pipeline_upper_bound` (the vacuous one). The other **162 reach
  only `propext`, `Classical.choice`, `Quot.sound`.** No `sorryAx`, no `Lean.ofReduceBool`.
* **`native_decide` is confined to `Tests/`.** Four uses, all in `Tests/CooperSequences.lean`
  (the golden numeric tests), each tagged `TRUST: native_decide` in its own docstring. Results
  proved that way are kernel-checked **modulo compiler trust**, not plain Tier A, and prose citing
  them must say so. **Nothing in `Agora/` or `OpenGoals/` uses it** — confirmed by the audit
  finding no `Lean.ofReduceBool` anywhere in `Agora`.
  ⚠️ **Trap, and I walked into it:** `grep -l native_decide Agora/…` returns hits in
  `WZCertificates.lean` and `Integrality.lean`. Every one of them is *prose inside a docstring
  asserting "no `native_decide`"*. A filename-level grep for a tactic name will mislead you in
  this repo, because its docstrings discuss tactics constantly. Grep for the tactic in proof
  position, or — better — let `axiom_audit.py` answer it, since `Lean.ofReduceBool` cannot hide.
* One open goal: `open_goal_partner_eq_sqrt_s7`. Three named failed strategies plus a fourth
  post-ruling attempt are recorded in its docstring. Do not re-litigate it without new
  information; read the docstring first.
* `python3 scripts/export_open_goals.py` regenerates `open_goals.json` (Stream 2 consumes it).
  **Never hand-edit it. Do re-run it** — see §5.3.

### The migration does NOT move the axiomatization boundary — checked, not assumed

A toolchain bump is a natural moment to assume a "blocked-on-mathlib" item has become
unblocked. Here it has not, and that was verified by diffing the two Mathlib trees rather than
guessed:

| Justification on record | 4.32.0 | 4.34.0-rc2 |
|---|---|---|
| `NumberTheory/ModularForms/` (justifies the O'Brien axiom) | 23 files | 24 — only `LFunction.lean` added; `QExpansion.lean` 724 → 741 lines |
| `PowerSeries` square root (blocks `open_goal_partner_eq_sqrt_s7`) | absent | **still absent** |
| `RingTheory/PowerSeries/` | 21 files | 21 files |
| holonomic / D-finite sequence API | absent | **still absent** |

So `obrien2016_theorem6_2` is still needed for the same reason as before, and the open goal is
still blocked for the same reason as before. **Neither status may be changed on the strength of
the version bump alone.** Re-run this diff before claiming otherwise.

Tier discipline (`VISION.md` §2, the `epistemic-guardrails` skill) applies to every sentence,
including one-line summaries. Finite checks are reported `PASS(N)`, never bare `PASS`.
The physics tier (Tier C) is **blocked** program-wide: no exact observables exist anywhere, so do
not encode or "temporarily assume" numeric values for them in any `.lean` file or prose.

---

## 5. Findings — things that were wrong, and traps for the next session

These were all found incidentally while doing the migration. None is caused by it.

### 5.1 "CI-enforced" was false — there is no CI
`CLAUDE.md` rule 3 claimed the no-`sorry`-outside-`OpenGoals/` policy was CI-enforced.
**The repo has no `.github/` directory at all.** The only mechanism is
`.claude/hooks/lean_guard.sh`, a Claude Code `PostToolUse` hook, which:
* fires **only** when *Claude* edits a `.lean` file in a session that loads `.claude/settings.json`;
* **blocks** an `axiom` declared outside `Axioms/` (rule 2) — this part works;
* only **warns** about a `sorry` outside `OpenGoals/`; it `exit 0`s. Its own comment says
  "main blocked by CI", which is not true.

A hand edit, a different tool, or any `git commit` bypasses all of it. Rule 3 is corrected on this
branch. **Lesson that travels: verify an enforcement claim by finding the enforcing file before
repeating it.**

`paper/sections/09-formalization.tex` §"Toolchain and layout" carried the same overstatement
("enforced mechanically by a repository hook … the no-`sorry` check excludes `OpenGoals/` and
nothing else"). It was first flagged rather than edited, since the prose is T0-ratified;
**T0 then instructed the amendment the same day (2026-09-20)** and it now reads honestly — the
`axiom` rule mechanically enforced by an editor hook, the `sorry` rule maintained by review and
reported by the audit commands. The original wording and the evidence against it are preserved in
a LaTeX comment at that spot, so the correction is auditable rather than silent. This is the
claim a referee is most entitled to check, which is exactly why it could not ship overstated.

### 5.2 A bare `lake build` is a false PASS in this repo
`CLAUDE.md` documented the full build as `lake build`. This package declares **no
`default_target`**, so that command prints

```
warning: no targets specified and no default targets configured
Nothing to build.
```

and **exits 0**. A session (or a script, or a CI job someone adds later) that runs `lake build`
and checks the exit code will report a green build having compiled nothing at all. Corrected on
this branch to `lake build Agora OpenGoals Tests`.

**This is the same failure shape as the retracted checkers in §5.6** — a check that cannot fail,
reporting success. Worth carrying into any new project: give the package a `default_target`, or
name targets explicitly and never trust a bare build's exit code.

### 5.3 `open_goals.json` was stale
It is generated from Lean docstrings and machine-consumed by Stream 2. Re-running the exporter
produced a diff: the committed copy was missing the **WP S1-14 update block** that has been in
`OpenGoals/PartnerIntegrality.lean` since 2026-07-26 — a substantial passage recording a fourth
proof strategy and an `ore_algebra` tool mismatch. Nobody re-ran the exporter after editing the
docstring. Regenerated on this branch. **If a file is generated, regenerate it before trusting it.**

### 5.4 The paper's toolchain facts go stale on merge
`paper/sections/09-formalization.tex` states `v4.32.0` and mathlib `3dffaf2f…` in three places
(lines 3, 15–17, 281–283). Those become false the moment this branch lands. **The paper edit must
be part of the merge commit, not a follow-up.**

### 5.5 LeanMaster's own downstream docs have two stale numbers
Not this repo's to fix, but they will mislead:
* `examples/consumer_demo/lakefile.lean` `packagesDir` → `…/leanmaster/lake/packages` is the
  **v4.33.1** tree, while the file's own comment says v4.34.0-rc2. Correct tree: `lake-v434`.
* `docs/USING_LEANMASTER.md` §4 says "425 theorems"; `README.md` and
  `docs/VERIFIED_FOUNDATION.md` say **711** audited theorems across ten libraries as of the
  2026-09-19 migration. 425 is the 2026-09-17 figure.

### 5.6 The standing warnings in this program (read before citing anything)
* **Checker scripts in this repo have printed `PASS` while computing nothing.** Four
  `checkers/*.py` once returned hardcoded placeholders with self-tests that could not fail; every
  downstream conclusion was retracted (README correction notice, `briefs/ESCALATIONS.md` E-007).
  **Negative-control any checker before believing a `PASS`** — feed it input that must fail and
  confirm it fails.
* **A statement that cannot fail is not evidence.** Two "integrality" theorems were tautologies
  (`∃ k : ℕ, s7 n = k` for `s7 : ℕ → ℕ`), retained and relabelled `⚠️ VACUOUS`. Same failure mode
  as E-002/E-005.
* **Retracted results are retained in place with `⛔ RETRACTED` banners, not deleted.** If you
  find a number in this repo, check for a banner above it before reusing it. Specifically:
  ρ = 4 / T = 18 and all "Kodaira" readings off L₂/L₃ exponents are retracted (E-007/E-008/E-009);
  ρ = 19 / T = 3 is the current Tier B value.
* Fabricated results have been caught **three times** in this program, twice by the producing
  session itself. Producer ≠ verifier is not bureaucracy here; it is load-bearing.

---

## 6. Landing this branch

Not done — these need a T0 call:

1. Merge `migrate/lean-4.34.0-rc2` → `main`, **with** the `paper/sections/09-formalization.tex`
   toolchain correction (§5.4) **and a recompiled `paper/main.pdf`** in the same commit.
   `paper/main.pdf` is a committed artifact, so a `.tex` edit that ships without a rebuild leaves
   the repository asserting two different toolchains at once — the §5.3 failure, one file over.
   Rebuild with `pdflatex main && bibtex main && pdflatex main && pdflatex main`
   (**`pdflatex`, not `lualatex`** — lualatex is broken in this environment), then confirm the
   page count is still 37 and `grep -c '^!' main.log` is 0; a LaTeX error truncates the PDF
   silently.
2. The main checkout's `.lake` is a real 7.7 GB directory of **4.32.0** artifacts. After merging,
   either delete it and `lake exe cache get`, or repoint it at
   `/mnt/disks/disk-socrateai-local-1/dualscale-lake-v434`. Do not leave a 4.32.0 `.lake` next to a
   4.34.0-rc2 `lean-toolchain`.
3. Decide what "align with LeanMaster" should mean beyond the pin: version alignment only (done),
   or also `require` LeanMaster so `Agora/` can import its lattice/K3/T-duality corpus. The pin is
   a strict prerequisite for either, so nothing is lost by deciding later.
4. `CLAUDE.md` rule 1 has been re-pointed, not lifted: `lake update` is again forbidden without a
   new dated T0 decision.

---

**Reproduce every number above rather than trusting this memo.** In the worktree:

```bash
cd /mnt/disks/disk-socrateai-local-1/dualscale-wt-lean434
cat lean-toolchain                                  # leanprover/lean4:v4.34.0-rc2
lake build Agora OpenGoals Tests                    # 3155 jobs, 0 errors
grep -rn '\bsorry\b' Agora OpenGoals Tests --include=*.lean   # one hit: OpenGoals/PartnerIntegrality.lean:201
LEAN_PROJECT_ROOT=$PWD python3 ~/SocrateAI-Scientific-Agora-LeanMaster/tools/statement_lock.py --check $(find Agora OpenGoals Tests -name '*.lean')
LEAN_PROJECT_ROOT=$PWD python3 ~/SocrateAI-Scientific-Agora-LeanMaster/tools/axiom_audit.py Agora
```

---

Generated-by: Claude Opus 5 (1M context), Stream 1 session 2026-09-20 |
Verified-by: Lean kernel (`lake build`, 3155 jobs, 0 errors), `statement_lock.py --check` (OK, 299 decls),
`axiom_audit.py Agora` (165 audited, 3 on registered axioms), `#print axioms` on five key theorems
diffed against the pre-migration 4.32.0 baseline — identical |
Reviewed-by: T0 **partial** — T0 ruled on §5.1 the same day (the paper's enforcement claim was
amended on instruction) and authorised the merge, push, release and Zenodo deposition. §5.5
(LeanMaster's stale downstream paths) is reported, not actioned — it belongs to that repository.
