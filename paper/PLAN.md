# PLAN — First mathematics paper of the program

**Scope ruling (T0 directive, 2026-07-27):** pure mathematics only. Zero physics — no
dark-sector, cosmology, or "universe model" content anywhere in the manuscript, including
motivation. The paper is built under `paper/` only; no other repo file is modified except
one pointer line in `TODO.md`.

---

## 1. Legitimacy assessment — is there a publishable paper here?

### 1.1 The adversarial question first: what is classical, what is new?

**Classical territory (must be cited, not claimed):**

- That the Picard–Fuchs operator of an M_n-polarized K3 family is the symmetric square of
  a second-order Fuchsian operator is **Doran, Thm 5.13** (arXiv:math/9812162, CMP 212
  (2000)); the lattice statement (M_n)^perp = U + <2n> and K_{M_n} = H/Gamma_0(n)+ is
  **Dolgachev 1996** (Thm 7.1, §7 p.20). Both were fetched, hash-pinned, and read by the
  program (Stream 2 `docs/literature/MANIFEST.md`).
- Cooper's sporadic sequences and their order-3 recurrences are **Cooper 2012**; the
  uniform template and closed forms are **Gorodetsky** (arXiv:2102.11839); explicit
  projective K3 models for the sporadic third-order operators are
  **Almkvist–van Straten** (arXiv:2103.08651). The s7 partner's modular parametrization
  and integrality is **O'Brien 2016** (Massey MSc thesis, Thm 6.2).
- Simplicity of the transcendental Hodge structure is **Zarhin 1983** Thm 1.6(a);
  minimality of T is **Huybrechts**, *Lectures on K3 Surfaces*, ch. 3.

So a paper claiming "symmetric-square structure relates these operators to K3 families"
as its contribution would be re-announcing known mathematics. That is NOT the paper.

**What the program actually adds (candidate novel contributions, each verified against a
repo artifact — see the claims inventory, §3):**

1. **A uniform, kernel-checked structure theorem for the whole Cooper template.** The
   literature treats the sporadic operators candidate-by-candidate. The Lean development
   proves, for *every* parameter choice (a,b,c,d) in Q^4 of the Cooper/Gorodetsky
   template, that the order-3 operator is P2·Sym²(L2) for an *explicitly determined*
   order-2 partner (the partner is solved out of the identities, not guessed), via four
   coefficient identities plus the "magic collapse" theta(P2) = 2·P1 that makes the
   identity division-free — and, independently, that the Almkvist–van Straten
   self-adjointness criterion W ≡ 0 holds identically in (a,b,c,d) in cleared-denominator
   form. Both are single `ring`-closed kernel proofs covering s7, s10, s18 (and any
   future template instance) simultaneously. To our knowledge no kernel-checked proof of
   a symmetric-square/Picard–Fuchs structure theorem exists in any proof assistant;
   the uniform template statement itself does not appear to be written down in the
   literature (Doran's theorem gives existence for M_n-polarized families; here the
   partner is exhibited in closed form from the template parameters, with no geometric
   hypothesis). — *Artifacts:* `Agora/Sequences/PartnerOperators.lean`,
   `Agora/Swampland/SymSquareC3b.lean`.

2. **An arithmetic separation of the three sporadic candidates.** The template-level
   partner makes a candidate-level arithmetic fact visible: s7 is the only one of
   Cooper's three sporadic sequences whose order-2 partner has an integral holomorphic
   solution (non-integrality of the s10/s18 partners is kernel-proven by finite witness —
   17/2 resp. 45/2 at n = 2; integrality of the s7 partner is O'Brien's Thm 6.2, cited,
   with the recurrence-matching step kernel-checked). The *mechanism* is sharpened: the
   load-bearing property is that X7 = eta_1^3 eta_7^3 / z_7^3 is a **normalized** integral
   uniformizer (leading coefficient exactly 1), not the folklore "eta-quotients are
   integral" — the Stream 2 checker exhibits two other integral, normalized eta-quotient
   readings that fail to reproduce A279619, so the resolution of O'Brien's eq. (3.15) is
   itself a checked fact. — *Artifacts:* `Agora/Sequences/PartnerIntegrality.lean`,
   Stream 2 `data/certificates/S7_PARTNER_MODULAR.json`.

