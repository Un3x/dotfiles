---
name: commit
description: "Write a commit message, or a pull request title and body, for a reader who has none of the session. Read before every git commit and every gh pr create."
---

# commit

The reader of a commit or a PR has neither the ticket, nor the plan, nor the diff open, and reads the log commit by commit. Loïc's history on API Entreprise is the model ([`examples.md`](examples.md)): a subject that names the change in domain words, no body unless a why is not already in the subject, `Closes <link>`.

## Commit message

1. **Subject** — under 60 characters, hard stop 72. The behaviour or capability that changed, in the repo's language, prefixed when it helps by the area in words and a colon: `Editor: paginate authorization requests`. A type prefix (`feat:`, `fix(voice):`) only where the repo's own `CLAUDE.md` asks for one. Done when the line reads as a changelog entry for the team.
2. **Body** — empty by default. One or two lines only when the subject leaves a why or a constraint unsaid: the reason, the trap avoided, the related sha or issue. Never the files touched, the steps taken, or the plan step. Done when nothing in it can be read from the diff.
3. **Fix-ups from a review round** go into the commit they fix: `git commit --fixup <sha>`, then `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base>` before merge (no editor opens), pushed with `--force-with-lease`. Done when the branch reads as one story, not as the review loop.
4. Commit with the message in a heredoc, no trailer of any kind.

## Pull request

Read [`pull-request.md`](pull-request.md) at `gh pr create`.

## Rules

- The why is written once, in the message: the plan, the Linear issue and the PR are not files the log reader can open.
- The message speaks the repo's language (Simplifions: French; Bangun, Apistration: English), whatever language the session runs in.
- A subject past 72 characters is a subject carrying its body: cut it, do not wrap it (2026-08 → 09-30: 89 of 368 subjects on Bangun and Simplifions ran past 72).
