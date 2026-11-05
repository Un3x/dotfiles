# Output format

The review is one list of findings, every one proven (`SKILL.md` § Rules), ranked by severity, most severe first. It goes on GitHub as one review, the same shape whether it was asked for or triggered automatically: the automatic one only keeps the `critical` and `important` findings. Its reader is the author or the next agent, who finds the fix on their own.

A finding lives where its reader meets it:

- **Summary findings**, the high-level ones: `ask`, `design`, `rule`, `pre-existing`. They go in the review's body.
- **Line findings**, the code-level ones: `bug`, `test`, `simplicity`, `readability`. Each goes as a comment on its first `Where:` line; one whose line is not in the diff goes in the body with the summary findings.

Each says what is wrong. It may end with a direction in a few plain words (when there are two ways, joined by « or ») (« Deleting the rules from there would solve it », « Inverting the dependency would comply with X »), never code: a way to go, not the fix. A visual direction, pointing to a screen or a pattern the app already shows (« comme sur les pages « modifier » »), comes with a capture of it, attached with the `gh-image` skill.

## Severity

- **critical**: breaks prod, data or security.
- **important**: a user will hit it, or the next feature of the same kind will pay for it. An `ask` finding for a missing or deviating line, or an extra that crosses a stated limit, is at least important.
- **minor**: debt, simplicity, a missing test, a detail.

A missing announcement (changelog, release note, doc) ranks by what it announces: a change in behaviour is important, information only is minor.

## Type

One of: `ask` (a line of the ask missing, deviating or unclear, or an extra that crosses a limit), `bug`, `test`, `design`, `simplicity`, `readability`, `rule` (a written rule the diff breaks), `pre-existing` (a bug in code the diff did not change, left out of the verdict).

## Constat

The **wait-what** pitch of the finding, written for the PR's author (who may be the PO, not a developer): the risk, not its proof: what can happen, when, and what the user gets, in one sentence of about 20 words, a little context, in ASD-STE100 Simplified Technical English, in the words of the repo's `GLOSSARY.md` when it has one (`GLOSSARY-MAP.md` leads to the right one). It names the behaviour a user or a developer meets: names from the product (an app, a screen, an endpoint) but no code names (a constant, a field, a method), no quotes from the spec or the code, and no proof (timings, config, values, error text): they go in the finding's posted `Details` block. Reread each constat as the author before posting: a sentence that needs the code to be understood is rewritten. A finding that only exists in the code (a missing index, an unrelated reformatting) names the screen, the data or the change it touches. A `rule` finding quotes the rule, never its file. File paths live in § Details, the fix with the author.

## Verdict

From the findings, `pre-existing` left out; the first that matches: `needs rethink` (the ask is `off-target`, or a `critical` or `important` `design` finding questions the approach itself), `fix first` (a `critical` or `important` finding), `clean up first` (a `minor` one), `ship it`.

## Language

Constats and placeholders are in the project language. In the local report, the labels, type words, severity words, verdict words, `Ask:` marks and `not run` stay as written below, since `/ship` reads it by them; the posted review translates them (FR: `Ask:` → `Demande :`, `Ask delivered:` → `Demande réalisée : oui | non | partielle`, `Note:` → `Commentaire :`, `Direction:` → `Piste de correction :`, `Reproduce:` → `Reproduire :`, `Details` → `Détails`, `Where:` → `Où :`, `Result:` → `Résultat :`, `Class:` → `Classe :`). A link is always whole: a PR, an issue or a URL in full; a rule's file by its full path.

## Local report

Every finding. § Second opinions stays local. A section with nothing in it is left out. The data flow diagram of step 8 is a working tool, not part of the report.

