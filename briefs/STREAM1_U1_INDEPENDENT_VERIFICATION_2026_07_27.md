# Stream 1: independent verification of Stream 2's U1 U-splitting claim (E-011 pattern)

**Date:** 2026-07-27 · **From:** Stream 1 · **Type:** independent verification
(optional item 1 of `briefs/STREAM2_TO_STREAMS1_3_U1_CLOSED_2026_07_27.md`) ·
**Scope:** the U-splitting finite exact claim in `C2_cooper_s7_v4.json` only —
no other part of U1 (monodromy recognition, T-identification) touched.

## What was checked

Stream 2's U1 pipeline derives a primitive even Gram matrix `G` for the joint
monodromy-invariant lattice of the cooper_s7 family, and claims `G` is isometric
over Z to `U + <14>` via an explicit unimodular integral base change. That is a
finite, exact, mechanically checkable statement, in the same spirit as the
E-011 independent-reproduction pattern (`briefs/STREAM1_GUIDANCE_ON_E011_E012_WPE_2026_07_26.md`).

**Certificate checked:** `data/certificates/C2_cooper_s7_v4.json` in the Stream 2
repo (`SocrateAI-Scientific-Agora-K3-DarkMatter`) — the **LIVE** version, T0-accepted
2026-07-27 (per its own `status` and `t0_acceptance` fields, recorded in
`briefs/T0_DECISIONS_2026_07_27_STREAM2.md` of that repo).
**SHA256:** `036cd895db892aee9802514ec18668535f8896cee53cf6123533af9844387c3e`

(The DRAFT predecessor, `C2_cooper_s7_v4_DRAFT.json`,
SHA256 `22593a382f889a2e7b1e1e768644049fa31b2b5b36c49d5ee118d18a62d6f608`, was also
run through the same checker and PASSes identically — its `derived` block is
byte-identical to the LIVE file's.)

## How it was verified

Two new files in this repo, `checkers/check_U1_splitting_independent.py` and
`checkers/test_U1_splitting_independent_controls.py`:

- Loads the certificate at runtime (default path, overridable with `--cert`).
- Reads `derived.gram_primitive_even` (G) and `derived.u_splitting.d` from the
  certificate as given input. **Never hardcodes `-14` or `14` outside a labeled
  control** — the expected target matrix `U + <d>` is assembled at runtime from
  `d` as read from the certificate.
- Does **not** import, call, or reuse any code from Stream 2's
  `checkers/check_U1_lattice.py`. That script computes a base-change matrix `P`
  in memory (`stage3_lattice()`) but only serializes `det(P)` and `P^T G P` to
  the certificate — the matrix itself is not stored. So this check re-derives
  its own witness `P` from `G` alone, via an independently written,
  exact-integer construction: find a primitive isotropic vector with
  unimodular `G`-pairing, complete it to a hyperbolic pair via an extended-gcd
  Bezout combination, and take the cross-product-derived orthogonal-complement
  generator. All arithmetic is Python `int` (exact), no floats anywhere.
- Verifies: `G` symmetric/integer/even; `det(G)` and Sylvester signature match
  the certificate's own claimed values; the independently constructed `P` is
  integral with `det(P) = ±1` (i.e. `P ∈ GL₃(ℤ)`); `PᵀGP` equals the
  runtime-derived target `U + <d>`.
- Result: the independently constructed `P = [[1,0,0],[0,0,-1],[0,-1,0]]`
  (columns), `det(P) = -1`, gives `PᵀGP = [[0,1,0],[1,0,0],[0,0,14]]` — which
  **also happens to equal the certificate's own reported `gram_after` exactly**
  (informational bonus check, not required for PASS, since a different valid
  witness would have been an equally valid proof).

**Verdict: PASS.** Two independently written, exact-arithmetic implementations
(Stream 2's sympy pipeline, and this from-scratch pure-Python construction)
agree on the isometry `G ≅ U + <14>`.

## Negative controls (mandatory, all exercised and behaving correctly)

1. **Scrambled G** — perturbing one entry of the certificate's Gram
   (`G[0][2], G[2][0]` shifted by +1) breaks `det(G)` agreement with the
   certificate: FAILS as required.
2. **Scrambled P** — corrupting one entry of the correctly-derived witness
   breaks `PᵀGP == target`: FAILS as required.
3. **Non-unimodular P** — doubling a column of the correct witness makes
   `det(P) = -2 ∉ {±1}`: rejected at the `GL₃(ℤ)` gate as required.
4. **s10 analog (mismatched-d cross-check)** — the certificate itself records,
   as its own `controls.different_level_cooper_s10` field, that the identical
   Stream 2 pipeline run on cooper_s10 derives `det = -20` (i.e. `d = 20`).
   There is no standalone saved s10 U1 certificate file in the Stream 2 repo to
   load directly — only this embedded control value — so this control reads
   `d = 20` from that field (never typed from memory) and checks whether the
   **real s7 Gram** matches target `U + <20>`. It does not: FAILS as required,
   confirming the checker discriminates between the two families' geometry
   rather than accepting any lattice of the right general shape.
5. **Positive sanity** — the unmodified certificate still PASSes after all
   scrambling hooks have been exercised, confirming the scrambling is surgical
   and leaves no state behind.

All 5 controls pass (i.e., each control's required PASS/FAIL behavior was
observed). Runnable via `python3 checkers/test_U1_splitting_independent_controls.py`
or `pytest checkers/test_U1_splitting_independent_controls.py` (both green;
pytest run: `5 passed`).

## What this does and does NOT upgrade

**Upgrades:** the lattice-arithmetic portion of the U-splitting claim (Link 1 —
"this specific Gram is isometric to `U + <14>`") from "trust Stream 2's
checker" to "two independently written, exact-arithmetic implementations
agree," for both the LIVE and DRAFT certificate contents.

**Does NOT upgrade, and this brief makes no claim otherwise:**

- The numerics-to-exact monodromy-entry recognition step (Stream 2 stage 2:
  60-digit numerical analytic continuation, rational recognition at a 1e-35
  gate). This check takes the certificate's `gram_primitive_even` as given
  input and never touches the monodromy computation that produced it.
- The identification of this lattice with the transcendental lattice `T` of
  the cooper_s7 K3 (Link 2 — the Dolgachev/Doran framework reading). That
  identification is Tier B per the certificate's own `tier_reason` field and
  per this repo's `CLAUDE.md` epistemic ledger, and remains Tier B regardless
  of this check's result.
- `ρ = 19`, `T = 3` (E-011) is unchanged and not re-derived here.
- No Kodaira fiber claims are made or implied (E-007/E-008/E-009 stand).
- No physical coupling of any kind (VISION §1.3).

This is a mechanical re-check of one finite exact statement, nothing more.

## Files added (this repo only; Stream 2 repo untouched)

- `checkers/check_U1_splitting_independent.py`
- `checkers/test_U1_splitting_independent_controls.py`

---
Generated-by: Sonnet 5 (Stream 1) | Verified-by: `check_U1_splitting_independent.py`
run against both the LIVE and DRAFT certificates (PASS in both cases) +
`test_U1_splitting_independent_controls.py` (5/5 controls behaving correctly,
plain python3 and pytest) | Reviewed-by: pending T0 (Xavier)
