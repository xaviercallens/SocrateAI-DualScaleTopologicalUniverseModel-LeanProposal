# Manuscript: Formal Verification of Structural Properties of Cooper's Sporadic Apéry-Like Sequences

Scientific report on the Lean 4 formalization work in `Agora/Sequences/`,
`Agora/SymSquare.lean`, and `Agora/Swampland/SymSquareC3b.lean`. Covers only
the mathematically rigorous content — see §10 ("Scope boundary") of the
manuscript itself for what is deliberately excluded and why.

## Build

```
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

Requires `pdflatex` with the `listings`, `booktabs`, `amsthm`, and `hyperref`
packages (standard in any full TeX Live install). Do **not** use
`lualatex`/`xelatex` unless `luaotfload`/`fontspec` are confirmed working in
the build environment — this document intentionally avoids `fontspec` and
uses a `listings` `literate` table instead, since the Unicode identifiers used
throughout the source (`ℚ`, `θ`, `′`, etc.) need to render without a working
Unicode-aware font backend.

## Contents

The appendix (`\lstinputlisting`) includes the actual `.lean` source files by
direct file reference (relative paths into `../Agora/` and `../Tests/`), not
a hand-transcribed copy — rebuilding this document after any change to those
files will pick up the change automatically, and there is no risk of the
manuscript drifting from the buildable source.

## Companion document

`../briefs/INTERNAL_PHYSICS_TIER_GAPS_2026-07-24.md` — an internal-only memo
(not a scientific report, not for distribution) cataloguing epistemic gaps
found in the repository's speculative physics-modeling code while surveying
the codebase for this manuscript. That material is excluded from this
manuscript entirely; the memo exists so the exclusion is a documented,
reviewable decision.
