---
name: plan
description: "Write or replan `.notes/<branch>/plan.md` for one issue in the project's tracker."
---

Plans one issue of the project's tracker ([`../tracker.md`](../tracker.md)), first plan or replan.

## Usage
- `/plan <issue>` - Create or replan the plan for that issue (ID or URL)
- `/plan` (no args) - Scan `.notes/*/plan.md` for unanswered questions or FIXMEs and replan those, one at a time

## Steps

1. Read [`one-rule.md`](one-rule.md). Every plan is measured against it; a plan that escalates complexity on its own is wrong even when it works.
2. Read the issue from the tracker → get the branch name → create or replan `.notes/<branch>/plan.md` in the format of [`plan-format.md`](plan-format.md).
3. Stop the moment the plan has questions or a flag — do NOT guess on ambiguity. Done when the plan is ready, its questions are written in it, or the issue goes back to `/challenge`.

## Output

Questions or flag: show them, so the user can answer inline.
Ready: the branch name and a copy-pasteable `/ship <issue>` line.
Back to `/challenge` (several stories, or a screen with no mockup): why, and the `/challenge <issue>` line; no `plan.md`.
