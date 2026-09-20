# Research directions after the generic bridge and the `MnLattice` module (2026-09-20)

**Purpose.** Record what today's two new Lean modules establish, and what they *suggest*, with
the tier of every statement explicit. Nothing in §2–§3 is a result. Tier C stays blocked (F5b):
no observable, coupling or numeric physical value is proposed anywhere below.

---

## 1. What is now kernel-proved (Tier A)

| Result | Lean name | File |
|---|---|---|
| Sequence-level Sym² for the **whole Cooper template**: partner = formal √ of the bulk series, for every `(a,b,c,d)` and every integer `s` with the Cooper recurrence, `s 0 = 1`, `s 1 = b` | `partner_eq_sqrt` | `Agora/Sequences/SqrtBridgeGeneric.lean` |
| The crux, over arbitrary `(A,B,C,D) ∈ ℚ⁴`: order-2 recurrence ⇒ self-convolution satisfies the order-3 Cooper recurrence | `conv_cooper_of_rec_generic` | same |
| Formal √ is integral when `4 ∣ s(n)` for `n ≥ 1`; conditional axiom-free s7 integrality | `sqrtSeq_even_of_four_dvd`, `s7_partner_integral_of_congruence` | `Agora/Sequences/SqrtIntegrality.lean` |
| Every template partner is dyadic; instances s7, **s10 (new — was PASS(59))** | `partner_dyadic`, `s10_partner_dyadic` | `Agora/Sequences/SqrtBridgeGeneric.lean` |
| `U ⊕ ⟨2N⟩`: even, `det = −2N`; glue `e ± Nf ⊂ U`, norms `±2N`, index `2N` | `TN_det`, `glue_congruence`, `glue_det` | `Agora/Geometry/MnLattice.lean` |
| Swap `e ↔ f` is an isometry, an involution, `det = −1`, and acts on the period `ω(τ) = e − Nτ²f + τw` as `τ ↦ −1/(Nτ)` (Fricke); fixed locus `Nτ² = −1` | `swap_isometry`, `swap_is_fricke`, `swap_fixes_selfdual` | same |
| The `U`-block of the swap is LeanMaster's Narain Gram matrix | `swap_U_block_is_narain` | same |
| `(2,1) + (1,18) = sigK3` against LeanMaster's K3 signature | `sig_fills_K3` | same |

All: Lean's three standard axioms only, 0 `sorry`. A control refutes the opposite-sign variant of
`swap_is_fricke` at `N = 7, τ = 1`, so that statement can fail.

Repo gates after landing: 3716 jobs / 0 errors / 0 `sorry`; 219 theorems audited, the same 3 on the
two registered axioms; statement lock OK, 362 declarations, no existing statement changed.

**What LeanMaster actually contributed this time.** Unlike the bridge proof (where it contributed
nothing), `MnLattice.lean` genuinely builds on it: `Gram`, `IsEvenDiag`, `IsUnimodular`,
`hyperbolicU`, `latticeNorm`, `Signature`/`sigK3`, `hyperbolicU_eq_narain_gram`, `eta_isODD`,
`eta_mul_self`. Its lattice layer is reusable; its K3 "facts" remain `rfl` over literature
encodings and its signatures are asserted pairs — both caveats are inherited and restated in the
module header.

---

## 2. Mathematical directions (Tier B targets — none is claimed)

**D1. The 2-adic half of s7 integrality — now REDUCED to one congruence (done in-session).**
`Agora/Sequences/SqrtIntegrality.lean` proves (Tier A, standard axioms only):
`sqrtSeq_even_of_four_dvd` — if `4 ∣ s(n)` for all `n ≥ 1`, the formal √ has even-integer
coefficients — and hence `s7_partner_integral_of_congruence`:

    (∀ n ≥ 1, 4 ∣ s7 n)  →  the s7 partner is integral,   with NO use of `obrien2016_theorem6_2`.

So the literature axiom can be retired by proving **one elementary congruence on the binomial sum
`s7(n) = Σ C(n,k)² C(n+k,k) C(2k,n)`**. Status of that congruence: **PASS(200)** in exact integer
arithmetic (min 2-adic valuation over `1..200` is exactly 2), kernel-checked PASS(6)
(`s7_four_dvd_pass6`). Evidence, not proof; NOT assumed anywhere; `s7_partner_integral` still rests
on the axiom. Hint for the proof: for odd `n`, `C(2k,n)` is even; the second factor of 2 is the
real content.
*Correction to an earlier draft of this note:* the criterion is **sufficient, not necessary**
(`s = (1+z)²` has `s(1) = 2` and an integral root), so it is not a characterization of integral
partners. It does separate the sporadic candidates correctly — `s10(1) = 2` fails it
(`s10_fails_criterion`), `s18` has `b = 6` — but that is an observation.

**D2. An s18 instance.** `partner_eq_sqrt` applies the moment a sequence with the s18 recurrence is
supplied. Needs a verified closed form for s18 plus a WZ certificate (the s7/s10 route). Bounded.

