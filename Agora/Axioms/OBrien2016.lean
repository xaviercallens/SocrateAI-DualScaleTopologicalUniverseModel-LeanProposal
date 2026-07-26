/-
  OBrien2016.lean
  ════════════════════════════════════════════════════════════════════════════════

  A single citation: L. O'Brien (2016), Theorem 6.2 — the sequence satisfying
  the level-7 three-term recurrence is integer-valued.

  WHY AN AXIOM, NOT A PROOF. O'Brien's proof (transcribed below, verbatim in
  substance) is NOT a generic "composition of integral power series"
  corollary. It is an explicit coefficient-matching induction that uses the
  q-expansions of two specific weight-1 level-7 modular objects — a modular
  form built from Ramanujan-type Eisenstein series and the level-7 Hauptmodul
  — established via classical modular-forms machinery (theta functions,
  differential equations for these specific objects) that is genuinely absent
  from the pinned Mathlib. This is an external mathematical fact, cited on the
  same footing as any other literature-sourced axiom in this repo (rule 2),
  not something re-derived here.

  O'Brien's proof, condensed (thesis pp.46–48, Theorem 6.2). Write the known
  q-expansions X₇ = q − 9q² + 30q³ − … and z₇ = 1 + 2q + 4q² + 6q⁴ + … (his
  eq. 6.7–6.8, themselves consequences of z₇, X₇ being explicit ratios of
  Eisenstein series — NOT proved here). Substitute X₇'s q-expansion into
  z₇ = Σ c₇(n)X₇ⁿ and equate coefficients of qⁿ on both sides. Because X₇ has
  leading term exactly q (coefficient 1), the coefficient of c₇(n) in the qⁿ
  equation is always 1 — every other term in that equation involves only
  z₇'s known integer coefficients and c₇(0),…,c₇(n−1), already integers by
  induction. Hence c₇(n) ∈ ℤ for all n.

  THE CITATION ERROR THIS CORRECTS. Deep Think's 2026-07-26 literature audit
  (`briefs/DEEPTHINK_L2_PARTNERS_RESPONSE_2026_07_26.md`) attributed
  integrality to Theorem 6.1 (which only establishes the recurrence↔
  generating-function correspondence, not integrality) via a generic
  "η-quotients have integer Fourier coefficients, therefore corollary"
  argument. That argument is not valid in general — z₇ = Σc₇(n)X₇ⁿ is a
  REVERSION of X₇'s q-series, and reversion does not automatically preserve
  integrality even when both input series do (that is exactly why O'Brien
  needed pp.46–48's induction rather than a one-line corollary). The correct
  citation is Theorem 6.2, p.47, and the correct mechanism is the induction
  above. Read the source before citing it — the standing rule this project
  keeps re-learning (E-007, E-010).

  Stream 2 independently reached the same correction, via a different route
  and with sharper precision on WHY reversion works here: `X₇ = q − 9q² + …`
  is a NORMALIZED integral uniformizer — integer coefficients with leading
  coefficient exactly 1 — and reverting a monic integral series never
  introduces a denominator (a leading coefficient of anything but 1 would
  reintroduce exactly the kind of denominators seen in s10/s18). See
  `checkers/check_s7_partner_integrality_modular.py` in the Agora repo, which
  also resolves an OCR ambiguity in the thesis's eq. (3.15) between `z₇`/`Z₇`.
  That checker is Tier B (computational, not kernel-checked); this axiom is
  what makes the conclusion Tier A here.

  -- Source: L. O'Brien, "Modular forms and two new integer sequences at
  level 7", MSc thesis, Massey University, Albany, New Zealand, 2016
  (supervisor S. Cooper), Theorem 6.2, p.47 (recurrence eq. 6.5, q-expansions
  eq. 6.7–6.8). Fetched and hash-pinned by Stream 2 (Agora repo,
  `refs/literature_provenance.txt`;
  `docs/literature/obrien_2016_massey_thesis.txt`, lines 2560–2697). Full
  proof text read directly by Stream 1, 2026-07-26.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Mathlib.Data.Rat.Defs

namespace Agora.Axioms

/-- O'Brien (2016), Theorem 6.2, re-indexed to avoid ℕ-truncated subtraction:
    his eq. (6.5), `(n+1)²c₇(n+1) = (26n²+13n+2)c₇(n) + 3(3n−1)(3n−2)c₇(n−1)`
    for `n ≥ 1`, becomes the equivalent statement below under `n = k+1`
    (`k ≥ 0`); his boundary computation `c₇(-1)=0, c₇(0)=1 ⇒ c₇(1)=2` (his
    p.47, the `n=0` instance) becomes the two initial values `c 0 = 1, c 1 = 2`
    taken as hypotheses directly. Any sequence matching this data is
    (uniquely, and per the theorem, integrally) his `c₇`.
    -- Source: see file docstring. -/
axiom obrien2016_theorem6_2 (c : ℕ → ℚ) (h0 : c 0 = 1) (h1 : c 1 = 2)
    (hrec : ∀ k : ℕ,
      ((k : ℚ) + 2) ^ 2 * c (k + 2) =
        (26 * ((k : ℚ) + 1) ^ 2 + 13 * ((k : ℚ) + 1) + 2) * c (k + 1)
          + 3 * (3 * (k : ℚ) + 1) * (3 * (k : ℚ) + 2) * c k) :
    ∀ n, ∃ m : ℤ, c n = (m : ℚ)

end Agora.Axioms
