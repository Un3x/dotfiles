# The project's tracker

Read by any skill or session that reads or writes an issue. Skills say « the tracker », never a product: each project picks its own, so a tracker can be tried on one project, or replaced, without touching the skills.

## Which tracker

1. The `> Tracker:` line at the top of the project's vault `STATUS.md`. A session running in a repo finds that folder in `.claude/project-lead`.
2. No such line: Linear when the repo's `.mcp.json` has a `linear-<workspace>` MCP server. Linear is the default.
3. `none`, or neither of the above: the project has no tracker. A skill that needs an issue says so and asks the user instead of guessing.

## Verbs

A skill names the verb; this table gives the call. Writing the description or creating an issue goes through the `issue` skill first. A tracker can serve a project only once every row of its column is filled. Trying a new one starts by adding its column.

| Verb | Linear (`linear-<workspace>` MCP) |
| --- | --- |
| read an issue: title, body, status, branch name | `get_issue` (`gitBranchName` is the branch) |
| list a project's open issues | `list_issues` |
| write the description | `save_issue` with `id` and `description` |
| change the status | `save_issue` with `id` and `state` |
| create an issue | `save_issue` without `id` |
| comment | `save_comment` |
| attach a file | `prepare_attachment_upload` → `curl -X PUT --data-binary` with the signed headers, within 60 seconds → `create_attachment_from_upload` |
| link a PR | `Closes <ISSUE-ID>` in the PR body; the tracker's GitHub integration links it |
| is it done? | `get_issue`, status type `completed` or `canceled` |
