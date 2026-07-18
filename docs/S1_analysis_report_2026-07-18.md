# Stream 1 (Lean 4) — Analysis Dossier

**Program:** Dual-Scale Topological Dark Sector
**Date:** 2026-07-18 · **Branch:** `main` @ `cdfe6e3` · **Release:** v0.2 · **Stream-1 build:** green

> **Epistemic status.** Statements here describe formalization and encoding — what compiles,
> what is sourced, what was computed. The symmetric-square relation, where it holds, is a
> *geometric / arithmetic* relation **[Tier A/B]**; it implies **no** physical coupling
> (VISION §1.3). Candidate K3 identifications remain **[Tier B, unverified]**. No Tier C
> physics claim is made.

---

## 1. Summary

One session of Stream 1 work: three work packages, two primary-source fetches, three T0
decisions, and a symbolic verification that the three candidate sequences' order-3 operators
are symmetric squares. All Lean work is kernel-verified; the Stream-1 sources on `main` are
**sorry-free** (the only `sorry`s sit in the sanctioned `OpenGoals/` directory).

---

## 2. Work completed

| WP | Deliverable | Verifier | Status |
|---|---|---|---|
| S1-03 | Integrality lemmas + base cases for s7, s10 | Lean kernel (`decide`) | done |
| S1-04 API | `symSquare` design: `DiffOp2/3`, `IsSymSquareOf` | 2 first-principles golden tests | landed |
| S1-04 data | Cooper s18 encoded from primary source | Kernel recurrence check | done |
| S1-04 C3 | Symmetric-square verification (W=0) for s7, s10, s18 | Symbolic (sympy), controls pass | verified |
| hygiene | Module aggregators; `sorry` moved off `main` into `OpenGoals/` | CI no-sorry gate | done |

---

## 3. T0 decisions (delegated authority)

| ID | Decision | Rationale |
|---|---|---|
| D1 · E-001 | **Drop S22 & t103; add s18** | S22/t103 uncitable after documented search; "t103 = AESZ 103" is an order-4 CY3 operator (category error). Executed K3_CRITERIA's own drop-not-guess rule. s18 is Cooper's genuine third sequence. |
| D2 · E-002 | **Approve WP S1-07**, after S1-04 | Pre-existing `empirical_s7_degree` axioms are vacuous (`∃P, P.natDegree=3`). Vacuity disclosed now in `AXIOMS.md`; S1-07 rebuilds Theorem 1 on real operator content. |
| D3 · API | **symSquare = concrete identity** | `IsSymSquareOf` pins every L3 coefficient as a polynomial in L2's — deliberately non-vacuous (anti-E-002). Formula kernel-validated against sin/cos and exp solution spaces. |

---

## 4. Sourced parameter data

Primary source: **O. Gorodetsky, arXiv:2102.11839 v2, p.3 Cooper table** (PDF SHA256
`520da4b0…371ee1`, pinned in `refs/cooper_sequences.md`). Read directly from the PDF — not
recalled.

Recurrence convention (matches Lean `SatisfiesCooperRecurrence`):
`(n+1)³·u(n+1) = (2n+1)(a·n²+a·n+b)·u(n) − n(c·n²+d)·u(n−1)`, with `u(−1)=0, u(0)=1`.

| Sequence | a | b | c | d | Outcome |
|---|---|---|---|---|---|
| s7 | 13 | 4 | −27 | 3 | ✓ confirms existing encoding |
| s10 | 6 | 2 | −64 | 4 | ✓ confirms existing encoding |
| s18 | 14 | 6 | 192 | −12 | new — encoded from source |

**s18 encoded via recurrence + golden values, not the closed form.** A direct transcription of
the paper's s18 closed form disagreed with the recurrence at n=3 (540 vs 564) — a
signed-vs-ℕ-truncated binomial edge-case. The recurrence values are authoritative (Cooper
*defines* the sequences by the recurrence) and divided exactly at all 12 computed steps.

```
s18 = 1, 6, 54, 564, 6390, 76356, 948276, 12132504, 158984694, 2124923460
```

---

## 5. Key finding — criterion C3 (E-004 resolved, symbolic)

Source theory: **Almkvist–van Straten, *Calabi-Yau operators of degree two* (arXiv:2103.08651)**
— "degree two" = 3-term recurrence = exactly Cooper's setting. A third-order operator
`y‴ + a₂y″ + a₁y′ + a₀y` is a symmetric square of a second-order operator **iff** the
self-adjointness polynomial vanishes:

```
W = (1/3)a₂″ + (2/3)a₂a₂′ + (4/27)a₂³ + 2a₀ − (2/3)a₁a₂ − a₁′  =  0
```

