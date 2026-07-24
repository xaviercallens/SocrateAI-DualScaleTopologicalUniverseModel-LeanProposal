# Stream 2 → Stream 1: Prove L₃ = Sym²(L₂) for Cooper s7/s10

**From:** Stream 2 (K3 Selection, C3b checker)  
**To:** Stream 1 (Opus 4.8 executor · Fable 5 math design)  
**Date:** 2026-07-24  
**Status:** OPENED — awaiting Fable's operator output + Deep Think concurrence  
**Tier trajectory:** [B, PASS(58)] → [A] (all-n proof)  
**Criticality:** not on critical path for D-3; unblocks C3b upgrade post-freeze

---

## 1. What Stream 2 Established (Epistemic status: [B, PASS(58)])

### Cooper s7 (OEIS A183204, order-3 bulk operator)

From the frozen recurrence in `refs/cooper_s7_bulk.txt`, Stream 2 extracted an order-2 partner:

```
Recurrence (n+1)² fₙ₊₁ = (26n² + 13n + 2)fₙ + 3(3n−1)(3n−2)fₙ₋₁

Partner sequence: f = [1, 2, 22, 336, 6006, 117348, …] (OEIS A279619)
Closure: verified exact nullspace fit on n ≤ 26, re-validated to n = 58
Mirror-map agreement: z(L₂)(q) = z(L₃)(q) to q¹⁴ (exact, not approximate)
```

### Cooper s10 (OEIS A005260, order-3 bulk operator)

```
Recurrence: (n+1)² fₙ₊₁ = (12n² + 6n + 1)fₙ + (8n−5)(8n−3)fₙ₋₁

Partner sequence: f rational (denominators powers of 2)
Closure: verified exact nullspace fit on n ≤ 26, re-validated to n = 58
Mirror-map agreement: z(L₂)(q) = z(L₃)(q) to q¹⁴ (exact)
```

**The gap:** "validated to n=58" is a finite-order machine check (Tier B), not a proof for all n. The order-2 recurrence was **fitted** (nullspace extraction), not **derived** — a fit is sufficient for certificate evidence but not for Tier A.

**Why this matters:** if `L₃ = Sym²(L₂)` holds as a differential-operator identity over ℚ(z), then the holomorphic MUM solution `g` of `L₃` is necessarily `g = f²` (where `f` satisfies `L₂`). This discharges the all-n content: the finite checks become *consequences* of the structural identity, retroactively justifying the n=58 validation and the mirror-map agreement.

---

## 2. The Claim to Prove (Tier-A target)

**Theorem (to formalize in Lean):**
```
For cooper_s7 and cooper_s10:
  L₃ = Sym²(L₂)  (equality as differential operators over ℚ(z))
```

where:
- **L₃** = the bulk order-3 Picard–Fuchs operator (from the frozen recurrence in `refs/`)
- **L₂** = the order-2 partner operator (from the extracted recurrence above)
- **Sym²** = the symmetric-square construction (order-2 → order-3, by the classical formula)

**Consequence (automatic if theorem holds):**
- If `g` is the holomorphic MUM solution of `L₃`, then `g = f²` where `f` is the holomorphic solution of `L₂`.
- This implies `z(L₂)(q) = z(L₃)(q)` structurally (Sym² preserves the nome).
- All finite checks (n ≤ 58) become *instances* of the general identity, not independent evidence.

---

## 3. Recommended Proof Route (Reuses D1 Option-B Machinery)

### Phase 1: Recurrence → Operator (Fable 5 subtask)

**Input:** the frozen recurrences (as coefficients in `refs/cooper_s{7,10}_bulk.txt` and extracted partner recurrences).

**Output:** explicit differential operators with cleared-denominator polynomial coefficients.

1. **For L₃ (order-3 bulk):** starting from the Cooper three-term recurrence template
   ```
   (n+1)³·u(n+1) = (2n+1)(a·n² + a·n + b)·u(n) − n·(c·n² + d)·u(n−1)
   ```
   with concrete `(a,b,c,d)` for s7 and s10, convert to the differential operator
   ```
   L₃ = θ³ + a₂(z)·θ² + a₁(z)·θ + a₀(z)  [θ = z d/dz]
   ```
   Emit with polynomial coefficients (clear any denominators).

2. **For L₂ (order-2 partner):** starting from the extracted two-term recurrence
   ```
   (n+1)²·fₙ₊₁ = p₁(n)·fₙ + p₀(n)·fₙ₋₁
   ```
   with concrete coefficients from s7/s10 partners, convert to
   ```
   L₂ = θ² + b₁(z)·θ + b₀(z)
   ```
   with polynomial coefficients.

3. **Deliver:** explicit `L₃` and `L₂` for each sequence (sympy or TeX form).

### Phase 2: Symbolic Sym² Computation (Fable 5 + checker)

