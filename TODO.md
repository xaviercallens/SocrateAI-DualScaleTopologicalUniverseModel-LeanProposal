# TODO — Stream 1 & Stream 2 (2026-07-24 Post-Review)

**Priority order:** Critical path first, then parallel tracks.

---

## 🔴 CRITICAL PATH (Must Complete Before Geometry Lock)

### C1: Kodaira Fiber Classification (Xavier / Theory)

**Status:** Ready to execute (exact singular points provided)

**Input:**
- s7 singularities: `z = 1/27, z = −1`
- s10 singularities: `z = 1/16, z = −1/4`

**Tasks:**
- [ ] Run `scripts/k3_monodromy_verification.py` at s7 singular points
  - [ ] Compute local Frobenius exponents at z = 1/27
  - [ ] Compute local Frobenius exponents at z = −1
  - [ ] Classify Kodaira types (I₁, I₂, …, II, III, IV, …)
- [ ] Run monodromy script at s10 singular points (same process)
- [ ] Generate `data/certificates/C1_cooper_s7.json`
  - [ ] Include singular z-values, monodromy orders, Kodaira types
  - [ ] Include fiber configuration Σ(s7)
  - [ ] Include Picard number lower bound (2 + Σ(m_v − 1))
- [ ] Generate `data/certificates/C1_cooper_s10.json` (same structure)
- [ ] Golden test: run C1 on Fermat K3 (ρ = 20), verify expected output
- [ ] Golden test: run C1 on non-K3 (reject)

**Expected output format:**
```json
{
  "candidate": "s7",
  "singular_points": [
    {"z": "1/27", "monodromy_order": 2, "kodaira_type": "I₁"},
    {"z": "-1", "monodromy_order": 2, "kodaira_type": "I₁"}
  ],
  "fibre_configuration": "Σ(s7) = [I₁, I₁]",
  "picard_number_lower_bound": 4,
  "status": "CERTIFIED",
  "timestamp": "2026-07-24"
}
```

**Effort:** 2–4 hours  
**Owner:** Xavier

---

### C2: Picard Lattice & Transcendental Rank (Xavier / Theory)

**Status:** Dependent on C1 completion

**Input:** C1 fiber configurations Σ(s7), Σ(s10)

**Tasks:**
- [ ] Implement Shioda-Tate formula in exact arithmetic
  - [ ] ρ = 2 + Σ(m_v − 1) + rank(Mordell-Weil)
  - [ ] For s7: expect ρ = 4 (two I₁ fibers)
  - [ ] For s10: expect ρ = 4 (two I₁ fibers, rational caveat)
- [ ] Compute transcendental rank
  - [ ] τ = 22 − ρ
  - [ ] For both: expect τ = 18
- [ ] Compute intersection form (transcendental lattice)
  - [ ] Exact discriminant (expect −3, definite)
  - [ ] Verify signature (should be negative definite for K3)
- [ ] Generate `data/certificates/C2_cooper_s7.json`
  - [ ] Picard number, transcendental rank, discriminant
  - [ ] Intersection matrix (2×2 for transcendental lattice)
- [ ] Generate `data/certificates/C2_cooper_s10.json` (same)
  - [ ] Flag: "Provisional [B] — A4 caveat on rational 2-adic scaling"
- [ ] Golden tests (Fermat K3, non-K3)

**Expected output:**
```json
{
  "candidate": "s7",
  "picard_number": 4,
  "transcendental_rank": 18,
  "intersection_matrix": [[2, 1], [1, 2]],
  "discriminant": -3,
  "status": "CERTIFIED",
  "caveat": null
}
```

**Effort:** 2–3 hours (after C1)  
**Owner:** Xavier

---

### Physics Interpretation (Xavier / Theory + Physics)

**Status:** Requires C1/C2 complete

**Gate:** C1/C2 both certified [B]

**Tasks:**
- [ ] Review C1 Kodaira fiber types for s7 and s10
- [ ] Map fiber types → possible D-brane gauge groups
  - [ ] I₁ fibers: support SU(2)? SU(3)?
  - [ ] Configuration Σ = [I₁, I₁]: what is the full gauge group?
- [ ] Examine C2 intersection form
  - [ ] Is discriminant consistent with expected physics?
  - [ ] Does s7 admit Standard Model embedding (SU(5), SO(10))?
- [ ] Evaluate s10 caveat (A4: rational 2-adic scaling)
  - [ ] Does non-integrality of sequence coefficients signal orbifold?
  - [ ] Would orbifold reduce gauge-group rank?
- [ ] Write physics brief (Tier C, explicitly marked)
  - [ ] State all gauge-group claims as [C] conjecture
  - [ ] Identify "load-bearing vacuum" (s7 vs s10)
- [ ] Deliverable: `briefs/STREAM2_C3B_PHYSICS_INTERPRETATION.md`

**Effort:** 4–6 hours  
**Owner:** Xavier (authority on physics)

---

## 🟡 BLOCKING ITEM (Must Resolve Before Validation)

### Provenance Documentation (A5/A6 Gate)

**Status:** Partial (sequences identified, sources cited, PDFs not yet fetched)

**Tasks:**
- [ ] Create `docs/literature/` directory
- [ ] Fetch and save:
  - [ ] Zagier, "Integral solutions of Apéry-like recurrence equations" (2009 or latest)
  - [ ] Gorodetsky, arXiv:2102.11839 v2 (PDF + locally saved)
  - [ ] Cooper, "Sporadic sequences, modular forms and new series for 1/π" (Ramanujan J. 2012)
