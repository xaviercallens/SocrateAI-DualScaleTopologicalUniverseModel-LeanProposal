#!/usr/bin/env python3
"""
disclosure_reaches_source.py — does the criticism reach the declaration?

A disclosure can be correct, detailed, and still fail, by living in a README, a
memo, an escalation or a paper section rather than in the docstring. It then does
not travel with the declaration into generated catalogues, importing projects,
retrieval systems, or the eyes of anyone reading the source.

  *A disclosure belongs on the declaration, not only in the prose that discusses
  it.* Prose is read by whoever reads that prose; a docstring is read by everyone
  who meets the theorem.

This asks a question neither the build, the `sorry` grep, the axiom audit nor the
statement lock can ask, and that `name_vs_statement.py` also cannot: not "does the
statement match the name" but "does the criticism reach whoever meets the
declaration".

FOUND THIS WAY (2026-09-21)
---------------------------
  master_moduli_stabilization  docstring claimed "In the perturbative regime
                               (S_{1,2} ≤ 1.177)"; the conjunct is a bare
                               `∃ s, perturbative_regime s` off a vacuous axiom.
                               Disclosed in README.md and AXIOMS.md, not here.
  review item A1               filed 2026-07-26 against the encoding under this
                               repo's headline result, never answered, tracked
                               nowhere. An unanswered review item leaves NO trace
                               in any gate — not a `sorry`, not an axiom, not a
                               failing build — so it reads as done because
                               nothing says otherwise.

LIMITATIONS — read these before believing an empty report
---------------------------------------------------------
1. **It cannot confirm a disclosure exists, only that its VOCABULARY appears.**
   A correct in-place disclosure phrased outside the keyword list is reported as
   missing (a false positive on the *fix*), and — worse — a docstring that merely
   uses the words looks disclosed. Convention adopted here in response, from the
   LeanMaster session: every in-place disclosure opens with the literal word
   **`Disclosure`**, so the audit and the reader look for the same token.
   `--token` checks for that instead of the keyword list.
2. **Homonyms.** Binding a base name to the first file that matches produces
   false positives when several declarations share a name and only one is
   disclosed. This tool keeps ALL homonyms and flags only when NONE carries the
   language.
3. **Modifier prefixes.** `noncomputable def`, `private theorem`, `@[simp]` —
   an anchored `^(theorem|def)` regex silently skips them and reports them clean.
   That bug was live here and hid 41 of 465 declarations, `cooperC3` among them.
4. **Read the sentence; never trust the match.** Prose that *describes* a
   declaration, or criticises a past ruling about it, or cites it as the FIX for
   someone else's defect, matches every keyword. In this repo 4 of 5 flags were
   that. LeanMaster's twin: a book citing a guard that is explicitly NOT vacuous.

Usage:
    python3 scripts/disclosure_reaches_source.py            # critique vocabulary
    python3 scripts/disclosure_reaches_source.py --token    # literal `Disclosure`

Provenance: Generated-by: Claude Opus 5 (Stream 1 session, 2026-09-21) |
Verified-by: self-tested against this session's own in-place disclosures, which
is how limitations 1 and 3 were found | Reviewed-by: T0 N
"""
import re
import sys
import pathlib

CRIT = re.compile(
    r'vacuou|vacuit|overstat|overclaim|stale|retract|misleading|claims more|disclos|'
    r'not a theorem|not proved|not checked|not formalized|does not (prove|establish|say|carry)|'
    r'carries no|content-free|placeholder|is not what|weaker than|wrong|false', re.I)
TOKEN = re.compile(r'\bdisclosure\b', re.I)

DECL = re.compile(
    r'^(?:@\[[^\]]*\]\s*)*(?:noncomputable\s+|private\s+|protected\s+|partial\s+)*'
    r'(theorem|lemma|def|axiom|abbrev|structure)\s+([A-Za-z_][A-Za-z0-9_\']*)', re.M)

PROSE = ('README.md', 'AXIOMS.md', 'VISION.md', 'CLAUDE.md',
         'briefs/*.md', 'paper/sections/*.tex', 'docs/*.md')


def source_docstrings(root='Agora'):
    """name -> [(file, docstring), ...]  keeping ALL homonyms."""
    out = {}
    for p in pathlib.Path(root).rglob('*.lean'):
        text = p.read_text(errors='ignore')
        for m in DECL.finditer(text):
            head = text[:m.start()]
            ds = list(re.finditer(r'/--.*?-/', head, re.S))
            doc = ds[-1].group(0) if ds and len(head[ds[-1].end():].strip()) < 60 else ''
            out.setdefault(m.group(2), []).append((p.name, doc))
    return out


def main(use_token=False):
    probe = TOKEN if use_token else CRIT
    docs = source_docstrings()
    criticised = {}
    for pat in PROSE:
        for f in pathlib.Path('.').glob(pat):
            for line in f.read_text(errors='ignore').splitlines():
                if CRIT.search(line):
                    for ident in re.findall(r'`([A-Za-z_][A-Za-z0-9_]{4,})`', line):
                        criticised.setdefault(ident, (set(), line.strip()))[0].add(f.name)

    unlanded = []
    for ident, (files, line) in sorted(criticised.items()):
        here = docs.get(ident)
        if here and not any(probe.search(doc) for _, doc in here):   # homonym-aware
            unlanded.append((ident, [f for f, _ in here], sorted(files), line[:130]))

    print(f"{len(criticised)} identifiers criticised in prose; "
          f"{len(unlanded)} whose declaration carries no "
          f"{'`Disclosure` token' if use_token else 'critique vocabulary'}:\n")
    for ident, where, files, line in unlanded:
        print(f"  {ident}  ({', '.join(where)})   prose: {', '.join(files)}")
        print(f"      > {line}\n")
    print("READ EACH SENTENCE. Most flags are prose describing, not criticising "
          "(4 of 5 here). An empty report is not a clean bill — see LIMITATIONS.")


if __name__ == '__main__':
    main('--token' in sys.argv)
