# VIGIL_BA_Proj.md

Ce qui est vrai en permanence de `armandld/BA_Proj`. L'état du jour est dans
le dernier commentaire de la PR ouverte ; la méthode est dans `VIGIL.md`.
Ici, ni l'un ni l'autre : seulement les **faits de ce dépôt**.

## Périmètre

    FOCUS = ["armandld/BA_Proj"]     # tout le dépôt

`src/` **n'est pas fini**, `study/` n'a jamais été commencé.

L'ordre ne vient pas d'un répertoire. Il vient des documents.

## L'ordre du travail — sans exception

1. **Lire les six documents et le fil de la PR ouverte au début de chaque
   passe.** Priorité absolue sur tout le reste.
2. **Les entrées ouvertes de `DEFAUTS.md`** passent avant tout terrain neuf.
3. **Finir le module en cours.** On ne quitte pas un module qui porte un
   défaut ouvert pour en ouvrir un autre : le fermer maintenant coûte moins
   cher que le retrouver dans trois semaines, contexte perdu.
4. **Terrain neuf seulement quand rien n'est ouvert** sur le module courant.
5. **Une trouvaille dans un module « déjà audité » le rouvre**, et cette
   réouverture passe avant le terrain neuf.

## Ce que « audité » veut dire ici

Un module n'est pas audité parce que ses fonctions ont été lues. Il l'est
quand un test emprunte **chacune de ses configurations réelles**.

Les configurations rapides de la suite n'empruntent qu'un côté de chaque axe.
À `max_depth = 1`, le balayage traite `depth = 0` puis s'arrête : le chemin
borné n'est jamais exécuté. Un millier de tests verts ne dit rien du code
qu'aucun d'eux ne traverse.

Les axes de ce dépôt, à parcourir des deux côtés :

| axe | les deux valeurs |
|---|---|
| profondeur AMR | `depth = 0` **et** `depth > 0` |
| bord du patch | périodique **et** borné — deux constructeurs d'Hamiltonien distincts |
| bras | quantique **et** `classical_only` |
| backend | `state_vector` **et** échantillonné |
| warm start | absent **et** présent |
| Hamiltonien | non nul **et** nul |
| optimiseur | COBYLA **et** les autres méthodes autorisées |

Quand un module est déclaré fini, écrire **quels axes ont été empruntés**.
« Vérifié et trouvé sain » sans cette liste ne vaut rien.

**Les fixtures de `tests/quantum/` sont à portée module et coûteuses** :
leurs imports s'exécutent au *setup*, pas à la collecte. Une réorganisation
de fichiers s'y vérifie en lançant la suite, jamais en la collectant — six
tests sont morts deux commits durant sans qu'aucune collecte ne le signale.
`tests/test_suite_integrity.py` couvre ce cas depuis.

## Numéros de défaut — à réserver avant d'écrire

Le registre est la table « Les N défauts corrigés » en tête de
`docs/RESULTS.md`. Les numéros sont **globaux et uniques**.

Avant d'en prendre un :

    git fetch --all --prune
    git log --oneline --all -- docs/RESULTS.md | head -5
    grep -o '^| D-[0-9]*' docs/RESULTS.md | sort -t- -k2 -n | tail -1

Prendre le suivant, et **pousser la ligne de registre avant d'écrire le
reste**. Deux collisions en une journée : D-18 désigne deux défauts
différents selon l'endroit du fichier, et D-28 a été pris deux fois en
parallèle. Un numéro n'est pas un identifiant s'il faut deviner qui l'a.

Si le numéro visé est déjà pris à la relecture : renuméroter **le sien**,
jamais celui qui est déjà publié dans un commentaire de PR.

## Branches

Le travail de USER sur ce dépôt est en cours et rebasé souvent : un push sur
sa branche le force à rebaser sur toi. Ouvrir sa propre branche depuis la
plus récente, et la proposer.

## Les six documents — où écrire quoi

| document | contenu | ce qu'on n'y met **pas** |
|---|---|---|
| `PLAN_PREPRINT.md` | objectif, hypothèses, ce qu'on peut prouver ou non | ni défaut, ni mesure |
| `DEFAUTS.md` | où ça **bloque**, uniquement | ce qui est corrigé |
| `COUVERTURE.md` | ce qui est **testé**, comment, pourquoi | des résultats scientifiques |
| `RESULTS.md` | ce qui est **accompli** + la commande pour le refaire | des blocages |
| `EVALUATION.md` | ce qui, dans RESULTS, est **exploitable** | de nouvelles mesures |
| `CODE_REVIEW.md` | note de relecture | tout le reste |

