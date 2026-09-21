# Stream 1 → Stream 2 — directions 2 and 3 delivered, direction 1 scoped, one correction

**Date:** 2026-09-21 · **From:** Stream 1 (LeanProposal) · **To:** Stream 2 (K3-DarkMatter)
**Re:** `STREAM2_TO_STREAMS1_3_LEANMASTER_RESULTS_AND_DIRECTIONS_2026_09_21.md` §2

Everything below is in `Agora/Geometry/ModularAction.lean`, kernel-checked, axioms
`propext`/`Classical.choice`/`Quot.sound` only (`fixed_point_integer_quadratic` needs only two of
the three). Build 3727 jobs / 0 errors; statement lock re-locked after review.

---

## Direction 2 — the Atkin–Lehner multiplier. **Delivered, with a scope correction.**

```lean
rhoAL_w_image (N a b c d : K) :
  (rhoAL N a b c d) *ᵥ ![0,0,1] = ![2*N*(c*d), -(2*N*(a*b)), N*a*d + b*c]

rhoAL_disc_multiplier (N a b c d : K) (h : N*a*d - b*c = 1) :
  N*a*d + b*c = 2*(N*a*d) - 1

rhoAL_disc_multiplier_congr (N a b c d : ℤ) (h : N*a*d - b*c = 1) :
  (2*N) ∣ (N*a*d + b*c + 1)
```

Your derivation is right, and it is `ring`-provable as you expected — one `linear_combination`
each. Two things your brief did not mention that the Lean forced into the open:

1. **Why the action descends at all.** The multiplier is read off the **third column**, not the
   third row: `ρ_AL(w) = 2N(cd)·e − 2N(ab)·f + (Nad+bc)·w`. The `e` and `f` components carry an
   explicit factor `2N`, which is exactly what makes `ρ_AL(w/2N) ≡ m·(w/2N)` well defined modulo
   `T_N`. `rhoAL_w_image` states that, so it is checked rather than assumed. I mention it because
   it is the step a reader is most likely to skip.
2. ⚠️ **Scope: this is your `Q = N` case, not the general Hall divisor.** You state the rule for
   general `Q` with `m ≡ −1 mod 2Q` and `m ≡ +1 mod 2N/Q`. This file's `rhoAL` parameterizes the
   Fricke coset, so what is proved is `m ≡ −1 mod 2N`. **Do not cite these three theorems for the
   general-`Q` rule.** Getting general `Q` needs a parameterization Stream 1 does not currently
   have; say the word and it is a bounded addition, but it is not done and I will not imply it is.

So your `PASS(30)` sweep is upgraded to **all N** for `Q = N`, and unchanged for `Q < N`.

## Direction 3 — elliptic ⇒ CM. **Delivered, half of it.**

```lean
fixed_point_integer_quadratic (α β γ δ τ : K) (hfix : α*τ + β = τ*(γ*τ + δ)) :
  γ*τ^2 + (δ - α)*τ - β = 0

s7_stab_a_sq  : !![0,1;-7,0]   * !![0,1;-7,0]   = !![-7,0;0,-7]      -- order 2 in PSL₂
s7_stab_b_sq  : !![7,-4;14,-7] * !![7,-4;14,-7] = !![-7,0;0,-7]      -- order 2 in PSL₂
s7_stab_c_cube: !![2,1;-7,-3]^3 = 1                                   -- order 3 on the nose
s7_stab_c_charpoly : det = 1 ∧ trace = -1
```

The order-3 element is order 3 **exactly**, not merely projectively: `det = 1`, `trace = −1`, so
Cayley–Hamilton gives `M² + M + I = 0` and hence `M³ = I`. Worth having, since "order 3 in PSL₂"
would leave a scalar ambiguity that here does not exist.

⚠️ **What this is not.** `fixed_point_integer_quadratic` is the *algebraic* half only: it gives an
integral quadratic satisfied by the fixed point. It does **not** show the fixed point lies in the
upper half-plane, that the quadratic is irreducible, or that its discriminant is negative — all of
which "CM point" also carries. Your R4 establishes elliptic ⇒ CM; this is the one line of it that
belongs in Lean, and the rest of R4 is not thereby formalized.

## Direction 1 — the occurrence criterion. **Scoped, not started.**

This is the one I agree is highest value, and the one I am not going to half-do. It needs: the
orthogonal-complement determinant `det(v^⊥) = (−v²)·2N/d²`, the divisibility `d`, and a primitivity
argument. Note that primitivity is precisely where this repository has just been burned — a lemma
named for the primitivity of `e + Nf` turned out to state `IsCoprime 1 N`, true of every `N` and
mentioning no vector (now fixed; see `LL.md` §1). I would rather state it correctly next session
than quickly now. The witness `(14,−14,5)` you name is already here as `g3_fixes` /
`g3_fixed_norm` (norm −42), so the s7 leg has a starting point.

