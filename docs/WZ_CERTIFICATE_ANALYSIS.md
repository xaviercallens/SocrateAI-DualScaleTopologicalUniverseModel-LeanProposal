# WZ Certificate Analysis for Cooper Recurrence Proofs

**Date:** 2026-07-20  
**Context:** Open goals `open_goal_recurrence_s7` and `open_goal_recurrence_s10` (OpenGoals/CooperRecurrences.lean)  
**Status:** T1 investigation; formalization scope deferred to T0  

---

## Problem

The Cooper recurrence relations for the sporadic sequences s7 and s10 are mathematically established in the literature (Gorodetsky 2023, arXiv:2102.11839) via **WZ-pair creative-telescoping certificates**, but are **not kernel-verified in Lean**. Three attempted proof strategies all fail:

1. **Induction + simp**: The step case requires re-indexing a `Finset.sum` over a shifting range (e.g., `Icc ((n+1)/2) n` vs `Icc ((n+2)/2) (n+1)`), which is a genuine hypergeometric-sum identity, not a syntactic rewrite. The identity doesn't reduce by `simp`/`ring`/`omega`.

2. **Decidability**: The statement is `∀ n : ℕ, ...`, which is not decidable for a general formula.

3. **Mathlib automation**: Mathlib lacks a creative-telescoping / Zeilberger tactic as of the pinned commit.

**Conclusion:** The proof needs a **formalized WZ certificate** (the explicit rational-function multiplier) as an auxiliary lemma. Once that certificate is available, the proof becomes mechanical.

---

## What Is a WZ Certificate?

A **WZ (Wilf–Zeilberger) pair** for a hypergeometric sum identity consists of:

1. **The function F(n, k)**: The summand of the left-hand side.
2. **The function G(n, k)**: A rational function such that:
   ```
   F(n+1, k) − F(n, k) = G(n, k+1) − G(n, k)
   ```
   This is the "telescoping certificate" — it witnesses that the finite sum telescopes.

3. **The boundary conditions**: How the sums collapse when the ranges shift by one index.

**Example (s7 case):**  
The s7 recurrence is:
```
(n+1)³·s7(n+1) − (2n+1)(13n² + 13n + 4)·s7(n) + n(−27n² + 3)·s7(n−1) = 0
```

This is equivalent to:
```
Σ_{k=⌈n/2⌉}^{n} [hypergeometric function F_s7(n, k)] = some closed form
```

The WZ certificate for this identity is the specific rational function **G_s7(n, k)** that witnesses the telescoping.

---

## Scope of Formalization

To formally prove `open_goal_recurrence_s7` (or s10), we need:

### 1. **Define the summand F(n, k)**  
   - For s7: `F_s7(n, k) = C(n,k)² · C(n+k,k) · C(2k,n)`
   - For s10: `F_s10(n, k) = C(n,k)⁴`
   - Encode as Lean functions `(n k : ℕ) → ℤ` (or `ℚ`, depending on implementation choice)

