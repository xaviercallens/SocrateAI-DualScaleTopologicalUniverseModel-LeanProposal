#!/usr/bin/env python3
"""
export_pipeline_artifact.py
═══════════════════════════════════════════════════════════════════════════

Stream 2 → Stream 1 data bridge (decision D3 / escalation E-005).

Converts a floating-point pipeline statistic (the S₁,₂ upper bound) into an
EXACT-RATIONAL, CRYPTOGRAPHICALLY-HASHED, self-verifying JSON artifact that the
Lean kernel can later ingest without ever touching a float.

WHAT THIS DOES AND DOES NOT DO (read before citing anywhere):
  • This script EMITS the "static, cryptographically hashed exact-rational data
    artifact from Stream 2" that D3 (briefs/ESCALATIONS.md E-005) is *awaiting*.
    Producing it is the precondition D3 named — nothing more.
  • It does NOT discharge the `pipeline_upper_bound` axiom. Per D3 the axiom
    stays an explicit, `[DISCLOSED-VACUOUS]`-tagged axiom (RETAIN AXIOMATIC
    FIREWALL). Discharge = a *later*, separately-gated Lean WP that imports this
    artifact and restates the bound about it. This tool touches no .lean file.
  • The default value 1.177 is the E-005 placeholder float. Until a genuine
    certified Stream 2/3 run supplies its provenance, the artifact is stamped
    `epistemic_status = "PLACEHOLDER-VACUOUS"` — it must NOT be read as a
    certified pipeline result. Supply `--certified-source`/`--run-id` only when
    a real, reproducible run backs the number (D3: forging a certified-looking
    artifact to shed the axiom tag is the exact epistemic vulnerability to avoid).

Exact-rational conversion: `Fraction(str(x)).limit_denominator(...)`. Passing the
value THROUGH `str()` avoids binary float error (str(1.177) == "1.177" → 1177/1000
exactly), and the denominator cap keeps the rational bounded. Prefer passing the
value as a decimal STRING to remove float ambiguity entirely.

Determinism: the sha256 is computed over the canonical JSON of the *payload*
(sorted keys, compact separators, the checksum field excluded), so identical
inputs ⇒ bit-identical hash. `--verify` recomputes and confirms; a tampered file
fails the check. This is what makes the artifact a trustworthy import target.

Usage:
  python3 scripts/export_pipeline_artifact.py                 # emit placeholder (1.177)
  python3 scripts/export_pipeline_artifact.py --value 1.177
  python3 scripts/export_pipeline_artifact.py --value 1.177 \
      --certified-source "Stream2 V4C run" --run-id <sha>     # certified emission
  python3 scripts/export_pipeline_artifact.py --verify        # self-check an existing artifact

Output: data/pipeline_artifact.json
"""

import argparse
import datetime
import hashlib
import json
import sys
from fractions import Fraction
from pathlib import Path

SCHEMA_VERSION = "1.0"
CHECKSUM_ALGORITHM = "sha256"
DEFAULT_OUTPUT = "data/pipeline_artifact.json"
DEFAULT_MAX_DENOMINATOR = 1_000_000


def _canonical_bytes(payload: dict) -> bytes:
    """Deterministic serialization of the hashed payload (checksum field excluded)."""
    return json.dumps(payload, sort_keys=True, separators=(",", ":")).encode("utf-8")


def compute_checksum(payload: dict) -> str:
    return hashlib.sha256(_canonical_bytes(payload)).hexdigest()


