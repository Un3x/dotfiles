# Red-green-commit

Read at phase 3 (implement) of `/ship`, and again at each review round's re-ship.

- **First action of this phase**: copy the plan's step list verbatim into your todo list, one todo per step — paraphrasing the plan is how steps get silently dropped
- At each step, follow the **red-green-commit** cycle:
  1. **Red**: Write the failing test(s) specified in the plan step
  2. Run the test — confirm it fails for the expected reason (not a typo/syntax error)
  3. **Green**: Implement the minimum code needed to make the test pass
  4. Run the test — confirm it passes
  5. **Refactor = less indirection, not fewer lines**: each test and each method reads top to bottom without jumping around. A table of lambdas, `instance_exec`, a helper returning tuples to destructure, or an inline `begin…end` memo is not a refactor: if this step wrote one, rewrite it. Never introduce an abstraction the plan doesn't name (a `shared_examples` or a `build_x` memo reader is readability, not an abstraction); if one feels necessary mid-step, stop and flag it instead of improvising. Re-run tests to confirm still green
  6. Run broader quality checks (rubocop, related test files)
  7. **Commit**: tests and implementation ship in the same commit (never separate "add tests" commits), with the message written by the `commit` skill: the plan step is context the log reader does not have
  8. Track progress in `.notes/<branch_name>/implement-plan.md`
  9. Update session with current plan step number
- **Spike exception**: If the plan was flagged as a spike during `/challenge`, the red-green cycle is optional — but note skipped tests in the plan file so review catches them.
- **A change the plan names but the step could do without gets its own commit**, before the commit that uses it: a boy-scout cleanup, a new hook in a base class, a rename. Folded into a feature commit, it reads as a required change.
- **Design tripwire**: when a plan step's design does not hold (the approved construct breaks a test or hides a failure), stop and flag it with what broke. Never swap in another construct, least of all one the plan's `Design:` line rejected: the shape is the planner's call.
- **Scope tripwire**: the diff stops at the issue's scope, never at a line count. A change the plan did not name goes in the session file and to the user; a diff that outgrows a commit-by-commit read gets a review guide (`commit/review-guide.md`), not a split that ships half a functionality.
- If tests fail unrelated to the plan, note them and continue
- No blocking on flaky feature tests
- **Learning capture**: If you encounter a non-trivial problem during implementation (unexpected behavior, tricky API, framework gotcha, debugging dead-end) and find a solution, save the lesson to your auto memory. This compounds knowledge across sessions and prevents hitting the same wall twice.
