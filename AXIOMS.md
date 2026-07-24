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

### Axioms — Total Count: **1** (in `Axioms/`)

| Axiom | Location | Status |
|---|---|---|
| `pipeline_upper_bound` | `Agora/Axioms/PipelineBound.lean` | **DISCLOSED-VACUOUS** (E-005 / D3) — vacuously true (witness 1), encodes no pipeline data. Relocated here 2026-07-24 (Xavier T0) from `Agora/Swampland/DualScaleStability.lean`; statement verbatim. **NOT discharged.** Discharge path: Lean import of the certified Stream 2/3 artifact (`data/pipeline_artifact.json`, currently PLACEHOLDER-VACUOUS) + restate the bound about that data. See `briefs/ESCALATIONS.md` E-005. |

### DISCHARGED — E-002 vacuous axioms (S1-07, 2026-07-18)

> **Discharged 2026-07-18 by WP S1-07.** The two vacuous axioms
> `empirical_S12_degree` / `empirical_s7_degree` formerly in
> `Agora/Geometry/FTheoryFibration.lean` have been **deleted**. Theorem 1
> (`dual_scale_classification`, `master_fibration_classification`,
> `Master.theorem1_holds`) is now stated about the **concrete θ-form
> Picard-Fuchs operators** of `Agora/Sequences/ThetaOperators.lean`
> (Cooper eq 1.7 / Zagier eq 1.6 templates, coefficients pinned per candidate
> from sourced parameters), and the order-2/order-3 facts are kernel-computed
> (`zagierThetaOperator_natDegree`, `cooperThetaOperator_natDegree` — proved
> for EVERY parameter choice; leading θ-coefficient has constant term 1).
>
> Honest boundary (unchanged): minimality of each operator for its sequence
> and the elliptic/K3 geometric identification remain Tier B (S1-05 bridge
> scope); Theorem 1 may now be cited as a non-vacuous statement **about the
> encoded operators**, nothing more.
>
> Also in S1-07: the unregistered `axiom m87_alpha_eff_certificate`
> (`DualScaleMaster.lean`) was converted to a proved theorem with a vacuity
> disclosure in its docstring (statement `∃ v, v > 0.45` is content-free).

### DISCHARGED — ChameleonRescue numerical-certificate axioms (2026-07-18, T1)

> `Agora/Phenomenology/ChameleonRescue.lean`'s `m87_numerical_certificate`
> ((10⁶)^{1/4} > 2.905) and `density_threshold_certificate` (0.155·R^{1/4} > 0.42 for
> R ≥ 55) — flagged above as likely-provable follow-on — are now **proved theorems**,
> not axioms. Both reduce to a 4th-power numeric bound via `Real.rpow_lt_rpow` /
> `Real.rpow_le_rpow` + `pow_rpow_inv_natCast` (rewrite `x^(1/4)` as `x^((4:ℕ):ℝ)⁻¹`,
> compare 4th powers with `norm_num`, un-power). Contentful statements unchanged;
> no design decision involved (both are fixed-exponent rational rpow, not the
> irrational-exponent case the original docstring anticipated). Both proofs succeeded
> on first attempt, no grind loop needed. `lake build Agora` verified green.

### Known tracked gap — vacuous `pipeline_upper_bound` (E-005)

> **Disclosed 2026-07-18 (T0, F6 discipline, found during S1-07).**
> `Agora/Swampland/DualScaleStability.lean` (pre-existing, on `main`) contains
>
> ```
> axiom pipeline_upper_bound : ∃ (S12_max : ℝ), S12_max ≤ 1.177 ∧ S12_max > 0
> ```
>
> which is **vacuously true** (witness `1`) — the same failure mode as E-002.
> Its docstring cites the GPU pipeline, but the statement encodes none of that
> data. NOTE: the docstring was *expanded* on 2026-07-18 (commit `9c4a6b4`)
> while the statement remained vacuous — the enhanced sourcing must not be
> read as added content. Not counted in the budget above (outside `Axioms/`,
> predates the hook). Discharge path: T0 design of a genuine pipeline-data
> encoding (proposed WP S1-09); see `briefs/ESCALATIONS.md` E-005. Until then,
> no prose may cite `pipeline_upper_bound` or its consumers as data-carrying.

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
