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

            # Check if this is a closed goal (marked as CLOSED in docstring)
            if "CLOSED" in docstring:
                status = "closed"
            else:
                status = "open"

            # Extract the primary status line (first line of docstring)
            lines = docstring.split('\n')
            short_desc = lines[0].strip() if lines else ""

            # Try to extract the blocking reason (look for "STATUS:" or "Conclusion:")
            blocking = "Requires formalization of WZ certificate"
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
                "context": "WP S1-02/S1-03 (sequence recurrence proofs)"
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
