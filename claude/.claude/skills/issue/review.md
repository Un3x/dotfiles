# Reviewing an issue

Input: an issue (id, url or draft file), its sources, and from round two the triage file: a finding answered or rejected is not raised again unless the draft changed what it rests on. A round after `prête` reviews the change alone. It reports; the author fixes. A reviewer model is weakest at « is this needed, is this right? »: it flags, the user decides.

## 1. Read the sources

The issue, its comments (a newer comment the description does not reflect is a contradiction), what it links, the project's recorded decisions. Look at the design: images opened, the mockup run when it can be; a screen criterion that differs from it unsaid is a contradiction. A source named but not linked is PAS CLAIR: the reader cannot reach it either. A fact is checked in a source before it becomes a finding: a wrong finding costs a round.

## 2. Contradictions

Two statements that cannot both hold, inside the issue (title, criteria, exclusions, questions) or against its sources (brief, parent, mockup, decision). BLOQUANT, both sides quoted. Criteria that follow an open question's proposed answer do not contradict it.

## 3. The blind reader

Having read the sources, the reviewer cannot get lost where the PO does. A fresh subagent gets the title and the top, nothing else, no tool:

> Tu es la PO : tu connais le site et ses écrans, pas le code. Tu n'as que ce texte : n'ouvre aucun lien, n'utilise aucun outil. Lis-le une fois. 1. Redis avec tes mots, en trois phrases au plus, ce qui se passe aujourd'hui et ce qui doit changer. 2. Cite chaque phrase que tu ne pourrais pas expliquer à un collègue sans deviner, et ce que tu as deviné. 3. Le titre décrit-il un mauvais comportement ou une nouvelle fonctionnalité, et lequel ? 4. Quelles phrases pourrais-tu retirer sans rien perdre de ce que tu dois décider ou vérifier ?

- BLOQUANT: a restatement that differs from the issue; a guess on what changes or on the first sentence; a title read the wrong way; a bug in the story's shape, or two wrong behaviours in one bug.
- PAS CLAIR: another guess that changes what gets built or checked; each sentence it could remove (cut it).
- A fact missing from the top is a finding only when the PO needs it to decide or check; one for the dev goes to `/plan`.
- Not reported: a guess on a detail that changes neither.

Then check against [`../issue-template.md`](../issue-template.md): the rules there are the smells (a dev word, a criterion with two checks, a vague word, an exclusion without its reason, a hidden question, the top past its goal).

## 4. The other readers

- **Dev**: can estimate from the top and the links; each decision said as what was decided. Code detail below the line, a screen detail in the expected behaviour, or a decision that repeats the top or says who, when or how, is PAS CLAIR.
- **Tester and `/ship`**: the scope is bounded; each criterion is a check they can run; each user the change touches has one for their usual path; the bug's steps reproduce from a clean account; nothing needed sits outside the repo unsaid.
- **The requester**: they recognise their request.

An edge case the rule or a decision answers is `/plan`'s, not a finding; one the PO would answer differently is a hidden question, BLOQUANT.

## Output

In the issue's language. About five findings, the ones that change what gets built or checked; repeats are one finding. Each says what is wrong, never the rewrite. `prête` when nothing is BLOQUANT; an empty section is left out.

```
## Revue d'issue : [ID — titre, lien complet] — [prête | à reprendre]

### Lecture à l'aveugle
[sa reformulation] · deviné : « … » · à retirer : « … »

### BLOQUANT
**1. [Ce qu'un lecteur ne peut pas faire ou comprendre]**
Où : « [citation] » ; « [l'autre côté] »

### PAS CLAIR
**1. ...**
Où : « ... »

### Questions
**Question 1**
[contexte]
**[Décision nécessaire ?]**
> **Proposé :** [réponse]
```
