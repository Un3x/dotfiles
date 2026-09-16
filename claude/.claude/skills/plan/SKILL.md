---
name: plan
description: "Write or replan `.notes/<branch>/plan.md` for Linear issues."
disable-model-invocation: true
---

Plan command for Linear issues. Handles both initial planning and replanning.

## Usage
- `/plan <issue1> <issue2> ...` - Create or replan for listed issues (IDs or URLs)
- `/plan` (no args) - Resume active session OR replan plans with unanswered questions

## Steps

1. Read [`one-rule.md`](one-rule.md). Every plan is measured against it; a plan that escalates complexity on its own is wrong even when it works.
2. Open or resume the session file ([`session.md`](session.md)).
   - **With issue arguments**: write the session file with the issue list. Per issue: fetch from Linear MCP → get branch name → create/replan/skip at `.notes/<branch>/plan.md` in the format of [`plan-format.md`](plan-format.md) → update session status.
   - **Without arguments**: resume from the session file if pending items exist; else scan `.notes/*/plan.md` for unanswered questions / FIXMEs and replan those.
3. Stop the moment a plan has questions or a flag — do NOT guess on ambiguity. Done when every listed issue is `ready`, `has-questions`, or skipped in the session file.

## Output

On stop: show progress list + the questions, so the user can answer inline.
On batch complete: list ready issues with branch names + a copy-pasteable `/ship FAS-123 FAS-124` line, and any still-has-questions issues.
