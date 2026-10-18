---
name: issue
description: "Write or review a tracker issue so every reader understands it on one read. Use before any write of an issue's title or description on the tracker (Linear save_issue, create or update), whoever asked for it; and when an issue is to be reviewed or clarified."
---

# issue

An issue is read by several people who all need it: the PO who decides, the dev who estimates, the tester who checks, the agent that ships it, the person who asked. The top of the issue is written for the PO and must hold on one read; the part below the line is for the dev and the agent. The reference reader is a PO who always needs to understand: an issue she must reread has failed.

## When

- **Write**: before any title or description goes to the tracker — a new issue, a rewrite, a verdict persisted by `/challenge`, a ticket after `/reproduce`, a line added to someone else's issue. A comment is not an issue body and does not need this skill.
- **Review** (`review <ISSUE-ID | url | draft path>`): called at step 3 of Write, or when an issue is to be checked.

## Write

1. **Gather the sources**: the issue and its comments if it exists (read an issue, [`../tracker.md`](../tracker.md)), the tickets, briefs, designs and decisions it links, the challenge or reproduce verdict, the project's recorded decisions, those that hold for every issue as well as this one (a status file, a memory), what the user said in this session. Done when every fact the issue will state traces to one of them.
2. **Pick the type and write it** with [`template.md`](template.md), in the language it sets, into a draft file in the scratchpad. Done when the top holds on one screen.
3. **Review the draft**: a fresh subagent, prompt exactly `Use the issue skill: review <absolute path of the draft file>` plus the paths or links of the sources of step 1 and, from round two, the earlier reports and a triage file next to the draft: each finding, and what was done with it. A reply written only in a prompt is lost by the next round. Check each finding before applying it: a reviewer can be wrong. Fix every BLOQUANT finding; a PAS CLAIR one is fixed or answered in the report to the user. A change made after `prête` gets one more review, of the change alone: a fresh look at the whole issue finds new detail every time. Done when the review says `prête`. Past three rounds the issue is likely too big or a question is still open: stop, show the user what still blocks and say which you suspect.
4. **Show the user** the draft and the open questions, then post on their go (write the description or create an issue, `../tracker.md`). The tracker is never written before the user has weighed in. Done when the tracker holds the draft as shown.

## Review

Read [`template.md`](template.md) for the shape and the language, then follow [`review.md`](review.md). The review reports; it never edits the issue.

## Rules

- An issue someone else wrote (a PO, a teammate) is never touched: what it lacks is appended under a heading of its own, « Ajouté après relecture », or said in a comment, once the user agreed. A later decision on it is a comment that quotes the line it changes. A title that does not say what the issue asks is a question to its author, in the addition or the comment, with a proposed title.
- On an issue we wrote, a decision taken after it was written changes the lines it touches in place, and a comment says what changed and why. No section appended below that contradicts the criteria above.
- What ships, how it was built and the review rounds go on the PR, never on the issue.
