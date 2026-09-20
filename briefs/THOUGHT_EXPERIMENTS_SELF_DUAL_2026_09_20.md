# Expériences de pensée — « la marche vers l'auto-dual » : registre et évaluation (2026-09-20)

**Origine.** Intuition T0 (Xavier) : parmi les directions de
`briefs/RESEARCH_DIRECTIONS_2026_09_20.md`, la plus prometteuse est celle du **point auto-dual** —
le lieu fixe de l'involution qui est Fricke côté K3 et T-dualité côté T².
**Ce document** consigne les expériences de pensée (GE-1…GE-6), évalue chacune, et indique ce qui
a été établi en Lean 4 **Tier A** *en parallèle* (`Agora/Geometry/SelfDual.lean`).

**Verdict d'ensemble.** L'intuition est **confirmée au niveau mathématique**, et plus fortement
qu'attendu : les deux points singuliers finis des opérateurs de Picard–Fuchs de s₇,
`z = 1/27` et `z = −1`, **sont** des points auto-duaux. Elle n'est **pas** confirmée — ni infirmée —
au niveau physique : rien ici ne fournit de couplage (VISION §1.3) et le Tier C reste bloqué (F5b).

Légende des statuts : **(K)** prouvé par le noyau Lean · **(E)** calcul exact hors Lean ·
**(N)** numérique · **(L)** littérature · **(C)** conjecture.

---

## GE-1 — « L'échange e ↔ f est-il une simple permutation, ou une réflexion de Weyl ? »

*Pensée.* Si l'involution auto-duale est une réflexion dans une racine, son lieu fixe est un **mur**,
et « marcher vers l'auto-dual » veut dire marcher vers un mur de chambre de Weyl.

*Résultat — (K).* `r = e − f` est de norme `−2` dans `U ⊕ ⟨2N⟩` pour tout `N` (`root_norm`), et
`swap = reflection (TN N) r` (`swap_eq_reflection`), où `reflection` est celle de **LeanMaster**.
Isométrie et involution se redéduisent alors des théorèmes généraux de LeanMaster
(`reflection_isometry`, `reflection_involution`) : seconde dérivation, indépendante.
Même énoncé sur le plan hyperbolique nu = réseau de Narain du cercle : l'échange impulsion ↔
enroulement est la réflexion dans `(1, −1)`, de norme `−2` (`narain_swap_eq_reflection`).

*Évaluation.* **Confirmé.** Des deux côtés, l'involution est *la même* réflexion de Weyl dans *la
même* (−2)-racine de `U`.

## GE-2 — « Où est le mur ? »

*Résultat — (K).* `⟨e − f, ω(τ)⟩ = −(Nτ² + 1)` (`root_pairing_period`) ; donc la racine est
orthogonale à la période **ssi** `Nτ² = −1` (`root_orthogonal_iff_selfdual`). Le lieu auto-dual est
exactement le mur de la racine.

*Lecture géométrique — (L), non formalisée.* Sur ce mur, `e − f` devient une classe algébrique :
le rang de Picard saute de 19 à 20 et une (−2)-classe apparaît. *Lecture physique — (C), non
revendiquée :* dans la littérature des compactifications, un tel mur est un lieu de symétrie de
jauge étendue, comme le rayon auto-dual du cercle. Cette phrase est du contexte, pas un résultat du
programme.

## GE-3 — « Les points singuliers de L₃ sont-ils des points auto-duaux ? »  ← le résultat central

*Pensée.* E-008/E-009 ont établi que `{−1, 1/27}` sont des points elliptiques d'ordre 2 de
`X₀(7)⁺`, pas des dégénérescences de Kodaira. Un point elliptique d'ordre 2 est un point fixe
d'une involution. Laquelle ?

*Résultat — (K), sur l'application rationnelle `z(h) = h/(1 + 13h + 49h²)` :*
- `z(1/(49h)) = z(h)` — invariance de Fricke (`zOf_fricke`) ;
- points fixes de `h ↦ 1/(49h)` sur ℚ : exactement `h = ±1/7` (`fricke_fixed_iff`) ;
- `z(1/7) = 1/27`, `z(−1/7) = −1` (`zOf_selfdual_pos/neg`) ;
- **identité du discriminant** : `(1 − 26z − 27z²)·(1+13h+49h²)² = (1 − 49h²)²`
  (`s7_P2_discriminant`), où `1 − 26z − 27z²` **est** le `s7_P2` du dépôt (`s7_P2_eval`) ;
