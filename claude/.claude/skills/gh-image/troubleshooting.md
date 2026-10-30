# Troubleshooting

Read at step 5 of `gh-image` when an attach fails, half succeeds, or the flag is unknown.

`--attach` needs gh 2.99.0 or newer (`gh --version`, the flag in the command's `--help`), write access to the repo, and GitHub.com or Enterprise Cloud.

When some uploads fail, the command can still create or update the resource with the others, then exit non-zero. Read stderr and the resource, then retry only the missing files with `edit` on that resource, never a second `create`.

| Symptom | Action |
|---|---|
| Unknown `--attach` flag | Upgrade gh, check the command's `--help` |
| Authentication failure | `gh auth status`, check `GH_TOKEN` / `GITHUB_TOKEN` overrides |
| Write-access error, upload 404 | `gh api repos/OWNER/REPO --jq .permissions` |
| Local path left in the body | Check the path is absolute, the working directory, stderr; code spans are never rewritten |
| Rejected file | Non-empty supported image or video; stderr gives type and size limits |
