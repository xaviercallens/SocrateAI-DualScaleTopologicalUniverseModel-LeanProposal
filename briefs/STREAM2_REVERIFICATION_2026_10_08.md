# Stream 2 → Stream 1 — release gates re-run on `main` @ be2abb2 (2026-10-08), and what this branch changes

**Who and why.** Run by the Stream 2 session (Claude Opus 5.5) on T0's instruction of 2026-10-08: *"complete the work and
communicate to others streams and publish the stream 1, stream 2 and stream 3 results as tex and pdf. commit, push, merge and
release"*. Producer ≠ verifier: this session wrote none of the Lean code checked here.

## Gate run: `K3DM=<K3-DarkMatter clone> bash scripts/release_gates.sh` in the main checkout, at be2abb2

| Gate | Result |
|---|---|
| 0. K3_CRITERIA.md mirror pin | **FAIL: PIN STALE.** The mirror matched its pin (7af500a7…), but the canonical file at K3-DarkMatter `origin/main` hashed 50907eb5…. |
| 1. self-tests (name_vs_statement, disclosure_reaches_source) | ok, ok |
| 2. `lake build Agora OpenGoals Tests` | `Build completed successfully (3730 jobs).` |
| 3. sorry | no `declaration uses sorry` warning in the build log. Per `LL.md` §3.2 the build cannot fail on a `sorry`; sorry-freedom rests on gate 4, where `sorryAx` would be counted. |
| 4. axiom audit (expected 3 failing) | `421 theorems audited, 3 failing`, the 3 registered axioms, unchanged |
| 5. statement lock | `statement lock: OK` |
| 6. quarantine boundary | no core module imports `Agora/Unverified/` |
| 7. open goals export | `open_goals.json` unchanged (`git status` clean afterwards) |
| 8. audits | reading lists only; not compared against the last release in this run |

**Reading this table honestly.** A green gate is not a clean bill (header of `release_gates.sh`; `LL.md` §1). The run confirms that
the version-4 formal development still builds and audits as recorded at be2abb2. It adds no new verification of any statement's
*meaning*.

## What this branch (`worktree-paper-v5-2026-10-08`) changes

1. **Mirror re-pin.** `K3_CRITERIA.md` is now a byte-for-byte copy of the canonical file at K3-DarkMatter `5fe0f98` (sha256 50907eb5…),
   and `K3_CRITERIA.mirror.json` is updated, with the old pin kept under `previous_pins`. The canonical file moved only in its
   generated section 5, at 268dd18 and ac86c26; no criterion text was amended. After the re-pin,
   `python3 checkers/check_k3_criteria_mirror.py --source <K3-DarkMatter>` reports `MIRROR OK` and `PIN CURRENT`.
2. **Paper revision of 2026-10-08.** `paper/sections/12-developments-2026-10-08.tex` is a dated addendum, plus a short revision note in
   the abstract and the rebuilt `paper/main.pdf`. Sections 1–11 (version 4, Zenodo 10.5281/zenodo.23030319) are unchanged. The
   addendum records companion results with their status. It does **not** close the rescaling gap of the conjecture, and it adds no
   kernel-checked statement.
3. **Not done here.** No `.lean` file was touched; no toolchain or dependency change; no `lake update`. Nothing was uploaded to Zenodo:
   a version 5 deposit is T0's step (`scripts/publish_to_zenodo.py`).

## Still open for Stream 1's own sessions

The TW2 lattice-attestation request of 2026-10-07 (`briefs/STREAM2_TO_STREAM1_TW2_LATTICE_ATTESTATION_REQUEST_2026_10_07.md`) is
unanswered. A kernel proof written by the requesting stream would not be independent, so it was not attempted here.

## Release rule applied (LL.md §3.14)

The run above is **red** at gate 0, so it is not the run a release may cite. No tag is made on it. After this branch is merged, the
gates are re-run in full on the merged `main`, and the tag is made only on `ALL GATES OK`. That run is recorded below.

## Gate run 2: on the merged `main` (filled in after merge)

*(pending)*

*Generated-by: Claude (Opus 5.5), Stream 2 | Verified-by: the gate output quoted above, which is the excerpt of record (the raw log
was not committed), and the mirror checker re-run | Reviewed-by: N*
