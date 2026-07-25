# Stream 1 — Lean Encoding Guide: the order-2 partner operators and `L₃ = P₂ · Sym²(L₂)`

**Date:** 2026-07-25
**Audience:** whoever writes the next Lean in `Agora/Sequences/`
**Status of the mathematics below:** every identity is machine-verified twice — exact
rational CAS (`scripts/verify_sym2_partner_identities.py`) and a compiled Lean proof.
**Status of the Lean below:** compiled against this repo's pinned toolchain, 0 errors,
axioms `[propext, Classical.choice, Quot.sound]` only. Copy-paste is safe.

---

## 0. Read this first — deviations from the commissioning spec

This guide was requested as "2–3 hours, compile existing Stream 1 handoff docs into a cohesive
guide." It is not that, because the material it asks for **is not in the repo**. Four items in
the spec needed changing, and you should know which:

| Spec said | Reality | What I did |
|---|---|---|
| "compile existing handoff docs" | `θ(P₂)=2P₁`, "magic collapse", and `D₀/D₁/D₂` appear **nowhere** in this repository | Derived them from scratch and verified them before writing a word |
| "Frobenius coefficients (D₀=D₁=D₂=0)" | "Frobenius" is a misnomer — Frobenius/indicial exponents are a *different* object (see `scripts/c1_singular_analysis.py`, they are `{0,0}` and `{0,½}` here) | Interpreted `D₂,D₁,D₀` as the **Sym² residuals**, which is the only reading that makes `=0` true. Verified. Called them "residuals" throughout |
| "references to Stream 2 certificates included" | The Stream 2 C1/C2 certificates were **retracted** on 2026-07-25 — see `briefs/ESCALATIONS.md` E-007 | **Deliberately not cited.** Nothing here depends on them. References point to re-runnable scripts instead |
| "Gate E result" | No "Gate E" exists in this repo | Ignored; flagged here |

The mathematics all checks out — better than the spec claimed, in fact (§3). But the premise
that this was a documentation-compilation task was wrong.

---

## 1. The exact polynomials

`L₂ = P₂(z)·θ² + P₁(z)·θ + P₀(z)`, with `θ = z·d/dz`. All coefficients in `ℤ[z] ⊂ ℚ[z]`.

### s7 partner

```
P₂ = 1 − 26z − 27z²        = −(z + 1)(27z − 1)
P₁ =    −13z − 27z²
P₀ =     −2z −  6z²
```

### s10 partner

```
P₂ = 1 − 12z − 64z²        = −(4z + 1)(16z − 1)
P₁ =     −6z − 64z²
P₀ =      −z − 15z²
```

**Provenance:** `briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md`, rows `s7`/`s10`. These were
labelled `[A] Certified` there, and that label **survives independent audit** — see §5.

### ⚠️ These are NOT instances of the existing `zagierThetaOperator`

`Agora/Sequences/ThetaOperators.lean` already has `zagierThetaOperator (A, lam, B)`, which
expands to `(1 − Az + Bz²)θ² + (−Az + 2Bz²)θ + (−λz + Bz²)`. Its `θ¹` coefficient equals
`θ` of its `θ²` coefficient. **Ours is half that.** Matching `θ²` forces `A = 26, B = −27` for
s7, which would give `θ¹` coefficient `−26z − 54z²`, but our `P₁` is `−13z − 27z²`. So:

> **Do not try to reuse `zagierThetaOperator`.** Write a new definition. The two templates
> coincide only when `θ(P₂) = 0`, i.e. `P₂` constant.

(Machine-checked as CLAIM 4 in `scripts/verify_sym2_partner_identities.py`.)

---

## 2. The critical identity: `θ(P₂) = 2·P₁`

```
s7 :  θ(P₂) = z·(−26 − 54z) = −26z − 54z²  =  2·(−13z − 27z²) = 2P₁   ✓
s10:  θ(P₂) = z·(−12 −128z) = −12z −128z²  =  2·( −6z − 64z²) = 2P₁   ✓
```

Both hold **exactly**, as polynomial identities in `ℚ[z]`.

### Why this is the "magic collapse" — the actual mechanism

Write `α = P₁/P₂`, `β = P₀/P₂`. From `L₂y = 0` we get `θ²y = −α·θy − β·y`. For `u = y·w` with
`y, w` both solutions, put `s₀ = yw`, `s₁ = (θy)w + y(θw)`, `s₂ = (θy)(θw)`. Then

