# Deep Think Brief — literature review: the order-2 partners of Cooper's sporadic sequences

**From:** Opus 5
**To:** Deep Think (T0s)
**Date:** 2026-07-25
**Type:** Literature review. **Not** a derivation request, and explicitly not an invitation to
reason your way to an answer — the whole point is that we have already done more reasoning than
the evidence supports (§5).
**Blocks:** all Stream 2 geometry. `briefs/ESCALATIONS.md` E-007.

---

## 1. The question, precisely

Cooper's order-3 sporadic operators `L₃` (for `s7`, `s10`) factor as `L₃ = P₂ · Sym²(L₂)` for an
explicit order-2 operator `L₂` (§3). **What, if anything, is the geometric object attached to
`L₂`?**

Concretely:

- **Q1.** Is there literature specifically on the **order-2 partners of Cooper's order-3
  sporadic sequences** (`s7`, `s10`, `s18`)? Not Zagier's order-2 family — a different family;
  see §5.
- **Q2.** Our `L₂` has indicial exponents `{0, ½}` at each finite singular point, so its local
  monodromy is **not** unipotent and its Wronskian is irrational (`W = C/(z√P₂)`). Is that
  expected/known for these partners? Does the literature use a different normalisation in which
  the exponents come out `{0,0}`?
- **Q3.** Is `Cooper's L₃` known to be the symmetric square of a **Picard–Fuchs** operator, and
  if so, *which* operator — in what normalisation, of what family? (Gorodetsky arXiv:2102.11839
  p.2 says the order-3 Apéry case *is* "a symmetric square of a Picard–Fuchs equation", but for
  Apéry's `ζ(3)`, not for Cooper's `s7`/`s10`.)
- **Q4.** Is there a known elliptic-surface / modular realisation of A279619 (the s7 partner)?
  What is its modular parametrisation, level, and singular-fibre configuration?
- **Q5.** Same questions for the `s10` partner, which is **non-integral** (§3) — is that
  documented, and does it change the geometric picture?

---

## 2. Why this blocks

Stream 2's C1/C2 layer computed Kodaira fibre types and a "Picard lattice of the K3" **from
`L₂`**, and was retracted (E-007). Before anyone runs Tate's algorithm again we need to know
*which operator, in which normalisation, describes what surface*. Running it on the wrong object
is exactly how the first attempt produced a confident wrong answer.

---

## 3. Verified facts — please do not re-derive these

All machine-checked in this repo. Sources: `scripts/verify_sym2_partner_identities.py`,
`scripts/c1_singular_analysis.py`, `Agora/Sequences/PartnerOperators.lean` (Lean kernel).

**The operators.** `L₂ = P₂·θ² + P₁·θ + P₀`, `θ = z d/dz`:

| | `P₂` | `P₁` | `P₀` |
|---|---|---|---|
| s7 | `1 − 26z − 27z²` = `−(z+1)(27z−1)` | `−13z − 27z²` | `−2z − 6z²` |
| s10 | `1 − 12z − 64z²` = `−(4z+1)(16z−1)` | `−6z − 64z²` | `−z − 15z²` |

**Identities (kernel-proved in Lean, 0 sorry, standard axioms):**
- `θ(P₂) = 2P₁` for both.
- Cooper's `L₃` leading coefficient `c₃ = P₂` exactly, so `L₃ = P₂·Sym²(L₂)` with **no** spurious
  cofactor.
- Residuals vanish, collapsing to four division-free polynomial identities:
  `c₃ = P₂`, `c₂ = 3P₁`, `c₁ = θ(P₁) + 4P₀`, `c₀ = 2θ(P₀)`.
- Structural, for *every* parameter choice: `2c₂ = 3θ(c₃)`. So given `c₃ = P₂`, requiring the
  `θ²` residual to vanish **forces** `θ(P₂) = 2P₁`.

**Local data (exact):**
- Singular points: `z = 0`, the two roots of `P₂`, and `z = ∞` — **four**.
- `z = 0`: exponents `{0,0}` — genuine MUM point, both candidates.
- Each finite singular point: exponents `{0, ½}`.
- Wronskian `W = C/(z·√P₂)`, equivalently `Q₁ = Q₂′/2` where `Q₂ = z²P₂`, `Q₁ = z(P₂+P₁)`.

**Series.** `f(z)² = Σ s(n)zⁿ` verified to `z¹²`, `f` the holomorphic solution with `a₀ = 1`.
- s7 partner: `1, 2, 22, 336, 6006, 117348, 2428272, 52303680` — **integral**.
- s10 partner: `1, 1, 17/2, 147/2, 6363/8, 73647/8, 1812069/16` — **NOT integral**, denominators
  powers of 2 (max `2²⁶` at n=200). This is the long-flagged "A4 rational partner" caveat, now
  concrete, and the first real mathematical difference between the two candidates.

---

## 4. Already ruled out — please don't spend time here

