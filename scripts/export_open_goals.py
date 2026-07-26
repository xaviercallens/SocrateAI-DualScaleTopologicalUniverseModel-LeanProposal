#!/usr/bin/env python3
"""
export_open_goals.py
═══════════════════════════════════════════════════════════════════════════

Extracts named open goals from OpenGoals/*.lean files and writes open_goals.json
for Stream 2 consumption.

Usage: python3 scripts/export_open_goals.py

Output: open_goals.json in the repo root
"""

import json
import re
import sys
from pathlib import Path

# Which work package each OpenGoals file belongs to. Keyed by filename so a new
# goal file shows up as explicitly unmapped rather than silently inheriting
# whichever WP happened to be hardcoded here (Stream 2 consumes this field).
WP_CONTEXT = {
    "CooperRecurrences.lean": "WP S1-02/S1-03 (sequence recurrence proofs)",
    "PartnerIntegrality.lean": "WP S1-11/S1-12 (order-2 partner arithmetic)",
}


def extract_goals(opengoals_dir: Path) -> list[dict]:
    """
    Parse OpenGoals/*.lean files and extract theorem definitions with docstrings.
    Returns a list of dicts with keys: name, description, statement, status, context.
    """
    goals = []

    for lean_file in opengoals_dir.glob("*.lean"):
        content = lean_file.read_text()

        # Find all theorems with preceding /-- ... -/ docstrings
        # Match: /-- ... -/ followed (possibly with whitespace) by theorem name : statement := by sorry
        pattern = r'/--\s*(.*?)\s*-/\s*theorem\s+(\w+)\s*:\s*((?:(?!:=).)*)\s*:=\s*by'
        matches = re.finditer(pattern, content, re.DOTALL)

        for match in matches:
            docstring = match.group(1).strip()
            name = match.group(2)
            statement = match.group(3).strip()
            # Normalize statement (remove extra whitespace but keep structure)
            statement = ' '.join(statement.split())

            # Status is derived from the PROOF BODY, not the docstring: a goal
            # is open iff its proof still contains `sorry`. The previous
            # heuristic (substring "CLOSED" in the docstring) misclassified a
            # goal whose docstring merely DISCUSSED closure ("CONSEQUENCE IF
            # CLOSED: ..."), and docstrings have lied in this repo before.
            # Stream 2 consumes this field; it must track the kernel.
            # Cut at the next declaration OR its docstring, whichever comes
            # first, then strip comments: prose in this repo legitimately
            # contains the word "sorry" ("no sorry", "0 sorry"), and only the
            # bare token in actual proof code means the goal is open.
            cut_points = [i for i in (content.find("theorem ", match.end()),
                                      content.find("/--", match.end())) if i != -1]
            proof_body = content[match.end(): min(cut_points) if cut_points else len(content)]
            proof_code = re.sub(r"--.*", "", proof_body)          # line comments
            proof_code = re.sub(r"/-.*?-/", "", proof_code, flags=re.DOTALL)  # block comments
            status = "open" if re.search(r"\bsorry\b", proof_code) else "closed"
            if status == "open" and "CLOSED" in docstring.split("\n")[0]:
                print(f"  WARNING: {name} docstring header says CLOSED but proof "
                      f"contains sorry — reporting open (kernel wins)", file=sys.stderr)

            # Extract the primary status line (first line of docstring)
            lines = docstring.split('\n')
            short_desc = lines[0].strip() if lines else ""

            # Try to extract the blocking reason (look for "STATUS:" or "Conclusion:")
            # Default is deliberately non-committal: inventing a blocker for a goal
            # whose docstring does not state one is how wrong status propagates to
            # Stream 2, which consumes this file.
            blocking = "not stated in docstring — add a STATUS: line"
            if "STATUS:" in docstring:
                status_match = re.search(r'STATUS:\s*(.+?)(?:\n|$)', docstring)
                if status_match:
                    blocking = status_match.group(1).strip()

            goals.append({
                "name": name,
                "description": short_desc,
                "full_docstring": docstring,
                "statement": statement,
                "status": status,
                "file": lean_file.name,
                "blocking": blocking,
                "context": WP_CONTEXT.get(
                    lean_file.name, f"unmapped OpenGoals file {lean_file.name} — "
                                    "add it to WP_CONTEXT in scripts/export_open_goals.py")
            })

    return goals

def main():
    repo_root = Path(__file__).parent.parent
    opengoals_dir = repo_root / "OpenGoals"

    if not opengoals_dir.exists():
        print(f"Error: OpenGoals directory not found at {opengoals_dir}", file=sys.stderr)
        sys.exit(1)

    goals = extract_goals(opengoals_dir)

    # Write JSON output
    output_file = repo_root / "open_goals.json"
    with open(output_file, 'w') as f:
        json.dump(goals, f, indent=2)

    print(f"Exported {len(goals)} open goals to {output_file}")
    for goal in goals:
        status_marker = "✓" if goal["status"] == "closed" else "✗"
        print(f"  {status_marker} {goal['name']} ({goal['status']})")

if __name__ == "__main__":
    main()
