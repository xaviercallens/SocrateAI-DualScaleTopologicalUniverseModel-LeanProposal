---
name: file_navigation_guide
description: Critical files by role, common edit patterns, and where to find specific concepts
metadata:
  type: reference
---

# File Navigation Guide

## Quick Lookup: "I Want to Edit..."

| What | Go To | Why |
|-----|--------|-----|
| **Theorem 1 proof** (classification) | `Agora/Geometry/FTheoryFibration.lean` | Main theorem 1 |
| **Theorem 2 proof** (stability) | `Agora/Swampland/DualScaleStability.lean` | Main theorem 2 |
| **Theorem 3 proof** (M87*) | `Agora/Phenomenology/ChameleonRescue.lean` | Main theorem 3 |
| **Master theorem** | `Agora/DualScaleMaster.lean` | Combines all three |
| **Picard-Fuchs classification** | `Agora/ML/AutoEvolve_PicardFuchs.ipynb` | ML for axioms 1-2 |
| **Moduli optimization** | `Agora/ML/Optimize_Moduli.py` | Genetic algorithm for axiom 3 |
| **K3/Weierstrass models** | `Agora/Geometry/Weierstrass.lean` | Geometric primitives |
| **Discriminant locus** | `Agora/Geometry/DiscriminantLocus.lean` | Singular fiber analysis |
| **Axiom inventory** | `Agora/DualScaleMaster.lean` (lines 136-162) | All 6 axioms listed |
| **Project overview** | `README.md` | High-level structure |
| **Bibliography** | `docs/REFERENCES.md` | Citations and sources |
| **Proposal & roadmap** | `docs/PHASE_8_FTHEORY_PROPOSAL.md` | Future work |

---

## File Structure with Annotations

### Root Directory

```
.claude/settings.json                  # Claude Code project config
.claude/settings.local.json            # Local overrides
.gitignore                             # Git ignore patterns
.gitmodules                            # Submodule definitions
lakefile.lean                          # Lean 4 build configuration ⭐
LICENSE                                # MIT license
README.md                              # Project overview ⭐
MEMORY.md                              # This memory index ⭐
```

### Agora/ (Core Formalization)

```
Agora/
├── DualScaleMaster.lean ⭐⭐⭐         # MASTER THEOREM (start here)
│   ├── Imports all three theorems
│   ├── Axiom inventory (lines 136-162)
│   └── Master proof (lines 127-129)
│
├── Geometry/
│   ├── FTheoryFibration.lean ⭐⭐     # THEOREM 1: Classification
│   │   ├── Picard-Fuchs degree analysis
│   │   ├── Empirical axioms 1-2
│   │   └── Theorem 1 proof (Order-2 ≠ Order-3)
│   │
│   ├── Weierstrass.lean ⭐             # Geometric primitives
│   │   ├── Weierstrass form: y² = x³ + fx + g
│   │   ├── Elliptic curve definitions
│   │   └── Singular fiber analysis
│   │
│   └── DiscriminantLocus.lean          # Discriminant properties
│       ├── Singular locus: Δ = 0
│       └── Fibration structure analysis
│
├── Swampland/
│   └── DualScaleStability.lean ⭐⭐   # THEOREM 2: Stability
│       ├── LVS parametrization (A, B, a, b)
│       ├── Scalar potential V(τ₁, τ₂)
│       ├── Hessian positivity proof
│       └── Swampland Distance Conjecture
│
├── Phenomenology/
│   └── ChameleonRescue.lean ⭐⭐      # THEOREM 3: Observational
│       ├── M87* black hole parameters
│       ├── Superradiance mechanism
│       ├── Chameleon coupling α_eff
│       ├── Numerical certificates (axioms 4-6)
│       └── Theorem 3 proof (α_eff > 0.42)
│
└── ML/
    ├── AutoEvolve_PicardFuchs.ipynb ⭐ # ML classification
    │   ├── Imports S_{1,2} coefficients
    │   ├── OEIS A006077 analysis
    │   ├── ML classifier training
    │   └── Outputs empirical axioms 1-2
    │
    ├── Optimize_Moduli.py ⭐            # Genetic algorithm
    │   ├── DEAP fitness function
    │   ├── Moduli stability objective
    │   ├── Observational fit constraint
    │   └── Outputs axiom 3 (upper bound)
    │
    └── requirements.txt                 # Python dependencies
        ├── numpy, scipy, pandas
        ├── scikit-learn
        ├── JAX, Flax
        └── DEAP
```

