# ESCALATIONS — T0-Owned Ambiguities

Per `CLAUDE.md`: "Ambiguity in the `symSquare` API or the axiomatization boundary is
T0-owned: write an escalation note here instead of improvising the mathematics."

---

## E-001: "S22" and "t103" candidates unidentified in sporadic-sequence literature

**Filed by:** Claude (Sonnet 5 tier), WP S1-02  
**Date:** 2026-07-17  
**Status:** OPEN — blocks K3_CRITERIA.md candidate register rows K-S22, K-t103; blocks
their inclusion in Agora/Sequences/CooperRecurrences.lean.

### What was attempted

WP S1-02 requires encoding s7, s10, S22, and t103 as Lean data with `-- Source:`
citations (`EXECUTION_PLAN.md` §2, row S1-02). The complete, well-documented
classification of "sporadic Apéry-like sequences" consists of exactly **15** named
sequences:

- 6 due to D. Zagier (labels A, B, C, D, E, F)
- 6 due to Almkvist–Zudilin (labels α, β, γ, δ, ε, ζ)
- 3 due to S. Cooper (labels **s₇, s₁₀, s₁₈** — subscripts denote the level of the
  associated modular form)

Sources checked (multi-query web search + direct fetch, per the anti-hallucination
protocol — no claim taken from model memory):

- S. Cooper, "Sporadic sequences, modular forms and new series for 1/π",
  Ramanujan J. 29 (2012), 163–183.
- O. Gorodetsky, "New representations for all sporadic Apéry-like sequences, with
  applications to congruences", Exp. Math. 32 (2023), arXiv:2102.11839.
- D. Zagier, "Integral solutions of Apéry-like recurrence equations" (survey).
- Multiple secondary sources (arXiv:2312.07134 "On sporadic sequences",
  arXiv:2302.00757, Wikipedia "Ramanujan–Sato series").

