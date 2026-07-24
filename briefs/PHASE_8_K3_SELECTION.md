# 🔬 Phase 8: Shioda–Inose Selection & Core Prioritization

**Authorized:** Xavier (T0 owner) + Deep Think (T0s), directive of 2026-07-24.  
**Transcribed:** Fable 5, with epistemic-tier adjustments flagged inline (VISION §2; content
preserved, attribution and hedges added — no claim silently weakened or strengthened).

---

## 1. Relieving the Stream 1 Burden

Stream 1 has verified — **symbolically (sympy exact arithmetic, two-model: Opus + Deep Think
concurrence), not yet kernel-proved** — that the vanishing of the Almkvist–van Straten invariant
(`W ≡ 0`) holds structurally for the **entire** Cooper ansatz (`scripts/check_C3_symsquare.py`;
generic `a,b,c,d`). Consequently `W ≡ 0` certifies the **symmetric-square structure** of the
order-3 operator — the algebraic precondition for a K3/Shioda–Inose interpretation (that
geometric identification itself is Tier B, criterion C3b) — but it is **non-discriminating**
between s7 and s10: every Cooper-form operator passes automatically.

> *Tier adjustment vs. the directive text: "proof of K3 geometry" → "symmetric-square structure,
> precondition for the (Tier B) K3 identification". Per VISION §1.3, Sym² is a geometric relation
> only and implies no physical coupling; the kernel upgrade `SYM2_PROVED` is in flight (D1,
> gated on Deep Think concurrence — `briefs/D1_P_CLEARED_FABLE_2026-07-24.md`).*

**Stream 1's candidate-selection duty is complete** (decision D4, 2026-07-20). The burden of
active candidate selection now shifts entirely to Stream 2.

## 2. Active Physics Discriminators

To break the structural degeneracy, the Python/SymPy pipeline must compute the non-structural
criteria (definitions and thresholds: `K3_CRITERIA.md`):

1. **C3b (Shioda–Inose moduli map):** exhibit the explicit second-order partner operator `L₂`
   with `L₃ = Sym²(L₂)` and the explicit correspondence map, verified to order N
   (report `PASS(N)`, never bare `PASS`).
2. **C1/C2 (mirror integrality / Kodaira fibers):** extract the fiber table and transcendental-
   lattice data. Any gauge-group statement (e.g. an SU(5)/SO(10) GUT embedding) derived from it
   is **Tier C until an explicit EFT matching exists** — it may be stated only as a conjectured
   target of the check, not as an established consequence.

## 3. Physical Priority Target: Cooper s7

**Xavier (T0, physics evaluation) designates Cooper s7 as the primary physical priority target**,
on the grounds — reported by Xavier from the Stream 3 V4C analysis of the SDSS DR17 galaxy
catalog, **not verified by Stream 1** — that s7 emerged as the dominant candidate there. Stream 2
computational resources will therefore prioritize mapping the `L₂` partner of s7 over s10.

> *Tier adjustments: (i) "primary load-bearing physical vacuum" is a Tier C physical
> interpretation — recorded here as a **resource-prioritization decision** (T0 prerogative,
> needs no proof) plus a **conjecture** that s7 is the physically realized candidate; it does not
> pre-empt the C3b/C1/C2 outcome, and a C3b failure for s7 still removes it (K3_CRITERIA F1
> rule). (ii) The V4C/SDSS claim is attributed to Xavier's Stream 3 report; Stream 1 has no
> certificate for it. (iii) The OEIS ID "A183204" for s7 comes from the directive text and could
> not be fetch-verified this session (oeis.org 403) — the repo's source of truth for s7 remains
> the kernel-checked encoding + golden values (`Tests/CooperSequences.lean`). (iv) Register
> status unchanged: both s7 and s10 stay `TIER_A_POOL` in the frozen register (D5); this
> prioritization orders Stream 2's queue, it does not amend the register.*

---

*Generated-by: Fable 5 (transcribing Xavier T0 directive 2026-07-24) | Verified-by: n/a
(directive record; symbolic claims reference `scripts/check_C3_symsquare.py`,
`scripts/derive_D1_P_cleared.py`) | Reviewed-by: T0 Y (Xavier authored the underlying directive;
tier adjustments flagged inline for his review)*
