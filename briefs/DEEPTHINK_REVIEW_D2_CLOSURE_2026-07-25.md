# Deep Think Review Brief — D2 Closure Spot-Check

**From:** Opus 4.8 / Sonnet 5 (mid-tier executor + orchestrator)
**To:** Deep Think (Gemini / T0s CAS node)
**Date:** 2026-07-25
**Re:** Second-reviewer spot-check of the Lean closure for `open_goal_recurrence_s7` /
`open_goal_recurrence_s10`. This is a **review request, not a derivation request** —
the certificates were already derived and independently re-proved from Mathlib's
`Nat.choose` API. Follow-on to `DEEPTHINK_HANDOFF_2026-07-20.md`, which requested the
certificate derivation this closure is built on.

> **Why this brief exists:** `lake build` green + `#print axioms` clean is real
> independent verification of the *Lean proof*, but it cannot catch whether the
> **statement being proved** subtly diverges from the sourced Cooper recurrence, or
> whether the certificate-to-Lean translation smuggled in an unjustified step. That is
> exactly the class of error this project's two-model discipline (E-004, E-006) exists
> to catch — hence this request, before D2 is treated as beyond question.

---

## 1. What was closed

Commit `27fa454` (pushed to `main`, tagged `v0.5-D2-closed`) discharges both open goals
in `OpenGoals/CooperRecurrences.lean`:

```
theorem open_goal_recurrence_s7  : SatisfiesCooperRecurrence (fun n => (s7 n : ℤ)) s7_params
theorem open_goal_recurrence_s10 : SatisfiesCooperRecurrence (fun n => (s10 n : ℤ)) s10_params
```

via `exact Agora.Sequences.WZ.s7_satisfies` / `s10_satisfies`, proved in the new file
`Agora/Sequences/WZCertificates.lean` (587 lines, 0 `sorry`).

**Verified so far (by me, not just the delegated agent's claim):**
- `lake build Agora OpenGoals Tests` — green, 3113 jobs
- `#print axioms Agora.Sequences.OpenGoals.open_goal_recurrence_s7` and `_s10` — both
  reduce to `[propext, Classical.choice, Quot.sound]` only (no `sorry`, no
  `native_decide`, no custom axiom)

**Not yet verified by a second model** — this is what the request below covers.

---

## 2. What to check

You do **not** need to re-derive anything (§2 of the earlier handoff already covers
that; the certificates there match `cert7`/`cert10` below). What's needed is an
independent read of `Agora/Sequences/WZCertificates.lean` for three specific failure
modes:

### 2a. Certificate fidelity
Does `cert7`/`cert10` (lines 203–211, 447–460) match the certificate your CAS run
returned for §3.1/3.2 of the 2026-07-20 handoff, up to the denominator-clearing
transform in §2c below? A transcription error here would compile (Lean only checks the
*identity*, not that the identity is the one originally intended) but silently prove a
recurrence for the wrong summand.

### 2b. Recurrence normalization fidelity
Does `s7_recurrence_shifted` / `s10_recurrence_shifted` (lines 389, 553) and the final
`s7_satisfies` / `s10_satisfies` (lines 419, 579) reduce to **exactly** the §3.3
normalization from the 2026-07-20 handoff —
`(n+1)³u(n+1) = (2n+1)(an²+an+b)u(n) − n(cn²+d)u(n−1)` with `(a,b,c,d) = (13,4,−27,3)`
for s7 and `(6,2,−64,4)` for s10 — with no silent renormalization (monic rescaling,
index shift, sign flip)?

### 2c. The denominator-cancellation step (the one place a real bug was already caught)
The raw `ore_algebra` certificate for s7 has denominator `7(n−k+1)²(n−k+2)²`, which
vanishes at `k = n+1, n+2` — **inside** the summation range — as a genuine `0/0` with a
nonzero limit (not a Lean junk-value case; verified numerically before any Lean was
written, see `docs/WZ_CERTIFICATE_ANALYSIS.md` ADDENDUM 5). The fix used: rewrite the
summand via `C(n,k)(n+1)(n+2) = C(n+2,k)(n−k+1)(n−k+2)` (Pascal ratio, `atom_A1`/`A2`,
lines 101–123) to re-express against `H7(n,k) = C(n+2,k)²·C(n+k,k)·C(2k,n)` instead of
`F7(n,k) = C(n,k)²·C(n+k,k)·C(2k,n)`, giving `G7 = cert7 · H7` with a denominator
(`(n+1)²(n+2)²`) that never vanishes on `ℕ`. This is the crux of the encoding and the
most likely place for a subtle error to hide. Please check:
- The algebraic identity `F(n,k)/(n−k+1)²(n−k+2)² = H(n,k)/(n+1)²(n+2)²` is actually
  equivalent to the original raw certificate identity (not just individually
  well-typed).
- `tele7`/`tele10` (lines 323, 505) — the core telescoping identity
  `G(n,k+1) − G(n,k) = (recurrence operator applied to H or F)` — is the identity that
  was actually intended, not an artifact of the rewrite.
- The boundary terms `G7_top`/`G7_bot` (lines 375, 379) and `G10_top`/`G10_bot` (lines
  545, 549) correctly vanish at the true summation endpoints (`k=0` and `k=n+3`,
  accounting for `H7_eq_zero_of_gt`/`F7_eq_zero_of_not_mem`, lines 348, 371) — i.e. that
  the telescoping sum was properly closed, not silently truncated.

### 2d. Anything Lean's kernel can't catch by construction
Kernel green proves the *stated* theorem is true; it says nothing about whether
`SatisfiesCooperRecurrence` (the definition being proved) is itself a faithful
transcription of Cooper's Table 1 recurrence, or whether `s7`/`s10` (the closed forms
in `Agora/Sequences/CooperRecurrences.lean`) are faithful transcriptions of Gorodetsky's
formulas. These definitions predate this closure and were presumably reviewed already —
flag only if something looks off, no need to re-audit from scratch.

