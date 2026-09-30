# Pull request title and body

Read at `gh pr create`, and at phase 4 of `/ship`. The reader is the reviewer, then the developer who lands here from a commit months later when the issue is archived ([`readers.md`](readers.md)): the why must stand without Linear.

- **One PR = one functionality**, self-sufficient and shippable on its own (user, 2026-09-30): a reader must not need another PR to understand it, and merging it must leave the app with something usable. Size is not a reason to split; unreadability is a reason to guide.
- **Title**: the story of the branch in under 70 characters, shaped like a commit subject. A one-commit PR takes its commit subject verbatim.
- **Body**, this shape and nothing else:

  ```
  <one to three lines: what the reader gets, and the one constraint or trade-off they must know>

  Closes <ISSUE-ID> → <Linear URL>
  ```
  The last line becomes `Suite de`, `Related` or a sha for a follow-up without an issue. A screenshot when the change is visible. Numbered steps to test by hand only when the diff does not make them obvious. The commits are the reading path: when their order matters, one line says « à lire commit par commit » with the first one to open; when the PR outgrows that read, the third line links the review guide ([`review-guide.md`](review-guide.md)).
- Nothing else: no headers, no test plan (CI and the diff), no proof essay (Apistration #439, 2026-09-24: 21 lines of `git grep` to prove a field was dead, when the two specs pinning it were the proof), no restating of the issue.
- Review replies and follow-ups: assistants never post on PR threads (guardrail). A follow-up that changes the scope goes on the Linear issue as a question; a technical leftover becomes its own one-line issue or stays in `.notes/`; Thomas talks to the team.
