#!/usr/bin/env bash
# PostToolUse guard for Edit|Write on .lean files. Reads hook JSON on stdin.
set -euo pipefail
payload=$(cat)
file=$(echo "$payload" | jq -r '.tool_input.file_path // empty')
[ -z "$file" ] && exit 0
case "$file" in *.lean) ;; *) exit 0 ;; esac

# Rule 1: axiom quarantine — new axiom declarations only under Axioms/
if grep -qE '^\s*axiom\s' "$file" 2>/dev/null; then
  case "$file" in
    */Axioms/*|Axioms/*) : ;;
    *) echo "BLOCKED by lean_guard: 'axiom' outside Axioms/ (CLAUDE.md rule 2). Move it to Axioms/ with a docstring and register it in AXIOMS.md." >&2
       exit 2 ;;
  esac
fi

# Rule 2: sorry outside OpenGoals/ — advisory (branches OK; main blocked by CI)
if grep -qE '\bsorry\b' "$file" 2>/dev/null; then
  case "$file" in
    */OpenGoals/*|OpenGoals/*) : ;;
    *) echo "lean_guard notice: 'sorry' in $file — branch-only. Convert to a named open goal in OpenGoals/ before merge (lean-proof-workflow skill)." >&2 ;;
  esac
fi
exit 0
