# D1 Gate Step 2: Deep Think CAS Verification Request

**From:** Stream 1 (Opus 4.8, theory)  
**To:** Deep Think (T0s, CAS authority)  
**Date:** 2026-07-24  
**Deadline:** 2026-07-25 (non-critical path, but blocks S1-08 Lean proof)  
**Status:** ⏳ AWAITING DEEP THINK CONCURRENCE (two-model rule, gate condition for Opus encoding)

---

## The Task (Exact & Bounded)

Independently re-derive the **cleared-denominator polynomial identity** `P_cleared(z)` equivalent to the Almkvist–van Straten self-adjointness criterion `W ≡ 0` for the **generic Cooper operator** (Gorodetsky arXiv:2102.11839 eq 1.7, symbolic `a,b,c,d`).

**You must do this WITHOUT copying Fable's derivation** — this is the "two-model rule" gate. Independent re-derivation in your CAS (Mathematica, Sage, Macaulay2, your choice).

---

## Input: The Cooper Family (Generic)

**Theta-form Picard-Fuchs operator (Gorodetsky arXiv:2102.11839 eq 1.7):**

```
L = θ³ − z(2θ+1)(aθ² + aθ + b) + z²(c(θ+1)³ + d(θ+1))
```

where:
- θ = z·d/dz (Euler operator)
- a, b, c, d are **symbolic parameters** (generic family)
- No numerical substitution

**Your task:**
1. Convert this to **D-form** (standard d/dz derivative): `L = p3·D³ + p2·D² + p1·D + p0`
2. Compute the **monic normalized coefficients**: `aᵢ = pᵢ/p3`
3. Substitute into the **Almkvist–van Straten self-adjointness criterion**:
   ```
   W = (1/3)a₂″ + (2/3)a₂·a₂′ + (4/27)a₂³ + 2a₀ − (2/3)a₁·a₂ − a₁′
   ```
4. **Clear denominators**: multiply by the exact common denominator (find it!)
5. Output: the resulting pure polynomial `P_cleared(a,b,c,d,z)` in expanded form

---

## Reference: Fable's Output (For Comparison, Not Copying)

**Location:** `briefs/D1_P_CLEARED_FABLE_2026-07-24.md` + `scripts/derive_D1_P_cleared.py`

**Fable's claimed results:**

### D-form coefficients (generic):
```
p3 = z³·(1 − 2az + cz²)
p2 = 3z²·(1 − 3az + 2cz²)
p1 = z·(1 − (6a+2b)z + (7c+d)z²)
p0 = z·(−b + (c+d)z)
```

**Sanity check:** Fable claims `a₂ = p2/p3 = 3(1−3az+2cz²)/(z(1−2az+cz²))`, which matches literature.

### Cleared identity (Fable's claim):

```
P_cleared := 9·(p2″p3² − p2·p3·p3″ − 2p2′p3·p3′ + 2p2·(p3′)²)
           + 18·p2·(p2′p3 − p2·p3′)
           + 4·p2³
           + 54·p0·p3²
           − 18·p1·p2·p3
           − 27·p3·(p1′p3 − p1·p3′)
```

**Equivalence claim (verify this!):** In ℚ(a,b,c,d,z), `W = P_cleared/(27·p3³)` with `p3 ≠ 0` → `W ≡ 0 ⇔ P_cleared ≡ 0`.

---

## Acceptance Criteria (All Must Pass)

### ✅ Criterion 1: Independently Derived D-form

**You must provide:**
- p3, p2, p1, p0 as polynomials in ℚ[a,b,c,d][z]
- State any transformations if your form differs from Fable's

**Verification:** Does your p0, p1, p2, p3 match Fable's (up to algebraic equivalence)?

### ✅ Criterion 2: Clearing Multiplier

**You must identify:**
- The exact common denominator needed to clear fractions from W
- Expected: `27·p3³` (but compute it independently)
- If different: provide justification

**Verification:** Does your multiplier match 27·p3³?

### ✅ Criterion 3: Cleared Polynomial P_cleared

**You must provide:**
- The explicit, expanded form of P_cleared(a,b,c,d,z)
- Every term listed
- Coefficients in ℚ

**Verification:**
1. Does P_cleared expand to exactly **ZERO** for generic a,b,c,d? (the D1 claim)
2. Is P_cleared/(27·p3³) − W identically zero in ℚ(a,b,c,d,z)? (equivalence)

### ✅ Criterion 4: Negative Control (Detector Test)

