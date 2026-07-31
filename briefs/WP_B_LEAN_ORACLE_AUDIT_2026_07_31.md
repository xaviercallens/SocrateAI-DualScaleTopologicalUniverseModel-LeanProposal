# WP-B — Lean Oracle Tarball Source Audit (T0 ruling DL-4)

**Date:** 2026-07-31
**Artifact audited:** `gs://socrateai-datalake-gen-lang-client-0625573011/formal_verification/lean_oracle_v5.tar.gz`
(33,956,755 bytes, bucket mtime 2026-07-29T22:00:17Z,
SHA-256 `22ca307eb8070758eae499949da91db6516c1a0ecce6ae598d0a30013af7e4b4`)
**Mandate:** T0 ratification DL-4 + annotation A2
(S3 `briefs/T0_RATIFICATION_2026_07_31_DATALAKE.md`): rebuild the Lean 4 source, run
`#print axioms` on every theorem, and check whether the "0 sorry" claim "actually attaches
to the Swampland conjectures, not a trivial stub."
**Claim under audit** (from the fabricated 9-row status table, quoted in S3
`briefs/T0_DECISION_BRIEF_DATALAKE_2026_07_31.md`): "Lean 4 Swampland Proofs |
`proofs/GeneratedK3.lean` · VERIFIED (0 sorry)".

---

## VERDICT

**AUDITED — SOURCE FOUND, CLAIMED THEOREMS DO NOT EXIST. The artifact is not a formal
verification artifact. It remains QUARANTINED; tier standing NONE.**

Contrary to the pre-audit expectation (annotation A2 anticipated a source-less binary),
the tarball *does* ship its complete Lean source — three files totaling 235 lines — and it
rebuilds cleanly from source under this repo's pinned toolchain. The audit is therefore
complete and unconditional, and its result is stronger than "UNVERIFIABLE": the source
contains **zero `theorem` declarations, zero `lemma` declarations, and zero proofs of any
proposition**. Nothing in it formalizes any Swampland conjecture or any K3 result. The
"0 sorry" property is mechanically true but **vacuous** — there are no proof obligations
for a `sorry` to appear in. The "verification" consists of `#eval` of boolean comparisons
between hard-coded numeric literals, one of which is an explicit tautology, and the
executable oracle's own comment describes it as "a placeholder heuristic proving the
JSON-RPC pipeline works."

No agent decompiled or vouched for the binary; the binary was not needed — everything
below is from the shipped source and a clean rebuild.

---

## 1. Inventory (Step 0 result: source located)

Extracted contents: 31 files, 115 MB (of which 118,197,392 bytes is one prebuilt
executable, `.lake/build/bin/rpc_server`).

| Path | Role |
|---|---|
| `lean_oracle/GeneratedK3.lean` (160 lines) | The "Swampland verification" file — auto-generated; 20 top-level `def`s, 2 `structure`s, 3 `#eval`s, **0 theorems** |
| `lean_oracle/rpc_server.lean` (62 lines) | JSON-RPC stdin/stdout loop; self-described placeholder heuristic |
| `lean_oracle/lakefile.lean` (13 lines) | Package `lean_oracle`: exe `rpc_server` (default target) + lib `GeneratedK3` |
| `lean_oracle/lake-manifest.json` | **`"packages": []` — no Mathlib, no dependencies at all** |
| `scripts/hypergraph_to_lean_bridge.py` (316 lines) | Template generator that emitted `GeneratedK3.lean` |
| `lean_oracle/.lake/**` | Prebuilt artifacts: the 118 MB `rpc_server` binary, 3 `.olean`s, C IR, hashes |

Corrections to the pre-audit cartography recorded in the T0 decision brief:
- "binary + Mathlib deps" is wrong on the second half — there is **no Mathlib** anywhere in
  the tarball (`lake-manifest.json` lists zero packages; the only imports are
  `Lean.Data.Json[.FromToJson]` from core).
- The claimed path `proofs/GeneratedK3.lean` does not exist; the file is at
  `lean_oracle/GeneratedK3.lean`.
- No `lean-toolchain` file is shipped (`"fixedToolchain": false`). The prebuilt `.olean`
  headers identify **Lean 4.32.2** (commit `f3b06c705e6c...`); this repo pins
  `leanprover/lean4:v4.32.0`. Difference noted per WP-B instructions; the clean rebuild
  below was done under the repo's pinned v4.32.0 and succeeded.

