---
name: clean
description: "Delete .notes subfolders whose issue is done, auto-review briefs whose PR is merged or closed, and our branches whose PR is merged."
disable-model-invocation: true
---

The goal is to clean what finished work leaves: the .notes folder, the briefs, the branches.
For each subfolder, check the corresponding issue in the project's tracker (« is it done? », [`../tracker.md`](../tracker.md)), and if it is done, clean the corresponding folder. A project with no tracker: the folder's PR answers instead. Run `gh pr list --state all --limit 1000 --json headRefName,state` and take the PR whose `headRefName` is the folder's name or ends in `/<folder>`. Merged or closed unmerged: done. Open: keep.
Then delete the project's auto-review briefs whose PR is merged or closed: `~/Documents/mylife_in_a_vault/systems/clean-briefs.sh <project>`, the project being the last folder of the path in `.claude/project-lead`.
Then the branches, after `git fetch --prune origin`:
Our finished branches are the `headRefName` and `headRefOid` of `gh pr list --author @me --state merged --limit 1000`. A branch that is the default branch, the base (`baseRefName`) of any PR (`--state all --limit 1000`), or the head of more than one PR, is never one of them: it is long-lived.
- **Local**: each one deleted with `git branch -d`. When git refuses (a squash merge), `git branch -D` only when its tip is the PR's `headRefOid`.
- **Remote**: each one whose remote tip is still the PR's `headRefOid`, deleted with `git push origin --delete`.
- Never deleted: the current branch, a branch in a worktree, a branch with an open PR. A closed PR's branch and a teammate's are not finished branches. A finished branch that stays is named in the report (the reply, or the brief's Result).

Done when each finished branch is deleted or named in the report.
