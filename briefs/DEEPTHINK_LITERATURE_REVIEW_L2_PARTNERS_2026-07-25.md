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

---

# ADDENDUM 2026-07-26 — several questions have since been answered; please read before starting

Between filing and now, Stream 2 fetched two primary sources (E-007/E-009) and Stream 1 proved a
generic result. **The request is narrower than §1 states.** Retired questions below; do not spend
effort re-answering them.

## Retired — Q4 and the §6 metadata, now confirmed from primary sources

All four §6 leads were flagged "search-result summary, not a direct fetch". Three are now
**fetched and hash-pinned** (`refs/literature_provenance.txt` in the Stream 2 repo):

- **O'Brien, *"Modular forms and two new integer sequences at level 7"*, MSc thesis, Massey
  University, 2016 (supervisor S. Cooper), Theorem 6.1** — fetched (freely hosted). Its
  recurrence and all 10 printed terms match our s7 partner exactly. **The A279619 identity, the
  A002652/A279618 compositional relation, and the level-7 modular parametrisation are confirmed
  from the primary source.** Q4 is substantially answered for s7.
- **Almkvist–van Straten, arXiv:2103.08651v1**, § "three sporadic third order operators" — states
  in its own words that these are Cooper's *"s10, s7 and s18"*, and gives **explicit K3
  constructions** (s7 → six hyperplane sections of `G(2,6)`; s10 → four `(1,1)` sections in
  `P³×P³`). So the objects exist and are constructed; Q3's "is it a Picard–Fuchs operator"
  is no longer open-ended in the way §1 assumed.
- **Chan–Cooper–Sica (2010)** — still **unfetched**, not found freely hosted. Cooper 2012 and
  Stienstra–Beukers 1985 are confirmed **paywalled with no OA mirror**. If you have access,
  these three are the remaining gap.

⚠️ **Citation-precision warning — please do not inherit this.** Our own `ESCALATIONS.md` attached
*"X₀(7), CM by ℚ(√−7)"* to O'Brien Theorem 6.1. On fetching the thesis: it establishes the
generating-function identity and a level-7 parametrisation (`z₇`, `X₇` as η-quotients in `q, q⁷`),
but **never states "X₀(7)" or "CM by ℚ(√−7)"** — zero hits in the text. That framing is a standard
fact about the disc-`−7` form `x²+xy+2y²` underlying A002652, *not* something Theorem 6.1 asserts.
The citation has been rescoped to the g.f. identity only. Treat any X₀(7)/CM claim as needing its
own source.

## Retired — Q2's premise about our normalisation

Q2 asked whether the `{0, ½}` exponents are an artefact of how we recorded `L₂`. **They are not.**
`det(monodromy) = −1 ∉ SL₂(ℤ)`, so no Kodaira fibre type is derivable from `L₂`'s exponents by any
labelling — `L₂` is a *twisted* Picard–Fuchs operator (E-007, verified independently in
`checkers/check_C1_kodaira_consistency.py`). The sub-question that survives is only the
literature one: **does any source normalise these partners differently, and if so how?**

## Changed — Q1/Q3/Q5 are re-framed by a new Tier A result

Stream 1 has since proved (Lean kernel, 0 `sorry`, commit `5fad591`) that the four θ-form
identities **determine** the partner from the Cooper parameters, and that the leftover constraint
holds **identically in `(a,b,c,d)`**. Consequences for this brief:

- **Q3 is answered on the algebraic side.** *Every* operator of the Cooper template is
  `P₂·Sym²` of an explicit order-2 operator — s7 and s10 are not special in this respect. What
  remains open is entirely the geometric/modular side: is the partner a *Picard–Fuchs* operator
  of something, and of what.
- **Q1/Q5 gain a third data point.** The s18 partner is now explicit —
  `P₂ = 1−28z+192z² = (1−12z)(1−16z)`, `P₁ = −14z+192z²`, `P₀ = −3z+45z²`, singular at
  `z = 1/12, 1/16` — and its holomorphic solution is **not integral** (`1, 3, 45/2, 429/2, …`).
  **s7 is the only Cooper sporadic whose order-2 partner is integral.**

**A new question this raises (please treat as a question, not a claim).** E-007 finding 5 explains
s10's non-integrality as level-specific: *"level 10 (Γ₀(10)) lacks the cusp structure that yields
integral coefficients at level 7, forcing denominators scaling as powers of 2 (2-isogeny)"*. But
s18's partner shows the **same** 2-power denominator behaviour (every denominator a power of 2,
checked to `n = 60`; max `2⁵⁶`), and s18 is not level 10. So either that explanation generalises
beyond Γ₀(10) or it is not the operative mechanism. **Q6: what actually controls integrality of
the order-2 partner across Cooper's three sequences?** A sourced answer here would be more
valuable to us than anything else in this brief.

## Unchanged

§5 (the withdrawn Beauville/`χ_top = 12` inference) and §8 (what not to do) stand as written, and
§8's third bullet — *do not report an OEIS or paper claim without having opened it* — is if
anything reinforced: the X₀(7) rescoping above is a fourth instance of exactly that failure.

**Still genuinely open, in priority order:** Q6 (integrality mechanism) · Q1/Q4 for **s10 and s18**
partners (nothing found for either) · Q2's normalisation sub-question · Chan–Cooper–Sica 2010,
Cooper 2012, Stienstra–Beukers 1985 if you have access. **"No source found" remains a fully
acceptable answer.**

*Addendum provenance:* Generated-by: Opus 5 (Stream 1) | Verified-by: Lean kernel (`lake build
Agora`, 3108 jobs) for the generic result; Stream 2 `refs/literature_provenance.txt` +
`ESCALATIONS.md` E-007/E-009 for the fetches; `scripts/verify_sym2_partner_identities.py`
CLAIM 5/6 for the s18 partner and parameters | Reviewed-by: T0 N — pending.