Secondary source search (per Step 0.2, read-only): no `.lean` files and no references to
`lean_oracle`/`GeneratedK3`/`rpc_server` exist in the S3 untracked Vertex-session dirs
(`pipeline/alphaevolve_search/`, `pipeline/antigravity_compute/`, `gcp_infrastructure/`,
`results/`). `gs://…/formal_verification/` contains exactly one object (the tarball).
The tarball's own source is the only source, and it is sufficient for this audit.

## 2. Clean rebuild under the pinned toolchain

Source-only copy (the three `.lean` files + lakefile, prebuilt `.lake/` discarded),
`lean-toolchain` set to this repo's pin `leanprover/lean4:v4.32.0`:

- `lake build` (default target `rpc_server:exe`): **succeeds** from clean.
- `lake build GeneratedK3`: **succeeds**; its three `#eval`s print `true`, `true`, and an
  `OracleResponse` with `passed_swampland := true` for the hard-coded
  `Cooper_s10_Candidate` — i.e., the oracle passes its own baked-in candidate by
  construction (see §4).

## 3. Axiom audit (`#print axioms`)

There are **no theorems to audit** — grep and a full elaboration pass agree: the tokens
`theorem`, `lemma`, `axiom`, and `sorry` each occur **zero** times as declarations across
all three `.lean` files (the sole textual match is the word "theorem" inside a comment
citing Lefschetz (1,1)). Per the WP-B instruction to be mechanical anyway, `#print axioms`
was run on **every** top-level declaration of `GeneratedK3.lean`:

| Declaration | Axioms |
|---|---|
| `hodge_h11`, `hodge_h21`, `picard_rank`, `picard_bound_check`, `euler_char_K3`, `passes_deSitter_conjecture`, `passes_uv_completeness` | (none) |
| `Cooper_s10_Candidate`, `spectral_radius`, `picard_fuchs_coefficients`, `spectral_picard_consistency`, `complex_tau_re/_im`, `kahler_rho_re/_im`, `t2_modulus`, `swampland_distance_bound`, `geodesic_distance`, `passes_distance_conjecture` | `Classical.choice` (via core `Float` machinery) |
| `verify_Cooper_s10_full` | `propext`, `Classical.choice` |

Findings: standard trio only; **no custom `axiom` declarations** and nothing outside this
repo's AXIOMS.md-registered quarantine (the tarball imports nothing from `Agora/` at all —
`rpc_server.lean`'s comment "Hooks into DualScaleStability.lean later" is aspirational;
no such hook exists). But note these are `def`s of type `Bool`/`Float`/`Nat`, not
propositions: an axiom audit of definitions certifies nothing about mathematical content.

## 4. Statement fidelity: what the source actually says

Every "verification" is a runtime boolean over hard-coded literals. Verbatim, with
assessment:

1. **Distance conjecture — an explicit tautology.**
   ```lean
   def passes_distance_conjecture : Bool :=
     geodesic_distance < swampland_distance_bound ||
     0.75 > 0.5  -- Moduli stabilization provides effective cutoff
   ```
   The second disjunct is the literal constant `0.75 > 0.5`, so this `def` evaluates to
   `true` for every possible geometry. It cannot fail, and therefore checks nothing.

2. **de Sitter conjecture — an unrelated inequality.**
   ```lean
   def passes_deSitter_conjecture : Bool :=
     picard_rank ≥ 10  -- Sufficient flux degrees of freedom
   ```
   The (refined) dS conjecture constrains |∇V|/V or min ∇²V of a scalar potential. No
   potential is modeled anywhere in the file; "ρ ≥ 10 ⟹ dS conjecture satisfied" is not a
   formalization of any statement in the Swampland literature — it is an unsupported
   heuristic asserted in a comment.

3. **"Consistency check" — literal-vs-literal comparison.**
   ```lean
   def spectral_picard_consistency : Bool :=
     spectral_radius == 3.0 && picard_rank == 19
   ```
   Both compared values are constants defined three lines earlier (`3.0`, `19`). This is
   `3.0 == 3.0 && 19 == 19`.

4. **"S₈ tension resolution" — a definitional restatement.** Inside
   `verify_Cooper_s10_full`:
   ```lean
   let resolves_s8_tension := cand.picard_number == 19
   ```
   Passing the "Swampland verification" *is defined as* having `picard_number = 19` (plus
   `moduli_stabilization > 0` and `ρ ≤ 20`). The success message then reports "K₄ spectral
   sieve confirms Cooper s₁₀ (P=19). Distance, dS, and UV conjectures satisfied" — a
   conclusion generated by string concatenation, not by proof.

