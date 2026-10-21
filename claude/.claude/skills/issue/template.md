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
  what they do and see today,         the rule, in the product's word,
  then what they cannot do;           then what does not follow it;
                                      one wrong behaviour per bug
À trancher        (while open)      Reproduire
  1. Question ? → proposé : …          steps ending on « constater que … »
     Décide : …                       Comportement attendu: the rule
                                       that must hold, not the screen
                                    À trancher        (while open)
Critères
Hors périmètre                      Hors périmètre
────────
Pour le dev
  Liens : the mockup, the related tickets, the meeting note.
  Décisions : what was decided outside the tracker and is not already
  above, said as the decision itself.
```

A bug has no Critères: its steps and its expected behaviour are the check. Nothing else below the line: the cause, the files and the edge cases are what `/plan` finds in the code. A decision is its content, never who took it, when, or how; it is there because the dev would otherwise get it wrong, about three.

## Example

SIM-244, after the PO stopped at the first line of its earlier version; the wrong « Masquée » status went to its own bug:

```
Bug — Une donnée utile modifiée est publiée immédiatement

Ce qui ne va pas
Dans l'admin, une modification d'une démarche publiée passe d'abord en
brouillon : le site garde l'ancienne version jusqu'à la publication de la
démarche. Ses recommandations suivent la même règle.

Les données utiles ne respectent pas ce processus et sont immédiatement
publiées après avoir été modifiées.

Reproduire
1. Sur le site, ouvrir la page d'une démarche publiée. Dans la carte d'une
   solution recommandée, repérer une ligne du tableau « Endpoints utiles de
   l'API ».
2. Dans l'admin, ouvrir cette démarche, modifier la description de cette
   donnée utile, enregistrer.
3. Recharger la page sur le site : constater que la nouvelle description est
   déjà en ligne.
Comportement attendu : une donnée utile modifiée attend la publication de sa
démarche, comme toute recommandation.

Hors périmètre
- Supprimer une donnée utile reste immédiat, comme pour une solution recommandée.

────────
Pour le dev
Décisions : une donnée utile n'a plus ses propres boutons « Publier » et
« Masquer ». Les 286 données utiles en ligne aujourd'hui le restent après le
déploiement.
```

## Rules

- **Necessary and sufficient.** The top holds what the PO needs to decide and to check: about five sentences for the why, about three criteria. A finding is fixed by rewording or cutting, never by adding a sentence: a loop that adds one per finding doubled SIM-244 in eight rounds. Each thing is said once: a section that repeats another is cut. The issue says what, never who, when or how.
- **Simple.** Written as one says it to a colleague. Short sentences, one idea each, the words on the screen, an example rather than a rule. No dev word above the line (endpoint, modal, a class name); one the PO needs is explained where it is used. An action names its object, in everyday words: « la publication de la démarche », never « la publication » alone. A button's name belongs in the steps to follow, not in the why or the expected behaviour.
- **Show how it works before what breaks.** A mechanism the reader needs is named with the product's word, in one sentence (« la modification passe d'abord en brouillon »), then what does not follow it, said in full (« ne respectent pas ce processus et sont immédiatement publiées »), never with a pronoun that points back (« y échappent »), and nothing on why. A second wrong behaviour is its own bug, linked: two in one issue blur both and their steps. The expected behaviour is that rule restored, in a sentence or two; what it implies on a screen (a button gone, a badge) is a decision below the line. A link is a source, never the explanation.
- **The mockup is the spec for the screen.** A screen criterion says « comme la maquette » with the capture, and nothing more: prose only for what a capture cannot show (a click, a sort, an empty case). The requester and the mockup's author go in Liens, not above. A difference from it is settled with the user before posting, never asked of the person who drew it.
- **A criterion is one check** anyone can run in the app or the data. One sentence; « Étant donné / Quand / Alors » only when the starting state is not obvious. A rule beats its list of cases; a case goes above only when the PO would answer it differently. Each user the change touches keeps a criterion for their usual path.
- **A question to the PO** is numbered, with a proposed answer and who decides, before the criteria it changes; while open, the criteria say « si la réponse proposée est retenue ». It never assumes its answer, and never reopens what the requester's text, her mockup or a recorded decision settles. A requester's word the product uses differently is a question.
- **Every exclusion carries its reason.** Only what the PO could expect to be included; often there is none. A `/challenge` no-go always goes on the issue.
- **Size is a question**: too big for its priority, propose what to cut; several stories, propose the split ([`../challenge/slices.md`](../challenge/slices.md)).
- **Nothing contradicts anything else**: title, criteria, exclusions, decisions and the linked sources say the same thing.
