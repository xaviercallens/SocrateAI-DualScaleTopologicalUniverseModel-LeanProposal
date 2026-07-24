# Handoff to Deep Think — D2 CAS Re-derivation Brief

**From:** Opus 4.8 (middle-tier executor)  
**To:** Deep Think (Gemini / T0s CAS node)  
**Date:** 2026-07-20  
**Re:** WZ-certificate re-derivation for Cooper s7 / s10 — with the **canonical repo definitions** you must certify against.

> **Why this brief exists:** you are about to spin up an isolated CAS (Mathematica `HolonomicFunctions` / SageMath) to re-derive the Zeilberger certificates `G(n,k)`. The **single largest failure mode** is deriving a certificate for a summand or recurrence normalization that differs from what the Lean kernel actually holds. §3 below pins the exact objects. Certify against **those**, not against a literature variant.

---

## 1. Decisions locked (2026-07-20 two-model consensus)

| ID | Decision | State |
|---|---|---|
| **D1** (E-006) | **Option B** — cleared-denominator polynomial identity; check `Numerator(W) ≡ 0` by `ring`. Concurrence gate: Fable outputs `P_cleared(z)`, you regenerate via CAS, Opus encodes **iff** they match. | Waiting on Fable's `P_cleared(z)`. |
| **D2** (WZ cert) | Author-fetch **FAILED** (Gorodetsky arXiv:2102.11839 gives no explicit `G(n,k)`; uses constant-term methods, cites Cooper/Zudilin, no ancillary files). **→ your CAS re-derivation.** | **This brief. Awaiting your certificates.** |
| **D3** (E-005) | **Maintain quarantine** — `pipeline_upper_bound` stays `[DISCLOSED-VACUOUS]` until Stream 2/3 emits a hashed exact-rational artifact. | Parked. |
| **D4** (C3b) | Stream 1's C3 duty **complete** (`W≡0` structural, not discriminating). Selection = Stream 2 (Shioda–Inose) + Xavier's physics eval. | Shifted to Stream 2. |
| **D5** (register) | **Register partition** (NOT a v1.0 freeze — §7 checklist still open): `TIER_A_POOL={s7,s10}`, `TIER_B_QUARANTINE={s18}` (n=3 closed-form edge). Logged K3_CRITERIA v0.1b. | Recorded. |

**Encoding is pre-validated:** s7/s10 closed forms satisfy their recurrences at every n=1–18, kernel-checked (`native_decide`, `Tests/CooperSequences.lean`). Your certificate targets a **sound** object.

---

## 2. What Opus needs back from you (certificate format)

For each of s10 (first — cheaper) and s7, hand back **raw polynomials**, not prose:

1. The **certificate** `R(n,k)` (the rational multiplier) such that, with `F(n,k)` the summand in §3,
   the creative-telescoping identity holds:
   ```
   a₂(n)·F(n+2,k) + a₁(n)·F(n+1,k) + a₀(n)·F(n,k)  =  G(n,k+1) − G(n,k),
   where G(n,k) = R(n,k)·F(n,k)
   ```
   — **or**, if you prefer the order-2/3-term shifted form, state the exact index convention you used.
2. The **recurrence operator** `(a₀, a₁, a₂)` (polynomials in `n`) your certificate proves — I will
   check it reduces to the repo normalization in §3.3. Flag any normalization change explicitly.
3. **Degree and term-count** of `R(n,k)` in each variable (drives the Lean heartbeat / chunking call).
4. The **boundary terms**: what `G(n,k)` evaluates to at the summation endpoints (the `⌈n/2⌉` lower
   limit for s7 is the delicate one — see §3.1).

Opus writes **no Lean** until your raw certificate arrives and (for D1) Fable's `P_cleared(z)` matches yours.

---

## 3. CANONICAL DEFINITIONS — certify against exactly these

These are the literal Lean encodings (`Agora/Sequences/CooperRecurrences.lean`). They are the source of truth for this program regardless of literature-variant forms.

### 3.1 Cooper s7

