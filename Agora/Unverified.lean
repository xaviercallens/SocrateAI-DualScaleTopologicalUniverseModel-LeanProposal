/-
  Agora/Unverified.lean
  ════════════════════════════════════════════════════════════════════════════════

  ⚠️  QUARANTINE. NOTHING IN THIS DIRECTORY IS A PHYSICS RESULT.

  Everything under `Agora/Unverified/` is retained, compiles, and is kernel-checked
  in the narrow sense that its Lean statements are proved. That is all. **No
  declaration here establishes a physical claim**, and several have names and
  docstrings that read as though they do. They are kept rather than deleted so the
  record stays legible; they are separated rather than left in place so that the
  directory tree says what the epistemic tiers say.

  ────────────────────────────────────────────────────────────────────────────────
  WHY THIS DIRECTORY EXISTS (2026-09-21)

  A systematic name-vs-statement audit found nine defects of one class across this
  repository and its sibling: a theorem that is true, compiles, and passes every
  gate — the audit of axioms, the statement lock, the `sorry` grep — while proving
  **less than its name says**, the claim living in the identifier and the
  docstring rather than in the statement.

  **Every one of them landed in these five files.** Not one landed in the
  arithmetic and lattice core (`Agora/Sequences/`, `Agora/Geometry/`,
  `Agora/Swampland/SymSquareC3b.lean`), which held up under direct attack. That
  asymmetry is the reason for the split: leaving these modules interleaved with
  the verified core made the file tree imply a parity that VISION §2 explicitly
  denies.

  WHAT IS ACTUALLY IN HERE

  * `DualScaleMaster.lean` — `dual_scale_universe_model_consistent`, whose
    docstring claims the model is "Dynamically stable", "Observationally viable
    (consistent with EHT M87* data)" and "the first machine-checkable proof of
    internal consistency for an F-theory string cosmology". Two of its three
    conjuncts are `∃ v : ℝ, v > 0.45` (witness `1`) and "a product of positive
    reals is positive". Filed as **E-013**; disposition is a T0 decision.
  * `DualScaleStability.lean` — `master_moduli_stabilization`, whose conjunct (v)
    is a bare existential discharged from the DISCLOSED-VACUOUS axiom
    `pipeline_upper_bound`. Its docstring's "S_{1,2} ≤ 1.177" appears nowhere in
    the statement.
  * `ChameleonRescue.lean` — M87* chameleon numerics.
  * `DiscriminantLocus.lean` — an F-theory "physical dictionary" mapping Δ_obs to
    dark-matter subhaloes and Kodaira types to gauge algebras. ⚠️ The Kodaira
    reading is a **category error retracted as E-008/E-009** (CLAUDE.md ledger
    item 3): the finite singular loci are order-2 elliptic points of X₀(n)⁺, not
    Kodaira degenerations.
  * `Phenomenology.lean` — the former aggregator, retained.

  THE GOVERNING CONSTRAINT

  **Tier C is blocked program-wide (F5b.)** No exact observable (m_φ, α_D, Λ_D)
  exists anywhere in this program. Nothing here supplies one, and nothing here may
  be cited as evidence for one. A genuine rebuild of Theorem 2 or Theorem 3
  therefore cannot be attempted until that block lifts — which is why these
  modules are quarantined rather than repaired.

  NOTHING IN `Agora/` OUTSIDE THIS DIRECTORY IMPORTS IT. The verified core does
  not depend on any declaration here, and the split is enforced by that absence
  rather than by convention. `lake build Agora` still compiles this directory, so
  the quarantine is epistemic, not a build exclusion: the claim is "this is not
  evidence", never "this does not compile".

  See `briefs/ESCALATIONS.md` E-013 and its three companions.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Unverified.DiscriminantLocus
import Agora.Unverified.ChameleonRescue
import Agora.Unverified.Phenomenology
import Agora.Unverified.DualScaleStability
import Agora.Unverified.DualScaleMaster
