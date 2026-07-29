# WP-P1 draft status — Stream 1 paper kickoff, 2026-07-29

**Authority:** S3 `briefs/EXECUTION_PLAN_2026_07_29_TWISTED_AND_WPE6.md` WP-P1, executing T0
Action 2. **Status: DRAFT, work-in-progress — not merge/finalize-ready.** A separate
verification pass (producer ≠ verifier, per §0 rule 1 of that plan) must review this before
promotion.

## What was already drafted (found, not rewritten)

The paper skeleton (commit lineage from `5bd0916`, ratified `paper/PLAN.md` §5 in `e621f6a`)
already contains, at the correct tier, everything WP-P1 items (i)–(iii) asked for:

- **(i) L₃ = Sym²(L₂), Tier A** — `paper/sections/04-sym2.tex` (Theorem `thm:sym2-template`).
  Verified this session: no `native_decide`, no axiom dependency for this specific theorem
  (`paper/sections/09-formalization.tex` states explicitly "No result in §§4–7 depends on
  them [native_decide]"; confirmed independently by `grep native_decide Agora/Sequences/
  PartnerOperators.lean Agora/Swampland/SymSquareC3b.lean` — no hits). Correctly stated as
  fact, no hedge needed.
- **(ii) Monodromy/lattice sections** — `03-operators.tex` (Riemann schemes),
  `06-lattice.tex` (numerical monodromy → exact lattice pipeline). Already carries full (N)
  disclosure for the monodromy step and (E) for everything downstream of it.
- **(iii) U1, T ≅ U⊕⟨14⟩, Tier B** — `06-lattice.tex` Proposition `prop:usplit` (unconditional
  statement about the exhibited Gram matrix) + `08-dolgachev-doran.tex` (conditional
  identification with the family's transcendental lattice, Conjecture `conj:T`). Already
  cites the two independent implementations by name. No changes made — rewriting
  T0-ratified prose was flagged as the main risk for this WP and avoided.

I did **not** touch these files' content, only their cross-reference/provenance footers where
new material links into them.

## What I drafted this session

**(iv) G0 result** — new subsection `\subsection{An independent cross-check: the orthogonal
complement (G0)}` in `paper/sections/08-dolgachev-doran.tex`, new Proposition
`prop:g0complement`. Content: the Nikulin orthogonal complement of the computed lattice
$G$ (Prop. `prop:lattice`) inside the K3 lattice $\Lambda = U^3\oplus E_8(-1)^2$ is
$U\oplus E_8(-1)\oplus E_8(-1)\oplus\langle-14\rangle$ — rank 19, signature (1,18), cyclic
discriminant group order 14, $q = 27/14 \bmod 2\mathbb Z$ — exactly $M_7$ under the standard
sign convention. Cited: S2 `briefs/G0_NS_GENUS_RESULT_2026_07_28.md` (commits `9a386d9`,
`15f16c5`) and decision log `briefs/WP_S2G_X4_EXHIBITION_PLAN_2026_07_27.md` §8 (commit
`256017d`, LIVE promotion + Deep Think cross-model verification entry) — two new
`@techreport` entries in `references.bib`.

Two epistemic points I want flagged explicitly for the verification pass, because getting
either wrong would be a real overclaim:

1. **Rank 19 here is arithmetic, not new evidence for ρ=19.** Since rank(Λ)=22 and rank(T)=3
   by construction, rank(NS)=19 is forced; I wrote two explicit paragraphs ("What it does not
   add" / "What it does add") plus a "What is not claimed" bullet stating this is *not* a
   second derivation of ρ=19. The real content is the *explicit isometry type* (NS = M_7
   exactly) and a verified (not assumed) Nikulin uniqueness-of-embedding bound.
2. **"Three independent lineages" is capped by the source's own caveat.** The G0 brief itself
   lists "two honest limits" on the Deep Think re-derivation's independence (it was handed the
   embedding formula verbatim; it shares the Nikulin bound with the in-house routes). I
   transcribed that caveat into the paper rather than writing "three fully independent
   derivations," and added a sentence stating explicitly this is corroboration of one
   computation, not a fourth independent route to ρ=19.

Also updated: `10-reproducibility.tex` (new artifact-table rows for
`check_NS_genus_G0.py` + `test_NS_genus_G0_controls.py`, 5/5 controls, citing the S2 brief for
the count); `paper/PLAN.md` §3 (new claims-inventory row #21, keeping "every number traces to
a row of this table" intact) and §4 (status table rows updated).

**AI-acknowledgment** — new `paper/sections/11-acknowledgments.tex` (starred section, no
renumbering), `\input` added to `main.tex` before the bibliography. Text extracted from
`paper/PLAN.md` §5 item 3, cross-diffed word-for-word against S3
`briefs/T0_DECISIONS_2026_07_28_PENDING_ITEMS.md` D2.3 (both hash-pinned rulings of the same
T0 decision — they agree exactly, differing only in markdown line-wrap). Transcribed once,
verbatim, unedited.

**ρ = 19 / T = 3 phrasing** — verified everywhere in the manuscript (existing + new prose):
always "conditional proposition," never "proven"/"establishes." No occurrence of "ρ=19" or
"proven" together found in the diff or the pre-existing sections I read.

## G1 stub

One-paragraph, unnumbered `\subsection*{A further construction (placeholder, 2026-07-29)}` at
the end of `08-dolgachev-doran.tex`. States only that a further section is planned but not
drafted pending an in-progress feasibility check on relevant base spaces; no content, method,
or conclusion described, per instruction.

**Flagged for T0, not resolved here:** whether this placeholder belongs in *this* manuscript
at all is unclear to me. `paper/PLAN.md`'s scope ruling (T0, 2026-07-27) is explicit: "pure
mathematics only. Zero physics — no dark-sector, cosmology, or 'universe model' content
anywhere in the manuscript, including motivation." The pending twisted-Weierstrass work
(WP-TW0/TW1, S2) is motivated by an F-theory/heterotic E8×E8 construction — physics
motivation, even if the underlying lattice/divisor arithmetic is pure algebraic geometry. I
wrote the stub in strictly abstract terms (no E8×E8, F-theory, or dark-sector language
anywhere) so it does not itself violate the scope ruling, but I did not decide — and it is not
my call — whether a construction motivated that way should ever appear in an *Experimental
Mathematics* pure-math submission versus staying entirely in Stream 2. Recommend T0 rule on
this before the placeholder is either filled in or removed.

## Guardrails self-review (checklist run against this diff)

- [x] No Tier C sentence anywhere in the diff — no physics content added at all (scope
  ruling respected).
- [x] Grepped the diff for forbidden verbs (predicts/establishes/shows/implies/locks/
  governs/determines/demonstrates/proves); only hit was "provenance" (substring false
  positive), no actual forbidden-verb usage on an unconstructed mechanism.
- [x] Every number in the new text traced to a specific line in a named source document
  (quoted or grepped directly, not from memory) before being typed: rank 19, signature
  (1,18), disc. order 14, q=27/14 mod 2Z, Nikulin bound 19≥3, commits `9a386d9`/`15f16c5`/
  `256017d`, control count 5/5.
- [x] No bare `PASS` — the one count cited is "5/5 controls," matching the source's "5-control
  suite: ALL PASSED."
- [x] Provenance footer present and updated on every changed/new file
  (`08-dolgachev-doran.tex`, `10-reproducibility.tex`, `11-acknowledgments.tex`, `main.tex`).
- [x] AI-acknowledgment paragraph verified byte-identical (word-for-word diff) to
  `PLAN.md` §5 item 3 before transcription.

## RULING-REQUESTED items

None added to a `TIER_LEDGER.md` — no claim's tier was ambiguous to me. `TIER_LEDGER.md` does
not currently exist in this repo (checked: `find . -iname TIER_LEDGER*` — no hits); I did not
create one since I had no entry to put in it. The one genuine open question (whether the G1
placeholder belongs in this manuscript's scope at all) is a **scope** question, not a tier
question, so I flagged it above for T0 rather than filing it as a tier ruling request.

## Build verification

`pdflatex main && bibtex main && pdflatex main && pdflatex main` — clean: 0 undefined
references, 0 undefined citations, 35 pages. `bibtex` emits one pre-existing warning (missing
pages in `Gorodetsky2023`), unrelated to this session's changes.

## Files changed this session (all in S1, named individually — no `git add -A` used)

- `paper/main.tex` — added `\input{sections/11-acknowledgments}`, provenance footer
- `paper/PLAN.md` — claims row #21, §4 status table rows for 08/10/11
- `paper/references.bib` — two new `@techreport` entries (G0 result, G0 decision log)
- `paper/sections/08-dolgachev-doran.tex` — G0 subsection + proposition, evidence-table row,
  "what is conjectural"/"what is not claimed" additions, G1 placeholder, provenance footer
- `paper/sections/10-reproducibility.tex` — G0 artifact rows, provenance footer
- `paper/sections/11-acknowledgments.tex` — new file
- `paper/main.pdf` — recompiled

---
Generated-by: Sonnet 5 (WP-P1, 2026-07-29) | Verified-by: pdflatex+bibtex clean build (0
undefined refs/cites); every new number grepped from its cited source document this session
(not from memory); AI-ack text diffed word-for-word against `PLAN.md` §5.3 and S3
`T0_DECISIONS_2026_07_28_PENDING_ITEMS.md` D2.3 | Reviewed-by: pending (coordinator
verification pass required before promotion, per WP-P1's own DoD)