**Closed form (as encoded):**
```
s7(n) = Σ_{k = ⌈n/2⌉}^{n}  C(n,k)² · C(n+k, k) · C(2k, n)
```
- Summand `F_s7(n,k) = binomial(n,k)^2 * binomial(n+k,k) * binomial(2k,n)`.
- **Lower limit note (critical):** the Lean range is `Finset.Icc ((n+1)/2) n` with `(n+1)/2 = ⌈n/2⌉`
  in ℕ. This is **exactly equivalent** to summing `k = 0..n`, because `C(2k,n) = 0` whenever `2k < n`
  (i.e. `k < n/2`). So your CAS may sum over `k = 0..n` freely; just confirm the vanishing-below-⌈n/2⌉
  fact, since it governs the boundary term at the lower endpoint.
- Params `(a,b,c,d) = (13, 4, −27, 3)`; `s7(0)=1`, `s7(1)=4`.

**Golden values `s7(0..19)`** (independently computed, kernel-checked):
```
1, 4, 48, 760, 13840, 273504, 5703096, 123519792, 2751843600, 62659854400,
1451780950048, 34116354472512, 811208174862904, 19481055861877120,
471822589361293680, 11511531876280913760, 282665135367572129040,
6980148970765596060480, 173234698046183331148800, 4318681773260285456995200
```

### 3.2 Cooper s10

**Closed form (as encoded):**
```
s10(n) = Σ_{k = 0}^{n}  C(n,k)⁴
```
- Summand `F_s10(n,k) = binomial(n,k)^4`. (OEIS A005260. Single hypergeometric sum, no range subtlety.)
- Params `(a,b,c,d) = (6, 2, −64, 4)`; `s10(0)=1`, `s10(1)=2`.

**Golden values `s10(0..19)`** (independently computed, kernel-checked):
```
1, 2, 18, 164, 1810, 21252, 263844, 3395016, 44916498, 607041380,
8345319268, 116335834056, 1640651321764, 23365271704712, 335556407724360,
4854133484555664, 70666388112940818, 1034529673001901732,
15220552520052960516, 224929755893153896200
```

### 3.3 The recurrence normalization (EXACT — sign conventions matter)

Both sequences satisfy the Cooper three-term template, in **this** normalization (Lean
`SatisfiesCooperRecurrence`), for all `n ≥ 1`:

```
(n+1)³ · u(n+1)  =  (2n+1)(a·n² + a·n + b) · u(n)  −  n·(c·n² + d) · u(n−1)
```

Substituting the params gives the exact identities your certificate must certify:

- **s7:** `(n+1)³ s7(n+1) = (2n+1)(13n² + 13n + 4)·s7(n) − n(−27n² + 3)·s7(n−1)`
  &nbsp;&nbsp;[i.e. `− n(−27n²+3) = + n(27n² − 3)`]
- **s10:** `(n+1)³ s10(n+1) = (2n+1)(6n² + 6n + 2)·s10(n) − n(−64n² + 4)·s10(n−1)`
  &nbsp;&nbsp;[i.e. `− n(−64n²+4) = + n(64n² − 4)`]

If your CAS emits a recurrence in a different but equivalent normalization (e.g. monic in `u(n+1)`,
or with a different sign on the `u(n−1)` term), **say so explicitly and give the transform** — do not
silently hand back a re-normalized recurrence, as that is the exact E-04c misunderstanding this brief
exists to prevent.

---

## 4. Recommended sequencing

1. **s10 first** — single sum `Σ C(n,k)⁴`, directly Zeilberger-able; smallest certificate.
2. **s7 second** — 4-factor summand + `⌈n/2⌉` lower limit; expect a larger `R(n,k)` and a nontrivial
   lower-boundary term. If `deg/term-count` is large, propose the "Polynomial Chunking" split so the
   Lean `ring` proof stays under heartbeat.
3. Return both as raw polynomials per §2; Opus encodes into `OpenGoals → Agora` and the two open goals
   `open_goal_recurrence_s7 / _s10` close under the kernel.

**In parallel (D1):** once Fable posts `P_cleared(z)` for the generic `W`, regenerate it in your CAS;
on exact match, Opus encodes the `Numerator(W) ≡ 0` identity via `ring`.

---

*Sources for the fetch result:* [arXiv:2102.11839](https://arxiv.org/abs/2102.11839) · [full text](https://arxiv.org/html/2102.11839) · [OEIS A005260](https://oeis.org/A005260).  
*Provenance:* Generated-by: Opus 4.8 (mid-tier) | Verified-by: definitions transcribed verbatim from `Agora/Sequences/CooperRecurrences.lean`, golden values kernel-checked (`native_decide`, `Tests/CooperSequences.lean`) | Reviewed-by: T0 N (handoff, not a claim).
