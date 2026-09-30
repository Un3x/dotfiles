# Plan format — one screen max

Read at step 2 of `/plan`, when writing or replanning `.notes/<branch_name>/plan.md` (strip prefix before `/` in branch names).

```markdown
# <ISSUE-ID> — <title>

<one-line restatement of the outcome>

## Diagram
<5-line ASCII of the flow: happy path + error path. So a reader grasps the change in a second — describe the design, never justify it.>

## Steps
1. <failing test to write> → <change that makes it pass>
2. ...
N. Simplify: after green, what can be deleted, inlined, or collapsed?

## Size
~X lines, Y files, N commits in reading order   ← an estimate, not a cap (user, 2026-09-30): one PR per functionality, self-sufficient; the commits are the reviewer's path. Sized from the issue's appetite when /challenge wrote one.

## Questions          ← only if any; presence = has-questions
- ...
Flag: ...             ← only if you believe simple is insufficient (one sentence)
```

- **TDD is the default.** Each step = failing test + the behavior change that makes it pass, together. Never a trailing "add tests" step. Spike exception only if `/challenge` flagged it — note it in the plan.
- Explore the codebase before planning; plans reference real files.
- Lines with FIXME must be addressed when replanning.

## Fresh-eyes check (non-trivial plans only)

Before marking `ready`, spawn a subagent on `sonnet` with only the issue + draft plan: "Propose a design with half the moving parts." If it finds a simpler shape, that becomes the plan. Exploration and fresh-eyes run on the smaller model on purpose (routing decided 2026-09-30, not for limits but to have the data when they bind); judgment stays on the main one.
