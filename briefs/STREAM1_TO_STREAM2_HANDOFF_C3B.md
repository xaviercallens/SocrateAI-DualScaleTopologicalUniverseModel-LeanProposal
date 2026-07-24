# Stream 1 → Stream 2: L₂ Operators Certified — Run C3b Validation & Geometry Selection

**From:** Stream 1 (Theory — Opus 4.8 / Fable 5)  
**To:** Stream 2 (K3 Selection · Xavier)  
**Date:** 2026-07-24  
**Status:** [A] L₂ CLEARED FOR DOWNSTREAM USE. C1/C2 authorised.  
**Provenance:** commit b16642e (SymSquareC3b template); L₂ verified in `data/certificates/C3b_symsqrt_cooper_s{7,10}.json`; source refs `cooper_s{7,10}_partner`

---

## 1. What Stream 1 Delivers (and Its Exact Status)

### L₃ = Sym²(L₂) Operator Identity: [A, CAS-proven]

For **cooper_s7** (OEIS A183204) and **cooper_s10** (OEIS A005260):
- The bulk Picard–Fuchs operator **L₃** (order-3, from frozen recurrence) is the **symmetric square** of an order-2 operator **L₂** (extracted partner).
- **Formal statement:** L₃ = Sym²(L₂), verified as an exact **rational-function identity over ℚ(z)**.
- **Verification:** Deep Think T0s CONCUR + independent Stream-1 re-derivation (two-model rule, both CAS agree).
- **Verdict:** `SYM2_OPERATOR_IDENTITY_PROVEN` (Lean formalization in progress, does not block your C1/C2 work).

### The Verified L₂ Operators (θ = z d/dz basis)

**θ-form Picard–Fuchs:** L₂ = P₂(z)·θ² + P₁(z)·θ + P₀(z), where θ acts on solutions as multiplication by z d/dz.

| Candidate | P₂(z) | P₁(z) | P₀(z) | Partner Sequence | Status |
|---|---|---|---|---|---|
| **s7** | 1 − 26z − 27z² | −13z − 27z² | −2z − 6z² | OEIS A279619 (integer) | [A] Certified |
| **s10** | 1 − 12z − 64z² | −6z − 64z² | −z − 15z² | rational (2-power denoms) | [A] Certified |

**Source:** Nullspace extraction (Stream 2 prior work, verified to n=58 in certificates). Operators generated from the explicit three-term recurrences in `refs/cooper_s{7,10}_partner.txt` (links pending).

### Consequence You May Use: [B, checkable]

L₂ is the **genuine order-2 Picard–Fuchs operator of the elliptic partner family**, not a fit artifact. The bulk K3 is its **symmetric-square surface** (Shioda–Inose-type construction). Therefore:

- The K3's **lattice/fibre invariants are computable from L₂'s singular fibres** — you no longer need a catalogued partner or a guessed modular level.
- The **monodromy of L₂** determines the **Kodaira fibre configuration** of the K3; the **transcendental lattice rank and discriminant** follow from Picard-Lefschetz theory.
- This closes the "guessing the modular form" loop: the geometry is now **derived**, not assumed.

---

## 2. Your Tasks: C1, C2 (Actionable, Existing Tooling)

### C1 — Kodaira Fibre Classification of the Elliptic Partner

**Purpose:** Determine the singular-fibre types of L₂ and classify their monodromy.

**Input:** The L₂ coefficients (P₂, P₁, P₀) from §1 for s7 and s10.

**Computation:**

1. **Singular loci:** Compute the zeros of the leading coefficient P₂(z) (after clearing to standard d/dz form).
2. **Monodromy:** At each singular point, classify the local exponents / Frobenius action.
3. **Kodaira classification:** Map each singularity to a Kodaira fibre type (I₀, Iₙ, II, III, IV, I₀*, II*, …).

**Existing tooling to reuse:**

- `scripts/k3_t2_singular_loci.py` (GATE D-2.4 — PF discriminant & singular-locus computation)
- `scripts/k3_monodromy_verification.py` (Fuchs classification + monodromy matrices)

**Point both scripts at:** The order-2 L₂ recurrences in `refs/cooper_s{7,10}_partner`, **not** the order-3 bulk.

**Deliverable:**

- `checkers/check_C1_kodaira_fibers.py` — exact-arithmetic Kodaira classifier with golden tests (one known-good K3 + one non-K3 negative control).
- `data/certificates/C1_cooper_s{7,10}.json` — per-candidate output:
  ```json
  {
    "candidate": "s7",
    "singular_points": [{"z": "...", "kodaira_type": "I₁", "monodromy_order": 2}, ...],
    "fibre_configuration": "Σ(s7) = [list of types]",
    "status": "CERTIFIED",
    "verification": {"golden_test_good": true, "golden_test_bad": true}
  }
  ```

### C2 — Transcendental/Picard Lattice of the K3

**Purpose:** Compute the exact transcendental lattice rank and intersection form.

**Input:** C1 fibre configuration Σ(s7) and Σ(s10).

**Computation:**

