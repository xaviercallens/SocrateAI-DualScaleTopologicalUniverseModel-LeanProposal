# ESCALATIONS — T0-Owned Ambiguities

Per `CLAUDE.md`: "Ambiguity in the `symSquare` API or the axiomatization boundary is
T0-owned: write an escalation note here instead of improvising the mathematics."

---

## E-001: "S22" and "t103" candidates unidentified in sporadic-sequence literature

**Filed by:** Claude (Sonnet 5 tier), WP S1-02  
**Date:** 2026-07-17  
**Status:** **RESOLVED 2026-07-18** by T0 (Opus 4.8) under delegated authority from Xavier
("review the best options and take decision on my behalf"). See resolution below.

### RESOLUTION (T0, 2026-07-18)

**Decision: DROP K-S22 and K-t103.** They are not citable in the sporadic-sequence
literature after a documented multi-source search, and K3_CRITERIA.md's own pre-committed
rule is binding: *"a candidate without a citable defining recurrence at freeze time is
dropped, not guessed."* The "t103 = AESZ 103" hypothesis is explicitly **not** acted on —
AESZ 103 is a fourth-order CY3 operator, not an order-3 K3 operator; encoding it would be a
category error and a violation of the anti-hallucination protocol.

**Companion decision: ADD K-s18** (Cooper's genuine third sequence) as an approved
candidate, flagged `PENDING_ENCODING` until its (a,b,c,d) parameters are fetched from
Cooper (2012) Table 1 (fetched, not recalled). Rationale: restores a meaningful ≥3-candidate
ranking pool using a legitimate, citable substitute rather than a guess. s18 does NOT block
S1-04, which proceeds on {s7, s10} now.

**Active candidate register → {s7, s10, s18-pending}.** Recorded as an explicit amendment in
`K3_CRITERIA.md` §1 (still SKELETON v0.1 — this resolves TBD rows, it is not itself a freeze).
Xavier retains phase-gate override per EXECUTION_PLAN §6.5.

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
**Status:** **DISCHARGED 2026-07-18 (WP S1-07, T0 = Fable 5).** Both axioms **deleted**;
Theorem 1 rebuilt on the concrete θ-form Picard-Fuchs operators of
`Agora/Sequences/ThetaOperators.lean` (Cooper eq 1.7 / Zagier eq 1.6 templates, coefficients
pinned from sourced per-candidate parameters). Order-2/order-3 are now kernel-computed for
every parameter choice (`zagierThetaOperator_natDegree`, `cooperThetaOperator_natDegree`).
`Master.theorem1_holds` restated about the concrete operators `ode_S12`/`ode_s7`; the
unregistered vacuous `axiom m87_alpha_eff_certificate` (DualScaleMaster) converted to a
proved theorem with vacuity disclosure. Design note: the operators are encoded in θ-form
(`Polynomial (Polynomial ℚ)`, order = θ-degree) rather than monic D-form `DiffOp3`,
deliberately avoiding the RatFunc normalization trap (escalation trigger E-04b) — the
S1-04 `symSquare`/`DiffOp3` API is untouched and remains the C3 vehicle. Minimality and
geometric identification remain Tier B (S1-05). See `briefs/S1-07.md`.

### RESOLUTION (T0, 2026-07-18)

**Decision: approve WP S1-07 (retire vacuous Theorem-1 axioms), sequenced AFTER S1-04.**
The correct replacement for `empirical_s7_degree`/`empirical_S12_degree` is genuine operator
content, which S1-04's `symSquare` machinery (`Agora/SymSquare.lean`, now landed and
kernel-validated) produces. `IsSymSquareOf` was deliberately designed as a *concrete
coefficient identity* precisely to avoid this vacuity mode — so S1-07 rebuilds Theorem 1 on
`DiffOp3`/`symSquare` data rather than on `∃ P, P.natDegree = 3`.

**Interim honesty (done now):** the vacuity is recorded explicitly in `AXIOMS.md` as a known,
tracked gap (F6 discipline — a known weakness is disclosed, not left implicit), rather than
waiting for S1-07 to land. No new claim may cite `theorem1_holds`/`dual_scale_classification`
as non-vacuous until S1-07 discharges it.

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

## E-004: C3 (Sym²) structure for Cooper's d≠0 operators — needs T0s derivation

**Filed by:** Opus 4.8 (T0), during primary-source fetch for S1-04
**Date:** 2026-07-18
**Status:** **CLOSED 2026-07-18 (two-model).** `W=0` computed and CONFIRMED for all three
candidates (`scripts/check_C3_symsquare.py`, exact sympy, controls pass). Deep Think (T0s)
independent re-derivation CONCURS — see `adversarial/S1-04_C3_deepthink_review.md` and the
T0 adjudication recorded there. `SYM2_SYMBOLIC` is two-model signed for s7/s10/s18;
`SYM2_PROVED` still requires the route-2 Lean kernel proof (WP S1-08). Sequence data
unaffected (done).

