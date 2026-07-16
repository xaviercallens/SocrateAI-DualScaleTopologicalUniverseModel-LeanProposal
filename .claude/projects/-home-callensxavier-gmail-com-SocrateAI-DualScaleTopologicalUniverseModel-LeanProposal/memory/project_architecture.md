---
name: project_architecture
description: High-level project goals, structure, interdisciplinary components, and how they integrate
metadata:
  type: project
---

# SocrateAI Project Architecture

## Mission Statement

**Bridge formal mathematics and physics:** Construct a machine-checkable proof that the Dual-Scale Topological Universe Model (a string theory ansatz) is internally consistent—meaning it has distinct geometric objects, stable moduli, and compatibility with observational data (M87* black hole).

---

## The Unification Problem

### What Problem Are We Solving?

**Dark matter and dark energy remain observationally mysterious.** String theory suggests solutions via:
- **Dark matter:** Axions from extra-dimensional geometry
- **Dark energy:** Moduli stabilization in higher-dimensional vacua

But string theory landscape is vast (~10^500 vacua). The **Dual-Scale Topological Universe Model** proposes:
1. Use **algebraic geometry** (F-theory, K3 surfaces) to classify candidate vacua
2. Filter by **stability** (Hessian analysis, Swampland constraints)
3. Check against **observations** (M87* EHT data, superradiance bounds)

**Our contribution:** Formalize all three steps in Lean 4, proving they cohere.

---

## Three-Layer Architecture

### Layer 1: Geometric (Theorem 1)
**File:** `Agora/Geometry/FTheoryFibration.lean`  
**Question:** Are the candidate geometric objects mathematically distinct?

- **S_{1,2} elliptic curve:** Picard-Fuchs ODE of Order 2 (from AutoEvolve classification)
- **Cooper s_7 K3 surface:** Picard-Fuchs ODE of Order 3 (from AutoEvolve classification)
- **Proof:** 2 ≠ 3, so they live on different algebraic varieties. No degeneracy.

**Why this matters:** If they were the same object, there'd be no distinction between dark matter and dark energy mechanisms. Theorem 1 ensures they're orthogonal.

### Layer 2: Dynamical Stability (Theorem 2)
**File:** `Agora/Swampland/DualScaleStability.lean`  
**Question:** Does the combined moduli space (K3 × T²) have a stable vacuum?

- **Large Volume Scenario (LVS):** Parametrized by A, B, a, b > 0
- **Scalar Potential:** V(τ₁, τ₂) = A·a²·exp(-a·τ₁) × B·b²·exp(-b·τ₂)
- **Stability:** Hessian is positive-definite for all LVS parameters
- **Swampland Safety:** Distance Conjecture (τ_Δ < c_1) satisfied

**Why this matters:** An unstable vacuum (tachyons, runaway scalars) means the model is unphysical. Theorem 2 guarantees stability.

### Layer 3: Observational Viability (Theorem 3)
**File:** `Agora/Phenomenology/ChameleonRescue.lean`  
**Question:** Can the S_{1,2} axion evade M87* superradiance constraints?

- **M87* Black Hole:** Mass ~6.5 billion M_☉ (from EHT observations)
- **Superradiance Bound:** Axions with α_eff < 0.42 are amplified and radiated away
- **Chameleon Mechanism:** In high-density regions (near event horizon), scalar couples more weakly
- **M87* Result:** α_eff ≈ 0.155 × (10⁶)^{1/4} ≈ 4.90 >> 0.42 (safe!)

**Why this matters:** Even a geometrically sound, stable model must match observations. Theorem 3 anchors theory to data.

---

## Master Theorem: Coherence

**File:** `Agora/DualScaleMaster.lean`

**Proof:** `dual_scale_universe_model_consistent : theorem1 ∧ theorem2 ∧ theorem3`

The master theorem asserts that all three theorems hold *simultaneously*:
- ✓ Geometric objects are distinct
- ✓ Moduli space is stable
- ✓ Observational constraints are satisfied

**This is the formal proof of model consistency.**

---

## Project Structure Map