---

## 3. Reference material

- `Agora/Sequences/WZCertificates.lean` — the file under review
- `Agora/Sequences/CooperRecurrences.lean` — `SatisfiesCooperRecurrence`, `s7`, `s10`,
  `s7_params`, `s10_params` definitions (unchanged by this closure)
- `docs/WZ_CERTIFICATE_ANALYSIS.md` — ADDENDUM 4 (certificate derivation, Sage session
  transcript, double-verification) and ADDENDUM 5 (Lean closure writeup, including the
  boundary-collapse error that was caught and fixed — read this first, it documents the
  exact reasoning trap to check hasn't recurred elsewhere in the file)
- `scripts/derive_wz_certificates_s7_s10.sage` — reproducible certificate derivation
- `briefs/ESCALATIONS.md` — D2 section, full history including this closure
- `briefs/DEEPTHINK_HANDOFF_2026-07-20.md` — original certificate-derivation request
  this closure is built on (§3 there has the canonical definitions and golden values)

---

## 4. What to send back

A pass/fail per §2a–2d, with specifics for any fail (which line, what's wrong, what the
correct version should be). If all pass, a one-line concurrence is sufficient — Xavier
can then upgrade D2 from "kernel-proved, single-reviewer" to "kernel-proved,
two-model-verified" in `ESCALATIONS.md` and `TIER_LEDGER.md` if applicable.

---

*Provenance:* Generated-by: Sonnet 5 (orchestrator) | Verified-by: `lake build` +
`#print axioms` (this session, independent of the Opus sub-agent that wrote the file) |
Reviewed-by: T0 N (this brief is the request for that review).

---

## Result: 🟢 PASSED / GREEN (2026-07-25)

Deep Think returned a pass on all four checks (§2a–2d) — no certificate transcription
error, no recurrence renormalization, the denominator-cancellation rewrite in §2c
confirmed algebraically sound (including the boundary closure at `k=0`/`k=n+3`), and the
pre-existing `SatisfiesCooperRecurrence`/`s7`/`s10` definitions confirmed faithful to
Cooper (2012) / Gorodetsky. D2 is now closed at **Tier A, two-model-verified**. Full
detail logged in `briefs/ESCALATIONS.md` (E-006 companion, final update).

*Reviewed-by: Deep Think (T0s), 2026-07-25.*
