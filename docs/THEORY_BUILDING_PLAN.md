# Theory-Building Plan: From Scaffold to Genuine Formal String Cosmology

**Version:** 1.1 — 2026-07-16
**Program context:** This repo is **Stream 1 (Theory)** of a three-stream program —
see [`VISION.md`](../VISION.md) for the unified vision, the cross-stream data
contracts (Sequence Registry I-1, certificates I-2/I-3), hypotheses H-A/H-B/H-C,
and the two-paper publication strategy.
**Role of this document:** The operating plan for evolving the Dual-Scale Topological
Universe Model formalization from its v0.1 scaffold into a scientifically defensible,
machine-checked body of work. It is written so that individual tasks can be executed
by lower-tier LLMs (Haiku, Sonnet) under guardrails, with Fable 5 acting as scientific
partner on design-level work, and with explicit checkpoints where a human physicist
or mathematician must review or contribute.

---

## 1. Executive Summary

v0.1 compiles with 0 `sorry` and has a clean three-theorem architecture, but the
**formal content is currently much weaker than the claims made about it**. The path
forward is not "more proofs" — it is a disciplined program to make the formal
statements *mention the actual mathematical objects* (Picard-Fuchs operators, the
LVS potential with its genuine minimum, the superradiance coupling with units), to
replace numerical axioms with verified computations, and to have the physics
modelling choices validated by human experts before they are frozen into axioms.

The plan is organized as seven workstreams (WS0–WS6), ~30 tasks, each tagged with an
execution tier:

| Tier | Who | What |
|------|-----|------|
| **T-H** | Haiku | Mechanical: reference fixing, CI boilerplate, doc hygiene, axiom-inventory scripts, applying a fully specified proof recipe |
| **T-S** | Sonnet | Skilled labor: Lean proofs against a written spec, mathlib lemma hunting, `HasDerivAt` bookkeeping, Python pipeline refactors |
| **T-F** | Fable 5 | Scientific/design: new formal definitions, proof architecture, physics-to-math translation, anything that changes a theorem *statement* |
| **T-HU** | Human | Physics validity judgments, axiom sign-off, community engagement, peer review, authorship |

**Iron rule for T-H and T-S tasks:** they may *close* goals but may never add an
`axiom`, change a theorem statement, or weaken a definition. Any task that needs to
do so escalates to T-F, and any T-F change to an axiom escalates to T-HU sign-off.

---

## 2. Frank Scientific Assessment of v0.1

This assessment was produced by direct inspection of the Lean sources (not the
documentation). It is the ground truth the plan is built on.

### What v0.1 actually establishes

- A consistent Lean 4 project layout with readable, commented, `sorry`-free files.
- True (if shallow) mathematical facts: 2 ≠ 3; sums/products of positive reals are
  positive; `exp` is positive; monotonicity of the chameleon mass formula.
- An explicit, honest axiom inventory — a genuinely good practice worth keeping.

### Gap analysis

**G1 — Statements don't mention the objects (Theorem 1).**
`theorem1_holds` is `∃ d_fiber d_base : ℕ, d_fiber = 2 ∧ d_base = 3 ∧ d_fiber ≠ d_base`.
Nothing in the statement refers to the S₁,₂ sequence, the Cooper s₇ sequence, a
Picard-Fuchs operator, or a variety. The theorem is true in every possible world,
so it carries no information about the model. The `PicardFuchsODE` structure in
`FTheoryFibration.lean` is a record holding a natural number called "order" — the
ODE itself (coefficients, solutions, minimality of the order) is not formalized.

**G2 — The stability theorem does not establish a vacuum (Theorem 2).**
`V_F(τ₁, τ₂) = A·e^{-aτ₁} + B·e^{-bτ₂}` with A, B, a, b > 0 is **strictly
monotonically decreasing in both moduli**: ∂V/∂τ₁ = −Aa·e^{-aτ₁} < 0 everywhere.
There is **no critical point**; this is the textbook decompactification runaway
(Dine–Seiberg problem), the very failure mode moduli stabilization exists to solve.
The formalized facts (V > 0, diagonal Hessian entries > 0) are true but do not imply
a stable vacuum — positive-definite Hessian is only meaningful *at a critical point*.
Additionally, the "second derivatives" are *defined* as closed-form expressions,
never proven to be derivatives of `V_F` (no `HasDerivAt`/`deriv` connection). The
genuine LVS potential (Balasubramanian–Berglund–Conlon–Quevedo) has competing terms
and a real (AdS, non-supersymmetric) minimum — that is what must be formalized.

