# Literature Provenance Fetching Guide (A5/A6 Anti-Hallucination Protocol)

**Purpose:** Ensure all sporadic sequence parameters are traced to **fetched, verified sources**, not AI memory.

**Gate:** A5/A6 adversarial checks require all PDFs fetched and hashes pinned before running full validation suite.

---

## Sources Required

### 1. Zagier Sporadic Sequences (6: A, B, C, D, E, F)

**Source:** D. Zagier, "Integral solutions of Apéry-like recurrence equations" (survey, 2009 or latest)

**Where to fetch:**
- arXiv: https://arxiv.org/abs/math/0611800 (or search "Zagier sporadic")
- Direct: Search JSTOR / Math reviews for the survey

**Parameters to verify (from paper / table):**
- A: (1, 0, 0, 0)
- B: (2, 1, 0, 0)
- C: (2, 2, -1, -1)
- D: (6, 6, -16, -16)
- E: (1, 1, -1, -1)
- F: (3, 3, -1, -1)

**OEIS cross-check:**
- Zagier A → A000984 (central binomial)
- Zagier B → A002893
- Zagier C → A006003
- Zagier D → A001850 (Delannoy)
- Zagier E → A002895
- Zagier F → A005259

**Save to:** `docs/literature/Zagier_2009_sporadic.pdf`

---

### 2. Almkvist-Zudilin (AESZ) Sequences (6: α, β, γ, δ, ε, ζ)

**Source:** G. Almkvist, D. van Straten, "Calabi-Yau operators and their Apéry-like recurrences" arXiv:2103.08651

**Where to fetch:**
- arXiv: https://arxiv.org/abs/2103.08651 (PDF download)
- Direct: Visit arxiv.org, download PDF

**Parameters to verify (from paper / AESZ database table):**
- α: (2, 2, -1, -1)
- β: (2, 1, 0, 0)
- γ: (6, 0, -32, 0)
- δ: (3, 1, 0, 0) — NOTE: This is s10 (OEIS A005260)
- ε: (1, 1, 0, 0)
- ζ: (3, 3, -1, -1) — Same as Zagier F (Apéry π)

**OEIS cross-check:**
- AESZ α → A006003
- AESZ β → A002893
- AESZ γ → A006242
- AESZ δ → A005260 (s10)
- AESZ ε → A005258
- AESZ ζ → A005259 (Apéry π)

**Save to:** `docs/literature/Almkvist_vanStraten_arXiv2103.08651.pdf`

---

### 3. Cooper Sporadic Sequences (3: s7, s10, s18)

**Source 1:** S. Cooper, "Sporadic sequences, modular forms and new series for 1/π" (Ramanujan Journal, 2012)

**Where to fetch:**
- JSTOR: Ramanujan Journal, Vol. 29 (2012), pp. 163–183
- ResearchGate: https://www.researchgate.net/ (search "Cooper sporadic sequences")
- arXiv: Try searching author name

**Save to:** `docs/literature/Cooper_2012_Ramanujan.pdf`

**Source 2 (Unified table):** O. Gorodetsky, "New representations for all sporadic Apéry-like sequences, with applications to congruences" (Experimental Mathematics, 2023)

**Where to fetch:**
- arXiv: https://arxiv.org/abs/2102.11839 (version 2 or latest)
- PDF download: Visit arxiv.org

**Parameters to verify (Gorodetsky Table 1, p.3, or arXiv v2 p.3):**
- s7: (13, 4, -27, 3) — OEIS A183204
- s10: (6, 2, -64, 4) — OEIS A005260
- s18: (14, 6, 192, -12) — OEIS A181418

**⚠️ CRITICAL: s18 has a known transcription error in some copies. Use Gorodetsky arXiv:2102.11839 v2 p.3 as authoritative source.**

**Save to:** `docs/literature/Gorodetsky_arXiv2102.11839_v2.pdf`

---

## Verification Procedure

### Step 1: Fetch All PDFs

```bash
# Create docs/literature/ folder (already done)
cd docs/literature/

# Download each PDF manually (cannot be automated due to access controls)
# Option A: arXiv
#   - Visit https://arxiv.org/abs/2103.08651 → click "PDF"
#   - Save to docs/literature/Almkvist_vanStraten_arXiv2103.08651.pdf
#
# Option B: Journal access (if available)
#   - Access via institution / ResearchGate
#   - Save to docs/literature/Cooper_2012_Ramanujan.pdf
#
# Option C: Author contact (if needed)
#   - Email author for reprint
```

### Step 2: Compute Hashes

