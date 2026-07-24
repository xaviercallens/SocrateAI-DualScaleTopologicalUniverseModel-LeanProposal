# D1 (E-006) — Fable 5 Output: Cleared-Denominator Identity `P_cleared(z)`

**From:** Fable 5 (T0 math design)  
**To:** Deep Think (T0s — independent CAS re-derivation required, two-model rule)  
**Date:** 2026-07-24  
**Status:** **FROZEN, AWAITING DEEP THINK CONCURRENCE. Opus encodes NO Lean until concurrence is recorded here.**

---

## 1. The claim to certify

For the generic Cooper operator (Gorodetsky arXiv:2102.11839 eq 1.7; symbolic `a,b,c,d`)

```
L = θ³ − z(2θ+1)(aθ² + aθ + b) + z²(c(θ+1)³ + d(θ+1)),   θ = z·d/dz
```

the Almkvist–van Straten self-adjointness criterion `W ≡ 0` (arXiv:2103.08651) is **equivalent**
to the pure polynomial identity `P_cleared ≡ 0` in `ℚ[a,b,c,d][z]` defined below — the Option-B
reformulation that eliminates the z=0 pole and the need for any `RatFunc` derivative API.

## 2. D-form coefficients (derived, exact)

`L = p3·D³ + p2·D² + p1·D + p0` with:

```
p3 = z³·(1 − 2az + cz²)
p2 = 3z²·(1 − 3az + 2cz²)
p1 = z·(1 − (6a+2b)z + (7c+d)z²)
p0 = z·(−b + (c+d)z)
```

Cross-check: `a₂ = p2/p3 = 3(1−3az+2cz²)/(z(1−2az+cz²))` — matches the monic-normalized `a₂`
cited in E-006 from the literature. ✓

## 3. The cleared identity (the object to re-derive)

Substituting `aᵢ = pᵢ/p3` into `W = ⅓a₂″ + ⅔a₂a₂′ + 4⁄27·a₂³ + 2a₀ − ⅔a₁a₂ − a₁′` and
multiplying by the exact common denominator **`27·p3³`**:

```
P_cleared := 9·(p2″p3² − p2·p3·p3″ − 2p2′p3·p3′ + 2p2·(p3′)²)
           + 18·p2·(p2′p3 − p2·p3′)
           + 4·p2³
           + 54·p0·p3²
           − 18·p1·p2·p3
           − 27·p3·(p1′p3 − p1·p3′)
```

(′ = d/dz. Every division has been eliminated; each term is a polynomial product.)

**Equivalence argument (sign off on this specifically):** in `Frac(ℚ[a,b,c,d][z])`,
`W = P_cleared/(27·p3³)` with `p3` a nonzero polynomial, hence `W ≡ 0 ⇔ P_cleared ≡ 0`.
The clearing multiplier is explicit; no factor is silently gained or lost (the E-04c risk).

## 4. Verification performed (sympy 1.14, exact arithmetic — `scripts/derive_D1_P_cleared.py`)

| Check | Result |
|---|---|
| `P_cleared` expands to the **zero polynomial** for generic `a,b,c,d` | **PASS** (the D1 claim) |
| Same at concrete s7 (13,4,−27,3), s10 (6,2,−64,4), s18 (14,6,192,−12) | PASS ×3 |
| Negative control (non-Cooper `p₃=1, p₂=z²+1, p₁=z+2, p₀=z³`): `P_cleared = 4z⁶+12z⁴+72z³−24z²+18z−41 ≠ 0` | PASS (detector still fires) |
| Clearing identity itself: `P_cleared/(27p3³) − W = 0` on the control | PASS |

## 5. What Deep Think must do (concurrence gate)

1. Independently derive the D-form `p0..p3` from eq 1.7 (do not copy §2).
2. Independently clear denominators of `W` and confirm the multiplier is `27·p3³` and the
   six-term shape of §3 (or an algebraically identical form — state any difference explicitly).
3. Confirm `P_cleared ≡ 0` for generic `a,b,c,d` in your CAS.
4. Record concurrence (or discrepancy) in `briefs/ESCALATIONS.md` E-006.

**Then** Opus encodes: `p0..p3 : Polynomial ℚ` (per candidate, or with `a,b,c,d` as rational
coefficients via `MvPolynomial`), states `P_cleared = 0`, discharges by `ring`, and flips
`SYM2_SYMBOLIC → SYM2_PROVED`.

---

*Generated-by: Fable 5 (T0 math design) | Verified-by: sympy exact symbolic, controls pass
(`scripts/derive_D1_P_cleared.py`) | Reviewed-by: T0 N — awaiting Deep Think (two-model rule)*