### docs/ (Documentation)

```
docs/
├── PHASE_8_FTHEORY_PROPOSAL.md ⭐      # Unified proposal
│   ├── Abstract (problem statement)
│   ├── Contribution checklist
│   └── Future work outline
│
└── REFERENCES.md ⭐                    # Bibliography
    ├── String theory foundations (KKLT, LVS)
    ├── F-theory geometry (K3, Weierstrass)
    ├── Swampland conjectures
    ├── Chameleon mechanism
    ├── M87* observations (EHT)
    └── ML classification methods
```

### external/ (Submodules & Zenodo)

```
external/
├── README.md                           # Submodule guide
├── Lean-QuantumInfo/                   # Submodule (empty)
├── Lean4PHYS/                          # Submodule (empty)
├── ml-string-landscape/                # Submodule (empty)
│
└── zenodo_20290893/                    # Hilbert-Pólya resource (4.7 MB)
    ├── README.md                       # Zenodo record summary
    ├── omega-pcf.zip                   # Compressed archive
    │
    └── omega-pcf-01-hilbert-polya-65ab6d0/
        ├── lean/                       # Lean 4 formalization
        │   ├── HilbertPolyaOperator.lean
        │   └── SpectralProperties.lean
        ├── src/                        # LaTeX documentation
        │   └── methods.tex (67 KB)
        ├── scripts/                    # Python generators (14 files)
        ├── images/                     # Visualizations (27 SVG + 8 PNG)
        ├── build/                      # Compiled PDF (1.1 MB)
        ├── tests/                      # Verification scripts
        └── docs/                       # Usage & architecture guides
```

### scripts/

```
scripts/
├── setup_externals.sh                  # Initialize git submodules
│   └── Runs: git submodule update --init --recursive
│
└── download_zenodo.sh                  # Fetch Zenodo 10.5281/zenodo.20290893
    └── Downloads & extracts 4.7 MB archive
```

### data/ (Empty, Planned)

```
data/
├── discoveries.json                    # [PLACEHOLDER] K3-DISC results
├── pipeline_runs.json                  # [PLACEHOLDER] GPU logs
└── ned_crossmatch/                     # [PLACEHOLDER] NED cross-match
```

---

## Common Edit Patterns

### Pattern 1: Extend Theorem with New Constraint

**Scenario:** LIGO finds new axion mass bound.

**Steps:**
1. Add axiom to `Agora/Phenomenology/ChameleonRescue.lean`:
   ```lean
   axiom ligo_axion_bound : axion_mass > 1e-6_eV
   ```

2. Derive intermediate theorem:
   ```lean
   theorem ligo_constraint_satisfied : ... := by
     -- Prove chameleon mechanism still rescues model
     ...
   ```

3. Update master theorem in `Agora/DualScaleMaster.lean`:
   ```lean
   theorem dual_scale_universe_model_consistent_v2 :
       theorem1_holds ∧ theorem2_holds ∧ theorem3_holds ∧ ligo_constraint_satisfied := by
     exact ⟨theorem1, theorem2, theorem3, ligo_constraint_satisfied⟩
   ```

### Pattern 2: Improve ML Classification

**Scenario:** AutoEvolve accuracy improves; axiom 1 changes from 2 to 2 with higher confidence.

**Steps:**
1. Update `Agora/ML/AutoEvolve_PicardFuchs.ipynb`:
   - Retrain classifier on new dataset
   - Verify Order-2 classification on S_{1,2}
   - Export confidence scores

2. Update axiom comment in `Agora/Geometry/FTheoryFibration.lean`:
   ```lean
   -- empirical_S12_degree: 
   -- Source: AutoEvolve v2.1 (confidence 99.7%)
   -- Previous: v1.0 (confidence 98.2%)
   axiom empirical_S12_degree : degree_picard_fuchs(S_{1,2}) = 2
   ```

3. No change to proof (still 2 ≠ 3), so Theorem 1 remains valid.

### Pattern 3: Add New Theorem (Extension)

