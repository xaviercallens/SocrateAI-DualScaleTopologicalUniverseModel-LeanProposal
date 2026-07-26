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
# Streams 2/3 live in a sibling checkout, not this repo — hint only, may drift.
AGORA_REPO_HINT="/mnt/disks/disk-socrateai-local-1/callensxavier_home_data/SocrateAI-Scientific-Agora-K3-DarkMatter"

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
ok "COMPLETE — S1-02 through S1-14 all closed except one named open goal (below)"
echo "     Base result: generic Cooper W≡0 (P_cleared_eq_zero), proved via ring,"
echo "     specializes to s7/s10/s18 as free corollaries. WP-B1 (chameleon mechanism)"
echo "     T0-signed-off 2026-07-26 — Stream 1's last operational gate is closed."
echo "     S1-10..S1-14 (2026-07-26): the Cooper Sym² partner is GENERIC over"
echo "     (a,b,c,d) — s7/s10/s18 partners are free corollaries; s18_params vindicated"
echo "     vs Almkvist–van Straten; dyadic baseline (sqrtSeq_dyadic) kernel-proved;"
echo "     s7 partner integrality CLOSED via a cited O'Brien 2016 Thm 6.2 axiom (not"
echo "     blocked-on-mathlib as first ruled — recompute before accepting that label)."
echo "     0 sorry outside OpenGoals/. 2 axioms total (Agora/Axioms/), both registered"
echo "     in AXIOMS.md: pipeline_upper_bound (DISCLOSED-VACUOUS, undischarged, waits"
echo "     on real Stream 2/3 pipeline data) and obrien2016_theorem6_2 (literature cite)."
echo "     Manuscript: manuscript/main.pdf (rebuild: cd manuscript && pdflatex main.tex"
echo "     && bibtex main && pdflatex main.tex && pdflatex main.tex — use pdflatex,"
echo "     NOT lualatex/xelatex, luaotfload is broken in this environment)."
if [ -f open_goals.json ]; then
  N_OPEN=$(python3 -c "import json;print(len(json.load(open('open_goals.json'))))" 2>/dev/null || echo "?")
  N_STILL_OPEN=$(python3 -c "import json;print(sum(1 for g in json.load(open('open_goals.json')) if g['status']=='open'))" 2>/dev/null || echo "?")
  echo "     Named goals tracked: $N_OPEN, of which OPEN: $N_STILL_OPEN"
  echo "     (open_goal_partner_eq_sqrt_s7 — genuinely blocked-on-mathlib, no"
  echo "     PowerSeries/holonomic-sequence transport API at the pin; S1-14 sketches a"
  echo "     plausible elementary Finset.sum route, not yet attempted in full)"
fi

hdr "Stream 2 — Physics Selection & Geometry (Agora repo, separate checkout)"
echo "     ⚠️  The C1/C2 (Kodaira/Picard) layer this section used to track is"
echo "     PERMANENTLY RETRACTED (E-007, 2026-07-25) — ρ=4/T=18 traced to a hardcoded"
echo "     lookup, not geometry. Do not resurrect checks against those old certificate"
echo "     paths; they are gone by design."
ok "E-011 (2026-07-26): ρ=19, T=3 — DERIVED for real this time, Tier B."
echo "     Chain: L3 irreducible (computed, Frobenius-exponent argument) ⇒ rank V=3 ⇒"
echo "     [B, 2 independent citations: Zarhin 1983 Thm 1.6(a); Huybrechts Lemma"
echo "     3.2.7/3.3.1] T irreducible ⇒ T=3 ⇒ ρ=22-3=19. Independently reproduced and"
echo "     the guard deliberately broken-and-restored by Stream 1, 2026-07-26"
echo "     (briefs/STREAM1_GUIDANCE_ON_E011_E012_WPE_2026_07_26.md) — sound."
echo "     Caveats that MUST travel with this number: very-general-member only"
echo "     (jumps to 20 on Noether-Lefschetz locus); projectivity load-bearing;"
echo "     discriminant and Mordell-Weil rank still null; nothing about s18."
warn "E-010 (2026-07-26, same day): a FIRST attempt at this exact derivation was"
echo "     fabricated (hardcoded rho, rigged D-3 observable) and retracted before push."
echo "     E-011 is the real one — verify by reading the checker, not by trusting a brief."
echo "     Next action (Agora repo): cat briefs/T0_AUTHORIZATION*.md, ESCALATIONS.md E-011"

