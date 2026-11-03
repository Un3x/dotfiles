# Output format

The report is one table of **rows**, every finding of every pass and second opinion, sorted by score, highest first. It says what is wrong, never how to fix it: its reader is the author or the next agent, who finds the fix on their own. It goes on GitHub without rewriting: the user posts it, except under an auto-review brief, where the agent posts its § Posted on the PR form.

## Score

From 1 to 10, on fixed anchors:

- **9–10**: breaks prod, data or security.
- **7–8**: a user will hit it, or the next feature of the same kind will pay for it.
- **4–6**: debt, simplicity, a missing test.
- **1–3**: detail.

A missing announcement (changelog, release note, doc) scores by what it announces: a change in behaviour is 7–8, information only is 4–5.

An `ask` row for a missing or deviating line, or an extra that crosses a stated limit, scores at least 7.

## Type

One of: `ask` (a line of the ask missing, deviating, unclear or unproven, or an extra that crosses a limit), `bug`, `test`, `design`, `simplicity`, `readability`, `rule` (a written rule the diff breaks), `pre-existing` (a bug in code the diff did not change, left out of the verdict).

## Constat

The **wait-what** pitch of the finding: one or two short sentences, a little context, in ASD-STE100 Simplified Technical English, in the words of the repo's `GLOSSARY.md` when it has one (`GLOSSARY-MAP.md` leads to the right one). It names the behaviour a user or a developer meets. A finding that only exists in the code (a missing index, an unrelated reformatting) names the screen, the data or the change it touches. A `rule` row quotes the rule, never its file. File paths and the fix live elsewhere: the paths in § Details, the fix with the author.

## Verdict

From the scores, `pre-existing` rows left out; the first that matches: `needs rethink` (the ask is `off-target`, or a `design` row from 7 questions the approach itself), `fix first` (a row from 7), `clean up first` (a row from 4), `ship it`.

## Language

Constats and placeholders are in the project language. The labels, type words, verdict words, `Ask:` marks and `not run` stay as written below in the local report, since `/ship` and the harness read it by them; the posted form translates them. A link is always whole: a PR, an issue or a URL in full; a rule's file by its full path.

## Local report

The full report, every row. § Details and § Second opinions stay local. A section with nothing in it is left out. The data flow diagram of step 8 is a working tool, not part of the report.

```
## Code Review: [PR title or branch] — [verdict]
Author: [PR author login, or the branch owner] · Model: [the model this review ran on] · Head: [the commit SHA reviewed]
Ask: [ISSUE-ID and title, or "no source found"] — delivered | partial | off-target

| Score | Type | Constat |
|---|---|---|
| [1–10] | [type] | [constat] |

### Details
1. [the line of row 1's type, below]

### Second opinions
Codex: effort [rung] ([the signals, or "none"]) · Rejected: [finding — why] (or: not run — <reason>)
Layered rails: Rejected: [finding — why] (or: not run — <reason>; left out when the app is not Rails)
```

Details item N is the table's row N, in the line of its type:

- `bug`, `test`, `pre-existing`: `Reproduce: [steps] · Result: [what happens, against what should] · Class: [the kind of bug, when the diff holds several instances] · Where: [path:line, path:line]`
- `design`: `[who decides or holds what today] · [who should] · [what disappears if it moves] · Where: [path:line]`, the first three in plain words, no code names
- `simplicity`, `readability`: `[what it costs] · Where: [path:line]`
- `rule`: `[the rule, quoted] — [its file] · Where: [path:line]`
- `ask`: `[the ask line] — missing | deviates: [how] | extra: [the limit it crosses] · Result: [what the user gets]`, or `[the ask line] — unclear: [what would settle it] | unproven` (no Result: the missing proof is the fact)

## Posted on the PR

Under an auto-review brief, the agent posts one comment, never an approval or a change request: only the rows from 7, everything in the project language, labels included. Nothing outside the table and its two lines above, and no path outside the repo.

```
review triggered automatically

**[verdict]** · commit `[short SHA]`

| Score | Type | Constat |
|---|---|---|
| [7–10] | [type] | [constat] |
```

No row from 7: the comment is `review triggered automatically` and one line in the project language saying nothing of importance was found (FR: « Revue automatique : rien d'important relevé. »).
