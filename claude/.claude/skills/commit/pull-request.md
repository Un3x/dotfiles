# Pull request title and body

The reader is the reviewer, then the developer who lands here from a commit months later when the issue is archived ([`readers.md`](readers.md)): the why must stand without the tracker.

- **One PR = one functionality**: the grain is in [`../slices.md`](../slices.md).
- **Stacked PRs** (a series where each builds on the one before) go through `gh stack` (`init`, `add`, `submit`, `rebase`), never PRs based on each other by hand.
- **Title**: the story of the branch, shaped like a commit subject and held to its length (`SKILL.md` step 1). A one-commit PR takes its commit subject verbatim.
- **Body**, this shape and nothing else:

  ```
  <one to three lines: what the reader gets, and the one constraint or trade-off they must know>

  Closes <ISSUE-ID> → <issue URL>
  ```
  Under `Closes`, when the change is user-facing, one line says what the verify drive showed: the action, the result seen and, when short, the read-back quoted, so the reviewer starts from a proof instead of redoing it. Never a local path (`tmp/verify/…`): the reviewer cannot open it, and it is gone once the worktree is removed. The last line becomes `Suite de`, `Related` or a sha for a follow-up without an issue. A screenshot when the change is visible, attached with the `gh-image` skill (Skill tool). Numbered steps to test by hand only when the diff does not make them obvious. The commits are the reading path: when their order matters, one line says « à lire commit par commit » with the first one to open; when the user has published a review guide for it (`/review-guide`), its link goes on the line after.
- Review replies and follow-ups on our PRs: Thomas posts them. A follow-up that changes the scope goes on the issue as a question; a technical leftover becomes its own one-line issue or stays in `.notes/`; Thomas talks to the team.