- donc `s7_P2` s'annule aux images des deux points fixes (`s7_singular_points_are_selfdual`).

Le coefficient dominant de l'opérateur partenaire, tiré en arrière sur la droite du Hauptmodul, est
un **carré parfait** qui s'annule exactement aux points fixes de Fricke : le lieu singulier de
L₂/L₃ est le lieu de ramification du quotient par l'involution.

*Entrées non (K) — à citer comme telles :*
- **(E), PASS(40)** : avec `h = q∏(1−q^{7n})⁴/(1−q^n)⁴`, `Σ s₇(n) z(h)ⁿ = (Σ q^{a²+ab+2b²})²`
  comme séries exactes jusqu'à `O(q⁴⁰)`. Contrôle négatif : `13 → 12` fait échouer le test.
  (`scripts/check_selfdual_points_s7.py`)
- **(N), 40 chiffres** : `h(i/√7) = 1/7` → `z = 1/27` ; `h((−1 + i/√7)/2) = −1/7` → `z = −1` ;
  `49·h(τ)·h(−1/(7τ)) = 1` en un point générique (résidu ~10⁻⁴²).
- **(L)** : la loi `h(−1/(7τ)) = 1/(49 h(τ))` découle de `η(−1/τ) = √(τ/i)·η(τ)`.

*Évaluation.* **Confirmé, et c'est nouveau pour le programme.** `z = 1/27` est le point fixe de
Fricke lui-même (`τ = i/√7`) ; `z = −1` est le point fixe de l'involution conjuguée
(`τ = (−1 + i/√7)/2`, matrice `[[7,4],[−14,−7]]/√7`). Cela remplace la lecture « Kodaira »
rétractée par un énoncé exact : **les singularités de la famille s₇ sont ses points auto-duaux.**

## GE-4 — « Y a-t-il une fonction qui mesure la marche ? »

*Résultat — (K).* Sur l'axe `τ = it` : `H_N(t) = Nt² + 1/(Nt²) ≥ 2` (`height_ge_two`), invariante
par `t ↦ 1/(Nt)` (`height_fricke`), égalité **ssi** `Nt² = 1` (`height_eq_two_iff`).
`height_ge_two` est *littéralement* `circle_effective_scale_ge_two` de **LeanMaster** évalué en
`R = Nt²` : la borne dual-scale du cercle et la hauteur de Fricke sont la même inégalité.

*Évaluation.* **Confirmé comme identité.** *Limite :* `H_N` n'est définie ici que sur l'axe
imaginaire ; aucune dynamique (flot, potentiel) n'est construite. « Marche » reste une métaphore
tant qu'aucun potentiel n'est exhibé — et en exhiber un serait du Tier C.

## GE-5 — « Le critère mod 4 a-t-il un rapport avec l'auto-dualité ? »  (spéculatif)

