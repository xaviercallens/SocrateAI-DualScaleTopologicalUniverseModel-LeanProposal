# AXIOMS — Inventory of Axiom Declarations

**Status:** Phase 0 Scaffold (v0.1)  
**Frozen at:** [G0 phase gate]  
**CI enforced:** Every new `axiom` declaration outside `Axioms/` is rejected.

---

## Purpose

This file maintains a complete, auditable inventory of all non-standard assumptions used in the formal Lean development. Every `axiom` declaration must:

1. Reside in the `Axioms/` subdirectory (enforced by hook).
2. Appear in this register with a justification.
3. Carry a `-- Source:` or `-- Justification:` docstring in the `.lean` file.

---

## Current Inventory

### Axioms — Total Count: **0** (in `Axioms/`)

*(Empty as of Phase 0 scaffold — no axioms in the quarantined `Axioms/` directory.)*

### Known tracked gap — pre-existing vacuous axioms (E-002)

> **Disclosed 2026-07-18 (T0, F6 discipline).** `Agora/Geometry/FTheoryFibration.lean`
> (pre-existing, currently on `main`) contains two axioms that are **vacuously true** and do
> not encode the data their docstrings claim:
>
> ```
> axiom empirical_S12_degree : ∃ P : Polynomial ℚ, P.natDegree = 2 ∧ P.natDegree ≥ 1
> axiom empirical_s7_degree  : ∃ P : Polynomial ℚ, P.natDegree = 3 ∧ P.natDegree ≥ 1
> ```
>
> `P = X²` and `P = X³` satisfy these trivially, referencing no actual S₁,₂ / Cooper-s7 data.
> `theorem1_holds` / `dual_scale_classification` / `DualScaleMaster.lean` inherit this
> vacuity. **These are NOT counted in the budget above** (they live outside `Axioms/` and
> predate the hook) but are recorded here so no downstream claim treats them as content.
>
> **Discharge plan:** WP **S1-07** (approved 2026-07-18, sequenced after S1-04) replaces them
> with genuine `DiffOp3`/`symSquare` operator content from `Agora/SymSquare.lean`. Until then,
> no prose may cite Theorem 1 as a non-vacuous result. See `briefs/ESCALATIONS.md` E-002.

---

## Axiom Budget Tracking

| Phase | Max allowed | Used | Remaining | Status |
|-------|-----------|------|-----------|--------|
| **Phase 0** (baseline) | — | 0 | — | Open |
| **Phase 1** (geometry axiomatization, per S1-05) | TBD by T0 | — | — | Pending |
| **Phase 2** (K3 criteria verification) | TBD | — | — | Pending |

---

## Discharge Policy

Axioms are discharged (removed from this inventory) when:

1. A kernel-checked proof is provided, OR
2. The axiom is shown to be derivable from Mathlib / previously-registered axioms, OR
3. The assumption is reclassified as out-of-scope and the associated code is removed.

Every discharge is logged as a commit message with `Discharges: <axiom-name>`.

---

## Related Documents

- `Axioms/` — Directory containing all axiom declarations
- `OPEN_GOALS.md` — Proof goals blocked on missing Mathlib API (distinct from axioms)
- `EXECUTION_PLAN.md` §1.2 — Routing rules and axiom handling (T0-authorized)
