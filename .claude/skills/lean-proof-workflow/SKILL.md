---
name: lean-proof-workflow
description: The proof-development loop for this Lean 4 / Mathlib repo. Use this skill for ANY work on .lean files — stating definitions, attempting proofs, fixing build errors, adding tests, managing axioms, or exporting open goals. Also use when asked to "grind", "attempt lemmas", or "clear sorries". The Lean kernel is the project's objective verifier; this skill defines how to work with it honestly.
allowed-tools: Bash(lake build:*), Bash(lake env:*), Bash(lake exe:*), Bash(grep:*), Bash(git status:*), Bash(git diff:*)
---

# Lean Proof Workflow (Stream 1)

The kernel is the judge. Your job is to propose; `lake build` disposes. A proof that
does not compile does not exist, no matter how plausible it reads.

## Ground rules

1. **Mathlib is pinned.** Never run `lake update` or change `lake-manifest.json` /
   `lean-toolchain`. If an API you need is missing at the pinned commit, record it in
   `OPEN_GOALS.md` under "blocked-on-mathlib" instead of bumping the pin.
2. **Axiom quarantine.** New `axiom` declarations are allowed ONLY in `Axioms/`, each with
   a docstring justification, and each must be added to `AXIOMS.md` in the same change.
   The post-edit hook blocks `axiom` anywhere else — do not try to work around it.
3. **Citation docstrings.** Every definition encoding a literature object (a recurrence,
   an ODE, an operator) carries `-- Source: <paper, eqn>` in its docstring. A definition
   without a source is a bug even if it compiles.
4. **`sorry` policy.** `sorry` is permitted only on branches, never on `main`. ⚠️ **Nothing enforces
   this**: there is no CI, the build passes with a `sorry`, and the hook only warns. Before ending a session, convert any remaining `sorry` into a named open goal
   (see export below) or delete the attempt.
5. **`decide` vs `native_decide`.** Prefer `decide`/`norm_num`. `native_decide` extends
   the trusted base to the compiler — acceptable for numeric golden tests
   (sequence-vs-literature checks), but any theorem using it must be tagged
   `/-- TRUST: native_decide -/` so prose citing it can disclose the caveat.

## The grind loop (per lemma)

1. `lake build <TargetModule>` — read the FIRST error only; later errors are usually cascade.
2. Inspect the goal state; try, in order of cheapness:
   `exact?` → `apply?` → `simp` / `simp_all` with hypotheses → `omega`/`norm_num`
   (arithmetic) → `decide` (decidable, small) → `induction` on the recurrence index
   with `simp [defn]` on the step.
3. If a rewrite fails, check universe/implicit-argument mismatches before changing tactics.
4. **Three-strikes rule:** after 3 genuinely different failed strategies, STOP. Convert to
   an open goal (below) and move to the next lemma. Unbounded retries burn budget and
   produce nothing the kernel didn't already reject.
5. Never "prove" a statement by weakening it silently. If the honest statement is out of
   reach, keep the strong statement as the open goal and (optionally) prove the weaker
   one under a DIFFERENT name with a docstring noting the gap.

## Open-goal export (feeds Stream 2's status table)

Open goals live as named declarations with `sorry` in `OpenGoals/` (excluded from the
no-sorry CI check for `main` — the ONLY exclusion), one per statement, named
`open_goal_<topic>_<candidate>` (e.g. `open_goal_sym2_s7`). After any session that adds
or discharges one, regenerate the machine-readable list:

```
python3 scripts/export_open_goals.py   # writes open_goals.json at repo root
```

Stream 2's `render_status_table.py` consumes `open_goals.json` — do not hand-edit it.

## Working the Sym² criterion (C3, WP S1-04)

- The `symSquare` API design is T0-owned. Implement against `Agora/SymSquare.lean`'s
  signatures; if the spec is ambiguous, log an escalation note rather than improvising
  the mathematics.
- For each candidate: state `theorem sym2_<candidate> : L3_<candidate> = symSquare L2_<candidate>`.
  Proof attempts follow the grind loop; discharge upgrades the candidate's flag from
  `SYM2_SYMBOLIC` to `SYM2_PROVED` automatically via the export.

## Definition of done (any WP in this repo)

**Run `bash scripts/release_gates.sh`.** It is the checklist, it reads exit codes correctly,
and it is green only after review. There is **no CI** (CLAUDE.md rule 3) — do not write or
repeat that there is.

- Open-goal export regenerated if the goal set changed (`python3 scripts/export_open_goals.py`;
  generated files go stale silently).
- Provenance footer + citation docstrings present (epistemic-guardrails skill).
- Statement lock re-locked **after review**, with the reason recorded in the commit if an
  existing statement CHANGED.

## Reading the gates honestly (LL.md §3 — all of this is mutation-verified)

1. **Never read a gate through a pipe.** `lake build NoSuchTarget | grep "Build completed"`
   exits **0** while lake exits **1**. Capture the status: `cmd > log 2>&1; RC=$?`.
2. **A `sorry` does NOT fail the build** — exit 0, `warning: declaration uses \`sorry\`` only,
   and note the **backticks**: a straight-quote grep finds nothing. The `sorry` gate is
   `axiom_audit.py`, via `sorryAx`.
3. **`axiom_audit.py Agora` exits 1 permanently.** It fails on any registered axiom and the
   steady state is three. Compare the *count* against `EXPECTED_FAILING`, never against zero,
   and read *which* theorems fail.
4. **A gate never seen red is a gate you are trusting, not running.** Mutate it and watch it
   fire before quoting it. Red in the *output* is not red in the *status*.
5. **A scan that cannot see a declaration reports it clean.** Anchoring on `^(theorem|def)`
   hides every `noncomputable`/`private`/`@[simp]` declaration — 41 of 465 here. Run any audit
   tool's `--self-test` first; it must fail in **both** directions.

## Before claiming a theorem proves what its name says (LL.md §1)

- Check that every noun in the name appears in the **statement**. If the object the name is
  about is absent, the claim is in the prose.
- Beware abbreviations that collapse: `fromRows B 0` silently **was** `Phi_T`.
- Constraining an object is not identifying it. Four theorems pinned every property of `sym2`
  and none said what it *is*; state what the object IS (`sym2_is_substitution`).
- Verifying someone else's theorem means verifying the **statement**, not the mathematics they
  describe in prose around it.
- Where a statement could be satisfied trivially, add a **non-vacuity control** and check the
  hypothesis is satisfiable.