**"S22" and "t103" do not appear as sequence names anywhere in this literature.**
s7 and s10 were successfully identified, cited, and encoded (see
`Agora/Sequences/CooperRecurrences.lean`); s18 (Cooper's third sequence) was
identified but not yet encoded (lower priority — not in the original candidate list).

### Working hypothesis (NOT acted on — flagged for T0/Xavier judgment only)

"t103" resembles a garbled reference to an **AESZ database** label (Almkvist–van
Enckevort–van Straten–Zudilin catalogue of Calabi-Yau operators,
https://cydb.mathematik.uni-mainz.de/). If so, "AESZ 103" would denote a
**fourth-order** differential operator (Calabi-Yau *threefold* Picard-Fuchs type),
not a third-order K3-type operator. Using it as a K3 candidate (as
`K3_CRITERIA.md`'s register implies) would be a category error — order-4 CY3
operators are not order-3 K3 operators (cf. `Agora/Geometry/FTheoryFibration.lean`'s
own `IsK3SurfaceODE`/`IsCY3ODE` distinction, which are defined as mutually
exclusive). **This is a hypothesis, not a verified identification — do not encode
under this name without confirmation.**

No comparable hypothesis was found for "S22". It may be a typo/mislabeling of
Cooper's s18, of the elliptic-curve-side "S_{1,2}" already used elsewhere in the
codebase (see E-002 below — which has its own sourcing problem), or an entirely
different object not yet searched correctly.

### Requested resolution

1. **Xavier / T0:** confirm or supply the correct citation (paper + table/equation
   number) for whatever "S22" and "t103" are meant to denote, OR
2. **Per K3_CRITERIA.md's own stated rule** ("a candidate without a citable
   defining recurrence at freeze time is dropped, not guessed"): drop K-S22 and
   K-t103 from the candidate register at freeze, leaving K-s7 and K-s10 (now
   properly cited) as the Phase 0 candidate set.

### Impact if unresolved

`K3_CRITERIA.md` v1.0 cannot freeze with these two rows in their current TBD state
per the file's own pre-freeze checklist. `EXECUTION_PLAN.md` S2-01/S2-04 (Stream 2
K3 ranking) would run on an incomplete candidate set if these are silently dropped
without a recorded decision — recommend an explicit amendment entry either way.

---

## E-002: Pre-existing axiom `empirical_S12_degree` / `empirical_s7_degree` are vacuous

**Filed by:** Claude (Sonnet 5 tier), discovered during WP S1-02  
**Date:** 2026-07-17  
**Status:** OPEN — informational, not blocking S1-02, but blocks honest S1-04/S1-05
work if left uncorrected.

### Finding

`Agora/Geometry/FTheoryFibration.lean` (pre-existing, already merged to `main`,
0-sorry) contains:

```lean
axiom empirical_S12_degree : ∃ (P : Polynomial ℚ),
  P.natDegree = 2 ∧ P.natDegree ≥ 1

axiom empirical_s7_degree : ∃ (P : Polynomial ℚ),
  P.natDegree = 3 ∧ P.natDegree ≥ 1
```

Both are **vacuously true** — e.g. `P = X^2` and `P = X^3` respectively satisfy
these existentials trivially, without reference to any actual data of the S_{1,2}
or Cooper s7 sequences. The docstrings cite "AutoEvolve pipeline exact-rational
nullspace extraction" as source, but the axiom statement itself encodes no content
connecting it to that pipeline's actual output (no recurrence coefficients, no
sequence values, nothing falsifiable). `theorem dual_scale_classification` and the
downstream `DualScaleMaster.lean` master theorem inherit this vacuity — the proof
that "S_{1,2} is Order-2 and s7 is Order-3" is true of *any* two polynomials of
degrees 2 and 3, which is content-free as physics/mathematics (this matches the
v0.1 audit finding already in project memory: "Theorem 1 is '2 ≠ 3' without
mentioning the objects"). It carries no information about the actual sequences.

This directly conflicts with `CLAUDE.md` rule 4 ("Every literature-encoding
definition has a `-- Source:` docstring") in spirit if not letter — a docstring
citing a source for a statement that doesn't actually encode that source's content
is misleading, not honest provenance.

### Not fixed in this session because

Fixing this properly means replacing the axioms with genuine data (now available:
`Agora/Sequences/CooperRecurrences.lean`'s `s7`/`s7_params`, real and cited) and
re-deriving `theorem1_holds` from actual recurrence content — a nontrivial
refactor touching `FTheoryFibration.lean`, `DualScaleStability.lean`,
`ChameleonRescue.lean`, and `DualScaleMaster.lean`. Out of S1-02's declared scope;
recommend a dedicated WP (proposed: **S1-07 — retire vacuous Theorem 1 axioms**)
rather than an opportunistic fix.

### Requested resolution

T0 to confirm scope/priority of S1-07, or explicitly accept the current axioms as
a known, tracked gap (update `AXIOMS.md` to record the vacuity explicitly rather
than implicitly).

---

## E-003: Local-disk data-loss incident during cross-session disk migration

**Filed by:** Claude (Sonnet 5 tier)  
**Date:** 2026-07-17  
**Status:** RESOLVED (this repo) / OPEN (Mirror-Map-Sieve, separate repo)

### What happened

A separate concurrent session ("antigravity") ran a disk-migration chain moving
several large directories from the OS boot disk to the mounted second disk
(`/mnt/disks/disk-socrateai-local-1`) and replacing each with a symlink, to
relieve OS-disk pressure (root disk was at 49GB free / 146GB before, and had
already caused an `ENOSPC` failure in this session's own tool sandbox). Of six
items migrated, two — this repo and `Mirror-Map-Sieve` — ended up as **broken
symlinks**: source directory deleted from the root disk, no corresponding data
present at the destination on the second disk. `.cache`, `.elan`, `venv`, and
`SocrateAI-Scientific-Agora-K3-DarkMatter` were independently verified intact.

Root cause of the partial-move failure is unknown (no visibility into the other
session's terminal). Live-recovery checks (open file descriptors, `lost+found`,
undelete tooling) all came back negative; the root filesystem is mounted with
`discard`, which makes classic block-level undelete unlikely to have succeeded
even with proper tooling, this long after the event.

### Resolution (this repo only)

Per Xavier's explicit choice (reconstruct now): re-cloned from GitHub
(`origin/main` at `ecb85e4`, the pre-session baseline — nothing from this session
had been pushed), reinitialized submodules, and re-applied every local-only
change from this session's own record (S1-01, P0-D, and all of S1-02 including
this escalations file) verbatim. No content was actually lost — it existed in
the acting model's own context — only the on-disk copy needed rebuilding.
Discovered in the process: `.claude/hooks/lean_guard.sh` was already committed
(`df271e6`) but never wired into `.claude/settings.json`; fixed as part of the
S1-01 re-commit rather than reintroducing the cruder ad-hoc hook this session had
built before the incident.

### Still open

`Mirror-Map-Sieve` remains a broken symlink as of this writing — outside this
repo's scope and this session's context (no prior knowledge of its contents to
reconstruct from). Xavier/the antigravity session needs to check its GitHub
remote the same way this repo's loss was bounded, or restore from another
backup.

### Process note for future sessions

Any session running or observing a bulk filesystem migration that touches a
repo's own directory should treat "processes still running on overlapping
paths" as a hard stop, not a race to finish first — this incident's actual
data loss happened in the *other* session, but this session's own read/write
operations were correctly withheld once the conflict was detected (see
git history / conversation log around 2026-07-17 17:15–17:22 for the sequence).