```bash
# Once all PDFs are in docs/literature/, compute SHA256

cd /path/to/repo
for pdf in docs/literature/*.pdf; do
  sha256sum "$pdf"
done
```

**Example output:**
```
abc123def456... Almkvist_vanStraten_arXiv2103.08651.pdf
ghi789jkl012... Gorodetsky_arXiv2102.11839_v2.pdf
mno345pqr678... Cooper_2012_Ramanujan.pdf
stu901vwx234... Zagier_2009_sporadic.pdf
```

### Step 3: Verify Parameters Against PDFs

**For each sequence, open PDF and manually verify:**

1. **Zagier A (central binomial):** Find in Zagier paper, confirm (1,0,0,0)
2. **s7 Cooper:** Open Gorodetsky p.3, find Table 1, confirm (13,4,-27,3) for row "s7"
3. **s10 Cooper:** Same table, confirm (6,2,-64,4)
4. **s18 Cooper:** Same table, confirm (14,6,192,-12)
5. **AESZ sequences:** Open Almkvist-vanStraten paper, find AESZ database entry, verify all 6

**Record in spreadsheet or notes:**
```
Sequence | OEIS | (a,b,c,d) | Source PDF | Source Page | Verified? | Date
s7       | A183204 | (13,4,-27,3) | Gorodetsky_arXiv2102.11839_v2.pdf | p.3, Table 1 | YES | 2026-07-24
s10      | A005260 | (6,2,-64,4) | Gorodetsky_arXiv2102.11839_v2.pdf | p.3, Table 1 | YES | 2026-07-24
...
```

### Step 4: Pin Hashes in Registry

**Update `refs/literature_provenance.txt`:**

```txt
Zagier_2009_sporadic.pdf | MD5:abc123 | SHA256:stu901vwx234... | Zagier 2009 survey | 2026-07-24
Gorodetsky_arXiv2102.11839_v2.pdf | MD5:ghi789 | SHA256:mno345pqr678... | arXiv:2102.11839 v2 | 2026-07-24
Cooper_2012_Ramanujan.pdf | MD5:jkl012 | SHA256:xyz789abc123... | Ramanujan J. 29:163-183 | 2026-07-24
Almkvist_vanStraten_arXiv2103.08651.pdf | MD5:def456 | SHA256:ghi789jkl012... | arXiv:2103.08651 | 2026-07-24
```

### Step 5: Run A5/A6 Validation

```bash
python3 checkers/adversarial_A5_A6_provenance_hygiene.py
```

**Expected output:**
```
✅ All 15 sporadic sequences traced to fetched sources
✅ SHA256 hashes verified
✅ No AI memory hallucination detected
A5/A6 Verdict: ✅ PASS
```

---

## Checkpoint: Anti-Hallucination Gate

**Before proceeding to C1/C2 computation, MUST HAVE:**

- [ ] docs/literature/ folder created ✓
- [ ] Zagier_2009_sporadic.pdf fetched
- [ ] Almkvist_vanStraten_arXiv2103.08651.pdf fetched
- [ ] Gorodetsky_arXiv2102.11839_v2.pdf fetched
- [ ] Cooper_2012_Ramanujan.pdf fetched (if accessible)
- [ ] All 6 Zagier params verified against Zagier paper
- [ ] All 6 AESZ params verified against Almkvist-vanStraten paper
- [ ] All 3 Cooper params (s7, s10, s18) verified against Gorodetsky arXiv p.3
- [ ] SHA256 hashes computed and pinned in refs/literature_provenance.txt
- [ ] checkers/adversarial_A5_A6_provenance_hygiene.py passes ✅

**If any step fails:** HALT — resolve before proceeding.

---

## Anti-Hallucination Rule (Binding)

**EVERY sporadic sequence parameter used in the codebase (tests, checkers, Lean proofs) must be:**

1. Traced to a **fetched PDF** (not model memory)
2. **Verified character-by-character** against the source (manual check, not OCR)
3. **Cross-checked** with OEIS entries
4. **Hash-pinned** in this registry

**Violations:**
- No checkers run (A1–A6 blocked)
- No C1/C2 computation (geometry lock blocked)
- No physics brief (Stream 2 blocked)

**Consequence of violation:** Return to step 1, re-fetch, re-verify.

---

**Generated-by:** A5/A6 protocol (anti-hallucination gate)  
**Owner:** Xavier (provenance authority)  
**Status:** Ready for manual PDF fetching (automated fetch not possible; arXiv PDFs must be downloaded manually)  
**Next:** Fetch all PDFs, compute hashes, run A5/A6 validation
