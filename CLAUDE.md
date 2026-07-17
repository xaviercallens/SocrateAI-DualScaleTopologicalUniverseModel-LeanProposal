# CLAUDE.md — Stream 1: Theory (Lean 4)

Formal verification repo for the Dual-Scale program. Governing docs: `VISION.md` (esp. §1.3, §2),
`EXECUTION_PLAN.md` §2. Read the **lean-proof-workflow** skill before touching any .lean file and
the **epistemic-guardrails** skill before writing any prose.

## Commands
- Build: `lake build` (full), `lake build <Module>` (targeted)
- Tests: `lake build Tests` (golden numeric checks vs literature values)
- Open goals: `lake exe export_open_goals` → `open_goals.json` (machine-consumed by Stream 2; never hand-edit)

## Non-negotiable rules
1. Never `lake update`; toolchain and Mathlib pin are frozen (missing API → OPEN_GOALS.md "blocked-on-mathlib").
2. `axiom` only in `Axioms/`, registered in `AXIOMS.md` (hook-enforced).
3. `sorry` on branches only; on `main` only inside `OpenGoals/` (CI-enforced).
4. Every literature-encoding definition has a `-- Source:` docstring.
5. Three failed strategies on a lemma → named open goal, move on. No unbounded grinding.
6. Never silently weaken a statement to make it provable.

## Escalation
Ambiguity in the `symSquare` API or the axiomatization boundary is T0-owned: write an
escalation note in `briefs/ESCALATIONS.md` instead of improvising the mathematics.
