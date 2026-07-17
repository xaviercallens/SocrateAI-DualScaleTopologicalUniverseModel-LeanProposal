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
4. **`sorry` policy.** `sorry` is permitted only on branches, never on `main` (CI blocks
   it). Before ending a session, convert any remaining `sorry` into a named open goal
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
lake exe export_open_goals   # writes open_goals.json at repo root
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

- `lake build` green from clean; CI green (no sorry on main, axiom check, golden numeric
  tests matching literature values via the test files in `Tests/`).
- Open-goal export regenerated if the goal set changed.
- Provenance footer + citation docstrings present (epistemic-guardrails skill).