### SYMBOLIC VERIFICATION RESULT (scripts/check_C3_symsquare.py, 2026-07-18)

Computed `W` (the self-adjointness / symmetric-square polynomial) for each candidate's order-3
operator, converted from θ-form (Gorodetsky 1.7) to D-form and normalized to monic. Controls:
Apéry a_n (known symmetric square) → `W=0`; a generic non-Cooper operator → `W≠0` (detector works).

| candidate | (a,b,c,d) | W | verdict |
|---|---|---|---|
| s7  | (13,4,−27,3)   | 0 | symmetric square — clears `SYM2_UNVERIFIED → SYM2_SYMBOLIC` |
| s10 | (6,2,−64,4)    | 0 | symmetric square — `SYM2_SYMBOLIC` |
| s18 | (14,6,192,−12) | 0 | symmetric square — `SYM2_SYMBOLIC` |

**→ d≠0 is fully dead as a worry.** All three order-3 operators ARE symmetric squares of
order-2 operators.

### IMPORTANT nuance — C3 is structural, not discriminating

Running `W` on **symbolic** (a,b,c,d) gives `W=0` **identically**: the symmetric-square property
is AUTOMATIC for Cooper's operator ansatz `θ³ − x(2θ+1)(aθ²+aθ+b) + x²(c(θ+1)³+d(θ+1))`. So C3
confirms the Sym² geometric relation *exists* for every Cooper-form candidate but does **not
discriminate** among them. **Candidate selection therefore rests on C1 (mirror integrality),
C2 (Kodaira fibers), C3b (Shioda–Inose moduli map — the actual K3 geometry), C4, C5.** This
explains why C3b was correctly added as the separate, load-bearing criterion.

### Remaining
- ~~Deep Think (T0s) independent re-derivation → two-model closure~~ **DONE 2026-07-18**
  (`adversarial/S1-04_C3_deepthink_review.md` — concurrence on all §6 checklist items).