- [ ] Compute SHA256 hash for each PDF
- [ ] Record in `refs/literature_provenance.txt`
  ```
  Zagier_2009.pdf | SHA256:abc123...
  Gorodetsky_arXiv2102.11839_v2.pdf | SHA256:def456...
  Cooper_2012.pdf | SHA256:ghi789...
  ```
- [ ] Update `checkers/adversarial_A5_A6_provenance_hygiene.py` to verify hashes
- [ ] Run A5/A6 test: `python3 checkers/adversarial_A5_A6_provenance_hygiene.py`
  - [ ] All 15 sporadic sequences verified against fetched sources
  - [ ] No AI memory hallucination detected
  - [ ] Test PASS

**Effort:** 1–2 hours  
**Owner:** Xavier or Opus (documentation)  
**Blocking:** Adversarial validation (A1–A6 full suite)

---

## ✅ CLOSED: S1-08 Lean Formalization

### S1-08: Generic W≡0 (`P_cleared ≡ 0`) proved in Lean (Opus / Theory)

**Status:** ✅ COMPLETE (commit 206db17). D1 gate all 3 steps passed (Fable derivation
→ Deep Think CAS concurrence → Lean kernel proof).

**What landed (`Agora/Swampland/SymSquareC3b.lean`):**
- [x] `p3, p2, p1, p0 : Polynomial ℚ` — D-form coefficients, generic in `a b c d : ℚ`,
      cross-checked against `cooperThetaOperator_eq` (θ=zD substitution, hand-verified
      term-for-term) and against `scripts/derive_D1_P_cleared.py` (ground truth)
- [x] `P_cleared (a b c d : ℚ) : Polynomial ℚ` built from REAL `Polynomial.derivative`
      calls (not hand-transcribed derivatives — kernel checks every differentiation step)
- [x] `theorem P_cleared_eq_zero (a b c d : ℚ) : P_cleared a b c d = 0` — proved by
      `ring` after simp normalization. ONE fully generic theorem, not per-candidate.
- [x] Specialized to `P_cleared_s7`, `P_cleared_s10`, `P_cleared_s18` by trivial
      substitution (no extra proof work — this is the payoff of proving it generically)
- [x] Compiled: `lake build Agora` green (3106 jobs), `lake build Tests` green (3000 jobs)
- [x] Verified 0 `sorry` via `export_open_goals.py` (only pre-existing, unrelated goals remain)
- [x] Committed "S1-08: Lean kernel proof..." + pushed to origin/main

**Effort actually spent:** ~1 session (iterating the `ring`-closing simp set — two
debugging rounds: `Polynomial.C 3` needed to be a bare numeral, and `derivative_pow`'s
`Nat.cast` output needed `map_natCast`, not just `map_ofNat`, to unify with numerals).

**Owner:** Opus/Sonnet (Stream 1)  
**Blocker:** None — CLOSED

---

## ✅ COMPLETED (Prior + This Session)

- [x] Stream 1 L₃ = Sym²(L₂) verified [A, two-model CAS]
- [x] L₂ operators extracted for s7/s10
- [x] Handoff brief created (`briefs/STREAM1_TO_STREAM2_HANDOFF_C3B.md`)
- [x] Adversarial checker infrastructure built (7 files)
- [x] C1/C2 checker templates ready
- [x] Memory tracking updated (index maintained)
- [x] **S1-08 Lean kernel proof landed** (generic `P_cleared_eq_zero`, specialized to s7/s10/s18)
- [x] Commits pushed to origin/main

---

## 📊 Timeline Estimate

| Task | Est. Time | Start | End | Owner |
|---|---|---|---|---|
| Provenance docs (A5/A6 gate) | 1–2h | ASAP | — | Xavier/Opus |
| C1 Kodaira computation | 2–4h | After A5/A6 | — | Xavier |
| C2 Picard lattice | 2–3h | After C1 | — | Xavier |
| Physics interpretation | 4–6h | After C2 | — | Xavier |
| ~~S1-08 Lean encoding~~ | ~~2–3h~~ | ✅ DONE | ✅ DONE | Opus |
| **Total Stream 2 critical path** | **9–15h** | Today | End of phase | Xavier |

---

## 🎯 Success Criteria

**C3b Geometry Lock** (Xavier authority):
- ✅ A1–A6 adversarial checks all PASS
- ✅ C1 certificates generated (Kodaira types confirmed)
- ✅ C2 certificates generated (Picard lattice computed)
- ✅ No contradiction with L₃ = Sym²(L₂) proven geometry
- ✅ Physics claims marked [C] (no physics-washing)
- ✅ Feedback to Stream 1: Σ(s7)/Σ(s10) for base-geometry cross-check

**Decision:** "C3b geometry locked. Stream 2 physics selection (D-brane GUT matching) proceeds."

---

## Notes

- **No surprises expected:** Singular points given exactly (factored), monodromy scripts validated, Shioda-Tate formula standard.
- **A4 caveat on s10:** Rational 2-power denominators → provisional [B] status. Treat lattice claims as [B] with explicit flag.
- **s18 OFF-LIMITS:** Corrupt recurrence (gorodetsky_s18). Re-transcribe from arXiv v2 p.3 before any work.
- **Physics vs. geometry:** All gauge-group/GUT claims are [C] (conjecture, requires EFT matching). Picard lattice is [B] (checkable).

---

**Last updated:** 2026-07-24 (post-review, Xavier approval)  
**Owner:** Xavier (Stream 1/2 authority)  
**Next review:** Post-C1/C2 certificate generation
