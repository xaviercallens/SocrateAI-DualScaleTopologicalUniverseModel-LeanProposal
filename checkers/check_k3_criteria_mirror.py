#!/usr/bin/env python3
"""check_k3_criteria_mirror.py — fail-closed drift detector for the K3_CRITERIA.md MIRROR.

K3_CRITERIA.md in this repository is a hash-pinned mirror of the canonical file in
SocrateAI-Scientific-Agora-K3-DarkMatter (T0 D8'/AM-5, 2026-09-21). The pin lives in
K3_CRITERIA.mirror.json. This script:

  * recomputes sha256(K3_CRITERIA.md) and compares it with the pin           -> exit 1 on mismatch
  * optionally (--source <path-to-K3-DarkMatter-clone>) compares the pin with
    `git show origin/main:K3_CRITERIA.md` there, so an upstream re-render is
    reported as PIN_STALE rather than silently trusted                         -> exit 1 if stale
  * --self-test mutates a copy of the mirror by one byte and checks that the
    comparison FAILS, and checks that an unmodified copy PASSES. A checker that
    has never been seen red is a checker being trusted, not run (LL.md §3.4).

Exit codes: 0 = mirror matches pin (and, with --source, pin matches upstream);
            1 = drift / stale / self-test failure; 2 = usage or missing file.

This checks BYTES. It cannot tell you whether the canonical text is correct, whether
its thresholds are frozen (they are not: SKELETON, section 7 open), or whether a
certificate it cites is LIVE. Read the file for that.
"""
import argparse
import hashlib
import json
import os
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MIRROR = os.path.join(ROOT, "K3_CRITERIA.md")
PIN = os.path.join(ROOT, "K3_CRITERIA.mirror.json")


def sha256_file(path: str) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def compare(mirror_path: str, pinned: str) -> bool:
    return sha256_file(mirror_path) == pinned


def upstream_hash(source_repo: str, ref: str = "origin/main") -> str:
    out = subprocess.run(
        ["git", "-C", source_repo, "show", f"{ref}:K3_CRITERIA.md"],
        check=True, capture_output=True,
    ).stdout
    return hashlib.sha256(out).hexdigest()


def self_test() -> int:
    if not (os.path.exists(MIRROR) and os.path.exists(PIN)):
        print("SELF-TEST: mirror or pin file missing", file=sys.stderr)
        return 2
    pinned = json.load(open(PIN))["sha256"]
    with tempfile.TemporaryDirectory() as d:
        clean = os.path.join(d, "clean.md")
        mutated = os.path.join(d, "mutated.md")
        data = open(MIRROR, "rb").read()
        open(clean, "wb").write(data)
        # flip one byte in the middle of the file
        mid = len(data) // 2
        open(mutated, "wb").write(data[:mid] + bytes([data[mid] ^ 0x01]) + data[mid + 1:])
        ok_clean = compare(clean, pinned)
        ok_mutated = compare(mutated, pinned)
    print(f"SELF-TEST: unmodified copy matches pin: {ok_clean}")
    print(f"SELF-TEST: one-byte mutation is REJECTED: {not ok_mutated}")
    if ok_clean and not ok_mutated:
        print("SELF-TEST PASS (the checker fires in both directions)")
        return 0
    print("SELF-TEST FAIL", file=sys.stderr)
    return 1


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--self-test", action="store_true")
    ap.add_argument("--source", help="path to a K3-DarkMatter clone; compares the pin with origin/main there")
    ap.add_argument("--ref", default="origin/main")
    a = ap.parse_args()
    if a.self_test:
        return self_test()
    if not os.path.exists(PIN):
        print(f"missing {PIN}", file=sys.stderr)
        return 2
    if not os.path.exists(MIRROR):
        print(f"missing {MIRROR}", file=sys.stderr)
        return 2
    pin = json.load(open(PIN))
    pinned = pin["sha256"]
    actual = sha256_file(MIRROR)
    rc = 0
    if actual == pinned:
        print(f"MIRROR OK      K3_CRITERIA.md sha256 {actual[:16]}… matches K3_CRITERIA.mirror.json")
    else:
        print(f"MIRROR DRIFT   K3_CRITERIA.md sha256 {actual}\n               pin              {pinned}")
        print("               The mirror was edited locally or re-pinned without updating the pin file. Do not fix by editing the pin: re-copy from the canonical repo.")
        rc = 1
    if a.source:
        try:
            up = upstream_hash(a.source, a.ref)
        except Exception as e:  # noqa: BLE001
            print(f"UPSTREAM ?     could not read {a.ref}:K3_CRITERIA.md in {a.source}: {e}")
            return max(rc, 1)
        if up == pinned:
            print(f"PIN CURRENT    {a.ref} in {os.path.basename(a.source)} has the pinned hash")
        else:
            print(f"PIN STALE      {a.ref} K3_CRITERIA.md sha256 {up}\n               pin                         {pinned}")
            print("               The canonical file moved (section 5 is generated). Re-pin: copy it byte-for-byte, update the pin file, record the upstream commit.")
            rc = 1
    return rc


if __name__ == "__main__":
    sys.exit(main())
