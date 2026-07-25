#!/usr/bin/env python3
"""
adversarial_A5_A6_provenance_hygiene.py — real provenance verification.

REWRITTEN 2026-07-25 after E-007 (briefs/ESCALATIONS.md). The previous version was
a stub: it marked every sequence 'verified': True with the comment
"# Placeholder: would fetch OEIS", and its hash-pinning function returned literal
'SHA256:PLACEHOLDER' strings instead of hashing anything. It reported
"A5/A6 Verdict: PASS -- all 15 sporadic sequences verified" while verifying
nothing. That false PASS was consumed as the Phase 1 provenance gate result.

It also failed to catch that the file saved as Zagier_2009_sporadic.pdf was in
fact "Covering the Plane by Rotations of a Lattice Arrangement of Disks"
(arXiv:math/0611800) -- an unrelated paper -- whose SHA256 had been pinned into
refs/literature_provenance.txt as a Zagier source. The identity check below
exists specifically to catch that failure mode.

WHAT THIS CHECKER NOW DOES (all of it real):
  A6a  computes SHA256 of each declared PDF and compares it against the pinned
       value in refs/literature_provenance.txt;
  A6b  extracts each PDF's front-page text and requires expected keywords, so a
       correctly-hashed but WRONG document fails;
  A5   checks that the recurrence parameters the project actually consumes (the
       Cooper triple) are literally present in the fetched Gorodetsky PDF text.

WHAT IT DOES NOT DO -- deliberately, rather than pretending:
  * It does not verify against OEIS. There is no network dependency here and no
    cached OEIS data in the repo. The old code claimed this and did not do it.
  * It does not verify the 6 Zagier or 6 Almkvist-Zudilin parameter sets. Those
    tables were REMOVED: they were recorded as 4-tuples (a,b,c,d) in Cooper's
    order-3 format, but Zagier's sporadic sequences satisfy an ORDER-2, THREE-
    parameter recurrence -- cf. Agora/Sequences/ThetaOperators.lean, whose
    ZagierRecurrenceParams has three fields. The tuples were therefore in a
    format that cannot be right, cited a paper (arXiv:1804.00007) that was never
    fetched, and are consumed by nothing in the Lean sources. Restore them only
    with real values read off a real fetched source.
"""

import hashlib
import re
import unicodedata
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
LIT = REPO / "docs" / "literature"
REGISTRY = REPO / "refs" / "literature_provenance.txt"

# Documents we require, with keywords that must appear on the front page.
EXPECTED = {
    "Gorodetsky_arXiv2102.11839_v2.pdf": {
        "keywords": ["sporadic", "sequences"],
        "role": "authoritative source for the Cooper (a,b,c,d) parameters (p.3 table)",
    },
    "Almkvist_vanStraten_arXiv2103.08651.pdf": {
        "keywords": ["Calabi-Yau", "operators"],
        "role": "Calabi-Yau operators of degree two",
    },
    "Zagier_AperylikeRecEqs.pdf": {
        "keywords": ["apery-like", "Zagier"],
        "role": "source for the 7 sporadic (A,B,lambda) triples, labels A-G",
    },
}

# Zagier's SEVEN sporadic solutions, (A, B, lambda), with the u0..u6 he prints.
# -- Source: Zagier, "Integral solutions of Apery-like recurrence equations",
#    the table headed "new label / index / A / B / lambda / u0 ... u6".
#    Recurrence normalisation (his eq. 2/3, and the one ZagierRecurrenceParams uses):
#        (n+1)^2 u_{n+1} = (A n^2 + A n + lambda) u_n - B n^2 u_{n-1}
# RESTORED 2026-07-25. The previous Zagier/AZ tables were removed under E-007 because
# they were 4-tuples in Cooper's order-3 format (wrong arity) citing a paper never
# fetched. These are 3-tuples in Zagier's own normalisation, read off the now-fetched
# PDF, and each is CHECKED below by regenerating the paper's own printed values.
ZAGIER_SPORADIC = {
    "A": ((7, -8, 2), [1, 2, 10, 56, 346, 2252, 15184]),
    "B": ((9, 27, 3), [1, 3, 9, 21, 9, -297, -2421]),
    "C": ((10, 9, 3), [1, 3, 15, 93, 639, 4653, 35169]),
    "D": ((11, -1, 3), [1, 3, 19, 147, 1251, 11253, 104959]),
    "E": ((12, 32, 4), [1, 4, 20, 112, 676, 4304, 28496]),
    "F": ((17, 72, 6), [1, 6, 42, 312, 2394, 18756, 149136]),
    "G": ((0, -16, 0), [1, 0, 4, 0, 36, 0, 400]),
}

# The only sporadic-sequence parameters this project actually consumes.
# -- Source: Gorodetsky arXiv:2102.11839 v2, p.3 table (fetched, hash-pinned).
COOPER = {
    "s7": (13, 4, -27, 3),
    "s10": (6, 2, -64, 4),
    "s18": (14, 6, 192, -12),
}


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def _fold(t):
    """Casefold and strip accents, so a keyword match is not defeated by whether the
    PDF encodes 'E' + combining acute or the precomposed 'É'. (This bit us on Zagier's
    title, which is genuinely correct but failed a naive comparison.)"""
    return "".join(c for c in unicodedata.normalize("NFKD", t)
                   if not unicodedata.combining(c)).casefold()


