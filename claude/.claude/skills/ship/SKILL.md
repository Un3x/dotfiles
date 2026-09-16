---
name: ship
description: "Implement planned Linear issues: red-green-commit, PR, review loop."
disable-model-invocation: true
---

Ship command for Linear issues. Executes provide-plan + implement-plan + PR + review loop for each issue.

## Usage
- `/ship <issue1> <issue2> ...` - Ship listed issues sequentially
- `/ship` (no args) - Resume active shipping session

## Behavior

Progress lives in `.notes/_ship-session.md` ([`session.md`](session.md): format, markers, resumption). Update it after each phase change.

- **With issue arguments ($1, $2, ...)**: create/update the session file with the issue list, then execute each issue sequentially through the phases below.
- **Without arguments**: if the session file has in-progress or pending items, resume from the current issue and phase as `session.md` § Resumption says. If no session, report "No active ship session".

## Phases (per issue)

1. **Setup** — mark the issue `in-progress`, phase `setup`. Fetch issue details from Linear MCP to get the branch name; switch to the branch (create from main if needed). Locate the plan at `.notes/<branch_name>/plan.md` (strip prefix before `/` in branch names). Verify it exists and has no unanswered questions or FIXME markers; if it has, mark the issue `skipped` and move to the next one.
2. **Provide plan to Linear** — phase `post-plan`. Comment a **plan summary** on the Linear issue, not the full plan: the diagram + the step list (one line per step) + the size cap. ≤15 lines. The full plan lives in `.notes/` and the PR diff tells the rest.
3. **Implement** — phase `implement`. Follow each step in the plan with the [red-green-commit](red-green-commit.md) cycle. Done when every plan step has its commit and `implement-plan.md` says so.
4. **Push and create PR** — phase `push-pr`. Run the `/simplify` skill on the branch diff and apply its fixes (reuse, simplification, inlining); re-run tests to confirm still green. Push the branch to remote with `-u`, then `gh pr create` with the title and body of [`pr-body.md`](pr-body.md). Record the PR number, phase `review`.
5. **Review loop** — [`review-loop.md`](review-loop.md): fresh `/review` subagent, triage, re-plan + re-ship, round cap 3. Done when a round has no actionable finding or the cap is hit and reported.
6. **Next issue** — move to the next pending issue in the session; if none remain, the session is complete.

## Output

Templates in [`output.md`](output.md): resuming, after each issue, review cap hit, batch complete, error.
