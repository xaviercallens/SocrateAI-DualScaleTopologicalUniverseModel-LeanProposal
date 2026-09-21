# Stream 1 — Theory: Lean 4 Formalization

**Dual-Scale Topological Universe Model: Arithmetic & Formal Verification**

This is **Stream 1** of the Dual-Scale Topological Universe Model project. Its role is to **machine-certify the mathematical claims** (Tier A) and formalize the conjectures (Tier B) in Lean 4.

**See [VISION.md](VISION.md) for the full project scope, roadmap, and epistemic framework.**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22853238.svg)](https://doi.org/10.5281/zenodo.22853238)

**Paper:** *A kernel-checked symmetric-square structure theorem for Cooper's sporadic Apéry-like
operators, and the monodromy lattice of the s₇ family* — **48 pp.**

📄 **[Download the PDF](https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal/releases/latest/download/dual-scale-stream1-paper.pdf)**
(attached to every release from `v0.13` onward), or build it from the full LaTeX sources in
[`paper/`](paper/) with `pdflatex main.tex` — **not** `lualatex`/`xelatex`, whose font stack is
broken in this environment.

- **Cite this DOI** — [10.5281/zenodo.22853238](https://doi.org/10.5281/zenodo.22853238) — it is the
  *concept* DOI and always resolves to the latest archived version.
- Current version **v3**: [10.5281/zenodo.22875834](https://doi.org/10.5281/zenodo.22875834),
  deposited 2026-09-21 from release
  [`v0.14-paper-published`](https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal/releases/tag/v0.14-paper-published).
  It carries the 48 pp. PDF, the complete LaTeX sources, and a tarball of the Lean 4 development.
  New since v2: the rank-22 embedding assembly, `sym2_is_substitution`, the Gorodetsky (1.7)
  encoding check, the quarantine of the legacy physics modules, and §9.7 of the manuscript.
- v2 was [10.5281/zenodo.22864700](https://doi.org/10.5281/zenodo.22864700) (release
  `v0.10-two-lattices`) and v1 was [10.5281/zenodo.22853239](https://doi.org/10.5281/zenodo.22853239)
  (release `v0.8`); both are superseded, both remain citable, neither is withdrawn.

---

## What This Repository Does

- **Formalizes Cooper sequences** as holonomic Picard-Fuchs ODEs.
- **Proves arithmetic properties**: order-3 operator = symmetric square of order-2, congruence relations, integrality of mirror maps.
- **Bridges to K3 geometry** via clearly-marked axiomatized conjectures, so proof obligations are machine-readable.
- **Targets Mathlib contribution**: full algebraic-geometric machinery (K3 surfaces, Kodaira classification) is a 12–24 month horizon.

This repository is **not** responsible for:
- Ranking K3 candidates (→ Stream 2, `SocrateAI-Scientific-Agora-K3-DarkMatter`)
- Testing predictions against data (→ Stream 3, `SocrateAI-Scientific-Agora-Home`)

---

## Results at a glance

Everything in this table is kernel-checked with Lean's three standard axioms only
(`propext`, `Classical.choice`, `Quot.sound`) — no `sorry`, no `native_decide`, no literature
axiom. Names are Lean declarations; grep for them.

| Result | Lean name | File |
|---|---|---|
| `L₃ = P₂·Sym²(L₂)` — four coefficient identities, uniform in `(a,b,c,d)` | `partner_res0..3`, `partner_magic` | `Sequences/PartnerOperators.lean` |
| Almkvist–van Straten criterion `W ≡ 0`, identically on the template | `P_cleared_eq_zero` | `Swampland/SymSquareC3b.lean` |
| **Sequence-level Sym²**: partner = formal √ of the bulk series, whole template | `partner_eq_sqrt` | `Sequences/SqrtBridgeGeneric.lean` |
| — instances s₇ and s₁₀; s₁₀'s partner dyadic (was PASS(59)) | `partner_eq_sqrt_s10`, `s10_partner_dyadic` | `"` |
| **`4 ∣ s₇(n)`** for `n ≥ 1`, termwise and elementary | `four_dvd_s7` | `Sequences/S7Mod4.lean` |
| — hence s₇ partner integral **with no literature axiom** | `s7_partner_integral_axiom_free` | `"` |
| s₁₀, s₁₈ partners **not** integral (single witnesses) | `s10_partner_not_integral` | `Sequences/PartnerIntegrality.lean` |
| `Γ₀(N)⁺ ⊂ O(U⊕⟨2N⟩)` by explicit integer 3×3 ρ; ρ is a homomorphism | `rho_isometry`, `rho_mul` | `Geometry/ModularAction.lean` |
| — automorphy `(Ncτ+d)²` as a **polynomial identity**, no hypotheses | `rho_mulVec_period` | `"` |
| — ρ is the symmetric square, and lands in `SO(2,1)` | `rho_trace`, `rho_det` | `"` |
| Gauss form: `sym2(M)ᵀG₀sym2(M) = (det M)²G₀`; `sym2` is **contravariant** | `sym2_isometry_general`, `sym2_contravariant` | `Geometry/SymSquareForms.lean` |
| The discriminant lattice and `U⊕⟨2N⟩` are **not isometric** | `no_isometry_G0N_TN` | `"` |
| Signature of `U⊕⟨2N⟩` is `(2,1)`, by explicit diagonalization | `TN_diagonalises` | `Geometry/MnLattice.lean` |
| Both singular points `{−1, 1/27}` are walls of `(−2)`-roots | `s7_P2_discriminant`, `W7conj_eq_neg_reflection` | `Geometry/SelfDual.lean`, `ModularAction.lean` |
| Embedding witness `B`, `C`, orthogonality, index 14 (**not** primitivity — see below) | `B_pullback`, `B_orthogonal_C` | `Geometry/Embedding.lean` |
| `ρ_AL` on the discriminant group `ℤ/2N`: multiplier `m = 2Nad − 1`, so `2N ∣ m+1` (Fricke coset only) | `rhoAL_w_image`, `rhoAL_disc_multiplier_congr` | `Geometry/ModularAction.lean` |
| A Möbius fixed point satisfies an integer quadratic; the three s₇ stabilizers, orders 2, 2, 3 | `fixed_point_integer_quadratic`, `s7_stab_c_cube` | `"` |
| **Occurrence criterion, arithmetic half:** `D − m² = 4N·x′y′` exactly — **no primitivity needed** | `occurrence_identity`, `occurrence_congruence` | `Geometry/Occurrence.lean` |
| — `−3` is not a square mod 40 (arithmetic obstruction to `A₂` at level 10; the determinant formula is a *hypothesis*) | `A2_not_in_s10_family` | `"` |
| Orthogonal-join of two embeddings, **generic** (any ring, any index types) | `join_pullback` | `Geometry/EmbeddingAssembly.lean` |
| — hence `prop:g0complement` over the whole rank-22 `Λ = U³ ⊕ E₈(−1)²` | `assembly` | `"` |
| — discriminant of the pullback is `−14²`, matching `\|disc T₇\| = 14` | `assembly_det` | `"` |

---

## What you may cite, and what you may not

This project's credibility rests on the distinction. Tiers are defined in [VISION.md](VISION.md) §2.

**You may state as fact (Tier A).** Everything in the table above. These are theorems about
sequences, polynomials, rational maps and integer matrices.

**You must hedge (Tier B).** That `U⊕⟨14⟩` *is* the transcendental lattice of the s₇ K3 family,
and ρ = 19 / T = 3 for `cooper_s7`. These rest on a numerical monodromy computation (Stream 2,
E-011), not on the kernel.

**Exact computation, not kernel-checked (E).** That the Hauptmodul `h = (η(7τ)/η(τ))⁴` with
`z = h/(1+13h+49h²)` parametrizes the s₇ family — verified as an exact `q`-series identity to
`O(q⁴⁰)`, with a negative control, by `scripts/check_selfdual_points_s7.py`.

**Blocked, program-wide (Tier C).** No exact physical observable exists anywhere in this program
(F5b). The Sym² relation supplies **no physical coupling** (VISION §1.3). In particular the
coincidence that one integer matrix is both the Fricke involution and the Narain T-duality
generator is a fact about a lattice isometry and **not** a physical identification. Stream 3
independently found that T-duality is homologically invisible, which is consistent.

**Retracted — never cite.** ρ = 4 / T = 18; any Kodaira reading of the L₂/L₃ exponents; and
everything in the two correction notices below.

---

## Verify it yourself

Do not trust the numbers in this file; regenerate them.

```bash
lake exe cache get
bash scripts/release_gates.sh      # ← the checklist. Reads exit codes correctly.
```

It runs the audit tools' self-tests first, then the build, the `sorry` check, the axiom audit and
the statement lock — each **unpiped**, because a pipe hands you the filter's exit code and not the
tool's (`lake build NoSuchTarget | grep "Build completed"` exits **0** while lake exits 1).

Three things about these gates, each mutation-verified and recorded in [`LL.md`](LL.md) §3:

- ⚠️ **A `sorry` does NOT fail the build.** Appending one gives exit 0 and only
  `warning: declaration uses` + backtick + `sorry` — and note the *backticks*, so a
  straight-quote grep finds nothing. The real `sorry` gate is the axiom audit, via `sorryAx`.
- ⚠️ **`axiom_audit.py` exits 1 permanently here.** It fails on any registered axiom and the
  steady state is **3** — the two disclosed axioms of [`AXIOMS.md`](AXIOMS.md), neither
  load-bearing. Compare the count against 3, never against 0, and read *which* theorems fail.
- ⚠️ **There is no CI** (CLAUDE.md rule 3). This script, run by a human, is the gate.

```bash
# the individual tools, if you want them separately
python3 scripts/export_open_goals.py                   # all five goals report closed
python3 scripts/check_selfdual_points_s7.py            # PASS(40) + negative control
python3 scripts/name_vs_statement.py --self-test       # must pass before the tool is believed
LM=~/SocrateAI-Scientific-Agora-LeanMaster
LEAN_PROJECT_ROOT=$PWD python3 $LM/tools/axiom_audit.py Agora
LEAN_PROJECT_ROOT=$PWD python3 $LM/tools/statement_lock.py --check $(find Agora OpenGoals Tests -name '*.lean')
```

⚠️ **A vacuous theorem would pass every one of those gates.** It compiles, evades the `sorry`
grep, reports the three standard axioms and locks cleanly. This repository has shipped vacuous
theorems twice (E-002/E-005, and the two relabelled `⚠️ VACUOUS` below). Only reading the
*statement* catches it. Where a statement could be satisfied trivially, this repo now carries an
explicit non-vacuity control — e.g. `sqrtSeq_even_needs_hypothesis`, `rho_not_isometry_of_det_two`,
`B_six_not_T7`, `sym2_not_covariant`, `TN_diagonalises_sign`, `dyadic_baseline_control`.

---

## Toolchain (pinned)

| | Value |
|---|---|
| Lean | `leanprover/lean4:v4.34.0-rc2` |
| Mathlib | tag `v4.34.0-rc2` = commit `85e3a25e006c35636f0e53b0e9296caca2685bc0` |
| LeanMaster | tag `v3.33.0` = commit `61fc58d599182185613e1460861e48d6c7dd39a7` |

Migrated from Lean `v4.32.0` / Mathlib `3dffaf2f…` on **2026-09-20** (T0 decision). The pin matches
`SocrateAI-Scientific-Agora-LeanMaster` deliberately, so the two projects share one Mathlib olean
cache — that cache is toolchain-exact, and a mismatch costs a from-source Mathlib rebuild.
The pin is frozen again: changing it needs a new dated T0 decision (`CLAUDE.md` rule 1).

The migration required **no change to any Lean source file**; all 314 declaration signatures are
byte-identical across the two versions. Details, and a reusable migration playbook, in
**[`briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md`](briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md)**.

**[LeanMaster](https://github.com/xaviercallens/SocrateAI-Scientific-Agora-LeanMaster) is a build
dependency** as of 2026-09-20, pinned to release tag `v3.33.0` — required *from git by tag, never
by local path*, so this build never depends on a sibling checkout's uncommitted state. It requires
the same Mathlib tag, so the two dependency graphs unify (`mathlib` appears once in
`lake-manifest.json`). `Agora/Bridge/LeanMasterK3.lean` exercises the dependency and is imported
from `Agora.lean`, so `lake build Agora` genuinely compiles against LeanMaster rather than merely
declaring it.

⚠️ That module **establishes no new mathematics**, and says so in its header. LeanMaster's K3
facts (`k3_b2_is_22`, `k3_lattice_rank_valid`, `k3_signature_is_minus_16`) are `rfl` over
hand-written encodings of literature values (BHPV2004, GH1978) — kernel-checked *bookkeeping with
a citable source*, not a derivation of K3 topology. In particular LeanMaster's generic Hodge
signature split (b₂⁺, b₂⁻) = (3, 19) is **not** evidence for this project's ρ = 19 / T = 3 for
`cooper_s7`, which remains **Tier B** on Stream 2's derivation. The numerals coincide because
22 − 19 = 3; that is arithmetic, exactly as the paper already states at `prop:g0complement`.

## Verified status

Last checked 2026-09-21 at the pin above. **Re-run the commands rather than trusting these numbers.**

| Check | Result |
|---|---|
| `bash scripts/release_gates.sh` | **all gates OK** (it reads exit codes correctly; a green run is not a clean bill) |
| `lake build Agora OpenGoals Tests` | 3728 jobs, **0 errors** (linter warnings only) |
| Axiom audit of `Agora` | **334 theorems audited.** 331 depend only on `propext`, `Classical.choice`, `Quot.sound`. ⚠️ Exits **1** permanently — see below |
| — the other 3 | depend on the two *registered, disclosed* axioms below; no `sorryAx`, no `Lean.ofReduceBool` |
| `sorry` | **ZERO.** The last one closed 2026-09-20 (see below) |
| Statement lock | OK — 502 declarations in 38 files; mutation-verified to fire |
| `scripts/export_open_goals.py` | all **5** registered goals report `closed` |

## 🎯 The last `sorry` is closed (2026-09-20)

`open_goal_partner_eq_sqrt_s7` — that the recurrence-defined order-2 partner of Cooper's s₇ **is**
the formal square root of the s₇ series, at every index — is **proved unconditionally**
(`Agora/Sequences/SqrtBridge.lean`). This is the bridge that carries the kernel-proved
*operator-level* theorem `L₃ = P₂·Sym²(L₂)` down to the level of **sequences**. Axioms: Lean's
three only; it does *not* use `obrien2016_theorem6_2`.

**The `blocked-on-mathlib` ruling on it was wrong.** That ruling cited the absence of a
`PowerSeries` square root and of a holonomic API. Both absences are real; neither mattered — the
proof uses only API that was present at the *previous* pin too. The four recorded failed strategies
were never refuted, they were routed around: a convolution sum can be symmetrized in its two
indices (`Finset.sum_range_reflect`), after which the solution-level Sym² transport is a single
`linear_combination`. This is the **second** time a `blocked-on-mathlib` label on this file proved
wrong. The label describes a proof route, not a goal.

New consequence: `partner_s7_dyadic` — the s₇ partner lies in ℤ[1/2] for every `n`, upgrading a
PASS(59) observation to a theorem and excluding every odd prime. ⚠️ Dyadic is **not** integral:
this reduces `open_goal_partner_integral_s7` to a purely 2-adic statement, and does **not**
discharge `obrien2016_theorem6_2`.

**Same day, three follow-ons (all kernel-proved, standard axioms only):**
- **The bridge holds for the whole Cooper template** (`SqrtBridgeGeneric.partner_eq_sqrt`): for
  every `(a,b,c,d)` and every integer sequence with the Cooper recurrence, partner = formal √.
  New instance: **s₁₀**, whose partner is now *proved* dyadic at every index (was PASS(59)).
  No s₁₈ instance is stated — the repo has no closed form for s₁₈ to instantiate at.
- **s₇ integrality is reduced to one congruence** (`SqrtIntegrality`): if `4 ∣ s₇(n)` for all
  `n ≥ 1` then the s₇ partner is integral *without* `obrien2016_theorem6_2`. The congruence was
  **PASS(200)**, kernel-checked PASS(6), and not proved — so the axiom still stood at the time of
  writing. ⭐ **SUPERSEDED the same day, 2026-09-20:** the congruence is now proved
  (`S7Mod4.four_dvd_s7`), which is exactly what "would leave the development with no literature
  axiom" anticipated. See [§⭐ No literature axiom is load-bearing](#-no-literature-axiom-is-load-bearing-2026-09-20).
- **`U ⊕ ⟨2N⟩` on LeanMaster's lattice API** (`Agora/Geometry/MnLattice.lean`): the glue
  `e ± Nf ⊂ U` of index `2N` (the paper's embedding witness at `N = 7`), and the swap `e ↔ f`
  acting on the period as the Fricke involution `τ ↦ −1/(Nτ)`. The same matrix is LeanMaster's
  Narain form, on which the swap is T-duality — **a fact about a lattice isometry, not a physical
  identification** (VISION §1.3). Whether `U ⊕ ⟨14⟩` *is* the s₇ transcendental lattice stays Tier B.

- **The self-dual locus** (`Agora/Geometry/SelfDual.lean`, evaluation of the "walk toward the
  self-dual point"): the swap is the Weyl reflection in the (−2)-root `e − f` (LeanMaster's
  `reflection`), its wall is exactly `Nτ² = −1`, and — the central result — the finite singular
  points `{−1, 1/27}` of the s₇ operators are the images of the Fricke fixed points `h = ±1/7`
  under `z(h) = h/(1+13h+49h²)`, with `s7_P2(z(h))·(1+13h+49h²)² = (1−49h²)²`. Kernel-proved for
  the rational map; that `z(h)` parametrizes the s₇ family is PASS(40) exact + literature, not
  kernel-proved. **The foundation behind it** (`Agora/Geometry/ModularAction.lean`): an explicit
  integer 3×3 representation ρ realizing Γ₀(N) *and* the Atkin–Lehner elements inside
  `O(U ⊕ ⟨2N⟩)`, multiplicative, acting on the period with the weight-2 automorphy factor
  `(Ncτ+d)²` — as a polynomial identity needing no determinant hypothesis. Both singular points
  `{−1, 1/27}` are walls of (−2)-roots. The modular group **is** the lattice's isometry group.
  No physics is claimed. Record and verdicts (in French):
  [`briefs/THOUGHT_EXPERIMENTS_SELF_DUAL_2026_09_20.md`](briefs/THOUGHT_EXPERIMENTS_SELF_DUAL_2026_09_20.md).

- **The embedding witness is now kernel-checked** (`Agora/Geometry/Embedding.lean`): explicit
  integer matrices `B = (e₁, f₁, e₃+7f₃)` and `C = (e₂, f₂, e₃−7f₃)` with `BᵀU³B = U⊕⟨14⟩`,
  `CᵀU³C = U⊕⟨−14⟩`, `BᵀU³C = 0`, index 14. Six dimensions suffice because `E₈(−1)²` is
  unimodular and splits off. This upgrades the paper's embedding *witness* from (E) to (K); that
  the *monodromy* lattice is `U⊕⟨14⟩` still depends on the numerical claim and stays Tier B.
  ⚠️ **Corrected 2026-09-21 — this bullet and the table row above said "the primitive
  embedding".** Primitivity is *not* kernel-checked. What is checked is the witness, the two
  pullbacks, orthogonality, and the numerical coincidence `index = |disc T₇| = 14`; the step from
  that coincidence to "both sublattices are primitive and each is the other's complement" is the
  standard **Nikulin-style criterion, which is literature and is formalized nowhere in this
  repository**. The same qualification applies to `prop:embedding` in the paper, and is stated
  there alongside `prop:assembly`.
  **The rank-22 assembly is now kernel-checked too** (`Agora/Geometry/EmbeddingAssembly.lean`):
  the generic orthogonal-join lemma `join_pullback` and its instantiation `assembly` over
  `Λ = U³ ⊕ E₈(−1)²`, with `assembly_det` giving `−196 = −14²`. Note `assembly` is a statement
  about the *pullback* of `Λ` along `Φ` — it is not a rank or injectivity claim about `Φ`.

- **Two rank-3 lattices, not one** (`Agora/Geometry/SymSquareForms.lean`). The symmetric square
  `sym2` acts on the *discriminant* lattice of Γ₀(N)-forms (`b² − 4Nac`, Gram determinant `−4N²`);
  ρ acts on the *transcendental* lattice `U ⊕ ⟨2N⟩` (Gram determinant `−2N`). Both have signature
  (2,1) and both carry Γ₀(N)⁺ actions, but they are **not isometric** — an isometry preserves the
  Gram determinant, and `−4N² = −2N` only at `N = 0` or `N = ½` (`no_isometry_G0N_TN`). Conflating
  them under one name is a real error; this was caught in cross-session review with the LeanMaster
  repository. Neither repository's Lean files asserted the conflation — a directive did.
  Also proved here: `sym2(M)ᵀG₀sym2(M) = (det M)²G₀` with **no** `det = 1` hypothesis,
  `det sym2 = (det M)³`, `tr sym2 = (tr M)² − det M`, and `sym2` is **contravariant**
  (`sym2(MM') = sym2(M')sym2(M)`, with a negative control showing the order matters).
- **The signature (2,1) of `U ⊕ ⟨2N⟩` is now Tier A**, not asserted: the integer basis change
  `P = (e+f, w, e−f)` gives `PᵀT_N P = diag(2, 2N, −2)` (`TN_diagonalises`, with a sign control).
  Supplied by the LeanMaster session and re-verified here; it retires a caveat this repo had
  inherited.

Directions and the (Tier C, conjecture-marked, not in the paper) K3 × T² question:
[`briefs/RESEARCH_DIRECTIONS_2026_09_20.md`](briefs/RESEARCH_DIRECTIONS_2026_09_20.md).

Full account of the closure, including the verification chain and its negative control:
**[`briefs/BRIDGE_GOAL_CLOSED_2026_09_20.md`](briefs/BRIDGE_GOAL_CLOSED_2026_09_20.md)**.

<sub>All figures in the table are from the run recorded in the most recent commit; earlier revisions of
this README carried counts from earlier commits. Counts have moved 3155 → 3724 jobs and 165 → 297
audited theorems over the changes on
2026-09-20 (the LeanMaster dependency, then this closure). No existing statement changed at any
point and no new axiom dependency entered.</sub>

## ⭐ No literature axiom is load-bearing (2026-09-20)

`4 ∣ s₇(n)` for every `n ≥ 1` is now **proved** (`Agora/Sequences/S7Mod4.lean`,
`four_dvd_s7`), by an elementary termwise argument. Feeding it into the repo's existing
reduction gives `s7_partner_integral_axiom_free` — the *same* conclusion as the old
`s7_partner_integral`, but with axioms `propext`, `Classical.choice`, `Quot.sound` only.
The contrast, from one `#print axioms` run:

```
'Partner.s7_partner_integral'           → [..., Agora.Axioms.obrien2016_theorem6_2]
'S7Mod4.s7_partner_integral_axiom_free' → [propext, Classical.choice, Quot.sound]
```

**The mechanism.** Divisibility is termwise. For a summand `C(n,k)²·C(n+k,k)·C(2k,n)`: if
`C(n,k)` is even, `4` divides its square; if `C(n,k)` is odd, two instances of
`Nat.choose_mul` expose the central binomial `C(2k,k)` — even for `k ≥ 1` — inside *each*
of the other two factors. Equivalently the summand is `C(n+k,2k)·C(k,n−k)·C(2k,k)²`, where
`4 ∣ C(2k,k)²` is visible by inspection.

**What it is not.** Not a new theorem: `4 ∣ s₇(n)` follows from the classical modular
identity. It is an elementary, self-contained, machine-checked proof needing no modular
input. The modulus is sharp (`8 ∤ s₇(1) = 4`) and the criterion discriminates
(`4 ∤ s₁₀(1)`). The citation axiom is **retained, not deleted** — `S7Mod4` transitively
imports `PartnerIntegrality`, so the legacy theorem cannot be rewired without a cycle, and
keeping both lets the derivations be compared.

**Why it had looked hard.** Three recorded failures all attacked a *recurrence*: mod 4 on
the order-3 recurrence (the `(n+1)³` leading coefficient is even for odd `n`), mod 2 on the
partner recurrence (controls odd indices only), and deduction from integrality (circular).
The closing argument touches no recurrence at all. The obstruction was the representation,
not the depth — the third time in this repo that a "blocked" goal fell to a change of
representation rather than new machinery.

The two axioms, both registered in [`AXIOMS.md`](AXIOMS.md):

- **`obrien2016_theorem6_2`** — a literature citation (O'Brien 2016, MSc thesis, Massey University,
  Thm 6.2 p.47). ⭐ **SUPERSEDED 2026-09-20**, see above: retained and still used by the legacy
  `s7_partner_integral`, but no longer necessary for any result. Cite
  `S7Mod4.s7_partner_integral_axiom_free` instead.
- **`pipeline_upper_bound`** — flagged **DISCLOSED-VACUOUS**: vacuously true, encodes no pipeline
  data, **not** discharged. The two theorems reaching it carry no content from it; do not cite it
  as evidence.

`native_decide` is confined to `Tests/` (four golden numeric tests, each tagged `TRUST:
native_decide`). Results proved that way are kernel-checked *modulo compiler trust*, not plain
Tier A. Nothing in `Agora/` or `OpenGoals/` uses it.

---

## ⚠️ Correction notice — 2026-07-25 (F6 disclosure)

Work published to `main` on 2026-07-25 under the heading "Stream 2 geometry locked" has been
**retracted the same day**. The C1/C2 "certificates", the C3b physics-interpretation brief, the
EFT-matching analyses, and the decision to unlock the EFT phase were all built on checker
scripts that performed **no computation** — every value they reported was a hardcoded
placeholder, and their self-tests returned `True` unconditionally and could not fail.

Specifically retracted: the claim that the s7/s10 fiber configuration is `[I₁, I₁]`; that the
Picard lattice is `[[2,1],[1,2]]` with ρ=2, τ=20; that discriminant −3 indicates an SU(5) GUT
(that lattice is A₂, i.e. SU(3)); that `s7` is the weight-3 modular form η(τ)⁶ (unsupported by
the cited source, which states only that the generating function *composed with* a modular
function is a modular form); and every downstream number, including the 10¹⁸ GeV string scale
and the 10⁴⁰⁻⁴¹ yr proton lifetime. A separate provenance failure: the PDF pinned as Zagier's
paper was in fact an unrelated article on lattice disk coverings, so the "15 sporadic sequences
verified" claim was also false.

**Not affected:** all Lean results, including the D2 closure
(`Agora/Sequences/WZCertificates.lean`, `open_goal_recurrence_s7`/`_s10`). Those are kernel
proofs, independently re-verified and two-model reviewed; `lake build` is green and both
theorems depend only on `propext`/`Classical.choice`/`Quot.sound`. The Cooper parameters
`(13,4,−27,3)` / `(6,2,−64,4)` / `(14,6,192,−12)` were genuinely checked against the fetched
Gorodetsky PDF and stand.

Full analysis, evidence, and remediation: **[`briefs/ESCALATIONS.md` § E-007](briefs/ESCALATIONS.md)**.
Retracted artifacts are retained in place with `⛔ RETRACTED` banners rather than deleted, so the
record stays auditable.

## ⚠️ Correction notice — 2026-07-26 (F6 disclosure): two vacuous "integrality" theorems

`Agora/Sequences/Integrality.lean` (WP S1-03) described itself as proving that Cooper's s7 and
s10 "are integral for all n". It does not. `s7` and `s10` are declared `ℕ → ℕ`, so the two
theorems in question — `s7_is_nat`, `s10_is_nat`, both of the form `∃ k : ℕ, s7 n = k` — are
**tautologies**, closed by `use s7 n`. They restate the type signature and carry no arithmetic
content. This is the same failure mode as E-002 and E-005 (a statement that cannot fail being
cited as though it had been verified); no external claim rested on them, and nothing else in the
repository depended on them.

Both are retained, relabelled `⚠️ VACUOUS`, so they are not silently re-added as evidence. The
file header now states honestly what it does and does not establish.

**The real arithmetic content has been supplied** in the same change, as WP S1-11
(`Agora/Sequences/PartnerIntegrality.lean`): the *order-2 partner* sequences are ℚ-valued —
their recurrence divides by `(k+2)²` — so their integrality is a genuine theorem, and it
separates the candidates. Proved unconditionally: **s10's and s18's partners are NOT integral**
(single witnesses, `17/2` and `45/2` at `n = 2`). **Not proved: s7's partner is integral** — that
is kernel-checked only to `n ≤ 7` (`PASS(7)`) and is registered as the named open goal
`open_goal_partner_integral_s7`, with the reason it is hard (an Apéry-style divisibility, not a
typing fact) recorded there. Please do not cite it as established.

> ⭐ **Update 2026-09-20 — this last sentence no longer applies.** `open_goal_partner_integral_s7`
> is **closed**: s₇'s partner is integral, proved unconditionally as
> `S7Mod4.s7_partner_integral_axiom_free` (via `four_dvd_s7`), with Lean's three standard axioms
> only. The `PASS(7)` status and the named open goal above are the 2026-07-26 state, retained for
> the record; the declaration `open_goal_partner_integral_s7` no longer exists in the source. The
> rest of this notice — the two vacuous `ℕ → ℕ` theorems, and s10/s18 non-integrality — stands
> unchanged. See [§⭐](#-no-literature-axiom-is-load-bearing-2026-09-20) and
> [§🎯](#-the-last-sorry-is-closed-2026-09-20).

---

## Key Documents

📕 **[`LL.md`](LL.md) — lessons learnt.** Read before quoting any gate, number or verification
claim from this repository. It records, with the mutation tests that establish them: a `sorry`
does **not** fail the build; `axiom_audit.py` exits 1 permanently here and is not a pass/fail
signal; a pipe hands you the filter's exit code, not the tool's; and the defect class where a
theorem is true, compiles, passes every gate, and proves **less than its name says**.

1. **[VISION.md](VISION.md)** — The master vision document. Read this first.
2. **[K3_CRITERIA.md](K3_CRITERIA.md)** — Frozen criteria for ranking K3 candidates (Tier A/B properties). Stream 2 uses this.
3. **[PREDICTION.md](PREDICTION.md)** — Draft falsifiable predictions. Stream 3 tests these against data.
4. **[PHASE_8_FTHEORY_PROPOSAL.md](docs/PHASE_8_FTHEORY_PROPOSAL.md)** — Previous F-theory proposal (for context).

---

## Repository Structure

```
.
├── Agora/                  # The mathematics. No `sorry` anywhere.
│   ├── Axioms/             # The ONLY place an `axiom` may be declared (see AXIOMS.md)
│   ├── Sequences/          # Cooper sequences, recurrences, θ-form operators, Sym² partners
│   ├── Geometry/           # Lattices, modular action, the rank-22 embedding assembly
│   ├── Swampland/          # The Almkvist–van Straten Sym² criterion (`P_cleared_eq_zero`)
│   ├── Unverified/         # ⚠️ QUARANTINE — compiles, but NOT a physics result. See below.
│   └── ML/                 # Python/notebook experiments (not Lean)
├── OpenGoals/              # The ONLY place a `sorry` may appear; each is a named goal
├── Tests/                  # Golden numeric tests (these use `native_decide`)
├── briefs/                 # Session briefs, escalations, cross-stream memos
├── paper/                  # LaTeX manuscript
├── docs/                   # Documentation, references, statement_lock.json
├── data/                   # Test data and sequence values
├── external/               # Vendored third-party repos (reference only — not build deps)
└── scripts/                # Automation (export_open_goals.py, checkers, verification)
```

The `Agora/` – `Agora/Axioms/` – `Agora/Unverified/` – `OpenGoals/` split is the epistemic
contract: the mathematics, the declared assumptions, the material that is **not evidence**, and
the admitted gaps each have exactly one place to live.

### ⚠️ `Agora/Unverified/` — the quarantine (2026-09-21)

A systematic name-vs-statement audit found nine defects of one class: *a theorem that is true,
compiles, and passes every gate while proving **less than its name says***. **Every one of them
landed in five legacy physics modules. Not one landed in the arithmetic and lattice core**, which
held up under direct attack. Those five now live in `Agora/Unverified/`, retained with history —
nothing was deleted.

What is in there: `dual_scale_components_conjunction` (renamed from
`dual_scale_universe_model_consistent`), two of whose three conjuncts are `∃ v : ℝ, v > 0.45`
(witness `1`) and "a product of positive reals is positive"; the M87* chameleon numerics; and an
F-theory "physical dictionary" whose Kodaira-to-gauge-algebra reading is the category error
retracted as E-008/E-009. **Nothing in the core imports any of it** — the separation is enforced
by an absence of edges, not by convention. It still compiles: the claim is *"this is not
evidence"*, never *"this does not compile"*.

Tier C is blocked program-wide (F5b), so these cannot be repaired into results — which is why
they are quarantined rather than rebuilt. See [`LL.md`](LL.md) and `briefs/ESCALATIONS.md` E-013.

---

## Building & Testing

```bash
git clone https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal.git
cd SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal

# Fetch the prebuilt Mathlib oleans for the pinned commit (minutes instead of hours).
lake exe cache get

# Build. Name the targets explicitly — the package declares no default target,
# so a bare `lake build` reports "Nothing to build" and exits 0.
lake build Agora OpenGoals Tests
```

`./scripts/setup_externals.sh` is **not** needed to build. It clones the `external/` submodules,
which are vendored for reference only; since 2026-09-20 no `external/` package is a build
dependency (the unused `QuantumInfo` require was removed during the toolchain migration).

Expect exactly one `sorry` warning, from `OpenGoals/PartnerIntegrality.lean` — that is the single
named open goal, and it is the only permitted location. Verify the claims above with:

```bash
grep -rn '\bsorry\b' Agora OpenGoals Tests --include=*.lean   # one hit, in OpenGoals/
python3 scripts/export_open_goals.py                          # regenerates open_goals.json
```

---

## Roadmap (from VISION.md)

| Phase | Dates | Deliverable |
|-------|-------|-------------|
| **Phase 0** | Weeks 1–2 | VISION.md, K3_CRITERIA.md, draft PREDICTION.md (all three repos) |
| **Phase 1** | Months 1–2 | Finalize falsifiable prediction (M1) |
| **Phase 2** | Months 2–8 | Lean arithmetic formalization + arXiv preprint (M2) |
| **Phase 3** | Months 8–14 | Stream 3 observational report (M3) |
| **Phase 4** | Months 14–18 | Final manuscript(s) |

**This repo's focus:** Phase 2 (months 2–8).

---

## Contact & Collaboration

- **Author:** Xavier Callens (callensxavier@gmail.com)
- **Feedback:** Open issues or PRs. Mathematical results should be reviewed by the modular-forms / mirror-symmetry community before claiming Tier A status.
- **External math libraries:** See `external/` for credits (Lean-QuantumInfo, Lean4PHYS, ml-string-landscape).
  These are vendored for reference and are **not** build dependencies — the repository's only Lean
  dependency is Mathlib at the pinned commit.
- **Sibling repository:** [`SocrateAI-Scientific-Agora-LeanMaster`](https://github.com/xaviercallens/SocrateAI-Scientific-Agora-LeanMaster)
  shares this toolchain pin and supplies the reusable proof-gate tooling (`statement_lock.py`,
  `axiom_audit.py`) used to verify the table above.

---

<sub>README verified against the repository 2026-09-20 (Lean v4.34.0-rc2). Build, axiom, `sorry` and
statement-lock figures are from that session's runs, recorded in
[`briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md`](briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md).
Tier discipline per [VISION.md](VISION.md) §2. Not yet T0-reviewed.</sub>
