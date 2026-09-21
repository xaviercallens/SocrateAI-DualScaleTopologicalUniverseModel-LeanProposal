# CLAUDE.md — Stream 1: Theory (Lean 4)

Formal verification repo for the Dual-Scale program. Governing docs: `VISION.md` (esp. §1.3, §2),
`EXECUTION_PLAN.md` §2. Read the **lean-proof-workflow** skill before touching any .lean file and
the **epistemic-guardrails** skill before writing any prose.

📕 **Read [`LL.md`](LL.md) before quoting any gate, number or verification claim.** It is the
lessons-learnt file: what the gates can and cannot see, why a `sorry` does not fail the build, why
`axiom_audit.py` can never report green here, and the defect class in which a theorem is true,
compiles, passes every gate, and still proves less than its name says. §1 is the one to read if
you read one.

## Commands
- Build (full): **`lake build Agora OpenGoals Tests`**, or `lake build <Module>` (targeted).
  ⚠️ **Corrected 2026-09-20: a bare `lake build` builds NOTHING and still exits 0** — the package
  declares no `default_target`, so it prints "no targets specified … Nothing to build." Treating
  that exit code as a green build is a false PASS. Always name the targets.
- Tests: `lake build Tests` (golden numeric checks vs literature values)
- Open goals: `python3 scripts/export_open_goals.py` → `open_goals.json` (machine-consumed by Stream 2; never hand-edit)

## Non-negotiable rules
1. Never `lake update`; toolchain and Mathlib pin are frozen (missing API → OPEN_GOALS.md "blocked-on-mathlib").
   **Current pin (T0 decision, 2026-09-20): Lean `v4.34.0-rc2` + Mathlib tag `v4.34.0-rc2`**
   (commit `85e3a25e006c35636f0e53b0e9296caca2685bc0`), chosen to match
   `SocrateAI-Scientific-Agora-LeanMaster` so the two share one olean cache.
   Previous pin: Lean `v4.32.0` + Mathlib `3dffaf2f18b47d11948f6390838ea6f2ae662aaf`.
   **Second dependency (T0 decision, 2026-09-20): `SocrateAI-Scientific-Agora-LeanMaster`**
   at release tag `v3.33.0` (commit `61fc58d599182185613e1460861e48d6c7dd39a7`), required
   **from git by tag, never by local path** — LeanMaster is under active concurrent
   development on this machine and its working tree is routinely dirty, so a `packagesDir`
   dependency would make this build depend on another session's uncommitted state.
   It requires the same Mathlib tag, so the graphs unify (`mathlib` appears once in
   `lake-manifest.json`). Exercised by `Agora/Bridge/LeanMasterK3.lean`, which is imported
   from `Agora.lean` so `lake build Agora` actually compiles against it.
   The freeze is not lifted — it has been re-pointed twice, both times by T0, and
   `lake update` is again forbidden without a new dated T0 decision recorded here.
   **T0 decision 2026-09-21 — the LeanMaster pin STAYS at `v3.33.0`.** LeanMaster released
   `v3.45.0`; the re-point was considered and **declined**. Reason: this repo consumes only
   `Gram`, `IsEvenDiag`, `IsUnimodular`, `hyperbolicU`, `latticeNorm`, `Signature`/`sigK3`,
   `e8Neg`, `reflection` and `eta` — all stable at `v3.33.0` — and the one new result worth
   having (`sym2_is_substitution`) was re-derived here independently and generalized to an
   arbitrary `CommRing`, so nothing is imported for it. A version bump with no consumer is
   precisely what this freeze exists to prevent, and it would cost a full rebuild plus
   re-verification of every theorem citing their lemmas, against a dependency under active
   concurrent development. Revisit only when a specific theorem here needs something only a
   newer LeanMaster provides; the tag will be there.
2. `axiom` only in `Axioms/`, registered in `AXIOMS.md` (hook-enforced).
3. `sorry` on branches only; on `main` only inside `OpenGoals/`.
   ⚠️ **Not CI-enforced — corrected 2026-09-20.** This rule previously claimed "(CI-enforced)".
   There is no CI: the repo has no `.github/` directory at all. The only mechanism is
   `.claude/hooks/lean_guard.sh`, a Claude Code `PostToolUse` hook, which (a) runs only when
   *Claude* edits a `.lean` file in a session that loads `.claude/settings.json`, (b) *blocks*
   an `axiom` outside `Axioms/` (rule 2), but (c) only *warns* about a `sorry` outside
   `OpenGoals/` — it exits 0. A hand edit, another tool, or any `git commit` bypasses all of it.
   Treat rules 2 and 3 as honour-system on the human side and verify by hand before claiming
   compliance. See `briefs/MEMO_LEAN_4_34_MIGRATION_2026_09_20.md` §5.
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