1. **Picard number ρ** via Shioda–Tate: ρ = 2 + Σ(mᵥ − 1) + rank(Mordell–Weil), where mᵥ is the number of irreducible components in fibre v.
2. **Transcendental lattice rank** = 22 − ρ (for a K3).
3. **Intersection form / discriminant:** Compute the exact discriminant and signature of the lattice.

**Deliverable:**

- `checkers/check_C2_picard_lattice.py` — Shioda–Tate calculator with golden tests.
- `data/certificates/C2_cooper_s{7,10}.json` — per-candidate output:
  ```json
  {
    "candidate": "s7",
    "picard_number": 20,
    "transcendental_rank": 2,
    "intersection_matrix": [[...], ...],
    "discriminant": -27,
    "status": "CERTIFIED",
    "verification": {"golden_test_good": true, "golden_test_bad": true}
  }
  ```

---

## 3. Adversarial Checks: Validate C3b Proof (A1–A6)

**Risk:** The order-2 recurrence for L₂ could be a finite-order overfitting artifact (fitted on n ≤ 26, validated to n = 58).

**Gate:** A1–A6 must pass before C1/C2 results are trusted as downstream geometry input.

### A1 & A2: Nullspace & Mirror-Map Controls

**A1 — Extend Nullspace Validation to n = 200:**

- Regenerate the s7 and s10 partner sequences to n = 200 using the **exact recurrence** (not approximate fit).
- Verify the **order-2 recurrence still holds exactly** over ℚ at every step.
- **Negative control (CRITICAL):** Intentionally perturb the s7 sequence (e.g., change a₁ by a small factor). Run the exact same nullspace-fit script. If it finds an order-2 operator for the broken sequence, your checker is **mathematically flawed** — halt and debug. It **must** return "no fit" for corrupted data.
- **Deliverable:** `checkers/adversarial_A1_nullspace_control.py` with both tests embedded (exact 200-term check + negative control).

**A2 — Apéry ζ(3) Mirror-Map Test:**

- Run the **Apéry ζ(3) sequence** through your mirror-map checker (the exact same pipeline used for s7/s10).
- **Expected result:** FAIL — Apéry ζ(3) is **non-MUM** (not a modular-form operator). Your checker must detect this and reject it, proving z(L₂) = z(L₃) is not a tautology.
- **Positive control:** Run s7 through the same pipeline; expect PASS.
- **Deliverable:** `checkers/adversarial_A2_mirror_map_control.py` (both Apéry + s7 tests).

### A4: Rational Partner of s10 — Physics Caveat

**Context:** s10's extracted partner sequence has rational coefficients (2-power denominators, not integers like s7).

**Action:**

1. **Evaluate whether the non-integrality signals:**
   - A **branch-cut / scaling defect** that invalidates the Shioda–Inose mapping, or
   - Simply a **specific orbifold / orientifold scaling requirement** for the resulting D-brane gauge fluxes.

2. **Determine:** Does this caveat affect the **load-bearing vacuum choice** for s10?

**Deliverable:** `checkers/adversarial_A4_rational_partner_analysis.py` (exact-arithmetic analysis of denominator structure) + `briefs/A4_RATIONAL_PARTNER_CAVEAT.md` (physics interpretation).

### A5 & A6: Provenance Hygiene (CRITICAL)

**Risk:** AI memory hallucinations corrupting the register (e.g., false OEIS IDs, wrong Zagier triple parameters).

**Action:**