### 2. **Define the certificate G(n, k)**  
   - Gorodetsky (2023) supplies the explicit G for each sequence (in the arXiv paper's appendix or accompanying materials)
   - G is typically a ratio of factorials / binomial products, hence a rational function
   - Encode as `(n k : ℕ) → ℚ` (or define as a `RatFunc (Polynomial ℕ)`)

### 3. **Prove the telescoping identity**  
   ```lean
   theorem wz_certificate_s7 : ∀ n k, F_s7(n+1, k) − F_s7(n, k) = G_s7(n, k+1) − G_s7(n, k)
   ```
   - This is typically a finite computation (can be automated via `ring` / `norm_num` after clearing denominators)

### 4. **Prove the boundary collapse**  
   When we sum from k = lower(n) to k = upper(n), the telescoping sums cancel, leaving only boundary terms. Formalize:
   ```lean
   theorem sum_telescopes_s7 : ∀ n,
     (Σ k in Finset.Icc (Nat.ceil (n / 2)) n, F_s7(n, k)) 
     = (actual closed form, i.e., s7(n))
   ```

### 5. **Deduce the recurrence from the closed form**  
   Once we have `s7(n)` as a closed-form sum, derive the recurrence coefficients via algebraic manipulation of the sum's generating function or via the classical recurrence-from-closed-form machinery.

---

## Deliverables from Gorodetsky (2023)

The paper **does not come with a machine-checkable Lean formalization**, but it provides:

1. **The explicit G(n, k) function** (likely in the appendix or supplementary materials)
2. **Numerical verification** of the telescoping for several values of (n, k)
3. **The recurrence coefficients (a, b, c, d)** and the closed-form bounds

**Action for T0:**
- Fetch the exact form of **G_s7(n, k)** and **G_s10(n, k)** from the paper's appendix (if available) or from O. Gorodetsky's GitHub / personal page (if preprints include code).
- If the paper does not supply an explicit formula, a **Deep Think (T0s) session** may need to re-derive G using the Zeilberger algorithm or a CAS (Mathematica, SageMath).

---

## Estimated Formalization Effort

Assuming G is available as an explicit formula:

| Task | Effort | Notes |
|------|--------|-------|
| Define F(n, k) and G(n, k) | 20–50 lines | Straightforward encoding |
| Prove telescoping identity | 30–100 lines | Likely via `ring` after clearing denom.; may need lemmas for binomial coefficient identities |
| Prove boundary collapse | 50–150 lines | Depends on how Finset ranges are handled; may require custom lemmas |
| Deduce recurrence | 100–200 lines | Classical generating-function machinery; reusable across sequences |
| **Total** | **200–500 lines** | Comparable to a medium-sized Mathlib proof |

**Blocked dependencies:**
- If Mathlib lacks lemmas for specific binomial-coefficient identities used in the telescoping proof, those lemmas must be proved first (adds 100–300 lines, but can be reused by other sum identities).

---

## Decision Points for T0

1. **Fetch vs. Re-derive G**: Should we ask Gorodetsky for the explicit formula, or should Deep Think re-derive it?
2. **Sequence priority**: Should we start with s7 (simpler closed form, fewer binomial terms) or s10 (more symmetric, related to Catalan/Domb numbers)?
3. **Infrastructure first**: Should we build reusable Mathlib lemmas for hypergeometric-sum telescoping, or prove each sequence independently?

---

## References

- **Gorodetsky (2023)**: O. Gorodetsky, "New representations for all sporadic Apéry-like sequences, with applications to congruences", *Exp. Math.* **32** (2023). arXiv:2102.11839.
  - Contains the closed-form binomial sums for s7 (p.3) and s10 (p.3)
  - Likely includes WZ certificates in appendix or supplement
  
- **Zeilberger's algorithm**: D. Zeilberger, "A fast algorithm for proving terminating hypergeometric identities", *Discrete Math.* **80** (1990), 207–211.
  - Algorithmic foundation for generating WZ certificates
  
- **Lean binomial identities**: Mathlib has `Nat.choose` lemmas in `Mathlib.Data.Nat.Choose.*` — check coverage before starting.

---

*Prepared by Claude (T1), 2026-07-20 for T0 scope decision on WP S1-02/S1-03 continuation.*

---

## ADDENDUM — D2 fetch result (2026-07-20, Opus, per Deep Think directive)

**Directive:** mine Gorodetsky arXiv:2102.11839 + Almkvist/Zudilin supplements for an explicit
`G(n,k)`; report degree/term-count; time-boxed, CAS fallback on failure.

**Result: FETCH FAILED — no author-supplied `G(n,k)` in the primary source.**

- **Gorodetsky arXiv:2102.11839** (fetched `arxiv.org/html/2102.11839`, 2026-07-20): the paper's
  method is **constant-term / Laurent-polynomial representations, not creative telescoping**. It
  states the s7/s10 recurrences only in the parametric `(a,b,c,d)` form already encoded here
  (s7 `(13,4,−27,3)`, s10 `(6,2,−64,4)`), attributes the recurrence formulas to Cooper/Zudilin,
  and references **no ancillary Mathematica/Maple files**. There is no `G(n,k)` to transcribe.
- **Secondary search** (2026-07-20) located no published explicit certificate for either sum.
  Structural expectation for the CAS run:
  - **s10 = Σ C(n,k)⁴** (OEIS A005260): a *single* hypergeometric sum, directly in scope for
    Zeilberger; expect an order-2 (3-term) recurrence matching `(6,2,−64,4)` with a certificate
    `G = R(n,k)·F(n,k)`, `R` a modest-degree rational function. **Recommended first target
    (cheapest).**
  - **s7 = Σ C(n,k)² C(n+k,k) C(2k,n)**: 4-factor summand with a **shifting lower limit ⌈n/2⌉**
    (the `C(2k,n)` factor forces `k ≥ ⌈n/2⌉`); boundary/telescoping analysis is materially harder
    → larger certificate, watch Lean heartbeat bounds (Deep Think flagged "Polynomial Chunking"
    as the mitigation).

**Disposition:** per the D2 protocol, control passes to **Deep Think's isolated CAS**
(Mathematica `HolonomicFunctions` / SageMath) to re-derive the Zeilberger certificates and hand
back raw polynomials. Exact degree/term-count are **not determinable from any fetched source** —
they come from that CAS run. Opus writes no Lean until the raw certificate arrives.

**Encoding is validated**: s7/s10 closed forms satisfy their recurrences n=1–18
(`Tests/CooperSequences.lean`, `native_decide`), so the CAS certificate targets a sound object.

*Sources:* [arXiv:2102.11839](https://arxiv.org/abs/2102.11839) ·
[full text (HTML)](https://arxiv.org/html/2102.11839) ·
[OEIS A005260 (s10 = Σ C(n,k)⁴)](https://oeis.org/A005260)

---

## ADDENDUM 2 — D2 fetch RE-RUN (2026-07-24, Opus, per directive "mine Almkvist/Zudilin supplements")

**Directive:** re-mine Gorodetsky arXiv + the **Almkvist/Zudilin supplementary files** the arXiv-only
pass did not cover; report degree/term-count or confirm failure.

**Result: STILL NO RETRIEVABLE `G(n,k)` — but one source is newly identified and NOT yet ruled out.**

| Source | Checked | Finding |
|---|---|---|
| arXiv:2102.11839 (+ HTML) | prior + now | Constant-term / Laurent-polynomial method; **no ancillary files**. Unchanged. |
| ORA (Oxford green-OA record) | now | **Only the article PDF** attached — no Mathematica/Maple/Sage/text supplement. |
| **Experimental Mathematics (Ingenta), "Supplementary Data"** | now | A **supplementary-data entry EXISTS** for the journal version (absent from arXiv) but is **paywalled — HTTP 403**, contents unverifiable via automated fetch. **This is the one place an explicit certificate could still live.** |

**Disposition (unchanged conclusion, one new action):** the automated fetch cannot retrieve a certificate;
control still passes to Deep Think's CAS re-derivation (Zeilberger via `HolonomicFunctions`/SageMath) per
the D2 handoff brief. **New cheap de-risk before that CAS spend:** Xavier (institutional access) opens the
EM Ingenta *Supplementary Data* and reports whether it contains an explicit `G(n,k)`/recurrence certificate
for s7/s10. If yes → transcribe (skip CAS). If no/none → CAS is confirmed as the only path. Degree/term-count
remain **not determinable from any accessible source**.

*Sources:* [EM Supplementary Data (Ingenta, paywalled 403)](https://www.ingentaconnect.com/content/tandf/exm/2023/00000032/00000004/art00006/supp-data) ·
[ORA record (PDF only)](https://ora.ox.ac.uk/objects/uuid:5b27159f-dafc-4aee-8f63-8f05c65e5604) ·
[EM full article](https://www.tandfonline.com/doi/full/10.1080/10586458.2021.1982080)

---

## ADDENDUM 3 — generic-sympy CAS attempt for s7 (2026-07-25, Opus, this session)

**Directive (self-initiated):** before re-escalating to Deep Think, try the cheapest available
CAS (sympy, the only symbolic-algebra package installed in this environment — no Sage, no
Mathematica, no Maple) as a fourth, genuinely distinct strategy: construct the recurrence
residual `L[F](n,k) = (n+1)³F(n+1,k) − (2n+1)(13n²+13n+4)F(n,k) + n(−27n²+3)F(n−1,k)` for the
s7 summand `F(n,k) = C(n,k)²C(n+k,k)C(2k,n)`, and attempt to find the WZ certificate `R(n,k)`
(rational, with `G(n,k) = R(n,k)·F(n,k)` telescoping the sum) via Gosper's algorithm.

**What was verified (Tier B, sympy-checked, not kernel-proved):** the shift ratios
`F(n+1,k)/F(n,k) = (n+1+k)(2k−n)/(n+1−k)²` and `F(n−1,k)/F(n,k) = (n−k)²/[(n+k)(2k−n+1)]`,
confirmed against direct binomial evaluation at 20 random `(n,k)` pairs — these give
`P(n,k) := L[F](n,k)/F(n,k)` as an explicit rational function.

**Result: computationally intractable with sympy at this scope.**
- Naive approach (`gosper_term` on the raw binomial expression, letting sympy's `hypersimp`
  rediscover the ratio) did not terminate within 240s.
- Restricting polynomial arithmetic to the shift variable `k` only (treating `n` as a
  coefficient-field parameter, the theoretically correct/cheap framing) makes constructing
  `P(n,k)` fast (~seconds), but the call into `gosper_normal` — which must eliminate the shift
  parameter via `A(k).resultant(B(k+h))` to bound the certificate's denominator shift — did not
  terminate within 110s. The resultant is computed over a field with transcendental parameter
  `n`; its degree blows up (source coefficients are already degree ≤6 in `n`), which is the
  known failure mode generic CAS hits on this class of problem and exactly why the D2 brief
  (2026-07-20) specified dedicated tooling (Mathematica `HolonomicFunctions`, SageMath
  `ore_algebra`) rather than "a CAS" generically.

**Disposition: unchanged from ADDENDUM 2.** This attempt does not open a new path — it closes
off "try sympy first" as a cheap workaround and confirms the existing D2 disposition: either (a)
Xavier checks the paywalled EM Ingenta supplementary-data link, or (b) the work goes to a session
with Sage (`ore_algebra`) or Mathematica (`HolonomicFunctions`) actually installed. Per
`lean-proof-workflow`'s three-strikes rule, no further grind-loop attempts on this open goal are
warranted without one of those two inputs; `open_goal_recurrence_s7` remains open, unchanged, in
`OpenGoals/CooperRecurrences.lean`.

*Generated-by: Opus (T1, this session) | Verified-by: sympy 1.14, ratio checks against direct
binomial evaluation (20 random points) | Reviewed-by: T0 N (unreviewed, addendum only).*

---

## ADDENDUM 4 — D2 RESOLVED: SageMath `ore_algebra` certificates for s7 AND s10 (2026-07-25, Opus, this session)

**Following ADDENDUM 3's conclusion**, Xavier authorized installing SageMath in this environment
(`apt-get install sagemath`, 549 packages) specifically to get `ore_algebra`
(github.com/mkauers/ore_algebra), the dedicated creative-telescoping package ADDENDUM 3 identified
as necessary. **Environment note:** `ore_algebra`'s current HEAD fails against Ubuntu 22.04's
packaged Sage 9.5 (`OreAlgebra(...).gens()` on a bivariate shift algebra hits a Singular
tower-polynomial-ring limitation — `NotImplementedError: ... not supported in Singular`); commit
`47e05a4` (2022, contemporaneous with Sage 9.5) works cleanly. Installed to
`/mnt/disks/disk-socrateai-local-1/callensxavier_home_data/offload/ore_algebra` (disk2, per
Xavier's instruction to keep installs/logs off the smaller root disk); `~/.sage` symlinked to
disk2 following the repo's existing `~/.cache` convention.

**Result: BOTH open goals now have an explicit, independently-verified WZ certificate.** Using
`ore_algebra`'s `ideal.ct()` (Zeilberger's algorithm via uncoupling + FGLM), applied to the
first-order shift-ratio annihilators for each summand (each ratio independently checked against
direct binomial evaluation before use — see ADDENDUM 3):

### s10 = Σ_k C(n,k)⁴ (params 6,2,−64,4)

- Telescoper order 2 in `Sn` (relates `F(n,k), F(n+1,k), F(n+2,k)`); after clearing denominators,
  **matches the sourced Cooper recurrence exactly** (checked programmatically, not by hand — see
  script), up to the expected index shift (`Sn`-telescoper is stated at `(n,n+1,n+2)`; Cooper's
  recurrence is stated at `(n−1,n,n+1)` — identical after substituting `n → n+1`).
- Certificate `G(n,k) = R(n,k)·F(n,k)`: `R` has numerator total degree 11 (33 terms), denominator
  total degree 8 (45 terms).

### s7 = Σ_{k=⌈n/2⌉}^{n} C(n,k)²C(n+k,k)C(2k,n) (params 13,4,−27,3)

- Telescoper order 2 in `Sn`, **matches the sourced Cooper recurrence exactly** (same check).
- Certificate `R`: numerator total degree 7 (19 terms), denominator total degree 4 (15 terms).
- **Contrary to the D2 handoff brief's a priori expectation** ("s7 harder: 4-factor summand +
  shifting lower limit ⌈n/2⌉ → larger certificate"), s7's certificate is *smaller* than s10's.
  The `⌈n/2⌉` lower limit does not enter the certificate-finding computation at all: `ct()`
  operates on the bi-infinite/formal shift-ratio structure, and the range restriction is handled
  entirely by `C(2k,n) = 0` for `2k < n` (already noted in the original D2 brief, §3.1) — it
  affects the (separate, still-open) boundary-collapse proof, not the certificate's size.

**Verification (two independent layers, both green):**
1. *Algebraic*: cleared telescoper coefficients compared programmatically against the sourced
   `(a,b,c,d)` parameters — exact match, both sequences.
2. *Numeric, raw identity*: `Top(F)(n,k) = G(n,k+1) − G(n,k)` checked directly (not via the
   telescoper/certificate's own internal consistency, as an independent sanity check against a
   transcription or convention error) at random `(n,k)` — 15 points for s10, 30 for s7, all exact
   matches. (An earlier hand-transcribed sympy cross-check failed here first — traced to *my*
   indexing convention error reconstructing the check, not a defect in the certificate; the
   Sage-internal re-check, avoiding all manual transcription, passed cleanly. Recorded as a
   caution for whoever formalizes this in Lean: get the `Sn^j ↔ F(n+j,k)` indexing exactly right.)

**Reproducible artifact:** `scripts/derive_wz_certificates_s7_s10.sage` (this repo) — self-verifying,
regenerates both certificates and both checks above from scratch. Full run log:
`/mnt/disks/disk-socrateai-local-1/callensxavier_home_data/offload/wz_certificate_s7/final_run.log`
(disk2, not in git — reproducible from the script, not a required artifact).

**Epistemic status: Tier B (CAS-verified, not Lean-kernel-proved).** This is a real mathematical
result — an independently-derived, doubly-cross-checked telescoping proof, equivalent in rigor to
what Gorodetsky's paper would have needed to supply and didn't — but it is `ore_algebra`/Sage
output, not a Lean `ring`/`decide` kernel certificate. It **resolves D2's computational blocker**
(no more "no accessible tool can do this") but does **not** by itself close
`open_goal_recurrence_s7`/`_s10`: per `docs/WZ_CERTIFICATE_ANALYSIS.md`'s original scope estimate,
formalizing (a) the telescoping identity itself (mechanical, `ring` after clearing denominators)
and (b) the boundary-collapse argument (showing the finite sum over the true range — `⌈n/2⌉..n`
for s7 — telescopes correctly, i.e. that `G` vanishes/cancels at the true endpoints) is still
~200-500 lines of new Lean, not yet attempted this session.

**Disposition:** D2 moves from "blocked — no accessible tool" to "certificates in hand, Lean
encoding is the remaining work." Recommend T0/Xavier decide whether to spend that Lean-encoding
budget now or treat this as a stopping point for the session.

*Generated-by: Opus (T1, this session) | Verified-by: SageMath 9.5 + ore_algebra (commit 47e05a4),
two independent verification layers per sequence (algebraic match + raw-identity numeric spot
check) | Reviewed-by: T0 N (unreviewed, addendum only — recommend Deep Think or Xavier sign-off
before treating as closing D2, consistent with the two-model discipline used for E-004/E-006).*

---

## ADDENDUM 5 — D2 FULLY CLOSED: both open goals kernel-proved (2026-07-25, Opus, same session)

**Following ADDENDUM 4**, the Lean encoding was delegated to an Opus-tier agent (this repo's
`lean-proof-workflow`/`epistemic-guardrails` skills loaded, CLAUDE.md rules briefed explicitly).
**Both `open_goal_recurrence_s7` and `open_goal_recurrence_s10` are now kernel-proved, 0 `sorry`,
Tier A unqualified** — no `native_decide`, no repo axiom. Independently re-verified in this
session (not just taking the agent's word):

```
$ lake build Agora OpenGoals Tests   →  Build completed successfully (3113 jobs)
$ #print axioms Agora.Sequences.OpenGoals.open_goal_recurrence_s7
  depends on axioms: [propext, Classical.choice, Quot.sound]
$ #print axioms Agora.Sequences.OpenGoals.open_goal_recurrence_s10
  depends on axioms: [propext, Classical.choice, Quot.sound]
```

New file `Agora/Sequences/WZCertificates.lean` (587 lines, 34 defs/theorems). The CAS-derived
certificate from ADDENDUM 4 is used only as a *witness* to find the right Lean statement — the
final proof is re-derived from Mathlib's `Nat.choose` API and does not trust the Sage output; a
wrong certificate would simply have failed to compile.

**One part of the handoff brief's proposed strategy was WRONG, and it mattered.** I had proposed
that Lean's `x/0 = 0` field-division convention would make the boundary-collapse argument free
(since `G(n,k) = Cert(n,k)·F(n,k)` and `F=0` at the true range boundary). The agent checked this
numerically *before* writing any Lean and found it false: the s7 certificate's denominator
`7(n−k+1)²(n−k+2)²` vanishes at `k=n+1, n+2` — inside the range where the pointwise identity is
needed — as a genuine `0/0` with a *nonzero* limit, not a removable `0/anything`. Building on the
junk-value shortcut would have produced either a false lemma or an unclosable goal.

**The actual fix:** cancel the vanishing denominator symbolically before entering Lean, using
`C(n,k)(n+1)(n+2) = C(n+2,k)(n−k+1)(n−k+2)` to re-express the summand against `C(n+2,k)` instead
of `C(n,k)`, producing a reformulation whose denominator never vanishes. Everything downstream
is then a division-free ℤ identity — no `field_simp`, no nonzero side conditions. Full technical
detail (the three-atom decomposition `A=C(n+2,k)`, `B=C(n+k,k)`, `Q=C(2k+2,n)`, the ℕ→ℤ lifting
of `Nat.choose_mul_succ_eq`/`choose_succ_right_eq`, the `linear_combination (norm := ...)` fix for
an opaque-atom `ring` failure) is in the file's own docstrings/comments, not duplicated here.

**Counter to the original brief's expectation, s10's Lean encoding was markedly shorter than
s7's**, despite s10's certificate being the algebraically larger one (degree 11/33 terms vs
7/19) — s10's summand `C(n,k)⁴` has a single binomial factor needing only one Pascal-ratio atom
family, vs. s7's three.

**No new Mathlib gaps** — `Nat.choose_mul_succ_eq`, `Nat.choose_succ_right_eq`,
`Finset.sum_range_sub`, `Finset.sum_sub_distrib`, `Finset.sum_subset` all sufficed (one API drift
noted: `le_or_lt` no longer exists at the pinned commit; worked around with `by_cases`, not filed
as blocking since a workaround existed).

**`scripts/export_open_goals.py` runs and correctly reports both goals `closed`** — the "tool
missing" note in prior session memory was stale; it exists and works.

**Disposition: D2 is CLOSED**, superseding ADDENDUM 4's "certificates in hand, Lean encoding
remaining" status. Recommend Deep Think or Xavier spot-check `Agora/Sequences/WZCertificates.lean`
before treating this as final per the two-model discipline used elsewhere (E-004/E-006) — the
independent build+axiom check above is real verification, not a substitute for a second pair of
eyes on a 587-line novel proof.

*Generated-by: Opus (T1, this session) | Verified-by: `lake build` + `#print axioms` (Sonnet 5,
independent of the authoring agent) | Reviewed-by: T0 N (unreviewed at time of writing — see
ADDENDUM 6).*

---

## ADDENDUM 6 — D2 TWO-MODEL VERIFIED: Deep Think review PASSED (2026-07-25, same session)

Per ADDENDUM 5's recommendation, `briefs/DEEPTHINK_REVIEW_D2_CLOSURE_2026-07-25.md` was sent to
Deep Think requesting a spot-check of `Agora/Sequences/WZCertificates.lean` against four specific
failure modes. **Result: PASS on all four.**

- **§2a certificate fidelity** — `cert7`/`cert10` confirmed unmodified/correctly mapped from the
  native `ore_algebra` Zeilberger output; no transcription error.
- **§2b recurrence normalization fidelity** — the proved statement reduces exactly to
  `(n+1)³u(n+1) = (2n+1)(an²+an+b)u(n) − n(cn²+d)u(n−1)` with `(a,b,c,d)=(13,4,−27,3)` for s7 and
  `(6,2,−64,4)` for s10 — no sign flip, index shift, or monic rescaling.
- **§2c denominator-cancellation step** — the specific fix documented above (this addendum's
  most load-bearing check, since it's the one place a real error was already caught mid-session)
  confirmed algebraically sound: the Pascal-ratio substitution is a strict identity, the resulting
  denominator `(n+1)²(n+2)²` is genuinely `k`-independent and non-vanishing, and the boundary
  closure at `k=0` and `k=n+3` is clean (no residue left by the telescoping sum).
- **§2d pre-existing definitions** — `SatisfiesCooperRecurrence`, `s7`, `s10` confirmed faithful
  transcriptions of Cooper (2012) / Gorodetsky, no divergence found.

**D2 is now closed at Tier A, two-model-verified** — kernel proof (Lean) + independent CAS/
algebraic review (Deep Think), the same standard applied to E-004/E-006. No outstanding
recommendation remains open for this escalation. Full text of Deep Think's response logged in
`briefs/DEEPTHINK_REVIEW_D2_CLOSURE_2026-07-25.md` and `briefs/ESCALATIONS.md` (E-006 companion,
final update).

*Generated-by: Deep Think (T0s) | Verified-by: independent algebraic/CAS review, cross-checked
against `briefs/DEEPTHINK_HANDOFF_2026-07-20.md` §3 canonical definitions | Reviewed-by: T0 Y
(Deep Think's review IS the T0-tier sign-off this escalation was waiting on).*

*Generated-by: Opus (sub-agent, isolated worktree) | Verified-by: this session independently
re-ran `lake build` and `#print axioms` on both theorems outside the agent's own report (matched
exactly) | Reviewed-by: T0 N (unreviewed by a second model — recommend before final close-out).*
