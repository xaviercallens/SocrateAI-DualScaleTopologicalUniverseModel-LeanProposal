#!/usr/bin/env bash
# release_gates.sh — the pre-release checklist for Stream 1.
#
# There is no CI in this repository (CLAUDE.md rule 3). This script is the gate,
# and it is run by a human before tagging. It exists because of 2026-09-21: nine
# defects were found that day and NOT ONE was produced by any gate.
#
# ─────────────────────────────────────────────────────────────────────────────
# READ THIS BEFORE TRUSTING A GREEN RUN
#
#  * Every command is run UNPIPED and its own exit code is captured. A pipe
#    hands you the filter's status, not the tool's: `lake build NoSuchTarget |
#    grep "Build completed"` exits 0 while lake itself exits 1. Verified.
#  * `axiom_audit.py` EXITS 1 PERMANENTLY here — it fails on any non-standard
#    axiom including the registered, disclosed ones, and the steady state is
#    three. So it is compared against EXPECTED_FAILING below, never against
#    zero. A gate that can never go green is a signal engineered to be ignored;
#    if you add or discharge a registered axiom, change that number deliberately.
#  * A `sorry` does NOT fail the build (exit 0, warning only). The audit is what
#    catches it, via `sorryAx`. Do not read a green build as a no-sorry result.
#  * The two audit scripts are READING LISTS, not verdicts. They cannot establish
#    that a declaration is clean. Their `--self-test` must pass first; a tool that
#    cannot see a declaration reports it as clean.
# ─────────────────────────────────────────────────────────────────────────────

set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

EXPECTED_FAILING=3   # pipeline_ensures_perturbative, lvs_potential_positivity_and_placeholder,
                     # legacy s7_partner_integral — all registered in AXIOMS.md and disclosed.
LM="${LM:-$HOME/SocrateAI-Scientific-Agora-LeanMaster}"
log=$(mktemp -d)/gates.log
rc=0
step() { printf '\n── %s\n' "$1"; }
bad()  { printf '   FAIL: %s\n' "$1"; rc=1; }

step "1. self-tests (a tool that cannot see a declaration reports it clean)"
python3 scripts/name_vs_statement.py --self-test      || bad "name_vs_statement self-test"
python3 scripts/disclosure_reaches_source.py --self-test || bad "disclosure_reaches_source self-test"

step "2. build — named targets (a bare \`lake build\` builds NOTHING and exits 0)"
lake build Agora OpenGoals Tests > "$log" 2>&1
[ $? -eq 0 ] || bad "lake build exited non-zero"
tail -1 "$log"

step "3. sorry — via the audit, NOT via the build"
if grep -q 'declaration uses' "$log"; then   # NB: Lean uses BACKTICKS around sorry
    bad "build log contains a 'declaration uses \`sorry\`' warning"
else
    echo "   no sorry warning in the build log"
fi

step "4. axiom audit — compared against EXPECTED_FAILING=$EXPECTED_FAILING, not against 0"
LEAN_PROJECT_ROOT=$PWD python3 "$LM/tools/axiom_audit.py" Agora > "$log.aa" 2>&1
n=$(sed -n 's/.*audited, \([0-9]*\) failing.*/\1/p' "$log.aa" | tail -1)
tail -1 "$log.aa"
if [ "${n:-x}" != "$EXPECTED_FAILING" ]; then
    bad "axiom audit reports ${n:-?} failing, expected $EXPECTED_FAILING — read WHICH ones changed"
else
    echo "   the $EXPECTED_FAILING expected failures, unchanged"
fi

step "5. statement lock"
LEAN_PROJECT_ROOT=$PWD python3 "$LM/tools/statement_lock.py" --check \
    $(find Agora OpenGoals Tests -name '*.lean') > "$log.sl" 2>&1
[ $? -eq 0 ] || bad "statement lock reports a CHANGED entry — review it, then --update with a reason"
tail -1 "$log.sl"

step "6. open goals export (generated files go stale silently)"
python3 scripts/export_open_goals.py > /dev/null 2>&1 || bad "export_open_goals failed"
git diff --quiet open_goals.json || bad "open_goals.json was stale — it is now regenerated, commit it"

step "7. audits — read the NEW flags since the last release, not the whole list"
echo "   python3 scripts/name_vs_statement.py | ..."
echo "   python3 scripts/disclosure_reaches_source.py"
echo "   (226 of 333 flags are expected and mostly benign; compare against last release)"

printf '\n══ %s ══\n' "$([ $rc -eq 0 ] && echo 'ALL GATES OK — and a green run is not a clean bill; see the header' || echo 'GATES FAILED')"
exit $rc
