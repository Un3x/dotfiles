# What an issue holds

Read at step 2 of Write, and by Review as the shape to check against. The issue is written in French on the `linear-opi` workspace; elsewhere, in the language the project's issues already use, headings translated.

## Types

| Type | Title prefix | When |
| --- | --- | --- |
| Story | `US —` | a user can see or do something new, or stops seeing something |
| Technical task | `TS —` | nothing changes on screen, or a change the user never asked for (a removal, a migration, a fix in the setup) |
| Bug | `Bug —` | something that worked, or should work, does not |

The title says what will be true once it is done, in the user's words: « Voir les données intégrées par une solution depuis sa carte », not the cause (« sprockets incompatible avec json 3 ») nor the task (« Lire le DSN depuis les credentials »).

## Shape

```
Pourquoi
[Who, what they cannot do today, what it costs them. Two or three sentences
that stand without opening a link. The request's source: who asked, or the
decision, with its link.]

À trancher                                      (only while open)
1. [The question, ending with « ? »] → proposé : [the answer we recommend]
   Décide : [who]

Critères
- Étant donné [the starting state] / Quand [the action] / Alors [what the
  user sees, or what the data holds]
- ...

Reproduire                                      (Bug only)
1. [step, as a role, on a screen]
Résultat : [what happens]   Attendu : [what should]

Hors périmètre                                  (only what a reader would expect)
- [what stays as it is] — [why, or the issue that handles it]

────────
Pour le dev
[Appétit : what the outcome is worth (a morning, a day, a week), when
/challenge set one: /plan sizes from it.
Links: the design, the PR of the mockup, the related tickets.
Constraints found while investigating, with the measure behind them.
Where in the code, when known: files and existing patterns to follow.
External dependencies: what must be true outside the repo (a host, a
partner, a config) and who confirms it.]
```

## Rules

- **Simplicity first.** The why is told so that a twelve-year-old who has never seen the product follows it: short sentences, one idea each, everyday words, an example rather than a rule. When it reads simple, it is understood.
- **The top is for the PO and holds on one read.** No dev word above the line (endpoint, payload, modal, a class or file name, a size in bytes): the app's own words, the ones on the screen. A dev word the PO needs is explained in the sentence that uses it.
- **One criterion, one check.** Someone can verify it by using the app or reading the data, without asking the author. A list of eight elements in one line is eight lines, or a link to the design that shows them. « Works well » is not a criterion.
- **No how above the line.** The issue says what must be true; the plan finds how. Below the line it points to where (files, patterns, constraints), never to the steps: those are the plan, attached to the issue as a file.
- **Every exclusion carries its reason.** An « Out of scope » line nobody would have expected is a fence for the agent, and the PO reads it as a riddle: leave it out, or say what it prevents.
- **A question to the PO is a question,** numbered, with its proposed answer and who decides, before the criteria it changes. An issue with an open question is not ready for `/plan`.
- **Nothing contradicts anything else**: the criteria, the decisions, the out-of-scope lines and the linked brief or parent say the same thing. When a choice changes a criterion, the criterion is rewritten.