**You must test:** A non-Cooper operator (provide your own or use Fable's example)
```
p₃=1, p₂=z²+1, p₁=z+2, p₀=z³
```

**Computation:** Apply the same clearing formula to this non-self-adjoint operator.

**Verification:** Does P_cleared ≠ 0 for this control? (Yes = detector works, No = flawed)

### ✅ Criterion 5: Algebraic Equivalence Check

**For each concrete candidate (s7, s10, s18), substitute:**
- s7: (a,b,c,d) = (13, 4, −27, 3)
- s10: (a,b,c,d) = (6, 2, −64, 4)
- s18: (a,b,c,d) = (14, 6, 192, −12)

**Verify:** P_cleared evaluates to exactly **ZERO** at each candidate.

---

## Deliverable Format

**Create:** `briefs/D1_DEEPTHINK_VERIFICATION_2026-07-24.md`

**Structure (use this template):**

```markdown
# D1 Gate Step 2 Verification: Deep Think CAS Re-derivation

**Status:** ✅ VERIFIED / ❌ DISCREPANCY

**CAS used:** [Mathematica / Sage / Macaulay2 / other]

## Independently Derived Results

### D-form coefficients
- p3 = [your polynomial]
- p2 = [your polynomial]
- p1 = [your polynomial]
- p0 = [your polynomial]

### Clearing multiplier
[Your multiplier] — justification if different from 27·p3³

### P_cleared (full expansion)
[Your polynomial expression, all terms]

## Verification Results

| Check | Result | Status |
|---|---|---|
| P_cleared ≡ 0 (generic a,b,c,d) | [YES/NO] | ✅/❌ |
| P_cleared/(27p3³) − W ≡ 0 (equivalence) | [YES/NO] | ✅/❌ |
| Negative control P_cleared ≠ 0 (non-Cooper) | [YES/NO] | ✅/❌ |
| s7 (13,4,-27,3): P_cleared = 0 | [YES/NO] | ✅/❌ |
| s10 (6,2,-64,4): P_cleared = 0 | [YES/NO] | ✅/❌ |
| s18 (14,6,192,-12): P_cleared = 0 | [YES/NO] | ✅/❌ |

## Comparison with Fable

**Fable's D-form:**
- p3 = z³·(1 − 2az + cz²)
- p2 = 3z²·(1 − 3az + 2cz²)
- p1 = z·(1 − (6a+2b)z + (7c+d)z²)
- p0 = z·(−b + (c+d)z)

**Your D-form:**
[Copy your polynomials here]

**Assessment:** Match / Equivalent / Divergent [with explanation]

## Conclusion

[State concurrence or discrepancy. If discrepant, provide exact difference.]

**Gate outcome:** ✅ GATE STEP 2 PASS / ❌ REQUIRES RESOLUTION

**Timestamp:** [ISO 8601]
```

---

## Why This Matters

**Gate condition (binding):**
- ✅ If verified: Opus encodes L₃ = Sym²(L₂) in Lean via `ring` tactic (S1-08, 2–3 hours)
- ❌ If divergent: Investigation required; S1-08 stays blocked until resolved

**Scope:** This is the **final verification gate** before Lean encoding. Two-model rule is complete once you concur.

**Criticality:** Not on Stream 2 critical path (C1/C2/physics proceed independently), but needed to close Stream 1.

---

## Quick Start (For Your CAS)

**Pseudocode (Sage/Python):**

```python
from sympy import symbols, expand, diff, simplify, factor, cancel

a, b, c, d, z = symbols('a b c d z')

# Step 1: Define p0, p1, p2, p3
p3 = z**3 * (1 - 2*a*z + c*z**2)
p2 = 3*z**2 * (1 - 3*a*z + 2*c*z**2)
p1 = z * (1 - (6*a + 2*b)*z + (7*c + d)*z**2)
p0 = z * (-b + (c + d)*z)

# Step 2: Monic coefficients
a2 = p2 / p3
a1 = p1 / p3
a0 = p0 / p3

# Step 3: Almkvist–van Straten W
W = (1/3) * diff(a2, z, 2) + (2/3) * a2 * diff(a2, z) + (4/27) * a2**3 + 2*a0 - (2/3) * a1 * a2 - diff(a1, z)

# Step 4: Clear denominators (multiply by 27*p3^3)
P_cleared = expand(27 * p3**3 * W)

# Step 5: Verify P_cleared ≡ 0
print("P_cleared (generic):", simplify(P_cleared))

# Step 6: Test on s7
s7_result = P_cleared.subs([(a, 13), (b, 4), (c, -27), (d, 3)])
print("s7 test:", simplify(s7_result))
```

---

## Contact & Questions

If you have questions about the derivation:
- Ask Fable (original derivation) for clarification on the literal steps
- Ask Opus (theory owner) for context on why this criterion matters
- **But do NOT copy Fable's work** — re-derive independently in your CAS

**Submit result:** Create PR with `briefs/D1_DEEPTHINK_VERIFICATION_2026-07-24.md`, or comment in ESCALATIONS.md E-006.

---

## Timeline & Impact

**Your ETA:** 2026-07-25 (parallel to Stream 2 Phase 1, no rush)

**Opus blocks on:** Your concurrence message in ESCALATIONS.md E-006 saying "✅ Gate step 2 PASS"

**Then (2–3h after your signal):** Opus fills SymSquareC3b.lean, runs `ring` proof, commits.

---

**Generated-by:** Opus 4.8 (Stream 1 theory owner)  
**Authority:** Xavier Callens (T0, two-model rule enforcer)  
**Gate:** Binding verification (no Lean proof without your sign-off)
