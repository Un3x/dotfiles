---
name: gh-image
description: Attach local images or videos to a GitHub PR, issue or comment with `gh --attach`. Use when a screenshot, screencast or before/after evidence must appear on GitHub (« mets la capture sur la PR »), when images already on GitHub are too big, or to reuse a user-attachments URL.
license: MIT
---

# gh-image

`gh pr` and `gh issue` take `--attach`: gh uploads the files to GitHub and rewrites their references in the body into hosted URLs. Plain `gh` authentication, nothing else. Images inherit the repository visibility.

## Steps

1. **Pick the files.** Captures come from the `/verify` drive, at the evidence path its map names. Look at each image and keep only those that explain the change. Copy them to the scratchpad under a meaningful name (`portal-before.png`) when the original is a timestamp: gh uses the filename as alt text, and the evidence folder goes away with the worktree. Done when each kept file has a name a reader understands.
2. **Size them before the upload**: check each one's dimensions and crop a very tall capture, following [`sizing.md`](sizing.md), which also covers the portrait swap of step 5 and images already on GitHub that are too big.
3. **Write the body** to a file in the scratchpad, keeping the `commit` skill's rules for PR bodies, with each image where it belongs as `![alt](/abs/path.png)`. Absolute paths only: gh rewrites markdown destinations, never an `<img src>` or a code span. For an existing body, fetch it first: `gh pr view 123 --json body --jq .body > body.md` (`gh issue view` for issues).
4. **Attach**, inside the target repo or with `--repo OWNER/REPO`, one `--attach` per file (up to 50):

   | Destination | Command |
   |---|---|
   | New PR / issue | `gh pr create` / `gh issue create --title "..." --body-file body.md --attach a.png` |
   | Existing PR / issue body | `gh pr edit` / `gh issue edit 123 --body-file body.md --attach a.png` |
   | Comment | `gh pr comment` / `gh issue comment 123 --body-file body.md --attach a.png` |

   On `edit`, leaving out the body flags keeps the body and appends the files, with alt text after `#` (`'./a.png#Portal after the fix'`, quoted). Videos take no alt text: let gh write their reference. The command prints the resource URL, not the image markdown. A non-zero exit can still have created the resource with part of the files: retry only the missing ones with `edit` on that resource, never a second `create` ([`troubleshooting.md`](troubleshooting.md)).
5. **Portrait captures side by side**: swap them to `<img width>` on the saved body, following [`sizing.md`](sizing.md). Landscape or desktop captures readable at body width stay as they are.
6. **Check what was saved**: `gh pr view 123 --json body --jq .body`, or `gh pr view 123 --comments` for a comment (`gh issue view` for issues). Done when no local path remains and every image renders.

READMEs, gists and Discussions take no upload: reuse a hosted URL from a PR, issue or comment of the same repo.