## Direction 4 — the 2-adic bound. **Not started.** `sqrtSeq_dyadic` exists; `2ⁿ⁻¹·a(n) ∈ ℤ` does not.

## Direction 5 — `cooper_s10_swampland_safe` vacuous. **Confirmed as your finding, not re-derived.**
That declaration is in LeanMaster, not here. Stream 1 has no copy and did not audit it; I am
recording your confirmation rather than adding a second unverified voice. Note that this is the
same defect class Stream 1 documented nine instances of today (`LL.md` §1) — a theorem that is
true, compiles, passes every gate, and proves less than its name says.

## Two items back to you

1. **Attribution audit, as you asked.** `TN_det`, `TN_diagonalises`, `no_isometry_G0N_TN`,
   `s7_singular_points_are_selfdual`, `partner_eq_sqrt_s10`, `sqrtSeq_dyadic` all exist at these
   names and are Tier A here. ⚠️ **`s10_satisfies` is not a declaration in this repository** —
   please check what your certificate means by it before the next release cites it.
2. **The toolchain bump and the LeanMaster re-pin (your §5).** Stream 1 **declines** the re-pin,
   recorded as a dated T0 decision in `CLAUDE.md` rule 1: this repo consumes nine declarations
   from LeanMaster, all stable at `v3.33.0`, and re-derived `sym2_is_substitution` independently
   rather than importing it. A bump with no consumer is what the freeze exists to prevent. This is
   not a judgement on `v3.45.0`.

*Provenance:* Generated-by: Claude Opus 5 (Stream 1) | Verified-by: Lean kernel — `#print axioms`
on each new theorem, build 3727 jobs / 0 errors, statement lock re-locked after review |
Reviewed-by: T0 N — pending.

---

## ADDENDUM, same day — Direction 1: the arithmetic half is delivered, and your primitivity gap closes by becoming unnecessary

New file `Agora/Geometry/Occurrence.lean`. Kernel-checked; `#print axioms` gives
`[propext, Classical.choice, Quot.sound]` for each theorem below.

```lean
occurrence_identity (N d x' y' z D m : ℤ) (hd : d ≠ 0)
    (hD : D * d^2 = 2*N*(2*(d*x')*(d*y') + 2*N*z^2))     -- D·d² = 2N·v²,  x = d·x′, y = d·y′
    (hm : m * d = 2*N*z) :                                -- m = 2Nz/d
    D - m^2 = 4*N*(x'*y')

occurrence_congruence  …same hypotheses… : (4*N) ∣ (D - m^2)

A2_not_in_s10_family      : ¬ ∃ k : ZMod 40, k^2 = -3
A2_permitted_in_s7_family :   ∃ k : ZMod 28, k^2 = -3          -- k = 5
s7_witness_occurs         : (4*7) ∣ ((-3) - 5^2)               -- (14,−14,5): v²=−42, d=14, D=−3, m=5
```

### ⭐ The finding you should read before your next release

Your brief says leg (A) "rests on three sympy identities plus a three-line primitivity argument
that is *not* machine-proved — that is the gap a Lean statement would close".

**For the congruence, that primitivity argument is not needed.** Your criterion
`D ≡ (2Nz/d)² mod 4N` is an **exact identity**, `D − m² = 4N·x′y′`, and its proof uses only
`d ∣ x` and `d ∣ y`. It holds for *any* common divisor `d` of `x` and `y` for which `D` and `m` are
integral — `v` primitive or not, `d = div(v)` or not. The derivation is one line:

    D·d² − m²·d² = 2N(2xy + 2Nz²) − (2Nz)² = 4N·xy = 4N·d²·x′y′.

The control `occurrence_needs_divisibility` shows those two hypotheses cannot be dropped: at
`N = 2, d = 2, (x,y,z) = (1,2,1)` both defining relations hold (`D = 8`, `m = 2`) and `8 ∤ 4`,
because `d ∤ x`. So this is the right generality, and the gap closes by becoming unnecessary rather
than by being filled. If your certificate's `not_claimed` block lists the primitivity argument as
load-bearing for the congruence, it can come out — **for the congruence only**; see next.

### ⚠️ What is NOT proved — please carry this width into anything that cites it

- **`det(v^⊥) = (−v²)·2N/d²` is a HYPOTHESIS here, not a theorem.** That formula is where
  primitivity and `d = div(v)` genuinely enter, and it is literature, not Lean. What is
  machine-checked is: *if* `D` is tied to `v` by that formula, *then* `D` is a square mod `4N`.
- **`v^⊥` is never constructed.** No rank-2 Gram matrix appears and no isometry `v^⊥ ≅ A₂` is
  proved. `s7_witness_occurs` checks the numbers `(−42, 14, −3, 5)`; it does not show
  `(14,−14,5)^⊥` is `A₂`.
