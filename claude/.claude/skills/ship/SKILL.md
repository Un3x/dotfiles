---
name: ship
description: "Implement one planned issue: red-green-commit, proof through the verify map, PR, review loop. Run by a subagent that the project lead session spawns with `Run /ship <ISSUE>`."
---

Ships one issue of the project's tracker ([`../tracker.md`](../tracker.md)): its plan, implementation, PR and review loop.

## Usage
- `/ship <issue>` - Ship that issue
- `/ship` (no args) - Resume an in-progress ship (`session.md` § Resumption); none → report "No active ship session"

Progress lives in `.notes/<branch_name>/ship-session.md` ([`session.md`](session.md)). Update it after each phase change.

## Phases

1. **Setup** — read the issue from the tracker to get the branch name, then write the session file: status `in-progress`, phase `setup`. Look for a worktree script: one named in the repo's `CLAUDE.md`, or `bin/*worktree*`. With a script: run `git fetch origin`, then create the worktree with the script. Pass it the tracker's branch name when it takes one. Work in the worktree: it has its own database and ports, so parallel sessions do not share state. The plan and the session file stay in the main checkout's `.notes/` (`git worktree list` gives its path). `/verify` drives the worktree's ports. The worktree stays until its PR is merged or closed; the session-start sweep then removes it with the repo's remove script. With no script: switch to the branch, created from the default branch if needed. Locate the plan at `.notes/<branch_name>/plan.md` (strip the prefix before `/` in branch names). Check that it exists and has no unanswered questions or FIXME markers. If it has some, mark the session `skipped` and stop.
2. **Attach the plan to the issue** — phase `post-plan`. Upload `.notes/<branch_name>/plan.md` as a file on the issue (attach a file, title « Plan YYYY-MM-DD »). No comment: the issue's readers are not the plan's (`commit/readers.md`). A scope decision the plan surfaced is the one thing worth a comment, as a question.
3. **Implement** — phase `implement`. Follow each step in the plan with the [red-green-commit](../red-green-commit.md) cycle. Done when every plan step has its commit and the session's Plan step says so.
4. **Prove, push and create PR** — phase `push-pr`. Run the `/simplify` skill on the branch diff and apply its fixes (reuse, simplification, inlining); re-run tests to confirm still green. Then prove the change the way a user meets it, in a **fresh subagent** (`sonnet`: driving is mechanical, and a fresh context is what keeps each drive call from replaying the whole ship). Its prompt opens with `Prove:` (the harness counts these runs), then gives the worktree path and its ports, the project's verify map (`.claude/skills/verify-<app>/`, every app has one), the feature the issue names and the behaviour to prove; it drives once per the `verify` skill and returns the result lines and the evidence path. A feature the map does not cover: write its feature file and its drive in this PR first, then spawn. A `FAIL` comes back with what it saw: fix, then a new subagent; the third `FAIL` reports `blocked` with what the drive saw. What the drive showed is the PR body's third line (`pull-request.md`); the evidence path goes in the /ship report (`output.md`), never in the PR. No proof, no PR: report `blocked` with what stopped the drive. Push the branch to remote with `-u`, then `gh pr create` with the title and body of the `commit` skill's `pull-request.md`. Record the PR number, phase `review`.
5. **Review loop** — [`review-loop.md`](review-loop.md): fresh `/review` subagent, triage, re-plan + re-ship, round cap 3. Done when a round has no actionable finding or the cap is hit and reported.

## Output

Templates in [`output.md`](output.md): resuming, shipped, review cap hit, skipped, error.
