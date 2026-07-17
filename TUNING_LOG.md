# TUNING_LOG — Assumption-List Changes After Phase Pin

**Status:** Phase 0 Skeleton (v0.1)  
**Initialized at:** 2026-07-17  
**Gate:** G0 (Phase 0 exit) requires this file to exist with CI rule active.

---

## Purpose

Once `ASSUMPTIONS.md` is finalized and Phase 0 is pinned (at G0 gate), any change to the assumption-tag list in `PREDICTION.md`, `K3_CRITERIA.md`, or `ASSUMPTIONS.md` itself must be logged here with full justification.

This file tracks assumption-list mutations *after freezing*, distinguishing them from the initial Phase 0 build-out (which is unlogged).

---

## Entry Template

| Date | Commit | File(s) affected | Assumption ID | Change (old → new) | Justification | Impact |
|------|--------|------------------|---------------|--------------------|---------------|--------|
| YYYY-MM-DD | `abc1234` | `PREDICTION.md` | A-SEQ | Removed (redundant) | Empirical: 3 independent verifications showed no sensitivity to this degree of freedom. | P1 prediction simplifies; no re-calibration needed. |

---

## Change Entries

*(To be populated after G0 gate. Each change to PREDICTION.md assumptions, K3_CRITERIA.md tier tags, or ASSUMPTIONS.md itself is logged here before merge.)*

---

## CI Rule

**Enforced at:** Pre-merge (main branch protection)  
**Rule:** Every commit touching `PREDICTION.md`, `K3_CRITERIA.md`, or `ASSUMPTIONS.md` after Phase 0 pin (G0 gate) must have a corresponding entry in this log, or the commit is rejected.

```bash
# Example CI check (pseudocode)
if commit_touches(PREDICTION.md | K3_CRITERIA.md | ASSUMPTIONS.md):
  if phase_pin >= G0:
    if no_tuning_log_entry_for_this_commit():
      reject_commit("Assumption-list change requires TUNING_LOG entry")
```

---

## Related Documents

- `ASSUMPTIONS.md` — The load-bearing assumptions (frozen at G0)
- `PREDICTION.md` — Observable predictions (tagged with assumption lists)
- `K3_CRITERIA.md` — K3 candidate evaluation criteria (tagged with assumption dependencies)
- `VISION.md` §5 — "Tuning event" definition and pre-commitment
