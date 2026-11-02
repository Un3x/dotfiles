# Built-in checklist

Each pass lists what to look for; the bar for a finding is in `review/SKILL.md` § Rules. Every finding, whatever its pass, is one scored row of the table in [`review/output.md`](review/output.md).

## Pass 1: CRITICAL
Issues that will break production, lose data, or create security holes.

Categories:
- **SQL safety**: Raw queries, missing indexes on new columns, N+1 queries, missing transactions where needed
- **Race conditions**: TOCTOU bugs, concurrent access without locking, shared mutable state
- **Trust boundaries**: User input flowing into queries/commands without validation, LLM output treated as trusted, external API responses used without verification
- **Silent failures**: Bare rescue/catch blocks, swallowed errors, missing error handling on external calls. An HTTP client that only reports a non-2xx (Sentry, log) and neither raises nor returns a failure: its caller goes on as if the call succeeded.
- **Data loss**: Destructive migrations without backfill, cascade deletes, missing null checks on critical paths
- **Auth/authz gaps**: Missing authorization checks, privilege escalation paths, exposed endpoints
- **Removed behaviour**: every route, branch, field, button, job or side effect the diff deletes with no replacement elsewhere in it. Nothing fails to compile and no test goes red: the feature is just gone. A removal the issue or the PR names is intended; any other one is a finding when something still reaches it (a caller in the tree, a name dispatched by string, an external client, data at rest still holding the removed value). A deleted test is a signal.
- **Unhealed bad state**: a wrong value written by an unattended trigger (job, cron, webhook, retry) that no path restores. The Result line names the only way out (manual fix, delete and re-add). One that heals on the next run is scored by the harm until then.
- **Untested new code paths**: a new method, branch or behaviour no test exercises directly, spike PRs flagged as such excepted.
- **Unproven premise**: Name the one fact the change is safe or effective because of, and how it is proven (test, drive, measurement, or assumed). If that fact is unproven for the case that motivated the PR, the row scores at least 7.

## Pass 2: INFORMATIONAL
Issues that cost later rather than break now.

Categories:
- **Conditional complexity**: Nested conditions that hide logic bugs, boolean expressions that could be simplified
- **Missing edge cases**: Nil/null/empty/zero handling, unicode, timezone, pagination boundaries
- **Test gaps**: Happy-path-only tests, missing error case tests, weak assertions, an assertion that something deleted is absent or a spy repeating what the outcome assertions prove ([`red-green-commit.md`](red-green-commit.md) step 1), a test that still passes with the behaviour broken or fails on an internals-only change
- **Performance**: Unbounded queries, missing pagination, loading associations unnecessarily
- **Dead code**: Unused variables, unreachable branches, commented-out code
- **Naming/clarity**: Misleading names, magic numbers, unclear intent (only when it could cause bugs; test names and readable code: see Readability)
- **Readability** (app code and specs, no bug risk needed; the cost is a reviewer's time; RSpec/Ruby examples): double-negative or vague `describe`/`context` names; several cases driven by a data table and metaprogramming (a table of lambdas, `instance_exec`) instead of one `context` per case with its stub in a `before` and a `shared_examples` taking the expected value; helpers returning tuples to destructure; vague assertions (`be >= 400` where the status is known); memoized readers with an inline block (`begin…end`) instead of `@x ||= build_x`; a sequence of steps whose purpose only the commit message explains, instead of a method that names it

## Pass 3: DESIGN
Walk [`design-grid.md`](design-grid.md) on the diff, all but § Simplicity.

## Pass 4: SIMPLICITY
Walk [`design-grid.md`](design-grid.md) § Simplicity on the diff.
