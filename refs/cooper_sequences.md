# Reference — Cooper's sporadic sequences (s7, s10, s18)

**Primary source (fetched 2026-07-18, per anti-hallucination protocol EXECUTION_PLAN §6):**

- O. Gorodetsky, *New representations for all sporadic Apéry-like sequences, with
  applications to congruences*, Exp. Math. 32 (2023). arXiv:**2102.11839** v2 (5 Jan 2025).
  - PDF SHA256: `520da4b0171128d22971d7398f79a1aa6cd760c2412b34a78ba5120adc371ee1`
  - URL: https://arxiv.org/pdf/2102.11839
  - Data below is from the **Cooper table on p.3** (read directly from the PDF, not recalled).

- Cross-reference (secondary): A. Malik, A. Straub, *Divisibility properties of sporadic
  Apéry-like numbers*, arXiv:**1508.00297** (studies s7, s10, s18; confirms the labels).

## Recurrence convention (p.3, matches `SatisfiesCooperRecurrence` in Lean)

Cooper (2012) form:
```
(n+1)³·u_{n+1} − (2n+1)(a·n² + a·n + b)·u_n + n(c·n² + d)·u_{n−1} = 0
```
i.e. `(n+1)³·u_{n+1} = (2n+1)(a n²+a n+b)·u_n − n(c n²+d)·u_{n−1}`, with `u_{−1}=0, u_0=1`.

## Parameters (a, b, c, d) — from Gorodetsky p.3 table

| Sequence | a | b | c | d | Closed form (p.3) | Other names |
|---|---|---|---|---|---|---|
| s7  | 13 | 4 | −27 | 3 | `Σ_{k=⌈n/2⌉}^{n} C(n,k)² C(n+k,k) C(2k,n)` | — |
| s10 | 6 | 2 | −64 | 4 | `Σ_{k=0}^{n} C(n,k)⁴` | Yang–Zudilin numbers |
| s18 | 14 | 6 | 192 | −12 | `Σ_{k=0}^{⌊n/3⌋} (−1)^k C(n,k) C(2k,k) C(2n−k,n−k)·[C(2n−3k−1,n)+C(2n−3k,n)]` | — |

- **s7, s10 params CONFIRM** the pre-existing `s7_params`/`s10_params` encoding.
- **s18 params** are new (resolves the `PENDING_ENCODING` flag from E-001).

## s18 values — computed from the SOURCED recurrence (exact integer arithmetic)

`u = 1, 6, 54, 564, 6390, 76356, 948276, 12132504, 158984694, 2124923460, …`

Method: `u_1 = b = 6` (recurrence at n=0); each subsequent term from the recurrence with
(14,6,192,−12). **Every step divided exactly** (no fractions over 12 steps) — strong internal
validation, since integrality is the defining property of a sporadic sequence.

> **Closed-form caveat (honest):** a direct transcription of the p.3 s18 closed form into
> ℕ arithmetic disagreed with the recurrence at n=3 (540 vs 564) — the binomial edge-cases
> `C(2n−3k−1, n)` need the correct (signed/negative-top) convention, not ℕ-truncated
> subtraction. The **recurrence values above are authoritative** (Cooper *defines* the s_j by
> the recurrence); a verified s18 closed form is deferred follow-on work, not a blocker.

## Differential-operator / Sym² structure (p.1–3) — for criterion C3

- Cooper's order-3 operator (θ = z d/dz form, eq. 1.7):
  `(θ³ − z(2θ+1)(aθ²+aθ+b) + z²(c(θ+1)³ + d(θ+1)))·y = 0`.
- Zagier's order-2 operator (eq. 1.6): `(θ² − z(Aθ²+Aθ+λ) + Bz²(θ+1)²)·y = 0`.
- p.3: the Almkvist–Zudilin (d=0) order-3 g.f.s are **essentially squares** of the
  corresponding Zagier order-2 g.f.s, via the parameter map `(a,b,c) = (A, A−2λ, A²−4B)`.
  Verified here: Zagier F `(17,72,6) → (17,5,1)` = a_n; Zagier D `(11,−1,3) → (11,5,125)` = (η). ✓
- **Open structural question (feeds C3, flagged to T0s):** Cooper's three candidates all have
  **d ≠ 0** (s7:3, s10:4, s18:−12). The clean AZ↔Zagier symmetric-square map is the d=0 case.
  Whether Cooper's d≠0 order-3 operators are symmetric squares of order-2 operators — and in
  what generalized sense the `d` term is absorbed — is exactly criterion C3's content and is
  **not resolved by this source**. See `briefs/ESCALATIONS.md` E-004.
