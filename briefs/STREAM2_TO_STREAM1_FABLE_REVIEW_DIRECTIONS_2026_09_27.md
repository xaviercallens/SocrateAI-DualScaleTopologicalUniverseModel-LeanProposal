# Stream 2 → Stream 1 — directions from the audited external review (Fable 5.1, 2026-09-21)

**Date:** 2026-09-27 · **Delivered untracked** (do not commit from a Stream 2 session) · **Full record
and audit:** K3-DarkMatter `briefs/EXTERNAL_REVIEW_FABLE51_AUDIT_AND_DIRECTIONS_2026_09_27.md`,
`data/certificates/EXTERNAL_REVIEW_FABLE_2026_09_21_AUDIT.json` (12/12 Stream-2 clauses CONFIRMED),
verbatim text `docs/literature/external_reviews/FABLE51_K3_SELECTION_REVIEW_2026_09_21.md`
(sha256 `6ab67453…`). T0 authorised Stream 2 to pass directions on (in session, 2026-09-27).

The review's spec target (`~/K3spec.md`) was REJECTED by T0 on 2026-09-16; nothing there is for you.
What is for you:

1. **Pin Doran 1998 (Thm 5.13, Picard–Fuchs uniformization) as Tier L** where your docs rely on
   "Sym² ⇔ rank-3 signature (2,1) ⇔ M_N-polarized family". K3-DarkMatter holds the fetched PDF,
   hash-pinned in `docs/literature/MANIFEST.md` (`doran_1998_picard_fuchs_uniformization.pdf`,
   `2a3ce065…`), read. Copy it with its hash; do not cite from memory.
2. **Rank-jump lemma (integer linear algebra, next to `TN_diagonalises`, `Agora/Geometry/MnLattice.lean:179`):**
   in U⊕⟨2N⟩ with Gram [[0,1,0],[1,0,0],[0,0,2N]] (your basis; ours is [[0,0,−1],[0,2N,0],[−1,0,0]]),
   the class v = e − f has v² = −2 and v^⊥ ≅ ⟨2⟩⊕⟨2N⟩; at N=7 the other order-2 point's class
   v = ±(−2,4,1) (our basis) has v² = −2 and v^⊥ ≅ [[2,1],[1,4]]. These are rows of our
   `CM_POINTS_RHO20.json` (Tier B numeric recognition of z; the lattice arithmetic is exact). A kernel
   statement of the lattice half would move that half to Tier A; the z-recognition stays Tier B.
3. **Optional Lean targets, finite computations:** Inose–Weierstrass models
   y² = x³ − 3αt⁴x + t⁵(t² − 2βt + 1) at (α,β) = (0,1) [X₃, T = A₂] and (0,0) [X₄, T = ⟨2⟩⊕⟨2⟩]:
   orders of vanishing of a₄, a₆, Δ → fibre types → Euler sum 24 → NS rank 20 → disc NS = −disc T.
   Note: Kodaira types **from an explicit Weierstrass model** are not the E-007 category error (that
   was Kodaira from L₂/L₃ exponents, which stays forbidden). Also the D₄ / Hurwitz-order observation
   (C²/Λ_{D₄} ≅ E_i × E_i and ≅ E_ω × E_ω as complex tori) as a rank-2 free-module statement — the review
   flags it "to check, not a claim".
4. **README line "s₇ transcendental lattice Tier B pending Stream 2 numerical monodromy":** cite
   `C2_cooper_s7_v5.json` (LIVE, T0 D5′ 2026-07-27, witness P serialized) and `CM_POINTS_RHO20.json`;
   still Tier B (Dolgachev/Doran identification + numeric recognition). Not "closed".
5. **Unchanged:** the t103 flag (`T0_FLAG_K3_CRITERIA_T103_STALE_2026_08_01.md`) is still unanswered;
   `K3_CRITERIA.md` is canonical in K3-DarkMatter (D8′) — re-pin your mirror after PR #55 merges
   (sha256 on the PR #55 branch at its last commit:
   `8e6c5d17e84360bb70ae4f298f33df25a1106efe51dd0052e6865e904b337531` — after T0 D9′ of 2026-09-27
   adopted AM-6 selector clause + AM-7 C3 checker path, and the §5 table gained the certified-monodromy
   note; record `briefs/T0_DECISIONS_2026_09_27_STREAM2.md`. **Recompute at merge**
   (`git show main:K3_CRITERIA.md | sha256sum`) rather than trusting this line: the §5 table is
   generated and any further certificate change before merge moves it.)

What the review does NOT give you: a preferred surface. D7′ adopts no ranking; the review's own point
is that three selectors (discriminant floor → A₂, height → ⟨2⟩⊕⟨2⟩, Fricke point → two surfaces at
N=7) disagree, and a selector must be named by T0 text (AM-6 proposed, not adopted).

*Generated-by: Claude (Fable 5.1), Stream 2 | Verified-by: the audit certificate named above; theorem
locations by repo search 2026-09-27 | Reviewed-by: N*
