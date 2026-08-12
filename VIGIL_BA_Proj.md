# VIGIL_BA_Proj.md

Ce qui est vrai en permanence de `armandld/BA_Proj`. L'état du jour est
dans le dernier commentaire de la PR ouverte — ici, rien qui change d'une
semaine à l'autre.

## FOCUS

    FOCUS = ["armandld/BA_Proj:study/"]

`src/` a été audité par contrat de bout en bout : 36 défauts trouvés, 34
corrigés, chacun mesuré avant/après et verrouillé par un test. Le rester
d'y revenir est de re-trouver ce qui est déjà corrigé — c'est arrivé le
12 août : une passe entière sur `hyperparams_loader.py` a conclu « le
défaut et son correctif existaient déjà ».

`study/` n'a **jamais** été audité par contrat. C'est là qu'est le travail.
Ordre par risque décroissant : `pipeline/`, `h3_representation/`,
`h0_selection/` + `closed_loop/`, `h2b_prediction/` + `h4_transfer/`,
`common/`.

Toucher à `src/` reste permis quand `study/` en révèle un défaut — mais on
n'y va pas *chercher*.

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

Ne jamais pousser sur une branche portant les commits de quelqu'un d'autre
— y compris `claude/*` ouverte par USER ou par un autre agent. Ouvrir sa
propre branche depuis la plus récente, et la proposer.

Le travail de USER sur ce dépôt est en cours et rebasé souvent : un push
sur sa branche le force à rebaser sur toi.

## Les six documents — où écrire quoi

| document | contenu | ce qu'on n'y met **pas** |
|---|---|---|
| `PLAN_PREPRINT.md` | objectif, hypothèses, ce qu'on peut prouver ou non | ni défaut, ni mesure |
| `DEFAUTS.md` | où ça **bloque**, uniquement | ce qui est corrigé |
| `COUVERTURE.md` | ce qui est **testé**, comment, pourquoi | des résultats scientifiques |
| `RESULTS.md` | ce qui est **accompli** + la commande pour le refaire | des blocages |
| `EVALUATION.md` | ce qui, dans RESULTS, est **exploitable** | de nouvelles mesures |
| `CODE_REVIEW.md` | note de relecture | tout le reste |

Un défaut corrigé sort de `DEFAUTS.md` et entre dans `RESULTS.md` : c'est
un résultat, pas un blocage. Un défaut sans mesure est une suspicion ; un
défaut sans commande de vérification n'entre nulle part.

**Les nombres de `docs/archive/` sont obsolètes.** Ne rien en citer.

## Pièges propres à ce dépôt

**L'opérateur non assorti.** Une grandeur discrète n'a de valeur que
relativement à l'opérateur qui la calcule. Mesurer la divergence d'un champ
avec un stencil différent de celui qui l'a produit mesure l'écart entre
deux opérateurs, pas le champ. **Cinq occurrences.** Une fois, un défaut de
huit ordres est resté invisible ; une autre, une correction *correcte* a
paru fausse (2,1e−05 au lieu de 1e−16).

**Deux mappeurs, non interchangeables.** La boucle fermée tourne sur
`PhysicalMapper` (v1, entraîné, **dimensionnel**) ; `study/` sur
`PhysicalMapperV2` (sans paramètre, **adimensionnel** — ν, η et dx n'y
entrent pas). Tout verdict doit dire lequel l'a produit.

**Convention d'axes.** `grid.py` fait foi : `indexing='ij'`, `AXIS_X = 0`,
`AXIS_Y = 1`. Tout rotationnel écrit à la main avec un axe numérique nu est
un défaut ; `tests/study/test_no_private_curl_survives.py` fait échouer la
suite dessus.

**Le champ qui ne sépare pas.** Sur Taylor-Green, deux conventions de
rotationnel *opposées* rendent la même enstrophie. Avant d'écrire un
test : *sur quelle entrée les deux hypothèses divergent-elles ?*

**Le balayage vide.** Un `pytest -k` dont le motif ne correspond à rien
sort en vert. Vérifier le **nombre de tests sélectionnés**, pas le code de
retour. Trois commandes sur vingt-deux d'un registre ne sélectionnaient
rien — dans le fichier même censé détecter ce piège.

**Le seuil périmé.** Un test calibré sur la mesure du jour cesse de mesurer
au premier changement légitime. Il ne s'actualise pas : il se **remesure**,
ancienne et nouvelle valeur écrites. Si la grandeur s'avère non
reproductible, changer de **grandeur**, pas de seuil.

**Le test qui lit une chaîne de caractères.** Chercher
`'HyperParams["gamma_hydro"] = 2.0'` dans un source teste la mise en forme,
pas le comportement. Deux tests de ce type ont cassé sur un changement
voulu. Interroger le module, pas son texte.

**Le bras QAOA n'est pas déterministe.** Dispersion 1,79e−1 à 3,61e−1 sur
45 paires d'appels identiques ; auto-corrélation de rang médiane 0,933. Les
**valeurs** bougent, le **classement** tient. Avant de conclure sur un
écart : mesurer la variance de la mesure elle-même. Deux estimations du même
contraste ont différé d'un facteur 3,5.

**Retirer une couche révèle ce qu'elle cachait.** D-26 et D-27 n'ont été
vus qu'en cessant de projeter B. Aucune des quatre questions ne les aurait
trouvés.

## Ce qu'on ne corrige pas

`study/pipeline/dns_validation.py` est gelé : ses artefacts sont publiés.
Les versions corrigées vivent dans `dns_extension`. Une correction y a déjà
été annulée après qu'un test a rappelé la décision.

## Étalonnage

Sur ~10 500 lignes de `src/` : 36 défauts, et 164 des 180 nombres publiés
inchangés. **La majorité du code est juste.** Un rapport d'un défaut par
fonction se trompe — un faux positif coûte plus cher qu'un défaut manqué,
parce qu'il envoie corriger du code correct.

Quand le doute porte sur défaut *contre* choix de conception : mesurer,
documenter, **ne pas corriger**, demander.
