# docs/literature/ MANIFEST — fetched primary sources (Stream 1)

Every PDF here is hash-pinned. A source may be **cited as load-bearing (Tier L) only after it has
been READ** in this repository — page images or text layer, with the theorem number checked against
the page, not against memory or against another stream's summary. Format copied from Stream 2's
`docs/literature/MANIFEST.md` (K3-DarkMatter) so the two manifests can be diffed.

| file | sha256 | source | fetched / copied | read status (here) |
|---|---|---|---|---|
| Almkvist_vanStraten_arXiv2103.08651.pdf | 549c176daa7eb5605b09a6894a8e5a9cbe94c015ef6e7dcb87650ceef4e7cfec | arXiv:2103.08651 (Almkvist–van Straten) | 2026-07-25 | READ 2026-07-26 (s18 partner vindication, `s1_10`) — hash recorded 2026-09-27, matches Stream 2's copy |
| Gorodetsky_arXiv2102.11839_v2.pdf | 520da4b0171128d22971d7398f79a1aa6cd760c2412b34a78ba5120adc371ee1 | arXiv:2102.11839 v2 (Gorodetsky) | 2026-07-25 | READ (s18 provenance, `s18_params`) — hash recorded 2026-09-27, matches Stream 2's copy |
| Zagier_AperylikeRecEqs.pdf | 9fe93aadda4a5dc0297c7b5d835d8c3026ebf026f5dc139eefc0ff7856f4fc97 | Zagier, "Integral solutions of Apéry-like recurrence equations" | 2026-07-25 | READ (sporadic table; **the earlier wrong-PDF incident is E-007's**, Stream 2 2026-07-25 — this file is the one `S12_zagier_params` was checked against) |
| doran_1998_picard_fuchs_uniformization.pdf | 2a3ce0656f6b36ea78aafbbb77472e74d51c86952dda1b767780e24cefbaac44 | arXiv:math/9812162 (Doran, "Picard–Fuchs uniformization…", CMP 212 (2000) 625–647) | copied 2026-09-27 from K3-DarkMatter `docs/literature/` at origin/main `ef78d83`; hash identical to their MANIFEST row | **READ 2026-09-27 (text layer, `pdftotext`)**: Thm 5.13, p. 17–18 — *"The Picard-Fuchs equation of a family of Mₙ-polarized K3 surfaces is the symmetric square of a second order homogeneous linear Fuchsian ordinary differential equation."* Proof: order = rank T = 22 − 19 = 3; the period domain lies on a nondegenerate quadric in P² (Dolgachev's Torelli); Cor 5.8 (a third-order equation whose fundamental solutions satisfy a nondegenerate quadric is a symmetric square) closes it. §5.3, after Conj 5.14: third-order PF ⟺ polarization by a rank-19 lattice. |

## What the Doran pin is for (and what it is not)

**Tier L pin (Stream 2 direction 1, `briefs/STREAM2_TO_STREAM1_FABLE_REVIEW_DIRECTIONS_2026_09_27.md`).**
Wherever this repository's prose relies on the chain

> *Sym² structure of the third-order operator ⟺ rank-3 transcendental lattice of signature (2,1) ⟺ Mₙ-polarized family*

the forward implication "Mₙ-polarized ⇒ PF is a Sym²" is **Doran 1998 Thm 5.13**, and the
lattice `(Mₙ)^⊥ = U ⊕ ⟨2n⟩` with period domain `H/Γ₀(n)⁺` is **Dolgachev 1996 §7** (pinned in
Stream 2's manifest, `a913a0f3…`; not copied here — cite Stream 2's row). Both are **Tier L**:
literature, read, hash-pinned; neither is formalized in Lean here.

**Not supplied by the pin.** The *converse* — that the s₇ operator being a Sym² (Tier A here,
`Agora/SymSquare*.lean`) makes the s₇ family M₇-polarized — is **not** Thm 5.13, and Doran §6
says the rank-19 classification needed for a converse is "lacking". The identification of the
monodromy-invariant lattice of `cooper_s7` with `U ⊕ ⟨14⟩` is Stream 2's Tier B certificate
(`C2_cooper_s7_v6.json`, LIVE 2026-09-27, values identical to v5), and stays Tier B.

---
*Generated-by: Claude (Fable 5.1), Stream 1, 2026-09-27 | Verified-by: `sha256sum` on the files in
this directory, run in this session; Doran Thm 5.13 read from the text layer of the pinned PDF in
this session | Reviewed-by: N*