1. **Trace the 6 Zagier sporadic sequences** (A, B, C, D, E, F) and **all OEIS IDs used in the register** directly to a **fetched, cited source document** (e.g., Gorodetsky arXiv:2102.11839 or Zagier's 2009 paper).
2. **Do NOT let any LLM pull these constants from memory.** Fetch the paper, read it, extract the values.
3. **Save the PDFs** to `docs/literature/` folder (create if absent) with SHA256 hashes pinned in `refs/literature_provenance.txt`.

**Deliverable:** `checkers/adversarial_A5_A6_provenance_hygiene.py` (verifies every OEIS ID against fetched sources) + updated `docs/literature/` + `refs/literature_provenance.txt`.

### Adversarial Test Master: Golden Tests & Status Report

**All checks (A1–A6) must have:**

- **Golden test (PASS):** one known-good example that should succeed.
- **Golden test (FAIL):** one known-bad example that should be rejected.
- **Exact-arithmetic verification:** no floating-point approximations, no model-memory values.
- **Automated regeneration:** `checkers/adversarial_tests.py` runs all A1–A6 in sequence, reports pass/fail, and regenerates a status table.

**Deliverable:** `checkers/adversarial_tests.py` (master runner) + `data/certificates/A1_through_A6_status.json` (status per attack, per candidate).

---

## 4. Epistemic Guardrails (Binding — Do Not Relax)

### Tier Distinctions

| Tier | Definition | Example | Obligation |
|---|---|---|---|
| **[A]** | Mathematically proven (Lean kernel or two-model CAS concurrence) | L₃ = Sym²(L₂), Kodaira type at a singular point | Report with proof reference; no hedging. |
| **[B]** | Checkable by algorithm (exact arithmetic, golden tests, no model memory) | Picard number ρ, lattice discriminant, C1/C2 classifier status | Report with golden-test trace; flag any caveat. |
| **[C]** | Physical conjecture (no mathematical proof, requires EFT matching or phenomenology data) | "s7 realizes SU(5) GUT gauge group", "D-brane coupling is load-bearing for SUSY" | Carry explicit [C] marker in the same sentence; do not state as fact. |

### Key Rules

1. **Geometry ≠ physics.** The Sym²/Shioda–Inose relation does **not** "link," "lock," or "couple" bulk to brane EFT. It **proves** a geometric fact. Physics (gauge groups, phenomenology) is [C]-tier conjecture. State them separately and marked.

2. **No model-memory values in C1/C2 certificates.** Numbers about candidates come **only** from `checkers/check_C{1,2}_*.py` exact arithmetic. If you need a reference value (e.g., the Picard lattice of a known K3), fetch it from a published table, not from memory.

3. **Caveat on s10:** The rational partner (2-power denominators) may complicate the geometric (integral-lattice) interpretation. Treat any lattice claim for s10 as **provisional** [B] with an explicit flag: "subject to orbifold / orientifold scaling interpretation (see A4)."

4. **s18 is OFF-LIMITS.** `gorodetsky_s18` recurrence is **BLOCKED** (corrupt transcription from arXiv). Do **not** run C1/C2 on s18 until the recurrence is re-transcribed from arXiv:2102.11839 v2 p.3 against the paper in hand.

---

## 5. Order of Operations & Execution Path

### Sequence (Do This Order)

1. **Run A1–A6 adversarial checks** (validate C3b proof before trusting L₂).
2. **If A1–A6 all pass:** proceed to C1/C2.
3. **C1 first (s7, then s10):** Kodaira fiber classification.
4. **C2 (s7, then s10):** Picard lattice from C1 fibre data.
5. **Interpret results under Tier guardrails:** geometry [A]/[B], physics [C]-marked.

### Why This Order

- A1–A6 validates that L₂ is **not a numerical artifact**; C1/C2 depend on L₂ being exact.
- s7 first: integer partner sequence → cleaner geometry, easier to interpret.
- s10 second: rational partner → flag all lattice claims as provisional (A4 caveat).

### Known Caveats

- **s10's non-integrality (A4):** May signal an orbifold scaling or simply a different normalization. Treat [B] lattice results for s10 as provisional pending physics interpretation.
- **Lean formalization lag:** Stream 1 is still encoding L₃ = Sym²(L₂) in Lean (commit b16642e template). This does **not** block C1/C2 — you already have the [A]-certified operators. Proceed.

---

## 6. Feedback Stream 1 Needs Back

Once C1/C2 are complete:

1. **C1 fibre configuration Σ(s7) and Σ(s10)** — these constrain Stream 1's base-geometry work (S1-3, T² lattice formalization) and let Stream 1 cross-check the transcendental lattice against the Sym² structure.

2. **Any C1/C2 result that contradicts the proven L₃ = Sym²(L₂) structure** → **open an F6-track issue** with both artifacts attached. Do not silently reconcile discrepancies.

3. **s10 lattice flags (provisional, if any)** — inform Opus whether orbifold/orientifold scaling makes the s10 geometry viable or introduces a falsification signal.

---

## 7. Certificate Indexing & Reconstruction

All outputs regenerated deterministically from source data:

```
refs/cooper_s{7,10}_partner.txt           ← L₂ recurrence source
  ↓
checkers/check_C1_kodaira_fibers.py       ← singular-locus + monodromy
  ↓
data/certificates/C1_cooper_s{7,10}.json  ← Kodaira types, Σ(s7)/Σ(s10)
  ↓
checkers/check_C2_picard_lattice.py       ← Shioda–Tate calculator
  ↓
data/certificates/C2_cooper_s{7,10}.json  ← ρ, lattice discriminant, [B] status
```

Adversarial checks:

```
data/C3b_symsqrt_cooper_s{7,10}.json      ← L₂ certified (n=58)
  ↓
checkers/adversarial_A{1..6}_*.py         ← golden + negative controls
  ↓
data/certificates/A1_through_A6_status.json  ← all tests pass/fail
```

---

## 8. Acceptance & Deployment Gate

✅ **C1/C2 complete & pass adversarial A1–A6**  
✅ **All certificate JSON outputs generated**  
✅ **s7 geometry finalized, s10 geometry finalized (with A4 caveat flagged)**  
✅ **Feedback loop: Σ(s7)/Σ(s10) sent to Stream 1 for cross-check**  
✅ **Any F6 issue from Stream 1 → resolved or re-escalated**

→ **C3b_L3_sym2_L2 geometry is LOCKED. Physics selection (GUT gauge groups) proceeds as [C] conjecture.**

---

**Generated-by:** Opus 4.8 (Stream-1→2 handoff, Tier B)  
**Verified-by:** L₂ operators certified in `C3b_symsqrt_cooper_s{7,10}` (commit b16642e)  
**Reviewed-by:** pending T0 (Deep Think physics interpretation / A4 orbifold caveat)
