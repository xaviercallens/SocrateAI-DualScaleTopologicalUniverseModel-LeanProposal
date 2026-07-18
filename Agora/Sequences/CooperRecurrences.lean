/-
  CooperRecurrences.lean
  ════════════════════════════════════════════════════════════════════════════════

  WP S1-02 — Cooper's sporadic sequences s7 and s10, encoded as computable
  closed-form definitions with literature citations, plus the three-term
  holonomic recurrence they are known (in the literature) to satisfy.

  SCOPE NOTE (honest, per EXECUTION_PLAN.md §6 anti-hallucination protocol):
  This file covers s7 and s10 only. The candidates "S22" and "t103" named in
  K3_CRITERIA.md's register could NOT be identified in the sporadic-sequence
  literature (Zagier's 6, Almkvist–Zudilin's 6, Cooper's 3 = s7/s10/s18) after
  a genuine multi-query search effort. See `briefs/ESCALATIONS.md` entry
  "S22-t103-unidentified" — T0/Xavier must resolve the correct citation or
  drop these candidates per K3_CRITERIA.md's own rule: "a candidate without a
  citable defining recurrence at freeze time is dropped, not guessed."

  0 sorry in this file (the recurrence-satisfaction facts are isolated in
  OpenGoals/CooperRecurrences.lean, per the sorry-only-in-OpenGoals policy).

  ════════════════════════════════════════════════════════════════════════════════
-/

import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Int.Basic
import Mathlib.Tactic

namespace Agora.Sequences

open Finset

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE RECURRENCE TEMPLATE                                       ║
-- ║  Zagier / Almkvist–Zudilin / Cooper's sporadic sequences all solve  ║
-- ║  a three-term recurrence of this shape, differing only in the four  ║
-- ║  integer parameters (a, b, c, d).                                   ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Parameters (a, b, c, d) fixing one instance of the sporadic three-term
    recurrence
      (n+1)³ u(n+1) = (2n+1)(a·n² + a·n + b)·u(n) − n·(c·n² + d)·u(n−1),
    the common template for the 15 known sporadic Apéry-like sequences
    (6 due to Zagier, 6 due to Almkvist–Zudilin, 3 due to Cooper).
    -- Source: S. Cooper, "Sporadic sequences, modular forms and new series
    for 1/π", Ramanujan J. 29 (2012), 163–183.
    -- Source: O. Gorodetsky, "New representations for all sporadic
    Apéry-like sequences, with applications to congruences", Exp. Math. 32
    (2023), arXiv:2102.11839, §1–2 (recurrence template and per-sequence
    parameter table). -/
structure CooperRecurrenceParams where
  a : ℤ
  b : ℤ
  c : ℤ
  d : ℤ
  deriving Repr, DecidableEq

/-- A sequence `u : ℕ → ℤ` satisfies the Cooper-template recurrence with
    parameters `p` if the defining identity holds for every `n ≥ 1`.
    -- Source: Cooper (2012), Ramanujan J. 29, recurrence template
    underlying Table 1; see also Gorodetsky (2023), arXiv:2102.11839, §1. -/
def SatisfiesCooperRecurrence (u : ℕ → ℤ) (p : CooperRecurrenceParams) : Prop :=
  ∀ n : ℕ, 1 ≤ n →
    ((n : ℤ) + 1) ^ 3 * u (n + 1) =
      (2 * (n : ℤ) + 1) * (p.a * (n : ℤ) ^ 2 + p.a * (n : ℤ) + p.b) * u n
        - (n : ℤ) * (p.c * (n : ℤ) ^ 2 + p.d) * u (n - 1)

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. COOPER'S s7                                                    ║
-- ║  Third-order sporadic sequence (K3-type Picard-Fuchs operator).     ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Recurrence parameters for Cooper's s7: (a, b, c, d) = (13, 4, −27, 3).
    -- Source: Cooper (2012), Ramanujan J. 29, Table 1, sequence s₇.
    -- Cross-checked: Gorodetsky (2023), arXiv:2102.11839, §2 (parameter
    table for the three Cooper sequences s₇, s₁₀, s₁₈). -/
def s7_params : CooperRecurrenceParams := ⟨13, 4, -27, 3⟩

/-- Cooper's s7, as the closed-form binomial-sum representation
      u(n) = Σ_{k=⌈n/2⌉}^{n} C(n,k)² · C(n+k,k) · C(2k,n),
    a WZ-pair (Wilf–Zeilberger) certificate representation proved in the
    literature to satisfy `s7_params`'s recurrence with u(0)=1, u(1)=4.
    Computable and matched against independently-verified values in
    `Tests/CooperSequences.lean`.
    -- Source: O. Gorodetsky, "New representations for all sporadic
    Apéry-like sequences, with applications to congruences", Exp. Math. 32
    (2023), arXiv:2102.11839, closed-form for s₇ (§2/§3 table). Originally
    defined via the recurrence in S. Cooper (2012), Ramanujan J. 29,
    Table 1. -/
def s7 (n : ℕ) : ℕ :=
  ∑ k ∈ Finset.Icc ((n + 1) / 2) n, (n.choose k) ^ 2 * (n + k).choose k * (2 * k).choose n

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. COOPER'S s10                                                   ║
-- ║  Third-order sporadic sequence, "Yang–Zudilin numbers".             ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Recurrence parameters for Cooper's s10: (a, b, c, d) = (6, 2, −64, 4).
    -- Source: Cooper (2012), Ramanujan J. 29, Table 1, sequence s₁₀.
    -- Cross-checked: Gorodetsky (2023), arXiv:2102.11839, §2. -/
def s10_params : CooperRecurrenceParams := ⟨6, 2, -64, 4⟩

/-- Cooper's s10, as the closed-form binomial-sum representation
      u(n) = Σ_{k=0}^{n} C(n,k)⁴.
    Known in the literature as the "Yang–Zudilin numbers". Computable and
    matched against independently-verified values in
    `Tests/CooperSequences.lean`.
    -- Source: O. Gorodetsky (2023), arXiv:2102.11839, closed-form for s₁₀
    (§2/§3 table). Originally defined via the recurrence in S. Cooper
    (2012), Ramanujan J. 29, Table 1. -/
def s10 (n : ℕ) : ℕ :=
  ∑ k ∈ Finset.range (n + 1), (n.choose k) ^ 4

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. COOPER'S s18                                                   ║
-- ║  Third Cooper sequence. Added 2026-07-18 after primary-source fetch ║
-- ║  (resolves E-001 PENDING_ENCODING). Encoded via its recurrence      ║
-- ║  parameters + golden values, NOT the closed form (see caveat).      ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- Recurrence parameters for Cooper's s18: (a, b, c, d) = (14, 6, 192, −12).
    -- Source: O. Gorodetsky, arXiv:2102.11839 v2 (5 Jan 2025), p.3 Cooper table
    (SHA256 pinned in refs/cooper_sequences.md). Cross-ref: Cooper (2012),
    Ramanujan J. 29, Table 1; Malik–Straub arXiv:1508.00297.
    NOTE: unlike s7/s10, no verified closed-form `s18 : ℕ → ℕ` is provided here —
    a direct transcription of the p.3 closed form disagreed with the recurrence
    at n=3 (ℕ-truncated vs signed binomial edge-cases). s18 is therefore
    represented by its (sourced) parameters plus recurrence-validated golden
    values in Tests/; a verified closed form is deferred follow-on work. -/
def s18_params : CooperRecurrenceParams := ⟨14, 6, 192, -12⟩

end Agora.Sequences
