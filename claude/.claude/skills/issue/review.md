# Reviewing an issue

Read by the `issue` skill's Review. The input is an issue (id, url, or a draft file), the sources it rests on, and on a later round the earlier reports with what the writer did with each finding: a finding already answered or rejected is not raised again, unless the draft changed what it rests on. A round after `prête` reviews the change alone. The review checks that every reader understands it on one read and that nothing in it, or around it, says otherwise. It reports; the author fixes.

A reviewer model misses much of what an expert finds and is weakest at « is this needed, is this right? ». So it flags, and the user decides what the issue should say.

## 1. Read the sources

The issue and its comments, then everything it links that carries the ask: the parent issue, the brief, the design ticket and its comments, the decision cited (a committee, a meeting note). A comment newer than the description is where a PO's answer usually sits: an answer the description does not reflect is a contradiction. Read an issue, [`../tracker.md`](../tracker.md). A design is looked at: its images opened, the mockup run when it can be; a screen criterion that differs from it without saying so is a contradiction. A source it names but does not link is a finding (PAS CLAIR): the reader cannot reach it either. Decisions taken outside the tracker live in the notes the writer passes, wherever the project records them (a status file, a memory): read them before calling something unsettled. A fact about the code or a decision is checked (the code, `git log`, the notes) before it becomes a finding, and a fact the reviewer only remembers, with no source opened, is not checked: a wrong finding gets written into the draft and costs a round.

## 2. Contradictions

Two statements that cannot both hold. Inside the issue: title against criteria, a criterion against an out-of-scope line, a criterion against a « choice made » or a question below it, the why against what the criteria deliver. Against the sources: the issue against its brief, its parent, the design, the decision it cites. Each is BLOQUANT, both sides quoted. Criteria under a heading saying they follow the proposed answer do not contradict the open question. Nor does the title of someone else's issue once the addition asks its author for a new one, with a proposed title.

## 3. The PO reads it once

Having read the sources, the reviewer cannot get lost where the PO does. So a fresh subagent, the blind reader, gets the title and the top above the line, nothing else: no source, no link opened, no tool. Prompt:

> Tu es la PO : tu connais le site et ses écrans, pas le code. Tu n'as que ce texte : n'ouvre aucun lien, n'utilise aucun outil. Lis-le une fois. 1. Redis avec tes mots, en trois phrases au plus, ce qui se passe aujourd'hui et ce qui doit changer. 2. Cite chaque phrase que tu ne pourrais pas expliquer à un collègue sans deviner, et ce que tu as deviné. 3. Le titre décrit-il le problème ou le résultat attendu ?

Each guess is a finding, quoted with what was guessed: BLOQUANT when it is on what changes or on the first sentence of the why, or when the title reads the wrong way; PAS CLAIR otherwise. A restatement that differs from the issue is BLOQUANT. Then answer the four questions from the blind reader's restatement, or write where the read broke:

1. What will change for the user?
2. Why now, and who asked?
3. What do I have to decide, and what is proposed?
4. How will I check that it is done?

A question with no answer is BLOQUANT, and so is a read that breaks: a title that names the defect or the task instead of what will be true, a question that assumes its answer. Then the smells that slow the read, each PAS CLAIR:

- a why a twelve-year-old who has never seen the product would not follow: long sentences, several ideas in one, abstract words where an example would do;
- a dev word above the line, unexplained;
- a criterion that checks several things (the fix is fewer criteria, not longer ones), or that only the author can check;
- a vague word that hides a choice: « correctement », « si besoin », « etc. », « gérer », a « it » with two possible referents;
- an out-of-scope line without its reason, or one nobody would have expected;
- a question hidden in a sentence (no « ? », no proposed answer, no one named to decide);
- a why that needs a link opened to make sense;
- the top running past one screen.

## 4. The other readers

Each reads the whole issue. A gap that stops the reader is BLOQUANT, one that slows them PAS CLAIR. The code is read only to check a fact the issue states; how to build it is the plan's question, never a finding here. An edge case the rule or a recorded decision answers is not a finding, and a missing one goes below the line, PAS CLAIR at most. One the PO would answer differently from the rule, or one the writer answered below the line with neither behind it, is a hidden question: BLOQUANT. Each criterion added makes the issue harder for the PO to read.

- **Dev**: can estimate it; the constraints and the external dependencies are named, with who confirms them; a size past the appetite, or past the priority when none is set, is a Question, never BLOQUANT.
- **Tester**: each criterion has a starting state, an action and a visible result; each user the change touches has a criterion for their usual path; the bug's steps reproduce from a clean account.
- **Agent running `/ship`**: the scope is bounded; each criterion is a check it can run (a test, a drive of the app); the files or patterns are pointed to when known; nothing it needs sits outside the repo without a named way to get it.
- **The requester**, when the ask came from outside: they would recognise their request in the why and the criteria.

## Output

In the issue's language, headings translated. Each finding explains first, then quotes the issue on a `Where:` line; it says what is wrong, never the rewrite.

```
## Revue d'issue : [ISSUE-ID — titre, lien complet] — [prête | à reprendre]

### La lecture de la PO
1. Ce qui change : [réponse] | perdue à : « [citation] »
2. Pourquoi maintenant : ...
3. À trancher : ...
4. Comment vérifier : ...

### BLOQUANT
**1. [Ce qu'un lecteur ne peut pas faire ou comprendre, en une phrase]**
[Qui est arrêté, et pourquoi]
Où : « [citation] » ; « [l'autre côté, pour une contradiction] »

### PAS CLAIR
**1. ...**
Où : « ... »

### Questions
1. [Une décision dont l'issue a besoin, finie par « ? »] → proposé : [réponse]
```

The report is read by the user, who passes it on as is: about five findings in all, the ones that change what gets built or checked, and about five questions, none that the requester's text or a recorded decision already answers. Smells that repeat are one finding with their quotes. A section with nothing in it is left out. `prête` when nothing is BLOQUANT.
