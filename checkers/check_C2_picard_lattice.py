#!/usr/bin/env python3
"""
check_C2_picard_lattice.py — DISABLED. Picard lattice computation is NOT implemented.

The previous contents of this file were a stub. compute_intersection_matrix_s7/s10
returned a literal [[2,1],[1,2]] regardless of input; both golden tests returned
True unconditionally; and the "reference" values baked into them were themselves
wrong (it asserted a Kummer surface has rho=4 -- Kummer surfaces have rho >= 17 --
and that the Fermat quartic K3 has transcendental discriminant -3, which it does
not). Its output was consumed as a gate result on 2026-07-25 and produced
retracted certificates. See briefs/ESCALATIONS.md E-007.

This file now refuses to run rather than printing a PASS it cannot justify.

IMPORTANT SCOPE CORRECTION (E-007 finding 6). The old code computed with the
singular fibers of L2 and labelled the output "the Picard lattice of the K3".
Those are different objects. L2 is the Picard-Fuchs operator of a family of
ELLIPTIC CURVES; the K3 direction is L3 = Sym^2(L2). Gorodetsky arXiv:2102.11839
states this explicitly on p.2 ("(1.4) is a Picard-Fuchs equation, while (1.3) is
a symmetric square of a Picard-Fuchs equation"). Any future implementation must
first fix which surface it is talking about.

WHAT WOULD BE NEEDED, in order:
  1. Fix the geometry: the K3 family attached to L3 = Sym^2(L2), not to L2.
  2. Obtain its Kodaira fiber data (blocked on check_C1 being implemented).
  3. Apply Shioda-Tate:  rho = 2 + rank(MW) + sum_v (m_v - 1), with m_v the
     number of components of the fiber at v -- this needs the COMPLETE fiber
     list, verified by sum_v e(F_v) = 24, not a partial one.
  4. Determine rank(MW) independently; it is not automatically 0.
  5. Only then compute the transcendental lattice, whose rank is 22 - rho.
     Note a rank-20 transcendental lattice cannot be presented as a 2x2 Gram
     matrix -- the old code reported tau=20 alongside a 2x2 form, which was
     internally inconsistent.
"""

import sys

MSG = __doc__


def main():
    sys.stderr.write(MSG + "\n")
    sys.stderr.write("REFUSING TO REPORT A RESULT. exit 2.\n")
    return 2


if __name__ == "__main__":
    sys.exit(main())
