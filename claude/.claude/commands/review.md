Paranoid code review. Two-pass structural audit of changes, designed to catch bugs that pass CI but blow up in production.

## Usage
- `/review` - Review current branch changes against main
- `/review <PR-number>` - Review a specific PR
- `/review <file1> <file2> ...` - Review specific files

## Purpose

This is the **paranoid staff engineer brain**. Not a style review, not a linting pass. This catches structural bugs: race conditions, N+1 queries, trust boundary violations, silent failures, and logic errors.

## Behavior

### 1. Gather the diff
- No args: `git diff main...HEAD` (all changes on current branch)
- PR number: fetch PR diff via `gh pr diff <number>`
- Specific files: `git diff main -- <files>`

### 2. Read the checklist
- Check if `.claude/review-checklist.md` exists (project-specific overrides)
- If not, use the built-in checklist below

### 3. Run Pass 1: CRITICAL
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

### 4. Run Pass 2: INFORMATIONAL
Issues worth knowing about but not blocking.

Categories:
- **Conditional complexity**: Nested conditions that hide logic bugs, boolean expressions that could be simplified
- **Missing edge cases**: Nil/null/empty/zero handling, unicode, timezone, pagination boundaries
- **Test gaps**: Happy-path-only tests, missing error case tests, weak assertions (promoted to CRITICAL if an entire new code path has zero tests)
- **Performance**: Unbounded queries, missing pagination, loading associations unnecessarily
- **Dead code**: Unused variables, unreachable branches, commented-out code
- **Naming/clarity**: Misleading names, magic numbers, unclear intent (only when it could cause bugs)

### 5. Run Pass 3: ARCHITECTURE (Rails projects only)
If the codebase is a Rails application, run a layered architecture check using the `layered-rails` skill:
- Invoke `/layers:review` on the changed files
- This checks for layer violations (e.g., controller doing domain logic), god objects, missing abstractions, and extraction signals
- Merge findings into the output under an "ARCHITECTURE" section between CRITICAL and INFORMATIONAL

Skip this pass for non-Rails projects.

### 6. Run Pass 4: SIMPLICITY (over-engineering)
Complexity that costs more than it pays. Same rule as CRITICAL: each finding needs a concrete cost statement, not a vibe.

Categories:
- **Speculative generality**: params, options, config flags, or branches nothing uses today
- **Single-caller indirection**: a class/service/method with exactly one call site that could be inlined
- **Impossible-state defense**: guards/rescues for states that cannot occur given the actual callers
- **Homeless abstraction**: new class/module created where existing code had a natural home
- **Plan drift**: diff significantly larger than the plan's size estimate (`.notes/<branch>/plan.md`) — name where the growth happened

Each finding states the deletion payoff ("inlining this removes 40 lines and one file").

### 7. Diagram the data flow (if applicable)
If the diff touches a data pipeline, request handler, or multi-step process:
- Draw an ASCII diagram of the data flow
- Mark where validation happens (or doesn't)
- Mark where errors can occur and how they're handled

## Output Format

```
## Code Review: [branch or PR title]

### CRITICAL (must fix)

**1. [Category]: [Brief description]**
`file:line` — [explanation of the failure scenario]
Fix: [suggested fix]

**2. ...**

### ARCHITECTURE (layer violations)

**1. [Violation type]: [Brief description]**
`file:line` — [explanation + which layer boundary is crossed]
Fix: [suggested extraction or restructure]

### SIMPLICITY (over-engineering)

**1. [Category]: [Brief description]**
`file:line` — [what it costs, what deleting/inlining buys]

### INFORMATIONAL (worth knowing)

**1. [Category]: [Brief description]**
`file:line` — [explanation]

### Data Flow
[ASCII diagram if applicable]

### Summary
- Critical: N issues
- Simplicity: N issues
- Informational: N issues
- Verdict: [ship it / fix criticals first / simplify first / needs rethink]
```

## Rules

- No style nits. RuboCop and linters handle that.
- Every critical finding must include a concrete failure scenario ("when X happens, Y breaks because Z").
- Don't flag things that are already covered by existing tests (read the test files).
- If the diff is clean, say "no issues found, ship it" — don't invent problems.
- Be specific. "This could be a problem" is useless. "This N+1 fires on the index page with 50+ records and will timeout" is useful.
- Read surrounding code for context before flagging — the "bug" might be handled elsewhere.