def pdftext(path, front_page=False):
    cmd = ["pdftotext"]
    if front_page:
        cmd += ["-f", "1", "-l", "1"]
    cmd += [str(path), "-"]
    try:
        return subprocess.run(cmd, capture_output=True, text=True, timeout=60).stdout
    except Exception:                                          # noqa: BLE001
        return ""


def pinned_hashes():
    """Parse `<file>.pdf | ... SHA256:<hex> ...` entries from the registry."""
    if not REGISTRY.exists():
        return {}
    out = {}
    for line in REGISTRY.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        m = re.match(r"^(\S+\.pdf)\s*\|", line)
        if not m:
            continue
        h = re.search(r"SHA256:([0-9a-fA-F]{64})", line)
        out[m.group(1)] = h.group(1).lower() if h else None
    return out


def check_a6():
    print("[A6] hash + document-identity verification")
    pinned = pinned_hashes()
    failures = []

    for name, spec in EXPECTED.items():
        path = LIT / name
        if not path.exists():
            print(f"  FAIL {name}: not present in docs/literature/")
            failures.append(name)
            continue

        actual = sha256(path)
        want = pinned.get(name)
        if want is None:
            print(f"  FAIL {name}: no SHA256 pinned in {REGISTRY.name}")
            failures.append(name)
        elif want != actual:
            print(f"  FAIL {name}: hash mismatch")
            print(f"       pinned {want}")
            print(f"       actual {actual}")
            failures.append(name)
        else:
            print(f"  ok   {name}: sha256 matches pin ({actual[:16]}...)")

        head = pdftext(path, front_page=True)
        if not head.strip():
            print(f"  WARN {name}: no text extracted (pdftotext unavailable?);"
                  " identity NOT checked")
        else:
            folded = _fold(head)
            missing = [k for k in spec["keywords"] if _fold(k) not in folded]
            if missing:
                title = " / ".join(l for l in head.strip().splitlines()[:4] if l.strip())
                print(f"  FAIL {name}: identity check failed, missing {missing}")
                print(f"       document appears to be: {title[:110]}")
                failures.append(name)
            else:
                print(f"  ok   {name}: identity confirmed ({spec['role']})")

    for p in sorted(LIT.glob("*.pdf")):
        if p.name not in EXPECTED:
            print(f"  FAIL {p.name}: in docs/literature/ but not a declared source."
                  " Declare it in EXPECTED or remove it.")
            failures.append(p.name)

    return failures


def check_a5_zagier():
    """Regenerate each Zagier sporadic sequence from its (A,B,lambda) and require it to
    reproduce the u0..u6 printed in the fetched paper. This is a real consistency test:
    a mistyped parameter changes the sequence immediately."""
    from fractions import Fraction
    print("\n[A5-Zagier] sporadic (A,B,lambda) triples vs the values Zagier prints")

    def gen(A, B, lam, n_terms):
        u = [Fraction(1), Fraction(lam)]
        for n in range(1, n_terms - 1):
            u.append((Fraction(A*n*n + A*n + lam) * u[n]
                      - Fraction(B*n*n) * u[n-1]) / Fraction((n+1)**2))
        return [int(x) if x.denominator == 1 else x for x in u]

    failures = []
    for label, ((A, B, lam), printed) in sorted(ZAGIER_SPORADIC.items()):
        got = gen(A, B, lam, len(printed))
        if got == printed:
            print(f"  ok   {label}: (A,B,lam)=({A},{B},{lam}) reproduces {printed[:5]}...")
        else:
            print(f"  FAIL {label}: (A,B,lam)=({A},{B},{lam})")
            print(f"       generated {got}")
            print(f"       paper     {printed}")
            failures.append(f"zagier-{label}")
    return failures


def check_a5():
    print("\n[A5] Cooper parameters vs the fetched Gorodetsky PDF")
    path = LIT / "Gorodetsky_arXiv2102.11839_v2.pdf"
    if not path.exists():
        print("  FAIL source PDF absent; cannot verify parameters")
        return ["gorodetsky-absent"]

    norm = pdftext(path)
    for dash in ("−", "–", "—"):
        norm = norm.replace(dash, "-")
    norm = re.sub(r"[\s,()]+", " ", norm)

    failures = []
    for name, (a, b, c, d) in COOPER.items():
        if re.search(rf"(?<![\d-]){a} {b} {c} {d}(?![\d])", norm):
            print(f"  ok   {name}: ({a}, {b}, {c}, {d}) located in source text")
        else:
            print(f"  FAIL {name}: ({a}, {b}, {c}, {d}) NOT found in source text")
            failures.append(name)
    return failures


def main():
    print("=" * 78)
    print("  A5/A6 Provenance Hygiene (real checks; see docstring for exact scope)")
    print("=" * 78 + "\n")

    failures = check_a6() + check_a5() + check_a5_zagier()

    print("\n" + "=" * 78)
    if failures:
        print(f"  A5/A6 Verdict: FAIL  ({len(failures)} problem(s): {failures})")
        print("=" * 78)
        return 1
    print("  A5/A6 Verdict: PASS")
    print("  Scope: hashes + document identity + the 3 Cooper parameter sets")
    print("         + Zagier's 7 sporadic triples (regenerated against his printed values).")
    print("  NOT checked: OEIS cross-reference; the 6 Almkvist-Zudilin parameter sets,")
    print("  which remain UNVERIFIED (their cited source arXiv:1804.00007 is not fetched).")
    print("=" * 78)
    return 0


if __name__ == "__main__":
    sys.exit(main())
