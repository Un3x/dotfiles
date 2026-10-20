# What an issue holds

Read at step 2 of Write, and by Review as the shape to check against. The issue is written in French on the `linear-opi` workspace; elsewhere, in the language the project's issues already use, headings translated.

## Types

| Type | Title prefix | When |
| --- | --- | --- |
| Story | `US —` | a user can see or do something new, or stops seeing something |
| Technical task | `TS —` | nothing changes on screen, or a change the user never asked for (a removal, a migration, a fix in the setup) |
| Bug | `Bug —` | something that worked, or should work, does not |

The title says what will be true once it is done, in the user's words: « Voir les données intégrées par une solution depuis sa carte », not the cause (« sprockets incompatible avec json 3 ») nor the task (« Lire le DSN depuis les credentials »). No negation: « ne la met plus en ligne aussitôt » reads as the defect and the fix at once.

## Shape

```
Pourquoi
[Who, what they do and see in the app today, in order, then what goes wrong
or what they cannot do, and what it costs them. Two or three sentences that
stand without opening a link. The request's source: who asked, or the
decision, with its link.]

À trancher                                      (only while open)
1. [The question, ending with « ? »] → proposé : [the answer we recommend]
   Décide : [who]

Critères                                        (« si la réponse proposée est retenue » while a question is open)
- Étant donné [the starting state] / Quand [the action] / Alors [what the
  user sees, or what the data holds]
- ...

Reproduire                                      (Bug only)
1. [step, as a role, on a screen]
Résultat : [what happens]   Attendu : [what should]

Hors périmètre                                  (the challenge no-gos, and what a reader would expect)
- [what stays as it is] — [why, or the issue that handles it]

────────
Pour le dev
[Appétit : what the outcome is worth (a morning, a day, a week), set by
/challenge or by the PO's answer: /plan sizes from it.
Links: the design, the PR of the mockup, the related tickets.
Constraints found while investigating, with the measure behind them.
Where in the code, when known: files and existing patterns to follow.
Edge cases the tester and the agent need, each with the answer the rule
above or a recorded decision gives; one with no such answer is a question.
External dependencies: what must be true outside the repo (a host, a
partner, a config) and who confirms it.]
```

## Rules

- **Simplicity first.** The why is told so that a twelve-year-old who has never seen the product follows it: short sentences, one idea each, everyday words, an example rather than a rule. When it reads simple, it is understood.
- **The top is for the PO and holds on one read.** No dev word above the line (endpoint, payload, modal, a class or file name, a size in bytes): the app's own words, the ones on the screen. A dev word the PO needs is explained in the sentence that uses it.
- **One criterion, one check; a rule beats the list of its cases.** Someone can verify each criterion by using the app or reading the data, without asking the author; « Works well » is not one. When many cases share an answer, the first criterion states it (« Alors la page montre ce qu'elle montrerait après un rechargement »), one or two more show it, and the other cases go below the line, under the edge cases. A case goes above only when the PO would answer it differently from the rule. When one screen and one check per criterion pull apart, write fewer criteria, never longer ones. Each user the change touches (the visitor, the person who enters the content) keeps a criterion for their usual path: cutting criteria tends to keep the refusals and drop what people do.
- **Show how it works before what breaks.** When the reader needs a mechanism to follow the why (how drafts work, a rule set by another ticket), the why tells it as what the user does and sees, step by step. A link is where it comes from, never the explanation: « une recommandation modifiée attend la publication (SIM-232) » lost the PO at its first line.
- **The mockup is the spec for the screen.** When a design exists, a screen criterion says « comme la maquette » and points to the capture, instead of describing the screen again. A difference from the mockup is a question settled with the user before the issue is posted, never asked of the person who drew it: she answers by repeating her mockup.
- **No how above the line.** The issue says what must be true; the plan finds how. Below the line it points to where (files, patterns, constraints), never to the steps: those are the plan, attached to the issue as a file.
- **Every exclusion carries its reason.** A no-go decided at `/challenge` always goes on the issue, with its reason: `/review` checks the change against it. A fence the writer adds on their own, that nobody would have expected, reads as a riddle to the PO: leave it out, or say what it prevents.
- **A question to the PO is a question,** numbered, with its proposed answer and who decides, before the criteria it changes. An issue with an open question is not ready for `/plan`. A requester's word that is also a word of the product is a question when their examples do not fit the product's sense, with the sense their examples give as the proposed answer: reading it in the product's sense decides for them. A question never reopens what the requester's text, her mockup or a recorded decision already settles: asking again is what makes the PO reread. While it is open, the title says what is true whatever the answer, and the criteria follow the proposed answer under a heading that says so.
- **Size is a question too.** Bigger than it is worth (no appetite, criteria that outgrow a low priority): a question proposes what to cut, or asks for an appetite. Several stories in one: the split is a question, each part named by its title and cut by [`../challenge/slices.md`](../challenge/slices.md), created once the user agreed; Hors périmètre points to them.
- **Nothing contradicts anything else**: the criteria, the decisions, the out-of-scope lines and the linked brief or parent say the same thing. When a choice changes a criterion, the criterion is rewritten.
