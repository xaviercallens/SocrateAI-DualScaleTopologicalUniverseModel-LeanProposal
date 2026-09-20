# `open_goal_partner_eq_sqrt_s7` is CLOSED — and the `blocked-on-mathlib` ruling was wrong

**Date:** 2026-09-20 · **Status:** kernel-proved, independently re-verified, landed on
`feature/close-bridge-goal`. **The repository now has ZERO `sorry`.**

---

## 1. The result

```lean
theorem Agora.Sequences.SqrtBridge.partner_eq_sqrt_s7 :
    ∀ n, partnerSeq s7_params n = FormalSqrt.sqrtSeq (fun k => (s7 k : ℤ)) n
```

The recurrence-defined order-2 partner of Cooper's s₇ **is** the formal square root of the s₇
generating series, at every index. Unconditional, all `n`.

This is the bridge that makes the kernel-proved *operator-level* theorem `L₃ = P₂·Sym²(L₂)` bite
at the level of **sequences**. `Agora/Sequences/SqrtBridge.lean`, 8 theorems, 0 `sorry`.

Axioms: `propext`, `Classical.choice`, `Quot.sound` — Lean's own only. **No `native_decide`, no
`sorryAx`, and it does not use `Axioms.obrien2016_theorem6_2`.**

---

## 2. Verification chain — producer ≠ verifier, twice

This program has caught fabricated "verified" claims three times, twice from the producing agent
itself. So the result was checked at three independent levels.

1. **Producing agents** (workflow Attempt phase) compiled each lemma and pasted literal
   `lake env lean` output.
2. **Workflow verifier agent** re-ran every claimed success from the files on disk, built its own
   statement lock, and ran a negative control.
3. **Session main loop (this report)** did not trust either. It rebuilt the lock from scratch:

```lean
-- in a file that ALSO imports the repo's real, sorry-carrying OpenGoals module
theorem MY_repo_statement_lock :
    @Agora.Sequences.OpenGoals.open_goal_partner_eq_sqrt_s7
      = @Attempt3.open_goal_partner_eq_sqrt_s7 := rfl
```
`Eq` is homogeneous, so this elaborates **only** if the two types are definitionally equal; `rfl`
then closes by proof irrelevance. A weakened statement cannot pass it. → **exit 0.**

**Negative control** (the step that makes the lock meaningful): the same file with the target
perturbed to index `n+1`. → **exit 1, `error: Type mismatch` at exactly the lock line.**
The lock discriminates. It is not a check that cannot fail.

**Final gate, on the library itself** (not a scratch file):
```
'Agora.Sequences.OpenGoals.open_goal_partner_eq_sqrt_s7' depends on axioms:
  [propext, Classical.choice, Quot.sound]
```

Repo gates after landing: `lake build Agora OpenGoals Tests` → **3171 jobs, 0 errors, 0 `sorry`
warnings**; statement lock **OK, no existing statement changed** (310 locked in 27 files);
axiom audit **176 theorems, 3 failing** — the same three pre-existing registered-axiom
dependencies, unchanged.

> One discrepancy, recorded for honesty: the workflow's report cited a file
> `wf/verify/lock_verify.lean` that **does not exist on disk**. Its *conclusion* reproduced when
> I rebuilt the lock myself, so the result stands — but the citation was to a file that was not
> there, which is exactly why level 3 exists.

---

## 3. Why it was open — the methodological finding

The goal carried **four recorded failed strategies** and a T0 `blocked-on-mathlib` ruling, on the
stated grounds that Mathlib had no `PowerSeries` square root and no D-finite/holonomic API.

**Both absences are real. Neither matters.** The proof uses only `PowerSeries.mk`, `coeff_mul`,
`Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk`, `isUnit_iff_constantCoeff`,
`PowerSeries.instNoZeroDivisors` and `Finset.sum_range_reflect` — every one present at the pinned
commit, **and at the previous v4.32.0 pin too**. Nothing was missing from Mathlib. The migration
did not unblock this; it was never blocked.

The four strategies were never *refuted* — they were **routed around**. The missing idea:

| Step | Lemma | What it replaces |
|---|---|---|
| 1 | `conv_symm` — a convolution sum may be symmetrized in its two indices, via `Finset.sum_range_reflect` | the "Leibniz rule for convolution" strategy 2 expected to need |
| 2 | `conv_cooper_of_rec` — **the crux.** If `a` satisfies the order-2 partner recurrence, `a ⋆ a` satisfies Cooper's order-3 recurrence exactly. Three symmetrized kernels, one `linear_combination`. | the solution-level Sym² transport that strategy 2 assumed was a WZ-certificate problem. It is not, at the coefficient level. |
| 3 | `cooper_unique` — same order-3 recurrence + same first two values ⇒ equal. Strong induction; `(n+2)³ ≠ 0` over ℚ. | — |
| 4 | square-root uniqueness in `ℚ⟦X⟧` (constant coeff 1, equal squares, domain) | the absent `PowerSeries.sqrt` |