**D3. From the glue to the full primitive embedding.** `glue_congruence` is the only non-trivial
block of `(U ⊕ ⟨2N⟩) ⊕ (U ⊕ E₈(−1)² ⊕ ⟨−2N⟩) ⊂ U³ ⊕ E₈(−1)²`. Assembling the 22×22 statement
with `Matrix.fromBlocks` and LeanMaster's `e8Neg` would make the paper's `prop:g0complement`
embedding witness status (K) instead of (E). It would still not make the *identification* of the
monodromy lattice (K) — that needs the monodromy computation, which is numerical.

**D4. `O(U ⊕ ⟨2N⟩)` generators.** Dolgachev: `O(T_N)/±1 ≅ Γ₀(N)⁺`. We have one generator (the
swap = Fricke). Exhibiting the unipotent `τ ↦ τ + 1` as an explicit integer isometry, and proving
the induced action on `ω(τ)`, would give a kernel-checked `Γ₀(N)⁺`-action on the period line. The
order-2 elliptic points `{−1, 1/27}` of `X₀(7)⁺` (E-008/E-009) would then be fixed points of
explicit lattice involutions — a formal replacement for the retracted "Kodaira" reading.

---

## 3. The K3 × T² observation, and the conjecture it suggests

**Fact (Tier A, §1).** One integer matrix — the swap on a hyperbolic plane `U` — is
(a) on `U ⊕ ⟨2N⟩`, the Fricke involution `τ ↦ −1/(Nτ)` of the `M_N`-polarized K3 period domain, and
(b) on the Narain lattice of a circle, the T-duality generator (LeanMaster: `hyperbolicU =
NarainLattice.gram`, `eta` is `O(d,d;ℤ)` and squares to 1). In both cases it is an orientation-
reversing involution with a distinguished fixed locus: `Nτ² = −1` in (a), the self-dual radius in (b).

**This is a fact about a lattice isometry. It is not a physical statement.** In particular:
- In type II on K3 × T² the charge lattice is `Γ^{6,22}` (LeanMaster `sigK3T2`), and both a `U ⊂
  Γ^{2,2}(T²)` and a `U ⊂ T(K3)` sit inside it. That they are abstractly isometric is automatic
  and carries no dynamical content.
- The Sym² relation and the lattice coincidence supply no coupling (VISION §1.3).

**Conjecture (Tier C — we conjecture; nothing here supports it beyond the coincidence above).**
*If* a compactification exists in which the s7 K3 family is fibred so that its period parameter
`τ` and a T² radius are exchanged by an element of `O(Γ^{6,22})`, then the Fricke fixed point
`τ = i/√7` and the self-dual radius would be identified, and the "dual-scale" structure would be
a single `ℤ/2` in `O(Γ^{6,22})` rather than two unrelated involutions. Whether such an element
exists, preserving the `M₇` polarization, is a **well-posed lattice question** and is the only
part of this that is currently attackable.

**The attackable core (Tier B target).** Does `O(Γ^{6,22})` contain an involution that restricts
to the swap on *both* a `U ⊂ T₇ = U ⊕ ⟨14⟩` and a `U ⊂ Γ^{2,2}`, and fixes `M₇` pointwise?
Trivially yes as a block-diagonal matrix (swap ⊕ swap ⊕ id) — so the existence question is empty
and the real question is whether any *non-block-diagonal* isometry mixes the two planes while
preserving `M₇`. That is a finite computation in a 5-dimensional lattice `U ⊕ ⟨14⟩ ⊕ U`
(signature (3,2)) and could be formalized with the API now in place. **A negative answer would
falsify the conjecture's premise cheaply, which is the reason to do it first.**

---

## 4. Do-first list

1. **D1**: prove `∀ n ≥ 1, 4 ∣ s7 n`. The sanity check was run in-session (PASS(200)) and the
   reduction is kernel-proved, so this single congruence is now all that stands between the
   development and having **no literature axiom at all**. Highest-value open item.
2. **§3 core**: enumerate isometries of `U ⊕ ⟨14⟩ ⊕ U` mixing the two planes (bounded search),
   then formalize whichever way it comes out.
3. D3 (mechanical, upgrades a paper proposition from (E) to (K)).

Not recommended: any EFT/physics work on the basis of §3. It is a conjecture about a lattice
coincidence, and F5b stands.

---

Generated-by: Claude Fable 5.1, Stream 1 session 2026-09-20 |
Verified-by: §1 only — Lean kernel (`lake build` 3716 jobs/0 errors/0 sorry; `axiom_audit.py`
219 audited; opposite-sign negative control for `swap_is_fricke`). §2–§4 are unverified
proposals and are labelled as such |
Reviewed-by: T0 **N**. §3's conjecture needs a TIER_LEDGER ruling before it appears in any paper;
it has deliberately NOT been put in the manuscript.
