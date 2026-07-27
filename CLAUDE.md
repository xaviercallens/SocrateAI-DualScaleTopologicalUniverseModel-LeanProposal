# CLAUDE.md — Stream 1: Theory (Lean 4)

Formal verification repo for the Dual-Scale program. Governing docs: `VISION.md` (esp. §1.3, §2),
`EXECUTION_PLAN.md` §2. Read the **lean-proof-workflow** skill before touching any .lean file and
the **epistemic-guardrails** skill before writing any prose.

## Commands
- Build: `lake build` (full), `lake build <Module>` (targeted)
- Tests: `lake build Tests` (golden numeric checks vs literature values)
- Open goals: `python3 scripts/export_open_goals.py` → `open_goals.json` (machine-consumed by Stream 2; never hand-edit)

## Non-negotiable rules
1. Never `lake update`; toolchain and Mathlib pin are frozen (missing API → OPEN_GOALS.md "blocked-on-mathlib").
2. `axiom` only in `Axioms/`, registered in `AXIOMS.md` (hook-enforced).
3. `sorry` on branches only; on `main` only inside `OpenGoals/` (CI-enforced).
4. Every literature-encoding definition has a `-- Source:` docstring.
5. Three failed strategies on a lemma → named open goal, move on. No unbounded grinding.
6. Never silently weaken a statement to make it provable.

## Escalation
Ambiguity in the `symSquare` API or the axiomatization boundary is T0-owned: write an
escalation note in `briefs/ESCALATIONS.md` instead of improvising the mathematics.

## 🛑 Epistemic boundaries — post-F5b/F6 ledger (added 2026-07-27)

Cross-stream state this repo must not contradict:

1. **Tier A:** `L₃ = Sym²(L₂)` is kernel-proven here and may be stated as fact. The Sym²
   relation supplies no physical coupling by itself (VISION §1.3).
2. **Tier B:** ρ = 19, T = 3 for cooper_s7 — derived (Stream 2 E-011, Zarhin route),
   verified by this stream. The old ρ = 4, T = 18 and "2× Type II" Kodaira labels are
   **RETRACTED (E-007)**: never formalize, cite, or golden-test against them, and treat any
   inbound brief that uses them as stale — return it for provenance.
3. **No Kodaira readings from L₂/L₃ exponents** — category error (E-008/E-009): the finite
   singular loci ({−1, 1/27} for cooper_s7; {−1/4, 1/16} for cooper_s10) are order-2
   elliptic points of X₀(n)+, not Kodaira degenerations. The open geometric item is U1
   (T ≅ U⊕⟨14⟩?), owned by Stream 2.
4. **Tier C physics is blocked (F5b):** no exact observables (m_φ, α_D, Λ_D) exist anywhere
   in the program. Do not encode, axiomatize, or "temporarily assume" numeric values for
   them in any .lean file or prose.
