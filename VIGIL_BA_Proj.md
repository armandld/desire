# VIGIL_BA_Proj.md

Fiche de `armandld/BA_Proj` pour 🦉 Vigil. La méthode est dans [VIGIL.md](VIGIL.md) ; ici, ce
qui est propre à ce dépôt.

Q-HAS : cadre hybride quantique-classique d'AMR pour la MHD 2-D. Le dépôt sépare l'**objet
d'étude** (`src/`) du **travail de falsification** (`study/`), organisé par hypothèse.

---

## Où écrire

Les rôles sont disjoints — s'y tenir, sous peine de faire diverger deux sources :

| fichier | contenu |
|---|---|
| `docs/DEFAUTS.md` | **les défauts** : ce qui les a révélés, comment tester s'ils sont encore là |
| `docs/RESULTS.md` | **les résultats** : comment ils ont été obtenus, comment les réobtenir |
| `docs/PLAN_PREPRINT.md` | la structure du manuscrit — **ni défaut, ni mesure** |

`docs/DEFAUTS.md` est le point d'entrée de toute passe : il dit ce qui est corrigé, ce qui est
gelé volontairement, ce qui reste ouvert.

---

## Chemins

**À relire** — le chemin de décision :
`src/Simulation/`, `src/VQA/`, `src/pipeline.py`, `src/hyperparams_loader.py`,
`src/call_vqa_shell.py`, puis `study/`.

**À ne pas relire** : les scripts d'analyse et de visualisation, sauf demande. Beaucoup sont
inutilisés.

**À ne jamais modifier sans autorisation explicite** :
- tout fichier portant la mention d'un gel (`phase 1b reste intouchée`) ;
- `results/hyperparams/` — entrée gelée, seul dossier non reproductible par une commande.

`src/` est l'objet d'étude, pas une dépendance à améliorer : toute modification y est un
changement de comportement scientifique, jamais faite « au passage ».

---

## Deux pièges propres à ce dépôt

**Deux mappeurs, non interchangeables.** La boucle fermée tourne sur `PhysicalMapper` (v1,
entraîné, dimensionnel) ; `study/` sur `PhysicalMapperV2` (sans paramètre, **adimensionnel** —
ν, η et dx n'y entrent pas). Tout verdict doit dire lequel l'a produit.

**L'ordre de la campagne est contraint.** Réoptimiser, puis relancer, puis republier. Les
hyperparamètres actuels optimisent un problème que six corrections ont modifié, et trois d'entre
eux n'ont jamais été échantillonnés par aucune campagne (D-22). Ne lancer aucune campagne longue
avant la réoptimisation : un résultat obtenu dans le désordre est l'optimum d'un autre problème.

---

## État

`src/Simulation/`, `src/VQA/`, `src/pipeline.py` : audités. Le détail vit dans `docs/DEFAUTS.md`,
l'ordre des travaux restants dans le fil de la PR ouverte — lire les deux, ils bougent plus vite
que cette fiche.

Étalonnage de cet audit : 24 défauts sur 10 567 lignes, 12 par la question 4, 20 corrigés et
verrouillés par un test, ~500 tests ajoutés, 164 des 180 nombres publiés inchangés.
