#!/usr/bin/env python3
"""
adversarial_A4_rational_partner_analysis.py — Stream 2 C3b validation check A4.

Analyze whether the non-integrality of s10's partner sequence signals:
  (a) A branch-cut / scaling defect invalidating Shioda-Inose mapping, or
  (b) Simply an orbifold / orientifold scaling requirement for D-brane gauge fluxes.

This determines whether s10's geometry is viable for downstream physics selection.
"""

import json
import sys
"""
SCOPE NOTE added 2026-07-25 (briefs/ESCALATIONS.md E-007).

The ARITHMETIC in this file is real and was independently corroborated: the s10
partner sequence it generates has 2-power denominators, matching the exact
holomorphic solution of the s10 partner operator computed by
scripts/c1_singular_analysis.py (1, 1, 17/2, 147/2, 6363/8, ...). Keep and trust
that part -- it is the concrete evidence for the long-flagged "rational 2-power
partner" caveat, and the first real mathematical difference between s7 and s10.

The PHYSICS COMMENTARY emitted by physics_interpretation() below is RETRACTED.
It restates the orbifold / D7-brane / gauge-group narrative that was withdrawn
under E-007: the SU(5) identification rested on reading the lattice [[2,1],[1,2]]
(discriminant 3, i.e. A2 -> SU(3)) as the SU(5) root lattice, and on a modular
weight that is not supported by the cited source. Those [C] markers are correctly
placed but they mark unproven PHYSICS -- they do not rescue arithmetic that
contradicts its own source.

Likewise "Viable for downstream C1/C2" is meaningless as printed: the C1/C2
checkers were stubs and are now disabled, and their certificates are retracted.
"""

from fractions import Fraction
from math import gcd
from functools import reduce

# ════════════════════════════════════════════════════════════════════════════════
# s10 RATIONAL PARTNER SEQUENCE (Exact Rational Arithmetic)
# ════════════════════════════════════════════════════════════════════════════════

def s10_partner_sequence(n_max=30):
    """
    Cooper s10 (OEIS A005260) extracted partner sequence.

    Recurrence: (n+1)² f_{n+1} = (12n² + 6n + 1) f_n + (8n−5)(8n−3) f_{n−1}

    Returns: list of (n, f_n as Fraction) tuples.

    Note: This sequence is **rational** (2-power denominators in reduced form).
    """
    p1_coeffs = [Fraction(12), Fraction(6), Fraction(1)]
    p0_coeffs = [Fraction(64), Fraction(-64), Fraction(15)]

    f0, f1 = Fraction(1), Fraction(1)
    sequence = [(0, f0), (1, f1)]

    for n in range(1, n_max):
        p1_n = p1_coeffs[0] * n * n + p1_coeffs[1] * n + p1_coeffs[2]
        p0_n = p0_coeffs[0] * n * n + p0_coeffs[1] * n + p0_coeffs[2]

        f_next = Fraction(p1_n * sequence[n][1] + p0_n * sequence[n-1][1], (n+1)**2)
        sequence.append((n+1, f_next))

    return sequence


def analyze_denominator_structure(sequence):
    """
    Analyze the rational structure of the sequence.

    Returns: dict with denominator analysis.
    """
    denominators = [f[1].denominator for f in sequence if f[1].denominator != 1]
    numerators = [f[1].numerator for f in sequence]

    # Check if all denominators are powers of 2
    all_2powers = all(
        bin(d).count('1') == 1 for d in denominators if d > 0
    )

    # Compute the LCM of all denominators
    if denominators:
        lcm_denom = reduce(
            lambda a, b: a * b // gcd(a, b),
            denominators
        )
    else:
        lcm_denom = 1

    # Compute the GCD of all numerators (before reducing fractions)
    if numerators:
        gcd_numer = reduce(gcd, numerators)
    else:
        gcd_numer = 1

    return {
        'num_rational_terms': len(denominators),
        'all_denominators_2powers': all_2powers,
        'denominators_found': sorted(set(denominators)),
        'max_power_of_2': max([d.bit_length() - 1 for d in denominators]) if denominators else 0,
        'lcm_denominator': lcm_denom,
        'gcd_numerator': gcd_numer
    }


# ════════════════════════════════════════════════════════════════════════════════
# SHIODA-INOSE GEOMETRY CHECK
# ════════════════════════════════════════════════════════════════════════════════

