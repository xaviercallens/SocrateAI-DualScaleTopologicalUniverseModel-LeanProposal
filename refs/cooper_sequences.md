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
### C3 criterion + d≠0 resolution — Almkvist–van Straten (arXiv:2103.08651)

**Second primary source (fetched 2026-07-18):** G. Almkvist, D. van Straten, *Calabi-Yau
operators of degree two*, arXiv:**2103.08651** v1 (15 Mar 2021). PDF SHA256
`549c176daa7eb5605b09a6894a8e5a9cbe94c015ef6e7dcb87650ceef4e7cfec`. "Degree two" = 3-term
recurrence = exactly Cooper's setting. Read from pages 1–8.

**The symmetric-square criterion (p.4–5), the honest computable C3 check.** A third-order
operator `y‴ + a₂y″ + a₁y′ + a₀y` is (essentially self-adjoint ⇔) a **symmetric square of a
second-order operator** iff the differential polynomial vanishes:

```
W := (1/3)a₂″ + (2/3)a₂ a₂′ + (4/27)a₂³ + 2a₀ − (2/3)a₁a₂ − a₁′  =  0
```

This replaces "guess L₂ and check equality" with a **direct, non-vacuous, per-candidate
symbolic check** on the order-3 operator's own coefficients. Recommended as the S1-04 / C3
checker basis.

**Main component (p.7) — self-adjoint order-3 degree-2 operators — INCLUDES d≠0.** The locus
of symmetric-square operators is parametrised (their notation a,b,c,d,e,f,α; note b=2(c−d)) as

```
(m):  θ³ + x(2θ+1)((c−2d)θ² + (c−2d)θ + d) + f x²(θ+α)(θ+1)(θ+2−α)
```

Matching this to Cooper's operator (Gorodetsky 1.7) `θ³ − z(2θ+1)(a_C θ²+a_C θ+b_C) +
z²(c_C(θ+1)³ + d_C(θ+1))` gives the dictionary
`a_C = c−2d`, `b_C = d`, `c_C = f`, `d_C = −f(α−1)²`, hence **(α−1)² = −d_C/c_C**.

**Necessary-condition check for our candidates (this repo, exact arithmetic):**

| cand | (a_C,b_C,c_C,d_C) | (α−1)² = −d_C/c_C | perfect square? | α |
|---|---|---|---|---|
| s7  | (13,4,−27,3)   | 1/9  | ✓ | 2/3 or 4/3 |
| s10 | (6,2,−64,4)    | 1/16 | ✓ | 3/4 or 5/4 |
| s18 | (14,6,192,−12) | 1/16 | ✓ | 3/4 or 5/4 |

α matches the known characteristic exponents at ∞. **All three satisfy the necessary
condition to lie on the symmetric-square main component — i.e. d≠0 does NOT obstruct the
Sym² structure.** This favourably addresses the E-004 worry.

> **Epistemic status [Tier B, UNVERIFIED].** The above is a *derivation in this repo* from the
> two sources' formulas, checking a *necessary* condition (−d_C/c_C a perfect square), NOT the
> full `W=0` verification and NOT kernel-checked. Per the two-model rule it must be confirmed
> by (a) a symbolic `W=0` computation per candidate, and (b) an independent Deep Think (T0s)
> re-derivation (running in parallel as of 2026-07-18). The Sym² relation, if confirmed, is a
> **geometric/arithmetic** relation only — it implies no physical coupling (VISION §1.3).
> See `briefs/ESCALATIONS.md` E-004.
