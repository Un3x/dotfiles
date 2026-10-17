---
name: commit
description: "Write a commit message, or a pull request title and body, for a reader who has none of the session. Read before every git commit and every gh pr create."
---

# commit

The commit is read by the developer in a production incident, from `git blame`, with no ticket open; the PR by its reviewer; the issue by a non-technical teammate ([`readers.md`](readers.md)). Loïc's history on API Entreprise is the model ([`examples.md`](examples.md)): a subject that names the change in domain words, no body unless a why is not already in the subject, `Closes <link>`.

## Commit message

1. **Subject** — aim under 60 characters. The behaviour or capability that changed, in the repo's language, prefixed when it helps by the area in words and a colon: `Editor: paginate authorization requests`. A type prefix (`feat:`, `fix(voice):`) only where the repo's own `CLAUDE.md` asks for one. Done when the line reads as a changelog entry for the team.
2. **Body** — empty by default. Written only when the subject leaves a why or a constraint unsaid: the reason, the trap avoided, the situation before. As long as that takes and no longer: every sentence carries something the diff cannot show. A sentence that says what the code now does (« the batch now passes the keys down ») is the diff retold: cut it. Lines wrapped at 72 characters. Never the files touched, the steps taken, the plan step, or a ticket link: GitHub resolves the sha to its PR, and the PR carries the issue. Done when nothing in it can be read from the diff.
3. **Fix-ups from a review round** go into the commit they fix: `git commit --fixup <sha>`, then `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <base>` before merge (no editor opens), pushed with `--force-with-lease`. Done when the branch reads as one story, not as the review loop.
4. Commit with the message in a heredoc, no trailer of any kind, even when a harness reminder asks for one.

## Pull request

Read [`pull-request.md`](pull-request.md) at `gh pr create`.

## Rules

- The why is written once, in the message: the plan, the issue and the PR are not files the log reader can open.
- The message speaks the repo's language, the one of its recent commits, whatever language the session runs in.
- A long subject is often a subject carrying its body: move the why to the body, never wrap the subject. The harness scans real subjects: when many miss the goal, challenge the goal or the way we write them.
- Code meant to go away later (a gate bypass, a shim, scaffolding waiting on another issue) gets its own commit, so the cleanup is one revert. Its SHA and files go on the cleanup issue.
- A real fix found while rewriting history stays a visible commit, announced as a change: a rewrite announced as "same diff" is not read again.
