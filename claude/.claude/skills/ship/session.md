# Ship session file and resumption

Progress lives in `.notes/<branch_name>/ship-session.md`, in the main checkout, so it survives compaction and restarts and parallel ships never share it. Read it first to reorient yourself. When a write to the main checkout is refused, the session writes `.notes/<branch_name>/` inside the worktree and names those files in its report, and the project lead moves them to the main checkout.

```markdown
# Ship FAS-124
Started: YYYY-MM-DD HH:MM
Status: in-progress
Phase: implement
Plan step: 3/5
Review round: 0
PR:

## Notes
```

Status: `in-progress`, `shipped` (PR open, review loop finished clean or cap reported), `skipped` (the plan has questions), `blocked` (no proof, reason in Notes), `failed` (error, reason in Notes).

Phases: `setup` → `post-plan` → `implement` → `push-pr` → `review` → `done`

## Resumption

`/ship` with no args: scan the main checkout's `.notes/*/ship-session.md` and each worktree's (`git worktree list` gives their paths) for Status `in-progress`. Several: report the list and stop, the project lead session reruns `/ship <issue>`. When the branch has a worktree, continue there, from its Phase:
- `implement`: from its Plan step
- `review`: read the latest `.notes/<branch_name>/review-round-N.md`; open rows (`review-loop.md`) → resume the fix cycle; none → spawn the next review subagent
