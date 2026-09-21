---
name: epistemic-guardrails
description: Enforce the VISION.md epistemic tier system in ALL written output. Use this skill whenever writing or editing any prose about the project — README files, reports, abstracts, docstrings, commit messages, paper drafts, talk notes, issue comments, or any sentence that describes what the model/mathematics does or shows. Also use when reviewing a PR. Trigger even for one-line descriptions: tier violations happen most in casual summaries.
---

# Epistemic Guardrails

This project's credibility rests on never overstating a claim. VISION.md §2 defines
three tiers; this skill makes the rules operational for every sentence you write.

## The three tiers (short form)

- **Tier A** — established/machine-certified mathematics. May be stated as fact.
- **Tier B** — checkable but unproven (per-candidate Sym², integrality beyond N, Swampland
  checks). Must carry a hedge + its verification route: "conjectured, tracked as criterion C3",
  "verified to order N₁ (evidence, not proof)".
- **Tier C** — physical interpretation (dark sector identification, brane realization,
  bulk/brane coupling). Must carry an explicit conjecture marker in the SAME sentence.

## Hard language rules

1. **Forbidden for Tier C claims** (unless prefixed by "we conjecture", "would", "if the
   matching exists"): *predicts, establishes, shows, implies, locks, governs, determines,
   demonstrates, proves*.
2. **The Sym² relation implies no physics.** Never write that the symmetric-square /
   Shioda-Inose structure "links", "locks", or "couples" the bulk to the brane EFT.
   The binding ruling is VISION §1.3: geometric relation ≠ physical coupling absent a
   worked EFT matching.
3. **`PASS(N)` notation.** Finite-order checks (mirror-map integrality to N terms) are
   always reported as `PASS(N)`, never bare `PASS`.
4. **`native_decide` and axioms.** Any Lean result whose proof uses `native_decide` or an
   axiom from `Axioms/` must say so when cited in prose ("kernel-checked modulo compiler
   trust" / "modulo axioms listed in AXIOMS.md"). It is not plain Tier A.
5. **No numbers from memory.** Every numeric constant or literature value in prose must
   trace to a checker certificate, a Lean `#eval`/test, or a cited file in `refs/`.
   If you cannot point to the source, do not write the number.

## Required artifacts

- **Provenance footer** on every generated file:
  `Generated-by: <model/tier> | Verified-by: <verifier> | Reviewed-by: <T0 Y/N>`
- **Tier ruling requests**: if you are unsure of a claim's tier, do NOT guess — add an
  entry to `TIER_LEDGER.md` with status `RULING-REQUESTED` and flag it for the T0
  orchestrator session. Writing the cautious (lower-tier) phrasing in the meantime.
- **F6 discipline**: if you discover an error in a previously claimed Tier A/B result,
  the fix is not enough — add the disclosure note to the repo README in the same PR.

## The claim must live in the statement, not the name (LL.md §1)

This is the defect class that produced nine findings on 2026-09-21, **none of which any gate
caught**. A declaration can be true, compile, and pass the build, the `sorry` grep, the axiom
audit and the statement lock while proving **less than its name says** — the claim living in
the identifier and the docstring.

6. **Every noun in a name must appear in the statement.** `glue_primitive` was
   `IsCoprime (1 : ℤ) N` — `isCoprime_one_left` renamed, mentioning no vector, no basis and
   no `U`. If the object the name is about is absent from the statement, the claim is prose.
7. **Constraining ≠ identifying.** A theorem can pin every property you tested and still leave
   the object unnamed; then the *name* does the identifying. Say what the object IS.
8. **A docstring cannot fix a name.** A name is what gets quoted, in isolation, by readers and
   by retrieval systems. When the statement cannot be raised to meet the name — e.g. Tier C is
   blocked — **the name comes down to meet the statement.**
9. **A disclosure belongs ON the declaration**, not only in the prose discussing it — and on
   **the declaration the criticism names**, which is not always where the substance lives.
   Open each in-place disclosure with the literal word `Disclosure`.
10. **Writing a critique is not landing it.** If a review says a declaration claims more than
    it proves, the FIRST edit is that declaration's docstring. A correct critique sitting in a
    README or a paper is an *unlanded fix* — treat it as open, not done.
11. **Quarantine, never delete** (LL.md §5.1). Superseded claims are marked and kept; a rename
    leaves a pointer comment. `git mv`, never `rm`.

## Encoding traps when checking prose (LL.md §3.9)

A matcher checks a string, not the object. All three of these produced confident wrong numbers
in one day:

- Lean writes `` declaration uses `sorry` `` with **backticks** — a straight-quote grep finds 0
  while the warning is present.
- LaTeX splits a banned phrase across macros: `PASS(\texorpdfstring{$N$}{N})` does not match
  `PASS\([0-9N]`, and `100\% verified` does not match `100% verified`.
- A line-anchored token check fires on prose (`^\s*axiom\s` matches a sentence beginning
  "axiom audit…") and misses attribute-prefixed declarations.

## Review checklist (run on any prose diff)

- [ ] Every Tier C sentence has a conjecture marker in the sentence itself.
- [ ] No forbidden verb applied to an unconstructed physical mechanism.
- [ ] Every number traceable; every `PASS` carries its order.
- [ ] Provenance footer present.
- [ ] Nothing in this diff weakens VISION §2/§4 (those may only be strengthened).
- [ ] Every declaration name in the diff is matched by its statement, not by its docstring.
- [ ] Any disclosure is on the declaration itself, opening with the word `Disclosure`.
- [ ] No fenced block is presented as tool output unless pasted from a run in THIS session
      (LL.md §6 — the danger signature is near-certainty, not carelessness; "pending" is
      always available).