**Symbolic verification** (`scripts/check_C3_symsquare.py`, exact sympy; controls pass — Apéry
a_n → W=0, generic operator → W≠0):

| candidate | (a,b,c,d) | W | verdict |
|---|---|---|---|
| s7 | (13,4,−27,3) | **0** | symmetric square → `SYM2_SYMBOLIC` |
| s10 | (6,2,−64,4) | **0** | symmetric square → `SYM2_SYMBOLIC` |
| s18 | (14,6,192,−12) | **0** | symmetric square → `SYM2_SYMBOLIC` |

**All three order-3 operators ARE symmetric squares. The d≠0 worry is fully dead.**

### The honest structural nuance

Running `W` on *symbolic* (a,b,c,d) gives `W = 0` **identically** — the symmetric-square
property is *automatic* for Cooper's operator ansatz. So C3 confirms the Sym² geometric relation
*exists* for every Cooper-form candidate but does **not discriminate** among them. Candidate
selection rests on C1 (mirror integrality), C2 (Kodaira fibers), **C3b (Shioda–Inose moduli
map)**, C4, C5 — which is exactly why C3b was added as the separate, load-bearing criterion.

An earlier "(α−1)²=−d/c perfect square" observation was **retracted**: it matched only the
x²-term and is automatically satisfiable, not the real criterion. The direct `W=0` computation
is the ground truth and was reported faithfully even though it revised the prior note.

**Tier [B, symbolic].** Verified by sympy, not a Lean kernel proof (a route-2 kernel proof would
upgrade → `SYM2_PROVED`). Two-model closure pending an independent Deep Think re-derivation.
Sym² is a geometric relation only — no physical coupling (VISION §1.3).

---

## 6. Points for adversarial review (for Deep Think)

Where a second model can most usefully attack this work:

- **Re-derive W independently.** Confirm both `W=0` per candidate *and* the stronger claim that
  `W=0` holds identically for the Cooper ansatz. Disagreement blocks the two-model sign-off
  (logged in `DERIVATION_DISPUTES.md`).
- **Operator construction.** Check the θ-form→D-form conversion and monic normalization in
  `check_C3_symsquare.py` — an error there could produce a spurious `W=0`. The Apéry positive
  control guards against this but is not a proof.
- **s18 provenance.** Independently confirm `(14,6,192,−12)` and the first terms; and whether a
  correct closed form exists (our transcription was buggy).
- **Criteria architecture.** Does "C3 is structural, not discriminating" hold up? If so, is C3b
  specified sharply enough to carry the selection weight now on it?
- **C3b itself.** The Shioda–Inose moduli map is the load-bearing criterion and is *not* yet
  verified for any candidate — the next real bottleneck.

---

## 7. Open items

| ID | Item | Next step |
|---|---|---|
| E-004 | C3 Sym² for d≠0 operators — resolved (symbolic) | Deep Think two-model concurrence; optional route-2 Lean kernel proof |
| E-002 | Vacuous Theorem-1 axioms | WP S1-07 (approved), after S1-04 |
| C3b | Shioda–Inose moduli map — unverified for all candidates | The real selection bottleneck; Stream 2 checker + T0s |
| build | Full-repo build not green | Pre-existing `Geometry/Phenomenology/DualScaleMaster` errors (S1-07/E-002) |
| — | 4 named open goals in `OpenGoals/` | Recurrence induction (s7/s10); polynomial growth bounds |

---

## 8. Artifacts & provenance

| Artifact | Path (in repo unless noted) |
|---|---|
| symSquare API | `Agora/SymSquare.lean` |
| Cooper sequences (incl. s18) | `Agora/Sequences/CooperRecurrences.lean` |
| Integrality lemmas | `Agora/Sequences/Integrality.lean` |
| Golden tests | `Tests/CooperSequences.lean` |
| Open goals | `OpenGoals/CooperRecurrences.lean` |
| C3 symbolic checker | `scripts/check_C3_symsquare.py` |
| Source reference (SHA-pinned) | `refs/cooper_sequences.md` |
| S1-04 design brief | `briefs/S1-04.md` |
| Escalations log | `briefs/ESCALATIONS.md` |
| Web dossier (private) | https://claude.ai/code/artifact/35b9f32f-50e6-48a5-8514-2f9e3fe999d8 |
| Release | GitHub tag v0.2 |

Sources fetched (PDFs bundled in `S1_analysis_bundle_2026-07-18.tar.gz`):
Gorodetsky arXiv:2102.11839; Almkvist–van Straten arXiv:2103.08651; Malik–Straub arXiv:1508.00297.

---

*Generated-by: Opus 4.8 (T0) · Verified-by: Lean kernel + sympy controls · Reviewed-by: T0 ✓ · 2026-07-18*