```
θs₀ = s₁
θs₁ = −2β·s₀ − α·s₁ + 2s₂
θs₂ =          −β·s₁ − 2α·s₂
```

Eliminating `s₁, s₂` gives the monic symmetric square

```
Sym²(L₂) :  θ³ + 3α·θ² + (2α² + θα + 4β)·θ + (4αβ + 2θβ)
```

Those coefficients live in `ℚ(z)` with **`P₂²` in the denominator** — that is the "fractional
terms" problem. Now clear denominators on the residuals `D_k := c_k/c₃ − (Sym² coefficient)`:

```
P₂²·D₁ = c₁P₂ − 2P₁² − θ(P₁)P₂ + P₁·θ(P₂) − 4P₀P₂
P₂²·D₀ = c₀P₂ − 4P₁P₀ − 2θ(P₀)P₂ + 2P₀·θ(P₂)
```

Substituting `θ(P₂) = 2P₁`:

* in `D₁`, `P₁·θ(P₂) = 2P₁²` — **cancels the `−2P₁²`**;
* in `D₀`, `2P₀·θ(P₂) = 4P₀P₁` — **cancels the `−4P₁P₀`**.

Every remaining term carries a single factor of `P₂`, which divides out. So the collapse is
specifically this: **the quadratic-in-`P₁` terms annihilate, dropping the identity from a
rational-function statement needing `P₂²` to a polynomial statement in `ℚ[z]`.** No
`field_simp`, no nonvanishing side conditions, no `RatFunc` — which is exactly the trap that
E-006/E-04b cost this project a work package to avoid.

This is not a coincidence of these two candidates. In Cooper's template the `θ²` coefficient is
always `(3/2)·θ` of the `θ³` coefficient, so given `c₃ = P₂` the identity `θ(P₂) = 2P₁` is
*forced* by requiring `D₂ = 0`.

---

## 3. `L₃ = P₂ · Sym²(L₂)`, and the residuals vanish

Cooper's order-3 operator, from **Gorodetsky arXiv:2102.11839 v2 eq. (1.7)** (fetched,
SHA256-pinned in `refs/literature_provenance.txt`, identity re-checked by
`checkers/adversarial_A5_A6_provenance_hygiene.py`):

```
θ³ − z(2θ+1)(aθ² + aθ + b) + z²(c(θ+1)³ + d(θ+1))
```

Expanded into `θ`-coefficients (all `z`'s to the left; the inner factors have constant
coefficients so no commutators arise):

```
c₃ = 1 − 2a·z + c·z²
c₂ =   −3a·z + 3c·z²
c₁ = −(a+2b)·z + (3c+d)·z²
c₀ =     −b·z + (c+d)·z²
```

**Result (verified for both candidates):** `c₃ = P₂` exactly — Cooper's leading coefficient
*is* the partner's leading coefficient — and

```
D₂ = D₁ = D₀ = 0
```

so `L₃_Cooper = P₂ · Sym²(L₂)` on the nose, with no spurious factor.

### The four goals Lean should actually prove

Because `c₃ = P₂`, the whole thing collapses to four **division-free polynomial identities**:

| | identity |
|---|---|
| `D₃` | `c₃ = P₂` |
| `D₂` | `c₂ = 3·P₁` |
| `D₁` | `c₁ = θ(P₁) + 4·P₀` |
| `D₀` | `c₀ = 2·θ(P₀)` |

Each is a `ring` goal in `ℚ[z]`. That is the whole content.

**Non-vacuity control** (do not skip this reasoning — a "proof" of a trivial statement is
worthless): perturbing `P₁ → P₁ + z` breaks `D₁`, giving residual `z(81z² + 50z − 1)` for s7
and `z(192z² + 22z − 1)` for s10. The identities have real content.

---

## 4. Lean encoding — compiled, copy-paste ready

Verified against the pinned toolchain: **0 errors, 0 `sorry`**, axioms
`[propext, Classical.choice, Quot.sound]`.

Two encoding notes learned the hard way:

1. **Use plain numerals, not `C 26`.** `ring` treats `C 26` and `C 13` as *unrelated atoms* and
   cannot see that `C 26 = 2 * C 13`. Writing `26 * X` uses `Polynomial ℚ`'s own numerals,
   which `ring` computes with. The first draft of this file failed for exactly this reason.
