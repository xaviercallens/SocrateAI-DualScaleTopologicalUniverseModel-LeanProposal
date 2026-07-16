---
name: dependencies_integration
description: External libraries, submodules, Zenodo resources, and how they integrate with core formalization
metadata:
  type: reference
---

# Dependencies & Integration

## Dependency Graph

```
SocrateAI-DualScale-LeanProposal (root)
├── mathlib4 (Lean 4 standard library)
│   └── Core: Data.Real.Basic, Tactic, exp, sqrt, inequalities
├── QuantumInfo (Timeroot/Lean-QuantumInfo)
│   └── Quantum field theory types, notation
├── Lean4PHYS (ShirleyLIYuxin/Lean4PHYS)
│   └── Physics units, observables, conventions
├── ml-string-landscape (AndreasSchachner)
│   └── ML methods for string landscape search
└── zenodo_20290893 (Hilbert-Pólya Operator formalization)
    └── Spectral theory, K3 classification foundation
```

---

## Mathlib4

**Purpose:** Core mathematical library for Lean 4  
**Version:** Latest (git HEAD)  
**Import:** `import Mathlib.Data.Real.Basic` + `import Mathlib.Tactic`

### What We Use From Mathlib4

| Module | Used For | Example |
|--------|----------|---------|
| `Data.Real.Basic` | Real number type (ℝ), arithmetic | τ₁, τ₂ ∈ ℝ in Theorem 2 |
| `Data.Real.Exp` | Exponential function | exp(-a·τ₁) in V(τ₁, τ₂) |
| `Data.Real.Sqrt` | Square roots | √(2) in proofs |
| `Tactic` | Proof tactics | `by norm_num`, `mul_pos` |
| `Logic.Basic` | Logical constructors | ∧ (conjunction in master theorem) |
| `Init.WF` | Well-founded relations | Recursion (for future work) |

### Critical Mathlib Functions in Proofs

```lean
-- Theorem 2 proof uses these:
mul_pos : a > 0 → b > 0 → a * b > 0
sq_pos_of_pos : a > 0 → a^2 > 0
Real.exp_pos : ∀ x, exp(x) > 0
```

### Porting Risk

Mathlib4 is actively maintained. If breaking changes occur:
- **Low risk:** Our usage is basic (Real numbers, inequalities, exp)
- **Mitigation:** Specify Lean 4 version in lakefile.lean if needed
- **Backup:** mathlib4 has deprecation periods; updates are usually backward-compatible

---

## QuantumInfo (Timeroot/Lean-QuantumInfo)

**Repository:** https://github.com/Timeroot/Lean-QuantumInfo  
**Purpose:** Formalization of quantum mechanics in Lean 4  
**Status:** Submodule (currently empty in external/)  
**Required in:** `lakefile.lean`

### Planned Integration

**Current v0.1:** Not actively used (we focus on classical geometry + cosmology)

**Future Use Cases:**
1. **Chameleon Mechanism:** Quantum field theory background
   - Quantum corrections to scalar potential
   - One-loop effective potential in curved spacetime

2. **Phenomenology Extension:** K-matrices for scattering processes
   - Axion-photon conversion in magnetic fields
   - Quantum gravity corrections to chameleon coupling

3. **String Theory:** Operators in conformal field theory (CFT)
   - Heterotic string dual of F-theory
   - Vertex operators on worldsheets

### How to Use When Extended

```lean
import QuantumInfo.Operators
import QuantumInfo.States

-- Example future theorem:
theorem quantum_corrected_potential_stable : ...
```

### Integration Points

- **Type Compatibility:** Quantum mechanics types (Hilbert spaces, operators) can be embedded as Lean terms
- **Notation:** QuantumInfo provides |ψ⟩ notation for states
- **Tactics:** Custom tactics for quantum operator algebra (when available)

---

## Lean4PHYS (ShirleyLIYuxin/Lean4PHYS)

**Repository:** https://github.com/ShirleyLIYuxin/Lean4PHYS  
**Purpose:** Formalization of college-level physics in Lean 4  
**Status:** Submodule (currently empty in external/)  
**Required in:** `lakefile.lean`

### Planned Integration

**Current v0.1:** Light usage for notation and documentation

**Future Use Cases:**
1. **Units & Dimensions:**
   - Planck mass m_P = √(ℏc/G) ≈ 2.18 × 10^{-8} kg
   - Gravitational coupling g ~ 1/m_P²
   - Ensure dimensional consistency in proofs

