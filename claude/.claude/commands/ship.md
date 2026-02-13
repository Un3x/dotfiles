Ship command for Linear issues. Executes provide-plan + implement-plan + PR for each issue.

## Usage
- `/ship <issue1> <issue2> ...` - Ship listed issues sequentially
- `/ship` (no args) - Resume active shipping session

## Session Tracking

All progress is persisted in `.notes/_ship-session.md` so work survives context compaction or session restarts.

Session file format:
```markdown
# Ship Session
Started: YYYY-MM-DD HH:MM

## Issues
- [x] FAS-123 - shipped (PR: #123)
- [>] FAS-124 - in-progress (step: implement, plan-step: 3/5)
- [ ] FAS-125 - pending
- [-] FAS-126 - skipped (has questions)
- [!] FAS-127 - failed (test failures)

## Current
FAS-124

## Current Phase
implement

## Notes
FAS-127: RuntimeError in UserService - needs investigation
```

Status markers:
- `[ ]` pending - not yet started
- `[>]` in-progress - currently being shipped
- `[x]` shipped - PR created successfully
- `[-]` skipped - has questions or intentionally skipped
- `[!]` failed - error during shipping

Phases: `setup` → `post-plan` → `implement` → `push-pr` → `done`

## Behavior

### With issue arguments ($1, $2, ...):
1. Create/update `.notes/_ship-session.md` with the issue list
2. For each issue, execute sequentially (see phases below)
3. Update session file after each phase change

### Without arguments:
1. Check if `.notes/_ship-session.md` exists with in-progress or pending items
2. Resume from current issue and phase
3. If no session, report "No active ship session"

## Phases (per issue)

### 1. Setup
- Update session: mark issue as `in-progress`, phase as `setup`
- Fetch issue details from Linear MCP to get branch name
- Switch to the branch (create from main if needed)
- Locate plan at `.notes/<branch_name>/plan.md` (strip prefix before `/` in branch names)
- Verify plan exists and has no unanswered questions or FIXME markers
- If plan has questions/FIXMEs: mark as `skipped`, move to next issue

### 2. Provide Plan to Linear
- Update session: phase as `post-plan`
- Add the plan content to the Linear issue as a comment
- Remove Linear-specific references from the posted content

### 3. Implement Plan
- Update session: phase as `implement`
- Follow each step in the plan
- At each step:
  - Implement the code changes
  - Run quality checks (rubocop, tests as specified in plan)
  - Commit with a focused message (why, not what; no co-authored-by)
  - Track progress in `.notes/<branch_name>/implement-plan.md`
  - Update session with current plan step number
- If tests fail unrelated to the plan, note them and continue
- Do not add comments in code - code should be self-explanatory
- No blocking on flaky feature tests

### 4. Push and Create PR
- Update session: phase as `push-pr`
- Push branch to remote with `-u` flag
- Create pull request using `gh pr create`
- PR title: concise, under 70 characters
- PR body: summary bullets + test plan + link to Linear issue
- Update session: mark as `shipped`, record PR number

### 5. Next Issue
- Move to next pending issue in session
- If none remaining, session complete

## Resumption

When resuming (via `/ship` with no args):
1. Read `.notes/_ship-session.md` to understand current state
2. Find the `## Current` issue and `## Current Phase`
3. For `implement` phase: also read `.notes/<branch>/implement-plan.md` to find current step
4. Continue from that exact point

This works even after:
- Context compaction (conversation summarized)
- Session restart (new Claude Code session)
- Interruption (user closes terminal)

Always read the session file first to reorient yourself.

## Output

### When resuming:
```
Resuming ship session (started YYYY-MM-DD).
Progress: 3/10 issues shipped, 1 in-progress.
Current: FAS-124 (phase: implement, step 3/5)

Continuing implementation...
```

### After each issue ships:
```
Shipped FAS-124 -> PR: https://github.com/org/repo/pull/124
Continuing with FAS-125...
```

### When batch complete:
```
Shipping complete.

Shipped:
  FAS-123 - title -> PR: https://github.com/org/repo/pull/123
  FAS-124 - title -> PR: https://github.com/org/repo/pull/124

Skipped (has questions):
  FAS-125 - title (run /plan FAS-125 to resolve)

Failed:
  FAS-126 - title (error: reason)
```

### On error:
```
Error shipping FAS-126: [error details]

Session saved. Run `/ship` to retry this issue or continue with remaining.
To skip this issue: manually mark as skipped in .notes/_ship-session.md
```
