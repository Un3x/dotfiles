# Pull request title and body

Read at `gh pr create`, and at phase 4 of `/ship`.

- **Title**: the story of the branch in under 70 characters, shaped like a commit subject. A one-commit PR takes its commit subject verbatim.
- **Body**, this shape and nothing else:

  ```
  <one to three lines: what the reader gets, and the one constraint or trade-off they must know>

  Closes <ISSUE-ID> → <Linear URL>
  ```
  The last line becomes `Suite de`, `Related` or a sha for a follow-up without an issue. A screenshot when the change is visible. A « Howto review » paragraph giving the reading order of the commits only when the PR holds five commits or more and the order matters.
- Nothing else: no headers, no test plan (CI and the diff), no proof essay (Apistration #439, 2026-09-24: 21 lines of `git grep` to prove a field was dead, when the two specs pinning it were the proof), no restating of the issue.
- Review replies and follow-ups: assistants never post on PR threads (guardrail). A follow-up that needs words goes on the Linear issue, linked from the body; Thomas talks to the team.