**Scenario:** Want to formalize loop corrections to scalar potential.

**Steps:**
1. Create `Agora/Corrections/LoopCorrections.lean`:
   ```lean
   namespace Agora.Corrections

   def loop_correction_holds : Prop := ...

   theorem loop_corrected_potential_stable : loop_correction_holds := by
     ...
   ```

2. Update `Agora/DualScaleMaster.lean`:
   - Import new theorem
   - Add to master theorem conjunction:
   ```lean
   theorem dual_scale_universe_model_consistent_v3 :
       theorem1_holds ∧ theorem2_holds ∧ theorem3_holds ∧ loop_correction_holds := ...
   ```

### Pattern 4: Optimize ML Fitness Function

**Scenario:** Improve moduli optimization convergence.

**Steps:**
1. Edit `Agora/ML/Optimize_Moduli.py`:
   ```python
   def fitness(individual):
       A, B, a, b = individual
       # Old: hessian_det = compute_hessian_det(A, B, a, b)
       # New: Include secondary objective (gradient norm minimization)
       stability = compute_stability_score(A, B, a, b)  # Higher is better
       convergence = compute_convergence_speed(A, B, a, b)  # New metric
       return (stability * 0.8 + convergence * 0.2,)
   ```

2. Re-run optimization to get new parameter bounds.

3. Update axiom 3 if upper bound changes:
   ```lean
   -- axiom pipeline_upper_bound: S_{1,2} ≤ 1.177  (OLD)
   axiom pipeline_upper_bound : S_{1,2} ≤ 1.150  (NEW)
   ```

4. Verify Theorem 2 still holds (it should; Hessian positivity is robust).

---

## Finding Specific Concepts

### "I want to understand the K3 surface formalization"

**Go To:**
1. Start: `Agora/Geometry/Weierstrass.lean` (K3 as Weierstrass equation)
2. Then: `Agora/Geometry/FTheoryFibration.lean` (Cooper s_7 classification)
3. Deep dive: `external/zenodo_20290893/lean/SpectralProperties.lean` (spectral properties)
4. Reference: `docs/REFERENCES.md` (search "K3 surface")

### "I want to understand the chameleon mechanism"

**Go To:**
1. Start: `Agora/Phenomenology/ChameleonRescue.lean` (main theorem)
2. Review: `docs/REFERENCES.md` (papers on chameleon mechanism)
3. Numerical: `Agora/ML/Optimize_Moduli.py` (density dependence implementation)
4. Observation: `Agora/DualScaleMaster.lean` (M87* axioms)

### "I want to understand the master theorem assembly"

**Go To:**
1. Main file: `Agora/DualScaleMaster.lean` (lines 127-129)
2. Component 1: `Agora/Geometry/FTheoryFibration.lean` (theorem1_holds)
3. Component 2: `Agora/Swampland/DualScaleStability.lean` (theorem2_holds)
4. Component 3: `Agora/Phenomenology/ChameleonRescue.lean` (theorem3_holds)

### "I want to verify the axioms are correct"

**Go To:**
1. Axiom inventory: `Agora/DualScaleMaster.lean` (lines 136-162)
2. Empirical axioms: `Agora/ML/AutoEvolve_PicardFuchs.ipynb` (S12_degree, s7_degree)
3. Pipeline bound: `Agora/ML/Optimize_Moduli.py` (S_{1,2} upper bound)
4. M87* axioms: `Agora/Phenomenology/ChameleonRescue.lean` (numerical certificates)
5. Cross-check: `docs/REFERENCES.md` (original papers)

### "I want to understand the project roadmap"

**Go To:**
1. Overview: `README.md` (quick start)
2. Proposal: `docs/PHASE_8_FTHEORY_PROPOSAL.md` (future work)
3. Architecture: `MEMORY.md` → `project_architecture.md` (interdependencies)

---

## Editor Configuration Tips

### VS Code + Lean 4 Extension

**Recommended settings for this project:**

```json
{
  "lean4.autoImplicit": false,
  "lean4.serverOptions": {
    "checkIntervalMs": 100
  },
  "editor.rulers": [80, 120],
  "editor.formatOnSave": true,
  "[lean]": {
    "editor.defaultFormatter": "leanprover.lean4"
  }
}
```

### Navigation Shortcuts

