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

1. **Gather the sources**: the issue and its comments if it exists (read an issue, [`../tracker.md`](../tracker.md)), the tickets, briefs, designs and decisions it links, the challenge or reproduce verdict, what the user said in this session. Done when every fact the issue will state traces to one of them.
2. **Pick the type and write it** with [`template.md`](template.md), in the language it sets. Done when the top holds on one screen.
3. **Review the draft**: a fresh subagent, prompt exactly `Use the issue skill: review <path of the draft file>` plus the paths or links of the sources of step 1. Fix every BLOQUANT finding; a PAS CLAIR one is fixed or answered in the report to the user.
4. **Show the user** the draft and the open questions, then post on their go (write the description or create an issue, `../tracker.md`). The tracker is never written before the user has weighed in.

## Review

Follow [`review.md`](review.md). The review reports; it never edits the issue.

## Rules

- An issue someone else wrote (a PO, a teammate) is never rewritten: the lines it lacks go under a heading of their own, « Ajouté par Thomas », once the user agreed.
- A decision taken after the issue was written changes the lines it touches in place, and a comment says what changed and why. No section appended below that contradicts the criteria above.
- What ships, how it was built and the review rounds go on the PR, never on the issue.
