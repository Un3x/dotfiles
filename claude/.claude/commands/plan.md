Plan command for Linear issues. Handles both initial planning and replanning.

## Usage
- `/plan <issue1> <issue2> ...` - Create or replan for listed issues (IDs or URLs)
- `/plan` (no args) - Resume active session OR replan plans with unanswered questions

## Session Tracking

All progress is persisted in `.notes/_plan-session.md` so work survives context compaction or session restarts.

Session file format:
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

Status markers:
- `[ ]` pending - not yet processed
- `[~]` has-questions - plan exists but needs answers
- `[x]` ready - plan complete, no questions

## Behavior

### With issue arguments ($1, $2, ...):
1. Create/update `.notes/_plan-session.md` with the issue list
2. For each issue:
   a. Update session: mark as current
   b. Fetch issue details from Linear MCP (use the issue ID like FAS-385 or extract from URL)
   c. Get the branch name from the Linear issue
   d. Check if `.notes/<branch_name>/plan.md` exists (strip prefix before `/` in branch names)
   e. If plan exists and has your answers to previous questions: replan (re-read answers, update plan)
   f. If plan exists but no changes: skip (already clean)
   g. If no plan: create new plan by exploring codebase and following repository guidelines
   h. Update session: mark as ready or has-questions
3. After all issues processed OR if stopping for questions: update session file

### Without arguments:
1. **First**: Check if `.notes/_plan-session.md` exists with pending items → resume from current position
2. **Then**: Scan all `.notes/*/plan.md` files for unanswered questions or `FIXME:` markers
3. For each plan needing attention:
   - Re-read the plan and answers
   - Rewrite the plan addressing the answers
   - If new questions arise, add them at the end
   - Update session file status

## Planning Guidelines
- Explore the codebase first to understand context
- Each step should contain its own tests and quality checks
- Always include a final step for quality enhancement (analysis after development)
- Keep plans concise - clarity over verbosity
- If you have questions, put them at the end of the plan document
- Lines with FIXME should be addressed in the plan

## IMPORTANT: Stop on questions
When you have questions about requirements or implementation approach, you MUST:
1. Write them at the end of the plan document
2. Update session file (mark issue as `has-questions`, keep as current)
3. STOP and wait for the user to answer
4. Do NOT guess or make assumptions on ambiguous requirements

After user answers, they can run `/plan` to resume - the session file tells you where you were.

## Resumption

When resuming (via `/plan` with no args and an active session):
1. Read `.notes/_plan-session.md` to understand current state
2. Find the `## Current` issue
3. Read its plan to see if questions were answered
4. Continue from there

This works even after:
- Context compaction (conversation summarized)
- Session restart (new Claude Code session)
- Interruption (user closes terminal)

Always read the session file first to reorient yourself.

## Output

### When stopping for questions:
```
Planning paused - questions need answers.

Progress (5/24):
  [x] FAS-121 - ready
  [x] FAS-122 - ready
  [~] FAS-123 - has questions (see below)
  [ ] FAS-124 - pending
  ...

Questions for FAS-123:
1. Should the validation apply to existing records?
2. What error message format do you prefer?

Answer in the plan file or here, then run `/plan` to continue.
```

### When batch complete:
```
Planning complete.

Ready:
  FAS-123 - title of issue (branch: fas-123-slugified-title)
  FAS-124 - title of issue (branch: fas-124-slugified-title)

Still has questions:
  FAS-125 - title of issue (3 questions remaining)

To ship ready plans:
/ship FAS-123 FAS-124
```

This allows the user to copy-paste the /ship command directly, editing if needed.

### When resuming:
```
Resuming plan session (started YYYY-MM-DD).
Progress: 5/24 issues processed.
Current: FAS-123 (has-questions)

Reading plan and continuing...
```
