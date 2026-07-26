# Deep Think response — literature audit of the order-2 partners: adjudication

**Date:** 2026-07-26 · **Received via:** Xavier (T0), relayed in-session with authorization
("consider with my authority")
**Responds to:** `briefs/DEEPTHINK_LITERATURE_REVIEW_L2_PARTNERS_2026-07-25.md` + its
2026-07-26 addendum
**Adjudicated by:** Stream 1, same session · **Actions taken:** WP S1-12 (see §Actions)

Per standing practice, claims were sorted into *verified here*, *accepted as sourced*, and
*flagged as unsourced* — nothing was inherited untested (E-007/E-010 discipline).

---

## Q6 (integrality mechanism) — algebraic half VERIFIED and now KERNEL-PROVED

Deep Think's central claim: 2-power denominators are not a level anomaly but the **default
for any formal square root of an integer series**; the true anomaly is s7 *lacking* them.

**Verified by direct computation, then proved in Lean (WP S1-12):**

- CAS: 200 random integer series, formal square roots to `n = 60` — all dyadic. Negative
  control (division by 3 instead of 2) produces 3-power denominators, so the test is live.
- **Kernel: `FormalSqrt.sqrtSeq_dyadic`** — for *every* `s : ℕ → ℤ`, every coefficient of
  the formal square root of `Σ s(n)zⁿ` lies in `ℤ[1/2]`. Tier A, 0 `sorry`, generic; with
  its own in-kernel negative control (`dyadic_baseline_control`). The convolution theorem
  `sqrtSeq_sq` pins that the object really is the square root, not an arbitrary recursion.

**Consequences adopted:**
1. s10/s18 partner non-integrality is *baseline*, not pathology. The candidate separation
   reads "s7 is the anomaly", exactly as Deep Think framed it.
2. `open_goal_partner_integral_s7` is conditionally **reduced to a purely 2-adic question**
   — the odd-prime half is `sqrtSeq_dyadic`, modulo the bridge (below).

**Bridge status (the one gap, honestly):** the identification `partnerSeq = sqrtSeq(cooper)`
is CAS-verified to `n = 59` (all three candidates), kernel-checked at the first indices on
both the integral (s7) and non-integral (s10) sides, and filed as the named open goal
`open_goal_partner_eq_sqrt_s7` — it needs solution-level transport of the operator identity,
for which the pinned Mathlib has no machinery. Candidate blocked-on-mathlib; T0's call.

**Flagged [B], not formalised:** the *modular* half — "level 7's integral weight-1 form +
integral Hauptmodul absorb the ½'s; levels 10 and 18 do not". The level-7 positive side is
consistent with O'Brien 2016 (fetched) and our `n = 81` integer check; the negative side for
levels 10/18 is **unsourced as a mechanism** — though its *outcome* is our own kernel theorem
(`s10_partner_not_integral`, `s18_partner_not_integral`). Mechanism [B]; outcome Tier A.
(Also note "level 18" for s18 is nowhere verified in our sources — do not propagate it.)

## Q1/Q4 for s10/s18 — "NO SOURCE FOUND": ACCEPTED, search closed

Exactly the answer format §7.5 of the request declared most useful. Deep Think's explanation
(the literature hunts *integer* sequences; non-integral partners get discarded) is plausible
and consistent with the s7 partner alone having an OEIS entry. **Action: Stream 1/2 stop
searching for standalone geometric realisations of the s10/s18 order-2 partners.** They
remain what the kernel says they are: explicit, forced, formal Sym² factors over `ℚ[z]`.

## Q2 (normalisation) — answered: quadratic base change; consistent with Route γ

The `{0, ½}` exponents are the honest local data of the raw square root; the literature
untwists via base change (`z ↦ x²`-type pullback), not by renormalising coefficients in `z`.
This is *structurally the same move* as Stream 2's Route γ step 1 (ramified Hauptmodul
pullback clearing the branch cut at order-2 elliptic points, E-008) — the two independent
threads agree. No primary citation was given for "authors implicitly apply…"; we don't need
one, since our operative conclusions (L₂ is twisted; never run Tate on raw L₂) predate this
answer and stand on our own verification.

## Stienstra–Beukers 1985 — WARNING NOTED, nothing upgraded

Deep Think: S-B 1985 proves the *generic* ρ=19/T=3 theorem for symmetric-square K3 families,
but applying it to s7/s10 is a later authors' extension, **not text printed in S-B 1985** —
and Deep Think has not fetched the paywalled paper either, so even that description is
secondary. Consequences:
- **ρ/T remain `null`. Nothing here certifies ρ=19/T=3 for our specific K3s.** This brief
  emits no ρ and no T.
- Gate E criterion 1 stays **UNRESOLVED** per T0 D1 — Deep Think's own recommendation.
- Deep Think's phrase "theoretically sound" is *not* adopted as a tier upgrade; it is the
  same [B]-pending-citation status Stream 2 already records.

## Chan–Cooper–Sica 2010 — superseded for our purposes

O'Brien 2016 (fetched, hash-pinned) *proves* the relevant Conjecture 5.4 content for s7.
CCS-2010 remains unfetched and is no longer on any critical path.

---

## Actions (all landed as WP S1-12, this session)

| Action | Artifact |
|---|---|
| Q6 algebraic half → kernel | `Agora/Sequences/FormalSqrt.lean` (`sqrtSeq`, `sqrtSeq_sq`, `sqrtSeq_dyadic`, control) |
| Bridge instances → kernel | `sqrt_matches_partner_s7` (n≤3), `sqrt_matches_partner_s10` (n≤2) |
| Bridge, general → open goal | `open_goal_partner_eq_sqrt_s7` (routes + blocker documented) |
| s7 integrality goal → reduced | `open_goal_partner_integral_s7` docstring UPDATE (odd primes done modulo bridge) |
| s10/s18 partner search | **closed** per Q1/Q4 |
| ρ/T, Gate E | **no change** — null / UNRESOLVED per D1 |

The 2026-07-25 literature-review brief is now **ANSWERED** (its addendum already retired the
fetch-resolved items; this adjudication disposes of the remainder). Remaining externally
open: Cooper 2012 and Stienstra–Beukers 1985 (paywalled, no OA mirror) — dormant, nothing
blocked on them for Stream 1.

---

**Generated-by:** Fable 5 (Stream 1, T1) | **Verified-by:** CAS (`q6_check.py`, 200-series
sweep + live control) and Lean kernel (`lake build Agora`, 0 `sorry` outside `OpenGoals/`)
for everything marked verified; [B] flags retained where no source was produced |
**Reviewed-by:** Xavier (T0) — authorized consideration 2026-07-26; adjudication pending his
countermand as always
