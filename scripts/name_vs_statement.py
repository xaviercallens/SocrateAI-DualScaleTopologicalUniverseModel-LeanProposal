#!/usr/bin/env python3
"""
name_vs_statement.py — triage for the "the claim lives in the name" defect.

WHAT IT LOOKS FOR
-----------------
A Lean theorem that is TRUE, compiles, and passes the axiom audit, the statement
lock and the `sorry` grep, while proving less than its name says. The claim lives
in the identifier and the docstring; the statement carries something weaker.

Found this way on 2026-09-21 (all four now fixed or disclosed):

  glue_primitive             was  `IsCoprime (1 : ℤ) N`  — `isCoprime_one_left`
                             renamed; no vector, no basis, no `U`.
  plus_seven_not_orthogonal  tested `fromRows B 0`, which IS `Phi_T`; so it said
                             only `T₇ ≠ 0`, not that the `±` sign matters.
  sym2 (whole file)          four theorems CONSTRAINED it, none IDENTIFIED it.
  theorem2_holds / theorem3_holds   see E-013.

THE ESSENTIAL TRICK
-------------------
Strip docstrings and comments BEFORE asking whether the statement mentions the
name's tokens. Otherwise the docstring supplies the very words being tested for,
and every declaration looks clean — which is precisely how these survive review.

HOW TO READ THE OUTPUT — this is a READING LIST, NOT A VERDICT
--------------------------------------------------------------
* FALSE POSITIVES are the common case and are fine. Lean states properties
  symbolically, so the English word is legitimately absent: `isometry` appears as
  `Mᵀ * G * M = G`, `dvd` as `∣`, `involution` as `M * M = 1`, `symm` as `ᵀ`,
  `mulvec` as `*ᵥ`. On this repo it flags ~208 of 481; most are these.
* FALSE NEGATIVES exist and matter more: a name token appearing SOMEWHERE in the
  statement does NOT prove the claim is carried. This tool cannot establish that
  a declaration is clean. It can only produce a list worth reading.
* The highest-signal flags are missing OBJECT names (`fricke`, `glue`,
  `primitive`), not missing property words — an absent object usually means the
  identification is being made in prose.

BEFORE TRUSTING IT, POSITIVE-CONTROL IT (this repo's policy: negative-control
any PASS). Run it against a commit predating a known defect and confirm the
defect is flagged:

    mkdir -p /tmp/old/Agora/Geometry
    git show bb74acb:Agora/Geometry/MnLattice.lean > /tmp/old/Agora/Geometry/MnLattice.lean
    cd /tmp/old && python3 .../name_vs_statement.py
    # expect: glue_primitive [missing: glue, primitive]

Usage:  python3 scripts/name_vs_statement.py [root=Agora]

Provenance: Generated-by: Claude Opus 5 (Stream 1 session, 2026-09-21) |
Verified-by: positive-controlled against `glue_primitive` and
`plus_seven_not_orthogonal` at their pre-fix commits | Reviewed-by: T0 N
"""
import re
import sys
import json
import pathlib
import collections

# Tokens that carry no claim, so their absence from a statement means nothing.
STOP = set("""of is the and eq to for at in not no iff imp all any mem has from via by with a an
on as it its that this ne le lt ge gt add sub mul div neg zero one two three four five six seven
eight nine ten pos self left right comm assoc apply def thm lemma case aux helper""".split())

DECL = re.compile(r'^(theorem|lemma)\s+([A-Za-z_][A-Za-z0-9_\'.]*)', re.M)


def declarations(path):
    """Yield (name, statement_text) with docstrings and comments REMOVED."""
    src = path.read_text()
    src = re.sub(r'/-.*?-/', '', src, flags=re.S)   # block comments + docstrings
    src = re.sub(r'--[^\n]*', '', src)              # line comments
    for m in DECL.finditer(src):
        rest = src[m.end():]
        depth, end, i = 0, len(rest), 0
        while i < len(rest):
            ch = rest[i]
            if ch in '([{':
                depth += 1
            elif ch in ')]}':
                depth -= 1
            elif depth == 0 and rest.startswith(':=', i):
                end = i
                break
            elif depth == 0 and rest.startswith('\n', i) and \
                    re.match(r'\n\s*(theorem|lemma|def|end|namespace)\b', rest[i:]):
                end = i
                break
            i += 1
        yield m.group(2), rest[:end]


def main(root='Agora'):
    rows, total = [], 0
    for p in sorted(pathlib.Path(root).rglob('*.lean')):
        for name, stmt in declarations(p):
            total += 1
            low = stmt.lower()
            toks = [t for t in re.split(r"[_']+", name)
                    if t and t.lower() not in STOP and len(t) > 2]
            missing = [t for t in toks if t.lower() not in low]
            if missing:
                rows.append({'file': str(p), 'name': name, 'missing': missing,
                             'stmt': ' '.join(stmt.split())[:220]})

    print(json.dumps(rows, indent=1))
    c = collections.Counter(t.lower() for r in rows for t in r['missing'])
    print(f"\n{len(rows)} of {total} declarations flagged FOR READING "
          f"(not defects — see module docstring).", file=sys.stderr)
    print("most common missing tokens: " +
          ', '.join(f'{t}×{n}' for t, n in c.most_common(12)), file=sys.stderr)


if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else 'Agora')