**The lesson, and this is the second time on this very file.** `open_goal_partner_integral_s7`
was also ruled `blocked-on-mathlib`, also wrongly — closed by citing O'Brien. Twice now the label
described **a proof route, not a goal**. `n` failed strategies are evidence about those `n`
strategies and nothing more. Before accepting such a ruling: name the specific absent declaration,
and check the goal actually needs it.

---

## 4. What this gives, stated precisely

**DOES:** `sqrtSeq_dyadic` now transports — `SqrtBridge.partner_s7_dyadic` proves the s₇ partner
lies in ℤ[1/2] for **every** `n`, upgrading the old PASS(59) observation to a theorem and
excluding every odd prime.

**DOES NOT:** discharge `Axioms.obrien2016_theorem6_2`. `IsDyadic` means "denominator a power of
2", which is **not** integrality. The axiom remains the sole support for
`open_goal_partner_integral_s7`. This result reduces that goal to a purely 2-adic statement; that
statement is open and was **not attempted**. Do not cite this as discharging the axiom.

**Tier note:** this is Tier A and changes nothing about Tier B or Tier C. It is a statement about
sequences and operators. It supplies no physical coupling (VISION §1.3), and the Tier C block
(F5b) is untouched.

---

## 5. What LeanMaster contributed: nothing — and two findings about why

**Not one theorem, not one technique.** No LeanMaster module appears in any dependency path of the
proof. Recon searched all ten libraries (150 files, 760 declarations): zero hits for `PowerSeries`,
convolution, Cauchy product, `sum_bij`, strong induction. The 133 `θ` hits are orientifold Gram
matrices, not the Ramanujan θ operator. What exists (`mulTrunc`/`divTrunc`/`Ser` in
`DualScaleMoonshine`) is finite, ℤ-valued and `decide`d, with no algebraic lemma proved about it —
so it cannot support a `∀n` claim. **This is a real finding about the corpus's scope, not a failure
of the attack.**

Two traps found while establishing that, both of which will mislead the next session:

- **LeanMaster's declaration index is not trustworthy for coverage questions.**
  `.leancache/declarations.db` (900 rows) does not cover the modules holding the series machinery:
  querying it for "series" returns only `VertexOperators`, while `DualScaleMoonshine.QSeries` and
  `.Shadow` appear for no keyword. A session using the index — which is what the
  `leanmaster-theorem-search` skill does — will see nothing and conclude the corpus was searched.
  **Grep over the ten library directories is the ground truth.** (Do not grep from the repo root:
  it descends into `.lake` and hangs.)
- **"The corpus was searched" was not true as written.** The fetched v3.33.0 dependency also ships
  `lean4basesource/`, containing **127,584 `.lean` files** (904 with `sorry`), including a large
  modular-curve tree. It is *not* referenced in LeanMaster's lakefile, so it is not a lake target
  and not importable as configured — an unsearched region with a known reason for being unsearched.
  No claim is made here about whether it would have helped.

---

## 6. For the next session

1. **The 2-adic remainder** is now the only thing between the repo and discharging
   `obrien2016_theorem6_2`. `partner_s7_dyadic` has done the odd-prime half unconditionally. This
   is a well-posed, bounded question and is the highest-value open item.
2. **Re-examine the other `blocked-on-mathlib` judgements** in this repo with the §3 test. The
   label has now been wrong twice on this file alone.
3. **`conv_cooper_of_rec` is generic in shape.** It is stated for s₇'s specific coefficients, but
   the symmetrization argument does not obviously depend on them — generalizing it to the
   four-parameter Cooper template would make the Sym² transport available for s₁₀ and s₁₈ too.

---

Generated-by: Claude Opus 5 (1M context), Stream 1 session 2026-09-20; proof produced by a 9-agent
workflow (recon → lemma DAG → kernel-checked attempts → adversarial verification) |
Verified-by: Lean kernel — independent statement lock built by the session main loop against the
repository's own declaration, **with a passing negative control**; `lake build` 3171 jobs/0 errors/
0 sorry; `axiom_audit.py` 176 audited; `#print axioms` on the library declaration shows the three
standard axioms only |
Reviewed-by: T0 **N** — not yet reviewed. §3's claim that a T0 `blocked-on-mathlib` ruling was
wrong is a finding for T0 to confirm.