2. For the parametrised Cooper coefficients, normalise with `norm_num [map_ofNat, map_neg]`
   before `ring` — same idiom as the existing `zagierThetaOperator_eq`.

```lean
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Tactic

namespace Agora.Sequences.Partner

open Polynomial

/-- θ acting on a coefficient polynomial: `θ(f) = z · f′`. -/
noncomputable def thetaC (f : Polynomial ℚ) : Polynomial ℚ := X * derivative f

-- ── s7 partner L₂ ────────────────────────────────────────────────────────────
-- Source: briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md, row s7.
noncomputable def s7_P2 : Polynomial ℚ := 1 - 26 * X - 27 * X ^ 2
noncomputable def s7_P1 : Polynomial ℚ := -13 * X - 27 * X ^ 2
noncomputable def s7_P0 : Polynomial ℚ := -2 * X - 6 * X ^ 2

-- ── s10 partner L₂ ───────────────────────────────────────────────────────────
-- Source: briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md, row s10.
noncomputable def s10_P2 : Polynomial ℚ := 1 - 12 * X - 64 * X ^ 2
noncomputable def s10_P1 : Polynomial ℚ := -6 * X - 64 * X ^ 2
noncomputable def s10_P0 : Polynomial ℚ := -1 * X - 15 * X ^ 2

-- ── Cooper L₃ θ-coefficients ─────────────────────────────────────────────────
-- Source: Gorodetsky, arXiv:2102.11839 v2, eq. (1.7), expanded.
noncomputable def cooper_c3 (a c : ℚ) : Polynomial ℚ := 1 - C (2*a) * X + C c * X ^ 2
noncomputable def cooper_c2 (a c : ℚ) : Polynomial ℚ := -C (3*a) * X + C (3*c) * X ^ 2
noncomputable def cooper_c1 (a b c d : ℚ) : Polynomial ℚ :=
  -C (a + 2*b) * X + C (3*c + d) * X ^ 2
noncomputable def cooper_c0 (b c d : ℚ) : Polynomial ℚ := -C b * X + C (c + d) * X ^ 2

attribute [local simp] derivative_sub derivative_add derivative_mul derivative_one

-- ── The magic collapse ───────────────────────────────────────────────────────
theorem s7_magic : thetaC s7_P2 = 2 * s7_P1 := by
  unfold thetaC s7_P2 s7_P1; simp; ring

theorem s10_magic : thetaC s10_P2 = 2 * s10_P1 := by
  unfold thetaC s10_P2 s10_P1; simp; ring

-- ── Residuals vanish: s7 ─────────────────────────────────────────────────────
theorem s7_D3 : cooper_c3 13 (-27) = s7_P2 := by
  unfold cooper_c3 s7_P2; norm_num [map_ofNat, map_neg]; ring

theorem s7_D2 : cooper_c2 13 (-27) = 3 * s7_P1 := by
  unfold cooper_c2 s7_P1; norm_num [map_ofNat, map_neg]; ring

theorem s7_D1 : cooper_c1 13 4 (-27) 3 = thetaC s7_P1 + 4 * s7_P0 := by
  unfold cooper_c1 thetaC s7_P1 s7_P0; norm_num [map_ofNat, map_neg]; ring

theorem s7_D0 : cooper_c0 4 (-27) 3 = 2 * thetaC s7_P0 := by
  unfold cooper_c0 thetaC s7_P0; norm_num [map_ofNat, map_neg]; ring

-- ── Residuals vanish: s10 ────────────────────────────────────────────────────
theorem s10_D3 : cooper_c3 6 (-64) = s10_P2 := by
  unfold cooper_c3 s10_P2; norm_num [map_ofNat, map_neg]; ring

theorem s10_D2 : cooper_c2 6 (-64) = 3 * s10_P1 := by
  unfold cooper_c2 s10_P1; norm_num [map_ofNat, map_neg]; ring

theorem s10_D1 : cooper_c1 6 2 (-64) 4 = thetaC s10_P1 + 4 * s10_P0 := by
  unfold cooper_c1 thetaC s10_P1 s10_P0; norm_num [map_ofNat, map_neg]; ring

theorem s10_D0 : cooper_c0 2 (-64) 4 = 2 * thetaC s10_P0 := by
  unfold cooper_c0 thetaC s10_P0; norm_num [map_ofNat, map_neg]; ring

end Agora.Sequences.Partner
```