- Reconstruct explicit L₂ per candidate: **now the C3b work** (S2-01b). NOTE — no explicit
  L₂ has been *exhibited* for any candidate; only existence via `W=0` is established.
  Nothing downstream may cite an explicit L₂ until C3b constructs it (T0 correction to the
  reviewer memo's "verified order-2 partners" phrasing).
- Route-2 Lean kernel proof of the generic `W ≡ 0` identity → `SYM2_PROVED` for the whole
  family: adopted as **WP S1-08**.
- Epistemic: Sym² is a geometric/arithmetic relation only — no physics (VISION §1.3).

### RESOLUTION UPDATE (deeper fetch — Almkvist–van Straten arXiv:2103.08651)

The fetch found the exact theory. Two results (see `refs/cooper_sequences.md` for detail):

1. **Computable C3 criterion (self-adjointness).** A third-order operator is a symmetric
   square of a second-order operator **iff** `W = (1/3)a₂″ + (2/3)a₂a₂′ + (4/27)a₂³ + 2a₀ −
   (2/3)a₁a₂ − a₁′ = 0`. This is the honest per-candidate check — no need to guess L₂ (which
   was the whole difficulty). **Recommend rebasing the S1-04 C3 check on `W=0`.**

2. **d≠0 does NOT obstruct.** The paper's symmetric-square "main component" (p.7) explicitly
   includes d≠0 operators and has exactly Cooper's shape. Matching gives `(α−1)² = −d_C/c_C`;
   for all three candidates this is a perfect square (s7:1/9, s10,s18:1/16 → α = 2/3, 3/4, 3/4),
   the necessary condition to lie on the main component. So the E-004 core worry ("d≠0 breaks
   Sym²") is **likely a non-issue**.

**Still required before clearing SYM2_UNVERIFIED (two-model rule, do NOT skip):**
- (a) Compute `W` symbolically for each candidate's order-3 operator and confirm `W=0` exactly
  (this is the sufficient check, not just the perfect-square necessary condition).
- (b) Independent Deep Think (T0s) re-derivation — running in parallel per Xavier.
- (c) Then reconstruct the explicit L₂ for the record (paper's appendix; `symSquare` may be
  redesigned to θ-form, or the C3 check may bypass L₂ entirely via `W=0`).

Until (a)+(b) agree, per-candidate `sym2_<candidate>` stays a named open goal.

### What the primary source establishes (Gorodetsky arXiv:2102.11839, p.1–3)

The symmetric-square structure for these sequences lives in the **θ-operator (Picard-Fuchs)
form**, θ = z d/dz:
- Order-3 (Cooper, eq. 1.7): `θ³ − z(2θ+1)(aθ²+aθ+b) + z²(c(θ+1)³ + d(θ+1))`.
- Order-2 (Zagier, eq. 1.6): `θ² − z(Aθ²+Aθ+λ) + Bz²(θ+1)²`.
- For the **d = 0** (Almkvist–Zudilin) case, the order-3 g.f. is *essentially the square* of
  the order-2 Zagier g.f., via the parameter map `(a,b,c) = (A, A−2λ, A²−4B)`.
  (Verified from the paper: Zagier F (17,72,6)→(17,5,1)=a_n; Zagier D (11,−1,3)→(11,5,125)=(η).)

### The problem

All three Cooper candidates have **d ≠ 0** (s7: d=3, s10: d=4, s18: d=−12). The clean
symmetric-square map above is the d=0 case. **Whether Cooper's d≠0 order-3 operators are
symmetric squares of order-2 operators — and how the `d` term is absorbed — is exactly what
criterion C3 asks, and this source does not resolve it.**

Two consequences for the S1-04 design:
1. `Agora/SymSquare.lean`'s `symSquare` is written in the **D = d/dt** form. It is a valid
   *general* definition (kernel-validated by golden tests), but the candidate operators
   naturally arrive in **θ-operator** form. Bridging the two needs either a variable-change
   derivation or a θ-form redesign of `symSquare` — a T0 design choice informed by (2).
2. The honest C3 check for a Cooper candidate is most likely a **parameter-map** statement
   (does (a,b,c,d) arise as the Sym² of some order-2 (A,B,λ)?), not naive operator equality.
   The d≠0 generalization of `(a,b,c)=(A,A−2λ,A²−4B)` must come from Cooper's own construction.

### Requested resolution (do NOT improvise the mathematics — CLAUDE.md)

- **T0s (Deep Think)** or a fetch of **Cooper (2012), Ramanujan J. 29, §5–7** (the geometry
  sections, refs [45][55] in Gorodetsky) to obtain: (a) the explicit order-2 L₂ for each
  Cooper candidate, or (b) the d≠0 symmetric-square correspondence, or (c) a proof that a
  given candidate is NOT a symmetric square (→ F1 for that candidate's dual-scale role).
- Until resolved, S1-04's per-candidate `sym2_<candidate>` stays a **named open goal**; do not
  assert operator equality against an unverified L₂.

### Not blocking

Sequence-level work is done: s7/s10 confirmed, s18 encoded + kernel-validated. This
escalation concerns only the operator/Sym² layer (criterion C3), which was always the
substantive mathematical content.

---

## E-005: `pipeline_upper_bound` axiom is vacuous (same mode as E-002); pre-existing build breakage found on `main`

**Filed by:** Fable 5 (T0), during WP S1-07 honesty pass  
**Date:** 2026-07-18  
**Status:** OPEN — T0 decision recorded below; discharge deferred to a dedicated WP.

### Finding 1 — vacuous axiom (F6 disclosure)

`Agora/Swampland/DualScaleStability.lean:293`:

```lean
axiom pipeline_upper_bound : ∃ (S12_max : ℝ), S12_max ≤ 1.177 ∧ S12_max > 0
```

Vacuously true (witness `1`) — identical failure mode to E-002. The docstring cites the
GPU pipeline result S₁,₂ ≤ 1.177, but the statement encodes no pipeline data. CAUTION:
the docstring was *expanded* with source metadata on 2026-07-18 (commit `9c4a6b4`) while
the statement stayed vacuous; the improved sourcing must not be mistaken for content.

**Decision (T0):** record now (AXIOMS.md tracked-gap entry added), discharge later as
proposed **WP S1-09**: encode the actual pipeline statistic (per-sector values or the
certified maximum as exact rational data, checksummed from the Stream 2/3 artifact) and
restate the bound about that data. Not folded into S1-07 to avoid improvising the
pipeline-data interface, which is a cross-stream design question (T0-owned per CLAUDE.md).
No prose may cite `pipeline_upper_bound` or downstream `perturbative_regime` results as
data-carrying until discharged.

### Finding 2 — pre-existing build failures on `main` (untouched by S1-07)

During the S1-07 build, `Agora.Geometry.DiscriminantLocus` and
`Agora.Phenomenology.ChameleonRescue` failed to compile (`⊢ False` / tactic failure) in
their HEAD state — these files do not import anything S1-07 changed. This contradicts the
"CI green on main" assumption. Being verified module-by-module; findings and disposition
recorded in the S1-07 commit and below once confirmed. If confirmed, this is an F6-relevant
event: a claimed kernel-green main that does not build.

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
