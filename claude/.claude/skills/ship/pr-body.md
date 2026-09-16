# PR title, body and comments

Read at phase 4 (push-pr) of `/ship`. The global `CLAUDE.md` prose diet applies: a pointer plus the minimum that orients the reader.

- PR title: concise, under 70 characters
- **PR body: a pointer to the issue, not a second copy of it.** The issue holds the why/what/plan; the diff holds the how. Keep it to ≤6 lines, this exact shape:
  ```
  <one-sentence summary of what changed>

  - <key change>            # optional, only for multi-part PRs
  - <key change>            # max 3 bullets

  Closes <ISSUE-ID> → <Linear URL>
  ```
  No test plan (CI + the diff cover it), no implementation narrative, no restating the issue. If you feel the urge to explain more, it belongs in the issue.
- **PR comments** (review replies, follow-ups): assistants never post on PR threads. A follow-up that needs words goes on the Linear issue, linked from the PR body; Thomas talks to the team.