`4 ∣ s₇(n)` (PASS(200), non prouvé) équivaut à : la série `Σ s₇(n)zⁿ` est de la forme `1 + 4u(z)`.
Au point auto-dual `z = 1/27`, `θ²` est la forme de poids 2 évaluée au point CM `τ = i/√7`.
*Aucun lien n'est établi.* Piste : chercher si `4 ∣ s₇(n)` se lit sur `θ(q)² = 1 + 4(…)` —
**vrai pour θ² en `q`** (`r₂`-type : le nombre de représentations par `a²+ab+2b²` est pair, et
`θ² − 1 = 2(θ−1) + (θ−1)²` avec `θ − 1 ∈ 2qℤ[[q]]` donne `θ² ≡ 1 mod 4`). Reste à transporter de
`q` à `z` : `z = q + …` à coefficients entiers, inversible sur ℤ, donc **la congruence se
transporte**. ⇒ *Esquisse de preuve de `4 ∣ s₇(n)`*, conditionnelle à l'identité modulaire
`F(z(q)) = θ(q)²` (qui n'est que PASS(40)/(L)). Contrôle fait en séance, **(E) PASS(200)** : `θ − 1` a tous ses coefficients pairs et `θ²` a
tous ses coefficients d'indice ≥ 1 divisibles par 4, pour `n < 200`. **Statut : (C) — esquisse
cohérente, non formalisée, à attaquer en premier** ; si elle tient, l'axiome O'Brien tombe modulo l'identité modulaire, ce qui
ne ferait que déplacer la citation. À peser avant d'investir.

## GE-6 — « K3 × T² : une seule ℤ/2 ? »  (Tier C — conjecture, hors manuscrit)

Inchangé par rapport à `RESEARCH_DIRECTIONS` §3, mais **précisé** par GE-1 : la question devient
« existe-t-il, dans `O(Γ^{6,22})`, une isométrie *non bloc-diagonale* envoyant la racine `e − f` de
`U ⊂ T₇` sur la racine `(1,−1)` de `U ⊂ Γ^{2,2}` en fixant `M₇` ? » Les deux racines ont même
norme (K) ; dans un réseau unimodulaire pair indéfini, les (−2)-vecteurs primitifs forment peu
d'orbites — donc la réponse est *probablement oui* au niveau du réseau, ce qui rend la question
**peu discriminante** : une réponse positive n'apprendrait presque rien. **Évaluation : moins
prometteur que GE-3/GE-5.** À ne pas prioriser.

---

## Synthèse de l'évaluation

| GE | Énoncé | Statut | Verdict |
|---|---|---|---|
| 1 | swap = réflexion de Weyl dans `e − f` (K3 et Narain) | (K) | confirmé |
| 2 | lieu auto-dual = mur de la racine | (K) | confirmé |
| 3 | points singuliers de L₃ = points fixes de Fricke | (K) sur `z(h)` ; (E)+(N)+(L) pour le lien modulaire | **confirmé — résultat central** |
| 4 | hauteur dual-scale, minimum à l'auto-dual | (K), via LeanMaster | confirmé (identité ; pas de dynamique) |
| 5 | `4 ∣ s₇(n)` via `θ² ≡ 1 mod 4` | (C) esquisse | **à attaquer en premier** |
| 6 | une seule ℤ/2 dans `O(Γ^{6,22})` | (C), Tier C | peu discriminant |

**Ce que l'intuition a produit de solide :** un remplacement exact de la lecture Kodaira rétractée
(GE-3), l'unification swap/réflexion des deux côtés (GE-1), et l'usage *réel* de deux théorèmes
LeanMaster (`reflection_*`, `circle_effective_scale_ge_two`).
**Ce qu'elle n'a pas produit :** de la physique. Tout ce qui est (K) porte sur des matrices
entières, une application rationnelle et une inégalité réelle.

**Suite proposée.** (1) GE-5 : vérifier l'esquisse (`θ − 1 ∈ 2qℤ[[q]]` est élémentaire :
`(a,b) ↦ (−a,−b)` est sans point fixe hors de l'origine). (2) Porter GE-3 dans le papier (§8),
avec les statuts ci-dessus — décision T0. (3) D4 de `RESEARCH_DIRECTIONS` : l'involution conjuguée
`[[7,4],[−14,−7]]` comme isométrie explicite de `U ⊕ ⟨14⟩`, pour rendre (K) le second point fixe
côté réseau.

Portes du dépôt après intégration : `lake build` 3720 jobs / 0 erreur / 0 `sorry` ; verrou des
énoncés OK (386 déclarations, aucun énoncé existant modifié) ; audit 238 théorèmes, les 3 mêmes sur
les deux axiomes enregistrés.

---

Generated-by: Claude Fable 5.1, session Stream 1 du 2026-09-20 |
Verified-by: (K) — noyau Lean (`Agora/Geometry/SelfDual.lean`, axiomes standard seulement) ;
(E)/(N) — `scripts/check_selfdual_points_s7.py`, PASS(40) avec contrôle négatif, mpmath 40 chiffres ;
GE-5 et GE-6 **non vérifiés** et étiquetés (C) |
Reviewed-by: T0 **N**. GE-3 dans le manuscrit et tout usage de GE-6 demandent une décision T0.