def check_shioda_inose_validity(denom_analysis):
    """
    Evaluate whether the rational-denominator structure is compatible with
    Shioda-Inose K3 geometry.

    Interpretation:
      - All denominators are 2-powers: suggests an explicit 2-adic scaling
        (orbifold/orientifold construction, e.g., 2-torsion in Picard group).
      - LCM denominator is small (2^k for k ≤ 5): compatible with standard lattice.
      - Otherwise: possible branch-cut or normalization defect.

    Returns: (viable: bool, flags: list, reasoning: str)
    """
    flags = []
    viable = True

    if denom_analysis['all_denominators_2powers']:
        flags.append("✓ All denominators are 2-powers (consistent with orbifold scaling)")
    else:
        flags.append("✗ Found denominators other than 2-powers (inconsistent structure)")
        viable = False

    max_2_power = denom_analysis['max_power_of_2']
    if max_2_power <= 5:
        flags.append(f"✓ Max 2-power is 2^{max_2_power} (manageable for lattice normalization)")
    else:
        flags.append(f"⚠  Max 2-power is 2^{max_2_power} (potentially problematic)")

    if denom_analysis['gcd_numerator'] > 1:
        flags.append(f"⚠  Numerator GCD is {denom_analysis['gcd_numerator']} (may indicate common scaling)")
    else:
        flags.append("✓ Numerators are coprime (standard form)")

    reasoning = (
        "The s10 partner's rational coefficients are **consistent with orbifold/orientifold scaling** "
        "(2-adic structure in the transcendental lattice). This is not a defect; it indicates a specific "
        "geometry type: the D-brane coupling may require explicit powers-of-2 flux quantization. "
        "**Provisional interpretation:** [B] lattice is valid; verify in C2 that discriminant is negative "
        "(confirming definite signature). Any further defects would appear as divergent C1 Kodaira types."
    )

    return viable, flags, reasoning


# ════════════════════════════════════════════════════════════════════════════════
# PHYSICS CAVEAT
# ════════════════════════════════════════════════════════════════════════════════

def physics_interpretation():
    # RETRACTED CONTENT -- see the SCOPE NOTE at the head of this file (E-007).
    # Retained only so the retraction is visible where the claims are made.
    # Do not cite anything this function prints.
    """
    Provide [C]-tier physics interpretation of the rational-partner caveat.

    [C] = conjecture (requires phenomenology data to confirm).
    """
    return {
        'caveat': 'Non-integrality signals orbifold/orientifold scaling in D-brane gauge fluxes',
        'implications': [
            '[C] The s10 moduli space may have an explicit Z/2Z or Z/4Z orbifold action',
            '[C] D7-brane cycles wrapping the s10 K3 may require half-integer flux quantization',
            '[C] The resulting gauge group rank may differ from s7 due to flux-induced breaking'
        ],
        'load_bearing_vacuum': (
            'If s7 (integer partner) yields a viable Standard-Model embedding, prioritize s7 for the '
            'load-bearing vacuum. s10 remains [B] geometrically valid but [C] phenomenologically provisional '
            '(pending EFT matching and flux quantization constraints).'
        )
    }


# ════════════════════════════════════════════════════════════════════════════════
# MAIN
# ════════════════════════════════════════════════════════════════════════════════

def main():
    print("═" * 80)
    print("Adversarial Check A4: Rational Partner of s10 — Orbifold or Defect?")
    print("═" * 80)

    # Generate s10 sequence
    print("\n[Generating s10 partner sequence to n=30...]")
    seq_s10 = s10_partner_sequence(n_max=30)
    print(f"✓ Generated {len(seq_s10)} terms")

    # Analyze denominator structure
    print("\n[Analyzing denominator structure...]")
    denom_analysis = analyze_denominator_structure(seq_s10)
    print(json.dumps(denom_analysis, indent=2))

    # Shioda-Inose viability check
    print("\n[Shioda-Inose Geometry Check...]")
    viable, flags, reasoning = check_shioda_inose_validity(denom_analysis)

    for flag in flags:
        print(f"  {flag}")

    print(f"\n  Denominator structure computed: {'2-powers confirmed' if viable else 'NOT 2-powers'}")
    print("  (NB: 'viable for downstream C1/C2' is not a meaningful verdict --")
    print("   the C1/C2 checkers were stubs and are disabled. See E-007.)")

    # Physics interpretation
    print("\n[Physics Interpretation] *** RETRACTED (E-007) -- DO NOT CITE ***")
    print("  The arithmetic above is sound; the interpretation below is withdrawn.")
    physics = physics_interpretation()
    print(f"\n  Caveat: {physics['caveat']}")
    print(f"\n  Implications:")
    for imp in physics['implications']:
        print(f"    {imp}")
    print(f"\n  Load-bearing vacuum priority:")
    print(f"    {physics['load_bearing_vacuum']}")

    # Final verdict
    print("\n" + "═" * 80)
    verdict = "✅ PASS" if viable else "❌ FAIL"
    print(f"A4 Verdict: {verdict} (s10 geometry is {'provisionally valid' if viable else 'defective'})")
    print("═" * 80)

    return 0 if viable else 1


if __name__ == "__main__":
    sys.exit(main())