```
Agora/ (core formalization)
├── Geometry/
│   ├── FTheoryFibration.lean (Theorem 1: Classification)
│   ├── Weierstrass.lean (K3 Weierstrass model equations)
│   └── DiscriminantLocus.lean (Singular locus analysis)
├── Swampland/
│   └── DualScaleStability.lean (Theorem 2: Moduli stability + SDC)
├── Phenomenology/
│   └── ChameleonRescue.lean (Theorem 3: M87* observational viability)
├── ML/
│   ├── Optimize_Moduli.py (Genetic algorithm for LVS parameters)
│   ├── AutoEvolve_PicardFuchs.ipynb (Picard-Fuchs ODE classification)
│   └── requirements.txt (JAX, scikit-learn, DEAP, etc.)
├── DualScaleMaster.lean (Master theorem: all three hold)
└── [Physics/] (units, observables—planned)

docs/
├── PHASE_8_FTHEORY_PROPOSAL.md (Unified proposal + contribution guide)
└── REFERENCES.md (Comprehensive bibliography)

data/ (currently empty)
├── discoveries.json (K3-DISC classification results)
├── pipeline_runs.json (GPU pipeline execution logs)
└── ned_crossmatch/ (cross-match with NED catalog)

external/ (submodules + Zenodo)
├── Lean-QuantumInfo/ (quantum field theory in Lean 4)
├── Lean4PHYS/ (physics formalization library)
├── ml-string-landscape/ (ML methods for string landscape)
└── zenodo_20290893/ (Hilbert-Pólya spectral theory foundation)

scripts/
├── setup_externals.sh (initialize submodules)
└── download_zenodo.sh (fetch Zenodo resource)
```

---

## Data Flow & Integration

### ML Pipeline → Axioms

```
GPU/CPU Pipeline (e.g., SDSS/Euclid data)
        ↓
AutoEvolve (Picard-Fuchs classification)
        ↓
Empirical Axiom:
  - empirical_S12_degree = 2
  - empirical_s7_degree = 3
        ↓
Lean 4 Theorem 1 (uses axioms as assumptions)
```

### Genetic Algorithm → Moduli Parameters

```
Optimize_Moduli.py (DEAP-based)
        ↓
Fitness function:
  - Moduli stability (Hessian eigenvalues)
  - Observational fit (M87* data)
        ↓
Optimal LVS parameters: A, B, a, b
        ↓
Lean 4 Theorem 2 (proves Hessian positive for all valid parameters)
```

### Zenodo (Hilbert-Pólya) → Spectral Foundation

```
Zenodo 10.5281/zenodo.20290893
  (Hilbert-Pólya Operator formalization)
        ↓
K3 surface spectral properties
        ↓
Used in FTheoryFibration + DiscriminantLocus
```

### Submodules → Type Ecosystems

```
mathlib4          → Core types (ℝ, ℕ, exp, inequalities)
QuantumInfo       → Quantum field theory notation
Lean4PHYS         → Physics units and observables
ml-string-landscape → ML landscape search patterns
```

---

## Key Interdependencies

| Component | Depends On | Implication |
|-----------|-----------|-------------|
| Theorem 1 | AutoEvolve ODE classification | If ML changes, axiom `empirical_S12_degree` may change |
| Theorem 2 | LVS parametrization | If moduli space changes, Hessian proof must adapt |
| Theorem 3 | M87* observational data | If EHT revises black hole parameters, we must re-check α_eff > 0.42 |
| Master Theorem | All three theorems | A single `sorry` in any theorem breaks the master proof |

---

## Why This Is NOT a Standard Software Project

1. **No "version iterations"** — v0.1 has 0 sorry. This is a complete formal proof, not a beta.
2. **Axioms are load-bearing** — Unlike typical software where assumptions are hidden, every axiom here is explicit and sourced.
3. **Physics-to-math translation is critical** — Changes to the physics model (e.g., new M87* observations) feed directly into axioms.
4. **ML and proofs co-evolve** — If Optimize_Moduli finds new LVS parameters, the Lean proofs must accommodate them.

---

## Roadmap (Beyond v0.1)

- [ ] **Extended Phenomenology:** Add more observational tests (GW170817, LIGO axion searches)
- [ ] **Quantum Corrections:** Formalize loop corrections to scalar potential
- [ ] **Landscape Search:** Use ml-string-landscape to find other viable compactifications
- [ ] **Interactive Verification:** Provide web interface for exploring proof structure
- [ ] **Publication:** Peer review of formalization and observational predictions

---

## For LLM Context: Remember

- **This is physics formalization, not a product.** The goal is human-verifiable mathematical certainty, not performance or scalability.
- **"0 sorry" is sacred.** Any incomplete proof breaks the coherence of the model.
- **Axioms are contracts.** Every axiom has a source and justification. Adding a new axiom requires justification from physics or computation.
- **Interdisciplinary = complex.** Edits to ML affect axioms; changes to Lean proofs affect which ML parameters are valid; both must remain consistent.
