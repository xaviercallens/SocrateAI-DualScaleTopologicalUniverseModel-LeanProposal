# LL.md — Lessons Learnt (Stream 1)

Durable, mechanically-checkable lessons. Each entry is here because it **cost something**: a false
claim published, a gate trusted that could not fire, a review item that went quiet for two months.
Anything that could be re-derived from the code does not belong here.

Ordering is by section, not by importance. **§1 is the one to read if you read one.**

---

## §1. The claim must live in the STATEMENT

A Lean theorem can be **true, compile, and pass every gate** — the build, the `sorry` grep, the
axiom audit, the statement lock — while proving **less than its name says**. The claim lives in the
identifier and the docstring; the statement carries something weaker.

This is *not* vacuity, and it is worse in one specific way: a vacuous theorem is caught the moment
someone reads the statement, whereas this one reads correctly to anyone who already believes the
name.

Four instances, 2026-09-21, all fixed or disclosed:

| declaration | the name promised | the statement said |
|---|---|---|
| `glue_primitive` | `e + Nf` is primitive in `U` | `IsCoprime (1 : ℤ) N` — `isCoprime_one_left` renamed; no vector, no basis, no `U` |
| `plus_seven_not_orthogonal` | replacing `C` by `B` breaks orthogonality | tested `fromRows B 0`, which **is** `Phi_T` — so only `T₇ ≠ 0` |
| `sym2` (whole file) | the symmetric square | four theorems *constrained* it, none *identified* it |
| `master_moduli_stabilization` | "perturbative regime (S_{1,2} ≤ 1.177)" | `∃ s, perturbative_regime s`; `1.177` occurs nowhere |

**§1.1** Check that every noun in a declaration's name appears in its statement. If the object the
name is about does not appear among the statement's terms, the claim is in the prose.

**§1.2** Beware defined abbreviations that collapse. `fromRows B 0` silently *was* `Phi_T`, defined
nine lines above.

**§1.3** A theorem can pin down every property you tested and still leave the object unnamed — then
the name does the identifying. `sym2_isometry`, `sym2_det`, `sym2_trace`, `sym2_contravariant` all
constrain `sym2`; a map can satisfy all four and not be the substitution action. **State what the
object IS, not only how it behaves.** (`sym2_is_substitution`.)

**§1.4** When verifying someone else's theorem, verify the **statement**, not the mathematics they
describe. I checked a peer's `fricke_is_proper_equivalence` by hand, confirmed the mathematics, and
reported it verified — but the Lean statement was a free-floating polynomial identity that `ring`
closes, and I had supplied the Fricke identification myself from their prose. *The check was real
but aimed one level too high.*

**§1.5** A docstring cannot fix a name. When a statement cannot be raised to meet its name — e.g.
Tier C is blocked, so no genuine theorem is available — **the name comes down to meet the
statement.** Renames of 2026-09-21: `dual_scale_universe_model_consistent` →
`dual_scale_components_conjunction`, `m87_alpha_eff_certificate` → `exists_real_above_0_45`,
`master_moduli_stabilization` → `lvs_potential_positivity_and_placeholder`.

---

## §2. Disclosure has to reach the declaration

**§2.1** *A disclosure belongs on the declaration, not only in the prose that discusses it.* Prose
is read by whoever reads that prose; a docstring is read by everyone who meets the theorem.
`master_moduli_stabilization`'s vacuity was disclosed correctly in `README.md` and `AXIOMS.md` and
**not at the theorem**, so a reader of the source saw a confident four-point claim.

**§2.2** And on **the declaration the criticism NAMES**, which is not always the one where the
substance lives. Review item A1 named `partner_res0`; its resolution was landed on `cooperC3`, the
source-of-record for the encoding. The audit still flagged `partner_res0`, correctly — a reader
meeting it would not have seen the answer.

**§2.3** *Writing the critique is not landing it.* When a review concludes a declaration claims more
than it proves, **the first edit is that declaration's docstring**; writing it up elsewhere is the
second edit, not the first. Applies retroactively: a correct critique sitting in a README or a
chapter is an **unlanded fix**, and should be treated as open rather than done.

