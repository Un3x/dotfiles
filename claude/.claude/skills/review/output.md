# Output format

The report says what is wrong and how to see it, never how to fix it. Its reader is the author or the next agent, who finds the fix on their own: a finding is a behaviour, the steps that reproduce it, and the result, in plain words. Its references in the code come after the explanation, on a `Where:` line (full repo-relative path and line), never inside it. No « Fix: » line. The user posts it without rewriting it. A finding that only exists in the code (a missing index, an unrelated reformatting) names the screen, the data or the change it touches in plain words.

The report is written in French, whatever the language of the PR or the session: the user reads it and posts it on GitHub as is. Only the free text that fills a `[…]` or `<…>` placeholder is French; the headings, labels, status words, `not run`, the `(also …)` tags and the verdict picked from its list stay as written below, since `/ship` reads the report by them.

A link is always whole: a PR, an issue or a URL in full; the file a missed rule lives in by its full path, never its basename.

A section with nothing in it is left out. The data flow diagram of step 8 is a working tool, not part of the report.

```
## Code Review: [PR title or branch] — [verdict: ship it / fix criticals first / simplify first / needs rethink]
Author: [PR author login, or the branch owner] · Model: [the model this review ran on] · Head: [the commit SHA reviewed]

### ASKED vs BUILT
Ask: [ISSUE-ID and title, or "no source found"]
- [line of the ask] — delivered ([the test or scenario that proves it]) | missing | deviates: [how] | unclear: [what would settle it] | unproven
Extra: [what the change does that no line asked for, and the limit it crosses if any]
Verdict: delivered | partial | off-target

### CRITICAL (must fix)

**1. [The wrong behaviour, in one sentence]**
Reproduce:
1. [step]
2. [step]
Result: [what happens, against what should]
Class: [the kind of bug, when the diff holds more than one instance]
Where: [path:line, path:line]

### DESIGN

**1. [Who decides or holds what today, and who should, in plain words]**
[What disappears if it moves: a second path, a list, a copy]
Where: [path:line, path:line]

### SIMPLICITY (over-engineering)

**1. [What is heavier than it needs to be]**
[What it costs]
Where: [path:line]

### RULES MISSED
1. [the rule, quoted] — [its file] — [where the diff breaks it, in plain words] — Where: [path:line]

### CODEX SECOND OPINION
Effort: [rung] ([the signals, or "none"])
Confirmed: [findings Codex raised that you verified and did not have, written like the ones above]
Rejected: [finding — why]
(or: "not run — <reason>"; agreements are tagged "(also Codex)" on your own finding and need no line here)

### LAYERED RAILS
Confirmed: [findings the layered-rails reviewer raised that you verified and did not have, written like the ones above]
Rejected: [finding — why]
(or: "not run — <reason>"; left out when the app is not Rails)

### PRE-EXISTING (not this PR's)
1. [a bug in code the diff did not change, written like the ones above] — Where: [path:line]
(not in the verdict, not fixed in this PR)

### INFORMATIONAL (worth knowing)

**1. [What to know, in one sentence]**
[When it shows up, and who it affects]
```
