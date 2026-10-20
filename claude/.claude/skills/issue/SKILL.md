---
name: issue
description: "Write or review a tracker issue so every reader understands it on one read. Use before any write of an issue's title or description on the tracker (Linear save_issue, create or update), whoever asked for it; and when an issue is to be reviewed or clarified."
---

# issue

The top of an issue is written for the PO, who decides and checks; below the line, links and decisions for the dev. The reference reader is a PO who always needs to understand: an issue she must reread has failed. An agent's `prête` is not her verdict, she is.

## When

- **Write**: before any title or description goes to the tracker — a new issue, a rewrite, a verdict persisted by `/challenge`, a ticket after `/reproduce`, a line added to someone else's issue. A comment does not need this skill.
- **Review** (`review <ISSUE-ID | url | draft path>`): step 3 of Write, or when an issue is to be checked.

## Write

1. **Gather the sources**: the issue and its comments ([`../tracker.md`](../tracker.md)), what it links, the challenge or reproduce verdict, the project's recorded decisions (status file, memory), what the user said. A design is looked at, not read: open its images and run the mockup, keeping captures. Done when every fact the issue states traces to a source.
2. **Write it** with [`template.md`](template.md) into a draft file in the scratchpad. Done when the top meets the template's goal.
3. **Review it**: a fresh subagent, prompt `Use the issue skill: review <absolute path of the draft>` plus the sources and, from round two, a triage file next to the draft (each finding, what was done with it). Check a finding before applying it. Fix each BLOQUANT by rewording or cutting; a PAS CLAIR is fixed or reported. A change after `prête` is reviewed alone. After the third round, apply nothing more: show the user what still blocks.
4. **Show the user** the draft and the open questions early; post on their go. Done when the tracker holds the draft as shown.

## Review

Read [`template.md`](template.md), then follow [`review.md`](review.md). The review reports; it never edits the issue.

## Rules

- **Someone else's issue is never touched**: what it lacks goes under « Ajouté après relecture » or in a comment, once the user agreed. A title that does not say what it asks is a question to its author, with a proposed title.
- **A rewrite of our issue for clarity translates**: the words change, the meaning does not. A point the template leaves out (the cause, code, edge cases, who decided) is cut, and listed for the user at step 4: never dropped silently.
- **A later decision changes the lines it touches in place**, and a comment says what changed and why.
- What ships and how goes on the PR, never on the issue.