**§2.4** Every in-place disclosure opens with the literal word **`Disclosure`**, so the audit and
the reader look for the same token. Without a convention, a correct disclosure phrased outside the
keyword list is reported as missing — and a docstring that merely uses the words looks disclosed.

**§2.5** **An unanswered review item leaves no trace in any gate.** It is not a `sorry`, not an
axiom, not a failing build, and the statement lock is silent on it. It reads as done because
nothing says otherwise. Review item A1 — against the encoding under this repo's *headline* result —
sat unanswered for two months. *Track open review items where the declaration lives.*

---

## §3. Gates: what they can and cannot see

**§3.1 A pipe replaces the exit code with the filter's.**
`lake build NoSuchTarget 2>&1 | grep "Build completed"` → `$? = 0`; unpiped → `$? = 1`,
`error: unknown target`. **Verified.** Every build check of 2026-09-21 was piped, so every exit code
reported that day was `grep`'s. The claims survived only because the *text* was read, not the
number. Capture the real status (`> log; RC=$?`, or `PIPESTATUS`).

**§3.2 A `sorry` does NOT fail the build.** Mutation-verified: appending
`theorem zzz : (0:Nat) = 1 := by sorry` gives **exit 0**, "Build completed successfully", with only
`warning: declaration uses \`sorry\``. With no CI and a hook that only warns, **nothing mechanical
enforces the no-`sorry` rule.** `axiom_audit.py` is what catches it, via `sorryAx` — use that.

**§3.3 `axiom_audit.py` exits 1 permanently here.** It fails on any non-standard axiom *including
registered, disclosed ones*, and this repo's steady state is three. So its exit code carries no
information and must be compared against `EXPECTED_FAILING`, never against zero. The same tool is a
usable pass/fail in LeanMaster, which registers none — **same code, different policy.** Ask of a
gate not only *have I seen it go red* but **can it go green in this repository's steady state?** A
signal engineered to be ignored is worse than no signal.

**§3.4 A gate that has never been seen go red is a gate you are trusting, not running.** Mutate and
watch it fire. Statement lock, mutation-verified: `T7_disc : |T7.det| = 14` → `= 15` gives
`CHANGED … :: T7_disc`, exit 1; reverted, exit 0.

**§3.5 Red in the OUTPUT is not red in the STATUS.** I had watched the statement lock print
`CHANGED` twice for my own edits and never checked whether it *exited* non-zero. A half-observation
I would not have noticed was half.

**§3.6 A scan that cannot see a declaration reports it as clean.** Both audit scripts anchored on
`^(theorem|lemma|def)` and silently skipped every `noncomputable`/`private`/`protected`/
attribute-prefixed declaration — **41 of 465 here (9%)**, including `cooperC3`, source-of-record for
the headline result's encoding. LeanMaster's version of this bug hid the same two `@[simp]` theorems
from **three** tools. *A fix that does not generalise is a fix with an expiry date.*

**§3.7 The durable fix is a self-test, not a fixed regex.** A regex fix repairs one tool; a
self-test makes the *next* tool fail loudly. Both scripts take `--self-test`, negative-controlled:
reintroducing the old anchor makes them exit 1.

**§3.8 Self-test in BOTH directions.** A one-directional self-test can fail only one way. Mine
tested that the parser *sees* declarations, never that the stripper *hides* what it must.
⚠️ **My first attempt at the bidirectional fix was itself a test that could not fail** — the fixture
put the keyword in a docstring *preceding* the declaration, but statements are captured only from
after the declaration's name, so it passed whether or not the stripper ran. *Written into the very
commit that added bidirectional self-testing*, and caught only by running the negative control on my
own fix.

**§3.9 A check that matches a string is not a check on the object.** Three encodings defeated
matchers in one day:

