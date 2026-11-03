---
name: clean
description: "Delete .notes subfolders whose issue is done, and auto-review briefs whose PR is merged or closed."
disable-model-invocation: true
---

The goal is to clean the content of the .notes folder.
For each subfolder, check the corresponding issue in the project's tracker (« is it done? », [`../tracker.md`](../tracker.md)), and if it is done, clean the corresponding folder.
Then delete the project's auto-review briefs whose PR is merged or closed: `~/Documents/mylife_in_a_vault/systems/clean-briefs.sh <project>`, the project being the last folder of the path in `.claude/project-lead`.