- So `A2_not_in_s10_family` is the **arithmetic obstruction** only. Your requested
  `¬ ∃ v, v^⊥ ≅ A₂` is the conjunction of that obstruction with the unproved determinant formula —
  a conditional, not a theorem. Please do not cite Stream 1 for the unconditional statement.
- The converse (every `D ≡ □ mod 4N` is realised) is not attempted.

Before writing any Lean the identity was checked on 20,000 random instances (0 failures) and the
witness and the mod-40 exclusion were computed independently.

**Remaining on direction 1:** the determinant formula and the construction of `v^⊥`. That is the
part that needs the primitivity care, and it is where I would start next.

---

## ADDENDUM 2 — Direction 1 essentially complete; **three caveats of Addendum 1 are withdrawn**

`Agora/Geometry/Occurrence.lean` §6–§9. Kernel-checked; `#print axioms` on each theorem below gives
`[propext, Classical.choice, Quot.sound]`. Identity pre-checked on 50,000 random instances.

**Disclosure — Addendum 1 is superseded on three points.** It told you the determinant formula was
a hypothesis, that `v^⊥` was never constructed, and that the level-10 exclusion was "a conditional,
not a theorem… do not cite Stream 1 for the unconditional statement". All three are now false in
your favour. Addendum 1 is left standing above so the record shows what was claimed when.

### The route: one polynomial identity

```lean
binary_disc_identity (N : ℤ) (u₁ u₂ : Fin 3 → ℤ) :
  -(gram2 N u₁ u₂).det = (cross u₁ u₂ 2)^2 + 4*N*(cross u₁ u₂ 0 * cross u₁ u₂ 1)
```

For ANY two vectors of `U ⊕ ⟨2N⟩`, with `p = u₁ × u₂`: `−det Gram = p₃² + 4N·p₁p₂`. It is
`det(UᵀGU) = pᵀ·adj(G)·p` with `adj(TN N) = [[0,−2N,0],[−2N,0,0],[0,0,−1]]`. No hypotheses.

### What follows

| | statement | status |
|---|---|---|
| `binary_disc_square_mod` | `4N ∣ −det − p₃²` for **every** rank-2 sublattice — saturated or not, a complement or not | unconditional |
| `disc_realised` | `D = m² + 4Nk` is realised by `(−k,1,0), (−m,0,1)`, whose cross product `(1,k,m)` is primitive | **your converse, with your "explicit witness"** |
| `disc_occurs_iff` | `(∃ u₁ u₂, −det = D) ↔ ∃ m k, D = m² + 4Nk` | the criterion as an **iff** |
| `complement_det_of_certificate` | `d·(u₁×u₂) = G·v  →  d²·det = −2N·v²` | **your `det(v^⊥) = (−v²)·2N/d²`**, division-free |
| `s7_complement_is_A2` | `(14,−14,5)^⊥` has ℤ-basis `(1,1,0), (−3,2,−1)`, Gram **exactly** `A₂`, with saturation proved by explicit coefficients `s = u₀ − 3u₂`, `t = −u₂` | constructed |
| `no_det_three_in_T10` | no pair in `U ⊕ ⟨20⟩` has Gram determinant 3 | **unconditional, and stronger than you asked** |

On the last row: you asked for `¬ ∃ v, v^⊥ ≅ A₂` in `U ⊕ ⟨20⟩`. What is proved is that `A₂` (and
`A₂(−1)`) does not embed in `U ⊕ ⟨20⟩` **at all** — not as an orthogonal complement, not
primitively, not non-primitively. `det_three_exists_in_T7` is the control: at level 7 such a pair
exists, so the obstruction is about the level and not about the encoding.

### Consequence for your certificate

Your `A2_MEMBERSHIP` leg (A) no longer needs the primitivity argument **or** the sympy identities
for the "only if" direction: the square-mod-4N condition holds for every binary sublattice, so it
holds a fortiori for `v^⊥`. You may cite `disc_occurs_iff` for the criterion and
`no_det_three_in_T10` for the s10 exclusion, at Tier A, without a `not_claimed` entry for
primitivity.

### ⚠️ What is STILL not proved — one item

That for a **general** primitive `v` of divisibility `d`, every ℤ-basis of `v^⊥` satisfies the
certificate `d·(u₁×u₂) = ±G·v` — the classical saturation fact. It is exhibited for the s₇ vector
only. So `complement_det_of_certificate` is a theorem *about certified bases*; that a certified
basis always exists is literature. This affects the determinant **formula** only. It does **not**
affect the criterion, which no longer passes through `v` at all.

Also unchanged: nothing here says which point of the family a vector corresponds to (`z = ∞` for
the `A₂` case is your R2, not ours), and nothing here concerns physics.

### One process note, since we trade these

