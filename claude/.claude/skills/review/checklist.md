# Built-in checklist

Read at step 2 of `/review` when the project has no `.claude/review-checklist.md`. Each pass lists what to look for; the bar for a finding is in `SKILL.md` § Rules.

## Pass 1: CRITICAL
Issues that will break production, lose data, or create security holes.

For each finding:
- Describe the problem with file:line reference
- Explain the failure scenario (when does this blow up?)
- Suggest a fix

Categories:
- **SQL safety**: Raw queries, missing indexes on new columns, N+1 queries, missing transactions where needed
- **Race conditions**: TOCTOU bugs, concurrent access without locking, shared mutable state
- **Trust boundaries**: User input flowing into queries/commands without validation, LLM output treated as trusted, external API responses used without verification
- **Silent failures**: Bare rescue/catch blocks, swallowed errors, missing error handling on external calls
- **Data loss**: Destructive migrations without backfill, cascade deletes, missing null checks on critical paths
- **Auth/authz gaps**: Missing authorization checks, privilege escalation paths, exposed endpoints
- **Untested new code paths**: New methods, branches, or behaviors introduced without a corresponding test. This is not "low coverage" hand-wringing — flag only when a specific new path has zero direct test exercising it. TDD was violated; bugs will ship. (Exception: spike PRs explicitly flagged as such.)

## Pass 2: INFORMATIONAL
Issues worth knowing about but not blocking.

Categories:
- **Conditional complexity**: Nested conditions that hide logic bugs, boolean expressions that could be simplified
- **Missing edge cases**: Nil/null/empty/zero handling, unicode, timezone, pagination boundaries
- **Test gaps**: Happy-path-only tests, missing error case tests, weak assertions (promoted to CRITICAL if an entire new code path has zero tests)
- **Performance**: Unbounded queries, missing pagination, loading associations unnecessarily
- **Dead code**: Unused variables, unreachable branches, commented-out code
- **Naming/clarity**: Misleading names, magic numbers, unclear intent (only when it could cause bugs)

## Pass 3: ARCHITECTURE (Rails projects only)
If the codebase is a Rails application, run a layered architecture check using the `layered-rails` skill:
- Invoke `/layers:review` on the changed files
- **Violations only**: misplaced responsibility (e.g., controller doing domain logic), god objects
- **Never prescribe adding a construct.** A finding may only relocate code to an existing home or delete it — "extract a service/form object/query object" is not a valid finding. Review removes complexity; it never adds it.
- Merge findings into the output under an "ARCHITECTURE" section between CRITICAL and INFORMATIONAL

Skip this pass for non-Rails projects.

## Pass 4: SIMPLICITY (over-engineering)
Complexity that costs more than it pays, measured against [the one rule](../plan/one-rule.md). Same rule as CRITICAL: each finding needs a concrete cost statement, not a vibe.

Categories:
- **Configuration over convention**: config flags, option hashes, initializers, or custom plumbing where a Rails convention/built-in does the job — name the built-in that replaces it
- **Speculative generality**: params, options, config flags, or branches nothing uses today
- **Single-caller indirection**: a class/service/method with exactly one call site that could be inlined
- **Impossible-state defense**: guards/rescues for states that cannot occur given the actual callers
- **Homeless abstraction**: new class/module created where existing code had a natural home
- **Plan drift**: diff significantly larger than the plan's size estimate (`.notes/<branch>/plan.md`) — name where the growth happened

Each finding states the deletion payoff ("inlining this removes 40 lines and one file").