**Input:** explicit `L₂` operators.

**Computation:** for `L₂ = θ² + b₁(z)·θ + b₀(z)`, compute the symmetric square (the order-3 operator annihilating products of L₂-solutions). Standard formula exists in the literature (e.g., Almkvist–van Straten arXiv:2103.08651, but applied backwards: compute Sym² from a given L₂).

**Output:** explicit `Sym²(L₂)` as an order-3 operator with polynomial coefficients (cleared denominators).

### Phase 3: Operator Equality → Polynomial Identity (Opus 4.8 + Deep Think)

**Exactly the D1 pattern:**

1. **Fable:** deliver both `L₃` and `Sym²(L₂)` with cleared-denominator polynomial coefficients.

2. **Deep Think:** independently verify Sym² computation (or re-derive `L₂` from the recurrence and recompute Sym² in your CAS).

3. **Opus:** form the polynomial identity `P(z) := Sym²(L₂) − L₃` (coefficient-wise), then prove `P(z) ≡ 0 in Polynomial ℚ` using the `ring` tactic (or `native_decide`, disclosed per guardrails).

4. **On success:** 
   - Commit with `Discharges: C3b_L3_sym2_L2_s7, C3b_L3_sym2_L2_s10`.
   - Update `data/certificates/C3b_symsqrt_cooper_s{7,10}.json` verdict from `PASS(58)` to `PROVED_LEAN` (reference the lake build number and commit hash).
   - Set repo state `SYM2_PROVED_C3B` for both s7 and s10.

---

## 4. Scope Guards (Non-Negotiable)

| Scope | Status | Reason |
|---|---|---|
| **s7, s10** | ✅ IN SCOPE | recurrences valid, partners extracted, certified data exists |
| **s18** | ❌ OUT OF SCOPE | `gorodetsky_s18` recurrence is **corrupt** (transcription error from arXiv); do NOT run this task on s18. Re-transcribe from arXiv:2102.11839 v2 p.3 before any s18 Sym² work. |
| **Physics in theorem** | ❌ FORBIDDEN | The Lean theorem states ONLY the operator identity. L₂-as-brane, bulk↔brane coupling, brane embedding — these are [C] tier conjectures, not proven theorems. No physics claims in the Lean statement or theorem name. (See feedback [[feedback_k3_rigor]]: no physics-washing.) |
| **s10 integral partner** | ✅ OK (rational) | s10's extracted partner f has rational (non-integral) entries. The operator identity `L₃ = Sym²(L₂)` is well-posed over ℚ(z); integrality of the sequence is not required for the proof. |

---

## 5. Deliverables & Acceptance

| Deliverable | Owner | Acceptance |
|---|---|---|
| Explicit `L₃, L₂` operators (polynomial coefficients, cleared denoms) | Fable 5 | output posted, syntax verified |
| Independent `Sym²(L₂)` verification or re-derivation | Deep Think | CAS output posted, algebraically matches Fable's |
| Lean theorem `L₃ = Sym²(L₂)` for s7 + s10 | Opus 4.8 | compiles, `ring` discharge, no sorries |
| Commit + certificate updates | Opus 4.8 | hash-pinned, Discharges footer, C3b verdict upgraded |

---

## 6. Timeline & Blocking

**Prerequisite:** D1 (P_cleared concurrence) unrelated, but uses same pattern → can proceed in parallel once Fable posts `L₃, L₂`.

**Estimated effort (if all CAS verifications align):**
- Fable derivation: 1–2 hours (operator extraction, Sym² symbolic computation)
- Deep Think verification: 1–3 hours (independent CAS, match-check)
- Opus Lean encoding: 2–4 hours (formalize recurrence→operator, state identity, `ring` discharge)

**Not on critical path:** this unblocks C3b upgrade but does NOT gate v0.4 release or any Stream-2-facing deliverables.

---

## 7. Related Context

- **D1 parallel task:** `briefs/D1_P_CLEARED_FABLE_2026-07-24.md` — same Option-B pattern (clear denoms, polynomial identity, `ring` proof).
- **Stream 2 artifact:** `data/certificates/C3b_symsqrt_cooper_s{7,10}.json` (current verdict: `PASS(58)`; target verdict: `PROVED_LEAN`).
- **Scope guards:** feedback [[feedback_k3_rigor]] on no physics-washing in Lean; [[s1_constraints]] on axiom budget.
- **Recurrence sources:** `refs/cooper_s7_bulk.txt`, `refs/cooper_s10_bulk.txt`, extracted partners (links pending from Stream 2 commit 3b6064b).

---

**Generated-by:** Stream 2 (K3 Selection handoff)  
**Transcribed-by:** Opus 4.8  
**Reviewed-by:** pending (Fable, Deep Think, Opus gate sequence)
