/-
  Tests/CooperSequences.lean
  ════════════════════════════════════════════════════════════════════════════════

  Golden numeric tests for WP S1-02 (Agora/Sequences/CooperRecurrences.lean).

  Values below were computed independently in Python (standard library
  `math.comb`, exact integer arithmetic) directly from the closed-form
  binomial-sum definitions — NOT recalled from memory. See commit message
  for the derivation script. Cross-checked against Cooper's three-term
  recurrence for n = 1..7 (both s7_params and s10_params satisfied exactly,
  zero residual) before being accepted as golden values.

  0 sorry. Uses `native_decide`: terms up to n=19 involve binomial
  coefficients large enough (e.g. C(38,19)) that kernel `decide` is
  impractical. Both golden theorems are tagged TRUST: native_decide per
  the lean-proof-workflow skill's disclosure rule.

  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.CooperRecurrences

namespace Agora.Sequences.Tests

open Agora.Sequences

/-- s7(n) for n = 0..19, independently computed. -/
def s7_golden : List ℕ :=
  [1, 4, 48, 760, 13840, 273504, 5703096, 123519792, 2751843600, 62659854400,
   1451780950048, 34116354472512, 811208174862904, 19481055861877120,
   471822589361293680, 11511531876280913760, 282665135367572129040,
   6980148970765596060480, 173234698046183331148800, 4318681773260285456995200]

/-- s10(n) for n = 0..19, independently computed. -/
def s10_golden : List ℕ :=
  [1, 2, 18, 164, 1810, 21252, 263844, 3395016, 44916498, 607041380,
   8345319268, 116335834056, 1640651321764, 23365271704712, 335556407724360,
   4854133484555664, 70666388112940818, 1034529673001901732,
   15220552520052960516, 224929755893153896200]

/-- Golden test: s7 matches the independently-computed reference values
    for the first 20 terms.
    /-- TRUST: native_decide -/ -/
theorem s7_golden_test :
    (List.range 20).map s7 = s7_golden := by native_decide

/-- Golden test: s10 matches the independently-computed reference values
    for the first 20 terms.
    /-- TRUST: native_decide -/ -/
theorem s10_golden_test :
    (List.range 20).map s10 = s10_golden := by native_decide

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  s18 — golden values + recurrence-satisfaction check                ║
-- ║  s18 has no verified closed form here; instead we pin its values    ║
-- ║  (computed from the SOURCED params by exact integer arithmetic) and ║
-- ║  kernel-check that they satisfy Cooper's s18 recurrence. This ties  ║
-- ║  the sourced (14,6,192,−12) params to concrete integers directly.   ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- s18(n) for n = 0..9, from the sourced recurrence (Gorodetsky p.3,
    params (14,6,192,−12)); every recurrence step divided exactly.
    -- Source: refs/cooper_sequences.md (arXiv:2102.11839 v2, SHA-pinned). -/
def s18_golden : List ℤ :=
  [1, 6, 54, 564, 6390, 76356, 948276, 12132504, 158984694, 2124923460]

/-- Recurrence-residual check at index `n` given three consecutive values
    `um1 = u(n−1)`, `u = u(n)`, `up1 = u(n+1)`, for Cooper's s18 params
    (14, 6, 192, −12): returns `true` iff the recurrence holds exactly. -/
def s18RecOK (n : ℕ) (um1 u up1 : ℤ) : Bool :=
  ((n : ℤ) + 1) ^ 3 * up1 ==
    (2 * (n : ℤ) + 1) * (14 * (n : ℤ) ^ 2 + 14 * n + 6) * u
      - (n : ℤ) * (192 * (n : ℤ) ^ 2 - 12) * um1

/-- The s18 golden values satisfy Cooper's recurrence at every index n = 1..8
    (each index whose neighbours are both in the pinned list). A kernel proof
    here validates that the pinned values are consistent with the SOURCED
    parameters `s18_params = (14,6,192,−12)` — no closed form needed. -/
theorem s18_golden_satisfies_recurrence :
    (List.range 8).all
      (fun i => s18RecOK (i + 1)
        (s18_golden.getD i 0) (s18_golden.getD (i + 1) 0) (s18_golden.getD (i + 2) 0))
      = true := by
  decide

end Agora.Sequences.Tests