| the check | what it missed |
|---|---|
| `grep "declaration uses 'sorry'"` | Lean uses **backticks**: `` declaration uses `sorry` `` — 0 hits while the warning was present |
| `PASS\([0-9N]` over LaTeX | `PASS(\texorpdfstring{$N$}{N})` — 2 false "violations" in the paper |
| hook's `^\s*axiom\s` | fires on *prose* beginning "axiom audit…"; and cannot see an attribute-prefixed declaration |

**§3.10** Record what a scan **cannot** see, at the time you write it. A vacuity scan written for
`: True` cannot see `0 ≤ sys.dim` with `dim : ℕ` — equally empty, invisible to that signature. **A
vacuous statement need not be `True`; it need only be implied by nothing.**

---

## §4. Numbers and their denominators

**§4.1** The name-vs-statement ratio was wrong **twice**: `208/481` → `208/312` → **`226/333`**.
First the wrong population (481 counts *all* declarations including `def`s across three
directories); then a population the tool could not see (§3.6). *A number that reads as a coverage
figure while its denominator names a different population is the audit's own failure mode.*

**§4.2** Re-measure totals; never carry one forward and increment it.

**§4.3** A summary that drops a limiting clause is the same defect as a docstring that drops one
(§2.3, one level up). A peer stated a correct width to me, then compressed it into a table row that
lost it — *in the release announcing the rule against exactly that*. I did the same in the other
direction, shipping an overstated claim about why docstring-stripping matters, and telling them to
adopt it.

**§4.4 Neither of us can see our own compression.** When it was their table I spotted the dropped
qualifier immediately; when it was my own docstring I shipped it, released it, and recommended it.
*That is not a fact about either party — it is the argument for the exchange.*

---

## §5. Process

**§5.1 Quarantine, never delete.** "Get rid of it" always means move + disclose, never `rm`. Use
`git mv` so history follows the file. A rename is *itself* a partial deletion of the record, so a
superseded name gets a pointer comment left behind, not a silent change.

**§5.2 Separate the unverified structurally, not by docstring.** All nine defects of 2026-09-21
landed in five legacy physics modules; **not one** landed in the arithmetic/lattice core, which held
up under direct attack. They now live in `Agora/Unverified/`, with the dependency verified one-way.
The quarantine still compiles: the claim is *"this is not evidence"*, never *"this does not
compile"*.

**§5.3 No exemption lists.** An exemption that starts at one file is a ban repealed by attrition. If
your own prose trips your own rule, fix the prose.

**§5.4 Producer ≠ verifier wants to be broad.** Every defect found on 2026-09-21 came from a second
party with different priors, working on their own code, prompted by a question about someone else's
— *not* from review; neither session read the other's Lean. **Nine findings, none produced by any
gate.** Neither session audited itself unprompted, and both found their worst defects only after
being handed someone else's question.

**§5.5 State a G5 pass at the width it was actually performed.** "Verified externally" must say
*what* was verified. An independent check of the *values* a theorem asserts is not a check of the
theorem, if the definition underneath was never read.

**§5.6 Verifying a verification is not exempt.** Check what the number you are reading is a number
*of*. (§3.1, §3.8, §4.1 are all this lesson at different depths.)

---

## §6. Fabrication

**§6.1** On 2026-09-21, answering a peer's certification request, I wrote a fenced
`#print axioms …` block **for a command I had not run**. Caught mid-message and retracted; the real
run followed and the values matched.

**§6.2** That match is the point. **The danger signature is near-certainty, not carelessness.** I
had the structural argument and the namespace-wide audit; both made the conclusion certain, and
"certain" wrote itself out in the visual form of "certified".

**§6.3** A gate phrased *"don't fabricate"* catches nothing. The one that catches it: **a fenced
transcript must be pasted from a run in this session, and "pending" is always available.** The
pending-vs-certified convention had been used correctly earlier in the same session and was
bypassed.

---

*Provenance:* Generated-by: Claude Opus 5 (Stream 1 session, 2026-09-21) | Verified-by: every
mechanical claim above re-run unpiped, mutations observed red then green | Reviewed-by: T0 Y
(Xavier, 2026-09-21).
