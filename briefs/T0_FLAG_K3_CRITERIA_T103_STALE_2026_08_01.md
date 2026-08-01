# Flag for T0 — `K3_CRITERIA.md`'s t103 DROP is stale, contradicted by S2's own later, thorough resolution

**Not an amendment. Nothing changed in `K3_CRITERIA.md` by this brief.** Candidate-register
changes are explicitly T0-owned ("no criterion, threshold, or weight may change except by a
versioned amendment... recorded before any ranking," this file's own header). This is a flag,
found while doing unrelated low-tier bookkeeping in the S2 repo (auditing sequences for a
literature-tabulation task) and cross-checking against this file.

## The contradiction

`K3_CRITERIA.md` §1 (this repo), candidate register, frozen 2026-07-20:
> `~~K-t103~~ | ~~t103~~ | **DROPPED 2026-07-18** — uncitable; "AESZ 103" is order-4 CY3,
> category error (E-001) | — | DROPPED`

S2 repo (`SocrateAI-Scientific-Agora-K3-DarkMatter`) `ESCALATIONS.md` E-014, **RESOLVED
2026-07-26** (8 days after this file's freeze date, so genuinely later information):

> Searched every artifact that classifies t103 [9 named files + full git history search].
> **Every one agrees**: t103 (A276536) has generating-function ODE order 3 / degree 6, is
> K3-type, has integral mirror map (q₂ = 25), and is a GATE-C finalist, kernel-verified in
> Lean (`t103_recurrence_checked`, zero `sorry`)... **No document anywhere records a T0
> decision vetoing t103.** The genuinely-existing order-4, CY3-shape object in this repo is
> a **different candidate**: `cooper_s18`... The "t103 vetoed as order-4 CY3" claim most
> likely conflated these two candidates somewhere upstream... **Resolution: t103 is not
> vetoed. It stays in the GATE-C finalist pool** alongside s7/s10, with the caveat that it
> has no C1/C2 lattice work and no order-2 partner (E-011's ρ=19/T=3 does not cover it).

S2's `TODO.md` (2026-07-27, S2's own restart doc, read first every session) already carries
this as a closed mechanical item: *"t103 status — RESOLVED (E-014, 2026-07-26): not
vetoed... t103 stays in the pool."*

**So: this file's frozen register drops t103 for a reason S2's own later, far more thorough
investigation found to be unfounded** (no T0 record exists anywhere; the disqualifying
"order-4 CY3" property belongs to a different candidate, `cooper_s18`, not t103). The
correction never propagated back to this file.

## What I checked, so this isn't itself another unverified claim

- Read E-014's full text in `ESCALATIONS.md` directly (not summarized from TODO.md alone) —
  confirms the 9-artifact + git-history search, the exact q₂=25 mirror-map value, and the
  Lean kernel-check name (`t103_recurrence_checked`).
- Confirmed dates: this file's freeze (2026-07-20) predates E-014's resolution (2026-07-26)
  — E-014 is not something this file's authors could have known about.
- Checked S22 (this file's other DROPPED-2026-07-18 entry, same E-001 amendment) for a
  similar later reversal: **found none.** No mention of S22 anywhere in S2's `TODO.md` or
  `ESCALATIONS.md`. S22's drop appears to stand un-contested — this flag is about t103
  specifically, not a claim that E-001 was wrong generally.
- Checked whether S2's `VISION.md` (dated 2026-07-26, i.e. even-later than this file but
  same day as E-014) reflects the correction: it still lists candidates as "s7, s10, S22,
  t103" in three places (lines 23, 52, 111) — consistent with keeping t103 (per E-014) but
  **also still listing S22**, which nothing has un-dropped. `EXECUTION_PLAN.md` (S2) has the
  same S22 residue at lines 49/84. So VISION.md/EXECUTION_PLAN.md are *also* stale on S22,
  independent of this file.

## Why this matters beyond one candidate name

This is very likely the deepest reason `K3_CRITERIA.md` never got its declared "hash-pinned
copy" into `SocrateAI-Scientific-Agora-K3-DarkMatter` (this file's own stated "repo of
record") — the full v1.0 freeze (criteria thresholds/weights, §7) was never completed
("SKELETON v0.1, NOT YET FROZEN," this file's own status line), so the copy-at-freeze
propagation this file promises never triggered. That gap was independently flagged this
session in the S2 repo (`briefs/LOW_TIER_QUEUE_2026_08_01.md` item A-S2-1, S2's own
`VISION.md`/`EXECUTION_PLAN.md` cite a "frozen `K3_CRITERIA.md`" that doesn't exist in that
repo) — this brief supplies the missing half of that picture: the file exists, just in the
other repo, un-synced, and now also stale on at least one candidate.

## Recommendation (non-binding, T0's call)

1. Amend this file's §1 register: restore t103 (citing E-014's resolution verbatim, per
   this repo's own amendment protocol §6), leave S22 dropped (uncontested).
2. Separately: T0 decide whether/when to complete the full v1.0 freeze (§7 thresholds) and
   propagate the hash-pinned copy to S2 as this file's header promises — or formally revise
   that promise if the sync mechanism isn't going to be used as originally designed.
3. Once (1) lands, S2's `VISION.md`/`EXECUTION_PLAN.md` S22 residue (3+2 lines respectively)
   should be corrected to match — mechanical once the register itself is settled, not before.

---
*Generated-by: Fable 5 (T1 coordinator) | Verified-by: direct read of `ESCALATIONS.md` E-014
full text, `TODO.md`, `VISION.md`, `EXECUTION_PLAN.md`, and this file's own dates/header —
no claim restated from a summary without checking the source | Reviewed-by: pending T0*