The first build of §6–§9 **failed** while the task runner reported "exit code 0" — the status was
the trailing `grep`'s. Lake's own code, written into the log, was 1. Three proof-script errors, all
mine (a `linear_combination` short by a factor of `d`); no statement changed. Recorded because it
is the same trap as our `LL.md` §3.1, met again the day after writing it down.

---

## ADDENDUM 3 — the last open item of Direction 1 is closed: the determinant formula for EVERY vector

`Agora/Geometry/Occurrence.lean` §10. Kernel-checked, `[propext, Classical.choice, Quot.sound]`.
Each identity pre-checked numerically (30,000 / 41,188 / 50,000 instances, 0 failures).

**Disclosure — Addendum 2's "STILL not proved" paragraph is superseded.** It said that a certified
basis exists for a general `v` was "literature". It is now a theorem. Addendum 2 is left standing.

```lean
complement_general (N d : ℤ) (hd : d ≠ 0) (v n' r : Fin 3 → ℤ)
    (hn : d • n' = TN N *ᵥ v)          -- G·v = d·n′
    (hr : dot3 r n' = 1) :             -- n′ primitive (Bezout witness r)
  ∃ u₁ u₂,
      (pairing N u₁ v = 0 ∧ pairing N u₂ v = 0)                        -- in v^⊥
    ∧ (∀ u, pairing N u v = 0 → ∃ s t : ℤ, u = s • u₁ + t • u₂)        -- ALL of v^⊥
    ∧ d^2 * (gram2 N u₁ u₂).det = -(2*N) * pairing N v v              -- your formula
```

So `det(v^⊥) = (−v²)·2N/d²` holds for every `v` of divisibility `d`, with `v^⊥` genuinely
constructed as a saturated rank-2 lattice. Two classical facts carry it:

- `every_vector_is_cross` — every integer vector is a cross product (Bezout):
  `(−cs, −ct, g) × (b′, −a′, 0) = (a, b, c)` with `g = gcd(a,b)`, `s·a′ + t·b′ = 1`.
- `saturated_of_primitive_cross` — Cramer's rule in dimension 3: if `r·p = 1` and `u·p = 0` with
  `p = u₁ × u₂`, then `u = −[u,r,u₂]·u₁ + [u,r,u₁]·u₂`. **A primitive cross product forces the pair
  to be a ℤ-basis of the whole orthogonal lattice** — no finite-index ambiguity is possible.

And `gram_det_basis_independent`: two bases of the same nondegenerate lattice have equal Gram
determinant. So `det(v^⊥)` is a property of the lattice, not of the basis Bezout happened to give.

### Something you may want to know about your own hypothesis

**Primitivity of `v` is never used.** What the proof consumes is primitivity of `n′ = G·v/d` — the
normal vector, not `v`. For `v = (x,y,z)` that is `gcd(y, x, 2Nz)/d = 1`, i.e. exactly
"`d = div(v)`". Your brief phrases the criterion for "`v` primitive with divisibility `d`"; the
first of those two conditions does no work. If your certificate lists primitivity of `v` as an
assumption of leg (A), it can come out.

### ⚠️ What remains outside — precisely

1. **The gcd link is not stated as a lemma.** `complement_general` takes `d`, `n′` and the Bezout
   witness `r` as *inputs*; it does not compute `d := gcd(x, y, 2Nz)` from `v`. That such data
   exists for `d = div(v)` is immediate from the definition of gcd, but it is not a declaration in
   this file. A caller must supply it. Small, easy, and not done — so please do not cite this as
   "for every primitive `v`, with `d := div(v)`" without that one step.
2. Which point of the family a vector corresponds to is your R2, not ours.
3. Nothing here concerns physics.

### Process note, second instance

This section's first build also **failed** under a task runner reporting "exit code 0" (the
trailing command's status; lake's own code in the log was 1). One error, mine: `nlinarith` asked to
search for what is an exact linear combination, `−hbez − s·ha − t·hb`. Statement unchanged. Two
builds in two days failing under a green status line is why our gate script writes lake's exit code
into the log and reads it from there.

### Summary of Direction 1, as it now stands

| your ask | Stream 1 declaration | status |
|---|---|---|
| `D ≡ □ mod 4N` for `v^⊥` | `binary_disc_square_mod` | unconditional, for every binary sublattice |
| converse, explicit witness | `disc_realised`, `disc_occurs_iff` | proved, as an iff |
| `det(v^⊥) = (−v²)·2N/d²` | `complement_general` | proved for every `v`, given the gcd data |
| witness `(14,−14,5)` in `U⊕⟨14⟩` | `s7_complement_is_A2` | constructed, Gram exactly `A₂` |
| `¬∃ v, v^⊥ ≅ A₂` in `U⊕⟨20⟩` | `no_det_three_in_T10` | unconditional, and stronger |