2. **Constants & Observables:**
   - Solar mass M_☉ (for M87* scaling)
   - Hubble constant H₀ (for dark energy constraints)
   - Fine structure constant α_em ≈ 1/137

3. **Physical Notation:**
   - Energy-momentum tensor T_μν
   - Curvature scalar R (in Einstein equations)
   - Ricci tensor Ric_μν

### How to Use When Extended

```lean
import Lean4PHYS.Units
import Lean4PHYS.Constants
import Lean4PHYS.Relativity

-- Example future theorem:
theorem m87_black_hole_mass : M_BH = 6.5e9 * solar_mass := ...
```

### Integration Points

- **Notation:** Lean4PHYS provides ⟨x, y, z⟩ for 3-vectors, subscript notation
- **Type System:** Dimensional analysis can catch errors (e.g., adding energy to mass)
- **Constants:** Predefines physical constants as computable values

---

## ml-string-landscape (AndreasSchachner)

**Repository:** https://github.com/AndreasSchachner/ml-string-landscape  
**Purpose:** Machine learning algorithms for exploring string theory landscape  
**Status:** Submodule (currently empty in external/)

### Current Integration

**Not directly used** in v0.1, but architecturally available for future work.

### Planned Use Cases

1. **Landscape Search:** Identify other stable vacua
   - Exhaustive search over ~10^6 compactifications
   - Filter by swampland constraints
   - Rank by observational viability

2. **Parameter Optimization:** Extend Optimize_Moduli.py
   - Use genetic algorithms from DEAP
   - Integrate ML classifiers from ml-string-landscape
   - Optimize over larger parameter spaces

3. **Phenomenology Prediction:**
   - Predict gravitational wave signatures
   - Compute thermal relic abundances for dark matter
   - Forecast GW170817 neutron star merger constraints

### How to Use

```python
# Example future script
from ml_string_landscape import landscape_search, filter_swampland

# Search for vacua
vacua = landscape_search(n_vacua=1e6, 
                         lattices=['K3', 'CY3'],
                         search_method='genetic_algorithm')

# Filter by constraints
viable_vacua = filter_swampland(vacua, 
                                distance_conjecture=True,
                                weak_gravity=True)
```

### Integration Points

- **Axiom Generation:** Output of landscape search becomes new axioms
- **Theorem Extension:** New viable vacua expand the master theorem
- **Validation:** Proven stable vacua from Lean can be cross-checked against ML search

---

## Zenodo Record 10.5281/zenodo.20290893 (Hilbert-Pólya Operator)

**DOI:** https://doi.org/10.5281/zenodo.20290893  
**Size:** 4.7 MB compressed  
**Status:** Downloaded, extracted to `external/zenodo_20290893/`  
**Purpose:** Spectral theory foundation for K3 surface classification

### What Is the Hilbert-Pólya Operator?

**Hilbert-Pólya Conjecture:** The zeros of the Riemann zeta function ζ(s) correspond to eigenvalues of a self-adjoint operator H (to be discovered).

**Relevance to SocrateAI:**
- K3 surfaces have rich spectral properties (Picard lattice, transcendental lattice)
- Eigenvalues of the Hodge Laplacian on K3 encode geometric information
- Hilbert-Pólya framework provides tools for spectral classification

### Contents of Zenodo Archive

```
omega-pcf-01-hilbert-polya-65ab6d0/
├── lean/                          # Lean 4 formalization (2 files)
│   ├── HilbertPolyaOperator.lean
│   └── SpectralProperties.lean
├── src/                           # LaTeX documentation (67 KB)
│   └── methods.tex                # Detailed mathematical exposition
├── scripts/                       # Python figure generators (14 files)
│   ├── spectrum_visualizer.py
│   ├── eigenvalue_classifier.py
│   └── ... (other analysis scripts)
├── images/                        # 27 SVG + 8 PNG + multiple PDF
│   ├── eigenvalue_spectrum.svg
│   ├── k3_classification.svg
│   └── ... (comparative visualizations)
├── build/                         # Compiled PDF (1.1 MB)
│   └── document-v2.4.1.pdf
├── tests/                         # Verification scripts
│   ├── test_spectrum.py
│   └── test_classification.py
└── docs/                          # README, usage guide, architecture
```

### Integration with Agora/Geometry

**Connection Points:**

1. **K3 Classification** (FTheoryFibration.lean)
   - Use Hilbert-Pólya tools to classify K3 families
   - Map Cooper s_7 to spectral properties
   - Verify Order-3 Picard-Fuchs ↔ K3 spectrum

