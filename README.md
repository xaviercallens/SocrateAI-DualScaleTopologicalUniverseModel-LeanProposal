# Stream 1 — Theory: Lean 4 Formalization

**Dual-Scale Topological Universe Model: Arithmetic & Formal Verification**

This is **Stream 1** of the Dual-Scale Topological Universe Model project. Its role is to **machine-certify the mathematical claims** (Tier A) and formalize the conjectures (Tier B) in Lean 4.

**See [VISION.md](VISION.md) for the full project scope, roadmap, and epistemic framework.**

---

## What This Repository Does

- **Formalizes Cooper sequences** as holonomic Picard-Fuchs ODEs.
- **Proves arithmetic properties**: order-3 operator = symmetric square of order-2, congruence relations, integrality of mirror maps.
- **Bridges to K3 geometry** via clearly-marked axiomatized conjectures, so proof obligations are machine-readable.
- **Targets Mathlib contribution**: full algebraic-geometric machinery (K3 surfaces, Kodaira classification) is a 12–24 month horizon.

This repository is **not** responsible for:
- Ranking K3 candidates (→ Stream 2, `SocrateAI-Scientific-Agora-K3-DarkMatter`)
- Testing predictions against data (→ Stream 3, `SocrateAI-Scientific-Agora-Home`)

---

## Key Documents

1. **[VISION.md](VISION.md)** — The master vision document. Read this first.
2. **[K3_CRITERIA.md](K3_CRITERIA.md)** — Frozen criteria for ranking K3 candidates (Tier A/B properties). Stream 2 uses this.
3. **[PREDICTION.md](PREDICTION.md)** — Draft falsifiable predictions. Stream 3 tests these against data.
4. **[PHASE_8_FTHEORY_PROPOSAL.md](docs/PHASE_8_FTHEORY_PROPOSAL.md)** — Previous F-theory proposal (for context).

---

## Repository Structure

```
.
├── Agora/                  # Lean 4 formalizations
│   ├── Sequences/          # Cooper sequences and recurrences
│   ├── Operators/          # Picard-Fuchs ODEs and symmetric squares
│   ├── Geometry/           # K3 surface conjectures (axiomatized)
│   ├── Swampland/          # Swampland constraints
│   └── Physics/            # Physical observables
├── docs/                   # Documentation and references
├── data/                   # Test data and sequence values
├── external/               # External Lean/math libraries
└── scripts/                # Automation (testing, verification)
```

---

## Building & Testing

```bash
# Clone and set up
git clone https://github.com/xaviercallens/SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal.git
cd SocrateAI-DualScaleTopologicalUniverseModel-LeanProposal
./scripts/setup_externals.sh

# Build the Lean 4 proofs (no `sorry` stubs in kernel)
lake build
```

---

## Roadmap (from VISION.md)

| Phase | Dates | Deliverable |
|-------|-------|-------------|
| **Phase 0** | Weeks 1–2 | VISION.md, K3_CRITERIA.md, draft PREDICTION.md (all three repos) |
| **Phase 1** | Months 1–2 | Finalize falsifiable prediction (M1) |
| **Phase 2** | Months 2–8 | Lean arithmetic formalization + arXiv preprint (M2) |
| **Phase 3** | Months 8–14 | Stream 3 observational report (M3) |
| **Phase 4** | Months 14–18 | Final manuscript(s) |

**This repo's focus:** Phase 2 (months 2–8).

---

## Contact & Collaboration

- **Author:** Xavier Callens (callensxavier@gmail.com)
- **Feedback:** Open issues or PRs. Mathematical results should be reviewed by the modular-forms / mirror-symmetry community before claiming Tier A status.
- **External math libraries:** See `external/` for credits (Lean-QuantumInfo, Lean4PHYS, etc.)
