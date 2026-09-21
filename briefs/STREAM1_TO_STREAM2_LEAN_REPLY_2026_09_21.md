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