```
## Code Review: [PR title or branch] — [verdict]
Author: [PR author login, or the branch owner] · Model: [the model this review ran on] · Head: [the commit SHA reviewed]
Ask: [ISSUE-ID and title, or "no source found"] — delivered | partial | off-target
Note: [what the review could not check, or left out]

### Summary
| # | Severity | Type | Constat |
|---|---|---|---|
| [n] | [critical / important / minor] | [type] | [constat] |

### Lines
| # | Severity | Type | Where | Constat |
|---|---|---|---|---|
| [n] | [severity] | [type] | [path:line] | [constat, then its direction if any] |

### Details
[n]. [the line of finding n's type, below]

### Second opinions
Codex: effort [rung] ([the signals, or "none"]) · Rejected: [finding — why] (or: not run — <reason>)
Layered rails: Rejected: [finding — why] (or: not run — <reason>; left out when the app is not Rails)
```

Findings are numbered once across both tables, most severe first. Details item N is finding N, in the line of its type:

- `bug`, `test`, `pre-existing`: `Reproduce: [steps] · Result: [what happens, against what should] · Class: [the kind of bug, when the diff holds several instances] · Where: [path:line, path:line]`
- `design`: `[who decides or holds what today] · [who should] · [what disappears if it moves] · Where: [path:line]`, the first three in plain words, no code names
- `simplicity`, `readability`: `[what it costs] · Where: [path:line]`
- `rule`: `[the rule, quoted] — [its file] · Where: [path:line]`
- `ask`: `[the ask line] — missing | deviates: [how] | extra: [the limit it crosses] · Result: [what the user gets]`, or `[the ask line] — unclear: [what would settle it]`

## Posted on the PR

One GitHub review, event `COMMENT`, never an approval or a change request. Asked for: posted by the agent once the user says go, every finding. Automatic, under an auto-review brief: posted by the agent on its own, the `critical` and `important` findings only, its first line `review triggered automatically`. Everything in the project language, labels included; no path outside the repo; § Second opinions stays local. A finding's proof goes in a closed `<details><summary>Details</summary>` block (one per line comment, one for the whole body), which GitHub shows folded, with a blank line after `</summary>` so its markdown renders: its § Details line translated, without a file outside the repo and, in a line comment, without the `Reproduce:` part the comment already shows, plus what the constat left out (timings, config, values, error text).

- **Body**: `**[Verdict]** · commit [short SHA]`, the verdict starting with a capital letter (FR: « **À corriger d'abord** »), then the ask in three lines: `Ask: [the ticket, linked]`, `Ask delivered: yes | no | partly` (from `delivered | off-target | partial`; left out when no source was found), and, when the review could not check a behaviour, `Note: [what it could not check, as the review's limit, never as a gap of the PR]`. Then the summary findings, and any line finding whose line is not in the diff, as one table: `| # | | Constat |`, a row `| [n] | **[Severity]**&nbsp;·&nbsp;[type] | [constat] |` per finding (the label joined by `&nbsp;` so GitHub never breaks it; a line finding's `path:line —` comes before its constat). Under the table, one `Details` block holding, per finding, `[n].` its proof, then its `Direction:` (its capture under it when visual) and, when it has one, its `Reproduce:` line. Nothing else.
- **Line comments**: one per line finding, short lines: `**[Severity]** · [type] — [constat]`, then its `Direction: …` when it has one (its capture under it when visual), then for a `bug` or `test` `Reproduce: …`, the action only, with no values and no error text. Then its `Details` block.
- **Post**: `gh api repos/<owner>/<repo>/pulls/<n>/reviews --input review.json`, the file holding `commit_id` (the head SHA), `event: "COMMENT"`, `body`, and `comments: [{path, line, side: "RIGHT", body}]`. A line is in the diff when `gh pr diff` shows it as an added or context line of a hunk. A `422` rejects the whole review: move the comments it names (or all of them) into the body and post again, and an auto-review brief's Result says so.

No finding left after the filter: the automatic review posts the body alone, saying in the project language that nothing of importance was found (FR: « Revue automatique : rien d'important relevé. »).
