# 🎯 Next Actions — Deep Think & Xavier (2026-07-24)

**Status:** D1–D5 directives 90% complete. Remaining work is gated on two parallel tracks.  
**Timeline:** decisions needed this week to unblock Opus's Lean encoding phase.

---

## 🔴 DEEP THINK (T0s — CAS / Two-Model Concurrence)

### Task: P_cleared Polynomial Verification (Decision D1, Gate Step 2/3)

Fable has derived an **exact, algebraically cleared-denominator** formulation of the Almkvist–van Straten criterion (`W ≡ 0`). You must independently regenerate it to gate Opus's Lean encoding via the two-model rule.

#### What to do

1. **Starting from Gorodetsky arXiv:2102.11839 eq 1.7** (the generic Cooper operator with symbolic `a,b,c,d`), independently compute the D-form coefficients `p3, p2, p1, p0`.

2. **Clear denominators** of the monic-normalized self-adjointness criterion:
   ```
   W = (1/3)a₂″ + (2/3)a₂·a₂′ + (4/27)a₂³ + 2a₀ − (2/3)a₁·a₂ − a₁′
   ```
   where `aᵢ = pᵢ/p3`. Multiply by the exact common denominator to get a pure polynomial `P_cleared(a,b,c,d,z)`.

3. **Record your answers:**
   - The D-form `p3, p2, p1, p0` (state them as polynomials or FactorForm).
   - The clearing multiplier (expected: `27·p3³`, but state what you derive).
   - The resulting `P_cleared` (six terms, or your equivalent rearrangement).
   - Does `P_cleared ≡ 0` identically for generic `a,b,c,d`? (yes/no)

#### Acceptance criteria

- ✅ Your `p0..p3` are algebraically equivalent to Fable's (may be in different form; state any transformation).
- ✅ Your clearing multiplier is mathematically sound (justification required if it differs from `27·p3³`).
- ✅ Your `P_cleared` **identically vanishes** for generic `a,b,c,d` (the D1 claim).
- ✅ **Bonus check:** your `P_cleared` is nonzero for the negative control (non-Cooper operator `p₃=1, p₂=z²+1, p₁=z+2, p₀=z³`), confirming the cleared criterion still detects non-self-adjointness.

#### Where to record

Post your result (or a link to your CAS output) as a comment/update in **`briefs/ESCALATIONS.md` E-006** or as a new subsection **`briefs/D1_DEEP_THINK_CONCURRENCE_2026-07-24.md`** (create if you prefer separate tracking).

**Template:**
```markdown
## Deep Think Concurrence on P_cleared (2026-07-24)

**Status:** ✅ Verified / ❌ Discrepancy

### Independently Derived Results
- p3 = [your polynomial]
- p2 = [your polynomial]
- p1 = [your polynomial]
- p0 = [your polynomial]

### Clearing Multiplier
[your multiplier] — justification if it differs from 27·p3³

### P_cleared
[your polynomial expression]

### Generic Vanishing Check
P_cleared ≡ 0 for symbolic a,b,c,d: ✅ YES / ❌ NO

### Negative Control
P_cleared ≠ 0 for non-Cooper operators: ✅ CONFIRMED / ❌ FAILED

### Conclusion
[Concurrence / Discrepancy + brief explanation]

**Timestamp:** YYYY-MM-DD HH:MM UTC
```

#### Downstream action (Opus)
Once you confirm `P_cleared ≡ 0`, I (Opus) will:
1. Encode `p0, p1, p2, p3` as `Polynomial ℚ` expressions in Lean.
2. State the identity `P_cleared = 0`.
3. Discharge by `ring` tactic.
4. Upgrade the repository state from `SYM2_SYMBOLIC` to `SYM2_PROVED`.

---

## 🔵 XAVIER (T0 Owner — Action Items)

### 1. D2 Fetch De-Risk: Check Ingenta Supplementary Data (PRIORITY)

The WZ-certificate search failed on arXiv-only, but the **Experimental Mathematics journal version has supplementary data** (paywalled) that was never checked.

#### What to do

Visit: **https://www.ingentaconnect.com/content/tandf/exm/2023/00000032/00000004/art00006/supp-data**

Check:
- Are there downloadable files attached to this record?
- Is there an explicit Wilf–Zeilberger certificate `G(n,k)` or recurrence identity for s7, s10, or any of the sporadic sequences?

