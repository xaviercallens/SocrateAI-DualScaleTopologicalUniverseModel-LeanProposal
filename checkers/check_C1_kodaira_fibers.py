#!/usr/bin/env python3
"""
check_C1_kodaira_fibers.py — DISABLED. Kodaira classification is NOT implemented.

The previous contents of this file were a stub: every returned value was a
hardcoded literal marked "# Placeholder", and all golden tests returned True
unconditionally, so the checker could not fail. Its output was consumed as a
gate result on 2026-07-25 and produced retracted certificates.
See briefs/ESCALATIONS.md E-007.

This file now refuses to run rather than printing a PASS it cannot justify.

WHAT IS ACTUALLY AVAILABLE: scripts/c1_singular_analysis.py computes, for real,
the singular points and local indicial exponents of the L2 operators, and tests
the Sym^2 relation at series level. Run that instead.

WHAT WOULD BE NEEDED to legitimately classify Kodaira fibers:
  1. Build the Weierstrass model y^2 = x^3 + A(z) x + B(z) of the elliptic
     surface whose period satisfies L2.
  2. Compute the discriminant Delta(z) = 4A^3 + 27B^2 and the j-invariant.
  3. Run Tate's algorithm at each vanishing locus of Delta to read off the
     Kodaira type.
  4. Check sum_v e(F_v) = 12 (rational elliptic) or 24 (K3) as an arithmetic
     consistency test that the classification is complete.
Local exponents alone do NOT determine the Kodaira type, which is why this is
not a small patch on the old code.
"""

import sys

MSG = __doc__


def main():
    sys.stderr.write(MSG + "\n")
    sys.stderr.write(
        "REFUSING TO REPORT A RESULT. exit 2.\n"
        "  Real partial analysis:  python3 scripts/c1_singular_analysis.py\n"
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
