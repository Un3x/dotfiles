# Review loop

Read at phase 5 (review) of `/ship`.

- Spawn a review subagent (fresh context) whose prompt is exactly:
  ```
  Run /review <pull_request_link>
  ```
  Nothing else — the reviewer forms its own view from the PR alone. `/review` carries the checklist, the four passes and the Codex second opinion, so this phase adds nothing on top of it. Save the subagent's report **verbatim** to `.notes/<branch_name>/review-round-N.md` (the `review/output.md` shape, headings and numbering kept), then append `## Triage` with one line per finding: `N. fixed | rebutted: <why> | deferred: <where>`. A paraphrased round file cannot be counted (72 round files by 2026-09-30, a dozen heading shapes, no recurrence measurable).
- Triage the report (ASKED vs BUILT lines marked missing, deviates or extra, then CRITICAL, ARCHITECTURE, SIMPLICITY and confirmed CODEX findings; a "Codex: not run" line is noted in the session file `## Notes` and does not block the loop):
  - **No actionable findings** → mark issue `shipped` (record the round count), move to next issue
  - **Actionable findings** → fix on the same branch:
    1. **Re-plan**: append a `## Review round N` section to `.notes/<branch_name>/plan.md` — same format and same one rule as /plan ([`../plan/one-rule.md`](../plan/one-rule.md); one step per finding: failing test → fix; simplest fix only, flag rather than escalate). A finding you disagree with gets a one-line rebuttal in review-round-N.md instead of a step. An **extra** the user wants kept is a scope change: ask, do not decide; a **missing** line is never rebutted, it is built or the issue is re-scoped by the user.
    2. **Re-ship**: implement the new steps with the [red-green-commit](red-green-commit.md) cycle, push to the same branch (the PR updates)
    3. Spawn a **fresh** review subagent on the updated PR with the same prompt, repeat
- **Round cap: 3.** If findings remain after round 3, stop looping: note the open findings in the session file `## Notes` and surface them to the user — don't ping-pong indefinitely.
- Update session round number after each pass so resumption re-enters the loop correctly
