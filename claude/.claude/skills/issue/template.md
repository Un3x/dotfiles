# What an issue holds

Read at step 2 of Write, and by Review. French on the `linear-opi` workspace; elsewhere, the language the project's issues use, headings translated.

## Types and titles

| Type | Prefix | When | Title says |
| --- | --- | --- | --- |
| Story | `US —` | a user sees or does something new, or stops seeing something | what will be true once done |
| Technical task | `TS —` | nothing changes on screen, or a change nobody asked for | what will be true once done |
| Bug | `Bug —` | something that should work does not | the wrong behaviour, as the user sees it |

In the user's words, never the cause or the task, and without negation: « ne la met plus en ligne aussitôt » reads as the defect and the fix at once.

## Shapes

```
Story, task                         Bug
───────────                         ───
Pourquoi                            Ce qui ne va pas
  what they do and see today,         what the user does and sees, up to
  then what they cannot do;          the wrong behaviour; who found it
  who asked
À trancher        (while open)      Reproduire
  1. Question ? → proposé : …          steps · Résultat · Attendu
     Décide : …                     À trancher        (while open)
Critères                            Ce qui doit changer
Hors périmètre                      Hors périmètre
────────
Pour le dev
  Liens : the mockup, the related tickets, the meeting note.
  Décisions : decided outside the tracker, a measure taken in production,
  what must be true outside the repo and who confirms it.
```

Nothing else below the line: the cause, the files and the edge cases are what `/plan` finds in the code.

## Example

SIM-244, after the PO stopped at the first line of its earlier version:

```
Bug — Une donnée utile modifiée part en ligne sans attendre sa démarche

Ce qui ne va pas
Sur une démarche publiée, une modification attend le clic sur « Publier » : le
site garde l'ancienne version en attendant. Les données utiles (tableau
« Endpoints utiles de l'API ») échappent à cette règle : une description
corrigée part en ligne dès « Enregistrer ». Et l'admin les marque toutes
« Masquée », alors qu'elles sont sur le site.

Reproduire
1. Dans l'admin, ouvrir une démarche publiée, modifier la description d'une
   donnée utile, enregistrer.
2. Ouvrir la démarche sur le site.
Résultat : la nouvelle description est en ligne, l'admin indique « Masquée ».
Attendu : l'ancienne reste en ligne jusqu'au clic sur « Publier », l'admin
indique « Publiée » avec un badge « Brouillon ».

Ce qui doit changer
- Une donnée utile modifiée part en ligne au clic sur « Publier » de la
  démarche, pas avant.
- L'admin la marque « Publiée » si le visiteur la voit, « Masquée » sinon, avec
  un badge « Brouillon » quand une modification attend.
- Son écran perd ses boutons « Publier » et « Masquer ».
- Aucune donnée utile ne disparaît du site.

Hors périmètre
- Supprimer une donnée utile reste immédiat, comme pour une solution recommandée.
```

## Rules

- **Necessary and sufficient.** The top holds what the PO needs to decide and to check: about five sentences for the why, about three criteria. A finding is fixed by rewording or cutting, never by adding a sentence: a loop that adds one per finding doubled SIM-244 in eight rounds.
- **Simple.** Short sentences, one idea each, the words on the screen, an example rather than a rule. No dev word above the line (endpoint, modal, a class name); one the PO needs is explained where it is used. An action names its object: « le clic sur « Publier » de la démarche », never « la publication ».
- **Show how it works before what breaks.** A mechanism the reader needs (how drafts work) is told as what the user does and sees. A link is a source, never the explanation.
- **The mockup is the spec for the screen.** A screen criterion says « comme la maquette » with the capture. A difference from it is settled with the user before posting, never asked of the person who drew it.
- **A criterion is one check** anyone can run in the app or the data. One sentence; « Étant donné / Quand / Alors » only when the starting state is not obvious. A rule beats its list of cases; a case goes above only when the PO would answer it differently. Each user the change touches keeps a criterion for their usual path.
- **A question to the PO** is numbered, with a proposed answer and who decides, before the criteria it changes; while open, the criteria say « si la réponse proposée est retenue ». It never assumes its answer, and never reopens what the requester's text, her mockup or a recorded decision settles. A requester's word the product uses differently is a question.
- **Every exclusion carries its reason.** A `/challenge` no-go always goes on the issue. A fence nobody expected is left out.
- **Size is a question**: too big for its priority, propose what to cut; several stories, propose the split ([`../challenge/slices.md`](../challenge/slices.md)).
- **Nothing contradicts anything else**: title, criteria, exclusions, decisions and the linked sources say the same thing.