def build_artifact(
    value,
    metric: str = "S12_max_upper_bound",
    max_denominator: int = DEFAULT_MAX_DENOMINATOR,
    certified_source: str | None = None,
    run_id: str | None = None,
) -> dict:
    """Build the full, checksummed artifact dict from an observed statistic."""
    # Exact rational conversion. `str()` first so a float literal like 1.177 becomes
    # the decimal 1177/1000, not its binary-float neighbour.
    frac = Fraction(str(value)).limit_denominator(max_denominator)
    if frac <= 0:
        raise ValueError(f"pipeline statistic must be > 0 (matches axiom S12_max > 0); got {frac}")

    certified = certified_source is not None and run_id is not None
    epistemic_status = "CERTIFIED" if certified else "PLACEHOLDER-VACUOUS"

    # `payload` is exactly the bytes the checksum covers — everything content-bearing.
    payload = {
        "schema_version": SCHEMA_VERSION,
        "metric": metric,
        # Exact rational — the ONLY numeric fields Lean should read.
        "num": frac.numerator,
        "den": frac.denominator,
        "string_val": f"{frac.numerator}/{frac.denominator}",
        # Retained only for human diffing; NOT for kernel ingestion.
        "decimal_approx": float(frac),
        "epistemic_status": epistemic_status,
        "provenance": {
            "source": certified_source or "PLACEHOLDER (E-005 float 1.177, no certified run)",
            "run_id": run_id or "NONE",
            "generated_utc": datetime.datetime.now(datetime.timezone.utc)
            .replace(microsecond=0)
            .isoformat(),
        },
    }

    artifact = dict(payload)
    artifact["checksum_algorithm"] = CHECKSUM_ALGORITHM
    artifact["checksum"] = compute_checksum(payload)
    return artifact


def verify_artifact(path: Path) -> tuple[bool, str]:
    """Recompute the checksum over the artifact's payload and compare to the stored value."""
    artifact = json.loads(path.read_text())
    stored = artifact.get("checksum")
    if not stored:
        return False, "no checksum field present"
    payload = {k: v for k, v in artifact.items() if k not in ("checksum", "checksum_algorithm")}
    recomputed = compute_checksum(payload)
    if recomputed == stored:
        return True, recomputed
    return False, f"MISMATCH: stored={stored} recomputed={recomputed}"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--value", default="1.177", help="observed pipeline statistic (decimal string preferred). Default: E-005 placeholder 1.177")
    parser.add_argument("--metric", default="S12_max_upper_bound")
    parser.add_argument("--output", default=DEFAULT_OUTPUT)
    parser.add_argument("--max-denominator", type=int, default=DEFAULT_MAX_DENOMINATOR)
    parser.add_argument("--certified-source", default=None, help="human-readable source of a genuine certified run (omit for placeholder)")
    parser.add_argument("--run-id", default=None, help="reproducible run identifier / hash (omit for placeholder)")
    parser.add_argument("--verify", action="store_true", help="verify an existing artifact's checksum instead of writing")
    args = parser.parse_args()

    repo_root = Path(__file__).parent.parent
    output_path = (repo_root / args.output) if not Path(args.output).is_absolute() else Path(args.output)

    if args.verify:
        if not output_path.exists():
            print(f"✗ no artifact to verify at {output_path}", file=sys.stderr)
            return 1
        ok, detail = verify_artifact(output_path)
        if ok:
            print(f"✅ checksum OK ({CHECKSUM_ALGORITHM}): {detail}")
            return 0
        print(f"✗ checksum verification FAILED: {detail}", file=sys.stderr)
        return 1

    artifact = build_artifact(
        args.value,
        metric=args.metric,
        max_denominator=args.max_denominator,
        certified_source=args.certified_source,
        run_id=args.run_id,
    )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w") as f:
        json.dump(artifact, f, indent=2)
        f.write("\n")

    rel = output_path.relative_to(repo_root) if output_path.is_relative_to(repo_root) else output_path
    print(f"✅ wrote exact-rational bridge → {rel}")
    print(f"   metric        : {artifact['metric']}")
    print(f"   exact value   : {artifact['string_val']}  (≈ {artifact['decimal_approx']})")
    print(f"   status        : {artifact['epistemic_status']}")
    print(f"   {CHECKSUM_ALGORITHM}        : {artifact['checksum']}")
    if artifact["epistemic_status"] == "PLACEHOLDER-VACUOUS":
        print("   ⚠  PLACEHOLDER — does NOT discharge `pipeline_upper_bound` (D3: axiom firewall retained).")
    return 0


if __name__ == "__main__":
    sys.exit(main())

# Generated-by: Opus 4.8 (executor) | Verified-by: self-verify mode (--verify recomputes sha256) |
# Reviewed-by: T0 N (produced under directive D3 2026-07-24; Lean-side discharge separately gated)