hdr "Stream 3 — Experimentation (Agora repo, separate checkout)"
block "D-3 (2026-07-26, E-012): Stream 3 self-blocked rather than run a fabricating"
echo "     pipeline. 4 independent blockers found: no observable selected yet (by"
echo "     design, WP S3-00 hasn't run), the pinned runner fabricates (same np.random"
echo "     pattern as E-010), PREDICTION.md's own prerequisites are now false, and the"
echo "     data can't support the observable (photo-z smears radial position ~10^2 Mpc)."
echo "     Gate E criteria 1-2: UNSCOREABLE (not FAIL) — E-011 supplies a PRIOR, not a"
echo "     measurement. Good self-catch, 3rd instance of this failure mode today."
warn "WP S3-00 (MVM matching): the actual next unblocked, highest-value work per both"
echo "     Stream 2's WP-E review and Stream 1's independent read. Not yet run."

hdr "Open items needing Xavier's attention (not blocking, but tracked)"
warn "PREDICTION.md (Agora repo) v1.0-PINNED still shows a CHECKED box (line ~49) for"
echo "     the retracted rho=4/T=18, contradicting its own later prose. Needs a T0 call:"
echo "     re-pin at v1.1, or annotate under the countermand window. NOT resolved as of"
echo "     the last Stream 1 check — see"
echo "     briefs/STREAM1_GUIDANCE_ON_E011_E012_WPE_2026_07_26.md § 4 (this repo)."
warn "open_goal_partner_eq_sqrt_s7 — the one Lean goal still open. T0-ruled"
echo "     blocked-on-mathlib; S1-14 found the framing may overstate it (elementary"
echo "     Finset.sum route sketched, not attempted). Worth a dedicated session, not a"
echo "     re-litigation without new information."
warn "pipeline_upper_bound axiom (Agora/Axioms/PipelineBound.lean) — still"
echo "     DISCLOSED-VACUOUS, undischarged. Confirmed 2026-07-26: no real pipeline"
echo "     artifact exists yet in either repo. Waits on Stream 2/3 data, not Stream 1."

hdr "Quick commands"
echo "  lake build Agora               # full Stream 1 build (should be green, ~3118 jobs)"
echo "  lake build Tests                # golden numeric tests"
echo "  lake build OpenGoals             # named open goals (1 sorry expected: the bridge goal)"
echo "  python3 scripts/export_open_goals.py    # regenerate open_goals.json"
echo "  python3 scripts/verify_sym2_partner_identities.py   # CAS cross-check, S1-10/11/12/13"
echo "  cat briefs/T0_AUTHORIZATION_EXECUTED_AND_S1_13_CORRECTION_2026_07_26.md"
echo "  cat briefs/STREAM1_GUIDANCE_ON_E011_E012_WPE_2026_07_26.md   # latest cross-stream state"
echo
echo "  In the Agora repo (Streams 2/3), separately:"
echo "    cd $AGORA_REPO_HINT 2>/dev/null || echo '(set AGORA_REPO_HINT below if path moved)'"
echo "    git log --oneline -10          # check for activity beyond E-011/E-012/WP-E"
echo "    cat briefs/T0_AUTHORIZATION*.md ESCALATIONS.md   # ρ/T and Gate E status"

if [[ "${1:-}" == "--build" ]]; then
  hdr "Running lake build Agora (--build flag passed)"
  lake build Agora
fi

echo
echo -e "${BOLD}════════════════════════════════════════════════════════════════════${RESET}"
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "(none)")
echo "  Last tag reachable from HEAD: $LAST_TAG (may predate the latest commits above —"
echo "  check 'git log --oneline -10' for anything landed since)"
echo "  Repo root: $REPO_ROOT"
echo -e "${BOLD}════════════════════════════════════════════════════════════════════${RESET}"
