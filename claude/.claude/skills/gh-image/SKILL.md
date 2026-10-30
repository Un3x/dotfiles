---
name: gh-image
description: Attach local images or videos to a GitHub PR, issue or comment with `gh --attach`. Use when a screenshot, screencast or before/after evidence must appear on GitHub (« mets la capture sur la PR »), when images already on GitHub are too big, or to reuse a user-attachments URL.
license: MIT
---

# gh-image

`gh pr` and `gh issue` take `--attach`: gh uploads the files to GitHub and rewrites their references in the body into hosted URLs. Plain `gh` authentication, nothing else. Images inherit the repository visibility.

## Steps

1. **Pick the files.** Captures come from the `/verify` drive, at the evidence path its map names. Look at each image and keep only those that explain the change. Copy them to the scratchpad under a meaningful name (`portal-before.png`) when the original is a timestamp: gh uses the filename as alt text, and the evidence folder goes away with the worktree. Done when each kept file has a name a reader understands.
2. **Write the body** to a file in the scratchpad, keeping the `commit` skill's rules for PR bodies, with each image where it belongs as `![alt](/abs/path.png)`. Absolute paths only: gh rewrites markdown destinations, never an `<img src>` or a code span. For an existing body, fetch it first: `gh pr view 123 --json body --jq .body > body.md` (`gh issue view` for issues).
3. **Attach**, inside the target repo or with `--repo OWNER/REPO`, one `--attach` per file (up to 50):

   | Destination | Command |
   |---|---|
   | New PR / issue | `gh pr create` / `gh issue create --title "..." --body-file body.md --attach a.png` |
   | Existing PR / issue body | `gh pr edit` / `gh issue edit 123 --body-file body.md --attach a.png` |
   | Comment | `gh pr comment` / `gh issue comment 123 --body-file body.md --attach a.png` |

   On `edit`, leaving out the body flags keeps the body and appends the files. Videos take no alt text: let gh write their reference.
4. **Size portrait captures** so before/after stay comparable side by side: [`sizing.md`](sizing.md). Landscape or desktop captures readable at body width stay as they are.
5. **Check the saved body**: `gh pr view 123 --json body --jq .body`. Done when no local path remains and every image renders. A failure, a partial upload or an unknown flag: [`troubleshooting.md`](troubleshooting.md).

READMEs, gists and Discussions take no upload: reuse a hosted URL from a PR, issue or comment of the same repo.