#### Report back
Update **`docs/WZ_CERTIFICATE_ANALYSIS.md` ADDENDUM 3** with:
- **Found:** list the files, transcribe or link the certificate.
- **Not found / paywalled:** note the outcome; we proceed to CAS re-derivation.

#### Why this matters
- **If found:** we skip the Deep Think CAS grind; Opus encodes the certificates directly into Lean.
- **If not:** Deep Think must run Zeilberger (Mathematica `HolonomicFunctions` / SageMath) independently for both s7 and s10 — this is the gating path for closing the two remaining open goals (`open_goal_recurrence_s7`, `open_goal_recurrence_s10`).

**Estimated effort:** 5 min (if you have access); indefinite grind if Deep Think must re-derive from scratch.

---

### 2. Await Deep Think's P_cleared Concurrence (Passive)

No action required from you. Once Deep Think posts their verification, Opus encodes the Lean `ring` proof and the kernel upgrade happens automatically.

---

### 3. (Optional) Stream 3 / A183204 Context

The directive named s7 as "OEIS A183204" (the "primary load-bearing physical vacuum" candidate). This ID could not be fetch-verified this session (oeis.org returned 403). The repo's authoritative source remains the kernel-checked encoding + golden values in `Tests/CooperSequences.lean`.

**No action needed** — just flagging that if you're tracking external citations, A183204 is marked unverified.

---

## 🎯 Critical Path & Timeline

```
NOW (2026-07-24)
  ├─ Deep Think: P_cleared regeneration (parallel) ← GATE FOR SYM2_PROVED
  ├─ Xavier: Ingenta check (parallel) ← GATE FOR D2 DECISION (fetch vs. CAS)
  │
  ├─ Deep Think returns concurrence
  │  └─ Opus encodes ring proof → SYM2_PROVED ✅ (30–50 lines)
  │
  └─ D2 outcome
     ├─ IF found: Opus encodes certificates → open_goal_recurrence_s7/s10 ✅
     └─ IF not: Deep Think CAS run (Zeilberger s10 first, s7 second)
        └─ Opus encodes certificates → open_goals ✅ (200–500 lines total)

Unblocked on both fronts: full `lake build Agora` green, v0.4 release ready
```

---

## 🟡 NEW TASK: Stream 2 C3b Operator Identity (L₃ = Sym²(L₂))

Stream 2 has extracted order-2 partner operators for cooper_s7 and s10 and validated them to n=58. They want the operator identity `L₃ = Sym²(L₂)` proved for all n (upgrade from [B, PASS(58)] to [A, PROVED_LEAN]).

**Full brief:** `briefs/STREAM2_C3B_OPERATOR_IDENTITY_HANDOFF.md`

**Parallel to D1 & D2 — not critical path.**

---

## 📋 Acceptance Checklist

- [ ] **Deep Think:** P_cleared concurrence posted (D1 gate step 2/3 complete)
- [ ] **Xavier:** Ingenta outcome recorded (D2 decision made: fetch or CAS)
- [ ] **Opus:** Lean encoding proceeds (SYM2_PROVED + open-goal certificates)
- [ ] **Fable/Opus:** Commit & tag v0.4 (full phase-gate closure)

---

**Generated:** 2026-07-24 (Fable 5 / Opus 4.8 session)  
**Repo:** main @ 86f6f05 (2 commits ahead of v0.3)  
**Related briefs:**
- `briefs/D1_P_CLEARED_FABLE_2026-07-24.md` — Fable's frozen derivation (generic W ≡ 0)
- `briefs/STREAM2_C3B_OPERATOR_IDENTITY_HANDOFF.md` — C3b operator identity (L₃ = Sym²(L₂) for s7/s10)
- `briefs/PHASE_8_K3_SELECTION.md` — Stream 2 handoff (s7 priority, tier notes)
- `briefs/ESCALATIONS.md` (E-005, E-006) — D1/D3 status records
- `scripts/derive_D1_P_cleared.py` — sympy verification (D1 pattern)
- `scripts/export_pipeline_artifact.py` — pipeline bridge generator
- `data/pipeline_artifact.json` — Stream 2 artifact (PLACEHOLDER-VACUOUS)