### Suggested sequencing

1. Land the definitions and the eight residual lemmas above as
   `Agora/Sequences/PartnerOperators.lean`. This is the low-risk core and it already compiles.
2. Wire the Cooper coefficients to the existing `CooperRecurrenceParams` (`s7_params`,
   `s10_params`) instead of bare numerals, so the parameters have one source of truth.
3. *Optional, harder:* state `IsSymSquareOf` (`Agora/SymSquare.lean`) for these operators. Note
   that API is `DiffOp3`/`DiffOp2` in **D-form**, whereas everything here is **θ-form**. Do not
   convert to D-form casually — monic D-form normalisation is what forced `RatFunc` and blocked
   S1-08 (E-04b / E-006). The θ-form residuals above are the safe formulation. Treat the bridge
   as a T0 design question, not a refactor.

---

## 5. Golden tests — and independent confirmation the operators are right

The sharpest available check on `L₂` is at the level of series, and it is what vindicates the
handoff's `[A] Certified` label independently of anything Stream 2 produced.

Let `f = Σ aₙzⁿ` be the holomorphic solution of `L₂` with `a₀ = 1`. Since `L₃ = P₂·Sym²(L₂)`,
`f²` must be the generating function of the Cooper sequence:

```
f(z)² = Σ s(n)·zⁿ
```

**Verified to z¹² for both candidates.** A wrong `L₂` fails this immediately, so it is a strong
test, not a formality.

| | `f` coefficients | Cooper sequence |
|---|---|---|
| s7 | `1, 2, 22, 336, 6006, 117348, 2428272, 52303680` | `1, 4, 48, 760, 13840, 273504, 5703096, 123519792` |
| s10 | `1, 1, 17/2, 147/2, 6363/8, 73647/8, 1812069/16` | `1, 2, 18, 164, 1810, 21252, 263844, 3395016` |

The s7 Cooper values match the independently kernel-checked golden list in
`briefs/DEEPTHINK_HANDOFF_2026-07-20.md` §3.1.

### ⚠️ s10's partner is not integral

`f` for s10 has denominators `2, 2, 8, 8, 16, …` — **powers of 2** — while s7's is integral.
This is the first *concrete* confirmation of the long-flagged "A4 rational 2-power partner"
caveat, which until now was a suspicion. Consequences for Lean:

* `s10_P2/P1/P0` are still fine over `ℚ[z]`; the identities in §4 are unaffected.
* But **do not** state the s10 series result over `ℤ`. Any integrality lemma about the s10
  partner is false as stated.
* If a candidate-ranking criterion ever keys on partner integrality, s7 and s10 **differ**, and
  that is a real mathematical distinction rather than a bookkeeping artifact.

### Re-run everything

```bash
python3 scripts/verify_sym2_partner_identities.py   # all 4 claims, both candidates
python3 scripts/c1_singular_analysis.py             # singular points + local exponents
```

Both compute from the polynomials; nothing is hardcoded except the operator coefficients, which
CLAIM 3 then tests. Neither script has a golden test that returns `True` unconditionally — the
reason that phrasing matters is E-007.

---

## 6. Out of scope — do not derive these from anything here

Uncomputed, **not** refuted:

* Kodaira fiber types. Local exponents do not determine them; that needs the Weierstrass model
  and Tate's algorithm. The retracted `[I₁, I₁]` claim is in fact *inconsistent* with the
  computed exponents `{0, ½}` (non-unipotent monodromy).
* Any K3 surface, Picard number, Picard lattice. Note `L₂` is the Picard–Fuchs operator of an
  **elliptic curve** family; the K3 direction is `L₃ = Sym²(L₂)` (Gorodetsky p.2). Conflating
  the two was E-007 finding 6.
* Every gauge-theoretic statement (SU(5), generations, proton decay). All retracted.

---

*Generated-by: Opus 5 | Verified-by: `scripts/verify_sym2_partner_identities.py` (exact rational
CAS, 4 claims × 2 candidates, incl. non-vacuity control) and a compiled Lean proof of all ten
theorems in §4 (0 errors, standard axioms only) | Reviewed-by: T0 N — pending.*
