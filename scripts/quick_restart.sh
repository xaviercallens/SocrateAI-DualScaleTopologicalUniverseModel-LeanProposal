#!/usr/bin/env bash
# scripts/quick_restart.sh
# ════════════════════════════════════════════════════════════════════════════
# Quick-restart status dashboard for the Dual-Scale Topological Universe Model
# project. Run this at the start of any new session (human or AI) to get an
# instant, repo-derived picture of what's done and what's next, across all
# three streams. Checks live repo state where cheap to do so — it does not
# just print static text.
#
# Usage: bash scripts/quick_restart.sh          # status only (fast, no build)
#        bash scripts/quick_restart.sh --build   # also runs `lake build Agora`
# ════════════════════════════════════════════════════════════════════════════

set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
REPO_ROOT="$(pwd)"

BOLD='\033[1m'; DIM='\033[2m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'
ok()    { echo -e "  ${GREEN}✅${RESET} $1"; }
warn()  { echo -e "  ${YELLOW}🟡${RESET} $1"; }
block() { echo -e "  ${RED}⏳${RESET} $1"; }
hdr()   { echo; echo -e "${BOLD}$1${RESET}"; echo "────────────────────────────────────────────────────────────────────"; }

echo -e "${BOLD}════════════════════════════════════════════════════════════════════"
echo "  DUAL-SCALE TOPOLOGICAL UNIVERSE MODEL — QUICK RESTART"
echo -e "════════════════════════════════════════════════════════════════════${RESET}"

hdr "Repository state"
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
COMMIT=$(git log -1 --format="%h %ad — %s" --date=short 2>/dev/null)
DIRTY=$(git status --porcelain 2>/dev/null)
echo "  Branch:     $BRANCH"
echo "  Last commit: $COMMIT"
if [ -z "$DIRTY" ]; then ok "Working tree clean"; else warn "Uncommitted changes present"; fi

hdr "Stream 1 — Theory (Lean 4 formalization)"
ok "COMPLETE — S1-02, S1-03, S1-04, S1-07, S1-08 all closed"
echo "     Main result: generic Cooper W≡0 (P_cleared_eq_zero), proved via ring,"
echo "     specializes to s7/s10/s18 as free corollaries. 0 sorry outside OpenGoals/."
echo "     Manuscript: manuscript/main.pdf (rebuild: cd manuscript && pdflatex main.tex"
echo "     && bibtex main && pdflatex main.tex && pdflatex main.tex — use pdflatex,"
echo "     NOT lualatex/xelatex, luaotfload is broken in this environment)."
if [ -f open_goals.json ]; then
  N_OPEN=$(python3 -c "import json;print(len(json.load(open('open_goals.json'))))" 2>/dev/null || echo "?")
  echo "     Open goals remaining: $N_OPEN (expected: 2 — open_goal_recurrence_s7/s10)"
fi

hdr "Stream 2 — Physics Selection & Geometry (C3b)"
if [ -d docs/literature ] && [ -n "$(ls -A docs/literature 2>/dev/null)" ]; then
  ok "Phase 1 (provenance): PDFs fetched — check refs/literature_provenance.txt for hash status"
else
  block "Phase 1 (provenance gate) NOT STARTED — docs/literature/ empty. START HERE (1-2h)."
fi
if [ -f data/certificates/C1_cooper_s7.json ]; then
  ok "C1 (Kodaira fibers): certificates present"
else
  block "C1 (Kodaira fibers) not computed — depends on Phase 1"
fi
if [ -f data/certificates/C2_cooper_s7.json ]; then
  ok "C2 (Picard lattice): certificates present"
else
  block "C2 (Picard lattice) not computed — depends on C1"
fi
echo "     Next action: briefs/INDEX_STREAM2_STREAM3_NEXT_ACTIONS.md § Stream 2"
echo "     Exact singular points already given (no solve needed):"
echo "       s7:  z = 1/27, z = -1   |   s10: z = 1/16, z = -1/4"

hdr "Stream 3 — Experimentation (public-data confrontation)"
if [ -f data/MANIFEST.md ]; then
  ok "WP S3-01 (data acquisition): MANIFEST.md present"
else
  block "WP S3-01 (data acquisition) NOT STARTED — unblocked, can start now (2-4h)"
fi
if grep -rq "TEST\|FIT" scripts/*.py checkers/*.py 2>/dev/null; then
  ok "WP S3-02 (pipeline scaffold): TEST/FIT labeling scaffolding found"
else
  block "WP S3-02 (pipeline scaffold) NOT STARTED — unblocked, can start now (4-8h)"
fi
block "WP S3-00 (MVM matching) BLOCKED — needs Stream 2 geometry lock + ASSUMPTIONS.md"
echo "     sign-off + PREDICTION.md observable freeze. Do NOT shortcut this."
echo "     Next action: briefs/STREAM3_EXPERIMENTATION_DIRECTIVE_2026-07-24.md § 1-2"

hdr "Open items needing Xavier's attention (not blocking, but tracked)"
warn "briefs/INTERNAL_PHYSICS_TIER_GAPS_2026-07-24.md — 6 findings where physics-file"
echo "     docstrings overclaim relative to their Lean content (2 involve axioms/props"
echo "     self-disclosed as vacuous at declaration, cited as established 1-3 files away)."
echo "     Diagnostic only, no files changed. 4 remediation options given, your call."
warn "ASSUMPTIONS.md — still DRAFT v0.1, 'NOT YET T0-AUTHORED OR SIGNED OFF' per its"
echo "     own header. Blocks Stream 3 S3-00 until reviewed."
warn "PREDICTION.md — observable choice (P1 PTA / P2 lensing / Lyman-α) still open,"
echo "     deferred to external astrophysics consultation per its own §3."
warn "An unverified 'OEIS↔F-theory' matrix was proposed and REJECTED this session —"
echo "     contradicts sourced S12_zagier_params (Tier B pipeline data, not a named"
echo "     OEIS sequence). If revisited, needs the same fetch-and-hash protocol as"
echo "     Cooper's s7/s10/s18 — do not accept OEIS IDs/mirror-map values at face value."

hdr "Quick commands"
echo "  lake build Agora              # full Stream 1 build (should be green, ~3106 jobs)"
echo "  lake build Tests               # golden numeric tests"
echo "  python3 scripts/export_open_goals.py   # regenerate open_goals.json"
echo "  cat briefs/INDEX_STREAM2_STREAM3_NEXT_ACTIONS.md   # full next-actions routing"

if [[ "${1:-}" == "--build" ]]; then
  hdr "Running lake build Agora (--build flag passed)"
  lake build Agora
fi

echo
echo -e "${BOLD}════════════════════════════════════════════════════════════════════${RESET}"
echo "  Latest release tag: v0.4-S1-complete"
echo "  Repo root: $REPO_ROOT"
echo -e "${BOLD}════════════════════════════════════════════════════════════════════${RESET}"
