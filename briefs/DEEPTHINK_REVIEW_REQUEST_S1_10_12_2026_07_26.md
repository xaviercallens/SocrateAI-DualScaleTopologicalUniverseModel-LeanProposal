# Deep Think Review Request — S1-10/11/12 Lean layer + two follow-up literature questions

**Date:** 2026-07-26 · **From:** Stream 1 · **To:** Deep Think (T0s)
**Type:** Adversarial review (the D2/WZ two-model bar) + two narrow literature questions.
**Pending:** T0 authorization (queued as decision #3 in
`briefs/STREAM1_S1_10_11_12_STATUS_AND_UNBLOCK_2026_07_26.md`).
**First:** thank you for the Q6 audit — its algebraic half checked out under recomputation
(200-series CAS sweep, live control) and is now the kernel theorem `sqrtSeq_dyadic`. This
request is the follow-through: the same review bar we applied to the WZ certificates, now
that these files carry candidate-ordering weight.

---

## A. Review scope — three files, four specific failure modes

Files (repo `main`, commit `ffa1361`): `Agora/Sequences/PartnerOperators.lean`,
`Agora/Sequences/PartnerIntegrality.lean`, `Agora/Sequences/FormalSqrt.lean`.

Please attack these four places specifically — each is where a subtle error would sit:

**A1. The `partnerP0` quarters (PartnerOperators.lean §2½).**
`partnerP0 = −(b/2)z + ((c+d)/4)z²` was *solved out of* `c₁ = θ(P₁) + 4P₀`. Check against
Gorodetsky eq. (1.7)'s θ-expansion that the `c₁`/`c₀` coefficients we encoded
(`cooperC1 = −(a+2b)z + (3c+d)z²`, `cooperC0 = −bz + (c+d)z²`) are the correct expansion —
a sign or commutator slip there would make the "identically vanishing constraint"
(`partner_res0`) vacuously consistent with a WRONG operator. (The z-left-of-θ argument for
no commutator terms is stated in the docstring; verify it.)

**A2. The convolution off-by-one (FormalSqrt.lean §2).**
`sqrtSeq_sq` splits `Σ_{i∈range(n+2)} bᵢ·b_{n+1−i}` into first + middle + last. Natural
subtraction (`n+1−i` in ℕ) is exactly where an index error hides. Check the middle-sum
reindexing `(n+1)−(i+1) = n−i` and that the two boundary terms are `b₀b_{n+1}` and
`b_{n+1}b₀`, not a double-counted diagonal.

**A3. The dyadic induction bounds (FormalSqrt.lean §3).**
`sqrtSeq_dyadic`'s strong induction uses `ih (i+1)` and `ih (n−i)` for `i ∈ range n` against
target index `n+1`. Verify both are strictly below `n+1` for every `i` the sum ranges over —
and that `IsDyadic` (`∃ m k, q = m/2^k`) is the claim you intended in Q6, not a weaker cousin.

**A4. The golden values (PartnerIntegrality.lean §2, §4½).**
`1,2,22,336,6006` (s7 partner), `1,1,17/2,147/2` (s10), `1,3,45/2,429/2` (s18), and the
`sqrtSeq`-vs-`partnerSeq` matches at n≤3 — spot-check any two against your own independent
computation from the raw Cooper parameters. These constants anchor everything downstream.

Format: same as your D2 review — PASS/FAIL per item, with the failing computation if FAIL.
**"FAIL" on any item retracts the corresponding theorem's Tier A status same-day.**

## B. Verdict requested: blocked-on-mathlib?

Two named open goals remain (`OpenGoals/PartnerIntegrality.lean`, full grind records inline):

1. `open_goal_partner_eq_sqrt_s7` — `partnerSeq = sqrtSeq(cooper)`. Informal proof: both
   square to the same series with constant term 1, `ℚ⟦z⟧` is a domain. Missing: any machinery
   connecting a θ-form operator identity to its solution sequences at the pinned Mathlib.
2. `open_goal_partner_integral_s7` — now purely 2-adic modulo goal 1. Missing:
   modular-forms/Hauptmodul-expansion machinery.

**Do you concur these are blocked-on-mathlib rather than merely hard at the current pin?**
Concretely: name any Mathlib API at commit pin `v4.32.0-era` (see `lake-manifest.json`) that we
missed and that makes either goal tractable. "You missed X" is the most valuable possible
answer; concurrence is second-best. T0 rules after your input.

## C. Two narrow literature questions (fetched sources only)

**C1. Does O'Brien 2016 PROVE integrality of the `c_n` (A279619)?** You have the thesis
(hash-pinned). Theorem 6.1 gives the g.f.-in-Hauptmodul identity; we need to know whether
integrality of the expansion coefficients is *proved* there (or in Chan–Cooper–Sica's
conjecture statement), or merely evident from the printed terms. This decides whether the s7
anomaly is sourced mathematics or still literature-open. Cite theorem/page, or "not proved
there".

**C2. Your Q6 modular half — one source, or downgrade it.** "Level 7's integral weight-1 form
+ integral Hauptmodul absorb the ½'s; levels 10 and 18 do not" is currently [B]-unsourced in
our adjudication (its *outcome* is kernel-proved; the *mechanism* is not). One citation for
the cancellation criterion — or an explicit "this was my synthesis, treat as [C]" — and we
file it correctly. Also: we found no source for "s18 ↔ level 18"; if you have one, name it;
if not, we keep not propagating it.

## D. What NOT to do (standing, post-E-007/E-010)

- Do not re-derive the §A identities from theory and report agreement — recompute them
  mechanically or report the discrepancy. The kernel already accepted them; your job is to
  find where WE mis-encoded, not to confirm the mathematics is pretty.
- No ρ, no T, no Gate E commentary — out of scope here; D1 governs.
- "No source found" remains a fully acceptable answer to §C.

---

**Generated-by:** Fable 5 (Stream 1, T1) | **Verified-by:** everything in §A is
kernel-accepted at `ffa1361`; this request is the independent-model leg of the two-model bar |
**Reviewed-by:** Xavier (T0) — authorization pending (unblock queue #3)
