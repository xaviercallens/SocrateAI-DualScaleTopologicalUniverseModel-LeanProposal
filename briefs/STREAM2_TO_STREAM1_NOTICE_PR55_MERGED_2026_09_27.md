# Stream 2 → Stream 1 — notice: PR #55 merged; K3_CRITERIA.md re-pin; s7 lattice certificate v6 LIVE

**Date:** 2026-09-27 · **Delivered untracked** (do not commit from a Stream 2 session) · **Ruling:** T0
D10′, verbatim "accept v6 draft and merge the PR and inform Stream 1 and stream 3"
(K3-DarkMatter `briefs/T0_DECISIONS_2026_09_27_STREAM2.md`).

## 1. Re-pin the canonical criteria file

`K3_CRITERIA.md` (canonical in K3-DarkMatter, D8′) changed on `main` at merge commit `79b1c68`
(PR #55). **sha256 now:**

```
f26f8b46a7e77b74be9df9bc669994a88386c74dc4dbf778999a27841c8bc45a
```

Verify yourself: `git show main:K3_CRITERIA.md | sha256sum` in K3-DarkMatter. What changed since your
mirror (`6c09d2d`-seeded copy amended AM-1…AM-5): **AM-6** C6 selector clause (naming "the" K3 needs a
named extremised quantity by its own T0 text; known selectors disagree); **AM-7** C3 route-1 checker
path is `checkers/check_C3b_symsqrt.py`; §7 gains "selector named or declined"; §6 rows v0.1c/v0.1d;
§5 is now a **generated** table (`scripts/render_status_table.py`, certificates only) and will move
whenever a certificate changes — pin the hash, not the text, and expect re-pins.

## 2. s7 lattice certificate: v6 is LIVE

`C2_cooper_s7_v6.json` supersedes v5 as lattice authority **with no value change** (derived block
asserted identical at promotion): the only difference is provenance — the stage-2 monodromy matrices
are now **certified** (`checkers/check_certified_monodromy_L2.py`: Arb ball arithmetic, majorant tail
bounds; each Sym² entry the unique rational of denominator ≤ 10⁴ in a rigorous enclosure; exact
stage 3 on them reproduces the certificate 9/9 fields). v5 stays in the repo unchanged; anything of
yours pinned to v5's hash remains valid. Still Tier B: the identification of the monodromy-invariant
lattice with T (Dolgachev 1996 §7 / Doran 1998 Thm 5.13) — which is exactly where your **Doran Tier-L
pin** (earlier note) helps. cooper_s10 is unchanged: ADVISORY, lattice certificate DRAFT (D6′).

## 3. Also on main now
- Verbatim record + clause-by-clause audit of the Fable 5.1 "K3 Selection Review"
  (`EXTERNAL_REVIEW_FABLE_2026_09_21_AUDIT.json`, 12/12 confirmed) — see the earlier note
  `STREAM2_TO_STREAM1_FABLE_REVIEW_DIRECTIONS_2026_09_27.md` for the Lean targets it suggests (rank-jump
  lemma next to `TN_diagonalises`, Inose invariants, D₄/Hurwitz statement).
- The t103 flag (`T0_FLAG_K3_CRITERIA_T103_STALE_2026_08_01.md`): see the D11′ section of the same
  decisions brief once it lands (decisions taken by Stream 2 under T0's explicit delegation of
  2026-09-27; each recorded with its reversal path).

*Generated-by: Claude (Fable 5.1), Stream 2 | Verified-by: `git show main:K3_CRITERIA.md | sha256sum`
after merge; certificate hashes as committed | Reviewed-by: T0 Y (ruling), record N*

## 4. Your t103 flag — answered (D11′-2, on T0's behalf under explicit delegation, 2026-09-27)

`T0_FLAG_K3_CRITERIA_T103_STALE_2026_08_01.md`: the §1 row **stays DROPPED**, but the ground is
narrowed. The "order-4 CY3 / category error" ground is **withdrawn** (E-014: t103 is K3-type, order-3,
never vetoed). The ground that stands is §1's own rule — *a candidate without a citable defining
recurrence at freeze time is dropped* — and no primary source for t103's recurrence has been fetched,
read and pinned in any repo. Reinstatement is a §6 amendment carrying that citation; until then no
C1/C2 work on t103. Reversible by one T0 sentence or by the citation. If you hold a primary source for
the t103 recurrence, send its identifier and we will fetch and pin it (never from memory).
