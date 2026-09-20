/-
  Agora/Sequences/S7Mod4.lean
  ════════════════════════════════════════════════════════════════════════════════

  `4 ∣ s₇(n)` FOR EVERY `n ≥ 1` — AND THE RESULTING AXIOM-FREE PROOF THAT THE
  s₇ PARTNER IS INTEGRAL.

  This retires the development's only literature axiom. `AXIOMS.md` goes from two
  entries to one (`pipeline_upper_bound`, disclosed-vacuous, remains).

  ────────────────────────────────────────────────────────────────────────────────
  THE MECHANISM: DIVISIBILITY IS TERMWISE

  `s₇(n) = Σ_{k} C(n,k)²·C(n+k,k)·C(2k,n)`. We show `4` divides EVERY summand
  with `k ≥ 1`, and the summation range `Icc ⌈n/2⌉ n` contains only such `k` once
  `n ≥ 1`. Case on the parity of `C(n,k)`:

    • `C(n,k)` even  ⇒  `4 ∣ C(n,k)²`, done.
    • `C(n,k)` odd   ⇒  the OTHER TWO factors are each even, giving `2·2`.

  The odd case is where the content is, and it comes from two instances of the
  subset-of-a-subset identity `Nat.choose_mul`, each arranged to expose the
  CENTRAL binomial coefficient `C(2k,k)`, which is even for `k ≥ 1`:

      C(n+k,2k)·C(2k,k) = C(n+k,k)·C(n,k)      ⇒  2 ∣ C(n+k,k)  when C(n,k) odd
      C(2k,n) ·C(n,k)   = C(2k,k)·C(k,n−k)     ⇒  2 ∣ C(2k,n)   when C(n,k) odd

  Equivalently, in one line: the summand equals `C(n+k,2k)·C(k,n−k)·C(2k,k)²`,
  in which `4 ∣ C(2k,k)²` is visible by inspection. No recurrence, no generating
  function, no modular form.

  ────────────────────────────────────────────────────────────────────────────────
  WHY THIS WAS THOUGHT HARD, AND WHAT THE OBSTRUCTION ACTUALLY WAS

  The statement had been attacked three ways, all recorded as failures:
  (a) induction mod 4 on the order-3 recurrence for `s₇` — the leading
      coefficient `(n+1)³` is even for odd `n`, so dividing loses 2-adic
      information; (b) mod-2 analysis of the order-2 partner recurrence — it
      controls odd indices only, because `(k+2)²` is even exactly at the even
      ones; (c) deducing it from partner integrality — circular, the two are
      equivalent. A modular route was also known (`Σ s₇(n)z(q)ⁿ = θ(q)²` with
      `θ = Σ q^{a²+ab+2b²}`, whence `θ² ≡ 1 mod 4`), but it imports an identity
      this development verifies only to `O(q⁴⁰)`.

  Every one of those is a statement about RECURRENCES or about MODULAR OBJECTS.
  The proof below touches neither: it is a statement about a finite sum of
  binomial coefficients, proved by factoring one summand. The obstruction was
  framing, not depth. This is the third time in this development that a goal
  recorded as blocked fell to a change of representation rather than to new
  machinery — cf. `OpenGoals/PartnerIntegrality.lean`.

  ────────────────────────────────────────────────────────────────────────────────
  STATUS

  Tier A. 0 `sorry`, no `native_decide`, axioms `propext`/`Classical.choice`/
  `Quot.sound` only — verified by `#print axioms` on
  `s7_partner_integral_axiom_free` below.

  We do NOT claim this is a new theorem: `4 ∣ s₇(n)` follows from the modular
  identity, which is in the literature. We claim an elementary, self-contained,
  machine-checked proof of it that needs no modular input. Whether this exact
  argument appears in print, we have not established and do not assert.

  The legacy `Partner.s7_partner_integral` still routes through
  `Axioms.obrien2016_theorem6_2` and is retained so the two derivations can be
  compared; `s7_partner_integral_axiom_free` below is the one to cite.
  ════════════════════════════════════════════════════════════════════════════════
-/

import Agora.Sequences.SqrtIntegrality
import Mathlib.Data.Nat.Choose.Central

namespace Agora.Sequences.S7Mod4

open Agora.Sequences Agora.Sequences.Partner

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §1. THE CENTRAL BINOMIAL COEFFICIENT IS EVEN                       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- `C(2k,k)` is even for `k ≥ 1`. -/
theorem two_dvd_central {k : ℕ} (hk : 0 < k) : 2 ∣ (2 * k).choose k := by
  have h := Nat.two_dvd_centralBinom_of_one_le hk
  rwa [Nat.centralBinom_eq_two_mul_choose] at h

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §2. THE ODD CASE: THE OTHER TWO FACTORS ARE EVEN                   ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- If `C(n,k)` is odd and `1 ≤ k ≤ n`, then `C(n+k,k)` is even.
    From `C(n+k,2k)·C(2k,k) = C(n+k,k)·C(n,k)`. -/
