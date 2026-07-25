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
            missing = [k for k in spec["keywords"] if k.lower() not in head.lower()]
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

    failures = check_a6() + check_a5()

    print("\n" + "=" * 78)
    if failures:
        print(f"  A5/A6 Verdict: FAIL  ({len(failures)} problem(s): {failures})")
        print("=" * 78)
        return 1
    print("  A5/A6 Verdict: PASS")
    print("  Scope: hashes + document identity + the 3 Cooper parameter sets.")
    print("  NOT checked: OEIS cross-reference; Zagier/AZ parameter sets (removed).")
    print("  Do NOT cite this as '15 sporadic sequences verified'.")
    print("=" * 78)
    return 0


if __name__ == "__main__":
    sys.exit(main())