Un défaut corrigé sort de `DEFAUTS.md` et entre dans `RESULTS.md` : c'est un
résultat, pas un blocage.

**Les nombres de `docs/archive/` sont obsolètes.** Ne rien en citer.

## Faits du dépôt

Ce ne sont pas des règles — ce sont des propriétés mesurées, qu'il faut
connaître avant de conclure quoi que ce soit.

**Deux mappeurs, non interchangeables.** La boucle fermée tourne sur
`PhysicalMapper` (v1, entraîné, **dimensionnel**) ; `study/` sur
`PhysicalMapperV2` (sans paramètre, **adimensionnel** — ν, η et dx n'y
entrent pas). Tout verdict doit dire lequel l'a produit.

**Convention d'axes.** `grid.py` fait foi : `indexing='ij'`, `AXIS_X = 0`,
`AXIS_Y = 1`. Tout rotationnel écrit à la main avec un axe numérique nu est
un défaut ; `tests/study/test_no_private_curl_survives.py` fait échouer la
suite dessus.

**Le bras QAOA n'est pas déterministe.** Dispersion 1,79e−1 à 3,61e−1 sur 45
paires d'appels identiques ; auto-corrélation de rang médiane 0,933. Les
**valeurs** bougent, le **classement** tient : une conclusion fondée sur un
ordre est robuste, une conclusion fondée sur une valeur ne l'est pas.

**`g_strain + g_rot ≡ 1`** par identité algébrique : les termes ZZ et ZZZZ
partitionnent un unique scalaire d'Okubo-Weiss. Ce ne sont pas deux
détecteurs indépendants, et `kappa` ne pilote qu'un degré de liberté.

**La couche de coût du QAOA est diagonale** : γ seul ne déplace aucune
probabilité de mesure (4,4e−16). Seul le mixeur agit, borné à
`π/(4·reps) = 0,393 rad`.

## Ce qu'on ne corrige pas

`study/pipeline/dns_validation.py` est gelé : ses artefacts sont publiés. Les
versions corrigées vivent dans `dns_extension`. Une correction y a déjà été
annulée après qu'un test a rappelé la décision.

## Les pièges de `VIGIL.md`, tels qu'ils se sont produits ici

La règle est dans `VIGIL.md` ; voici où elle a mordu, avec ses nombres. Ces
instances valent avertissement : elles se reproduiront dans `study/`.

| règle | l'instance ici |
|---|---|
| opérateur assorti | la divergence de B mesurée au spectral : 9,5e−02, indistinguable du bruit ; mesurée au FD4 du second membre : **4,63e−07 contre 1,00e−14**, huit ordres |
| … et contre soi | une perturbation dérivée analytiquement paraissait fausse à 2,1e−05 — c'était la **mesure** qui l'était, pas la correction |
| champ qui ne sépare pas | Taylor-Green : deux conventions de rotationnel **opposées** rendent la même enstrophie |
| balayage vide | 3 commandes sur 22 d'un registre ne sélectionnaient aucun test — dans le fichier censé détecter ce piège |
| seuil périmé | un contraste asserti à 2σ variait d'un facteur **3,5** entre deux exécutions ; le test a été déplacé sur le coefficient de plaquette, déterministe (0,0553 → 1,2545, ×22,7) |
| test qui lit le source | trois tests cassés par des changements **voulus**, sans qu'aucun défaut n'existe |
| test qui vérifie que l'appel passe | `assert len(params) == 4` passait alors que Powell avait perdu la borne sur son mixeur |
| avertissement invisible | `Method Powell cannot handle constraints`, sur stderr, noyé dans des centaines d'essais |
| transformation deux fois | `_resize_padded_maxpool` ajoute le halo, l'appelant le redemandait : `(6,6)` contre `(4,4)`, deux moitiés d'Hamiltonien sur deux grilles — D-37 |
| retirer une couche | D-26 et D-27 n'ont été vus qu'en **cessant** de projeter B ; aucune des quatre questions ne les aurait trouvés |

## Étalonnage

Sur ~10 500 lignes de `src/` : **38 défauts**, dont **2 trouvés dans du code
déjà déclaré audité**, dont **1 présent depuis le premier commit et
bloquant**. Et 164 des 180 nombres publiés inchangés.

**La majorité du code est juste.** Un rapport d'un défaut par fonction se
trompe — un faux positif coûte plus cher qu'un défaut manqué, parce qu'il
envoie corriger du code correct.

Quand le doute porte sur défaut *contre* choix de conception : mesurer,
documenter, **ne pas corriger**, demander.