theorem two_dvd_choose_add {n k : ℕ} (hk : 0 < k) (hkn : k ≤ n)
    (hodd : ¬ 2 ∣ n.choose k) : 2 ∣ (n + k).choose k := by
  have key : (n + k).choose (2 * k) * (2 * k).choose k
      = (n + k).choose k * n.choose k := by
    have h := Nat.choose_mul (n := n + k) (k := 2 * k) (s := k) (by omega)
    rwa [Nat.add_sub_cancel, show 2 * k - k = k by omega] at h
  have hL : 2 ∣ (n + k).choose k * n.choose k :=
    key ▸ dvd_mul_of_dvd_right (two_dvd_central hk) _
  rcases (Nat.Prime.dvd_mul Nat.prime_two).mp hL with h | h
  · exact h
  · exact absurd h hodd

/-- If `C(n,k)` is odd and `1 ≤ k ≤ n`, then `C(2k,n)` is even.
    From `C(2k,n)·C(n,k) = C(2k,k)·C(k,n−k)`. -/
theorem two_dvd_choose_two_mul {n k : ℕ} (hk : 0 < k) (hkn : k ≤ n)
    (hodd : ¬ 2 ∣ n.choose k) : 2 ∣ (2 * k).choose n := by
  have key : (2 * k).choose n * n.choose k
      = (2 * k).choose k * k.choose (n - k) := by
    have h := Nat.choose_mul (n := 2 * k) (k := n) (s := k) hkn
    rwa [show 2 * k - k = k by omega] at h
  have hL : 2 ∣ (2 * k).choose n * n.choose k :=
    key ▸ dvd_mul_of_dvd_left (two_dvd_central hk) _
  rcases (Nat.Prime.dvd_mul Nat.prime_two).mp hL with h | h
  · exact h
  · exact absurd h hodd

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §3. EVERY SUMMAND IS DIVISIBLE BY 4                                ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **Termwise divisibility.** For `1 ≤ k ≤ n`, `4` divides the `k`-th summand
    of `s₇(n)`. -/
theorem four_dvd_term {n k : ℕ} (hk : 0 < k) (hkn : k ≤ n) :
    4 ∣ (n.choose k) ^ 2 * ((n + k).choose k) * ((2 * k).choose n) := by
  by_cases h : 2 ∣ n.choose k
  · obtain ⟨c, hc⟩ := h
    exact ⟨c ^ 2 * ((n + k).choose k) * ((2 * k).choose n), by rw [hc]; ring⟩
  · obtain ⟨a, ha⟩ := two_dvd_choose_add hk hkn h
    obtain ⟨b, hb⟩ := two_dvd_choose_two_mul hk hkn h
    exact ⟨(n.choose k) ^ 2 * a * b, by rw [ha, hb]; ring⟩

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §4. THE THEOREM                                                    ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **`4 ∣ s₇(n)` for every `n ≥ 1`.** -/
theorem four_dvd_s7 (n : ℕ) (hn : 1 ≤ n) : 4 ∣ s7 n := by
  rw [s7]
  refine Finset.dvd_sum fun k hk => ?_
  rw [Finset.mem_Icc] at hk
  exact four_dvd_term (by omega) hk.2

/-- The same, in the exact form consumed by
    `SqrtIntegrality.s7_partner_integral_of_congruence`. -/
theorem four_dvd_s7_int (n : ℕ) (hn : 1 ≤ n) : (4 : ℤ) ∣ (s7 n : ℤ) := by
  exact_mod_cast Int.natCast_dvd_natCast.mpr (four_dvd_s7 n hn)

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §5. THE PAYOFF: PARTNER INTEGRALITY WITHOUT THE AXIOM              ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- **The s₇ partner is integral — with no literature axiom.**

    Same conclusion as `Partner.s7_partner_integral`, which routes through
    `Axioms.obrien2016_theorem6_2`. This one does not: its axiom set is
    `propext`, `Classical.choice`, `Quot.sound`. This is the declaration to
    cite. -/
theorem s7_partner_integral_axiom_free :
    ∀ n, IsIntegral (partnerSeq s7_params n) :=
  SqrtIntegrality.s7_partner_integral_of_congruence four_dvd_s7_int

-- ╔════════════════════════════════════════════════════════════════════╗
-- ║  §6. CONTROLS                                                       ║
-- ╚════════════════════════════════════════════════════════════════════╝

/-- The modulus `4` is SHARP: `8 ∤ s₇(1) = 4`. So the theorem is not a
    statement that any modulus would satisfy. -/
theorem eight_not_dvd_s7_one : ¬ (8 ∣ s7 1) := by decide

/-- The criterion DISCRIMINATES: it fails for `s₁₀` already at `n = 1`,
    consistent with `s10_partner_not_integral`. -/
theorem four_not_dvd_s10_one : ¬ (4 ∣ s10 1) := by decide

/-- Golden check against the literature opening `1, 4, 48, 760, 13840`. -/
theorem s7_opening : s7 0 = 1 ∧ s7 1 = 4 ∧ s7 2 = 48 ∧ s7 3 = 760 ∧ s7 4 = 13840 := by
  refine ⟨by decide, by decide, by decide, by decide, by decide⟩

end Agora.Sequences.S7Mod4