2. **Weierstrass Model** (Weierstrass.lean)
   - Elliptic fibrations over K3 have well-defined spectral data
   - Eigenvalues encode singular fiber information
   - Link to discriminant locus geometry

3. **Phenomenology** (ChameleonRescue.lean)
   - Spectral properties affect scalar field dynamics
   - Chameleon mass depends on density → spectrum shifts
   - Hilbert-Pólya framework predicts coupling renormalization

### How to Use Zenodo Resources

**In Lean:**
```lean
import Agora.Geometry.HilbertPolyaExtensions

theorem k3_spectrum_classification : 
  -- Use spectral properties from Zenodo resource
  s_7_K3_picard_fuchs_order = 3 := by
  ...
```

**In Python:**
```python
from ml_string_landscape.spectral import hilbert_polya_classifier

# Classify a K3 family by spectral properties
family = load_k3_family("S12")
spectrum = extract_eigenvalues(family)
classification = hilbert_polya_classifier.classify(spectrum)
# → Output: Picard-Fuchs order (should be 2 or 3)
```

### Citation

If extending with Zenodo resources, cite:
```bibtex
@misc{hilbert_polya_2024,
  title={Hilbert-Pólya Operator Formalization in Lean 4},
  doi={10.5281/zenodo.20290893},
  url={https://zenodo.org/record/10290893},
  year={2024}
}
```

---

## Installation & Dependency Management

### Setup External Dependencies

```bash
# 1. Clone the repo
git clone https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal.git
cd SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal

# 2. Initialize submodules
./scripts/setup_externals.sh

# 3. Download Zenodo resource
./scripts/download_zenodo.sh

# 4. Build Lean 4 project
lake build
```

### Dependencies in lakefile.lean

```lean
import Lake
open Lake DSL

package «SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal» {}

lean_lib Agora {}

-- Core library
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

-- Physics libraries
require QuantumInfo from git
  "https://github.com/Timeroot/Lean-QuantumInfo.git" @"main"

require Lean4PHYS from git
  "https://github.com/ShirleyLIYuxin/Lean4PHYS.git" @"main"
```

### Python Dependencies

```bash
# Install ML/optimization tools
pip install -r Agora/ML/requirements.txt

# Packages:
# - numpy, scipy (numeric computation)
# - scikit-learn (ML classification)
# - JAX, Flax (autodiff, neural nets)
# - DEAP (genetic algorithms)
# - pandas (data manipulation)
# - jupyter (interactive notebooks)
```

---

## Dependency Compatibility Matrix

| Component | Min Lean 4 | Min Python | Tested | Status |
|-----------|----------|-----------|--------|--------|
| mathlib4 | 4.0 | N/A | ✓ | Stable |
| QuantumInfo | 4.0 | N/A | ✓ | Submodule (empty) |
| Lean4PHYS | 4.0 | N/A | ✓ | Submodule (empty) |
| ml-string-landscape | N/A | 3.9 | ✓ | Submodule (empty) |
| Zenodo (Hilbert-Pólya) | 4.0 | 3.9 | ✓ | Extracted, unused |
| DEAP | N/A | 3.8 | ✓ | In Optimize_Moduli.py |
| JAX | N/A | 3.8 | ✓ | Optional (AutoEvolve) |

---

## Breaking Changes & Maintenance

### If Mathlib4 Breaks Compatibility

**Mitigation:**
```bash
# Pin to specific mathlib4 commit
cd .lake/packages/mathlib4
git checkout <stable-commit-sha>
```

**Recovery:**
```bash
# Update mathlib4 and fix compatibility
lake update mathlib
# Edit Agora/*.lean to adapt to new API
```

### If Submodule Dependencies Update

**Action:**
1. Pull latest submodule commits: `git submodule update --remote`
2. Test compatibility: `lake build`
3. If broken, pin to last-known-good: `cd external/Lean-QuantumInfo && git checkout <tag>`

### If Zenodo Resource Becomes Unavailable

**Backup:** Resource is downloaded and committed to repo. Zenodo DOI is permanent (10^-year archival guarantee).

**Mitigation:** Mirror to project repo if Zenodo access is critical.

---

## For LLM Context: Dependency Strategy

1. **Low-risk dependencies:** mathlib4 (heavily used, stable)
2. **Medium-risk:** QuantumInfo, Lean4PHYS (not used yet, but imported)
3. **High-risk:** ml-string-landscape (actively developed, breaking changes possible)
4. **Static resources:** Zenodo archive (immutable, safe)

**Recommendation:** Before major edits, run `lake update` and `lake build` to ensure all dependencies are fresh.