3. **Exact irreducibility and minimality.** L2(s7) is irreducible by a clean denominator
   obstruction (attainable residues of a hyperexponential logarithmic derivative lie in
   (1/2)Z, while the infinity exponents are {1/3, 2/3}; for s10, {3/8, 5/8}); the
   monodromy is not dihedral (double indicial root at 0 forces a logarithmic solution,
   and no nontrivial unipotent lies in the normalizer of a maximal torus of SL2); hence
   Sym²(L2) = L3 is irreducible and is the minimal-order annihilator of its holomorphic
   solution. Elementary but apparently not in the literature for these operators, and
   exact over Q. — *Artifacts:* Stream 2 `checkers/check_L3_irreducible_minimal.py`,
   `data/certificates/L3_IRREDUCIBLE.json` (+ 16-assertion negative-control test).

4. **The explicit monodromy lattice with an exact integral splitting.** From 60-digit
   analytic continuation of L2(s7), rational recognition of the Sym² monodromy entries
   (largest residual ~1e-59 against a loud 1e-35 gate), and an exact rational lattice
   pipeline, the joint monodromy-invariant lattice of the s7 family has primitive even
   Gram [[0,0,-1],[0,14,0],[-1,0,0]], det -14, signature (2,1), discriminant form Z/14
   (q = 1/14), and an explicit GL_3(Z) base change realizing U + <14> — the last step
   verified by **two independently written exact implementations** (Stream 2 sympy
   pipeline; Stream 1 from-scratch pure-Python construction), each with negative
   controls, and discriminating against the s10 family (det -20). This matches
   Dolgachev's (M_7)^perp = U + <14> on the nose and, with the Gamma_0(7)+ Hauptmodul
   identification (Fricke constant kappa = 49) and rank T = 3, gives strong convergent
   evidence that the s7 family is M_7-polarized. **Tier honesty:** the numerics-to-exact
   recognition step and the identification of the computed lattice with the
   transcendental lattice T are *not* proven; they are presented as
   numerically-supported / conditional, never as theorems. — *Artifacts:* Stream 2
   `checkers/check_U1_lattice.py`, `data/certificates/C2_cooper_s7_v4.json`
   (SHA256 036cd895…), Stream 1 `checkers/check_U1_splitting_independent.py`,
   `briefs/STREAM1_U1_INDEPENDENT_VERIFICATION_2026_07_27.md`.

5. **The formalization itself as a contribution to formalized mathematics.** A worked
   example of formalizing "experimental number theory adjacent to algebraic geometry"
   under an explicit epistemic discipline: axiom quarantine (exactly one load-bearing
   literature axiom, O'Brien Thm 6.2, registered and disclosed), source-pinned
   definitions, golden validation of the Sym² formula against first-principles examples,
   PASS(N) reporting for finite checks, and named open goals instead of silent
   weakening. — *Artifacts:* `AXIOMS.md`, `Agora/SymSquare.lean` §3,
   `Agora/Sequences/Integrality.lean`.

### 1.2 Verdict

**Yes — there is a genuinely publishable pure-mathematics paper**, provided it is framed
as what it is: an *exact-computation + formalization* paper about a specific, arithmetically
distinguished family, not a new-theorem-in-transcendence-theory paper. The core
contribution is the **combination**: a kernel-checked uniform Sym² structure theorem for
the Cooper template + exact irreducibility/minimality + the explicit, doubly-verified
integral monodromy lattice U + <14> with a fully tier-honest account of which links are
proven, which are exact-symbolic, and which are numerical. No single ingredient would
carry a paper alone; the assembled package — with every number reproducible from a
public checker — is exactly the kind of paper *Experimental Mathematics* exists for.

**Honest weaknesses to manage (reviewer-anticipation):**
- A referee may say "Doran already tells you the PF operator of an M_7-polarized family
  is a Sym² and Dolgachev already tells you T = U + <14>." Response, built into the
  paper: the logical direction here is the *converse* — we compute the invariants of a
  concretely given operator family and match them against the framework; Doran himself
  (§6) flags the rank-19 classification as lacking, which is precisely why the lattice
  identification stays conditional here.
- The Lean proofs are `ring` identities — technically shallow. The paper must sell the
  *statement architecture* (the partner being determined, not chosen; non-vacuity by
  concrete identity; the golden-test validation of the Sym² formula) rather than proof
  difficulty.
- The monodromy step is numerical. This is disclosed as such, prominently, with the
  residuals and gate stated; the exact post-verification (involutions, infinity relation,
  invariant-form uniqueness, orbit closure) is described precisely.

### 1.3 Scope decision required from T0 (blocking for final framing, not for drafting)

**Option A (recommended, drafted here):** one paper including the lattice/monodromy
material as clearly-labeled numerically-supported + conditional sections (§6, §8).
Best fit: Experimental Mathematics, where mixed exact/numerical evidence with full
disclosure is the house genre.

**Option B:** restrict to the unconditional content (Sym² template theorem,
irreducibility/minimality, integrality mechanism, formalization) and defer the lattice
to a second paper once/if the recognition step is made exact (e.g. via exact
hypergeometric connection formulae) — fits J. Symbolic Computation or an ITP/CPP paper.
The section files are organized so that Option B = dropping `06-lattice.tex` and
`08-dolgachev-doran.tex` plus minor introduction edits.

## 2. Target venues

1. **Experimental Mathematics** (Taylor & Francis) — *primary recommendation.* The
   paper's genre (exact computation + numerical recognition + formal verification, full
   reproducibility, honest epistemic labeling) is this journal's core identity; papers
   presenting strongly-supported conjectures alongside proven results are explicitly in
   scope. Gorodetsky's template paper is published there, making it a natural home.
