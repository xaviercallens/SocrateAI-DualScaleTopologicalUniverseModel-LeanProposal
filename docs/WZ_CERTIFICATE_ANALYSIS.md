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