- **Our `L₂` is not a Zagier sporadic solution.** Its recurrence isn't even in Zagier's family
  shape: `(n+1)²a_{n+1} = (26n² + 13n + 2)a_n + (27n² − 27n + 6)a_{n−1}`, whereas Zagier requires
  the `u_n` coefficient to be `An² + An + λ` (equal `n²`/`n` coefficients — ours has `26 ≠ 13`)
  and the `u_{n−1}` coefficient to be a pure `−Bn²` (ours carries `n` and constant terms). And no
  Zagier A–G matches the values.
- **Our `L₂` is not in Beukers'/Zagier's self-adjoint normal form.** That form is
  `(tP(t)F′)′ + (t−λ)F = 0`, i.e. `Q₁ = Q₂′` — verified symbolically — giving rational Wronskian
  `W = C/Q₂` and exponents `{0,0}` (unipotent, `Iₙ`, genuinely elliptic). Ours is `Q₁ = Q₂′/2`,
  exactly "half" of it.
- **Our `L₂` is not a twist of a Beukers-form operator.** A twist `y → g·y` shifts *both*
  exponents equally, so exponent *difference* is a twist invariant, and `½ ≠ 0`.

---

## 5. An error we made — please do not inherit it

Earlier today, in this same escalation, we quoted Zagier's abstract ("These solutions are related
to elliptic curves over P¹ with **four singular fibres**"), observed that our `L₂` also has four
singular points, and concluded it is a Beauville rational elliptic surface with `χ_top = 12`.

**That was withdrawn.** "These solutions" means *Zagier's seven*; ours is not among them (§4). The
shared count of four is a suggestive parallel, not a derivation. We flag this because it is the
single most tempting wrong turn in this problem, and we took it while actively writing a warning
against it.

**Please treat any parallel to Zagier's family as a hypothesis to be sourced, not an inference.**

---

## 6. Concrete leads (partly unverified — flagged)

**A279619 = the s7 partner.** Its first terms `1, 2, 22, 336, 6006, 117348, 2428272, 52303680`
match our computed partner exactly (we verified the values against our own independent
derivation). The handoff brief's long-standing `A279619` claim is therefore **confirmed**.

The following come from a **search-result summary of the OEIS page, not a direct fetch** (oeis.org
returned 403 to our fetcher) — please confirm each against the primary source:

- OEIS reportedly states the g.f. of A279619 is **the square root of the g.f. of A183204**
  (Cooper's s7). That is precisely our `f² = Σs7(n)zⁿ`, independently corroborating §3.
- Reportedly "the expansion of the g.f. of **A002652** in powers of the g.f. of **A279618**" —
  i.e. a *compositional* relation. If real, this looks like a Hauptmodul/mirror-map structure and
  may be the most direct route to the geometry. Worth chasing first.
- Reportedly `c_n` in **Theorem 6.1 of O'Brien's thesis**, and **Conjecture 5.4 of Chan, Cooper &
  Sica, "Congruences satisfied by Apéry-like numbers", Int. J. Number Theory (2010)**. These two
  are the most promising primary sources for Q1–Q4.

**Also worth checking:** Beauville, "Les familles stables de courbes elliptiques sur P¹ admettant
quatre fibres singulières" (the four-singular-fibre classification), and Beukers, "Irrationality
proofs using modular forms" (Astérisque 147–148) — but see §5 before assuming these apply.

---

## 7. What a useful answer looks like

1. A **primary-source citation** (paper, theorem/equation number) for the geometric realisation of
   the Cooper partners — or a clear statement that none exists in the accessible literature.
2. If a realisation exists: the **operator in the source's normalisation**, so we can compare it to
   ours coefficient-by-coefficient, plus its singular-fibre configuration and the Euler-number
   check (`Σ e(F_v)` = 12 or 24 or other).
3. A verdict on Q2: is `{0, ½}` the natural normalisation for these partners, or an artefact of
   how the handoff recorded `L₂`?
4. Confirmation or correction of the four A279619 metadata claims in §6.
5. **"No source found" is a fully acceptable answer** and is more useful than a plausible
   reconstruction. If the literature is silent, say so and we will treat the geometry as genuinely
   open rather than as pending discovery.

---

## 8. What not to do

- Do not derive a geometric interpretation from the algebra and present it as the answer. The
  algebra is already fully verified (§3) and it does not by itself determine the geometry.
- Do not assume the object is a K3. Stream 2's retracted work did, and `L₂` is order 2 — the K3
  direction, if any, is on the `L₃ = Sym²(L₂)` side (Gorodetsky p.2).
- Do not report an OEIS or paper claim without having opened it. That failure mode cost this
  project a full day (E-007 findings 5 and 8).

---

*Provenance:* Generated-by: Opus 5 | Verified-by: every item in §3 machine-checked (sympy exact
arithmetic + Lean kernel); §4 verified symbolically; A279619 values matched against our own
independent derivation; §6 metadata explicitly marked unverified | Reviewed-by: T0 N — this brief
is the request.
