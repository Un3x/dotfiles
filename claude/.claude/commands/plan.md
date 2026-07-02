Plan command for Linear issues. Handles both initial planning and replanning.

## Usage
- `/plan <issue1> <issue2> ...` - Create or replan for listed issues (IDs or URLs)
- `/plan` (no args) - Resume active session OR replan plans with unanswered questions

## The one rule

**The plan IS the simplest Rails-conventional design. Nothing else.**

Convention over configuration. Rails built-in before custom construct. No new class, table, gem, job, route, state value, or config flag unless the issue demands it or the user asked for it. If you believe the simple design is genuinely insufficient, you do not design the alternative — you add **one flagged sentence** at the end of the plan ("Flag: I think X is insufficient because Y"), mark the issue `has-questions`, and stop. The user drives complexity escalation, never the planner.

## Plan format — one screen max

`.notes/<branch_name>/plan.md` (strip prefix before `/` in branch names):

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
~X lines, Y files   ← hard cap for /ship, not an estimate to outgrow

## Questions          ← only if any; presence = has-questions
- ...
Flag: ...             ← only if you believe simple is insufficient (one sentence)
```

- **TDD is the default.** Each step = failing test + the behavior change that makes it pass, together. Never a trailing "add tests" step. Spike exception only if `/challenge` flagged it — note it in the plan.
- Explore the codebase before planning; plans reference real files.
- Lines with FIXME must be addressed when replanning.

## Fresh-eyes check (non-trivial plans only)

Before marking `ready`, spawn a subagent with only the issue + draft plan: "Propose a design with half the moving parts." If it finds a simpler shape, that becomes the plan.

## Session Tracking

Progress persists in `.notes/_plan-session.md` so work survives compaction or restarts:

```markdown
# Plan Session
Started: YYYY-MM-DD HH:MM

## Issues
- [ ] FAS-123 - pending
- [~] FAS-124 - has-questions (3)
- [x] FAS-125 - ready

## Current
FAS-123
```

### With issue arguments:
1. Write session file with the issue list
2. Per issue: fetch from Linear MCP → get branch name → create/replan/skip at `.notes/<branch>/plan.md` → update session status
3. Stop the moment a plan has questions or a flag — do NOT guess on ambiguity

### Without arguments:
1. Resume from session file if pending items exist
2. Else scan `.notes/*/plan.md` for unanswered questions / FIXMEs and replan those

Always read the session file first when resuming.

## Output

On stop: show progress list + the questions, so the user can answer inline.
On batch complete: list ready issues with branch names + a copy-pasteable `/ship FAS-123 FAS-124` line, and any still-has-questions issues.