2. **Journal of Symbolic Computation** — good fit for the operator-algebra and checker
   content (Option B scope); the lattice/numerics sections would need to be reframed or
   dropped. Slower, more traditional refereeing.
3. **ITP or CPP (conference, formalization-led reframing)** — if T0 prefers to lead with
   the Lean development ("formalizing symmetric-square structure of Picard–Fuchs
   operators under an epistemic-tier discipline"). Different paper: the mathematics
   becomes the case study. Keep as fallback or as a *second* publication; the
   formalization section (§9) is written so it can seed that paper.

   (Note: LMS J. Comput. Math. ceased publication in 2017 — not an option.)

## 3. Claims inventory (every claim in the manuscript, with status and source)

Legend: **LEAN** = kernel-checked in Lean 4 (no `sorry`; axioms as noted) · **EXACT** =
exact symbolic computation, reproducible by a repo checker with negative controls ·
**NUM** = numerical recognition, presented as numerically supported, never as proven ·
**CITED** = classical result, cited to a read, hash-pinned source.

| # | Claim | Status | Source artifact |
|---|---|---|---|
| 1 | Cooper template operator L3(a,b,c,d), theta-form coefficients | LEAN (defs, source-pinned) | `Agora/Sequences/PartnerOperators.lean` §2; Gorodetsky eq. (1.7) |
| 2 | Partner P2 = 1-2az+cz², P1 = -az+cz², P0 = -(b/2)z+((c+d)/4)z² is determined by the template | LEAN | `partner_res3/2/1/0`, `partner_magic` (ibid. §2.5–§3.5) |
| 3 | L3 = P2·Sym²(L2) identically in (a,b,c,d) (theta-form, division-free) | LEAN (coefficient identities) + EXACT (series cross-check) | ibid.; `scripts/verify_sym2_partner_identities.py` |
| 4 | Almkvist–van Straten W ≡ 0 for the whole template (cleared form, 27·p3³·W) | LEAN | `Agora/Swampland/SymSquareC3b.lean` `P_cleared_eq_zero` |
| 5 | Sym² formula D³+3pD²+(2p²+p'+4q)D+(4pq+2q') validated on two first-principles examples | LEAN | `Agora/SymSquare.lean` §3 golden tests |
| 6 | s7 params (13,4,-27,3); s10 (6,2,-64,4); s18 (14,6,192,-12) | CITED (Cooper 2012 Table 1 / Gorodetsky) + LEAN (encoded, source-pinned) | `Agora/Sequences/CooperRecurrences.lean` |
| 7 | s7 partner series 1,2,22,336,6006,… (= A279619); s10 partner non-integral (17/2 at n=2); s18 non-integral (45/2 at n=2) | LEAN (non-integrality: finite witness; s7 head PASS(7)) + EXACT | `Agora/Sequences/PartnerIntegrality.lean`; `S7_PARTNER_MODULAR.json` |
| 8 | s7 partner integrality (all n) | CITED (O'Brien 2016 Thm 6.2, p.47) + LEAN (recurrence match mechanical; axiom `obrien2016_theorem6_2`, registered) | `Agora/Axioms/OBrien2016.lean`; `AXIOMS.md` |
| 9 | X7 = eta1³eta7³/z7³ is a normalized integral uniformizer; normalization is load-bearing; reading of O'Brien eq. (3.15) resolved among three candidates | EXACT | Stream 2 `check_s7_partner_integrality_modular.py`, `S7_PARTNER_MODULAR.json` |
| 10 | g.f. of A279618 is a Hauptmodul for Gamma_0(7)+; Fricke constant kappa = 49 | EXACT (identities to stated order) + CITED (Atkin–Lehner normalizer, classical) | Stream 2 `check_s7_hauptmodul_gamma07plus.py`, `HAUPTMODUL_S7_GAMMA07PLUS.json` |
| 11 | Exact Riemann schemes of L2/L3 (s7: sing {0,-1,1/27,inf}; L3 exponents; Fuchs sum 6; MUM at 0; W(L3) = W(L2)³) | EXACT | Stream 2 `check_L3_riemann_scheme.py`, `L3_RIEMANN_SCHEME.json` |
| 12 | Implied Fuchsian signature (genus 0; orders 2,2,3; 1 cusp; area/2pi = 2/3) matches Gamma_0(7)+ | EXACT (signature) + supporting identification | `L3_RIEMANN_SCHEME.json` lead1_bonus |
| 13 | L2(s7) irreducible (denominator obstruction: residues in (1/2)Z vs inf-exponents {1/3,2/3}); not dihedral (double indicial root at 0); L3 irreducible; L3 minimal | EXACT (argument exact over Q, checker-reproduced, 16-assertion controls) | Stream 2 `check_L3_irreducible_minimal.py`, `L3_IRREDUCIBLE.json`, `test_L3_irreducible_minimal_controls.py` |
| 14 | Monodromy matrices of L2(s7): M(1/27) = (i/sqrt7)[[0,1],[-7,0]], M(-1) = (i/sqrt7)[[7,4],[-14,-7]] | NUM (60-digit continuation; recognition residuals ~1e-59, gate 1e-35; exact post-verification of involutions + infinity relation) | Stream 2 `check_U1_lattice.py` stage 2; `C2_cooper_s7_v4.json` |
| 15 | Joint monodromy-invariant lattice: primitive even Gram [[0,0,-1],[0,14,0],[-1,0,0]], det -14, sig (2,1), disc Z/14, q = 1/14; zero proper even invariant overlattices | NUM input + EXACT pipeline (conditional on #14) | `C2_cooper_s7_v4.json` `derived` block |
| 16 | That Gram is GL_3(Z)-isometric to U + <14>, by explicit base change | EXACT, **two independent implementations** | Stream 2 stage 3; Stream 1 `checkers/check_U1_splitting_independent.py` (P = [[1,0,0],[0,0,-1],[0,-1,0]], det -1) + 5 controls |
| 17 | s10 control: identical pipeline derives det -20 / U + <20> | NUM+EXACT (control) | `C2_cooper_s7_v4.json` controls; `test_U1_controls.py` |
| 18 | rho = 19, T = 3 for the very general member (given the A–vS projective K3 model and that L3 governs its transcendental sub-VHS) | CITED (Zarhin Thm 1.6(a); Huybrechts Lem 3.2.7/3.3.1) + EXACT (rank input from #13); presented conditionally | Stream 2 `check_C2_transcendental_rank.py`, `C2_cooper_s7_v3.json` |
| 19 | (M_n)^perp = U + <2n>; K_{M_n} = H/Gamma_0(n)+; PF of M_n-polarized family = Sym² (Doran Thm 5.13); rank-19 classification open (Doran §6) | CITED (read, hash-pinned) | Stream 2 `docs/literature/MANIFEST.md`; `STREAM2_PHASE4_STEP2_SOURCES_READ_2026_07_26.md` |
| 20 | Identification of the computed monodromy lattice with the transcendental lattice T of the s7 family | CONDITIONAL/conjectural (framework reading; the lambda-rescaling branch excluded by framework shape, not computation) | `C2_cooper_s7_v4.json` `claim` + `tier_reason`; U1 brief §4 |
| 21 | Orthogonal complement of the computed lattice G in the K3 lattice Λ=U³⊕E8(-1)²: NS ≅ U⊕E8(-1)⊕E8(-1)⊕⟨-14⟩, rank 19, signature (1,18), disc. group Z/14 (q=27/14 mod 2Z); exactly M_7. Verified 3 ways (2 in-house exact routes + 1 external zero-shot re-derivation); does NOT independently re-derive rho=19 (rank is arithmetically forced by rank T=3) and does NOT discharge (H1)/(H2) or Conjecture T — conditional on the same Numerical Claim (monodromy) as row #14 | NUM input + EXACT pipeline (conditional on #14), added 2026-07-29 per WP-P1 | Stream 2 `briefs/G0_NS_GENUS_RESULT_2026_07_28.md` (commits 9a386d9, 15f16c5); decision log `briefs/WP_S2G_X4_EXHIBITION_PLAN_2026_07_27.md` §8 (commit 256017d); `checkers/check_NS_genus_G0.py`, `test_NS_genus_G0_controls.py` (5/5) |

**Rule enforced throughout:** every number in the manuscript traces to a row of this
table; no typed constants presented as computed.

## 4. Writing roadmap

Master: `paper/main.tex` (amsart). One file per section under `paper/sections/`.

| File | Content | Status | Remaining effort |
|---|---|---|---|
| `01-introduction.tex` | Contribution statement, epistemic-status table, related work, paper outline | **DRAFTED** | Polish after T0 scope decision (Option A/B); 1–2 h |
| `02-preliminaries.tex` | Notation; theta-operators; Cooper template; Riemann schemes; Sym² of an operator | **DRAFTED** | 0.5 h polish |
| `03-operators.tex` | L2/L3 for s7 (and s10 in passing): exact Riemann schemes, Fuchs sum 6, MUM, W(L3)=W(L2)³, Fuchsian signature | **DRAFTED** | 0.5 h polish |
| `04-sym2.tex` | The template structure theorem (partner determined + magic collapse + W ≡ 0), proof, Lean pointers | **DRAFTED** | 1 h polish |
| `05-irreducibility.tex` | Irreducibility of L2/L3, minimality; full proofs | **DRAFTED** | 1 h polish |
| `06-lattice.tex` | Monodromy computation (disclosed as numerical), exact lattice pipeline, the U + <14> splitting proposition (unconditional part), two independent verifications, s10 control | **DRAFTED** | 1–2 h; T0 Option A/B decision |
| `07-integrality.tex` | s7-partner integrality mechanism; normalized uniformizer; A279618/A279619; kappa = 49 | **STUB** (detailed outline, statements in place) | 3–4 h; needs care re O'Brien attribution and PASS(N) vs axiom presentation |
| `08-dolgachev-doran.tex` | Match against the M_n-polarized framework; rho = 19 / T = 3 (conditional); G0 orthogonal-complement cross-check (added 2026-07-29, claim #21); G1 construction placeholder stub (dated 2026-07-29, undescribed pending twisted-Weierstrass feasibility check — scope question for T0, see WP-P1 status brief); what remains open | **DRAFTED** (G0/G1 additions 2026-07-29) | polish pass only |
| `09-formalization.tex` | The Lean development: architecture, axiom inventory (2, disclosed), golden tests, PASS(N) discipline, three-strikes escalation discipline (§9.4, added 2026-07-30), what the kernel checked vs what is cited | **DRAFTED** (was mislabeled STUB in this table; body content already complete as of 5bd0916 — toolchain/axiom facts re-verified 2026-07-30 against `lean-toolchain`/`lake-manifest.json`/`AXIOMS.md`, all match; §9.4 added this session) | polish pass only |
| `10-reproducibility.tex` | Artifact/checker table, negative-control philosophy, how to re-run | **DRAFTED** (short; G0 rows added 2026-07-29) | 0.5 h |
| `10a-calabi-yau-construction.tex` | Empty placeholder, gated on Directive 1 | **STUB (deliberately empty)**, added 2026-07-30 (T0 Directive 3) | none — waits on Directive 1 |
| `10b-empirical-astrophysics.tex` | Empty placeholder, gated on Directive 2; scope tension vs this paper's own zero-physics ruling flagged, not resolved | **STUB (deliberately empty)**, added 2026-07-30 (T0 Directive 3) | none — waits on Directive 2 + a T0 scope call |
| `11-acknowledgments.tex` | T0-mandated AI-acknowledgment paragraph, verbatim (PLAN.md §5 item 3) | **DRAFTED** 2026-07-29 (WP-P1) | none — wording is non-negotiable |
| `references.bib` | Real, program-read references only | **DONE** (TODO-verify comments on 2 entries; 2 `@techreport` entries added 2026-07-29 for the G0 internal reports, D2.5) | verify Zagier 2009 & A–vS titles against PDFs: 0.5 h |

**2026-07-30 (T0 Directive 3) deviation-with-cause:** the directive listed a
"U⊕⟨20⟩ monodromy derivation" (cooper_s10) among certified sections to draft.
Searched this repo (row #17 above; `06-lattice.tex` `nc:s10-control`) and
Stream 2's `PREDICTION.md`, `PROOF_STATUS.txt`, `K3_SELECTION_REPORT.md`: no
certified, independently-verified cooper_s10 monodromy-lattice derivation
exists anywhere in either ledger. The only occurrence of $\U\oplus\langle
20\rangle$ is a discriminating regression control (already correctly tiered
NC/(N)+(E) in `06-lattice.tex`, used only to show the $s_7$ pipeline is
level-sensitive) and an identical control note in Stream 2's
`checkers/check_NS_genus_G0.py` / `data/certificates/G0_NS_genus_cooper_s7.json`.
Per Stream 2 Standing Rule 4 (verify a directive's artifacts before
executing), no new "certified cooper_s10" section was written; an explicit
stub disclaimer was inserted instead in `08-dolgachev-doran.tex` §"What is
not claimed".

**Compile status:** see §5 note in the report; `pdflatex` is available at
`/usr/bin/pdflatex` and the draft compiles (see commit).

**Not in scope of this scaffold:** abstract fine-tuning, journal-specific formatting,
arXiv metadata, acknowledgments policy (T0 to decide whether to acknowledge the
program's AI-assisted workflow — recommended for honesty, and Experimental Mathematics
has no policy against it, but T0 owns the wording).

## 5. Open questions for T0 — **ALL RESOLVED (T0 ruling 2026-07-28)**

Rulings recorded by T0 (Xavier Callens) 2026-07-28; full decision record with rationales
in the Stream 3 coordination repo, `briefs/T0_DECISIONS_2026_07_28_PENDING_ITEMS.md` (D2).

1. **Scope Option A vs B** (§1.3) — **RESOLVED: Option A.** One unified paper; the
   lattice/monodromy material stays as clearly-labeled conditional sections (§6, §8).
   Option B is retained only as a structural fallback if referees demand a split.
2. **Venue** — **RESOLVED: Experimental Mathematics** (primary submission target, per §2
   ranking).
3. **Authorship/acknowledgment** — **RESOLVED:** sole author Xavier Callens, affiliation
   "Independent Researcher". T0-mandated acknowledgment wording (verbatim):
   > "Computations, architectural drafting, and formal verification tooling were
   > accelerated via AI models (Anthropic Claude/Google Gemini). However, no mathematical
   > claim relies on generative text. All claims are explicitly backed by either Lean 4
   > kernel verification, exact symbolic Python execution, or hash-pinned literature,
   > with all artifacts publicly available for reproduction."
4. **rho = 19 / T = 3 presentation** (§8) — **RESOLVED: conditional proposition** (current
   draft form stands), hypotheses (A–vS operator identification; very-general-member
   caveat) stated explicitly. Tier note: the rank result is Tier B (derived) via two
   independent exact routes — Zarhin (E-011) and the Nikulin NS-complement (Stream 2 G0
   certificate, promoted LIVE 2026-07-28) — presented as such, not as kernel-proven.
5. **Internal report citation** — **RESOLVED: cite explicitly** as a hash-pinned
   unpublished technical report (title, year, repo + commit hash); no silent folding.

---
Generated-by: Fable 5 (Stream 1 paper agent) | Verified-by: every claim row checked
against the named artifact this session (certificates read; Lean files read;
briefs read) | Reviewed-by: pending T0 (Xavier)