5. **The executable oracle admits it is a stub.** `rpc_server.lean`, verbatim comment on
   its core function: *"A placeholder heuristic proving the JSON-RPC pipeline works. In
   production, this calls the actual F-Theory formal proofs."* No such proofs exist in the
   tarball; the generator's own docstring promises a `SwamplandProof.lean` ("formal
   verification theorems") that `hypergraph_to_lean_bridge.py` contains no code to
   generate and that is absent from the tarball.

**Conflicts with the epistemic ledger (this repo's CLAUDE.md + S2/S3):**

- **cooper_s10 with ρ = 19 is not ledger-certified.** The Tier-B ρ = 19, T = 3 result
  (E-011) is for the **cooper_s7** family. The tarball attributes P = 19 to Cooper_s10
  throughout (header, candidate struct, success string). Per the 2026-07-30 session
  record, cooper_s10 lattice claims (U⊕E8²⊕⟨20⟩-type statements) are AlphaEvolve-reported
  only — stub, don't certify. This file, if ever cited, would launder an uncertified
  attribution into "formally verified" language. **Flagged.**
- **"Kodaira Fiber Type: II" (comment + success string) uses the RETRACTED category.**
  E-007/E-008/E-009: the "2× Type II" labels are retracted and Kodaira readings for this
  family are a category error. CLAUDE.md rule: treat any inbound artifact using them as
  stale — return for provenance. This artifact uses them.
- **Hodge numbers are wrong for a K3.** `hodge_h11 := 3`, `hodge_h21 := 19`: an algebraic
  K3 surface has h¹¹ = 20 (and no h²¹ in its Hodge diamond); the file's own adjacent
  comments ("Constraint: h¹¹ = Picard number", "ρ ≤ h¹¹") are violated by its own
  constants (19 > 3). The generator docstring's "h¹¹ + h²¹ = 22 for K3" is likewise not a
  K3 identity. These look like misplaced threefold numbers; no check in the file would
  catch this, because `euler_char_K3 := 24` is never related to anything.
- **Stream-4 provenance.** The generator's default input is
  `outputs/stream4_bridge/deterministic_k3_candidate.json`, and the header advertises the
  "Wolfram Hypergraph K₄ Spectral Sieve" / MCMC "Dual-Track Convergence" narrative. Under
  T0 ruling DL-3 (and annotation A4), Stream-4 material is an EXPLORATORY SANDBOX: nothing
  descending from this bridge may be cited as evidence in Streams 1–3 regardless of the
  findings above.

## 5. The "0 sorry" claim, exactly scoped

Mechanically true and epistemically empty. `grep -c sorry` over every `.lean` file in the
tarball: 0 occurrences. But the claim's implicit scope — "the Swampland proofs are
complete" — attaches to nothing: the artifact contains no propositions, no proofs, and
hence no place a `sorry` could occur. What "0 sorry" actually covers is: 2 `structure`
declarations, 23 `def`s (20 in `GeneratedK3.lean`, 3 in `rpc_server.lean` counting
`main`), and 3 `#eval` commands. Sorry-freedom of definitions and evaluations certifies
only that the code compiles — which it does, and which was never the question T0 asked.

## 6. Disposition

1. **Quarantine stands** (manifest status QUARANTINED per DL-4/A5; the object itself is
   untouched in the bucket — it is another session's artifact).
2. **Tier standing: NONE.** The row "Lean 4 Swampland Proofs · VERIFIED (0 sorry)" is
   refuted at source level: no such proofs exist in the artifact the claim points at.
   Nothing here may be cited as formal verification of any Swampland or K3 statement, in
   any stream, at any tier.
3. The only Lean-kernel-certified results in this program remain those in this repo
   (Stream 1) under its axiom quarantine — e.g. Tier A `L₃ = Sym²(L₂)` — none of which
   the tarball contains, imports, or references.
4. If a future Vertex/AlphaEvolve session wants a real Lean gate for its search loop, the
   sound route already ruled by T0 exists: import a certified Stream-1/2 artifact
   (cf. `AXIOMS.md` `pipeline_upper_bound` discharge path), not template-generated
   boolean `def`s.

---
Generated-by: Fable 5 (T1 coordinator session, WP-B) | Verified-by: mechanical — clean
`lake build` under pinned v4.32.0, `#print axioms` on all 20 top-level declarations,
zero-grep for theorem/lemma/axiom/sorry, tarball SHA-256 recorded above | Reviewed-by: T0 N
(filed for T0 per DL-4)