**G3 — Theorem 3 is circular.**
`theorem3 : theorem3_holds := m87_alpha_eff_certificate` — the axiom *is* the
conclusion (`∃ v, v > 0.45`). The chameleon derivation chain (density profile →
effective mass → effective coupling → comparison with the superradiance threshold)
exists only in comments. Moreover the physics inputs need expert review: the quoted
ambient density near the M87* horizon (~nuclear density) is many orders of magnitude
above realistic ADAF accretion-flow densities (~10⁻¹⁷ g/cm³ scale), and the
*direction* of the superradiance bound (safe for large α_eff) must be checked against
the literature (superradiance excludes a *window* in the mass/coupling plane; "bigger
α is safe" is not generically true).

**G4 — Numerical axioms are provable.**
`(10⁶)^{1/4} > 2.905` and `0.155·R^{1/4} > 0.42 for R ≥ 55` are theorems of real
arithmetic, provable in Lean today (`Real.rpow` lemmas + `norm_num`, or interval
arithmetic). Keeping them as axioms weakens the trust story for no reason. (Note
also: (10⁶)^{1/4} ≈ 31.6, so the stated certificate is extremely loose — the bound
that actually matters downstream should be identified and proven tightly.)

**G5 — The bibliography is unreliable.**
`docs/REFERENCES.md` cites arXiv:1806.08627 for four different papers (Palti review,
Distance Conjecture, de Sitter Conjecture, dark-energy EoS) and several other IDs
appear wrong (e.g., "Evidence for F-theory" is hep-th/9602022, not 9602062). Every
reference must be re-verified. Corrected list in §6.

**G6 — Claim–content mismatch.**
"First machine-checkable proof of internal consistency of an F-theory string
cosmology" is not supported by G1–G3. Until content exists, public-facing claims
must be scoped down to: *"a formally verified scaffold with an explicit,
machine-audited axiom inventory."* Honesty here is what will make the eventual
result credible.

**None of this is fatal.** The architecture (three layers + master conjunction +
sourced axioms) is sound. The program below fills it with real mathematics.

---

## 3. Guiding Principles

1. **Claim–content parity.** No document may claim more than
   `#print axioms dual_scale_universe_model_consistent` supports. CI enforces the
   axiom inventory (WS0.2).
2. **Axioms are generated certificates, never hand-written.** Every empirical axiom
   must be emitted by a pipeline artifact (JSON certificate → generated `.lean`
   file) with provenance in the docstring (WS5). Numerical axioms are eliminated
   entirely (WS1).
3. **Blueprint-driven development.** Adopt the
   [leanblueprint](https://github.com/PatrickMassot/leanblueprint) workflow used by
   the FLT and PFR projects: a human-readable LaTeX blueprint where every node
   (definition/lemma) links to its Lean counterpart and carries a status. The
   blueprint's dependency graph *is* the task board: Fable 5 writes nodes
   (statement + proof sketch + references), Sonnet formalizes ready nodes, Haiku
   handles leaf lemmas and maintenance. This is the single most important mechanism
   for safely delegating to lower-tier models.
4. **Physics decisions are made by humans, encoded by Fable 5, proven by anyone.**
   The tier boundary is: *choosing what to assume* is human; *choosing how to state
   it formally* is Fable-level; *discharging a stated goal* is Sonnet/Haiku-level.
5. **Upstream when general.** Definitions of independent mathematical interest
   (P-recursive sequences, elliptic fibrations, Kodaira fiber types) should target
   mathlib, with community review — this multiplies the project's scientific value.

---

## 4. Workstreams and Tasks

Task ID convention: `WSn.m`. Each task lists **Tier / Definition / Definition of
Done (DoD) / Validation / Depends on**.

### WS0 — Infrastructure & Truth-in-Claims (immediate, ~1–2 weeks)

**WS0.1 — Real Lake build with pinned mathlib + CI**
- Tier: T-S (setup), T-H (maintenance)
- Definition: Make `lake build` work from a clean clone: `lakefile.lean` requires
  mathlib pinned to a release tag, `lean-toolchain` matching, GitHub Actions using
  [leanprover/lean-action](https://github.com/leanprover/lean-action) with mathlib
  cache (`lake exe cache get`).
- DoD: CI green on a clean runner; README badge; build time < 20 min with cache.
- Validation: A fresh `git clone && lake build` by a human reproduces 0 errors.

**WS0.2 — Axiom-inventory gate**
- Tier: T-H
- Definition: A CI step running a small Lean file that does
  `#print axioms Agora.Master.dual_scale_universe_model_consistent`, diffing the
  output against a committed allowlist (`docs/AXIOM_ALLOWLIST.txt`). Any new axiom
  fails CI.
- DoD: CI fails when a test axiom is introduced on a branch; allowlist matches the
  6 current axioms.
- Validation: Deliberate red-team commit (add junk axiom) is rejected by CI.

**WS0.3 — Reference audit and repair**
- Tier: T-H (verification legwork) + T-HU (final confirmation)
- Definition: For every entry in `docs/REFERENCES.md`, resolve the arXiv/DOI link,
  confirm title/authors match, and replace wrong IDs using §6 of this plan as the
  starting point. Add missing key references (§6).
- DoD: Every link resolves to a paper whose title matches the citation text; zero
  duplicate IDs across distinct papers.
- Validation: Script (`scripts/check_references.py`) fetches each arXiv abstract and
  fuzzy-matches the title; run in CI weekly.

**WS0.4 — Scope-down public claims**
- Tier: T-F (drafting) + T-HU (approval, blocking)
- Definition: Rewrite README/MEMORY claims to match §2: "formally verified
  scaffold + audited axiom inventory," with the ambition stated as ambition.
- DoD: No public document contains "first machine-checkable proof of internal
  consistency for an F-theory string cosmology" until WS2–WS4 land.
- Validation: Human (Xavier) signs off on the wording. **Checkpoint H3.**

**WS0.5 — Adopt leanblueprint**
- Tier: T-S (tooling), T-F (initial node authoring)
- Definition: Install leanblueprint; write blueprint chapters mirroring WS1–WS4 with
  every planned definition/lemma as a node carrying `\lean{}`/`\leanok` links and a
  tier tag in a custom macro.
- DoD: `leanblueprint web` builds; dependency graph renders; every WS1–WS4 task
  below has ≥1 blueprint node.
- Validation: Graph shows no orphan nodes; each node's status matches repo reality.

### WS1 — Verified Numerics: eliminate numerical-certificate axioms (~2–3 weeks)

Resources: `Mathlib.Analysis.SpecialFunctions.Pow.Real` (`rpow` lemmas),
`norm_num`, and for harder bounds [girving/interval](https://github.com/girving/interval)
(verified interval arithmetic in Lean 4).

**WS1.1 — Prove `(10^6 : ℝ) ^ ((1:ℝ)/4) > 2.905`**
- Tier: T-S
- Definition: Replace `m87_numerical_certificate` with a theorem. Recipe:
  `(10^6)^(1/4) = 10^(3/2) = 10·√10`; `√10 > 3.16`; conclude `> 31.6 > 2.905`.
  Use `Real.rpow_natCast`, `Real.rpow_le_rpow_left_iff`, `Real.sq_sqrt`,
  `Real.lt_sqrt`, `nlinarith`.
- DoD: `axiom m87_numerical_certificate` deleted; all downstream proofs compile;
  axiom allowlist shrinks by one.
- Validation: `#print axioms` on Theorem 3 chain no longer lists it; CI green.

**WS1.2 — Prove `∀ R ≥ 55, 0.155 * R^(1/4) > 0.42`**
- Tier: T-S
- Definition: Replace `density_threshold_certificate`. Recipe: `rpow` is monotone on
  positives, so it suffices at R = 55: show `55^(1/4) > 2.71` (since 2.71⁴ = 53.94…
  < 55), then `0.155 · 2.71 = 0.42005 > 0.42`. NOTE the margin is razor-thin —
  first confirm with T-F/T-HU whether 0.155 and 0.42 are the intended constants or
  artifacts (see WS4.1); if the margin is real, use `girving/interval` for a clean
  verified evaluation instead of hand `nlinarith`.
- DoD: Axiom deleted; explicit lemma with the exact constants; margin documented.
- Validation: axiom allowlist shrinks; a comment states the numerical slack.

**WS1.3 — Derive α_eff instead of postulating it**
- Tier: T-H (after WS1.1/1.2 land, this is assembly)
- Definition: `def m87_alpha_eff : ℝ := 0.155 * (10^6 : ℝ)^((1:ℝ)/4)` already
  exists in spirit; prove `theorem3_holds` by exhibiting this value via WS1.1, and
  delete `m87_alpha_eff_certificate`.
- DoD: Theorem 3 proven from definitions + WS1 lemmas; axiom count 6 → 3.
- Validation: `#print axioms` for the master theorem lists only the 3 empirical
  axioms. **Release v0.2 gate.**

### WS2 — Real Geometry: Theorem 1 with mathematical content (~2–3 months)

The honest mathematical core: Zagier's six sporadic order-2 Apéry-like sequences
correspond to families of elliptic curves; Cooper's s₇ (and s₁₀, s₁₈) order-3
sporadic sequences correspond to K3 families. "Order 2 vs order 3" is then a real
theorem about *minimal recurrence order*, not about the naked numerals 2 and 3.

**WS2.1 — Formalize P-recursive (holonomic) sequences and minimal order**
- Tier: T-F (definitions + API design), then T-S (lemma farm)
- Definition: In `Agora/Geometry/Holonomic.lean` (target: eventually mathlib):
  `def SatisfiesPRecurrence (u : ℕ → ℚ) (cs : Fin (r+1) → Polynomial ℚ) : Prop`,
  `def PRecursiveOrder (u) : ℕ` (least r such that a nonzero recurrence of order r
  exists), plus basic API (order of a constant sequence, order is monotone under
  the natural operations needed later). Mathlib's `LinearRecurrence` covers only
  constant coefficients — polynomial coefficients are new.
- DoD: Definitions compile with ≥ 10 API lemmas, all `sorry`-free; blueprint nodes
  marked `\leanok`.
- Validation: T-F review that the definition of *minimal* order is the standard
  one (nonzero leading coefficient, not identically-zero recurrence); a toy example
  (`u n = n!`, order 1) proven as a sanity test.

**WS2.2 — Define the actual sequences**
- Tier: T-S (from a T-F-written spec)
- Definition: Define the concrete sequences — all four program sequences per
  VISION.md: **S₁₂ and S₂₁** (Order-2 candidates) and **Cooper s₇ and s₁₀**
  (Order-3 candidates). Definitions are *generated from the cross-stream Sequence
  Registry* (`data/registry/sequences.json`, VISION.md interface I-1), which pins
  each sequence's OEIS ID and exact recurrence — the memory cites A006077 for
  S₁,₂; **T-HU must confirm** this is the intended object. Reference for the
  order-3 case: Cooper's s₇ (Ramanujan J. 29 (2012) 163–183, recurrence
  `(n+1)³ s₇(n+1) = (2n+1)(11n²+11n+5) s₇(n) + 3n(9n²−1) s₇(n−1)` — verify against
  the paper in WS0.3). Prove each satisfies its stated recurrence for all n (this
  is `decide`-style polynomial identity checking on the definition, or definitional
  if defined *by* the recurrence with seed values).
- DoD: Both sequences defined; `SatisfiesPRecurrence` instances proven; first 10
  terms match OEIS values by `decide`/`norm_num`.
- Validation: Cross-check terms against OEIS raw b-files in CI (Python script).

**WS2.3 — Upper bounds on order (easy direction)**
- Tier: T-S
- Definition: From WS2.2, `PRecursiveOrder S12 ≤ 2` and `PRecursiveOrder s7 ≤ 3`.
- DoD: Both lemmas `sorry`-free.
- Validation: blueprint node closed.

**WS2.4 — Lower bounds on order (hard direction) — the real Theorem 1**
- Tier: T-F (proof strategy) + T-S (execution); T-HU math review
- Definition: Prove `PRecursiveOrder S12 = 2` and `PRecursiveOrder s7 = 3`, i.e.
  *no* order-1 (resp. ≤ 2) recurrence with polynomial coefficients of bounded
  degree exists. Strategy (T-F to finalize): an order-r recurrence with coefficient
  degree ≤ d imposes linear conditions on finitely many unknowns; exhibiting enough
  sequence terms makes the linear system overdetermined and infeasible — a finite,
  `decide`-able certificate *for each degree bound d*; the unbounded-d statement
  needs an asymptotic/growth argument (genuinely novel formalization; publishable
  on its own). An honest intermediate milestone: state the theorem with an explicit
  degree bound and label it as such.
- DoD (milestone A): order lower bound for coefficient degree ≤ 5, machine-checked.
  DoD (milestone B): unconditional minimal order, or a documented reduction to a
  clearly-stated conjecture (which then becomes an *honest* axiom with provenance).
- Validation: **Checkpoint H5** — external mathematician (Lean Zulip #maths) reviews
  the minimality argument; empirical axioms `empirical_S12_degree`/
  `empirical_s7_degree` are deleted or reduced to milestone-B residue.

**WS2.5 — Weierstrass/elliptic-curve connection via mathlib**
- Tier: T-S (mathlib has `Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass`:
  `WeierstrassCurve`, discriminant `Δ`, j-invariant)
- Definition: Replace the hand-rolled `WeierstrassModel` structure with mathlib's
  `WeierstrassCurve` over `ℚ(t)` (or `Polynomial ℚ` localized); define the model's
  fiber family; prove discriminant ≠ 0 away from an explicit finite set (the
  discriminant locus), replacing the current ad-hoc `discriminant_F`.
- DoD: `Agora/Geometry/Weierstrass.lean` builds on mathlib types; discriminant
  locus is an explicit finite set of roots with a proof.
- Validation: No duplicate Weierstrass definitions remain; T-F review of the
  translation.

**WS2.6 — Elliptic fibrations & Kodaira fiber types (long-term, upstream target)**
- Tier: T-F + T-HU (this is frontier formalization; coordinate with mathlib
  community before building)
- Definition: Minimal definitions of an elliptic fibration over a base scheme/curve
  and the Kodaira classification data needed to *state* (not prove) "s₇ is a K3
  family." Deliberately scoped: statements first, proofs later.
- DoD: Definitions accepted in principle by mathlib reviewers (RFC thread) or
  maintained here with a written upstreaming plan.
- Validation: **Checkpoint H5/H6** — community review on Zulip; this is the
  project's chief mathematical contribution and should be socialized early.

### WS3 — Real Stability: Theorem 2 with a genuine vacuum (~2–3 months, parallel to WS2)

**WS3.1 — Replace the runaway potential with the genuine LVS potential** ⚠️
- Tier: T-F (derivation) + **T-HU blocking review (Checkpoint H2)**
- Definition: Adopt the actual LVS scalar potential (Balasubramanian–Berglund–
  Conlon–Quevedo, hep-th/0502058), 1-modulus reduction first:
  `V(𝒱, τ_s) = λ √τ_s e^{−2a τ_s} / 𝒱 − μ W₀ τ_s e^{−a τ_s} / 𝒱² + ξ W₀² / 𝒱³`,
  with the known exponentially-large-volume AdS minimum. Fable 5 derives the
  precise parameter ranges and the closed-form location of the extremum to the
  extent possible; a human string theorist validates the truncation and whether
  the K3×T² dual-scale structure maps onto (𝒱, τ_s) sensibly, *before* any Lean
  code is written.
- DoD: A blueprint chapter with the exact potential, parameter hypotheses, and the
  statement "∃ (𝒱*, τ*) critical point with positive-definite Hessian," signed off
  by the human reviewer.
- Validation: Numerical cross-check in Python (`Agora/ML/`) reproducing the known
  LVS minimum for benchmark parameters (e.g. 𝒱* ~ e^{aτ*}) before formalization.

**WS3.2 — Calculus infrastructure: derivatives are theorems, not definitions**
- Tier: T-S
- Definition: For the WS3.1 potential, prove `HasDerivAt`/`HasFDerivAt` statements
  so every gradient/Hessian entry used later is *derived* (mathlib:
  `Mathlib.Analysis.Calculus.Deriv.*`, `iteratedFDeriv`). Kill the pattern of
  defining `d2V_...` by fiat (current G2).
- DoD: Each Hessian entry equals an `iteratedFDeriv`/second-`deriv` of `V` by a
  proven lemma.
- Validation: Grep gate in CI: no `def d2V` without an accompanying
  `theorem ..._eq_deriv`.

**WS3.3 — Existence of the critical point (1D first)**
- Tier: T-F (skeleton) + T-S (lemmas)
- Definition: 1D reduction: show `∂V/∂τ_s` changes sign on an explicit interval for
  stated parameter ranges (IVT: `intermediate_value_Icc`) and is continuous, hence
  a critical point exists; then `V'' > 0` there (interval-arithmetic bound or
  monotonicity argument). Then extend to the 2D `(𝒱, τ_s)` system via Sylvester
  (`Matrix.PosDef`, `Matrix.posDef_iff_...` in mathlib) at the critical point.
- DoD: `theorem lvs_vacuum_exists : ∃ x, IsLocalMin (V p) x` (or critical point +
  PosDef Hessian) for an explicit, physically motivated parameter box.
- Validation: The parameter box matches what `Optimize_Moduli.py` outputs (WS5.3);
  T-HU spot-check that the box is physical (W₀, ξ ranges from flux statistics).

**WS3.4 — Honest Swampland statement**
- Tier: T-F + T-HU (Checkpoint H2 continued)
- Definition: The current `sdc_satisfied : 1/√2 ≥ 1/√2` is vacuous. Formalize the
  Distance Conjecture as a *statement about this model*: define the moduli-space
  metric (for LVS, the Kähler metric on (𝒱, τ_s)), the geodesic distance along the
  stabilization trajectory, and the tower-mass decay rate; prove the model's λ
  satisfies the conjectured bound λ ≥ 1/√2 (or c = √(2/3) — human picks the
  convention with citation, Ooguri–Vafa hep-th/0605264, Etheredge et al.).
- DoD: SDC lemma whose statement quantifies over the model's actual metric and
  masses; convention documented with citation.
- Validation: Human string theorist confirms the statement is the SDC and not a
  tautology.

### WS4 — Real Phenomenology: Theorem 3 with a validated derivation (~1–2 months; **blocked on H1**)

**WS4.1 — Physics validation of the chameleon/superradiance chain** ⚠️ **Checkpoint H1 (blocking)**
- Tier: T-HU (lead) + T-F (literature synthesis and write-up)
- Definition: Before formalizing anything, a human phenomenologist must answer,
  with citations:
  1. What is the correct M87* superradiance exclusion for an axion of mass μ?
     (Baseline: Davoudiasl & Denton, arXiv:1904.09242: EHT M87* spin excludes
     roughly 2.9×10⁻²¹ eV ≲ μ ≲ 4.6×10⁻²¹ eV; general theory: Brito–Cardoso–Pani,
     arXiv:1501.06570; Stott & Marsh, arXiv:1805.02016.)
  2. Is "α_eff > 0.42 ⇒ safe" the right *direction*? (α = GMμ/ℏc³; large α
     suppresses superradiant growth of low harmonics but the exclusion is a window
     — this must be stated as a window, not a one-sided bound.)
  3. What is a defensible ambient density profile near M87* (ADAF/RIAF literature)
     and does a chameleon with the stated coupling actually acquire the claimed
     mass there? The current 10²⁰ g/cm³ figure appears unphysical by many orders
     of magnitude and likely invalidates the current numbers.
  4. Do self-interactions/bosenova effects (Arvanitaki–Dubovsky, arXiv:1004.3558)
     change the conclusion?
- DoD: A short (2–4 page) validated derivation note in `docs/phenomenology/`,
  every equation numbered, every constant sourced, signed off by the human expert.
  This note *is the spec* for WS4.2.
- Validation: External review (this is the natural piece to circulate to an
  astro-particle colleague; see §7 call for contributions).

**WS4.2 — Formalize the validated bound with units**
- Tier: T-F (statement design using dimensional analysis à la PhysLean) + T-S (proofs)
- Definition: Encode the WS4.1 note: define α(M, μ) with units (leverage
  [PhysLean](https://github.com/HEPLean/PhysLean)'s dimensional-analysis
  infrastructure rather than bare `ℝ`), state the exclusion window, and prove the
  model's axion parameters lie outside it (or inside the chameleon-screened safe
  region, per the note). All numerics via WS1 machinery — zero new numerical axioms.
- DoD: Theorem 3 restated so that every symbol in the statement is defined in terms
  of (M_BH, spin, μ, coupling, density profile); proof `sorry`-free.
- Validation: `#print axioms` shows only the empirical inputs (M87* mass/spin as
  *sourced observational axioms*, each citing the EHT paper in its docstring).

**WS4.3 — Robustness margins**
- Tier: T-S
- Definition: Sensitivity lemmas: by how much can M_BH (6.5 ± 0.7 ×10⁹ M_⊙) or the
  density normalization shift before the conclusion flips? Prove the conclusion for
  the whole observational error box, not the central value.
- DoD: Theorem quantified over the EHT 1σ box.
- Validation: Margin documented in README; T-HU confirms error box matches EHT.

### WS5 — ML ↔ Proof Interface: axioms as generated certificates (~1 month, parallel)

**WS5.1 — Certificate schema + Lean generation**
- Tier: T-S
- Definition: `AutoEvolve` emits `data/certificates/*.json` (sequence ID, recurrence
  coefficients, number of verified terms, pipeline version, timestamp, input-data
  hash). A generator (`scripts/gen_certificates.py`) renders these into
  `Agora/Generated/Certificates.lean` — as *definitions and decidable lemmas* where
  possible (WS2.2 route), and as clearly-marked axioms with full provenance
  docstrings only where genuinely empirical.
- DoD: No hand-written axiom remains outside `Agora/Generated/`; regeneration is
  idempotent and diffed in CI.
- Validation: Red-team: edit a JSON, regenerate, CI axiom gate (WS0.2) flags it.

**WS5.2 — Pipeline reproducibility harness**
- Tier: T-H
- Definition: Pin Python deps (`requirements.txt` → lockfile), add a smoke test that
  reruns AutoEvolve classification on the committed sequence data and diffs the
  certificates.
- DoD: `make verify-certificates` green in CI.
- Validation: Deliberate perturbation of input data changes the certificate and
  fails the diff.

**WS5.3 — Optimize_Moduli → Theorem 2 parameter box**
- Tier: T-S
- Definition: The genetic algorithm's output becomes the explicit parameter box
  used in WS3.3's hypotheses (JSON → generated Lean hypotheses), closing the loop
  "ML proposes, Lean disposes."
- DoD: WS3.3 theorem instantiated at the GA's best-fit box.
- Validation: Round-trip test in CI.

### WS6 — Community, Review, Publication (continuous)

**WS6.1 — Engage the Lean community early** — Tier: T-HU.
Post the blueprint to Lean Zulip (#maths, #general) and the PhysLean community;
WS2.1/WS2.6 definitions should be socialized *before* they harden. DoD: thread
opened, feedback triaged into blueprint issues. **Checkpoint H5.**

**WS6.2 — Upstream contributions** — Tier: T-HU + T-F.
P-recursive sequences (WS2.1) and, later, elliptic-fibration definitions (WS2.6)
as mathlib PRs; chameleon/units work as PhysLean PRs. DoD: PRs opened; review
feedback incorporated. Validation: merge or documented maintainer feedback.

**WS6.3 — Honest preprint** — Tier: T-HU (physics authorship) + T-F (drafting
formalization sections). Target: *"Machine-checked consistency arguments in string
cosmology: a case study"* — framed as methodology + the WS2.4 minimal-order result,
not as a proof of the universe. Venue: arXiv hep-th + cs.LO cross-list; consider
CICM/ITP for the formalization component and a physics journal for the
phenomenology note (WS4.1). DoD: preprint on arXiv with a tagged repo release.
**Checkpoint H6: no submission without human sign-off on every physics claim.**

**WS6.4 — Call for scientific contribution** — Tier: T-HU, drafted by T-F.
Publish `docs/CALL_FOR_CONTRIBUTIONS.md` + GitHub issues labeled by tier
(`good-first-issue` = T-H tasks, which are equally good first issues for human
newcomers). Specific asks: (a) a string phenomenologist for H1/H2 review,
(b) a number theorist for WS2.4 minimality, (c) Lean/mathlib contributors for
WS2.1/WS2.6, (d) an EHT-literate astrophysicist for the density profile in WS4.1.
Channels: Lean Zulip, PhysLean, string_data community, arXiv preprint's
"code available" note.

---

## 5. Delegation Protocol for Haiku / Sonnet

Every delegated task ships as a self-contained brief:

```
TASK: <ID + title>                     TIER: T-H | T-S
CONTEXT FILES: <≤3 files to read; never "explore the repo">
GOAL: <exact Lean statement(s) to prove / exact artifact to produce>
RECIPE: <for T-H: full step list. For T-S: strategy + candidate mathlib lemmas>
GUARDRAILS:
  - MUST NOT add `axiom`, `sorry`, or modify any `def`/`theorem` statement
  - MUST NOT touch files outside <list>
  - On failure after N attempts: STOP and report the exact failing goal state
DoD: <from this plan>
VALIDATION: lake build && axiom-gate && <task-specific check>
```

Additional rules:
- **Lemma discovery:** T-S agents should use [Loogle](https://loogle.lean-lang.org),
  [LeanSearch](https://leansearch.net), and `exact?`/`apply?` rather than guessing
  mathlib names (hallucinated lemma names are the dominant low-tier failure mode).
- **Escalation path:** T-H → T-S → T-F → T-HU. An escalation must carry the exact
  Lean goal state, not a paraphrase.
- **Fable 5's standing role:** author blueprint nodes, review every merged T-S proof
  for *statement drift* (the proof may be valid while the statement quietly became
  vacuous — exactly the v0.1 failure mode), and maintain this plan.
- **CI is the arbiter:** no delegated work is "done" until WS0.1 build + WS0.2 axiom
  gate + task-specific validation all pass. Low-tier agents never self-certify.

---

## 6. Literature & Resources (verified starting set)

*All IDs below should still be link-checked in WS0.3; they replace the current
`REFERENCES.md` where they conflict.*

**F-theory / compactification**
- Vafa, *Evidence for F-theory*, hep-th/9602022
- Morrison & Vafa, *Compactifications of F-theory on Calabi–Yau threefolds I/II*, hep-th/9602114, hep-th/9603161
- Weigand, *TASI lectures on F-theory*, arXiv:1806.01854
- Denef, *Les Houches lectures on constructing string vacua*, arXiv:0803.1194

**Moduli stabilization**
- Kachru, Kallosh, Linde, Trivedi (KKLT), hep-th/0301240
- Balasubramanian, Berglund, Conlon, Quevedo (LVS), hep-th/0502058
- Conlon, Quevedo, Suruliz, hep-th/0505076

**Swampland**
- Ooguri & Vafa, *On the geometry of the string landscape and the swampland*, hep-th/0605264
- Obied, Ooguri, Spodyneiko, Vafa (de Sitter conjecture), arXiv:1806.08362
- Palti, *The Swampland: Introduction and Review*, arXiv:1903.06239

**Sporadic sequences / Picard-Fuchs (mathematical core of WS2)**
- Zagier, *Integral solutions of Apéry-like recurrence equations* (CRM Proc. 47, 2009)
- Cooper, *Sporadic sequences, modular forms and new series for 1/π*, Ramanujan J. 29 (2012)
- OEIS: A006077 and the b-files for the chosen sequences (CI cross-check, WS2.2)

**Superradiance / chameleon (WS4 spec inputs)**
- Brito, Cardoso, Pani, *Superradiance* (review), arXiv:1501.06570
- Arvanitaki & Dubovsky, arXiv:1004.3558; string axiverse arXiv:0905.4720
- Davoudiasl & Denton, *Ultralight boson DM and EHT observations of M87**, arXiv:1904.09242
- Stott & Marsh, arXiv:1805.02016
- Khoury & Weltman, *Chameleon fields*, astro-ph/0309300 (PRL), astro-ph/0309411 (PRD)
- EHT Collaboration, *First M87 EHT Results I–VI*, arXiv:1906.11238 ff.

**Lean 4 ecosystem to leverage**
- [mathlib4](https://github.com/leanprover-community/mathlib4) — `WeierstrassCurve`
  + discriminant/j-invariant, `Matrix.PosDef`, `intermediate_value_Icc`,
  `HasDerivAt`, `Real.rpow` API, `LinearRecurrence` (constant-coefficient only)
- [PhysLean](https://github.com/HEPLean/PhysLean) (Tooby-Smith, arXiv:2405.08863) —
  the most mature physics-in-Lean effort; units/dimensional analysis, field theory;
  natural home for WS4 upstreaming. Likely supersedes the Lean4PHYS submodule.
- [girving/interval](https://github.com/girving/interval) — verified interval
  arithmetic (WS1, WS3.3 numeric bounds)
- [SciLean](https://github.com/lecopivo/SciLean) — scientific computing / symbolic
  differentiation patterns (WS3.2 inspiration)
- [leanblueprint](https://github.com/PatrickMassot/leanblueprint) — project
  coordination (WS0.5); study [FLT](https://github.com/ImperialCollegeLondon/FLT)
  and PFR as exemplars of blueprint-driven multi-contributor formalization
- [leanprover/lean-action](https://github.com/leanprover/lean-action) — CI (WS0.1)
- [Loogle](https://loogle.lean-lang.org) / [LeanSearch](https://leansearch.net) —
  lemma discovery for delegated agents (§5)

**String-landscape ML**
- [ml-string-landscape](https://github.com/AndreasSchachner/ml-string-landscape) (already vendored)
- [CYTools](https://github.com/LiamMcAllisterGroup/cytools) + Kreuzer–Skarke
  database — if/when the model is embedded in an explicit Calabi–Yau (post-WS3)

---

## 7. Human Review & Contribution Checkpoints

| ID | What | Who | Blocks | When |
|----|------|-----|--------|------|
| **H1** | Superradiance direction + density profile + chameleon viability at M87* (WS4.1) | External astro-particle phenomenologist | All of WS4 | Before any Theorem-3 formalization |
| **H1-b** | Δ_obs → 7-brane bridge derivation note (VISION.md hypothesis H-C): signal shape, amplitude, trials-corrected significance | Cosmologist / survey statistician | Any public claim linking K3-DISC detections to the discriminant locus | Before Stream-3 results are cited by this repo |
| **H2** | LVS potential adoption, truncation validity, SDC convention (WS3.1, WS3.4) | String theorist (external or Xavier + advisor) | WS3.3+ | Before Lean code for Theorem 2 v2 |
| **H3** | Public claim language (WS0.4) | Xavier | Any publicity/release notes | Immediately |
| **H4** | Axiom sign-off: every release, walk the allowlist; every axiom has provenance | Xavier | Each tagged release | Recurring |
| **H5** | Mathematical review of minimal-order argument (WS2.4) + mathlib RFCs (WS2.6) | Lean Zulip / mathlib community + a number theorist | WS2 milestone B | When milestone A lands |
| **H6** | Preprint sign-off — every physics sentence human-approved | Xavier + coauthors | WS6.3 submission | Pre-submission |

**Call for contribution (to publish as WS6.4):** the project seeks (1) a string
phenomenologist to audit the M87* chain, (2) a number theorist for recurrence-order
minimality, (3) mathlib contributors for P-recursive sequences and elliptic
fibrations, (4) any newcomer for tier-H issues. Credit policy: contributors at
checkpoints H1/H2/H5 are offered coauthorship on the corresponding paper.

---

## 8. Milestones & Release Gates

| Release | Content | Gate |
|---------|---------|------|
| **v0.2** (~3 wks) | WS0 complete; numerical axioms eliminated (WS1); claims scoped down | CI green; axiom count 6→3; H3 signed |
| **v0.3** (~2 mo) | Real LVS potential with proven critical point + PosDef Hessian (WS3.1–3.3); derivatives as theorems | H2 signed; WS5.3 loop closed |
| **v0.4** (~3 mo) | P-recursive framework + minimal-order milestone A (WS2.1–2.4A); mathlib Weierstrass migration (WS2.5) | H5 review opened; empirical axioms regenerated as certificates (WS5.1) |
| **v0.5** (~4 mo) | Validated phenomenology note + formalized Theorem 3 v2 with units and error box (WS4) | H1 signed; only sourced observational axioms remain |
| **v1.0** | Master theorem restated over the *real* definitions; blueprint complete; preprint (WS6.3) | H4 + H6 signed; `#print axioms` lists only observational inputs, each with provenance |

## 9. Risk Register

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| WS4.1 review invalidates the chameleon rescue (density figure looks unphysical) | **High** | That is the point of H1. Fallback: restate Theorem 3 as the Davoudiasl–Denton mass-window exclusion, and show the model's axion mass lies outside the excluded window — a weaker but honest and formalizable claim. |
| WS2.4 milestone B (unconditional minimality) too hard | Medium | Milestone A (bounded coefficient degree) is already a meaningful, publishable formal result; residual becomes a clearly labeled conjecture. |
| Mathlib API churn breaks the build | Medium | Pin releases (WS0.1); quarterly bump task (T-H). |
| Low-tier agents introduce vacuous statements | Medium | §5 guardrails: statements are frozen by T-F; agents only close goals; Fable 5 reviews for statement drift. |
| Community pushback on physics framing | Medium | WS0.4 claim discipline + early engagement (WS6.1) — lead with the formalization methodology, not cosmological claims. |

---

*Maintained by: Fable 5 (scientific partner) under Xavier Callens' direction.
Amendments to this plan are T-F changes requiring an H4-style sign-off note in the
update log below.*

**Update log**
- 2026-07-16 — v1.0 of the plan created from a direct audit of the v0.1 Lean sources.
- 2026-07-16 — v1.1: linked to VISION.md (three-stream program); WS2.2 extended to
  all four registry sequences (S₁₂, S₂₁, s₇, s₁₀) sourced from interface I-1;
  added checkpoint H1-b (Δ_obs → 7-brane bridge review).
