---
name: clean
description: "Delete .notes subfolders whose issue is done, auto-review briefs whose PR is merged or closed, and our branches whose PR is merged or closed."
disable-model-invocation: true
---

The goal is to clean the content of the .notes folder.
For each subfolder, check the corresponding issue in the project's tracker (« is it done? », [`../tracker.md`](../tracker.md)), and if it is done, clean the corresponding folder.
Then delete the project's auto-review briefs whose PR is merged or closed: `~/Documents/mylife_in_a_vault/systems/clean-briefs.sh <project>`, the project being the last folder of the path in `.claude/project-lead`.
Then the branches, after `git fetch --prune origin`:
- **Local**: each branch whose PR is merged or closed (`gh pr list --state merged` and `--state closed`, their `headRefName`) or whose tip is in `origin/main`, deleted with `git branch -D`. A branch checked out in a worktree stays, and is named in the report.
- **Remote**: each branch of a PR we authored (`--author @me`) that is merged or closed, deleted with `git push origin --delete`. A teammate's branch and any branch with an open PR stay.

Done when no local branch and no remote branch of ours belongs to a merged or closed PR.
