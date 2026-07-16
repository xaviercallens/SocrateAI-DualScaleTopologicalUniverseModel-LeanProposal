# SocrateAI Project Memory Index

**Last Updated:** 2026-07-16  
**Optimization Level:** Fable 5 / High-Cost LLM Ready  
**Token-Efficient Briefing:** This index maps all critical project knowledge for rapid context-loading.

---

## 📋 Quick Project Identity

- **Name:** SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal
- **Purpose:** Machine-checkable formal verification of F-theory string cosmology with dark matter/dark energy predictions
- **Status:** v0.1 release, 1,551 lines Lean 4 code, **0 sorry** (complete proofs)
- **Core Achievement:** First formal proof of internal consistency for an F-theory string cosmology model
- **Author:** Xavier Callens (callensxavier@gmail.com)

---

## 🗂️ Memory Files (Read in Order)

| File | Focus | For Questions About |
|------|-------|---------------------|
| **[[project_architecture]]** | High-level goals, structure, interdisciplinary bridge | "What is this project building?" "How do the pieces fit?" |
| **[[lean4_core_theorems]]** | The three main theorems and their proofs | "What are we proving?" "How do the proofs work?" |
| **[[ftheory_formalization]]** | F-theory geometric concepts, K3 surfaces, Weierstrass models | "What is K3?" "How is Weierstrass model formalized?" |
| **[[ml_pipeline_guide]]** | ML components, genetic algorithms, moduli optimization, AutoEvolve | "How do ML tools integrate?" "What does Optimize_Moduli do?" |
| **[[dependencies_integration]]** | External libraries, submodules, Zenodo resources, mathlib4 usage | "Which external libraries matter?" "Where are dependencies?" |
| **[[axioms_constraints_inventory]]** | Complete axiom list, empirical vs. numerical, swampland constraints | "What axioms does the proof use?" "What are the constraints?" |
| **[[file_navigation_guide]]** | Critical files by role, edit patterns, where to find things | "Which file should I edit?" "Where is the chameleon mechanism?" |
| **[[ml_moduli_space_notes]]** | Deep dive into moduli stabilization, LVS parameters, optimization strategy | "How does moduli stabilization work?" "What is LVS?" |

---

## 🎯 Core Theorem Structure

**Three theorems woven into one unified proof:**

1. **Theorem 1 (Classification):** S_{1,2} elliptic curve (Order-2 Picard-Fuchs) ≠ Cooper s_7 K3 (Order-3)
2. **Theorem 2 (Stability):** Moduli stabilization; Hessian-positive LVS vacuum; Swampland-safe
3. **Theorem 3 (Observational):** Chameleon mechanism rescues S_{1,2} axion from M87* superradiance

**Master Theorem:** All three hold ⟹ Model is geometrically sound, dynamically stable, and observationally viable.

---

## 🧠 Critical Patterns for LLM Work

### When Editing Lean 4 Proofs
- **Rule:** Never introduce `sorry`. Proofs must be complete.
- **Structure:** Each theorem lives in its own `.lean` file under `Agora/`.
- **Imports:** All theorems import from `Mathlib.Data.Real.Basic` and `Mathlib.Tactic`.
- **Style:** Use structured `by` tactics, prefer `exact` over `simp`, leave comments for non-obvious steps.

### When Extending ML Components
- **Genetic Algorithm:** DEAP-based in `Optimize_Moduli.py`; fitness = moduli stability + observational fit.
- **AutoEvolve:** Classifies Picard-Fuchs ODE order via ML in Jupyter notebook.
- **Dependencies:** JAX/Flax for autodiff; scikit-learn for classification; DEAP for evolution.

### When Discussing Physical Constraints
- **Swampland Distance Conjecture (SDC):** τ_Δ < c_1 (field distance bounded)
- **LVS Parameters:** A, B, a, b > 0 (control moduli stabilization depth)
- **M87* Bound:** α_eff > 0.42 (effective coupling must exceed critical value for axion safety)

---

## ⚡ Why This Matters (Context for Fable 5)

This is **not** a typical software project. It's a **physics formalization** where:

1. **Axioms are empirical/numerical certificates** — not arbitrary choices. Each axiom has a source (AutoEvolve pipeline, GPU computation, observable data).
2. **Proof structure mirrors physics intuition** — The three theorems each answer a physical question: (1) Are the mathematical objects distinct? (2) Is the vacuum stable? (3) Does nature allow it?
3. **Interdisciplinary coherence is load-bearing** — Lean proofs, Python ML, algebraic geometry, and observational astronomy are tightly coupled. Edits ripple across layers.
4. **"0 sorry" is the goal, not the starting point** — Every incomplete proof breaks the model. This is not a research playground; it's a completed formal theorem.

---

## 🔗 Integration Points (Critical for High-Cost LLM Work)

- **Mathlib4 ↔ Agora:** Core types (ℝ, natural numbers, exp, inequalities) flow from mathlib.
- **QuantumInfo ↔ Phenomenology:** Quantum field theory concepts bridge to chameleon mechanism.
- **Lean4PHYS ↔ Geometry:** Physics notation/types integrate with algebraic geometry.
- **ML ↔ Axioms:** AutoEvolve pipeline outputs become axioms (Picard-Fuchs degrees, bounds).
- **Zenodo (Hilbert-Pólya) ↔ Agora:** Spectral theory foundation for K3 surface classification.

---

## 🎓 Recommended Reading Order for LLM Context

1. **Start here:** [[project_architecture]] (5 min read)
2. **Understand the theorems:** [[lean4_core_theorems]] (10 min)
3. **Dive into specifics:** [[ftheory_formalization]] OR [[ml_pipeline_guide]] (depends on task)
4. **When blocked:** [[axioms_constraints_inventory]] (audit assumptions)
5. **For edits:** [[file_navigation_guide]] (find the right file)

---

## 📊 Key Statistics

- **Lean 4 Code:** 1,551 lines across 9 files
- **Python ML:** 36 files, primarily in `Agora/ML/`
- **Axioms:** 6 total (3 empirical, 3 numerical certificates)
- **External Dependencies:** mathlib4, QuantumInfo, Lean4PHYS, ml-string-landscape
- **Proof Sorries:** **0** (all theorems complete)

---

## 🚨 Common Pitfalls for New Contributors

1. **Adding a new axiom:** Must document source (empirical pipeline or numerical cert). Update `DualScaleMaster.lean` axiom inventory.
2. **Modifying ML fitness function:** Impacts which solutions are "stable"; affects which axioms hold.
3. **Changing Picard-Fuchs classification:** Breaks Theorem 1 if Order-2 ≠ Order-3 assumption violated.
4. **Ignoring Swampland constraints:** SDC violation invalidates Theorem 2 (moduli stabilization).

---

## 🔄 For Autonomous/Batch LLM Work

If using this with Fable 5 for multi-turn tasks:

1. **Pre-compute:** Load [[lean4_core_theorems]] into context before attempting proofs.
2. **Constraint-aware:** Reference [[axioms_constraints_inventory]] when proposing changes.
3. **Test axioms:** After any ML edit, verify axiom derivation still holds.
4. **Commit pattern:** One theorem per commit; update MEMORY.md if architectural changes.
5. **Cost optimization:** Avoid re-reading Zenodo resources (27 MB); reference only when extending spectral theory.

---

## 📝 Update Log

- **2026-07-16:** Initial comprehensive memory created for Fable 5 optimization
