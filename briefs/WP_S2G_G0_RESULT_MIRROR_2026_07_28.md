# Mirror: WP S2-G Phase G0 result (canonical in Stream 2)

**Date:** 2026-07-28. Canonical: S2 `briefs/G0_NS_GENUS_RESULT_2026_07_28.md`, commit 9a386d9.
Mirrors the WP S2-G plan itself (S1 `920f39f`, this repo's prior mirror).

## Result

Phase G0 (NS-genus certification, opened by T0 2026-07-28) determined **PROCEED**: the
Néron-Severi lattice of the certified cooper_s7 family's generic K3 fiber, computed as the
Nikulin complement of T ≅ U⊕⟨14⟩ inside Λ = U³⊕E8(-1)², is **U⊕E8(-1)⊕E8(-1)⊕⟨-14⟩**
(rank 19) — contains the required U summand. The plan's stop condition did not fire.

An unforced cross-check relevant to this repo: NS's rank (19) matches ρ=19 (E-011) via an
independent derivation route from the one Stream 1 used for its own U1 verification.

**Stream 1 relevance** (as noted when the plan itself was mirrored): the G0 NS-genus
certificate — exact lattice arithmetic, Nikulin primitive-embedding theory, two independent
derivations agreeing bit-for-bit — is a candidate for eventual Lean formalization if T0 opens
that gate. Not proposed or begun here; flagged for awareness only.

**Status: DRAFT**, coordinator-reproduced (checker re-run + full 5-control suite, both
independently confirmed in the S2 session) but not yet independently re-derived in separate
code (the standard this program set for U1). **Does not authorize G1** — a separate T0 gate.

Full method, caveats (weak discriminating power; fiberwise-only), and verification log: see
the canonical S2 brief.