- **Jump to definition:** Ctrl+Click on theorem name
- **Find all references:** Ctrl+Shift+F, search theorem name
- **Go to file:** Ctrl+P, type `FTheoryFibration.lean`
- **Search diagnostics:** Ctrl+Shift+M (shows proof errors)

### Common Proof Editing

**When a proof breaks:**
1. Go to line with `sorry` or type error
2. Check the **expected type** in error message
3. Look for analogous proof in same file or sibling theorems
4. Use `#check` to verify types:
   ```lean
   #check mul_pos  -- See what mul_pos expects
   ```

---

## Build & Test Workflow

### Full Build

```bash
# Clean and rebuild everything
lake clean
lake build

# Output: 
# ✓ No errors = all proofs compile
# ✗ Errors = syntax or proof issues to fix
```

### Quick Verification

```bash
# Just check syntax (fast)
lake check

# Check specific file
lake check Agora/Geometry/FTheoryFibration.lean
```

### Run ML Pipeline

```bash
# Recompute empirical axioms 1-2
jupyter notebook Agora/ML/AutoEvolve_PicardFuchs.ipynb

# Reoptimize moduli parameters
python Agora/ML/Optimize_Moduli.py --generations 100 --pop-size 50
```

---

## File Dependencies

### Import Graph

```
DualScaleMaster.lean
├── Geometry/FTheoryFibration.lean
│   └── Mathlib.Data.Real.Basic
├── Swampland/DualScaleStability.lean
│   └── Mathlib.Data.Real.Basic
└── Phenomenology/ChameleonRescue.lean
    └── Mathlib.Data.Real.Basic

Weierstrass.lean
└── Mathlib.Data.Real.Basic

DiscriminantLocus.lean
└── Mathlib.Data.Real.Basic
```

### (No circular dependencies — good!)

---

## Checklist: Before Committing Changes

- [ ] Run `lake build` (no errors)
- [ ] Check `lake check Agora/*.lean` (all files compile)
- [ ] Review changes with `git diff`
- [ ] Update MEMORY.md if architectural changes
- [ ] Test ML pipeline if axioms changed: `python Agora/ML/Optimize_Moduli.py --test`
- [ ] Update `DualScaleMaster.lean` axiom inventory if new axiom added
- [ ] Verify master theorem still compiles
- [ ] Write descriptive commit message (see below)

### Commit Message Template

```
[TYPE] Brief title (max 50 chars)

Detailed explanation of:
- WHAT changed (which theorem, file, axiom)
- WHY it changed (physics update, ML improvement, bug fix)
- HOW it affects other files (if applicable)

Axiom changes:
- List any axioms added/modified
- Include source (ML pipeline, numerical cert, observation)

Related files:
- Agora/DualScaleMaster.lean (axiom inventory)
- docs/REFERENCES.md (if new papers cited)
```

### Example Commit

```
[AXIOM] Update empirical_S12_degree confidence

AutoEvolve v2.1 improves Picard-Fuchs classification with 99.7% confidence
on expanded dataset (SDSS DR18 + Euclid early data). S_{1,2} Order-2
classification remains robust. No change to theorem proofs.

Axiom changes:
- empirical_S12_degree: confidence 98.2% → 99.7%
  Source: AutoEvolve v2.1 (Agora/ML/AutoEvolve_PicardFuchs.ipynb)

Related files:
- Agora/DualScaleMaster.lean (line 141: axiom comment updated)
```

---

## For LLM Context: Critical Files Priority

**If you only read 3 files:**
1. `Agora/DualScaleMaster.lean` — Master theorem & axiom inventory
2. `Agora/Geometry/FTheoryFibration.lean` — Theorem 1
3. `Agora/Swampland/DualScaleStability.lean` — Theorem 2

**If you have more time, add:**
4. `Agora/Phenomenology/ChameleonRescue.lean` — Theorem 3
5. `Agora/ML/Optimize_Moduli.py` — Axiom derivation
6. `Agora/ML/AutoEvolve_PicardFuchs.ipynb` — ML classification

**For full understanding, finish with:**
7. `docs/REFERENCES.md` — Physics background
8. `docs/PHASE_8_FTHEORY_PROPOSAL.md` — Future work
9. `external/README.md` — Integration points

